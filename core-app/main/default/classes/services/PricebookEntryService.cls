public with sharing class PricebookEntryService {
    public static void create(
        Id priceBookId,
        ProductService.ProductInfo[] products,
        Boolean allOrNone
    ) {
        PricebookEntry[] entries = new List<PricebookEntry>{};
        for (ProductService.ProductInfo p : products) {
            entries.add(
                new PricebookEntry(
                    Product2Id = p.productId,
                    UnitPrice = p.price,
                    Pricebook2Id = priceBookId
                )
            );
        }

        for (Database.SaveResult sr : Database.insert(entries, allOrNone)) {
            Log logger = Log.get();
            if (!sr.isSuccess()) {
                logger.add(
                    String.format(
                        'PricebookEntry.create {0}',
                        new List<Object>{ sr.getErrors().toString() }
                    )
                );
            }
            logger.publish();
        }
    }
}
