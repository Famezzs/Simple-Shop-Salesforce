trigger PurchaseTrigger on Purchase__c (before insert, before update) {
    PurchaseHandler.handle(Trigger.oldMap, Trigger.newMap, Trigger.operationType);
}