public with sharing class PurchaseService {

    private final static String NO_VENDOR_ERROR_MESSAGE = 'You must provide a vendor before completing the purchase';

    public static Set<Id> getPurchaseIdsWhereStatusChangedToCompleted(
            Map<Id, Purchase__c> oldValuesByIds,
            Map<Id, Purchase__c> newValuesByIds,
            TriggerOperation operationType) {

        Set<Id> completedPurchasesIds = new Set<Id>();

        if (newValuesByIds == null) {
            return new Set<Id>();
        }

        for (Purchase__c purchase: newValuesByIds.values()) {
            if (PurchaseHelper.checkIfStatusChangedToCompleted(oldValuesByIds, purchase, operationType)) {
                if (purchase.Vendor__c == null) {
                    purchase.addError(NO_VENDOR_ERROR_MESSAGE);
                }
                completedPurchasesIds.add(purchase.Id);
            }
        }

        return completedPurchasesIds;
    }
}