trigger LogTrigger on Log__e(after insert) {
    switch on Trigger.operationType {
        when AFTER_INSERT {
            LogTriggerHandler.afterInsert(Trigger.new);
        }
    }
}
