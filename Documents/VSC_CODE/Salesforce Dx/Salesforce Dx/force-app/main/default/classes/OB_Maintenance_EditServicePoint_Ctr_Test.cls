@isTest
public class OB_Maintenance_EditServicePoint_Ctr_Test
{

    /*******************************************************************************
    Purpose:  Method prepares ServicePointWrapper
    Parameters: Id merchantId, String nameValue
    Returns: ServicePointWrapper

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       05/07/2019      Created         NEXI-143
    ********************************************************************************/
    private static OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper getServicePointWrapper( Id merchantId, String nameValue )
    {
        NE__Service_Point__c testServicePoint = OB_TestDataFactory.getServicePoint( );
        testServicePoint.NE__Account__c = merchantId;
        insert testServicePoint;

        Contact testTechnicalReferent = new Contact( );
        testTechnicalReferent.LastName = nameValue;

        Contact testServicePointResponsible = new Contact( );
        testServicePointResponsible.LastName = nameValue;

        Contact testAdministrativeResponsible = new Contact( );
        testAdministrativeResponsible.LastName = nameValue;

        ExternalSourceMapping__c testESM = new ExternalSourceMapping__c( );
        testESM.OB_Merchant_ID__c = merchantId;
        testESM.OB_Service_Point_ID__c = testServicePoint.Id;
        testESM.OB_CustomerCodeClientCode__c = 'TEST';
        insert testESM;

        OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper testData = new OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper( );
        testData.pv = testServicePoint;
        testData.technicalReferent = testTechnicalReferent;
        testData.servicePointResponsible = testServicePointResponsible;
        testData.administrativeResponsible = testAdministrativeResponsible;
        testData.listOfSourceMapping = new List<ExternalSourceMapping__c> {testESM};

        return testData;
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditServicePoint_Ctr.generateDiffernenceMap - success scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       05/07/2019      Created         NEXI-143
    ********************************************************************************/
    @isTest
    private static void generateDiffernenceMapHappyTest( )
    {
        Account testAccount = OB_TestDataFactory.getAccount( );
        insert testAccount;
        OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper oldData = getServicePointWrapper( testAccount.Id, 'oldName' );
        OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper newData = getServicePointWrapper( testAccount.Id, 'newName' );

        Test.startTest( );
        Map<SObject, SObject> result = OB_Maintenance_EditServicePoint_Ctr.generateDiffernenceMap( oldData, newData );
        Test.stopTest( );

        System.assert( !result.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditServicePoint_Ctr.retriveAccountId - success scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       05/07/2019      Created         NEXI-143
    ********************************************************************************/
    @isTest
    private static void retriveAccountIdHappyTest( )
    {
        Account testAccount = OB_TestDataFactory.getAccount( );
        insert testAccount;
        NE__Service_Point__c testServicePoint = OB_TestDataFactory.getServicePoint( );
        testServicePoint.NE__Account__c = testAccount.Id;
        insert testServicePoint;

        Test.startTest( );
        String result = OB_Maintenance_EditServicePoint_Ctr.retriveAccountId( testServicePoint ); //  Micol Ferrari <micol.ferrari@accenture.com>, 13/07/2019
        Test.stopTest( );

        System.assertEquals( String.valueOf( testAccount.Id ), result );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditServicePoint_Ctr.retriveAccountId - empty result scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       05/07/2019      Created         NEXI-143
    ********************************************************************************/

    @isTest
    private static void saveRequestTest1( )
    {
        Account merchantAccount = OB_TestDataFactory.getAccount( );
        insert merchantAccount;

        OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper servicePointWrapperOld = getServicePointWrapper( merchantAccount.Id, null );
        OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper servicePointWrapperNew = getServicePointWrapper( merchantAccount.Id, 'two' );

        //NEXI-162 Zuzanna Urban<z.urban@accenture.com>, 04/07/2019 Start
        ExternalSourceMapping__c esmTwo = new ExternalSourceMapping__c(
                OB_Merchant_ID__c = merchantAccount.Id,
                OB_Service_Point_ID__c = servicePointWrapperNew.pv.Id,
                OB_CustomerCodeClientCode__c = 'TEST 2',
                OB_Source__c = OB_UtilityConstants.SIA,
                OB_MCC__c = '5542'
        );
        //NEXI-162 Zuzanna Urban<z.urban@accenture.com>, 04/07/2019 Stop
        insert esmTwo;

        servicePointWrapperOld.listOfSourceMapping.add( esmTwo );
        servicePointWrapperNew.listOfSourceMapping.add( esmTwo );

        servicePointWrapperNew.listOfSourceMapping.get( 0 ).OB_CustomerCodeClientCode__c = 'TEST MOD';
        servicePointWrapperNew.listOfSourceMapping.get( 1 ).OB_CustomerCodeClientCode__c = 'TEST 2 MOD';

        //NEXI-162 Zuzanna Urban<z.urban@accenture.com>, 04/07/2019 Start
        Account testAccountPV = OB_TestDataFactory.getAccount( );
        insert testAccountPV;
        Contact testContactPV = OB_TestDataFactory.getContact( testAccountPV );
        testContactPV.FirstName = 'Test';
        testContactPV.LastName = 'Test';
        testContactPV.Email = 'test@gmail.com';
        testContactPV.MobilePhone = '123456';
        testContactPV.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.REFERENTE_PUNTO_VENDITA ).getRecordTypeId( );
        insert testContactPV;
        servicePointWrapperNew.servicePointResponsible = testContactPV;

        Account testAccountAdmin = OB_TestDataFactory.getAccount( );
        insert testAccountAdmin;
        Contact testContactAdmin = OB_TestDataFactory.getContact( testAccountAdmin );
        testContactAdmin.FirstName = 'Test';
        testContactAdmin.LastName = 'Test';
        testContactAdmin.Email = 'test@gmail.com';
        testContactAdmin.MobilePhone = '123456';
        testContactAdmin.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.RESPONSABILE_AMMINISTRATIVO ).getRecordTypeId( );
        insert testContactAdmin;
        servicePointWrapperNew.administrativeResponsible = testContactAdmin;

        Account testAccountTech = OB_TestDataFactory.getAccount( );
        insert testAccountTech;
        Contact testContactTech = OB_TestDataFactory.getContact( testAccountTech );
        testContactTech.FirstName = 'Test';
        testContactTech.LastName = 'Test';
        testContactTech.Email = 'test@gmail.com';
        testContactTech.MobilePhone = '123456';
        testContactTech.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.REFERENTE_TECNICO ).getRecordTypeId( );
        insert testContactTech;
        servicePointWrapperNew.technicalReferent = testContactTech;
        //NEXI-162 Zuzanna Urban<z.urban@accenture.com>, 04/07/2019 Start

        String spOriginal = JSON.serialize( servicePointWrapperOld );
        String spModded = JSON.serialize( servicePointWrapperNew );

        Test.startTest( );
        OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper result = OB_Maintenance_EditServicePoint_Ctr.saveRequest( spOriginal, spModded, '{}' );


        Test.stopTest( );
    }

    @isTest
    private static void saveRequestTest2( )
    {
        Account merchantAccount = OB_TestDataFactory.getAccount( );
        insert merchantAccount;

        OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper servicePointWrapperOne = getServicePointWrapper( merchantAccount.Id, 'one' );
        OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper servicePointWrapperTwo = getServicePointWrapper( merchantAccount.Id, 'two' );

        //NEXI-162 Zuzanna Urban<z.urban@accenture.com>, 04/07/2019 Start
        ExternalSourceMapping__c esmTwo = new ExternalSourceMapping__c(
                OB_Merchant_ID__c = merchantAccount.Id,
                OB_Service_Point_ID__c = servicePointWrapperTwo.pv.Id,
                OB_CustomerCodeClientCode__c = 'TEST 2' );
        //NEXI-162 Zuzanna Urban<z.urban@accenture.com>, 04/07/2019 Stop
        insert esmTwo;

        servicePointWrapperOne.listOfSourceMapping.add( esmTwo );
        servicePointWrapperTwo.listOfSourceMapping.add( esmTwo );

        servicePointWrapperTwo.listOfSourceMapping[ 0 ].OB_CustomerCodeClientCode__c = 'TEST MOD';
        servicePointWrapperTwo.listOfSourceMapping[ 1 ].OB_CustomerCodeClientCode__c = 'TEST 2 MOD';

        String merchantRecordTypeId = [ SELECT Id FROM RecordType WHERE Name = 'merchant' AND SobjectType = 'Account' LIMIT 1 ].Id;

        Account merchant = new Account( Name = 'name', OB_Employees_Number__c = 'Minore di 10', NE__Fiscal_code__c = 'AAAAAA11A11A111A', recordTypeId = merchantRecordTypeId, OB_VAT_Not_Present__c = true, OB_DescriptionVATNotPresent__c = 'desc' );
        Id recordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName( ).get( 'Merchant' ).getRecordTypeId( );
        merchant.RecordTypeId = recordTypeIdAcc;
        insert merchant;

        Contact cont = new Contact( );
        cont.FirstName = 'RIRI';
        cont.LastName = '';
        cont.OB_Fiscal_Code__c = 'TTORRI00B01D150K';
        cont.OB_Document_Release_Authority__c = 'Comune' ;

        cont.OB_Document_Type__c = 'Carta di Identità';
        cont.OB_Sex__c = 'M';
        cont.OB_BypassValidation__c = false;
        cont.OB_Document_Number__c = '123erty644';
        cont.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName( ).get( 'Esecutore' ).getRecordTypeId( );
        cont.AccountId = merchant.id;

        Contact con = new Contact( );
        con.FirstName = 'RIRI';
        con.LastName = 'test';
        con.OB_Fiscal_Code__c = 'TTORRI00B01D150K';
        con.OB_Document_Release_Authority__c = 'Comune' ;

        con.OB_Document_Type__c = 'Carta di Identità';
        con.OB_Sex__c = 'M';
        con.OB_BypassValidation__c = false;
        con.OB_Document_Number__c = '123erty644';
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName( ).get( 'Esecutore' ).getRecordTypeId( );
        con.AccountId = merchant.Id;
        insert con;

        Contact rightContact = ( Contact ) JSON.deserialize( JSON.serialize( cont ), Contact.class );


        NE__Service_Point__c sp1 = new NE__Service_Point__c( Name = 'Service Point Test', NE__Account__c = merchant.Id );
        insert sp1;

        NE__Service_Point__c sp2 = new NE__Service_Point__c( Name = 'Service Point Test Mod', NE__Account__c = merchant.Id );
        insert sp2;

        List<ExternalSourceMapping__c> listOfSourceMapping = new List<ExternalSourceMapping__c>( );

        ExternalSourceMapping__c ext = new ExternalSourceMapping__c( OB_Merchant_ID__c = merchant.Id,
                OB_Service_Point_ID__c = sp1.Id,
                OB_CustomerCodeClientCode__c = 'TEST' );
        listOfSourceMapping.add( ext );

        ExternalSourceMapping__c ext2 = new ExternalSourceMapping__c( OB_Merchant_ID__c = merchant.Id,
                OB_Service_Point_ID__c = sp1.Id,
                OB_CustomerCodeClientCode__c = 'TEST 2' );
        listOfSourceMapping.add( ext2 );

        insert listOfSourceMapping;

        listOfSourceMapping[ 0 ].OB_CustomerCodeClientCode__c = 'TEST MOD';
        listOfSourceMapping[ 1 ].OB_CustomerCodeClientCode__c = 'TEST 2 MOD';

        OB_LogRequest__c lr = new OB_LogRequest__c( );
        insert lr;

        OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper spw = new OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper( );
        spw.errorOccurred = false;
        spw.errorMessage = '';
        spw.logrequestId = lr.id;
        spw.pv = sp1;
        spw.listOfSourceMapping = listOfSourceMapping;
        spw.administrativeResponsible = cont;
        spw.technicalReferent = cont;
        spw.servicePointResponsible = cont;

        String spwString = JSON.serialize( spw );
        System.debug( 'spwString: ' + spwString );

        Test.startTest( );
        OB_Maintenance_EditServicePoint_Ctr.saveRequest( spwString, spwString, '{}' );
        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:  Method tests OB_Maintenance_EditServicePoint_Ctr.saveRequest method
                change from non-gambling to gambling mcc scenario
    Parameters: -
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Grzegorz Banach       9/07/2019        Created           NEXI-146
    ********************************************************************************/
    @isTest
    private static void saveRequestTestForGambling( )
    {
        Account testAccount = OB_TestDataFactory.getAccount( );
        insert testAccount;

        NE__Lov__c mccNonGamblingLov = OB_TestDataFactory.getGenericMCCLov( );
        insert mccNonGamblingLov;

        NE__Lov__c mccGamblingLov = OB_TestDataFactory.getGamblingMCCLov( );
        insert mccGamblingLov;

        NE__Service_Point__c oldTestServicePoint = OB_TestDataFactory.getServicePoint( );
        oldTestServicePoint.NE__Account__c = testAccount.Id;
        oldTestServicePoint.OB_MCC__c = mccNonGamblingLov.NE__Value2__c;
        insert oldTestServicePoint;

        NE__Service_Point__c newTestServicePoint = OB_TestDataFactory.getServicePoint( );
        newTestServicePoint.NE__Account__c = testAccount.Id;
        newTestServicePoint.OB_MCC__c = mccGamblingLov.NE__Value2__c;
        insert newTestServicePoint;

        Asset testAsset = OB_TestDataFactory.getAsset( );
        testAsset.Name = OB_Maintenance_EditServicePoint_Ctr.ASSET_NAME_VISA_MASTERCARD;
        testAsset.NE__Status__c = OB_UtilityConstants.STATUS_ACTIVE;
        testAsset.NE__Service_Point__c = newTestServicePoint.Id;
        insert testAsset;

        ExternalSourceMapping__c testOldEsm = OB_TestDataFactory.getExternalSourceMapping( );
        testOldEsm.OB_Service_Point_ID__c = oldTestServicePoint.Id;
        testOldEsm.OB_MCC__c = mccNonGamblingLov.NE__Value2__c;
        insert testOldEsm;

        ExternalSourceMapping__c testNewEsm = OB_TestDataFactory.getExternalSourceMapping( );
        testNewEsm.OB_Service_Point_ID__c = newTestServicePoint.Id;
        testNewEsm.OB_MCC__c = mccGamblingLov.NE__Value2__c;
        insert testNewEsm;

        OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper oldWrapper = new OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper( );
        oldWrapper.errorOccurred = false;
        oldWrapper.errorMessage = '';
        oldWrapper.logrequestId = null;
        oldWrapper.pv = oldTestServicePoint;
        oldWrapper.listOfSourceMapping = new List<ExternalSourceMapping__c> {testOldEsm};

        OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper newWrapper = new OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper( );
        newWrapper.errorOccurred = false;
        newWrapper.errorMessage = '';
        newWrapper.logrequestId = null;
        newWrapper.pv = newTestServicePoint;
        newWrapper.listOfSourceMapping = new List<ExternalSourceMapping__c> {testNewEsm};

        String oldWrapperJSON = JSON.serialize( oldWrapper );
        String newWrapperJSON = JSON.serialize( newWrapper );

        Test.startTest( );
        OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper result = OB_Maintenance_EditServicePoint_Ctr.saveRequest( oldWrapperJSON, newWrapperJSON, '{}' );
        Test.stopTest( );

        System.assert( !result.errorOccurred );
        System.assert( String.isNotBlank( result.logrequestId ) );
        System.assert( result.documentRequired );
        System.assert( result.conditionMCC );
        System.assert( result.approvalProcessRequired );
    }

    /*******************************************************************************
    Purpose:  Method creates Account and NE__Service_Point__c
    Parameters: String mccCode
    Returns: NE__Service_Point__c

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       15/07/2019      Created         NEXI-209
    1.1         Joanna Mielczarek       17/07/2019      Modified        NEXI-225 set codice of product
    1.2         Joanna Mielczarek       19/07/2019      Modified        NEXI-225 return service point
    ********************************************************************************/
    private static NE__Service_Point__c prepareServicePoint( String mccCode )
    {
        Account testAccount = OB_TestDataFactory.getAccount( );
        insert testAccount;

        NE__Service_Point__c testServicePoint = OB_TestDataFactory.getServicePoint( );
        testServicePoint.NE__Account__c = testAccount.Id;
        testServicePoint.OB_MCC__c = mccCode;
        insert testServicePoint;

        return testServicePoint;
    }

    /*******************************************************************************
    Purpose:  Method prepares ServicePointWrapper
    Parameters: NE__Service_Point__c inServicePoint, String mccCode, String mccL2Code
    Returns: String

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       15/07/2019      Created         NEXI-209
    1.1         Joanna Mielczarek       17/07/2019      Modified        NEXI-225 set codice of product
    1.2         Joanna Mielczarek       19/07/2019      Modified        NEXI-225 changed preparing data
    ********************************************************************************/
    private static String prepareServicePointWrapper( NE__Service_Point__c inServicePoint, String mccCode, String mccL2Code )
    {
        inServicePoint.OB_MCC__c = mccCode;

        ExternalSourceMapping__c testEsm = OB_TestDataFactory.getExternalSourceMapping( );
        testEsm.OB_Service_Point_ID__c = inServicePoint.Id;
        testEsm.OB_MCC__c = mccCode;
        testEsm.OB_MCCL2__c = mccL2Code;
        insert testEsm;

        OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper testWrapper = new OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper( );
        testWrapper.errorOccurred = false;
        testWrapper.errorMessage = '';
        testWrapper.logrequestId = null;
        testWrapper.pv = inServicePoint;
        testWrapper.listOfSourceMapping = new List<ExternalSourceMapping__c> {testEsm};

        return JSON.serialize( testWrapper );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditServicePoint_Ctr.saveRequest - Alberghi - no assets

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       19/07/2019      Created         NEXI-225
    ********************************************************************************/
    @isTest
    private static void saveRequestTestForAlberghiNoAssets( )
    {
        NE__Service_Point__c testServicePoint = prepareServicePoint( '7512' );

        String oldWrapperJSON = prepareServicePointWrapper( testServicePoint, '7512', '0047' );
        String newWrapperJSON = prepareServicePointWrapper( testServicePoint, '5631', '0002' );

        Test.startTest( );
        OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper result = OB_Maintenance_EditServicePoint_Ctr.saveRequest( oldWrapperJSON, newWrapperJSON, '{}' );
        Test.stopTest( );

        System.assert( result.conditionMCC );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditServicePoint_Ctr.saveRequest - alberghi code and asset which fulfils conditions
              - false result

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       19/07/2019      Created         NEXI-225
    1.1         Kinga Fornal            08/08/2019      Updated         added RecordTypeId to the testProduct
    ********************************************************************************/
    @isTest
    private static void saveRequestTestAlberghiFalse( )
    {
        NE__Service_Point__c servicePoint = prepareServicePoint( '7512' );

        NE__Product__c testProduct = OB_TestDataFactory.getProduct( );
        testProduct.RecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.PRODUCT_RECORDTYPE_VAS ).getRecordTypeId( );
        testProduct.OB_Codice_sfdc__c = OB_Maintenance_EditServicePoint_Ctr.CODICE_SFDC_ALB_AUTO;
        insert testProduct;

        Asset testAsset = OB_TestDataFactory.getAsset( );
        testAsset.OB_MCC__c = '5631';
        testAsset.OB_MCCL2__c = '0002';
        testAsset.NE__Status__c = OB_UtilityConstants.STATUS_ACTIVE;
        testAsset.NE__Service_Point__c = servicePoint.Id;
        testAsset.NE__ProdId__c = testProduct.Id;
        testAsset.RecordTypeId = OB_Maintenance_EditServicePoint_Ctr.ASSET_RT_VAS;
        insert testAsset;

        String oldData = prepareServicePointWrapper( servicePoint, '7512', '0047' );
        String newData = prepareServicePointWrapper( servicePoint, '5631', '0002' );

        Test.startTest( );
        OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper result = OB_Maintenance_EditServicePoint_Ctr.saveRequest( oldData, newData, '{}' );
        Test.stopTest( );

        System.assert( !result.conditionMCC );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditServicePoint_Ctr.saveRequest - alberghi code and true result
              - false result

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       19/07/2019      Created         NEXI-225
    ********************************************************************************/
    @isTest
    private static void saveRequestTestAlberghiTrue( )
    {
        NE__Service_Point__c servicePoint = prepareServicePoint( '7512' );

        Asset testAsset = OB_TestDataFactory.getAsset( );
        testAsset.OB_MCC__c = '5631';
        testAsset.OB_MCCL2__c = '0002';
        testAsset.NE__Status__c = OB_UtilityConstants.STATUS_ACTIVE;
        testAsset.NE__Service_Point__c = servicePoint.Id;
        insert testAsset;

        String oldData = prepareServicePointWrapper( servicePoint, '7512', '0047' );
        String newData = prepareServicePointWrapper( servicePoint, '5631', '0002' );

        Test.startTest( );
        OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper result = OB_Maintenance_EditServicePoint_Ctr.saveRequest( oldData, newData, '{}' );
        Test.stopTest( );

        System.assert( result.conditionMCC );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditServicePoint_Ctr.saveRequest - actual mcc code is 5542
              - false result

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       19/07/2019      Created         NEXI-225
    ********************************************************************************/
    @isTest
    private static void saveRequestTestOld5542( )
    {
        NE__Service_Point__c servicePoint = prepareServicePoint( '5542' );

        String oldData = prepareServicePointWrapper( servicePoint, '5542', '0016' );
        String newData = prepareServicePointWrapper( servicePoint, '5631', '0002' );

        Test.startTest( );
        OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper result = OB_Maintenance_EditServicePoint_Ctr.saveRequest( oldData, newData, '{}' );
        Test.stopTest( );

        System.assert( !result.conditionMCC );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditServicePoint_Ctr.saveRequest - 5542 - no assets

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       19/07/2019      Created         NEXI-225
    ********************************************************************************/
    @isTest
    private static void saveRequestTestFor5542NoAssets( )
    {
        NE__Service_Point__c testServicePoint = prepareServicePoint( '5631' );

        String oldWrapperJSON = prepareServicePointWrapper( testServicePoint, '5631', '0002' );
        String newWrapperJSON = prepareServicePointWrapper( testServicePoint, '5542', '0016' );

        Test.startTest( );
        OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper result = OB_Maintenance_EditServicePoint_Ctr.saveRequest( oldWrapperJSON, newWrapperJSON, '{}' );
        Test.stopTest( );

        System.assert( result.conditionMCC );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditServicePoint_Ctr.saveRequest - 5542 - visamastercard product

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       15/07/2019      Created         NEXI-209
    1.1         Joanna Mielczarek       16/07/2019      Modified        NEXI-212 remove asserts
    ********************************************************************************/
    @isTest
    private static void saveRequestTestFor5542VM( )
    {
        NE__Service_Point__c testServicePoint = prepareServicePoint( '5631' );

        NE__Product__c testProduct = OB_TestDataFactory.getProduct( );
        testProduct.OB_Codice_sfdc__c = OB_Maintenance_EditServicePoint_Ctr.VISA_MASTERCARD;
        insert testProduct;

        Asset testAsset = OB_TestDataFactory.getAsset( );
        testAsset.OB_MCC__c = '5542';
        testAsset.OB_MCCL2__c = '0016';
        testAsset.NE__Status__c = OB_UtilityConstants.STATUS_ACTIVE;
        testAsset.NE__Service_Point__c = testServicePoint.Id;
        testAsset.NE__ProdId__c = testProduct.Id;
        insert testAsset;

        String oldWrapperJSON = prepareServicePointWrapper( testServicePoint, '5631', '0002' );
        String newWrapperJSON = prepareServicePointWrapper( testServicePoint, '5542', '0016' );

        Test.startTest( );
        OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper result = OB_Maintenance_EditServicePoint_Ctr.saveRequest( oldWrapperJSON, newWrapperJSON, '{}' );
        Test.stopTest( );

        System.assert( !result.conditionMCC );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditServicePoint_Ctr.saveRequest - 5542 - attended product

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       19/07/2019      Created         NEXI-225
    ********************************************************************************/
    @isTest
    private static void saveRequestTestFor5542Attended( )
    {
        NE__Service_Point__c testServicePoint = prepareServicePoint( '5631' );

        NE__Product__c testProduct = OB_TestDataFactory.getProduct( );
        testProduct.RecordTypeId = OB_Maintenance_EditServicePoint_Ctr.PRODUCT_RT_POS;
        testProduct.OB_Codice_sfdc__c = OB_UtilityConstants.POS_TERZI_ATTENDED;
        insert testProduct;

        Asset testAsset = OB_TestDataFactory.getAsset( );
        testAsset.OB_MCC__c = '5542';
        testAsset.OB_MCCL2__c = '0016';
        testAsset.NE__Status__c = OB_UtilityConstants.STATUS_ACTIVE;
        testAsset.NE__Service_Point__c = testServicePoint.Id;
        testAsset.NE__ProdId__c = testProduct.Id;
        insert testAsset;

        String oldWrapperJSON = prepareServicePointWrapper( testServicePoint, '5631', '0002' );
        String newWrapperJSON = prepareServicePointWrapper( testServicePoint, '5542', '0016' );

        Test.startTest( );
        OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper result = OB_Maintenance_EditServicePoint_Ctr.saveRequest( oldWrapperJSON, newWrapperJSON, '{}' );
        Test.stopTest( );

        System.assert( !result.conditionMCC );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditServicePoint_Ctr.saveRequest - 5542 - true scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       19/07/2019      Created         NEXI-225
    ********************************************************************************/
    @isTest
    private static void saveRequestTestFor5542True( )
    {
        NE__Service_Point__c testServicePoint = prepareServicePoint( '5631' );

        Asset testAsset = OB_TestDataFactory.getAsset( );
        testAsset.OB_MCC__c = '5542';
        testAsset.OB_MCCL2__c = '0016';
        testAsset.NE__Status__c = OB_UtilityConstants.STATUS_ACTIVE;
        testAsset.NE__Service_Point__c = testServicePoint.Id;
        insert testAsset;

        String oldWrapperJSON = prepareServicePointWrapper( testServicePoint, '5631', '0002' );
        String newWrapperJSON = prepareServicePointWrapper( testServicePoint, '5542', '0016' );

        Test.startTest( );
        OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper result = OB_Maintenance_EditServicePoint_Ctr.saveRequest( oldWrapperJSON, newWrapperJSON, '{}' );
        Test.stopTest( );

        System.assert( result.conditionMCC );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditServicePoint_Ctr.saveRequest - 5541 - no assets

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       19/07/2019      Created         NEXI-225
    ********************************************************************************/
    @isTest
    private static void saveRequestTestFor5541NoAssets( )
    {
        NE__Service_Point__c testServicePoint = prepareServicePoint( '5631' );

        String oldWrapperJSON = prepareServicePointWrapper( testServicePoint, '5631', '0002' );
        String newWrapperJSON = prepareServicePointWrapper( testServicePoint, '5541', '0016' );

        Test.startTest( );
        OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper result = OB_Maintenance_EditServicePoint_Ctr.saveRequest( oldWrapperJSON, newWrapperJSON, '{}' );
        Test.stopTest( );

        System.assert( result.conditionMCC );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditServicePoint_Ctr.saveRequest - 5541 - false result

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       19/07/2019      Created         NEXI-225
    1.1         Joanna Mielczarek       07/08/2019      Modified        NEXI-262 align test to new logic
    ********************************************************************************/
    @isTest
    private static void saveRequestTestFor5541False( )
    {
        NE__Service_Point__c testServicePoint = prepareServicePoint( '5631' );

        NE__Product__c rootProduct = OB_TestDataFactory.getProduct( );
        rootProduct.OB_Codice_sfdc__c = OB_Maintenance_EditServicePoint_Ctr.VISA_MASTERCARD;
        insert rootProduct;

        Asset rootAsset = OB_TestDataFactory.getAsset( );
        rootAsset.NE__ProdId__c = rootProduct.Id;
        rootAsset.OB_enablement__c = 'Y';
        insert rootAsset;

        NE__Product__c childProduct = OB_TestDataFactory.getProduct( );
        childProduct.OB_Codice_sfdc__c = OB_UtilityConstants.START_SFDC;
        insert childProduct;

        Asset childAsset = OB_TestDataFactory.getAsset( );
        childAsset.NE__ProdId__c = childProduct.Id;
        insert childAsset;

        NE__Product__c testProduct = OB_TestDataFactory.getProduct( );
        testProduct.OB_Codice_sfdc__c = OB_UtilityConstants.POS_TERZI_UNATTENDED;
        testProduct.RecordTypeId = OB_Maintenance_EditServicePoint_Ctr.PRODUCT_RT_POS;
        insert testProduct;

        Asset testAsset = OB_TestDataFactory.getAsset( );
        testAsset.OB_MCC__c = '5541';
        testAsset.OB_MCCL2__c = '0016';
        testAsset.NE__Status__c = OB_UtilityConstants.STATUS_ACTIVE;
        testAsset.NE__Service_Point__c = testServicePoint.Id;
        testAsset.NE__ProdId__c = testProduct.Id;
        testAsset.NE__Root_Order_Item__c = rootAsset.Id;
        testAsset.NE__Bundle_Configuration__c = childAsset.Id;
        insert testAsset;

        String oldWrapperJSON = prepareServicePointWrapper( testServicePoint, '5631', '0002' );
        String newWrapperJSON = prepareServicePointWrapper( testServicePoint, '5541', '0016' );

        Test.startTest( );
        OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper result = OB_Maintenance_EditServicePoint_Ctr.saveRequest( oldWrapperJSON, newWrapperJSON, '{}' );
        Test.stopTest( );

        System.assert( !result.conditionMCC );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditServicePoint_Ctr.saveRequest - confirmed Log Request

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Grzegorz Banach       02/09/2019        Created          NEXI-294
    ********************************************************************************/
    @isTest
    private static void saveRequestTestConfirmedLogRequest( )
    {
        String mccCode = '5631';
        String mccL2Code = '0002';

        NE__Service_Point__c testServicePoint = prepareServicePoint( mccCode );

        ExternalSourceMapping__c testEsm = OB_TestDataFactory.getExternalSourceMapping( );
        testEsm.OB_Service_Point_ID__c = testServicePoint.Id;
        testEsm.OB_MCC__c = mccCode;
        testEsm.OB_MCCL2__c = mccL2Code;
        testEsm.OB_InternationalSettlementMethod__c = '';
        insert testEsm;

        OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper testWrapper = new OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper( );
        testWrapper.errorOccurred = false;
        testWrapper.errorMessage = '';
        testWrapper.logrequestId = null;
        testWrapper.pv = testServicePoint;
        testWrapper.listOfSourceMapping = new List<ExternalSourceMapping__c> {testEsm};

        String oldWrapperJSON = JSON.serialize( testWrapper );
        testEsm.OB_InternationalSettlementMethod__c = 'ACCREDITO AL LORDO DELLE COMMISSIONI';
        String newWrapperJSON = JSON.serialize( testWrapper );

        Test.startTest( );
        OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper result = OB_Maintenance_EditServicePoint_Ctr.saveRequest( oldWrapperJSON, newWrapperJSON, '{}' );
        Test.stopTest( );

        System.assert( !result.errorOccurred );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditServicePoint_Ctr.saveRequest - 5541 - true result

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       19/07/2019      Created         NEXI-225
    ********************************************************************************/
    @isTest
    private static void saveRequestTestFor5541True( )
    {
        NE__Service_Point__c testServicePoint = prepareServicePoint( '5631' );

        Asset testAsset = OB_TestDataFactory.getAsset( );
        testAsset.OB_MCC__c = '5541';
        testAsset.OB_MCCL2__c = '0016';
        testAsset.NE__Status__c = OB_UtilityConstants.STATUS_ACTIVE;
        testAsset.NE__Service_Point__c = testServicePoint.Id;
        insert testAsset;

        String oldWrapperJSON = prepareServicePointWrapper( testServicePoint, '5631', '0002' );
        String newWrapperJSON = prepareServicePointWrapper( testServicePoint, '5541', '0016' );

        Test.startTest( );
        OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper result = OB_Maintenance_EditServicePoint_Ctr.saveRequest( oldWrapperJSON, newWrapperJSON, '{}' );
        Test.stopTest( );

        System.assert( result.conditionMCC );
    }

    @isTest
    private static void retriveSchemaInformationTest( )
    {

        List<String> SObjectToRetrive = new List<String>( );
        SObjectToRetrive.add( 'Account' );
        SObjectToRetrive.add( 'Contact' );
        Test.startTest( );
        OB_Maintenance_EditServicePoint_Ctr.retriveSchemaInformation( SObjectToRetrive );
        Test.stopTest( );
    }

    @isTest
    private static void retrieveServicePointDataTest( )
    {
        String merchantRecordTypeId = [ SELECT Id FROM RecordType WHERE Name = 'merchant' AND SobjectType = 'Account' LIMIT 1 ].Id;
        Account merchant = new Account( Name = 'name', OB_Employees_Number__c = 'Minore di 10', RecordTypeId = merchantRecordTypeId, NE__Fiscal_code__c = 'AAAAAA11A11A111A', OB_VAT_Not_Present__c = true, OB_DescriptionVATNotPresent__c = 'desc' );

        Id recordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName( ).get( 'Merchant' ).getRecordTypeId( );
        merchant.RecordTypeId = recordTypeIdAcc;
        insert merchant;

        NE__Service_Point__c sp1 = new NE__Service_Point__c( Name = 'Service Point Test', NE__Account__c = merchant.Id );
        insert sp1;

        OB_Maintenance_EditServicePoint_Ctr.retrieveServicePointData( sp1.Id );
    }

    @isTest
    private static void retriveValueTypologyTest( )
    {
        List<String> sObjectToRetrive = new List<String>( );
        sObjectToRetrive.add( 'Account' );
        OB_Maintenance_EditServicePoint_Ctr.retriveSchemaInformation( sObjectToRetrive );
    }

    @isTest
    private static void retrieveValueTypologyTest( )
    {
        OB_Maintenance_EditServicePoint_Ctr.retrieveValueTypology( );
    }

    @isTest
    private static void retrievePuntiVenditaDataTest( )
    {
        String merchantRecordTypeId = [ SELECT Id FROM RecordType WHERE Name = 'merchant' AND SobjectType = 'Account' LIMIT 1 ].Id;
        String merchantRecordTypeId2 = [ SELECT Id FROM RecordType WHERE Name = 'Bank' AND SobjectType = 'Account' LIMIT 1 ].Id;

        String valueAbi = '';
        Account merchant = new Account( );
        merchant.Name = 'name';
        merchant.RecordTypeId = merchantRecordTypeId;
        merchant.OB_Employees_Number__c = 'Minore di 10';
        merchant.NE__Fiscal_code__c = 'AAAAAA11A11A111A';
        merchant.OB_VAT_Not_Present__c = true;
        merchant.OB_DescriptionVATNotPresent__c = 'desc';
        merchant.OB_ABI__c = valueAbi;
        insert merchant;
        Account acc = new Account( );
        acc.Name = 'name';
        acc.RecordTypeId = merchantRecordTypeId2;
        acc.OB_Employees_Number__c = 'Minore di 10';
        acc.NE__Fiscal_code__c = 'AAAAAA11A11A111A';
        acc.OB_VAT_Not_Present__c = true;
        acc.OB_DescriptionVATNotPresent__c = 'desc';
        acc.OB_ABI__c = null;
        insert acc;

        NE__Service_Point__c sp = new NE__Service_Point__c( );
        insert sp;
        ExternalSourceMapping__c esm = new ExternalSourceMapping__c( );
        esm.OB_Service_Point_ID__c = sp.id;
        esm.OB_CustomerCodeClientCode__c = '123';
        insert esm;
        ExternalSourceMapping__c esm2 = new ExternalSourceMapping__c( );
        esm.OB_Service_Point_ID__c = sp.id;
        esm2.OB_ServicePointCodeShopCode__c = 'abcde';
        esm2.OB_CustomerCodeClientCode__c = '12345';
        insert esm2;
        List<ExternalSourceMapping__c> esmList = new List <ExternalSourceMapping__c>( );
        esmList.add( esm );
        esmList.add( esm2 );

        Asset ass1 = new Asset( );
        ass1.Name = 'test';
        ass1.AccountId = acc.id;
        ass1.NE__Status__c = 'Active';
        ass1.NE__Service_Point__c = sp.id;
        ass1.OB_GT__c = 'Monetica';
        ass1.OB_CustomerCode__c = '12345';
        ass1.OB_ShopCode__c = 'abcde';
        ass1.OB_ProposerABI__c = acc.Id;
        insert ass1;
        Asset ass2 = new Asset( );
        ass2.Name = 'test';
        ass2.AccountId = merchant.id;
        ass2.NE__Status__c = 'Active';
        ass2.NE__Service_Point__c = sp.id;
        ass2.OB_Processor__c = 'EQUENS';
        ass2.OB_CompanyCode__c = '123';
        insert ass2;
        Test.startTest( );
        OB_Maintenance_EditServicePoint_Ctr.retrievePuntiVenditaData( sp.id );
        Test.stopTest( );
    }
    // PRODOB-106,  Doris Dongmo <doris.tatiana.dongmo@accenture.com>, 06/05/2019 - Start

    @isTest
    private static void retrievePuntiVenditaDataTest_2( )
    {
        String merchantRecordTypeId = [ SELECT Id FROM RecordType WHERE Name = 'merchant' AND SobjectType = 'Account' LIMIT 1 ].Id;
        Account merchant = new Account( );
        merchant.Name = 'name';
        merchant.RecordTypeId = merchantRecordTypeId;
        merchant.OB_Employees_Number__c = 'Minore di 10';
        merchant.NE__Fiscal_code__c = 'AAAAAA11A11A111A';
        merchant.OB_VAT_Not_Present__c = true;
        merchant.OB_DescriptionVATNotPresent__c = 'desc';
        insert merchant;
        NE__Service_Point__c sp = new NE__Service_Point__c( );
        insert sp;
        ExternalSourceMapping__c esm = new ExternalSourceMapping__c( );
        esm.OB_Service_Point_ID__c = sp.id;
        esm.OB_CustomerCodeClientCode__c = '12345';
        esm.OB_ServicePointCodeShopCode__c = '1234567';
        esm.OB_Conventioncode__c = '4532';
        insert esm;
        Asset ass1 = new Asset( );
        ass1.Name = 'test';
        ass1.AccountId = merchant.id;
        ass1.NE__Status__c = 'Active';
        ass1.NE__Service_Point__c = sp.id;
        ass1.OB_GT__c = 'Monetica';
        ass1.OB_CustomerCode__c = '12345';
        ass1.OB_ShopCode__c = '1234567';
        insert ass1;

        Asset ass3 = new Asset( );
        ass3.Name = 'test';
        ass3.AccountId = merchant.id;
        ass3.NE__Status__c = 'Active';
        ass3.NE__Service_Point__c = sp.id;
        ass3.OB_Processor__c = 'EQUENS';
        ass3.OB_CompanyCode__c = '12345';
        ass3.OB_ServicePointCode__c = '1234567';
        insert ass3;

        Test.startTest( );
        OB_Maintenance_EditServicePoint_Ctr.retrievePuntiVenditaData( sp.id );
        Test.stopTest( );
    }

    @isTest
    private static void retrievePuntiVenditaDataTest_3( )
    {
        String merchantRecordTypeId = [ SELECT Id FROM RecordType WHERE Name = 'merchant' AND SobjectType = 'Account' LIMIT 1 ].Id;
        Account merchant = new Account( );
        merchant.Name = 'name';
        merchant.RecordTypeId = merchantRecordTypeId;
        merchant.OB_Employees_Number__c = 'Minore di 10';
        merchant.NE__Fiscal_code__c = 'AAAAAA11A11A111A';
        merchant.OB_VAT_Not_Present__c = true;
        merchant.OB_DescriptionVATNotPresent__c = 'desc';
        insert merchant;
        NE__Service_Point__c sp = new NE__Service_Point__c( );
        insert sp;
        ExternalSourceMapping__c esm = new ExternalSourceMapping__c( );
        esm.OB_Service_Point_ID__c = sp.id;
        esm.OB_CustomerCodeClientCode__c = '12345';
        esm.OB_ServicePointCodeShopCode__c = '1234567';
        insert esm;
        Asset ass1 = new Asset( );
        ass1.Name = 'test';
        ass1.AccountId = merchant.id;
        ass1.NE__Status__c = 'Active';
        ass1.NE__Service_Point__c = sp.id;
        ass1.OB_GT__c = 'Monetica';
        ass1.OB_CustomerCode__c = '1237';
        ass1.OB_ShopCode__c = '1234';
        insert ass1;
        Asset ass3 = new Asset( );
        ass3.Name = 'test';
        ass3.AccountId = merchant.id;
        ass3.NE__Status__c = 'Active';
        ass3.NE__Service_Point__c = sp.id;
        ass3.OB_Processor__c = 'EQUENS';
        ass3.OB_CompanyCode__c = '12345';
        ass3.OB_ServicePointCode__c = '1234567';
        insert ass3;

        Test.startTest( );
        OB_Maintenance_EditServicePoint_Ctr.retrievePuntiVenditaData( sp.id );
        Test.stopTest( );
    }

    @isTest
    private static void retrievePuntiVenditaDataTest_4( )
    {
        String merchantRecordTypeId = [ SELECT Id FROM RecordType WHERE Name = 'merchant' AND SobjectType = 'Account' LIMIT 1 ].Id;
        Account merchant = new Account( );
        merchant.Name = 'name';
        merchant.RecordTypeId = merchantRecordTypeId;
        merchant.OB_Employees_Number__c = 'Minore di 10';
        merchant.NE__Fiscal_code__c = 'AAAAAA11A11A111A';
        merchant.OB_VAT_Not_Present__c = true;
        merchant.OB_DescriptionVATNotPresent__c = 'desc';
        insert merchant;
        NE__Service_Point__c sp = new NE__Service_Point__c( );
        insert sp;
        ExternalSourceMapping__c esm = new ExternalSourceMapping__c( );
        esm.OB_Service_Point_ID__c = sp.id;
        esm.OB_CustomerCodeClientCode__c = '12345';
        esm.OB_ServicePointCodeShopCode__c = '1234567';
        insert esm;
        Asset ass1 = new Asset( );
        ass1.Name = 'test';
        ass1.AccountId = merchant.id;
        ass1.NE__Status__c = 'Active';
        ass1.NE__Service_Point__c = sp.id;
        ass1.OB_GT__c = 'Monetica';
        ass1.OB_CustomerCode__c = '12345';
        ass1.OB_ShopCode__c = '1234567';
        insert ass1;
        Asset ass2 = new Asset( );
        ass2.Name = 'test';
        ass2.AccountId = merchant.id;
        ass2.NE__Status__c = 'Active';
        ass2.NE__Service_Point__c = sp.id;
        ass2.OB_Processor__c = 'EQUENS';
        ass2.OB_CompanyCode__c = '12345';
        insert ass2;

        Test.startTest( );
        OB_Maintenance_EditServicePoint_Ctr.retrievePuntiVenditaData( sp.id );
        Test.stopTest( );
    }
    // PRODOB-106,  Doris Dongmo <doris.tatiana.dongmo@accenture.com>, 06/05/2019 - End

    @isTest
    private static void retrieveLovMccL2Test( )
    {
        Test.startTest( );
        OB_Maintenance_EditServicePoint_Ctr.retrieveLovMccL2( );
        Test.stopTest( );
    }

    @isTest
    private static void retrieveLovMccL3Test( )
    {
        Test.startTest( );
        OB_Maintenance_EditServicePoint_Ctr.retrieveLovMccL3( );
        Test.stopTest( );
    }

    @isTest
    private static void checkCoherencyDateTest( )
    {
        Test.startTest( );
        OB_Maintenance_EditServicePoint_Ctr.checkCoherencyDate( null, null, Time.newInstance( 13, 00, 00, 00 ), Time.newInstance( 13, 00, 00, 00 ) );
        OB_Maintenance_EditServicePoint_Ctr.checkCoherencyDate( Time.newInstance( 09, 00, 00, 00 ), null, Time.newInstance( 13, 00, 00, 00 ), Time.newInstance( 14, 00, 00, 00 ) );
        OB_Maintenance_EditServicePoint_Ctr.checkCoherencyDate( null, Time.newInstance( 18, 00, 00, 00 ), Time.newInstance( 13, 00, 00, 00 ), Time.newInstance( 14, 00, 00, 00 ) );
        OB_Maintenance_EditServicePoint_Ctr.checkCoherencyDate( Time.newInstance( 09, 00, 00, 00 ), Time.newInstance( 18, 00, 00, 00 ), Time.newInstance( 13, 00, 00, 00 ), null );
        OB_Maintenance_EditServicePoint_Ctr.checkCoherencyDate( Time.newInstance( 09, 00, 00, 00 ), Time.newInstance( 18, 00, 00, 00 ), null, Time.newInstance( 14, 00, 00, 00 ) );
        OB_Maintenance_EditServicePoint_Ctr.checkCoherencyDate( Time.newInstance( 18, 00, 00, 00 ), Time.newInstance( 09, 00, 00, 00 ), null, Time.newInstance( 14, 00, 00, 00 ) );
        OB_Maintenance_EditServicePoint_Ctr.checkCoherencyDate( Time.newInstance( 09, 00, 00, 00 ), Time.newInstance( 14, 00, 00, 00 ), Time.newInstance( 13, 00, 00, 00 ), Time.newInstance( 18, 00, 00, 00 ) );
        OB_Maintenance_EditServicePoint_Ctr.checkCoherencyDate( Time.newInstance( 13, 00, 00, 00 ), Time.newInstance( 14, 00, 00, 00 ), Time.newInstance( 09, 00, 00, 00 ), Time.newInstance( 18, 00, 00, 00 ) );
        OB_Maintenance_EditServicePoint_Ctr.checkCoherencyDate( Time.newInstance( 09, 00, 00, 00 ), Time.newInstance( 18, 00, 00, 00 ), Time.newInstance( 08, 00, 00, 00 ), Time.newInstance( 17, 00, 00, 00 ) );

        Test.stopTest( );
    }

    @isTest
    private static void ParseTime_Test( )
    {

        Test.startTest( );
        String timeString = '14:26:41.276Z';

        OB_Maintenance_EditServicePoint_Ctr.ParseTime( timeString );
        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditServicePoint_Ctr.deleteLogRequest - success scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       05/07/2019      Created         NEXI-143
    1.1         Joanna Mielczarek       16/07/2019      Modified        NEXI-212 re-added assert
    ********************************************************************************/
    @isTest
    private static void deleteLogRequestHappyTest( )
    {
        OB_LogRequest__c testLogRequest = OB_TestDataFactory.getLogRequest( );
        insert testLogRequest;

        Test.startTest( );
        String result = OB_Maintenance_EditServicePoint_Ctr.deleteLogRequest( String.valueOf( testLogRequest.Id ) );  //  Micol Ferrari <micol.ferrari@accenture.com>, 13/07/2019
        Test.stopTest( );

        System.assertEquals( '', result );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditServicePoint_Ctr.deleteLogRequest - fail scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       05/07/2019      Created         NEXI-143
    1.1         Joanna Mielczarek       16/07/2019      Modified        NEXI-212 re-added assert
    ********************************************************************************/
    @isTest
    private static void deleteLogRequestFailTest( )
    {
        OB_LogRequest__c testLogRequest = OB_TestDataFactory.getLogRequest( );
        insert testLogRequest;

        Test.startTest( );
        String result = OB_Maintenance_EditServicePoint_Ctr.deleteLogRequest( null ); //  Micol Ferrari <micol.ferrari@accenture.com>, 13/07/2019
        Test.stopTest( );

        System.assert( !String.isBlank( result ) );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditServicePoint_Ctr.startApprovalProcess - positive scenario

    History
    --------
    1.0         Grzegorz Banach       05/07/2019        Created         NEXI-143
    1.1			Joanna Mielczarek	   02/08/2019		Modified	      NEXI-201 added missing values
    ********************************************************************************/
    @isTest
    private static void startApprovalProcessTest( )
    {
        OB_LogRequest__c testLogRequest = OB_TestDataFactory.getLogRequest( );
        testLogRequest.OB_Change_of_data_of_beneficial_owners__c = true;
        testLogRequest.OB_isGambling__c = true;
        testLogRequest.OB_Gianos__c = '26';

        insert testLogRequest;

        NE__Product__c testCommercialProduct = OB_TestDataFactory.getProduct( );
        testCommercialProduct.OB_Acquirer__c = OB_UtilityConstants.PRODUCT_ACQUIRER_NEXI;
        insert testCommercialProduct;

        NE__Catalog__c testCatalog = OB_TestDataFactory.getCatalog( );
        insert testCatalog;

        NE__Catalog_Item__c testCatalogItem = OB_TestDataFactory.getCatalogItem( testCatalog.Id, testCommercialProduct.Id );
        insert testCatalogItem;

        Asset testAsset = OB_TestDataFactory.getAsset( );
        testAsset.AccountId = testLogRequest.OB_AccountId__c;
        testAsset.Name = OB_Maintenance_EditServicePoint_Ctr.ASSET_NAME_VISA_MASTERCARD;
        testAsset.NE__Status__c = OB_UtilityConstants.STATUS_ACTIVE;
        testAsset.NE__CatalogItem__c = testCatalogItem.Id;
        testAsset.NE__ProdId__c = testCommercialProduct.Id;
        testAsset.NE__Root_Order_Item__c = null;
        insert testAsset;

        Boolean approvalStarted = OB_Maintenance_EditServicePoint_Ctr.startApprovalProcess( testLogRequest.Id );

        System.assert( approvalStarted );
    }

    /*******************************************************************************
    Purpose:    Test method of merchantAndAssetCheck
                with null and blank values

    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Szuba       	12/08/2019      Created         NEXI-261
    ********************************************************************************/
    @isTest
    private static void merchantAndAssetCheckWithNullIdAndNoJSON( )
    {
        Test.startTest( );
        OB_Maintenance_EditServicePoint_Ctr.MerchantAssetCheckWrapper result = OB_Maintenance_EditServicePoint_Ctr.merchantAndAssetCheck( null, '' );
        Test.stopTest( );
        System.assert( !result.assetCheck );
        System.assert( !result.merchantCheck );
    }

    /*******************************************************************************
    Purpose:    Test method of merchantAndAssetCheck
                with wrong JSON value

    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Szuba       	12/08/2019      Created         NEXI-261
    ********************************************************************************/
    @isTest
    private static void merchantAndAssetCheckWithWrongJSON( )
    {
        Test.startTest( );
        OB_Maintenance_EditServicePoint_Ctr.MerchantAssetCheckWrapper result = OB_Maintenance_EditServicePoint_Ctr.merchantAndAssetCheck( null, 'wrong' );
        Test.stopTest( );
        System.assert( !result.assetCheck );
        System.assert( !result.merchantCheck );
    }

    /*******************************************************************************
    Purpose:    Test method of merchantAndAssetCheck
                with correct values

    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Szuba       	12/08/2019      Created         NEXI-261
    ********************************************************************************/
    @isTest
    private static void merchantAndAssetCheckTest( )
    {
        Account accTest = OB_TestDataFactory.getAccount( );
        accTest.NE__VAT__c = null;
        accTest.OB_VAT_Not_Present__c = true;
        accTest.OB_DescriptionVATNotPresent__c = OB_UtilityConstants.B_AND_B;
        insert accTest;

        Asset testAsset = OB_TestDataFactory.getAsset( );
        testAsset.OB_ServicePointCode__c = '0004';
        testAsset.OB_SettlementType__c = OB_UtilityConstants.SETTLEMENT_TYPE_BANCA_LORDO;
        insert testAsset;

        String testJson = '[{"Id":"a2A000000000xxxEST","OB_ServicePointCodeShopCode__c":"0004"}]';

        Test.startTest( );
        OB_Maintenance_EditServicePoint_Ctr.MerchantAssetCheckWrapper result = OB_Maintenance_EditServicePoint_Ctr.merchantAndAssetCheck( accTest.Id, testJson );
        Test.stopTest( );
        System.assert( result.assetCheck );
        System.assert( result.merchantCheck );
    }

    /*******************************************************************************
    Purpose:   Test method check when ServicePointWrapper has value MCC equals to PO118
    and the old is empty.

    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Michal Targiel       25/07/2019   	   Created         	NEXI-232
    ********************************************************************************/
    @isTest
    private static void logRequestPO118MoToSetRetrunOBPO118MOTOcSetToTrue( )
    {
        List<OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper> testData = prepareDataForLogRequestPO118MoTo( );
        NE__Product__c product = OB_TestDataFactory.getProduct( );
        product.RecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.PRODUCT_RECORDTYPE_MOTO ).getRecordTypeId( );
        insert product;

        Asset asset = OB_TestDataFactory.getAsset( );
        asset.NE__Service_Point__c = testData[ 0 ].pv.Id;
        asset.NE__ProdId__c = product.Id;
        insert asset;

        System.assertEquals( new Map<String, String> {OB_UtilityConstants.OB_PO118_MOTO => 'true'}, OB_Maintenance_EditServicePoint_Ctr.LogRequestPO118MoToSet( testData[ 0 ], testData[ 1 ] ) );
    }
    /*******************************************************************************
    Purpose:   Test method check when method LogRequestPO118MoTo get all not null parameters
    but method can't find correct asserts. Set OB_PO118_MOTO__c to false.

    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Michal Targiel       25/07/2019   	   Created         	NEXI-232
    ********************************************************************************/
    @isTest
    private static void logRequestPO118MoToSetRetrunOBPO118MOTOcWithEmptyAssertsSetToFalse( )
    {
        List<OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper> testData = prepareDataForLogRequestPO118MoTo( );
        System.assertEquals( new Map<String, String> {OB_UtilityConstants.OB_PO118_MOTO => 'false'}, OB_Maintenance_EditServicePoint_Ctr.LogRequestPO118MoToSet( testData[ 0 ], testData[ 1 ] ) );
    }

    /*******************************************************************************
    Purpose:   Test method check when LogRequestPO118MoToSet method get null
    in parameters and set OB_PO118_MOTO__c to false
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Michal Targiel       25/07/2019   	   Created         	NEXI-232
    ********************************************************************************/
    @isTest
    private static void logRequestPO118MoToSetGetNullAndReturnFalse( )
    {
        System.assertEquals( new Map<String, String> {OB_UtilityConstants.OB_PO118_MOTO => 'false'}, OB_Maintenance_EditServicePoint_Ctr.LogRequestPO118MoToSet( null, null ) );
    }

    /*******************************************************************************
    Purpose: Method prepare data for test method LogRequestPO118MoToSet
     Parameters: *
    Returns: List<OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper>
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Michal Targiel       25/07/2019   	   Created         	NEXI-232
    ********************************************************************************/
    private static List<OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper> prepareDataForLogRequestPO118MoTo( )
    {
        ExternalSourceMapping__c externalSourceMapping = OB_TestDataFactory.getExternalSourceMapping( );
        externalSourceMapping.OB_MCC__c = '3061';
        insert externalSourceMapping;

        NE__Lov__c lov = OB_TestDataFactory.getLov( );
        lov.NE__Value1__c = OB_UtilityConstants.MCC_LOV_PO118;
        lov.NE__Value2__c = '3061';
        lov.NE__Type__c = 'MCC';
        insert lov;

        ExternalSourceMapping__c externalSourceMappingOld = OB_TestDataFactory.getExternalSourceMapping( );
        externalSourceMappingOld.Id = externalSourceMapping.Id;

        OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper simpleNew = new OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper( );
        simpleNew.listOfSourceMapping = new ExternalSourceMapping__c[]
        {
                externalSourceMapping
        };

        OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper simpleNewOld = new OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper( );
        simpleNewOld.listOfSourceMapping = new ExternalSourceMapping__c[]
        {
                externalSourceMappingOld
        };

        simpleNew.pv = OB_TestDataFactory.getServicePoint( );
        insert simpleNew.pv;

        simpleNewOld.pv = OB_TestDataFactory.getServicePoint( );

        return new OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper[]
        {
                simpleNew,
                simpleNewOld
        };
    }

    /*******************************************************************************
    Purpose: Test of saveRequest method, empty Account lookup on Service Point

    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Grzegorz Banach       21/08/2019   	    Created          NEXI-261
    ********************************************************************************/
    @isTest
    private static void saveRequestTestEmptyAccountId( )
    {
        Map<String, Object> testNewData = new Map<String, Object> {'pv' => new Map<String, String>( )};
        OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper result = OB_Maintenance_EditServicePoint_Ctr.saveRequest( '', JSON.serialize( testNewData ), '' );
        System.assert( result.errorOccurred );
        System.assertEquals( Label.OB_ServerLogicFailed, result.errorMessage );
    }

    /*******************************************************************************
    Purpose: Test of saveRequest method, incorrect Account lookup on Service Point

    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Grzegorz Banach       21/08/2019   	    Created          NEXI-261
    ********************************************************************************/
    @isTest
    private static void saveRequestTestBadAccountId( )
    {
        Account testAccount = OB_TestDataFactory.getAccount( );
        insert testAccount;
        delete testAccount;

        Map<String, String> servicePointAsMap = new Map<String, String> {'NE__Account__c' => testAccount.Id};
        Map<String, Object> testNewData = new Map<String, Object> {'pv' => servicePointAsMap};
        OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper result = OB_Maintenance_EditServicePoint_Ctr.saveRequest( '', JSON.serialize( testNewData ), '' );
        System.assert( result.errorOccurred );
        System.assertEquals( Label.OB_ServerLogicFailed, result.errorMessage );
    }

    /*******************************************************************************
    Purpose: Test of saveRequest method, Service Point city is different than 'Livingo',
                 when Account Tipologia di Societa is 'Livingo'

    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Grzegorz Banach       21/08/2019   	    Created          NEXI-261
    ********************************************************************************/
    @isTest
    private static void saveRequestTestLivignoIllegalScenario( )
    {
        Account testAccount = OB_TestDataFactory.getAccount( );
        testAccount.NE__VAT__c = null;
        testAccount.OB_VAT_Not_Present__c = true;
        testAccount.OB_DescriptionVATNotPresent__c = OB_UtilityConstants.LIVIGNO;
        insert testAccount;

        Map<String, String> servicePointAsMap = new Map<String, String>
        {
                'NE__Account__c' => testAccount.Id,
                'NE__City__c' => 'CITY DIFFERENT FROM LIVIGNO'
        };
        Map<String, Object> testNewData = new Map<String, Object> {'pv' => servicePointAsMap};
        OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper result = OB_Maintenance_EditServicePoint_Ctr.saveRequest( '', JSON.serialize( testNewData ), '' );
        System.assert( result.errorOccurred );
        System.assertEquals( Label.OB_LIVIGNO_CHECK_ERROR, result.errorMessage );
    }

    /*******************************************************************************
    Purpose: Method tests OB_Maintenance_EditServicePoint_Ctr.saveDraft for existing success scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien        02/09/2019       Created     		 NEXI-294
    ********************************************************************************/
    @isTest
    private static void saveDraftSuccessTest( )
    {
        OB_LogRequest__c testLogRequest = OB_TestDataFactory.getLogRequest( );
        testLogRequest.OB_Save_as_Draft__c = false;
        insert testLogRequest;
        OB_Maintenance_EditServicePoint_Ctr.saveDraft( testLogRequest.Id );
        System.assert( [ SELECT OB_Save_as_Draft__c FROM OB_LogRequest__c WHERE Id = :testLogRequest.Id ].OB_Save_as_Draft__c );
    }

    /*******************************************************************************
    Purpose: Method tests OB_Maintenance_EditServicePoint_Ctr.saveDraft for catch exception scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien        02/09/2019       Created     		 NEXI-294
    ********************************************************************************/
    @isTest
    private static void saveDraftCatchTest( )
    {
        OB_Maintenance_EditServicePoint_Ctr.saveDraft( null );
        System.assert( true );
    }

    /*******************************************************************************
    Purpose: Method tests OB_Maintenance_EditServicePoint_Ctr.confirmUploadedDocumentsSetInAttesa for success scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien        02/09/2019       Created     		 NEXI-294
    ********************************************************************************/
    @isTest
    private static void confirmUploadedDocumentsSetInAttesaStatusTest( )
    {
        OB_LogRequest__c testLogRequest = OB_TestDataFactory.getLogRequest( );
        testLogRequest.OB_Status__c = System.Label.OB_MAINTENANCE_LOGREQUEST_STATUS_DRAFT;
        insert testLogRequest;
        OB_Maintenance_EditServicePoint_Ctr.confirmUploadedDocumentsSetInAttesaStatus( testLogRequest.Id );
        System.assertEquals( OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA, [ SELECT OB_Status__c FROM OB_LogRequest__c WHERE Id = :testLogRequest.Id ].OB_Status__c );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditServicePoint_Ctr.getRequest for success scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       03/09/2019         Created         NEXI-194
    ********************************************************************************/
    @isTest
    private static void getRequestSuccessTest( )
    {
        NE__Service_Point__c testServicePoint = prepareServicePoint( '7512' );

        String oldWrapperJSON = prepareServicePointWrapper( testServicePoint, '7512', '0047' );
        String newWrapperJSON = prepareServicePointWrapper( testServicePoint, '5631', '0002' );

        List<String> oldData = new List<String>();
        List<String> newData = new List<String>();
        oldData.add(oldWrapperJSON);
        newData.add(newWrapperJSON);

        testServicePoint = prepareServicePoint( '0012' );
        oldWrapperJSON = prepareServicePointWrapper( testServicePoint, '0012', '0047' );
        newWrapperJSON = prepareServicePointWrapper( testServicePoint, '5632', '0003' );

        oldData.add(oldWrapperJSON);
        newData.add(newWrapperJSON);

        Test.startTest( );
        List<OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper> result = OB_Maintenance_EditServicePoint_Ctr.getRequests( oldData, newData, '{}' );
        Test.stopTest( );

        System.assertEquals( '', result.get(0).errorMessage );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditServicePoint_Ctr.getRequest test for existing log request

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       03/09/2019         Created         NEXI-194
    ********************************************************************************/
    @isTest
    private static void getRequestCatchTest( )
    {
        NE__Service_Point__c testServicePoint = prepareServicePoint( '7512' );
        OB_LogRequest__c testLogRequest = OB_TestDataFactory.getLogRequest();
        testLogRequest.OB_ChangeServicePointData__c = true;
        testLogRequest.OB_AccountId__c = testServicePoint.NE__Account__c;
        insert testLogRequest;

        String oldWrapperJSON = prepareServicePointWrapper( testServicePoint, '7512', '0047' );
        String newWrapperJSON = prepareServicePointWrapper( testServicePoint, '5631', '0002' );

        List<String> oldData = new List<String>();
        List<String> newData = new List<String>();
        oldData.add(oldWrapperJSON);
        newData.add(newWrapperJSON);

        Test.startTest( );
        List<OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper> result = OB_Maintenance_EditServicePoint_Ctr.getRequests( oldData, newData, '{}' );
        Test.stopTest( );

        System.assertEquals('', result.get(0).errorMessage );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_EditServicePoint_Ctr.saveRequest - scenario where Location referent exists, but it's modified

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Grzegorz Banach         10/10/2019      Created         NEXI-361
    ********************************************************************************/

    @isTest
    private static void saveRequestContactsAlreadyExist( )
    {
        Account merchantAccount = OB_TestDataFactory.getAccount( );
        insert merchantAccount;

        NE__Service_Point__c testServicePoint = OB_TestDataFactory.getServicePoint( );
        testServicePoint.NE__Account__c = merchantAccount.Id;
        insert testServicePoint;

        Contact oldTechnicalReferent = new Contact( );
        oldTechnicalReferent.LastName = 'Test';
        Contact newTechnicalReferent = oldTechnicalReferent.clone( false, true );
        newTechnicalReferent.LastName = 'TestNew';
        Contact oldResponsabileAmministrativo = new Contact( );
        oldResponsabileAmministrativo.FirstName = 'Test';
        Contact newResponsabileAmministrativo = oldResponsabileAmministrativo.clone( false, true );

        OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper oldSpw = new OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper( );
        oldSpw.technicalReferent = oldTechnicalReferent;
        oldSpw.administrativeResponsible = oldResponsabileAmministrativo;
        oldSpw.pv = testServicePoint;
        OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper newSpw = new OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper( );
        newSpw.technicalReferent = newTechnicalReferent;
        newSpw.administrativeResponsible = newResponsabileAmministrativo;
        newSpw.pv = testServicePoint;


        String spOriginal = JSON.serialize( oldSpw );
        String spModded = JSON.serialize( newSpw );

        Test.startTest( );
        OB_Maintenance_EditServicePoint_Ctr.ServicePointWrapper result = OB_Maintenance_EditServicePoint_Ctr.saveRequest( spOriginal, spModded, '{}' );
        System.assert(!result.errorOccurred);

        Test.stopTest( );
    }
}