/*******************************************************************************
 Purpose: Test class for CustomRetrieveServicePoint_Test

 History
 --------
 VERSION         AUTHOR           DATE              DETAIL          Description
 1.0            ?                 ?                 Created             *
 1.1            Wojciech Szuba    11/10/2019        Refactored      NEXI-103
 ********************************************************************************/
@isTest
private class CustomRetrieveServicePoint_Test
{
    /*******************************************************************************
     Purpose: Test method for CustomRetrieveServicePoint.executeMethod

     History
     --------
     VERSION         AUTHOR           DATE              DETAIL          Description
     1.0            ?                 ?                 Created             *
     1.1            Wojciech Szuba    11/10/2019        Refactored      NEXI-103
     ********************************************************************************/
    @isTest
    private static void executeMethodTest( )
    {
        Account accountTest = OB_TestDataFactory.getAccount( );
        insert accountTest;

        Map<String, Object> testData = ( Map<String, Object> ) JSON.deserializeUntyped( '{"Unbind" : {"sObjectType" : "Unbind", "POS" : "", "Acquiring" : true, "FiscalCode" : "AAAAAA11A11A111A" }}' );
        Test.startTest( );
        CustomRetrieveServicePoint testCustomRetrieveServicePoint = new CustomRetrieveServicePoint( );
        bit2flow.DynamicWizardStepWrapper testResult = testCustomRetrieveServicePoint.executeMethod( '', testData, '', '', new List<bit2flow.DynamicWizardWrapper.StepDefinitions>( ), new bit2flow.DynamicWizardWrapper( ) );
        Test.stopTest( );
        System.assertEquals( null, testResult.result );
    }

