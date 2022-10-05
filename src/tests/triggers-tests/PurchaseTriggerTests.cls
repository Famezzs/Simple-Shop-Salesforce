@IsTest
private class PurchaseTriggerTests {

    private final static String DRAFT_STATUS = 'Draft';
    private final static String COMPLETED_STATUS = 'Completed';

    @IsTest
    static void purchaseStatusChangedToCompleted_productAmountIncreased() {
        final Decimal expectedAmount = 100;

        final Id vendorId = PurchaseTriggerTestData.generateVendor();

        final Id productId = PurchaseTriggerTestData.generateProduct();

        Purchase__c purchase = new Purchase__c(Name='Test', Status__c=DRAFT_STATUS, Vendor__c=vendorId);

        insert purchase;

        PurchaseLineItem__c item = new PurchaseLineItem__c(Purchase__c=purchase.Id,
                Price__c=100,
                Quantity__c=expectedAmount,
                Product__c=productId);

        insert item;

        Test.startTest();

        purchase.Status__c = COMPLETED_STATUS;

        update purchase;

        final Decimal actualAmount = [SELECT Id, ProductStock__c FROM Product2 WHERE Id =: productId].ProductStock__c;

        Test.stopTest();

        System.assertEquals(expectedAmount, actualAmount);
    }

    @IsTest
    static void purchaseStatusNotChanged_productAmountNotIncreased() {
        final Decimal quantity = 100;
        final Decimal expectedAmount = 0;

        final Id vendorId = PurchaseTriggerTestData.generateVendor();

        final Id productId = PurchaseTriggerTestData.generateProduct();

        Purchase__c purchase = new Purchase__c(Name='Test', Status__c=DRAFT_STATUS, Vendor__c=vendorId);

        insert purchase;

        PurchaseLineItem__c item = new PurchaseLineItem__c(Purchase__c=purchase.Id,
                Price__c=100,
                Quantity__c=quantity,
                Product__c=productId);

        insert item;

        Test.startTest();

        purchase.Name = 'Test-New';

        update purchase;

        final Decimal actualAmount = [SELECT Id, ProductStock__c FROM Product2 WHERE Id =: productId].ProductStock__c;

        Test.stopTest();

        System.assertEquals(expectedAmount, actualAmount);
    }

    @IsTest
    static void purchaseStatusChangedFromCompletedToDraft_productAmountNotIncreased() {
        final Decimal quantity = 100;
        final Decimal expectedAmount = 0;

        final Id vendorId = PurchaseTriggerTestData.generateVendor();

        final Id productId = PurchaseTriggerTestData.generateProduct();

        Purchase__c purchase = new Purchase__c(Name='Test', Status__c=COMPLETED_STATUS, Vendor__c=vendorId);

        insert purchase;

        PurchaseLineItem__c item = new PurchaseLineItem__c(Purchase__c=purchase.Id,
                Price__c=100,
                Quantity__c=quantity,
                Product__c=productId);

        insert item;

        Test.startTest();

        purchase.Status__c = DRAFT_STATUS;

        update purchase;

        final Decimal actualAmount = [SELECT Id, ProductStock__c FROM Product2 WHERE Id =: productId].ProductStock__c;

        Test.stopTest();

        System.assertEquals(expectedAmount, actualAmount);
    }
}