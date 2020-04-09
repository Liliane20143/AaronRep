@isTest
public class OB_Maintenance_Helper_Test
{
    @isTest
    public static void checkBoleanFieldsTest( )
    {
        OB_Maintenance_Helper.CheckboxesWrapper cbw = new OB_Maintenance_Helper.CheckboxesWrapper( );
        Test.startTest( );
        OB_Maintenance_Helper.checkBoleanFields( 'NE__Fiscal_code__c', cbw );
        OB_Maintenance_Helper.checkBoleanFields( 'OB_Legal_Form__c', cbw );
        OB_Maintenance_Helper.checkBoleanFields( '', cbw );
        Test.stopTest( );
    }

//-------------------------------------- DD .01/02/2019. -----------------------------------------//

    //retriveBankOwner
    @isTest
    public static void retriveBankOwner_Test( )
    {
        string inputAbi = '00000';
        List<User> listUser = new List<User> ( );
        listUser = [ SELECT Id, Profile.Userlicense.Name,OB_CAB__c, contact.account.OB_ABI__c FROM User WHERE Id = :userinfo.getuserid( ) LIMIT 1 ];
        System.debug( 'List users ::: ' + listUser );

        list<OB_Bank_Profile__c> listOfBankProfile = new list<OB_Bank_Profile__c>( );

        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName( ).get( 'Bank' ).getRecordTypeId( );
        Account acc = new Account( Name = 'acc', OB_ABI__c = '00000', RecordTypeId = recordTypeId, OB_VAT_Not_Present__c = false, OB_Employees_Number__c = 'Minore di 10', NE__VAT__c = '05218600962' );
        insert acc;
        OB_Bank_Profile__c bp = new OB_Bank_Profile__c( );
        bp.OB_Bank__c = acc.Id;
        bp.OB_Service_Type__c = 'Acquiring';
        bp.OB_Business_Model_POS__c = 'Bilaterale';
        bp.OB_Circuit__c = 'JCB';
        bp.OB_Other_Acquirer__c = 'Amex';
        bp.OB_Applicant_RAC_Code_SIA__c = 'Banca';
        bp.OB_Terminal_Id_Generator__c = 'Banca';
        bp.OB_Technical_component_invoicing__c = 'TecMarket(servizio fatturazione per conto terzi)';
        bp.OB_GT__c = 'Nexi';
        bp.OB_Processor__c = 'SIA SMAC';
        bp.OB_Bilateral_Pricing__c = 'SI';
        bp.OB_Sending_Contract_to_Nexi__c = 'SI';
        bp.OB_SME_Factory__c = 'SI';
        bp.OB_Business_Model_Acquiring__c = 'Bancario';
        insert bp;
        listOfBankProfile.add( bp );

        system.System.debug( 'list Of Bank Profile ::: ' + listOfBankProfile );

        Test.startTest( );
        OB_Maintenance_Helper.retriveBankOwner( inputAbi );
        Test.stopTest( );
    }


    //retriveBankOwner : else listOfBankProfile.isEmpty()
    @isTest
    public static void retriveBankOwner_Test1( )
    {
        string inputAbi = '00000';
        List<User> listUser = new List<User> ( );
        listUser = [ SELECT Id, Profile.Userlicense.Name,OB_CAB__c, contact.account.OB_ABI__c FROM User WHERE Id = :userinfo.getuserid( ) LIMIT 1 ];
        System.debug( 'List users ::: ' + listUser );

        list<OB_Bank_Profile__c> listOfBankProfile = new list<OB_Bank_Profile__c>( );

        Test.startTest( );
        OB_Maintenance_Helper.retriveBankOwner( inputAbi );
        Test.stopTest( );
    }


    //fieldObjType2APINameSchema
    @isTest
    public static void fieldObjType2APINameSchemaTest( )
    {
        String objectTypeList = 'Account';
        Test.startTest( );
        OB_Maintenance_Helper.fieldObjType2APINameSchema( objectTypeList );
        Test.stopTest( );
    }

