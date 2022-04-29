@isTest
public class CapitalGainsTriggerHandlerTest {
  private static Map<String, ID> setup() {
    Account acc = (Account) TestDataFactory.createSObject(
      'Account',
      new Map<String, Object>{}
    );
    Product2 prod = (Product2) TestDataFactory.createSObject(
      'Product2',
      new Map<String, Object>{}
    );
    Asset a1 = (Asset) TestDataFactory.createSObject(
      'Asset',
      new Map<String, Object>{
        'Price__c' => 1,
        'Quantity__c' => 200,
        'Status' => 'Sold',
        'PurchaseDate' => Date.newInstance(1960, 2, 17),
        'Account.id' => acc.id,
        'Product2.id' => prod.id
      }
    );
    Asset a2 = (Asset) TestDataFactory.createSObject(
      'Asset',
      new Map<String, Object>{
        'Price__c' => 1.1,
        'Quantity__c' => 250,
        'Status' => 'Purchase',
        'PurchaseDate' => Date.newInstance(1960, 2, 17),
        'Account.id' => acc.id,
        'Product2.id' => prod.id
      }
    );
    return new Map<String, ID>{ 'a1' => a1.ID, 'a2' => a2.ID };
  }

  @isTest
  static void shouldUpdateTaxedAmount() {
    Map<String, ID> testData = setup();

    Capital_Gains__c cg = new Capital_Gains__c(
      Amount__c = 100,
      Purchase__c = testData.get('a2'),
      Sold__c = testData.get('a1')
    );
    List<Capital_Gains__c> cgList = new List<Capital_Gains__c>();
    cgList.add(cg);
    CapitalGainsTriggerHandler.checkAmountTaxed(cgList);

    List<Asset> result = [
      SELECT Amount_Taxed__c
      FROM Asset
      WHERE ID IN (:testData.get('a2'), :testData.get('a1'))
    ];
    System.assertEquals(100, result[0].Amount_Taxed__c);
    System.assertEquals(100, result[1].Amount_Taxed__c);
  }

  @isTest
  static void shouldUpdateTaxedAmountMultipleEntries() {
    Map<String, ID> testData = setup();

    Capital_Gains__c cg1 = new Capital_Gains__c(
      Amount__c = 100,
      Purchase__c = testData.get('a2'),
      Sold__c = testData.get('a1')
    );
    CapitalGainsTriggerHandler.checkAmountTaxed(
      new List<Capital_Gains__c>{ cg1 }
    );

    Capital_Gains__c cg2 = new Capital_Gains__c(
      Amount__c = 100,
      Purchase__c = testData.get('a2'),
      Sold__c = testData.get('a1')
    );
    CapitalGainsTriggerHandler.checkAmountTaxed(
      new List<Capital_Gains__c>{ cg2 }
    );

    List<Asset> result = [
      SELECT Amount_Taxed__c
      FROM Asset
      WHERE ID IN (:testData.get('a2'), :testData.get('a1'))
    ];
    System.assertEquals(100, result[0].Amount_Taxed__c);
    System.assertEquals(100, result[1].Amount_Taxed__c);
  }

  @isTest
  static void shouldFailUpdateTaxedAmount() {
    Map<String, ID> testData = setup();

    Capital_Gains__c cg = new Capital_Gains__c(
      Amount__c = 1000,
      Purchase__c = testData.get('a2'),
      Sold__c = testData.get('a1')
    );
    List<Capital_Gains__c> cgList = new List<Capital_Gains__c>();
    cgList.add(cg);
    CapitalGainsTriggerHandler.checkAmountTaxed(cgList);

    List<Asset> result = [
      SELECT Amount_Taxed__c
      FROM Asset
      WHERE ID IN (:testData.get('a2'), :testData.get('a1'))
    ];
    System.assertEquals(null, result[0].Amount_Taxed__c);
    System.assertEquals(null, result[1].Amount_Taxed__c);
  }

  @isTest
  static void shouldFaliUpdateTaxedAmountMultipleEntries() {
    Map<String, ID> testData = setup();

    Capital_Gains__c cg1 = new Capital_Gains__c(
      Amount__c = 100,
      Purchase__c = testData.get('a2'),
      Sold__c = testData.get('a1')
    );
    CapitalGainsTriggerHandler.checkAmountTaxed(
      new List<Capital_Gains__c>{ cg1 }
    );

    Capital_Gains__c cg2 = new Capital_Gains__c(
      Amount__c = 1000,
      Purchase__c = testData.get('a2'),
      Sold__c = testData.get('a1')
    );
    CapitalGainsTriggerHandler.checkAmountTaxed(
      new List<Capital_Gains__c>{ cg2 }
    );

    List<Asset> result = [
      SELECT Amount_Taxed__c
      FROM Asset
      WHERE ID IN (:testData.get('a2'), :testData.get('a1'))
    ];
    System.assertEquals(100, result[0].Amount_Taxed__c);
    System.assertEquals(100, result[1].Amount_Taxed__c);
  }
}
