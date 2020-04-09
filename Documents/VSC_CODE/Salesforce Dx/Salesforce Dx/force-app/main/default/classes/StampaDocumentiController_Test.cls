@isTest
private with sharing class StampaDocumentiController_Test
{
    @isTest
    public static void getProductDocumentsServerTest( )
    {
        String mcc = '1234';
        List<NE__OrderItem__c> orderItems = new List <NE__OrderItem__c>( );
        NE__Order_Header__c orderHeader = new NE__Order_Header__c( );
        orderHeader.OB_Main_Process__c = 'Maintenance';
        orderHeader.OB_Business_Model_Acquiring__c = 'Bancario' ;
        orderHeader.OB_Business_Model_POS__c = 'Diretto';
        insert orderHeader;
        //Doris Dongmo - 13/06/2019 - Start
        NE__Product__c prod = new NE__Product__c( OB_Codice_sfdc__c = 'VISAMASTERCARD', NE__Engine_Code__c = '' );
        insert prod;
        //Doris Dongmo - 13/06/2019 - END
        NE__Order__c order = new NE__Order__c( );
        order.NE__Order_Header__c = orderHeader.Id;
        insert order;
        NE__Order__c order1 = new NE__Order__c( );
        order1.OB_ABI__c = '12345'; //antonio.vatrano 02/10/2019
        insert order1;


        Account acc1 = new Account( Name = 'test' );
        acc1.OB_Employees_Number__c = 'Minore di 10';
        acc1.NE__Fiscal_code__c = '12345678909';
        acc1.NE__VAT__c = '67543456789';
        acc1.OB_CCIAA__c = 'isTest';
        acc1.OB_ATECO__c = '1234567';
        acc1.OB_Legal_Form__c = 'Società per azioni';
        acc1.RecordTypeId = [ SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'Bank' LIMIT 1 ].id;
        acc1.OB_ABI__c = '12345';
        insert acc1;

        OB_Bank_Profile__c bankProfile = new OB_Bank_Profile__c( OB_Bank__c = acc1.Id,
                OB_Service_Type__c = 'Servizio GT+Acquiring',
                OB_Business_Model_POS__c = 'Bilaterale',
                OB_Circuit__c = 'JCB',
                OB_Other_Acquirer__c = 'Amex',
                OB_Applicant_RAC_Code_SIA__c = 'Nexi',
                OB_Terminal_Id_Generator__c = 'Nexi',
                OB_Technical_component_invoicing__c = 'Al p.v.',
                OB_GT__c = 'Nexi',
                OB_Processor__c = 'SIA SMAC',
                OB_Bilateral_Pricing__c = 'SI',
                OB_Sending_Contract_to_Nexi__c = 'SI',
                OB_SME_Factory__c = 'SI',
                OB_NeedBIO__c = false );
        insert bankProfile;

        List<NE__Lov__c> mccLovList = new List<NE__Lov__c>( );
        NE__Lov__c mccLov = new NE__Lov__c ( NE__Type__c = 'MCC',
                NE__Active__c = true,
                NE__Value2__c = mcc,
                NE__Value1__c = 'PO118' );
        mccLovList.add( mccLov );
        insert mccLovList;

        List<NE__Lov__c> atecoLovList = new List<NE__Lov__c>( );
        NE__Lov__c atecoLov = new NE__Lov__c( );
        atecoLov.NE__Type__c = 'ATECO';
        atecoLov.NE__Active__c = true;
        atecoLov.Name = '1234567';
        atecoLov.NE__Value3__c = '1234567';
        atecoLovList.add( atecoLov );
        insert atecoLovList;

        List<NE__Lov__c> legalFormLovList = new List<NE__Lov__c>( );
        NE__Lov__c legalFormLov = new NE__Lov__c( );
        legalFormLov.NE__Type__c = 'LegalForm';
        legalFormLov.NE__Active__c = true;
        legalFormLov.Name = 'Società per azioni';
        legalFormLov.NE__Value1__c = 'DITTA_INDIVIDUALE';
        legalFormLovList.add( legalFormLov );
        insert legalFormLovList;

        NE__Billing_Profile__c bp = new NE__Billing_Profile__c( );
        bp.NE__Account__c = acc1.id;
        bp.Name = 'test';
        bp.OB_Bank_Account_Number__c = '012345678901';
        //bp.NE__OrderId__c = order1.id;
        //bp.NE__Qty__c = 12 ;
        //insert bp;

        NE__Product__c commercialProduct = new NE__Product__c( );
        commercialProduct.Name = 'testTest';
        insert commercialProduct;

        NE__OrderItem__c orderItem = new NE__OrderItem__c( );
        orderItem.NE__Account__c = acc1.id;
        orderItem.NE__BillingProfId__c = bp.Id;
        orderItem.NE__ProdId__c = commercialProduct.id;
        orderItem.NE__Billing_Account__c = acc1.id;
        orderItem.NE__OrderId__c = order1.id;
        orderItem.NE__Qty__c = 76;
        orderItem.NE__Action__c = 'Add';// Doris Dongmo - added  'NE__Action__c' - 13/06/2019

        NE__OrderItem__c orderItem1 = new NE__OrderItem__c(
                NE__OrderId__c = order.Id,
                NE__Qty__c = 1,
                NE__ProdId__c = prod.Id,
                NE__Action__c = 'Add' );// Doris Dongmo - added  'NE__Action__c' - 13/06/2019


        orderItems.add( orderItem );
        orderItems.add( orderItem1 );
        insert orderItems;

        List<OB_Special_Category_Configuration__c> listToFilter = new List<OB_Special_Category_Configuration__c>( );
        OB_Special_Category_Configuration__c obj1 = new OB_Special_Category_Configuration__c( OB_DocRequired__c = true, OB_ATECO__c = acc1.OB_ATECO__c );
        obj1.Name = 'sccTest';
        obj1.RecordTypeId = Schema.SObjectType.OB_Special_Category_Configuration__c.getRecordTypeInfosByName( ).get( 'MCC_OR_ATECO' ).getRecordTypeId( );
        insert obj1;

        List<OB_Product_Document__c> allDocuments = new List<OB_Product_Document__c> ( );
        OB_Product_Document__c prodDoc = new OB_Product_Document__c( );
        prodDoc.Name = 'document 1';
        prodDoc.OB_Description__c = 'Description product';
        prodDoc.OB_Start_Date__c = Date.newInstance( 2001, 01, 21 );

        OB_Product_Document__c goodDocument = new OB_Product_Document__c( );
        goodDocument.OB_Business_Model__c = 'Diretto';
        goodDocument.OB_Client_Type__c = 'sccTest';
        goodDocument.OB_Request_Typology__c = 'Maintenance';
        goodDocument.OB_Document_Typology__c = 'CONTRATTO FIRMATO';

        OB_Product_Document__c pd2 = new OB_Product_Document__c( );
        pd2.OB_Business_Model__c = 'Bancario';
        pd2.OB_Document_Typology__c = 'DOCUMENTO DI IDENTITA';
        pd2.OB_Start_Date__c = Date.newInstance( 2011, 01, 21 );
        pd2.OB_Client_Type__c = 'a2E9E000000hoWX';
        pd2.OB_Request_Typology__c = 'Maintenance';


        allDocuments.add( prodDoc );
        allDocuments.add( goodDocument );
        allDocuments.add( pd2 );
        insert allDocuments;

        List<String> prodStringList = new List<String>( );
        List<NE__Product__c> products = new List<NE__Product__c> ( );
        String prodString = String.valueOf( prod );
        prodStringList.add( prodString );

        String merchantId = acc1.id;

        Test.startTest( );
        StampaDocumentiController.getProductDocumentsServer( String.valueOf( order.Id ), String.valueOf( orderHeader.Id ), mcc, acc1.OB_ATECO__c, acc1.OB_Legal_Form__c, merchantId, '12345', false );
        Test.stopTest( );
    }

    @isTest
    public static void getCommercialProductsServer_Test( )
    {
        NE__Product__c prod = new NE__Product__c( );
        List<NE__Product__c> products = new List<NE__Product__c> ( );
        products.add( prod );
        insert products;

        Test.startTest( );
        StampaDocumentiController.getCommercialProductsServer( );
        Test.stopTest( );
    }

    @isTest
    public static void updateDocReqTrue_Test1( )
    {
        NE__Order_Header__c oh = new NE__Order_Header__c( );
        insert oh;
        Boolean isToTriggered = true;
        Test.startTest( );
        StampaDocumentiController.updateDocReqTrue( oh.Id, isToTriggered );
        Test.stopTest( );
    }

    @isTest
    public static void updateDocReqTrue_Test2( )
    {
        NE__Order_Header__c oh = new NE__Order_Header__c( );
        insert oh;
        Boolean isToTriggered = false;
        Test.startTest( );
        StampaDocumentiController.updateDocReqTrue( oh.Id, isToTriggered );
        Test.stopTest( );
    }
    /*
    * Author : Giovanni Spinelli
    * Date : 10/05/2019
    * Description : test method for StampaDocumentiController.retrieveSavedDocs() and StampaDocumentiController.deprecateDocs().
    */
    @isTest
    public static void retrieveSavedDocs_test( )
    {
        OB_Integration_Configuration__c configuration = new OB_Integration_Configuration__c( );
        configuration.Name = 'DEV1';
        configuration.OB_CAsigned_name__c = '';
        configuration.OB_Client_ID__c = '631edaf5-d79a-43b8-8753-1dd64e8e210f';
        configuration.OB_Client_Secret__c = '1b332dad-0b9f-4745-87b1-01c4f5d1a292';
        configuration.OB_Domain__c = 'dev1';
        configuration.OB_Grant_Type__c = 'client_credentials';
        configuration.OB_Timeout_Continuation__c = '30';
        configuration.OB_Timestamp__c = '154392275757575';
        configuration.OB_Token_1__c = 'eyJ0eXAiOiJKV1QiLCJjdHkiOiJKV1QiLCJhbGciOiJSU0EtT0FFUCIsImVuYyI6IkExMjhDQkMtSFMyNTYifQ.Lgw6lqjmOIWy4dPRJmvIyKQBht9BlMDATRylNS1nJGeDePjmvfSxgeZbRzMnu89snNTh9b6SzxsPVUMsgDJ4klsUT81GuFU-sPe4u_zBss5y9jvXe8KwuU5zXDm7ElY_jYUqHKaWaLpCpkfq8UwGcJ_VL7TDJ7m7_eWAc67P';
        configuration.OB_Token_2__c = 'gPl_TKmk2ggdSoRnvQqC9FF2ywLGPtYj_6kKea5esiQlrfmmgtJUy2kcjeUS8YOtxw3X63q-ehEYEvPwQ_eZ9Mpr09DuKtlnOQCsOqBCle60zxNZpiWsyOmmT_Z4Diy2CjaN84u9uIUT-9cea4cdKgEMXTJpqhD5MGHaegt8m-DKKA.pnvamAYqa8kZ_uDcM2tAnQ.ox1twscMrBYAHxrob9WYAgzLu76VDEIKNT5xZgm53kkwmzRqs2lPkBp92';
        configuration.OB_Token_3__c = 'eTSNiQC0mvmjuu2JL0K3h5XLwTUgjHsBW90uAj8oBEnubLcjzb_bQLi5kBTuCmZmIYmVaO3PNl4-RTzWpKcmm6ICa53xxcU_N81mzi_QM9meGrPOOH9YsCJuwPDvacSDg6-XfgHUvqelmSSHKbJBR_-A12b8WjyrFFTHzthFQp36h2Q9kovuYAwukbDTaakh6OOtpxw7zzROB4hM5k2kLRkiNRBg6zslcYytx5tXHnZzZLsZO73cSsD8mG_iRmT';
        configuration.OB_Token_4__c = 'gkR6gY0FEswxXWrbVrGdVtLxNwNctoqwWtxBiDfzJgA30byG0N6TM4IBfnt6c58VtAlqOUpsB_Qm3TbDk4SF3NtGTxOuaT-TgRyWQkt5_Dq-XatnL9W_RtNcnuOruhImP-X6zc9m6lYDQ98TArn-4ADOWpZpB8vOx6-bDrOxr-OG5uQ6V5FymfSZI5K24QXxuiofZzvPfhJzsS_4fpNkCUGPGhQCr_KTmqMMqgmzfRcErX23RRh6uFo0Hm2ohXH';
        configuration.OB_Token_5__c = 'LZTWscVQ1OZl9qDSMA9vFJle-WWxoxhfXdQeD9ePZ41werIqxkf6nZp6sAm3wwKVnSnLVVBstnAXFOTbGfzzX8LQJOrfs8R1jvoOa9ylLpPoBQwdkkR9MeE7pjMAfbebqJh2BX8Xx-MzB5CVkyxPPNchDkidvPUA8UW4EkZQWvDLElUKhAChy9J5TyYkYWvbRgrx4fDgZ5QPZ00-afJYiK1uHfR7botM4xm5hR_04R3XdCCnCicShD2XLN6doaG';
        configuration.OB_Token_6__c = 't6Gzv14CU1S-rN9zA9FCO7PDBywCWfzR2G8tzud0rUq_JnBTBCJFfDu01ki82TR78Od1dbM0iLpVcNJMMEMTFi_Csh3tdXM_yPiE07009WrFiWl29goM8VPlQxbmLmsqg-bWCNAVKZqutqMavqnRjJN2q3EkJbGfut9Ghc0OUae4wXDwbwvh3dijaaftSuaY0xuCVuqbopiPfS4_y5VSztt5gai1rpW0NSO3_D1pSA9Ikvfl1DipbN1tk529J_0';
        configuration.OB_Token_7__c = 'NXsfUdKgf3ADwJPcNPb2pVafkyfqr-R4xn44bnaIuOyG5firipGOROVColCMkwyL0nRYSf40CYG.KpiIzQP0btC54uMB-gvw8Q';
        insert configuration;
        List<String> idsList = new List<String>( );
        idsList.add( 'test' );
        Test.setMock( HttpCalloutMock.class, new MockMakeGetCalloutController( ) );
        Test.startTest( );
        StampaDocumentiController.retrieveSavedDocs( '', '', '' );
        StampaDocumentiController.deprecateDocs( '', '', '', idsList );
        StampaDocumentiController.getTokenJWE( 'test.pdf' );//giovanni spinelli 24/05/2019
        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:  Test method for getProductDocuments when have only Order Id
    Parameters: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek      	28/07/2019      Created         NEXI-211
    ********************************************************************************/
    @isTest
    private static void getProductDocumentsServerWhenOnlyOrderId( )
    {
        NE__Order__c oOrder = OB_TestDataFactory.getOrder( );
        insert oOrder;

        Map<String, String> result = StampaDocumentiController.getProductDocumentsServer( oOrder.Id, null, null, null, null, null, null, null, false );

        System.assert( result.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Test method for getProductDocuments when have only OrderHeader Id
    Parameters: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek      	28/07/2019      Created         NEXI-211
    ********************************************************************************/
    @isTest
    private static void getProductDocumentsServerWhenOnlyOrderHeader( )
    {
        NE__Order_Header__c oOrderHeader = OB_TestDataFactory.getOrderHeader( );
        insert oOrderHeader;

        Map<String, String> result = StampaDocumentiController.getProductDocumentsServer( null, oOrderHeader.Id, null, null, null, null, null, null, false );

        System.assert( result.isEmpty( ) );
    }


    /*******************************************************************************
      Purpose:  Method tests saving - returning null

      History
      --------
      VERSION     AUTHOR                  DATE            DETAIL          Description
      1.0        Roland Nieznanski       19/08/2019      Created         Check client type MOTO
      ********************************************************************************/
    @isTest
    public static void getProductDocumentsServerMOTOTest( )
    {
        String mcc = '1234';
        List<NE__OrderItem__c> orderItems = new List <NE__OrderItem__c>( );
        NE__Order_Header__c orderHeader = OB_TestDataFactory.getOrderHeader( );
        orderHeader.OB_Main_Process__c = 'Maintenance';
        orderHeader.OB_Business_Model_Acquiring__c = 'Bancario' ;
        orderHeader.OB_Business_Model_POS__c = 'Diretto';
        insert orderHeader;
        NE__Product__c prod = new NE__Product__c( OB_Codice_sfdc__c = 'VISAMASTERCARD', NE__Engine_Code__c = 'test' );
        insert prod;
        NE__Order__c order = new NE__Order__c( );
        order.NE__Order_Header__c = orderHeader.Id;
        insert order;
        NE__Order__c order1 = new NE__Order__c( );
        order1.OB_ABI__c = '12345';//antonio.vatrano 02/10/2019
        insert order1;


        Account acc1 = OB_TestDataFactory.getAccount();
        acc1.OB_Employees_Number__c = 'Minore di 10';
        acc1.NE__Fiscal_code__c = '12345678909';
        acc1.NE__VAT__c = '67543456789';
        acc1.OB_CCIAA__c = 'isTest';
        acc1.OB_ATECO__c = '1234567';
        acc1.OB_Legal_Form__c = 'Società per azioni';
        acc1.RecordTypeId = [ SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'Bank' LIMIT 1 ].id;
        acc1.OB_ABI__c = '12345';
        insert acc1;

        OB_Bank_Profile__c bankProfile = new OB_Bank_Profile__c( OB_Bank__c = acc1.Id,
                OB_Service_Type__c = 'Servizio GT+Acquiring',
                OB_UploadSignedContract__c = true,
                OB_Business_Model_POS__c = 'Bilaterale',
                OB_Circuit__c = 'JCB',
                OB_Other_Acquirer__c = 'Amex',
                OB_Applicant_RAC_Code_SIA__c = 'Nexi',
                OB_Terminal_Id_Generator__c = 'Nexi',
                OB_Technical_component_invoicing__c = 'Al p.v.',
                OB_GT__c = 'Nexi',
                OB_Processor__c = 'SIA SMAC',
                OB_Bilateral_Pricing__c = 'SI',
                OB_Sending_Contract_to_Nexi__c = 'SI',
                OB_SME_Factory__c = 'SI',
                OB_NeedBIO__c = false );
        insert bankProfile;

        List<NE__Lov__c> legalFormLovList = new List<NE__Lov__c>( );
        NE__Lov__c mccLov = new NE__Lov__c ( NE__Type__c = 'MCC',
                NE__Active__c = true,
                NE__Value2__c = mcc,
                NE__Value1__c = 'PO118' );
        legalFormLovList.add( mccLov );

        NE__Lov__c atecoLov = new NE__Lov__c( );
        atecoLov.NE__Type__c = 'ATECO';
        atecoLov.NE__Active__c = true;
        atecoLov.Name = '1234567';
        atecoLov.NE__Value3__c = '1234567';
        legalFormLovList.add( atecoLov );

        NE__Lov__c legalFormLov = new NE__Lov__c( );
        legalFormLov.NE__Type__c = 'LegalForm';
        legalFormLov.NE__Active__c = true;
        legalFormLov.Name = 'Società per azioni';
        legalFormLov.NE__Value1__c = 'DITTA_INDIVIDUALE';
        legalFormLovList.add( legalFormLov );
        insert legalFormLovList;

        NE__Billing_Profile__c bp = new NE__Billing_Profile__c( );
        bp.NE__Account__c = acc1.id;
        bp.Name = 'test';
        bp.OB_Bank_Account_Number__c = '012345678901';

        NE__Product__c commercialProduct = new NE__Product__c( );
        commercialProduct.Name = 'testTest';
        insert commercialProduct;

        NE__OrderItem__c orderItem = new NE__OrderItem__c( );
        orderItem.NE__Account__c = acc1.id;
        orderItem.NE__BillingProfId__c = bp.Id;
        orderItem.NE__ProdId__c = commercialProduct.id;
        orderItem.NE__Billing_Account__c = acc1.id;
        orderItem.NE__OrderId__c = order1.id;
        orderItem.NE__Qty__c = 76;
        orderItem.NE__Action__c = 'Add';

        NE__OrderItem__c orderItem1 = new NE__OrderItem__c(
                NE__OrderId__c = order.Id,
                NE__Qty__c = 1,
                NE__ProdId__c = prod.Id,
                NE__Action__c = 'Add' );


        orderItems.add( orderItem );
        orderItems.add( orderItem1 );
        insert orderItems;

        List<OB_Special_Category_Configuration__c> listToFilter = new List<OB_Special_Category_Configuration__c>( );
        OB_Special_Category_Configuration__c obj1 = new OB_Special_Category_Configuration__c( OB_DocRequired__c = true, OB_ATECO__c = acc1.OB_ATECO__c );
        obj1.Name = 'MOTO';
        obj1.OB_EngineCodeCommercialProduct__c = 'test';
        obj1.OB_Legal_Form__c = 'DITTA_INDIVIDUALE';
        obj1.RecordTypeId = Schema.SObjectType.OB_Special_Category_Configuration__c.getRecordTypeInfosByDeveloperName( ).get( 'OB_PRODUCT_ACTIVATION_FORMA_GIURIDICA' ).getRecordTypeId( );
        insert obj1;

        List<OB_Product_Document__c> allDocuments = new List<OB_Product_Document__c> ( );
        OB_Product_Document__c prodDoc = new OB_Product_Document__c( );
        prodDoc.Name = 'document 1';
        prodDoc.OB_Description__c = 'Description product';
        prodDoc.OB_Start_Date__c = Date.newInstance( 2001, 01, 21 );

        OB_Product_Document__c goodDocument = new OB_Product_Document__c( );
        goodDocument.OB_Business_Model__c = 'Diretto';
        goodDocument.OB_Client_Type__c = 'MOTO';
        goodDocument.OB_Request_Typology__c = 'Maintenance';
        goodDocument.OB_Document_Typology__c = 'CONTRATTO FIRMATO';

        OB_Product_Document__c pd2 = new OB_Product_Document__c( );
        pd2.OB_Business_Model__c = 'Bancario';
        pd2.OB_Document_Typology__c = 'DOCUMENTO DI IDENTITA';
        pd2.OB_Start_Date__c = Date.newInstance( 2011, 01, 21 );
        pd2.OB_Client_Type__c = 'a2E9E000000hoWX';
        pd2.OB_Request_Typology__c = 'Maintenance';


        allDocuments.add( prodDoc );
        allDocuments.add( goodDocument );
        allDocuments.add( pd2 );
        insert allDocuments;

        List<String> prodStringList = new List<String>( );
        List<NE__Product__c> products = new List<NE__Product__c> ( );
        String prodString = String.valueOf( prod );
        prodStringList.add( prodString );

        String merchantId = acc1.id;

        Test.startTest( );
        Map<String, String> result = StampaDocumentiController.getProductDocumentsServer( order.Id, null, mcc, acc1.OB_ATECO__c, acc1.OB_Legal_Form__c, merchantId, '12345', false, true );
        Test.stopTest( );
        System.assert( !result.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Test method for getProductDocuments - user is in queue

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek     	 23/08/2019      Created         NEXI-216
    ********************************************************************************/
    @isTest
    private static void getProductDocumentsServerUserInQueue( )
    {
        User testUser = OB_TestDataFactory.getUser( );
        testUser.ProfileId = [ SELECT Id FROM Profile WHERE Name = 'Approvatore Risk Evaluation' LIMIT 1 ].Id;
        insert testUser;

        Id groupId = [ SELECT Id FROM Group WHERE Type = 'Queue' and DeveloperName = 'Controlli_Sicurezza' ].Id;
        GroupMember testGroupMember = new GroupMember( UserOrGroupId = testUser.Id, GroupId = groupId );
        insert testGroupMember;

        System.runAs( testUser )
        {
            NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
            testOrderHeader.OB_In_Approvazione_a__c = OB_UtilityConstants.FASECONTROL_SECURITY_CHECKS;
            insert testOrderHeader;

            NE__Order__c testOrder = OB_TestDataFactory.getOrder( testOrderHeader );
            insert testOrder;

            NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
            insert testOrderItem;

            OB_Product_Document__c testDocument = OB_TestDataFactory.getProductDocument( );
            testDocument.Name = 'Scheda di valutazione';
            testDocument.OB_Document_Typology__c = 'VALUTAZIONE RISCHIO';
            insert testDocument;

            Map<String, String> result = StampaDocumentiController.getProductDocumentsServer( testOrder.Id, testOrderHeader.Id, '', '', '', '', '', false, false );
            System.assert( !result.isEmpty( ) );
        }
    }
    /*
	* Author : Gianluigi Virga
	* Date : 01/10/2019
	* Description : Test Method to coverage StampaDocumentiController.deprecateContracts().
	*/
    @isTest
    public static void deprecateContracts_test(){
        List<String> idsList = new List<String>();
        idsList.add('test');

        OB_Integration_Configuration__c configuration = new OB_Integration_Configuration__c();
		configuration.Name = 'DEV1';
		configuration.OB_CAsigned_name__c = '';
		configuration.OB_Client_ID__c = '631edaf5-d79a-43b8-8753-1dd64e8e210f';
		configuration.OB_Client_Secret__c = '1b332dad-0b9f-4745-87b1-01c4f5d1a292';
		configuration.OB_Domain__c = 'dev1';
		configuration.OB_Grant_Type__c = 'client_credentials';
		configuration.OB_Timeout_Continuation__c = '30';
		configuration.OB_Timestamp__c = '154392275757575';
		configuration.OB_Token_1__c = 'eyJ0eXAiOiJKV1QiLCJjdHkiOiJKV1QiLCJhbGciOiJSU0EtT0FFUCIsImVuYyI6IkExMjhDQkMtSFMyNTYifQ.Lgw6lqjmOIWy4dPRJmvIyKQBht9BlMDATRylNS1nJGeDePjmvfSxgeZbRzMnu89snNTh9b6SzxsPVUMsgDJ4klsUT81GuFU-sPe4u_zBss5y9jvXe8KwuU5zXDm7ElY_jYUqHKaWaLpCpkfq8UwGcJ_VL7TDJ7m7_eWAc67P';
		configuration.OB_Token_2__c = 'gPl_TKmk2ggdSoRnvQqC9FF2ywLGPtYj_6kKea5esiQlrfmmgtJUy2kcjeUS8YOtxw3X63q-ehEYEvPwQ_eZ9Mpr09DuKtlnOQCsOqBCle60zxNZpiWsyOmmT_Z4Diy2CjaN84u9uIUT-9cea4cdKgEMXTJpqhD5MGHaegt8m-DKKA.pnvamAYqa8kZ_uDcM2tAnQ.ox1twscMrBYAHxrob9WYAgzLu76VDEIKNT5xZgm53kkwmzRqs2lPkBp92';
		configuration.OB_Token_3__c = 'eTSNiQC0mvmjuu2JL0K3h5XLwTUgjHsBW90uAj8oBEnubLcjzb_bQLi5kBTuCmZmIYmVaO3PNl4-RTzWpKcmm6ICa53xxcU_N81mzi_QM9meGrPOOH9YsCJuwPDvacSDg6-XfgHUvqelmSSHKbJBR_-A12b8WjyrFFTHzthFQp36h2Q9kovuYAwukbDTaakh6OOtpxw7zzROB4hM5k2kLRkiNRBg6zslcYytx5tXHnZzZLsZO73cSsD8mG_iRmT';
		configuration.OB_Token_4__c = 'gkR6gY0FEswxXWrbVrGdVtLxNwNctoqwWtxBiDfzJgA30byG0N6TM4IBfnt6c58VtAlqOUpsB_Qm3TbDk4SF3NtGTxOuaT-TgRyWQkt5_Dq-XatnL9W_RtNcnuOruhImP-X6zc9m6lYDQ98TArn-4ADOWpZpB8vOx6-bDrOxr-OG5uQ6V5FymfSZI5K24QXxuiofZzvPfhJzsS_4fpNkCUGPGhQCr_KTmqMMqgmzfRcErX23RRh6uFo0Hm2ohXH';
		configuration.OB_Token_5__c = 'LZTWscVQ1OZl9qDSMA9vFJle-WWxoxhfXdQeD9ePZ41werIqxkf6nZp6sAm3wwKVnSnLVVBstnAXFOTbGfzzX8LQJOrfs8R1jvoOa9ylLpPoBQwdkkR9MeE7pjMAfbebqJh2BX8Xx-MzB5CVkyxPPNchDkidvPUA8UW4EkZQWvDLElUKhAChy9J5TyYkYWvbRgrx4fDgZ5QPZ00-afJYiK1uHfR7botM4xm5hR_04R3XdCCnCicShD2XLN6doaG';
		configuration.OB_Token_6__c = 't6Gzv14CU1S-rN9zA9FCO7PDBywCWfzR2G8tzud0rUq_JnBTBCJFfDu01ki82TR78Od1dbM0iLpVcNJMMEMTFi_Csh3tdXM_yPiE07009WrFiWl29goM8VPlQxbmLmsqg-bWCNAVKZqutqMavqnRjJN2q3EkJbGfut9Ghc0OUae4wXDwbwvh3dijaaftSuaY0xuCVuqbopiPfS4_y5VSztt5gai1rpW0NSO3_D1pSA9Ikvfl1DipbN1tk529J_0';
		configuration.OB_Token_7__c = 'NXsfUdKgf3ADwJPcNPb2pVafkyfqr-R4xn44bnaIuOyG5firipGOROVColCMkwyL0nRYSf40CYG.KpiIzQP0btC54uMB-gvw8Q';
        
		insert configuration;
        Test.setMock(HttpCalloutMock.class, new MockMakeGetCalloutController());
        Test.startTest();
        StampaDocumentiController.deprecateContracts('','','',idsList);
        System.assertEquals('test', idsList[0]);
        Test.stopTest();
    }

}