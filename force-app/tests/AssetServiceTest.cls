@isTest
public class AssetServiceTest {
  @TestSetup
  static void makeData() {
    Product2 p1 = (Product2) TestDataFactory.createSObject(
      'Product2',
      new Map<String, Object>{
        'Name' => 'Prod1',
        'IsActive' => true
      }
    );
    Product2 p2 = (Product2) TestDataFactory.createSObject(
      'Product2',
      new Map<String, Object>{
        'Name' => 'Prod2',
        'IsActive' => true
      }
    );
    Account a = (Account) TestDataFactory.createSObject(
      'Account',
      new Map<String, Object>{}
    );

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
  public static void shouldGetTotalAmount() {
    Product2 product = [SELECT id FROM Product2 WHERE Name = 'Prod1'];

    Decimal result = AssetService.getTotalAmount(product.id);
    System.assertEquals(14, result);
  }

  @isTest
  public static void shouldGetTotalAmounts() {
    List<Product2> products = [
      SELECT id
      FROM Product2
      WHERE Name IN ('Prod1', 'Prod2')
    ];

    Map<String, Decimal> result = AssetService.getTotalAmounts(
      new List<ID>{ products[0].id, products[1].id }
    );
    Decimal p1 = result.get(products[0].id);
    Decimal p2 = result.get(products[1].id);
    System.assertEquals(14, p1);
    System.assertEquals(5, p2);
  }
}
