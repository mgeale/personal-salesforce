public class AssetSelector extends fflib_SObjectSelector {
    public Schema.SObjectField[] getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            Asset.Id,
            Asset.Name,
            Asset.Product2Id,
            Asset.Status,
            Asset.PurchaseDate,
            Asset.Price__c,
            Asset.Quantity__c,
            Asset.Total_Cost__c,
            Asset.Amount_Taxed__c
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Asset.sObjectType;
    }

    public Asset[] selectById(Set<Id> idSet) {
        return (Asset[]) selectSObjectsById(idSet);
    }

    public Asset[] selectByProductId(Id productId, Integer limitCount) {
        return (Asset[]) Database.query(
            newQueryFactory()
                .setLimit(limitCount)
                .setOrdering(
                    Asset.CreatedDate,
                    fflib_QueryFactory.SortOrder.DESCENDING
                )
                .setCondition('Product2Id = :productId')
                .toSOQL()
        );
    }

    public Map<String, Decimal> sumQuantitiesByProduct(
        ID[] productIds,
        Boolean isActive
    ) {
        Map<String, Decimal> totalAmounts = new Map<String, Decimal>();
        for (AggregateResult aggregate : [
            SELECT Product2Id, SUM(Quantity_Real_Number__c) Amount
            FROM Asset
            WHERE Product2Id IN :productIds AND Product2.IsActive = :isActive
            GROUP BY Product2Id
            HAVING SUM(Quantity_Real_Number__c) > 0.0000
        ]) {
            totalAmounts.put(
                (String) aggregate.get('Product2Id'),
                (Decimal) aggregate.get('Amount')
            );
        }
        return totalAmounts;
    }
}
