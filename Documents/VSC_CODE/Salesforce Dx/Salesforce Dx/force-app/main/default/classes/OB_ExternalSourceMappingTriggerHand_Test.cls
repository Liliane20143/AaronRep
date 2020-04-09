/**************************************************************
* Date Created       : 13/11/2018  
* Author             : Doris Tatiana
* Class name to test : OB_ExternalSourceMappingTriggerHandler
***************************************************************
*/

@isTest
public  class OB_ExternalSourceMappingTriggerHand_Test {

	@isTest
	public static void  updateMerchant_Test() {

		Test.startTest();

		Account acc = new Account();
		acc.Name = 'Test';
		acc.NE__E_mail__c  = 'test@null.it';
		acc.OB_Employees_Number__c = 'Minore di 10';
		acc.NE__VAT__c  = '12345678901';
		acc.NE__Fiscal_code__c= '12345678901';
		acc.OB_VAT_Not_Present__c = false;
		insert acc;
		NE__Service_Point__c sp = new NE__Service_Point__c();
  		insert sp;
		//Map<ExternalSourceMapping__c ,  Boolean> booleanExtMap = new Map<ExternalSourceMapping__c ,  Boolean>();
		Map<Id, ExternalSourceMapping__c> oldExternal = new Map<Id, ExternalSourceMapping__c>()  ;
		Map<Id, ExternalSourceMapping__c> newExternal = new Map<Id, ExternalSourceMapping__c> ();
		ExternalSourceMapping__c externalMap          = new ExternalSourceMapping__c();
   		externalMap.OB_Merchant_ID__c      = acc.id;
   		externalMap.OB_Service_Point_ID__c = sp.id; 
   		externalMap.OB_ToBeChecked__c      = true; 
   		externalMap.OB_MCC__c              = '40'; 
   		insert externalMap;

		oldExternal.put(externalMap.id , externalMap); 
		externalMap.OB_ToBeChecked__c      = false;  
		update externalMap;
		newExternal.put(externalMap.id , externalMap);
		
		
		//OB_ExternalSourceMappingTriggerHandler externalTrigger = new OB_ExternalSourceMappingTriggerHandler();
		OB_ExternalSourceMappingTriggerHandler.updateMerchant(oldExternal, newExternal);
		Test.stopTest();
		
	}

	@isTest
	public static void  modifyDescription_Test() {

		Test.startTest();

		Map<Id, ExternalSourceMapping__c> oldExternal = new Map<Id, ExternalSourceMapping__c>() ;
		Map<Id, ExternalSourceMapping__c> newExternal = new Map<Id, ExternalSourceMapping__c> ();
		//newExternal.put();
		
		OB_ExternalSourceMappingTriggerHandler.modifyDescription(oldExternal, newExternal);
		Test.stopTest();
		
	}
}