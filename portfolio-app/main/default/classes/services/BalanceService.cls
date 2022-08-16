public with sharing class BalanceService {
    public static Boolean create(PricebookEntry[] entries) {
        ID[] productIds = new List<ID>{};
        for (PricebookEntry e : entries) {
            productIds.add(e.Product2Id);
        }
        Map<String, Decimal> totalAmounts = new AssetService(true)
            .getTotals(productIds);

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

        Boolean[] isSuccess = new List<Boolean>{};
        for (Database.SaveResult sr : Database.insert(balances, false)) {
            isSuccess.add(sr.isSuccess());
        }
        return isSuccess.contains(true);
    }

    public Balance__c[] getBalanceByProduct(Id productId, Integer limitCount) {
        return new BalanceSelector().selectByProductId(productId, limitCount);
    }
}
