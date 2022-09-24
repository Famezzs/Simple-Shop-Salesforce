public with sharing class OpportunityHelper {

    private final static String CLOSED_WON_STAGE = 'Closed Won';

    public static Boolean checkIfStageChangedToWon(
            Map<Id, Opportunity> oldValuesByIds,
            Opportunity valueToCheck,
            TriggerOperation operationType) {

        switch on operationType {
            when BEFORE_INSERT {
                return valueToCheck.StageName == CLOSED_WON_STAGE;
            }
            when BEFORE_UPDATE {
                return valueToCheck.StageName == CLOSED_WON_STAGE &&
                        valueToCheck.StageName != oldValuesByIds.get(valueToCheck.Id).StageName;
            }
        }

        return false;
    }
}