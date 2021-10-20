@isTest
private class OrderTests {

    @TestSetup
    public static void SetupTestData() {
        TestDataFactory.InsertTestData(Constants.DEFAULT_ROWS);
    }

    @IsTest
    private static void OrderUpdate_UnitTest() {
        List<Order> listOrders = [SELECT Id, Status FROM Order];
        List<Product2> listProdsBefore = [SELECT Id, Quantity_Ordered__c FROM Product2];
        Product2 originalProd = listProdsBefore.get(0);

        for(Order eachOrder : listOrders) {
            eachOrder.Status = Constants.ACTIVATED_ORDER_STATUS;
        }

        update listOrders;

        Product2 updatedProd = [SELECT Id, Quantity_Ordered__c FROM Product2 WHERE Id =: originalProd.Id];

        TestDataFactory.VerifyQuantityOrdered(originalProd, updatedProd, 5);
    }

    @IsTest
    private static void OrderExtension_UnitTest() {
        PageReference reference = Page.OrderEdit;
        Test.setCurrentPage(reference);
        Order CurOrder = [Select Id,Status from Order limit 1];
        ApexPages.StandardController controller = new Apexpages.StandardController(CurOrder);
        OrderExtension extension = new OrderExtension(controller);
        System.assertEquals(5, extension.orderItemList.size());
        extension.selectedFamily = 'Dessert';
        extension.SelectFamily();
        extension.OnFieldChange();
        extension.First();
        extension.Next();
        extension.Previous();
        extension.Last();
        extension.GetHasNext();
        extension.GetPageNumber();
        extension.GetHasPrevious();
        extension.GetTotalPages();
        extension.GetFamilyOptions();
        extension.Save();
        ChartHelper.GetInventory();
    }

}