    /*******************************************************************************
     Purpose: Test method for CustomRetrieveServicePoint.init

     History
     --------
     VERSION         AUTHOR           DATE              DETAIL          Description
     1.0            ?                 ?                 Created             *
     1.1            Wojciech Szuba    11/10/2019        Refactored      NEXI-103
     ********************************************************************************/
    @isTest
    private static void initTest( )
    {
        Account testAccount = OB_TestDataFactory.getAccount( );
        testAccount.OB_BypassValidation__c = true;
        insert testAccount;

        NE__Service_Point__c testServicePoint = OB_TestDataFactory.getServicePoint( );
        testServicePoint.NE__Account__c = testAccount.Id;
        insert testServicePoint;

        Id titolareEffettivoRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName( ).get( 'Titolare_Effettivo' ).getRecordTypeId( );
        String jsonString = '{"BillingProfile2":{"sobjectType":"ne__billing_profile__c","RecordTypeId":"","OB_ABI__c":"","OB_Bank_Account_Number__c":"","OB_Bank_Account_Owner__c":"","OB_Bank_Account_Type__c":"Debit"},"BillingProfile1":{"sobjectType":"ne__billing_profile__c","RecordTypeId":"' + titolareEffettivoRecordTypeId + '","OB_ABI__c":"","OB_Bank_Account_Number__c":"","OB_Bank_Account_Owner__c":"","OB_Bank_Account_Type__c":"Credit"},"contact6":{"sobjectType":"contact","RecordTypeId":"' + titolareEffettivoRecordTypeId + '","FirstName":"","LastName":"","OB_Fiscal_Code__c":"","OB_Sex__c":"","Role__c":"","AccountId":"","OB_Birth_Date__c":"","OB_Birth_State__c":"","OB_Birth_City__c":"","OB_Document_Type__c":"","OB_Document_Release_City__c":"","OB_Document_Number__c":"","OB_Document_Release_Date__c":"","OB_Document_Release_Authority__c":""},"titolare_effettivo":{"sobjectType":"contact","RecordTypeId":"' + titolareEffettivoRecordTypeId + '","FirstName":"","LastName":"","OB_Fiscal_Code__c":"","OB_Sex__c":"","Role__c":"","AccountId":"","OB_Birth_Date__c":"","OB_Birth_State__c":"","OB_Birth_City__c":"","OB_Document_Type__c":"","OB_Document_Release_City__c":"","OB_Document_Number__c":"","OB_Document_Release_Date__c":"","OB_Document_Release_Authority__c":""},"contact4":{"sobjectType":"contact","RecordTypeId":"","FirstName":"","LastName":"","OB_Fiscal_Code__c":"","OB_Sex__c":"","Role__c":"","AccountId":"","OB_Birth_Date__c":"","OB_Birth_State__c":"","OB_Birth_City__c":"","OB_Document_Type__c":"","OB_Document_Release_City__c":"","OB_Document_Number__c":"","OB_Document_Release_Date__c":"","OB_Document_Release_Authority__c":""},"contact3":{"sobjectType":"contact","RecordTypeId":"' + titolareEffettivoRecordTypeId + '","FirstName":"","LastName":"","OB_Fiscal_Code__c":"","OB_Sex__c":"","Role__c":"","AccountId":"","OB_Birth_Date__c":"","OB_Birth_State__c":"","OB_Birth_City__c":"","OB_Document_Type__c":"","OB_Document_Release_City__c":"","OB_Document_Number__c":"","OB_Document_Release_Date__c":"","OB_Document_Release_Authority__c":""},"contact2":{"sobjectType":"contact","RecordTypeId":"' + titolareEffettivoRecordTypeId + '","FirstName":"","LastName":"","OB_Fiscal_Code__c":"","OB_Sex__c":"","Role__c":"","AccountId":"","OB_Birth_Date__c":"","OB_Birth_State__c":"","OB_Birth_City__c":"","OB_Document_Type__c":"","OB_Document_Release_City__c":"","OB_Document_Number__c":"","OB_Document_Release_Date__c":"","OB_Document_Release_Authority__c":""},"contact1":{"sobjectType":"contact","RecordTypeId":"' + titolareEffettivoRecordTypeId + '","FirstName":"","LastName":"","OB_Fiscal_Code__c":"","OB_Sex__c":"","Role__c":"","AccountId":"","OB_Birth_Date__c":"","OB_Birth_State__c":"","OB_Birth_City__c":"","OB_Document_Type__c":"","OB_Document_Release_City__c":"","OB_Document_Number__c":"","OB_Document_Release_Date__c":"","OB_Document_Release_Authority__c":""},"legale_rappresentante":{"sobjectType":"contact","RecordTypeId":"","FirstName":"","LastName":"","OB_Fiscal_Code__c":"","OB_Sex__c":"","Role__c":"","OB_Birth_Date__c":"","OB_Birth_State__c":"","OB_Birth_City__c":"","OB_Document_Type__c":"","OB_Document_Number__c":"","OB_Document_Release_Date__c":"","OB_Document_Release_City__c":"","OB_Document_Release_Authority__c":""},"orderId":{"sobjectType":"UNBIND","RecordTypeId":""},"puntoVendita":{"sobjectType":"ne__service_point__c","RecordTypeId":"","NE__Account__c":"","Name":"","NE__Street__c":"","NE__Zip_Code__c":"","NE__City__c":"","NE__Province__c":"","NE__Country__c":"","Id":"","OB_MCC__c":"","OB_Email__c":"","OB_PEC__c":"","OB_Opening_Monday_Morning__c":"true","OB_Opening_Monday_Afternoon__c":"true","OB_Opening_Thursday_Morning__c":"true","OB_Opening_Thursday_Afternoon__c":"true","OB_Opening_Tuesday_Morning__c":"true","OB_Opening_Tuesday_Afternoon__c":"true","OB_Opening_Wednesday_Morning__c":"true","OB_Opening_Wednesday_Afternoon__c":"true","OB_Opening_Friday_Morning__c":"true","OB_Opening_Friday_Afternoon__c":"true","OB_Opening_Saturday_Morning__c":"true","OB_Opening_Saturday_Afternoon__c":"true","OB_Opening_Sunday_Morning__c":"true","OB_Opening_Sunday_Afternoon__c":"true"},"unbind":{"sobjectType":"UNBIND","RecordTypeId":"","nextCheckout":"","nextCheck":"","orderId":"","UNBIND7":"ACQUIRING","UNBIND5":"","UNBIND6":""},"merchant":{"sobjectType":"account","RecordTypeId":"","Id":"' + testAccount.Id + '","Name":"","NE__Fiscal_code__c":"yuiou8956tyu895t","NE__VAT__c":"","OB_Services_Choice__c":"","OB_Legal_Address_Street__c":"","OB_Legal_Address_City__c":"","OB_Legal_Address_State__c":"","OB_Legal_Address_ZIP__c":"","OB_Legal_Address_Country__c":"","OB_Administrative_Office_City__c":"","OB_Administrative_Office_Street__c":"","OB_Administrative_Office_State__c":"","OB_Administrative_Office_ZIP__c":"","OB_Administrative_Office_Name__c":""}}';

        Map<String, Object> testData = new Map<String, Object>( );
        testData = ( Map<String, Object> ) JSON.deserializeUntyped( jsonString );

        Test.startTest( );
        CustomRetrieveServicePoint testCustomRetrieveServicePoint = new CustomRetrieveServicePoint( );
        bit2flow.DynamicWizardStepWrapper testResult = testCustomRetrieveServicePoint.init( '', testData, new List<bit2flow.DynamicWizardWrapper.StepDefinitions>( ), new bit2flow.DynamicWizardWrapper( ) );
        Test.stopTest( );
        System.assertEquals( bit2flow.DynamicWizardStepWrapper.OKCODE, testResult.result );
    }

