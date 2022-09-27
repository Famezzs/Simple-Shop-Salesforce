public with sharing class AccountSelector {
    @AuraEnabled(Cacheable=true)
    public static Account getAccountByAccountId(Id accountId) {
        return [SELECT Id, Type FROM Account WHERE Id =: accountId];
    }
}