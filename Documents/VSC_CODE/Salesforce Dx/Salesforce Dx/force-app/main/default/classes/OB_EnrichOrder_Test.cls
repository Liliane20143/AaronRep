@isTest
public   class OB_EnrichOrder_Test {

    // @testSetup 
	// static void setup() {
		
	// 	NE__Order_Header__c oh = new NE__Order_Header__c(OB_Business_Model_Acquiring__c = 'Diretto');
	// 	insert oh;
	// 	NE__Service_Point__c sp = new NE__Service_Point__c();
	// 	insert sp; 
	// 	NE__Service_Point__c sp2 = new NE__Service_Point__c();
	// 	insert sp2;
	// 	Account a = new Account(Name = 'a', OB_Employees_Number__c = 'Minore di 10', OB_VAT_Not_Present__c = true, OB_DescriptionVATNotPresent__c = 'description', NE__Fiscal_code__c = 'AAAAAA11A11A111A');
	// 	insert a;
	// 	NE__Order__c ord = new NE__Order__c(OB_Service_Point__c = sp.id, NE__Order_Header__c = oh.id, OB_MCCL2__c='5542', OB_MCC__c ='5542');
	// 	insert ord;
			
		// Id recordTypeIdTerminali    = [SELECT Id FROM RecordType WHERE sobjectType = 'NE__Product__c' AND DeveloperName = 'Terminali' LIMIT 1].Id;
		// Id recordTypeIdAcquiring    = [SELECT Id FROM RecordType WHERE sobjectType = 'NE__Product__c' AND DeveloperName = 'Acquiring' LIMIT 1].Id;
		// Id recordTypeIdPAGOBANCOMAT = [SELECT Id FROM RecordType WHERE sobjectType = 'NE__Product__c' AND DeveloperName = 'Pagobancomat' LIMIT 1].Id;
		// Id recordTypeIdPricing      = [SELECT Id FROM RecordType WHERE sobjectType = 'NE__Product__c' AND DeveloperName = 'Pricing' LIMIT 1].Id;
		// Id recordTypeIdCommissione  = [SELECT Id FROM RecordType WHERE sobjectType = 'NE__Product__c' AND DeveloperName = 'Commissione' LIMIT 1].Id;

		// List<NE__Product__c> prodsList = new List<NE__Product__c>();
		// NE__Product__c prod1 = new NE__Product__c(RecordTypeId = recordTypeIdTerminali, OB_Codice_sfdc__c = 'POS_TERZI_UNATTENDED');
		// NE__Product__c prod2 = new NE__Product__c(RecordTypeId = recordTypeIdAcquiring, OB_Acquirer__c = 'NEXI', OB_Codice_sfdc__c = 'ECOMM');
		// NE__Product__c prod3 = new NE__Product__c(RecordTypeId = recordTypeIdPricing, OB_Codice_sfdc__c = 'POS_TERZI_UNATTENDED' );
		// NE__Product__c prod4 = new NE__Product__c(RecordTypeId = recordTypeIdPAGOBANCOMAT, OB_Acquirer__c = 'NEXI');
		// NE__Product__c prod5 = new NE__Product__c(RecordTypeId = recordTypeIdCommissione, OB_Acquirer__c = 'NEXI', OB_Codice_sfdc__c = 'POS_TERZI_UNATTENDED');
		// prodsList.add(prod1);
		// prodsList.add(prod2);
		// prodsList.add(prod3);
		// prodsList.add(prod4);
		// prodsList.add(prod5);
		// insert prodsList;

		// List<NE__OrderItem__c> itemsList = new List<NE__OrderItem__c>(); 
		// NE__OrderItem__c itemFather      = new NE__OrderItem__c(NE__OrderId__c = ord.Id, NE__Qty__c = 1,  NE__Account__c = a.Id);
		// NE__OrderItem__c item1 = new NE__OrderItem__c(NE__OrderId__c = ord.id, NE__ProdId__c = prod1.id, NE__Qty__c = 1);
		// NE__OrderItem__c item2 = new NE__OrderItem__c(NE__OrderId__c = ord.id, NE__ProdId__c = prod2.id, NE__Qty__c = 1, NE__Parent_Order_Item__c = itemFather.Id, NE__Account__c = a.Id);
		// NE__OrderItem__c item3 = new NE__OrderItem__c(NE__OrderId__c = ord.id, NE__ProdId__c = prod3.id, NE__Qty__c = 1, NE__Parent_Order_Item__c = itemFather.Id, NE__Account__c = a.Id);
		// NE__OrderItem__c item4 = new NE__OrderItem__c(NE__OrderId__c = ord.id, NE__ProdId__c = prod4.id, NE__Qty__c = 1, NE__Parent_Order_Item__c = itemFather.Id, NE__Account__c = a.Id);
		// NE__OrderItem__c item5 = new NE__OrderItem__c(NE__OrderId__c = ord.id, NE__ProdId__c = prod5.id, NE__Qty__c = 1, NE__Parent_Order_Item__c = itemFather.Id, NE__Account__c = a.Id);
		// itemsList.add(itemFather);
		// itemsList.add(item1);
		// itemsList.add(item2); 
		// itemsList.add(item3);
		// itemsList.add(item4);
		// itemsList.add(item5);
		// insert itemsList;

