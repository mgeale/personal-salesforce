public inherited sharing class BalanceSelector extends fflib_SObjectSelector {
    public Schema.SObjectField[] getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            Balance__x.Id,
            Balance__x.Balance__c,
            Balance__x.BalanceAUD__c,
            Balance__x.CreatedDate__c
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Balance__x.sObjectType;
    }

    public Balance__x[] selectById(Set<Id> idSet) {
        return (Balance__x[]) selectSObjectsById(idSet);
    }

    public Balance__x[] selectByProductId(Id productId, Integer limitCount) {
        return (Balance__x[]) Database.query(
            newQueryFactory()
                .setCondition('Product__r.id = :productId')
                .toSOQL()
        );
    }
}
