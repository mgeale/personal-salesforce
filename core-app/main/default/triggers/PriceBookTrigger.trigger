trigger PriceBookTrigger on Pricebook2(after insert) {
    switch on Trigger.operationType {
        when AFTER_INSERT {
            PriceBookTriggerHandler.afterInsert(Trigger.new);
        }
    }
}
