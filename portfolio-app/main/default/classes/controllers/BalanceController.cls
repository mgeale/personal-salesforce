public with sharing class BalanceController {
    @AuraEnabled(cacheable=true)
    public static Balance__x[] getBalanceHistoryForProduct(Id productId) {
        Integer limitCount = 10;
        return new BalanceSelector().selectByProductId(productId, limitCount);
    }
}
