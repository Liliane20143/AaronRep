/*****************************************************************
Name:  OB_HomePage_CC_Test

============================================================
Purpose:     test class of   OB_HomePage_CC                                                                                                     
============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                             DATE           DETAIL          Description
1.0         Giovanni Spinelli              22/07/2019      Created          CSR: 
*****************************************************************/
@isTest 
public class OB_HomePage_CC_Test {
    private static final Map<String, Schema.RecordTypeInfo> ACCOUNT_INFO = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( );
    private static final Id ACCOUNT_RT_ID = ACCOUNT_INFO.get( OB_UtilityConstants.ACC_RT_MERCHANT ).getRecordTypeId( );
    @testSetup
    static void setupData(){
         OB_LogRequest__c testLogRequest = new OB_LogRequest__c();
         testLogRequest.OB_RejectReason__c = 'test';
         testLogRequest.OB_Status__c='Rifiutato';
         insert testLogRequest;
        
    }

     @isTest
     public static void getTableInformation_Test_Catch(){
        Test.startTest();
        OB_HomePage_CC.getTableInformation();
        Test.stopTest();
     }
     @isTest
     public static void getTableInformation_Test_2(){
        User portalAccountOwner = OB_TestDataFactory.getPortalAccountOwner( );
        insert portalAccountOwner;

        User testCommunityUser;
        System.runAs( portalAccountOwner )
        {
            System.debug('portalAccountOwner: ' + portalAccountOwner);
            Account testAccount = OB_TestDataFactory.getAccount( );
            testAccount.OwnerId = portalAccountOwner.Id;
            testAccount.RecordTypeId = ACCOUNT_RT_ID;
            testAccount.OB_ABI__c='05116';
            System.debug('testAccount: ' + testAccount);
            insert testAccount;
            Contact testContact = OB_TestDataFactory.getContact( testAccount );
            System.debug('testContact: ' + testContact.Account.OB_ABI__c);
            
            insert testContact;
            testCommunityUser = OB_TestDataFactory.getCommunityUser( testContact );
            testCommunityUser.ProfileId = OB_TestDataFactory.getNexiPartnerApproverL1Profile( ).Id;
            
            insert testCommunityUser;
        } 
        Id groupId = [ SELECT Id FROM Group WHERE Type = 'Queue' and Name = '05116 - Approvazione Pricing' ].Id;
        GroupMember testGroupMember = new GroupMember( UserOrGroupId = testCommunityUser.Id, GroupId = groupId );
        insert testGroupMember;
        System.runAs( testCommunityUser )
        {
            System.debug('testCommunityUser.OB_CAB__c: ' + testCommunityUser.OB_CAB__c);
            System.debug('testCommunityUser.OB_ABI__c : ' + testCommunityUser.OB_ABI__c);
            NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
            insert testOrderHeader;
            
            NE__Order__c order1 = new NE__Order__c();
            order1.NE__Type__c = 'ChangeOrder';
            order1.OB_Bank_OrderStatus__c =  'Draft - rejected pricing';
            order1.OB_ApprovalType__c = 'Pricing';
            order1.OB_ApprovalBIO__c = false;
            order1.NE__Order_Header__c= testOrderHeader.Id;
            order1.OB_CAB__c = testCommunityUser.OB_CAB__c;
            order1.OB_ABI__c = '05116';
            order1.OwnerId = groupId;
            insert order1;
            OB_LogRequest__c logRequest1 = [SELECT id,OB_StatusFormula__c FROM OB_LogRequest__c];
            logRequest1.OB_CAB__c = testCommunityUser.OB_CAB__c;
            logRequest1.OB_ABI__c = '05116';
            System.debug('OB_StatusFormula__c '+logRequest1.OB_StatusFormula__c);
            update logRequest1;

            System.debug('testOrder: ' + order1);
            Test.startTest();
            OB_HomePage_CC.getTableInformation();
            Test.stopTest();
        }
     }
    @isTest
    public static void hideToAdmin_Apex_Test(){
        Test.startTest();
        Boolean isTest = OB_HomePage_CC.hideToAdmin_Apex();
        System.assertEquals(false, isTest);
        Test.stopTest();
    }
}