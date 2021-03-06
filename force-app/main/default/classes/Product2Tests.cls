@isTest
private class Product2Tests {

    /**
     * @name product2Extension_UnitTest
     * @description UnitTest for product2Extension
    **/
    @IsTest
    private static void Product2Extension_UnitTest(){

        List<Product2> listProds = TestDataFactory.ConstructProducts(1);

        PageReference testPage = Page.Product2New;
        Test.setCurrentPage(testPage);
        ApexPages.StandardController sc = new ApexPages.StandardController(listProds.get(0));

        Test.startTest();
        Product2Extension ext = new Product2Extension(sc);

        System.assertEquals(ext.productsToInsert.size(), Constants.DEFAULT_ROWS);

        ext.addRows();
        System.assertEquals(ext.productsToInsert.size(), Constants.DEFAULT_ROWS * 2);

        for(Integer i = 0; i < 5; i++) {
            ext.productsToInsert.get(i).productRecord = new Product2(Initial_Inventory__c = 10, Name = 'Prod ' + i,
                    IsActive = true, Family = Constants.PRODUCT_FAMILY.get(Math.mod(i, 4)).getValue());
            ext.productsToInsert.get(i).pricebookEntryRecord = new PricebookEntry(UnitPrice = 15);
        }
        ext.Save();
        List<Product2> prodsAfter = [SELECT Id FROM Product2];
        System.assertEquals(prodsAfter.size(), 5);

        Test.stopTest();
    }

    @IsTest
    private static void Product2Trigger_UnitTest() {
        Test.startTest();
        Product2 newProduct = new Product2();
        newProduct.Name = 'Test';
        newProduct.Family = 'Beverage';
        newProduct.IsActive = true;
        newProduct.Quantity_Ordered__c = 10;
        newProduct.Initial_Inventory__c = 15;
        insert newProduct;

        CollaborationGroup c = new CollaborationGroup();
        c.Name = 'TEST' + Constants.INVENTORY_ANNOUNCEMENTS;
        c.Description = 'Blabla';
        c.CollaborationType = 'Public';
        insert c;

        newProduct.Quantity_Ordered__c = 96;
        update newProduct;
        Test.stopTest();
    }

}