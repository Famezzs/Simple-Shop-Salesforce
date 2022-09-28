import {LightningElement, api, wire, track} from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {createRecord} from 'lightning/uiRecordApi';
import {updateRecord} from "lightning/uiRecordApi";
import getAccountByAccountId from '@salesforce/apex/AccountSelector.getAccountByAccountId';
import getProductNameById from '@salesforce/apex/ProductSelector.getProductNameById';

import PURCHASE_OBJECT from '@salesforce/schema/Purchase__c';
import PURCHASE_NAME_FIELD from '@salesforce/schema/Purchase__c.Name';
import PURCHASE_VENDOR_FIELD from '@salesforce/schema/Purchase__c.Vendor__c';
import PURCHASE_STATUS_FIELD from '@salesforce/schema/Purchase__c.Status__c';

import ORDER_OBJECT from '@salesforce/schema/PurchaseLineItem__c';
import ORDER_PURCHASE_FIELD from '@salesforce/schema/PurchaseLineItem__c.Purchase__c';
import ORDER_PRODUCT_FIELD from '@salesforce/schema/PurchaseLineItem__c.Product__c';
import ORDER_PRICE_FIELD from '@salesforce/schema/PurchaseLineItem__c.Price__c';
import ORDER_QUANTITY_FIELD from '@salesforce/schema/PurchaseLineItem__c.Quantity__c';

export default class PurchaseOrder extends LightningElement {
    @api
    recordId;

    @wire (getAccountByAccountId, {accountId: '$recordId'})
    account;

    @track
    purchaseOrders = [];

    isDraft;

    showAddOrder = false;

    purchaseName;

    currentOrder;

    quantity;

    price;

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

    handleCurrentOrderChange(event) {
        this.currentOrder = event.target.value;
    }

    handleQuantityChange(event) {
        this.quantity = event.target.value;
    }

    handlePriceChange(event) {
        this.price = event.target.value;
    }

    handleShowAddOrder() {
        this.showAddOrder ^= true;

        if (!this.showAddOrder) {
            this.clearAllInputFields();
        }
    }

    handleRemoveOrder(event) {
        let index = event.target.value;

        this.removePurchaseOrder(index);
    }

    addPurchaseOrder() {

        if (!this.arePurchaseOrderFieldsValid()) {
            this.showToastNotification('Invalid Order Values', 'Please provide valid values for fields in the form', 'error');
            return;
        }

        getProductNameById({productId: this.currentOrder})
            .then((value) => {
                let newPurchaseOrder = { product: this.currentOrder, name: value, quantity: this.quantity, price: this.price };
                this.purchaseOrders.push(newPurchaseOrder);
                this.clearAllInputFields();
            })
            .catch(() => {
                let newPurchaseOrder = { product: this.currentOrder, name: '', quantity: this.quantity, price: this.price };
                this.purchaseOrders.push(newPurchaseOrder);
                this.clearAllInputFields();
            });
    }

    clearAllInputFields() {
        this.currentOrder = null;
        this.quantity = null;
        this.price = null;
    }

    removePurchaseOrder(index) {
        let newPurchaseOrders = [];

        if (index == null ||
            index < 0) {

            return;
        }

        for (let currentIndex = 0; currentIndex < this.purchaseOrders.length; currentIndex += 1) {
            if (currentIndex !== index) {
                newPurchaseOrders.push(this.purchaseOrders.at(currentIndex));
            }
        }

        this.purchaseOrders = newPurchaseOrders;
    }

    showToastNotification(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });

        this.dispatchEvent(event);
    }

    showError(message) {
        this.showToastNotification('An Error Occurred', message, 'error');
    }

    arePurchaseOrderFieldsValid() {
        return this.currentOrder &&
            this.quantity > 0 &&
            this.price > 0;
    }

    savePurchase() {
        const purchaseRecord = this.createNewPurchaseObject();

        createRecord(purchaseRecord)
            .then(() => {
                alert('success');
            })
            .catch((error) => {
                alert(error.message);
            })

        /*
        createRecord(purchaseRecord)
            .then((purchaseId) => {
                this.saveOrders(purchaseId.id);

                if (!this.isDraft) {
                    purchaseRecord.fields[PURCHASE_STATUS_FIELD.fieldApiName] = 'Completed';

                    updateRecord(purchaseRecord)
                        .then(() => {

                        })
                        .catch((error) => {
                           this.showError(error.message + 'createRecord(purchaseRecord)');
                        });
                }

                this.showToastNotification('Success', 'Purchase successfully created!', 'success');
            })
            .catch((error) => {
                this.showError(error.message + 'savePurchase()');
            });

         */
    }

    saveOrders(purchaseId) {
        this.purchaseOrders.forEach((order) => {
            createRecord(this.createNewOrderObject(order, purchaseId))
                .then(() => {

                })
                .catch((error) => {
                    this.showError(error.message + 'saveOrders()');
                });
        });
    }

    createNewPurchaseObject() {
        let fields = {};

        fields[PURCHASE_NAME_FIELD.fieldApiName] = this.purchaseName;
        fields[PURCHASE_VENDOR_FIELD.fieldApiName] = this.recordId;

        return { apiName: PURCHASE_OBJECT.objectApiName, fields };
    }

    createNewOrderObject(order, purchaseId) {
        let fields = {};

        fields[ORDER_PURCHASE_FIELD.fieldApiName] = purchaseId;
        fields[ORDER_PRODUCT_FIELD.fieldApiName] = order.product;
        fields[ORDER_PRICE_FIELD.fieldApiName] = order.price;
        fields[ORDER_QUANTITY_FIELD.fieldApiName] = order.quantity;

        return { apiName: ORDER_OBJECT.objectApiName, fields };
    }
}