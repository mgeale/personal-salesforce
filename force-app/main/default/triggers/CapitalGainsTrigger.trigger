trigger CapitalGainsTrigger on Capital_Gains__c(before insert, before update) {
  switch on Trigger.operationType {
    when BEFORE_INSERT, BEFORE_UPDATE {
      CapitalGainsTriggerHandler.checkAmountTaxed(Trigger.new);
    }
  }
}
