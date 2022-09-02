public with sharing class CapitalGainsService {
    public static Capital_Gains__c[] allocateToAsset(
        Capital_Gains__c[] capitalGainsList
    ) {
        Set<Id> ids = new Set<Id>();
        for (Capital_Gains__c capitalGains : capitalGainsList) {
            ids.add(capitalGains.Purchase__c);
            ids.add(capitalGains.Sold__c);
        }

        Map<Id, Asset> assetMap = new Map<Id, Asset>(
            [
                SELECT
                    Quantity__c,
                    (SELECT Amount__c FROM Capital_Gains_Sold__r),
                    (SELECT Amount__c FROM Capital_Gains_Purchase__r)
                FROM Asset
                WHERE id IN :ids
            ]
        );

        for (Capital_Gains__c capitalGains : capitalGainsList) {
            Asset purchaseAsset = assetMap.get(capitalGains.Sold__c);
            calculateAmountByAsset(
                purchaseAsset,
                purchaseAsset.Capital_Gains_Sold__r,
                capitalGains
            );

            Asset soldAsset = assetMap.get(capitalGains.Purchase__c);
            calculateAmountByAsset(
                soldAsset,
                soldAsset.Capital_Gains_Purchase__r,
                capitalGains
            );

            if (capitalGains.hasErrors()) {
                throw new DmlException(
                    String.valueOf(capitalGains.getErrors())
                );
            }
        }

        Database.update(assetMap.values());
        return capitalGainsList;
    }

    private static void calculateAmountByAsset(
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
                String.format(
                    '{0} total is greater than maximum of {1}.',
                    new List<Object>{ total, a.Quantity__c }
                )
            );
        } else {
            a.Amount_Taxed__c = total;
        }
    }
}
