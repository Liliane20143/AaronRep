/*
Controller name class : OB_DocumentComponentAddressController
Doris Tatiana, 30/10/2018
*/

@isTest
public  class OB_DocumentComponentAddress_Test {

    @isTest
    static void  getDocTypeValuesTest() {

        Map<String,String> pickListValuesList= new Map<String,String>();
        Contact cont = new Contact();
        
        Test.startTest();
        OB_DocumentComponentAddressController.getDocTypeValues();
        Test.stopTest();
        
    }


    @isTest
    static void  getDocAuthValuesTest() {

        Map<String,String> pickListValuesList= new Map<String,String>();
        Contact cont = new Contact();
        
        Test.startTest();
        OB_DocumentComponentAddressController.getDocAuthValues();
        Test.stopTest();
        
    }
    
    /*
	*	Author	:	Morittu Andrea
	*	Date	:	17-Sept-2019
	*	Task	:	EVO_Backlog_10
	*	Description	:	covering
	*/
    @isTest
    static void  pagoBancomatArePresent_Test() {
        NE__Product__c productAmex = OB_TestDataFactory.getProduct();
        productAmex.RecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get('Acquiring').getRecordTypeId();
        insert productAmex;
        
        NE__Product__c productPB = OB_TestDataFactory.getProduct();
        productPB.RecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get('Pagobancomat').getRecordTypeId();
        insert productPB;
        
		NE__Order_Header__c orderHeader = OB_TestDataFactory.getOrderHeader();
        insert orderHeader;
        
       	NE__Order__c orderWithPBOnly = OB_TestDataFactory.getOrder(orderHeader);
        insert orderWithPBOnly;
		
        NE__Order__c orderWithMultipleItem = OB_TestDataFactory.getOrder(orderHeader);
        insert orderWithMultipleItem;
        List<NE__OrderItem__c> orderItemsToInsert = new List<NE__OrderItem__c>();
        for(Integer i = 10; i < 10; i++ ) {
            NE__OrderItem__c orderItemPB 		= OB_TestDataFactory.getOrderItem(orderWithPBOnly.Id);
            NE__OrderItem__c orderItemMultiple = OB_TestDataFactory.getOrderItem(orderWithMultipleItem.Id);
            if(Math.mod(i, 2) == 0) {
                orderItemPB.NE__ProdId__c = productPB.Id;
                orderItemsToInsert.add(orderItemPB);
            } else {
                orderItemMultiple.NE__ProdId__c = productAmex.Id;
                orderItemsToInsert.add(orderItemMultiple);
            }
        }
       insert orderItemsToInsert;
       Test.startTest();
       	OB_DocumentComponentAddressController.pagoBancomatArePresent(orderWithMultipleItem.Id);
       Test.stopTest(); 
    }
}