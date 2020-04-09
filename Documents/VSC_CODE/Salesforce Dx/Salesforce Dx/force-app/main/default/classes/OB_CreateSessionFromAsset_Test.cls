@isTest
private class OB_CreateSessionFromAsset_Test 
{
    @testSetup
    static void setup() 
    {   
        OB_Integration_Configuration__c ic = new OB_Integration_Configuration__c();
        ic.Name = 'DEV1';
        ic.OB_Domain__c = 'dev1';
        ic.OB_Token_1__c = 'eyJ0eXAiOiJKV1QiLCJjdHkiOiJKV1QiLCJhbGciOiJSU0EtT0FFUCIsImVuYyI6IkExMjhDQkMtSFMyNTYifQ.nynF9045u2M-1WGn007JxObPiM3PBK0Q4GM8EBwQS0o6fJutTABfMSTtekOlCpQEv4vKSLmj0-Rgk5rQgireCX-cOp_Vvh9IYLl6xfOJfUR8f5mLUmY4r7BGrWtLbaM5wwTIJXQs8kFpp2VIePragkN2MahtjIOtBp1vQW2y';
        ic.OB_timestamp__c = '1542902538147';
        ic.OB_Timeout_Continuation__c = '30';
        insert ic;

        Account acc  = new Account(); 
        acc.Name         = 'TEST';
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Bank'].id;
        acc.OB_Employees_Number__c         = 'Minore di 10';
        acc.OB_VAT_Not_Present__c          = false;
        acc.OB_DescriptionVATNotPresent__c = 'description';
        acc.NE__Fiscal_code__c             = 'RSSMRA80A01F205X';
        acc.OB_BypassValidation__c         = true;
        acc.OB_Status__c                   = 'Active'; 
        acc.NE__VAT__c                     = '12312312312'; 
        acc.OB_ABI__c                      = '05696';
        insert acc;
 
        NE__Bundle__c bundle = new NE__Bundle__c( Name	= 'test',
											  								NE__Configuration_Type__c 		= 'Free',
											  								NE__BaseRecurringCharge__c		= 12.00,
											  								NE__RecurringChargeFrequency__c = 'Annual',
											  								NE__Start_Date__c 				= system.now(),
											  								NE__End_Date__c 				= system.now().addDays(1)	);
		insert bundle;

        NE__Order_Header__c oh    = new NE__Order_Header__c(OB_Business_Model_Acquiring__c = 'Bancario', 
                                                            OB_Business_Model_POS__c = 'Trilaterale Nuovo', 
                                                            OB_Main_Process__c = 'Setup');
        insert oh;
        NE__Service_Point__c sp   = new NE__Service_Point__c();
        sp.OB_MCC__c   ='2345';
        sp.NE__City__c = 'Yaounde';
        insert sp;
        
        NE__Billing_Profile__c bp = new NE__Billing_Profile__c(NE__Account__c = acc.id);
        insert bp;

        NE__Order__c ord        = new NE__Order__c(NE__Order_Header__c = oh.id);
        ord.NE__AccountId__c    = acc.id;
        ord.NE__BillAccId__c    = acc.Id;
        ord.NE__ServAccId__c    = acc.Id;
        ord.OB_MCCL2__c         = '0000';
        ord.OB_GT__c		    = 'Nexi';
        ord.OB_Service_Point__c = sp.id;
        ord.NE__BillingProfId__c = bp.Id;    
        insert ord; 
        
        NE__Product__c prod       = new NE__Product__c();
        Id rtCommission = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Commissione').getRecordTypeId();
        prod.RecordTypeId = rtCommission;
        insert prod;

        NE__Catalog__c cat        = new NE__Catalog__c();
        insert cat;
        NE__Catalog_Item__c ci    = new NE__Catalog_Item__c(NE__Catalog_Id__c = cat.id ,NE__ProductId__c = prod.id);
        insert ci;

        NE__Bit2Win_Session__c sess = new NE__Bit2Win_Session__c ();
        insert sess;

        Id rtStd = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        Asset assFather = new Asset();
        assFather.Name = 'test';
        assFather.AccountId = acc.id;
        assFather.NE__Billing_Account__c = acc.id;
        assFather.NE__Service_Account__c = acc.id;
        assFather.recordTypeId = rtStd;
        assFather.NE__Status__c ='Active';
        assFather.NE__Order_Config__c = ord.id;
        assFather.NE__BillingProf__c = bp.Id; 
        assFather.quantity = 1;
        assFather.OB_B2W_Session__c = 'xyz#' + sess.id;
        insert assFather;

        
        Asset ass = new Asset();
        ass.recordTypeId = rtStd;
        ass.NE__Order_Config__c = ord.id;
        ass.NE__BillingProf__c = bp.Id;
        ass.NE__CatalogItem__c              = ci.id;
        ass.quantity = 1;
        ass.AccountId                       = acc.id;
        ass.NE__Billing_Account__c = acc.id;
        ass.NE__Service_Account__c = acc.id;
        ass.OB_DebitProfId__c               = bp.id;
        ass.OB_ProposerABI__c               = acc.id;
        ass.IsCompetitorProduct             = false;
        ass.IsInternal                      = false;
        ass.Name                            = 'Offerta Personalizzata';
        ass.NE__Action__c                   = 'Change';
        ass.NE__AssetItemEnterpriseId__c    = '123123123';
        ass.NE__BaseOneTimeFee__c           = 0;
        ass.NE__BaseRecurringCharge__c      = 0;
        ass.NE__Billing_Account__c          = acc.id;
        ass.NE__Commitment__c               = false;
        ass.NE__Discount_One_time__c        = 0;
        ass.NE__Discount__c                 = 0;
        ass.NE__Generate_Asset_Item__c      = true;
        //ass.NE__Item_Code__c                = '';
        ass.NE__Order_Config__c             = ord.id;
        ass.NE__ProdId__c                   = prod.id;
        ass.NE__RecurringChargeFrequency__c = 'Monthly';
        ass.NE__Remove_from_total__c        = false;
        ass.NE__Service_Account__c          = acc.id;
        ass.NE__Service_Point__c            = sp.id;
        ass.NE__Status__c                   = 'Active';
        ass.OB_enablement__c                = 'N';
        ass.OB_MCCL2__c                     = '0001';
        ass.OB_MCC__c                       = '5200';
        ass.OB_Report_Type__c               = 'Punto Vendita';
        ass.OB_Ro__c                        = 'N';
        ass.OB_Visible__c                   = 'N';
        ass.Quantity                        = 1;
        ass.OB_ShopSign__c                  = '23112';
        ass.NE__Order_Config__c             = ord.id;
        ass.NE__ProdId__c                   = prod.id;
        ass.NE__Bundle_Configuration__c     = assFather.id;
        
       insert ass;

    }
 

    @isTest
    public static void createSession()
    {
    	Test.startTest();
        
        Asset assFather = [SELECT id , name from Asset WHERE NE__Bundle_Configuration__c = null LIMIT 1];
        Set<Id> roots = new set<Id>();
        roots.add(assFather.Id);
        Id jobID = Database.executeBatch(new OB_CreateSessionFromAsset(roots));
        
        System.assertEquals(jobID != null, true);
        Test.stopTest();      

    }
    
}