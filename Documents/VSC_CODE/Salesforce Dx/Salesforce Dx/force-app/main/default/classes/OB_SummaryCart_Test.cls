@isTest
public class OB_SummaryCart_Test {

    @isTest
    	static void retrieveOrderTest(){
        
            String orderId;
            NE__Order__c configuration = new NE__Order__c();
            configuration.NE__Description__c = 'Im a test';
            insert configuration;
            
           List<NE__OrderItem__c> orditems = new List<NE__OrderItem__c>();
           NE__OrderItem__c ordItem = new NE__OrderItem__c();
           ordItem.NE__City__c = 'MilanoTest';
           orditem.NE__OrderId__c = configuration.Id;
           orditem.NE__Qty__c = 2;
           insert ordItem;
           orditems.add(ordItem);
            
          SummaryCartController.retrieveOrder(orderId);
    }
}