public with sharing class ProductSelector {
    public static List<Product2> selectProductsByIds(Set<Id> productIds) {
        return [SELECT Id, Name, ProductStock__c FROM Product2 WHERE Id IN :productIds];
    }

    public static Product2 selectProductById(Id productId) {
        final List<Product2> result = [SELECT Id, Name, ProductStock__c FROM Product2 WHERE Id =: productId];
        return result.isEmpty() ? null : result.get(0);
    }

    @AuraEnabled(Cacheable=true)
    public static String getProductNameById(Id productId) {
        final List<Product2> result = [SELECT Id, Name FROM Product2 WHERE Id =: productId];
        return result.isEmpty() ? null : result.get(0).Name;
    }
}