    /*******************************************************************************
     Purpose: Test method for CustomRetrieveServicePoint.validate

     History
     --------
     VERSION         AUTHOR           DATE              DETAIL          Description
     1.0            ?                 ?                 Created             *
     1.1            Wojciech Szuba    15/10/2019        Refactored      NEXI-103
     ********************************************************************************/
    @isTest
    private static void validateTest( )
    {
        Test.startTest( );
        CustomRetrieveServicePoint testCustomRetrieveServicePoint = new CustomRetrieveServicePoint( );
        bit2flow.DynamicWizardStepWrapper testResult = testCustomRetrieveServicePoint.validate( '', new Map<String, Object>( ), new List<bit2flow.DynamicWizardWrapper.StepDefinitions>( ), new bit2flow.DynamicWizardWrapper( ) ) ;
        Test.stopTest( );
        System.debug( testResult );
        System.assertEquals( null, testResult.result );
    }

    /*******************************************************************************
     Purpose: Test method for CustomRetrieveServicePoint.save

     History
     --------
     VERSION         AUTHOR           DATE              DETAIL          Description
     1.0            ?                 ?                 Created             *
     1.1            Wojciech Szuba    15/10/2019        Refactored      NEXI-103
     ********************************************************************************/
    @isTest
    private static void saveTest( )
    {
        Id titolareEffettivoRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName( ).get( 'Titolare_Effettivo' ).getRecordTypeId( );
        String jsonString = '{"BillingProfile2":{"sobjectType":"ne__billing_profile__c","RecordTypeId":"","OB_ABI__c":"","OB_Bank_Account_Number__c":"","OB_Bank_Account_Owner__c":"","OB_Bank_Account_Type__c":"Debit"},"BillingProfile1":{"sobjectType":"ne__billing_profile__c","RecordTypeId":"","OB_ABI__c":"","OB_Bank_Account_Number__c":"","OB_Bank_Account_Owner__c":"","OB_Bank_Account_Type__c":"Credit"},"contact6":{"sobjectType":"contact","RecordTypeId":"' + titolareEffettivoRecordTypeId + '","FirstName":"","LastName":"","OB_Fiscal_Code__c":"","OB_Sex__c":"","Role__c":"","AccountId":"","OB_Birth_Date__c":"","OB_Birth_State__c":"","OB_Birth_City__c":"","OB_Document_Type__c":"","OB_Document_Release_City__c":"","OB_Document_Number__c":"","OB_Document_Release_Date__c":"","OB_Document_Release_Authority__c":""},"contact5":{"sobjectType":"contact","RecordTypeId":"' + titolareEffettivoRecordTypeId + '","FirstName":"","LastName":"","OB_Fiscal_Code__c":"","OB_Sex__c":"","Role__c":"","AccountId":"","OB_Birth_Date__c":"","OB_Birth_State__c":"","OB_Birth_City__c":"","OB_Document_Type__c":"","OB_Document_Release_City__c":"","OB_Document_Number__c":"","OB_Document_Release_Date__c":"","OB_Document_Release_Authority__c":""},"contact4":{"sobjectType":"contact","RecordTypeId":"' + titolareEffettivoRecordTypeId + '","FirstName":"","LastName":"","OB_Fiscal_Code__c":"","OB_Sex__c":"","Role__c":"","AccountId":"","OB_Birth_Date__c":"","OB_Birth_State__c":"","OB_Birth_City__c":"","OB_Document_Type__c":"","OB_Document_Release_City__c":"","OB_Document_Number__c":"","OB_Document_Release_Date__c":"","OB_Document_Release_Authority__c":""},"contact3":{"sobjectType":"contact","RecordTypeId":"' + titolareEffettivoRecordTypeId + '","FirstName":"","LastName":"","OB_Fiscal_Code__c":"","OB_Sex__c":"","Role__c":"","AccountId":"","OB_Birth_Date__c":"","OB_Birth_State__c":"","OB_Birth_City__c":"","OB_Document_Type__c":"","OB_Document_Release_City__c":"","OB_Document_Number__c":"","OB_Document_Release_Date__c":"","OB_Document_Release_Authority__c":""},"contact2":{"sobjectType":"contact","RecordTypeId":"' + titolareEffettivoRecordTypeId + '","FirstName":"","LastName":"","OB_Fiscal_Code__c":"","OB_Sex__c":"","Role__c":"","AccountId":"","OB_Birth_Date__c":"","OB_Birth_State__c":"","OB_Birth_City__c":"","OB_Document_Type__c":"","OB_Document_Release_City__c":"","OB_Document_Number__c":"","OB_Document_Release_Date__c":"","OB_Document_Release_Authority__c":""},"contact1":{"sobjectType":"contact","RecordTypeId":"' + titolareEffettivoRecordTypeId + '","FirstName":"","LastName":"","OB_Fiscal_Code__c":"","OB_Sex__c":"","Role__c":"","AccountId":"","OB_Birth_Date__c":"","OB_Birth_State__c":"","OB_Birth_City__c":"","OB_Document_Type__c":"","OB_Document_Release_City__c":"","OB_Document_Number__c":"","OB_Document_Release_Date__c":"","OB_Document_Release_Authority__c":""},"legale_rappresentante":{"sobjectType":"contact","RecordTypeId":"","FirstName":"","LastName":"","OB_Fiscal_Code__c":"","OB_Sex__c":"","Role__c":"","OB_Birth_Date__c":"","OB_Birth_State__c":"","OB_Birth_City__c":"","OB_Document_Type__c":"","OB_Document_Number__c":"","OB_Document_Release_Date__c":"","OB_Document_Release_City__c":"","OB_Document_Release_Authority__c":""}, "legale_rappresentante":{"sobjectType":"contact","RecordTypeId":"","FirstName":"","LastName":"","OB_Fiscal_Code__c":"","OB_Sex__c":"","Role__c":"","OB_Birth_Date__c":"","OB_Birth_State__c":"","OB_Birth_City__c":"","OB_Document_Type__c":"","OB_Document_Number__c":"","OB_Document_Release_Date__c":"","OB_Document_Release_City__c":"","OB_Document_Release_Authority__c":""},"orderId":{"sobjectType":"UNBIND","RecordTypeId":""},"pv":{"sobjectType":"ne__service_point__c","RecordTypeId":"","NE__Account__c":"","Name":"","NE__Street__c":"","NE__Zip_Code__c":"","NE__City__c":"","NE__Province__c":"","NE__Country__c":"","Id":"","OB_MCC__c":"","OB_Email__c":"","OB_PEC__c":"","OB_Opening_Monday_Morning__c":"true","OB_Opening_Monday_Afternoon__c":"true","OB_Opening_Thursday_Morning__c":"true","OB_Opening_Thursday_Afternoon__c":"true","OB_Opening_Tuesday_Morning__c":"true","OB_Opening_Tuesday_Afternoon__c":"true","OB_Opening_Wednesday_Morning__c":"true","OB_Opening_Wednesday_Afternoon__c":"true","OB_Opening_Friday_Morning__c":"true","OB_Opening_Friday_Afternoon__c":"true","OB_Opening_Saturday_Morning__c":"true","OB_Opening_Saturday_Afternoon__c":"true","OB_Opening_Sunday_Morning__c":"true","OB_Opening_Sunday_Afternoon__c":"true"},"unbind":{"sobjectType":"UNBIND","RecordTypeId":"","nextCheckout":"","nextCheck":"","orderId":"","UNBIND7":"ACQUIRING","UNBIND5":"","UNBIND6":""},"merchant":{"sobjectType":"account","RecordTypeId":"","Id":"0019E00000foRz3","Name":"","NE__Fiscal_code__c":"yuiou8956tyu895t","NE__VAT__c":"","OB_Services_Choice__c":"","OB_Legal_Address_Street__c":"","OB_Legal_Address_City__c":"","OB_Legal_Address_State__c":"","OB_Legal_Address_ZIP__c":"","OB_Legal_Address_Country__c":"","OB_Administrative_Office_City__c":"","OB_Administrative_Office_Street__c":"","OB_Administrative_Office_State__c":"","OB_Administrative_Office_ZIP__c":"","OB_Administrative_Office_Name__c":""}}';
        Map<String, Object> testData = new Map<String, Object>( );
        testData = ( Map<String, Object> ) JSON.deserializeUntyped( jsonString );
        Test.startTest( );
        CustomRetrieveServicePoint testCustomRetrieveServicePoint = new CustomRetrieveServicePoint( );
        bit2flow.DynamicWizardStepWrapper testResult = testCustomRetrieveServicePoint.save( '', testData, '', new List<bit2flow.DynamicWizardWrapper.StepDefinitions>( ), new bit2flow.DynamicWizardWrapper( ) ) ;
        Test.stopTest( );
        System.assertEquals( bit2flow.DynamicWizardStepWrapper.OKCODE, testResult.result );
    }
}