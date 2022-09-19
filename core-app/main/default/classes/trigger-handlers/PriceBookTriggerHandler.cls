@SuppressWarnings('PMD.OperationWithLimitsInLoop')
public without sharing class PriceBookTriggerHandler extends TriggerHandler {
    Pricebook2[] incomingRecords;

    public PriceBookTriggerHandler() {
        this.incomingRecords = (Pricebook2[]) Trigger.new;
    }

    @SuppressWarnings('PMD.OperationWithLimitsInLoop')
    override public void afterInsert() {
        Database.executeBatch(
            new PricebookEntryCreatorAsync(this.incomingRecords)
        );
    }
}
