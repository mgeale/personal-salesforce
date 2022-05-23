@isTest
public class BalanceCreatorQueueable_Test {
  @isTest
  public static void shouldCreateBalanceEntries() {
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

    Test.startTest();
    System.enqueueJob(new BalanceCreatorQueueable(pricebookId));
    Test.stopTest();

    List<Balance__c> result = [
      SELECT Balance__c, Balance_AUD__c
      FROM Balance__c
      WHERE Price_Book__c = :pricebookId AND Product__c = :prod.id
    ];
    System.assertEquals(10, result[0].Balance__c);
    System.assertEquals(15, result[0].Balance_AUD__c);
  }
}