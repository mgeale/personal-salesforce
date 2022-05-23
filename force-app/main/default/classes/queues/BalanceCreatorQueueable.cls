public with sharing class BalanceCreatorQueueable implements Queueable {
  private Id priceBookId;

  public BalanceCreatorQueueable(Id priceBookId) {
    this.priceBookId = priceBookId;
  }

  public void execute(QueueableContext ctx) {
    List<PricebookEntry> entries = [
      SELECT id, Product2Id, UnitPrice
      FROM PricebookEntry
      WHERE Pricebook2Id = :this.priceBookId
    ];
    List<ID> productIds = new List<ID>();
    for (PricebookEntry e : entries) {
      productIds.add(e.Product2Id);
    }
    Map<String, Decimal> totalAmounts = AssetService.getTotalAmounts(
      productIds
    );

    List<Balance__c> balances = new List<Balance__c>();
    for (PricebookEntry e : entries) {
      Decimal amount = totalAmounts.get(e.Product2Id);
      if (amount == 0) {
        continue;
      }
      Balance__c b = new Balance__c();
      b.Price_Book__c = this.priceBookId;
      b.Product__c = e.Product2Id;
      b.Balance__c = amount;
      b.Balance_AUD__c = amount * e.UnitPrice;
      balances.add(b);
    }
    insert balances;
  }
}