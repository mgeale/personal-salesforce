@isTest
public class ProductSelector_Test {
    @TestSetup
    static void makeData() {
        Id pricebookId = Test.getStandardPricebookId();
        Product2[] products = (Product2[]) TestDataFactory.createSObjectList(
            'Product2',
            5
        );

        insert new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = products[0].id,
            UnitPrice = 10.5
        );
        insert new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = products[1].id,
            UnitPrice = 10.5
        );
        insert new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = products[2].id,
            UnitPrice = 10.5
        );
        insert new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = products[3].id,
            UnitPrice = 10.5
        );
        insert new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = products[4].id,
            UnitPrice = 10.5
        );
    }

    @IsTest
    static void shouldConstructSelectAllWithSubqueries() {
        Product2[] results = new ProductSelector()
            .selectAll(100, false, true, false);

        System.assertEquals(5, results.size());
        for (Product2 p : results) {
            System.assertEquals(1, p.PricebookEntries.size());
            for (PricebookEntry entry : p.PricebookEntries) {
                System.assertEquals(10.5, entry.UnitPrice);
            }
        }
    }
}
