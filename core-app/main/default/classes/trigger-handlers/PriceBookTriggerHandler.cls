public without sharing class PriceBookTriggerHandler extends TriggerHandler {
    Pricebook2[] incomingRecords = new List<Pricebook2>{};

    public PriceBookTriggerHandler() {
        this.incomingRecords = (Pricebook2[]) Trigger.new;
    }

    override public void afterInsert() {
        for (Pricebook2 book : this.incomingRecords) {
            Database.executeBatch(new PricebookEntryCreatorAsync(book.id));
        }
    }
}
