public with sharing class ProductSelector {
    public static List<Product2> selectProductsByIds(Set<Id> productIds) {
        return [SELECT Id, Name, ProductStock__c FROM Product2 WHERE Id IN :productIds];
    }

    public static Product2 selectProductById(Id productId) {
        return [SELECT Id, Name, ProductStock__c FROM Product2 WHERE Id =: productId];
    }

    @AuraEnabled(Cacheable=true)
    public static String getProductNameById(Id productId) {
        return [SELECT Id, Name FROM Product2 WHERE Id =: productId]?.Name;
    }
}