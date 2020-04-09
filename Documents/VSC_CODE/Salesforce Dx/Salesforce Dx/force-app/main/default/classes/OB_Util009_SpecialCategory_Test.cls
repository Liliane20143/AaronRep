/*********************************************************************
Name:  OB_Util009_SpecialCategory_Test
======================================================================
History

  AUTHOR            DATE CREATED        DESCRIPTION
  Szuba          	26/07/2019			Test class for OB_Util009_SpecialCategory
  Wojciech

**********************************************************************/

@IsTest
private class OB_Util009_SpecialCategory_Test
{
    /*******************************************************************************
     Purpose:  Test with return Null Special Category
     History
     --------
     VERSION     AUTHOR                  DATE            DETAIL          Description
     1.0         Zuzanna Urban           17/07/2019      Created         NEXI-208
     2.0         Wojciech Szuba          19/07/2019      Modified        NEXI-208
     ********************************************************************************/
    @isTest
    private static void detectSpecialCategoryForWrongIdTest( )
    {
        Account testAccount = OB_TestDataFactory.getAccount( );
        insert testAccount;
        Map<Id, List<String>> testMap = OB_Util009_SpecialCategory.detectSpecialCategory( new List<Id> { testAccount.Id } );
        System.assertEquals( new Map<Id, List<String>>( ), testMap );
    }

