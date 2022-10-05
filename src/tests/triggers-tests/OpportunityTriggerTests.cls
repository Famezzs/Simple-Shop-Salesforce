@IsTest
private class OpportunityTriggerTests {

    private final static String PROSPECTING_STAGE = 'Prospecting';
    private final static String CLOSED_WON_STAGE = 'Closed Won';

    @IsTest
    static void opportunityStatusChangedToClosedWon_enoughStock_productStockDecreased() {
        final Integer amountOfItems = 3;
        final Integer quantityPerItem = 10;
        final Integer totalStock = amountOfItems * quantityPerItem;
        final Decimal expectedStock = totalStock - amountOfItems * quantityPerItem;

        final Opportunity opportunity = new Opportunity(Name='Test', CloseDate=Date.today(), StageName=PROSPECTING_STAGE);

        insert opportunity;

        final Id productId =
                OpportunityLineItemSelectorTestData.createLineItemsWithProduct(opportunity.Id, amountOfItems, totalStock, quantityPerItem);

        Test.startTest();

        opportunity.StageName = CLOSED_WON_STAGE;

        update opportunity;

        final Decimal actualStock = [SELECT Id, ProductStock__c FROM Product2 WHERE Id =: productId].ProductStock__c;

        Test.stopTest();

        System.assertEquals(expectedStock, actualStock);
    }

    @IsTest
    static void opportunityStatusChangedToClosedWon_notEnoughStock_dmlException() {
        final Integer amountOfItems = 3;
        final Integer quantityPerItem = 10;
        final Integer totalStock = amountOfItems * quantityPerItem - 1;
        DmlException result = null;

        final Opportunity opportunity = new Opportunity(Name='Test', CloseDate=Date.today(), StageName=PROSPECTING_STAGE);

        insert opportunity;

        final Id productId =
                OpportunityLineItemSelectorTestData.createLineItemsWithProduct(opportunity.Id, amountOfItems, totalStock, quantityPerItem);

        Test.startTest();

        opportunity.StageName = CLOSED_WON_STAGE;

        try {
            update opportunity;
        } catch (DmlException ex) {
            result = ex;
        }

        Test.stopTest();

        System.assert(result != null, 'If product does not have enough stock to satisfy opportunity, a dml exception must be thrown');
    }

    @IsTest
    static void opportunityStatusNotChangedToClosedWon_anyStock_productStockNotChanged() {
        final Integer amountOfItems = 3;
        final Integer quantityPerItem = 10;
        final Integer totalStock = amountOfItems * quantityPerItem;
        final Decimal expectedStock = totalStock;

        final Opportunity opportunity = new Opportunity(Name='Test', CloseDate=Date.today(), StageName=PROSPECTING_STAGE);

        insert opportunity;

        final Id productId =
                OpportunityLineItemSelectorTestData.createLineItemsWithProduct(opportunity.Id, amountOfItems, totalStock, quantityPerItem);

        Test.startTest();

        opportunity.Name = 'Test-new';

        update opportunity;

        final Decimal actualStock = [SELECT Id, ProductStock__c FROM Product2 WHERE Id =: productId].ProductStock__c;

        Test.stopTest();

        System.assertEquals(expectedStock, actualStock);
    }

    @IsTest
    static void opportunityStatusChangedFromClosedWonToProspecting_anyStock_productStockNotChanged() {
        final Integer amountOfItems = 3;
        final Integer quantityPerItem = 10;
        final Integer totalStock = amountOfItems * quantityPerItem;
        final Decimal expectedStock = totalStock;

        final Opportunity opportunity = new Opportunity(Name='Test', CloseDate=Date.today(), StageName=CLOSED_WON_STAGE);

        insert opportunity;

        final Id productId =
                OpportunityLineItemSelectorTestData.createLineItemsWithProduct(opportunity.Id, amountOfItems, totalStock, quantityPerItem);

        Test.startTest();

        opportunity.StageName = PROSPECTING_STAGE;

        update opportunity;

        final Decimal actualStock = [SELECT Id, ProductStock__c FROM Product2 WHERE Id =: productId].ProductStock__c;

        Test.stopTest();

        System.assertEquals(expectedStock, actualStock);
    }
}