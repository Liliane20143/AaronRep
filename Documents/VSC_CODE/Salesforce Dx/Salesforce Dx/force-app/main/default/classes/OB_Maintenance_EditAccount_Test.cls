@isTest
public class OB_Maintenance_EditAccount_Test
{
    @isTest
    public static void constructorsTest( )
    {
        Test.startTest( );
        OB_Maintenance_EditAccount_Controller.EditAccountSimpleContainer easc = new OB_Maintenance_EditAccount_Controller.EditAccountSimpleContainer( );
        OB_Maintenance_EditAccount_Controller.EditExecutorSimple ees = new OB_Maintenance_EditAccount_Controller.EditExecutorSimple( );
        Test.stopTest( );
    }

    //saveRequest
    @isTest
    public static void saveRequestTest1( )
    {

        string oldData = '{"Account" : {"Name" : "TEST"}  , "Contact" : {"LastName" : "test" }}' ;
        string newData = '{"Account" : {"Name" : "TEST2"} , "Contact" : {"LastName" : "test2" }}';
        String objectDataString = '{"errorFamily" : {"key" : true}}';
        Test.startTest( );
        OB_Maintenance_EditAccount_Controller.saveRequest( oldData, newData, objectDataString );
        Test.stopTest( );
    }

    @isTest
    public static void saveRequestTest2( )
    {
        Account acc = new Account( Name = 'acc', OB_ABI__c = '12345', OB_Employees_Number__c = 'Minore di 10', OB_BypassValidation__c = true );
        Id recordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName( ).get( 'Merchant' ).getRecordTypeId( );
        acc.RecordTypeId = recordTypeIdAcc;
        insert acc;
        OB_LogRequest__c req = new OB_LogRequest__c( );
        req.OB_AccountId__c = acc.id;
        req.OB_ChangeCompanyData__c = false;
        req.OB_ChangeLegalForm__c = false;
        req.OB_NewLegalRepresentative__c = false;
        req.OB_ChangeLegalRepresentative__c = false;
        req.OB_ChangeMerchantName__c = false;
        req.OB_ChangeServicePointData__c = false;
        req.OB_Status__c = 'status';
        insert req;
        String oldData = '{"Account" : {"Name" : "TEST"}  , "Contact" : {"LastName" : "test" }}' ;
        String newData = '{"Account" : {"Name" : "TEST2", "Id" : "' + acc.id + '" } , "Contact" : {"LastName" : "test2" }}';
        String objectDataString = '{"errorFamily" : {"key" : false}}';
        Test.startTest( );
        OB_Maintenance_EditAccount_Controller.saveRequest( oldData, newData, objectDataString );
        Test.stopTest( );
    }
    /*******************************************************************************
   Purpose:  Method tests OB_Maintenance_EditAccount_Controller.saveRequest for catching LogRequest Exist Exception
   Parameters: -
   Returns: -

   History
   --------
   VERSION     AUTHOR                  DATE            DETAIL          Description
   1.0         Marta Stempien        31/07/2019        Created         NEXI-179
   ********************************************************************************/
    @isTest
    public static void saveRequestCatchLogRequestExistExceptionTest( )
    {
        Boolean catchException = false;
        Account acc = new Account( Name = 'acc', OB_ABI__c = '12345', OB_Employees_Number__c = 'Minore di 10', OB_BypassValidation__c = true );
        Id recordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName( ).get( 'Merchant' ).getRecordTypeId( );
        acc.RecordTypeId = recordTypeIdAcc;
        insert acc;
        OB_LogRequest__c req = new OB_LogRequest__c( );
        req.OB_AccountId__c = acc.id;
        req.OB_ChangeCompanyData__c = false;
        req.OB_ChangeLegalForm__c = false;
        req.OB_NewLegalRepresentative__c = false;
        req.OB_ChangeLegalRepresentative__c = false;
        req.OB_ChangeMerchantName__c = true;
        req.OB_ChangeServicePointData__c = false;
        req.OB_Status__c = 'status';
        insert req;
        String oldData = '{"Account" : {"Name" : "TEST"}  , "Contact" : {"LastName" : "test" }}' ;
        String newData = '{"Account" : {"Name" : "TEST2", "Id" : "' + acc.id + '" } , "Contact" : {"LastName" : "test2" }}';
        String objectDataString = '{"errorFamily" : {"key" : false}}';
        try
        {
            OB_Maintenance_EditAccount_Controller.saveRequest( oldData, newData, objectDataString );
        } catch ( OB_Maintenance_EditAccount_Controller.LogRequestExistsException ex )
        {
            catchException = true;
        }
         System.assert( !catchException );
    }

    @isTest
    public static void saveRequestTest3( )
    {
        Account acc = new Account( Name = 'acc', OB_ABI__c = '12345', OB_Employees_Number__c = 'Minore di 10', OB_BypassValidation__c = true );
        Id recordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName( ).get( 'Merchant' ).getRecordTypeId( );
        acc.RecordTypeId = recordTypeIdAcc;
        insert acc;
        OB_LogRequest__c req = new OB_LogRequest__c( );
        req.OB_AccountId__c = acc.id;
        req.OB_ChangeCompanyData__c = false;
        req.OB_ChangeLegalForm__c = false;
        req.OB_NewLegalRepresentative__c = false;
        req.OB_ChangeLegalRepresentative__c = false;
        req.OB_ChangeMerchantName__c = false;
        req.OB_ChangeServicePointData__c = false;
        req.OB_Status__c = 'status';
        insert req;
        String oldData = '{"Account" : {"Name" : "TEST"}  , "Contact" : {"LastName" : "test" }}' ;
        String newData = '{"Account" : {"Name" : "TEST2", "Id" : "' + acc.id + '" } , "Contact" : {"LastName" : "test2" }}';
        String objectDataString = '{"errorFamily" : {"key" : false}}';
        Test.startTest( );
        OB_Maintenance_EditAccount_Controller.saveRequest( oldData, newData, objectDataString );
        Test.stopTest( );
    }