    /*******************************************************************************
    Purpose:  Test with return Special Category that contains Gambling, Fiduciarie, Trust and Crowdfunding for Log Request
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Zuzanna Urban          	17/07/2019      Created         NEXI-208
    2.0         Wojciech Szuba          19/07/2019      Modified        NEXI-208
    ********************************************************************************/
    @isTest
    private static void detectSpecialCategoryLogRequestPartOneTest( )
    {
        Account testAccount = OB_TestDataFactory.getAccount( );
        testAccount.OB_ATECO__c = OB_UtilityConstants.GAMBLING_VALUE_920;
        testAccount.OB_SAE_Code__c = OB_UtilityConstants.FIDUCIARIE_VALUE_273;
        testAccount.OB_Legal_Form__c = OB_UtilityConstants.LEGAL_FORM_TRUST;
        testAccount.OB_Legal_Form_Code__c = OB_UtilityConstants.LEGAL_FORM_CODE_TRUST;
        testAccount.OB_IsCrowdfunding__c = true;
        insert testAccount;
        OB_LogRequest__c testLogRequest = OB_TestDataFactory.getLogRequest( );
        testLogRequest.OB_AccountId__c = testAccount.Id;
        insert testLogRequest;
        Map<Id, List<String>> specialCategoryMap = OB_Util009_SpecialCategory.detectSpecialCategory( new List<Id> {testLogRequest.Id} );
        System.assert( !specialCategoryMap.get( testLogRequest.Id ).isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Test with return Special Category that contains Onlus and Moneytransfer for Log Request
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Szuba          19/07/2019      Created         NEXI-208
    ********************************************************************************/
    @isTest
    private static void detectSpecialCategoryLogRequestPartTwoTest( )
    {
        OB_LogRequest__c testLogRequest = OB_TestDataFactory.getLogRequest( );
        Account testAccount = OB_TestDataFactory.getAccount( );
        testAccount.OB_Legal_Form__c = OB_UtilityConstants.DESCRIPTIONVAT_NO_PROFIT;
        testAccount.OB_Legal_Form_Code__c = OB_UtilityConstants.LEGAL_FORM_CODE_NO_PROFIT;
        testAccount.OB_ATECO__c = OB_UtilityConstants.MONEYTRANSFER_VALUE_66195;
        insert testAccount;
        testLogRequest.OB_AccountId__c = testAccount.Id;
        insert testLogRequest;
        Map<Id, List<String>> specialCategoryMap = OB_Util009_SpecialCategory.detectSpecialCategory( new List<Id> {testLogRequest.Id} );
        System.assert( !specialCategoryMap.get( testLogRequest.Id ).isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Test with return Special Category that the order is gambling - for Log Request
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Szuba          19/07/2019      Created         NEXI-208
    1.1         Joanna Mielczarek       30/08/2019      Modified        NEXI-288 align test to new logic
    ********************************************************************************/
    @isTest
    private static void detectSpecialCategoryLogRequestFromMCCTest( )
    {
        // NEXI-288 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 30/08/2019 START
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        testOrder.OB_MCC__c = OB_UtilityConstants.GAMBLING_VALUE_7995;
        insert testOrder;
        // NEXI-288 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 30/08/2019 STOP
        Account testAccount = OB_TestDataFactory.getAccount( );
        insert testAccount;
        OB_LogRequest__c testLogRequest = OB_TestDataFactory.getLogRequest( );
        testLogRequest.OB_OrderId__c = testOrder.Id; // NEXI-288 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 30/08/2019
        testLogRequest.OB_AccountId__c = testAccount.Id;
        insert testLogRequest;
        Map<Id, List<String>> specialCategoryMap = OB_Util009_SpecialCategory.detectSpecialCategory( new List<Id> {testLogRequest.Id} );
        System.assert( specialCategoryMap.get( testLogRequest.Id ).contains( OB_UtilityConstants.SPECIAL_CATEGORY_GAMBLING ) );
    }

    /*******************************************************************************
    Purpose:  Test with return Special Category that the order is gambling - for Order Header
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       30/08/2019      Created         NEXI-288
    ********************************************************************************/
    @isTest
    private static void detectSpecialCategoryOrderHeaderFromMCC( )
    {
        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        insert testOrderHeader;
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( testOrderHeader );
        testOrder.OB_MCC__c = OB_UtilityConstants.GAMBLING_VALUE_7996;
        insert testOrder;
        Map<Id, List<String>> specialCategoryMap = OB_Util009_SpecialCategory.detectSpecialCategory( new List<Id> {testOrderHeader.Id} );
        System.assert( specialCategoryMap.get( testOrderHeader.Id ).contains( OB_UtilityConstants.SPECIAL_CATEGORY_GAMBLING ) );
    }

    /*******************************************************************************
    Purpose:  Test with return Special Category that contains Gambling, Fiduciarie, Trust and Crowdfunding for OrderHeader
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Szuba          19/07/2019      Created         NEXI-208
    ********************************************************************************/
    @isTest
    private static void detectSpecialCategoryOrderHeaderPartOneTest( )
    {
        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        Account testAccount = OB_TestDataFactory.getAccount( );
        testAccount.OB_ATECO__c = OB_UtilityConstants.GAMBLING_VALUE_920;
        testAccount.OB_SAE_Code__c = OB_UtilityConstants.FIDUCIARIE_VALUE_273;
        testAccount.OB_Legal_Form__c = OB_UtilityConstants.LEGAL_FORM_TRUST;
        testAccount.OB_Legal_Form_Code__c = OB_UtilityConstants.LEGAL_FORM_CODE_TRUST;
        testAccount.OB_IsCrowdfunding__c = true;
        insert testAccount;
        testOrderHeader.NE__AccountId__c = testAccount.Id;
        insert testOrderHeader;
        Map<Id, List<String>> specialCategoryMap = OB_Util009_SpecialCategory.detectSpecialCategory( new List<Id> {testOrderHeader.Id} );
        System.assert( !specialCategoryMap.get( testOrderHeader.Id ).isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Test with return Special Category that contains Onlus and Moneytransfer for OrderHeader
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Szuba          19/07/2019      Created         NEXI-208
    ********************************************************************************/
    @isTest
    private static void detectSpecialCategoryOrderHeaderPartTwoTest( )
    {
        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        Account testAccount = OB_TestDataFactory.getAccount( );
        testAccount.OB_Legal_Form__c = OB_UtilityConstants.DESCRIPTIONVAT_NO_PROFIT;
        testAccount.OB_Legal_Form_Code__c = OB_UtilityConstants.LEGAL_FORM_CODE_NO_PROFIT;
        testAccount.OB_ATECO__c = OB_UtilityConstants.MONEYTRANSFER_VALUE_66195;
        insert testAccount;
        testOrderHeader.NE__AccountId__c = testAccount.Id;
        insert testOrderHeader;
        Map<Id, List<String>> specialCategoryMap = OB_Util009_SpecialCategory.detectSpecialCategory( new List<Id>{ testOrderHeader.Id } );
        System.assert( !specialCategoryMap.get( testOrderHeader.Id ).isEmpty( ) );
    }
}