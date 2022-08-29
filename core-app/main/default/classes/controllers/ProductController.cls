public with sharing class ProductController {
    @AuraEnabled(cacheable=true)
    public static ProductService.ProductInfo[] getProductInfo(ID[] productIds) {
        Product2[] products = new ProductSelector()
            .selectById(new Set<Id>(productIds));
        return new ProductService().convertToProductInfos(products);
    }

    @AuraEnabled(cacheable=true)
    public static Product2[] getProductList() {
        Boolean isActive = true;
        Integer limitCount = 10;
        Boolean includePricebookEntries = true;
        Boolean includeBalances = true;
        return new ProductSelector()
            .selectAll(
                isActive,
                limitCount,
                includePricebookEntries,
                includeBalances
            );
    }
}
