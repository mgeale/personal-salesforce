public with sharing class BalanceController {
  @AuraEnabled(cacheable=true)
  public static List<Balance__c> getBalanceHistoryForProduct(Id productId) {
    return [
      SELECT Id, CreatedDate, Balance_AUD__c, Balance__c
      FROM Balance__c
      WHERE Product__r.id = :productId
    ];
  }
}