@isTest
public class BalanceService_Test {
    @TestSetup
    static void makeData() {
        Product2 prod = (Product2) TestDataFactory.createSObject(
            'Product2',
            new Map<String, Object>{
                'Name' => 'Ethereum',
                'ExternalId' => 'ethereum',
                'Family' => 'Crypto',
                'IsActive' => true
            }
        );
        Account acc = (Account) TestDataFactory.createSObject('Account');

        Id pricebookId = Test.getStandardPricebookId();
        insert new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = prod.id,
            UnitPrice = 1.5
        );
        insert new Asset(
            Quantity__c = 10,
            Status = 'reward',
            Product2Id = prod.id,
            Name = 'blah',
            AccountId = acc.id
        );
    }

    @isTest
    public static void shouldCreateBalanceEntries() {
        Id pricebookId = Test.getStandardPricebookId();

        Test.startTest();
        Balance__x[] result = BalanceService.create(
            new PricebookEntrySelector()
                .selectByPricebookId(new Set<Id>{ priceBookId })
        );
        Test.stopTest();

        System.assert(result.size() > 0);
    }
}
