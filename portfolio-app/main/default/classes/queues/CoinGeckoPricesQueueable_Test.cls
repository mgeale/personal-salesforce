@isTest
public class CoinGeckoPricesQueueable_Test {
  @isTest
  public static void shouldSavePricesBookEntries() {
    CoinGeckoPricesQueueable.doChainJob = false;

    String response = '{"ethereum":{"aud":6178.0},"avalanche-2":{"aud":94.07},"maker":{"aud":3930.0},"usd-coin":{"aud":1.35},"tether":{"aud":1.35},"0x":{"aud":1.7},"augur":{"aud":34.03},"dai":{"aud":1.35},"cdai":{"aud":0.02921444},"compound-usd-coin":{"aud":0.03002133}}';
    MockHttpCalloutResponse mock = new MockHttpCalloutResponse(
      200,
      response,
      null
    );
    Test.setMock(HttpCalloutMock.class, mock);

    Product2 p = (Product2) TestDataFactory.createSObject(
      'Product2',
      new Map<String, Object>{
        'Name' => 'Ethereum',
        'ExternalId' => 'ethereum',
        'Family' => 'Web3'
      }
    );

    Id pricebookId = Test.getStandardPricebookId();

    Test.startTest();
    System.enqueueJob(new CoinGeckoPricesQueueable(pricebookId));
    Test.stopTest();

    List<PricebookEntry> result = [
      SELECT id, Product2Id, UnitPrice
      FROM PricebookEntry
      WHERE Pricebook2Id = :pricebookId
    ];
    System.assertEquals(6178.0, result[0].UnitPrice);
  }
}