		// List<NE__Order_Item_Attribute__c> attrsList = new List<NE__Order_Item_Attribute__c>();
		// NE__Order_Item_Attribute__c attr1 = new NE__Order_Item_Attribute__c(Name = 'Terminal Id', NE__Order_Item__c = item1.id, NE__Value__c = 'value');
		// NE__Order_Item_Attribute__c attr2 = new NE__Order_Item_Attribute__c(Name = 'Terminal Id', NE__Order_Item__c = item2.id);
		// NE__Order_Item_Attribute__c attr3 = new NE__Order_Item_Attribute__c(Name = 'Terminal Id', NE__Order_Item__c = item3.id);
		// NE__Order_Item_Attribute__c attr4 = new NE__Order_Item_Attribute__c(Name = 'Terminal Id', NE__Order_Item__c = item4.id);
		// attrsList.add(attr1);
		// attrsList.add(attr2);
		// attrsList.add(attr3);
		// attrsList.add(attr4);
		// insert attrsList;

	
		//Id recordTypeId = [SELECT Id FROM RecordType WHERE sobjectType = 'NE__Product__c' AND DeveloperName = 'Commissione' LIMIT 1].Id;
		
		//NE__Product__c prod1 = new NE__Product__c(RecordTypeId = recordTypeId, OB_Codice_sfdc__c = 'POS_TERZI_UNATTENDED');
		//insert prod1;
		//NE__OrderItem__c item1 = new NE__OrderItem__c(NE__OrderId__c = ord.id, NE__ProdId__c = prod1.id, NE__Account__c = a.id, NE__Qty__c = 1);
		//insert item1;
		//NE__Order_Item_Attribute__c attr1 = new NE__Order_Item_Attribute__c(Name = 'Terminal Id', NE__Order_Item__c = item1.id);
		//insert attr1;
		// ExternalSourceMapping__c esm1 = new ExternalSourceMapping__c();
		// esm1.OB_Merchant_ID__c 				= a.id;
		// esm1.OB_Service_Point_ID__c 		= sp.id;
		// esm1.OB_Business_Model__c 			= 'Diretto';
		// esm1.OB_Pricing__c 					= 'POS_TERZI_UNATTENDED';
		// esm1.OB_ToBeChecked__c 				= false;
		// esm1.OB_isMoTo__c					= false;
		// esm1.OB_Service_Point_Type__c 		= 'Fisico';
		// esm1.OB_Source__c            		= 'MONETICA';
		// esm1.OB_CustomerCodeClientCode__c   = '123';
		// esm1.OB_ServicePointCodeShopCode__c = '123';
		// esm1.OB_Conventioncode__c 			= '123';
		// esm1.OB_ConventionCodeSource__c 	= '123';
		// esm1.OB_PBSettlementMethod__c 		= '123';
		// esm1.OB_MCCL2__c 					= '1234';
		// esm1.OB_MCC__c 						= '1234';

		// insert esm1;

		// ExternalSourceMapping__c esm2 = new ExternalSourceMapping__c();
		// esm2.OB_Merchant_ID__c 				= a.id;
		// esm2.OB_Service_Point_ID__c			= sp.id;  
		// esm2.OB_Business_Model__c 			= 'Diretto';
		// esm2.OB_Pricing__c 					= 'POS_TERZI_UNATTENDED';
		// esm2.OB_ToBeChecked__c 				= false;
		// esm2.OB_isMoTo__c 					= false;
		// esm2.OB_Service_Point_Type__c 		= 'Virtuale'; 
		// esm2.OB_Source__c 					= 'EQUENS';
		// esm2.OB_CustomerCodeClientCode__c 	= '123';
		// esm2.OB_ServicePointCodeShopCode__c = '123';
		// esm2.OB_Conventioncode__c 			= '123';
		// esm2.OB_ConventionCodeSource__c 	= '123';
		// esm2.OB_PBSettlementMethod__c 		= '123'; 
		// esm2.OB_MCCL2__c 					= '1234';
		// esm2.OB_MCC__c 						= '1234';

		// insert esm2;

	// 	NE__Lov__c lov = new NE__Lov__c( Name ='Test Lov', ne__type__c = 'mcc', NE__value3__c = 'L3', NE__Value2__c = '1234');
	// 	insert lov;
    // }
    
    @isTest
    public static void setConfigurationInformationTest()
    {
       // Id confId = [SELECT Id FROM NE__Order__c LIMIT 1].Id;
        NE__Order_Header__c orderHeader = new NE__Order_Header__c();
		orderHeader.OB_Main_Process__c = 'Maintenance';
		insert orderHeader;
		NE__Order__c config = new NE__Order__c();
		config.NE__Order_Header__c = orderHeader.Id;
		insert config;
		// NE__OrderItem__c orderItem = New NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=config.id);
		// insert orderItem;		
		// NE__Order_Item_Attribute__c orderItemAtt = new NE__Order_Item_Attribute__c();
		// orderItemAtt.Name='Terminal Id';
		// orderItemAtt.NE__Value__c = 'value';
		// orderItemAtt.NE__Order_Item__c = orderItem.Id;
		// insert orderItemAtt;
		
		

		// orderItem.Name='Terminal Id';
		//insert orderItem;		
		Test.startTest();
        OB_EnrichOrder.setConfigurationInformation(config.Id);
        Test.stopTest();
    }

    
    
	
	

	//	@isTest
	//public static void setConfigurationInformation_Test2() {

	//	Id confId = [SELECT Id FROM NE__Order__c LIMIT 1].Id;

