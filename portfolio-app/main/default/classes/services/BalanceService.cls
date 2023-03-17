public with sharing class BalanceService {
    public static Balance__x[] create(PricebookEntry[] entries) {
        Id[] productIds = new List<Id>{};
        for (PricebookEntry e : entries) {
            productIds.add(e.Product2Id);
        }
        Map<String, Decimal> totalAmounts = new AssetSelector()
            .sumQuantitiesByProduct(productIds, true);

        Balance__x[] balances = new List<Balance__x>{};
        for (PricebookEntry e : entries) {
            Decimal amount = totalAmounts.get(e.Product2Id);
            if (amount == 0 || amount == null) {
                continue;
            }
            balances.add(
                new Balance__x(
                    Price_Book__c = e.Pricebook2Id,
                    Product__c = e.Product2Id,
                    Balance__c = amount,
                    BalanceAUD__c = amount * e.UnitPrice
                )
            );
        }

        Database.insertAsync(balances);
        return balances;
    }
}
