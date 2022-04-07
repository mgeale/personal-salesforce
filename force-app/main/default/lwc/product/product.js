import { LightningElement, wire } from "lwc";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import { CurrentPageReference } from "lightning/navigation";
import { subscribe, MessageContext } from 'lightning/messageService';
import PRODUCT_ID from "@salesforce/schema/Product2.Id";
import PRODUCT_NAME from "@salesforce/schema/Product2.Name";
import PRODUCT_IMAGE from "@salesforce/schema/Product2.DisplayUrl";
import PRODUCT_SELECTED_CHANNEL from '@salesforce/messageChannel/Product_Selected__c';
import getTransactionHistory from "@salesforce/apex/AssetController.getTransactionHistory";
import getTotalAmount from "@salesforce/apex/AssetController.getTotalAmount";

const fields = [PRODUCT_ID, PRODUCT_NAME, PRODUCT_IMAGE];

export default class Product extends LightningElement {
  subscription = null;
  error;
  product;
  recordId;

  _transactionHistory;
  _totalAmount;
  _transactionColumns = [
    { label: "Date", fieldName: "date", type: "text" },
    { label: "Quantity", fieldName: "quantity", type: "text" },
    { label: "Price Per Unit", fieldName: "price", type: "text" },
    { label: "Total Cost", fieldName: "totalCost", type: "text" }
  ];

  @wire(CurrentPageReference) pageRef;

  @wire(getRecord, {
    recordId: "$recordId",
    fields
  })
  wiredRecord({ error, data }) {
    if (error) {
      this.error = error;
      this.product = undefined;
    } else if (data) {
      this.error = undefined;
      this.product = data;
    } else {
      this.product = undefined;
    }
  }

  @wire(getTransactionHistory, { productId: "$recordId" })
  apexTransactionHistory({ error, data }) {
    if (error) {
      this.error = error;
      this._transactionHistory = undefined;
    } else if (data) {
      this._transactionHistory = data.map((item) => {
        return {
          id: item.Id,
          date: item.PurchaseDate,
          quantity: item.Quantity__c,
          price: item.Price__c,
          totalCost: item.Total_Cost__c
        };
      });
    } else {
      this._transactionHistory = undefined;
    }
  }

  @wire(getTotalAmount, { productId: "$recordId" })
  apexTotalAmount({ error, data }) {
    if (error) {
      this.error = error;
      this._totalAmount = undefined;
    } else if (data) {
      this._totalAmount = data;
    } else {
      this._totalAmount = undefined;
    }
  }

  @wire(MessageContext)
  messageContext;

  subscribeToMessageChannel() {
    this.subscription = subscribe(
        this.messageContext,
        PRODUCT_SELECTED_CHANNEL,
        (message) => this.handleMessage(message)
    );
  }

  handleMessage(message) {
    this.recordId = message.recordId;
  }

  connectedCallback() {
    this.subscribeToMessageChannel();
  }

  disconnectedCallback() {}

  get productName() {
    return getFieldValue(this.product, PRODUCT_NAME);
  }

  get productImage() {
    return getFieldValue(this.product, PRODUCT_IMAGE);
  }

  get transactionColumns() {
    return this._transactionColumns;
  }

  get transactionHistory() {
    return this._transactionHistory;
  }

  get totalAmount() {
    return this._totalAmount;
  }
}