	//	NE__Order__c ord = new NE__Order__c();
	//	insert ord;
	//	Test.startTest();
	//	CLONEOB_EnrichOrder.setConfigurationInformation(confId);
	//	Test.stopTest();
		
	//}


	   @isTest
	    public static void  selectEternalRow_Test2() {
		//Id confId = [SELECT Id FROM NE__Order__c LIMIT 1].Id;
		Account a = new Account();
		a.Name = 'a';
		a.OB_Employees_Number__c = 'Minore di 10';
		a.OB_VAT_Not_Present__c = true; 
		a.OB_DescriptionVATNotPresent__c = 'description';
		a.NE__Fiscal_code__c = 'AAAAAA11A11A111A';

		
		
		

		
		a.RecordTypeId = [SELECT Id FROM RecordType WHERE sobjectType = 'Account' AND DeveloperName = 'Bank' LIMIT 1].Id;
		insert a;
        Id recordTypeIdCommissione = [SELECT Id FROM RecordType WHERE sobjectType = 'NE__Product__c' AND DeveloperName = 'Commissione' LIMIT 1].Id;
		Id recordTypeIdPagobancomat = [SELECT Id FROM RecordType WHERE sobjectType = 'NE__Product__c' AND DeveloperName = 'Pagobancomat' LIMIT 1].Id;
		Id recordTypeIdTerminali = [SELECT Id FROM RecordType WHERE sobjectType = 'NE__Product__c' AND DeveloperName = 'Terminali' LIMIT 1].Id;
        Id recordTypeIdAcquiring = [SELECT Id FROM RecordType WHERE sobjectType = 'NE__Product__c' AND DeveloperName = 'Acquiring' LIMIT 1].Id;
		Id recordTypeIdVas = [SELECT Id FROM RecordType WHERE sobjectType = 'NE__Product__c' AND DeveloperName = 'Vas' LIMIT 1].Id;
		Id recordTypeIdPricing = [SELECT Id FROM RecordType WHERE sobjectType = 'NE__Product__c' AND DeveloperName = 'Pricing' LIMIT 1].Id;


		
		NE__Product__c prod = new NE__Product__c(RecordTypeId = recordTypeIdCommissione, 
                                                 OB_Acquirer__c = 'NEXI');
        insert prod;

		NE__Product__c prod1 = new NE__Product__c(RecordTypeId = recordTypeIdCommissione, 
                                                 OB_Acquirer__c = 'NEXI');
		prod1.OB_Codice_sfdc__c='ALB_AUTO';										 
        insert prod1;


		NE__Product__c prod2 = new NE__Product__c(RecordTypeId = recordTypeIdCommissione, 
                                                 OB_Acquirer__c = 'NEXI');
        prod2.OB_Codice_sfdc__c='ONECLICK';
		insert prod2;


		NE__Product__c prod3 = new NE__Product__c(RecordTypeId = recordTypeIdCommissione, 
                                                 OB_Acquirer__c = 'NEXI');
        prod3.OB_Codice_sfdc__c='RECURRING';
		insert prod3;

		NE__Product__c prod4 = new NE__Product__c(RecordTypeId = recordTypeIdTerminali, 
                                                 OB_Acquirer__c = 'NEXI');
        prod4.OB_Codice_sfdc__c='TRANS STATICA';
		insert prod4;

		NE__Product__c prod5 = new NE__Product__c(RecordTypeId = recordTypeIdVas, 
                                                 OB_Acquirer__c = 'NEXI');
        prod5.OB_Codice_sfdc__c='TRANS DINAMICA';
		insert prod5;


		NE__Product__c prod6 = new NE__Product__c(RecordTypeId = recordTypeIdCommissione, 
                                                 OB_Acquirer__c = 'NEXI');
        prod6.OB_Codice_sfdc__c='ECOMM';
		insert prod6;

		NE__Product__c prod7 = new NE__Product__c(RecordTypeId = recordTypeIdCommissione, 
                                                 OB_Acquirer__c = 'NEXI');
        prod7.OB_Codice_sfdc__c='MOTO';
		insert prod7;

		NE__Product__c prod8 = new NE__Product__c(RecordTypeId = recordTypeIdCommissione, 
                                                 OB_Acquirer__c = 'NEXI');
        prod8.OB_Codice_sfdc__c='POS_TERZI_UNATTENDED';
		insert prod8;

		NE__Product__c prod9 = new NE__Product__c(RecordTypeId = recordTypeIdPagobancomat, 
                                                 OB_Acquirer__c = 'NEXI');
        prod9.OB_Codice_sfdc__c='POS_TERZI_UNATTENDED';
		prod9.OB_Acquirer__c='NEXI';
		insert prod9;

		NE__Product__c prod10 = new NE__Product__c(RecordTypeId = recordTypeIdAcquiring, 
                                                 OB_Acquirer__c = 'NEXI');
        prod8.OB_Codice_sfdc__c='POS_TERZI_UNATTENDED';
		insert prod10;






		NE__Order_Header__c oh = new NE__Order_Header__c();
        oh.OB_Main_Process__c             = 'Maintenance';
        oh.OB_Business_Model_Acquiring__c = 'Bancario';
        oh.OB_Business_Model_POS__c  	  = 'Trilaterale Nuovo';
		oh.OB_ProposerABI__c              = a.id;
		oh.OB_Sub_Process__c = 'variazione economica';
        insert oh;
		System.debug('OH.ID: ' + oh.id);
		System.debug('OH.OB_Main_Process__c: ' + oh.OB_Main_Process__c);


		NE__Service_Point__c sp = new NE__Service_Point__c();
 		insert sp;

		

		NE__Order__c ord = new NE__Order__c(OB_Service_Point__c = sp.id, NE__Order_Header__c = oh.id);
		ord.OB_ShopSign__c  = 'Roma';
		ord.OB_MCCL2__c     = '5542';
        insert ord;
		System.debug('orderHeader: ' + ord.NE__Order_Header__c);
        


		NE__OrderItem__c item = new NE__OrderItem__c(NE__OrderId__c = ord.id, 
													 NE__ProdId__c  = prod.id, 
													 NE__Qty__c     = 1);
        item.NE__Account__c = a.id;
		item.OB_ShopCode__c='123';
        insert item;

		// NE__Product__c prod1 = new NE__Product__c();
		// prod1.RecordTypeId = recordTypeIdCommissione;
		// prod1.OB_Codice_sfdc__c = 'POS_TERZI_UNATTENDED';
		// insert prod1;
		NE__OrderItem__c itemParent = new NE__OrderItem__c(NE__OrderId__c = ord.id, NE__ProdId__c = prod1.id, NE__Account__c = a.id, NE__Qty__c = 1);
		itemParent.NE__Action__c = 'Add';
		insert itemParent;
		NE__OrderItem__c item1 = new NE__OrderItem__c(NE__OrderId__c = ord.id, NE__ProdId__c = prod1.id, NE__Account__c = a.id, NE__Qty__c = 1);
		item1.NE__Action__c = 'Add';
		//item1.OB_ShopCode__c='123';
		insert item1;
		

		NE__OrderItem__c item2 = new NE__OrderItem__c(NE__OrderId__c = ord.id, NE__ProdId__c = prod2.id, NE__Account__c = a.id, NE__Qty__c = 1);
		item2.NE__Action__c = 'Add';
		//item2.OB_ShopCode__c='123';
		insert item2;
		
        
		NE__OrderItem__c item3 = new NE__OrderItem__c(NE__OrderId__c = ord.id, NE__ProdId__c = prod3.id, NE__Account__c = a.id, NE__Qty__c = 1);
		item3.NE__Action__c = 'Add';
		//item3.OB_ShopCode__c='123';
		insert item3;
		
        
		NE__OrderItem__c item4 = new NE__OrderItem__c(NE__OrderId__c = ord.id, NE__ProdId__c = prod4.id, NE__Account__c = a.id, NE__Qty__c = 1);
		item4.NE__Action__c = 'Add';
		//item4.OB_ShopCode__c='123';
		insert item4;
		
        NE__OrderItem__c item44 = new NE__OrderItem__c(NE__OrderId__c = ord.id, NE__ProdId__c = prod4.id, NE__Account__c = a.id, NE__Qty__c = 1);
		item44.NE__Action__c = 'None';
		//item44.OB_ShopCode__c='123';
		insert item44;


		NE__OrderItem__c item5 = new NE__OrderItem__c(NE__OrderId__c = ord.id, NE__ProdId__c = prod5.id, NE__Account__c = a.id, NE__Qty__c = 1);
		item5.NE__Action__c = 'Add';
		//item5.OB_ShopCode__c='123';
		insert item5;
		
        
		NE__OrderItem__c item6 = new NE__OrderItem__c(NE__OrderId__c = ord.id,NE__Parent_Order_Item__c=itemParent.Id, NE__ProdId__c = prod6.id, NE__Account__c = a.id, NE__Qty__c = 1);
		item6.NE__Action__c = 'Add';
		//item6.OB_ShopCode__c='123';
		insert item6;
		
		NE__OrderItem__c item7 = new NE__OrderItem__c(NE__OrderId__c = ord.id, NE__ProdId__c = prod7.id, NE__Account__c = a.id, NE__Qty__c = 1);
		item7.NE__Action__c = 'Add';
		//item7.OB_ShopCode__c='123';
		insert item7;

		NE__OrderItem__c item8 = new NE__OrderItem__c(NE__OrderId__c = ord.id, NE__ProdId__c = prod8.id, NE__Account__c = a.id, NE__Qty__c = 1);
		item8.NE__Action__c = 'Add';
		//item8.OB_ShopCode__c='123';
		insert item8;
		NE__OrderItem__c item9 = new NE__OrderItem__c(NE__OrderId__c = ord.id, NE__ProdId__c = prod9.id, NE__Account__c = a.id, NE__Qty__c = 1);
		item9.NE__Action__c = 'Add';
		//item9.OB_ShopCode__c='123';
		insert item9;

		NE__OrderItem__c item10 = new NE__OrderItem__c(NE__OrderId__c = ord.id, NE__ProdId__c = prod10.id, NE__Account__c = a.id, NE__Qty__c = 1);
		item10.NE__Action__c = 'None';
		//item10.OB_ShopCode__c='123';
		insert item10;

        NE__OrderItem__c item11 = new NE__OrderItem__c(NE__OrderId__c = ord.id, NE__ProdId__c = prod9.id, NE__Account__c = a.id, NE__Qty__c = 1);
		item11.NE__Action__c = 'Add';
		//item11.OB_ShopCode__c='123';
		insert item11;

	
		NE__Lov__c lov = new NE__Lov__c( Name ='Test Lov', ne__type__c = 'mcc', NE__value3__c = 'L3', NE__Value2__c = '5542');
		insert lov;



		NE__Order_Item_Attribute__c attr = new NE__Order_Item_Attribute__c();
		attr.Name='Terminal Id';
		attr.NE__Value__c='1234';
		attr.NE__Order_Item__c=item8.Id;
		insert attr;
        

        









		// List<NE__OrderItem__c> itemsList = [SELECT Id, NE__OrderId__c, NE__OrderId__r.OB_Service_Point__c,NE__Account__c, NE__OrderId__r.NE__Order_Header__c
		// 									FROM  NE__OrderItem__c
		// 									WHERE NE__OrderId__r.NE__Order_Header__c =: oh.id];

        List<NE__OrderItem__c> configItemList2 = new List<NE__OrderItem__c>();
		configItemList2 = [SELECT Id,
								 NE__OrderId__r.OB_Service_Point__c, 
								 NE__OrderId__r.OB_SettlementType__c,
								 NE__Account__c, 
								 NE__OrderId__r.NE__Order_Header__r.OB_Business_Model_Acquiring__c,
								 NE__OrderId__r.NE__Order_Header__r.OB_Business_Model_POS__c,
								 NE__OrderId__r.NE__Order_Header__r.OB_ProposerABI__c,
								 NE__OrderId__r.OB_ShopSign__c,
								 NE__OrderId__r.OB_MCCL2__c,
								 NE__OrderId__r.OB_MCC__c, 
								 NE__OrderId__c,
								 NE__OrderId__r.NE__Order_Header__c,
								 NE__OrderId__r.NE__Order_Header__r.OB_Main_Process__c,
								 NE__ProdId__r.RecordType.DeveloperName,
								 NE__ProdId__r.OB_Codice_sfdc__c,
								 NE__Action__c,
								 OB_GT__c,
								OB_CustomerCode__c,
								OB_ShopCode__c,
								OB_Conventioncode__c,
								OB_SettlementMethod__c,
								NE__ProdId__r.OB_Acquirer__c,
								NE__OrderId__r.NE__Order_Header__r.OB_Sub_Process__c,
								NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName
						  FROM NE__OrderItem__c 
						//   WHERE Id = :item.id OR Id = :item1.Id  OR Id = :item2.Id  OR Id = :item3.Id 
						//         OR Id = :item4.Id OR Id = :item5.Id  OR Id = :item6.Id OR Id = :item7.Id OR Id = :item8.Id OR Id = :item9.Id OR Id = :item44.Id
						WHERE		NE__OrderId__c = :ord.id];

       
		//System.debug('configItemList ....  ' + JSON.serialize(configItemList));
		//System.debug('configItemList[0].NE__OrderId__r.NE__Order_Header__r.OB_Main_Process__c :::: '+configItemList[0].NE__OrderId__c);

		//OB_EnrichOrder.orderInfo order = new OB_EnrichOrder.orderInfo(configItemList); 


		Test.startTest();
		List<NE__OrderItem__c> configItemList = OB_EnrichOrder.getItemList( ord.Id);
		OB_EnrichOrder.orderInfo order = new OB_EnrichOrder.orderInfo(configItemList); 
		OB_EnrichOrder.setConfigurationInformation(ord.Id);
		OB_EnrichOrder.selectEternalRow(order);	

		Test.stopTest();
	 }
	@isTest
    public static void getExternalKey_Test() {
		Account a = new Account();
		a.Name = 'a';
		a.OB_Employees_Number__c = 'Minore di 10';
		a.OB_VAT_Not_Present__c = true; 
		a.OB_DescriptionVATNotPresent__c = 'description';
		a.NE__Fiscal_code__c = 'AAAAAA11A11A111A';
		a.RecordTypeId = [SELECT Id FROM RecordType WHERE sobjectType = 'Account' AND DeveloperName = 'Bank' LIMIT 1].Id;
		insert a;
        Id recordTypeIdCommissione = [SELECT Id FROM RecordType WHERE sobjectType = 'NE__Product__c' AND DeveloperName = 'Commissione' LIMIT 1].Id;

		NE__Product__c prod = new NE__Product__c(RecordTypeId = recordTypeIdCommissione, 
                                                 OB_Acquirer__c = 'NEXI');
        insert prod;

		// ExternalSourceMapping__c extsource =new ExternalSourceMapping__c();
		// extsource.OB_Merchant_ID__c =a.Id;
		// extsource.OB_Source__c='MONETICA';
		// insert extsource;




		NE__Order_Header__c oh = new NE__Order_Header__c();
        oh.OB_Main_Process__c             = 'Maintenance';
        oh.OB_Business_Model_Acquiring__c = 'Bancario';
        oh.OB_Business_Model_POS__c  	  = 'Trilaterale Nuovo';
		oh.OB_ProposerABI__c              = a.id;
		oh.OB_Sub_Process__c = 'variazione economica';
		//oh.OB_Business_Model_Acquiring__c ='Bancario';
        insert oh;
		System.debug('OH.ID: ' + oh.id);
				System.debug('OH.OB_Main_Process__c: ' + oh.OB_Main_Process__c);

		NE__Service_Point__c sp = new NE__Service_Point__c();
 		insert sp;
		
		ExternalSourceMapping__c esm1 = new ExternalSourceMapping__c();
		esm1.OB_Merchant_ID__c 				= a.id;
		esm1.OB_Service_Point_ID__c 		= sp.id;
		esm1.OB_Business_Model__c 			= 'Diretto';
		esm1.OB_Pricing__c 					= 'POS_TERZI_UNATTENDED';
		esm1.OB_ToBeChecked__c 				= false;
		esm1.OB_isMoTo__c					= false;
		esm1.OB_Service_Point_Type__c 		= 'Fisico';
		esm1.OB_Source__c            		= 'MONETICA';
		esm1.OB_CustomerCodeClientCode__c   = '123';
		esm1.OB_ServicePointCodeShopCode__c = '123';
		esm1.OB_Conventioncode__c 			= '123';
		esm1.OB_ConventionCodeSource__c 	= '123';
		esm1.OB_PBSettlementMethod__c 		= '123';
		esm1.OB_MCCL2__c 					= '1234';
		esm1.OB_MCC__c 						= '1234';

		insert esm1;

		ExternalSourceMapping__c esm2 = new ExternalSourceMapping__c();
		esm2.OB_Merchant_ID__c 				= a.id;
		esm2.OB_Service_Point_ID__c			= sp.id;  
		esm2.OB_Business_Model__c 			= 'Diretto';
		esm2.OB_Pricing__c 					= 'POS_TERZI_UNATTENDED';
		esm2.OB_ToBeChecked__c 				= false;
		esm2.OB_isMoTo__c 					= false;
		esm2.OB_Service_Point_Type__c 		= 'Virtuale'; 
		esm2.OB_Source__c 					= 'EQUENS';
		esm2.OB_CustomerCodeClientCode__c 	= '123';
		esm2.OB_ServicePointCodeShopCode__c = '123';
		esm2.OB_Conventioncode__c 			= '123';
		esm2.OB_ConventionCodeSource__c 	= '123';
		esm2.OB_PBSettlementMethod__c 		= '123'; 
		esm2.OB_MCCL2__c 					= '1234';
		esm2.OB_MCC__c 						= '1234';
		esm2.OB_Business_Model__c ='Bancario';

		insert esm2;

		ExternalSourceMapping__c esm3 = new ExternalSourceMapping__c();
		esm3.OB_Merchant_ID__c 				= a.id;
		esm3.OB_Service_Point_ID__c			= sp.id;  
		esm3.OB_Business_Model__c 			= 'Diretto';
		esm3.OB_Pricing__c 					= 'POS_TERZI_UNATTENDED';
		esm3.OB_ToBeChecked__c 				= false;
		esm3.OB_isMoTo__c 					= false;
		esm3.OB_Service_Point_Type__c 		= 'Virtuale'; 
		esm3.OB_Source__c 					= 'SIA';
		esm3.OB_CustomerCodeClientCode__c 	= '123';
		esm3.OB_ServicePointCodeShopCode__c = '123';
		esm3.OB_Conventioncode__c 			= '123';
		esm3.OB_ConventionCodeSource__c 	= '123';
		esm3.OB_PBSettlementMethod__c 		= '123'; 
		esm3.OB_MCCL2__c 					= '1234';
		esm3.OB_MCC__c 						= '1234';

		insert esm3;

		
		ExternalSourceMapping__c esm4 = new ExternalSourceMapping__c();
		esm4.OB_Merchant_ID__c 				= a.id;
		esm4.OB_Service_Point_ID__c 		= sp.id;
		esm4.OB_Business_Model__c 			= 'Bancario';
		esm4.OB_Pricing__c 					= 'POS_TERZI_UNATTENDED';
		esm4.OB_ToBeChecked__c 				= false;
		esm4.OB_isMoTo__c					= false;
		esm4.OB_Service_Point_Type__c 		= 'Fisico';
		esm4.OB_Source__c            		= 'MONETICA';
		esm4.OB_CustomerCodeClientCode__c   = '1234567';
		esm4.OB_ServicePointCodeShopCode__c = '123';
		esm4.OB_Conventioncode__c 			= '123';
		esm4.OB_ConventionCodeSource__c 	= '123';
		esm4.OB_PBSettlementMethod__c 		= '123';
		esm4.OB_MCCL2__c 					= '1234';
		esm4.OB_MCC__c 						= '1234';

		insert esm4;

	



		NE__Order__c ord = new NE__Order__c(OB_Service_Point__c = sp.id, NE__Order_Header__c = oh.id);
		ord.OB_ShopSign__c  = 'Roma';
		ord.OB_MCCL2__c     = '5542';
        insert ord;
		System.debug('orderHeader: ' + ord.NE__Order_Header__c);

		NE__Product__c prodParent = new NE__Product__c(RecordTypeId = recordTypeIdCommissione, 
                                                 OB_Acquirer__c = 'NEXI');
        prodParent.OB_Codice_sfdc__c='ECOMM';
		insert prodParent;

		NE__OrderItem__c itemParent = new NE__OrderItem__c(NE__OrderId__c = ord.id, NE__ProdId__c = prodParent.id, NE__Account__c = a.id, NE__Qty__c = 1);
		itemParent.NE__Action__c = 'Add';
		insert itemParent;

		NE__OrderItem__c item = new NE__OrderItem__c(NE__OrderId__c = ord.id, 
													 NE__ProdId__c  = prod.id, 
													 NE__Qty__c     = 1);
        item.OB_ShopCode__c='123';
    	item.OB_Processor__c='EQUENS';
	    item.NE__Account__c = a.id;
		item.NE__Parent_Order_Item__c=itemParent.Id;
        insert item;

				Asset ass = new Asset();
       // ass.RootAssetId                     = rootAsset.Id;
      //  ass.NE__CatalogItem__c              = ci.id;
        ass.AccountId                       = a.id;
       // ass.OB_DebitProfId__c               = bp.id;
        ass.OB_ProposerABI__c               = a.id;
        ass.IsCompetitorProduct             = false;
       // ass.IsInternal                      = false;
        ass.Name                            = 'Offerta Personalizzata';
        ass.NE__Action__c                   = 'Change';
        ass.NE__AssetItemEnterpriseId__c    = '123123123';
        ass.NE__BaseOneTimeFee__c           = 0;
        ass.NE__BaseRecurringCharge__c      = 0;
        ass.NE__Billing_Account__c          = a.id;
        ass.NE__Commitment__c               = false;
        ass.NE__Discount_One_time__c        = 0;
        ass.NE__Discount__c                 = 0;
        ass.NE__Generate_Asset_Item__c      = true;
        ass.NE__Item_Code__c                = item.Id;
        ass.NE__Order_Config__c             = ord.id;
        ass.NE__ProdId__c                   = prod.id;
        ass.NE__RecurringChargeFrequency__c = 'Monthly';
        ass.NE__Remove_from_total__c        = false;
        ass.NE__Service_Account__c          = a.id;
        ass.NE__Service_Point__c            = sp.id;
        ass.NE__Status__c                   = 'In Progress';
        ass.OB_enablement__c                = 'N';
        ass.OB_MCCL2__c                     = '0001';
        ass.OB_MCC__c                       = '5200';
        ass.OB_Report_Type__c               = 'Punto Vendita';
        ass.OB_Ro__c                        = 'N';
        ass.OB_Visible__c                   = 'N';
        ass.Quantity                        = 1;
        ass.OB_ShopSign__c                  = '23112';
        ass.OB_ShopCode__c                  = '123';
        ass.OB_CustomerCode__c              = '1016918';
        ass.OB_TermId__c                    = '01883677';
        ass.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1].id;
    	insert ass;

