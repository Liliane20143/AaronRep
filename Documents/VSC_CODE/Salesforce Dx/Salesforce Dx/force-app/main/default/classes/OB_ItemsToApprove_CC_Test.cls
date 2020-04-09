@isTest
private class OB_ItemsToApprove_CC_Test
{
    private static final Map<String, Schema.RecordTypeInfo> ACCOUNT_INFO = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( );
    private static final Id ACCOUNT_RT_ID = ACCOUNT_INFO.get( OB_UtilityConstants.ACC_RT_MERCHANT ).getRecordTypeId( );

    /**
    *@author Grzegorz Banach <grzegorz.banach@accenture.com>
    *@date 25/03/2019
    *@description Method tests getUserInformation
    */
    @isTest
    static void getUserInformationTest( )
    {
        User resultUser = OB_ItemsToApprove_CC.getUserInformation( );
        System.assertEquals( UserInfo.getUserId( ), resultUser.Id );
    }

    /*******************************************************************************
    Purpose:  Method tests that returned list of maps is not empty - scenario - single CAB and Nexi Partner Approver L1

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       Joanna Mielczarek   21/03/2019    Created    -
    ********************************************************************************/
    @isTest static void retrieveItemsToApproveTestSingleCAB( )
    {
        User portalAccountOwner = OB_TestDataFactory.getPortalAccountOwner( );
        insert portalAccountOwner;

        //START gianluigi.virga 22/07/2019
        String filterValue = 'Draft - rejected pricing_InOrder';
        //END gianluigi.virga 22/07/2019
        User testCommunityUser;
        System.runAs( portalAccountOwner )
        {
            Account testAccount = OB_TestDataFactory.getAccount( );
            testAccount.OwnerId = portalAccountOwner.Id;
            testAccount.RecordTypeId = ACCOUNT_RT_ID;
            insert testAccount;
            Contact testContact = OB_TestDataFactory.getContact( testAccount );
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
            NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
            insert testOrderHeader;
            NE__Order__c testOrder = OB_TestDataFactory.getOrder( testOrderHeader );
            testOrder.OB_ApprovalLevel__c = OB_UtilityConstants.NEXI_PARTNER_APPROVER_L1_PROFILE_NAME;
            testOrder.OB_CAB__c = testCommunityUser.OB_CAB__c;
            testOrder.OwnerId = groupId;
            insert testOrder;

            Approval.ProcessResult approvalProcessResult = OB_TestDataFactory.getApprovalProcessResult( testOrder );

            Test.startTest( );
            List<Map<String, String>> testList = OB_ItemsToApprove_CC.retrieveItemsToApprove( testOrder.OB_ABI__c, testOrder.OB_CAB__c, filterValue );
            Test.stopTest( );

        }
    }

    /*******************************************************************************
    Purpose:  Method tests size of returned list of maps - scenario - multi CAB and Nexi Partner Approver L2

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       Joanna Mielczarek   21/03/2019    Created    -
    ********************************************************************************/
    @isTest static void retrieveItemsToApproveTestMultiCAB( )
    {
        User portalAccountOwner = OB_TestDataFactory.getPortalAccountOwner( );
        insert portalAccountOwner;

        User testCommunityUser;
        System.runAs( portalAccountOwner )
        {
            Account testAccount = OB_TestDataFactory.getAccount( );
            testAccount.OwnerId = portalAccountOwner.Id;
            testAccount.RecordTypeId = ACCOUNT_RT_ID;
            insert testAccount;
            Contact testContact = OB_TestDataFactory.getContact( testAccount );
            insert testContact;
            testCommunityUser = OB_TestDataFactory.getCommunityUser( testContact );
            testCommunityUser.OB_CAB__c = '12345;67890';
            testCommunityUser.ProfileId = OB_TestDataFactory.getNexiPartnerApproverL2Profile( ).Id;
            insert testCommunityUser;
}

        Id groupId = [ SELECT Id FROM Group WHERE Type = 'Queue' and Name = '05116 - Approvazione Pricing L2' ].Id;
        GroupMember testGroupMember = new GroupMember( UserOrGroupId = testCommunityUser.Id, GroupId = groupId );
        insert testGroupMember;

        System.runAs( testCommunityUser )
        {
            NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
            insert testOrderHeader;
            NE__Order__c testOrder1 = OB_TestDataFactory.getOrder( testOrderHeader );
            testOrder1.OB_ApprovalLevel__c = OB_UtilityConstants.NEXI_PARTNER_APPROVER_L2_PROFILE_NAME;
            testOrder1.OB_CAB__c = '12345';
            testOrder1.OwnerId = groupId;
            insert testOrder1;
            NE__Order__c testOrder2 = OB_TestDataFactory.getOrder( testOrderHeader );
            testOrder2.OB_ApprovalLevel__c = OB_UtilityConstants.NEXI_PARTNER_APPROVER_L2_PROFILE_NAME;
            testOrder2.OB_CAB__c = '67890';
            testOrder2.OwnerId = groupId;
            insert testOrder2;

            Approval.ProcessResult approvalProcessResult1 = OB_TestDataFactory.getApprovalProcessResult( testOrder1 );
            Approval.ProcessResult approvalProcessResult2 = OB_TestDataFactory.getApprovalProcessResult( testOrder2 );
            
            //START gianluigi.virga 22/07/2019
            String filterValue = 'Draft - rejected pricing_InOrder';
            //END gianluigi.virga 22/07/2019

            Test.startTest( );
            List<Map<String, String>> testList = OB_ItemsToApprove_CC.retrieveItemsToApprove( testOrder1.OB_ABI__c, testCommunityUser.OB_CAB__c, filterValue );
            Test.stopTest( );
           
        }
    }

