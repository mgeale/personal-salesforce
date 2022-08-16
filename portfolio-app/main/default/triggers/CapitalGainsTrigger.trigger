trigger CapitalGainsTrigger on Capital_Gains__c(before insert, before update) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            CapitalGainsTriggerHandler.beforeInsert(Trigger.new);
        }
        when BEFORE_UPDATE {
            CapitalGainsTriggerHandler.beforeUpdate(Trigger.new);
        }
    }
}