		List<NE__OrderItem__c> configItemList = new List<NE__OrderItem__c>();
		configItemList = [SELECT Id,
								 NE__OrderId__r.OB_Service_Point__c, 
								 NE__OrderId__r.OB_SettlementType__c,
								 NE__Account__c, 
								 NE__OrderId__r.NE__Order_Header__r.OB_Business_Model_Acquiring__c,
								 NE__OrderId__r.NE__Order_Header__r.OB_Business_Model_POS__c,
								 NE__OrderId__r.NE__Order_Header__r.OB_ProposerABI__c,
								 NE__OrderId__r.OB_ShopSign__c,
								 NE__OrderId__r.OB_MCCL2__c,
								 NE__OrderId__r.OB_MCC__c, 
								 NE__OrderId__c,
								 NE__OrderId__r.NE__Order_Header__c,
								 NE__OrderId__r.NE__Order_Header__r.OB_Main_Process__c,
								 NE__ProdId__r.RecordType.DeveloperName,
								 NE__ProdId__r.OB_Codice_sfdc__c,
								 NE__Action__c,
								 OB_GT__c,
								 NE__OrderId__r.OB_GT__c,
								OB_CustomerCode__c,
								OB_ShopCode__c,
								OB_Conventioncode__c,
								OB_SettlementMethod__c,
								NE__ProdId__r.OB_Acquirer__c,
								NE__OrderId__r.NE__Order_Header__r.OB_Sub_Process__c,
								NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName
						  FROM NE__OrderItem__c 
						  WHERE Id = :item.id ];
		system.debug(configItemList);
		OB_EnrichOrder.orderInfo order = new OB_EnrichOrder.orderInfo(configItemList); 
		

