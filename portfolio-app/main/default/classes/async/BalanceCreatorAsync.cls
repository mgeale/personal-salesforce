public with sharing class BalanceCreatorAsync implements Queueable {
    private Id priceBookId;
    private List<PricebookEntry> entries;

    public BalanceCreatorAsync(Id priceBookId) {
        this.priceBookId = priceBookId;
    }

    public void execute(QueueableContext ctx) {
        try {
            BalanceService.create(
                new PricebookEntrySelector()
                    .selectByPricebookId(new Set<Id>{ this.priceBookId }),
                false
            );
        } catch (Exception e) {
            Log.get().publish(e);
        }
    }
}
