@IsTest
private class AccountSelectorTests {
    @IsTest
    static void getAccountByAccountId_validId_validAccount() {
        final Account newAccount = new Account(Name='Test');

        insert newAccount;

        final Id expected = newAccount.Id;

        Test.startTest();

        final Id actual = AccountSelector.getAccountByAccountId(expected).Id;

        Test.stopTest();

        System.assert(actual != null, 'Id returned by AccountSelector cannot be null if Id passed is valid');
        System.assertEquals(expected, actual);
    }

    @IsTest
    static void getAccountByAccountId_invalidId_null() {
        final Id expected = null;

        Test.startTest();

        final Id actual = AccountSelector.getAccountByAccountId(expected)?.Id;

        Test.stopTest();

        System.assert(expected == null, 'Id returned by AccountSelector must be null if Id passed is invalid');
        System.assertEquals(expected, actual);
    }
}