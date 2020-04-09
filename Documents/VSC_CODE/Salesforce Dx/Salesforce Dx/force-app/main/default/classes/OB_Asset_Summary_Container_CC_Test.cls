@isTest
public class OB_Asset_Summary_Container_CC_Test{
  @isTest
  public static void getAccountTest()
  {
      
     String servicePointsId_value='';
     


  Account acc = new Account();
		acc.Name = 'Test';
    
		//acc.Description  = 'Test';
		acc.NE__E_mail__c  = 'test@null.it';
		acc.OB_Employees_Number__c = 'Minore di 10';
		acc.NE__VAT__c  = '12345678901';
		acc.NE__Fiscal_code__c= '12345678901';
		acc.OB_VAT_Not_Present__c = false;
		insert acc;
     List<Account> ListOfAccounts = new  List<Account>();
     ListOfAccounts.add(acc);




    NE__Service_Point__c servicePoint1 = new NE__Service_Point__c();
    servicePoint1.NE__Account__c=acc.Id;
    insert servicePoint1;
    servicePointsId_value=servicePoint1.Id;
    List<NE__Service_Point__c> servicePoints=new List<NE__Service_Point__c>();
    servicePoints.add(servicePoint1);
    
    
    





     
     Contact cont           = new Contact();
	   
		 cont.FirstName 						  = 'RIRI';
		 cont.LastName 						  = 'TOTI';
	   cont.OB_Fiscal_Code__c 				  = 'TTORRI00B01D150K';
		 cont.OB_Document_Release_Authority__c = 'Comune' ;
		 cont.OB_Document_Type__c 			= 'Carta di Identità';
		 cont.OB_Sex__c 						= 'M';
	   cont.OB_BypassValidation__c 		= false;
	   cont.OB_Document_Number__c 			= '123erty644';
		 cont.RecordTypeId                   = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Esecutore').getRecordTypeId();
		 cont.AccountId                      = acc.Id;
     
      List<Contact> contacts = new  List<contact>();
      contacts.add(cont);

      ///////////////////////////////////////////////7
    
    
    ///////////////////////
   

    
								

     Test.startTest();
     OB_Asset_Summary_Container_CC.getAccount(servicePointsId_value);
     Test.stopTest();
  }   
}