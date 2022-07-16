public with sharing class AssetService {
    public static Decimal getTotalAmount(ID productId) {
        Map<String, Decimal> totals = getTotalAmounts(
            new List<ID>{ productId }
        );
        return totals.get(productId);
    }

    public static Map<String, Decimal> getTotalAmounts(List<ID> productIds) {
        AggregateResult[] groupedResults = [
            SELECT SUM(Quantity__c) Amount, Status, Product2Id
            FROM Asset
            WHERE Product2Id IN :productIds AND Product2.IsActive = TRUE
            GROUP BY Status, Product2Id
        ];

        Map<String, Decimal> totalAmounts = new Map<String, Decimal>();
        for (ID id : productIds) {
            totalAmounts.put(id, 0);
        }
        for (AggregateResult aggregate : groupedResults) {
            String productId = (String) aggregate.get('Product2Id');
            Decimal tally = totalAmounts.get(productId);
            tally = aggregate.get('Status') != 'Sold'
                ? tally + (Decimal) aggregate.get('Amount')
                : tally - (Decimal) aggregate.get('Amount');
            totalAmounts.put(productId, tally);
        }
        return totalAmounts;
    }

    public static Map<String, Decimal> getTotalAmounts(
        List<ID> productIds,
        Boolean isActive
    ) {
        AggregateResult[] groupedResults = [
            SELECT Product2Id, SUM(Quantity_Real_Number__c) Amount
            FROM Asset
            WHERE Product2Id IN :productIds AND Product2.IsActive = :isActive
            GROUP BY Product2Id
            HAVING SUM(Quantity_Real_Number__c) > 0.0000
        ];
        Map<String, Decimal> totalAmounts = new Map<String, Decimal>();
        for (AggregateResult aggregate : groupedResults) {
            totalAmounts.put(
                (String) aggregate.get('Product2Id'),
                (Decimal) aggregate.get('Amount')
            );
        }
        return totalAmounts;
    }
}
