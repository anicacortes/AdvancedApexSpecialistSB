/**
 * @name TestDataFactory
 * @description Contains methods to construct and/or validate commonly used records
**/
public with sharing class TestDataFactory {

    /**
     * @return CollaborationGroup
     */
    public static CollaborationGroup ConstructCollaborationGroup(){
        CollaborationGroup collGroup = new CollaborationGroup();
        collGroup.Name = 'TEST' + Constants.INVENTORY_ANNOUNCEMENTS;
        collGroup.CollaborationType = 'Public';

        return collGroup;
    }

    /**
     * @name CreateProducts
     * @description Constructs a list of Product2 records for unit tests
    **/
    public static List<Product2> ConstructProducts(Integer cnt){
        List<Product2> newProdList = new List<Product2>();
        for(Integer i = 0; i < cnt; i++) {
            Product2 prod = new Product2();
            prod.Name = 'Test product ' + i;
            prod.IsActive = true;
            prod.Initial_Inventory__c = 10;
            prod.Family = Constants.PRODUCT_FAMILY.get(Math.mod(i, 4)).getValue();

            newProdList.add(prod);
        }
        return newProdList;
    }

    /**
     * @name CreatePricebookEntries
     * @description Constructs a list of PricebookEntry records for unit tests
    **/
    public static List<PricebookEntry> ConstructPricebookEntries(List<Product2> prods){
        List<PricebookEntry> entriesList = new List<PricebookEntry>();

        for(Product2 eachProd: prods) {
            PricebookEntry newEntry = new PricebookEntry();
            newEntry.Product2Id = eachProd.Id;
            newEntry.IsActive = true;
            newEntry.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            newEntry.UnitPrice = 10;

            entriesList.add(newEntry);
        }
        return entriesList;
    }

    /**
     * @name CreateAccounts
     * @description Constructs a list of Account records for unit tests
    **/
    public static List<Account> ConstructAccounts(Integer cnt){
        List<Account> listAccounts = new List<Account>();

        for(Integer i = 0; i < cnt; i++) {
            Account acc = new Account();
            acc.Name = 'Test Account ' + i;

            listAccounts.add(acc);
        }
        return listAccounts;
    }

    /**
     * @name CreateContacts
     * @description Constructs a list of Contacxt records for unit tests
    **/
    public static List<Contact> ConstructContacts(Integer cnt, List<Account> accts){
        List<Contact> listContacts = new List<Contact>();

        for(Integer i = 0; i < cnt; i++) {
            Contact cont = new Contact();
            cont.LastName = 'Test Contact ' + accts.get(i).Id;
            cont.AccountId = accts.get(i).Id;

            listContacts.add(cont);
        }

        return listContacts;
    }

    /**
     * @name CreateOrders
     * @description Constructs a list of Order records for unit tests
    **/
    public static List<Order> ConstructOrders(Integer cnt, List<Account> accts){

        List<Order> listOrders = new List<Order>();

        for(Integer i = 0; i < cnt; i++) {
            Order order = new Order();
            order.Name = 'Test Order ' + accts.get(i).Id;
            order.AccountId = accts.get(i).Id;
            order.Status = 'Draft';
            order.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            order.EffectiveDate = Date.today();

            listOrders.add(order);
        }

        return listOrders;
    }

    /**
     * @name CreateOrderItems
     * @description Constructs a list of OrderItem records for unit tests
    **/
    public static List<OrderItem> ConstructOrderItems(integer cnt, list<pricebookentry> pbes, list<order> ords){
        List<OrderItem> itemsList = new List<OrderItem>();

        for(Integer i = 0; i < cnt; i++) {
            OrderItem item = new OrderItem();
            item.PricebookEntryId = pbes.get(i).Id;
            item.OrderId = ords.get(i).Id;
            item.Quantity = Constants.DEFAULT_ROWS;
            item.UnitPrice = 10;

            itemsList.add(item);
        }
        return itemsList;
    }

    /**
     * @name SetupTestData
     * @description Inserts accounts, contacts, Products, PricebookEntries, Orders, and OrderItems.
    **/
    public static void InsertTestData(Integer cnt){
        CollaborationGroup collgroup = ConstructCollaborationGroup();
        insert collgroup;

        List<Product2> listProds = ConstructProducts(cnt);
        insert listProds;

        List<PricebookEntry> entries = ConstructPricebookEntries(listProds);
        insert entries;

        List<Account> accList = ConstructAccounts(cnt);
        insert accList;

        List<Contact> conts = ConstructContacts(cnt, accList);
        insert conts;

        List<Order> orderList = ConstructOrders(cnt, accList);
        insert orderList;

        List<OrderItem> items = ConstructOrderItems(cnt, entries, orderList);
        insert items;
    }

    public static void VerifyQuantityOrdered(Product2 originalProduct, Product2 updatedProduct, Integer qtyOrdered) {
        System.assertEquals(originalProduct.Quantity_Ordered__c + qtyOrdered, updatedProduct.Quantity_Ordered__c);
    }
}