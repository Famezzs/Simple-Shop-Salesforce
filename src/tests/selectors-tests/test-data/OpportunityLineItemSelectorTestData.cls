public class OpportunityLineItemSelectorTestData {
    @TestVisible
    private static Set<Id> createOpportunitiesAndLineItems(Integer amountOfOpportunities, Integer amountOfItems) {
        final List<Opportunity> opportunities = new List<Opportunity>();
        final List<OpportunityLineItem> items = new List<OpportunityLineItem>();
        final Set<Id> opportunityIds = new Set<Id>();

        for (Integer amount = 0; amount < amountOfOpportunities; ++amount) {
            opportunities.add(generateOpportunity());
        }

        insert opportunities;

        final Id priceBookEntryId = generatePriceBookEntryId();

        for (Opportunity opportunity: opportunities) {
            for (Integer amount = 0; amount < amountOfItems; ++amount) {
                items.add(generateLineItem(opportunity.Id, priceBookEntryId));
            }

            opportunityIds.add(opportunity.Id);
        }

        insert items;

        return opportunityIds;
    }

    @TestVisible
    private static Id createLineItemsWithProduct(Integer amount) {
        final List<OpportunityLineItem> items = new List<OpportunityLineItem>();

        final Id productId = generateProductId();

        final Opportunity opportunity = generateOpportunity();

        insert opportunity;

        final Id priceBookEntryId = generatePriceBookEntryId(productId);

        for (Integer currentAmount = 0; currentAmount < amount; ++currentAmount) {
            items.add(generateLineItem(opportunity.Id, priceBookEntryId, productId));
        }

        insert items;

        return productId;
    }

    @TestVisible
    private static Id createLineItemsWithProduct(Id opportunityId, Integer amount, Decimal stock, Decimal quantity) {
        final List<OpportunityLineItem> items = new List<OpportunityLineItem>();

        final Id productId = generateProductId(stock);

        final Id priceBookEntryId = generatePriceBookEntryId(productId);

        for (Integer currentAmount = 0; currentAmount < amount; ++currentAmount) {
            items.add(generateLineItem(opportunityId, priceBookEntryId, productId, quantity));
        }

        insert items;

        return productId;
    }

    private static Id generatePriceBookEntryId() {
        final PricebookEntry entry = new PricebookEntry(UnitPrice=10,
                Product2Id=generateProductId(),
                Pricebook2Id=Test.getStandardPricebookId(),
                IsActive=true);

        insert entry;

        return entry.Id;
    }

    private static Id generatePriceBookEntryId(Id productId) {
        final PricebookEntry entry = new PricebookEntry(UnitPrice=10,
                Product2Id=productId,
                Pricebook2Id=Test.getStandardPricebookId(),
                IsActive=true);

        insert entry;

        return entry.Id;
    }

    private static Id generateProductId() {
        final Product2 product2 = new Product2(Name='Test');

        insert product2;

        return product2.Id;
    }

    private static Id generateProductId(Decimal stock) {
        final Product2 product2 = new Product2(Name='Test', ProductStock__c=stock);

        insert product2;

        return product2.Id;
    }

    private static Opportunity generateOpportunity() {
        return new Opportunity(Name='Test', StageName='Prospecting', CloseDate=Date.today());
    }

    private static OpportunityLineItem generateLineItem(Id opportunityId, Id priceBookEntryId) {
        return new OpportunityLineItem(Quantity = 100,
                TotalPrice=100,
                OpportunityId=opportunityId,
                PricebookEntryId=priceBookEntryId);
    }

    private static OpportunityLineItem generateLineItem(Id opportunityId, Id priceBookEntryId, Id productId) {
        return new OpportunityLineItem(Quantity = 100,
                TotalPrice=100,
                OpportunityId=opportunityId,
                PricebookEntryId=priceBookEntryId,
                Product2Id=productId);
    }

    private static OpportunityLineItem generateLineItem(Id opportunityId, Id priceBookEntryId, Id productId, Decimal quantity) {
        return new OpportunityLineItem(Quantity = quantity,
                TotalPrice=100,
                OpportunityId=opportunityId,
                PricebookEntryId=priceBookEntryId,
                Product2Id=productId);
    }
}