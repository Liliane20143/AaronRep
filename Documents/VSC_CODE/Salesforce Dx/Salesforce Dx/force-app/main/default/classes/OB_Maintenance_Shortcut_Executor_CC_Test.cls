@isTest
public class OB_Maintenance_Shortcut_Executor_CC_Test {
//         *@author Simone Misani <simone.misani@accenture.com>
//         *@date 18/04/2019
//         *@function-Helper return the current User
//         
    @isTest
    public static void retriveInfoTest (){

        OB_Maintenance_Shortcut_Executor_CC.SearchResultWrapper wrap1 = new OB_Maintenance_Shortcut_Executor_CC.SearchResultWrapper();
        wrap1.acc=null;
        wrap1.errorMessage='test';
        wrap1.listOfServicePoint= null;
        wrap1.executor= null;
        wrap1.selectedServicePoint = '';
        wrap1.selectedServicePointExt = '';
        wrap1.executorModifiedAllowed = true;
        wrap1.lovList = null;
        wrap1.outcome = '';
        wrap1.legalOffice = null;
        wrap1.selectedMerchantExt = '';
		wrap1.selectedMerchantAsset = '';
		wrap1.selectedServicePointAsset = '';
		wrap1.selectedAsset = null;
		wrap1.selectServicePointListId = null;
        Id recordTypeIdMerch  = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.MERCHANTRT).getRecordTypeId();
        Account acc = new Account();
            acc.Name 					 = 'a'; 
            acc.NE__VAT__c 			 = '12345678901'; 
            acc.OB_Employees_Number__c = 'Minore di 10';
            acc.NE__Fiscal_code__c 	 = 'AAAAAA11A11A111A';
            acc.OB_ABI__c 			 = '12345';
            acc.RecordTypeId = recordTypeIdMerch;
		insert acc;
		
		
		Contact cont   = new Contact();
            cont.LastName  = 'cord';
            cont.AccountId = acc.id;
		insert cont;

        String contactId = cont.id;
        Test.startTest();
		OB_Maintenance_Shortcut_Executor_CC.retriveInfo(contactId);
		Test.stopTest();

    }
     @isTest
    public static void contextUserTest (){

         Id recordTypeIdMerch  = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.MERCHANTRT).getRecordTypeId();
        Id recordTypeIdExec  = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Esecutore').getRecordTypeId();
        Id recordTypeIdTitolare  = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Titolare_Effettivo').getRecordTypeId();
        Account acc = new Account();
            acc.Name 					 = 'a'; 
            acc.NE__VAT__c 			 = '12345678901'; 
            acc.OB_Employees_Number__c = 'Minore di 10';
            acc.NE__Fiscal_code__c 	 = 'AAAAAA11A11A111A';
            acc.OB_ABI__c 			 = '12345';
            acc.RecordTypeId = recordTypeIdMerch;
		insert acc;		
		
		Contact cont1   = new Contact();
            cont1.LastName  = 'cord';
            cont1.AccountId = acc.id;            
            cont1.recordTypeId = recordTypeIdExec;
		insert cont1; 
        Contact cont2   = new Contact();
            cont2.LastName  = 'cord';
            cont2.AccountId = acc.id;            
            cont2.recordTypeId = recordTypeIdTitolare;
		insert cont2;
        String contactId = cont1.Id;
     

        Test.startTest();
		OB_Maintenance_Shortcut_Executor_CC.contextUser(contactId);
		Test.stopTest();


     }


}