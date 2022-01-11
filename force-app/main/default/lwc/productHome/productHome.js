import { LightningElement, wire } from "lwc";
import getProductList from "@salesforce/apex/ProductController.getProductList";

export default class Asset extends LightningElement {
  products = [];
  error;

  constructor() {
    super();
    this.formatterCurrency = new Intl.NumberFormat("en-AU", {
      style: "currency",
      currency: "AUD"
    });
    this.formatterDecimal = new Intl.NumberFormat("en-AU", {
      style: "decimal"
    });
    this.formatterPercent = new Intl.NumberFormat("en-AU", {
      style: "percent"
    });
  }

  @wire(getProductList)
  wiredProducts({ error, data }) {
    if (error) {
      this.error = error;
    } else if (data) {
      this.products = data.map((item) => {
        const price = item.PricebookEntries
          ? item.PricebookEntries[0].UnitPrice
          : null;
        const pricePrevious = item.PricebookEntries
          ? item.PricebookEntries[1].UnitPrice
          : null;
        const priceChange = this.formatterPercent.format(
          (price - pricePrevious) / pricePrevious
        );
        const balance = item.Balances__r
          ? this.formatterDecimal.format(item.Balances__r[0].Balance__c)
          : null;
        const balanceAUD = item.Balances__r
          ? this.formatterCurrency.format(item.Balances__r[0].Balance_AUD__c)
          : null;
        return {
          id: item.Id,
          name: item.Name,
          imageUrl: item.DisplayUrl,
          code: item.ProductCode,
          price,
          priceChange,
          priceStyle: priceChange > 0 ? "positive" : "negative",
          balance,
          balanceAUD
        };
      });

      this.products.sort((a, b) => a.balanceAUD > b.balanceAUD && -1 || 1);
    }
  }
}
