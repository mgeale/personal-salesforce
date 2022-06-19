import { LightningElement, wire } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import { publish, MessageContext } from "lightning/messageService";
import getProductList from "@salesforce/apex/ProductController.getProductList";
import PRODUCT_SELECTED_CHANNEL from "@salesforce/messageChannel/Product_Selected__c";

export default class ProductList extends LightningElement {
  error;
  tableData;
  treeData;

  @wire(CurrentPageReference) pageRef;

  @wire(MessageContext)
  messageContext;

  @wire(getProductList)
  apexProduct({ error, data }) {
    if (error) {
      this.error = error;
      this.treeData = undefined;
      this.tableData = undefined;
    } else if (data) {
      this.error = undefined;
      this.tableData = data;
      const map = {};
      const items = [];
      data.forEach((field) => {
        if (!map[field.Family]) {
          map[field.Family] = [];
        }
        map[field.Family].push({
          label: field.Name,
          name: field.Id,
          expanded: false
        });
      });

      Object.keys(map).forEach((key) => {
        items.push({
          label: key,
          expanded: false,
          items: map[key]
        });
      });

      this.treeData = items;
    }
  }

  connectedCallback() {}

  disconnectedCallback() {}

  handleTreeItemSelected(event) {
    const payload = { recordId: event.detail.name };

    publish(this.messageContext, PRODUCT_SELECTED_CHANNEL, payload);
  }
}