    //getSetOfObjectType
    @isTest
    public static void getSetOfObjectType_Test( )
    {
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName( ).get( 'Bank' ).getRecordTypeId( );
        Account acc = new Account( Name = 'acc', OB_ABI__c = '00000', RecordTypeId = recordTypeId, OB_VAT_Not_Present__c = false, OB_Employees_Number__c = 'Minore di 10', NE__VAT__c = '05218600962' );
        insert acc;
        list<Account> listOfData = new list<Account> ( );
        map<SObject, SObject> mapOldDataNewData = new map<SObject, SObject>( );
        listOfData.add( acc );
        mapOldDataNewData.put( acc, acc );

        Test.startTest( );
        OB_Maintenance_Helper.getSetOfObjectType( listOfData );
        OB_Maintenance_Helper.getSetOfObjectType( mapOldDataNewData );
        Test.stopTest( );
    }

    //map<SObject,SObject> mapOldDataNewData, serializeObject reducedOldData, serializeObject reducedNewData, CheckboxesWrapper checkboxFields){

    @isTest
    public static void generateDifferenceObject_Test( )
    {
        map<SObject, SObject> mapOldDataNewData = new map<SObject, SObject>( );
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName( ).get( 'Bank' ).getRecordTypeId( );
        Account acc = new Account( Name = 'acc', OB_ABI__c = '00000', RecordTypeId = recordTypeId, OB_VAT_Not_Present__c = false, OB_Employees_Number__c = 'Minore di 10', NE__VAT__c = '05218600962' );
        insert acc;
        Account acc1 = new Account( Name = 'acc1', OB_ABI__c = '00000', RecordTypeId = recordTypeId, OB_VAT_Not_Present__c = false, OB_Employees_Number__c = 'Minore di 10', NE__VAT__c = '05218600962' );
        insert acc1;
        mapOldDataNewData.put( acc, acc1 );
        mapOldDataNewData.put( acc1, acc1 );
        list<Account> listOfData = new list<Account> ( );
        listOfData.add( acc );
        OB_Maintenance_Helper.serializeObject serializeObject = new OB_Maintenance_Helper.serializeObject( );
        serializeObject.obj = listOfData;
        OB_Maintenance_Helper.CheckboxesWrapper checkboxFields = new OB_Maintenance_Helper.CheckboxesWrapper( );
        //checkboxFields.obj = listOfData;
        Test.startTest( );
        OB_Maintenance_Helper.generateDifferenceObject( mapOldDataNewData, serializeObject, serializeObject, checkboxFields );
        Test.stopTest( );
    }


    //estractFieldsLabel
    @isTest
    public static void estractFieldsLabel_Test( )
    {
        Map<String, Schema.DescribeFieldResult> objType2fieldData = new Map<String, Schema.DescribeFieldResult> ( );
        Map<String, Schema.SObjectType> GlobalMap = Schema.getGlobalDescribe( );
        Schema.DescribeSObjectResult obj = GlobalMap.get( 'Contact' ).getDescribe( );
        Schema.DescribeFieldResult testField = obj.Fields.getMap( ).get( 'AccountId' ).getDescribe( );
        objType2fieldData.put( 'Object', testField );

        Test.startTest( );
        OB_Maintenance_Helper.estractFieldsLabel( objType2fieldData );
        Test.stopTest( );
    }

    //isInternalUSer
    @isTest
    public static void isInternalUSer_Test( )
    {
        Test.startTest( );
        OB_Maintenance_Helper.isInternalUSer( );
        Test.stopTest( );
    }

    //retriveListOfId
    @isTest
    public static void retriveListOfId_Test( )
    {
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName( ).get( 'Bank' ).getRecordTypeId( );
        Account acc = new Account( Name = 'acc', OB_ABI__c = '00000', RecordTypeId = recordTypeId, OB_VAT_Not_Present__c = false, OB_Employees_Number__c = 'Minore di 10', NE__VAT__c = '05218600962' );
        insert acc;

        list<Account> listOfData = new list<Account> ( );
        listOfData.add( acc );

        Test.startTest( );
        OB_Maintenance_Helper.retriveListOfId( listOfData );
        Test.stopTest( );
    }

