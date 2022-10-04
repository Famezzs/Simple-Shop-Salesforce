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

    @IsTest
    static void selectProductsByIds_invalidIds_emptyListOfProducts() {
        final Boolean expectedIsEmpty = true;

        Test.startTest();

        final Boolean actualIsEmpty = ProductSelector.selectProductsByIds(new Set<Id>()).isEmpty();

        Test.stopTest();

        System.assertEquals(expectedIsEmpty, actualIsEmpty);
    }

    @IsTest
    static void selectProductById_validId_validProduct() {
        final Product2 expectedProduct = [SELECT Id, Name, ProductStock__c FROM Product2].get(0);

        Test.startTest();

        final Product2 actualProduct = ProductSelector.selectProductById(expectedProduct.Id);

        Test.stopTest();

        System.assert(actualProduct != null, 'Existing product with specified Id must be returned by ProductSelector as part of request');
        System.assertEquals(expectedProduct, actualProduct);
    }

    @IsTest
    static void selectProductById_invalidId_null() {
        Test.startTest();

        final Product2 result = ProductSelector.selectProductById(null);

        Test.stopTest();

        System.assert(result == null, 'ProductSelector must return null if product specified by id does not exist');
    }
}