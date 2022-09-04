trigger PriceBookTrigger on Pricebook2(
    before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete
) {
    new PriceBookTriggerHandler().run();
}
