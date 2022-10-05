public with sharing class PurchaseHandler {
    public static void handle(
            Map<Id, Purchase__c> oldValuesByIds,
            Map<Id, Purchase__c> newValuesByIds) {

        Set<Id> completedPurchasesIds =
                PurchaseService.getPurchaseIdsWhereStatusChangedToCompleted(oldValuesByIds, newValuesByIds);

        List<PurchaseLineItem__c> purchaseLineItems =
                PurchaseLineItemSelector.selectPurchaseLineItemsByPurchaseIds(completedPurchasesIds);

        Set<Id> productsIds = new Set<Id>();

        for (PurchaseLineItem__c item: purchaseLineItems) {
            productsIds.add(item.Product__c);
        }

        Map<Id, Product2> productsByIds = new Map<Id, Product2>
                (ProductSelector.selectProductsByIds(productsIds));

        for (PurchaseLineItem__c item: purchaseLineItems) {
            if (productsByIds.containsKey(item.Product__c)) {
                productsByIds.get(item.Product__c).ProductStock__c += item.Quantity__c;
            }
        }

        Database.update(productsByIds.values());
    }
}