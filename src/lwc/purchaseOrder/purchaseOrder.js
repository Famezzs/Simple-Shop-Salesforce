import {LightningElement, api, wire, track} from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {createRecord} from 'lightning/uiRecordApi';
import {updateRecord} from 'lightning/uiRecordApi';
import getProductNameById from '@salesforce/apex/ProductSelector.getProductNameById';

import PURCHASE_OBJECT from '@salesforce/schema/Purchase__c';
import PURCHASE_ID_FIELD from '@salesforce/schema/Purchase__c.Id';
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

    @track
    purchaseOrders = [];

    isDraft = true;

    isSaveButtonDisabled = false;

    showAddOrder = false;

    purchaseName;

    currentOrder;

    quantity;

    price;

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

    handleIsDraftChange(event) {
        this.isDraft = event.target.checked;
    }

    addPurchaseOrder() {

        if (!this.arePurchaseOrderFieldsValid()) {
            this.showToastNotification('Invalid Order Values', 'Please provide valid values for fields in the form', 'error');
            return;
        }

        getProductNameById({productId: this.currentOrder})
            .then((value) => {
                let newPurchaseOrder = {
                    product: this.currentOrder,
                    name: value,
                    quantity: this.quantity,
                    price: this.price
                };
                this.purchaseOrders.push(newPurchaseOrder);
                this.clearAllInputFields();
            })
            .catch(() => {
                let newPurchaseOrder = {
                    product: this.currentOrder,
                    name: '',
                    quantity: this.quantity,
                    price: this.price
                };
                this.purchaseOrders.push(newPurchaseOrder);
                this.clearAllInputFields();
            });
    }

    clearAllInputFields() {
        this.currentOrder = null;
        this.quantity = null;
        this.price = null;
    }

    clearAllOrders() {
        this.purchaseOrders = [];
    }

    resetForm() {
        this.showAddOrder = false;
        this.clearAllInputFields();
        this.clearAllOrders();
        this.purchaseName = null;
        this.isSaveButtonDisabled = false;
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

    showSuccess(message) {
        this.showToastNotification('Success', message, 'success');
    }

    arePurchaseOrderFieldsValid() {
        return this.currentOrder &&
            this.quantity > 0 &&
            this.price > 0;
    }

    async savePurchase() {
        let purchaseRecord = this.createNewPurchaseObject();

        this.isSaveButtonDisabled = true;

        createRecord(purchaseRecord)
            .then(async (purchaseRepresentation) => {
                await this.saveOrders(purchaseRepresentation.id);

                if (!this.isDraft) {
                    await this.markPurchaseAsCompleted(purchaseRecord, purchaseRepresentation.id);
                }

                this.resetForm();
                this.showSuccess('Purchase successfully created!');
            })
            .catch((error) => {
                this.showError(error.message);
            });
    }

    async saveOrders(purchaseId) {
        for (const order of this.purchaseOrders) {
            await createRecord(this.createNewOrderObject(order, purchaseId));
        }
    }

    createNewPurchaseObject() {
        let fields = {};

        fields[PURCHASE_NAME_FIELD.fieldApiName] = this.purchaseName;
        fields[PURCHASE_VENDOR_FIELD.fieldApiName] = this.recordId;
        fields[PURCHASE_STATUS_FIELD.fieldApiName] = 'Draft';

        return {apiName: PURCHASE_OBJECT.objectApiName, fields};
    }

    createNewOrderObject(order, purchaseId) {
        let fields = {};

        fields[ORDER_PURCHASE_FIELD.fieldApiName] = purchaseId;
        fields[ORDER_PRODUCT_FIELD.fieldApiName] = order.product;
        fields[ORDER_PRICE_FIELD.fieldApiName] = order.price;
        fields[ORDER_QUANTITY_FIELD.fieldApiName] = order.quantity;

        return {apiName: ORDER_OBJECT.objectApiName, fields};
    }

    async markPurchaseAsCompleted(purchase, purchaseId) {
        purchase.apiName = null;
        purchase.fields[PURCHASE_ID_FIELD.fieldApiName] = purchaseId;
        purchase.fields[PURCHASE_STATUS_FIELD.fieldApiName] = 'Completed';

        await updateRecord(purchase);
    }
}