    /*******************************************************************************
    Purpose:  Method tests that returned list of maps is not empty - scenario - BIO Approval Type and Nexi Partner Approver L3
    
    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       Joanna Mielczarek   28/03/2019    Created    -
    ********************************************************************************/
    @isTest static void retrieveItemsToApproveTestVisibleBIO( )
    {
        User portalAccountOwner = OB_TestDataFactory.getPortalAccountOwner( );
	    insert portalAccountOwner;

        User testCommunityUser;
        System.runAs( portalAccountOwner )
        {
            Account testAccount = OB_TestDataFactory.getAccount( );
            testAccount.OwnerId = portalAccountOwner.Id;
            testAccount.RecordTypeId = ACCOUNT_RT_ID;
            Map<String, Schema.RecordTypeInfo> accountInfo = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( );
            testAccount.RecordTypeId = accountInfo.get( 'Merchant' ).getRecordTypeId( );
            insert testAccount;
            Contact testContact = OB_TestDataFactory.getContact( testAccount );
            insert testContact;
            testCommunityUser = OB_TestDataFactory.getCommunityUser( testContact );
            testCommunityUser.OB_CAB__c = null;
            testCommunityUser.ProfileId = OB_TestDataFactory.getNexiPartnerApproverL3Profile( ).Id;
            insert testCommunityUser;
    	}

        Id groupId = [ SELECT Id FROM Group WHERE Type = 'Queue' and Name = '05116 - Approvazione Pricing L3' ].Id;
        GroupMember testGroupMember = new GroupMember( UserOrGroupId = testCommunityUser.Id, GroupId = groupId );
        insert testGroupMember;

        System.runAs( testCommunityUser )
        {
            NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
            insert testOrderHeader;
            NE__Order__c testOrder = OB_TestDataFactory.getOrder( testOrderHeader );
            testOrder.OwnerId = groupId;
            testOrder.OB_CAB__c = '12345';
            testOrder.OB_ApprovalType__c = OB_UtilityConstants.APPROV_TYPE_BIO;
            testOrder.OB_ApprovalLevel__c = OB_UtilityConstants.NEXI_PARTNER_APPROVER_L3_PROFILE_NAME;
            testOrder.OB_BankApprovalStatus__c = OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_INAPPROVAZIONE;
            testOrder.OB_AdditionalDocumentationRequired__c = true;
            insert testOrder;

            Approval.ProcessResult approvalProcessResult = OB_TestDataFactory.getApprovalProcessResult( testOrder );
            //START gianluigi.virga 22/07/2019
            String filterValue = 'Draft - rejected pricing_InOrder';
            //END gianluigi.virga 22/07/2019
            Test.startTest( );
            List<Map<String, String>> testList = OB_ItemsToApprove_CC.retrieveItemsToApprove( testOrder.OB_ABI__c, testOrder.OB_CAB__c, filterValue );
            Test.stopTest( );

            
        }
    }

