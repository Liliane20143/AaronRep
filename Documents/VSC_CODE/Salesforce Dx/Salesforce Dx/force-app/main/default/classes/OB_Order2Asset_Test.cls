@isTest
public with sharing class OB_Order2Asset_Test {

    /*******************************************************************************
    Purpose:  Method tests OB_UtilityCallingServices.createAsset

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Enrico    Purificato       25/11/2019                       Created
    
    ********************************************************************************/
    @isTest 
    public static void order2Asset_Test( )
    {

        NE__Order_Header__c oh = new NE__Order_Header__c( );
        oh.OB_Main_Process__c = 'Setup';
        oh.NE__Type__c = 'ChangeOrder';
        insert oh;
        NE__Order__c ord = new NE__Order__c( NE__Order_Header__c = oh.id, OB_MCC__c = '7932' );
        ord.NE__Type__c = 'ChangeOrder'; //antonio.vatrano 09/12/2019 PERF-30
        insert ord;

        OB_LogRequest__c lr = new OB_LogRequest__c( OB_OrderId__c =ord.Id , OB_Status__c  = OB_UtilityConstants.INATTESA);
        INSERT lr;

        Id rtMerchant = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( ).get( 'Merchant' ).getRecordTypeId( );
        Account merchant = new Account( Name = 'TEST',
                RecordTypeId = rtMerchant,
                OB_Employees_Number__c = 'Minore di 10',
                OB_VAT_Not_Present__c = false,
                NE__VAT__c = '06363391001',
                OB_DescriptionVATNotPresent__c = 'description',
                NE__Fiscal_code__c = 'RSSMRA80A01F205X',
                OB_BypassValidation__c = true,
                OB_Status__c = 'Active' );
        insert merchant;

        Asset myAsset = new Asset( AccountId = merchant.Id,
                Name = 'TEST',
                NE__Status__c = 'Disconnected' );
        myAsset.NE__Status__c = 'Active';
        insert myAsset;

        Asset myAsset2 = new Asset( AccountId = merchant.Id,
                Name = 'TEST',
                NE__Order_Config__c= ord.id,
                NE__Status__c = 'Pending' );
        
        insert myAsset2;


        NE__Service_Point__c salePoint = new NE__Service_Point__c( NE__Account__c = merchant.Id,
                Name = 'TEST SP',
                OB_Status__c = 'Inactive' );
        insert salePoint;
        //NEXI Kinga Fornal, kinga.fornal@accenture.com,  08.08.20119 test fix START
        NE__OrderItem__c orderItem = New NE__OrderItem__c( NE__Startdate__c=DateTime.Now( ), NE__Qty__c = 10, NE__OrderId__c = ord.id, NE__Action__c = 'Add' );
        insert orderItem;
        orderItem.NE__AssetItemEnterpriseId__c = orderItem.Id;
        update orderItem;
        NE__OrderItem__c orderItem2 = New NE__OrderItem__c( NE__Startdate__c=DateTime.Now( ), NE__Qty__c = 10, NE__OrderId__c = ord.id, NE__Action__c = 'Add' , NE__Bundle_Configuration__c = orderItem.Id );
        insert orderItem2;
        orderItem2.NE__AssetItemEnterpriseId__c = orderItem2.Id;
        update orderItem2;
        NE__Order_Item_Attribute__c  oia = new NE__Order_Item_Attribute__c (NE__Order_Item__c = orderItem2.Id);
        insert oia;
        oia.NE__AttrEnterpriseId__c = oia.id;
        update oia;

        NE__OrderItem__c orderItem3 = New NE__OrderItem__c( NE__Startdate__c=DateTime.Now( ), NE__Qty__c = 10, NE__OrderId__c = ord.id, NE__Action__c = 'Remove' );
        insert orderItem3;
        orderItem3.OB_FulfilmentStatus__c = 'Sent';
        orderItem3.NE__AssetItemEnterpriseId__c = myAsset2.Id;
        orderItem3.NE__Bundle_Configuration__c = orderItem.Id;
        update orderItem3;

        NE__OrderItem__c orderItem1 = New NE__OrderItem__c( NE__Startdate__c=DateTime.Now( ), NE__Qty__c = 10, NE__OrderId__c = ord.id, NE__Action__c = 'Remove' );
        orderItem1.NE__AssetItemEnterpriseId__c = myAsset.id;
        insert orderItem1;
        orderItem1.NE__AssetItemEnterpriseId__c = orderItem1.Id;
        update orderItem1;
        //NEXI Kinga Fornal, kinga.fornal@accenture.com,  08.08.20119 test fix STOP
        List<NE__OrderItem__c> allLineItems = new List<NE__OrderItem__c>( );
        allLineItems.add( orderItem );
        allLineItems.add( orderItem1 );


        Asset ass = new Asset( );
        ass.AccountId = merchant.id;
        ass.IsCompetitorProduct = false;
        ass.Name = 'Offerta Personalizzata';
        ass.NE__Action__c = 'Change';
        ass.NE__AssetItemEnterpriseId__c = orderItem.id;
        ass.NE__BaseOneTimeFee__c = 0;
        ass.NE__BaseRecurringCharge__c = 0;
        ass.NE__Billing_Account__c = merchant.id;
        ass.NE__Commitment__c = false;
        ass.NE__Discount_One_time__c = 0;
        ass.NE__Discount__c = 0;
        ass.NE__Generate_Asset_Item__c = true;
        ass.NE__Item_Code__c = '';
        ass.NE__Order_Config__c = ord.id;
        ass.NE__RecurringChargeFrequency__c = 'Monthly';
        ass.NE__Remove_from_total__c = false;
        ass.NE__Service_Account__c = merchant.id;
        ass.NE__Service_Point__c = salePoint.id;
        ass.NE__Status__c = 'Active';
        ass.OB_enablement__c = 'N';
        ass.OB_MCCL2__c = '0001';
        ass.OB_MCC__c = '5200';
        ass.OB_Report_Type__c = 'Punto Vendita';
        ass.OB_Ro__c = 'N';
        ass.OB_Visible__c = 'N';
        ass.Quantity = 1;
        ass.OB_ShopSign__c = '23112';
        ass.OB_ShopCode__c = 'MANVACA';
        ass.OB_CustomerCode__c = '1016918';
        ass.OB_TermId__c = '01883677';
        ass.RecordTypeId = [ SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1 ].id;
        insert ass;

        Asset ass2 = new Asset( );
        ass2.AccountId = merchant.id;
        ass2.IsCompetitorProduct = false;
        ass2.Name = 'Offerta Personalizzata';
        ass2.NE__Action__c = 'Add';
        ass2.NE__AssetItemEnterpriseId__c = orderItem2.id;
        ass2.NE__BaseOneTimeFee__c = 0;
        ass2.NE__BaseRecurringCharge__c = 0;
        ass2.NE__Billing_Account__c = merchant.id;
        ass2.NE__Commitment__c = false;
        ass2.NE__Discount_One_time__c = 0;
        ass2.NE__Discount__c = 0;
        ass2.NE__Generate_Asset_Item__c = true;
        ass2.NE__Item_Code__c = '';
        ass2.NE__Order_Config__c = ord.id;
        ass2.NE__RecurringChargeFrequency__c = 'Monthly';
        ass2.NE__Remove_from_total__c = false;
        ass2.NE__Service_Account__c = merchant.id;
        ass2.NE__Service_Point__c = salePoint.id;
        ass2.NE__Status__c = 'Active';
        ass2.OB_enablement__c = 'N';
        ass2.OB_MCCL2__c = '0001';
        ass2.OB_MCC__c = '5200';
        ass2.OB_Report_Type__c = 'Punto Vendita';
        ass2.OB_Ro__c = 'N';
        ass2.OB_Visible__c = 'N';
        ass2.Quantity = 1;
        ass2.OB_ShopSign__c = '23112';
        ass2.OB_ShopCode__c = 'MANVACA';
        ass2.OB_CustomerCode__c = '1016918';
        ass2.OB_TermId__c = '01883677';
        ass2.RecordTypeId = [ SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1 ].id;
        insert ass2;
        
        //Start antonio.vatrano 09/12/2019 PERF-30 cover CATCH
        Asset ass3 = new Asset( );
        ass3.AccountId = merchant.id;
        ass3.IsCompetitorProduct = false;
        ass3.Name = 'Offerta Personalizzata';
        ass3.NE__Action__c = 'Add';
        ass3.NE__AssetItemEnterpriseId__c = orderItem2.id;
        ass3.NE__BaseOneTimeFee__c = 0;
        ass3.NE__BaseRecurringCharge__c = 0;
        ass3.NE__Billing_Account__c = merchant.id;
        ass3.NE__Commitment__c = false;
        ass3.NE__Discount_One_time__c = 0;
        ass3.NE__Discount__c = 0;
        ass3.NE__Generate_Asset_Item__c = true;
        ass3.NE__Item_Code__c = '';
        ass3.NE__Order_Config__c = ord.id;
        ass3.NE__RecurringChargeFrequency__c = 'Monthly';
        ass3.NE__Remove_from_total__c = false;
        ass3.NE__Service_Account__c = merchant.id;
        ass3.NE__Service_Point__c = salePoint.id;
        ass3.NE__Status__c = 'Pending';
        ass3.OB_enablement__c = 'N';
        ass3.OB_MCCL2__c = '0001';
        ass3.OB_MCC__c = '5200';
        ass3.OB_Report_Type__c = 'Punto Vendita';
        ass3.OB_Ro__c = 'N';
        ass3.OB_Visible__c = 'N';
        ass3.Quantity = 1;
        ass3.OB_ShopSign__c = '23112';
        ass3.OB_ShopCode__c = 'MANVACA';
        ass3.OB_CustomerCode__c = '1016918';
        ass3.OB_TermId__c = '01883677';
        ass3.RecordTypeId = [ SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1 ].id;
        insert ass3;
        //END antonio.vatrano 09/12/2019 PERF-30 cover CATCH

        NE__AssetItemAttribute__c  ait = new NE__AssetItemAttribute__c (NE__Asset__c = ass2.Id , NE__AttrEnterpriseId__c = oia.Id);
        insert ait;
        Test.startTest( );
        OB_UtilityCallingServices.createAsset( ord.id, 'Setup' );
        Test.stopTest( );
    }
}