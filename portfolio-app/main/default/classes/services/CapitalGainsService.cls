public with sharing class CapitalGainsService {
    public static void processTotalTaxedAmount(Capital_Gains__c[] cgList) {
        for (Capital_Gains__c capitalGains : cgList) {
            Asset purchaseAsset = [
                SELECT
                    Quantity__c,
                    (SELECT id, Amount__c FROM Capital_Gains_Sold__r)
                FROM Asset
                WHERE id = :capitalGains.Sold__c
            ];
            updateAmountTaxed(
                purchaseAsset,
                purchaseAsset.Capital_Gains_Sold__r,
                capitalGains
            );

            Asset soldAsset = [
                SELECT
                    Quantity__c,
                    (SELECT Amount__c FROM Capital_Gains_Purchase__r)
                FROM Asset
                WHERE id = :capitalGains.Purchase__c
            ];
            updateAmountTaxed(
                soldAsset,
                soldAsset.Capital_Gains_Purchase__r,
                capitalGains
            );

            update soldAsset;
            update purchaseAsset;
        }
    }

    @TestVisible
    private static void updateAmountTaxed(
        Asset a,
        Capital_Gains__c[] cgList,
        Capital_Gains__c capitalGains
    ) {
        Decimal totalPast = 0;
        for (Capital_Gains__c cp : cgList) {
            if (cp.id != capitalGains.id) {
                totalPast = totalPast + cp.Amount__c;
            }
        }
        Decimal total = totalPast + capitalGains.Amount__c;
        if (total > a.Quantity__c) {
            capitalGains.addError(
                total +
                ' total is greater than maximum of ' +
                a.Quantity__c
            );
        } else {
            a.Amount_Taxed__c = total;
        }
    }
}