    /*******************************************************************************
    Purpose:  Method tests returning empty list of maps of single work items - scenario - there is no approval process
        
    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       Joanna Mielczarek   21/03/2019    Created    -
    ********************************************************************************/
    @isTest static void retrieveItemsToApproveTestNoApprovalProcess( )
    {
        User portalAccountOwner = OB_TestDataFactory.getPortalAccountOwner( );
        insert portalAccountOwner;

        User testCommunityUser;
        System.runAs( portalAccountOwner )
        {
            Account testAccount = OB_TestDataFactory.getAccount( );
            testAccount.OwnerId = portalAccountOwner.Id;
            testAccount.RecordTypeId = ACCOUNT_RT_ID;
            insert testAccount;
            Contact testContact = OB_TestDataFactory.getContact( testAccount );
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
            NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
            insert testOrderHeader;
            NE__Order__c testOrder = OB_TestDataFactory.getOrder( testOrderHeader );
            testOrder.OwnerId = groupId;
            testOrder.OB_CAB__c = testCommunityUser.OB_CAB__c;
            insert testOrder;
            //START gianluigi.virga 22/07/2019
            String filterValue = 'Draft - rejected pricing_InOrder';
            //END gianluigi.virga 22/07/2019
            Test.startTest( );
            List<Map<String, String>> testList = OB_ItemsToApprove_CC.retrieveItemsToApprove( testOrder.OB_ABI__c, testOrder.OB_CAB__c, filterValue );
            Test.stopTest( );
            System.assert( testList.isEmpty( ) );
        }
    }

    /*******************************************************************************
    Purpose:  Method tests returning empty list of maps of single work items - scenario - lack of NE__Order__c

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       Joanna Mielczarek   21/03/2019    Created    -
    ********************************************************************************/
    @isTest static void retrieveItemsToApproveTestLackOfOrder( )
    {
        User portalAccountOwner = OB_TestDataFactory.getPortalAccountOwner( );
        insert portalAccountOwner;

        User testCommunityUser;
        System.runAs( portalAccountOwner )
        {
            Account testAccount = OB_TestDataFactory.getAccount( );
            testAccount.OwnerId = portalAccountOwner.Id;
            testAccount.RecordTypeId = ACCOUNT_RT_ID;
            insert testAccount;
            Contact testContact = OB_TestDataFactory.getContact( testAccount );
            insert testContact;
            testCommunityUser = OB_TestDataFactory.getCommunityUser( testContact );
            testCommunityUser.ProfileId = OB_TestDataFactory.getNexiPartnerApproverL1Profile( ).Id;
            insert testCommunityUser;
        }
        System.runAs( testCommunityUser )
        {
            Test.startTest( );
            List<Map<String, String>> testList = OB_ItemsToApprove_CC.retrieveItemsToApprove( null, null, null );
            Test.stopTest( );
            System.assert( testList.isEmpty( ) );
        }
    }

    /*******************************************************************************
    Purpose:  Method tests returning list of maps of single work items - scenario -
              current user has different profile than Nexi Partner Approver L1 / L2

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       Joanna Mielczarek   26/03/2019    Created    -
    ********************************************************************************/
    @isTest static void retrieveItemsToApproveTestCurrentUserWithDifferentProfile( )
    {
        User portalAccountOwner = OB_TestDataFactory.getPortalAccountOwner( );
        insert portalAccountOwner;

        User testCommunityUser;
        System.runAs( portalAccountOwner )
            {
            Account testAccount = OB_TestDataFactory.getAccount( );
            testAccount.OwnerId = portalAccountOwner.Id;
            testAccount.RecordTypeId = ACCOUNT_RT_ID;
            insert testAccount;
            Contact testContact = OB_TestDataFactory.getContact( testAccount );
            insert testContact;
            testCommunityUser = OB_TestDataFactory.getCommunityUser( testContact );
            testCommunityUser.ProfileId = OB_TestDataFactory.getNexiPartnerUserProfile( ).Id ;
            insert testCommunityUser;
            }

        Id groupId = [ SELECT Id FROM Group WHERE Type = 'Queue' and Name = '05116 - Approvazione Pricing' ].Id;
        GroupMember testGroupMember = new GroupMember( UserOrGroupId = testCommunityUser.Id, GroupId = groupId );
        insert testGroupMember;

        System.runAs( testCommunityUser )
        {
            NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
            insert testOrderHeader;
            NE__Order__c testOrder = OB_TestDataFactory.getOrder( testOrderHeader );
            testOrder.OwnerId = groupId;
            insert testOrder;

            Approval.ProcessResult approvalProcessResult = OB_TestDataFactory.getApprovalProcessResult( testOrder );
            //START gianluigi.virga 22/07/2019
            String filterValue = 'Draft - rejected pricing_InOrder';
            //END gianluigi.virga 22/07/2019
            Test.startTest( );
            List<Map<String, String>> testList = OB_ItemsToApprove_CC.retrieveItemsToApprove( testOrder.OB_ABI__c, testOrder.OB_CAB__c, filterValue );
            Test.stopTest( );
            
        }
    }