    //CheckRequestAlreadyExist  && checkRequestAlreadyExist_ServicePoint ---> try()
    @isTest
    public static void CheckRequestAlreadyExist_Test( )
    {
        Account acc = OB_TestDataFactory.getAccount( );
        insert acc;

        NE__Service_Point__c sp = new NE__Service_Point__c( NE__Account__c = acc.Id,
                Name = 'TEST',
                OB_Status__c = 'Inactive' );
        insert sp;

        Map<String, String> sourceMap = new Map<String, String>( );
        sourceMap.put( 'OB_MaintenanceType__c', 'Anagrafica' );
        sourceMap.put( 'OB_AccountId__c', acc.id );
        sourceMap.put( 'OB_ServicePointId__c', sp.id );
        sourceMap.put( 'OB_ChangeCompanyData__c', 'true' );
        sourceMap.put( 'OB_ChangeLegalForm__c', 'false' );
        sourceMap.put( 'OB_ChangeLegalRepresentative__c', 'false' );
        sourceMap.put( 'OB_ChangeMerchantName__c', 'false' );
        sourceMap.put( 'OB_ChangeServicePointData__c', 'true' );
        sourceMap.put( 'OB_NewLegalRepresentative__c', 'false' );
        sourceMap.put( 'OB_isNotIntegrated__c', 'false' );
        sourceMap.put( 'OB_Status__c', OB_UtilityConstants.LOGREQUEST_STATUS_DRAFT );
        Test.startTest( );
        OB_Maintenance_Helper.CheckRequestAlreadyExist( sourceMap );
        OB_Maintenance_Helper.checkRequestAlreadyExist_ServicePoint( sourceMap );
        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose: Method tests OB_Maintenance_Helper.getTestLogRequest for the Change Company Data log Request

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien        26/07/2019       Created     		 NEXI-179
    ********************************************************************************/
    private static OB_LogRequest__c getTestLogRequest( )
    {
        Account testAccount = OB_TestDataFactory.getAccount( );
        insert testAccount;
        OB_LogRequest__c existingLogRequest = OB_TestDataFactory.getLogRequest( );
        existingLogRequest.OB_isNotIntegrated__c = false;
        existingLogRequest.OB_Status__c = OB_UtilityConstants.LOGREQUEST_STATUS_DRAFT;
        existingLogRequest.OB_AccountId__c = testAccount.Id;
        return existingLogRequest;
    }

    /*******************************************************************************
    Purpose: Method tests OB_Maintenance_Helper.checkRequestAlreadyExist for the Change Company Data log Request

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien        26/07/2019       Created     		 NEXI-179
    ********************************************************************************/
    @isTest
    private static void checkRequestAlreadyExistTestForChangeCompanyData( )
    {
        OB_LogRequest__c existingLogRequest = getTestLogRequest( );
        existingLogRequest.OB_ChangeCompanyData__c = true;
        existingLogRequest.OB_isNotIntegrated__c = false;
        insert existingLogRequest;
        Map<String, String> sourceMap = new Map<String, String>( );
        sourceMap.put( 'OB_AccountId__c', existingLogRequest.OB_AccountId__c );
        sourceMap.put( 'OB_ChangeCompanyData__c', 'true' );
        sourceMap.put( 'OB_isNotIntegrated__c', 'false' );
        Map<String, String> testResults = OB_Maintenance_Helper.CheckRequestAlreadyExist( sourceMap );
        System.assertEquals( 'true', testResults.get( 'RECORDFOUND' ) );
    }

    /*******************************************************************************
    Purpose: Method tests OB_Maintenance_Helper.checkRequestAlreadyExist for the Change Report Type log Request

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien        26/07/2019       Created     		 NEXI-179
    ********************************************************************************/
    @isTest
    private static void checkRequestAlreadyExistTestForChangeReportType( )
    {
        OB_LogRequest__c existingLogRequest = getTestLogRequest( );
        existingLogRequest.OB_change_of_reporting_type__c = true;
        existingLogRequest.OB_isNotIntegrated__c = false;
        insert existingLogRequest;
        Map<String, String> sourceMap = new Map<String, String>( );
        sourceMap.put( 'OB_AccountId__c', existingLogRequest.OB_AccountId__c );
        sourceMap.put( 'OB_change_of_reporting_type__c', 'true' );
        Map<String, String> testResults = OB_Maintenance_Helper.CheckRequestAlreadyExist( sourceMap );
        System.assertEquals( 'false', testResults.get( 'RECORDFOUND' ) );
    }

    /*******************************************************************************
    Purpose: Method tests OB_Maintenance_Helper.checkRequestAlreadyExist for the Merchant Name log Request

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien        26/07/2019       Created     		 NEXI-179
    ********************************************************************************/
    @isTest
    private static void checkRequestAlreadyExistTestForChangeMerchantName( )
    {
        OB_LogRequest__c existingLogRequest = getTestLogRequest( );
        existingLogRequest.OB_ChangeMerchantName__c = true;
        existingLogRequest.OB_isNotIntegrated__c = false;
        insert existingLogRequest;
        Map<String, String> sourceMap = new Map<String, String>( );
        sourceMap.put( 'OB_AccountId__c', existingLogRequest.OB_AccountId__c );
        sourceMap.put( 'OB_ChangeMerchantName__c', 'true' );
        Map<String, String> testResults = OB_Maintenance_Helper.CheckRequestAlreadyExist( sourceMap );
        System.assertEquals( 'false', testResults.get( 'RECORDFOUND' ) );
    }

    /*******************************************************************************
    Purpose: Method tests OB_Maintenance_Helper.checkRequestAlreadyExist for the Legal Form log Request

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien        26/07/2019       Created     		 NEXI-179
    ********************************************************************************/
    @isTest
    private static void checkRequestAlreadyExistTestForChangeLegalForm( )
    {
        OB_LogRequest__c existingLogRequest = getTestLogRequest( );
        existingLogRequest.OB_ChangeLegalForm__c = true;
        existingLogRequest.OB_isNotIntegrated__c = false;
        insert existingLogRequest;
        Map<String, String> sourceMap = new Map<String, String>( );
        sourceMap.put( 'OB_AccountId__c', existingLogRequest.OB_AccountId__c );
        sourceMap.put( 'OB_ChangeLegalForm__c', 'true' );
        Map<String, String> testResults = OB_Maintenance_Helper.CheckRequestAlreadyExist( sourceMap );
        System.assertEquals( 'false', testResults.get( 'RECORDFOUND' ) );
    }

    /*******************************************************************************
    Purpose: Method tests OB_Maintenance_Helper.checkRequestAlreadyExist for the Extecutor log Request

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien        26/07/2019       Created     		 NEXI-179
    ********************************************************************************/
    @isTest
    private static void checkRequestAlreadyExistTestForChangeExecutor( )
    {
        OB_LogRequest__c existingLogRequest = getTestLogRequest( );
        existingLogRequest.OB_ChangeLegalRepresentative__c = true;
        existingLogRequest.OB_isNotIntegrated__c = false;
        insert existingLogRequest;
        Map<String, String> sourceMap = new Map<String, String>( );
        sourceMap.put( 'OB_AccountId__c', existingLogRequest.OB_AccountId__c );
        sourceMap.put( 'OB_ChangeLegalRepresentative__c', 'true' );
        sourceMap.put( 'OB_ChangeCompanyData__c', 'false' );
        sourceMap.put( 'OB_ChangeLegalForm__c', 'false' );
        sourceMap.put( 'OB_NewLegalRepresentative__c', 'false' );
        sourceMap.put( 'OB_ChangeMerchantName__c', 'false' );
        sourceMap.put( 'OB_change_of_reporting_type__c', 'false' ); // NEXI-298 Marta Stempien <marta.stempien@accenture.com> 09/09/2019 Added OB_change_of_reporting_type__c to test
        sourceMap.put( 'OB_ChangeServicePointData__c', 'false' );
        sourceMap.put( 'OB_isNotIntegrated__c', 'false' );
        Map<String, String> testResults = OB_Maintenance_Helper.CheckRequestAlreadyExist( sourceMap );
        System.assertEquals( 'true', testResults.get( 'RECORDFOUND' ) );
    }

    ////CheckRequestAlreadyExist  && checkRequestAlreadyExist_ServicePoint ---> catch()
    @isTest
    public static void CheckRequestAlreadyExist_Test_Catch( )
    {
        Map<String, String> sourceMap = new Map<String, String>( );
        Test.startTest( );
        OB_Maintenance_Helper.checkRequestAlreadyExist_ServicePoint( sourceMap );
        Test.stopTest( );
    }


    static testMethod void getCurrentUser_Test( )
    {

        Test.startTest( );

        List<User> listOfUsers = [ SELECT Id, Profile.Userlicense.Name,OB_CAB__c, contact.account.OB_ABI__c, OB_ABI__c FROM User WHERE Id = :userinfo.getuserid( ) LIMIT 1 ];
        OB_Maintenance_Helper helperM = new OB_Maintenance_Helper( );
        helperM.getCurrentUser( );

        Test.stopTest( );
    }


//-------------------------------------- DD .-----------------------------------------//

    /*******************************************************************************
    Purpose:  Test method for generateDifferenceObject that will check mandatory fields for log request

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Szuba       	30/07/2019      Created          NEXI-187
    ********************************************************************************/
    @isTest
    private static void generateDifferenceObjectForExceptionalFields( )
    {
        map<SObject, SObject> mapOldDataNewData = new map<SObject, SObject>( );
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName( ).get( 'Bank' ).getRecordTypeId( );
        Account acc1 = new Account( Name = 'acc1', OB_ABI__c = '00000', RecordTypeId = recordTypeId, OB_VAT_Not_Present__c = false, OB_Employees_Number__c = 'Minore di 10', NE__VAT__c = '05218600962' );
        insert acc1;
        ExternalSourceMapping__c testExternalSourceMapping = OB_TestDataFactory.getExternalSourceMapping( );
        testExternalSourceMapping.OB_Merchant_ID__c = acc1.Id;
        testExternalSourceMapping.OB_ReportType__c = '';
        insert testExternalSourceMapping;
        ExternalSourceMapping__c testExternalSourceMapping1 = OB_TestDataFactory.getExternalSourceMapping( );
        testExternalSourceMapping1.OB_Merchant_ID__c = acc1.Id;
        testExternalSourceMapping1.OB_ReportType__c = 'Punto Vendita';
        insert testExternalSourceMapping1;
        mapOldDataNewData.put( testExternalSourceMapping, testExternalSourceMapping1 );
        list<ExternalSourceMapping__c> listOfData = new list<ExternalSourceMapping__c> ( );
        listOfData.add( testExternalSourceMapping );
        OB_Maintenance_Helper.serializeObject serializeObject = new OB_Maintenance_Helper.serializeObject( );
        serializeObject.obj = listOfData;
        OB_Maintenance_Helper.CheckboxesWrapper checkboxFields = new OB_Maintenance_Helper.CheckboxesWrapper( );
        //checkboxFields.obj = listOfData;
        Test.startTest( );
        OB_Maintenance_Helper.generateDifferenceObject( mapOldDataNewData, serializeObject, serializeObject, checkboxFields );
        Test.stopTest( );
        System.assert( serializeObject != null );
    }

    /*******************************************************************************
    Purpose: Method tests OB_Maintenance_Helper.checkRequestAlreadyExist_ServicePoint for existing ChangeServicePoint log Request

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien        02/09/2019       Created     		 NEXI-294
    ********************************************************************************/
    @isTest
    private static void checkRequestAlreadyExistServicePointChangeServicePointTest( )
    {
        OB_LogRequest__c existingLogRequest = getTestLogRequest( );
        existingLogRequest.OB_ChangeServicePointData__c = true;
        insert existingLogRequest;
        Map<String, String> testData = new Map<String, String>( );
        testData.put( 'OB_ChangeServicePointData__c', 'true' );
        testData.put( 'OB_AccountId__c', existingLogRequest.OB_AccountId__c );
        testData.put( 'OB_isNotIntegrated__c', 'false' ); //ANTONIO.VATRANO WN363 05/09/2019

        System.assertEquals( 'true', OB_Maintenance_Helper.checkRequestAlreadyExist_ServicePoint( testData ).get( 'RECORDFOUND' ) );
    }

    /*******************************************************************************
    Purpose: Method tests OB_Maintenance_Helper.checkRequestAlreadyExist_ServicePoint for existing SettlementProcedure log Request

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien        02/09/2019       Created     		 NEXI-294
    ********************************************************************************/
    @isTest
    private static void checkRequestAlreadyExistServicePointSettlementProcedureTest( )
    {
        OB_LogRequest__c existingLogRequest = getTestLogRequest( );
        existingLogRequest.OB_Settlement_Procedure__c = true;
        insert existingLogRequest;
        Map<String, String> testData = new Map<String, String>( );
        testData.put( 'OB_Settlement_Procedure__c', 'true' );
        testData.put( 'OB_AccountId__c', existingLogRequest.OB_AccountId__c );
        testData.put( 'OB_isNotIntegrated__c', 'false' ); //ANTONIO.VATRANO WN363 05/09/2019
        System.assertEquals( 'true', OB_Maintenance_Helper.checkRequestAlreadyExist_ServicePoint( testData ).get( 'RECORDFOUND' ) );
    }

    /*******************************************************************************
   Purpose: Method tests OB_Maintenance_Helper.checkRequestAlreadyExist_ServicePoint for existing SettlementProcedure log Request

   History
   --------
   VERSION     AUTHOR                  DATE            DETAIL          Description
   1.0         Marta Stempien        02/09/2019       Created     		 NEXI-294
   ********************************************************************************/
    @isTest
    private static void checkRequestAlreadyExistServicePointNoExistingLogRequestsTest( )
    {
        OB_LogRequest__c existingLogRequest = getTestLogRequest( );
        insert existingLogRequest;
        Map<String, String> testData = new Map<String, String>( );
        testData.put( 'OB_Settlement_Procedure__c', 'true' );
        testData.put( 'OB_AccountId__c', existingLogRequest.OB_AccountId__c );
        testData.put( 'OB_isNotIntegrated__c', 'true' ); //ANTONIO.VATRANO WN363 05/09/2019
        System.assertEquals( 'true', OB_Maintenance_Helper.checkRequestAlreadyExist_ServicePoint( testData ).get( 'RECORDFOUND' ) );
    }

    /*******************************************************************************
    Purpose:  Method tests OB_Maintenance_Helper.updateLogRequestStatus
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien        09/09/2019        Created          NEXI-298
   ********************************************************************************/
    @isTest
    private static void updateLogRequestStatusTest( )
    {
        OB_LogRequest__c testLogRequest = OB_TestDataFactory.getLogRequest( );
        insert testLogRequest;
        List<String> testLogRequestsIds = new List<String>( );
        testLogRequestsIds.add( testLogRequest.Id );
        OB_Maintenance_Helper.updateLogRequestStatus( testLogRequestsIds, OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA );
        System.assertEquals( OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA, [ SELECT OB_Status__c FROM OB_LogRequest__c WHERE Id = :testLogRequest.id ].get( 0 ).OB_Status__c );
    }
}