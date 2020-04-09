@isTest
public class OB_BankOrderDashController_Test  
{
    
    
    
	@testSetup 
	public static void setUp() 
	{ 
		Account a = new Account();
		a.Name 					 = 'a'; 
		a.NE__VAT__c 			 = '12345678901'; 
		a.OB_Employees_Number__c = 'Minore di 10';
		a.NE__Fiscal_code__c 	 = 'AAAAAA11A11A111A';
		a.OB_ABI__c 			 = '12345';
		insert a;
		
		Contact c   = new Contact();
		c.LastName  = 'c';
		c.AccountId = a.id;
		insert c;

	}
    
    /*
    *	Author		:	Morittu Andrea
    *	Date		:	22-11-2019
    *	Task		: 	PROD_159
    *	Description	:	Covering main Method
    */
	@isTest
	public static void OB_BankOrderDashControllerTest()
	{
		ApexPages.currentPage().getParameters().put('reportName', 'Test_Account');
		ApexPages.currentPage().getParameters().put('ABIField', '03138');
		ApexPages.currentPage().getParameters().put('CABField', '12300');

		User portalAccountOwner = OB_TestDataFactory.getPortalAccountOwner();
        insert portalAccountOwner;

        User testCommunityUser;
        System.runAs(portalAccountOwner) {
            Account testAccount = OB_TestDataFactory.getAccount();
            testAccount.OwnerId = portalAccountOwner.Id;
            Id IdMerchant =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Merchant').getRecordTypeId();
            testAccount.RecordTypeId = IdMerchant;
            insert testAccount;
            Contact testContact = OB_TestDataFactory.getContact(testAccount);
            insert testContact;
            testCommunityUser = OB_TestDataFactory.getCommunityUser(testContact);
            testCommunityUser.ProfileId = OB_TestDataFactory.getNexiPartnerUserProfile().Id;
            insert testCommunityUser;

            System.runAs(testCommunityUser) {

                Test.startTest();
                OB_BankOrderDashController chartController = new OB_BankOrderDashController();
                chartController.ABI = '03138';											
                chartController.CAB = '12300';								
                chartController.reportId = 'reportId';
                chartController.filter= 'filter';	
               	chartController.showReport=true; 									
                chartController.currentUser	= 'currentUser';
                chartController.lcBaseURL= 'lcBaseURL';									
                
                
                Test.stopTest();
            }
        }
	}



	@isTest
	public static void getFinalUrlTest()
	{
		Test.startTest();
		OB_BankOrderDashController.getFinalUrl();
		Test.stopTest();
	}
}