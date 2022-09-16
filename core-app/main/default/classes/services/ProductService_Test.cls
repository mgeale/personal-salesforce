@isTest
public class ProductService_Test {
    @TestSetup
    static void makeData() {
        Product2 p1 = (Product2) TestDataFactory.createSObject(
            'Product2',
            new Map<String, Object>{
                'Name' => 'Prod1',
                'ExternalId' => 'fake_id',
                'Family' => 'Web3',
                'IsActive' => true
            }
        );
        Product2 p2 = (Product2) TestDataFactory.createSObject(
            'Product2',
            new Map<String, Object>{
                'Name' => 'Prod2',
                'Family' => 'Stablecoin',
                'IsActive' => true
            }
        );
        Account a = (Account) TestDataFactory.createSObject('Account');

        insert new Asset(
            Quantity__c = 10,
            Status = 'sold',
            Product2Id = p1.id,
            Name = 'blah',
            AccountId = a.id
        );
        insert new Asset(
            Quantity__c = 20,
            Status = 'purchase',
            Product2Id = p1.id,
            Name = 'blah',
            AccountId = a.id
        );
        insert new Asset(
            Quantity__c = 5,
            Status = 'reward',
            Product2Id = p1.id,
            Name = 'blah',
            AccountId = a.id
        );
        insert new Asset(
            Quantity__c = 1,
            Status = 'sold',
            Product2Id = p1.id,
            Name = 'blah',
            AccountId = a.id
        );
        insert new Asset(
            Quantity__c = 12,
            Status = 'purchase',
            Product2Id = p2.id,
            Name = 'blah',
            AccountId = a.id
        );
        insert new Asset(
            Quantity__c = 13,
            Status = 'purchase',
            Product2Id = p2.id,
            Name = 'blah',
            AccountId = a.id
        );
        insert new Asset(
            Quantity__c = 15,
            Status = 'sold',
            Product2Id = p2.id,
            Name = 'blah',
            AccountId = a.id
        );
        insert new Asset(
            Quantity__c = 5,
            Status = 'reward',
            Product2Id = p2.id,
            Name = 'blah',
            AccountId = a.id
        );
        insert new Asset(
            Quantity__c = 10,
            Status = 'sold',
            Product2Id = p2.id,
            Name = 'blah',
            AccountId = a.id
        );
    }

    @isTest
    public static void shouldConstructProductInfo() {
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

        Product2 product = [
            SELECT id, ExternalId, Family
            FROM Product2
            WHERE Name = 'Prod1'
        ];

        ProductService.ProductInfo info = new ProductService.ProductInfo(
            product
        );
        System.assertEquals(14, info.total);
        System.assertEquals(178.05, info.price);
        System.assertEquals('Web3', info.family);
    }

    @isTest
    public static void shouldConstructProductInfoWithoutCallout() {
        Product2 product = [
            SELECT id, ExternalId, Family
            FROM Product2
            WHERE Name = 'Prod1'
        ];

        ProductService.ProductInfo info = new ProductService.ProductInfo(
            product,
            1.25
        );
        System.assertEquals(14, info.total);
        System.assertEquals(1.25, info.price);
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
            return new Map<String, Object>{ 'fake_id' => 178.05 };
        }
    }
}
