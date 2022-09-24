public with sharing class OpportunityHandler {
    public static void handle(
            Map<Id, Opportunity> oldValuesByIds,
            Map<Id, Opportunity> newValuesByIds,
            TriggerOperation operationType) {

        Set<Id> wonOpportunitiesIds =
                OpportunityService.getOpportunityIdsWhereStageChangedToWon(oldValuesByIds, newValuesByIds, operationType);

        List<OpportunityLineItem> opportunityLineItems =
                OpportunityLineItemSelector.selectOpportunityLineItemsByOpportunityIds(wonOpportunitiesIds);

        Set<Id> productsIds = new Set<Id>();

        for (OpportunityLineItem item: opportunityLineItems) {
            productsIds.add(item.Product2Id);
        }

        Map<Id, Product2> productsByIds = new Map<Id, Product2>
                (ProductSelector.selectProductsByIds(productsIds));

        for (OpportunityLineItem item: opportunityLineItems) {
            productsByIds.get(item.Product2Id).ProductStock__c -= item.Quantity;
        }

        try {
            Database.update(productsByIds.values(), true);
        } catch(DmlException dmlException) {

            OpportunityService.handleDmlException(
                    newValuesByIds,
                    wonOpportunitiesIds,
                    dmlException
            );
        }
    }
}