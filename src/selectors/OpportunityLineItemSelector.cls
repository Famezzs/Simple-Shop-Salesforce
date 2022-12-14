public with sharing class OpportunityLineItemSelector {
    public static List<OpportunityLineItem> selectOpportunityLineItemsByOpportunityIds(Set<Id> opportunityIds) {
        return [SELECT Id, OpportunityId, Product2Id, Quantity FROM OpportunityLineItem WHERE OpportunityId IN :opportunityIds];
    }

    public static List<OpportunityLineItem> selectOpportunityLineItemsByProductId(Id productId) {
        return [SELECT Id, OpportunityId, Product2Id, Quantity FROM OpportunityLineItem WHERE Product2Id = :productId];
    }
}