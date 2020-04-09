@isTest
class OB_AssetSessionDataRescue_Test {

public static String CRON_EXP = '0 0 0 28 2 ? 2022';

static testmethod void testScheduledJob() {
    NE__Order_Header__c oh = new NE__Order_Header__c( );
        oh.OB_Main_Process__c = 'Setup';
        oh.NE__Type__c = 'ChangeOrder';
        insert oh;
        NE__Order__c ord = new NE__Order__c( NE__Order_Header__c = oh.id, OB_MCC__c = '7932' );
        insert ord;

        OB_LogRequest__c lr = new OB_LogRequest__c( OB_OrderId__c =ord.Id , OB_Status__c  = OB_UtilityConstants.INATTESA);
        INSERT lr;

        Id rtMerchant =  Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( ).get( 'Merchant' ).getRecordTypeId( );
        Account merchant = new Account( Name = 'TEST',
                RecordTypeId = rtMerchant,
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


        NE__Service_Point__c salePoint = new NE__Service_Point__c( NE__Account__c = merchant.Id,
                Name = 'TEST SP',
                OB_Status__c = 'Inactive' );
        insert salePoint;
        //NEXI Kinga Fornal, kinga.fornal@accenture.com,  08.08.20119 test fix START
        NE__OrderItem__c orderItem = New NE__OrderItem__c( NE__Startdate__c=DateTime.Now( ), NE__Qty__c = 10, NE__OrderId__c = ord.id, NE__Action__c = 'Add' );
        insert orderItem;
        NE__OrderItem__c orderItem1 = New NE__OrderItem__c( NE__Startdate__c=DateTime.Now( ), NE__Qty__c = 10, NE__OrderId__c = ord.id, NE__Action__c = 'Remove' );
        orderItem1.NE__AssetItemEnterpriseId__c = myAsset.id;
        insert orderItem1;
        //NEXI Kinga Fornal, kinga.fornal@accenture.com,  08.08.20119 test fix STOP
        List<NE__OrderItem__c> allLineItems = new List<NE__OrderItem__c>( );
        allLineItems.add( orderItem );
        allLineItems.add( orderItem1 );
        
        NE__Catalog__c testCatalog = new NE__Catalog__c( Name = 'Catalog Test' );
        insert testCatalog;

        NE__Product__c product = new NE__Product__c(
                Name = 'testProd',
                NE__Description__c = '' );
        insert product;
        
        Id rCatalogItem = Schema.SObjectType.NE__Catalog_Item__c.getRecordTypeInfosByDeveloperName( ).get( 'Tariff_Plan' ).getRecordTypeId( );
        NE__Catalog_Item__c catalogItem = new NE__Catalog_Item__c(
                NE__Active__c = true,
                NE__Catalog_Id__c = testCatalog.Id,
                NE__ProductId__c = product.Id,
                RecordTypeId =rCatalogItem );
        insert catalogItem;     

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
        ass.NE__CatalogItem__c = catalogItem.id;
        ass.RecordTypeId = [ SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1 ].id;
        insert ass;

        Test.startTest();
        String jobId = System.schedule('OB_AssetSessionDataRescue',CRON_EXP,new OB_AssetSessionDataRescue());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime
                            FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP,ct.CronExpression);
        Test.stopTest();
    }
}