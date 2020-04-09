/*
	*	Author		:	Morittu Andrea
	*	Date		:	07-Nov-2019
	*	Task		:	EVO_BACKLOG143
	* 	Description	:	Covering main controller class
*/
@isTest
public with sharing class OB_Configure_Promo_Amex_Controller_Test {
    public static final Map<String, Schema.RecordTypeInfo> ACCOUNT_INFO = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( );
    public static final Id ACCOUNT_RT_ID = ACCOUNT_INFO.get( OB_UtilityConstants.ACC_RT_MERCHANT ).getRecordTypeId();
    
/*
	*	Author		:	Morittu Andrea
	*	Date		:	07-Nov-2019
	*	Task		:	EVO_BACKLOG143
	* 	Description	:	Prepare Data
*/
    @testSetup
    public static void makeData() {
		OB_Convention_Code__c conventionCode = new OB_Convention_Code__c();
        conventionCode.OB_Active__c = true;
        conventionCode.OB_Additional_Text__c = 'simulateTESTclass';
        conventionCode.OB_Commission__c = 'test';
        conventionCode.OB_LoyaltyCode__c = '12345';
        conventionCode.OB_Start_Date__c = System.today();
        insert conventionCode;
        
        Account bankAcc = OB_TestDataFactory.getBankAccount();
        bankAcc.Name = 'Test Class Bank Acc';
        bankAcc.OB_ABI__c = '03138';
        insert bankAcc;
        
        Id amexProductRT = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Acquiring').getRecordTypeId();
        NE__Product__c amexProduct = new NE__Product__c();
        amexProduct.Name = 'AMEX';
        amexProduct.RecordTypeId = amexProductRT;
        insert amexProduct;
        
    }
/*
	*	Author		:	Morittu Andrea
	*	Date		:	07-Nov-2019
	*	Task		:	EVO_BACKLOG143
	* 	Description	:	Test retrieveConventionCodes_Server method
*/
	@isTest
   	public static void retrieveConventionCodes_Server_Test() {
        User portalAccountOwner = OB_TestDataFactory.getPortalAccountOwner();
        insert portalAccountOwner;

        User testCommunityUser;
        System.runAs(portalAccountOwner) {
            Account testAccount = OB_TestDataFactory.getAccount();
            testAccount.OwnerId = portalAccountOwner.Id;
            testAccount.RecordTypeId = ACCOUNT_RT_ID;
            insert testAccount;
            Contact testContact = OB_TestDataFactory.getContact(testAccount);
            insert testContact;
            testCommunityUser = OB_TestDataFactory.getCommunityUser(testContact);
            testCommunityUser.ProfileId = OB_TestDataFactory.getNexiPartnerUserProfile().Id;
            testCommunityUser.OB_CAB__c = '123;456';
            insert testCommunityUser;

            System.runAs(testCommunityUser) {    
       			OB_Configure_Promo_Amex_Controller.retrieveConventionCodes_Server();
            }
		}
    }
    
/*
	*	Author		:	Morittu Andrea
	*	Date		:	07-Nov-2019
	*	Task		:	EVO_BACKLOG143
	* 	Description	:	Test performOperation_Server_Test method (edit)
*/
    @isTest
    public static void performOperation_Edit_Server_Test() {
        Map<String, Object> incomingWrapperMap = new Map<String, Object>();
        incomingWrapperMap.put('actionType' , System.Label.OB_Edit);
        incomingWrapperMap.put('bankAbi' , '03138');
        OB_Convention_Code__c conventionCode = [SELECT 		Id, 
                                                            OB_Active__c,
                                                            OB_Additional_Text__c,
                                                            OB_LoyaltyCode__c,
                                                            OB_Start_Date__c
                                                FROM 	OB_Convention_Code__c
                                                WHERE 	OB_Additional_Text__c = 'simulateTESTclass'
                                                LIMIT 	1];
       incomingWrapperMap.put('currentRecord' , conventionCode);
       Object wrapperToTest = (Object) incomingWrapperMap;
        Test.startTest();
       	OB_Configure_Promo_Amex_Controller.performOperation_Server(wrapperToTest);
        System.assertNotEquals(wrapperToTest, null);
        Test.stopTest();
    }
    
/*
	*	Author		:	Morittu Andrea
	*	Date		:	07-Nov-2019
	*	Task		:	EVO_BACKLOG143
	* 	Description	:	Test performOperation_Server_Test method (create)
*/
    @isTest
    public static void performOperation_Create_Server_Test() {

        Map<String, Object> incomingWrapperMap = new Map<String, Object>();
        incomingWrapperMap.put('actionType' , System.Label.OB_Create);
        incomingWrapperMap.put('bankAbi' , '03138');
        OB_Convention_Code__c conventionCode = new OB_Convention_Code__c();
        incomingWrapperMap.put('currentRecord' , conventionCode);
        Object wrapperToTest = (Object) incomingWrapperMap;
        OB_Configure_Promo_Amex_Controller.performOperation_Server(wrapperToTest);
        System.assertNotEquals(wrapperToTest, null);
    }
    
/*
	*	Author		:	Morittu Andrea
	*	Date		:	07-Nov-2019
	*	Task		:	EVO_BACKLOG143
	* 	Description	:	Test performOperation_Server_Test method (delete)
*/
    @isTest
    public static void performOperation_Delete_Server_Test() {

        Map<String, Object> incomingWrapperMap = new Map<String, Object>();
        incomingWrapperMap.put('actionType' , System.Label.OB_Delete);
        incomingWrapperMap.put('bankAbi' , '03138');
        OB_Convention_Code__c conventionCode = [SELECT Id, Name FROM OB_Convention_Code__c WHERE OB_Additional_Text__c = 'simulateTESTclass'];
        incomingWrapperMap.put('currentRecord' , conventionCode);
        Object wrapperToTest = (Object) incomingWrapperMap;
        OB_Configure_Promo_Amex_Controller.performOperation_Server(wrapperToTest);
        System.assertNotEquals(wrapperToTest, null);
    }
    
}