public with sharing class OpportunityHelperTestData {
    @TestVisible
    private static Opportunity getOpportunity(Id opportunityId, String stage) {
        return new Opportunity(Id=opportunityId,
                Name='Test',
                CloseDate=Date.today(),
                StageName=stage);
    }
}