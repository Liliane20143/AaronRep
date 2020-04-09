/**
 * Created by wojciech.kucharek@accenture.com on 23.07.2019.
 */
@isTest
public with sharing class OB_Util000_DocumentUpload_Test
{
    /*******************************************************************************
    Purpose:  Method prapare and insert product documents for test
    Parameters: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek      	23/07/2019      Created         NEXI-211
    ********************************************************************************/
    private static void prepareProductsDocument()
    {
        OB_Product_Document__c testDocument = OB_TestDataFactory.getProductDocument( );
        testDocument.Name = 'Codice Fiscale legale rappresentante e titolari effettivi';
        testDocument.OB_Description__c = 'Codice Fiscale titolare effettivo (maintenance)';
        testDocument.OB_Request_Typology__c = 'Maintenance';
        testDocument.OB_Document_Typology__c = 'CARTA REGIONALE SERVIZI';
        insert testDocument;

        OB_Product_Document__c testDocument2 = OB_TestDataFactory.getProductDocument( );
        testDocument2.Name = 'Copia documento Agenzia delle Entrate di rilascio P.IVA (riportante Codice Ateco';
        testDocument2.OB_Description__c = 'Copia documento Agenzia delle Entrate di rilascio P.IVA (riportante Codice Ateco)';
        testDocument2.OB_Request_Typology__c = 'Maintenance';
        testDocument2.OB_Document_Typology__c = 'CERTIFICATO PIVA';
        insert testDocument2;

        OB_Product_Document__c testDocument3 = OB_TestDataFactory.getProductDocument( );
        testDocument3.Name = 'Visura camerale';
        testDocument3.OB_Description__c = 'Visura camerale';
        testDocument3.OB_Request_Typology__c = 'Maintenance';
        testDocument3.OB_Document_Typology__c = 'VISURA';
        insert testDocument3;

        OB_Product_Document__c testDocument4 = OB_TestDataFactory.getProductDocument( );
        testDocument4.Name = 'Copia documento d’identità del Rappresentante/esecutore, di eventuali titolari e';
        testDocument4.OB_Description__c = 'Copia documento d’identità del Rappresentante/esecutore, di eventuali titolari effettivi, soci e amministratori';
        testDocument4.OB_Request_Typology__c = 'Maintenance';
        testDocument4.OB_Document_Typology__c = 'DOCUMENTO DI IDENTITA';
        insert testDocument4;
    }

    /*******************************************************************************
    Purpose:  Method prapare and insert required objects for test
    Parameters: -
    Return:   OrderHeaderId for tested method

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek      	23/07/2019      Created         NEXI-211
    ********************************************************************************/
    private static String prepareRequiredObjectsForTest()
    {
        Account accountTest = OB_TestDataFactory.getAccount( );
        accountTest.OB_ATECO__c = OB_UtilityConstants.GAMBLING_VALUE_920;// Roland Nieznanski <roland.nieznanski@accenture.com> 03/10/2019
        insert accountTest;

        NE__Order_Header__c oHeader = OB_TestDataFactory.getOrderHeader( );
        oHeader.OB_Gambling__c = true;
        oHeader.NE__AccountId__c = accountTest.Id;
        insert oHeader;

        NE__Service_Point__c sPoint = OB_TestDataFactory.getServicePoint( );
        sPoint.OB_MCC__c = '7995';
        insert sPoint;

        NE__Order__c orderTest = OB_TestDataFactory.getOrder( oHeader );
        orderTest.OB_Service_Point__c = sPoint.Id;
        insert orderTest;

        return oHeader.Id;
    }

    /*******************************************************************************
    Purpose:  Test method for documentsWhenSpecialCategory() when find correct product documents
    Parameters: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek      	23/07/2019      Created         NEXI-211
    ********************************************************************************/
    @isTest
    private static void documentsForSpecialCategoryNotEmpty( )
    {
        String orderHeaderId = prepareRequiredObjectsForTest();
        prepareProductsDocument();

        Map<String, String> testMap = OB_Util000_DocumentUpload.documentsWhenSpecialCategory( orderHeaderId );
        System.assert( !testMap.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Test method for documentsWhenSpecialCategory() when not find correct product documents
    Parameters: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek      	23/07/2019      Created         NEXI-211
    ********************************************************************************/
    @isTest
    private static void documentsForSpecialCategoryIsEmpty( )
    {
        String orderHeaderId = prepareRequiredObjectsForTest();
        Map<String, String> testMap = OB_Util000_DocumentUpload.documentsWhenSpecialCategory( orderHeaderId );
        System.assert( testMap.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Test method for setDocumentsToUpload() when find correct product documents
    Parameters: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek      	23/07/2019      Created         NEXI-211
    ********************************************************************************/
    @isTest
    private static void setDocumentsToUploadFindDocs( )
    {
        OB_Product_Document__c testDocument = OB_TestDataFactory.getProductDocument( );
        testDocument.Name = 'Scheda di valutazione';
        testDocument.OB_Description__c = 'Scheda di valutazione';
        testDocument.OB_Request_Typology__c = 'Maintenance';
        testDocument.OB_Document_Typology__c = 'VALUTAZIONE RISCHIO';
        insert testDocument;

        Map<String, String> result = OB_Util000_DocumentUpload.setDocumentsToUpload( OB_Util000_DocumentUpload.DOCUMENT_VR, OB_Util000_DocumentUpload.DOCUMENT_VR_DESCRIPTION );
        System.assertNotEquals( null, result );
    }

    /*******************************************************************************
    Purpose:  Test method for setDocumentsToUpload() when not find correct product documents
    Parameters: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek      	23/07/2019      Created         NEXI-211
    ********************************************************************************/
    @isTest
    private static void setDocumentsToUploadNotFindDocs( )
    {
        Map<String, String> result = OB_Util000_DocumentUpload.setDocumentsToUpload( OB_Util000_DocumentUpload.DOCUMENT_VR, OB_Util000_DocumentUpload.DOCUMENT_VR_DESCRIPTION );
        System.assertEquals( 0, result.size( ) );
    }

    /*******************************************************************************
    Purpose:  Test method for setDocumentsToUpload() parameters are null
    Parameters: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek      	23/07/2019      Created         NEXI-211
    ********************************************************************************/
    @isTest
    private static void setDocumentsToUploadNull( )
    {
        Map<String, String> result = OB_Util000_DocumentUpload.setDocumentsToUpload( null, null );
        System.assertEquals( 0, result.size( ) );
    }

    /*******************************************************************************
    Purpose:  Test method for documentsWhenSpecialCategory() when parameter is null
    Parameters: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek      	23/07/2019      Created         NEXI-211
    ********************************************************************************/
    @isTest
    private static void documentsForSpecialCategoryNull( )
    {
        Map<String, String> testMap = OB_Util000_DocumentUpload.documentsWhenSpecialCategory( null );
        System.assert( testMap.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Test method for documentsWhenSpecialCategory() when account have
                legal form = LAV_AUTONOMO
    Parameters: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek      	23/07/2019      Created         NEXI-211
    ********************************************************************************/
    @isTest
    private static void testForAccountWichLegalFormLavAutonom( )
    {
        String orderHeaderId = prepareRequiredObjectsForTest();
        prepareProductsDocument();

        Map<String, String> testMap = OB_Util000_DocumentUpload.documentsWhenSpecialCategory( orderHeaderId );
        System.assert( !testMap.isEmpty( ) );
    }
}