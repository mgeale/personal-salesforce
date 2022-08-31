public class CapitalGainsTriggerHandler {
    public static void beforeInsert(Capital_Gains__c[] newList) {
        CapitalGainsService.allocateToAsset(newList);
    }

    public static void beforeUpdate(Capital_Gains__c[] newList) {
        CapitalGainsService.allocateToAsset(newList);
    }
}