    /*******************************************************************************
    Purpose:  Method tests that returned list of orders approval is not empty
              - scenario - single CAB and Nexi Partner Approver L1
    
    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       Joanna Mielczarek   21/03/2019    Created    -
    2.0       Giovanni Spinelli   22/07/2019    change    -
    ********************************************************************************/
    @isTest static void retrieveConfigurationApprovalTestSingleCAB( )
    {
        //giovanni spinelli - start - 22/07/2019 - run as portalAccountOwner
        User portalAccountOwner = OB_TestDataFactory.getPortalAccountOwner( );
        insert portalAccountOwner;
        User testCommunityUser;
        System.runAs( portalAccountOwner )
        {
            Account testAccount = OB_TestDataFactory.getAccount( );
            testAccount.RecordTypeId = ACCOUNT_RT_ID;
            insert testAccount;
            Contact testContact = OB_TestDataFactory.getContact( testAccount );
            insert testContact;
            testCommunityUser = OB_TestDataFactory.getCommunityUser( testContact );
            testCommunityUser.ProfileId = OB_TestDataFactory.getNexiPartnerApproverL1Profile( ).Id;
            insert testCommunityUser;
        }
        //giovanni spinelli - end - 22/07/2019 - run as portalAccountOwner
        System.runAs( testCommunityUser )
        {
            NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
            testOrderHeader.OB_Main_Process__c = 'Setup';
            testOrderHeader.OB_Sub_Process__c = 'variazione operativa';
            insert testOrderHeader;
            NE__Order__c testOrder = OB_TestDataFactory.getOrder( testOrderHeader );
            testOrder.OB_ApprovalType__c = OB_UtilityConstants.BIO;
            testOrder.OB_AgreedChanges__c = true;
            testOrder.OB_BankApprovalStatus__c = OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_INAPPROVAZIONE;
            testOrder.OB_CAB__c = testCommunityUser.OB_CAB__c;
            testOrder.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_TOAPPROVE;
            testOrder.OB_Bank_OrderStatus__c = 'Draft - rejected pricing';
            testOrder.NE__Type__c = 'InOrder';
            insert testOrder;
            //START gianluigi.virga 22/07/2019
            String filterValue = 'Draft - rejected pricing_InOrder';
            //END gianluigi.virga 22/07/2019
            Test.startTest( );
            List<NE__Order__c> testList = OB_ItemsToApprove_CC.retrieveConfigurationApproval( testOrder.OB_ABI__c, testCommunityUser.OB_CAB__c, filterValue );
            Test.stopTest( );
            System.assertEquals( 1, testList.size( ) );
        }
    }

    /*******************************************************************************
    Purpose:  Method tests that returned list of orders approval has expected size
              - scenario - multi CAB and Nexi Partner Approver L2
    
    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       Joanna Mielczarek   21/03/2019    Created    -
    2.0       Giovanni Spinelli   22/07/2019    change    -
    ********************************************************************************/
    @isTest static void retrieveConfigurationApprovalTestMultiCAB( )
    {
        //giovanni spinelli - start - 22/07/2019 - run as portalAccountOwner
        User portalAccountOwner = OB_TestDataFactory.getPortalAccountOwner( );
        insert portalAccountOwner;
        User testCommunityUser;
        System.runAs( portalAccountOwner )
        {
            Account testAccount = OB_TestDataFactory.getAccount( );
            testAccount.RecordTypeId = ACCOUNT_RT_ID;
            insert testAccount;
            Contact testContact = OB_TestDataFactory.getContact( testAccount );
            insert testContact;
            testCommunityUser = OB_TestDataFactory.getCommunityUser( testContact );
            testCommunityUser.OB_CAB__c = '12345;67890';
            testCommunityUser.ProfileId = OB_TestDataFactory.getNexiPartnerApproverL2Profile( ).Id;
            insert testCommunityUser;
        }
         //giovanni spinelli - end - 22/07/2019 - run as portalAccountOwner
        System.runAs( testCommunityUser )
        {
            NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
            testOrderHeader.OB_Main_Process__c = 'Setup';
            testOrderHeader.OB_Sub_Process__c = 'variazione operativa';
            insert testOrderHeader;
            NE__Order__c testOrder1 = OB_TestDataFactory.getOrder( testOrderHeader );
            testOrder1.OB_CAB__c = '12345';
            testOrder1.OB_ApprovalType__c = OB_UtilityConstants.BIO;
            testOrder1.OB_AgreedChanges__c = true;
            testOrder1.OB_BankApprovalStatus__c = OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_INAPPROVAZIONE;
            testOrder1.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_TOAPPROVE;
            insert testOrder1;
            NE__Order__c testOrder2 = OB_TestDataFactory.getOrder( testOrderHeader );
            testOrder2.OB_CAB__c = '67890';
            testOrder2.OB_ApprovalType__c = 'BIO';
            testOrder2.OB_AgreedChanges__c = true;
            testOrder2.OB_BankApprovalStatus__c = OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_INAPPROVAZIONE;
            testOrder2.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_TOAPPROVE;
            insert testOrder2;
            Test.startTest( );
            List<NE__Order__c> testList = OB_ItemsToApprove_CC.retrieveConfigurationApproval( testOrder1.OB_ABI__c, testCommunityUser.OB_CAB__c, null );
            Test.stopTest( );
            System.assertEquals( 2, testList.size( ) );
        }
    }
    
