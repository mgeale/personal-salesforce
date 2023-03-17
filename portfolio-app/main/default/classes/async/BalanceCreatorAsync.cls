public with sharing class BalanceCreatorAsync extends InjectParameters implements Queueable {
    public void execute(QueueableContext ctx) {
        try {
            BalanceService.create(
                new PricebookEntrySelector().selectByPricebookId(recordIds)
            );
        } catch (Exception e) {
            Log.get().publish(e);
        }
    }
}