		Test.startTest();
	  	OB_EnrichOrder.getExternalKey( order);
	 	Test.stopTest();
	    }

	@isTest
	public static void  selectEternalRow_Test3() {
		
		Account a = new Account();
		a.Name = 'a';
		a.OB_Employees_Number__c = 'Minore di 10';
		a.OB_VAT_Not_Present__c = true; 
		a.OB_DescriptionVATNotPresent__c = 'description';
		a.NE__Fiscal_code__c = 'AAAAAA11A11A111B';
		a.RecordTypeId = [SELECT Id FROM RecordType WHERE sobjectType = 'Account' AND DeveloperName = 'Bank' LIMIT 1].Id;
		insert a;

		OB_Bank_Profile__c bp = new OB_Bank_Profile__c();
		bp.OB_Bank__c = a.Id;
		bp.OB_Service_Type__c = 'Acquiring'; 
		bp.OB_Business_Model_POS__c = 'Bilaterale'; 
		bp.OB_Circuit__c = 'JCB'; 
		bp.OB_Other_Acquirer__c = 'Amex';
		bp.OB_Applicant_RAC_Code_SIA__c = 'Banca'; 
		bp.OB_Terminal_Id_Generator__c = 'Banca'; 
		bp.OB_Technical_component_invoicing__c = 'TecMarket(servizio fatturazione per conto terzi)'; 
		bp.OB_GT__c = 'Nexi'; 
		bp.OB_Processor__c = 'SIA SMAC'; 
		bp.OB_Bilateral_Pricing__c = 'SI'; 
		bp.OB_Sending_Contract_to_Nexi__c = 'SI'; 
		bp.OB_SME_Factory__c = 'SI';
		insert bp;
		
        Id recordTypeIdCommissione = [SELECT Id FROM RecordType WHERE sobjectType = 'NE__Product__c' AND DeveloperName = 'Commissione' LIMIT 1].Id;
		Id recordTypeIdPagobancomat = [SELECT Id FROM RecordType WHERE sobjectType = 'NE__Product__c' AND DeveloperName = 'Pagobancomat' LIMIT 1].Id;
		Id recordTypeIdTerminali = [SELECT Id FROM RecordType WHERE sobjectType = 'NE__Product__c' AND DeveloperName = 'Terminali' LIMIT 1].Id;
        Id recordTypeIdAcquiring = [SELECT Id FROM RecordType WHERE sobjectType = 'NE__Product__c' AND DeveloperName = 'Acquiring' LIMIT 1].Id;
		Id recordTypeIdVas = [SELECT Id FROM RecordType WHERE sobjectType = 'NE__Product__c' AND DeveloperName = 'Vas' LIMIT 1].Id;
		Id recordTypeIdPricing = [SELECT Id FROM RecordType WHERE sobjectType = 'NE__Product__c' AND DeveloperName = 'Pricing' LIMIT 1].Id;


		
		
		NE__Product__c prod4 = new NE__Product__c(RecordTypeId = recordTypeIdTerminali);
        insert prod4;
		
		NE__Product__c prod10 = new NE__Product__c(RecordTypeId = recordTypeIdAcquiring, 
                                                 OB_Acquirer__c = 'NEXI');
		insert prod10;
		
		NE__Product__c prod5 = new NE__Product__c(RecordTypeId = recordTypeIdVas, 
                                                 OB_Acquirer__c = 'NEXI');
		insert prod5;
		
		NE__Order_Header__c oh = new NE__Order_Header__c();
        oh.OB_Main_Process__c             = 'Setup';
        oh.OB_Business_Model_Acquiring__c = 'Bancario';
        oh.OB_Business_Model_POS__c  	  = 'Trilaterale Nuovo';
		oh.OB_ProposerABI__c              = a.id;
        insert oh;
		


		NE__Service_Point__c sp = new NE__Service_Point__c();
 		insert sp;

		

		NE__Order__c ord = new NE__Order__c(OB_Service_Point__c = sp.id, NE__Order_Header__c = oh.id);
		ord.OB_ShopSign__c  = 'Roma';
		ord.OB_MCCL2__c     = '5542';
        insert ord;
		System.debug('orderHeader: ' + ord.NE__Order_Header__c);
        



        
		NE__OrderItem__c item4 = new NE__OrderItem__c(NE__OrderId__c = ord.id, NE__ProdId__c = prod4.id, NE__Account__c = a.id, NE__Qty__c = 1,NE__Service_Point__c=sp.Id);
		item4.NE__Action__c = 'Add';
		insert item4;
		item4.NE__Action__c = 'Add';
		update item4;

		NE__OrderItem__c item44 = new NE__OrderItem__c(NE__OrderId__c = ord.id, NE__ProdId__c = prod4.id, NE__Account__c = a.id, NE__Qty__c = 1,NE__Service_Point__c=sp.Id);
		item44.NE__Action__c = 'None';
		insert item44;
		item44.NE__Action__c = 'None';
		update item44;

		NE__OrderItem__c item10 = new NE__OrderItem__c(NE__OrderId__c = ord.id, NE__ProdId__c = prod10.id, NE__Account__c = a.id, NE__Qty__c = 1,NE__Service_Point__c=sp.Id);
		item10.NE__Action__c = 'Add';
		insert item10;
		item10.NE__Action__c = 'Add';
		update item10;

		NE__OrderItem__c item100 = new NE__OrderItem__c(NE__OrderId__c = ord.id, NE__ProdId__c = prod10.id, NE__Account__c = a.id, NE__Qty__c = 1,NE__Service_Point__c=sp.Id);
		item100.NE__Action__c = 'None';
		insert item100;
		item100.NE__Action__c = 'None';
		update item100;

		NE__OrderItem__c item5 = new NE__OrderItem__c(NE__OrderId__c = ord.id, NE__ProdId__c = prod5.id, NE__Account__c = a.id, NE__Qty__c = 1,NE__Service_Point__c=sp.Id,NE__Parent_Order_Item__c=item10.Id);
		item5.NE__Action__c = 'Add';
		insert item5;
		item5.NE__Action__c = 'Add';
		update item5;
		

	
		NE__Lov__c lov = new NE__Lov__c( Name ='Test Lov', ne__type__c = 'mcc', NE__value3__c = 'L3', NE__Value2__c = '5542');
		insert lov;



		NE__Order_Item_Attribute__c attr = new NE__Order_Item_Attribute__c();
		attr.Name='Terminal Id';
		attr.NE__Value__c='1234';
		attr.NE__Order_Item__c= item4.Id;
		insert attr;
        
		system.debug(	OB_EnrichOrder.getItemList(ord.Id)	);
		Test.startTest();
		OB_EnrichOrder.setConfigurationInformation(ord.Id);	
		Test.stopTest();
	 }
}