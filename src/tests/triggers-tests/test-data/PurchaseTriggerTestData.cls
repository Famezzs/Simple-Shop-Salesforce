public with sharing class PurchaseTriggerTestData {

    private final static String VENDOR_TYPE = 'Vendor';

    @TestVisible
    private static Id generateVendor() {
        Account vendor = new Account(Name='Test', Type=VENDOR_TYPE);

        insert vendor;

        return vendor.Id;
    }

    @TestVisible
    private static Id generateProduct() {
        Product2 product = new Product2(Name='Test', ProductStock__c=0, IsActive=true);

        insert product;

        return product.Id;
    }
}