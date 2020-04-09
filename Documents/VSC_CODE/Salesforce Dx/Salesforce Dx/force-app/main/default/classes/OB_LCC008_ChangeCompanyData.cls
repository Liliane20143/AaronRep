/*******************************************************************************
Purpose:  Class that is controller for OB_LCP008_ChangeCompanyData component
Parameters: -
Returns: -

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         Adrian Dlugolecki       09/07/2019      Created         NEXI-178
********************************************************************************/
public with sharing class OB_LCC008_ChangeCompanyData
{
    private static final Id RT_MERCHANT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.MERCHANTRT ).getRecordTypeId( );

    /*******************************************************************************
    Purpose:  Class that is wrapper for all data required in maintenance flow
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       09/07/2019      Created         NEXI-178
    ********************************************************************************/
    private class FlowInputWrapper
    {
        public String outcome;
        public String errorMessage;
        public Account acc;
        public Contact executor;
        public Contact legalOffice;
        public List<NE__Service_Point__c> listOfServicePoint;
        public String selectedServicePoint;
        public String selectedServicePointExt;
        public Boolean executorModifiedAllowed;
        public String selectedMerchantExt;
        public String selectedMerchantAsset;
        public String selectedServicePointAsset;
        public Asset selectedAsset;
        public List<String> selectServicePointListId;
        public List<NE__Lov__c> lovList;
    }

    /*******************************************************************************
    Purpose:  Class that is wrapper for all data that we need to send to component from init
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       09/07/2019      Created         NEXI-178
    ********************************************************************************/
    public class InitOutputWrapper
    {
        @AuraEnabled
        public String resultJSON;
        @AuraEnabled
        public Boolean isError = false;
        @AuraEnabled
        public String errorMessage;
        @AuraEnabled
        public Boolean showButton;
    }

    /*******************************************************************************
    Purpose:  Method that is executed on init of component. It prepare data for flow (select account and contact)
                and check if button willbe showed ( base on account rt and user profile)
    Parameters: Id inAccountId
    Returns: InitOutputWrapper

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       09/07/2019      Created         NEXI-178
    1.1         Kinga Fornal            02/08/2019      Modified        NEXI-292 Added OB_Employees_Number__c
    ********************************************************************************/
    @AuraEnabled
    public static InitOutputWrapper retrieveDataForEditAccount( Id inAccountId )
    {
        List<Account> accounts =
        [
                SELECT id,
                        Name,
                        OB_Legal_Address_Name__c,
                        NE__Fiscal_code__c,
                        NE__VAT__c,
                        OB_Legal_Address_City__c,
                        OB_Legal_Address_State__c,
                        OB_Legal_Address_Street__c,
                        OB_FATECO__c,
                        OB_ATECO__c,
                        OB_CCIAA__c,
                        OB_SAE_Code__c,
                        OB_Legal_Form__c,
                        OB_CCIAA_Province_Code__c,
                        OB_Legal_Address_Street_Number__c,
                        OB_Legal_Address_ZIP__c,
                        OB_Legal_Address_Country__c,
                        OB_Administrative_Office_State__c,
                        OB_Administrative_Office_Country__c,
                        OB_Administrative_Office_ZIP__c,
                        OB_Administrative_Office_Street_Number__c,
                        OB_Administrative_Office_Street__c,
                        OB_Administrative_Office_Address_Details__c,
                        OB_Administrative_Office_City__c,
                        OB_CCIAA_Province__c,
                        OB_Legal_Form_Code__c,
                        OB_Legal_Address_Country_Code__c,
                        OB_Legal_Address_State_Code__c,
                        OB_Administrative_Office_Country_Code__c,
                        OB_Administrative_Office_State_Code__c,
                        OB_BypassValidation__c,
                        OB_SAE_Description__c,
                        OB_ATECO_Description__c,
                        RecordTypeId,
                        OB_Employees_Number__c  //NEXI-292 R1F3-20 Kinga Fornal <kinga.fornal@accenture.com> 02/09/2019
                FROM Account
                WHERE id = :inAccountId
        ];
        InitOutputWrapper result = new InitOutputWrapper( );
        result.showButton = false;
        FlowInputWrapper dataContainer = new FlowInputWrapper( );
        if ( accounts.isEmpty( ) )
        {
            result.isError = true;
            result.errorMessage = 'No account found for ' + inAccountId;
            return result;
        }
        String userProfile = [ SELECT Profile.Name FROM User WHERE id = :UserInfo.getUserId( ) ].get( 0 ).Profile.Name;
        result.showButton = RT_MERCHANT == accounts.get( 0 ).RecordTypeId && 'Operation'.equalsIgnoreCase( userProfile );
        dataContainer.acc = accounts.get( 0 );
        dataContainer.executor = getActiveExecutorFromAccount( inAccountId );
        result.resultJSON = JSON.serialize( dataContainer );
        return result;
    }

    /*******************************************************************************
    Purpose: Method selects and returns active Executor for specified Account
    Parameters: String accountId
    Returns: Contact

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien         08/07/2019       Created         NEXI-165
    ********************************************************************************/
    private static Contact getActiveExecutorFromAccount( String accountId )
    {
        List <Contact> activeExecutors =
        [
                SELECT Id,
                        Fax,
                        Phone,
                        Email,
                        LastName,
                        FirstName,
                        OB_PEC__c,
                        OB_PEP__c,
                        OB_Sex__c,
                        Mobilephone,
                        OB_Birth_Date__c,
                        OB_Birth_City__c,
                        OB_Fiscal_code__c,
                        OB_Birth_State__c,
                        OB_Citizenship__c,
                        OB_Country_Birth__c,
                        OB_Document_Type__c,
                        OB_Address_Country__c,
                        OB_Document_Number__c,
                        OB_Birth_State_Code__c,
                        OB_Company_Link_Type__c,
                        OB_Country_Birth_Code__c,
                        OB_Document_Release_State__c,
                        OB_Document_Release_Country__c,
                        OB_Document_Release_State_Code__c,
                        OB_Document_Release_Country_Code__c,
                        OB_Document_Release_Authority__c,
                        OB_Document_Release_Date__c,
                        OB_Document_Expiration_Date__c,
                        OB_Document_Release_City__c,
                        OB_Address_Street__c,
                        OB_Address_Street_Number__c,
                        OB_Address_City__c,
                        OB_Address_State__c,
                        OB_Address_PostalCode__c,
                        OB_Address_Hamlet__c,
                        OB_Address_State_Code__c,
                        OB_Address_Country_Code__c,
                        OB_Contact_State__c,
                        AccountId,
                        RecordTypeId
                FROM Contact
                WHERE AccountId = :accountId
                AND OB_Contact_State__c = :OB_UtilityConstants.STATUS_ACTIVE
                AND RecordType.Name = :OB_UtilityConstants.ESECUTORE
                LIMIT 1
        ];
        return activeExecutors.isEmpty( ) ? new Contact( ) : activeExecutors.get( 0 );
    }
}