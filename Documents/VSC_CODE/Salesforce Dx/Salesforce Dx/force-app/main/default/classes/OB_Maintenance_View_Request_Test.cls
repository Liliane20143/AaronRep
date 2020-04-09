/*****************************************************************
Name: OB_LCC005_OperationalData_Test
Purpose:  Test class of OB_Maintenance_View_Request_Controller

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0            ?                      ?             Created              ?
1.1       Grzegorz Banach         25/07/2019        Modify          Added a constant RT for Log Request
********************************************************************************/
@isTest
public class OB_Maintenance_View_Request_Test
{
    private static final String LOG_REQUEST_ANAGRAFICA_RT = Schema.SObjectType.OB_LogRequest__c.getRecordTypeInfosByName( ).get( OB_UtilityConstants.ANAGRAFICA ).getRecordTypeId();

    /*******************************************************************************
    Purpose:  Method prepare enviroment settings (custom metadata type)
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       02/07/2019      Created         NEXI-149
    ********************************************************************************/
    private static void prepareConfiguration( )
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
    }

    @isTest
    public static void rejectLogRequestSuccessTest( )
    {
        OB_LogRequest__c request = new OB_LogRequest__c( );
        insert request;
        String rejectReason = 'test';

        Test.startTest( );
        OB_Maintenance_View_Request_Controller.rejectLogRequest( request.Id, rejectReason );
        Test.stopTest( );
    }

    @isTest
    public static void rejectLogRequestErrorTest( )
    {
        Contact cont = new Contact( );
        cont.LastName = 'test';
        insert cont;
        String rejectReason = 'test';

        Test.startTest( );
        OB_Maintenance_View_Request_Controller.rejectLogRequest( cont.id, rejectReason );
        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:  ?

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0            ?                      ?             Created              ?
    1.1       Grzegorz Banach        25/07/2019         Modified        Temp fix for Log Request JSONs, added asserts
    ********************************************************************************/
    @isTest
    public static void retrieveLogRequestSuccessTest( )
    {
        OB_LogRequest__c request = OB_TestDataFactory.getLogRequest( );
        request.OB_Status__c = OB_UtilityConstants.CONFERMATO;
        request.RecordTypeId = LOG_REQUEST_ANAGRAFICA_RT;

        insert request;

        Test.startTest( );
        String serializedLogRequestWrapper = OB_Maintenance_View_Request_Controller.retrieveLogRequest( request.Id );
        Test.stopTest( );

        Map<String, Object> wrapperMap = ( Map<String, Object> ) JSON.deserializeUntyped( serializedLogRequestWrapper );
        System.assert( !Boolean.valueOf( wrapperMap.get( 'errorOccurred' ) ) );
    }

    /*******************************************************************************
    Purpose:  ?

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0            ?                      ?             Created              ?
    1.1       Grzegorz Banach        25/07/2019         Modified        Temp fix for Log Request JSONs, added asserts
    ********************************************************************************/
    @isTest
    public static void retrieveLogRequestSuccessWithOldDataTest( )
    {
        Contact contact = new Contact( );
        contact.LastName = 'test';
        insert contact;
        Contact contact2 = new Contact( );
        contact2.LastName = 'test2';
        insert contact2;
        String oldData = '{"obj":[{"attributes":{"type":"Contact","url":"/services/data/v44.0/sobjects/Contact/' + contact.Id + '"},"Phone":"","Id":"' + contact.Id + '"}]}';
        String newData = '{"obj":[{"attributes":{"type":"Contact","url":"/services/data/v44.0/sobjects/Contact/' + contact2.Id + '"},"Phone":"","Id":"' + contact2.Id + '"}]}';
        OB_LogRequest__c request = OB_TestDataFactory.getLogRequest( );
        request.OB_Status__c = OB_UtilityConstants.CONFERMATO;
        request.RecordTypeId = LOG_REQUEST_ANAGRAFICA_RT;
        request.OB_ReducedOldData__c = oldData;
        request.OB_ReducedNewData__c = newData;

        insert request;

        Test.startTest( );
        String serializedLogRequestWrapper = OB_Maintenance_View_Request_Controller.retrieveLogRequest( request.id );
        Test.stopTest( );

        Map<String, Object> wrapperMap = ( Map<String, Object> ) JSON.deserializeUntyped( serializedLogRequestWrapper );
        System.assert( !Boolean.valueOf( wrapperMap.get( 'errorOccurred' ) ) );
    }

    @isTest
    public static void acceptLogRequestFinalATest( )
    {
        NE__Service_Point__c sp = new NE__Service_Point__c( );
        insert sp;
        String rnd = '{"obj":[{"attributes":{"type":"NE__Service_Point__c"},"Id": "' + sp.id + '", "Name":"test1", "OB_Opening_Time__c" : "09:00:00.000Z", "OB_Break_Start_Time__c" : "13:00:00.000Z", "OB_Break_End_Time__c" : "14:00:00.000Z", "OB_Ending_Time__c" : "18:00:00.000Z"}]}';
        String rod = '{"obj":[{"attributes":{"type":"NE__Service_Point__c"},"Id": "' + sp.id + '", "Name":"test2", "OB_Opening_Time__c" : "09:00:00.000Z", "OB_Break_Start_Time__c" : "13:00:00.000Z", "OB_Break_End_Time__c" : "14:00:00.000Z", "OB_Ending_Time__c" : "18:00:00.000Z"}]}';
        OB_LogRequest__c lr = new OB_LogRequest__c( OB_ABI__c = '12345', OB_ApprovalProcess__c = false, OB_ReducedNewData__c = rnd, OB_ReducedOldData__c = rod );
        insert lr;
        Test.startTest( );
        OB_Maintenance_View_Request_Controller.acceptLogRequestFinal( lr.id );
        Test.stopTest( );
    }

    @isTest
    public static void acceptLogRequestFinalBTest( )
    {
        NE__Service_Point__c sp = new NE__Service_Point__c( );
        insert sp;
        String rnd = '{"obj":[{"attributes":{"type":"NE__Service_Point__c"}, "id" : "' + sp.id + '","Name":"test1"}]}';
        String rod = '{"obj":[{"attributes":{"type":"NE__Service_Point__c"}, "id" : "' + sp.id + '","Name":"test2"}]}';
        OB_LogRequest__c lr = new OB_LogRequest__c( OB_ABI__c = '12345', OB_ApprovalProcess__c = false, OB_ReducedNewData__c = rnd, OB_ReducedOldData__c = rod );
        insert lr;
        Test.startTest( );
        OB_Maintenance_View_Request_Controller.acceptLogRequestFinal( lr.id );
        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose: Method to check acceptLogRequestFinal, logRequest should be in status Confermato

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0       Kinga Fornal           09/08/2019         Created             -
    ********************************************************************************/
    @isTest
    public static void acceptLogRequestFinalTest( )
    {
        NE__Service_Point__c servicePoint = OB_TestDataFactory.getServicePoint( );
        insert servicePoint;
        ExternalSourceMapping__c mapping = new ExternalSourceMapping__c( );
        mapping.OB_Service_Point_ID__c = servicePoint.Id;
        insert mapping;
        OB_LogRequest__c request = OB_TestDataFactory.getLogRequest( );
        request.OB_ServicePointId__c = servicePoint.Id;
        request.OB_ReducedNewData__c = '{"obj":[{"attributes":{"type":"Contact","url":"/services/data/v46.0/sobjects/Contact/0039E00000mpvFPQAY"},"OB_Document_Number__c":"docNumb880", "LastName":"Test"}]}';
        insert request;
        Contact cont = new Contact( );
        cont.AccountId = request.OB_AccountId__c;
        cont.LastName = 'test';
        insert cont;
        String rejectReason = 'test';

        Test.startTest( );
        String result = OB_Maintenance_View_Request_Controller.acceptLogRequestFinal( request.id );
        Test.stopTest( );

        List<OB_LogRequest__c> requestAfterAccept = [ SELECT Id,OB_Status__c FROM OB_LogRequest__c WHERE Id = :request.Id LIMIT 1 ];

        System.assertEquals( System.label.OB_MAINTENANCE_LOGREQUEST_STATUS_CONFIRMED, requestAfterAccept.get( 0 ).OB_Status__c );
    }


    /*******************************************************************************
    Purpose:  ?

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0            ?                      ?             Created              ?
    1.1       Grzegorz Banach        25/07/2019         Modified        Temp fix for Log Request JSONs, added asserts
     ********************************************************************************/
    @isTest
    public static void retrieveLogRequestATest( )
    {
        NE__Service_Point__c sp = new NE__Service_Point__c( );
        insert sp;
        String rnd = '{"obj":[{"attributes":{"type":"NE__Service_Point__c"},"Id": "' + sp.id + '", "Name":"test1", "OB_Opening_Time__c" : "09:00:00.000Z", "OB_Break_Start_Time__c" : "13:00:00.000Z", "OB_Break_End_Time__c" : "14:00:00.000Z", "OB_Ending_Time__c" : "18:00:00.000Z"}]}';
        String rod = '{"obj":[{"attributes":{"type":"NE__Service_Point__c"},"Id": "' + sp.id + '", "Name":"test2", "OB_Opening_Time__c" : "09:00:00.000Z", "OB_Break_Start_Time__c" : "13:00:00.000Z", "OB_Break_End_Time__c" : "14:00:00.000Z", "OB_Ending_Time__c" : "18:00:00.000Z"}]}';
        OB_LogRequest__c lr = OB_TestDataFactory.getLogRequest();
        lr.OB_ABI__c = '12345';
        lr.OB_ApprovalProcess__c = false;
        lr.OB_ReducednewData__c = rnd;
        lr.OB_ReducedOldData__c = rod;
        lr.RecordTypeId = LOG_REQUEST_ANAGRAFICA_RT;
        insert lr;
        Test.startTest( );
        String serializedLogRequestWrapper = OB_Maintenance_View_Request_Controller.retrieveLogRequest( lr.id );
        Test.stopTest( );

        Map<String, Object> wrapperMap = ( Map<String, Object> ) JSON.deserializeUntyped( serializedLogRequestWrapper );
        System.assert( !Boolean.valueOf( wrapperMap.get( 'errorOccurred' ) ) );
    }

    /*******************************************************************************
    Purpose:  ?

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0            ?                      ?             Created              ?
    1.1       Grzegorz Banach        25/07/2019         Modified        Temp fix for Log Request JSONs, added asserts
     ********************************************************************************/
    @isTest
    public static void retrieveLogRequestBTest( )
    {
        NE__Service_Point__c sp = new NE__Service_Point__c( );
        insert sp;
        String rnd = '[{"obj":[{"attributes":{"type":"NE__Service_Point__c"},"Id": "' + sp.id + '", "Name":"test1"}]}]';
        String rod = '[{"obj":[{"attributes":{"type":"NE__Service_Point__c"},"Id": "' + sp.id + '", "Name":"test2"}]}]';
        OB_LogRequest__c lr = OB_TestDataFactory.getLogRequest( );
        lr.OB_ABI__c = '12345';
        lr.OB_ApprovalProcess__c = false;
        lr.OB_ReducednewData__c = rnd;
        lr.OB_ReducedOldData__c = rod;
        insert lr;
        Test.startTest( );
        String serializedCobaWrapperList = OB_Maintenance_View_Request_Controller.retrieveLogRequest( lr.id );
        Test.stopTest( );

        System.assert( !String.isBlank( serializedCobaWrapperList ) );
    }

    //getBooleanValueToCheck
    @isTest
    public static void getBooleanValueToCheckTest( )
    {
        Test.startTest( );
        OB_Maintenance_View_Request_Controller.getBooleanValueToCheck( );
        Test.stopTest( );

    }

    //checkProfile
    @isTest
    public static void checkProfileTest( )
    {
        OB_LogRequest__c request = new OB_LogRequest__c( );
        //request.OB_Status__c = 'Confermato';
        insert request;

        Test.startTest( );
        OB_Maintenance_View_Request_Controller.checkProfile( String.valueOf( request.Id ) );
        Test.stopTest( );

    }

    @isTest
    public static void updateRequestSiaTest( )
    {
        prepareConfiguration( );//NEXI-149 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 02/07/2019
        OB_LogRequest__c logRequest = OB_TestDataFactory.getLogRequest( );
        insert logRequest;
        //NEXI-149 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 02/07/2019 Start
        Test.setMock( HttpCalloutMock.class, new OB_MockCallServiceBlackList( ) );
        Test.startTest( );
        OB_Maintenance_View_Request_Controller.updateRequestSia( logRequest );
        Test.stopTest( );
        //NEXI-149 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 02/07/2019 Stop
    }

    @isTest
    public static void getLogRequestTest( )
    {
        OB_LogRequest__c logRequest = OB_TestDataFactory.getLogRequest( );
        insert logRequest;

        OB_Maintenance_View_Request_Controller.getLogRequest( logRequest.id );
    }

    @isTest
    public static void updateRequestEwMoneticaTest( )
    {
        prepareConfiguration( );//NEXI-149 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 02/07/2019
        OB_LogRequest__c logRequest = OB_TestDataFactory.getLogRequest( );
        insert logRequest;
        //NEXI-149 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 02/07/2019 Start
        Test.setMock( HttpCalloutMock.class, new OB_MockCallServiceBlackList( ) );
        Test.startTest( );
        OB_Maintenance_View_Request_Controller.updateRequestEwMonetica( logRequest );
        Test.stopTest( );
        //NEXI-149 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 02/07/2019 Stop
    }

    /*******************************************************************************
    Purpose:  Method tests retrieveLogRequest method - with Codes Wrapper initialized

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       27/08/2019      Created         NEXI-274
    ********************************************************************************/
    @isTest
    private static void retrieveLogRequestESMWithCodesWrapper( )
    {
        NE__Service_Point__c testServicePoint = new NE__Service_Point__c( );
        insert testServicePoint;
        ExternalSourceMapping__c testESM = OB_TestDataFactory.getExternalSourceMapping( );
        testESM.OB_Service_Point_ID__c = testServicePoint.Id;
        insert testESM;
        OB_LogRequest__c testLogRequest = OB_TestDataFactory.getLogRequest( );
        testLogRequest.OB_isNotIntegrated__c = false;
        testLogRequest.OB_MaintenanceType__c = OB_UtilityConstants.ANAGRAFICA;
        testLogRequest.OB_ChangeServicePointData__c = true;

        Map<String, List<Sobject>> newDataMap = new Map<String, List<Sobject>>( );
        newDataMap.put( 'obj', new List<Sobject> {testESM} );
        Map<String, List<Sobject>> oldDataMap = new Map<String, List<Sobject>>( );
        testESM.OB_Source__c = 'test';
        update testESM;
        oldDataMap.put( 'obj', new List<Sobject> {testESM} );
        testLogRequest.OB_ReducedOldData__c = JSON.serialize( oldDataMap );
        testLogRequest.OB_ReducedNewData__c = JSON.serialize( newDataMap );
        insert testLogRequest;

        Test.startTest( );
        String result = OB_Maintenance_View_Request_Controller.retrieveLogRequest( testLogRequest.id );
        Test.stopTest( );

        System.assert( !String.isBlank( result ) );
    }
}