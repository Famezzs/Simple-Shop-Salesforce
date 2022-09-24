public with sharing class OpportunityService {
    public static Set<Id> getOpportunityIdsWhereStageChangedToWon(
            Map<Id, Opportunity> oldValuesByIds,
            Map<Id, Opportunity> newValuesByIds,
            TriggerOperation operationType) {

        Set<Id> wonOpportunitiesIds = new Set<Id>();

        for (Opportunity opportunity: newValuesByIds.values()) {
            if (OpportunityHelper.checkIfStageChangedToWon(oldValuesByIds, opportunity, operationType)) {
                wonOpportunitiesIds.add(opportunity.Id);
            }
        }

        return wonOpportunitiesIds;
    }

    public static void handleDmlException(
            Map<Id, Opportunity> newValuesByIds,
            Set<Id> acceptedOpportunitiesIds,
            DmlException dmlException) {

        Product2 failedProduct =
                ProductSelector.selectProductById(dmlException.getDmlId(0));

        String errorMessage = '\'' + failedProduct.Name + '\'' + ' (' + failedProduct.Id + ')' +
                ' stock is not enough to satisfy the requested quantity of ';

        List<OpportunityLineItem> failedLineItemsByIds =
                OpportunityLineItemSelector.selectOpportunityLineItemsByFailedProduct(failedProduct);

        for (OpportunityLineItem item: failedLineItemsByIds) {
            if (acceptedOpportunitiesIds.contains(item.OpportunityId)) {
                newValuesByIds.get(item.OpportunityId).addError(errorMessage + item.Quantity + ' units');
            }
        }
    }
}