public class CapitalGainsTriggerHandler extends TriggerHandler {
    Capital_Gains__c[] incomingRecords = new List<Capital_Gains__c>{};

    public CapitalGainsTriggerHandler() {
        this.incomingRecords = (Capital_Gains__c[]) Trigger.new;
    }

    override public void beforeInsert() {
        CapitalGainsService.allocateToAsset(this.incomingRecords);
    }

    override public void beforeUpdate() {
        CapitalGainsService.allocateToAsset(this.incomingRecords);
    }
}
