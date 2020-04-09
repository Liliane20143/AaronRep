/**************************************************************
* Date Created       : 20/11/2018  
* Created by         : Doris Tatiana
* Class name to test : OB_MandatoryFormalCheck
***************************************************************
*/

@isTest
public with sharing class OB_MandatoryFormalCheck_Test
{

    /*******************************************************************************
    Purpose:  Method prepares data to 'operationalData' and 'servicePoint' steps

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0			Doris Tatiana			 20/11/2018		  Created		  -
    2.0        Joanna Mielczarek        24/04/2019      Updated         removed annotation, added fields to account
   ********************************************************************************/
    private static Map<String, Object> setupData( )
    {
        Account testAccount = OB_TestDataFactory.getAccount();
        testAccount.OB_VAT_Not_Present__c = false;
        insert testAccount;

        NE__Service_Point__c sServicePoint = new NE__Service_Point__c ( Name = 'test', NE__Account__c = testAccount.Id );
        insert sServicePoint;

        String testJSON =
                '{"pv":{"NE__Street__c":"VIAIVNOVEMBRE","OB_AlternativeAddress__c":"","OB_Opening_Monday_Afternoon__c":true,' +
                        '"OB_Fax_Number__c":"","OB_PEC__c":"","OB_Start_Seasonal__c":"","OB_Opening_Tuesday_Morning__c":true,"OB_Opening_Thursday_Afternoon__c":true,' +
                        '"Name":"insegna","OB_Opening_Wednesday_Morning__c":true,"OB_Opening_Wednesday_Afternoon__c":true,"OB_Opening_Thursday_Morning__c":true,' +
                        '"OB_Opening_Friday_Afternoon__c":true,"OB_Email__c":"email@emai.tu","OB_Workshift__c":false,"RecordTypeId":"","OB_Address_Hamlet__c":"",' +
                        '"NE__City__c":"Assago","OB_Opening_Monday_Morning__c":true,"OB_Opening_Saturday_Morning__c":true,"OB_Phone_Number__c":"1234567890",' +
                        '"OB_Opening_Tuesday_Afternoon__c":true,"OB_Privacy_C4__c":false,"OB_Annual_Negotiated__c":"","OB_Privacy_C3__c":false,' +
                        '"OB_BypassValidation__c":false,"OB_Street_Number__c":"4","OB_Opening_Friday_Morning__c":true,"OB_Service_Point_City__c":"Assago",' +
                        '"OB_End_Seasonal__c":"","OB_Mobile_Phone_Number__c":"1234567890","OB_Opening_Saturday_Afternoon__c":true,"NE__Province__c":"MI",' +
                        '"OB_MCC_Description__c":"ACCESSORI AUTOMOBILI","NE__Postal_Code__c":"","NE__Account__c":"' + testAccount.Id + '","OB_MCC__c":"5533",' +
                        '"OB_Typology__c":"Fisico","OB_Opening_Sunday_Afternoon__c":true,"OB_Service_Point_Name__c":"insegna","Id":"' + sServicePoint.Id + '",' +
                        '"OB_Privacy_C5__c":false,"OB_Opening_Sunday_Morning__c":true,"OB_Annual_Revenue__c":"","OB_Ecommerce__c":false,"NE__Country__c":"ITA"},' +
                        '"legale_rappresentante":{"OB_Country_Birth__c":"USA","OB_Document_Release_Country__c":"Washington","OB_Address_Country__c":"USA"},' +
                        '"bankProfile":{"sobjectType":"ob_bank_profile__c","OB_Business_Model_POS__c":"Trilaterale Nuovo","OB_Business_Model_Acquiring__c":"Bancario",' +
                        '"OB_NDG__c":"false"}, ' +
                        '"Configuration" : { "OB_PBSettlementMethod__c" : "" }, ' +
                        '"OrderHeader" : { "OB_PreliminaryVerificationCode__c" : "", "OB_Report_Type__c" : "" }, ' +
                        '"merchant": { "sobjectType": "account", "RecordTypeId": "", "Id": "", "AccountId": "", "Name": "", ' +
                        '"NE__Fiscal_code__c": "yuiou8956tyu895t", "NE__VAT__c": "", "OB_Services_Choice__c": "", "OB_Legal_Address_Street__c": "stradaSedeLegale", ' +
                        '"OB_Legal_Address_Street_Number__c" : "civicoSedeLegale", "OB_Legal_Address_City__c": "comuneSedeLegale", "OB_Legal_Address_State__c": "provinciaSedeLegale", ' +
                        '"OB_Legal_Address_ZIP__c": "", "OB_Legal_Address_Country__c": "ITALIA", "OB_Administrative_Office_City__c": "", "OB_Administrative_Office_Street__c": "", ' +
                        '"OB_Administrative_Office_State__c": "", "OB_Administrative_Office_ZIP__c": "", "OB_Administrative_Office_Name__c": "" , "OB_VAT_Not_Present__c" : true, ' +
                        '"OB_SAE_Code__c": "sae", "OB_Legal_Form__c": "FormaGiuridica", "OB_Bank__c" : "", "OB_Annual_Negotiated__c" : "100", "OB_Annual_Revenue__c" : "1000", ' +
                        '"OB_Employees_Number__c" : "" }, ' +
                        '"isLegalEqualAdm" : true, ' +
                        '"reportTypeRO" : false, ' +
                        '"prelimVerifCodeRO" : false,' +
                        '"showPicklistPostpagato" : true, ' +
                        '"viewSettMeth" : true }';
        Map<String, Object> testData = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );

        return testData;
    }

    /*******************************************************************************
    Purpose:    Method prepares data to 'identifyCompany' step

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0        Joanna Mielczarek        24/04/2019      Created         R1F2_RP_000_CC_OB_MandatoryFormalCheck_Test
    ********************************************************************************/
    private static Map<String, Object> prepareData_identifyCompany( Boolean NDG, Boolean VATNotPresent )
    {
        String testJSON =
                '{ "bank": { "sobjectType": "ob_bank_profile__c", "OB_ABI__c" : "", "OB_Business_Model_POS__c": "", ' +
                        '"OB_Business_Model_Acquiring__c": "Bancario" }, ' +
                        '"user" : { "sobjectType": "ne__billing_profile__c", "RecordTypeId" : "", "OB_ABI__c" : "", "OB_CAB__c" : "", ' +
                        '"OB_Bank_Account_Number__c": "", "OB_Bank_Account_Owner__c": "", "OB_Bank_Account_Type__c": "" }, ' +
                        '"bankProfile" : { "sobjectType" : "ob_bank_profile__c", "OB_Business_Model_POS__c" : "", ' +
                        '"OB_Business_Model_Acquiring__c" : "", "OB_NDG__c" : ' + NDG + ' }, ' +
                        '"actualBank" : "", ' +
                        '"OrderHeader" : { "Id" : "", "OB_NDG__c" : "" }, ' +
                        '"Configuration": { "sobjectType": "NE__Order__c", "Id" : "" }, ' +
                        '"order" : { "OB_MCC__c" : "" }, ' +
                        '"order2" : { "OB_MCC__c" : "" }, ' +
                        '"merchant": { "sobjectType": "account", "RecordTypeId": "", "Id": "", "AccountId": "", "Name": "", ' +
                        '"OB_VAT_Not_Present__c" : ' + VATNotPresent + ', "OB_DescriptionVATNotPresent__c" : "", "NE__VAT__c" : "" }, ' +
                        '"pv": { "Id" : "", "sobjectType": "ne__service_point__c", "RecordTypeId": "", "NE__Account__c": "", ' +
                        '"Name": "pvName", "NE__Country__c" : "IT" },' +
                        '"isL3Required" : true, "correctCAB" : false }';
        Map<String, Object> testData = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );

        return testData;
    }

    /*******************************************************************************
    Purpose:    Method prepares data to 'companyData' step

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0        Joanna Mielczarek        24/04/2019      Created         R1F2_RP_000_CC_OB_MandatoryFormalCheck_Test
    ********************************************************************************/
    private static Map<String, Object> prepareData_companyData( )
    {
        String testJSON =
                '{ "isLegalEqualAdm": true, ' +
                        '"bankOwner" : "", ' +
                        '"bank": { "sobjectType": "ob_bank_profile__c", "OB_Business_Model_POS__c": "" }, ' +
                        '"user" : { "sobjectType": "ne__billing_profile__c", "RecordTypeId" : "", "OB_ABI__c" : "", "OB_CAB__c" : "", ' +
                        '"OB_Bank_Account_Number__c": "", "OB_Bank_Account_Owner__c": "", "OB_Bank_Account_Type__c": "" }, ' +
                        '"bankProfile" : { "sobjectType" : "ob_bank_profile__c", "OB_NDG__c" : "" }, ' +
                        '"actualBank" : "", ' +
                        '"OrderHeader" : { "Id" : "" }, ' +
                        '"Configuration": { "sobjectType": "NE__Order__c", "Id" : "", "OB_GT__c": "" }, ' +
                        '"merchant": { "sobjectType": "account", "RecordTypeId": "", "Id": "", "AccountId": "", "Name": "", "OB_FATECO__c" : "S" }, ' +
                        '"order" : { "OB_MCC__c": "" }, ' +
                        '"order2" : { "OB_MCC__c": "" }, ' +
                        '"legale_rappresentante": { "sobjectType": "contact", "RecordTypeId": "", "Id": "", "FirstName": "maria", "LastName": "maria",' +
                        '"OB_Country_Birth__c" : "IT", "OB_Document_Release_Country__c" : "IT", "OB_Address_Country__c" : "IT" }, ' +
                        '"sede_legale" : { "Id" : "", "OB_BypassValidation__c" : true, "AccountId" : "", "RecordTypeId" : "", "OB_Bank__c" : "", "LastName" : "" }, ' +
                        '"unbind": { "sobjectType": "UNBIND", "RecordTypeId": "", "nextCheckout": "", "nextCheck": "", "orderId": "", "UNBIND7": "ACQUIRING", ' +
                        '"UNBIND5": "", "UNBIND6": "", "yearOfConstitutionCompany": "" } }';
        Map<String, Object> testData = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );

        return testData;
    }

    /*******************************************************************************
    Purpose:    Method prepares data to 'actualOwner' steps

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0        Joanna Mielczarek        24/04/2019      Created         R1F2_RP_000_CC_OB_MandatoryFormalCheck_Test
    ********************************************************************************/
    private static Map<String, Object> prepareData_actualOwner( String contactNumber )
    {
        Integer thisYear = Date.today( ).year( );
        String testJSON =
                '{ "lastContact" : 1, ' +
                        '"Configuration" : { "sobjectType" : "NE__Order__c" , "OB_GT__c" : "" }, ' +
                        '"errorFamily" : { "key1" : false }, ' +
                        '"bankProfile" : { "sobjectType" : "ob_bank_profile__c", "OB_Business_Model_POS__c" : "Trilaterale Nuovo", ' +
                        '"OB_Business_Model_Acquiring__c" : "Bancario", "OB_NDG__c" : "true" }, ' +
                        '"actualBank" : "", ' +
                        '"OrderHeader" : { "Id" : "" }, ' +
                        '"Configuration": { "sobjectType": "NE__Order__c", "Id" : "", "OB_GT__c": "" }, ' +
                        '"merchant": { "sobjectType": "account", "RecordTypeId": "", "Id": "", "AccountId": "", "Name": "", ' +
                        '"NE__Fiscal_code__c": "yuiou8956tyu895t", "NE__VAT__c": "", "OB_Services_Choice__c": "", "OB_Legal_Address_Street__c": "stradaSedeLegale", ' +
                        '"OB_Legal_Address_Street_Number__c" : "civicoSedeLegale", "OB_Legal_Address_City__c": "comuneSedeLegale", "OB_Legal_Address_State__c": "provinciaSedeLegale", ' +
                        '"OB_Legal_Address_ZIP__c": "", "OB_Legal_Address_Country__c": "ITALIA", "OB_Administrative_Office_City__c": "", "OB_Administrative_Office_Street__c": "", ' +
                        '"OB_Administrative_Office_State__c": "", "OB_Administrative_Office_ZIP__c": "", "OB_Administrative_Office_Name__c": "" , "OB_VAT_Not_Present__c" : true, ' +
                        '"OB_SAE_Code__c": "sae", "OB_Legal_Form__c": "FormaGiuridica", "OB_Bank__c" : "", "OB_Annual_Negotiated__c" : "100", "OB_Annual_Revenue__c" : "1000", ' +
                        '"OB_Employees_Number__c" : "" }, ' +
                        '"contact' + contactNumber + '" : { "Id" : "",  "FirstName": "maria", "LastName": "maria", ' +
                        '"OB_Fiscal_Code__c" : "", "OB_Sex__c": "F", "OB_Cadastral_Code__c" : "F205", "OB_SkipCadastralCodeCheck__c" : true, ' +
                        '"Role__c": "aa", "OB_Birth_Date__c" : "1990-06-12", "OB_Birth_State__c" : "aa", "OB_Birth_City__c" : "aa", "OB_Country_Birth__c" : "IT", ' +
                        '"sobjectType" : "contact", "RecordTypeId" : "", "AccountId" : "", "OB_Document_Type__c" : "' + OB_UtilityConstants.CARTA_DI_IDENTITA + '", ' +
                        '"OB_Document_Number__c": "1231231231", "OB_Document_Release_Authority__c": "' + OB_UtilityConstants.COMUNE + '", ' +
                        '"OB_Document_Release_Date__c": "' + String.valueOf( Date.newInstance( thisYear - 1, 6, 13 ) ) + '", ' +
                        '"OB_Document_Expiration_Date__c": "' + String.valueOf( Date.newInstance( thisYear + 10, 6, 12 ) ) + '","OB_Document_Release_City__c":"city", ' +
                        '"OB_Document_Release_Country__c" : "IT", "OB_Document_Release_State__c" : "state", "OB_Address_Country__c" : "IT", ' +
                        '"OB_Address_State__c": "provinciaSedeLegale", "OB_Address_City__c": "comuneSedeLegale", "OB_Address_Street__c": "stradaSedeLegale", ' +
                        '"OB_Address_Street_Number__c": "civicoSedeLegale" },' +
                        '"contact' + contactNumber + 'EE" : { "Id" : "",  "FirstName": "maria", "LastName": "maria", ' +
                        '"OB_Fiscal_Code__c" : "", "OB_Sex__c": "F", "OB_Cadastral_Code__c" : "F205", "OB_SkipCadastralCodeCheck__c" : true, ' +
                        '"Role__c": "aa", "OB_Birth_Date__c" : "1990-06-12", "OB_Birth_State__c" : "aa", "OB_Birth_City__c" : "aa", "OB_Country_Birth__c" : "IT", ' +
                        '"sobjectType" : "contact", "RecordTypeId" : "", "AccountId" : "", "OB_Document_Type__c" : "", "OB_Document_Release_Date__c": "", ' +
                        '"OB_Document_Expiration_Date__c": "","OB_Document_Release_City__c":"", "OB_Document_Release_Country__c" : "IT", ' +
                        '"OB_Document_Release_State__c" : "", "OB_Address_Country__c" : "IT", "OB_Address_State__c": "", "OB_Address_City__c": "", ' +
                        '"OB_Address_Street__c": "", "OB_Address_Street_Number__c": "" } }';
        Map<String, Object> testData = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );

        return testData;
    }

    /*******************************************************************************
    Purpose:  Method checks correctness of given data for 'identifyCompany' method - VAT not present

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0        Joanna Mielczarek        24/04/2019      Created         R1F2_RP_000_CC_OB_MandatoryFormalCheck_Test
    ********************************************************************************/
    @isTest static void inputCheck_identifyCompany_VATNotPresent( )
    {
        Map<String, Object> data = OB_MandatoryFormalCheck_Test.prepareData_identifyCompany( false, false );
        String step = 'identifyCompany';
        Map<String, String> testErrorMap = OB_MandatoryFormalCheck.inputCheck( data, step );

        System.assert( !testErrorMap.containsKey( 'OB_DescriptionVATNotPresent__c' ) );
    }

    /*******************************************************************************
    Purpose:  Method checks correctness of given data for 'identifyCompany' method - VAT present

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0        Joanna Mielczarek        24/04/2019      Created         R1F2_RP_000_CC_OB_MandatoryFormalCheck_Test
    ********************************************************************************/
    @isTest static void inputCheck_identifyCompany_VATPresent( )
    {
        Map<String, Object> data = OB_MandatoryFormalCheck_Test.prepareData_identifyCompany( true, true );
        String step = 'identifyCompany';
        Map<String, String> testErrorMap = OB_MandatoryFormalCheck.inputCheck( data, step );

        System.assert( !testErrorMap.containsKey( 'NE__VAT__c' ) );
    }

    /*******************************************************************************
    Purpose:  Method checks correctness of given data for 'identifyCompany' method - false NDG

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0        Joanna Mielczarek        24/04/2019      Created         R1F2_RP_000_CC_OB_MandatoryFormalCheck_Test
    ********************************************************************************/
    @isTest static void inputCheck_identifyCompany_NDGfalse( )
    {
        Map<String, Object> data = OB_MandatoryFormalCheck_Test.prepareData_identifyCompany( false, true );
        String step = 'identifyCompany';
        Map<String, String> testErrorMap = OB_MandatoryFormalCheck.inputCheck( data, step );

        System.assert( !testErrorMap.containsKey( 'OB_NDG__c' ) );
    }

    /*******************************************************************************
    Purpose:  Method checks correctness of given data for 'companyData' method

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0        Joanna Mielczarek        24/04/2019      Created         R1F2_RP_000_CC_OB_MandatoryFormalCheck_Test
    ********************************************************************************/
    @isTest static void inputCheck_companyData( )
    {
        Map<String, Object> data = OB_MandatoryFormalCheck_Test.prepareData_companyData( );
        String step = 'companyData';
        Map<String, String> testErrorMap = OB_MandatoryFormalCheck.inputCheck( data, step );

        System.assert( !testErrorMap.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0        Joanna Mielczarek        24/04/2019      Created         R1F2_RP_000_CC_OB_MandatoryFormalCheck_Test
    ********************************************************************************/
    @isTest static void inputCheck_operationalData_ReportTypeMissing( )
    {
        Map<String, Object> data = OB_MandatoryFormalCheck_Test.setupData( );
        String step = 'operationalData';
        Map<String, String> testErrorMap = OB_MandatoryFormalCheck.inputCheck( data, step );

        System.assert( !testErrorMap.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0        Joanna Mielczarek        24/04/2019      Created         R1F2_RP_000_CC_OB_MandatoryFormalCheck_Test
    ********************************************************************************/
    @isTest static void inputCheck_operationalData_PreliminaryVerificationCodeMissing( )
    {
        Map<String, Object> data = OB_MandatoryFormalCheck_Test.setupData( );
        String step = 'operationalData';
        Map<String, String> testErrorMap = OB_MandatoryFormalCheck.inputCheck( data, step );

        System.assert( !testErrorMap.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method checks correctness of given data for 'actualOwner' method - contact1

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0        Joanna Mielczarek        24/04/2019      Created         R1F2_RP_000_CC_OB_MandatoryFormalCheck_Test
    ********************************************************************************/
    @isTest static void inputCheck_actualOwner_1( )
    {
        Map<String, Object> data = OB_MandatoryFormalCheck_Test.prepareData_actualOwner( '1' );
        String step = 'actualOwnerOne';
        Map<String, String> testErrorMap = OB_MandatoryFormalCheck.inputCheck( data, step );

        System.assert( !testErrorMap.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method checks correctness of given data for 'actualOwner' method - contact2

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0        Joanna Mielczarek        24/04/2019      Created         R1F2_RP_000_CC_OB_MandatoryFormalCheck_Test
    ********************************************************************************/
    @isTest static void inputCheck_actualOwner_2( )
    {
        Map<String, Object> data = OB_MandatoryFormalCheck_Test.prepareData_actualOwner( '2' );
        String step = 'actualOwnerTwo';
        Map<String, String> testErrorMap = OB_MandatoryFormalCheck.inputCheck( data, step );

        System.assert( !testErrorMap.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method checks correctness of given data for 'actualOwner' method - contact3

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0        Joanna Mielczarek        24/04/2019      Created         R1F2_RP_000_CC_OB_MandatoryFormalCheck_Test
    ********************************************************************************/
    @isTest static void inputCheck_actualOwner_3( )
    {
        Map<String, Object> data = OB_MandatoryFormalCheck_Test.prepareData_actualOwner( '3' );
        String step = 'actualOwnerThree';
        Map<String, String> testErrorMap = OB_MandatoryFormalCheck.inputCheck( data, step );

        System.assert( !testErrorMap.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method checks correctness of given data for 'actualOwner' method - contact4

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0        Joanna Mielczarek        24/04/2019      Created         R1F2_RP_000_CC_OB_MandatoryFormalCheck_Test
    ********************************************************************************/
    @isTest static void inputCheck_actualOwner_4( )
    {
        Map<String, Object> data = OB_MandatoryFormalCheck_Test.prepareData_actualOwner( '4' );
        String step = 'actualOwnerFour';
        Map<String, String> testErrorMap = OB_MandatoryFormalCheck.inputCheck( data, step );

        System.assert( !testErrorMap.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method checks correctness of given data for 'actualOwner' method - contact5

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0        Joanna Mielczarek        24/04/2019      Created         R1F2_RP_000_CC_OB_MandatoryFormalCheck_Test
    ********************************************************************************/
    @isTest static void inputCheck_actualOwner_5( )
    {
        Map<String, Object> data = OB_MandatoryFormalCheck_Test.prepareData_actualOwner( '5' );
        String step = 'actualOwnerFive';
        Map<String, String> testErrorMap = OB_MandatoryFormalCheck.inputCheck( data, step );

        System.assert( !testErrorMap.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method checks correctness of given data for 'actualOwner' method - contact6

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0        Joanna Mielczarek        24/04/2019      Created         R1F2_RP_000_CC_OB_MandatoryFormalCheck_Test
    ********************************************************************************/
    @isTest static void inputCheck_actualOwner_6( )
    {
        Map<String, Object> data = OB_MandatoryFormalCheck_Test.prepareData_actualOwner( '6' );
        String step = 'actualOwnerSix';
        Map<String, String> testErrorMap = OB_MandatoryFormalCheck.inputCheck( data, step );

        System.assert( !testErrorMap.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method checks correctness of given data for 'servicePoint' method -
              there is empty map scenario because fields of time cannot be null

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0        Joanna Mielczarek        24/04/2019      Created         R1F2_RP_000_CC_OB_MandatoryFormalCheck_Test
    ********************************************************************************/
    @isTest static void inputCheck_servicePoint( )
    {
        Map<String, Object> data = OB_MandatoryFormalCheck_Test.setupData( );
        String step = 'servicePoint';
        Map<String, String> testErrorMap = OB_MandatoryFormalCheck.inputCheck( data, step );

        System.assert( testErrorMap.isEmpty( ) );
    }
    
}