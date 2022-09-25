public with sharing class PurchaseLineItemSelector {
    public static List<PurchaseLineItem__c> selectPurchaseLineItemsByPurchaseIds(Set<Id> purchaseIds) {
        return [SELECT Id, Purchase__c, Product__c, Quantity__c FROM PurchaseLineItem__c WHERE Purchase__c IN :purchaseIds];
    }
}