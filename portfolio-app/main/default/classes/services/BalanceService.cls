public with sharing class BalanceService {
    public static void create(PricebookEntry[] entries) {
        ID[] productIds = new List<ID>{};
        for (PricebookEntry e : entries) {
            productIds.add(e.Product2Id);
        }
        Map<String, Decimal> totalAmounts = new AssetSelector()
            .getTotals(productIds, true);

        Balance__c[] balances = new List<Balance__c>{};
        for (PricebookEntry e : entries) {
            Decimal amount = totalAmounts.get(e.Product2Id);
            if (amount == 0) {
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

        for (Database.SaveResult sr : Database.insert(balances, false)) {
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