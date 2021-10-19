/**
 * @name TestDataFactory
 * @description Contains methods to construct and/or validate commonly used records
**/
public with sharing class TestDataFactory {

    /**
     * @return CollaborationGroup
     */
    public static CollaborationGroup ConstructCollaborationGroup(){
        //ToDo: Ensure this method returns a single Chatter CollaborationGroup
        //    whose Name starts with 'TEST' followed by the INVENTORY_ANNOUNCEMENTS constant
        //    and configured so anyone can join, see and post updates.
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
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Product2 records
        //  with all the required fields populated
        //  and IsActive = true
        //  an Initial Inventory set to 10
        //  and iterating through the product family picklist values throughout the list.
        List<Product2> newProdList = new List<Product2>();
        for(Integer i = 0; i < cnt; i++) {
            Product2 prod = new Product2();
            prod.Name = 'Test product ' + i;
            prod.IsActive = true;
            prod.Initial_Inventory__c = 10;
            prod.Family = Constants.PRODUCT_FAMILY.get(i).getValue();

            newProdList.add(prod);
        }
        return newProdList;
    }

    /**
     * @name CreatePricebookEntries
     * @description Constructs a list of PricebookEntry records for unit tests
    **/
    public static List<PricebookEntry> ConstructPricebookEntries(List<Product2> prods){
        //ToDo: Ensure this method returns a corresponding list of PricebookEntries records
        //  related to the provided Products
        //  with all the required fields populated
        //  and IsActive = true
        //  and belonging to the standard Pricebook
        List<PricebookEntry> entriesList = new List<PricebookEntry>();

        for(Product2 eachProd: prods) {
            PricebookEntry newEntry = new PricebookEntry();
            newEntry.Product2Id = eachProd.Id;
            newEntry.IsActive = true;
            newEntry.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;

            entriesList.add(newEntry);
        }
        return entriesList;
    }

    /**
     * @name CreateAccounts
     * @description Constructs a list of Account records for unit tests
    **/
    public static List<Account> ConstructAccounts(Integer cnt){
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Account records
        //  with all of the required fields populated.
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
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Contact records
        //  related to the provided Accounts
        //  with all of the required fields populated.

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
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Order records
        //  related to the provided Accounts
        //  with all of the required fields populated.

        List<Order> listOrders = new List<Order>();

        for(Integer i = 0; i < cnt; i++) {
            Order order = new Order();
            order.Name = 'Test Order ' + accts.get(i).Id;
            order.AccountId = accts.get(i).Id;

            listOrders.add(order);
        }

        return listOrders;
    }

    /**
     * @name CreateOrderItems
     * @description Constructs a list of OrderItem records for unit tests
    **/
    public static List<OrderItem> ConstructOrderItems(integer cnt, list<pricebookentry> pbes, list<order> ords){
        //ToDo: Ensure this method returns a list of size cnt of OrderItem records
        //  related to the provided Pricebook Entries
        //  and related to the provided Orders
        //  with all of the required fields populated.
        //  Hint: Use the DEFAULT_ROWS constant for Quantity as it will be used in the next challenge
        List<OrderItem> itemsList = new List<OrderItem>();

        for(Integer i = 0; i < cnt; i++) {
            OrderItem item = new OrderItem();
            item.PricebookEntryId = pbes.get(i).Id;
            item.OrderId = ords.get(i).Id;
            item.Quantity = Constants.DEFAULT_ROWS;

            itemsList.add(item);
        }
        return itemsList;
    }

    /**
     * @name SetupTestData
     * @description Inserts accounts, contacts, Products, PricebookEntries, Orders, and OrderItems.
    **/
    public static void InsertTestData(Integer cnt){
        //ToDo: Ensure this method calls each of the construct methods
        //  and inserts the results for use as test data.
        insert ConstructCollaborationGroup();

        List<Product2> listProds = ConstructProducts(Constants.DEFAULT_ROWS);
        insert listProds;

        List<PricebookEntry> entries = ConstructPricebookEntries(listProds);
        insert entries;

        List<Account> accList = ConstructAccounts(Constants.DEFAULT_ROWS);
        insert accList;

        ConstructContacts(Constants.DEFAULT_ROWS, accList);

        List<Order> orderList = ConstructOrders(Constants.DEFAULT_ROWS, accList);
        insert orderList;

        ConstructOrderItems(Constants.DEFAULT_ROWS, entries, orderList);
    }

}