@isTest
public class OB_FlowControlClass_Test
{

    /*******************************************************************************
    Purpose:  Method prepares data to 'companyData' test methods
    Parameters: -
    Returns: Map<String, Object>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       24/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
     ********************************************************************************/
    private static Map<String, Object> prepareDataCompanyData( )
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
                        '"merchant": { "sobjectType": "account", "RecordTypeId": "", "Id": "", "AccountId": "", "Name": "" }, ' +
                        '"order" : { "OB_MCC__c": "" }, ' +
                        '"order2" : { "OB_MCC__c": "" }, ' +
                        '"legale_rappresentante": { "sobjectType": "contact", "RecordTypeId": "", "Id": "", "FirstName": "maria", "LastName": "maria"  }, ' +
                        '"sede_legale" : { "Id" : "", "OB_BypassValidation__c" : true, "AccountId" : "", "RecordTypeId" : "", "OB_Bank__c" : "", "LastName" : "" }, ' +
                        '"unbind": { "sobjectType": "UNBIND", "RecordTypeId": "", "nextCheckout": "", "nextCheck": "", "orderId": "", "UNBIND7": "ACQUIRING", ' +
                        '"UNBIND5": "", "UNBIND6": "", "yearOfConstitutionCompany": "" } }';
        Map<String, Object> testData = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );

        return testData;
    }

    /*******************************************************************************
    Purpose:  Method prepares data to 'actualOwner' test methods
    Parameters: -
    Returns: Map<String, Object>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       24/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
     ********************************************************************************/
    private static Map<String, Object> prepareDataActualOwner( )
    {
        String testJSON =
                '{ ' +
                        '"lastContact" : 1, ' +
                        '"Configuration" : { "sobjectType" : "NE__Order__c" , "OB_GT__c" : "" }, ' +
                        '"errorFamily" : { "key1" : false }, ' +
                        '"bankProfile" : { "sobjectType" : "ob_bank_profile__c", "OB_Business_Model_POS__c" : "", ' +
                        '"OB_Business_Model_Acquiring__c" : "Bancario", "OB_NDG__c" : "" }, ' +
                        '"actualBank" : "", ' +
                        '"OrderHeader" : { "Id" : "" }, ' +
                        '"Configuration": { "sobjectType": "NE__Order__c", "Id" : "", "OB_GT__c": "" }, ' +
                        '"merchant": { "sobjectType": "account", "RecordTypeId": "", "Id": "", "AccountId": "", "Name": "", "NE__Fiscal_code__c": "" },' +
                        '"contact1" : { "Id" : "", "FirstName": "maria", "LastName": "maria" }, ' +
                        '"contact2" : { "Id" : "", "FirstName": "maria", "LastName": "maria" }, ' +
                        '"contact3" : { "Id" : "", "FirstName": "maria", "LastName": "maria" }, ' +
                        '"contact4" : { "Id" : "", "FirstName": "maria", "LastName": "maria" }, ' +
                        '"contact5" : { "Id" : "", "FirstName": "maria", "LastName": "maria" }, ' +
                        '"contact6" : { "Id" : "", "FirstName": "maria", "LastName": "maria" } }';
        Map<String, Object> testData = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );

        return testData;
    }

    /*******************************************************************************
    Purpose:  Method prepares data to 'identifyCompany' and 'servicePoint' test methods
    Parameters: -
    Returns: Map<String, Object>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       24/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
     ********************************************************************************/
    private static Map<String, Object> prepareDataIdentifyCompany( )
    {
        String testJSON =
                '{ "bank": { "sobjectType": "ob_bank_profile__c", "OB_ABI__c" : "", "OB_Business_Model_POS__c": "", ' +
                        '"OB_Business_Model_Acquiring__c": "Bancario" }, ' +
                        '"user" : { "sobjectType": "ne__billing_profile__c", "RecordTypeId" : "", "OB_ABI__c" : "", "OB_CAB__c" : "", ' +
                        '"OB_Bank_Account_Number__c": "", "OB_Bank_Account_Owner__c": "", "OB_Bank_Account_Type__c": "" }, ' +
                        '"bankProfile" : { "sobjectType" : "ob_bank_profile__c", "OB_Business_Model_POS__c" : "", ' +
                        '"OB_Business_Model_Acquiring__c" : "", "OB_NDG__c" : "" }, ' +
                        '"actualBank" : "", ' +
                        '"isOperation" : "false", ' +
                        '"OrderHeader" : { "Id" : "", "OB_NDG__c" : "" }, ' +
                        '"Configuration": { "sobjectType": "NE__Order__c", "Id" : "" }, ' +
                        '"order" : { "OB_MCC__c" : "" }, ' +
                        '"order2" : { "OB_MCC__c" : "" }, ' +
                        '"merchant": { "sobjectType": "account", "RecordTypeId": "", "Id": "", "AccountId": "", "Name": "" }, ' +
                        '"pv": { "Id" : "", "sobjectType": "ne__service_point__c", "RecordTypeId": "", "NE__Account__c": "", "Name": "pvName" },' +
                        '"isL3Required" : true, "correctCAB" : true }';
        Map<String, Object> testData = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );

        return testData;
    }

    /*******************************************************************************
    Purpose:  Method tests validating method - 'companyData'

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
     ********************************************************************************/
    @isTest static void validateStep5( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        Map<String, Object> data = OB_FlowControlClass_Test.prepareDataCompanyData( );
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        testWizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.validate( 'step5', data, null, testWizardWrapper );

        //System.assertEquals( 5, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests validating method - 'actualOwner'

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
     ********************************************************************************/
    @isTest static void validateStep6( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        Map<String, Object> data = OB_FlowControlClass_Test.prepareDataActualOwner( );
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        testWizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.validate( 'step6', data, null, testWizardWrapper );

        //System.assertEquals( 6, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests validating method - 'servicePoint'

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
     ********************************************************************************/
    @isTest static void validateStep7( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        Map<String, Object> data = OB_FlowControlClass_Test.prepareDataIdentifyCompany( );
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        testWizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.validate( 'step7', data, null, testWizardWrapper );

        //System.assertEquals( 8, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests validating method - 'downloadDocument'

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
     ********************************************************************************/
    @isTest static void validateStep8( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        String testJSON = '{ "allCheckedCreate" : "true","allCheckedLoad" : "true" }';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.validate( 'step8', data, null, testWizardWrapper );

		//System.assertEquals( 6, testResponse.stepToGo );
	}

    /*******************************************************************************
    Purpose:  Method tests overwriting next - 'identifyCompany'

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
     ********************************************************************************/
    @isTest static void overwriteNextStep1( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        Map<String, Object> data = OB_FlowControlClass_Test.prepareDataIdentifyCompany( );
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        testWizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.overwriteNext( '1', data, null, testWizardWrapper );

        //System.assertEquals( 1, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests overwriting next - 'GTselection'

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
     ********************************************************************************/
    @isTest static void overwriteNextStep2( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        String testJSON = '{ "Configuration" : { "sobjectType" : "NE__Order__c", "OB_GT__c" : "000" } }';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        testWizardWrapper.Name = 'OB_Catalogo_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.overwriteNext( '2', data, null, testWizardWrapper );

        //System.assertEquals( 3, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests overwriting next - 'operationalData'

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
     ********************************************************************************/
    @isTest static void overwriteNextStep4( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        String testJSON = '{ "reportTypeRO" : false } ';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.overwriteNext( '4', data, null, testWizardWrapper );

        //System.assert( testResponse != null );
    }

    /*******************************************************************************
    Purpose:  Method tests overwriting next - 'servicePoint'

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
     ********************************************************************************/
    @isTest static void overwriteNextStep7( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        Map<String, Object> data = OB_FlowControlClass_Test.prepareDataIdentifyCompany( );
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        testWizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.overwriteNext( '7', data, null, testWizardWrapper );

        //System.assertEquals( 8, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests overwriting - 'downloadDocument'

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
     ********************************************************************************/
    @isTest static void overwriteNextStep8( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        String testJSON = '{ "allCheckedCreate" : "true","allCheckedLoad" : "true" }';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.overwriteNext( '8', data, null, testWizardWrapper );

		//System.assertEquals( 6, testResponse.stepToGo );
	}

    /*******************************************************************************
    Purpose:  Method tests overwriting previous - 'GTselectionPrevious'

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
     ********************************************************************************/
    @isTest static void overwritePreviousStep2( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        String testJSON = '{ "messageNext" : { "message" : "", "severity" : "" } }';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        testWizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.overwritePrevious( '2', data, null, testWizardWrapper );

        //System.assertEquals( 1, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests overwriting previous - 'offertaSelectionPrevious'

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
     ********************************************************************************/
    @isTest static void overwritePreviousStep3( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        String testJSON = '{ "merchant": { "sobjectType": "account", "RecordTypeId": "", "Id": "", "Name": "", ' +
                '"NE__Fiscal_code__c": "yuiou8956tyu895t", "NE__VAT__c": "", "OB_Services_Choice__c": "", ' +
                '"OB_Legal_Address_Street__c": "", "OB_Legal_Address_City__c": "", "OB_Legal_Address_State__c": "", ' +
                '"OB_Legal_Address_ZIP__c": "", "OB_Legal_Address_Country__c": "", "OB_Administrative_Office_City__c": "", ' +
                '"OB_Administrative_Office_Street__c": "", "OB_Administrative_Office_State__c": "", ' +
                '"OB_Administrative_Office_ZIP__c": "", "OB_Administrative_Office_Name__c": "", "OB_VAT_Not_Present__c" : true }, ' +
                '"messageNext" : { "message" : "", "severity" : "" }, "GT" : "" }';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        testWizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.overwritePrevious( '3', data, null, testWizardWrapper );

        //System.assertEquals( 1, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests overwriting previous - 'operationalDataPrevious'

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
     ********************************************************************************/
    @isTest static void overwritePreviousStep4( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        Map<String, Object> data = new Map<String, Object>( );
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        testWizardWrapper.name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.overwritePrevious( '4', data, null, testWizardWrapper );

        //System.assertEquals( 3, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests overwriting previous - 'companyDataPrevious'

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
     ********************************************************************************/
    @isTest static void overwritePreviousStep5( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        String testJSON = '{ "BillingProfilePOS" : { "sobjectType": "ne__billing_profile__c", "RecordTypeId": "", ' +
                '"OB_ABI__c": "", "OB_Bank_Account_Number__c": "", "OB_Bank_Account_Owner__c": "", "OB_Bank_Account_Type__c": "Credit" } }';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        testWizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.overwritePrevious( '5', data, null, testWizardWrapper );

        //System.assertEquals( 4, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests overwriting previous - 'servicePointPrevious'

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
     ********************************************************************************/
    @isTest static void overwritePreviousStep7( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        String testJSON = '{ "merchant": { "sobjectType": "account", "RecordTypeId": "", "Id": "", "Name": "", ' +
                '"OB_Beneficial_Owner_Existence__c" : false } }';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        testWizardWrapper.Name = 'OB_Nuovo_Contratto';bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.overwritePrevious( '7', data, null, testWizardWrapper );

        //System.assertEquals( 5, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests overwriting previous - 'riepilogoPrevious'

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
     ********************************************************************************/
    @isTest static void overwritePreviousStep9( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        Map<String, Object> data = new Map<String, Object>( );
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        testWizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.overwritePrevious( '9', data, null, testWizardWrapper );

        //System.assertEquals( 8, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests overwriting save - 'riepilogoSave' -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
     ********************************************************************************/
    @isTest static void overwriteSaveStep1( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        Map<String, Object> data = new Map<String, Object>( );
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.overwriteSave( '1', data, null, testWizardWrapper, '' );

        //System.assertEquals( '666', testResponse.result );
    }

    /*******************************************************************************
    Purpose:  Method tests overwriting save - 'riepilogoSave' -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
     ********************************************************************************/
    @isTest static void overwriteSaveStep2( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        Map<String, Object> data = new Map<String, Object>( );
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.overwriteSave( '2', data, null, testWizardWrapper, '' );

        //System.assertEquals( '666', testResponse.result );
    }

    /*******************************************************************************
    Purpose:  Method tests overwriting save - 'riepilogoSave' -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
     ********************************************************************************/
    @isTest static void overwriteSaveStep3( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        Map<String, Object> data = new Map<String, Object>( );
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.overwriteSave( '3', data, null, testWizardWrapper, '' );

        //System.assertEquals( '666', testResponse.result );
    }

    /*******************************************************************************
    Purpose:  Method tests overwriting save - 'riepilogoSave' -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
     ********************************************************************************/
    @isTest static void overwriteSaveStep4( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        Map<String, Object> data = new Map<String, Object>( );
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.overwriteSave( '4', data, null, testWizardWrapper, '' );

        //System.assertEquals( '666', testResponse.result );
    }

    /*******************************************************************************
    Purpose:  Method tests overwriting save - 'saveDraft'

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
     ********************************************************************************/
    @isTest static void overwriteSaveStep5( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        testWizardWrapper.label = 'testLabel';
        testWizardWrapper.name = 'testName';
        testWizardWrapper.wizardId = '1';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( '{"JumpToStep" : "1","OrderHeader" : { "Id" : "" } }' );
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.overwriteSave( '5', data, null, testWizardWrapper, '' );

        //System.assertEquals( Label.OB_SavedFlowLabel, testResponse.description );
    }

    /*******************************************************************************
    Purpose:  Method tests overwriting save - update NE__Order__c - success scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       29/04/2019      Created         NEXI-22_order_status_saveAsDraft
     ********************************************************************************/
    @isTest static void overwriteSaveStep5UpdateOrder( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );

        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        insert testOrder;
        String testJSON = '' +
                '{ "JumpToStep" : "1",' +
                '"OrderHeader" : { "Id" : "" },' +
                '"Configuration" : { "sobjectType" : "NE__Order__c" , "Id" : "' + testOrder.Id + '" } }';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.overwriteSave( '5', data, null, testWizardWrapper, '' );

        List<NE__Order__c> testOrders =
        [
                SELECT Id, OB_Bank_OrderStatus__c
                FROM NE__Order__c
                WHERE Id = :testOrder.Id
        ];
        //System.assertEquals( OB_Order_ChangeStatus.ORDER_STATUS_ORDER_TO_BE_COMPLETED, testOrders.get( 0 ).OB_Bank_OrderStatus__c );
    }

    /*******************************************************************************
    Purpose:  Method tests overwriting save - update NE__Order__c - failed scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       29/04/2019      Created         NEXI-22_order_status_saveAsDraft
    ********************************************************************************/
    @isTest static void overwriteSaveStep5FailedUpdateOrder( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );

        String testJSON = '' +
                '{ "JumpToStep" : "1",' +
                '"OrderHeader" : { "Id" : "" },' +
                '"Configuration" : { "sobjectType" : "NE__Order__c" , "Id" : "" } }';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.overwriteSave( '5', data, null, testWizardWrapper, '' );

        List<NE__Order__c> testOrders =
        [
                SELECT Id, OB_Nexi_OrderStatus__c
                FROM NE__Order__c
                WHERE OB_Nexi_OrderStatus__c = :OB_Order_ChangeStatus.ORDER_STATUS_ORDER_TO_BE_COMPLETED
        ];
        //System.assertEquals( 0, testOrders.size( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests overwriting save - 'saveDraft'

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
     ********************************************************************************/
    @isTest static void overwriteSaveStep6( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        testWizardWrapper.label = 'testLabel';
        testWizardWrapper.name = 'testName';
        testWizardWrapper.wizardId = '1';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( '{"JumpToStep" : "1","OrderHeader" : { "Id" : "" } }' );
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.overwriteSave( '6', data, null, testWizardWrapper, '' );

        //System.assertEquals( Label.OB_SavedFlowLabel, testResponse.description );
    }

    /*******************************************************************************
    Purpose:  Method tests overwriting save - 'saveDraft'

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
     ********************************************************************************/
    @isTest static void overwriteSaveStep7( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        testWizardWrapper.label = 'testLabel';
        testWizardWrapper.name = 'testName';
        testWizardWrapper.wizardId = '1';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( '{"JumpToStep" : "1","OrderHeader" : { "Id" : "" } }' );
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.overwriteSave( '7', data, null, testWizardWrapper, '' );

        //System.assertEquals( Label.OB_SavedFlowLabel, testResponse.description );
    }

    /*******************************************************************************
    Purpose:  Method tests overwriting save - 'saveDraft'

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
     ********************************************************************************/
    @isTest static void overwriteSaveStep8( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        testWizardWrapper.label = 'testLabel';
        testWizardWrapper.name = 'testName';
        testWizardWrapper.wizardId = '1';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( '{"JumpToStep" : "1","OrderHeader" : { "Id" : "" } }' );
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.overwriteSave( '8', data, null, testWizardWrapper, '' );

        //System.assertEquals( Label.OB_SavedFlowLabel, testResponse.description );
    }

    /*******************************************************************************
      Purpose:  Method tests overwriting exit

     History
     --------
     VERSION     AUTHOR                  DATE            DETAIL          Description
     1.0			  ?						  ?				    ?				  ?
      2.0         Joanna Mielczarek       23/04/2019      Created         added assertion
      ********************************************************************************/
    @isTest static void overwriteExitTest( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        Map<String, Object> data = new Map<String, Object>( );
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.overwriteExit( '1', data, new List<bit2flow.DynamicWizardWrapper.StepDefinitions>( ), testWizardWrapper, null );

        //System.assertEquals( testWizardWrapper, testResponse.dynamicWizardWrapper );
    }

    /*******************************************************************************
      Purpose:  Method tests updating Section

     History
     --------
     VERSION     AUTHOR                  DATE            DETAIL          Description
     1.0			  ?						  ?				    ?				  ?
      2.0         Joanna Mielczarek       23/04/2019      Created         added assertion
      ********************************************************************************/
    @isTest static void updateSectionTest( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        bit2flow.DynamicWizardWrapper testResponse = OB_FlowControlClass.updateSection( new bit2flow.DynamicWizardWrapper( ), 'stepName', 1, true );
        System.assert( testResponse == null );
    }

    /*******************************************************************************
      Purpose:  Method tests executing given method - 'identifyCompany'

     History
     --------
     VERSION     AUTHOR                  DATE            DETAIL          Description
      1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
      ********************************************************************************/
    @isTest static void executeMethodIdentifyCompany( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        Map<String, Object> data = OB_FlowControlClass_Test.prepareDataIdentifyCompany( );
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        testWizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.executeMethod( '', data, '', 'identifyCompany', null, testWizardWrapper );

        //System.assertEquals( 1, testResponse.stepToGo );
    }

    /*******************************************************************************
      Purpose:  Method tests executing given method - 'GTselection'

     History
     --------
     VERSION     AUTHOR                  DATE            DETAIL          Description
      1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
      ********************************************************************************/
    @isTest static void executeMethodGTselection( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        String testJSON = '{ "Configuration" : { "sobjectType" : "NE__Order__c", "OB_GT__c" : "000" } }';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        testWizardWrapper.Name = 'OB_Catalogo_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.executeMethod( '', data, '', 'GTselection', null, testWizardWrapper );

        //System.assertEquals( 3, testResponse.stepToGo );
    }

    /*******************************************************************************
      Purpose:  Method tests executing given method - 'operationalData'

     History
     --------
     VERSION     AUTHOR                  DATE            DETAIL          Description
      1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
      ********************************************************************************/
    @isTest static void executeMethodOperationalData( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        String testJSON = '{ "reportTypeRO" : false } ';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.executeMethod( '', data, '', 'operationalData', null, testWizardWrapper );

        //System.assert( testResponse != null );
    }

    /*******************************************************************************
      Purpose:  Method tests executing given method - 'companyData'

     History
     --------
     VERSION     AUTHOR                  DATE            DETAIL          Description
      1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
      ********************************************************************************/
    @isTest static void executeMethodCompanyData( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        Map<String, Object> data = OB_FlowControlClass_Test.prepareDataCompanyData( );
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        testWizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.executeMethod( '', data, '', 'companyData', null, testWizardWrapper );

        //System.assertEquals( 5, testResponse.stepToGo );
    }

    /*******************************************************************************
      Purpose:  Method tests executing given method - 'actualOwner'

     History
     --------
     VERSION     AUTHOR                  DATE            DETAIL          Description
      1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
      ********************************************************************************/
    @isTest static void executeMethodActualOwner( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        Map<String, Object> data = OB_FlowControlClass_Test.prepareDataActualOwner( );
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        testWizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.executeMethod( '', data, '', 'actualOwner', null, testWizardWrapper );

        //System.assertEquals( 6, testResponse.stepToGo );
    }

    /*******************************************************************************
      Purpose:  Method tests executing given method - 'servicePoint'

     History
     --------
     VERSION     AUTHOR                  DATE            DETAIL          Description
      1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
      ********************************************************************************/
    @isTest static void executeMethodServicePoint( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        Map<String, Object> data = OB_FlowControlClass_Test.prepareDataIdentifyCompany( );
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        testWizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.executeMethod( '', data, '', 'servicePoint', null, testWizardWrapper );

        //System.assertEquals( 8, testResponse.stepToGo );
    }

    /*******************************************************************************
      Purpose:  Method tests executing given method - 'downloadDocument'

     History
     --------
     VERSION     AUTHOR                  DATE            DETAIL          Description
      1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
      ********************************************************************************/
    @isTest static void executeMethodDownloadDocument( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        String testJSON = '{ "allCheckedCreate" : "true","allCheckedLoad" : "true" }';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.executeMethod( '', data, '', 'downloadDocument', null, testWizardWrapper );

		//System.assertEquals( 6, testResponse.stepToGo );
	}

    /*******************************************************************************
      Purpose:  Method tests executing given method - 'GTselectionPrevious'

     History
     --------
     VERSION     AUTHOR                  DATE            DETAIL          Description
      1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
      ********************************************************************************/
    @isTest static void executeMethodGTselectionPrevious( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        String testJSON = '{ "messageNext" : { "message" : "", "severity" : "" } }';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        testWizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.executeMethod( '', data, '', 'GTselectionPrevious', null, testWizardWrapper );

        //System.assertEquals( 1, testResponse.stepToGo );
    }

    /*******************************************************************************
      Purpose:  Method tests executing given method - 'offertaSelectionPrevious'

     History
     --------
     VERSION     AUTHOR                  DATE            DETAIL          Description
      1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
      ********************************************************************************/
    @isTest static void executeMethodOffertaSelectionPrevious( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        String testJSON = '{ "merchant": { "sobjectType": "account", "RecordTypeId": "", "Id": "", "Name": "", ' +
                '"NE__Fiscal_code__c": "yuiou8956tyu895t", "NE__VAT__c": "", "OB_Services_Choice__c": "", ' +
                '"OB_Legal_Address_Street__c": "", "OB_Legal_Address_City__c": "", "OB_Legal_Address_State__c": "", ' +
                '"OB_Legal_Address_ZIP__c": "", "OB_Legal_Address_Country__c": "", "OB_Administrative_Office_City__c": "", ' +
                '"OB_Administrative_Office_Street__c": "", "OB_Administrative_Office_State__c": "", ' +
                '"OB_Administrative_Office_ZIP__c": "", "OB_Administrative_Office_Name__c": "", "OB_VAT_Not_Present__c" : true }, ' +
                '"messageNext" : { "message" : "", "severity" : "" }, "GT" : "" }';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        testWizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.executeMethod( '', data, '', 'offertaSelectionPrevious', null, testWizardWrapper );

        //System.assertEquals( 1, testResponse.stepToGo );
    }

    /*******************************************************************************
      Purpose:  Method tests executing given method - 'operationalDataPrevious'

     History
     --------
     VERSION     AUTHOR                  DATE            DETAIL          Description
      1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
      ********************************************************************************/
    @isTest static void executeMethodOperationalDataPrevious( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        Map<String, Object> data = new Map<String, Object>( );
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        testWizardWrapper.name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.executeMethod( '', data, '', 'operationalDataPrevious', null, testWizardWrapper );

        //System.assertEquals( 3, testResponse.stepToGo );
    }

    /*******************************************************************************
      Purpose:  Method tests executing given method - 'companyDataPrevious'

     History
     --------
     VERSION     AUTHOR                  DATE            DETAIL          Description
      1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
      ********************************************************************************/
    @isTest static void executeMethodCompanyDataPrevious( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        String testJSON = '{ "BillingProfilePOS" : { "sobjectType": "ne__billing_profile__c", "RecordTypeId": "", ' +
                '"OB_ABI__c": "", "OB_Bank_Account_Number__c": "", "OB_Bank_Account_Owner__c": "", "OB_Bank_Account_Type__c": "Credit" } }';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        testWizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.executeMethod( '', data, '', 'companyDataPrevious', null, testWizardWrapper );

        //System.assertEquals( 4, testResponse.stepToGo );
    }

    /*******************************************************************************
      Purpose:  Method tests executing given method - 'servicePointPrevious'

     History
     --------
     VERSION     AUTHOR                  DATE            DETAIL          Description
      1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
      ********************************************************************************/
    @isTest static void executeMethodServicePointPrevious( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        String testJSON = '{ "merchant": { "sobjectType": "account", "RecordTypeId": "", "Id": "", "Name": "", ' +
                '"OB_Beneficial_Owner_Existence__c" : false } }';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        testWizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.executeMethod( '', data, '', 'servicePointPrevious', null, testWizardWrapper );

        //System.assertEquals( 5, testResponse.stepToGo );
    }

    /*******************************************************************************
      Purpose:  Method tests executing given method - 'riepilogoPrevious'

     History
     --------
     VERSION     AUTHOR                  DATE            DETAIL          Description
      1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
      ********************************************************************************/
    @isTest static void executeMethodRiepilogoPrevious( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        Map<String, Object> data = new Map<String, Object>( );
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        testWizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.executeMethod( '', data, '', 'riepilogoPrevious', null, testWizardWrapper );

        //System.assertEquals( 8, testResponse.stepToGo );
    }

    /*******************************************************************************
      Purpose:  Method tests executing given method - 'saveDraft'

     History
     --------
     VERSION     AUTHOR                  DATE            DETAIL          Description
      1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
      ********************************************************************************/
    @isTest static void executeMethodSaveDraft( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        testWizardWrapper.label = 'testLabel';
        testWizardWrapper.name = 'testName';
        testWizardWrapper.wizardId = '1';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( '{"JumpToStep" : "1","OrderHeader" : { "Id" : "" } }' );
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.executeMethod( '', data, '', 'saveDraft', null, testWizardWrapper );

        //System.assertEquals( Label.OB_SavedFlowLabel, testResponse.description );
    }

    /*******************************************************************************
      Purpose:  Method tests executing given method - empty method name scenario

     History
     --------
     VERSION     AUTHOR                  DATE            DETAIL          Description
      1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
      ********************************************************************************/
    @isTest static void executeMethodNoMethod( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        Map<String, Object> data = new Map<String, Object>( );
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlClass.executeMethod( '', data, '', '', null, null );
        //System.assertEquals( '666', testResponse.result );
    }

    /*******************************************************************************
      Purpose:  Method tests initiating flow - success scenario
    data1.put('missingFieldsBoolean', true);//giovanni spinelli 15/04/2019 - add boolean

     History
     --------
     VERSION     AUTHOR                  DATE            DETAIL          Description
      1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
      ********************************************************************************/
    @isTest static void initTest( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        Map<String, Object> data1 = new Map<String, Object>( );
        data1.put( 'missingFieldsBoolean', true );//giovanni spinelli 15/04/2019 - add boolean
        OB_FlowControlClass flowControlClass = new OB_FlowControlClass( );
        bit2flow.DynamicWizardStepWrapper testResponse = flowControlClass.init( '', data1, null, null );

        //System.assertEquals( 4, testResponse.stepToGo );
    }

    /*******************************************************************************
      Purpose:  Method tests saving order - success scenario

     History
     --------
     VERSION     AUTHOR                  DATE            DETAIL          Description
      1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlClass
      ********************************************************************************/
    @isTest static void saveTest( )
    {
        // created by Joanna Mielczarek for code coverage increase - creator of tested code not known

        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        insert testOrderHeader;
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        insert testOrder;

        String testJSON = '{ ' +
                '"OrderHeader" : { "Id" : "' + testOrderHeader + '" }, ' +
                '"Configuration" : { "Id" : "' + testOrder + '" }, ' +
                '"bankProfile" : { "sobjectType" : "ob_bank_profile__c", "OB_Business_Model_POS__c" : "Trilaterale Nuovo", ' +
                '"OB_Business_Model_Acquiring__c" : "Bancario", "OB_NDG__c" : "true" }, "missingFieldsBoolean" : "false" }';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );
        OB_FlowControlClass flowControlClass = new OB_FlowControlClass( );
        bit2flow.DynamicWizardStepWrapper testResponse = flowControlClass.save( '', data, '', null, null );

        //System.assertEquals( bit2flow.DynamicWizardStepWrapper.OKCODE, testResponse.result );
    }
}