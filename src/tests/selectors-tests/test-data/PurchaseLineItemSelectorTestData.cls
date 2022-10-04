public with sharing class PurchaseLineItemSelectorTestData {
    @TestVisible
    private static Set<Id> createPurchasesAndLineItems(Integer amountOfPurchases, Integer amountOfItems) {
        final List<Purchase__c> purchases = new List<Purchase__c>();
        final List<PurchaseLineItem__c> items = new List<PurchaseLineItem__c>();
        final Set<Id> purchaseIds = new Set<Id>();

        for (Integer currentAmount = 0; currentAmount < amountOfPurchases; ++currentAmount) {
            purchases.add(generatePurchase());
        }

        insert purchases;

        for (Purchase__c purchase: purchases) {
            for (Integer currentAmount = 0; currentAmount < amountOfItems; ++currentAmount) {
                items.add(generateLineItem(purchase.Id));
            }

            purchaseIds.add(purchase.Id);
        }

        insert items;

        return purchaseIds;
    }

    private static Purchase__c generatePurchase() {
        return new Purchase__c(Name='Test', Status__c='Draft');
    }

    private static PurchaseLineItem__c generateLineItem(Id purchaseId) {
        return new PurchaseLineItem__c(Price__c=100,
                Quantity__c=100,
                Purchase__c=purchaseId);
    }
}