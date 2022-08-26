trigger CapitalGainsTrigger on Capital_Gains__c(before insert, before update) {
    Boolean isDisabled = Trigger_Settings__c.getOrgDefaults()
        .Disable_Capital_Gains_Trigger__c;
    if (!isDisabled) {
        switch on Trigger.operationType {
            when BEFORE_INSERT {
                CapitalGainsTriggerHandler.beforeInsert(Trigger.new);
            }
            when BEFORE_UPDATE {
                CapitalGainsTriggerHandler.beforeUpdate(Trigger.new);
            }
        }
    }
}
