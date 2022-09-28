trigger PurchaseTrigger on Purchase__c (before update) {
    PurchaseHandler.handle(Trigger.oldMap, Trigger.newMap);
}