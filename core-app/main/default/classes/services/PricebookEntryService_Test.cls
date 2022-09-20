@isTest
public class PricebookEntryService_Test {
    @TestSetup
    static void makeData() {
        TestDataFactory.createSObject(
            'Product2',
            new Map<String, Object>{
                'ExternalId' => 'fake_id',
                'Family' => 'Web3'
            }
        );
    }

    @isTest
    public static void shouldSavePricesBookEntries() {
        di_Injector.Org.Bindings.set(
            new di_Module()
                .bind(PricesCalloutService.class)
                .toObject(
                    Test.createStub(
                        PricesCalloutService.class,
                        new PricesCalloutServiceStub()
                    )
                )
        );

        Id pricebookId = Test.getStandardPricebookId();
        Pricebook2[] priceBooks = (Pricebook2[]) TestDataFactory.createSObjectList(
            'PriceBook2',
            new Map<String, Object>{
                'id' => pricebookId,
                'Product_Family__c' => 'Web3'
            },
            1,
            false
        );

        ProductService.ProductInfo[] products = new ProductService()
            .convertToProductInfos(
                [SELECT Id, ExternalId, Family FROM Product2]
            );

        Test.startTest();
        new PricebookEntryService(true, false).create(priceBooks, products);
        Test.stopTest();

        List<PricebookEntry> result = [
            SELECT UnitPrice
            FROM PricebookEntry
            WHERE Pricebook2Id = :pricebookId
        ];
        System.assertEquals(6178.0, result[0].UnitPrice);
    }

    @isTest
    public static void shouldFailToSavePricesBookEntries() {
        di_Injector.Org.Bindings.set(
            new di_Module()
                .bind(PricesCalloutService.class)
                .toObject(
                    Test.createStub(
                        PricesCalloutService.class,
                        new PricesCalloutServiceStub()
                    )
                )
        );

        // fake id to trigger DmlException
        Id pricebookId =
            PricebookEntry.SObjectType.getDescribe().getKeyPrefix() +
            '0'.repeat(11) +
            1;

        Pricebook2[] priceBooks = (Pricebook2[]) TestDataFactory.createSObjectList(
            'PriceBook2',
            new Map<String, Object>{
                'id' => pricebookId,
                'Product_Family__c' => 'Web3'
            },
            1,
            false
        );

        ProductService.ProductInfo[] products = new ProductService()
            .convertToProductInfos(
                [SELECT Id, ExternalId, Family FROM Product2]
            );

        Test.startTest();
        try {
            new PricebookEntryService().create(priceBooks, products);
            System.assert(false, 'Should not asset after Exception.');
        } catch (Exception e) {
            System.assert(e instanceof DmlException);
        }
        Test.stopTest();
    }

    private class PricesCalloutServiceStub implements System.StubProvider {
        public Map<String, Object> handleMethodCall(
            Object stubbedObject,
            String stubbedMethodName,
            Type returnType,
            List<Type> listOfParamTypes,
            List<String> listOfParamNames,
            List<Object> listOfArgs
        ) {
            return new Map<String, Object>{ 'fake_id' => 6178.0 };
        }
    }
}
