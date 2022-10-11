public with sharing class BalanceService {
    private Log logger;
    private Boolean commitToDb;
    private Boolean allOrNone;

    public BalanceService() {
        this(true, true);
    }

    public BalanceService(Boolean commitToDb, Boolean allOrNone) {
        this.logger = Log.get();
        this.commitToDb = commitToDb;
        this.allOrNone = allOrNone;
    }

    public Balance__c[] create(PricebookEntry[] entries) {
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

        if (this.commitToDb) {
            for (
                Database.SaveResult sr : Database.insert(
                    balances,
                    this.allOrNone
                )
            ) {
                if (!sr.isSuccess()) {
                    this.logger.add(
                        String.format(
                            'BalanceService.create {0}',
                            new List<Object>{ sr.getErrors().toString() }
                        )
                    );
                }
            }
        }

        this.logger.publish();
        return balances;
    }
}
