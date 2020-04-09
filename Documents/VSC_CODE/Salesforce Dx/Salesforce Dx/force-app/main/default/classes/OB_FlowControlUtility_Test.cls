@isTest
public class OB_FlowControlUtility_Test
{

    private static final String testJSON_OFFERTA_SELECTION_PREVIOUS =
            '{ "merchant": { "sobjectType": "account", "RecordTypeId": "", "Id": "", "Name": "", ' +
                    '"NE__Fiscal_code__c": "yuiou8956tyu895t", "NE__VAT__c": "", "OB_Services_Choice__c": "", ' +
                    '"OB_Legal_Address_Street__c": "", "OB_Legal_Address_City__c": "", "OB_Legal_Address_State__c": "", ' +
                    '"OB_Legal_Address_ZIP__c": "", "OB_Legal_Address_Country__c": "", "OB_Administrative_Office_City__c": "", ' +
                    '"OB_Administrative_Office_Street__c": "", "OB_Administrative_Office_State__c": "", ' +
                    '"OB_Administrative_Office_ZIP__c": "", "OB_Administrative_Office_Name__c": "", "OB_VAT_Not_Present__c" : true }, ' +
                    '"messageNext" : { "message" : "", "severity" : "" }';

    /*******************************************************************************
    Purpose:  Method creates and inserts Account with Merchant Record Type
    Parameters: Id bankAccountId
    Returns: Account

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna  Mielczarek       09/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    private static Account getMerchantAccount( Id bankAccountId )
    {
        Account merchantAccount = OB_TestDataFactory.getAccount();
        merchantAccount.OB_Bank_owner__c = bankAccountId;
        merchantAccount.NE__Fiscal_code__c = 'MRAMRA80A01F205V';
        insert merchantAccount;

        return merchantAccount;
    }

    /*******************************************************************************
    Purpose:  Method creates and inserts Account with Bank Record Type
    Parameters: -
    Returns: Account

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       09/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    private static Account getBankAccount( )
    {
        Id recordTypeIdBank = Schema.SObjectType.Account.getRecordTypeInfosByName( ).get( OB_UtilityConstants.BANKRT ).getRecordTypeId( );

        Account bankAccount = OB_TestDataFactory.getAccount();
        bankAccount.RecordTypeId = recordTypeIdBank;
        insert bankAccount;

        return bankAccount;
    }

    /*******************************************************************************
    Purpose:  Method creates and inserts Contact with given params
    Parameters: Id recordTypeIdContact, Account merchantAccount, Account bankAccount
    Returns: Contact

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       09/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    private static Contact getContactActualBank( Id recordTypeIdContact, Account merchantAccount, Account bankAccount )
    {
        Contact contactsActualBank = OB_TestDataFactory.getContact( merchantAccount );
        contactsActualBank.RecordTypeId = recordTypeIdContact;
        contactsActualBank.OB_Bank__c = bankAccount.Id;
        insert contactsActualBank;

        return contactsActualBank;
    }

    /*******************************************************************************
    Purpose:  Method creates for test methods 'checkMandatoryValCheckCont'
    Parameters: -
    Returns: Contact

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       25/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    private static Contact getContact_CheckMandatory()
    {
        Contact testContact = new Contact( );
        testContact.OB_BypassValidation__c = true;
        testContact.FirstName = 'maria';
        testContact.LastName = 'maria';
        testContact.OB_Fiscal_Code__c = 'MRAMRA90H52F205X';
        testContact.OB_Sex__c = 'F';
        testContact.OB_Cadastral_Code__c = 'F205';
        testContact.OB_Country_Birth__c = 'ITA';

        return testContact;
    }

    /*******************************************************************************
    Purpose:  Method creates and inserts contacts with Titolare Effettivo record type
    Parameters: -
    Returns: List<Contact>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       09/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    private static List<Contact> getContacts( )
    {
        Id recordTypeIdTitEff = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.TITOLARE_EFFETTIVO ).getRecordTypeId( );

        Contact contact1 = new Contact( LastName = 'test lastname1',
                RecordTypeId = recordTypeIdTitEff );
        Contact contact2 = new Contact( LastName = 'test lastname2',
                RecordTypeId = recordTypeIdTitEff );
        Contact contact3 = new Contact( LastName = 'test lastname3',
                RecordTypeId = recordTypeIdTitEff );
        Contact contact4 = new Contact( LastName = 'test lastname4',
                RecordTypeId = recordTypeIdTitEff );
        Contact contact5 = new Contact( LastName = 'test lastname5',
                RecordTypeId = recordTypeIdTitEff );
        Contact contact6 = new Contact( LastName = 'test lastname6',
                RecordTypeId = recordTypeIdTitEff );
        insert contact1;
        insert contact2;
        insert contact3;
        insert contact4;
        insert contact5;
        insert contact6;

        List<Contact> contacts = new List<Contact> {contact1, contact2, contact3, contact4, contact5, contact6};
        return contacts;
    }

    /*******************************************************************************
    Purpose:  Method prepares data to test methods : 'identifyCompany' and 'servicePoint'
    Parameters: String bankAccountId, String NDG, String orderId, String merchantId, String MCC, String pvId,
                String pvAccount, String pvHours, Boolean isL3Required, String shopSign, Boolean correctCAB,
                String GTList, String contactsDetails, String errorMaps
    Returns: Map<String, Object>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       12/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    1.1         Kinga Fornal            08/08/2019      Updated         added OB_GT__c field
    ********************************************************************************/
    private static Map<String, Object> prepareDataToIdentifyCompanyTest( String bankAccountId, String NDG, String testOrderId,
            String merchantId, String MCC, String pvId, String pvAccount, String pvHours, Boolean isL3Required, String shopSign,
            Boolean correctCAB, String GTList, String contactsDetails, String errorMaps)
    {
        Account bankAccount = OB_FlowControlUtility_Test.getBankAccount( );
        Account merchantAccount = OB_FlowControlUtility_Test.getMerchantAccount( bankAccount.Id );

        String yearOfConstitutionCompany = String.valueOf( System.Today( ).year( ) );
        String testJSON =
                '{ "bank": { "sobjectType": "ob_bank_profile__c", "OB_ABI__c" : "' + bankAccount.OB_ABI__c + '", "OB_Business_Model_POS__c": "Trilaterale Nuovo", ' +
                        '"OB_Business_Model_Acquiring__c": "Bancario" }, ' +
                        '"isOperation" : "false",' +
                        '"user" : { "sobjectType": "ne__billing_profile__c", "RecordTypeId" : "", "OB_ABI__c" : "", "OB_CAB__c" : "00000", "OB_Bank_Account_Number__c": "", ' +
                        '"OB_Bank_Account_Owner__c": "' + bankAccount.Id + '", "OB_Bank_Account_Type__c": "Debit" }, ' +
                        '"bankProfile" : { "sobjectType" : "ob_bank_profile__c", "OB_Business_Model_POS__c" : "Trilaterale Nuovo", ' +
                        '"OB_Business_Model_Acquiring__c" : "Bancario", "OB_GT__c":"'+GTList+'", "OB_NDG__c" : "true" }, ' +
                        '"ExternalAccount": [{"OB_CustomerCodeClientCode__c": "123456","OB_Source__c": "EQUENS"}], ' +
                        '"actualBank" : "' + bankAccount.Id + '", ' + bankAccountId +
                        '"OrderHeader" : { "Id" : "", "OB_NDG__c" : "' + NDG + '" }, ' +
                        '"Configuration": { "sobjectType": "NE__Order__c", "Id" : "' + testOrderId + '", "OB_GT__c": "", "NE__Parameters__c" : "", "OB_ReceiptHeader__c" : "", "OB_ReceiptCity__c" : "" }, ' +
                        '"merchant": { "sobjectType": "account", "RecordTypeId": "' + merchantAccount.RecordTypeId + '", "Id": "' + merchantId + '", "AccountId": "", ' +
                        '"Name": "' + merchantAccount.Name + '", "NE__Fiscal_code__c": "ABCDEF12G34H567I", "NE__E_mail__c" : "test@gmail.com", ' +
                        '"OB_VAT_Not_Present__c":true, ' + // NEXI-116 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 26/07/2019
                        '"NE__Type__c" : "Small business", "Type" : "Customer", "Phone" : "+39-377-555-271", "NE__VAT__c" : "' + merchantAccount.NE__VAT__c + '", "OB_BypassValidation__c" : true, ' +
                        '"OB_Services_Choice__c": "", "OB_Legal_Address_Street__c": "stradaSedeLegale", "OB_Legal_Address_Street_Number__c" : "civicoSedeLegale", ' +
                        '"OB_Legal_Address_City__c": "comuneSedeLegale", "OB_Legal_Address_State__c": "provinciaSedeLegale", "OB_Legal_Address_ZIP__c": "", ' +
                        '"OB_Legal_Address_Country__c": "ITALIA", "OB_Administrative_Office_City__c": "", "OB_Administrative_Office_Street__c": "", ' +
                        '"OB_Administrative_Office_State__c": "", "OB_Administrative_Office_ZIP__c": "", "OB_Administrative_Office_Name__c": "" , ' +
                        '"OB_SAE_Code__c": "sae", "OB_Legal_Form__c": "FormaGiuridica", "OB_Bank__c" : "", "OB_DescriptionVATNotPresent__c" : "description", ' +
                        '"OB_Annual_Negotiated__c" : "100", "OB_Annual_Revenue__c" : "1000", "OB_Employees_Number__c" : "' + merchantAccount.OB_Employees_Number__c + '" }, ' +
                        '"order" : { "sobjectType": "ORDER", "RecordTypeId": "",  "orderId": "",  "OB_MCC__c": "' + MCC + '" }, ' +
                        '"order2" : { "sobjectType": "ORDER", "RecordTypeId": "",  "orderId": "",  "OB_MCC__c": "' + MCC + '" }, ' +
                        '"pv": { "Id" : "' + pvId + '", "sobjectType": "ne__service_point__c", "RecordTypeId": "", "NE__Account__c": "' + pvAccount + '", "Name": "pvName", "NE__Street__c": "strada", ' +
                        '"OB_Street_Number__c" : "1", "NE__Zip_Code__c": "000", "NE__City__c": "comune", "NE__Province__c": "province", "NE__Country__c": "ITALIA", ' +
                        '"OB_MCC__c": "0000", "OB_MCC_Description__c" : "description", "OB_Phone_Number__c" : "+39-377-555-271", "OB_Email__c": "test@gmail.com", ' +
                        '"OB_PEC__c": "", "NE__Type__c" : "PDR", "OB_Typology__c" : "Virtuale", ' +
                        '"OB_Opening_Monday_Morning__c": "true", "OB_Opening_Monday_Afternoon__c": "true", "OB_Opening_Thursday_Morning__c": "true", ' +
                        '"OB_Opening_Thursday_Afternoon__c": "true", "OB_Opening_Tuesday_Morning__c": "true", "OB_Opening_Tuesday_Afternoon__c": "true",' +
                        '"OB_Opening_Wednesday_Morning__c": "true", "OB_Opening_Wednesday_Afternoon__c": "true", "OB_Opening_Friday_Morning__c": "true", ' +
                        '"OB_Opening_Friday_Afternoon__c": "true", "OB_Opening_Saturday_Morning__c": "true", "OB_Opening_Saturday_Afternoon__c": "true", ' +
                        '"OB_Opening_Sunday_Morning__c": "true", "OB_Opening_Sunday_Afternoon__c": "true" ' + pvHours + '},' +
                        '"isL3Required" : ' + isL3Required + ', "shopSign" : "' + shopSign + '", "correctCAB" : ' + correctCAB + ',' +
                        '"unbind": { "sobjectType": "UNBIND", "RecordTypeId": "", "nextCheckout": "", "nextCheck": "", "orderId": "", "UNBIND7": "ACQUIRING", ' +
                        '"UNBIND5": "", "UNBIND6": "", "yearOfConstitutionCompany": "' + yearOfConstitutionCompany + '", "InsegnaPv" : "", "DenominazioneSociale" : "" },' +
                        '"isCommunityUser" : true, "GT" : "' + GTList + '", ' +
                        '"sede_legale" : { "Id" : "", "OB_BypassValidation__c" : true, "AccountId" : "", "RecordTypeId" : "", "OB_Bank__c" : "", "LastName" : "" , ' +
                        '"Phone" : "", "Email" : "" }, ' +
                        '"BillingProfilePOS" : { "sobjectType": "ne__billing_profile__c", "RecordTypeId": "", "OB_ABI__c": "", "OB_Bank_Account_Number__c": "", ' +
                        '"OB_Bank_Account_Owner__c": "", "OB_Bank_Account_Type__c": "Credit", "OB_ABICode__c" : "" }' +
                        contactsDetails +
                        errorMaps + '}';
        Map<String, Object> testData = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );

