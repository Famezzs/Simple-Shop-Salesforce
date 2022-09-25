public with sharing class PurchaseHelper {

    private final static String COMPLETED_STATUS = 'Completed';

    public static Boolean checkIfStatusChangedToCompleted(
            Map<Id, Purchase__c> oldValuesByIds,
            Purchase__c valueToCheck,
            TriggerOperation operationType) {

        switch on operationType {
            when BEFORE_INSERT {
                return valueToCheck.Status__c == COMPLETED_STATUS;
            }
            when BEFORE_UPDATE {
                return valueToCheck.Status__c == COMPLETED_STATUS &&
                        valueToCheck.Status__c != oldValuesByIds.get(valueToCheck.Id).Status__c;
            }
        }

        return false;
    }
}