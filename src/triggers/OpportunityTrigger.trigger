trigger OpportunityTrigger on Opportunity (before update) {
    OpportunityHandler.handle(Trigger.oldMap, Trigger.newMap, Trigger.operationType);
}