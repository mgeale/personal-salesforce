trigger CapitalGainsTrigger on Capital_Gains__c(
    before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete
) {
    new CapitalGainsTriggerHandler().run();
}
