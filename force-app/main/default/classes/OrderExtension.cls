/**
 * @name OrderExtension
 * @description This class is provided for you to facilitate the Super Badge
**/
public class OrderExtension {

    public Order orderRecord {get;set;}
    public List<OrderItem> orderItemList {get;set;}
    public String selectedFamily {get;set;}
    public List<chartHelper.chartData> pieData {get;set;}
    public Decimal total {get;set;}

    public Map<Id,OrderItem> orderItemMap;
    ApexPages.StandardSetController standardSetController;

    public OrderExtension(ApexPages.StandardController standardController){
        orderRecord = (Order)standardController.getRecord();
        orderItemMap = new Map<id,OrderItem>();
        if ( orderRecord.Id != null ){
            orderRecord = queryOrderRecord(orderRecord.Id);
        }
    }

    //ToDo: Implement your own method to populate orderItemList
    //  that you will call after pagination and/or family selection

    public void populateItemsList() {
        orderItemList = new List<OrderItem>();

        if(standardSetController.getRecords().size() > 0) {
            for (SObject record : standardSetController.getRecords()) {
                PricebookEntry pbEntry = (PricebookEntry) record;
                if (orderItemMap.containsKey(pbEntry.Product2Id)) {
                    orderItemList.add(orderItemMap.get(pbEntry.Product2Id));
                }
                else {
                    OrderItem newItem = new OrderItem();
                    newItem.PricebookEntryId = pbEntry.Id;
                    newItem.Product2Id = pbEntry.Product2Id;
                    newItem.UnitPrice = pbEntry.UnitPrice;
                    newItem.Product2 = pbEntry.Product2;
                    newItem.Quantity = 0;
                    orderItemList.add(newItem);
                    orderItemMap.put(pbEntry.Product2Id, newItem);
                }
            }
        }
    }

    /**
     * @name OnFieldChange
     * @description
    **/
    public void OnFieldChange(){
        for(OrderItem item : orderItemList) {
            orderItemMap.put(item.Product2Id, item);
        }

        //load
        //ToDo: Implement logic to store the values changed on the page
        //      and populate pieData
        //      and populate total

    }

    /**
     * @name SelectFamily
     * @description
    **/
    public void SelectFamily(){

        //ToDo: Implement logic to filter based on the selected product family
        populateItemsList();
    }

    /**
     * @name Save
     * @description
    **/
    public void Save() {
        /*Savepoint sp = Database.setSavepoint();

        List<OrderItem> itemsToStore = new List<OrderItem>();
        List<OrderItem> itemsToDelete = new List<OrderItem>();
        try {

            for(OrderItem item : orderItemList) {
                if(item.Quantity > 0) {
                    if(item.OrderId == null) {
                        item.OrderId = orderRecord.Id;
                    }
                    itemsToStore.add(item);
                }
                else if(item.Id != null) {
                    itemsToDelete.add(new OrderItem(Id = item.Id));
                    item.Id = null;
                }
            }

            upsert itemsToStore;
            delete itemsToDelete;

            //standardSetController.save();
        }
        catch (Exception ex) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                    'Recods could not be saved: ' + ex.getMessage());
            ApexPages.addMessage(myMsg);
            Database.rollback(sp);
        }*/

        System.Savepoint sp = Database.setSavepoint();

        try {
            if(orderRecord.Pricebook2Id == null) {
                orderRecord.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            }
            upsert orderRecord;

            List<OrderItem> orderItemsToUpsert = new List<OrderItem>();
            List<OrderItem> orderItemsToDelete = new List<OrderItem>();

            for (OrderItem oi : orderItemMap.values()) {
                if(oi.Quantity > 0) {
                    if(oi.OrderId == null) {
                        oi.OrderId = orderRecord.Id;
                    }
                    orderItemsToUpsert.add(oi);
                } else if(oi.Id != null) {
                    orderItemsToDelete.add(new OrderItem(id=oi.Id));
                    oi.Id = null;
                }
            }

            upsert orderItemsToUpsert;
            delete orderItemsToDelete;

        } catch (Exception e){
            Database.rollback(sp);
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,Constants.ERROR_MESSAGE));
        }
    }




    /**
     * @name First
     * @description
    **/
    public void First(){
        standardSetController.first();
        populateItemsList();
    }


    /**
     * @name Next
     * @description
    **/
    public void Next(){
        standardSetController.next();
        populateItemsList();
    }


    /**
     * @name Previous
     * @description
    **/
    public void Previous(){
        standardSetController.previous();
        populateItemsList();
    }

    /**
     * @name Last
     * @description
    **/
    public void Last(){
        standardSetController.last();
        populateItemsList();
    }

    /**
     * @name GetHasPrevious
     * @description
    **/
    public Boolean GetHasPrevious(){
        return standardSetController.getHasPrevious();
    }

    /**
     * @name GetHasNext
     * @description
    **/
    public Boolean GetHasNext(){
        return standardSetController.getHasNext();
    }

    /**
     * @name GetTotalPages
     * @description
    **/
    public Integer GetTotalPages() {
        return (Integer)Math.ceil(standardSetController.getResultSize()/(Decimal)Constants.DEFAULT_ROWS);

        //return standardSetController.getPageSize();
    }

    /**
     * @name GetPageNumber
     * @description
    **/
    public Integer GetPageNumber(){
        return standardSetController.getPageNumber();
    }

    /**
     * @name GetFamilyOptions
     * @description
    **/
    public List<SelectOption> GetFamilyOptions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Constants.SELECT_ONE, Constants.SELECT_ONE));

        for(Schema.PicklistEntry picklistValue : Constants.PRODUCT_FAMILY) {
            options.add(new SelectOption(picklistValue.getValue(), picklistValue.getLabel()));
        }
        return options;
    }

    /**
     * @name QueryOrderRecord
     * @description
    **/
    public static Order QueryOrderRecord(Id orderId){
        return [
                SELECT Id, AccountId, EffectiveDate, Name, Status, Pricebook2Id,
                (
                        SELECT Id, OrderId, Quantity, UnitPrice, PricebookEntryId, Product2Id,
                                Product2.Name, Product2.Family, Product2.Quantity_Remaining__c
                        FROM OrderItems
                )
                FROM Order
                WHERE Id = :orderId
        ];
    }

}