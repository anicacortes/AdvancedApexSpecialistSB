public without sharing class OrderHelper {

    /**
     * @name AfterUpdate
     * @description 
     * @param List<Order> newList
     * @param List<Order> oldList
     * @return void
    **/
    public static void AfterUpdate(List<Order> newList, List<Order> oldList){
        Set<Id> orderIds = new Set<Id>();
        for (Integer i=0; i<newList.size(); i++ ){
            if (newList[i].Status == Constants.ACTIVATED_ORDER_STATUS && oldList[i].Status != Constants.ACTIVATED_ORDER_STATUS){
                orderIds.add(newList[i].Id);
            }
        }

        RollUpOrderItems(orderIds);
    }

    /**
     * @name RollUpOrderItems
     * @description Given a set of Activated Order ids, query the child Order Items and related Products to calculate Inventory levels
     * @param Set<Id> activatedOrderIds
     * @return void
    **/
    public static void RollUpOrderItems(Set<Id> activatedOrderIds){
        //ToDo: Declare a Map named "productMap" of Ids to Product2 records

        //ToDo: Loop through a query of OrderItems related to the activatedOrderIds

        //ToDo: Populate the map with the Id of the related Product2 as the key and Product2 record as the value

        //ToDo: Loop through a query that aggregates the OrderItems related to the Products in the ProductMap keyset

        //ToDo: Perform an update on the records in the productMap
        Map<Id, Product2> productMap = new Map<Id, Product2>();

        List<OrderItem> orderProducts = [SELECT Id, Product2Id, Product2.Quantity_Ordered__c, Quantity
        FROM OrderItem WHERE OrderId IN :activatedOrderIds];

        for(OrderItem eachProduct : orderProducts) {
            productMap.put(eachProduct.Product2Id, eachProduct.Product2);
        }

        AggregateResult[] groupedResult = [Select Product2Id, sum(Quantity) totalQuantity from OrderItem where product2Id in :productMap.keySet() group by product2Id];

        for(AggregateResult result : groupedResult) {
            productMap.get((String)result.get('Product2Id')).Quantity_Ordered__c = Integer.valueOf(result.get('totalQuantity'));
        }

        update productMap.values();
    }

}