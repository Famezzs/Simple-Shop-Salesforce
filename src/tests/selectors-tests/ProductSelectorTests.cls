@IsTest
private class ProductSelectorTests {
    @TestSetup
    static void setup() {
        final Integer amount = 10;
        final List<Product2> products = new List<Product2>();

        for (Integer currentAmount = 0; currentAmount < amount; ++currentAmount) {
            products.add(new Product2(Name='Product' + currentAmount + 1));
        }

        insert products;
    }

    @IsTest
    static void selectProductsByIds_validIds_listOfProducts() {
        final List<Product2> products = [SELECT Id FROM Product2];
        final Set<Id> productIds = new Set<Id>();
        final Integer expectedAmount = products.size();

        for (Product2 product: products) {
            productIds.add(product.Id);
        }

        Test.startTest();

        final List<Product2> result = ProductSelector.selectProductsByIds(productIds);

        final Integer actualAmount = result.size();

        Test.stopTest();
        
        System.assert(!result.isEmpty(), 'List of all products when there are products must not be empty');
        System.assertEquals(expectedAmount, actualAmount);
    }
}