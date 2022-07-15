import { LightningElement, api, wire } from 'lwc';
import getTransactionHistory from '@salesforce/apex/AssetController.getTransactionHistory';

export default class TransactionTable extends LightningElement {
    @api productId;
    error;

    _transactionHistory;
    _transactionColumns = [
        { label: 'Date', fieldName: 'date', type: 'text' },
        { label: 'Quantity', fieldName: 'quantity', type: 'text' },
        { label: 'Type', fieldName: 'status', type: 'text' }
    ];

    @wire(getTransactionHistory, { productId: '$productId' })
    wiredTransactionHistory({ error, data }) {
        if (error) {
            this.error = error;
            this._transactionHistory = undefined;
        } else if (data) {
            this.error = undefined;
            this._transactionHistory = data.map((item) => {
                return {
                    id: item.Id,
                    date: item.PurchaseDate,
                    quantity: item.Quantity__c,
                    price: item.Price__c,
                    totalCost: item.Total_Cost__c,
                    status: item.Status
                };
            });
        } else {
            this._transactionHistory = undefined;
        }
    }

    get transactionColumns() {
        return this._transactionColumns;
    }

    get transactionHistory() {
        return this._transactionHistory;
    }
}
