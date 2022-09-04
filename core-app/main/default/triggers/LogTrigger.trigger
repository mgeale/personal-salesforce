trigger LogTrigger on Log__e(after insert) {
    Boolean isDisabled = Trigger_Settings__c.getOrgDefaults()
        .Disable_Log_Trigger__c;
    if (!isDisabled) {
        new LogTriggerHandler().run();
    }
}
