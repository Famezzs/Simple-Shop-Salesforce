@IsTest
private class PurchaseLineItemSelectorTests {
    @IsTest
    static void selectPurchaseLineItemsByPurchaseIds_validIds_relatedItems() {
        final Integer amountOfItemsPerPurchase = 5;
        final Integer amountOfPurchases = 10;
        final Integer expectedAmountOfItems = amountOfPurchases * amountOfItemsPerPurchase;

        Test.startTest();

        final Set<Id> purchaseIds =
                PurchaseLineItemSelectorTestData.createPurchasesAndLineItems(amountOfPurchases, amountOfItemsPerPurchase);

        System.debug(purchaseIds.size());

        final Integer actualAmountOfItems = PurchaseLineItemSelector.selectPurchaseLineItemsByPurchaseIds(purchaseIds).size();

        Test.stopTest();

        System.assertEquals(expectedAmountOfItems, actualAmountOfItems);
    }

    @IsTest
    static void selectPurchaseLineItemsByPurchaseIds_invalidIds_emptyList() {
        final Boolean expectedIsEmpty = true;

        Test.startTest();

        final Boolean actualIsEmpty = PurchaseLineItemSelector.selectPurchaseLineItemsByPurchaseIds(new Set<Id>()).isEmpty();

        Test.stopTest();

        System.assertEquals(expectedIsEmpty, actualIsEmpty);
    }
}