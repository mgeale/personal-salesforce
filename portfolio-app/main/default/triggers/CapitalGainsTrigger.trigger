trigger CapitalGainsTrigger on Capital_Gains__c(
    before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete
) {
    Boolean isDisabled = Trigger_Settings__c.getOrgDefaults()
        .Disable_Capital_Gains_Trigger__c;
    if (!isDisabled) {
        new CapitalGainsTriggerHandler().run();
    }
}
