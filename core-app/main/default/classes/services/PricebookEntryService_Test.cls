@isTest
public class PricebookEntryService_Test {
    @TestSetup
    static void makeData() {
        TestDataFactory.createSObject(
            'Product2',
            new Map<String, Object>{ 'ExternalId' => 'fake_id' }
        );
    }

    @isTest
    public static void shouldSavePricesBookEntries() {
        di_Injector.Org.Bindings.set(
            new di_Module()
                .bind(CalloutService.class)
                .toObject(
                    Test.createStub(
                        CalloutService.class,
                        new CalloutServiceStub()
                    )
                )
        );

        Id pricebookId = Test.getStandardPricebookId();

        ProductService.ProductInfo[] products = new ProductService()
            .convertToProductInfos([SELECT Id, ExternalId FROM Product2]);

        Test.startTest();
        PricebookEntryService.create(pricebookId, products, false);
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
                .bind(CalloutService.class)
                .toObject(
                    Test.createStub(
                        CalloutService.class,
                        new CalloutServiceStub()
                    )
                )
        );

        // fake id to trigger DmlException
        Id pricebookId =
            PricebookEntry.SObjectType.getDescribe().getKeyPrefix() +
            '0'.repeat(11) +
            1;

        ProductService.ProductInfo[] products = new ProductService()
            .convertToProductInfos([SELECT Id, ExternalId FROM Product2]);

        Test.startTest();
        try {
            PricebookEntryService.create(pricebookId, products, true);
            System.assert(false, 'Should not asset after Exception.');
        } catch (Exception e) {
            System.assert(e instanceof DmlException);
        }
        Test.stopTest();
    }

    private class CalloutServiceStub implements System.StubProvider {
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
