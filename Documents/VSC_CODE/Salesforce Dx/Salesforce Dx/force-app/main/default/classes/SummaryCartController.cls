public with sharing class SummaryCartController {
    
    
    @AuraEnabled
    public static List<NE__OrderItem__c> retrieveOrder(String orderId) {
        
        
        List<NE__OrderItem__c> orderItems =  [select Id,NE__Bundle__c,NE__Bundle_Element__c,NE__ProdName__c, NE__Qty__c, NE__OneTimeFeeOv__c, NE__RecurringChargeOv__c, NE__Root_Order_Item__c, NE__Parent_Order_Item__c,NE__Action__c, NE__Status__c from NE__OrderItem__c WHERE NE__OrderId__c =: orderId];
        
        System.debug('Size: ' + orderItems.size());
        return orderItems;
    }

}