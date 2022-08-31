public class CapitalGainsSelector extends fflib_SObjectSelector {
    public Schema.SObjectField[] getSObjectFieldList() {
        return new List<Schema.SObjectField>{ Capital_Gains__c.Id };
    }

    public Schema.SObjectType getSObjectType() {
        return Capital_Gains__c.sObjectType;
    }

    public Capital_Gains__c[] selectById(Set<Id> idSet) {
        return (Capital_Gains__c[]) selectSObjectsById(idSet);
    }
}
