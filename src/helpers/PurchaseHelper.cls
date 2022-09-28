public with sharing class PurchaseHelper {

    private final static String COMPLETED_STATUS = 'Completed';

    public static Boolean checkIfStatusChangedToCompleted(
            Map<Id, Purchase__c> oldValuesByIds,
            Purchase__c valueToCheck) {

        return valueToCheck.Status__c == COMPLETED_STATUS &&
                valueToCheck.Status__c != oldValuesByIds.get(valueToCheck.Id).Status__c;
    }
}