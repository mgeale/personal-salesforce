public with sharing class BalanceService {
    public static void create(PricebookEntry[] entries, Boolean allOrNone) {
        Id[] productIds = new List<Id>{};
        for (PricebookEntry e : entries) {
            productIds.add(e.Product2Id);
        }
        Map<String, Decimal> totalAmounts = new AssetSelector()
            .sumQuantitiesByProduct(productIds, true);

        Balance__c[] balances = new List<Balance__c>{};
        for (PricebookEntry e : entries) {
            Decimal amount = totalAmounts.get(e.Product2Id);
            if (amount == 0 || amount == null) {
                continue;
            }
            balances.add(
                new Balance__c(
                    Price_Book__c = e.Pricebook2Id,
                    Product__c = e.Product2Id,
                    Balance__c = amount,
                    Balance_AUD__c = amount * e.UnitPrice
                )
            );
        }

        for (Database.SaveResult sr : Database.insert(balances, allOrNone)) {
            Log logger = Log.get();
            if (!sr.isSuccess()) {
                logger.add(
                    String.format(
                        'Failed to create Balance__c. Errors {0}.',
                        new List<Object>{ sr.getErrors().toString() }
                    )
                );
            }
            logger.publish();
        }
    }
}
