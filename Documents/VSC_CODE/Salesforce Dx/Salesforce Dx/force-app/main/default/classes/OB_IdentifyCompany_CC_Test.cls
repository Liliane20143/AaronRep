@isTest
public class OB_IdentifyCompany_CC_Test
{

    /*******************************************************************************
    Purpose:  Method tests getLegalFromValue

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing assertion
    ********************************************************************************/
    @isTest
    private static void getLegalFromValueTest( )
    {
       
        NE__Lov__c lov = new NE__Lov__c( NE__Type__c = 'LegalForm',
                NE__Sub_Type__c = 'TIPOLOGICHE',
                NE__Active__c = true );
        insert lov;

        Test.startTest( );
        Map<String, String> result = OB_IdentifyCompany_CC.getLegalFromValue( );
        Test.stopTest( );

        System.assert( !result.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests getCountryValue

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing assertion
    ********************************************************************************/
    @isTest
    private static void getCountryValueTest( )
    {
        NE__Lov__c lov = new NE__Lov__c( Name = 'country',
                NE__Sub_Type__c = 'TIPOLOGICHE',
                NE__Active__c = true );
        insert lov;

        Test.startTest( );
        Map<String, String> result = OB_IdentifyCompany_CC.getCountryValue( );
        Test.stopTest( );

        System.assert( !result.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests getShopSignTest

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing assertion
    ********************************************************************************/
    @isTest
    private static void getShopSignTest( )
    {
        NE__Service_Point__c testServicePoint = new NE__Service_Point__c( );
        insert testServicePoint;

        ExternalSourceMapping__c testESM = new ExternalSourceMapping__c( );
        testESM.OB_Service_Point_ID__c = testServicePoint.Id;
        testESM.OB_ShopSign__c = '0000';
        insert testESM;

        Test.startTest( );
        List<ExternalSourceMapping__c> result = OB_IdentifyCompany_CC.getShopSign( testServicePoint.Id );
        Test.stopTest( );

        System.assert( !result.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests getMccLovTest

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing assertion
    ********************************************************************************/
    @isTest
    private static void getMccLovTest( )
    {
        String MCCCodePv = 'test';
        NE__Lov__c lov = new NE__Lov__c( NE__Type__c = 'mcc',
                NE__Value2__c = MCCCodePv );
        insert lov;

        Test.startTest( );
        NE__Lov__c result = OB_IdentifyCompany_CC.getMccLov( MCCCodePv );
        Test.stopTest( );

        System.assertEquals( 'test', result.NE__Value2__c );
    }

    /*******************************************************************************
    Purpose:  Method tests getBankIdByUser

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing assertion
    1.2       Kinga Fornal        07/08/2019    Updated    changed OB_ABI__c of bankAccount
    ********************************************************************************/
    @isTest
    private static void getBankIdByUserTest( )
    {
        User portalAccountOwner = OB_TestDataFactory.getPortalAccountOwner( );
        insert portalAccountOwner;

        User testCommunityUser;
        System.runAs( portalAccountOwner )
        {
            Account bankAccount = OB_TestDataFactory.getBankAccount( );
            bankAccount.OB_ABI__c = '00000';
            insert bankAccount;

            Contact testContact = OB_TestDataFactory.getContact( bankAccount );
            insert testContact;

            testCommunityUser = OB_TestDataFactory.getCommunityUser( testContact );
            testCommunityUser.ProfileId = OB_TestDataFactory.getNexiPartnerUserProfile( ).Id;
            insert testCommunityUser;

            OB_Bank_Profile__c testBankProfile = OB_TestDataFactory.getBankProfile( bankAccount );
            testBankProfile.OB_Apm_Circuit__c = '';
            testBankProfile.OB_VAS__c = '';
            testBankProfile.OB_SettlementType__c = '';
            testBankProfile.OB_AccountHolder__c = true;
            testBankProfile.OB_Applicant_RAC_Code_SIA__c = 'Nexi';
            testBankProfile.OB_Terminal_Id_Generator__c = 'Nexi';
            testBankProfile.OB_NDG__c = true;
            testBankProfile.OB_Business_Model_Acquiring__c = 'Servicing';
            insert testBankProfile;
        }

        System.runAs( testCommunityUser )
        {
            Map<String, String> result = OB_IdentifyCompany_CC.getBankIdByUser( );
            System.assert( !result.isEmpty( ) );
        }
    }

    /*******************************************************************************
    Purpose:  Method tests listServicePoint

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing assertion
    ********************************************************************************/
    @isTest
    private static void listServicePoint( )
    {
        Account testAccount = OB_TestDataFactory.getAccount( );
        insert testAccount;
        NE__Service_Point__c testServicePoint = OB_TestDataFactory.getServicePoint( );
        testServicePoint.NE__Account__c = testAccount.Id;
        testServicePoint.Name = 'Test';
        testServicePoint.NE__Zip_Code__c = '12345';
        testServicePoint.NE__City__c = 'testCity';
        testServicePoint.NE__Street__c = 'testStreet';
        insert testServicePoint;
        Test.startTest( );
        List<NE__Service_Point__c> result = OB_IdentifyCompany_CC.listServicePoint( 'Test', '12345', 'testCity', 'testStreet', 'url', 'app', testAccount.Id, null );
        Test.stopTest( );

        System.assert( !result.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests listAcc

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing assertion
    ********************************************************************************/
    @isTest
    private static void listAccTest1( )
    {
        Account bankOwner = OB_TestDataFactory.getBankAccount( );
        insert bankOwner;
        Account testAccount = OB_TestDataFactory.getAccount( );
        insert testAccount;
        Test.startTest( );
        List<Account> result = OB_IdentifyCompany_CC.listAcc( testAccount.NE__Fiscal_code__c, 'aaaaa', testAccount.OB_Bank_owner__c );
        Test.stopTest( );

        System.assert( !result.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests listAcc

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing assertion
    ********************************************************************************/
    @isTest
    private static void listAccTest2( )
    {
        Account bankOwner = OB_TestDataFactory.getBankAccount( );
        insert bankOwner;
        Test.startTest( );
        List<Account> result = OB_IdentifyCompany_CC.listAcc( bankOwner.NE__Fiscal_code__c, '', bankOwner.Id ); // DD -- 06/12/2018
        Test.stopTest( );

        System.assert( !result.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests listAcc

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing assertion
    ********************************************************************************/
    @isTest
    private static void listAccTest3( )
    {
        Account bankOwner = OB_TestDataFactory.getBankAccount( );
        insert bankOwner;
        Test.startTest( );
        List<Account> result = OB_IdentifyCompany_CC.listAcc( '', 'aaa', bankOwner.Id );
        Test.stopTest( );

        System.assert( !result.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests getUserIdByUser

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing assertion
    ********************************************************************************/
    @isTest
    private static void getUserIdByUser( )
    {
        Test.startTest( );
        String result = OB_IdentifyCompany_CC.getUserIdByUser( );
        Test.stopTest( );

        System.assert( !String.isBlank( result ) );
    }

    /*******************************************************************************
    Purpose:  Method tests getEmployeesNumber

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing assertion
    ********************************************************************************/
    @isTest
    private static void getEmployeesNumberTest( )
    {
        Test.startTest( );
        Map<String, String> result = OB_IdentifyCompany_CC.getEmployeesNumber( );
        Test.stopTest( );

        System.assert( !result.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests checkNewServicePoint

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing assertion
    ********************************************************************************/
    @isTest
    private static void checkNewServicePointExistingSP( )
    {

        NE__Service_Point__c testServicePoint = OB_TestDataFactory.getServicePoint( );
        testServicePoint.NE__Street__c = 'Lepetit';
        testServicePoint.OB_MCC_Description__c = 'descr';
        testServicePoint.OB_Service_Point_Name__c = 'SPname';
        insert testServicePoint;
        Map<String, Object> objectDataMap = new Map<String, Object>( );
        objectDataMap.put( 'pv', testServicePoint );
        Account merchant = OB_TestDataFactory.getAccount( );
        insert merchant;
        Test.startTest( );
        Boolean result = OB_IdentifyCompany_CC.checkNewServicePoint( JSON.serialize( objectDataMap ), new List<NE__Service_Point__c>{testServicePoint}, merchant.Id );
        Test.stopTest( );

        System.assert( result );
    }

    /*******************************************************************************
    Purpose:  Method tests checkNewServicePoint

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing assertion
    ********************************************************************************/
    @isTest
    private static void checkNewServicePointNewSP( )
    {

        NE__Service_Point__c testServicePoint = OB_TestDataFactory.getServicePoint( );
        testServicePoint.NE__Street__c = 'Lepetit';
        testServicePoint.OB_MCC_Description__c = 'descr';
        testServicePoint.OB_Service_Point_Name__c = 'SPname';
        Map<String, Object> objectDataMap = new Map<String, Object>( );
        objectDataMap.put( 'pv', testServicePoint );
        Account merchant = OB_TestDataFactory.getAccount( );
        insert merchant;
        Test.startTest( );
        Boolean result = OB_IdentifyCompany_CC.checkNewServicePoint( JSON.serialize( objectDataMap ), new List<NE__Service_Point__c>( ), merchant.Id );
        Test.stopTest( );

        System.assert( !result );
    }

    /*******************************************************************************
    Purpose:  Method tests checkNewServicePoint

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing assertion
    ********************************************************************************/
    @isTest
    private static void checkNewServicePointNewSPFilledList( )
    {

        NE__Service_Point__c testServicePoint = OB_TestDataFactory.getServicePoint( );
        testServicePoint.NE__Street__c = 'Lepetit';
        testServicePoint.OB_MCC_Description__c = 'descr';
        Map<String, Object> objectDataMap = new Map<String, Object>( );
        objectDataMap.put( 'pv', testServicePoint );

        NE__Service_Point__c testSP = OB_TestDataFactory.getServicePoint( );
        testSP.NE__Street__c = 'Lepetit';
        testSP.OB_MCC_Description__c = 'descr';
        testSP.OB_Service_Point_Name__c = 'SPname';

        Account merchant = OB_TestDataFactory.getAccount( );
        insert merchant;
        Test.startTest( );
        Boolean result = OB_IdentifyCompany_CC.checkNewServicePoint( JSON.serialize( objectDataMap ), new List<NE__Service_Point__c>{testSP}, merchant.Id );
        Test.stopTest( );

        System.assert( !result );
    }

    /*******************************************************************************
    Purpose:  Method tests searchABIbyInputValue

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing assertion
    ********************************************************************************/
    @isTest
    private static void searchABIbyInputValueTest1( )
    {
        NE__Lov__c lov = new NE__Lov__c( Name = 'lovName' );
        insert lov;
        Test.startTest( );
        String result = OB_IdentifyCompany_CC.searchABIbyInputValue( lov.Name );
        Test.stopTest( );

        System.assert( !String.isBlank( result ) );
    }

    /*******************************************************************************
    Purpose:  Method tests searchABIbyInputValue

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing assertion
    ********************************************************************************/
    @isTest
    private static void searchABIbyInputValueTest2( )
    {
        NE__Lov__c lov = new NE__Lov__c( Name = 'lovName' );
        insert lov;
        Test.startTest( );
        String result = OB_IdentifyCompany_CC.searchABIbyInputValue( 'lovNamem' );
        Test.stopTest( );

        System.assert( result == null );
    }

    /*******************************************************************************
    Purpose:  Method tests getMccDescription

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing assertion
    ********************************************************************************/
    @isTest
    private static void getMccDescriptionTest1( )
    {
        NE__Lov__c lov = new NE__Lov__c( NE__Type__c = 'MCC', NE__Active__c = true, NE__value2__c = 'aaaaa' );
        insert lov;
        Test.startTest( );
        String result = OB_IdentifyCompany_CC.getMccDescription( lov.NE__value2__c );
        Test.stopTest( );

        System.assert( !String.isBlank( result ) );
    }

    /*******************************************************************************
    Purpose:  Method tests getMccDescription

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing assertion
    ********************************************************************************/
    @isTest
    private static void getMccDescriptionTest2( )
    {
        NE__Lov__c lov = new NE__Lov__c( NE__Type__c = 'MCC', NE__Active__c = true, NE__value2__c = 'aaaaa' );
        insert lov;
        Test.startTest( );
        String result = OB_IdentifyCompany_CC.getMccDescription( 'bbbbb' );
        Test.stopTest( );

        System.assert( result == null );
    }

    /*******************************************************************************
    Purpose:  Method tests getAccountById

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing assertion
    ********************************************************************************/
    @isTest
    private static void getAccountByIdTest( )
    {
        Account testAccount = OB_TestDataFactory.getAccount( );
        insert testAccount;
        Test.startTest( );
        Account result = OB_IdentifyCompany_CC.getAccountById( testAccount.Id );
        Test.stopTest( );

        System.assert( result != null );
    }

    /*******************************************************************************
    Purpose:  Method tests searchCABbyInputValue

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing assertion
    ********************************************************************************/
    @isTest
    private static void searchCABbyInputValueTest1( )
    {
        NE__Lov__c lov = new NE__Lov__c( NE__Active__c = true, NE__Sub_Type__c = 'TIPOLOGICHE', NE__Type__c = 'CAB', Name = 'lovName' );
        insert lov;

        System.assert( OB_IdentifyCompany_CC.searchCABbyInputValue( lov.Name, '' ) != null );
    }

    /*******************************************************************************
    Purpose:  Method tests searchCABbyInputValue

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing assertion
    ********************************************************************************/
    @isTest
    private static void searchCABbyInputValueTest2( )
    {
        NE__Lov__c lov = new NE__Lov__c( NE__Active__c = true, NE__Sub_Type__c = 'TIPOLOGICHE', NE__Type__c = 'CAB', Name = 'lovName', Ne__value1__c = 'lovName2' );
        insert lov;

        System.assert( OB_IdentifyCompany_CC.searchCABbyInputValue( lov.Name, lov.Ne__value1__c ) != null );
    }

    /*******************************************************************************
    Purpose:  Method tests getBankProfileByABI

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing assertion
    ********************************************************************************/
    @isTest
    private static void getBankProfileByABI( )
    {
        Account bankAccount = OB_TestDataFactory.getBankAccount( );
        bankAccount.OB_ABI__c = '00000';
        insert bankAccount;
        OB_Bank_Profile__c bankProfile = OB_TestDataFactory.getBankProfile( bankAccount );
        bankProfile.OB_Business_Model_Acquiring__c = 'Diretto';
        insert bankProfile;


        Test.startTest( );
        Map<String, String> result = OB_IdentifyCompany_CC.getBankProfileByABI( bankAccount.OB_ABI__c );
        Test.stopTest( );

        System.assert( !result.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests getServicePointTypologyValues_SP

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing assertion
    ********************************************************************************/
    @isTest
    private static void getServicePointTypologyValues_SPTest( )
    {
        Test.startTest( );
        Map<String, String> result = OB_IdentifyCompany_CC.getServicePointTypologyValues_SP( );
        Test.stopTest( );

        System.assert( !result.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests getOrderHeaderByAccountId

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing assertion
    ********************************************************************************/
    @isTest
    private static void getOrderHeaderByAccountIdTest( )
    {

        String merchantRecordTypeId = [ SELECT Id FROM RecordType WHERE Name = 'merchant' AND SobjectType = 'Account' LIMIT 1 ].Id;
        Account merchant = new Account( Name = 'name', RecordTypeId = merchantRecordTypeId, OB_Employees_Number__c = 'Minore di 10', NE__Fiscal_code__c = 'AAAAAA11A11A111A', OB_VAT_Not_Present__c = true, OB_DescriptionVATNotPresent__c = 'desc' );
        insert merchant;
        NE__Order_Header__c oh = new NE__Order_Header__c( );
        oh.NE__OrderStatus__c = 'Pending';
        oh.NE__AccountId__c = merchant.Id;
        insert oh; // DD --- 06/12/2018
        Test.startTest( );
        Boolean result = OB_IdentifyCompany_CC.getOrderHeaderByAccountId( merchant.Id );
        Test.stopTest( );

        System.assert( result );
    }

    /*******************************************************************************
    Purpose:  Method tests getSourceSystem

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing assertion
    ********************************************************************************/
    @isTest
    private static void getSourceSystemTest1( )
    {
        String merchantRecordTypeId = [ SELECT Id FROM RecordType WHERE Name = 'merchant' AND SobjectType = 'Account' LIMIT 1 ].Id;
        Account merchant = new Account( Name = 'name', RecordTypeId = merchantRecordTypeId, OB_Employees_Number__c = 'Minore di 10', NE__Fiscal_code__c = 'AAAAAA11A11A111A', OB_VAT_Not_Present__c = true, OB_DescriptionVATNotPresent__c = 'desc' );
        insert merchant;
        ExternalSourceMapping__c esm = new ExternalSourceMapping__c( );
        esm.OB_Merchant_ID__c = merchant.Id;
        esm.OB_Source__c = 'source';
        insert esm;
        Test.startTest( );
        List<ExternalSourceMapping__c> result = OB_IdentifyCompany_CC.getSourceSystem( merchant.Id );
        Test.stopTest( );

        System.assert( !result.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests getSourceSystem

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing assertion
    ********************************************************************************/
    @isTest
    private static void getSourceSystemTest2( )
    {
        String merchantId = '';
        Test.startTest( );
        List<ExternalSourceMapping__c> result = OB_IdentifyCompany_CC.getSourceSystem( merchantId );
        Test.stopTest( );

        System.assert( result.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests getExternalCode

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing assertion
    ********************************************************************************/
    @isTest
    private static void getExternalCodeTest1( )
    {
        String merchantRecordTypeId = [ SELECT Id FROM RecordType WHERE Name = 'merchant' AND SobjectType = 'Account' LIMIT 1 ].Id;
        Account merchant = new Account( Name = 'name', RecordTypeId = merchantRecordTypeId, OB_Employees_Number__c = 'Minore di 10', NE__Fiscal_code__c = 'AAAAAA11A11A111A', OB_VAT_Not_Present__c = true, OB_DescriptionVATNotPresent__c = 'desc' );
        insert merchant;
        String merchantId = merchant.Id;
        List<ExternalSourceMapping__c> otherCodes = new List<ExternalSourceMapping__c>( );
        ExternalSourceMapping__c esm = new ExternalSourceMapping__c( );
        esm.OB_Source__c = 'Monetica';
        esm.OB_ToBeChecked__c = false;
        esm.OB_Merchant_ID__c = merchantId;
        insert esm;
        otherCodes.add( new ExternalSourceMapping__c( OB_Source__c = 'Monetica', OB_CustomerCodeClientCode__c = 'cccc' ) );
        String merchantCategoryCode = 'MCC';
        String postalCode = 'PC';
        Boolean isEcommerce = true;
        Test.startTest( );
        String result = OB_IdentifyCompany_CC.getExternalCode( merchantId, otherCodes, merchantCategoryCode, postalCode, isEcommerce );
        Test.stopTest( );

        System.assert( !String.isBlank( result ) );
    }

    /*******************************************************************************
    Purpose:  Method tests getExternalCode

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing assertion
    ********************************************************************************/
    @isTest
    private static void getExternalCodeTest2( )
    {
        String merchantRecordTypeId = [ SELECT Id FROM RecordType WHERE Name = 'merchant' AND SobjectType = 'Account' LIMIT 1 ].Id;
        Account merchant = new Account( Name = 'name', RecordTypeId = merchantRecordTypeId, OB_Employees_Number__c = 'Minore di 10', NE__Fiscal_code__c = 'AAAAAA11A11A111A', OB_VAT_Not_Present__c = true, OB_DescriptionVATNotPresent__c = 'desc' );
        insert merchant;
        String merchantId = merchant.Id;
        List<ExternalSourceMapping__c> otherCodes = new List<ExternalSourceMapping__c>( );
        ExternalSourceMapping__c esm = new ExternalSourceMapping__c( );
        esm.OB_Source__c = 'NoMonetica';
        esm.OB_ToBeChecked__c = false;
        esm.OB_Merchant_ID__c = merchantId;
        insert esm;
        otherCodes.add( new ExternalSourceMapping__c( OB_Source__c = 'NoMonetica', OB_CustomerCodeClientCode__c = 'cccc' ) );
        String merchantCategoryCode = 'MCC';
        String postalCode = 'PC';
        Boolean isEcommerce = true;
        Test.startTest( );
        String result = OB_IdentifyCompany_CC.getExternalCode( merchantId, otherCodes, merchantCategoryCode, postalCode, isEcommerce );
        Test.stopTest( );

        System.assert( !String.isBlank( result ) );
    }

    /*******************************************************************************
    Purpose:  Method tests getExternalCode

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing assertion
    ********************************************************************************/
    @isTest
    private static void getOrderHeaderFromCodTest( )
    {
        String merchantRecordTypeId = [ SELECT Id FROM RecordType WHERE Name = 'merchant' AND SobjectType = 'Account' LIMIT 1 ].Id;
        Account merchant = new Account( Name = 'name', RecordTypeId = merchantRecordTypeId, OB_Employees_Number__c = 'Minore di 10', NE__Fiscal_code__c = 'AAAAAA11A11A111A', OB_VAT_Not_Present__c = true, OB_DescriptionVATNotPresent__c = 'desc' );
        insert merchant;
        NE__Order__c order = new NE__Order__c( );
        insert order;
        List<String> code = new List<String> {'123'};
        NE__OrderItem__c oi1 = new NE__OrderItem__c( );
        oi1.NE__Account__c = merchant.Id;
        oi1.OB_Processor__c = 'EQUENS';
        oi1.NE__Status__c = 'Pending';
        oi1.OB_CompanyCode__c = '123';
        oi1.NE__OrderId__c = order.Id;
        oi1.NE__Qty__c = 1;
        insert oi1;

        Test.startTest( );
        Boolean result = OB_IdentifyCompany_CC.getOrderHeaderFromCod( merchant.Id, code );
        Test.stopTest( );

        System.assert( result );
    }

    /*******************************************************************************
    Purpose:  Method tests formalCheckOnOldData

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing test
    ********************************************************************************/
    @isTest
    private static void getPendingOrderFromCodeEqualTest1( )
    {
        String merchantRecordTypeId = [ SELECT Id FROM RecordType WHERE Name = 'merchant' AND SobjectType = 'Account' LIMIT 1 ].Id;
        Account merchant = new Account( Name = 'name', RecordTypeId = merchantRecordTypeId, OB_Employees_Number__c = 'Minore di 10', NE__Fiscal_code__c = 'AAAAAA11A11A111A', OB_VAT_Not_Present__c = true, OB_DescriptionVATNotPresent__c = 'desc' );
        insert merchant;
        NE__Order__c o1 = new NE__Order__c( NE__AccountId__c = merchant.Id );
        insert o1;
        NE__OrderItem__c oi1 = new NE__OrderItem__c( NE__Account__c = merchant.Id, OB_GT__c = 'MONETICA', OB_CustomerCode__c = '425080', NE__Status__c = 'Pending', NE__Qty__c = 1, NE__OrderId__c = o1.Id );
        insert oi1;
        NE__OrderItem__c oi2 = new NE__OrderItem__c( NE__Account__c = merchant.Id, OB_Processor__c = 'EQUENS', OB_CustomerCode__c = '425081', NE__Status__c = 'Pending', NE__Qty__c = 1, NE__OrderId__c = o1.Id );
        insert oi2;
        asset a = new Asset ( Name = 'Product Type A', AccountId = merchant.Id, OB_GT__c = 'MONETICA', OB_CustomerCode__c = '425080' );
        insert a;
        asset a2 = new Asset ( Name = 'Product Type B', AccountId = merchant.Id, OB_Processor__c = 'EQUENS', OB_CustomerCode__c = '425081' );
        insert a2;
        asset a3 = new Asset ( Name = 'Product Type C', AccountId = merchant.Id, OB_GT__c = 'MONETICA', OB_CustomerCode__c = '425082' );
        insert a3;

        Map<String, Object> mapCode = ( Map<String, Object> ) JSON.deserializeUntyped( '{"nexiSystem":{"":""},"MONETICA":{"425080":{"425080":{"OB_CustomerCodeClientCode__c":"425080","OB_Source__c":"MONETICA"}},"425081":{"425081":{"OB_CustomerCodeClientCode__c":"425081","OB_Source__c":"EQUENS"}}}}' );
        Map<String, Map<String, NE__OrderItem__c>> result = OB_IdentifyCompany_CC.getPendingOrderFromCode( merchant.Id, 'equal', mapCode );
        System.assert( !result.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests formalCheckOnOldData

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing test
    ********************************************************************************/
    @isTest
    private static void getPendingOrderFromCodeEqualTest2( )
    {
        String merchantRecordTypeId = [ SELECT Id FROM RecordType WHERE Name = 'merchant' AND SobjectType = 'Account' LIMIT 1 ].Id;
        Account merchant = new Account( Name = 'name', RecordTypeId = merchantRecordTypeId, OB_Employees_Number__c = 'Minore di 10', NE__Fiscal_code__c = 'AAAAAA11A11A111A', OB_VAT_Not_Present__c = true, OB_DescriptionVATNotPresent__c = 'desc' );
        insert merchant;
        NE__Order__c o1 = new NE__Order__c( NE__AccountId__c = merchant.Id );
        insert o1;
        NE__OrderItem__c oi1 = new NE__OrderItem__c( NE__Account__c = merchant.Id, OB_Processor__c = 'EQUENS', OB_CustomerCode__c = '425081', NE__Status__c = 'Pending', NE__Qty__c = 1, NE__OrderId__c = o1.Id );
        insert oi1;
        asset a1 = new Asset ( Name = 'Product Type B', AccountId = merchant.Id, OB_GT__c = 'MONETICA', OB_CustomerCode__c = '425080' );
        insert a1;

        Map<String, Object> mapCode = ( Map<String, Object> ) JSON.deserializeUntyped( '{"EQUENS":{"425081":{"425081":{"OB_CustomerCodeClientCode__c":"425081","OB_Source__c":"EQUENS"}}}}' );
        Map<String, Map<String, NE__OrderItem__c>> result = OB_IdentifyCompany_CC.getPendingOrderFromCode( merchant.Id, 'equal', mapCode );
        System.assert( result.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests formalCheckOnOldData

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing test
    ********************************************************************************/
    @isTest
    private static void getPendingOrderFromCodeDifferentTest( )
    {
        String merchantRecordTypeId = [ SELECT Id FROM RecordType WHERE Name = 'merchant' AND SobjectType = 'Account' LIMIT 1 ].Id;
        Account merchant = new Account( Name = 'name', RecordTypeId = merchantRecordTypeId, OB_Employees_Number__c = 'Minore di 10', NE__Fiscal_code__c = 'AAAAAA11A11A111A', OB_VAT_Not_Present__c = true, OB_DescriptionVATNotPresent__c = 'desc' );
        insert merchant;
        Account externalAcc = new Account( Name = 'name ext', RecordTypeId = merchantRecordTypeId, OB_Employees_Number__c = 'Minore di 10', NE__Fiscal_code__c = 'BBBBBB11A11A111A', OB_VAT_Not_Present__c = true, OB_DescriptionVATNotPresent__c = 'desc' );
        insert externalAcc;
        NE__Order__c o1 = new NE__Order__c( NE__AccountId__c = merchant.Id );
        insert o1;
        NE__OrderItem__c oi1 = new NE__OrderItem__c( NE__Account__c = merchant.Id, OB_Processor__c = 'EQUENS', OB_CustomerCode__c = '425081', NE__Status__c = 'Pending', NE__Qty__c = 1, NE__OrderId__c = o1.Id );
        insert oi1;
        ExternalSourceMapping__c externalMapping = new ExternalSourceMapping__c( OB_Merchant_ID__c = externalAcc.Id, OB_CustomerCodeClientCode__c = '425081', OB_Source__c = 'EQUENS' );
        insert externalMapping;

        Map<String, Object> mapCode = ( Map<String, Object> ) JSON.deserializeUntyped( '{"EQUENS":{"425081":{"425081":{"OB_CustomerCodeClientCode__c":"425081","OB_Source__c":"EQUENS"}}}}' );
        Map<String, Map<String, NE__OrderItem__c>> result = OB_IdentifyCompany_CC.getPendingOrderFromCode( merchant.Id, 'different', mapCode );
        System.assert( !result.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests formalCheckOnOldData

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing test
    ********************************************************************************/
    @isTest
    private static void checkOtherMerchantByCodTest( )
    {

        String merchantRecordTypeId = [ SELECT Id FROM RecordType WHERE Name = 'merchant' AND SobjectType = 'Account' LIMIT 1 ].Id;
        Account externalAcc = new Account( Name = 'name ext', RecordTypeId = merchantRecordTypeId, OB_Employees_Number__c = 'Minore di 10', NE__Fiscal_code__c = 'AAAAAA11A11A111A', OB_VAT_Not_Present__c = true, OB_DescriptionVATNotPresent__c = 'desc' );
        insert externalAcc;
        NE__Order__c o1 = new NE__Order__c( NE__AccountId__c = externalAcc.Id );
        insert o1;
        NE__OrderItem__c oi1 = new NE__OrderItem__c( NE__Account__c = externalAcc.Id, OB_Processor__c = 'EQUENS', OB_CustomerCode__c = '425081', NE__Status__c = 'Pending', NE__Qty__c = 1, NE__OrderId__c = o1.Id );
        insert oi1;
        ExternalSourceMapping__c externalMapping = new ExternalSourceMapping__c( OB_Merchant_ID__c = externalAcc.Id, OB_CustomerCodeClientCode__c = '425081', OB_Source__c = 'EQUENS' );
        insert externalMapping;
        List<String> codes = new List<String> {'425081'};
        Map<String, Object> mapCode = ( Map<String, Object> ) JSON.deserializeUntyped( '{"EQUENS":{"425081":{"425081":{"OB_CustomerCodeClientCode__c":"425081","OB_Source__c":"EQUENS"}}}}' );
        List<ExternalSourceMapping__c> result = OB_IdentifyCompany_CC.checkOtherMerchantByCod( codes, externalAcc.Id );

        System.assert( !result.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests formalCheckOnOldData

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing test
    ********************************************************************************/
    @isTest
    private static void getTimeOutTest( )
    {
        OB_Integration_Configuration__c integrationConf = new OB_Integration_Configuration__c( Name = 'DEV1', OB_Client_ID__c = '631edaf5-d79a-43b8-8753-1dd64e8e210f', OB_Timeout_Continuation__c = '10' );
        insert integrationConf;
        Integer result = OB_IdentifyCompany_CC.getTimeOut( );

        System.assert( result != null );
    }

    /*******************************************************************************
    Purpose:  Method tests formalCheckOnOldData

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing test
    ********************************************************************************/
    @isTest
    private static void getretrieveMerchantTest( )
    {
        String fiscalCode = '';
        String vatCod = '';
        Account testAccount = OB_TestDataFactory.getAccount( );
        insert testAccount;
        Test.startTest( );
        Object result = OB_IdentifyCompany_CC.getretrieveMerchant( fiscalCode, vatCod );
        Test.stopTest( );

        System.assert( result == null );
    }

    /*
    *@author antonio.vatrano <antonio.vatrano@accenture.com>
    *@date 17/06/2019
    *@description Method returns  List<NE__Service_Point__c> filtred for app url and account
    *@params string app, String Url, String AccountId
    *@return  List<NE__Service_Point__c>
    */
    @isTest
    public static void filterForUrlAndApp_Test( )
    {
        String url = 'www.test.it';
        String app = 'applicationTest' ;

        Account acc = OB_TestDataFactory.getAccount( );
        insert acc;
        NE__Service_Point__c sp = OB_TestDataFactory.getServicePoint( );
        sp.name = 'TESTSERVICEPOINT'; //francesca.ribezzi 24/09/19 changing sp name 
        insert sp;
        Asset ast = OB_TestDataFactory.getAsset( );
        ast.NE__Service_Point__c = sp.id;
        ast.AccountId = acc.id;
        insert ast;
        NE__AssetItemAttribute__c astAttAPP = OB_TestDataFactory.getAssetItemAttribute( ast.id );
        astAttAPP.name = 'APP';
        astAttAPP.NE__Value__c = app;
        insert astAttAPP;
        NE__AssetItemAttribute__c astAttURL = OB_TestDataFactory.getAssetItemAttribute( ast.id );
        astAttURL.name = 'URL';
        astAttURL.NE__Value__c = url;
        insert astAttURL;
        List<NE__Service_Point__c> listSp = OB_IdentifyCompany_CC.filterForUrlAndApp( url, app, acc.id );
        List<NE__Service_Point__c> listSp2 = new List<NE__Service_Point__c>( );
        listSp2.add( sp );

        System.assertEquals( listSp2.get( 0 ).name, listSp.get( 0 ).name );
    }

    /*
    *@author antonio.vatrano <antonio.vatrano@accenture.com>
    *@date 17/06/2019
    *@description Method void, update a merchant
    *@params -
    *@return void
    */
    @isTest
    public static void updateMerchantCodes3_Test( )
    {
        Account merchant = OB_TestDataFactory.getAccount( );
        Account merchant2 = OB_TestDataFactory.getAccount( );
        Account merchant3 = OB_TestDataFactory.getAccount( );
        Account externalAcc = OB_TestDataFactory.getAccount( );
        insert merchant;
        insert merchant2;
        insert merchant3;
        insert externalAcc;
        NE__Order__c o1 = OB_TestDataFactory.getOrder( );
        o1.NE__AccountId__c = merchant2.id;
        insert o1;
        NE__OrderItem__c oi1 = OB_TestDataFactory.getOrderItem( o1.id );
        oi1.NE__Account__c = merchant2.id;
        oi1.OB_GT__c = 'MONETICA';
        oi1.OB_CustomerCode__c = '425080';
        oi1.NE__Status__c = 'Pending';
        insert oi1;
        Asset ast = OB_TestDataFactory.getAsset( );
        ast.OB_GT__c = 'MONETICA';
        ast.OB_CustomerCode__c = '425080';
        insert ast;
        NE__Service_Point__c sp1 = OB_TestDataFactory.getServicePoint( );
        sp1.NE__Account__c = merchant.id;
        insert sp1;
        ExternalSourceMapping__c externalMapping1 = new ExternalSourceMapping__c( OB_Merchant_ID__c = externalAcc.Id, OB_CustomerCodeClientCode__c = '425080', OB_Source__c = 'MONETICA' );
        insert externalMapping1;
        ExternalSourceMapping__c externalMapping2 = new ExternalSourceMapping__c( OB_CustomerCodeClientCode__c = '425080', OB_Source__c = 'MONETICA', OB_Service_Point_ID__c = sp1.id );
        insert externalMapping2;
        NE__Lov__c lov1 = OB_TestDataFactory.getLov( );
        lov1.NE__Sub_Type__c = 'TIPOLOGICHE';
        lov1.NE__Type__c = 'SUBMIT';
        lov1.Name = 'OB_InternationalSettlementMethod__c';
        insert lov1;
        String extMappingId = String.valueOf( externalMapping1.id );
        Map<String, Object> MIPAndSfdcArray = ( Map<String, Object> ) JSON.deserializeUntyped( '{"MONETICA":{"425080":{"Id":"","Name":"ESM-0000000846","OB_Merchant_ID__c":"","OB_CustomerCodeClientCode__c":"425080","OB_Source__c":"MONETICA","OB_Pricing__c":"STANDARD", "OB_ReportType__c":"ALLA_SOCIETA_CUMULATIVO"}}}' );
        Map<String, Object> sfdcOnlyArray = ( Map<String, Object> ) JSON.deserializeUntyped( '{"MONETICA":{"425080":{"Id":"' + extMappingId + '","Name":"ESM-0000000846","OB_Merchant_ID__c":"","OB_CustomerCodeClientCode__c":"425080","OB_Source__c":"MONETICA", "OB_ReportType__c":"ALLA_SOCIETA_CUMULATIVO"}}}' );
        Map<String, Object> MIPOnlyArray = ( Map<String, Object> ) JSON.deserializeUntyped( '{"EQUENS":{"009587171":{"009587171":{"OB_CustomerCodeClientCode__c":"009587171","OB_Source__c":"EQUENS","OB_Start_Date__c":"2010-10-01","OB_Pricing__c":"STANDARD","OB_ReportType__c":"ALLA_SOCIETA_CUMULATIVO"}}},"MONETICA":{"425080":{"425080":{"OB_CustomerCodeClientCode__c":"425080","OB_Source__c":"MONETICA"}}}}' );

        List<ExternalSourceMapping__c> result = OB_IdentifyCompany_CC.updateMerchantCodes( String.valueOf( merchant.Id ), MIPAndSfdcArray, sfdcOnlyArray, MIPOnlyArray );
        System.assert( !result.isEmpty( ) );
    }

    /*
    *@author antonio.vatrano <antonio.vatrano@accenture.com>
    *@date 17/06/2019
    *@description Method returns information about current user
    *@params -
    *@return  userInfoWrapper
    */
    @isTest
    public static void getUserInformation_test( )
    {
        User us1 = getCommunityUserWithRole(); //NEXI, Kinga Fornal, kinga.fornal@accenture.com, 07.08.2019
        System.runAs( us1 )
        {
            Object wrap = OB_IdentifyCompany_CC.getUserInformation( );
            String jsonWrap = JSON.serialize( wrap );
            //NEXI, Kinga Fornal, kinga.fornal@accenture.com, 07.08.2019 START
            String assert = '{"isPartner":true,"isOperation":false,"hasError":null,"CABnature":null,"CAB":["12345"],"bankProfileObject":{"attributes":{"type":"OB_Bank_Profile__c"}},"bankProfile":{},"bankOwner":null,"actualBank":null,"ABI":"03138"}';
            //NEXI, Kinga Fornal, kinga.fornal@accenture.com, 07.08.2019 STOP
            System.assertEquals( assert, jsonWrap );
        }
    }

    /*
    *@author antonio.vatrano <antonio.vatrano@accenture.com>
    *@date 17/06/2019
    *@description Method returns information about lov
    *@params String id of lov
    *@return  NE__lov__c
    */
    @isTest
    public static void getMccLovL2_Test( )
    {
        NE__Lov__c lovToInsert = OB_TestDataFactory.getLov( );
        lovToInsert.NE__Type__c = 'mcc';
        insert lovToInsert;
        NE__lov__c lov = OB_IdentifyCompany_CC.getMccLovL2( lovToInsert.id );
        System.assertEquals( 'mcc', lov.NE__Type__c );
    }

    /*******************************************************************************
    Purpose:  Method tests formalCheckOnSameMerchant

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing test
    ********************************************************************************/
    @isTest
    private static void formalCheckOnSameMerchant( )
    {
        Account testAccount = OB_TestDataFactory.getAccount( );
        insert testAccount;

        NE__Service_Point__c testServicePoint = OB_TestDataFactory.getServicePoint( );
        testServicePoint.NE__Account__c = testAccount.Id;
        insert testServicePoint;

        Asset testAsset = OB_TestDataFactory.getAsset( );
        testAsset.AccountId = testAccount.Id;
        testAsset.NE__Service_Point__c = testServicePoint.Id;
        insert testAsset;

        OB_IdentifyCompany_CC.MerchantFromAssetWrapper result = OB_IdentifyCompany_CC.formalCheckOnSameMerchant( testAsset.Id );
        System.assert( result != null );
    }

    /*******************************************************************************
    Purpose:  Method tests formalCheckOnOldData

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing test
    ********************************************************************************/
    @isTest
    private static void formalCheckOnOldData( )
    {
        OB_IdentifyCompany_CC.MerchantFromAssetWrapper objectInfo = new OB_IdentifyCompany_CC.MerchantFromAssetWrapper( );

        Map<String, Boolean> result = OB_IdentifyCompany_CC.formalCheckOnOldData( '123', '123', JSON.serialize( objectInfo ), 'test1' );
        System.assert( !result.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests updateAssetMerchantTakeOver

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Joanna Mielczarek   05/08/2019    Updated    added missing test
    ********************************************************************************/
    @isTest
    private static void updateAssetMerchantTakeOver( )
    {
        Asset testAsset = OB_TestDataFactory.getAsset( );
        insert testAsset;
        OB_IdentifyCompany_CC.updateAssetMerchantTakeOver( testAsset );

        List<Asset> assets = [ SELECT OB_MerchantTakeover__c FROM Asset ];
        System.assert( assets.get( 0 ).OB_MerchantTakeover__c );
    }

    /*******************************************************************************
    Purpose:  Method tests get Community User as a Portal Account Owner

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       Kinga Fornal        07/08/2019    Created    -
    ********************************************************************************/
    private static User getCommunityUserWithRole( )
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
    /*
    * Author : Giovanni Spinelli
    * Date : 27/09/2019
    * Description : test method for OB_IdentifyCompany_CC.retrieveAutomaticSp
    */
    @isTest
    public static void retrieveAutomaticSp_Test(){
        NE__Service_Point__c sp = OB_TestDataFactory.getServicePoint();
        insert sp; 
        List<NE__Service_Point__c> spList1 = new List<NE__Service_Point__c>();
        spList1.add( sp );
        Test.startTest();
        List<NE__Service_Point__c> splist = OB_IdentifyCompany_CC.retrieveAutomaticSp(sp.id);
        System.assertEquals( (spList1.get(0).name).toUpperCase() , splist.get(0).name ); 
        Test.stopTest(); 
        
    }
    /*
    * Author : Giovanni Spinelli
    * Date : 27/09/2019
    * Description : test method for OB_IdentifyCompany_CC.listAcc
    *               scenario no banck account
    */
    @isTest
    public static void listAccTest_noNexiAccount(){

        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bank').getRecordTypeId();
        Account acc = new Account(Name = 'acc', OB_ABI__c = '00000', RecordTypeId = recordTypeId, OB_VAT_Not_Present__c=false, OB_Employees_Number__c = 'Minore di 10', NE__VAT__c='05218600962');
        insert acc;
        
        Account testAcc = OB_TestDataFactory.getAccount();
        insert testAcc;
        Test.startTest();
        List<Account> actualList = OB_IdentifyCompany_CC.listAcc('AAAAAA11A11A111A', '01234567890', '');
        System.assertEquals( actualList.size() , 1 );
        Test.stopTest();
    }
     /*******************************************************************************
    Purpose:  Method tests getBankProfileByABI
    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       gianluigi.virga      28/10/2019    Craeted    
    ********************************************************************************/
    @isTest
    private static void getBankProfileByABI_Test( )
    {
        User portalAccountOwner = OB_TestDataFactory.getPortalAccountOwner( );
        insert portalAccountOwner;
        User testCommunityUser;
        System.runAs( portalAccountOwner )
        {
            Account bankAccount = OB_TestDataFactory.getBankAccount( );
            bankAccount.OB_ABI__c = '00000';
            insert bankAccount;
            Contact testContact = OB_TestDataFactory.getContact( bankAccount );
            insert testContact;
            testCommunityUser = OB_TestDataFactory.getCommunityUser( testContact );
            testCommunityUser.ProfileId = OB_TestDataFactory.getNexiPartnerUserProfile( ).Id;
            insert testCommunityUser;
        }
        System.runAs( testCommunityUser )
        {
            
            Test.startTest( );
            Map<String, String> result = OB_IdentifyCompany_CC.getBankProfileByABI( '' );
            Test.stopTest( );
            System.assert( result.isEmpty( ) );
        }
    }
}