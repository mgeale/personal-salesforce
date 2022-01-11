import { LightningElement, wire } from "lwc";
import { fireEvent, unregisterAllListeners } from "c/pubsub";
import { CurrentPageReference } from "lightning/navigation";
import getProductList from "@salesforce/apex/ProductController.getProductList";

export default class ProductList extends LightningElement {
  empMessage;
  error;
  tableData;
  treeData;

  @wire(CurrentPageReference) pageRef;

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

  disconnectedCallback() {
    unregisterAllListeners(this);
  }

  handleTreeItemSelected(event) {
    const recordId = event.detail.name;
    if (recordId) {
      fireEvent(this.pageRef, "product__fieldselected", recordId);
    }
  }
}
