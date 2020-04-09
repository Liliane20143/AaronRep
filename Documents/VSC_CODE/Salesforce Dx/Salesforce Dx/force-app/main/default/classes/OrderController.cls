public with sharing class OrderController {
	
    @AuraEnabled
    public static List<NE__OrderItem__c> retrieveOrder(String orderId) {
        
        List<NE__OrderItem__c> orderItems =  [SELECT Id, Name, NE__ProdName__c FROM NE__OrderItem__c WHERE NE__OrderId__c =: orderId];
        System.debug('Size: ' + orderItems.size());
        return orderItems;
    }
}