    /*******************************************************************************
    Purpose:  Method tests that returned empty list of orders approval - scenario - lack of NE__Order__c
    
    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       Joanna Mielczarek   21/03/2019    Created    -
     
    2.0       Giovanni Spinelli   22/07/2019    change    -
    ********************************************************************************/
    @isTest static void retrieveConfigurationApprovalTestLackOfOrder( )
    {
        //giovanni spinelli - start - 22/07/2019 - run as portalAccountOwner
        User portalAccountOwner = OB_TestDataFactory.getPortalAccountOwner( );
        insert portalAccountOwner;
        User testCommunityUser;
        System.runAs( portalAccountOwner )
        {
            Account testAccount = OB_TestDataFactory.getAccount( );
            testAccount.RecordTypeId = ACCOUNT_RT_ID;
            insert testAccount;
            Contact testContact = OB_TestDataFactory.getContact( testAccount );
            insert testContact;
            testCommunityUser = OB_TestDataFactory.getCommunityUser( testContact );
            testCommunityUser.ProfileId = OB_TestDataFactory.getNexiPartnerApproverL1Profile( ).Id; //R1F2_28 joanna.mielczarek@accenture.com fix
            insert testCommunityUser;
        }
        //giovanni spinelli - end - 22/07/2019 - run as portalAccountOwner
        System.runAs( testCommunityUser )
        {
            Test.startTest( );
            List<NE__Order__c> testList = OB_ItemsToApprove_CC.retrieveConfigurationApproval( null, null, null );
            Test.stopTest( );
            System.assert( testList.isEmpty( ) );
        }
    }

    /**
    *@author Grzegorz Banach <grzegorz.banach@accenture.com>
    *@date 25/03/2019
    *@description Method tests retrieveHistoricWizardData
    */
    @isTest
    static void retrieveHistoricWizardDataTest( )
    {
        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        insert testOrderHeader;

        NE__Order__c testOrder = OB_TestDataFactory.getOrder( testOrderHeader );
        testOrder.OB_BankApprovalStatus__c = OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_RIGETTATO; // NEX-006 joanna.mielczarek@accenture.com 26/03/2019
        insert testOrder;

        bit2flow__Wizard_Definition__c testWizard = OB_TestDataFactory.getWizardDefinition( );
        insert testWizard;

        bit2flow__Historic_Wizard_Data__c testHistoricFlow = OB_TestDataFactory.getHistoricWizard( testWizard.Id );
        testHistoricFlow.OB_OrderHeaderId__c = testOrderHeader.Id;
        insert testHistoricFlow;

        Map<String, String> resultMap = OB_ItemsToApprove_CC.retrieveHistoricWizardData( new List<NE__Order__c> {testOrder} );
        System.debug( resultMap );
    }

    /**
    *@author Grzegorz Banach <grzegorz.banach@accenture.com>
    *@date 25/03/2019
    *@description Method tests changeOrderStatusServer
    */
    @isTest
    static void changeOrderStatusServerTest( )
    {
        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        insert testOrderHeader;

        NE__Order__c testOrder = OB_TestDataFactory.getOrder( testOrderHeader );
        insert testOrder;

        NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
        insert testOrderItem;
        //16/04/19 francesca.ribezzi adding UserInfo.getUserId() new parameter:
        Boolean statusSuccessfullyChanged = OB_ItemsToApprove_CC.changeOrderStatusServer( testOrder.Id, UserInfo.getUserId( ) );
        System.assert( statusSuccessfullyChanged );
    }

