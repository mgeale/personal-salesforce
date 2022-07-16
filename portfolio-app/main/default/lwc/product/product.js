import { LightningElement, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { subscribe, MessageContext } from 'lightning/messageService';
import PRODUCT_ID from '@salesforce/schema/Product2.Id';
import PRODUCT_NAME from '@salesforce/schema/Product2.Name';
import PRODUCT_IMAGE from '@salesforce/schema/Product2.DisplayUrl';
import PRODUCT_SELECTED_CHANNEL from '@salesforce/messageChannel/Product_Selected__c';
import getTotalAmount from '@salesforce/apex/AssetController.getTotalAmount';

const fields = [PRODUCT_ID, PRODUCT_NAME, PRODUCT_IMAGE];

export default class Product extends LightningElement {
    recordId;
    error;
    product;

    _totalAmount;

    subscription = null;

    @wire(getRecord, {
        recordId: '$recordId',
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

    @wire(getTotalAmount, { productId: '$recordId' })
    wiredTotalAmount({ error, data }) {
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

    get totalAmount() {
        return this._totalAmount;
    }
}
