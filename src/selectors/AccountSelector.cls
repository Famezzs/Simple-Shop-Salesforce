public with sharing class AccountSelector {
    @AuraEnabled(Cacheable=true)
    public static Account getAccountByAccountId(Id accountId) {
        final List<Account> result = [SELECT Id, Type FROM Account WHERE Id =: accountId];

        return result.isEmpty() ? null : result.get(0);
    }
}