    /**
    *@author Grzegorz Banach <grzegorz.banach@accenture.com>
    *@date 25/03/2019
    *@description Method tests changeOrderStatusServer
    */
    @isTest
    static void changeOrderStatusServerTestNullArgument( )
    {
        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        insert testOrderHeader;
        //START 16/04/19 francesca.ribezzi adding a null new parameters
        Boolean statusSuccessfullyChanged = OB_ItemsToApprove_CC.changeOrderStatusServer( null, null );
        System.assert( !statusSuccessfullyChanged );
        //END 16/04/19 francesca.ribezzi
    }

    /**
    *@author Grzegorz Banach <grzegorz.banach@accenture.com>
    *@date 25/03/2019
    *@description Method tests changeJumpToStepHistoricAttachment
    */
    @isTest
    static void changeJumpToStepHistoricAttachmentTest( )
    {
        bit2flow__Wizard_Definition__c testWizard = OB_TestDataFactory.getWizardDefinition( );
        insert testWizard;

        bit2flow__Historic_Wizard_Data__c testHistoricFlow = OB_TestDataFactory.getHistoricWizard( testWizard.Id );
        insert testHistoricFlow;

        Attachment testAttachment = new Attachment( );
        testAttachment.Name = Label.OB_dataJSON; //antonio.vatrano 11/06/2019 r1f2-241
        testAttachment.Body = Blob.valueOf( '{"JumpToStep":"3"}' );
        testAttachment.ParentId = testHistoricFlow.Id;
        insert testAttachment;

        Id resultHistoricWizardId = OB_ItemsToApprove_CC.changeJumpToStepHistoricAttachment( testHistoricFlow.Id );
        System.assertEquals( testHistoricFlow.Id, resultHistoricWizardId );
    }

    /**
    *@author Grzegorz Banach <grzegorz.banach@accenture.com>
    *@date 25/03/2019
    *@description Method tests changeJumpToStepHistoricAttachment - attachment body contains invalid data scenario
    */
    @isTest
    static void changeJumpToStepHistoricAttachmentTestInvalidBody( )
    {
        bit2flow__Wizard_Definition__c testWizard = OB_TestDataFactory.getWizardDefinition( );
        insert testWizard;

        bit2flow__Historic_Wizard_Data__c testHistoricFlow = OB_TestDataFactory.getHistoricWizard( testWizard.Id );
        insert testHistoricFlow;

        Attachment testAttachment = new Attachment( );
        testAttachment.Name = 'Test Attachment';
        testAttachment.Body = Blob.valueOf( '{"BrokenJSON": null}' );
        testAttachment.ParentId = testHistoricFlow.Id;
        insert testAttachment;

        Id resultHistoricWizardId = OB_ItemsToApprove_CC.changeJumpToStepHistoricAttachment( testHistoricFlow.Id );
        System.assertEquals( null, resultHistoricWizardId );
    }

    /**
    *@author Grzegorz Banach <grzegorz.banach@accenture.com>
    *@date 25/03/2019
    *@description Method tests changeJumpToStepHistoricAttachment - invalid Historic Wizard id scenario ( e.g. null )
    */
    @isTest
    static void changeJumpToStepHistoricAttachmentTestInvalidId( )
    {
        Id resultHistoricWizardId = OB_ItemsToApprove_CC.changeJumpToStepHistoricAttachment( null );
        System.assertEquals( null, resultHistoricWizardId );
    }

    /**
    *@author Joanna Mielczarek <joanna.mielczarek@accenture.com>
    *@date 26/03/2019
    *@description Method tests changeJumpToStepHistoricAttachment - broken body scenario
    */
    @isTest
    static void changeJumpToStepHistoricAttachmentTestBrokenBody( )
    {
        bit2flow__Wizard_Definition__c testWizard = OB_TestDataFactory.getWizardDefinition( );
        insert testWizard;

        bit2flow__Historic_Wizard_Data__c testHistoricFlow = OB_TestDataFactory.getHistoricWizard( testWizard.Id );
        insert testHistoricFlow;

        Attachment testAttachment = new Attachment( );
        testAttachment.Name = 'Test Attachment';
        testAttachment.Body = Blob.valueOf( '{"BrokenJSON": null' );
        testAttachment.ParentId = testHistoricFlow.Id;
        insert testAttachment;

        Id resultHistoricWizardId = OB_ItemsToApprove_CC.changeJumpToStepHistoricAttachment( testHistoricFlow.Id );
        System.assertEquals( null, resultHistoricWizardId );
    }

