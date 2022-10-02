@IsTest
private class OpportunityLineItemSelectorTests {
    @IsTest
    static void selectOpportunityLineItemsByOpportunityIds_validIds_relatedItems() {
        final Integer amountOfItemsPerOpportunity = 5;
        final Integer amountOfOpportunities = 10;
        final Integer expectedAmountOfItems = amountOfOpportunities * amountOfItemsPerOpportunity;

        Test.startTest();

        final Set<Id> opportunityIds =
                OpportunityLineItemSelectorTestData.createOpportunitiesAndLineItems(amountOfOpportunities, amountOfItemsPerOpportunity);

        final Integer actualAmountOfItems = OpportunityLineItemSelector.selectOpportunityLineItemsByOpportunityIds(opportunityIds).size();

        Test.stopTest();

        System.assertEquals(expectedAmountOfItems, actualAmountOfItems);
    }

    @IsTest
    static void selectOpportunityLineItemsByOpportunityIds_invalidIds_emptyList() {
        final Boolean expectedIsEmpty = true;

        Test.startTest();

        final Boolean actualIsEmpty = OpportunityLineItemSelector.selectOpportunityLineItemsByOpportunityIds(new Set<Id>()).isEmpty();

        Test.stopTest();

        System.assertEquals(expectedIsEmpty, actualIsEmpty);
    }

    @IsTest
    static void selectOpportunityLineItemsByProductId_validId_relatedItems() {
        final Integer expectedAmount = 50;

        final Id productId = OpportunityLineItemSelectorTestData.createLineItemsWithProduct(expectedAmount);

        Test.startTest();

        final List<OpportunityLineItem> result = OpportunityLineItemSelector.selectOpportunityLineItemsByProductId(productId);

        final Integer actualAmount = result.size();

        Test.stopTest();

        System.assertEquals(expectedAmount, actualAmount);
    }

    @IsTest
    static void selectOpportunityLineItemsByProductId_invalidId_emptyList() {
        final Boolean expectedIsEmpty = true;

        Test.startTest();

        final Boolean actualIsEmpty = OpportunityLineItemSelector.selectOpportunityLineItemsByProductId(null).isEmpty();

        Test.stopTest();

        System.assertEquals(expectedIsEmpty, actualIsEmpty);
    }
}