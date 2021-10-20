public class Product2Extension {

    public List<ProductWrapper> productsToInsert {get;set;}

    public Product2Extension(ApexPages.StandardController controller){
        productsToInsert = new List<ProductWrapper>();
        addRows();
    }

    public void addRows(){
        for ( Integer i=0; i<Constants.DEFAULT_ROWS; i++ ){
            productsToInsert.add(new ProductWrapper());
        }
    }

    public List<ChartHelper.ChartData> GetInventory(){
        return ChartHelper.GetInventory();
    }

    public PageReference Save(){
        Savepoint sp1 = Database.setSavepoint();
        try {
            List<Product2> prodsList = new List<Product2>();
            List<PricebookEntry> entriesList = new List<PricebookEntry>();
            List<PricebookEntry> newEntriesList = new List<PricebookEntry>();

            for(ProductWrapper wrap : productsToInsert) {
                /*if(String.isNotBlank(wrap.productRecord.Name) && wrap.pricebookEntryRecord.UnitPrice!=null &&
                        wrap.productRecord.Initial_Inventory__c!=null && wrap.productRecord.IsActive &&
                        wrap.productRecord.Initial_Inventory__c != 0 && wrap.pricebookEntryRecord.UnitPrice!=0) {
                    prodsList.add(wrap.productRecord);
                    entriesList.add(wrap.pricebookEntryRecord);
                }*/
                prodsList.add(wrap.productRecord);
                entriesList.add(wrap.pricebookEntryRecord);
            }

            Database.SaveResult[] productSaveResults = Database.insert(prodsList, false);
            for(Integer i=0; i<productSaveResults.size(); i++) {
                if(productSaveResults[i].isSuccess()) {
                    PricebookEntry entry = entriesList.get(i);
                    entry.Product2Id = productSaveResults[i].getId();
                    entry.IsActive = true;
                    entry.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
                    newEntriesList.add(entry);
                }
            }

            Database.insert(newEntriesList, false);

            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,prodsList.size()+' Inserted'));
            productsToInsert.clear();   //Do not remove
            addRows();  //Do not remove
        }
        catch (Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Constants.ERROR_MESSAGE));
            Database.rollback(sp1);
        }
        return null;
    }

    public List<SelectOption> GetFamilyOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Constants.SELECT_ONE, Constants.SELECT_ONE));

        for(Schema.PicklistEntry picklistValue : Constants.PRODUCT_FAMILY) {
            options.add(new SelectOption(picklistValue.getValue(), picklistValue.getLabel()));
        }
        return options;
    }

    public class ProductWrapper {
        public Product2 productRecord {get;set;}
        public PricebookEntry pricebookEntryRecord {get;set;}

        public ProductWrapper() {
            productRecord = new Product2(Initial_Inventory__c = 0);
            pricebookEntryRecord = new PricebookEntry(UnitPrice = 0.0);
        }
    }
}