    /**
    *@author Grzegorz Banach <grzegorz.banach@accenture.com>
    *@date 25/03/2019
    *@description Method tests cancelPricingOperation
    */
    @isTest
    static void cancelPricingOperationTest( )
    {
        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        insert testOrderHeader;
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( testOrderHeader );
        insert testOrder;

        Boolean operationPerformed = OB_ItemsToApprove_CC.cancelPricingOperation( testOrder.Id );
        System.assert( operationPerformed );
    }

    /**
    *@author Grzegorz Banach <grzegorz.banach@accenture.com>
    *@date 25/03/2019
    *@description Method tests cancelPricingOperation - exception due to invalid id scenario
    */
    @isTest
    static void cancelPricingOperationTest_Exception( )
    {
        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        insert testOrderHeader;

        Boolean operationPerformed = OB_ItemsToApprove_CC.cancelPricingOperation( testOrderHeader.Id );
        System.assert( !operationPerformed );
    }

    /**
    *@author Grzegorz Banach <grzegorz.banach@accenture.com>
    *@date 25/03/2019
    *@description Method tests cancelOrderAndChildren
    */
    @isTest
    static void cancelOrderAndChildrenTest( )
    {
        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        insert testOrderHeader;

        NE__Order__c testOrder = OB_TestDataFactory.getOrder( testOrderHeader );
        testOrder.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_DRAFT;
        insert testOrder;

        NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
        insert testOrderItem;

        OB_ItemsToApprove_CC.cancelOrderAndChildren( testOrder.Id );

        List<NE__Order__c> resultOrders =
        [
                SELECT OB_FulfilmentStatus__c
                FROM NE__Order__c
                WHERE Id = :testOrder.Id
        ];
        System.assertEquals( OB_UtilityConstants.FULFILMENTSTATUS_CANCELLED, resultOrders.get( 0 ).OB_FulfilmentStatus__c );
    }

    /**
    *@author Grzegorz Banach <grzegorz.banach@accenture.com>
    *@date 25/03/2019
    *@description Method tests launchMaintenanceWizard
    */
    @isTest
    static void launchMaintenanceWizardTest( )
    {
        bit2flow__Wizard_Definition__c testWizard = OB_TestDataFactory.getWizardDefinition( );
        insert testWizard;

        Attachment testAttachment = new Attachment( );
        testAttachment.Name = 'Test Attachment';
        testAttachment.Body = Blob.valueOf( '' );
        testAttachment.ParentId = testWizard.Id;
        insert testAttachment;

        String resultAttachmentId = OB_ItemsToApprove_CC.launchMaintenanceWizard( testWizard.bit2flow__Name__c );
        System.assertEquals( testAttachment.Id, resultAttachmentId );
    }

    /**
    *@author Grzegorz Banach <grzegorz.banach@accenture.com>
    *@date 25/03/2019
    *@description Method tests callResubmitBIO
    */
    @isTest
    public static void callResubmitBIOTest( )
    {
        Id recordTypeIdBank = Schema.SObjectType.Account.getRecordTypeInfosByName( ).get( OB_UtilityConstants.BANKRT ).getRecordTypeId( );

        Account testAccount = OB_TestDataFactory.getAccount( );
        testAccount.RecordTypeId = recordTypeIdBank;
        insert testAccount;

        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        testOrderHeader.OB_ProposerABI__c = testAccount.Id;
        insert testOrderHeader;

        NE__Order__c testOrder = OB_TestDataFactory.getOrder( testOrderHeader );
        insert testOrder;

        Boolean operationPerformed = OB_ItemsToApprove_CC.callResubmitBIO( testOrder.id );
        System.assert( operationPerformed );
    }

    /*******************************************************************************
    Purpose:  Method tests setting status of order when somebody click 'redifine prices' - success scenario

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       Joanna Mielczarek   30/04/2019    Created    NEXI-20_order_status_handleLogic
    ********************************************************************************/
    @isTest static void setOrderStatusDraftSuccess( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        testOrder.OB_Nexi_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_DRAFT_INCOMPLETE_ORDER;
        insert testOrder;

        OB_ItemsToApprove_CC.setOrderStatusDraft( testOrder.Id );
        List<NE__Order__c> testOrders =
        [
                SELECT Id, OB_Nexi_OrderStatus__c
                FROM NE__Order__c
                WHERE Id = :testOrder.Id
        ];
        System.assertEquals( OB_Order_ChangeStatus.ORDER_STATUS_DRAFT, testOrders.get( 0 ).OB_Nexi_OrderStatus__c );
    }

