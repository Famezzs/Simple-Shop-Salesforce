@IsTest
private class OpportunityHelperTests {

    private static Id validOpportunityId;
    private final static String CLOSED_WON_STAGE = 'Closed Won';
    private final static String PROSPECTING_STAGE = 'Prospecting';

    @TestSetup
    static void setup() {
        final Opportunity opportunity = new Opportunity(Name='Test', CloseDate=Date.today(), StageName=PROSPECTING_STAGE);

        insert opportunity;

        validOpportunityId = opportunity.Id;
    }

    @IsTest
    static void checkIfStageChangedToWon_stageIsClosedWonBeforeInsert_true() {
        final Boolean expectedResult = true;
        final TriggerOperation triggerOperation = TriggerOperation.BEFORE_INSERT;
        final Opportunity newOpportunity = OpportunityHelperTestData.getOpportunity(validOpportunityId, CLOSED_WON_STAGE);

        Test.startTest();

        final Boolean actualResult =
                OpportunityHelper.checkIfStageChangedToWon(null, newOpportunity, triggerOperation);

        Test.stopTest();

        System.assertEquals(expectedResult, actualResult);
    }

    @IsTest
    static void checkIfStageChangedToWon_stageIsNotClosedWonBeforeInsert_false() {
        final Boolean expectedResult = false;
        final TriggerOperation triggerOperation = TriggerOperation.BEFORE_INSERT;
        final Opportunity newOpportunity = OpportunityHelperTestData.getOpportunity(validOpportunityId, PROSPECTING_STAGE);

        Test.startTest();

        final Boolean actualResult =
                OpportunityHelper.checkIfStageChangedToWon(null, newOpportunity, triggerOperation);

        Test.stopTest();

        System.assertEquals(expectedResult, actualResult);
    }

    @IsTest
    static void checkIfStageChangedToWon_stageChangedToClosedWonBeforeUpdate_true() {
        final Boolean expectedResult = true;
        final TriggerOperation triggerOperation = TriggerOperation.BEFORE_UPDATE;
        final Opportunity oldOpportunity = OpportunityHelperTestData.getOpportunity(validOpportunityId, PROSPECTING_STAGE);
        final Opportunity newOpportunity = OpportunityHelperTestData.getOpportunity(validOpportunityId, CLOSED_WON_STAGE);
        final Map<Id, Opportunity> oldValues = new Map<Id, Opportunity>();

        oldValues.put(oldOpportunity.Id, oldOpportunity);

        Test.startTest();

        final Boolean actualResult =
                OpportunityHelper.checkIfStageChangedToWon(oldValues, newOpportunity, triggerOperation);

        Test.stopTest();

        System.assertEquals(expectedResult, actualResult);
    }

    @IsTest
    static void checkIfStageChangedToWon_stageChangedNotToClosedWonBeforeUpdate_false() {
        final Boolean expectedResult = false;
        final TriggerOperation triggerOperation = TriggerOperation.BEFORE_UPDATE;
        final Opportunity oldOpportunity = OpportunityHelperTestData.getOpportunity(validOpportunityId, CLOSED_WON_STAGE);
        final Opportunity newOpportunity = OpportunityHelperTestData.getOpportunity(validOpportunityId, PROSPECTING_STAGE);
        final Map<Id, Opportunity> oldValues = new Map<Id, Opportunity>();

        oldValues.put(oldOpportunity.Id, oldOpportunity);

        Test.startTest();

        final Boolean actualResult =
                OpportunityHelper.checkIfStageChangedToWon(oldValues, newOpportunity, triggerOperation);

        Test.stopTest();

        System.assertEquals(expectedResult, actualResult);
    }

    @IsTest
    static void checkIfStageChangedToWon_stageIsClosedWonBeforeUpdate_false() {
        final Boolean expectedResult = false;
        final TriggerOperation triggerOperation = TriggerOperation.BEFORE_UPDATE;
        final Opportunity oldOpportunity = OpportunityHelperTestData.getOpportunity(validOpportunityId, CLOSED_WON_STAGE);
        final Opportunity newOpportunity = OpportunityHelperTestData.getOpportunity(validOpportunityId, CLOSED_WON_STAGE);
        final Map<Id, Opportunity> oldValues = new Map<Id, Opportunity>();

        oldValues.put(oldOpportunity.Id, oldOpportunity);

        Test.startTest();

        final Boolean actualResult =
                OpportunityHelper.checkIfStageChangedToWon(oldValues, newOpportunity, triggerOperation);

        Test.stopTest();

        System.assertEquals(expectedResult, actualResult);
    }

    @IsTest
    static void checkIfStageChangedToWon_stageIsNotClosedWonBeforeUpdate_false() {
        final Boolean expectedResult = false;
        final TriggerOperation triggerOperation = TriggerOperation.BEFORE_UPDATE;
        final Opportunity oldOpportunity = OpportunityHelperTestData.getOpportunity(validOpportunityId, PROSPECTING_STAGE);
        final Opportunity newOpportunity = OpportunityHelperTestData.getOpportunity(validOpportunityId, PROSPECTING_STAGE);
        final Map<Id, Opportunity> oldValues = new Map<Id, Opportunity>();

        oldValues.put(oldOpportunity.Id, oldOpportunity);

        Test.startTest();

        final Boolean actualResult =
                OpportunityHelper.checkIfStageChangedToWon(oldValues, newOpportunity, triggerOperation);

        Test.stopTest();

        System.assertEquals(expectedResult, actualResult);
    }
}