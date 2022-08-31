trigger BatchApexErrorTrigger on BatchApexErrorEvent(after insert) {
    switch on Trigger.operationType {
        when AFTER_INSERT {
            BatchApexErrorTriggerHandler.afterInsert(Trigger.new);
        }
    }
}
