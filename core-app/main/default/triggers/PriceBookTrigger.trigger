trigger PriceBookTrigger on Pricebook2(
    before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete
) {
    Boolean isDisabled = Trigger_Settings__c.getOrgDefaults()
        .Disable_Pricebook_Trigger__c;
    if (!isDisabled) {
        new PriceBookTriggerHandler().run();
    }
}
