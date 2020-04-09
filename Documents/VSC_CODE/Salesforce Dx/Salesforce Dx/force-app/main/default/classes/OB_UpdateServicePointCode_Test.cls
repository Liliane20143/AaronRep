/*****************************************************************
Name: OB_UpdateServicePointCode_Test
Copyright © 2016 ITC
============================================================
Purpose:  Class tests OB_UpdateServicePointCode methods
History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0      Kinga Fornal            13/06/2019         Created
********************************************************************************/
@isTest
public with sharing class OB_UpdateServicePointCode_Test
{ 
    /*******************************************************************************
       Purpose:  Method tests OB_UpdateServicePointCode.myOrderItem, test if the assets from
       the myOrderItem method are returned correctly
       Parameters: -
       Returns: -
       History
       --------
       VERSION     AUTHOR                  DATE            DETAIL          Description
       1.0      Kinga Fornal            13/06/2019         Created             ---
       ********************************************************************************/
    @isTest
    public static void myOrderItemTest( )
    {
        Id merchantRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( ).get( 'Merchant' ).getRecordTypeId( );
        Account merchant = new Account( Name = 'TEST',
                RecordTypeId = merchantRecordId,
                OB_Employees_Number__c = 'Minore di 10',
                OB_VAT_Not_Present__c = true,
                OB_DescriptionVATNotPresent__c = 'description',
                NE__Fiscal_code__c = 'RSSMRA80A01F205X',
                OB_BypassValidation__c = true,
                OB_ABI__c = '05696',
                OB_Status__c = 'Active' );
        insert merchant;
        Id bankRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( ).get( 'Bank' ).getRecordTypeId( );
        Account bank = new Account( Name = 'TEST',
                RecordTypeId = bankRecordId,
                OB_Employees_Number__c = 'Minore di 10',
                OB_VAT_Not_Present__c = true,
                OB_DescriptionVATNotPresent__c = 'description',
                NE__Fiscal_code__c = 'RSSMRA80A01F205X',
                OB_BypassValidation__c = true,
                OB_ABI__c = '05696',
                OB_Status__c = 'Active' );
        insert bank;
        NE__Billing_Profile__c bp = new NE__Billing_Profile__c( );
        bp.NE__Account__c = merchant.Id;
        insert bp;
        NE__Order_Header__c orderHeader = new NE__Order_Header__c( NE__AccountId__c = merchant.Id, OB_Business_Model_Acquiring__c = 'Bancario' );
        insert orderHeader;
        NE__Order__c configuration = OB_TestDataFactory.getOrder( orderHeader );
        configuration.ob_business_model_acquiring__c = 'Bancario';
        configuration.OB_ABI__c = '05696';
        insert configuration;
        Id commissioneProductRecordTypeId = [ SELECT Id FROM RecordType WHERE DeveloperName = 'Commissione' AND sObjectType = 'NE__Product__c' LIMIT 1 ].id;
        NE__Product__c product = OB_TestDataFactory.getProduct( );
        product.RecordTypeId = commissioneProductRecordTypeId;
        product.OB_Codice_sfdc__c = 'VISAMASTERCARD';
        insert product;
        Asset assetParent = new Asset( );
        assetParent.Name = 'test';
        assetParent.AccountId = bank.id;
        assetParent.NE__Status__c = OB_UtilityConstants.STATUS_ACTIVE;
        assetParent.NE__ProdId__c = product.Id;
        insert assetParent;
        Asset sampleAsset = OB_TestDataFactory.getAsset( );
        sampleAsset.NE__ProdId__c = product.Id;
        sampleAsset.AccountId = merchant.Id;
        sampleAsset.NE__Status__c = OB_UtilityConstants.STATUS_ACTIVE;
        sampleAsset.NE__Order_Config__c = configuration.id;
        sampleAsset.NE__Bundle_Configuration__c = assetParent.id;
        sampleAsset.OB_ProposerABI__c = bank.id;
        insert sampleAsset;
        NE__OrderItem__c orItem = OB_TestDataFactory.getOrderItem( configuration.Id );
        orItem.NE__ProdId__c = product.Id;
        insert orItem;

        Map<String, Object> inputMap = new Map<String, Object>( );
        inputMap.put( 'BillingProfilePOS', bp );
        inputMap.put( 'Configuration', configuration );
        inputMap.put( 'merchant', merchant );
        inputMap.put( 'bank', bank );
        String inputData = JSON.serialize( inputMap );

        Test.startTest( );
        List<Asset> result = OB_UpdateServicePointCode.myOrderItem( inputData );
        Test.stopTest( );

        System.assertEquals( result.size( ), 1 );
        System.assertEquals( result[ 0 ].Name, sampleAsset.Name );
    }

    /*******************************************************************************
      Purpose:  Method tests OB_UpdateServicePointCode.updateConventionalCode checks if
      the OB_RelatedServicePointCode__c field is updated correctly on the NE__Order__c object
      (expected Punto Vendita )
      Parameters: -
      Returns: -
      History
      --------
      VERSION     AUTHOR                  DATE            DETAIL          Description
      1.0      Kinga Fornal            14/06/2019         Created             ---
      2.0      Francesca Ribezzi        05/07/19          Modified            ---
      ********************************************************************************/
    @isTest
    public static void updateConventionalCodeTest( )
    {
        Account merchant = new Account( Name = 'TEST',
                OB_Employees_Number__c = 'Minore di 10',
                OB_VAT_Not_Present__c = true,
                OB_DescriptionVATNotPresent__c = 'description',
                NE__Fiscal_code__c = 'RSSMRA80A01F205X',
                OB_BypassValidation__c = true,
                OB_ABI__c = '05696',
                OB_Status__c = 'Active' );
        insert merchant;
        //START francesca.ribezzi 04/07/19 addinf bank, billing profile and assetId
        Id bankRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( ).get( 'Bank' ).getRecordTypeId( );
        Account bank = new Account( Name = 'TEST',
                RecordTypeId = bankRecordId,
                OB_Employees_Number__c = 'Minore di 10',
                OB_VAT_Not_Present__c = true,
                OB_DescriptionVATNotPresent__c = 'description',
                NE__Fiscal_code__c = 'RSSMRA80A01F205X',
                OB_BypassValidation__c = true,
                OB_ABI__c = '05696',
                OB_Status__c = 'Active' );
        insert bank;
        NE__Billing_Profile__c billingProfile = new NE__Billing_Profile__c( );
        billingProfile.NE__Account__c = merchant.Id;
        insert billingProfile;
        //END francesca.ribezzi 04/07/19
        NE__Order_Header__c orderHeader = new NE__Order_Header__c( NE__AccountId__c = merchant.Id );
        insert orderHeader;
        NE__Order__c configuration = OB_TestDataFactory.getOrder( orderHeader );
        configuration.ob_business_model_acquiring__c = 'Bancario';
        configuration.OB_ABI__c = '05696';
        insert configuration;
        Id acquiringRT = [ SELECT Id FROM RecordType WHERE DeveloperName = 'Acquiring' AND sObjectType = 'NE__Product__c' LIMIT 1 ].id;
        NE__Product__c product = OB_TestDataFactory.getProduct( );
        product.RecordTypeId = acquiringRT;
        product.OB_Codice_sfdc__c = 'VISAMASTERCARD';
        product.OB_Acquirer__c = 'Nexi';
        insert product;
        
        //Start Noemi Infantino WN-619 16/10/2019
        Id posRT = [ SELECT Id FROM RecordType WHERE DeveloperName = 'Terminali' AND sObjectType = 'NE__Product__c' LIMIT 1 ].id;
        NE__Product__c productPos = OB_TestDataFactory.getProduct( );
        productPos.RecordTypeId = posRT;
        productPos.OB_Codice_sfdc__c = 'SMPOS';
        productPos.OB_Acquirer__c = 'Nexi';
        insert productPos;
        //Finish Noemi Infantino WN-619 16/10/2019
        NE__Catalog__c testCatalog = new NE__Catalog__c( );
        insert testCatalog;
        NE__Catalog_Item__c testCatalogItem = new NE__Catalog_Item__c( );
        testCatalogItem.NE__ProductId__c = product.Id;
        testCatalogItem.NE__Catalog_Id__c = testCatalog.Id;
        insert testCatalogItem;
        NE__Bundle__c myBundle = new NE__Bundle__c();
        myBundle.Name = 'Acquiring e-commerce';
        myBundle.NE__Active__c = true;
        myBundle.NE__Catalog__c = testCatalog.Id;
        myBundle.NE__Catalog_Item__c = testCatalogItem.Id;
        myBundle.NE__Configuration_Type__c = 'Configure Step by Step';
        myBundle.NE__BaseRecurringCharge__c = 0;
        myBundle.NE__RecurringChargeFrequency__c = 'Monthly';
        myBundle.NE__Start_Date__c = Datetime.NOW();
        insert myBundle;
        Asset assetParent = new Asset( );
        assetParent.Name = 'test';
        assetParent.AccountId = bank.id;
        assetParent.NE__Status__c = OB_UtilityConstants.STATUS_ACTIVE;
        assetParent.NE__ProdId__c = product.Id;
        assetParent.NE__Bundle__c = myBundle.Id;
        insert assetParent;
        Asset sampleAsset = OB_TestDataFactory.getAsset( );
        sampleAsset.NE__ProdId__c = product.Id;
        sampleAsset.AccountId = merchant.Id;
        sampleAsset.NE__Status__c = OB_UtilityConstants.STATUS_ACTIVE;
        sampleAsset.NE__Order_Config__c = configuration.id;
        sampleAsset.NE__Bundle_Configuration__c = assetParent.id;
        sampleAsset.OB_ProposerABI__c = bank.id;
        insert sampleAsset;
        NE__OrderItem__c orItem = OB_TestDataFactory.getOrderItem( configuration.Id );
        orItem.NE__ProdId__c = product.Id;
        orItem.OB_ServicePointCode__c = 'Test'; //Noemi infantino 17/10/2019
        insert orItem;
        //Start Noemi Infantino WN-619 16/10/2019
        NE__OrderItem__c orItem1 = OB_TestDataFactory.getOrderItem( configuration.Id );
        orItem1.NE__ProdId__c = productPos.Id;
        orItem1.NE__Bundle_Configuration__c=orItem.id; 
        orItem1.OB_ServicePointCode__c = 'Test'; //Noemi infantino 17/10/2019
        insert orItem1;
        //Finish Noemi Infantino WN-619 16/10/2019
        Map<String, Object> objectDataMap = new  Map<String, Object>();
        objectDataMap.put('Configuration', configuration);
        objectDataMap.put('bank', bank);
        objectDataMap.put('merchant', merchant);
        objectDataMap.put('BillingProfilePOS', billingProfile);
        String objectDataMapStr = JSON.serialize(objectDataMap);
        Test.startTest( );
        String code = OB_UpdateServicePointCode.updateConventionalCode(objectDataMapStr, '123456789',assetParent.Id ); //Noemi Infantino 17/10/2019
        Test.stopTest( );

        List<NE__Order__c> configurationUpdated = [ SELECT Id, OB_RelatedServicePointCode__c FROM NE__Order__c Where Id = :configuration.Id ];
       System.assertEquals( 'Test',configurationUpdated[0].OB_RelatedServicePointCode__c ); //Noemi Infantino 17/10/2019
    }
}