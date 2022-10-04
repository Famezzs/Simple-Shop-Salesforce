@IsTest
private class PurchaseHelperTests {

    private static Id validPurchaseId;
    private final static String DRAFT_STATUS = 'Draft';
    private final static String COMPLETED_STATUS = 'Completed';

    @TestSetup
    static void setup() {
        final Purchase__c oldPurchase = new Purchase__c(Name='Test', Status__c=DRAFT_STATUS);

        insert oldPurchase;

        validPurchaseId = oldPurchase.Id;
    }

    @IsTest
    static void checkIfStatusChangedToCompleted_statusChangedToCompleted_true() {
        final Purchase__c oldPurchase = new Purchase__c(Id=validPurchaseId,Name='Test', Status__c=DRAFT_STATUS);
        final Purchase__c newPurchase = new Purchase__c(Id=validPurchaseId,Name='Test', Status__c=COMPLETED_STATUS);
        final Map<Id, Purchase__c> oldValues = new Map<Id, Purchase__c>();

        oldValues.put(oldPurchase.Id, oldPurchase);

        final Boolean expectedResult = true;

        Test.startTest();

        final Boolean actualResult = PurchaseHelper.checkIfStatusChangedToCompleted(oldValues, newPurchase);

        Test.stopTest();

        System.assertEquals(expectedResult, actualResult);
    }

    @IsTest
    static void checkIfStatusChangedToCompleted_statusRemainedCompleted_false() {
        final Purchase__c oldPurchase = new Purchase__c(Id=validPurchaseId,Name='Test', Status__c=COMPLETED_STATUS);
        final Purchase__c newPurchase = new Purchase__c(Id=validPurchaseId,Name='Test', Status__c=COMPLETED_STATUS);
        final Map<Id, Purchase__c> oldValues = new Map<Id, Purchase__c>();

        oldValues.put(oldPurchase.Id, oldPurchase);

        final Boolean expectedResult = false;

        Test.startTest();

        final Boolean actualResult = PurchaseHelper.checkIfStatusChangedToCompleted(oldValues, newPurchase);

        Test.stopTest();

        System.assertEquals(expectedResult, actualResult);
    }

    @IsTest
    static void checkIfStatusChangedToCompleted_statusChangedToDraft_false() {
        final Purchase__c oldPurchase = new Purchase__c(Id=validPurchaseId,Name='Test', Status__c=COMPLETED_STATUS);
        final Purchase__c newPurchase = new Purchase__c(Id=validPurchaseId,Name='Test', Status__c=DRAFT_STATUS);
        final Map<Id, Purchase__c> oldValues = new Map<Id, Purchase__c>();

        oldValues.put(oldPurchase.Id, oldPurchase);

        final Boolean expectedResult = false;

        Test.startTest();

        final Boolean actualResult = PurchaseHelper.checkIfStatusChangedToCompleted(oldValues, newPurchase);

        Test.stopTest();

        System.assertEquals(expectedResult, actualResult);
    }

    @IsTest
    static void checkIfStatusChangedToCompleted_statusRemainedDraft_false() {
        final Purchase__c oldPurchase = new Purchase__c(Id=validPurchaseId,Name='Test', Status__c=DRAFT_STATUS);
        final Purchase__c newPurchase = new Purchase__c(Id=validPurchaseId,Name='Test', Status__c=DRAFT_STATUS);
        final Map<Id, Purchase__c> oldValues = new Map<Id, Purchase__c>();

        oldValues.put(oldPurchase.Id, oldPurchase);

        final Boolean expectedResult = false;

        Test.startTest();

        final Boolean actualResult = PurchaseHelper.checkIfStatusChangedToCompleted(oldValues, newPurchase);

        Test.stopTest();

        System.assertEquals(expectedResult, actualResult);
    }
}