public with sharing class BalanceCreatorAsync extends QueueParameters implements Queueable {
    public Id recordId;

    public void execute(QueueableContext ctx) {
        try {
            BalanceService.create(
                new PricebookEntrySelector()
                    .selectByPricebookId(new Set<Id>{ this.recordId }),
                false
            );
        } catch (Exception e) {
            Log.get().publish(e);
        }
    }
}
