trigger BatchApexErrorTrigger on BatchApexErrorEvent(after insert) {
    Boolean isDisabled = Trigger_Settings__c.getOrgDefaults()
        .Disable_Batch_Apex_Error_Trigger__c;
    if (!isDisabled) {
        new BatchApexErrorTriggerHandler().run();
    }
}
