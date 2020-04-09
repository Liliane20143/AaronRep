@isTest
    public class OB_Order_Test {

    @isTest
    	static void retrieveOrderTest(){
  
        
		NE__Order__c config = new NE__Order__c();
		config.NE__Description__c = 'Sono un Test';
		insert config;
        
        List<NE__OrderItem__c> orditems = new List<NE__OrderItem__c>();
        //String orderId;
            
        NE__OrderItem__c ordItem = new NE__OrderItem__c();
        ordItem.NE__City__c = 'MilanoTest';
        ordItem.NE__OrderId__c = config.id;
		ordItem.NE__Qty__c = 10;
            
        insert ordItem;
        
            
        orditems.add(orditem);
        OrderController.retrieveOrder(config.id);
    }
}