@isTest
public class OB_QueueableClassTracking_Test {

@isTest
  public static void test (){
    NE__Order_Header__c oh = OB_TestDataFactory.getOrderHeader();
    oh.OB_Main_Process__c = 'Maintenance';
    insert oh;
    NE__Order__c Order = OB_TestDataFactory.getOrder(oh);
    insert Order;

    NE__Product__c prod =OB_TestDataFactory.getProduct( );
    prod.RecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.POS_RT ).getRecordTypeId( );
    insert prod;
    NE__OrderItem__c oi1= OB_TestDataFactory.getOrderItem( Order.Id );
    oi1.NE__Action__c = 'None';
    oi1.NE__ProdId__c = prod.Id;
    insert oi1;

    NE__OrderItem__c oi2= OB_TestDataFactory.getOrderItem(Order.Id);
    oi2.NE__Action__c = 'Add';
    oi2.NE__ProdId__c = prod.Id;
    insert oi2;

    NE__OrderItem__c oi3= OB_TestDataFactory.getOrderItem(Order.Id);
    oi3.NE__Parent_Order_Item__c = oi2.Id;
    insert oi3;

    NE__Product__c prod2 = OB_TestDataFactory.getProduct( );
    prod2.RecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.ACQUIRING_RT ).getRecordTypeId( );
    prod2.OB_Acquirer__c = '';
    insert prod2;
    NE__OrderItem__c oi4= OB_TestDataFactory.getOrderItem( Order.Id );
    oi4.NE__Action__c = 'Add';
    oi4.NE__ProdId__c = prod2.Id;
    insert oi4;
    
    NE__OrderItem__c oi5= OB_TestDataFactory.getOrderItem(Order.Id);
   
    oi5.NE__Parent_Order_Item__c = oi4.Id;
    insert oi5;


    NE__Order_Header__c oh2 = OB_TestDataFactory.getOrderHeader();
    oh2.OB_Main_Process__c = 'Setup';
    insert oh2;
    NE__Order__c Order2 = OB_TestDataFactory.getOrder(oh2);
    insert Order2;


    OB_QueueableClassTracking updater = new OB_QueueableClassTracking( oh.Id );
    
    User testUser = [ SELECT Id FROM User WHERE Profile.UserLicense.Name = 'Salesforce' AND IsActive = true LIMIT 1 ].get( 0 );
 
    System.runAs( testUser )
        {
            Test.startTest( );
            System.enqueueJob( updater );
        // System.debug( OB_Utility.retrieveSpecialCategoryConfigurations(testOrderHeader.Id));
            Test.stopTest( );
        }





  }
  



}