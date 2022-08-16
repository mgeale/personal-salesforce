public class BalanceSelector extends fflib_SObjectSelector {
    public Schema.SObjectField[] getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            Balance__c.Id,
            Balance__c.Balance__c,
            Balance__c.Balance_AUD__c,
            Balance__c.CreatedDate
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Balance__c.sObjectType;
    }

    public Balance__c[] selectById(Set<Id> idSet) {
        return (Balance__c[]) selectSObjectsById(idSet);
    }

    public Balance__c[] selectByProductId(Id productId, Integer limitCount) {
        return (Balance__c[]) Database.query(
            newQueryFactory()
                .setCondition('Product__r.id = :productId')
                .toSOQL()
        );
    }
}