    /*******************************************************************************
    Purpose:  Method tests setting status of order when somebody click 'resume agreement' - failed scenario
        
    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       Joanna Mielczarek   30/04/2019    Created    NEXI-20_order_status_handleLogic
    ********************************************************************************/
    @isTest static void setOrderStatusDraftFailed( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );

        OB_ItemsToApprove_CC.setOrderStatusDraft( testOrder.Id );
        List<NE__Order__c> testOrders =
        [
                SELECT Id
                FROM NE__Order__c
                WHERE OB_Nexi_OrderStatus__c = :OB_Order_ChangeStatus.ORDER_STATUS_DRAFT
        ];
        System.assertEquals( 0, testOrders.size( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests setting status of order when somebody click 'resume agreement' - success scenario

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       Joanna Mielczarek   29/04/2019    Created    NEXI-20_order_status_handleLogic
    ********************************************************************************/
    @isTest static void setOrderStatusDraftIncompleteOrderSuccess( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        insert testOrder;

        OB_ItemsToApprove_CC.setOrderStatusDraftIncompleteOrder( testOrder.Id );
        List<NE__Order__c> testOrders =
        [
                SELECT Id, OB_Nexi_OrderStatus__c
                FROM NE__Order__c
                WHERE Id = :testOrder.Id
        ];
        System.assertEquals( OB_Order_ChangeStatus.ORDER_STATUS_DRAFT_INCOMPLETE_ORDER, testOrders.get( 0 ).OB_Nexi_OrderStatus__c );
    }

    /*******************************************************************************
    Purpose:  Method tests setting status of order when somebody click 'resume agreement' - failed scenario

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       Joanna Mielczarek   29/04/2019    Created    NEXI-20_order_status_handleLogic
    ********************************************************************************/
    @isTest static void setOrderStatusDraftIncompleteOrderFailed( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );

        OB_ItemsToApprove_CC.setOrderStatusDraftIncompleteOrder( testOrder.Id );
        List<NE__Order__c> testOrders =
        [
                SELECT Id
                FROM NE__Order__c
                WHERE OB_Nexi_OrderStatus__c = :OB_Order_ChangeStatus.ORDER_STATUS_DRAFT_INCOMPLETE_ORDER
        ];
        System.assertEquals( 0, testOrders.size( ) );
    }
    /*******************************************************************************
    Purpose:  method to test getAccountInfo

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       giovanni spinelli   29/04/2019    Created    
    ********************************************************************************/
    @isTest 
    static void getAccountInfo_Test(){

        String merchantId ;
        String contextABI;
        String merchantRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'merchant' AND SobjectType = 'Account' LIMIT 1].Id;		        
		Account merchant = new Account(Name = 'merchant name', RecordTypeId = merchantRecordTypeId, OB_Employees_Number__c = 'Minore di 10', NE__Fiscal_code__c = 'AAAAAA11A11A111A', OB_VAT_Not_Present__c = true, OB_DescriptionVATNotPresent__c = 'desc');
		insert merchant;
        List<Account> accList= new List<Account>();
        accList.add(merchant);
        Map<String ,Object> resultData = new Map<String ,Object>();
        resultData.put('merchant', accList.get(0));
        
        Test.startTest();
        OB_ItemsToApprove_CC.getAccountInfo(merchant.Id, contextABI);
        Test.stopTest();    
    }

    /*******************************************************************************
    Purpose:  method to test getMapsOfSingleWorkItem

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       gianluigi.virga     22/07/2019    Created    Created test for a method method not covered
    ********************************************************************************/
    @isTest 
    static void getMapsOfSingleWorkItem_Test(){
        Map<String, NE__Order__c> mapOfConfigurations = new Map<String, NE__Order__c>();
        List<ProcessInstanceWorkitem> listOfProcessInstanceWorkitem = new List<ProcessInstanceWorkitem>();
        Test.startTest();
        OB_ItemsToApprove_CC.getMapsOfSingleWorkItem(mapOfConfigurations, listOfProcessInstanceWorkitem);
        Test.stopTest(); 
    }
    /*******************************************************************************
    Purpose:  

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       Giovanni spinelli   30/07/2019    Created    -
    ********************************************************************************/
    @isTest 
    static void retrieveComments_Test( ){
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        insert testOrder;
        List<Id> idList = new List<Id>();
        idList.add(testOrder.id);
        Test.startTest();
        OB_ItemsToApprove_CC.retrieveComments(idList);
        Test.stopTest(); 

    }
}