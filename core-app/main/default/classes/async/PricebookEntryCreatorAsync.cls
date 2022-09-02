public with sharing class PricebookEntryCreatorAsync implements Database.Batchable<ProductService.ProductInfo>, Database.AllowsCallouts, Database.Stateful, Database.RaisesPlatformEvents {
    private Id priceBookId;
    private Boolean isSuccess;

    public PricebookEntryCreatorAsync(Id priceBookId) {
        this.priceBookId = priceBookId;
    }

    public ProductService.ProductInfo[] start(Database.BatchableContext bc) {
        ProductService service = new ProductService();
        ProductSelector selector = new ProductSelector();

        return service.convertToProductInfos(
            selector.selectByFamily(new List<String>{ 'Web3' })
        );
    }

    public void execute(
        Database.BatchableContext bc,
        ProductService.ProductInfo[] productInfos
    ) {
        try {
            PricebookEntryService.create(this.priceBookId, productInfos, false);
            this.isSuccess = true;
        } catch (Exception e) {
            this.isSuccess = false;
            Log.get().publish(e);
        }
    }

    @testVisible
    private Boolean doChainJob = true;

    public void finish(Database.BatchableContext bc) {
        if (this.isSuccess && this.doChainJob) {
            QueueParameters queue = (QueueParameters) Type.forName(
                    'BalanceCreatorAsync'
                )
                .newInstance();
            queue.setRecordId(this.priceBookId);
            System.enqueueJob(queue);
        }
    }
}
