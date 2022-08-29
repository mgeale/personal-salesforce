public with sharing class AssetController {
    @AuraEnabled(cacheable=true)
    public static Decimal getTotalAmount(ID productId) {
        Boolean includeOnlyActive = true;
        return new AssetSelector()
            .sumQuantitiesByProduct(
                new List<ID>{ productId },
                includeOnlyActive
            )
            .get(productId);
    }

    @AuraEnabled(cacheable=true)
    public static Asset[] getAssetsByProductId(Id productId) {
        Integer limitCount = 3;
        return new AssetSelector().selectByProductId(productId, limitCount);
    }
}
