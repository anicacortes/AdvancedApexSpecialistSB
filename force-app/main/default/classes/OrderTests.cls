@isTest
public class OrderTests {

    @TestSetup
    public static void SetupTestData() {
        TestDataFactory.InsertTestData(Constants.DEFAULT_ROWS);
    }

    @isTest
    public static void OrderUpdate_UnitTest() {
        List<Order> listOrders = [SELECT Id, Status FROM Order];
        List<Product2> listProdsBefore = [SELECT Id, Quantity_Ordered__c FROM Product2];
        Product2 originalProd = listProdsBefore.get(0);

        for(Order eachOrder : listOrders) {
            eachOrder.Status = Constants.ACTIVATED_ORDER_STATUS;
        }

        update listOrders;

        Product2 updatedProd = [SELECT Id, Quantity_Ordered__c FROM Product2 WHERE Id =: originalProd.Id];

        TestDataFactory.VerifyQuantityOrdered(originalProd, updatedProd, 10);
    }

}