public with sharing class ProductService {
    public class ProductInfo {
        public Id productId;
        public String externalId;
        public String family;
        public Decimal price {
            get {
                if (price == null) {
                    price = (Decimal) new ProductService()
                        .getPrices(new List<String>{ this.externalId })
                        .get(this.externalId);
                }
                return price;
            }
            set;
        }
        public Decimal total {
            get {
                return new AssetSelector()
                    .sumQuantitiesByProduct(
                        new List<ID>{ this.productId },
                        true
                    )
                    .get(this.productId);
            }
        }
        public ProductInfo(Product2 prod) {
            this.productId = prod.id;
            this.externalId = prod.ExternalId;
            this.family = prod.Family;
        }
        public ProductInfo(Product2 prod, Decimal price) {
            this.productId = prod.id;
            this.externalId = prod.ExternalId;
            this.family = prod.Family;
            this.price = price;
        }
    }

    public ProductInfo[] convertToProductInfos(Product2[] products) {
        String[] externalIds = new List<String>{};
        for (Product2 p : products) {
            externalIds.add(p.externalId);
        }

        Map<String, Object> prices = (Map<String, Object>) getPrices(
            externalIds
        );
        ProductInfo[] productInfos = new List<ProductInfo>{};
        for (Product2 prod : products) {
            productInfos.add(
                new ProductInfo(prod, (Decimal) prices.get(prod.externalId))
            );
        }
        return productInfos;
    }

    private Map<String, Object> getPrices(String[] externalIds) {
        CalloutService service = (CalloutService) di_Injector.Org.getInstance(
            CalloutService.class,
            (Object) null
        );
        return (Map<String, Object>) service.makeCallout(
            new Map<String, Object[]>{ 'externalIds' => externalIds }
        );
    }
}
