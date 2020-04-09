/****************************************************************
* Controller class name : OB_Maintenance_Pricing_Log_Request_CC *
* Created date:  24/01/2019									    *
*****************************************************************/


@isTest
public with sharing class OB_Maintenance_Pricing_Log_Request_Test {

	@isTest    
	public static void retrieveLogRequestTest()  
    {
    	Id terminaliProductRecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Terminali').getRecordTypeId(); 
        Id pricingProductRecordTypeId   = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Pricing').getRecordTypeId();
        Datetime startDatePOS = Datetime.newInstance(2008, 12, 1, 12, 30, 2);
        
        NE__Order_Header__c oh = new NE__Order_Header__c();
		insert oh;

        NE__Order__c ord = new NE__Order__c(NE__Order_Header__c = oh.id);
        insert ord;
        
        NE__Product__c prodTerminali = new NE__Product__c(RecordTypeId = terminaliProductRecordTypeId);      
        insert prodTerminali;  
        
        NE__Product__c prodPricing = new NE__Product__c(RecordTypeId = pricingProductRecordTypeId); 
        insert prodPricing; 
        
        NE__OrderItem__c parentOi = new NE__OrderItem__c(NE__OrderId__c = ord.Id, NE__Qty__c = 1, NE__ProdId__c = prodTerminali.id);    
        insert parentOi;

        NE__OrderItem__c oi = new NE__OrderItem__c(NE__OrderId__c = ord.Id, NE__Qty__c = 1, NE__ProdId__c = prodPricing.id, NE__Parent_Order_Item__c = parentOi.id, NE__Action__c = 'Remove');    
        insert oi;
        
		OB_LogRequest__c lr = new OB_LogRequest__c();
        lr.OB_OrderId__c = ord.id;
		insert lr;

		List<OB_LogRequest__c> requestList  = new List<OB_LogRequest__c> ();

		Test.startTest();
		OB_Maintenance_Pricing_Log_Request_CC.retrieveLogRequest(lr.id);
        OB_Maintenance_Pricing_Log_Request_CC.retrieveLogRequest(null);
		Test.stopTest();
	}
    
    @isTest
    public static void getVisibilityProfilesTest(){
        OB_LogRequest__c logrequest = new OB_LogRequest__c();
        
        Test.startTest();
		OB_Maintenance_Pricing_Log_Request_CC.getVisibilityProfiles(logRequest);
		Test.stopTest();        
    } 
  


    @isTest    
	public static void saveDate_Test() {
        
        Datetime startDatePOS       = Datetime.newInstance(2008, 12, 1, 12, 30, 2);//Datetime.newInstance(2008, 12, 1, 12, 30,  
		Datetime startDateAcquiring = Datetime.newInstance(2008, 12, 1, 12, 30, 2);
		Boolean isAcquiring 		= true ; 
		Boolean isPOS               = true ;

        Id rtProductTerminali = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Terminali').getRecordTypeId(); 
        Id rtProductPricing   = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Pricing').getRecordTypeId();
        Id rtProduct2         = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Acquiring').getRecordTypeId(); 

        NE__Product__c product1 = new NE__Product__c(RecordTypeId = rtProductTerminali);      
        insert product1;    
        NE__Product__c product2 = new NE__Product__c();
        product2.Name = 'test';
        product2.RecordTypeId = rtProduct2;      
        insert product2; 

        NE__Product__c product3 = new NE__Product__c(RecordTypeId = rtProductPricing);      
        insert product3; 

        NE__Order_Header__c orderHeader = new NE__Order_Header__c();
		insert orderHeader;

         NE__Order__c ord1 = new NE__Order__c(NE__Order_Header__c = orderHeader.id);
        insert ord1;

        NE__Order__c config = new NE__Order__c(NE__Order_Header__c=orderHeader.Id);
		insert config;

        NE__OrderItem__c parent1 = new NE__OrderItem__c(NE__OrderId__c=config.Id, NE__Qty__c=10);    
        parent1.NE__ProdId__c = product1.Id;
        parent1.RecordTypeId  = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByName().get('Acquiring').getRecordTypeId(); 
        insert parent1;

        NE__OrderItem__c parent2 = new NE__OrderItem__c(NE__OrderId__c=config.Id, NE__Qty__c=10);    
        parent2.NE__ProdId__c = product2.id;
        parent2.RecordTypeId  = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByName().get('Acquiring').getRecordTypeId(); 
        insert parent2;

        NE__OrderItem__c order = new NE__OrderItem__c(NE__Qty__c=10,NE__OrderId__c=config.Id);
        order.NE__ProdId__c = product3.id; 
        order.NE__Action__c='Change';
        order.NE__Parent_Order_Item__c = parent1.Id;      
        insert order;


        NE__OrderItem__c order1 = new NE__OrderItem__c(NE__Qty__c=10,NE__OrderId__c=config.Id);
        order1.NE__ProdId__c = product3.id;
        order1.NE__Action__c='Change';
        order1.NE__Parent_Order_Item__c = parent2.Id;      
        insert order1;
        
        List<NE__OrderItem__c> orderItemsList  = new List<NE__OrderItem__c>();
        //orderItemsList.add(order);
        orderItemsList.add(order1);

        OB_LogRequest__c lr = new OB_LogRequest__c(OB_orderId__c=config.Id);
		
        //  micol.ferrari 19/12/2019 - START
        NE__OrderItem__c oi1 = new NE__OrderItem__c(NE__OrderId__c=config.Id, NE__Qty__c=10);    
        oi1.NE__ProdId__c = product1.Id;
        oi1.RecordTypeId  = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByName().get('Acquiring').getRecordTypeId(); 
        insert oi1;

        NE__OrderItem__c oi2 = new NE__OrderItem__c(NE__OrderId__c=config.Id, NE__Qty__c=10);    
        oi2.NE__ProdId__c = product2.id;
        oi2.NE__Bundle_Configuration__c = oi1.id;
        oi2.RecordTypeId  = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByName().get('Acquiring').getRecordTypeId(); 
        insert oi2;
        //  micol.ferrari 19/12/2019 - STOP

		//lr.OB_AccountId__c = acc.id;
		lr.OB_ABI__c = '12345';
		lr.OB_ChangeMerchantName__c = true;
		lr.OB_ChangeCompanyData__c = true;
		lr.OB_ChangeLegalForm__c = true;
		lr.OB_NewLegalRepresentative__c = true;
		lr.OB_ChangeLegalRepresentative__c = true;
		lr.OB_ChangeServicePointData__c = true;
		insert lr;

        NE__Order_Header__c oh = new NE__Order_Header__c();
		oh.OB_Main_Process__c = 'Setup';
		oh.NE__Type__c        = 'ChangeOrder';
		insert oh;
		NE__Order__c ord = new NE__Order__c(NE__Order_Header__c = oh.id, OB_MCC__c='7932');
		insert ord;

		Id merchantRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Merchant').getRecordTypeId();
		Account merchant = new Account( Name='TEST', 
			RecordTypeId=merchantRecordTypeId, 
			OB_Employees_Number__c='Minore di 10',
			OB_VAT_Not_Present__c=false, 
			NE__VAT__c = '06363391001',
			OB_DescriptionVATNotPresent__c='description', 
			NE__Fiscal_code__c='RSSMRA80A01F205X',
			OB_BypassValidation__c=true,
			OB_Status__c='Active');
		insert merchant;

		Asset myAsset 	= new Asset(AccountId     = merchant.Id,
									Name          ='TEST',
									NE__Status__c ='Disconnected');
		myAsset.NE__Status__c 	= 'Active';
		insert myAsset;
		
		
		NE__Service_Point__c salePoint = new NE__Service_Point__c(	NE__Account__c=merchant.Id,
															Name='TEST SP',
															OB_Status__c='Inactive');
		insert salePoint;
		NE__OrderItem__c orderItem = New NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=ord.id, NE__Action__c = 'Add');
		insert orderItem;		
		NE__OrderItem__c orderItem1 = New NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=ord.id, NE__Action__c = 'Remove');
		orderItem1.NE__AssetItemEnterpriseId__c = myAsset.id;
		insert orderItem1;
		List<NE__OrderItem__c> allLineItems = new List<NE__OrderItem__c>();
		allLineItems.add(orderItem);
		allLineItems.add(orderItem1);
		
        //  micol.ferrari 19/12/2019 - change var name - START 
		Asset assy = new Asset();
        assy.AccountId                       = merchant.id;
        assy.IsCompetitorProduct             = false;
        assy.Name                            = 'Offerta Personalizzata';
        assy.NE__Action__c                   = 'Change';
        assy.NE__AssetItemEnterpriseId__c    = orderItem.id;
        assy.NE__BaseOneTimeFee__c           = 0;
        assy.NE__BaseRecurringCharge__c      = 0;
        assy.NE__Billing_Account__c          = merchant.id;
        assy.NE__Commitment__c               = false;
        assy.NE__Discount_One_time__c        = 0;
        assy.NE__Discount__c                 = 0;
        assy.NE__Generate_Asset_Item__c      = true;
        assy.NE__Item_Code__c                = '';
        assy.NE__Order_Config__c             = config.Id;
        assy.NE__RecurringChargeFrequency__c = 'Monthly';
        assy.NE__Remove_from_total__c        = false;
        assy.NE__Service_Account__c          = merchant.id;
        assy.NE__Service_Point__c            = salePoint.id;
        assy.NE__Status__c                   = 'Active';
        assy.OB_enablement__c                = 'N';
        assy.OB_MCCL2__c                     = '0001';
        assy.OB_MCC__c                       = '5200';
        assy.OB_Report_Type__c               = 'Punto Vendita';
        assy.OB_Ro__c                        = 'N';
        assy.OB_Visible__c                   = 'N';
        assy.Quantity                        = 1;
        assy.OB_ShopSign__c                  = '23112';
        assy.OB_ShopCode__c                  = 'MANVACA';
        assy.OB_CustomerCode__c              = '1016918';
        assy.OB_TermId__c                    = '01883677';
        assy.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1].id;
    	insert assy;	
        //  micol.ferrari 19/12/2019 - change var name - START 

		List<Asset> assets = new List<Asset> ();
		assets.add(assy);
		assets.add(myAsset);
        Test.startTest();
        OB_Maintenance_Pricing_Log_Request_CC.saveDatePOS(startDatePOS, lr.id);
        OB_Maintenance_Pricing_Log_Request_CC.saveDateAcquiring(startDatePOS, lr.id);
        OB_Maintenance_Pricing_Log_Request_CC.rejectRequestPOS(lr.Id);
        OB_Maintenance_Pricing_Log_Request_CC.rejectRequestAcquiring(lr.Id);
		Test.stopTest();

    }
    
    @isTest
    public static void saveDatePOSTest()
    {
        Id terminaliProductRecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Terminali').getRecordTypeId(); 
        Id pricingProductRecordTypeId   = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Pricing').getRecordTypeId();
        Datetime startDatePOS = Datetime.newInstance(2008, 12, 1, 12, 30, 2);
        
        NE__Order_Header__c oh = new NE__Order_Header__c();
		insert oh;

        NE__Order__c ord = new NE__Order__c(NE__Order_Header__c = oh.id);
        insert ord;
        
        NE__Product__c prodTerminali = new NE__Product__c(RecordTypeId = terminaliProductRecordTypeId);      
        insert prodTerminali;  
        
        NE__Product__c prodPricing = new NE__Product__c(RecordTypeId = pricingProductRecordTypeId); 
        insert prodPricing; 
        
        NE__OrderItem__c parentOi = new NE__OrderItem__c(NE__OrderId__c = ord.Id, NE__Qty__c = 1, NE__ProdId__c = prodTerminali.id);    
        insert parentOi;

        NE__OrderItem__c oi = new NE__OrderItem__c(NE__OrderId__c = ord.Id, NE__Qty__c = 1, NE__ProdId__c = prodPricing.id, NE__Parent_Order_Item__c = parentOi.id);    
        insert oi;
        
        OB_LogRequest__c lr = new OB_LogRequest__c();
        lr.OB_orderId__c = ord.id;
		lr.OB_ABI__c = '12345';
		lr.OB_ChangeMerchantName__c = true;
		lr.OB_ChangeCompanyData__c = true;
		lr.OB_ChangeLegalForm__c = true;
		lr.OB_NewLegalRepresentative__c = true;
		lr.OB_ChangeLegalRepresentative__c = true;
		lr.OB_ChangeServicePointData__c = true;
		insert lr;
        
        Test.startTest();
        OB_Maintenance_Pricing_Log_Request_CC.saveDatePOS(startDatePOS, lr.id);
        Test.stopTest();
    }
    
    @isTest
    public static void saveDateAcquiringTest()
    {
        Id pricingProductRecordTypeId   = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Pricing').getRecordTypeId();
        Id VASProductRecordTypeId   = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Vas').getRecordTypeId();
        Datetime startDateAcquiring = Datetime.newInstance(2008, 12, 1, 12, 30, 2);
        
        NE__Order_Header__c oh = new NE__Order_Header__c();
		insert oh;

        NE__Order__c ord = new NE__Order__c(NE__Order_Header__c = oh.id);
        insert ord;
        
        NE__Product__c prodVAS = new NE__Product__c(RecordTypeId = VASProductRecordTypeId);      
        insert prodVAS;  
        
        NE__Product__c prodPricing = new NE__Product__c(RecordTypeId = pricingProductRecordTypeId); 
        insert prodPricing; 
        
        NE__OrderItem__c parentOi = new NE__OrderItem__c(NE__OrderId__c = ord.Id, NE__Qty__c = 1, NE__ProdId__c = prodVAS.id);    
        insert parentOi;

        NE__OrderItem__c oiRemove = new NE__OrderItem__c(NE__OrderId__c = ord.Id, NE__Qty__c = 1, NE__ProdId__c = prodPricing.id, NE__Parent_Order_Item__c = parentOi.id, NE__Action__c = 'Remove');    
        insert oiRemove;
        
        NE__OrderItem__c oiNone = new NE__OrderItem__c(NE__OrderId__c = ord.Id, NE__Qty__c = 1, NE__ProdId__c = prodPricing.id, NE__Parent_Order_Item__c = parentOi.id, NE__Action__c = 'None');    
        insert oiNone;
        
        OB_LogRequest__c lr = new OB_LogRequest__c();
        lr.OB_orderId__c = ord.id;
		lr.OB_ABI__c = '12345';
		lr.OB_ChangeMerchantName__c = true;
		lr.OB_ChangeCompanyData__c = true;
		lr.OB_ChangeLegalForm__c = true;
		lr.OB_NewLegalRepresentative__c = true;
		lr.OB_ChangeLegalRepresentative__c = true;
		lr.OB_ChangeServicePointData__c = true;
		insert lr;

        
        //  micol.ferrari 19/12/2019 - START
        NE__OrderItem__c oi1 = new NE__OrderItem__c(NE__OrderId__c=ord.Id, NE__Qty__c=10);    
        oi1.NE__ProdId__c = prodPricing.Id;
        oi1.RecordTypeId  = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByName().get('Acquiring').getRecordTypeId(); 
        insert oi1;

        NE__OrderItem__c oi2 = new NE__OrderItem__c(NE__OrderId__c=ord.Id, NE__Qty__c=10);    
        oi2.NE__ProdId__c = prodPricing.id;
        oi2.NE__Bundle_Configuration__c = oi1.id;
        oi2.RecordTypeId  = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByName().get('Acquiring').getRecordTypeId(); 
        insert oi2;        

        Id merchantRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Merchant').getRecordTypeId();
		Account merchant = new Account( Name='TEST', 
			RecordTypeId=merchantRecordTypeId, 
			OB_Employees_Number__c='Minore di 10',
			OB_VAT_Not_Present__c=false, 
			NE__VAT__c = '06363391001',
			OB_DescriptionVATNotPresent__c='description', 
			NE__Fiscal_code__c='RSSMRA80A01F205X',
			OB_BypassValidation__c=true,
			OB_Status__c='Active');
		insert merchant;
        NE__Service_Point__c salePoint = new NE__Service_Point__c(	NE__Account__c=merchant.Id,
															Name='TEST SP',
															OB_Status__c='Inactive');
		insert salePoint;
        //  micol.ferrari 19/12/2019 - STOP

        //  micol.ferrari 19/12/2019 - change var name - START 
		Asset assy = new Asset();
        assy.AccountId                       = merchant.id;
        assy.IsCompetitorProduct             = false;
        assy.Name                            = 'Offerta Personalizzata';
        assy.NE__Action__c                   = 'Change';
        assy.NE__AssetItemEnterpriseId__c    = parentOi.id;
        assy.NE__BaseOneTimeFee__c           = 0;
        assy.NE__BaseRecurringCharge__c      = 0;
        assy.NE__Billing_Account__c          = merchant.id;
        assy.NE__Commitment__c               = false;
        assy.NE__Discount_One_time__c        = 0;
        assy.NE__Discount__c                 = 0;
        assy.NE__Generate_Asset_Item__c      = true;
        assy.NE__Item_Code__c                = '';
        assy.NE__Order_Config__c             = ord.Id;
        assy.NE__RecurringChargeFrequency__c = 'Monthly';
        assy.NE__Remove_from_total__c        = false;
        assy.NE__Service_Account__c          = merchant.id;
        assy.NE__Service_Point__c            = salePoint.id;
        assy.NE__Status__c                   = 'Active';
        assy.OB_enablement__c                = 'N';
        assy.OB_MCCL2__c                     = '0001';
        assy.OB_MCC__c                       = '5200';
        assy.OB_Report_Type__c               = 'Punto Vendita';
        assy.OB_Ro__c                        = 'N';
        assy.OB_Visible__c                   = 'N';
        assy.Quantity                        = 1;
        assy.OB_ShopSign__c                  = '23112';
        assy.OB_ShopCode__c                  = 'MANVACA';
        assy.OB_CustomerCode__c              = '1016918';
        assy.OB_TermId__c                    = '01883677';
        assy.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1].id;
    	insert assy;	
        //  micol.ferrari 19/12/2019 - change var name - START 
        
        Test.startTest();
        OB_Maintenance_Pricing_Log_Request_CC.saveDateAcquiring(startDateAcquiring, lr.id);
        Test.stopTest();
    }


}