public with sharing class Constants {

    public static final Integer DEFAULT_ROWS = 5; //An Integer used to control the number of rows displayed by a Visualforce page
    public static final String SELECT_ONE = System.Label.Select_One; //An Integer used to control the number of rows displayed by a Visualforce page
    public static final String INVENTORY_LEVEL_LOW = System.Label.Inventory_Level_Low; //An Integer used to control the number of rows displayed by a Visualforce page
    public static final List<Schema.PicklistEntry> PRODUCT_FAMILY = Product2.Family.getDescribe().getPickListValues(); //An Integer used to control the number of rows displayed by a Visualforce page
    public static final String DRAFT_ORDER_STATUS = 'Draft'; //An Integer used to control the number of rows displayed by a Visualforce page
    public static final String ACTIVATED_ORDER_STATUS = 'Activated'; //An Integer used to control the number of rows displayed by a Visualforce page
    public static final String INVENTORY_ANNOUNCEMENTS = 'Inventory Announcements'; //An Integer used to control the number of rows displayed by a Visualforce page
    public static final String ERROR_MESSAGE = 'An error has occurred, please take a screenshot with the URL and send it to IT.'; //An Integer used to control the number of rows displayed by a Visualforce page
    public static final Id STANDARD_PRICEBOOK_ID = '01s7Q000000prcuQAA'; //An Integer used to control the number of rows displayed by a Visualforce page

}