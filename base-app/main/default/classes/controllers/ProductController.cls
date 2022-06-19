public with sharing class ProductController {
  @AuraEnabled(cacheable=true)
  public static List<Product2> getProductList() {
    return [
      SELECT
        Id,
        Name,
        ProductCode,
        IsActive,
        Family,
        DisplayUrl,
        (
          SELECT UnitPrice
          FROM PricebookEntries
          ORDER BY createddate DESC
          LIMIT 2
        ),
        (
          SELECT Balance__c, Balance_AUD__c
          FROM Balances__r
          ORDER BY createddate DESC
          LIMIT 1
        )
      FROM Product2
      WHERE IsActive = TRUE
    ];
  }
}