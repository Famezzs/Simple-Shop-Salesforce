import {LightningElement, api, wire} from 'lwc';
import getAccountByAccountId from '@salesforce/apex/AccountSelector.getAccountByAccountId';

export default class PurchaseOrder extends LightningElement {
    @api
    recordId;

    @wire (getAccountByAccountId, {accountId: '$recordId'})
    account;

    isDraft;

    showAddOrder = false;

    purchaseName;

    purchaseOrders = [];

    get isVendor() {
        if (!this.account) {
            return false;
        }

        if (!this.account.data) {
            return false;
        }

        return this.account.data.Type === 'Vendor';
    }

    handlePurchaseNameChange(event) {
        this.purchaseName = event.target.value;
    }

    handleShowAddOrder(event) {
        this.showAddOrder ^= true;
    }
}