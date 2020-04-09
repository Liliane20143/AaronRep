/*******************************************************************************
Purpose:  Class that is test for OB_Maintenance_AttachedDocs_CC

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         Joanna Mielczarek       03/07/2019      Created         NEXI-143
********************************************************************************/
@isTest
public with sharing class OB_Maintenance_AttachedDocs_CC_Test 
{

    /*******************************************************************************
    Purpose:  Method prepares User
    Parameters: -
    Returns: User

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       22/06/2019      Created         NEXI-60
    1.1         Joanna Mielczarek       02/07/2019      Modified        NEXI-143 create community user as admin
    ********************************************************************************/
    private static User getUser( )
    {
        User portalAccountOwner = OB_TestDataFactory.getPortalAccountOwner( );
        insert portalAccountOwner;

        User testCommunityUser;

        System.runAs( portalAccountOwner )
        {
            Account testAccount = OB_TestDataFactory.getAccount( );
            testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName( ).get( OB_UtilityConstants.ACC_RT_MERCHANT ).getRecordTypeId( );
            insert testAccount;
            Contact testContact = OB_TestDataFactory.getContact( testAccount );
            insert testContact;
            testCommunityUser = OB_TestDataFactory.getCommunityUser( testContact );
            testCommunityUser.ProfileId = OB_TestDataFactory.getNexiPartnerUserProfile( ).Id;
            insert testCommunityUser;
        }
        return testCommunityUser;
    }

    /*******************************************************************************
    Purpose:  Method prepares LogRequest to getProductDocumentsServer method
    Parameters: -
    Returns: OB_LogRequest__c

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       22/06/2019      Created         NEXI-60
    ********************************************************************************/
    private static OB_LogRequest__c getLogRequest( )
    {
        Account aAccount = OB_TestDataFactory.getAccount( );
        insert aAccount;

        OB_LogRequest__c logRequest = OB_TestDataFactory.getLogRequest( );
        logRequest.OB_AccountId__c = aAccount.Id;

        Map<String, List<Sobject>> newDataMap = new Map<String, List<Sobject>>( );
        newDataMap.put( 'obj', new List<Sobject> {aAccount} );
        Map<String, List<Sobject>> oldDataMap = new Map<String, List<Sobject>>( );
        oldDataMap.put( 'obj', new List<Sobject> {aAccount} );

        logRequest.OB_ReducedOldData__c = JSON.serialize( oldDataMap );
        logRequest.OB_ReducedNewData__c = JSON.serialize( newDataMap );
        logRequest.OB_ChangeCompanyData__c = true;
        logRequest.OB_Change_of_data_of_beneficial_owners__c = true;
        insert logRequest;

        return logRequest;
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_AttachedDocs_CC.retrieveInfos.

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0           ?     				   ? 		     Created          ?
    1.1         Joanna Mielczarek       22/06/2019      Modified        NEXI-60 use TestDataFactory, add assertion
    1.2         Joanna Mielczarek       02/07/2019      Modified        NEXI-143 create objects as community user
    ********************************************************************************/
    @isTest
    private static void retrieveInfosTest( )
    {
        // NEXI-60 <joanna.mielczarek@accenture.com> - just covered method to increase CC

        User communityUser = getUser( );
        System.runAs( communityUser )
        {
            NE__Service_Point__c sServicePoint = OB_TestDataFactory.getServicePoint( );
            insert sServicePoint;
            OB_LogRequest__c logRequest = new OB_LogRequest__c( );
            logRequest.OB_AccountId__c = communityUser.Contact.AccountId;
            logRequest.OB_ServicePointId__c = sServicePoint.Id;
            insert logRequest;

            Test.startTest( );
            Map<String, String> result = OB_Maintenance_AttachedDocs_CC.retrieveInfos( logRequest.Id );
            Test.stopTest( );

            System.assert( !result.isEmpty( ) );
        }
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_AttachedDocs_CC.getProductDocumentsServer.

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0           ?     				   ? 		     Created          ?
    1.1         Joanna Mielczarek       22/06/2019      Modified        NEXI-60 use TestDataFactory, added missing params
    1.2         Joanna Mielczarek       02/07/2019      Modified        NEXI-143 create objects as community user
   ********************************************************************************/
    @isTest
    public static void getProductDocumentsServerTest1( )
    {
        // NEXI-60 <joanna.mielczarek@accenture.com> - just covered method to increase CC

        User testCommunityUser = getUser( );
        System.runAs( testCommunityUser )
        {
            Account bankAccount = OB_TestDataFactory.getAccount( );
            bankAccount.RecordTypeId = [ SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'Bank' LIMIT 1 ].Id;
            insert bankAccount;

            NE__Service_Point__c sServicePoint = OB_TestDataFactory.getServicePoint( );
            insert sServicePoint;

            NE__Order_Header__c oOrderHeader = OB_TestDataFactory.getOrderHeader( );
            oOrderHeader.NE__AccountId__c = testCommunityUser.Contact.AccountId;
            oOrderHeader.OB_Main_Process__c = 'Setup';
            insert oOrderHeader;
            String orderHeaderId = oOrderHeader.Id;

            OB_Special_Category_Configuration__c specialCategoryConfiguration = new OB_Special_Category_Configuration__c( );
            specialCategoryConfiguration.OB_DocRequired__c = true;
            specialCategoryConfiguration.OB_ATECO__c = 'Gambling';
            specialCategoryConfiguration.OB_MCC__c = 'Gambling';
            insert specialCategoryConfiguration;

            NE__Order__c oOrder = OB_TestDataFactory.getOrder( oOrderHeader );
            oOrder.OB_MCC__c = '0511';
            insert oOrder;

            NE__Product__c product = new NE__Product__c( OB_Contract_Type__c = 'Test' );
            insert product;

            NE__OrderItem__c oOrderItem = OB_TestDataFactory.getOrderItem( oOrder.Id );
            oOrderItem.NE__Qty__c = 1;
            oOrderItem.NE__ProdId__c = product.Id;
            insert oOrderItem;

            OB_Product_Document__c document = new OB_Product_Document__c( );
            document.Name = 'Documento 2';
            document.OB_Commercial_Product__c = product.Id;
            document.OB_Business_Model__c = 'Bancario';
            document.OB_Client_Type__c = 'Gambling';
            document.OB_Request_Typology__c = 'Setup';
            document.OB_Client_Type__c = 'Gambling';
            document.OB_Request_Typology__c = 'Setup';
            insert document;

            OB_LogRequest__c logRequest = new OB_LogRequest__c( );
            logRequest.OB_AccountId__c = testCommunityUser.Contact.AccountId;
            logRequest.OB_ABI__c = testCommunityUser.OB_ABI__c;
            logRequest.OB_ServicePointId__c = sServicePoint.Id;
            logRequest.OB_ReducedNewData__c = '{"obj":[{"attributes":{"type":"Account"}, "OB_Legal_Form__c":"OB_Legal_Form__cValue", "OB_MCC__c" : "1234"}]}';
            insert logRequest;

            Test.startTest( );
            Map<String, String> result = OB_Maintenance_AttachedDocs_CC.getProductDocumentsServer( logRequest.Id, false, false );
            Test.stopTest( );

            System.assertEquals( new Map<String, String>( ), result );
        }
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_AttachedDocs_CC.getProductDocumentsServer.

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0           ?     				   ? 		     Created          ?
    1.1         Joanna Mielczarek       22/06/2019      Modified        NEXI-60 added param to method
   ********************************************************************************/
    @isTest
    public static void getProductDocumentsServerTest2( )
    {
        // NEXI-60 <joanna.mielczarek@accenture.com> - just covered method to increase CC

        Account aAccount = OB_TestDataFactory.getAccount( );
        insert aAccount;

        Account bank = OB_TestDataFactory.getAccount( );
        bank.RecordTypeId = [ SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'Bank' LIMIT 1 ].Id;
        insert bank;

        NE__Service_Point__c sServicePoint = OB_TestDataFactory.getServicePoint( );
        insert sServicePoint;

        OB_LogRequest__c logRequest = new OB_LogRequest__c( );
        logRequest.OB_ServicePointId__c = sServicePoint.id;
        logRequest.OB_AccountId__c = aAccount.id;
        logRequest.OB_ABI__c = bank.OB_ABI__c;
        logRequest.OB_ChangeMerchantName__c = true;
        logRequest.OB_ChangeCompanyData__c = true;
        logRequest.OB_ChangeLegalForm__c = true;
        logRequest.OB_NewLegalRepresentative__c = true;
        logRequest.OB_ChangeLegalRepresentative__c = true;
        logRequest.OB_ChangeServicePointData__c = true;
        Map<String, List<Sobject>> newDataMap = new Map<String, List<Sobject>>( );
        newDataMap.put( 'obj', new List<Sobject> {aAccount} );
        Map<String, List<Sobject>> oldDataMap = new Map<String, List<Sobject>>( );
        oldDataMap.put( 'obj', new List<Sobject> {aAccount} );
        logRequest.OB_ReducedOldData__c = JSON.serialize( oldDataMap );
        logRequest.OB_ReducedNewData__c = JSON.serialize( newDataMap );
        insert logRequest;

        OB_Bank_Profile__c bankProfile = new OB_Bank_Profile__c( );
        bankProfile.OB_Bank__c = bank.Id;
        bankProfile.OB_Service_Type__c = 'Acquiring';
        bankProfile.OB_Business_Model_POS__c = 'Bilaterale';
        bankProfile.OB_Circuit__c = 'JCB';
        bankProfile.OB_Other_Acquirer__c = 'Amex';
        bankProfile.OB_Applicant_RAC_Code_SIA__c = 'Banca';
        bankProfile.OB_Terminal_Id_Generator__c = 'Banca';
        bankProfile.OB_Technical_component_invoicing__c = 'Al p.v.';
        bankProfile.OB_GT__c = 'Nexi';
        bankProfile.OB_Processor__c = 'SIA SMAC';
        bankProfile.OB_Bilateral_Pricing__c = 'SI';
        bankProfile.OB_Sending_Contract_to_Nexi__c = 'SI';
        bankProfile.OB_SME_Factory__c = 'SI';
        insert bankProfile;

        OB_Product_Document__c document = new OB_Product_Document__c( );
        document.OB_Request_Typology__c = 'Maintenance';
        document.OB_Client_Type__c = 'ctype';
        insert document;

        OB_Special_Category_Configuration__c specialCategoryConfiguration = new OB_Special_Category_Configuration__c( );
        specialCategoryConfiguration.Name = 'ctype';
        specialCategoryConfiguration.OB_RequestType__c = 'Maintenance';
        specialCategoryConfiguration.OB_DocRequired__c = true;
        specialCategoryConfiguration.RecordTypeId = [ SELECT Id FROM RecordType WHERE SObjectType = 'OB_Special_Category_Configuration__c' AND DeveloperName = 'OB_MCC_OR_ATECO' LIMIT 1 ].id;
        specialCategoryConfiguration.OB_ATECO__c = 'testATECO';
        insert specialCategoryConfiguration;

        NE__Lov__c lov = new NE__Lov__c( );
        lov.NE__Value3__c = 'testATECO';
        lov.NE__Type__c = 'ATECO';
        lov.NE__Active__c = true;
        lov.Name = '1234567';
        insert lov;

        Test.startTest( );
        Map<String, String> result = OB_Maintenance_AttachedDocs_CC.getProductDocumentsServer( logRequest.Id, false, false );
        Test.stopTest( );

        System.assertEquals( new Map<String, String>( ), result );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_AttachedDocs_CC.serverGetDocumentListId - success scnario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       22/06/2019      Created        NEXI-60
   ********************************************************************************/
    @isTest
    private static void serverGetDocumentListIdTest( )
    {
        // NEXI-60 <joanna.mielczarek@accenture.com> - just covered method to increase CC

        Account bankOwner = OB_TestDataFactory.getAccount( );
        insert bankOwner;

        NE__Service_Point__c sServicePoint = OB_TestDataFactory.getServicePoint( );
        insert sServicePoint;

        OB_LogRequest__c logRequest = new OB_LogRequest__c( );
        logRequest.OB_AccountId__c = bankOwner.Id;
        logRequest.OB_ServicePointId__c = sServicePoint.Id;
        insert logRequest;

        OB_Integration_Configuration__c integrationConfiguration = new OB_Integration_Configuration__c( );
        integrationConfiguration.Name = 'DEV1';
        integrationConfiguration.OB_Token_1__c = 'eyJ0eXAiOiJKV1QiLCJjdHkiOiJKV1QiLCJhbGciOiJSU0EtT0' +
                'FFUCIsImVuYyI6IkExMjhDQkMtSFMyNTYifQ.ae0uhFv92QHdZMIxqofDkYrOwRH2dR7Axkni1Xzu1_dhE1ohL1lTp' +
                '-2pyZ4O-QBnVNV7ulihyTc9DlVbMixGa813SFxwpAjIMrhqnG_xHQVnMLyi2-wE3dXZQcuwmw8NeqBM2Kg92NVpKAD' +
                'dcAEoQ7RAhxL0LJGuyhLJBXgZ';
        integrationConfiguration.OB_Timestamp__c = '1542025783107';
        insert integrationConfiguration;
        Test.setMock( HttpCalloutMock.class, new MockGetCadastrialCode( ) );

        Test.startTest( );
        String result = OB_Maintenance_AttachedDocs_CC.serverGetDocumentListId( logRequest.Id );
        Test.stopTest( );

        System.assert( !String.isEmpty( result ) );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_AttachedDocs_CC.retrieveLogRequests - success scnario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       22/06/2019      Created        NEXI-60
   ********************************************************************************/
    @isTest
    private static void retrieveLogRequestsTest( )
    {
        // NEXI-60 <joanna.mielczarek@accenture.com> - just covered method to increase CC

        OB_LogRequest__c logRequest = getLogRequest( );

        Test.startTest( );
        List<OB_LogRequest__c> result = OB_Maintenance_AttachedDocs_CC.retrieveLogRequests( logRequest.Id );
        Test.stopTest( );

        System.assert( !result.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_AttachedDocs_CC.getProductDocumentsServer.
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       10/06/2019      Created         NEXI-97
    1.1         Joanna Mielczarek       22/06/2019      Modified        NEXI-60 added param to method
   ********************************************************************************/
    @isTest
    private static void getProductDocumentsServerSaeAtecoTest( )
    {
        OB_LogRequest__c logRequest = getLogRequest( );

        Test.startTest( );
        OB_Maintenance_AttachedDocs_CC.getProductDocumentsServer( logRequest.Id, true, false );
        Test.stopTest( );

        System.assertEquals( new Map<String, String>( ), OB_Maintenance_AttachedDocs_CC.getProductDocumentsServer( logRequest.Id, true, false ) );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_AttachedDocs_CC.getProductDocumentsServer - success scnario - single param method

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       22/06/2019      Created        NEXI-60
   ********************************************************************************/
    @isTest
    private static void getProductDocumentsServerSingleParamTest( )
    {
        OB_LogRequest__c logRequest = getLogRequest( );

        Test.startTest( );
        OB_Maintenance_AttachedDocs_CC.getProductDocumentsServer( logRequest.Id );
        Test.stopTest( );

        System.assertEquals( new Map<String, String>( ), OB_Maintenance_AttachedDocs_CC.getProductDocumentsServer( logRequest.Id, true, false ) );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_AttachedDocs_CC.getProductDocumentsServer - success scnario & is Titolari Effettivo

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       22/06/2019      Created        NEXI-60
   ********************************************************************************/
    @isTest
    private static void getProductDocumentsServerTETest( )
    {
        OB_LogRequest__c logRequest = getLogRequest( );

        Test.startTest( );
        OB_Maintenance_AttachedDocs_CC.getProductDocumentsServer( logRequest.Id, false, true );
        Test.stopTest( );

        System.assertEquals( new Map<String, String>( ), OB_Maintenance_AttachedDocs_CC.getProductDocumentsServer( logRequest.Id, true, false ) );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_AttachedDocs_CC.getProductDocumentsServer - fail scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       22/06/2019      Created        NEXI-60
   ********************************************************************************/
    @isTest
    private static void getProductDocumentsServerNullTest( )
    {
        Test.startTest( );
        Map<String, String> result = OB_Maintenance_AttachedDocs_CC.getProductDocumentsServer( null, false, false );
        Test.stopTest( );

        System.assertEquals( new Map<String, String>( ), result );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_AttachedDocs_CC.retrieveInfos - checking checkIfTEChanged method
    Returns: Should return isTEEDIT = false, showComponent = false

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek       28/06/2019      Created        NEXI-131
    ********************************************************************************/
    @isTest
    private static void checkIfTEChangeTest( )
    {
        OB_LogRequest__c logRequest = getLogRequest( );
        logRequest.OB_Change_of_data_of_beneficial_owners__c = false;
        update logRequest;

        Map<String, String> result = OB_Maintenance_AttachedDocs_CC.retrieveInfos( logRequest.Id );
        System.assertEquals( 'false', result.get( 'isTEEDIT' ));
        System.assertEquals( 'true' , result.get( 'showComponent' ));
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_AttachedDocs_CC.retrieveInfos - checking checkIfTEChanged method
    Returns: Should return isTEEDIT = false, showComponent = false

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek       28/06/2019      Created        NEXI-131
    ********************************************************************************/
    @isTest
    private static void checkIfTEChangeTest2( )
    {
        OB_LogRequest__c logRequest = getLogRequest( );
        logRequest.OB_Change_of_data_of_beneficial_owners__c = true;
        update  logRequest;
        Map<String, String> result = OB_Maintenance_AttachedDocs_CC.retrieveInfos( logRequest.Id );
        System.assertEquals( 'false', result.get( 'isTEEDIT' ));
        System.assertEquals( 'false' , result.get( 'showComponent' ));
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_AttachedDocs_CC.retrieveInfos - checking checkIfTEChanged method
    Returns: Should return isTEEDIT = false, showComponent = true

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek       28/06/2019      Created        NEXI-131
    ********************************************************************************/
    @isTest
    private static void checkIfTEChangeTest3( )
    {
        OB_LogRequest__c mainLogRequest = getLogRequest( );
        mainLogRequest.OB_Change_of_data_of_beneficial_owners__c = true;
        update mainLogRequest;
        Account aAccount = OB_TestDataFactory.getAccount( );
        insert aAccount;

        Contact mainContact = OB_TestDataFactory.getContact( aAccount );
        mainContact.OB_PEP__c = true;

        Map<String, List<Sobject>> oldDataMap = new Map<String, List<Sobject>>( );
        oldDataMap.put( 'obj', new List<Sobject> {mainContact} );
        mainContact.OB_PEP__c = false;
        Map<String, List<Sobject>> newDataMap = new Map<String, List<Sobject>>( );
        newDataMap.put( 'obj', new List<Sobject> {mainContact} );
        mainLogRequest.OB_ReducedOldData__c = JSON.serialize( oldDataMap );
        mainLogRequest.OB_ReducedNewData__c = JSON.serialize( newDataMap );
        update mainLogRequest;
        Map<String, String> result = OB_Maintenance_AttachedDocs_CC.retrieveInfos( mainLogRequest.Id );

        System.assertEquals( 'false', result.get( 'isTEEDIT' ));
        System.assertEquals( 'true', result.get( 'showComponent' ));
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_AttachedDocs_CC.retrieveInfos - checking checkIfTEChanged method
    Returns: Should return isTEEDIT = true, showComponent = true

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek       28/06/2019      Created        NEXI-131
    ********************************************************************************/
    @isTest
    private static void checkIfTEChangeTest4( )
    {
        OB_LogRequest__c mainLogRequest = getLogRequest( );
        mainLogRequest.OB_Change_of_data_of_beneficial_owners__c = true;
        update mainLogRequest;
        Account aAccount = OB_TestDataFactory.getAccount( );
        insert aAccount;

        Contact mainContact = OB_TestDataFactory.getContact( aAccount );
        mainContact.OB_PEP__c = true;
        insert mainContact;

        Map<String, List<Sobject>> oldDataMap = new Map<String, List<Sobject>>( );
        oldDataMap.put( 'obj', new List<Sobject> {mainContact} );
        mainLogRequest.OB_ReducedOldData__c = JSON.serialize( oldDataMap );

        mainContact.FirstName = 'newFirstName';
        update mainContact;
        Map<String, List<Sobject>> newDataMap = new Map<String, List<Sobject>>( );
        newDataMap.put( 'obj', new List<Sobject> {mainContact} );

        mainLogRequest.OB_ReducedNewData__c = JSON.serialize( newDataMap );
        update mainLogRequest;
        Map<String, String> result = OB_Maintenance_AttachedDocs_CC.retrieveInfos( mainLogRequest.Id );

        System.assertEquals( 'true', result.get( 'isTEEDIT' ));
        System.assertEquals( 'true', result.get( 'showComponent' ));
    }
}