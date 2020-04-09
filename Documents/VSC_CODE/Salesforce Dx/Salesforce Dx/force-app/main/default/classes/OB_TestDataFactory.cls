/**
*@author Joanna Mielczarek <joanna.mielczarek@accenture.com>
*@date 20/03/2018
*@description Test data factory class to gets simple objects
*/
@isTest
public with sharing class OB_TestDataFactory
{

    /**
    *@author Joanna Mielczarek <joanna.mielczarek@accenture.com>
    *@date 20/03/2018
    *@description Method returns test Account
    *@params -
    *@return Account
    */
    public static Account getAccount( )
    {
        Account aAccount = new Account( );
        aAccount.Name = 'aAccount';
        aAccount.NE__VAT__c = '01234567890';
        aAccount.OB_Employees_Number__c = 'Minore di 10';
        aAccount.NE__Fiscal_code__c = 'AAAAAA11A11A111A';
        aAccount.OB_ABI__c = '03138';
        aAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.ACC_RT_MERCHANT ).getRecordTypeId( );//CC Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 05/04/2019
        aAccount.OB_Legal_Address_Street__c = 'POLO DELLA QUALITA\' ASI SUD MOD	';
        aAccount.OB_Legal_Address_Street_Number__c = '';
        aAccount.OB_Legal_Address_Detail__c = 'STUDIO DE MATTEIS	';
        aAccount.OB_Legal_Address_ZIP__c = '81025';
        aAccount.OB_Legal_Address_City__c = 'MARCIANISE';
        aAccount.OB_Legal_Address_State_Code__c = '';
        aAccount.OB_Legal_Address_Country_Code__c = ''; 
        return aAccount;
    }

    /**
    *@author Micol Ferrari <micol.ferrari@accenture.com>
    *@date 05/07/2018
    *@description Method returns test Bank Account
    *@params -
    *@return Account
    */
    public static Account getBankAccount( )
    {
        Account aAccount = new Account( );
        aAccount.Name = 'aAccount';
        aAccount.OB_ABI__c = '05116';
        aAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.BANKRT ).getRecordTypeId( );//CC Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 05/04/2019
        return aAccount;
    }

    /**
    *@author Micol Ferrari <micol.ferrari@accenture.com>
    *@date 05/07/2018 
    *@description Method returns test Bank Profile
    *@params -
    *@return OB_Bank_Profile__c
    */
    public static OB_Bank_Profile__c getBankProfile(Account bankAccount )
    {
        OB_Bank_Profile__c bankprof = new OB_Bank_Profile__c( );
        bankprof.OB_Bank__c = bankAccount.Id;
        bankprof.OB_NeedBIO__c = true;
        bankprof.OB_Applicant_RAC_Code_SIA__c = 'Nexi';
        bankprof.OB_Bilateral_Pricing__c = 'NO';
        bankprof.OB_Business_Model_POS__c = 'Trilaterale Nuovo';
        bankprof.OB_Circuit__c = 'Micropagamenti';
        bankprof.OB_GT__c = 'Nexi';
        bankprof.OB_Other_Acquirer__c = 'Amex';
        bankprof.OB_Processor__c = 'EQUENS (KCCS)';
        bankprof.OB_SME_Factory__c = 'SI';
        bankprof.OB_Sending_Contract_to_Nexi__c = 'SI';
        bankprof.OB_Service_Type__c = 'Acquiring';
        bankprof.OB_Technical_component_invoicing__c = 'Al p.v.';
        bankprof.OB_Terminal_Id_Generator__c = 'Nexi';
        return bankprof;
    }

    /**
    *@author Joanna Mielczarek <joanna.mielczarek@accenture.com>
    *@date 20/03/2018
    *@description Method returns test Contact
    *@param testAccount
    *@return Contact
    */
    public static Contact getContact( Account aAccount )
    {
        Contact cContact = new Contact( );
        cContact.LastName = 'cContact';
        cContact.AccountId = aAccount.id;
        cContact.FirstName = 'john';
        cContact.LastName = 'Smith';
        cContact.OB_Birth_City__c = 'Roma';
        cContact.OB_Country_Birth__c = 'Italy';
        cContact.Email = 'test@yahoo.fr';
        cContact.OB_Sex__c = 'M';
        cContact.OB_Document_Type__c = 'Patente';
        cContact.OB_Document_Release_Authority__c = 'Motorizzazione';
        //START gianluigi.virga 16/07/2019
        cContact.OB_Document_Release_Country__c = 'ITALIA';
        cContact.OB_Document_Release_Country_Code__c = 'ITA';
        //END gianluigi.virga
        return cContact;
    }

    /**
    *@author Joanna Mielczarek <joanna.mielczarek@accenture.com>
    *@date 20/03/2018
    *@description Method returns Partner Community User profile
    *@params -
    *@return Profile
    */
    public static Profile getNexiPartnerUserProfile( )
    {
        Profile partnerProfile = [ SELECT Id FROM Profile WHERE Name = :OB_UtilityConstants.NEXI_PARTNER_USER_PROFILE_NAME LIMIT 1 ];

        return partnerProfile;
    }

    /**
    *@author Joanna Mielczarek <joanna.mielczarek@accenture.com>
    *@date 20/03/2018
    *@description Method returns Nexi Partner Approver L1 profile
    *@params -
    *@return Profile
    */
    public static Profile getNexiPartnerApproverL1Profile( )
    {
        Profile partnerProfile = [ SELECT Id FROM Profile WHERE Name = :OB_UtilityConstants.NEXI_PARTNER_APPROVER_L1_PROFILE_NAME LIMIT 1 ];

        return partnerProfile;
    }

    /**
    *@author Joanna Mielczarek <joanna.mielczarek@accenture.com>
    *@date 22/03/2018
    *@description Method returns Nexi Partner Approver L2 profile
    *@params -
    *@return Profile
    */
    public static Profile getNexiPartnerApproverL2Profile( )
    {
        Profile partnerProfile = [ SELECT Id FROM Profile WHERE Name = :OB_UtilityConstants.NEXI_PARTNER_APPROVER_L2_PROFILE_NAME LIMIT 1 ];

        return partnerProfile;
    }

    /**
    *@author Joanna Mielczarek <joanna.mielczarek@accenture.com>
    *@date 28/03/2018
    *@description Method returns Nexi Partner Approver L3 profile
    *@params -
    *@return Profile
    */
    public static Profile getNexiPartnerApproverL3Profile( )
    {
        Profile partnerProfile = [ SELECT Id FROM Profile WHERE Name = :OB_UtilityConstants.NEXI_PARTNER_APPROVER_L3_PROFILE_NAME LIMIT 1 ];

        return partnerProfile;
    }

    /**
    *@author Joanna Mielczarek <joanna.mielczarek@accenture.com>
    *@date 20/03/2018
    *@description Method returns System Administrator profile
    *@params -
    *@return Profile
    */
    public static Profile getSystemAdministratorProfile( )
    {
        Profile systemAdministratorProfile = [ SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1 ];

        return systemAdministratorProfile;
    }

    /**
    *@author Joanna Mielczarek <joanna.mielczarek@accenture.com>
    *@date 20/03/2018
    *@description Method returns new test User with System Administrator Profile
    *@params -
    *@return User
    */
    public static User getPortalAccountOwner( )
    {
        UserRole portalRole = [ Select Id From UserRole Where PortalType = 'None' Limit 1 ];
        Profile portalAdmin = getSystemAdministratorProfile( );

        User uUser = new User( );
        uUser.ProfileId = portalAdmin.Id;
        uUser.Username = 'portalAccountOwner@test.com';
        uUser.Alias = 'alias';
        uUser.Email = 'portalAccountOwner@test.com';
        uUser.EmailEncodingKey = 'UTF-8';
        uUser.Firstname = 'firstName';
        uUser.Lastname = 'lastName';
        uUser.LanguageLocaleKey = 'en_US';
        uUser.LocaleSidKey = 'en_US';
        uUser.TimeZoneSidKey = 'America/Chicago';
        uUser.UserRoleId = portalRole.Id;

        return uUser;
    }

    /*******************************************************************************
    Purpose:  Method to get a user to assign 'Nexi Approver L3' profile
    Parameters: -
    Returns: User
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Salvatore Pianura     16/04/2019        Created         /FixOnUserTrigger
    ********************************************************************************/
    public static User getUserL3( )
    {
        User thisUser = new User( );
        thisUser.Username = 'OB_UserTriggerHandler_Test@test.com';
        thisUser.Alias = 'alias';
        thisUser.Email = 'OB_UserTriggerHandler_Test@test.com';
        thisUser.EmailEncodingKey = 'UTF-8';
        thisUser.LastName = 'lastName';
        thisUser.CommunityNickname = 'test12345';
        thisUser.TimeZoneSidKey = 'America/Los_Angeles';
        thisUser.LocaleSidKey = 'en_US';
        thisUser.LanguageLocaleKey = 'en_US';
        return thisUser;
    }

    /**
    *@author Zuzanna Urban <z.urban@accenture.com>
    *@date 22/03/2018
    *@description Method to get user
    *@return User
    */
    public static User getUser( )
    {
        User uUser = new User( );
        uUser.Username = 'OB_UserTriggerHandler_Test@test.com';
        uUser.Alias = 'alias';
        uUser.Email = 'OB_UserTriggerHandler_Test@test.com';
        uUser.EmailEncodingKey = 'UTF-8';
        uUser.LastName = 'lastName';
        uUser.CommunityNickname = 'test12345';
        uUser.TimeZoneSidKey = 'America/Los_Angeles';
        uUser.LocaleSidKey = 'en_US';
        uUser.LanguageLocaleKey = 'en_US';
        uUser.OB_CAB__c = '12345';

        return uUser;
    }

    /**
    *@author Joanna Mielczarek <joanna.mielczarek@accenture.com>
    *@date 20/03/2018
    *@description Method returns test current User
    *@param testContact
    *@return User
    */
    public static User getCommunityUser( Contact testContact )
    {
        User uUser = new User( );
        uUser.Username = 'user123123@test.com';
        uUser.ContactId = testContact.Id;
        uUser.Alias = 'alias';
        uUser.Email = 'user@test.com';
        uUser.EmailEncodingKey = 'UTF-8';
        uUser.LastName = 'lastName';
        uUser.CommunityNickname = 'test12345';
        uUser.TimeZoneSidKey = 'America/Los_Angeles';
        uUser.LocaleSidKey = 'en_US';
        uUser.LanguageLocaleKey = 'en_US';
        uUser.OB_CAB__c = '12345';

        return uUser;
    }

    public static NE__Order_Header__c getOrderHeader( )
    {
        NE__Order_Header__c ohOrderHeader = new NE__Order_Header__c( );

        return ohOrderHeader;
    }

    /**
    *@author Joanna Mielczarek <joanna.mielczarek@accenture.com>
    *@date 20/03/2018
    *@description Method returns new test Order
    *@params -
    *@return Profile
    */
    public static NE__Order__c getOrder( NE__Order_Header__c ohOrderHeader )
    {
        NE__Order__c oOrder = new NE__Order__c( );
        oOrder.NE__Order_Header__c = ohOrderHeader.Id;
        oOrder.OwnerId = UserInfo.getUserId( );
        oOrder.OB_ApprovalType__c = 'Pricing';
        oOrder.OB_BankApprovalStatus__c = 'To Approve';
        oOrder.OB_ABI__c = '05116';

        return oOrder;
    }

    /**
    *@author Grzegorz Banach <grzegorz.banach@accenture.com>
    *@date 25/03/2018
    *@description Method creates an Order Item
    *@params Id inOrderId
    *@return NE__OrderItem__c
    *@history 25/03/2018 Method created
    */
    public static NE__OrderItem__c getOrderItem( Id inOrderId )
    {
        return new NE__OrderItem__c( NE__OrderId__c = inOrderId, NE__Qty__c = 1 );
    }

    /**
    *@author Grzegorz Banach <grzegorz.banach@accenture.com>
    *@date 25/03/2018
    *@description Method creates bit2flow Wizard Definition
    *@params -
    *@return bit2flow__Wizard_Definition__c
    *@history 25/03/2018 Method created
    */
    public static bit2flow__Wizard_Definition__c getWizardDefinition( )
    {
        return new bit2flow__Wizard_Definition__c(
                bit2flow__Description__c = 'Test Wizard',
                bit2flow__Name__c = 'Test Wizard',
                bit2flow__Label__c = 'Test Wizard'
        );
    }

    /**
    *@author Grzegorz Banach <grzegorz.banach@accenture.com>
    *@date 25/03/2018
    *@description Method creates bit2flow Historic Wizard Data
    *@params Id inWizardId
    *@return bit2flow__Historic_Wizard_Data__c
    *@history 25/03/2018 Method created
    */
    public static bit2flow__Historic_Wizard_Data__c getHistoricWizard( Id inWizardId )
    {
        return new bit2flow__Historic_Wizard_Data__c(
                bit2flow__Wizard_Name__c = 'Test Historic Wizard',
                bit2flow__Wizard_Id__c = inWizardId
        );
    }

    /**
    *@author Joanna Mielczarek <joanna.mielczarek@accenture.com>
    *@date 21/03/2018
    *@description Method returns process result of approval test order
    *@param testOrder
    *@return -
    */
    public static Approval.ProcessResult getApprovalProcessResult( NE__Order__c oOrder )
    {
        Id adminProfileId = getSystemAdministratorProfile( ).Id;
        User systemAdminUser = [ SELECT Id FROM User WHERE ProfileId = :adminProfileId LIMIT 1 ];

        Approval.ProcessSubmitRequest submitRequest = new Approval.ProcessSubmitRequest( );
        submitRequest.setComments( 'Submitting request for approval.' );
        submitRequest.setObjectId( oOrder.Id );
        submitRequest.setSkipEntryCriteria( true );
        submitRequest.setNextApproverIds( new Id[] {systemAdminUser.Id} );
        Approval.ProcessResult processResult = Approval.process( submitRequest );

        return processResult;
    }

    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 21/03/2019
    * @description Method create simple matrix parameter object
    * @params  -
    * @return NE__Matrix_Parameter__c
    */
    public static NE__Matrix_Parameter__c getMatrixParameter( )
    {
        NE__Matrix_Parameter__c result = new NE__Matrix_Parameter__c( );
        return result;
    }

    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 21/03/2019
    * @description Method create simple matrix parameter row object
    * @params  Id inMatrixParameterId
    * @return NE__Matrix_Parameter_Row__c
    */
    public static NE__Matrix_Parameter_Row__c getMatrixParameterRow( Id inMatrixParameterId )
    {
        NE__Matrix_Parameter_Row__c result = new NE__Matrix_Parameter_Row__c( );
        result.NE__Matrix_Parameter__c = inMatrixParameterId;
        return result;
    }

    /*******************************************************************************
    Purpose:  Method returns Asset
    Parameters: -
    Returns: Asset
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       03/04/2019        Created           [RP_000]
    ********************************************************************************/
    public static Asset getAsset( )
    {
        Asset aAsset = new Asset( );
        aAsset.Name = 'testAsset';
        aAsset.RecordTypeId = [ SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1 ].id;
        return aAsset;
    }

    /*******************************************************************************
    Purpose:  Method returns NE__AssetItemAttribute__c
    Parameters: String assetId
    Returns: NE__AssetItemAttribute__c
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       03/04/2019        Created           [RP_000]
    ********************************************************************************/
    public static NE__AssetItemAttribute__c getAssetItemAttribute( String assetId )
    {
        NE__AssetItemAttribute__c assetItemAttribute = new NE__AssetItemAttribute__c( );
        assetItemAttribute.Name = 'testAssetItemAttribute';
        assetItemAttribute.NE__Asset__c = assetId;
        return assetItemAttribute;
    }

    /*******************************************************************************
    Purpose:  Method returns NE__Order__c
    Parameters: -
    Returns: NE__Order__c
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       03/04/2019        Created           [RP_000]
    ********************************************************************************/
    public static NE__Order__c getOrder( )
    {
        NE__Order__c order = new NE__Order__c( );
        return order;
    }

    /*******************************************************************************
    Purpose:  Method returns NE__OrderItem__c
    Parameters: String orderId
    Returns: NE__OrderItem__c
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       03/04/2019        Created           [RP_000]
    ********************************************************************************/
    public static NE__OrderItem__c getOrderItem( String orderId )
    {
        NE__OrderItem__c orderItem = new NE__OrderItem__c( );
        orderItem.NE__Qty__c = 1;
        orderItem.NE__OrderId__c = orderId;
        return orderItem;
    }

    /*******************************************************************************
    Purpose:  Method returns NE__Order_Item_Attribute__c
    Parameters: String orderItemId
    Returns: NE__Order_Item_Attribute__c
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       03/04/2019        Created           [RP_000]
    ********************************************************************************/
    public static NE__Order_Item_Attribute__c getOrderItemAttribute( String orderItemId )
    {
        NE__Order_Item_Attribute__c orderItemAttribute = new NE__Order_Item_Attribute__c( );
        orderItemAttribute.Name = 'testAssetItemAttribute';
        orderItemAttribute.NE__Order_Item__c = orderItemId;
        return orderItemAttribute;
    }

    /*******************************************************************************
    Purpose:  Method returns NE__Product__c
    Parameters: -
    Returns: NE__Product__c
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       03/04/2019        Created           [RP_000]
    ********************************************************************************/
    public static NE__Product__c getProduct( )
    {
        NE__Product__c product = new NE__Product__c( );
        product.Name = 'testProduct';
        return product;
    }

    /*******************************************************************************
    Purpose:  Method returns NE__Service_Point__c
    Parameters: -
    Returns: NE__Service_Point__c
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       04/04/2019        Created           [RP_000]
    ********************************************************************************/
    public static NE__Service_Point__c getServicePoint( )
    {
        NE__Service_Point__c servicePoint = new NE__Service_Point__c( );
        servicePoint.Name = 'testServicePoint';
        return servicePoint;
    }

    /*******************************************************************************
    Purpose:  Method returns NE__Family__c
    Parameters: -
    Returns: NE__Family__c
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       08/04/2019        Created           [RP_000]
    ********************************************************************************/
    public static NE__Family__c getFamily( )
    {
        NE__Family__c family = new NE__Family__c( );
        return family;
    }

    /*******************************************************************************
    Purpose:  Method returns NE__DynamicPropertyDefinition__c
    Parameters: -
    Returns:NE__DynamicPropertyDefinition__c
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       08/04/2019        Created           [RP_000]
    ********************************************************************************/
    public static NE__DynamicPropertyDefinition__c getDynamicPropertyDefinition( )
    {
        NE__DynamicPropertyDefinition__c dynamicPropertyDefinition = new NE__DynamicPropertyDefinition__c( );
        return dynamicPropertyDefinition;
    }

    /*******************************************************************************
    Purpose:  Method returns NE__ProductFamilyProperty__C
    Parameters: String familyId, String propId
    Returns: NE__ProductFamilyProperty__c
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       08/04/2019        Created           [RP_000]
    ********************************************************************************/
    public static NE__ProductFamilyProperty__C getProductFamilyProperty( String familyId, String propId )
    {
        NE__ProductFamilyProperty__c productFamilyProperty = new NE__ProductFamilyProperty__c( );
        productFamilyProperty.NE__FamilyId__c = familyId;
        productFamilyProperty.NE__PropId__c = propId;
        return productFamilyProperty;
    }

    /*******************************************************************************
    Purpose:  Method returns OB__LogRequest__c
    Parameters: -
    Returns: OB__LogRequest__c
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       09/04/2019        Created           [RP_000]
    ********************************************************************************/
    public static OB_LogRequest__c getLogRequest( )
    {
        OB_LogRequest__c logRequest = new OB_LogRequest__c( );
        Account a = OB_TestDataFactory.getAccount();
        insert a;
        logRequest.OB_AccountId__c = a.id;
        logRequest.OB_ChangeCompanyData__c = false;
        logRequest.OB_ChangeLegalForm__c = false;
        logRequest.OB_NewLegalRepresentative__c = false;
        logRequest.OB_ChangeLegalRepresentative__c = false;
        logRequest.OB_ChangeMerchantName__c = false; 
        logRequest.OB_ChangeServicePointData__c = false;
        logRequest.OB_Status__c = OB_UtilityConstants.LOGREQUEST_STATUS_DRAFT;
        logRequest.OB_SIAToBeApproved__c=false;
        logRequest.OB_ReducedOldData__c='{"obj":[{"attributes":{"type":"Contact","url":"/services/data/v46.0/sobjects/Contact/0039E00000mpvFPQAY"},"OB_Document_Number__c":"docNumb885","Id":"0039E00000mpvFPQAY"}]}';
        logRequest.OB_ReducedNewData__c='{"obj":[{"attributes":{"type":"Contact","url":"/services/data/v46.0/sobjects/Contact/0039E00000mpvFPQAY"},"OB_Document_Number__c":"docNumb880","Id":"0039E00000mpvFPQAY"}]}';
        return logRequest;
    }

    /*******************************************************************************
    Purpose:  Method returns OB__Contract__c
    Parameters: -
    Returns: OB__Contract__c
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       11/04/2019        Created           [RP_000]
    ********************************************************************************/
    public static OB_Contract__c getContract( )
    {
        OB_Contract__c testContract = new OB_Contract__c( );
        return testContract;
    }

    /*******************************************************************************
    Purpose:  Method returns Contract
    Parameters: Account merchant
    Returns: Contract
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Damian Krzyzaniak      18/07/2019       Created           [NEXI-121]
    ********************************************************************************/
    public static Contract getContract( Id merchantId )
    {
        Contract cContract = new Contract( );
        cContract.AccountId = merchantId;
        return cContract;
    }

    /*******************************************************************************
    Purpose:  Method returns OB_Integration_Configuration__c
    Parameters: -
    Returns: OB_Integration_Configuration__c
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       12/04/2019        Created           [RP_000]
    ********************************************************************************/
    public static OB_Integration_Configuration__c getIntegrationConfiguration( )
    {
        OB_Integration_Configuration__c testIntegrationConfiguration = new OB_Integration_Configuration__c( );
        testIntegrationConfiguration.Name = 'DEV1';
        return testIntegrationConfiguration;
    }

    /*******************************************************************************
    Purpose:  Method returns NE__Lov__c
    Parameters: -
    Returns: NE__Lov__c
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       12/04/2019        Created           [RP_000]
    ********************************************************************************/
    public static NE__Lov__c getLov( )
    {
        NE__Lov__c testLov = new NE__Lov__c( );
        return testLov;
    }

    /*******************************************************************************
    Purpose:  Method returns generic NE__Lov__c of type MCC
    Parameters: -
    Returns: NE__Lov__c
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Grzegorz Banach       9/07/2019        Created           NEXI-146
    ********************************************************************************/
    public static NE__Lov__c getGenericMCCLov( )
    {
        return new NE__Lov__c(
                NE__Value1__c = '',
                NE__Value2__c = '7299',
                NE__Value3__c = 'L3',
                NE__Type__c = 'MCC'
        );
    }

    /*******************************************************************************
    Purpose:  Method returns NE__Lov__c of type MCC for Gambling
    Parameters: -
    Returns: NE__Lov__c
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Grzegorz Banach       9/07/2019        Created           NEXI-146
    ********************************************************************************/
    public static NE__Lov__c getGamblingMCCLov( )
    {
        return new NE__Lov__c(
                NE__Value1__c = OB_UtilityConstants.MCC_LOV_GAMBLING,
                NE__Value2__c = '7995',
                NE__Value3__c = 'L3',
                NE__Type__c = 'MCC'
        );
    }

    /*******************************************************************************
    Purpose:  Method returns OB_Special_Category_Configuration__c
    Parameters: -
    Returns: OB_Special_Category_Configuration__c
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       12/04/2019        Created           [RP_000]
    1.1         Grzegorz Banach      21/05/2019        Modified
    ********************************************************************************/
    public static OB_Special_Category_Configuration__c getSpecialCategoryConfiguration( )
    {
        Id rtIdFormaGiuridica = Schema.SObjectType.OB_Special_Category_Configuration__c.getRecordTypeInfosByDeveloperName( ).get( 'OB_FORMA_GIURIDICA' ).getRecordTypeId( );
        return new OB_Special_Category_Configuration__c(
            Name = 'Test special category configuration',
            OB_ATECO__c = '',
            OB_DescriptionNoVat__c = '',
            OB_EngineCodeCommercialProduct__c = '',
            OB_isCrowdfunding__c = false,
            OB_Legal_Form__c = 'SSC',
            OB_MCC__c = '',
            OB_OrderHeader__c = '',
            OB_RequestType__c = '',
            RecordTypeId = rtIdFormaGiuridica );
    }

    /*******************************************************************************
    Purpose:  Method returns OB_Product_Document__c
    Parameters: -
    Returns: OB_Product_Document__c
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien      12/04/2019        Created           [RP_000]
    ********************************************************************************/
    public static OB_Product_Document__c getProductDocument( )
    {
        OB_Product_Document__c testProductDocument = new OB_Product_Document__c( );
        return testProductDocument;
    }

    /*******************************************************************************
    Purpose:  Method returns NE___Catalog__c
    Parameters: -
    Returns: NE___Catalog__c
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       18/04/2019        Created           [RP_000]
    ********************************************************************************/
    public static NE__Catalog__c getCatalog( )
    {
        NE__Catalog__c testCatalog = new NE__Catalog__c( );
        return testCatalog;
    }

    /*******************************************************************************
    Purpose:  Method returns NE___Catalog_Item__c
    Parameters: -
    Returns: NE___Catalog_Item__c
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       18/04/2019        Created           [RP_000]
    ********************************************************************************/
    public static NE__Catalog_Item__c getCatalogItem( String catalogId, String productId )
    {
        NE__Catalog_Item__c testCatalogItem = new NE__Catalog_Item__c( );
        testCatalogItem.NE__ProductId__c = productId;
        testCatalogItem.NE__Catalog_Id__c = catalogId;
        return testCatalogItem;
    }

    /*******************************************************************************
    Purpose:  Method returns Billing Profile
    Parameters: String
    Returns: NE__BillingProfile__c
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki      18/04/2019        Created           [RP_000]
    ********************************************************************************/
    public static NE__Billing_Profile__c getBillingProfile( String inAccountId )
    {
        NE__Billing_Profile__c bBillingProfile = new NE__Billing_Profile__c( );
        bBillingProfile.NE__Account__c = inAccountId;
        return  bBillingProfile;
    }


    /*******************************************************************************
    Purpose:  Method returns ExternalSourceMapping__c
    Parameters: -
    Returns: ExternalSourceMapping__c
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       18/06/2019        Created           [NEXI-87]
    ********************************************************************************/
    public static ExternalSourceMapping__c getExternalSourceMapping( )
    {
        ExternalSourceMapping__c externalSourceMapping = new ExternalSourceMapping__c( );
        return externalSourceMapping;
    }

    /*******************************************************************************
    Purpose: Method prepares lov for tests
    Parameters: String type, String value2
    Return: String testLov.Name
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       26/07/2019         Created         NEXI-120
    ********************************************************************************/
    public static String prepareLovForTest( String type, String value2 )
    {
        NE__Lov__c testLov = OB_TestDataFactory.getLov( );
        testLov.NE__Type__c = type;
        testLov.NE__Value2__c = value2;
        testLov.Name = '101';
        insert testLov;
        return testLov.Name;
    }

    /*******************************************************************************
    Purpose: Method prepares User for partner community.
    Parameters: Contact
    Return: User
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Roland Nieznanski     21/10/2019         Created         Contact should have email
    ********************************************************************************/
    public static User getCommunityUserWithInsert( Contact testContact )
    {
        Profile prof1 = [SELECT Id FROM Profile WHERE Name = 'Nexi Partner User' limit 1];

        User testUser = new User();
        testUser.Username = 'user123123@test.com';
        testUser.ContactId = testContact.id;
        testUser.ProfileId = prof1.id;
        testUser.Alias = 'alias';
        testUser.Email = testContact.Email;
        testUser.EmailEncodingKey = 'UTF-8';
        testUser.LastName = 'lastName';
        testUser.CommunityNickname = 'test12345';
        testUser.TimeZoneSidKey = 'America/Los_Angeles';
        testUser.LocaleSidKey = 'en_US';
        testUser.LanguageLocaleKey = 'en_US';
        testUser.OB_CAB__c = '12345';
        Id userId = Site.createExternalUser(testUser, testContact.accountId, null, false);
        testUser.Id = userId;
        return testUser;
    }

}