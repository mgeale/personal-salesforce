public with sharing class AssetController {
  @AuraEnabled(cacheable=true)
  public static List<Asset> getTransactionHistory(Id productId) {
    return [
      SELECT PurchaseDate, Price__c, Quantity__c, Total_Cost__c, Status
      FROM Asset
      WHERE Product2Id = :productId
      ORDER BY CreatedDate DESC
      LIMIT 3
    ];
  }

  @AuraEnabled(cacheable=true)
  public static Decimal getTotalAmount(ID productId) {
    return AssetService.getTotalAmount(productId);
  }
}
