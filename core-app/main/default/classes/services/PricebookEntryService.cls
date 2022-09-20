public with sharing class PricebookEntryService {
    private Log logger;
    private Boolean commitToDb;
    private Boolean allOrNone;

    public PricebookEntryService() {
        this(true, true);
    }

    public PricebookEntryService(Boolean commitToDb, Boolean allOrNone) {
        this.logger = Log.get();
        this.commitToDb = commitToDb;
        this.allOrNone = allOrNone;
    }

    public PricebookEntry[] create(
        Pricebook2[] priceBooks,
        ProductService.ProductInfo[] productInfos
    ) {
        PricebookEntry[] entries = new List<PricebookEntry>{};
        for (Pricebook2 book : priceBooks) {
            for (ProductService.ProductInfo p : productInfos) {
                if (book.Product_Family__c == p.family) {
                    entries.add(
                        new PricebookEntry(
                            Product2Id = p.productId,
                            UnitPrice = p.price,
                            Pricebook2Id = book.id
                        )
                    );
                }
            }
        }

        if (this.commitToDb) {
            for (
                Database.SaveResult sr : Database.insert(
                    entries,
                    this.allOrNone
                )
            ) {
                if (!sr.isSuccess()) {
                    this.logger.add(
                        String.format(
                            'PricebookEntryService.create {0}',
                            new List<Object>{ sr.getErrors().toString() }
                        )
                    );
                }
            }
        }

        this.logger.publish();
        return entries;
    }
}
