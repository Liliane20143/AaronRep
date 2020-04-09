/*********************************************************************
Name:  OB_FinalSummary_Test
======================================================================                                                                                                       
History                                                            
                                                        
  AUTHOR            DATE CREATED        DESCRIPTION
  Giovanni       	15/04/2019			test classes for OB_FinalSummary_CC 
  Spinelli								

**********************************************************************/
@isTest
public with sharing class OB_FinalSummary_Test {
    /**********************************************
    *   METHOD METHOD FOR OB_FinalSummary_CC.checkMissingField 
    **********************************************/
    @isTest
	public static void  checkMissingField() {
        Id recordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Merchant').getRecordTypeId();
		Account acc = new Account();	
		acc.Name                   = 'Test';
		acc.NE__E_mail__c          = 'test@null.it';
		acc.OB_Employees_Number__c = 'Minore di 10';
		acc.NE__VAT__c             = '12345678901';
		acc.NE__Fiscal_code__c     = 'TSTTST80A01F205J';
		acc.OB_VAT_Not_Present__c  =  false;
		acc.OB_ABI__c              = '12345';
		acc.OB_ATECO__c            = '1234567';
		acc.OB_Legal_Form__c       = 'test';
        acc.OB_Legal_Form_Code__c                        = 'test' ;
        acc.OB_Administrative_Office_ZIP__c              = 'test' ;
        acc.OB_Legal_Address_ZIP__c                      = 'test' ;
        acc.OB_Administrative_Office_Country__c          = 'test' ;
        acc.OB_Administrative_Office_Country_Code__c     = 'BA' ;
        acc.OB_Administrative_Office_State__c            = 'test' ;
        acc.OB_Administrative_Office_State_Code__c       = 'BA' ;
        acc.OB_SAE_Code__c                               = '' ;
        acc.RecordTypeId = recordTypeIdAcc;
		insert acc;
		//start antonio.vatrano 23/05/2019 insert configuration
		NE__Order__c configuration1= new NE__Order__c( NE__Type__c = 'ChangeOrder');
		NE__Order__c configuration2= new NE__Order__c( NE__Type__c = 'test');
		insert configuration1;
		insert configuration2;
		//END antonio.vatrano 23/05/2019 insert configuration
		NE__Service_Point__c sp = new NE__Service_Point__c();
		sp.OB_Fax_Number__c          = '123455';
		sp.OB_Phone_Number__c        = '1234554';
		sp.OB_Mobile_Phone_Number__c = '3455555';
		sp.NE__Street__c 	         = 'VIA ADDA' ;
		sp.OB_Street_Number__c 	     = '21';
		sp.OB_Address_Detail__c 	 = '' ;
		sp.OB_Province_code__c 	     = 'MI';
		sp.NE__City__c               = 'MILANO';  
		insert sp;
		Test.startTest();
		OB_FinalSummary_CC.checkMissingField(acc.Id , sp.Id, configuration1.Id); //antonio.vatrano 23/05/2019 add configuration
		OB_FinalSummary_CC.checkMissingField(acc.Id , sp.Id, configuration2.Id); //antonio.vatrano 23/05/2019 add configuration
		Test.stopTest();
    }
}