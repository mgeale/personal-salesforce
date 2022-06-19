public with sharing class CoinGeckoPricesQueueable implements Queueable, Database.AllowsCallouts {
  private Id priceBookId;
  private Log logger;

  @testVisible
  private static Boolean doChainJob = true;

  public CoinGeckoPricesQueueable(Id priceBookId) {
    this.priceBookId = priceBookId;
    this.logger = Log.get();
  }

  public void execute(QueueableContext ctx) {
    List<String> externalIds = new List<String>();
    List<Product2> products = [
      SELECT Id, ExternalId
      FROM Product2
      WHERE Family = 'Web3'
    ];
    for (Product2 p : products) {
      externalIds.add(p.ExternalId);
    }
    if (externalIds.size() == 0) {
      return;
    }
    HttpResponse response = RestClient.makeApiCall(
      'CoinGecko',
      RestClient.HttpVerb.GET,
      '/api/v3/simple/price?ids=' +
      String.join(externalIds, ',') +
      '&vs_currencies=aud'
    );
    if (response.getStatusCode() != 200) {
      this.logger.publish('Error: ' + response.getBody());
      return;
    }
    CoinGeckoParser parsedResponse = CoinGeckoParser.parse(response.getBody());
    List<PricebookEntry> entries = new List<PricebookEntry>();
    for (Product2 p : products) {
      CoinGeckoParser.Coin c = parsedResponse.coins.get(p.ExternalId);
      if (c == null) {
        continue;
      }
      PricebookEntry e = new PricebookEntry();
      e.Product2Id = p.Id;
      e.Pricebook2Id = this.priceBookId;
      e.UnitPrice = c.currencies.get('aud');
      entries.add(e);
    }
    insert entries;

    if (doChainJob) {
      System.enqueueJob(new BalanceCreatorQueueable(this.priceBookId));
    }
  }
}