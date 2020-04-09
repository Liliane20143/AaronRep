/**************************************************************
* Date Created       : 16/11/2018  
* Author             : Doris Tatiana
* Class name to test : OB_ContactTrigger
***************************************************************
*/

@isTest 

public with sharing class OB_ContactTrigger_Test {
	

    @isTest
	 public static void test_ContactTrigger() {

	 	Test.startTest();
        //	micol.ferrari 04/11/2019 - INSERT CUSTOM SETTING FOR DISABLE TRIGGER - START
        OB_TriggerSupport__c triggerSupport = new OB_TriggerSupport__c( );
        triggerSupport.Name = 'OB_DisableTriggers';
		triggerSupport.OB_DisableAll__c = false;
        triggerSupport.OB_DisableContactTrigger__c = false;
        insert triggerSupport;
        //	micol.ferrari 04/11/2019 - INSERT CUSTOM SETTING FOR DISABLE TRIGGER - STOP
    
	 	Contact cont = new Contact();
		cont.FirstName = 'RIRI';
		cont.LastName = 'TOTI';
		cont.OB_Fiscal_Code__c = 'TTORRI00B01D150K';
		cont.OB_Document_Release_Authority__c = 'Comune' ;
		cont.OB_Document_Type__c = 'Carta di Identità';
		cont.OB_Sex__c = 'M';
		cont.OB_BypassValidation__c = false;
		cont.OB_Document_Number__c = '123erty644';
		cont.OB_Document_Expiration_Date__c = Date.today().addYears(10);
		cont.OB_Document_Release_Date__c    = Date.today();

		insert cont;

		Contact cont1 = new Contact();
		cont1.FirstName = cont.FirstName ;
		cont1.LastName = 'TOTI';
		cont1.OB_Fiscal_Code__c = 'TTORRI00B01D150K';
		cont1.OB_Document_Release_Authority__c = 'Comune' ;
		cont1.OB_Document_Type__c = 'Carta di Identità';
		cont1.OB_Sex__c = cont.OB_Sex__c;
		cont1.OB_BypassValidation__c = false;
		cont1.OB_Document_Number__c = '123erty644';
		//cont.OB_Birth_Date__c = Date.newInstance(2000, 01, 01);
		cont1.OB_Document_Expiration_Date__c = Date.today().addYears(10);
		cont1.OB_Document_Release_Date__c    = Date.today();
		update cont;
		Test.stopTest();
		
	}
}