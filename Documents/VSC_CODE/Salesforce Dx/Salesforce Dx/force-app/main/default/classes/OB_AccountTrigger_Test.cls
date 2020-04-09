/**************************************************************
* Date Created       : 12/11/2018  
* Author             : Doris Tatiana
* Class name to test : OB_AccountTrigger
***************************************************************
*/ 
@isTest

private  class OB_AccountTrigger_Test {

    @isTest
	 private static void test_trigger() {
         
         
		//	micol.ferrari 04/11/2019 - INSERT CUSTOM SETTING FOR DISABLE TRIGGER - START
        OB_TriggerSupport__c triggerSupport = new OB_TriggerSupport__c( );
        triggerSupport.Name = 'OB_DisableTriggers';
		triggerSupport.OB_DisableAll__c = false;
        triggerSupport.OB_DisableAccountTrigger__c = false;
        insert triggerSupport;
        //	micol.ferrari 04/11/2019 - INSERT CUSTOM SETTING FOR DISABLE TRIGGER - STOP
	 	
		Test.startTest();
		Account oldAcc = new Account();	
		Account oldAcc1 = new Account();		
		oldAcc.Name = 'Test';
		//acc.Description  = 'Test';
		oldAcc.NE__E_mail__c  = 'test@null.it';
		oldAcc.OB_Employees_Number__c = 'Minore di 10';
		oldAcc.NE__VAT__c  = '12345678901';
		oldAcc.NE__Fiscal_code__c= '12345678901';
		oldAcc.OB_VAT_Not_Present__c = false;
		oldAcc.OB_ABI__c = '12345';
		insert oldAcc;

		oldAcc1.Name = 'Test1';
		//acc.Description  = 'Test';
		oldAcc1.NE__E_mail__c  = 'test@null.it';
		oldAcc1.OB_Employees_Number__c = 'Minore di 10';
		oldAcc1.NE__VAT__c  = '12345678901';
		oldAcc1.NE__Fiscal_code__c= '12345678901';
		oldAcc1.OB_VAT_Not_Present__c = false;
		oldAcc.Name = oldAcc1.Name;
		update oldAcc;
		Test.stopTest();
		
	}

}