public with sharing class PricebookEntryCreatorAsync implements Database.Batchable<ProductService.ProductInfo>, Database.AllowsCallouts, Database.Stateful, Database.RaisesPlatformEvents {
    private Pricebook2[] priceBooks;
    private Boolean isSuccess;

    private PricebookEntryService entryService;

    @testVisible
    private Boolean doChainJob = true;

    public PricebookEntryCreatorAsync(Pricebook2[] priceBooks) {
        this.priceBooks = priceBooks;
        this.entryService = new PricebookEntryService(true, false);
    }

    public ProductService.ProductInfo[] start(Database.BatchableContext bc) {
        Set<String> productFamilies = new Set<String>();
        for (Pricebook2 book : this.priceBooks) {
            productFamilies.add(book.Product_Family__c);
        }

        return new ProductService()
            .convertToProductInfos(
                new ProductSelector().selectByFamily(productFamilies)
            );
    }

    public void execute(
        Database.BatchableContext bc,
        ProductService.ProductInfo[] productInfos
    ) {
        try {
            this.entryService.create(this.priceBooks, productInfos);
            this.isSuccess = true;
        } catch (Exception e) {
            this.isSuccess = false;
            Log.get().publish(e);
        }
    }

    public void finish(Database.BatchableContext bc) {
        if (this.isSuccess && this.doChainJob) {
            InjectParameters balanceCreator = (InjectParameters) Type.forName(
                    'BalanceCreatorAsync'
                )
                .newInstance();

            Set<ID> ids = new Set<ID>();
            for (Pricebook2 book : this.priceBooks) {
                ids.add(book.id);
            }
            balanceCreator.setRecordIds(ids);
            System.enqueueJob(balanceCreator);
        }
    }
}