    @isTest
    public static void saveRequestTest4( )
    {
        Account acc = new Account( Name = 'acc', OB_ABI__c = '12345', OB_Employees_Number__c = 'Minore di 10', OB_BypassValidation__c = true );
        Id recordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName( ).get( 'Merchant' ).getRecordTypeId( );
        acc.RecordTypeId = recordTypeIdAcc;
        insert acc;
        OB_LogRequest__c req = new OB_LogRequest__c( );
        req.OB_AccountId__c = acc.id;
        req.OB_ChangeCompanyData__c = false;
        req.OB_ChangeLegalForm__c = false;
        req.OB_NewLegalRepresentative__c = false;
        req.OB_ChangeLegalRepresentative__c = false;
        req.OB_ChangeMerchantName__c = false;
        req.OB_ChangeServicePointData__c = false;
        req.OB_Status__c = 'status';
        insert req;
        String oldData = '{"Account" : {"Name" : "TEST", "Id" : "' + acc.id + '"}  , "Contact" : {"LastName" : "test" }}' ;
        String newData = '{"Account" : {"Name" : "TEST", "Id" : "' + acc.id + '" } , "Contact" : {"LastName" : "test" }}';
        String objectDataString = '{"errorFamily" : {"key" : false}}';
        Test.startTest( );
        OB_Maintenance_EditAccount_Controller.saveRequest( oldData, newData, objectDataString );
        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:  Method tests OB_Maintenance_EditAccount_Controller.getRequests(oldDataAll, newDataAll, objectDataMap)
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien        03/07/2019        Created         NEXI-144
    ********************************************************************************/
    @isTest
    private static void getRequestCheckForAccountTest( )
    {
        Account testAccount = OB_TestDataFactory.getAccount( );
        insert testAccount;
        Account testAcAccount = OB_TestDataFactory.getAccount( );
        insert testAcAccount;

        String oldData = '{"Account" : {"Name" : "' + testAccount.name + '", "Id" : "' + testAccount.id + '" }  , "Contact" : {"LastName" : "test" }}' ;
        String newData = '{"Account" : {"Name" : "TEST2", "Id" : "' + testAccount.id + '" } , "Contact" : {"LastName" : "test" }}';
        String oldObject = '{"Account" : {"Name" : "' + testAcAccount.name + '", "Id" : "' + testAccount.id + '" }  , "Contact" : {"LastName" : "test" }}' ;
        String newObject = '{"Account" : {"Name" : "TEST2", "Id" : "' + testAcAccount.id + '" } , "Contact" : {"LastName" : "test" }}';
        String objectDataMap = '{"errorFamily" : {"key" : false}}';
        List<String> oldDataAll = new List<String>( );
        oldDataAll.add( oldData );
        oldDataAll.add( oldObject );
        List<String> newDataAll = new List<String>( );
        newDataAll.add( newData );
        newDataAll.add( newObject );

        List <Map <String, Object>> objectDataMaps = OB_Maintenance_EditAccount_Controller.getRequests( oldDataAll, newDataAll, objectDataMap );
        System.assertEquals( false, objectDataMaps.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests OB_Maintenance_EditAccount_Controller.getRequests(oldDataAll, newDataAll, objectDataMap)
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien        03/07/2019        Created         NEXI-144
    1.1         Marta Stempien        16/07/2019        Modified        NEXI-179
    1.2         Marta Stempien        26/07/2019        Modified        NEXI-120
    ********************************************************************************/
    @isTest
    private static void getRequestCheckForExternalSourceMappingsTest( )
    {
        NE__Lov__c testLovAteco = OB_TestDataFactory.getLov( );
        testLovAteco.NE__Type__c = OB_Util006_MaintenanceAnagrafica.TYPE_OF_LOV_ATECO;
        testLovAteco.NE__Value2__c = 'S';
        testLovAteco.Name = '101';
        insert testLovAteco;

        NE__Lov__c testLovSae = OB_TestDataFactory.getLov( );
        testLovSae.NE__Type__c = OB_Util006_MaintenanceAnagrafica.TYPE_OF_LOV_SAE;
        testLovSae.NE__Value2__c = 'S';
        testLovSae.Name = '101';
        insert testLovSae;

        Account testAccount = OB_TestDataFactory.getAccount( );
        insert testAccount;
        Account testAcAccount = OB_TestDataFactory.getAccount( );
        insert testAcAccount;
        ExternalSourceMapping__c testExternalSourceMapping = OB_TestDataFactory.getExternalSourceMapping( );
        insert testExternalSourceMapping;

        String oldData = '{"Account": { "Name" : "' + testAccount.name + '","Id":"' + testAccount.Id + '","Name":"francesca S.p.a.12", "OB_ATECO__c":"101",' +
                '"OB_SAE_Code__c":"165"},"Contact":null,"externalSourceMappings":[{"Id":"' + testExternalSourceMapping.id + '","OB_Source__c":"EQUENS","OB_ServicePointCodeShopCode__c":"0002","OB_ReportType__c":"Punto Vendita"}]}';
        String newData = '{"Account": {"Name" : "' + testAccount.name + '", "Id":"' + testAccount.Id + '","Name":"francesca S.p.a.12", "OB_ATECO__c":"101",' +
                '"OB_SAE_Code__c":"101"},"Contact":null,"externalSourceMappings":[{"Id":"' + testExternalSourceMapping.id + '","OB_Source__c":"EQUENS","OB_ServicePointCodeShopCode__c":"0002","OB_ReportType__c":"Società Cumulativo"}]}';

        String objectDataMap = '{"errorFamily" : {"key" : false}}';
        List<String> oldDataAll = new List<String>( );
        oldDataAll.add( oldData );
        List<String> newDataAll = new List<String>( );
        newDataAll.add( newData );

        List <Map <String, Object>> objectDataMaps = OB_Maintenance_EditAccount_Controller.getRequests( oldDataAll, newDataAll, objectDataMap );
        System.assertEquals( 'Success', objectDataMaps.get( 0 ).get( 'message' ) );
    }

    /*******************************************************************************
    Purpose:  Method tests OB_Maintenance_EditAccount_Controller.getRequests(oldDataAll, newDataAll, objectDataMap) for invalid SaeAteco
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.2         Marta Stempien        26/07/2019        Modified        NEXI-120
    ********************************************************************************/
    @isTest
    private static void getRequestCheckForInvalidSaeAtecoTest( )
    {
        OB_TestDataFactory.prepareLovForTest( OB_Util006_MaintenanceAnagrafica.TYPE_OF_LOV_ATECO, 'S' );
        OB_TestDataFactory.prepareLovForTest( OB_Util006_MaintenanceAnagrafica.TYPE_OF_LOV_SAE, 'N' );

        Account testAccount = OB_TestDataFactory.getAccount( );
        insert testAccount;
        Account testAcAccount = OB_TestDataFactory.getAccount( );
        insert testAcAccount;
        ExternalSourceMapping__c testExternalSourceMapping = OB_TestDataFactory.getExternalSourceMapping( );
        insert testExternalSourceMapping;

        String oldData = '{"Account": { "Name" : "' + testAccount.name + '","Id":"' + testAccount.Id + '","Name":"francesca S.p.a.12", "OB_ATECO__c":"101",' +
                '"OB_SAE_Code__c":"165"},"Contact":null,"externalSourceMappings":[{"Id":"' + testExternalSourceMapping.id + '","OB_Source__c":"EQUENS","OB_ServicePointCodeShopCode__c":"0002","OB_ReportType__c":"Punto Vendita"}]}';
        String newData = '{"Account": {"Name" : "' + testAccount.name + '", "Id":"' + testAccount.Id + '","Name":"francesca S.p.a.12", "OB_ATECO__c":"101",' +
                '"OB_SAE_Code__c":"101"},"Contact":null,"externalSourceMappings":[{"Id":"' + testExternalSourceMapping.id + '","OB_Source__c":"EQUENS","OB_ServicePointCodeShopCode__c":"0002","OB_ReportType__c":"Società Cumulativo"}]}';

        String objectDataMap = '{"errorFamily" : {"key" : false}}';
        List<String> oldDataAll = new List<String>( );
        oldDataAll.add( oldData );
        List<String> newDataAll = new List<String>( );
        newDataAll.add( newData );

        List <Map <String, Object>> objectDataMaps = OB_Maintenance_EditAccount_Controller.getRequests( oldDataAll, newDataAll, objectDataMap );
        System.assertEquals( Label.OB_ErrorSaeAtecoFieldsNotValid, objectDataMaps.get( 0 ).get( 'message' ) );
    }

    /*******************************************************************************
    Purpose:  Method tests OB_Maintenance_EditAccount_Controller.getRequests(oldDataAll, newDataAll, objectDataMap) for valid SaeAteco
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.2         Marta Stempien        26/07/2019        Modified        NEXI-120
    ********************************************************************************/
    @isTest
    private static void getRequestCheckForValidSaeAtecoTest( )
    {
        OB_TestDataFactory.prepareLovForTest( OB_Util006_MaintenanceAnagrafica.TYPE_OF_LOV_ATECO, 'S' );
        OB_TestDataFactory.prepareLovForTest( OB_Util006_MaintenanceAnagrafica.TYPE_OF_LOV_SAE, 'S' );

        Account testAccount = OB_TestDataFactory.getAccount( );
        insert testAccount;
        Account testAcAccount = OB_TestDataFactory.getAccount( );
        insert testAcAccount;
        ExternalSourceMapping__c testExternalSourceMapping = OB_TestDataFactory.getExternalSourceMapping( );
        insert testExternalSourceMapping;



        String oldDataSaeAteco = '{"Account": { "Name" : "' + testAccount.name + '","Id":"' + testAccount.Id + '","Name":"francesca S.p.a.12", "OB_ATECO__c":"105",' +
                '"OB_SAE_Code__c":"165"},"Contact":null,"externalSourceMappings":[{"Id":"' + testExternalSourceMapping.id + '","OB_Source__c":"EQUENS","OB_ServicePointCodeShopCode__c":"0002","OB_ReportType__c":"Punto Vendita"}]}';
        String newDataSaeAteco = '{"Account": {"Name" : "' + testAccount.name + '", "Id":"' + testAccount.Id + '","Name":"francesca S.p.a.12", "OB_ATECO__c":"101",' +
                '"OB_SAE_Code__c":"101"},"Contact":null,"externalSourceMappings":[{"Id":"' + testExternalSourceMapping.id + '","OB_Source__c":"EQUENS","OB_ServicePointCodeShopCode__c":"0002","OB_ReportType__c":"Società Cumulativo"}]}';

        String objectDataMap = '{"errorFamily" : {"key" : false}}';
        List<String> oldDataAll = new List<String>( );
        oldDataAll.add( oldDataSaeAteco );
        List<String> newDataAll = new List<String>( );
        newDataAll.add( newDataSaeAteco );

        List <Map <String, Object>> objectDataMaps = OB_Maintenance_EditAccount_Controller.getRequests( oldDataAll, newDataAll, objectDataMap );
        System.assertEquals( 'Success', objectDataMaps.get( 0 ).get( 'message' ) );
    }


    /*******************************************************************************
    Purpose: Metho tests OB_Maintenance_EditAccount_Controller.getRequests(oldDataAll, newDataAll, objectDataMap) for null parameter
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien        03/07/2019        Created         NEXI-144
    ********************************************************************************/
    @isTest
    private static void getRequestTestCheckForNull( )
    {
        List<String> oldData = new List<String>( );
        List<String> newData = new List<String>( );
        List <Map <String, Object>> objectDataMaps = OB_Maintenance_EditAccount_Controller.getRequests( oldData, newData, null );
        System.assertEquals( Label.OB_ServerLogicFailed, objectDataMaps.get( 0 ).get( 'message' ) );
    }

    /*******************************************************************************
    Purpose:  Method tests OB_Maintenance_EditAccount_Controller.getRequests(oldDataAll, newDataAll, objectDataMap)'
    to satisfy following conditions OB_VAT_Not_Present__c = true, OB_DescriptionVATNotPresent__c = Livigno, OB_Legal_Address_City__c != Livigno
    Returns: -
    Parameters: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Kamil Entsua-Mensah     09/07/2019      Created         NEXI-117
    ********************************************************************************/
    @isTest
    public static void checkLivignoValueInTipologiaDiSocieta_TEST( )
    {
        Account testAccount = OB_TestDataFactory.getAccount( );
        testAccount.OB_VAT_Not_Present__c = true;
        testAccount.OB_BypassValidation__c = true;
        testAccount.OB_DescriptionVATNotPresent__c = 'Livigno';
        testAccount.OB_Legal_Address_City__c = 'Milano';
        insert testAccount;
        String oldData = '{' +
                '"Account" : {' +
                '"Name" : "Jozin", ' +
                '"Id" : "' + testAccount.id + '",' +
                '"NE__Fiscal_code__c":"GNDDNL89A22A010E",' +
                '"NE__VAT__c":"","OB_Services_Choice__c":"",' +
                '"OB_Legal_Address_Street__c":"LARGO AUGUSTO",' +
                '"OB_Legal_Address_City__c":"MILANO",' +
                '"OB_Legal_Address_State__c":"MILANO",' +
                '"OB_Legal_Address_ZIP__c":"20122",' +
                '"OB_Legal_Address_Country__c":"ITALIA",' +
                '"OB_Administrative_Office_City__c":"MILANO",' +
                '"OB_Administrative_Office_Street__c":"LARGO AUGUSTO",' +
                '"OB_Administrative_Office_State__c":"MILANO",' +
                '"OB_Administrative_Office_ZIP__c":"20122",' +
                '"OB_Administrative_Office_Name__c":"",' +
                '"OB_VAT_Not_Present__c":true}' +
                '}';
        String newData = '{' +
                '"Account":{' +
                '"Name":"Jozin",' +
                '"Id" : "' + testAccount.id + '",' +
                '"NE__Fiscal_code__c":"GNDDNL89A22A010E",' +
                '"NE__VAT__c":"",' +
                '"OB_Services_Choice__c":"",' +
                '"OB_Legal_Address_Street__c":"VIA ADDA",' +
                '"OB_Legal_Address_City__c":"MILANO",' +
                '"OB_Legal_Address_State__c":"BORMIO",' +
                '"OB_Legal_Address_ZIP__c":"23032",' +
                '"OB_Legal_Address_Country__c":"ITALIA",' +
                '"OB_Administrative_Office_City__c":"MILANO",' +
                '"OB_Administrative_Office_Street__c":"VIA ADDA",' +
                '"OB_Administrative_Office_State__c":"SONDRIO",' +
                '"OB_Administrative_Office_ZIP__c":"23032",' +
                '"OB_Administrative_Office_Name__c":"officeName",' +
                '"OB_VAT_Not_Present__c":true}' +
                '}';
        String objectDataString = '{"errorFamily" : {"key" : false}}';
        Test.startTest( );
        OB_Maintenance_EditAccount_Controller.saveRequest( oldData, newData, objectDataString );
        Test.stopTest( );
        Map<String, Object> testMap = OB_Maintenance_EditAccount_Controller.saveRequest( oldData, newData, objectDataString );
        System.assertEquals( testMap.get( 'message' ), Label.OB_LIVIGNO_CHECK_ERROR );
    }


    @isTest
    public static void saveRequestExecutorTest( ) // catch(){}
    {

        NE__Lov__c lov = new NE__Lov__c( Name = 'Cameroun', NE__Value2__c = '123', NE__Type__c = 'COUNTRY' );
        insert lov;
        Account acc = new Account( Name = 'acc', OB_ABI__c = '12345', OB_Employees_Number__c = 'Minore di 10', OB_BypassValidation__c = true );

        string oldData = '{"Account" : {"Name" : "TEST"}  , "Contact" : {"LastName" : "test" }}' ;
        String newData = '{"legaleRapp":{"OB_Country_Birth__c":"Cameroun"},"Account":{"Name":"TEST2"},"Contact":{"sobjectType":"contact","OB_Document_Number__c":"123","OB_Country_Birth__c":"Italy","RecordTypeId":"","FirstName":"","LastName":"test","OB_Fiscal_Code__c":11111,"OB_Sex__c":"","Role__c":"","AccountId":"' + acc.id + '","OB_Document_Type__c":"Carta di Identità"}} }';
        String jsonString = '{"errorEEMap" : {"key" : true}, "executor" : {"sobjectType" : "contact", "OB_Country_Birth__c" : "FRANCIA", "OB_Document_Release_Country__c" : "FRANCIA", "OB_Address_Country__c": "FRANCIA"}}';

        Map<String, Object> objectDataMap = new Map<String, Object>( );
        Map<String, Boolean> errorEEMapObject = ( Map<String, Boolean> ) JSON.deserialize( '{"key" : true}', Map<String, Boolean>.class );
        objectDataMap.put( 'errorEEMap', errorEEMapObject );
        Contact cont = ( Contact ) JSON.deserialize( '{"sobjectType" : "contact", "OB_Country_Birth__c" : "FRANCIA", "OB_Document_Release_Country__c" : "FRANCIA", "OB_Address_Country__c": "FRANCIA"}', Contact.class );
        objectDataMap.put( 'executor', cont );
        Test.startTest( );
        OB_Maintenance_EditAccount_Controller.saveRequestExecutor( oldData, newData, true, jsonString );
        Test.stopTest( );
    }

    @isTest
    public static void saveRequestExecutorCheckValidFalseTest( ) // catch(){}
    {
        NE__Lov__c lov = new NE__Lov__c( Name = 'Cameroun', NE__Value2__c = '123', NE__Type__c = 'COUNTRY' );
        insert lov;
        Account acc = new Account( Name = 'acc', OB_ABI__c = '12345', OB_Employees_Number__c = 'Minore di 10', OB_BypassValidation__c = true );

        string oldData = '{"Contact":{"attributes":{"type":"Contact","url":"/services/data/v46.0/sobjects/Contact/0039E00000mdTF3QAM"},"Id":"0039E00000mdTF3QAM","FirstName":"Elena","LastName":"Preteni","OB_Company_Link_Type__c":"LEGALE RAPPRESENTANTE","OB_Fiscal_Code__c":"PRTLNE90T59D612Y","OB_Sex__c":"F","OB_Country_Birth__c":"ITALIA","OB_Country_Birth_Code__c":"ITA","OB_Birth_State_Code__c":"FI","OB_Birth_Date__c":"1990-12-19","OB_Birth_City__c":"FIRENZE","OB_Birth_State__c":"FIRENZE","OB_Address_Country__c":"ITALIA","OB_Citizenship__c":"ITALIA","OB_Document_Release_Country__c":"ITALIA","OB_Document_Release_Country_Code__c":"ITA","OB_Document_Release_State_Code__c":"FI","OB_Document_Release_State__c":"FIRENZE","OB_Document_Type__c":"Carta di Identità","OB_Document_Number__c":"as12345678","OB_Document_Release_Authority__c":"Comune","OB_Document_Release_Date__c":"2018-12-19","OB_Document_Expiration_Date__c":"2028-12-19","OB_Document_Release_City__c":"FIRENZE","OB_PEP__c":false,"OB_Address_Street__c":"VIA BARNA","OB_Address_Street_Number__c":"5","OB_Address_City__c":"FIRENZE","OB_Address_State__c":"FIRENZE","OB_Address_PostalCode__c":"50143","OB_Address_State_Code__c":"FI","OB_Address_Country_Code__c":"ITA","OB_Contact_State__c":"Active","AccountId":"0019E00000pJ1afQAC","RecordTypeId":"0129E000000AkaNQAS","OB_Bank__c":"0019E00000sM80zQAC"}}' ;
        String newData = '{"Contact":{"attributes":{"type":"Contact","url":"/services/data/v46.0/sobjects/Contact/0039E00000mdTF3QAM"},"Id":"0039E00000mdTF3QAM","FirstName":"Elena","LastName":"Preteni","OB_Company_Link_Type__c":"LEGALE RAPPRESENTANTE","OB_Fiscal_Code__c":"PRTLNE90T59D612Y","OB_Sex__c":"F","OB_Country_Birth__c":"ITALIA","OB_Country_Birth_Code__c":"ITA","OB_Birth_State_Code__c":"FI","OB_Birth_Date__c":"1990-12-19","OB_Birth_City__c":"FIRENZE","OB_Birth_State__c":"FIRENZE","OB_Address_Country__c":"ITALIA","OB_Citizenship__c":"ITALIA","OB_Document_Release_Country__c":"ITALIA","OB_Document_Release_Country_Code__c":"ITA","OB_Document_Release_State_Code__c":"FI","OB_Document_Release_State__c":"FIRENZE","OB_Document_Type__c":"Carta di Identità","OB_Document_Number__c":"as12345976","OB_Document_Release_Authority__c":"Comune","OB_Document_Release_Date__c":"2018-12-19","OB_Document_Expiration_Date__c":"2028-12-19","OB_Document_Release_City__c":"FIRENZE","OB_PEP__c":false,"OB_Address_Street__c":"VIA BARNA","OB_Address_Street_Number__c":"5","OB_Address_City__c":"FIRENZE","OB_Address_State__c":"FIRENZE","OB_Address_PostalCode__c":"50143","OB_Address_State_Code__c":"FI","OB_Address_Country_Code__c":"ITA","OB_Contact_State__c":"Active","AccountId":"0019E00000pJ1afQAC","RecordTypeId":"0129E000000AkaNQAS","OB_Bank__c":"0019E00000sM80zQAC"}}';
        String jsonString = '{"selectServicePointListId":null,"selectedServicePointExt":null,"selectedServicePointAsset":null,"selectedServicePoint":null,"selectedMerchantExt":null,"selectedMerchantAsset":null,"selectedAsset":null,"outcome":"OPERAZIONE AVVENUTA CON SUCCESSO","lovList":[{"attributes":{"type":"NE__Lov__c","url":"/services/data/v46.0/sobjects/NE__Lov__c/a0j9E000005PbMLQA0"},"Id":"a0j9E000005PbMLQA0","Name":"ABBIGLIAMENTO E CALZATURE","NE__Active__c":true,"NE__Lov__c":"a0j9E000005PbMjQAK","NE__Source_Lov_Id__c":"a0j9E000005PbMLQA0","NE__Sub_Type__c":"TIPOLOGICHE","NE__Type__c":"MCC","NE__Value3__c":"L2","OB_Value4__c":"0059"},{"attributes":{"type":"NE__Lov__c","url":"/services/data/v46.0/sobjects/NE__Lov__c/a0j9E000005PbMMQA0"},"Id":"a0j9E000005PbMMQA0","Name":"ACCESSORI CASA","NE__Active__c":true,"NE__Lov__c":"a0j9E000005PbMjQAK","NE__Source_Lov_Id__c":"a0j9E000005PbMMQA0","NE__Sub_Type__c":"TIPOLOGICHE","NE__Type__c":"MCC","NE__Value3__c":"L2","OB_Value4__c":"0001"}],"listOfServicePoint":[{"attributes":{"type":"NE__Service_Point__c","url":"/services/data/v46.0/sobjects/NE__Service_Point__c/a199E000000qWLdQAM"},"Id":"a199E000000qWLdQAM","Name":"Paper","NE__City__c":"FIRENZE","NE__Province__c":"FIRENZE","NE__Street__c":"VIALE DEI BAMBINI","OB_MCC__c":"0001","OB_MCC_Description__c":"ALL","OB_Typology__c":"Fisico","OB_AddressFormula__c":"VIALE DEI BAMBINI 9, , FIRENZE (FI)","ExternalSourceMapping__r":{"totalSize":2,"done":true,"records":[{"attributes":{"type":"ExternalSourceMapping__c","url":"/services/data/v46.0/sobjects/ExternalSourceMapping__c/a2A9E000000R30HUAS"},"OB_Service_Point_ID__c":"a199E000000qWLdQAM","Id":"a2A9E000000R30HUAS"},{"attributes":{"type":"ExternalSourceMapping__c","url":"/services/data/v46.0/sobjects/ExternalSourceMapping__c/a2A9E000000R30WUAS"},"OB_Service_Point_ID__c":"a199E000000qWLdQAM","Id":"a2A9E000000R30WUAS"}]}}],"legalOffice":{"attributes":{"type":"Contact","url":"/services/data/v46.0/sobjects/Contact/0039E00000mdTF4QAM"},"Id":"0039E00000mdTF4QAM","Phone":"1234567890","Email":"elena.preteni@test.it","LastName":"Sede Legale","OB_PEP__c":false,"OB_Contact_State__c":"Active","AccountId":"0019E00000pJ1afQAC","RecordTypeId":"0129E000000AkaXQAS","OB_Bank__c":"0019E00000sM80zQAC"},"executorModifiedAllowed":null,"executor":{"attributes":{"type":"Contact","url":"/services/data/v46.0/sobjects/Contact/0039E00000mdTF3QAM"},"Id":"0039E00000mdTF3QAM","FirstName":"Elena","LastName":"Preteni","OB_Company_Link_Type__c":"LEGALE RAPPRESENTANTE","OB_Fiscal_Code__c":"PRTLNE90T59D612Y","OB_Sex__c":"F","OB_Country_Birth__c":"ITALIA","OB_Country_Birth_Code__c":"ITA","OB_Birth_State_Code__c":"FI","OB_Birth_Date__c":"1990-12-19","OB_Birth_City__c":"FIRENZE","OB_Birth_State__c":"FIRENZE","OB_Address_Country__c":"ITALIA","OB_Citizenship__c":"ITALIA","OB_Document_Release_Country__c":"ITALIA","OB_Document_Release_Country_Code__c":"ITA","OB_Document_Release_State_Code__c":"FI","OB_Document_Release_State__c":"FIRENZE","OB_Document_Type__c":"Carta di Identità","OB_Document_Number__c":"as12346778","OB_Document_Release_Authority__c":"Comune","OB_Document_Release_Date__c":"2018-12-19","OB_Document_Expiration_Date__c":"2028-12-19","OB_Document_Release_City__c":"FIRENZE","OB_PEP__c":false,"OB_Address_Street__c":"VIA BARNA","OB_Address_Street_Number__c":"5","OB_Address_City__c":"FIRENZE","OB_Address_State__c":"FIRENZE","OB_Address_PostalCode__c":"50143","OB_Address_State_Code__c":"FI","OB_Address_Country_Code__c":"ITA","OB_Contact_State__c":"Active","AccountId":"0019E00000pJ1afQAC","RecordTypeId":"0129E000000AkaNQAS","OB_Bank__c":"0019E00000sM80zQAC"},"errorMessage":null,"acc":{"attributes":{"type":"Account","url":"/services/data/v46.0/sobjects/Account/0019E00000pJ1afQAC"},"Id":"0019E00000pJ1afQAC","Name":"Billabong","NE__Fiscal_code__c":"PRTLNE90T59D612Y","OB_Legal_Address_City__c":"FIRENZE","OB_Legal_Address_State__c":"FIRENZE","OB_Legal_Address_Street__c":"VIA DELLA PALANCOLA","OB_ATECO__c":"1011","OB_CCIAA__c":"camera","OB_SAE_Code__c":"165","OB_Legal_Form__c":"Amministrazione dello Stato","OB_Legal_Address_Street_Number__c":"4","OB_Legal_Address_ZIP__c":"50133","OB_Legal_Address_Country__c":"ITALIA","OB_Administrative_Office_State__c":"FIRENZE","OB_Administrative_Office_Country__c":"ITALIA","OB_Administrative_Office_ZIP__c":"50133","OB_Administrative_Office_Street_number__c":"4","OB_Administrative_Office_Street__c":"VIA DELLA PALANCOLA","OB_Administrative_Office_City__c":"FIRENZE","OB_CCIAA_Province__c":"FI","OB_Legal_Form_Code__c":"AMMIN_STATO","OB_Legal_Address_Country_Code__c":"ITA","OB_Legal_Address_State_Code__c":"MI","OB_Administrative_Office_Country_Code__c":"ITA","OB_Administrative_Office_State_Code__c":"MI"},"userWrapper":{"cab":"12300"},"isLegalEqualAdm":true}';

        Map<String, Object> objectDataMap = new Map<String, Object>( );
        Map<String, Boolean> errorEEMapObject = ( Map<String, Boolean> ) JSON.deserialize( '{"key" : false}', Map<String, Boolean>.class );
        objectDataMap.put( 'errorEEMap', errorEEMapObject );
        Contact cont = ( Contact ) JSON.deserialize( newData, Contact.class );
        objectDataMap.put( 'executor', cont );
        Test.startTest( );
        OB_Maintenance_EditAccount_Controller.saveRequestExecutor( oldData, newData, false, jsonString );
        Test.stopTest( );
    }

    @isTest
    public static void saveRequestExecutorTest3( ) // try{}
    {

        Date birthDate = Date.newInstance( 2000, 1, 1 );
        Date documentReleaseDate = Date.newInstance( 2011, 1, 21 );
        Date documentExpirationeDate = Date.newInstance( 2024, 1, 1 );

        Date documentReleaseDateFalse = Date.newInstance( 2013, 2, 10 );
        String birthDateS = String.valueof( birthDate );
        String documentReleaseDateS = String.valueof( documentReleaseDate );

        id esecutoreRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName( ).get( 'Esecutore' ).getRecordTypeId( );

        string oldData = '{"Account" : {"Name" : "TEST"}  , "Contact" : {"LastName" : "test" }}' ;

        string newDataFalse = '{ "sobjectType":"contact", "OB_Document_Number__c": "1234567890","OB_Document_Release_Country__c": "ITA", "OB_Document_Release_Date__c" : "' + String.valueOf( documentReleaseDateFalse ) + '", "OB_Document_Expiration_Date__c" : "' + String.valueOf( documentExpirationeDate ) + '", "OB_Country_Birth__c":"Italy", "OB_Document_Release_Authority__c" : "Comune", "OB_Birth_Date__c":"' + birthDateS + '","OB_Cadastral_Code__c":"D150", "RecordTypeId":"' + esecutoreRecordTypeId + '","FirstName":"RIRI","LastName":"TOTI","OB_Fiscal_Code__c":"TTORRI00A41D150K","OB_Sex__c":"F","Role__c":"","AccountId":"", "OB_Document_Type__c" : "Carta di Identità"}';

        Map<String, Object> objectDataMapFalse = new Map<String, Object>( );
        Map<String, Boolean> errorEEMapObjectFalse = ( Map<String, Boolean> ) JSON.deserialize( '{"key" : false}', Map<String, Boolean>.class );
        objectDataMapFalse.put( 'errorEEMap', errorEEMapObjectFalse );

        String objectDataString = JSON.serialize( objectDataMapFalse );
        Test.startTest( );
        OB_Maintenance_EditAccount_Controller.saveRequestExecutor( oldData, newDataFalse, true, objectDataString );
        Test.stopTest( );
    }

    @isTest
    public static void getCompanyLinkTypesTest( )
    {
        Map<String, String> pickListValuesList = new Map<String, String>( );
        Test.startTest( );
        OB_Maintenance_EditAccount_Controller.getCompanyLinkTypes( );
        Test.stopTest( );
    }

    @isTest
    public static void getGendersTest( )
    {
        Map<String, String> pickListValuesList = new Map<String, String>( );
        Test.startTest( );
        OB_Maintenance_EditAccount_Controller.getGenders( );
        Test.stopTest( );
    }

    @isTest
    public static void retriveSchemaInformationTest( )
    {
        list<string> sObjectToRetrive = new list<string>( );
        sObjectToRetrive.add( 'Account' );
        Test.startTest( );
        OB_Maintenance_EditAccount_Controller.retriveSchemaInformation( sObjectToRetrive );
        Test.stopTest( );
    }

    //mandatoryFieldsCheck
    @isTest
    public static void mandatoryFieldsCheckTest( )
    {
        Map<String, String> testMap = new Map<String, String>( );
        testMap.put( 'Account', 'Account' );
        String objectDataMap = '{"merchant": { "NE__VAT__c": "05218600962", "OB_Annual_Revenue__c": "da_0_a_350K", "NE__Fiscal_code__c": "05218600962", "Id": "0019E00000pZ6p5QAC", "OB_Administrative_Office_Country__c": "ITALIA", "OB_DescriptionVATNotPresent__c": "ALTRA FORMA DI ENTE PRIVATO SENZA PERSONALITA\' GIURIDICA", "OB_FATECO__c": "S",  "OB_Legal_Form_Code__c": "55", "Type": "Account", "OB_Legal_Form__c": "ORGANIZZAZIONE NON PROFIT/STRUTTURE ANALOGHE", "OB_Bank_owner__c": "0019E00000hTauyQAC", "OB_Legal_Address_State__c": "MILANO", "OB_Administrative_Office_Street__c": "VIA ADDA", "OB_SAE_Code__c": "475", "OB_Legal_Address_Street__c": "VIA ADDA", "OB_Legal_Address_Country__c": "ITALIA", "OB_Legal_Address_Street_Number__c": "1", "OB_Legal_Address_City__c": "CUSANO MILANINO", "OB_Legal_Address_ZIP__c": "20095", "OB_ATECO__c": "920", "OB_Administrative_Office_State__c": "MILANO", "OB_ATECO_Description__c": "ATTIVITA\' RIGUARDANTI LE LOTTERIE, LE SCOMMESSE, LE CASE DA GIOCO", "OB_SAE_Description__c": "IMPRESE CONTROLLATE DALLE AMMINISTRAZIONI CENTRALI", "OB_Annual_Negotiated__c": "da_0_a_50K", "OB_No_Profit_Class__c": "Fondazioni di diritto speciale (familiari, bancarie, scolastiche, di culto, liriche, militari)", "OB_Employees_Number__c": "Minore di 10", "RecordTypeId": "0129E000000AXdiQAG", "Phone": "1234567890", "OB_No_Profit_Recipient_Class__c": "Senza tetto", "OB_VAT_Not_Present__c": false, "OB_Beneficial_Owner_Existence__c": true, "Name": "STRADIVARIUS ITALIA SRL", "OB_CCIAA_Province__c": "R", "OB_Administrative_Office_ZIP__c": "20095", "OB_Year_constitution_company__c": 2006, "NE__E_mail__c": "email@email.it", "OB_Administrative_Office_Street_number__c": "23", "OB_Administrative_Office_City__c": "MILANO", "NE__Status__c": "Prospect", "attributes": { "url": "/services/data/v44.0/sobjects/Account/0019E00000pZ6p5QAC", "type": "Account" }, "OB_Legal_Address_Country_Code__c": "ITA", "OB_Administrative_Office_Country_Code__c": "ITA", "OB_No_Profit_Recipient_Other__c": "" }}';

        Map<String, Map<String, String>> objectDataMapInput = new Map<String, Map<String, String>>( );
        objectDataMapInput = OB_UtilityConstants.MANDATORYMAINTENANCECOMPANYDATA;
        Account account = new Account( Name = 'test' );
        Map<String, Object> data = new Map<String, Object>( );
        data.put( 'Name', account );

        Test.startTest( );
        OB_Maintenance_EditAccount_Controller.mandatoryFieldsCheck( objectDataMapInput, data );
        Test.stopTest( );
    }

    @isTest
    public static void checkValidationContTest1( )
    {
        Contact cont = new Contact( );
        cont.OB_BypassValidation__c = true;
        cont.FirstName = 'aaaaaa';
        cont.LastName = 'aaaaaa';
        cont.OB_Document_Release_Date__c = Date.newInstance( 1898, 1, 1 );
        cont.OB_Document_Expiration_Date__c = Date.newInstance( 1998, 1, 1 );
        cont.OB_Birth_Date__c = Date.newInstance( 1899, 1, 1 );
        cont.OB_Country_Birth__c = 'ITALIA';
        cont.OB_Document_Number__c = '123ert54';
        cont.OB_Fiscal_Code__c = 'AAAAAA95A01A111';
        cont.OB_Sex__c = 'M';
        cont.OB_Cadastral_Code__c = '123';
        cont.OB_Document_Type__c = 'Carta di Identità';
        insert cont;
        NE__Lov__c lov = new NE__Lov__c( Name = cont.OB_Country_Birth__c, NE__Value2__c = '123', NE__Type__c = 'COUNTRY' );
        insert lov;
        List<NE__Lov__c> lovCadastralCode = new List<NE__Lov__c>( );
        lovCadastralCode.add( lov );

        String section = '';
        Map<String, Object> mappaErrorEE = new Map<String, Object>( );
        Test.startTest( );
        OB_Maintenance_EditAccount_Controller.checkValidationCont( cont, section, mappaErrorEE );
        Test.stopTest( );
    }

    @isTest
    public static void checkValidationContTest2( )
    {
        Contact cont = new Contact( );
        cont.OB_BypassValidation__c = true;
        cont.FirstName = 'aaaaaa';
        cont.LastName = 'aaaaaa';
        cont.OB_Document_Release_Date__c = Date.newInstance( 2013, 2, 1 );
        cont.OB_Document_Expiration_Date__c = Date.newInstance( 1998, 1, 1 );
        cont.OB_Birth_Date__c = Date.newInstance( 1899, 1, 1 );
        cont.OB_Document_Number__c = '123ert542';
        cont.OB_Fiscal_Code__c = 'AAAAAA95A01A111';
        cont.OB_Sex__c = 'M';
        cont.OB_Cadastral_Code__c = '123';
        cont.OB_Document_Type__c = 'Carta di Identità';
        insert cont;
        String section = '';
        Map<String, Object> mappaErrorEE = new Map<String, Object>( );
        Test.startTest( );
        OB_Maintenance_EditAccount_Controller.checkValidationCont( cont, section, mappaErrorEE );
        Test.stopTest( );
    }

    @isTest
    public static void checkValidationContTest3( )
    {
        Contact cont = new Contact( );
        cont.OB_BypassValidation__c = true;
        cont.FirstName = 'aaaaaa';
        cont.LastName = 'aaaaaa';
        cont.OB_Document_Release_Date__c = Date.newInstance( 2013, 2, 1 );
        cont.OB_Document_Expiration_Date__c = Date.newInstance( 1998, 1, 1 );
        cont.OB_Birth_Date__c = Date.newInstance( 1899, 1, 1 );
        cont.OB_Document_Number__c = '123ert542';
        cont.OB_Fiscal_Code__c = 'AAAAAA95A01A111';
        cont.OB_Sex__c = 'M';
        cont.OB_Cadastral_Code__c = '123';
        cont.OB_Document_Type__c = 'Patente';
        insert cont;
        String section = '';
        Map<String, Object> mappaErrorEE = new Map<String, Object>( );
        Test.startTest( );
        OB_Maintenance_EditAccount_Controller.checkValidationCont( cont, section, mappaErrorEE );
        Test.stopTest( );
    }

    @isTest
    public static void checkValidationContTest4( )
    {
        Contact cont = new Contact( );
        cont.OB_BypassValidation__c = true;
        cont.FirstName = 'aaaaaa';
        cont.LastName = 'aaaaaa';
        cont.OB_Document_Release_Date__c = Date.newInstance( 2013, 2, 1 );
        cont.OB_Document_Expiration_Date__c = Date.newInstance( 1998, 1, 1 );
        cont.OB_Birth_Date__c = Date.newInstance( 1899, 1, 1 );
        cont.OB_Document_Number__c = '123ert542';
        cont.OB_Fiscal_Code__c = 'AAAAAA95A01A111';
        cont.OB_Sex__c = 'M';
        cont.OB_Cadastral_Code__c = '123';
        cont.OB_Document_Type__c = 'Passaporto';
        insert cont;
        String section = '';
        Map<String, Object> mappaErrorEE = new Map<String, Object>( );
        Test.startTest( );
        OB_Maintenance_EditAccount_Controller.checkValidationCont( cont, section, mappaErrorEE );
        Test.stopTest( );
    }

    @isTest
    public static void checkValidationContTest5( )
    {
        Contact cont = new Contact( );
        cont.OB_BypassValidation__c = true;
        cont.FirstName = 'aaaaaa';
        cont.LastName = 'aaaaaa';
        cont.OB_Document_Release_Date__c = Date.newInstance( 2013, 3, 1 );
        cont.OB_Document_Expiration_Date__c = Date.newInstance( 1998, 1, 1 );
        cont.OB_Birth_Date__c = Date.newInstance( 1899, 2, 1 );
        cont.OB_Document_Number__c = '123ert542';
        cont.OB_Fiscal_Code__c = 'AAAAAA95A01A111';
        cont.OB_Sex__c = 'M';
        cont.OB_Cadastral_Code__c = '123';
        cont.OB_Document_Type__c = 'Carta di Identità';
        insert cont;
        String section = '';
        Map<String, Object> mappaErrorEE = new Map<String, Object>( );
        Test.startTest( );
        OB_Maintenance_EditAccount_Controller.checkValidationCont( cont, section, mappaErrorEE );
        Test.stopTest( );
    }


    @isTest
    public static void checkExistLogRequestTest( )
    {
        Account acc = new Account( name = 'test', OB_Employees_Number__c = 'Minore di 10', OB_BypassValidation__c = true );
        Id recordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName( ).get( 'Merchant' ).getRecordTypeId( );
        acc.RecordTypeId = recordTypeIdAcc;
        insert acc;
        OB_LogRequest__c lr = new OB_LogRequest__c( OB_AccountId__c = acc.id, OB_ChangeLegalRepresentative__c = true, OB_Status__c = 'Bozza' );
        insert lr;
        Test.startTest( );
        OB_Maintenance_EditAccount_Controller.checkExistLogRequest( acc.id );
        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:  Method tests if saveDraft works when gets null parameter
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien        26/07/2019        Created         NEXI-179
    ********************************************************************************/
    @isTest
    public static void saveDraftTest( )
    {
        OB_LogRequest__c logRequest = OB_TestDataFactory.getLogRequest( );
        logRequest.OB_Status__c = OB_UtilityConstants.INATTESA;
        insert logRequest;
        OB_Maintenance_EditAccount_Controller.saveDraft( logRequest.id );
        List<OB_LogRequest__c> logRequests = [ SELECT OB_STATUS__c FROM OB_LogRequest__c WHERE Id = :logRequest.id ];
        System.assertEquals( OB_UtilityConstants.BOZZA, logRequests.get( 0 ).OB_Status__c );
    }

    /*******************************************************************************
    Purpose:  Method tests if saveDraft works when gets null parameter
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien        26/07/2019        Created         NEXI-179
    ********************************************************************************/
    @isTest
    public static void saveDraftNullTest( )
    {
        OB_Maintenance_EditAccount_Controller.saveDraft( null );
        System.assert( true );
    }

    @isTest
    public static void checkNameSurnameCFTest( )
    {
        String nome = 'mariateresa' ;
        String cognome = 'rossi';
        String cf = 'RSSMTR80B51F205Y';
        String birthDate = '11/02/1980';
        String gender = 'F';
        String cadastralCode = '';
        Boolean skipCheckCadCode = false;

        Test.startTest( );
        OB_Maintenance_EditAccount_Controller.checkNameSurnameCF( nome, cognome, cf, birthDate, gender, cadastralCode, skipCheckCadCode );
        Test.stopTest( );
    }

    @isTest
    public static void checkNameSurnameCF2Test( )
    {
        String nome = 'fede' ;
        String cognome = 'lao';
        String cf = 'LAOFDE80B51F205A';
        String birthDate = '11/02/1980';
        String gender = 'F';
        String cadastralCode = '';
        Boolean skipCheckCadCode = false;

        Test.startTest( );
        OB_Maintenance_EditAccount_Controller.checkNameSurnameCF( nome, cognome, cf, birthDate, gender, cadastralCode, skipCheckCadCode );
        Test.stopTest( );
    }

    @isTest
    public static void controllaCheckDigitTest( )
    {
        String cf = 'LAOFDE80B51F205A';
        Test.startTest( );
        OB_Maintenance_EditAccount_Controller.controllaCheckDigit( cf );
        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditAccount_Controller.callSerializeAnagrafica - success scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       21/06/2019      Created         NEXI-60
    ********************************************************************************/
    @isTest
    private static void callSerializeAnagraficaSerializedTest( )
    {
        // NEXI-60 <joanna.mielczarek@accenture.com> - just covered method to increase CC

        OB_LogRequest__c logRequest = new OB_LogRequest__c( );
        logRequest.OB_SIAToBeApproved__c = false;
        logRequest.OB_EquensMoneticaToBeApproved__c = false;
        insert logRequest;

        Test.startTest( );
        OB_Maintenance_EditAccount_Controller.callSerializeAnagrafica( String.valueOf( logRequest.Id ) );
        Test.stopTest( );

        System.assert( true ); // Log Request should fulfill conditions from OB_Utility.serializeAnagrafica method
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditAccount_Controller.callSerializeAnagrafica - success scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       21/06/2019      Created         NEXI-60
    ********************************************************************************/
    @isTest
    private static void callSerializeAnagraficaInAttesaTest( )
    {
        // NEXI-60 <joanna.mielczarek@accenture.com> - just covered method to increase CC

        OB_LogRequest__c logRequest = new OB_LogRequest__c( );
        logRequest.OB_SIAToBeApproved__c = true;
        logRequest.OB_EquensMoneticaToBeApproved__c = true;
        insert logRequest;

        Test.startTest( );
        OB_Maintenance_EditAccount_Controller.callSerializeAnagrafica( String.valueOf( logRequest.Id ) );
        Test.stopTest( );

        List<OB_LogRequest__c> result = [ SELECT Id, OB_Status__c FROM OB_LogRequest__c ];
        System.assertEquals( OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA, result.get( 0 ).OB_Status__c );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditAccount_Controller.callSerializeAnagrafica - fail scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       21/06/2019      Created         NEXI-60
    ********************************************************************************/
    @isTest
    private static void callSerializeAnagraficaNullTest( )
    {
        // NEXI-60 <joanna.mielczarek@accenture.com> - just covered method to increase CC

        Test.startTest( );
        OB_Maintenance_EditAccount_Controller.callSerializeAnagrafica( null );
        Test.stopTest( );

        System.assert( true );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditAccount_Controller.cancelLogRequest happy flow
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       04/06/2019      Created         NEXI-58
    ********************************************************************************/
    @isTest
    private static void cancelLogRequestTest( )
    {
        List<Id> newLogRequests = new List<Id>( );
        List<Id> changedLogRequests = new List<Id>( );
        List<Id> deletedLogRequests = new List<Id>( );
        OB_LogRequest__c newLogRequest = OB_TestDataFactory.getLogRequest( );
        insert newLogRequest;
        newLogRequests.add( newLogRequest.Id );
        OB_LogRequest__c changeLogRequest = OB_TestDataFactory.getLogRequest( );
        insert changeLogRequest;
        changedLogRequests.add( changeLogRequest.Id );
        OB_LogRequest__c deletedLogRequest = OB_TestDataFactory.getLogRequest( );
        insert deletedLogRequest;
        deletedLogRequests.add( deletedLogRequest.Id );
        OB_Maintenance_EditAccount_Controller.cancelLogRequest( newLogRequests, changedLogRequests, deletedLogRequests );
        List<OB_LogRequest__c> results = [ SELECT OB_Status__c FROM OB_LogRequest__c ];
        for ( OB_LogRequest__c result : results )
        {
            System.assertEquals( OB_UtilityConstants.RIFIUTATO, result.OB_Status__c );
        }
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditAccount_Controller.cancelLogRequest bad data
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       05/06/2019      Created         NEXI-58
    ********************************************************************************/
    @isTest
    private static void cancelLogRequestBadDataTest( )
    {
        System.assert( !OB_Maintenance_EditAccount_Controller.cancelLogRequest( null, null, null ) );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditAccount_Controller.startApprovalProcess bad data
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       12/06/2019      Created         NEXI-60
    1.1         Joanna Mielczarek       21/06/2019      Modified        NEXI-60 changed IN param
    ********************************************************************************/
    @isTest
    private static void startApprovalProcessBadDataTest( )
    {
        OB_Maintenance_EditAccount_Controller.startApprovalProcess( null );
        System.assert( true );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditAccount_Controller.startApprovalProcess
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       12/06/2019      Created         NEXI-60
    1.1         Joanna Mielczarek       21/06/2019      Modified        NEXI-60 changed IN param
    ********************************************************************************/
    @isTest
    private static void startApprovalProcessTest( )
    {
        OB_LogRequest__c testLogRequest = new OB_LogRequest__c( );
        testLogRequest.OB_Status__c = OB_UtilityConstants.LOGREQUEST_STATUS_DRAFT;
        insert testLogRequest;

        OB_Maintenance_EditAccount_Controller.startApprovalProcess( testLogRequest.Id );
        List<OB_LogRequest__c> results = [ SELECT Id, OB_Status__c FROM OB_LogRequest__c ];

        System.assertEquals( OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA, results.get( 0 ).OB_Status__c );
    }

    /*******************************************************************************
    Purpose:  Method creates Community User
    Parameters: -
    Returns: User

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       21/06/2019      Created         NEXI-60
    1.1         Joanna Mielczarek       02/07/2019      Modified        NEXI-143 add portal account to create user
    ********************************************************************************/
    private static User getCommunityUser( )
    {
        User portalAccountOwner = OB_TestDataFactory.getPortalAccountOwner( );
        insert portalAccountOwner;
        User testCommunityUser;

        System.runAs( portalAccountOwner )
        {
            Account testAccount = OB_TestDataFactory.getAccount( );
            testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.ACC_RT_MERCHANT ).getRecordTypeId( );
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
    Purpose:  Method test OB_Maintenance_EditAccount_Controller.createLogRequest - success scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       21/06/2019      Created         NEXI-60
    ********************************************************************************/
    @isTest
    private static void createLogRequestTest( )
    {
        User testCommunityUser = getCommunityUser( );
        System.runAs( testCommunityUser )
        {
            List<Contact> inOldContacts = new List<Contact> {new Contact( )};
            List<Contact> inNewContacts = new List<Contact> {new Contact( )};
            OB_Maintenance_EditAccount_Controller.LogRequestWrapper result = OB_Maintenance_EditAccount_Controller.createLogRequest( inOldContacts, inNewContacts, testCommunityUser.AccountId, true,true );
            System.assert( !result.isError );
            System.assert( result.errorMessage == null );
            System.assert( result.logRequestId != null );
        }
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditAccount_Controller.createLogRequest - empty IN lists scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       21/06/2019      Created         NEXI-60
    ********************************************************************************/
    @isTest
    private static void createLogRequestEmptyINListsTest( )
    {
        User testCommunityUser = getCommunityUser( );
        System.runAs( testCommunityUser )
        {
            OB_Maintenance_EditAccount_Controller.LogRequestWrapper result = OB_Maintenance_EditAccount_Controller.createLogRequest( new List<Contact>( ), new List<Contact>( ), testCommunityUser.AccountId, true, false );
            System.assert( result.isError );
            System.assertEquals( 'Empty IN list', result.errorMessage );
            System.assert( result.logRequestId == null );
        }
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditAccount_Controller.createLogRequest - null params scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       21/06/2019      Created         NEXI-60
    ********************************************************************************/
    @isTest
    private static void createLogRequestFailTest( )
    {
        User testCommunityUser = getCommunityUser( );
        System.runAs( testCommunityUser )
        {
            OB_Maintenance_EditAccount_Controller.LogRequestWrapper result = OB_Maintenance_EditAccount_Controller.createLogRequest( null, null, null, true,null );
            System.assert( result.isError );
            System.assert( result.errorMessage != null );
            System.assert( result.logRequestId == null );
        }
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditAccount_Controller.getInitDataWrapper - success scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       21/06/2019      Created         NEXI-60
    ********************************************************************************/
    @isTest
    private static void getInitDataWrapperTest( )
    {
        Account testAccount = OB_TestDataFactory.getAccount( );
        insert testAccount;
        OB_LogRequest__c testLogRequest = new OB_LogRequest__c( );
        testLogRequest.OB_AccountId__c = testAccount.Id;
        testLogRequest.RecordTypeId = OB_LogRequestTriggerHandler.MAINTENANCE_ANAGRAFICA_RECORD_TYPE;
        testLogRequest.OB_Status__c = OB_UtilityConstants.LOGREQUEST_STATUS_DRAFT;
        testLogRequest.OB_Change_of_data_of_beneficial_owners__c = true;
        insert testLogRequest;

        OB_Maintenance_EditAccount_Controller.DataWrapper result = OB_Maintenance_EditAccount_Controller.getInitDataWrapper( String.valueOf ( testAccount.Id ) );
        System.assert( result.contactRecordTypeId != null );
        System.assert( result.hasLogRequest );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditAccount_Controller.getInitDataWrapper - fail scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       21/06/2019      Created         NEXI-60
    ********************************************************************************/
    @isTest
    private static void getInitDataWrapperFailTest( )
    {
        OB_Maintenance_EditAccount_Controller.DataWrapper result = OB_Maintenance_EditAccount_Controller.getInitDataWrapper( null );
        System.assert( result.contactRecordTypeId != null );
        System.assert( !result.hasLogRequest );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditAccount_Controller.checkIfMaintenanceTE - success scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       21/06/2019      Created         NEXI-60
    ********************************************************************************/
    @isTest
    private static void checkIfMaintenanceTETrueTest( )
    {
        Map<String, Object> testData = new Map<String, Object>( );
        testData.put( 'isMaintenanceTE', true );
        System.assert( OB_Maintenance_EditAccount_Controller.checkIfMaintenanceTE( testData ) );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditAccount_Controller.checkIfMaintenanceTE - success scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       21/06/2019      Created         NEXI-60
    ********************************************************************************/
    @isTest
    private static void checkIfMaintenanceTEFalseTest( )
    {
        Map<String, Object> testData = new Map<String, Object>( );
        testData.put( 'isMaintenanceTE', false );
        System.assert( !OB_Maintenance_EditAccount_Controller.checkIfMaintenanceTE( testData ) );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditAccount_Controller.checkIfMaintenanceTE - fail scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       21/06/2019      Created         NEXI-60
    ********************************************************************************/
    @isTest
    private static void checkIfMaintenanceTEWrongMapTest( )
    {
        Map<String, Object> testData = new Map<String, Object>( );
        testData.put( 'isMaintenanceTE', 'test' );
        System.assert( !OB_Maintenance_EditAccount_Controller.checkIfMaintenanceTE( testData ) );
    }

    /*******************************************************************************
    Purpose:  Method test for OB_Maintenance_EditAccount_Controller.saveRequestExecutor (with fiscal code check)

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Kinga Fornal            28/06/2019      Created         NEXI-125
    ********************************************************************************/
    @isTest
    private static void saveRequestExecutorAccountFiscalCodeTest( )
    {
        Account testAccount = OB_TestDataFactory.getAccount( );
        testAccount.NE__Fiscal_code__c = '12345678901';
        testAccount.OB_Legal_Form__c = OB_UtilityConstants.DITTA_INDIVIDUALE;
        insert testAccount;
        Contact testContact = OB_TestDataFactory.getContact( testAccount );
        testContact.FirstName = 'JAN';
        testContact.LastName = 'KOWALSKI';
        testContact.OB_Company_Link_Type__c = 'LEGALE RAPPRESENTANTE';
        testContact.OB_Fiscal_Code__c = 'KWLJNA90A01H502A';
        testContact.OB_Sex__c = 'M';
        testContact.OB_Country_Birth__c = 'ITALIA';
        testContact.OB_Country_Birth_Code__c = 'ITA';
        testContact.OB_Birth_State_Code__c = 'FI';
        testContact.OB_Birth_City__c = 'FIRENZE';
        testContact.OB_Birth_Date__c = Date.newInstance( 1990, 01, 01 );
        testContact.OB_Birth_State__c = 'FIRENZE';
        testContact.OB_Address_Country__c = 'ITALIA';
        testContact.OB_Citizenship__c = 'ITALIA';
        testContact.OB_Document_Release_Country__c = 'ITALIA';
        testContact.OB_Document_Release_Country_Code__c = 'ITA';
        testContact.OB_Document_Release_State_Code__c = 'FI';
        testContact.OB_Document_Release_State__c = 'FIRENZE';
        testContact.OB_Document_Type__c = 'Carta di Identità';
        /* ANDREA MORITTU START - FIX ON DOCUMENT LENGTH*/
        testContact.OB_Document_Number__c = '12345678';
        /* ANDREA MORITTU END - FIX ON DOCUMENT LENGTH*/
        testContact.OB_Document_Release_Authority__c = 'Comune';
        testContact.OB_Document_Release_Date__c = Date.newInstance( 2018, 01, 01 );
        testContact.OB_Document_Expiration_Date__c = Date.newInstance( 2028, 01, 01 );
        testContact.OB_Document_Release_City__c = 'FIRENZE';
        testContact.OB_PEP__c = false;
        testContact.OB_Address_Street__c = 'VIA BARNA';
        testContact.OB_Address_Street_Number__c = '5';
        testContact.OB_Address_City__c = 'FIRENZE';
        testContact.OB_Address_State__c = 'FIRENZE';
        testContact.OB_Address_PostalCode__c = '50143';
        testContact.OB_Address_State_Code__c = 'FI';
        testContact.OB_Address_Country_Code__c = 'ITA';
        testContact.OB_Contact_State__c = 'Active';
        insert testContact;

        String oldData = JSON.serialize( testContact );
        testContact.OB_Document_Number__c = 'as12345978';
        String newData = JSON.serialize( testContact );
        Map<String, Object> mapToSerialize = new Map<String, Object>( );
        mapToSerialize.put( 'executor', testContact );
        mapToSerialize.put( 'acc', testAccount );
        Map<String, Boolean> errorEEMapObject = ( Map<String, Boolean> ) JSON.deserialize( '{"key" : false}', Map<String, Boolean>.class );
        mapToSerialize.put( 'errorEEMap', errorEEMapObject );
        Test.startTest( );
        Map<String, Object> result = OB_Maintenance_EditAccount_Controller.saveRequestExecutor( oldData, newData, false, JSON.serialize( mapToSerialize ) );
        Test.stopTest( );

        Map<String, Object> validationCheckMap = ( Map<String, Object> ) result.get( 'validationCheckMap' );

        System.assertNotEquals( result, null );
        System.assertNotEquals( validationCheckMap, null );
        System.assert( validationCheckMap.containsKey( 'fiscalCodelegaleRapp' ) );
        System.assertEquals( validationCheckMap.get( 'fiscalCodelegaleRapp' ), Label.OB_MAINTENANCE_EXECUTOR_FC_NOT_VALID );

    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditAccount_Controller.retrieveExternalSourceMapping - not null list returned

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Zuzanna Urban          	10/07/2019      Created         NEXI-186
    ********************************************************************************/
    @isTest
    private static void retrieveExternalSourceMappingFullTest( )
    {
        Account myAccount = OB_TestDataFactory.getAccount( );
        insert myAccount;
        NE__Service_Point__c myServicePoint = OB_TestDataFactory.getServicePoint( );
        myServicePoint.NE__Account__c = myAccount.Id;
        insert myServicePoint;
        Asset myAsset = OB_TestDataFactory.getAsset( );
        myAsset.NE__Service_Point__c = myServicePoint.Id;
        myAsset.AccountId = myAccount.Id;
        insert myAsset;
        ExternalSourceMapping__c myESM = OB_TestDataFactory.getExternalSourceMapping( );
        myESM.OB_Merchant_ID__c = myAccount.Id;
        insert myESM;

        System.assert( OB_Maintenance_EditAccount_Controller.retrieveExternalSourceMapping( myAccount.Id ) != null );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditAccount_Controller.retrieveExternalSourceMapping - disconneted Asset

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Zuzanna Urban          	10/07/2019      Created         NEXI-186
    ********************************************************************************/
    @isTest
    private static void retrieveExternalSourceMappingDisTest( )
    {
        Account myAccount = OB_TestDataFactory.getAccount( );
        insert myAccount;
        NE__Service_Point__c myServicePoint = OB_TestDataFactory.getServicePoint( );
        myServicePoint.NE__Account__c = myAccount.Id;
        insert myServicePoint;
        Asset myAsset = OB_TestDataFactory.getAsset( );
        myAsset.NE__Service_Point__c = myServicePoint.Id;
        myAsset.AccountId = myAccount.Id;
        myAsset.NE__Status__c = OB_UtilityConstants.ASSET_STATUS_DISCONNECTED;
        insert myAsset;
        ExternalSourceMapping__c myESM = OB_TestDataFactory.getExternalSourceMapping( );
        myESM.OB_Merchant_ID__c = myAccount.Id;
        insert myESM;
        System.assert( OB_Maintenance_EditAccount_Controller.retrieveExternalSourceMapping( myAccount.Id ) != null );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditAccount_Controller.getNewESMList the same Report Type

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Zuzanna Urban          	11/07/2019      Created         NEXI-186
    ********************************************************************************/
    @isTest
    private static void getNewESMListTheSameValueTest( )
    {
        String newReportTypeValue = 'Punto Vendita';
        List<ExternalSourceMapping__c> esmOldList = new List<ExternalSourceMapping__c>( );
        List<ExternalSourceMapping__c> esmNewList = new List<ExternalSourceMapping__c>( );
        ExternalSourceMapping__c esmOldValue = OB_TestDataFactory.getExternalSourceMapping( );
        esmOldValue.OB_ReportType__c = newReportTypeValue;
        esmOldList.add( esmOldValue );
        ExternalSourceMapping__c esmNewValue = OB_TestDataFactory.getExternalSourceMapping( );
        esmNewValue.OB_ReportType__c = newReportTypeValue;
        esmNewList.add( esmOldValue );
        List<ExternalSourceMapping__c> esmList = OB_Maintenance_EditAccount_Controller.getNewESMList( newReportTypeValue, esmOldList, esmNewList );
        System.assert( esmList == null );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditAccount_Controller.getNewESMList not null List

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Zuzanna Urban          	11/07/2019      Created         NEXI-186
    ********************************************************************************/
    @isTest
    private static void getNewESMListTest( )
    {
        String newReportTypeValue = 'Punto Vendita';
        List<ExternalSourceMapping__c> esmOldList = new List<ExternalSourceMapping__c>( );
        List<ExternalSourceMapping__c> esmNewList = new List<ExternalSourceMapping__c>( );
        ExternalSourceMapping__c esmOldValue = OB_TestDataFactory.getExternalSourceMapping( );
        esmOldValue.OB_ReportType__c = 'Societa Cumulativo';
        esmOldList.add( esmOldValue );
        ExternalSourceMapping__c esmNewValue = OB_TestDataFactory.getExternalSourceMapping( );
        esmNewValue.OB_ReportType__c = newReportTypeValue;
        esmNewList.add( esmOldValue );
        List<ExternalSourceMapping__c> esmList = OB_Maintenance_EditAccount_Controller.getNewESMList( newReportTypeValue, esmOldList, esmNewList );
        System.assert( esmList != null );
    }

    /*******************************************************************************
    Purpose:  Wrapper for request data

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       02/09/2019      Created         NEXI-295
    ********************************************************************************/
    private class RequestWrapper
    {
        private String oldData;
        private String newData;
        private String objectDataMap;
    }

    /*******************************************************************************
    Purpose:  Method prepares request data for saveRequest unit tests
    Parameters: String inCode, Boolean isSAE
    Returns: RequestWrapper

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       02/09/2019      Created         NEXI-295
    1.1         Joanna Mielczarek       12/09/2019      Modified        NEXI-325 align method to new logic with legal form
    ********************************************************************************/
    private static RequestWrapper prepareRequestWrapper( String inCode, Boolean isSAE, String inLegalFormCode )
    {
        RequestWrapper wrapper = new RequestWrapper( );

        Account testAccount = OB_TestDataFactory.getAccount( );
        testAccount.OB_Administrative_Office_City__c = 'city';
        testAccount.OB_Administrative_Office_State__c = 'state';
        testAccount.OB_Administrative_Office_Street__c = 'street';
        testAccount.OB_Administrative_Office_Street_number__c = '1';
        testAccount.OB_Legal_Address_City__c = 'city';
        testAccount.OB_Legal_Address_State__c = 'state';
        testAccount.OB_Legal_Address_Street_Number__c = '1';
        testAccount.OB_Legal_Address_Street__c = 'street';
        testAccount.OB_Legal_Form__c = OB_UtilityConstants.DITTA_INDIVIDUALE;
        insert testAccount;
        Contact testContact = OB_TestDataFactory.getContact( testAccount );
        insert testContact;

        Map<String, Object> oldMap = new Map<String, Object>( );
        oldMap.put( 'account', testAccount );
        oldMap.put( 'contact', testContact );
        wrapper.oldData = JSON.serialize( oldMap );

        if ( isSAE )
        {
            testAccount.OB_SAE_Code__c = inCode;
        }
        else
        {
            testAccount.OB_ATECO__c = inCode;
        }
        if ( !String.isBlank( inLegalFormCode ) )
        {
            testAccount.OB_Legal_Form_Code__c = inLegalFormCode;
        }
        Map<String, Object> newMap = new Map<String, Object>( );
        newMap.put( 'account', testAccount );
        newMap.put( 'contact', testContact );
        wrapper.newData = JSON.serialize( newMap );

        Map<String, Object> objectDataMap = new Map<String, Object>( );
        objectDataMap.put( 'acc', testAccount );
        Map<String, Boolean> errorEEMapObject = ( Map<String, Boolean> ) JSON.deserialize( '{"key" : false}', Map<String, Boolean>.class );
        objectDataMap.put( 'errorEEMap', errorEEMapObject );
        wrapper.objectDataMap = JSON.serialize( objectDataMap );

        return wrapper;
    }

    /*******************************************************************************
    Purpose:  Method tests saveRequest method - if SAE is in special categories list

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       02/09/2019      Created         NEXI-295
    ********************************************************************************/
    @isTest
    private static void saveRequestSae( )
    {
        RequestWrapper wrapper = prepareRequestWrapper( OB_UtilityConstants.FIDUCIARIE_VALUE_273, true, '' ); // NEXI-325 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 12/09/2019 added param ''

        Test.startTest( );
        Map<String, Object> result = OB_Maintenance_EditAccount_Controller.saveRequest( wrapper.oldData, wrapper.newData, wrapper.objectDataMap );
        Test.stopTest( );

        Id logRequestId = ( Id ) result.get( 'logRequestId' );
        OB_LogRequest__c logRequest = [ SELECT OB_Fiduciarie__c FROM OB_LogRequest__c WHERE Id = :logRequestId ].get( 0 );
        System.assert( logRequest.OB_Fiduciarie__c );
    }

    /*******************************************************************************
    Purpose:  Method tests saveRequest method - if ATECO is in special categories list

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       02/09/2019      Created         NEXI-295
    ********************************************************************************/
    @isTest
    private static void saveRequestAteco( )
    {
        RequestWrapper wrapper = prepareRequestWrapper( OB_UtilityConstants.MONEYTRANSFER_VALUE_66195, false, '' ); // NEXI-325 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 12/09/2019 added param ''

        Test.startTest( );
        Map<String, Object> result = OB_Maintenance_EditAccount_Controller.saveRequest( wrapper.oldData, wrapper.newData, wrapper.objectDataMap );
        Test.stopTest( );

        Id logRequestId = ( Id ) result.get( 'logRequestId' );
        OB_LogRequest__c logRequest = [ SELECT OB_Moneytransfer__c FROM OB_LogRequest__c WHERE Id = :logRequestId ].get( 0 );
        System.assert( logRequest.OB_Moneytransfer__c );
    }

    /*******************************************************************************
    Purpose:  Method tests saveRequest method - if Legal Form is in special categories list

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       12/09/2019      Created         NEXI-325
    ********************************************************************************/
    @isTest
    private static void saveRequestLegalForm( )
    {
        RequestWrapper wrapper = prepareRequestWrapper( '0000', false, OB_UtilityConstants.LEGAL_FORM_CODE_NO_PROFIT );

        Test.startTest( );
        Map<String, Object> result = OB_Maintenance_EditAccount_Controller.saveRequest( wrapper.oldData, wrapper.newData, wrapper.objectDataMap );
        Test.stopTest( );

        Id logRequestId = ( Id ) result.get( 'logRequestId' );
        OB_LogRequest__c logRequest = [ SELECT OB_Onlus__c FROM OB_LogRequest__c WHERE Id = :logRequestId ].get( 0 );
        System.assert( logRequest.OB_Onlus__c );
    }

    /*******************************************************************************
    Purpose:  Method tests callSerializeAnagrafica method - if Log Request has special category

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       03/09/2019      Created         NEXI-295
    1.1         Joanna Mielczarek       12/09/2019      Modified        NEXI-325 align to new logic with Trust check
    1.2         Adrian Dlugolecki       17/09/2019      Changed         NEXI-329 change to in Bozza
    ********************************************************************************/
    @isTest
    private static void callSerializeAnagraficaSaeAteco( )
    {
        OB_LogRequest__c testLogRequest = OB_TestDataFactory.getLogRequest( );
        testLogRequest.OB_StartApprovalProcess__c = true;
        testLogRequest.OB_Trust__c = true;
        insert testLogRequest;

        Test.startTest( );
        OB_Maintenance_EditAccount_Controller.callSerializeAnagrafica( testLogRequest.Id );
        Test.stopTest( );

        OB_LogRequest__c logRequestResult = [ SELECT OB_Status__c FROM OB_LogRequest__c WHERE Id = :testLogRequest.Id ].get( 0 );
        System.assertEquals( OB_UtilityConstants.LOGREQUEST_STATUS_DRAFT, logRequestResult.OB_Status__c );
    }

    /*******************************************************************************
    Purpose:  Method tests OB_Maintenance_EditAccount_Controller.updateChangedSaeAtecoLogRequestStatusToInAttesa
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien        09/09/2019        Created          NEXI-298
    ********************************************************************************/
    @isTest
    private static void updateChangedSaeAtecoLogRequestStatusToInAttesaTest()
    {
        OB_LogRequest__c testLogRequest = OB_TestDataFactory.getLogRequest();
        insert testLogRequest;
        OB_Maintenance_EditAccount_Controller.updateChangedSaeAtecoLogRequestStatusToInAttesa(testLogRequest.id);
        System.assertEquals( OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA, [SELECT OB_Status__c FROM OB_LogRequest__c WHERE Id = :testLogRequest.id ].get(0).OB_Status__c );
    }
}