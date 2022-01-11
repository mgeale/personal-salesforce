@isTest
public class BalanceCreatorQueueableTest {
  @isTest
  public static void shouldCreateBalanceEntries() {
    Product2 p = new Product2();
    p.Name = 'Ethereum';
    p.ExternalId = 'ethereum';
    p.Family = 'Crypto';
    p.IsActive = true;
    insert p;
    Account a = new Account(Name = 'blah');
    insert a;

    Id pricebookId = Test.getStandardPricebookId();
    insert new PricebookEntry(
      Pricebook2Id = pricebookId,
      Product2Id = p.id,
      UnitPrice = 1.5
    );
    insert new Asset(
      Quantity__c = 10,
      Status = 'reward',
      Product2Id = p.id,
      Name = 'blah',
      AccountId = a.id
    );

    Test.startTest();
    System.enqueueJob(new BalanceCreatorQueueable(pricebookId));
    Test.stopTest();

    List<Balance__c> result = [
      SELECT Balance__c, Balance_AUD__c
      FROM Balance__c
      WHERE Price_Book__c = :pricebookId AND Product__c = :p.id
    ];
    System.assertEquals(10, result[0].Balance__c);
    System.assertEquals(15, result[0].Balance_AUD__c);
  }
}