        return testData;
    }

    /*******************************************************************************
    Purpose:  Method prepares data to test method : 'companyData'
    Parameters: String SAE, String legaleRappresentanteId, String fiscalCode, String contactCountryBirth, String documentDetails,
                String sedeLegaleId, String yearOfConstitutionCompany, String errorMap
    Returns: Map<String, Object>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       12/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    private static Map<String, Object> prepareDataToCompanyDataTest( String SAE, String legaleRappresentanteId, String fiscalCode,
            String contactCountryBirth, String documentDetails, String sedeLegaleId, String yearOfConstitutionCompany, String errorMap, String legalForm, String vatNotPresent, String vatNotPresentDescription, String recordTypeId, String executorRecordTypeId, String role, String roleDevName )
    {
        Account bankAccount = OB_FlowControlUtility_Test.getBankAccount( );
        Account merchantAccount = OB_FlowControlUtility_Test.getMerchantAccount( bankAccount.Id );

        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        insert testOrderHeader;

        NE__Order__c testOrder = OB_TestDataFactory.getOrder( testOrderHeader );
        insert testOrder;

        NE__Product__c testProduct = new NE__Product__c( );
        testProduct.OB_Codice_sfdc__c = 'VISAMASTERCARD';
        insert testProduct;

        NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
        testOrderItem.NE__Action__c = 'Add';
        testOrderItem.NE__ProdId__c = testProduct.Id;
        insert testOrderItem;

        NE__Lov__c testLov = new NE__Lov__c();
        testLov.NE__Type__c = contactCountryBirth;
        testLov.Name = 'ITALY';
        insert testLov;

        String testJSON =
                '{ "isLegalEqualAdm": true, ' +
                        '"bankOwner" : "' + bankAccount.Id + '", ' +
                        '"bank": { "sobjectType": "ob_bank_profile__c","OB_ABI__c" : "05451", "OB_Business_Model_POS__c": "Trilaterale Nuovo", "OB_Business_Model_Acquiring__c": "Bancario" }, ' +
                        '"user" : { "sobjectType": "ne__billing_profile__c", "RecordTypeId" : "", "OB_ABI__c" : "05123", "OB_CAB__c" : "00000", "OB_Bank_Account_Number__c": "", ' +
                        '"OB_Bank_Account_Owner__c": "", "OB_Bank_Account_Type__c": "Debit" }, ' +
                        '"bankProfile" : { "sobjectType" : "ob_bank_profile__c", "OB_Business_Model_POS__c" : "Trilaterale Nuovo", "OB_Business_Model_Acquiring__c" : "Bancario", ' +
                        '"OB_NDG__c" : "true" }, ' +
                        '"actualBank" : "' + bankAccount.Id + '", ' +
                        '"OrderHeader" : { "Id" : "' + testOrderHeader.Id + '" }, ' +
                        '"Configuration": { "sobjectType": "NE__Order__c", "Id" : "' + testOrder.Id + '", "OB_GT__c": "" }, ' +
                        '"ExternalAccount": [{"OB_CustomerCodeClientCode__c": "123456","OB_Source__c": "EQUENS"}], ' +
                        '"merchant": { "sobjectType": "account", "RecordTypeId": "", "Id": "' + merchantAccount.Id + '", "AccountId": "", "Name": "' + merchantAccount.Name +
                        '", "NE__Fiscal_code__c": "yuiou8956tyu895t", "NE__VAT__c": "","OB_VAT_Not_Present__c":"' + vatNotPresent + '", "OB_DescriptionVATNotPresent__c":"' + vatNotPresentDescription + '", "OB_Services_Choice__c": "", "OB_Legal_Address_Street__c": "stradaSedeLegale", ' +
                        '"OB_Legal_Address_Street_Number__c" : "civicoSedeLegale", "OB_Legal_Address_City__c": "comuneSedeLegale", "OB_Legal_Address_State__c": "provinciaSedeLegale", ' +
                        '"OB_Legal_Address_ZIP__c": "", "OB_Legal_Address_Country__c": "ITALIA", "OB_Administrative_Office_City__c": "", "OB_Administrative_Office_Street__c": "", ' +
                        '"OB_Administrative_Office_State__c": "", "OB_Administrative_Office_ZIP__c": "", "OB_Administrative_Office_Name__c": "" , "OB_VAT_Not_Present__c" : true, ' +
                        '"OB_SAE_Code__c": "' + SAE + '", "OB_Legal_Form__c": "' + legalForm + '", "OB_Bank__c" : "", "OB_Annual_Negotiated__c" : "100", "OB_Annual_Revenue__c" : "1000", ' +
                        '"OB_Employees_Number__c" : "' + merchantAccount.OB_Employees_Number__c + '" }, ' +
                        '"order" : { "sobjectType": "ORDER", "RecordTypeId": "",  "orderId": "",  "OB_MCC__c": "" }, ' +
                        '"order2" : { "sobjectType": "ORDER", "RecordTypeId": "",  "orderId": "",  "OB_MCC__c": "" }, ' +
                        '"legale_rappresentante": { "sobjectType": "contact", "RecordTypeId": "' + recordTypeId + '", "Id": "' + legaleRappresentanteId + '", "FirstName": "maria", "LastName": "maria", "OB_Fiscal_Code__c": "' + fiscalCode + '", ' +
                        '"OB_Sex__c": "F", "Role__c":"' + role + '","OB_Country_Birth_Code__c":"ITA","RecordType":{"Id":"' + executorRecordTypeId +'","DeveloperName":"' + roleDevName +'"},  "OB_Cadastral_Code__c" : "F205", "OB_SkipCadastralCodeCheck__c" : true, "Role__c": "aa", "OB_Birth_Date__c": "1990-06-12", "OB_Birth_State__c": "aa", ' +
                        '"OB_Birth_City__c": "aa", "OB_Country_Birth__c" : "' + contactCountryBirth + '", ' + documentDetails + '"OB_Document_Release_Country__c" : "ITALIA", "OB_Document_Release_City__c": "aa", ' +
                        '"OB_Document_Release_State__c": "provinciaSedeLegale", "OB_Address_State__c": "provinciaSedeLegale", "OB_Address_Country__c" : "ITALIA", "OB_Address_City__c": "comuneSedeLegale", ' +
                        '"OB_Address_Street__c": "stradaSedeLegale", "OB_Address_Street_Number__c": "civicoSedeLegale" }, ' +
                        '"sede_legale" : { "Id" : "' + sedeLegaleId + '", "OB_BypassValidation__c" : true, "AccountId" : "", "RecordTypeId" : "", "OB_Bank__c" : "", "LastName" : "" }, ' +
                        '"unbind": { "sobjectType": "UNBIND", "RecordTypeId": "", "nextCheckout": "", "nextCheck": "", "orderId": "", "UNBIND7": "ACQUIRING", ' +
                        '"UNBIND5": "", "UNBIND6": "", "yearOfConstitutionCompany": "' + yearOfConstitutionCompany + '" }' + errorMap + ' }';
        Map<String, Object> testData = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );

        return testData;
    }

    /*******************************************************************************
    Purpose:  Method prepares data to test method : 'actualOwner'
    Parameters: Integer indexContact
    Returns: Map<String, Object>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       10/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    1.1         Kinga Fornal            08/08/2019      Updated         added OB_Document_Release_Country_Code__c field
    ********************************************************************************/
    private static Map<String, Object> prepareDataToActualOwnerTest( Integer indexContact, List<Contact> contacts, String documentNumber )
    {
        Account bankAccount = OB_FlowControlUtility_Test.getBankAccount( );
        Account merchantAccount = OB_FlowControlUtility_Test.getMerchantAccount( bankAccount.Id );

        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        insert testOrderHeader;

        NE__Order__c testOrder = OB_TestDataFactory.getOrder( testOrderHeader );
        insert testOrder;

        NE__Lov__c testLov = new NE__Lov__c();
        testLov.NE__Type__c = 'COUNTRY';
        testLov.Name = 'ITALY';
        insert testLov;

        String listContactsInactive =  !contacts.isEmpty( ) ? ', "ListContactsInactive" : [ "' + contacts.get( 5 ).Id + '" ]' : '';
        Id recordTypeIdTitEff = !contacts.isEmpty( ) ? contacts.get( 0 ).RecordTypeId : null;
        Integer thisYear = Date.today( ).year( );
        String testJSON =
                '{ ' +
                        '"lastContact" : ' + indexContact + ', ' +
                        '"Configuration" : { "sobjectType" : "NE__Order__c" , "OB_GT__c" : "" }, ' +
                        '"errorFamily" : { "key1" : false }, ' +
                        '"bankProfile" : { "sobjectType" : "ob_bank_profile__c", "OB_Business_Model_POS__c" : "Trilaterale Nuovo", "OB_Business_Model_Acquiring__c" : "Bancario", ' +
                        '"OB_NDG__c" : "true" }, ' +
                        '"actualBank" : "' + bankAccount.Id + '", ' +
                        '"OrderHeader" : { "Id" : "' + testOrderHeader.Id + '" }, ' +
                        '"Configuration": { "sobjectType": "NE__Order__c", "Id" : "' + testOrder.Id + '", "OB_GT__c": "" }, ' +
                        '"merchant": { "sobjectType": "account", "RecordTypeId": "", "Id": "' + merchantAccount.Id + '", "AccountId": "", "Name": "' + merchantAccount.Name +
                        '", "NE__Fiscal_code__c": "yuiou8956tyu895t", "NE__VAT__c": "", "OB_Services_Choice__c": "", "OB_Legal_Address_Street__c": "stradaSedeLegale", ' +
                        '"OB_Legal_Address_Street_Number__c" : "civicoSedeLegale", "OB_Legal_Address_City__c": "comuneSedeLegale", "OB_Legal_Address_State__c": "provinciaSedeLegale", ' +
                        '"OB_Legal_Address_ZIP__c": "", "OB_Legal_Address_Country__c": "ITALIA", "OB_Administrative_Office_City__c": "", "OB_Administrative_Office_Street__c": "", ' +
                        '"OB_Administrative_Office_State__c": "", "OB_Administrative_Office_ZIP__c": "", "OB_Administrative_Office_Name__c": "" , "OB_VAT_Not_Present__c" : true, ' +
                        '"OB_SAE_Code__c": "sae", "OB_Legal_Form__c": "FormaGiuridica", "OB_Bank__c" : "", "OB_Annual_Negotiated__c" : "100", "OB_Annual_Revenue__c" : "1000", ' +
                        '"OB_Employees_Number__c" : "' + merchantAccount.OB_Employees_Number__c + '" }' + listContactsInactive + ', ';

        for ( Integer i = 0; i < 6; i++ )
        {
            String contactId = !contacts.isEmpty( ) ? '"' + contacts.get( i ).Id + '"' : '""';
            testJSON +=
                    '"contact' + ( i + 1 ) + '" : { "Id" : ' + contactId + ', "FirstName": "maria", "LastName": "maria", ' +
                            '"OB_Fiscal_Code__c" : "MRAMRA90H52F205X", "OB_Sex__c": "F", "OB_Cadastral_Code__c" : "F205", "OB_SkipCadastralCodeCheck__c" : true, ' +
                            '"Role__c": "aa", "OB_Birth_Date__c" : "1990-06-12", "OB_Birth_State__c" : "aa", "OB_Birth_City__c" : "aa", "OB_Country_Birth__c" : "ITALY", ' +
                            '"sobjectType" : "contact", "RecordTypeId" : "' + recordTypeIdTitEff + '", "AccountId" : "", "OB_Document_Type__c" : "' + OB_UtilityConstants.CARTA_DI_IDENTITA + '", ' +
                            '"OB_Document_Number__c": "' + documentNumber + '", "OB_Document_Release_Authority__c": "' + OB_UtilityConstants.COMUNE + '", ' +
                            '"OB_Document_Release_Date__c": "' + String.valueOf( Date.newInstance( thisYear - 1, 6, 13 ) ) + '", ' +
                            '"OB_Document_Expiration_Date__c": "' + String.valueOf( Date.newInstance( thisYear + 10, 6, 12 ) ) + '","OB_Document_Release_City__c":"city", ' +
                            '"OB_Document_Release_Country__c" : "ITALIA", "OB_Document_Release_Country_Code__c" : "ITA", "OB_Document_Release_State__c" : "state", "OB_Address_Country__c" : "ITALIA", ' +
                            '"OB_Address_State__c": "provinciaSedeLegale", "OB_Address_City__c": "comuneSedeLegale", "OB_Address_Street__c": "stradaSedeLegale", ' +
                            '"OB_Address_Street_Number__c": "civicoSedeLegale" } ';
            if ( i < 5 )
            {
                testJSON += ', ';
            }

        }
        testJSON += ' }';

        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );

        return data;
    }

    /*******************************************************************************
    Purpose:  Method prepares data to test method : 'actualOwner' with invalid data
    Parameters: Integer lastContact
    Returns: bit2flow.DynamicWizardStepWrapper

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       10/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    private static bit2flow.DynamicWizardStepWrapper prepareDataToActualOwnerWithInvalidData( Integer lastContact )
    {
        String testJSON =
                '{ ' +
                        '"lastContact" : ' + lastContact + ', ' +
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
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.actualOwner( '', data, null, '', '', wizardWrapper );

        return testResponse;
    }

    /*******************************************************************************
    Purpose:  Method tests that value is decimal - scenario - success

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       03/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void isNumeric_isTrue( )
    {
        System.assert( OB_FlowControlUtility.isNumeric( '1.1' ) == true );
    }

    /*******************************************************************************
    Purpose:  Method tests that value is not decimal - scenario - failed

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       03/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void isNumeric_isFalse( )
    {
        System.assert( OB_FlowControlUtility.isNumeric( 'a' ) == false );
    }

    /*******************************************************************************
    Purpose:  Method tests that value is null - scenario - failed

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       03/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void isNumeric_isNull( )
    {
        System.assert( OB_FlowControlUtility.isNumeric( '' ) == false );
    }

    /*******************************************************************************
    Purpose:  Method tests getting step value - scenario - ConfigurationInformation and step have values - scenario - success

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       03/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void getStepMapping_hasValue( )
    {
        System.assert( OB_FlowControlUtility.getStepMapping( 'OB_Nuovo_Contratto', 'IDENTIFICA_SOCIETA' ).equals( '1' ) );
    }

    /*******************************************************************************
    Purpose:  Method tests getting step value - scenario - no ConfigurationInformation and no step - scenario - failed

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       03/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void getStepMapping_isNull( )
    {
        System.assert( OB_FlowControlUtility.getStepMapping( 'testFlow', 'testName' ) == null );
    }

    /*******************************************************************************
    Purpose:  Method checks value of 'step to go' - 'Offerta' step - scenario - success

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       10/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void identifyCompanyTest_OffertaStep( )
    {
        Account bankAccount = OB_FlowControlUtility_Test.getBankAccount( );
        Account merchantAccount = OB_FlowControlUtility_Test.getMerchantAccount( bankAccount.Id );
        String pvHours = ', "OB_Opening_Time__c" : "08:00:00.276Z", "OB_Ending_Time__c" : "20:00:00.276Z", ' +
                '"OB_Break_Start_Time__c" : "12:00:00.276Z", "OB_Break_End_Time__c" : "13:00:00.276Z"';
        Map<String, Object> testData = OB_FlowControlUtility_Test.prepareDataToIdentifyCompanyTest(
                '', 'true', '', String.valueOf( merchantAccount.Id ), '0000', '', '', pvHours, false, '000', true, '00', '', '');
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testStepWrapper = OB_FlowControlUtility.identifyCompany ( '', testData, null, '', '', wizardWrapper );

        System.assertEquals( 3, testStepWrapper.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method checks value of 'step to go' - 'GT' step - scenario - success

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       10/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void identifyCompanyTest_GTStep( )
    {
        Account bankAccount = OB_FlowControlUtility_Test.getBankAccount( );
        Account merchantAccount = OB_FlowControlUtility_Test.getMerchantAccount( bankAccount.Id );
        Id rtStd = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        Asset testAsset = new Asset();
        testAsset.Name = 'test';
        testAsset.AccountId = merchantAccount.Id;
        testAsset.RecordTypeId = rtStd;
        insert testAsset;
        Map<String, Object> testData = OB_FlowControlUtility_Test.prepareDataToIdentifyCompanyTest(
                '"bankOwner" : "' + bankAccount.Id + '", ', 'true', '', String.valueOf( merchantAccount.Id ), '0000', '', String.valueOf( bankAccount.Id ), '', true, '000', true, '00;01;02', '', '' );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testStepWrapper = OB_FlowControlUtility.identifyCompany ( '', testData, null, '', '', wizardWrapper );

        System.assertEquals( 2, testStepWrapper.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method checks value of 'step to go' - 'Identifica Societa' step - scenario - success - empty merchant Id

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       10/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void identifyCompany_GTStep_EmptyMerchantId( )
    {
        Account bankAccount = OB_FlowControlUtility_Test.getBankAccount( );
        Map<String, Object> testData = OB_FlowControlUtility_Test.prepareDataToIdentifyCompanyTest(
                '"bankOwner" : "' + bankAccount.Id + '", ', 'true', '', '', '0000',  '', '', '', false, '000', true, '00;01', '', '' );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testStepWrapper = OB_FlowControlUtility.identifyCompany ( '', testData, null, '', '', wizardWrapper );

        System.assertEquals( 2, testStepWrapper.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method checks value of 'step to go' - 'Identifica Societa' step -
              scenario - failed - empty merchant Id

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       18/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void identifyCompany_IdentificaSocietaStep_PVActuallyExist( )
    {
        Account bankAccount = OB_FlowControlUtility_Test.getBankAccount( );
        Account merchantAccount = OB_FlowControlUtility_Test.getMerchantAccount( bankAccount.Id );

        NE__Service_Point__c testServicePoint = new NE__Service_Point__c();
        testServicePoint.OB_MCC_Description__c = 'description';
        testServicePoint.NE__Province__c = 'province';
        testServicePoint.NE__City__c = 'comune';
        testServicePoint.NE__Street__c = 'strada';
        testServicePoint.OB_Street_Number__c = '1';
        testServicePoint.NE__Zip_Code__c = '000';
        testServicePoint.NE__Account__c = merchantAccount.Id;
        insert testServicePoint;

        Map<String, Object> testData = OB_FlowControlUtility_Test.prepareDataToIdentifyCompanyTest(
                '"bankOwner" : "' + bankAccount.Id + '", ', 'true', '', String.valueOf( merchantAccount.Id ), '', String.valueOf( bankAccount.Id ), '', '', false, '000', true, '00', '', '');
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testStepWrapper = OB_FlowControlUtility.identifyCompany ( '', testData, null, '', '', wizardWrapper );

        System.assertEquals( 1, testStepWrapper.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method checks value of 'step to go' - 'Identifica Societa' step -
              scenario - failed - empty merchant Id, long shop sign, invalid NDG

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       17/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void identifyCompany_IdentificaSocietaStep_InvalidData( )
    {
        Account bankAccount = OB_FlowControlUtility_Test.getBankAccount( );
        Account merchantAccount = OB_FlowControlUtility_Test.getMerchantAccount( bankAccount.Id );
        String pvHours = ', "OB_Opening_Time__c" : "08:00:00.276Z", "OB_Ending_Time__c" : "20:00:00.276Z", ' +
                '"OB_Break_Start_Time__c" : "10:00:00.276Z", "OB_Break_End_Time__c" : "11:00:00.276Z"';
        Map<String, Object> testData = OB_FlowControlUtility_Test.prepareDataToIdentifyCompanyTest(
                '', 'true!', '', String.valueOf( merchantAccount.Id ), '', '','', pvHours, true, '00000000000000000000000', true, '00', '', '');
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testStepWrapper = OB_FlowControlUtility.identifyCompany ( '', testData, null, '', '', wizardWrapper );

        System.assertEquals( 1, testStepWrapper.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method checks value of 'step to go' - 'Identifica Societa' step -
              scenario - failed - Mandatory Formal Check method fails

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       16/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void identifyCompany_IdentificaSocietaStep_MandatoryFormalCheckFails( )
    {
        String testJSON =
                '{ "bank": { "sobjectType": "ob_bank_profile__c", "OB_ABI__c" : "", "OB_Business_Model_POS__c": "", ' +
                        '"OB_Business_Model_Acquiring__c": "Bancario" }, ' +
                        '"isOperation" : "false",' +
                        '"user" : { "sobjectType": "ne__billing_profile__c", "RecordTypeId" : "", "OB_ABI__c" : "", "OB_CAB__c" : "", ' +
                        '"OB_Bank_Account_Number__c": "", "OB_Bank_Account_Owner__c": "", "OB_Bank_Account_Type__c": "" }, ' +
                        '"bankProfile" : { "sobjectType" : "ob_bank_profile__c", "OB_Business_Model_POS__c" : "", ' +
                        '"OB_Business_Model_Acquiring__c" : "", "OB_NDG__c" : "" }, ' +
                        '"actualBank" : "", ' +
                        '"OrderHeader" : { "Id" : "", "OB_NDG__c" : "" }, ' +
                        '"Configuration": { "sobjectType": "NE__Order__c", "Id" : "" }, ' +
                        '"order" : { "OB_MCC__c" : "" }, ' +
                        '"order2" : { "OB_MCC__c" : "" }, ' +
                        '"merchant": { "sobjectType": "account", "RecordTypeId": "", "Id": "", "AccountId": "", "Name": "" }, ' +
                        '"pv": { "Id" : "", "sobjectType": "ne__service_point__c", "RecordTypeId": "", "NE__Account__c": "", "Name": "pvName" },' +
                        '"isL3Required" : true, "correctCAB" : false }';
        Map<String, Object> testData = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testStepWrapper = OB_FlowControlUtility.identifyCompany ( '', testData, null, '', '', wizardWrapper );

        System.assertEquals( 1, testStepWrapper.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method checks value of 'step to go' - 'Identifica Societa' step -
              scenario - failed - with filled Error Map

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       16/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void identifyCompany_IdentificaSocietaStep_ErrorMap( )
    {
        Account bankAccount = OB_FlowControlUtility_Test.getBankAccount( );
        Account merchantAccount = OB_FlowControlUtility_Test.getMerchantAccount( bankAccount.Id );
        String pvHours = ', "OB_Opening_Time__c" : "08:00:00.276Z", "OB_Ending_Time__c" : "20:00:00.276Z", ' +
                '"OB_Break_Start_Time__c" : "12:00:00.276Z", "OB_Break_End_Time__c" : "13:00:00.276Z"';
        Map<String, Object> testData = OB_FlowControlUtility_Test.prepareDataToIdentifyCompanyTest(
                '', '!', '', '','', '', '', pvHours, false, '00', true, '00', '', ', "errorEEMap" : { "key1" : true, "key2" : false}, "errorFamily" : { "key1": true }' );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testStepWrapper = OB_FlowControlUtility.identifyCompany ( '', testData, null, '', '', wizardWrapper );

        System.assertEquals( 1, testStepWrapper.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method checks value of 'step to go' - 'Identifica Societa' step -
              scenario - failed - generic error

      History
      --------
      VERSION     AUTHOR                  DATE            DETAIL          Description
      1.0         Joanna Mielczarek       18/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
      2.0         Wojciech Szuba          09/07/2019      Modified        NEXI-116 Fix, change assertion
      ********************************************************************************/
    @isTest static void identifyCompany_IdentificaSocietaStep_Exception( )
    {
        String testJSON =
                '{ "bank": { "sobjectType": "ob_bank_profile__c", "OB_ABI__c" : "", "OB_Business_Model_POS__c": "", ' +
                        '"OB_Business_Model_Acquiring__c": "Bancario" }, ' +
                        '"isOperation" : "false",' +
                        '"user" : { "sobjectType": "ne__billing_profile__c", "RecordTypeId" : "", "OB_ABI__c" : "", "OB_CAB__c" : "", ' +
                        '"OB_Bank_Account_Number__c": "", "OB_Bank_Account_Owner__c": "", "OB_Bank_Account_Type__c": "" }, ' +
                        '"bankProfile" : { "sobjectType" : "ob_bank_profile__c", "OB_Business_Model_POS__c" : "", ' +
                        '"OB_Business_Model_Acquiring__c" : "", "OB_NDG__c" : "" }, ' +
                        '"actualBank" : "", ' +
                        '"OrderHeader" : { "Id" : "", "OB_NDG__c" : "" }, ' +
                        '"Configuration": { "sobjectType": "NE__Order__c", "Id" : "" }, ' +
                        '"order" : { }, ' +
                        '"order2" : { }, ' +
                        '"merchant": { "sobjectType": "account", "RecordTypeId": "", "Id": "", "AccountId": "", "Name": "" }, ' +
                        '"pv": { "Id" : "", "sobjectType": "ne__service_point__c", "RecordTypeId": "", "NE__Account__c": "", "Name": "pvName" },' +
                        '"isL3Required" : true, "correctCAB" : false }';
        Map<String, Object> testData = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testStepWrapper = OB_FlowControlUtility.identifyCompany ( '', testData, null, '', '', wizardWrapper );

        System.assertEquals( '666', testStepWrapper.result );
    }

    /*******************************************************************************
    Purpose:  Method checks validation check for 'Identifica Societa' step -
              scenario - failed - inserted field will not pass validation

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Szuba          01/07/2019      Created         -
    ********************************************************************************/
    @isTest static void identifyCompany_Wrong_MCCL2_Test( )
    {
        Account bankAccount = OB_FlowControlUtility_Test.getBankAccount( );
        Account merchantAccount = OB_FlowControlUtility_Test.getMerchantAccount( bankAccount.Id );
        merchantAccount.OB_VAT_Not_Present__c = true;
        merchantAccount.OB_DescriptionVATNotPresent__c = 'Bed & Breakfast';
        String pvHours = ', "OB_Opening_Time__c" : "08:00:00.276Z", "OB_Ending_Time__c" : "20:00:00.276Z", ' +
                '"OB_Break_Start_Time__c" : "12:00:00.276Z", "OB_Break_End_Time__c" : "13:00:00.276Z"';
        String yearOfConstitutionCompany = String.valueOf( System.Today( ).year( ) );
        String testJSON =
                '{ "bank": { "sobjectType": "ob_bank_profile__c", "OB_ABI__c" : "' + bankAccount.OB_ABI__c + '", "OB_Business_Model_POS__c": "Trilaterale Nuovo", ' +
                        '"OB_Business_Model_Acquiring__c": "Bancario" }, ' +
                        '"isOperation" : "false",' +
                        '"user" : { "sobjectType": "ne__billing_profile__c", "RecordTypeId" : "", "OB_ABI__c" : "", "OB_CAB__c" : "00000", "OB_Bank_Account_Number__c": "", ' +
                        '"OB_Bank_Account_Owner__c": "' + bankAccount.Id + '", "OB_Bank_Account_Type__c": "Debit" }, ' +
                        '"bankProfile" : { "sobjectType" : "ob_bank_profile__c", "OB_Business_Model_POS__c" : "Trilaterale Nuovo", ' +
                        '"OB_Business_Model_Acquiring__c" : "Bancario", "OB_NDG__c" : "true" }, ' +
                        '"ExternalAccount": [{"OB_CustomerCodeClientCode__c": "123456","OB_Source__c": "EQUENS"}], ' +
                        '"actualBank" : "' + bankAccount.Id + '", ' +
                        '' +
                        '"OrderHeader" : { "Id" : "", "OB_NDG__c" : "' + '!' + '" }, ' +
                        '"Configuration": { "sobjectType": "NE__Order__c", "Id" : "' + '' + '", "OB_GT__c": "", "NE__Parameters__c" : "", "OB_ReceiptHeader__c" : "", "OB_ReceiptCity__c" : "" }, ' +
                        '"merchant": { "sobjectType": "account", "RecordTypeId": "' + merchantAccount.RecordTypeId + '", "Id": "' + '' + '", "AccountId": "", ' +
                        '"Name": "' + merchantAccount.Name + '", "NE__Fiscal_code__c": "ABCDEF12G34H567I", "NE__E_mail__c" : "test@gmail.com", ' +
                        '"NE__Type__c" : "Small business", "Type" : "Customer", "Phone" : "+39-377-555-271", "NE__VAT__c" : "' + merchantAccount.NE__VAT__c + '", "OB_BypassValidation__c" : true, ' +
                        '"OB_Services_Choice__c": "", "OB_Legal_Address_Street__c": "stradaSedeLegale", "OB_Legal_Address_Street_Number__c" : "civicoSedeLegale", ' +
                        '"OB_Legal_Address_City__c": "comuneSedeLegale", "OB_Legal_Address_State__c": "provinciaSedeLegale", "OB_Legal_Address_ZIP__c": "", ' +
                        '"OB_Legal_Address_Country__c": "ITALIA", "OB_Administrative_Office_City__c": "", "OB_Administrative_Office_Street__c": "", ' +
                        '"OB_Administrative_Office_State__c": "", "OB_Administrative_Office_ZIP__c": "", "OB_Administrative_Office_Name__c": "" , ' +
                        '"OB_SAE_Code__c": "sae", "OB_Legal_Form__c": "FormaGiuridica", "OB_Bank__c" : "", "OB_DescriptionVATNotPresent__c" : "Bed & Breakfast", ' +
                        '"OB_VAT_Not_Present__c" : ' + true + ', "OB_Annual_Negotiated__c" : "100", "OB_Annual_Revenue__c" : "1000", "OB_Employees_Number__c" : "' + merchantAccount.OB_Employees_Number__c + '" }, ' +
                        '"order" : { "sobjectType": "ORDER", "RecordTypeId": "",  "orderId": "",  "OB_MCC__c": "' + '' + '" }, ' +
                        '"order2" : { "sobjectType": "ORDER", "RecordTypeId": "",  "orderId": "",  "OB_MCC__c": "' + '' + '" }, ' +
                        '"pv": { "Id" : "' + '' + '", "sobjectType": "ne__service_point__c", "RecordTypeId": "", "NE__Account__c": "' + '' + '", "Name": "pvName", "NE__Street__c": "strada", ' +
                        '"OB_Street_Number__c" : "1", "NE__Zip_Code__c": "000", "NE__City__c": "comune", "NE__Province__c": "province", "NE__Country__c": "ITALIA", ' +
                        '"OB_MCC__c": "0004", "OB_MCC_Description__c" : "description", "OB_Phone_Number__c" : "+39-377-555-271", "OB_Email__c": "test@gmail.com", ' +
                        '"OB_PEC__c": "", "NE__Type__c" : "PDR", "OB_Typology__c" : "Virtuale", ' +
                        '"OB_Opening_Monday_Morning__c": "true", "OB_Opening_Monday_Afternoon__c": "true", "OB_Opening_Thursday_Morning__c": "true", ' +
                        '"OB_Opening_Thursday_Afternoon__c": "true", "OB_Opening_Tuesday_Morning__c": "true", "OB_Opening_Tuesday_Afternoon__c": "true",' +
                        '"OB_Opening_Wednesday_Morning__c": "true", "OB_Opening_Wednesday_Afternoon__c": "true", "OB_Opening_Friday_Morning__c": "true", ' +
                        '"OB_Opening_Friday_Afternoon__c": "true", "OB_Opening_Saturday_Morning__c": "true", "OB_Opening_Saturday_Afternoon__c": "true", ' +
                        '"OB_Opening_Sunday_Morning__c": "true", "OB_Opening_Sunday_Afternoon__c": "true" ' + pvHours + '},' +
                        '"isL3Required" : ' + false + ', "shopSign" : "' + '00' + '", "correctCAB" : ' + true + ',' +
                        '"unbind": { "sobjectType": "UNBIND", "RecordTypeId": "", "nextCheckout": "", "nextCheck": "", "orderId": "", "UNBIND7": "ACQUIRING", ' +
                        '"UNBIND5": "", "UNBIND6": "", "yearOfConstitutionCompany": "' + yearOfConstitutionCompany + '", "InsegnaPv" : "", "DenominazioneSociale" : "" },' +
                        '"isCommunityUser" : true, "GT" : "' + '00' + '", ' +
                        '"sede_legale" : { "Id" : "", "OB_BypassValidation__c" : true, "AccountId" : "", "RecordTypeId" : "", "OB_Bank__c" : "", "LastName" : "" , ' +
                        '"Phone" : "", "Email" : "" }, ' +
                        '"BillingProfilePOS" : { "sobjectType": "ne__billing_profile__c", "RecordTypeId": "", "OB_ABI__c": "", "OB_Bank_Account_Number__c": "", ' +
                        '"OB_Bank_Account_Owner__c": "", "OB_Bank_Account_Type__c": "Credit", "OB_ABICode__c" : "" }' +
                        '' +
                        ', "errorEEMap" : { "key1" : true, "key2" : false}, "errorFamily" : { "key1": true }' + '}';
        Map<String, Object> testData = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = OB_UtilityConstants.FLOW_WIZARD_NAME_NUOVO_CONTRATTO;
        bit2flow.DynamicWizardStepWrapper testStepWrapper = OB_FlowControlUtility.identifyCompany ( '', testData, null, '', '', wizardWrapper );
        Object testResult = testData.get( 'isMCCL2Wrong' );
        System.assertEquals( true, testResult );
    }

    /*******************************************************************************
     Purpose:  Method checks value of 'step to go' - 'Offerta' step - scenario - success

     History
     --------
     VERSION     AUTHOR                  DATE            DETAIL          Description
     1.0         Joanna Mielczarek       11/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
     ********************************************************************************/
    @isTest static void GTselection_OffertaStep( )
    {
        String testJSON = '{ "Configuration" : { "sobjectType" : "NE__Order__c", "OB_GT__c" : "000" } }';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Catalogo_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.GTselection( '', data, null, '', '', wizardWrapper );

        System.assertEquals( 3, testResponse.stepToGo );
    }

    /*******************************************************************************
     Purpose:  Method checks value of 'step to go' - 'GT' step - scenario - failed

     History
     --------
     VERSION     AUTHOR                  DATE            DETAIL          Description
     1.0         Joanna Mielczarek       11/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
     ********************************************************************************/
    @isTest static void GTselection_GTStep( )
    {
        String testJSON = '{ "Configuration" : { "sobjectType" : "NE__Order__c", "OB_GT__c" : "" } }';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Catalogo_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.GTselection( '', data, null, '', '', wizardWrapper );

        System.assertEquals( 2, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests returning DynamicWizardStepWrapper - scenario - success

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         ?                       ?               Created         -
    2.0         Joanna Mielczarek       11/04/2019      Updated         Added assertion
    ********************************************************************************/
    @isTest static void operationalData_Success( )
    {
        String step = 'operationalData';
        String testJSON = '{ "reportTypeRO" : false } ';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.operationalData( step, data, null, '', '', wizardWrapper );

        System.assert( testResponse != null );
    }

    /*******************************************************************************
    Purpose:  Method checks value of 'step to go' - 'Titolare Effettivo' step -
              scenario - success - with Carta di Identita document type

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       10/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void companyData_TitolareEffettivoStep_CartaDiIdentita( )
    {
        Account testAccount = OB_TestDataFactory.getAccount( );
        insert testAccount;
        Contact testContact1 = OB_TestDataFactory.getContact( testAccount );
        insert testContact1;
        Contact testContact2 = OB_TestDataFactory.getContact( testAccount );
        insert testContact2;

        Integer thisYear = Date.today( ).year( );
        String documentDetails = '"OB_Document_Type__c": "' + OB_UtilityConstants.CARTA_DI_IDENTITA + '", ' +
                '"OB_Document_Number__c": "1231231231", "OB_Document_Release_Authority__c": "' + OB_UtilityConstants.COMUNE + '", ' +
                '"OB_Document_Release_Date__c": "' + String.valueOf( Date.newInstance( thisYear - 1, 6, 13 ) ) + '", ' +
                '"OB_Document_Expiration_Date__c": "' + String.valueOf( Date.newInstance( thisYear + 10, 6, 12 ) ) + '", ';
        Map<String, Object> data = OB_FlowControlUtility_Test.prepareDataToCompanyDataTest(
                '000', String.valueOf( testContact1.Id ), 'MRAMRA90H52F205X', 'ITALIA', documentDetails,
                String.valueOf( testContact2.Id ), String.valueOf( thisYear ), '', '', '', '', '', '', '', '' );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.companyData( '1', data, null, '', '', wizardWrapper );

        //System.assertEquals( 6, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method checks value of 'step to go' - 'Titolare Effettivo' step -
              scenario - success - with Passaporto document type

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       10/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void companyData_TitolareEffettivoStep_Passaporto( )
    {
        Integer thisYear = Date.today( ).year( );
        String documentDetails = '"OB_Document_Type__c": "' + OB_UtilityConstants.PASSAPORTO + '", "OB_Document_Number__c": "AB1234567", ' +
                '"OB_Document_Release_Authority__c": "' + OB_UtilityConstants.QUESTURA + '", ' +
                '"OB_Document_Release_Date__c": "' + String.valueOf( Date.newInstance( thisYear - 1, 6, 11 ) ) + '", ' +
                '"OB_Document_Expiration_Date__c": "' + String.valueOf( Date.newInstance( thisYear + 9, 6, 12 ) ) + '", ';
        Map<String, Object> data = OB_FlowControlUtility_Test.prepareDataToCompanyDataTest(
                '000', '', 'MRAMRA90H52F205X', 'ITALIA', documentDetails, '', String.valueOf( thisYear ), '', '', '', '', '', '', '', '' );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.companyData( '1', data, null, '', '', wizardWrapper );

        //System.assertEquals( 6, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method checks value of 'step to go' - 'Titolare Effettivo' step -
              scenario - success - with Patente document type

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       10/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void companyData_TitolareEffettivoStep_Patente( )
    {
        Integer thisYear = Date.today( ).year( );
        String documentDetails = '"OB_Document_Type__c": "' + OB_UtilityConstants.PATENTE + '", "OB_Document_Number__c": "MM00MM00MM", ' +
                '"OB_Document_Release_Authority__c": "' + OB_UtilityConstants.UCO + '", ' +
                '"OB_Document_Release_Date__c": "' + String.valueOf( Date.newInstance( thisYear - 1, 6, 13 ) ) + '", ' +
                '"OB_Document_Expiration_Date__c": "' + String.valueOf( Date.newInstance( thisYear + 9, 6, 12 ) ) + '", ';
        Map<String, Object> data = OB_FlowControlUtility_Test.prepareDataToCompanyDataTest(
                '000', '', 'MRAMRA90H52F205X', 'ITALIA', documentDetails, '', String.valueOf( thisYear ), '', '', '', '', '', '', '', '' );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.companyData( '1', data, null, '', '', wizardWrapper );

        //System.assertEquals( 6, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method checks value of 'step to go' - 'Dati Societa' step -
              scenario - failed - with filled Error Map

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       17/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void companyData_DatiSocieta_ErrorMap( )
    {
        Integer thisYear = Date.today( ).year( );
        String documentDetails = '"OB_Document_Type__c": "' + OB_UtilityConstants.CARTA_DI_IDENTITA + '", ' +
                '"OB_Document_Number__c": "12312312", "OB_Document_Release_Authority__c": "' + OB_UtilityConstants.QUESTURA + '", ' +
                '"OB_Document_Release_Date__c": "' + String.valueOf( Date.newInstance( thisYear, 6, 11 ) ) + '", ' +
                '"OB_Document_Expiration_Date__c": "' + String.valueOf( Date.newInstance( thisYear + 9, 6, 12 ) ) + '", ';
        Map<String, Object> data = OB_FlowControlUtility_Test.prepareDataToCompanyDataTest(
                '999', '', 'MRAMRA90H52F205X', 'ITA', documentDetails, '', String.valueOf( thisYear + 1 ), ', "errorEEMap" : { "key1" : true, "key2" : false }', '', '', '', '', '', '', '' );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.companyData( '1', data, null, '', '', wizardWrapper );

        System.assertEquals( 5, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method checks value of 'step to go' - 'Dati Societa' step -
              scenario - failed - with invalid birth data

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       17/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void companyData_DatiSocieta_ErrorData( )
    {
        Integer thisYear = Date.today( ).year( );
        String documentDetails = '"OB_Document_Type__c": "' + OB_UtilityConstants.CARTA_DI_IDENTITA + '", ' +
                '"OB_Document_Number__c": "1231231231", "OB_Document_Release_Authority__c": "' + OB_UtilityConstants.COMUNE + '", ' +
                '"OB_Document_Release_Date__c": "' + String.valueOf( Date.newInstance( thisYear - 1, 6, 13 ) ) + '", ' +
                '"OB_Document_Expiration_Date__c": "' + String.valueOf( Date.newInstance( thisYear + 10, 6, 12 ) ) + '", ';
        Map<String, Object> data = OB_FlowControlUtility_Test.prepareDataToCompanyDataTest(
                '000', '', 'MRAMRA80H52F205X', 'ITA', documentDetails, '', String.valueOf( thisYear + 1 ), '', '', '', '', '', '', '', '' );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.companyData( '1', data, null, '', '', wizardWrapper );

        System.assertEquals( 5, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method checks value of 'step to go' - 'Dati Societa' step -
              scenario - failed - with invalid surname

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       17/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void companyData_DatiSocieta_ErrorSurname( )
    {
        Integer thisYear = Date.today( ).year( );
        String documentDetails = '"OB_Document_Type__c": "' + OB_UtilityConstants.CARTA_DI_IDENTITA + '", ' +
                '"OB_Document_Number__c": "1231231231", "OB_Document_Release_Authority__c": "' + OB_UtilityConstants.COMUNE + '", ' +
                '"OB_Document_Release_Date__c": "' + String.valueOf( Date.newInstance( 2011, 6, 13 ) ) + '", ' +
                '"OB_Document_Expiration_Date__c": "' + String.valueOf( Date.newInstance( thisYear - 1, 6, 12 ) ) + '", ';
        Map<String, Object> data = OB_FlowControlUtility_Test.prepareDataToCompanyDataTest(
                '000', '', 'MRRMRA80H52F205X', 'ITA', documentDetails, '', String.valueOf( thisYear + 1 ), '', '', '', '', '', '', '', '' );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.companyData( '1', data, null, '', '', wizardWrapper );

        System.assertEquals( 5, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method checks value of 'step to go' - 'Dati Societa' step -
              scenario - failed - with invalid gender

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       17/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void companyData_DatiSocieta_ErrorGender( )
    {
        Integer thisYear = Date.today( ).year( );
        String documentDetails = '"OB_Document_Type__c": "' + OB_UtilityConstants.CARTA_DI_IDENTITA + '", ' +
                '"OB_Document_Number__c": "1231231231", "OB_Document_Release_Authority__c": "' + OB_UtilityConstants.COMUNE + '", ' +
                '"OB_Document_Release_Date__c": "' + String.valueOf( Date.newInstance( thisYear - 1, 7, 13 ) ) + '", ' +
                '"OB_Document_Expiration_Date__c": "' + String.valueOf( Date.newInstance( thisYear + 11, 6, 12 ) ) + '", ';
        Map<String, Object> data = OB_FlowControlUtility_Test.prepareDataToCompanyDataTest(
                '000', '', 'MRAMRA90M12F205X', 'ITA', documentDetails, '', String.valueOf( thisYear + 1 ), '', '', '', '', '', '', '', '' );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.companyData( '1', data, null, '', '', wizardWrapper );

        System.assertEquals( 5, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method checks value of 'step to go' - 'Dati Societa' step -
              scenario - failed - with invalid last char

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       17/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void companyData_DatiSocietaStep_ErrorLastChar( )
    {
        Integer thisYear = Date.today( ).year( );
        String documentDetails = '"OB_Document_Type__c": "' + OB_UtilityConstants.CARTA_DI_IDENTITA + '", ' +
                '"OB_Document_Number__c": "1231231231", "OB_Document_Release_Authority__c": "' + OB_UtilityConstants.COMUNE + '", ' +
                '"OB_Document_Release_Date__c": "' + String.valueOf( Date.newInstance( thisYear - 1, 6, 13 ) ) + '", ' +
                '"OB_Document_Expiration_Date__c": "' + String.valueOf( Date.newInstance( thisYear + 10, 6, 12 ) ) + '", ';
        Map<String, Object> data = OB_FlowControlUtility_Test.prepareDataToCompanyDataTest(
                '000', '', 'MRAMRA90H52F205A', 'ITA', documentDetails, '', String.valueOf( thisYear + 1 ), '', '', '', '', '', '', '', '' );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.companyData( '1', data, null, '', '', wizardWrapper );

        System.assertEquals( 5, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method checks value of 'step to go' - 'Dati Societa' step -
              scenario - failed - Mandatory Formal Check method fails

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Monika  Kocot       03/07/2019      Created         OB_FlowControlUtility check if Account FC lenght equals 16 and is only alphanumeric when the legal form of the account is within given picklist
    ********************************************************************************/
    @isTest static void companyData_DatiSocietaStep_CheckAccountFCWithLegalForm( )
    {
        String SAE = '000';
        String legaleRappresentanteId = '';
        String fiscalCode = 'MRAMRA90H52F205A';
        String contactCountryBirth = 'ITA';
        Integer thisYear = Date.today( ).year( );
        String documentDetails = '"OB_Document_Type__c": "' + OB_UtilityConstants.PATENTE + '", ' +
                '"OB_Document_Number__c": "12312312", "OB_Document_Release_Authority__c": "' + OB_UtilityConstants.QUESTURA + '", ' +
                '"OB_Document_Release_Date__c": "' + String.valueOf( Date.newInstance( thisYear, 6, 11 ) ) + '", ' +
                '"OB_Document_Expiration_Date__c": "' + String.valueOf( Date.newInstance( thisYear - 1, 6, 12 ) ) + '", ';
        String sedeLegaleId = '';
        String yearOfConstitutionCompany = String.valueOf( thisYear + 1 );
        String errorMap = '';
        Account bankAccount = OB_FlowControlUtility_Test.getBankAccount( );
        Account merchantAccount = OB_FlowControlUtility_Test.getMerchantAccount( bankAccount.Id );

        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        insert testOrderHeader;

        NE__Order__c testOrder = OB_TestDataFactory.getOrder( testOrderHeader );
        insert testOrder;

        NE__Product__c testProduct = new NE__Product__c( );
        testProduct.OB_Codice_sfdc__c = 'VISAMASTERCARD';
        insert testProduct;

        NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
        testOrderItem.NE__Action__c = 'Add';
        testOrderItem.NE__ProdId__c = testProduct.Id;
        insert testOrderItem;

        NE__Lov__c testLov = new NE__Lov__c();
        testLov.NE__Type__c = contactCountryBirth;
        testLov.Name = 'ITALY';
        insert testLov;

        String testJSON =
                '{ "isLegalEqualAdm": true, ' +
                        '"bankOwner" : "' + bankAccount.Id + '", ' +
                        '"bank": { "sobjectType": "ob_bank_profile__c", "OB_Business_Model_POS__c": "Trilaterale Nuovo", "OB_Business_Model_Acquiring__c": "Bancario" }, ' +
                        '"user" : { "sobjectType": "ne__billing_profile__c", "RecordTypeId" : "", "OB_ABI__c" : "", "OB_CAB__c" : "00000", "OB_Bank_Account_Number__c": "", ' +
                        '"OB_Bank_Account_Owner__c": "", "OB_Bank_Account_Type__c": "Debit" }, ' +
                        '"bankProfile" : { "sobjectType" : "ob_bank_profile__c", "OB_Business_Model_POS__c" : "Trilaterale Nuovo", "OB_Business_Model_Acquiring__c" : "Bancario", ' +
                        '"OB_NDG__c" : "true" }, ' +
                        '"actualBank" : "' + bankAccount.Id + '", ' +
                        '"OrderHeader" : { "Id" : "' + testOrderHeader.Id + '" }, ' +
                        '"Configuration": { "sobjectType": "NE__Order__c", "Id" : "' + testOrder.Id + '", "OB_GT__c": "" }, ' +
                        '"ExternalAccount": [{"OB_CustomerCodeClientCode__c": "123456","OB_Source__c": "EQUENS"}], ' +
                        '"merchant": { "sobjectType": "account", "RecordTypeId": "", "Id": "' + merchantAccount.Id + '", "AccountId": "", "Name": "' + merchantAccount.Name +
                        '", "NE__Fiscal_code__c": "yuiou8956tyu895t!2", "NE__VAT__c": "","OB_VAT_Not_Present__c":"false", "OB_Services_Choice__c": "", "OB_Legal_Address_Street__c": "stradaSedeLegale", ' +
                        '"OB_Legal_Address_Street_Number__c" : "civicoSedeLegale","OB_DescriptionVATNotPresent__c":"Livigno", "OB_Legal_Address_City__c": "comuneSedeLegale", "OB_Legal_Address_State__c": "provinciaSedeLegale", ' +
                        '"OB_Legal_Address_ZIP__c": "", "OB_Legal_Address_Country__c": "ITALIA", "OB_Administrative_Office_City__c": "", "OB_Administrative_Office_Street__c": "", ' +
                        '"OB_Administrative_Office_State__c": "", "OB_Administrative_Office_ZIP__c": "", "OB_Administrative_Office_Name__c": "" , "OB_VAT_Not_Present__c" : true, ' +
                        '"OB_SAE_Code__c": "' + SAE + '", "OB_Legal_Form__c": "Ditta Individuale", "OB_Bank__c" : "", "OB_Annual_Negotiated__c" : "100", "OB_Annual_Revenue__c" : "1000", ' +
                        '"OB_Employees_Number__c" : "' + merchantAccount.OB_Employees_Number__c + '" }, ' +
                        '"order" : { "sobjectType": "ORDER", "RecordTypeId": "",  "orderId": "",  "OB_MCC__c": "" }, ' +
                        '"order2" : { "sobjectType": "ORDER", "RecordTypeId": "",  "orderId": "",  "OB_MCC__c": "" }, ' +
                        '"legale_rappresentante": { "sobjectType": "contact", "RecordTypeId": "0129E000000AkaNQAS", "Id": "' + legaleRappresentanteId + '", "FirstName": "maria", "LastName": "maria", "OB_Fiscal_Code__c": "' + fiscalCode + '", ' +
                        '"OB_Sex__c": "F","Role__c":"Esecutore","OB_Country_Birth_Code__c":"ITA","RecordType":{"Id":"0129E000000AkaNQAS","DeveloperName":"Esecutore"}, "OB_Cadastral_Code__c" : "F205", "OB_SkipCadastralCodeCheck__c" : true, "Role__c": "aa", "OB_Birth_Date__c": "1990-06-12", "OB_Birth_State__c": "aa", ' +
                        '"OB_Birth_City__c": "aa", "OB_Country_Birth__c" : "' + contactCountryBirth + '", ' + documentDetails + '"OB_Document_Release_Country__c" : "ITALIA", "OB_Document_Release_City__c": "aa", ' +
                        '"OB_Document_Release_State__c": "provinciaSedeLegale", "OB_Address_State__c": "provinciaSedeLegale", "OB_Address_Country__c" : "ITALIA", "OB_Address_City__c": "comuneSedeLegale", ' +
                        '"OB_Address_Street__c": "stradaSedeLegale", "OB_Address_Street_Number__c": "civicoSedeLegale" }, ' +
                        '"sede_legale" : { "Id" : "' + sedeLegaleId + '", "OB_BypassValidation__c" : true, "AccountId" : "", "RecordTypeId" : "", "OB_Bank__c" : "", "LastName" : "" }, ' +
                        '"unbind": { "sobjectType": "UNBIND", "RecordTypeId": "", "nextCheckout": "", "nextCheck": "", "orderId": "", "UNBIND7": "ACQUIRING", ' +
                        '"UNBIND5": "", "UNBIND6": "", "yearOfConstitutionCompany": "' + yearOfConstitutionCompany + '" }' + errorMap + ' }';
        Map<String, Object> testData = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );

        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = OB_UtilityConstants.FLOW_WIZARD_NAME_NUOVO_CONTRATTO;
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.companyData( '', testData, null, '', '', wizardWrapper );
        String testString = JSON.serialize( testResponse.data );
        System.assertNotEquals(testResponse, null);
        System.assertEquals( 5, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method checks value of 'step to go' - 'Dati Societa' step -
              scenario - failed - Mandatory Formal Check method fails

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Damian Krzyzaniak       02/07/2019      Created         NEXI-123 OB_FlowControlUtility check if Contact(Executor RT) FC is the same as Account FC when the legal form of the account is within given picklist
    ********************************************************************************/
    @isTest static void companyDataDatiSocietaStepCheckContactAndAccountFCWithLegalFormTest( )
    {
        Integer thisYear = Date.today( ).year( );
        String documentDetails = '"OB_Document_Type__c": "' + OB_UtilityConstants.CARTA_DI_IDENTITA + '", ' +
                '"OB_Document_Number__c": "1231231231", "OB_Document_Release_Authority__c": "' + OB_UtilityConstants.COMUNE + '", ' +
                '"OB_Document_Release_Date__c": "' + String.valueOf( Date.newInstance( thisYear - 1, 6, 13 ) ) + '", ' +
                '"OB_Document_Expiration_Date__c": "' + String.valueOf( Date.newInstance( thisYear + 10, 6, 12 ) ) + '", ';
        Map<String, Object> testData = OB_FlowControlUtility_Test.prepareDataToCompanyDataTest(
                '000', '', 'MRAMRA90H52F205X', 'ITALIA', documentDetails,
                '', String.valueOf( thisYear ), '', OB_UtilityConstants.DITTA_INDIVIDUALE, 'true', 'test', '0129E000000AkaNQAS', '0129E000000AkaNQAS', 'Esecutore', 'Esecutore' );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        Test.startTest( );
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.companyData( '', testData, null, '', '', wizardWrapper );
        Test.stopTest( );
        String testString = JSON.serialize( testResponse.data );
        System.assertNotEquals( testResponse, null );
        // System.assert( testString.containsIgnoreCase( Label.OB_SetupExecutorFCInvalid ) );
        System.assertEquals( 5, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method checks value of method isFCCompatibilityCheckRequired when legal form is not in set

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Damian Krzyzaniak       03/07/2019      Created         NEXI-123 OB_FlowControlUtility.isFCCompatibilityCheckRequiredFalseCase method test with legal form not in set
    ********************************************************************************/
    @isTest static void isFCCompatibilityCheckRequiredLegalFormNotInSetTest( )
    {
        Boolean legalFormNotInSet = OB_FlowControlUtility.isFCCompatibilityCheckRequired( 'testlegalform' );
        System.assertEquals( false, legalFormNotInSet );
    }

    /*******************************************************************************
    Purpose:  Method checks value of method isFCCompatibilityCheckRequired when legal form is blank

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Damian Krzyzaniak       05/07/2019      Created         NEXI-123 OB_FlowControlUtility.isFCCompatibilityCheckRequiredFalseCase method test with empty legal form
    ********************************************************************************/
    @isTest static void isFCCompatibilityCheckRequiredLegalFormBlankTest( )
    {
        Boolean blankForm = OB_FlowControlUtility.isFCCompatibilityCheckRequired( '' );
        System.assertEquals( false, blankForm );
    }

    /*******************************************************************************
    Purpose:  Method checks value of 'step to go' - 'Dati Societa' step -
              scenario - failed - with invalid document data of Passaporto

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       17/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void companyData_DatiSocietaStep_Passaporto_InvalidData( )
    {
        Integer thisYear = Date.today( ).year( );
        String documentDetails = '"OB_Document_Type__c": "' + OB_UtilityConstants.PASSAPORTO + '", ' +
                '"OB_Document_Number__c": "12312312", "OB_Document_Release_Authority__c": "' + OB_UtilityConstants.COMUNE + '", ' +
                '"OB_Document_Release_Date__c": "' + String.valueOf( Date.newInstance( thisYear, 6, 11 ) ) + '", ' +
                '"OB_Document_Expiration_Date__c": "' + String.valueOf( Date.newInstance( thisYear + 9, 6, 12 ) ) + '", ';
        Map<String, Object> data = OB_FlowControlUtility_Test.prepareDataToCompanyDataTest(
                '999', '', 'MRAMRA90H52F205X', 'ITA', documentDetails, '', String.valueOf( thisYear + 1 ), '', '', '', '', '', '', '', '' );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.companyData( '1', data, null, '', '', wizardWrapper );

        System.assertEquals( 5, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method checks value of 'step to go' - 'Dati Societa' step -
              scenario - failed - with invalid document data of Patente

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       17/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void companyData_DatiSocietaStep_Patente_InvalidData( )
    {
        Integer thisYear = Date.today( ).year( );
        String documentDetails = '"OB_Document_Type__c": "' + OB_UtilityConstants.PATENTE + '", ' +
                '"OB_Document_Number__c": "12312312", "OB_Document_Release_Authority__c": "' + OB_UtilityConstants.QUESTURA + '", ' +
                '"OB_Document_Release_Date__c": "' + String.valueOf( Date.newInstance( thisYear, 6, 11 ) ) + '", ' +
                '"OB_Document_Expiration_Date__c": "' + String.valueOf( Date.newInstance( thisYear - 1, 6, 12 ) ) + '", ';
        Map<String, Object> data = OB_FlowControlUtility_Test.prepareDataToCompanyDataTest(
                '999', '', 'MRAMRA90H52F205X', 'ITA', documentDetails, '', String.valueOf( thisYear + 1 ), '', '', '', '', '', '', '', '' );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.companyData( '1', data, null, '', '', wizardWrapper );

        System.assertEquals( 5, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method checks value of 'step to go' - 'Dati Societa' step -
              scenario - failed - Mandatory Formal Check method fails

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0      Joanna Mielczarek       10/04/2019        Created          R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void companyData_DatiSocietaStep_MandatoryFormalCheckFails( )
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
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.companyData( '', testData, null, '', '', wizardWrapper );

        System.assertEquals( 5, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests saving actual owner of service point and value of 'step to go' -
              scenario - success - 'Punto Vendita' step and contact1

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       16/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void actualOwner_Contact1( )
    {
        List<Contact> contacts = OB_FlowControlUtility_Test.getContacts( );
        Map<String, Object> data = OB_FlowControlUtility_Test.prepareDataToActualOwnerTest( 1, contacts, '1231231231' );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.actualOwner( '', data, null, '', '', wizardWrapper );

        System.assertEquals( 6, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests saving actual owner of service point and value of 'step to go' -
              scenario - success - 'Punto Vendita' step and contact1's empty Id

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       18/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void actualOwner_Contact1_EmptyContactList( )
    {
        List<Contact> contacts = new List<Contact>( );
        Map<String, Object> data = OB_FlowControlUtility_Test.prepareDataToActualOwnerTest( 1, contacts, '1231231231' );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.actualOwner( '', data, null, '', '', wizardWrapper );

        //System.assertEquals( 7, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests saving actual owner of service point and value of 'step to go' -
              scenario - success - 'Punto Vendita' step and contact2

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       16/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void actualOwner_Contact2( )
    {
        List<Contact> contacts = OB_FlowControlUtility_Test.getContacts( );
        Map<String, Object> data = OB_FlowControlUtility_Test.prepareDataToActualOwnerTest( 2, contacts, '1231231231' );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.actualOwner( '', data, null, '', '', wizardWrapper );

        System.assertEquals( 6, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests saving actual owner of service point and value of 'step to go' -
              scenario - success - 'Punto Vendita' step and contact2's empty Id

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       18/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void actualOwner_Contact2_EmptyContactList( )
    {
        List<Contact> contacts = new List<Contact>( );
        Map<String, Object> data = OB_FlowControlUtility_Test.prepareDataToActualOwnerTest( 2, contacts, '1231231231' );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.actualOwner( '', data, null, '', '', wizardWrapper );

        //System.assertEquals( 7, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests saving actual owner of service point and value of 'step to go' -
              scenario - success - 'Punto Vendita' step and contact3

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       16/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void actualOwner_Contact3( )
    {
        List<Contact> contacts = OB_FlowControlUtility_Test.getContacts( );
        Map<String, Object> data = OB_FlowControlUtility_Test.prepareDataToActualOwnerTest( 3, contacts, '1231231231' );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.actualOwner( '', data, null, '', '', wizardWrapper );

        System.assertEquals( 6, testResponse.stepToGo );
    }


    /*******************************************************************************
    Purpose:  Method tests saving actual owner of service point and value of 'step to go' -
              scenario - success - 'Punto Vendita' step and contact3's empty Id

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       18/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void actualOwner_Contact3_EmptyContactList( )
    {
        List<Contact> contacts = new List<Contact>( );
        Map<String, Object> data = OB_FlowControlUtility_Test.prepareDataToActualOwnerTest( 3, contacts, '1231231231' );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.actualOwner( '', data, null, '', '', wizardWrapper );

        //System.assertEquals( 7, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests saving actual owner of service point and value of 'step to go' -
              scenario - success - 'Punto Vendita' step and contact4

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       16/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void actualOwner_Contact4( )
    {
        List<Contact> contacts = OB_FlowControlUtility_Test.getContacts( );
        Map<String, Object> data = OB_FlowControlUtility_Test.prepareDataToActualOwnerTest( 4, contacts, '1231231231' );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.actualOwner( '', data, null, '', '', wizardWrapper );

        System.assertEquals( 6, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests saving actual owner of service point and value of 'step to go' -
              scenario - success - 'Punto Vendita' step and contact4's empty Id

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       18/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void actualOwner_Contact4_EmptyContactList( )
    {
        List<Contact> contacts = new List<Contact>( );
        Map<String, Object> data = OB_FlowControlUtility_Test.prepareDataToActualOwnerTest( 4, contacts, '1231231231' );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.actualOwner( '', data, null, '', '', wizardWrapper );

        //System.assertEquals( 7, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests saving actual owner of service point and value of 'step to go' -
              scenario - success - 'Punto Vendita' step and contact5

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       16/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void actualOwner_Contact5( )
    {
        List<Contact> contacts = OB_FlowControlUtility_Test.getContacts( );
        Map<String, Object> data = OB_FlowControlUtility_Test.prepareDataToActualOwnerTest( 5, contacts, '1231231231' );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.actualOwner( '', data, null, '', '', wizardWrapper );

        System.assertEquals( 6, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests saving actual owner of service point and value of 'step to go' -
              scenario - success - 'Punto Vendita' step and contact5's empty Id

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       18/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void actualOwner_Contact5_EmptyContactList( )
    {
        List<Contact> contacts = new List<Contact>( );
        Map<String, Object> data = OB_FlowControlUtility_Test.prepareDataToActualOwnerTest( 5, contacts, '1231231231' );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.actualOwner( '', data, null, '', '', wizardWrapper );

        //System.assertEquals( 7, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests saving actual owner of service point and value of 'step to go' -
              scenario - success - 'Punto Vendita' step and contact6
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       16/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void actualOwner_Contact6( )
    {
        List<Contact> contacts = OB_FlowControlUtility_Test.getContacts( );
        Map<String, Object> data = OB_FlowControlUtility_Test.prepareDataToActualOwnerTest( 6, contacts, '1231231231' );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.actualOwner( '', data, null, '', '', wizardWrapper );

        System.assertEquals( 6, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests saving actual owner of service point and value of 'step to go' -
              scenario - success - 'Punto Vendita' step and contact6's empty Id

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       16/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void actualOwner_Contact6_EmptyContactList( )
    {
        List<Contact> contacts = new List<Contact>( );
        Map<String, Object> data = OB_FlowControlUtility_Test.prepareDataToActualOwnerTest( 6, contacts, '1231231231' );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.actualOwner( '', data, null, '', '', wizardWrapper );

        //System.assertEquals( 7, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests saving actual owner of service point and value of 'step to go' -
              scenario - failed - 'Titolare Effettivo' step and contact1's invalid document data
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       17/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void actualOwner_Contact1_InvalidDocumentNumber( )
    {
        List<Contact> contacts = OB_FlowControlUtility_Test.getContacts( );
        Map<String, Object> data = OB_FlowControlUtility_Test.prepareDataToActualOwnerTest( 1, contacts, '123&&)12312' );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.actualOwner( '', data, null, '', '', wizardWrapper );

        System.assertEquals( 6, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests saving actual owner of service point and value of 'step to go' -
              scenario - failed - 'Titolare Effettivo' step and contact2's invalid document data

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       17/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void actualOwner_Contact2_InvalidDocumentNumber( )
    {
        List<Contact> contacts = OB_FlowControlUtility_Test.getContacts( );
        Map<String, Object> data = OB_FlowControlUtility_Test.prepareDataToActualOwnerTest( 2, contacts, '12312312' );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.actualOwner( '', data, null, '', '', wizardWrapper );

        System.assertEquals( 6, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests saving actual owner of service point and value of 'step to go' -
              scenario - failed - 'Titolare Effettivo' step and contact3's invalid document data

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       17/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void actualOwner_Contact3_InvalidDocumentNumber( )
    {
        List<Contact> contacts = OB_FlowControlUtility_Test.getContacts( );
        Map<String, Object> data = OB_FlowControlUtility_Test.prepareDataToActualOwnerTest( 3, contacts, '12312312' );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.actualOwner( '', data, null, '', '', wizardWrapper );

        System.assertEquals( 6, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests saving actual owner of service point and value of 'step to go' -
              scenario - failed - 'Titolare Effettivo' step and contact4's invalid document data

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       17/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void actualOwner_Contact4_InvalidDocumentNumber( )
    {
        List<Contact> contacts = OB_FlowControlUtility_Test.getContacts( );
        Map<String, Object> data = OB_FlowControlUtility_Test.prepareDataToActualOwnerTest( 4, contacts, '12312312' );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.actualOwner( '', data, null, '', '', wizardWrapper );

        System.assertEquals( 6, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests saving actual owner of service point and value of 'step to go' -
              scenario - failed - 'Titolare Effettivo' step and contact5's invalid document data
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       17/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void actualOwner_Contact5_InvalidDocumentNumber( )
    {
        List<Contact> contacts = OB_FlowControlUtility_Test.getContacts( );
        Map<String, Object> data = OB_FlowControlUtility_Test.prepareDataToActualOwnerTest( 5, contacts, '12312312' );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.actualOwner( '', data, null, '', '', wizardWrapper );

        System.assertEquals( 6, testResponse.stepToGo );
    }
    /*******************************************************************************
    Purpose:  Method tests saving actual owner of service point and value of 'step to go' -
              scenario - failed - 'Titolare Effettivo' step and contact6's invalid document data
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       17/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void actualOwner_Contact6_InvalidDocumentNumber( )
    {
        List<Contact> contacts = OB_FlowControlUtility_Test.getContacts( );
        Map<String, Object> data = OB_FlowControlUtility_Test.prepareDataToActualOwnerTest( 6, contacts, '12312312' );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.actualOwner( '', data, null, '', '', wizardWrapper );

        System.assertEquals( 6, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests saving actual owner of service point and value of 'step to go' -
              scenario - failed - 'Titolare Effettivo' step and contact1's empty data

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       17/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void actualOwner_Contact1_InvalidData( )
    {
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility_Test.prepareDataToActualOwnerWithInvalidData( 1 );
        System.assertEquals( 6, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests saving actual owner of service point and value of 'step to go' -
              scenario - failed - 'Titolare Effettivo' step and contact2's empty data
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       17/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void actualOwner_Contact2_InvalidData( )
    {
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility_Test.prepareDataToActualOwnerWithInvalidData( 2 );
        System.assertEquals( 6, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests saving actual owner of service point and value of 'step to go' -
              scenario - failed - 'Titolare Effettivo' step and contact3's empty data
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       17/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void actualOwner_Contact3_InvalidData( )
    {
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility_Test.prepareDataToActualOwnerWithInvalidData( 3 );
        System.assertEquals( 6, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests saving actual owner of service point and value of 'step to go' -
              scenario - failed - 'Titolare Effettivo' step and contact4's empty data

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       17/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void actualOwner_Contact4_InvalidData( )
    {
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility_Test.prepareDataToActualOwnerWithInvalidData( 4 );
        System.assertEquals( 6, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests saving actual owner of service point and value of 'step to go' -
              scenario - failed - 'Titolare Effettivo' step and contact5's empty data

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       17/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void actualOwner_Contact5_InvalidData( )
    {
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility_Test.prepareDataToActualOwnerWithInvalidData( 5 );
        System.assertEquals( 6, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests saving actual owner of service point and value of 'step to go' -
              scenario - failed - 'Titolare Effettivo' step and contact6's empty data

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       17/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void actualOwner_Contact6_InvalidData( )
    {
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility_Test.prepareDataToActualOwnerWithInvalidData( 6 );
        System.assertEquals( 6, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method checks value of 'step to go' - 'Carica Documenti' step -
              scenario - success - filled contacts details

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       17/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void servicePoint_CaricaDocumentiStep( )
    {
        Account bankAccount = OB_FlowControlUtility_Test.getBankAccount( );
        Account merchantAccount = OB_FlowControlUtility_Test.getMerchantAccount( bankAccount.Id );
        String pvHours = ', "OB_Opening_Time__c" : "08:00:00.276Z", "OB_Ending_Time__c" : "20:00:00.276Z", ' +
                '"OB_Break_Start_Time__c" : "12:00:00.276Z", "OB_Break_End_Time__c" : "13:00:00.276Z"';
        String contactsDetails =
                ',"Responsabile_Amm_PV" : { "Id" : " ", "LastName" : "amm", "FirstName" : "testname", "MobilePhone" : "1234567891", "Email" : "test1@email.it" },' +
                        '"Responsabile_PV" : { "Id" : " ", "LastName" : "amm", "FirstName" : "testname", "MobilePhone" : "1234567891", "Email" : "test2@email.it" },' +
                        '"Referente_TecnicoPV" : { "Id" : " " , "LastName" : "amm", "FirstName" : "testname", "MobilePhone" : "1234567891", "Email" : "test3@email.it" }';
        Map<String, Object> data = OB_FlowControlUtility_Test.prepareDataToIdentifyCompanyTest(
                '', 'true', '', String.valueOf( merchantAccount.Id ), '00', '', '', pvHours, false, '00', true, '00;00', contactsDetails, '');
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        //GIOVANNI SPINELLI START
        data.put('activateMandatoryChecksPrivacyInput','true');
        //GIOVANNI SPINELLI END
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.servicePoint( '', data, null, '', '', wizardWrapper );

        System.assertEquals( 7, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method checks value of 'step to go' - 'Carica Documenti' step -
              scenario - success - empty contacts details

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       17/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void servicePoint_CaricaDocumentiStep_EmptyContactDetails( )
    {
        Account bankAccount = OB_FlowControlUtility_Test.getBankAccount( );
        Account merchantAccount = OB_FlowControlUtility_Test.getMerchantAccount( bankAccount.Id );
        String pvHours = ', "OB_Opening_Time__c" : "08:00:00.276Z", "OB_Ending_Time__c" : "20:00:00.276Z", ' +
                '"OB_Break_Start_Time__c" : "12:00:00.276Z", "OB_Break_End_Time__c" : "13:00:00.276Z"';
        String contactsDetails =
                ',"Responsabile_Amm_PV" : { "Id" : "", "LastName" : "", "FirstName" : "", "MobilePhone" : "", "Email" : "" },' +
                        '"Responsabile_PV" : { "Id" : "", "LastName" : "", "FirstName" : "", "MobilePhone" : "", "Email" : "" },' +
                        '"Referente_TecnicoPV" : { "Id" : "" , "LastName" : "", "FirstName" : "","MobilePhone" : "" , "Email" : "" }';
        Map<String, Object> data = OB_FlowControlUtility_Test.prepareDataToIdentifyCompanyTest(
                '', 'true', '', String.valueOf( merchantAccount.Id ), '00', '', '', pvHours, false, '00', true, '00;00', contactsDetails, '');
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.servicePoint( '', data, null, '', '', wizardWrapper );

        System.assertEquals( 8, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method checks value of 'step to go' - 'Carica Documenti' step -
              scenario - success - empty contacts details and updated service point

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       23/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void servicePoint_CaricaDocumentiStep_UpdateServicePoint( )
    {
        Account bankAccount = OB_FlowControlUtility_Test.getBankAccount( );
        Account merchantAccount = OB_FlowControlUtility_Test.getMerchantAccount( bankAccount.Id );

        NE__Service_Point__c testServicePoint = new NE__Service_Point__c();
        testServicePoint.NE__Account__c = merchantAccount.Id;
        insert testServicePoint;

        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        insert testOrderHeader;

        NE__Order__c testOrder = OB_TestDataFactory.getOrder( testOrderHeader );
        testOrder.OB_ShopSign__c = '0000000000000000000000000';
        insert testOrder;

        NE__OrderItem__c testOrderItem = new NE__OrderItem__c();
        testOrderItem.NE__OrderId__c = testOrder.Id;
        testOrderItem.NE__Qty__c = 1;
        insert testOrderItem;

        String pvHours = ', "OB_Opening_Time__c" : "08:00:00.276Z", "OB_Ending_Time__c" : "20:00:00.276Z", ' +
                '"OB_Break_Start_Time__c" : "12:00:00.276Z", "OB_Break_End_Time__c" : "13:00:00.276Z"';
        String contactsDetails =
                ',"Responsabile_Amm_PV" : { "Id" : "", "LastName" : "", "FirstName" : "", "MobilePhone" : "", "Email" : "" },' +
                        '"Responsabile_PV" : { "Id" : "", "LastName" : "", "FirstName" : "", "MobilePhone" : "", "Email" : "" },' +
                        '"Referente_TecnicoPV" : { "Id" : "" , "LastName" : "", "FirstName" : "","MobilePhone" : "" , "Email" : "" }';
        Map<String, Object> data = OB_FlowControlUtility_Test.prepareDataToIdentifyCompanyTest(
                '', 'true', testOrder.Id, String.valueOf( merchantAccount.Id ), '00', testServicePoint.Id, '', pvHours, false, '00', true, '00;00', contactsDetails, '');
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.servicePoint( '', data, null, '', '', wizardWrapper );

        System.assertEquals( 8, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose: Method checks value of 'step to go' - 'Punto Vendita' step -
              scenario - pass - Tested with data for cover case (LIVIGNO);
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Michal Targiel       08/07/2019        Created            NEXI-141
    ********************************************************************************/
    @isTest static void servicePoint_PuntoVenditaStep_LivignoCheck_TEST( )
    {
        Account accountTest = OB_TestDataFactory.getAccount( );

        accountTest.OB_VAT_Not_Present__c = true;
        accountTest.OB_DescriptionVATNotPresent__c = OB_UtilityConstants.LIVIGNO;
        accountTest.NE__VAT__c = null;
        insert accountTest;

        NE__Service_Point__c servicePointTest = new NE__Service_Point__c( );
        servicePointTest.Name = 'Test';
        servicePointTest.NE__Account__c = accountTest.Id;
        insert servicePointTest;

        Map<String, Object> data = OB_FlowControlUtility_Test.prepareDataToIdentifyCompanyTest(
            '', 'true', '', String.valueOf( accountTest.Id ), '00', servicePointTest.Id, accountTest.Id, '', false, '00', true, '00;00', '', '' );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = OB_UtilityConstants.FLOW_WIZARD_NAME_NUOVO_CONTRATTO;
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.servicePoint( '', data, null, '', '', wizardWrapper );

        System.assertEquals( 8, testResponse.stepToGo );
    }

    /*******************************************************************************
     Purpose:  Method tests value of 'step to go' - 'Identifica Societa' step - scenario - success

     History
     --------
     VERSION     AUTHOR                  DATE            DETAIL          Description
     1.0         Joanna Mielczarek       09/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
     ********************************************************************************/
    @isTest static void offertaSelectionPrevious_IdentificaSocietaStep( )
    {
        String testJSON = testJSON_OFFERTA_SELECTION_PREVIOUS + ', "GT" : "" }';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.offertaSelectionPrevious( '', data, null, '', '', wizardWrapper );

        System.assertEquals( 1, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method checks value of 'step to go' - 'GT' step - scenario - failed

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       09/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void offertaSelectionPrevious_GTStep( )
    {
        String testJSON = testJSON_OFFERTA_SELECTION_PREVIOUS + ', "GT" : "a;b;c" }';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.offertaSelectionPrevious( '', data, null, '', '', wizardWrapper );

        System.assertEquals( 2, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method checks value of 'step to go' - 'GT' step - scenario - generic error in catch

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       19/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void offertaSelectionPrevious_Error( )
    {
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( '{ }' );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.offertaSelectionPrevious( '', data, null, '', '', wizardWrapper );

        System.assertEquals( null, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests value of 'step to go' - 'Identifica Societa' step - scenario - success

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       09/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void GTselectionPrevious_IdentificaSocietaStep( )
    {
        String testJSON = '{ "messageNext" : { "message" : "", "severity" : "" } }';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.GTselectionPrevious( '', data, null, '', '', wizardWrapper );

        System.assertEquals( 1, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests value of 'step to go' - 'Identifica Societa' step - scenario - failed - no 'messageNext' field in map of data

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       09/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void GTselectionPrevious_Failed( )
    {
        Map<String, Object> data = new Map<String, Object>( );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.GTselectionPrevious( '', data, null, '', '', wizardWrapper );

        System.assertEquals( 1, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests value of 'step to go' - 'Offerta' step - scenario - success

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       09/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void operationalDataPrevious_OffertaStep( )
    {
        Map<String, Object> data = new Map<String, Object>( );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.operationalDataPrevious( '', data, null, '', '', wizardWrapper );

        System.assertEquals( 3, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests value of 'step to go' - scenario - faield - no DynamicWizardWrapper and map of data

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       09/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void operationalDataPrevious_Failed( )
    {
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.operationalDataPrevious( '', null, null, '', '', null );
        System.assertEquals( null, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests value of 'step to go' - 'Dati Operativi' step - scenario - success

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       09/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void companyDataPrevious_DatiOperativiStep( )
    {
        String testJSON = '{ "BillingProfilePOS" : { "sobjectType": "ne__billing_profile__c", "RecordTypeId": "", ' +
                '"OB_ABI__c": "", "OB_Bank_Account_Number__c": "", "OB_Bank_Account_Owner__c": "", "OB_Bank_Account_Type__c": "Credit" } }';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.companyDataPrevious( '', data, null, '', '', wizardWrapper );

        System.assertEquals( 4, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests value of 'step to go' - 'Dati Societa' step - scenario - success

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       09/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void servicePointPrevious_DatiSocietaStep( )
    {
        String testJSON = '{ "merchant": { "sobjectType": "account", "RecordTypeId": "", "Id": "", "Name": "", ' +
                '"OB_Beneficial_Owner_Existence__c" : false } }';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.servicePointPrevious( '', data, null, '', '', wizardWrapper );

        System.assertEquals( 5, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests value of 'step to go' - 'Titolare Effettivo' step - scenario - success

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       09/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void servicePointPrevious_TitolareEffettivoStep( )
    {
        String testJSON = '{ "merchant": { "sobjectType": "account", "RecordTypeId": "", "Id": "", "Name": "", ' +
                '"OB_Beneficial_Owner_Existence__c" : true } }';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.servicePointPrevious( '', data, null, '', '', wizardWrapper );

        System.assertEquals( 6, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests value of 'step to go' - scenario - failed - no merchant account

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       09/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void servicePointPrevious_Failed( )
    {
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.servicePointPrevious( '', null, null, '', '', null );
        System.assertEquals( null, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests value of 'step to go' - 'Carica Documenti' step - scenario - success

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       09/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void riepilogoPrevious_CaricaDocumentiStep( )
    {
        Map<String, Object> data = new Map<String, Object>( );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = 'OB_Nuovo_Contratto';
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.riepilogoPrevious( '', data, null, '', '', wizardWrapper );

        System.assertEquals( 8, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests setting Configuration Information in OB_EnrichOrder class - scenario - success

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       09/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void riepilogoSave_Success( )
    {
        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        insert testOrderHeader;
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( testOrderHeader );
        insert testOrder;

        String testJSON = '{ "OrderHeader" : { "Id" : "' + testOrderHeader.Id + '"} }';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.riepilogoSave( '', data, null, '', '', wizardWrapper );

        System.assertEquals( data, testResponse.data );
    }

    /*******************************************************************************
    Purpose:  Method tests setting Configuration Information in OB_EnrichOrder class - scenario - failed

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       09/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void riepilogoSave_Failed( )
    {
        Map<String, Object> data = new Map<String, Object>( );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.riepilogoSave( '', data, null, '', '', wizardWrapper );

        System.assertEquals( data, testResponse.data );
    }

    /*******************************************************************************
    Purpose:  Method tests parsing time from String  - scenario longer version - with more than 5 characters

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       09/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void parseTime_LengthMoreThan5( )
    {
        System.assertEquals( Time.newInstance( 1, 1, 1, 1 ), OB_FlowControlUtility.ParseTime( '01:01:01.1' ) );
    }

    /*******************************************************************************
    Purpose:  Method tests parsing time from String - scenario shorter version - with 5 characters

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       09/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void parseTime_LengthEquals5( )
    {
        System.assertEquals( Time.newInstance( 1, 1, 0, 0 ), OB_FlowControlUtility.ParseTime( '01:01' ) );
    }

    /*******************************************************************************
    Purpose:  Method tests retrieving contact data - scenario - record type: Esecutore

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       09/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void retrieveDataContact_EsecutoreContact( )
    {
        Account bankAccount = OB_FlowControlUtility_Test.getBankAccount( );
        Account merchantAccount = OB_FlowControlUtility_Test.getMerchantAccount( bankAccount.Id );

        Id recordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.ESECUTORE ).getRecordTypeId( );
        Contact contactsActualBank = getContactActualBank( recordTypeIdContact, merchantAccount, bankAccount );

        String testJSON = '{ "merchant": {"id":"' + merchantAccount.Id + '","name":"Test","OB_Employees_Number__c":"Minore_di_10",' +
                '"NE__VAT__c":"00000000000","NE__Fiscal_code__c":"ABCDEF12G34H567I","RecordTypeId":"' + recordTypeIdContact + '"},' +
                '"actualBank":"' + bankAccount.Id + '" }}';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        OB_FlowControlUtility.retrieveDataContact( '', data, null, '', '', wizardWrapper );

        System.assert( data.containsKey( 'legale_rappresentante' ) );
    }

    /*******************************************************************************
    Purpose:  Method tests retrieving contact data - scenario - record type: Dati Societa Legale

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       09/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void retrieveDataContact_DatiSocietaLegaleContact( )
    {
        Account bankAccount = OB_FlowControlUtility_Test.getBankAccount( );
        Account merchantAccount = OB_FlowControlUtility_Test.getMerchantAccount( bankAccount.Id );

        Id recordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.DATI_SOCIETA_LEGALE ).getRecordTypeId( );
        Contact contactsActualBank = getContactActualBank( recordTypeIdContact, merchantAccount, bankAccount );

        String testJSON = '{ "merchant": {"id":"' + merchantAccount.Id + '","name":"Test","OB_Employees_Number__c":"Minore_di_10",' +
                '"NE__VAT__c":"00000000000","NE__Fiscal_code__c":"ABCDEF12G34H567I","RecordTypeId":"' + recordTypeIdContact + '"},' +
                '"actualBank":"' + bankAccount.Id + '" }}';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        OB_FlowControlUtility.retrieveDataContact( '', data, null, '', '', wizardWrapper );

        System.assert( data.containsKey( 'sede_legale' ) );
    }

    /*******************************************************************************
    Purpose:  Method tests retrieving contact data - scenario - record type: Titolare Effettivo

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       09/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void retrieveDataContact_TitolareEffettivoContact( )
    {
        Account bankAccount = OB_FlowControlUtility_Test.getBankAccount( );
        Account merchantAccount = OB_FlowControlUtility_Test.getMerchantAccount( bankAccount.Id );

        Id recordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.TITOLARE_EFFETTIVO ).getRecordTypeId( );
        Contact contactsActualBank = getContactActualBank( recordTypeIdContact, merchantAccount, bankAccount );

        String testJSON = '{ "merchant": {"id":"' + merchantAccount.Id + '","name":"Test","OB_Employees_Number__c":"Minore_di_10",' +
                '"NE__VAT__c":"00000000000","NE__Fiscal_code__c":"ABCDEF12G34H567I","RecordTypeId":"' + recordTypeIdContact + '"},' +
                '"actualBank":"' + bankAccount.Id + '" }}';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        OB_FlowControlUtility.retrieveDataContact( '', data, null, '', '', wizardWrapper );

        System.assert( data.containsKey( 'contact1' ) );
    }

    /*******************************************************************************
    Purpose:  Method tests retrieving map of record types - scenario - success

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       09/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void recordTypeQuery_Success( )
    {
        List<String> testList = new List<String> {OB_UtilityConstants.TITOLARE_EFFETTIVO, OB_UtilityConstants.DATI_SOCIETA_LEGALE} ;
        Map<String, RecordType> testMap = OB_FlowControlUtility.recordTypeQuery( 'Contact', testList );

        System.assertEquals( 2, testMap.size( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests retrieving new Account - scenario - success

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       09/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest
    public static void checkAccountSFDC_Success( )
    {
        Account bankAccount = OB_FlowControlUtility_Test.getBankAccount( );
        Account merchantAccount = OB_FlowControlUtility_Test.getMerchantAccount( bankAccount.Id );
        Account testAccount = OB_FlowControlUtility.checkAccountSFDC( merchantAccount, bankAccount.Id );

        System.assert( testAccount != null );
    }

    /*******************************************************************************
    Purpose:  Method checking existence of Service Point by given Account - scenario - success

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       09/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void checkPvSFDC_True( )
    {
        Account bankAccount = OB_FlowControlUtility_Test.getBankAccount( );
        Account testAccount = OB_FlowControlUtility_Test.getMerchantAccount( bankAccount.Id );

        NE__Service_Point__c testServicePoint = new NE__Service_Point__c( NE__Account__c = testAccount.Id );
        insert testServicePoint;

        System.assert( OB_FlowControlUtility.checkPvSFDC( testServicePoint, testAccount.Id ) == false );
    }

    /*******************************************************************************
    Purpose:  Method checking existence of Service Point by given Account - scenario - failed

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       09/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void checkPvSFDC_False( )
    {
        Account bankAccount = OB_FlowControlUtility_Test.getBankAccount( );
        Account testAccount = OB_FlowControlUtility_Test.getMerchantAccount( bankAccount.Id );
        NE__Service_Point__c testServicePoint = new NE__Service_Point__c( NE__Account__c = testAccount.Id );
        insert testServicePoint;

        System.assert( OB_FlowControlUtility.checkPvSFDC( testServicePoint, null ) == false );
    }

    /*******************************************************************************
    Purpose:  Method checks contact with Carta Di Identica - scenario - success

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       10/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    1.1         Kinga Fornal            08/08/2019      Updated         added OB_Document_Release_Country_Code__c ITA
    ********************************************************************************/
    @isTest static void checkMandatoryValCheckCont_CartaDiIdentita( )
    {
        Contact testContact = OB_FlowControlUtility_Test.getContact_CheckMandatory();
        testContact.OB_Document_Type__c = OB_UtilityConstants.CARTA_DI_IDENTITA;
        testContact.OB_Document_Number__c = '1231231231';
        testContact.OB_Document_Release_Date__c = Date.newInstance( 2018, 2, 10 );
        testContact.OB_Document_Expiration_Date__c = Date.newInstance( 2028, 2, 10 );
        testContact.OB_Document_Release_Authority__c = 'Questura';
        testContact.OB_Birth_Date__c = Date.newInstance( 1990, 06, 12 );
        testContact.OB_Document_Release_Country_Code__c = 'ITA';

        Map<String, Object> mappaErrorEE = new Map<String, Object>( );
        mappaErrorEE.put( 'key1', true );
        Map<String, String> testMap = OB_FlowControlUtility.checkMandatoryValCheckCont( testContact, 'section', mappaErrorEE );

        System.assert( testMap.containsKey( 'documentAuthcontactsectionDoc' ) );
    }

    /*******************************************************************************
    Purpose:  Method checks contact with Passaporto - scenario - success

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       10/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    1.1         Kinga Fornal            08/08/2019      Updated         added OB_Document_Release_Country_Code__c ITA
    ********************************************************************************/
    @isTest static void checkMandatoryValCheckCont_Passaporto( )
    {
        Date today = Date.today( );
        Integer thisYear = today.year( );

        Contact testContact = OB_FlowControlUtility_Test.getContact_CheckMandatory();
        testContact.OB_Document_Type__c = OB_UtilityConstants.PASSAPORTO;
        testContact.OB_Document_Number__c = 'AB1234567';
        testContact.OB_Document_Release_Authority__c = OB_UtilityConstants.UCO;
        testContact.OB_Document_Release_Date__c = Date.newInstance( thisYear, 1, 1 );
        testContact.OB_Document_Expiration_Date__c = Date.newInstance( thisYear + 10, 1, 1 );
        testContact.OB_Birth_Date__c = Date.newInstance( 1990, 06, 12 );
        testContact.OB_Document_Release_Country_Code__c = 'ITA';

        NE__Lov__c testLov = new NE__Lov__c(
                Name = testContact.OB_Country_Birth__c,
                NE__Type__c = 'COUNTRY',
                NE__Value2__c = '12345' );
        insert testLov;

        Map<String, Object> mappaErrorEE = new Map<String, Object>( );
        mappaErrorEE.put( 'key1', true );
        Map<String, String> testMap = OB_FlowControlUtility.checkMandatoryValCheckCont( testContact, 'section', mappaErrorEE );

        System.assert( testMap.containsKey( 'documentAuthcontactsectionDoc' ) );
    }

    /*******************************************************************************
    Purpose:  Method checks contact with Patente - scenario - success

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       11/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    1.1         Kinga Fornal            08/08/2019      Updated         added OB_Document_Release_Country_Code__c ITA
    ********************************************************************************/
    @isTest static void checkMandatoryValCheckCont_Patente( )
    {
        Date today = Date.today( );
        Integer thisYear = today.year( );

        Contact testContact = OB_FlowControlUtility_Test.getContact_CheckMandatory();
        testContact.OB_Document_Type__c = OB_UtilityConstants.PATENTE;
        testContact.OB_Document_Number__c = 'MM00MM00MM';
        testContact.OB_Document_Release_Authority__c = OB_UtilityConstants.QUESTURA;
        testContact.OB_Document_Release_Date__c = Date.newInstance( thisYear, 1, 1 );
        testContact.OB_Document_Expiration_Date__c = Date.newInstance( thisYear + 10, 1, 1 );
        testContact.OB_Birth_Date__c = Date.newInstance( 1990, 06, 12 );
        testContact.OB_Document_Release_Country_Code__c = 'ITA';

        Map<String, Object> mappaErrorEE = new Map<String, Object>( );
        mappaErrorEE.put( 'key1', true );
        Map<String, String> testMap = OB_FlowControlUtility.checkMandatoryValCheckCont( testContact, 'section', mappaErrorEE );

        System.assert( testMap.containsKey( 'documentAuthcontactsectionDoc' ) );
    }

    /*******************************************************************************
    Purpose:  Method checks contact with Carta Di Identita -
              scenario - failed with invalid release date of document

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       19/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    1.1         Kinga Fornal            08/08/2019      Updated         added OB_Document_Release_Country_Code__c ITA
   ********************************************************************************/
    @isTest static void checkMandatoryValCheckCont_InvalidReleaseDate( )
    {
        Date today = Date.today( );
        Integer thisYear = today.year( );

        Contact testContact = OB_FlowControlUtility_Test.getContact_CheckMandatory();
        testContact.OB_Document_Type__c = OB_UtilityConstants.CARTA_DI_IDENTITA;
        testContact.OB_Document_Number__c = '1231231231';
        testContact.OB_Document_Release_Date__c = Date.newInstance( 1989, 2, 10 );
        testContact.OB_Birth_Date__c = Date.newInstance( thisYear - 10, 2, 9 );
        testContact.OB_Document_Release_Country_Code__c = 'ITA';

        Map<String, Object> mappaErrorEE = new Map<String, Object>( );
        mappaErrorEE.put( 'key1', true );
        Map<String, String> testMap = OB_FlowControlUtility.checkMandatoryValCheckCont( testContact, 'section', mappaErrorEE );

        System.assert( testMap.containsKey( 'documentReleaseDatecontactsectionDoc' ) && testMap.containsKey( 'birthDatecontactsectionDoc' ) );
    }

    /*******************************************************************************
    Purpose:  Method checks contact with Carta Di Identita -
              scenario - failed with invalid expiration date of document - ver 1

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       19/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
   ********************************************************************************/
    @isTest static void checkMandatoryValCheckCont_CartaDiIdentita_InvalidExpirationDate1( )
    {
        Date today = Date.today( );
        Integer thisYear = today.year( );

        Contact testContact = OB_FlowControlUtility_Test.getContact_CheckMandatory();
        testContact.OB_Document_Type__c = OB_UtilityConstants.CARTA_DI_IDENTITA;
        testContact.OB_Document_Number__c = '1231231231';
        testContact.OB_Document_Release_Date__c = Date.newInstance( 2011, 2, 10 );
        testContact.OB_Document_Release_Date__c = Date.newInstance( 2018, 2, 10 );
        testContact.OB_Birth_Date__c = Date.newInstance( 1990, 2, 9 );
        testContact.OB_Document_Release_Country_Code__c = 'ITA';

        Map<String, Object> mappaErrorEE = new Map<String, Object>( );
        mappaErrorEE.put( 'key1', true );
        Map<String, String> testMap = OB_FlowControlUtility.checkMandatoryValCheckCont( testContact, 'section', mappaErrorEE );

        System.assert( testMap.containsKey( 'documentExpirationDatecontactsectionDoc' ) );
    }

    /*******************************************************************************
    Purpose:  Method checks contact with Carta Di Identita -
              scenario - failed with invalid expiration date of document - ver 2

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       19/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    1.1         Kinga Fornal            08/08/2019      Updated         added OB_Document_Release_Country_Code__c ITA
   ********************************************************************************/
    @isTest static void checkMandatoryValCheckCont_CartaDiIdentita_InvalidExpirationDate2( )
    {
        Date today = Date.today( );
        Integer thisYear = today.year( );

        Contact testContact = OB_FlowControlUtility_Test.getContact_CheckMandatory();
        testContact.OB_Document_Type__c = OB_UtilityConstants.CARTA_DI_IDENTITA;
        testContact.OB_Document_Number__c = '1231231231';
        testContact.OB_Document_Release_Date__c = Date.newInstance( 2013, 2, 10 );
        testContact.OB_Document_Release_Date__c = Date.newInstance( 2018, 2, 10 );
        testContact.OB_Birth_Date__c = Date.newInstance( 1990, 2, 9 );
        testContact.OB_Document_Release_Country_Code__c = 'ITA';

        Map<String, Object> mappaErrorEE = new Map<String, Object>( );
        mappaErrorEE.put( 'key1', true );
        Map<String, String> testMap = OB_FlowControlUtility.checkMandatoryValCheckCont( testContact, 'section', mappaErrorEE );

        System.assert( testMap.containsKey( 'documentExpirationDatecontactsectionDoc' ) );
    }

    /*******************************************************************************
    Purpose:  Method checks contact with Passaporto - scenario - failed - invalid expiration date of document and invalid last char

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       19/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    1.1         Kinga Fornal            08/08/2019      Updated         added OB_Document_Release_Country_Code__c ITA
    ********************************************************************************/
    @isTest static void checkMandatoryValCheckCont_Passaporto_InvalidExpirationDate( )
    {
        Date today = Date.today( );
        Integer thisYear = today.year( );

        Contact testContact = OB_FlowControlUtility_Test.getContact_CheckMandatory();
        testContact.OB_Fiscal_Code__c = 'MRAMRA90H52F205A';
        testContact.OB_Document_Type__c = OB_UtilityConstants.PASSAPORTO;
        testContact.OB_Document_Number__c = 'AB1234567';
        testContact.OB_Document_Release_Authority__c = OB_UtilityConstants.UCO;
        testContact.OB_Document_Release_Date__c = Date.newInstance( thisYear - 1, 1, 1 );
        testContact.OB_Document_Expiration_Date__c = Date.newInstance( thisYear , 1, 1 );
        testContact.OB_Birth_Date__c = Date.newInstance( 1990, 06, 12 );
        testContact.OB_Document_Release_Country_Code__c = 'ITA';

        Map<String, Object> mappaErrorEE = new Map<String, Object>( );
        mappaErrorEE.put( 'key1', true );
        Map<String, String> testMap = OB_FlowControlUtility.checkMandatoryValCheckCont( testContact, 'section', mappaErrorEE );

        System.assert( testMap.containsKey( 'documentExpirationDatecontactsectionDoc' ) && testMap.containsKey( 'fiscalCodeContactsection' ) );
    }

    /*******************************************************************************
    Purpose:  Method checks contact with Patente - scenario - failed - invalid expiration date of document and error gender

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       19/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    1.1         Kinga Fornal            08/08/2019      Updated         added OB_Document_Release_Country_Code__c ITA
    ********************************************************************************/
    @isTest static void checkMandatoryValCheckCont_Patente_InvalidExpirationDate( )
    {
        Date today = Date.today( );
        Integer thisYear = today.year( );

        Contact testContact = OB_FlowControlUtility_Test.getContact_CheckMandatory();
        testContact.OB_Fiscal_Code__c = 'MRAMRA90H00F205X';
        testContact.OB_Document_Type__c = OB_UtilityConstants.PATENTE;
        testContact.OB_Document_Number__c = 'MM00MM00MM';
        testContact.OB_Document_Release_Authority__c = OB_UtilityConstants.QUESTURA;
        testContact.OB_Document_Release_Date__c = Date.newInstance( thisYear - 1, 1, 1 );
        testContact.OB_Document_Expiration_Date__c = Date.newInstance( thisYear , 1, 1 );
        testContact.OB_Birth_Date__c = Date.newInstance( 1990, 06, 12 );
        testContact.OB_Document_Release_Country_Code__c = 'ITA';

        Map<String, Object> mappaErrorEE = new Map<String, Object>( );
        mappaErrorEE.put( 'key1', true );
        Map<String, String> testMap = OB_FlowControlUtility.checkMandatoryValCheckCont( testContact, 'section', mappaErrorEE );

        System.assert( testMap.containsKey( 'documentAuthcontactsectionDoc' ) && testMap.containsKey( 'fiscalCodeContactsection' ) );
    }

    /*******************************************************************************
      Purpose:  Method tests saving - returning null

      History
      --------
      VERSION     AUTHOR                  DATE            DETAIL          Description
      1.0         Joanna Mielczarek       19/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
      ********************************************************************************/
    @isTest static void save_Test( )
    {
        Map<String, Object> data = new Map<String, Object>( );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        OB_FlowControlUtility flowControlUtility = new OB_FlowControlUtility();
        bit2flow.DynamicWizardStepWrapper testResponse = flowControlUtility.save( '', data, '', null, wizardWrapper );

        System.assertEquals( null, testResponse );
    }

    /*******************************************************************************
      Purpose:  Method tests executing method's - returning null

      History
      --------
      VERSION     AUTHOR                  DATE            DETAIL          Description
      1.0         Joanna Mielczarek       18/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
      ********************************************************************************/
    @isTest static void executeMethod_Test( )
    {
        Map<String, Object> data = new Map<String, Object>( );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.executeMethod( '', data, '', '', null, wizardWrapper );

        System.assertEquals( null, testResponse );
    }

    /*******************************************************************************
      Purpose:  Method tests validation - returning null

      History
      --------
      VERSION     AUTHOR                  DATE            DETAIL          Description
      1.0         Joanna Mielczarek       19/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
      ********************************************************************************/
    @isTest static void validate_Test( )
    {
        Map<String, Object> data = new Map<String, Object>( );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        OB_FlowControlUtility flowControlUtility = new OB_FlowControlUtility();
        bit2flow.DynamicWizardStepWrapper testResponse = flowControlUtility.validate( '', data, null, wizardWrapper );

        System.assertEquals( null, testResponse );
    }

    /*******************************************************************************
    Purpose:  Method tests successful overwriting

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0           ?                      ?              Created
    2.0         Joanna Mielczarek       18/04/2019      Updated         Added assertion
    ********************************************************************************/
    @isTest static void overwriteExit_Test( )
    {
        Map<String, Object> data = new Map<String, Object>( );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        bit2flow.DynamicWizardStepWrapper testDynamicWizardStepWrapper = OB_FlowControlUtility.overwriteExit( '', data, null, wizardWrapper, '' );

        System.assertEquals( wizardWrapper, testDynamicWizardStepWrapper.dynamicWizardWrapper );
    }

    /*******************************************************************************
    Purpose:  Method tests successful overwriting

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0           ?                      ?              Created
    2.0         Joanna Mielczarek       18/04/2019      Updated         Added assertion
    ********************************************************************************/
    @isTest static void overwritePrevious_Test( )
    {
        Map<String, Object> data = new Map<String, Object>( );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        bit2flow.DynamicWizardStepWrapper newResponse = new bit2flow.DynamicWizardStepWrapper();
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.overwritePrevious( '', data, null, wizardWrapper );

        System.assertEquals( newResponse.result, testResponse.result );
    }

    /*******************************************************************************
    Purpose:  Method tests successful overwriting

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0           ?                      ?             Created
    2.0         Joanna Mielczarek       18/04/2019     Updated          Added assertion
    ********************************************************************************/
    @isTest static void overwriteSave_Test( )
    {
        Map<String, Object> data = new Map<String, Object>( );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.overwriteSave( '', data, null, wizardWrapper, '' );

        System.assertEquals( null, testResponse );
    }

    /*******************************************************************************
    Purpose:  Method tests successful overwriting

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0           ?                      ?             Created
    2.0         Joanna Mielczarek       18/04/2019     Updated          Added assertion
    ********************************************************************************/
    @isTest static void overwriteNext_Test( )
    {
        Map<String, Object> data = new Map<String, Object>( );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        bit2flow.DynamicWizardStepWrapper newResponse = new bit2flow.DynamicWizardStepWrapper();
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.overwriteNext( '', data, null, wizardWrapper );

        System.assertEquals( newResponse.result , testResponse.result );
    }

    /*******************************************************************************
    Purpose:  Method tests setting value of 'step to go' to 'Summary' - scenario - success

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       09/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void downloadDocument_SummaryStep( )
    {
        String jsonString = '{ "allCheckedCreate" : "true","allCheckedLoad" : "true" }';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( jsonString );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.downloadDocument( '', data, null, '', '', wizardWrapper );

        //System.assertEquals( 6, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests setting value of 'step to go' to 'Carica Documenti' - scenario - failed

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       09/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void downloadDocument_CaricaDocumentiStep( )
    {
        String jsonString = '{ "allCheckedCreate" : "false","allCheckedLoad" : "false" }';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( jsonString );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.downloadDocument( '', data, null, '', '', wizardWrapper );

        //System.assertEquals( 5, testResponse.stepToGo );
    }


    /*******************************************************************************
    Purpose:  Method tests correctness of personal data - scenario - male, success version

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       04/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void checkNameSurnameCF_successM( )
    {
        String name = 'mario';
        String surname = 'mario';
        String fiscalCode = 'MRAMRA80A01F205V';
        String birthDate = '1980/01/01';
        String gender = 'M';
        String cadastralCode = 'F205';
        String test = OB_FlowControlUtility.checkNameSurnameCF( name, surname, fiscalCode, birthDate, gender, cadastralCode, true );

        System.assertEquals( null, test );
    }

    /*******************************************************************************
    Purpose:  Method tests correctness of personal data - scenario - female, success version

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       04/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void checkNameSurnameCF_successF( )
    {
        String name = 'maria';
        String surname = 'maria';
        String fiscalCode = 'MRAMRA90H52F205X';
        String birthDate = '1990/06/12';
        String gender = 'F';
        String cadastralCode = 'F205';
        String test = OB_FlowControlUtility.checkNameSurnameCF( name, surname, fiscalCode, birthDate, gender, cadastralCode, true );

        System.assertEquals( null, test );
    }

    /*******************************************************************************
    Purpose:  Method tests correctness of personal data - scenario - female, failed version with longer name and surname

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       19/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void checkNameSurnameCF_NameSurnameLonger_errorName( )
    {
        String name = 'lamarria';
        String surname = 'lamarria';
        String fiscalCode = 'LMRLMR90H52A005C';
        String birthDate = '1990/06/12';
        String gender = 'F';
        String cadastralCode = 'A005';
        String test = OB_FlowControlUtility.checkNameSurnameCF( name, surname, fiscalCode, birthDate, gender, cadastralCode, true );

        System.assertEquals( 'errorName', test );
    }

    /*******************************************************************************
    Purpose:  Method tests correctness of personal data - scenario - incorrect name field

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       04/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void checkNameSurnameCF_errorName( )
    {
        String name = 'xxx';
        String surname = 'maria';
        String fiscalCode = 'MRAMRA90H52F205X';
        String birthDate = '1990/06/12';
        String gender = 'F';
        String cadastralCode = 'F205';
        String errorName = OB_FlowControlUtility.checkNameSurnameCF( name, surname, fiscalCode, birthDate, gender, cadastralCode, true );

        System.assertEquals( 'errorName', errorName );
    }

    /*******************************************************************************
    Purpose:  Method tests correctness of personal data - scenario - incorrect female gender field

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       04/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void checkNameSurnameCF_errorGenderF( )
    {
        String name = 'maria';
        String surname = 'maria';
        String fiscalCode = 'MRAMRA90H00F205X';
        String birthDate = '1990/06/12';
        String gender = 'F';
        String cadastralCode = 'F205';
        String errorGender = OB_FlowControlUtility.checkNameSurnameCF( name, surname, fiscalCode, birthDate, gender, cadastralCode, true );

        System.assertEquals( 'errorGender', errorGender );
    }

    /*******************************************************************************
    Purpose:  Method tests correctness of personal data - scenario - incorrect male gender field

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       04/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void checkNameSurnameCF_errorGenderM( )
    {
        String name = 'mario';
        String surname = 'mario';
        String fiscalCode = 'MRAMRA80A50F205V';
        String birthDate = '1980/01/01';
        String gender = 'M';
        String cadastralCode = 'F205';
        String errorGender = OB_FlowControlUtility.checkNameSurnameCF( name, surname, fiscalCode, birthDate, gender, cadastralCode, true );

        System.assertEquals( 'errorGender', errorGender );
    }

    /*******************************************************************************
    Purpose:  Method tests correctness of personal data - scenario - incorrect birthdate field

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       04/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void checkNameSurnameCF_errorData( )
    {
        String name = 'maria';
        String surname = 'maria';
        String fiscalCode = 'MRAMRA90H52F205X';
        String birthDate = '2019/04/04';
        String gender = 'F';
        String cadastralCode = 'F205';
        String errorData = OB_FlowControlUtility.checkNameSurnameCF( name, surname, fiscalCode, birthDate, gender, cadastralCode, true );

        System.assertEquals( 'errorData', errorData );
    }

    /*******************************************************************************
    Purpose:  Method tests correctness of personal data - scenario - incorrect last char in codice fiscale field

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       04/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void checkNameSurnameCF_errorLastChar( )
    {
        String name = 'maria';
        String surname = 'maria';
        String fiscalCode = 'MRAMRA90H52F205Q';
        String birthDate = '1990/06/12';
        String gender = 'F';
        String cadastralCode = 'F205';
        String errorLastChar = OB_FlowControlUtility.checkNameSurnameCF( name, surname, fiscalCode, birthDate, gender, cadastralCode, true );

        //System.assertEquals( 'errorLastChar', errorLastChar );
    }

    /*******************************************************************************
    Purpose:  Method tests correctness of personal data - scenario - incorrect cadastral code field

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       04/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void checkNameSurnameCF_errorCadastralCode( )
    {
        String name = 'maria';
        String surname = 'maria';
        String fiscalCode = 'MRAMRA90H52F205X';
        String birthDate = '1990/06/12';
        String gender = 'F';
        String cadastralCode = 'f234';
        String errorCadastralCode = OB_FlowControlUtility.checkNameSurnameCF( name, surname, fiscalCode, birthDate, gender, cadastralCode, false );

        System.assertEquals( 'errorCadastralCode', errorCadastralCode );
    }

    /*******************************************************************************
    Purpose:  Method tests changing special characters to letters - scenario - has special char

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       04/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void stringNormalizer_hasSpecialChar( )
    {
        System.assertEquals( 'tEst', OB_FlowControlUtility.stringNormalizer( 'tÉst' ) );
    }

    /*******************************************************************************
    Purpose:  Method tests changing special characters to letters - scenario - has not special char

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       04/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void stringNormalizer_hasntSpecialChar( )
    {
        System.assertEquals( 'test', OB_FlowControlUtility.stringNormalizer( 'test' ) );
    }

    /*******************************************************************************
    Purpose:  Method tests changing special characters to letters - scenario - has not special char

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       04/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void stringNormalizer_Failed( )
    {
        System.assertEquals( '', OB_FlowControlUtility.stringNormalizer( null ) );
    }

    /*******************************************************************************
    Purpose:  Method tests extracting vowels - scenario - has vowels

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       04/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void extractVowels_hasVowels( )
    {
        System.assertEquals( 'e', OB_FlowControlUtility.extractVowels( 'test' ) );
    }

    /*******************************************************************************
    Purpose:  Method tests extracting vowels - scenario - has not vowels

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       03/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void extractVowels_hasntVowels( )
    {
        System.assertEquals( '', OB_FlowControlUtility.extractVowels( 'tst' ) );
        System.assertEquals( '', OB_FlowControlUtility.extractVowels( '' ) );
    }

    /*******************************************************************************
    Purpose:  Method tests extracting consonants - scenario - has consonants

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       04/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void extractConsonants_hasConsonants( )
    {
        System.assertEquals( 'tst', OB_FlowControlUtility.extractConsonants( 'test' ) );
    }

    /*******************************************************************************
    Purpose:  Method tests extracting consonants - scenario - has not consonants

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       04/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void extractConsonants_hasntConsonants( )
    {
        System.assertEquals( '', OB_FlowControlUtility.extractConsonants( 'aeiou' ) );
        System.assertEquals( '', OB_FlowControlUtility.extractConsonants( '' ) );
    }

    /*******************************************************************************
    Purpose:  Method tests that String has digits - scenario - is success

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       04/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void controllaCheckDigit_isTrue( )
    {
        System.assert( OB_FlowControlUtility.controllaCheckDigit( 'MRABCH90H52F205Q' ) == true );
    }

    /*******************************************************************************
    Purpose:  Method tests that String has digits - scenario - is failed

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       04/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void controllaCheckDigit_isFalse( )
    {
        System.assert( OB_FlowControlUtility.controllaCheckDigit( '*' ) == false );
        System.assert( OB_FlowControlUtility.controllaCheckDigit( '' ) == null );
    }

    /*******************************************************************************
    Purpose:  Method tests saving draft - scenario - with wizard wrapper Id

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       03/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void init_WithStepToGo( )
    {
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        testWizardWrapper.label = 'testLabel';
        testWizardWrapper.name = 'testName';
        testWizardWrapper.wizardId = '1';

        String testJSON = '{"JumpToStep" : "1","OrderHeader" : {"":""} }';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );
        OB_FlowControlUtility flowControlUtility = new OB_FlowControlUtility( );
        bit2flow.DynamicWizardStepWrapper testResponse = flowControlUtility.init( '', data, null, testWizardWrapper );

        System.assertEquals( 1, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose:  Method tests saving draft - scenario - with wizard wrapper Id

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       18/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void init_WithStepToGo_NoOrderHeader( )
    {
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        testWizardWrapper.label = 'testLabel';
        testWizardWrapper.name = 'testName';
        testWizardWrapper.wizardId = '1';

        String jsonString = '{ "OrderHeader" : { "Id" : "" } }';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( jsonString );
        OB_FlowControlUtility flowControlUtility = new OB_FlowControlUtility( );
        bit2flow.DynamicWizardStepWrapper testResponse = flowControlUtility.init( '', data, null, testWizardWrapper );

        System.assertEquals( '000', testResponse.result );
    }

    /*******************************************************************************
    Purpose:  Method tests saving draft - scenario - with wizard wrapper Id

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       03/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void saveDraft_ExistingWizardWrapperId( )
    {
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        testWizardWrapper.label = 'testLabel';
        testWizardWrapper.name = 'testName';
        testWizardWrapper.wizardId = '1';
        //Start antonio.vatrano r1f3-75 20/09/2019
        NE__Order_Header__c oh = new NE__Order_Header__c();
        insert oh;
        //End antonio.vatrano r1f3-75 20/09/2019
        String jsonString = '{"JumpToStep" : "1","OrderHeader" : { "Id" : "'+oh.id+'" } }';	//antonio.vatrano r1f3-75 20/09/2019
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( jsonString );
        String testDraft = OB_FlowControlUtility.saveDraft( '2', data, null, testWizardWrapper, String.valueOf( testWizardWrapper ) );

        System.assertEquals( Label.OB_SavedFlowLabel, testDraft );
    }

    /*******************************************************************************
    Purpose:  Method tests saving draft - scenario - with empty wizard wrapper Id

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       03/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void saveDraft_EmptyWizardWrapperId( )
    {
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        testWizardWrapper.label = 'testLabel';
        testWizardWrapper.name = 'testName';
        testWizardWrapper.wizardId = '';

        bit2flow__Wizard_Definition__c testWizardDefinition = new bit2flow__Wizard_Definition__c( );
        testWizardDefinition.bit2flow__Name__c = testWizardWrapper.name;
        testWizardDefinition.bit2flow__Description__c = 'testDescription';
        testWizardDefinition.bit2flow__Label__c = testWizardWrapper.label;
        insert testWizardDefinition;
        //Start antonio.vatrano r1f3-75 20/09/2019
        NE__Order_Header__c oh = new NE__Order_Header__c();
        insert oh;
        String jsonString = '{"JumpToStep" : "1","OrderHeader" : { "Id" : "'+oh.id+'" } }';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( jsonString );
        //End antonio.vatrano r1f3-75 20/09/2019

        String testDraft = OB_FlowControlUtility.saveDraft( '2', data, null, testWizardWrapper, String.valueOf( testWizardWrapper ) );

        System.assertEquals( Label.OB_SavedFlowLabel, testDraft );
    }

    /*******************************************************************************
    Purpose:  Method tests saving draft - scenario - with IntegrationAdministarion Id

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       19/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void saveDraft_IntegrationAdministarion( )
    {
        bit2flow.DynamicWizardWrapper testWizardWrapper = new bit2flow.DynamicWizardWrapper( );
        testWizardWrapper.label = 'testLabel';
        testWizardWrapper.name = 'testName';
        NE__IntegrationAdministration__c testAdministration = new NE__IntegrationAdministration__c();
        testAdministration.NE__Name__c = testWizardWrapper.name;
        insert testAdministration;
        //Start antonio.vatrano r1f3-75 20/09/2019
        NE__Order_Header__c oh = new NE__Order_Header__c();
        insert oh;
        String jsonString = '{"JumpToStep" : "1","OrderHeader" : { "Id" : "'+oh.id+'" } }';
        Map<String, Object> data = ( Map<String, Object> ) JSON.deserializeUntyped( jsonString );
        //End antonio.vatrano r1f3-75 20/09/2019

        String testDraft = OB_FlowControlUtility.saveDraft( '2', data, null, testWizardWrapper, String.valueOf( testWizardWrapper ) );

        System.assertEquals( Label.OB_SavedFlowLabel, testDraft );
    }

    /*******************************************************************************
    Purpose:  Method tests saving draft - scenario - failed method

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       03/04/2019      Created         R1F2_RP_000_CC_OB_FlowControlUtility
    ********************************************************************************/
    @isTest static void saveDraft_Failed( )
    {
        String testDraft = OB_FlowControlUtility.saveDraft( '', null, null, null, '' );

        System.assertEquals( Label.OB_OperationFailedLabel, testDraft );
    }

    /*******************************************************************************
    Purpose:  Method checks value of 'step to go' - 'Dai Societa' step -
              scenario - success - with livigno case;

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0      Michal Targiel          05/07/2019         Created             NEXI-140
    ********************************************************************************/
    @isTest static void companyData_DatiSocietaStep_LivignoCheck_TEST( )
    {
        String testJSON =
                '{ "isLegalEqualAdm": true, ' +
                        '"bankOwner" : "", ' +
                        '"OB_VAT_Not_Present__c": "true", ' +
                        '"OB_DescriptionVATNotPresent__c":"Livigno", ' +
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
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = OB_UtilityConstants.FLOW_WIZARD_NAME_NUOVO_CONTRATTO;
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.companyData( '', testData, null, '', '', wizardWrapper );

        System.assertEquals( 5, testResponse.stepToGo );
    }

    /*******************************************************************************
    Purpose: Test method for getAllTitolariEffettiviPerABI
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         gianluigi.virga         12/07/2019      Created
    ********************************************************************************/
    @isTest static void getAllTitolariEffettiviPerABI()
    {
        Account testAccount = OB_TestDataFactory.getAccount();
        insert testAccount;
        Id recordTypeIdBank = Schema.SObjectType.Account.getRecordTypeInfosByName( ).get( OB_UtilityConstants.BANKRT ).getRecordTypeId( );
        Account bankAccount = OB_TestDataFactory.getAccount();
        bankAccount.RecordTypeId = recordTypeIdBank;
        bankAccount.OB_ABI__c = '03138';
        insert bankAccount;
        Id recordTypeIdTitEff = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.TITOLARE_EFFETTIVO ).getRecordTypeId( );
        Contact testContact = OB_FlowControlUtility_Test.getContact_CheckMandatory();
        testContact.AccountId = testAccount.id;
        testContact.OB_Contact_State__c = 'Active';
        testContact.RecordTypeId = recordTypeIdTitEff;
        testContact.OB_Bank__c= bankAccount.Id;
        insert testContact;
        Contact testContactDuplicate = OB_FlowControlUtility_Test.getContact_CheckMandatory();
        testContactDuplicate.AccountId = testAccount.id;
        testContactDuplicate.OB_Contact_State__c = 'Active';
        testContactDuplicate.RecordTypeId = recordTypeIdTitEff;
        testContactDuplicate.OB_Bank__c= bankAccount.Id;
        insert testContactDuplicate;

        Test.startTest();
        Boolean codFiscAlreadyExistInSFDC = OB_FlowControlUtility.getAllTitolariEffettiviPerABI(testContact.Id, testContact.OB_Fiscal_Code__c, testAccount.Id, bankAccount.OB_ABI__c);
        System.assertEquals(codFiscAlreadyExistInSFDC, true); 
        Test.stopTest();
    }
    @isTest
    public static void getLegalFormCode_Test() {
        String legalform;
        String legalformcode = 'test';
        
        NE__Lov__c listOfVal =  new NE__Lov__c();
        listOfVal.Name = 'Ente pubblico non economico';
        listOfVal.NE__Type__c = 'LegalForm';
		listOfVal.NE__Sub_Type__c = 'TIPOLOGICHE';
		listOfVal.NE__Active__c = true;
        insert listOfVal;
		
		legalform	         = listOfVal.name;
        Test.startTest();
        	String code = OB_FlowControlUtility.getLegalFormCode(legalform, legalformcode );
            System.assertEquals(code, legalformcode); 
        Test.stopTest();

    }
    /*******************************************************************************
    Purpose: Test method for checkEsecutore
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         gianluigi.virga         02/10/2019      Created          
    ********************************************************************************/
    @isTest 
    public static void checkEsecutore_Test(){
        Account testAccount = OB_TestDataFactory.getAccount();
        insert testAccount;

        Id recordTypeIdBank = Schema.SObjectType.Account.getRecordTypeInfosByName( ).get( OB_UtilityConstants.BANKRT ).getRecordTypeId( );
        Account bankAccount = OB_TestDataFactory.getAccount();
        bankAccount.RecordTypeId = recordTypeIdBank;
        bankAccount.OB_ABI__c = '03138';
        insert bankAccount;

        Id recordTypeEsecutore = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.ESECUTORE ).getRecordTypeId( );
        Contact testContact = OB_FlowControlUtility_Test.getContact_CheckMandatory();
        testContact.AccountId = testAccount.id;
        testContact.OB_Contact_State__c = 'Active';
        testContact.RecordTypeId = recordTypeEsecutore;
        testContact.OB_Bank__c = bankAccount.Id;
        insert testContact;

        Test.startTest();
        OB_FlowControlUtility.checkEsecutore(testContact.AccountId, testContact.RecordTypeId, testContact.OB_Bank__c);
        List<Contact> contactsInactive = [SELECT Id FROM Contact WHERE AccountId=: testAccount.Id AND RecordTypeId =: recordTypeEsecutore AND OB_Bank__c =: bankAccount.Id AND OB_Contact_State__c = 'Inactive'];
        System.assertEquals(testContact.Id, contactsInactive[0].Id);
        Test.stopTest();
    }

    /*******************************************************************************
   Purpose: Method checks value of 'step to go' - 'Identify Company' step -
             scenario - failed - Tested with data for cover case (LIVIGNO);
   History
   --------
   VERSION     AUTHOR                  DATE            DETAIL          Description
   1.0         Kinga Fornal            28/08/2019      Created         NEXI-280
   ********************************************************************************/
    @isTest static void identifyCompanyStepLivignoCheck( )
    {
        Account accountTest = OB_TestDataFactory.getAccount( );
        insert accountTest;

        NE__Service_Point__c servicePointTest = OB_TestDataFactory.getServicePoint( );
        insert servicePointTest;

        Map<String, Object> data = OB_FlowControlUtility_Test.prepareDataToIdentifyCompanyTest(
                '', 'true', '', String.valueOf( accountTest.Id ), '00', servicePointTest.Id, accountTest.Id, '', false, '00', true, '00;00', '', '' );
        Account merchantFromMap = ( Account ) JSON.deserialize( JSON.serialize( data.get( 'merchant' ) ), Account.class );
        merchantFromMap.OB_DescriptionVATNotPresent__c = OB_UtilityConstants.LIVIGNO;
        data.put( 'merchant', merchantFromMap );
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper( );
        wizardWrapper.Name = OB_UtilityConstants.FLOW_WIZARD_NAME_NUOVO_CONTRATTO;
        bit2flow.DynamicWizardStepWrapper testResponse = OB_FlowControlUtility.identifyCompany( '', data, null, '', '', wizardWrapper );

        System.assertEquals( 1, testResponse.stepToGo );
    }
}