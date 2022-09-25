public with sharing class OpportunityService {

    private final static String DML_ERROR_MESSAGE = ' stock is not enough to satisfy the requested quantity';

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
                DML_ERROR_MESSAGE;

        List<OpportunityLineItem> failedLineItemsByIds =
                OpportunityLineItemSelector.selectOpportunityLineItemsByFailedProduct(failedProduct);

        Map<Id, Decimal> totalQuantityRequestedByOpportunityId = new Map<Id, Decimal>();

        for (OpportunityLineItem item: failedLineItemsByIds) {
            if (!acceptedOpportunitiesIds.contains(item.OpportunityId)) {
                continue;
            }

            if (!totalQuantityRequestedByOpportunityId.containsKey(item.OpportunityId)) {
                totalQuantityRequestedByOpportunityId.put(item.OpportunityId, 0);
            }

            Boolean singleRequestQuantityLargerThanStock = item.Quantity > failedProduct.ProductStock__c;

            Boolean totalRequestQuantityLargerThanStock =
                    totalQuantityRequestedByOpportunityId.get(item.OpportunityId) + item.Quantity > failedProduct.ProductStock__c;

            if (singleRequestQuantityLargerThanStock ||
                totalRequestQuantityLargerThanStock) {

                newValuesByIds.get(item.OpportunityId).addError(errorMessage);
            } else {
                totalQuantityRequestedByOpportunityId.put(
                        item.OpportunityId,
                        totalQuantityRequestedByOpportunityId.get(item.OpportunityId) + item.Quantity
                );
            }
        }
    }
}