@isTest
public class OB_Maintenance_Consistenza_ConfItem_Test 
{
    /*******************************************************************************
    Purpose:  Method that checks if the current user is a partner user
    Parameters: Id bankAccountId
    Returns: Account

    History
    --------
    VERSION     AUTHOR                  DATE            
    1.0         Micol Ferrari       09/04/2019      
    ********************************************************************************/
    @isTest
    public static void isPartnerUser_Test()
    {
        Test.startTest();
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
    	Profile pAdmin = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
    	
    	User portalAccountOwner = new User();
    	portalAccountOwner.ProfileId = pAdmin.id;
    	portalAccountOwner.Username ='portalAccountOwner@test.com';
    	portalAccountOwner.Alias = 'alias';
    	portalAccountOwner.Email='portalAccountOwner@test.com';
    	portalAccountOwner.EmailEncodingKey='UTF-8';
    	portalAccountOwner.Firstname='firstName';
    	portalAccountOwner.Lastname='lastName';
    	portalAccountOwner.LanguageLocaleKey='en_US';
    	portalAccountOwner.LocaleSidKey='en_US';
    	portalAccountOwner.TimeZoneSidKey='America/Chicago';
    	portalAccountOwner.UserRoleId = portalRole.id;
	    insert portalAccountOwner;
	    
	    System.runAs(portalAccountOwner) {    	
    	    OB_Maintenance_Consistenza_ConfItem_CC.isPartnerUser();
        }
      	Test.stopTest();  
    }

	@isTest
    public static void saveAndSetTrackingGT_Test()
    {
		Account merchantAccount = new Account();
        merchantAccount.Name = 'merchantAccount';
        merchantAccount.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Merchant' AND sObjectType = 'Account' LIMIT 1].id;
        merchantAccount.OB_Employees_Number__c = 'Minore di 10';
        merchantAccount.OB_VAT_Not_Present__c = true;
        merchantAccount.OB_DescriptionVATNotPresent__c = 'description'; 
        merchantAccount.NE__Fiscal_code__c = 'RSSMRA80A01F205X';
        merchantAccount.OB_BypassValidation__c = true;
        merchantAccount.OB_Status__c = 'Active';
        insert merchantAccount;
        
        Account bankAccount	= new Account();
        bankAccount.Name = 'bankAccount';
        bankAccount.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Bank' AND sObjectType = 'Account' LIMIT 1].id;
        bankAccount.OB_Employees_Number__c = 'Minore di 10';
        bankAccount.OB_VAT_Not_Present__c = true;
        bankAccount.OB_DescriptionVATNotPresent__c = 'description'; 
        bankAccount.NE__Fiscal_code__c = 'RSSMRA80A01F205X';
        bankAccount.OB_BypassValidation__c = true;
        bankAccount.OB_Status__c = 'Active';
        insert bankAccount;
        
        NE__Order_Header__c orderHeader = new NE__Order_Header__c();
        orderHeader.OB_ProposerABI__c = bankAccount.Id; 
        orderHeader.NE__AccountId__c = merchantAccount.Id; 
        orderHeader.OB_Main_Process__c = 'Maintenance';
		insert orderHeader;
        
        NE__Service_Point__c servicePoint = new NE__Service_Point__c();
		insert servicePoint;
        
        NE__Order__c configuration = new NE__Order__c();
        configuration.NE__AccountId__c = merchantAccount.Id; 
        configuration.OB_Service_Point__c = servicePoint.Id;
        configuration.NE__Order_Header__c = orderHeader.Id; 
        configuration.OB_MCCL2__c = 'test';
		insert configuration;
        
        NE__Lov__c lovMCC2 = new NE__Lov__c();
		lovMCC2.ne__type__c   = 'mcc';
		lovMCC2.NE__Value3__c = 'L2';
		lovMCC2.OB_Value4__c  = configuration.OB_MCCL2__c;
		insert lovMCC2;
        
        Id rtProduct1              = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PAGOBANCOMAT).getRecordTypeId(); 
		NE__Product__c product1    = new NE__Product__c(OB_Acquirer__c = OB_EnrichOrder.NEXI , RecordTypeId = rtProduct1 );
		product1.OB_Codice_sfdc__c = OB_EnrichOrder.MOTO;
		insert product1;

		NE__OrderItem__c orderItem1 = new NE__OrderItem__c();	
		orderItem1.NE__Qty__c 	    = 10 ;
		orderItem1.NE__OrderId__c 	= configuration.id;
		orderItem1.NE__ProdId__c  	= product1.id;
        //START francesca ribezzi  19/12/2019    adding asset and bundleConf on item    
        orderItem1.OB_TermId__c = 'OB_TermId__c';
        orderItem1.NE__Root_Order_Item__c = null;
        orderItem1.NE__Bundle_Configuration__c = orderItem1.id;
insert orderItem1;
        
        NE__OrderItem__c orderItem2 = new NE__OrderItem__c();	
		orderItem2.NE__Qty__c 	    = 10 ;
		orderItem2.NE__OrderId__c 	= configuration.id;
		orderItem2.NE__ProdId__c  	= product1.id;
        orderItem2.OB_TermId__c = '01883677';
        orderItem2.NE__Root_Order_Item__c = null;
        orderItem2.NE__Bundle_Configuration__c = orderItem1.id;
       //START francesca ribezzi  19/12/2019    adding asset and bundleConf on item    
        insert orderItem2;
        
         //  micol.ferrari 19/12/2019 - change var name - START 
		Asset assy = new Asset();
        assy.AccountId                       = merchantAccount.id;
        assy.IsCompetitorProduct             = false;
        assy.Name                            = 'Offerta Personalizzata';
        assy.NE__Action__c                   = 'Change';
        assy.NE__AssetItemEnterpriseId__c    = orderItem1.id;
        assy.NE__BaseOneTimeFee__c           = 0;
        assy.NE__BaseRecurringCharge__c      = 0;
        assy.NE__Billing_Account__c          = merchantAccount.id;
        assy.NE__Commitment__c               = false;
        assy.NE__Discount_One_time__c        = 0;
        assy.NE__Discount__c                 = 0;
        assy.NE__Generate_Asset_Item__c      = true;
        assy.NE__Item_Code__c                = '';
        assy.NE__Order_Config__c             = configuration.Id;
        assy.NE__RecurringChargeFrequency__c = 'Monthly';
        assy.NE__Remove_from_total__c        = false;
        assy.NE__Service_Account__c          = merchantAccount.id;
        assy.NE__Service_Point__c            = servicePoint.id;
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

        //END francesca ribezzi  19/12/2019 
        List<Object> enablementsList = new List<Object>();
        enablementsList.add(orderItem1);
        
        Map<String,String> wrapperParMap = new Map<String,String>();
        
        wrapperParMap.put('idOrdineSfdc', configuration.id);
        wrapperParMap.put('sistemaSorgente', 'sistemaSorgente');
        wrapperParMap.put('statoProvisioning', 'statoProvisioning');
        wrapperParMap.put('codiceCliente', 'codiceCliente');
        wrapperParMap.put('termId', 'OB_TermId__c');
        wrapperParMap.put('modello', 'modello');
        wrapperParMap.put('descrizioneModello', 'descrizioneModello');
        wrapperParMap.put('descrizioneRelease', 'descrizioneRelease');
        wrapperParMap.put('descrizioneConnessione', 'descrizioneConnessione');
        wrapperParMap.put('release', 'release');
        wrapperParMap.put('modalitaCollegamento', 'modalitaCollegamento');
        wrapperParMap.put('statoInstallazione', 'statoInstallazione');
        wrapperParMap.put('modalitaCollegamento', 'modalitaCollegamento');
        wrapperParMap.put('causaleRifiuto', 'causaleRifiuto');
        wrapperParMap.put('dataInstallazione', 'dataInstallazione');
        wrapperParMap.put('dataDisinstallazione', 'dataDisinstallazione');
        wrapperParMap.put('codiceCTI', 'codiceCTI');
        wrapperParMap.put('codiceStabilimento', 'codiceStabilimento');
        wrapperParMap.put('codiceStabilimentoSIA', 'codiceStabilimentoSIA');
        wrapperParMap.put('codiceProgressivoSIA', 'codiceProgressivoSIA');
        wrapperParMap.put('codiceSIA', 'codiceSIA');
        
        Test.startTest();
    	OB_Maintenance_Consistenza_ConfItem_CC.saveAndSetTrackingGT(wrapperParMap,enablementsList);
      	Test.stopTest();   
    }
    
    @isTest
    public static void saveAndSetTrackingAcquiring_Test()
    {
		Account merchantAccount = new Account();
        merchantAccount.Name = 'merchantAccount';
        merchantAccount.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Merchant' AND sObjectType = 'Account' LIMIT 1].id;
        merchantAccount.OB_Employees_Number__c = 'Minore di 10';
        merchantAccount.OB_VAT_Not_Present__c = true;
        merchantAccount.OB_DescriptionVATNotPresent__c = 'description'; 
        merchantAccount.NE__Fiscal_code__c = 'RSSMRA80A01F205X';
        merchantAccount.OB_BypassValidation__c = true;
        merchantAccount.OB_Status__c = 'Active';
        insert merchantAccount;
        
        Account bankAccount	= new Account();
        bankAccount.Name = 'bankAccount';
        bankAccount.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Bank' AND sObjectType = 'Account' LIMIT 1].id;
        bankAccount.OB_Employees_Number__c = 'Minore di 10';
        bankAccount.OB_VAT_Not_Present__c = true;
        bankAccount.OB_DescriptionVATNotPresent__c = 'description'; 
        bankAccount.NE__Fiscal_code__c = 'RSSMRA80A01F205X';
        bankAccount.OB_BypassValidation__c = true;
        bankAccount.OB_Status__c = 'Active';
        insert bankAccount;
        
        NE__Order_Header__c orderHeader = new NE__Order_Header__c();
        orderHeader.OB_ProposerABI__c = bankAccount.Id; 
        orderHeader.NE__AccountId__c = merchantAccount.Id; 
        orderHeader.OB_Main_Process__c = 'Setup';
		insert orderHeader;
        
        NE__Service_Point__c servicePoint = new NE__Service_Point__c();
		insert servicePoint;
        
        NE__Order__c configuration = new NE__Order__c();
        configuration.NE__AccountId__c = merchantAccount.Id; 
        configuration.OB_Service_Point__c = servicePoint.Id;
        configuration.NE__Order_Header__c = orderHeader.Id; 
        configuration.OB_MCCL2__c = 'test';
        
		insert configuration;
        
        NE__Lov__c lovMCC2 = new NE__Lov__c();
		lovMCC2.ne__type__c   = 'mcc';
		lovMCC2.NE__Value3__c = 'L2';
		lovMCC2.OB_Value4__c  = configuration.OB_MCCL2__c;
		insert lovMCC2;
        
        Id rtProduct1              = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PAGOBANCOMAT).getRecordTypeId(); 
		NE__Product__c product1    = new NE__Product__c(OB_Acquirer__c = OB_EnrichOrder.NEXI , RecordTypeId = rtProduct1 );
		product1.OB_Codice_sfdc__c = OB_EnrichOrder.MOTO;
		insert product1;

		NE__OrderItem__c orderItem1 = new NE__OrderItem__c();	
		orderItem1.NE__Qty__c 	    = 10 ;
		orderItem1.NE__OrderId__c 	= configuration.id;
		orderItem1.NE__ProdId__c  	= product1.id;
        orderItem1.OB_TermId__c = 'OB_TermId__c';
        //START francesca ribezzi  19/12/2019    adding asset and bundleConf on item  
        orderItem1.NE__Bundle_Configuration__c=orderItem1.id;  
        orderItem1.NE__Root_Order_Item__c= null;
		insert orderItem1;
            NE__OrderItem__c orderItem2 = new NE__OrderItem__c();	
		orderItem2.NE__Qty__c 	    = 10 ;
		orderItem2.NE__OrderId__c 	= configuration.id;
		orderItem2.NE__ProdId__c  	= product1.id;
        orderItem2.OB_TermId__c = '01883677';
        orderItem2.NE__Root_Order_Item__c = null;
        orderItem2.NE__Bundle_Configuration__c = orderItem1.id;
       //START francesca ribezzi  19/12/2019    adding asset and bundleConf on item    
        insert orderItem2;
        
         //  micol.ferrari 19/12/2019 - change var name - START 
		Asset assy = new Asset();
        assy.AccountId                       = merchantAccount.id;
        assy.IsCompetitorProduct             = false;
        assy.Name                            = 'Offerta Personalizzata';
        assy.NE__Action__c                   = 'Change';
        assy.NE__AssetItemEnterpriseId__c    = orderItem1.id;
        assy.NE__BaseOneTimeFee__c           = 0;
        assy.NE__BaseRecurringCharge__c      = 0;
        assy.NE__Billing_Account__c          = merchantAccount.id;
        assy.NE__Commitment__c               = false;
        assy.NE__Discount_One_time__c        = 0;
        assy.NE__Discount__c                 = 0;
        assy.NE__Generate_Asset_Item__c      = true;
        assy.NE__Item_Code__c                = '';
        assy.NE__Order_Config__c             = configuration.Id;
        assy.NE__RecurringChargeFrequency__c = 'Monthly';
        assy.NE__Remove_from_total__c        = false;
        assy.NE__Service_Account__c          = merchantAccount.id;
        assy.NE__Service_Point__c            = servicePoint.id;
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
        //END francesca ribezzi  19/12/2019  
        Map<String,String> wrapperParMap = new Map<String,String>();
        
        wrapperParMap.put('idOrdineSfdc', configuration.id);
        wrapperParMap.put('sistemaSorgente', 'sistemaSorgente');
        wrapperParMap.put('codiceSocieta', 'codiceSocieta');
        wrapperParMap.put('codicePuntoVendita', 'codicePuntoVendita');
        wrapperParMap.put('dataInizioAcq', '2018-01-01');
        wrapperParMap.put('statoProvisioning', 'statoProvisioning');
        wrapperParMap.put('codiceCliente', 'codiceCliente');
        wrapperParMap.put('termId', 'OB_TermId__c');
        wrapperParMap.put('modello', 'modello');
        wrapperParMap.put('descrizioneModello', 'descrizioneModello');
        wrapperParMap.put('descrizioneRelease', 'descrizioneRelease');
        wrapperParMap.put('descrizioneConnessione', 'descrizioneConnessione');
        wrapperParMap.put('release', 'release');
        wrapperParMap.put('modalitaCollegamento', 'modalitaCollegamento');
        wrapperParMap.put('statoInstallazione', 'statoInstallazione');
        wrapperParMap.put('modalitaCollegamento', 'modalitaCollegamento');
        wrapperParMap.put('causaleRifiuto', 'causaleRifiuto');
        wrapperParMap.put('dataInstallazione', 'dataInstallazione');
        wrapperParMap.put('dataDisinstallazione', 'dataDisinstallazione');
        wrapperParMap.put('codiceCTI', 'codiceCTI');
        wrapperParMap.put('codiceStabilimento', 'codiceStabilimento');
        wrapperParMap.put('codiceStabilimentoSIA', 'codiceStabilimentoSIA');
        wrapperParMap.put('codiceProgressivoSIA', 'codiceProgressivoSIA');
        wrapperParMap.put('codiceSIA', 'codiceSIA');
        wrapperParMap.put('itemId', orderItem1.id );

        Map<String,String> wrapperParMapNEXI = new Map<String,String>();
        wrapperParMapNEXI.put('idOrdineSfdc', configuration.id);
        wrapperParMapNEXI.put('sistemaSorgente', 'sistemaSorgente');
        wrapperParMapNEXI.put('codiceSocieta', 'codiceSocieta');
        wrapperParMapNEXI.put('codicePuntoVendita', 'codicePuntoVendita');
        wrapperParMapNEXI.put('dataInizioAcq', '2018-01-01');
        wrapperParMapNEXI.put('statoProvisioning', 'statoProvisioning');
        wrapperParMapNEXI.put('codiceCliente', 'codiceCliente');
        wrapperParMapNEXI.put('termId', 'OB_TermId__c');
        wrapperParMapNEXI.put('modello', 'modello');
        wrapperParMapNEXI.put('descrizioneModello', 'descrizioneModello');
        wrapperParMapNEXI.put('descrizioneRelease', 'descrizioneRelease');
        wrapperParMapNEXI.put('descrizioneConnessione', 'descrizioneConnessione');
        wrapperParMapNEXI.put('release', 'release');
        wrapperParMapNEXI.put('modalitaCollegamento', 'modalitaCollegamento');
        wrapperParMapNEXI.put('statoInstallazione', 'statoInstallazione');
        wrapperParMapNEXI.put('modalitaCollegamento', 'modalitaCollegamento');
        wrapperParMapNEXI.put('causaleRifiuto', 'causaleRifiuto');
        wrapperParMapNEXI.put('dataInstallazione', 'dataInstallazione');
        wrapperParMapNEXI.put('dataDisinstallazione', 'dataDisinstallazione');
        wrapperParMapNEXI.put('codiceCTI', 'codiceCTI');
        wrapperParMapNEXI.put('codiceStabilimento', 'codiceStabilimento');
        wrapperParMapNEXI.put('codiceStabilimentoSIA', 'codiceStabilimentoSIA');
        wrapperParMapNEXI.put('codiceProgressivoSIA', 'codiceProgressivoSIA');
        wrapperParMapNEXI.put('codiceSIA', 'codiceSIA');
        wrapperParMapNEXI.put('itemId', orderItem1.id );
        wrapperParMapNEXI.put('acquirerType', 'NEXI');
        wrapperParMapNEXI.put('action', 'Add');
        
        Test.startTest();
    	OB_Maintenance_Consistenza_ConfItem_CC.saveAndSetTrackingAcquiring(wrapperParMap);
        OB_Maintenance_Consistenza_ConfItem_CC.saveAndSetTrackingAcquiring(wrapperParMapNEXI);
      	Test.stopTest();   
    }

    @isTest
    public static void getVasCloneTest()
    {
        String merchantRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'merchant' AND SobjectType = 'Account' LIMIT 1].Id;
		Account merchant = new Account(Name = 'name', RecordTypeId = merchantRecordTypeId, OB_Employees_Number__c = 'Minore di 10', NE__Fiscal_code__c = 'AAAAAA11A11A111A', OB_VAT_Not_Present__c = true, OB_DescriptionVATNotPresent__c = 'desc');
		insert merchant;
		NE__Order__c order = new NE__Order__c();
		insert order;
        Id rtProductVas = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get('Vas').getRecordTypeId(); 
		NE__Product__c prod    = new NE__Product__c(OB_Acquirer__c = OB_EnrichOrder.NEXI , RecordTypeId = rtProductVas );
		prod.OB_Codice_sfdc__c = OB_EnrichOrder.MOTO;
		insert prod;
        NE__OrderItem__c parentOrderItem = new NE__OrderItem__c();
		parentOrderItem.NE__OrderId__c = order.Id;
		parentOrderItem.NE__Qty__c = 1;
		insert parentOrderItem;
		NE__OrderItem__c orderItem = new NE__OrderItem__c();
		orderItem.NE__OrderId__c = order.Id;
		orderItem.NE__Qty__c = 1;
        orderItem.NE__Parent_Order_Item__c = parentOrderItem.id;
        orderItem.NE__ProdId__c = prod.id;
		insert orderItem;
        String parentVas = '{"type":"NE__OrderItem__c", "Id": "' + parentOrderItem.id + '", "NE__Account__c":"' + merchant.id + '", "NE__ProdId__c":"' + prod.id+ '", "NE__OrderId__c":"' + order.id + '", "OB_Processor__c":"EQUENS","NE__Status__c":"Pending","OB_CompanyCode__c":"123","NE__Qty__c":1}';
        Test.startTest();
        OB_Maintenance_Consistenza_ConfItem_CC.getVasClone(parentVas);
        Test.stopTest();
    }

    
    /*@isTest
    public static void saveAndSetTrackingAcquiring_Test()
     {
            Test.startTest();

            Map<String,String> wrapperParMap = new Map<String,String> ();

            NE__Order_Header__c orderHeader  = new NE__Order_Header__c();
            insert orderHeader;
            NE__Order__c order = new NE__Order__c(NE__Order_Header__c=orderHeader.Id);
            insert order; 

       //      NE__OrderItem__c orderItem = new NE__OrderItem__c(NE__Qty__c = 10, NE__OrderId__c = order.id);
       //      insert orderItem;
       
            wrapperParMap.put('idOrdineSfdc', order.id);
            wrapperParMap.put('itemId', 'itemId');
            wrapperParMap.put('dataInizioAcq', 'dataInizioAcq');
            wrapperParMap.put('dataCessazioneAcq', 'dataCessazioneAcq');
            wrapperParMap.put('causaleCessazioneAcq', 'causaleCessazioneAcq');
            wrapperParMap.put('tipo', 'tipo');
            wrapperParMap.put('sistemaSorgente', 'sistemaSorgente');
            wrapperParMap.put('codiceSocieta', 'codiceSocieta');

       //      OB_TrackingOrder.TrackingOrderRequest req = new OB_TrackingOrder.TrackingOrderRequest();
       //      req.idOrdineSfdc = wrapperParMap.get('idOrdineSfdc');
       
           // OB_Maintenance_Consistenza_ConfItem_CC.saveAndSetTrackingAcquiring(wrapperParMap);

            Test.stopTest();
     }*/
    @isTest
    public static void saveOrderItemIntegrazione_Test() {
        // INCOMING PARAMETER METHOD
        String action;
        String itemId;
        
        // RECORD TYPE ID:
        	// PRODUCT RECORD TYPE:
        	Id recTypeTerminaliProduct = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get( OB_UtilityConstants.POS_RT ).getRecordTypeId( );
        	
        	// ITEM RECORD TYPE 
        	Id recTypeTerminaliItem = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByDeveloperName().get( OB_UtilityConstants.POS_RT ).getRecordTypeId( );
        
        // MAIN ORDER HEADER
        NE__Order_Header__c orderHeader = OB_TestDataFactory.getOrderHeader();
        insert orderHeader;
        
        // CONFIGURATION
		NE__Order__c order = OB_TestDataFactory.getOrder(orderHeader);
        insert order;
		
        // PRODUCT
        NE__Product__c product = OB_TestDataFactory.getProduct();
        product.OB_Codice_sfdc__c = OB_UtilityCOnstants.M_POS;
        product.RecordTypeId = recTypeTerminaliProduct;
        insert product;
        
        DateTime endDate = datetime.newInstance(2020, 12, 1);
		// CONFIGURATIONITEMS
		String configItemId;
        List<NE__OrderItem__c> orderItemList = new List<NE__OrderItem__c>();
		for(Integer i = 0; i<10 ; i++) {
            NE__OrderItem__c orderItem = OB_TestDataFactory.getOrderItem(order.Id);
            orderItem.NE__ProdId__c = product.Id;
            orderItem.RecordTypeId = recTypeTerminaliItem;
            orderItem.NE__Status__c = 'Completed';
			orderItem.ob_fulfilmentstatus__c	= 'Completed';
			orderItem.NE__StartDate__c 	= System.today();
            orderItem.NE__EndDate__c  	= endDate.addDays(10);
			
            orderItemList.add(orderItem);
        }
        insert orderItemList;
        configItemId = orderItemList[0].Id;

        String startdateString 	= String.valueOf(orderItemList[0].NE__StartDate__c);
        String endDateString 	= String.valueOf(orderItemList[0].NE__EndDate__c);
        
        DateTime startdate = datetime.newInstance(2019, 12, 1);
        
        
        action = orderItemList[0].NE__Action__c;
        
        Test.startTest();
			OB_Maintenance_Consistenza_ConfItem_CC.saveOrderItemIntegrazione(action, String.valueOf(orderItemList[0].NE__StartDate__c) , endDateString, configItemId);
        Test.stopTest();
    }
    
    @isTest
    public static void retrieveStatus_Test() {
        // RECORD TYPE ID:
        	// PRODUCT RECORD TYPE:
        	Id recTypeTerminaliProduct = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get( OB_UtilityConstants.POS_RT ).getRecordTypeId( );
        	
        	// ITEM RECORD TYPE 
        	Id recTypeTerminaliItem = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByDeveloperName().get( OB_UtilityConstants.POS_RT ).getRecordTypeId( );
        
        // MAIN ORDER HEADER
        NE__Order_Header__c orderHeader = OB_TestDataFactory.getOrderHeader();
        insert orderHeader;
        
        // CONFIGURATION
		NE__Order__c order = OB_TestDataFactory.getOrder(orderHeader);
        insert order;
		
        // PRODUCT
        NE__Product__c product = OB_TestDataFactory.getProduct();
        product.OB_Codice_sfdc__c = OB_UtilityCOnstants.M_POS;
        product.RecordTypeId = recTypeTerminaliProduct;
        insert product;
        
        DateTime endDate = datetime.newInstance(2020, 12, 1);
		// CONFIGURATIONITEMS
		String configItemId;
        List<NE__OrderItem__c> orderItemList = new List<NE__OrderItem__c>();
		for(Integer i = 0; i<10 ; i++) {
            NE__OrderItem__c orderItem = OB_TestDataFactory.getOrderItem(order.Id);
            orderItem.NE__ProdId__c = product.Id;
            orderItem.RecordTypeId = recTypeTerminaliItem;
            orderItem.NE__Status__c = 'Completed';
			orderItem.ob_fulfilmentstatus__c	= 'Completed';
			orderItem.NE__StartDate__c 	= System.today();
            orderItem.NE__EndDate__c  	= endDate.addDays(10);
			
            orderItemList.add(orderItem);
        }
        insert orderItemList;
        String itemId = orderItemList[0].Id;
        
        Test.startTest();
			OB_Maintenance_Consistenza_ConfItem_CC.retrieveStatus(itemId);
        Test.stopTest();
        
    }
    
    //saveOrderItemGateway
    /*******************************************************************************
    Purpose:  Method tests updateItem method. Metod fails on Order Item update and
                returns reponse with error code 1.

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Kinga Fornal            31/07/2019      Created         NEXI-246
    ********************************************************************************/
    @isTest
    public static void updateItem( )
    {

        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        insert testOrder;
        NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
        testOrderItem.NE__Startdate__c = Datetime.now( );
        insert testOrderItem;
        NE__OrderItem__c testOrderItem2 = OB_TestDataFactory.getOrderItem( testOrder.Id );
        testOrderItem2.NE__Root_Order_Item__c = testOrderItem.Id;
        insert testOrderItem2;

        Test.startTest( );
        OB_Maintenance_Consistenza_ConfItem_CC.trkResponse response = OB_Maintenance_Consistenza_ConfItem_CC.updateItem ( testOrderItem2.Id, '2019-01-01', '2020-01-01', 'ABC' );
        Test.stopTest( );

        System.assertEquals( 1, response.errorCode );
    }

    /*******************************************************************************
    Purpose:  Method tests saveOrderItemGateway method, the update suceeds

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Kinga Fornal            31/07/2019      Created         NEXI-246
    ********************************************************************************/
    @isTest
    public static void saveOrderItemGateway( )
    {

        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        insert testOrder;
        NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
        testOrderItem.NE__Startdate__c = Datetime.now( );
        //START francesca ribezzi  19/12/2019    adding asset and bundleConf on item  
        testOrderItem.NE__Bundle_Configuration__c=testOrderItem.id;
        testOrderItem.NE__Root_Order_Item__c= null;
        insert testOrderItem;
        NE__OrderItem__c testOrderItem2 = OB_TestDataFactory.getOrderItem( testOrder.Id );
        testOrderItem2.NE__Root_Order_Item__c = testOrderItem.Id;
        testOrderItem2.NE__Bundle_Configuration__c=testOrderItem2.id;
        testOrderItem2.NE__Root_Order_Item__c= null;
        insert testOrderItem2;
        Asset assetTest = OB_TestDataFactory.getAsset();
        assetTest.NE__Order_Config__c = testOrder.id;
        //END francesca ribezzi  19/12/2019  
        String action = OB_UtilityConstants.ORDERITEM_ACTION_ADD;
        String itemId = testOrderItem.Id;
        List<Object> enablements = new List<Object>( );

        Test.startTest( );
        Boolean result = OB_Maintenance_Consistenza_ConfItem_CC.saveOrderItemGateway ( action, itemId, enablements );
        Test.stopTest( );

        List<NE__OrderItem__c> resultOrderItems = [ SELECT Id, OB_FulfilmentStatus__c FROM NE__OrderItem__c WHERE Id = :testOrderItem.Id ];

        System.assertEquals( OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED, resultOrderItems.get( 0 ).OB_FulfilmentStatus__c );
        System.assertEquals( true, result );
    }

    /*******************************************************************************
    Purpose:  Method tests verifyMixedLogrequest method, scenario when method returns True

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Kinga Fornal            31/07/2019      Created         NEXI-246
    ********************************************************************************/
    @isTest
    public static void verifyMixedLogrequestResultTrue( )
    {

        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        insert testOrder;
        OB_LogRequest__c testLogRequest = OB_TestDataFactory.getLogRequest();
        testLogRequest.OB_OrderId__c = testOrder.Id;
        testLogRequest.OB_Mixed_Maintenance__c = true;
        insert testLogRequest;

        String confId = testOrder.Id;

        Test.startTest( );
        Boolean result = OB_Maintenance_Consistenza_ConfItem_CC.verifyMixedLogrequest ( confId );
        Test.stopTest( );

        System.assertEquals( true, result );
    }

    /*******************************************************************************
    Purpose:  Method tests verifyMixedLogrequest method, scenario when method returns False

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Kinga Fornal            31/07/2019      Created         NEXI-246
    ********************************************************************************/
    @isTest
    public static void verifyMixedLogrequestResultFalse( )
    {

        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        insert testOrder;
        OB_LogRequest__c testLogRequest = OB_TestDataFactory.getLogRequest();
        testLogRequest.OB_OrderId__c = testOrder.Id;
        testLogRequest.OB_Mixed_Maintenance__c = false;
        insert testLogRequest;

        String confId = testOrder.Id;

        Test.startTest( );
        Boolean result = OB_Maintenance_Consistenza_ConfItem_CC.verifyMixedLogrequest ( confId );
        Test.stopTest( );

        System.assertEquals( false, result );
    }

    /*******************************************************************************
    Purpose:  Method tests updateOrderItemMixedMaintenance method

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Kinga Fornal            31/07/2019      Created         NEXI-246
    ********************************************************************************/
    @isTest
    public static void updateOrderItemMixedMaintenance( )
    {

        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        insert testOrder;
        NE__Product__c testProduct = OB_TestDataFactory.getProduct( );
        testProduct.RecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        insert testProduct;
        NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
        testOrderItem.NE__Startdate__c = Datetime.now( );
        testOrderItem.NE__Action__c = OB_UtilityConstants.ORDERITEM_ACTION_ADD;
        testOrderItem.NE__ProdId__c = testProduct.Id;
        testOrderItem.OB_isNotIntegrated__c = true;
        testOrderItem.NE__Root_Order_Item__c = null;
        insert testOrderItem;
        OB_LogRequest__c testLogRequest = OB_TestDataFactory.getLogRequest();
        testLogRequest.OB_OrderId__c = testOrder.Id;
        testLogRequest.OB_Response_Track__c = '';
        insert testLogRequest;

        String confId = testOrderItem.Id;
        String type = OB_UtilityConstants.RTASSETSTANDARD;

        Test.startTest( );
        Boolean result = OB_Maintenance_Consistenza_ConfItem_CC.updateOrderItemMixedMaintenance ( confId, type );
        Test.stopTest( );

        System.assertEquals( false, result );
    }

    /*******************************************************************************
   Purpose:  Method tests saveOrderItemIntegrazione method, no errors scenario

   History
   --------
   VERSION     AUTHOR                  DATE            DETAIL          Description
   1.0         Kinga Fornal            31/07/2019      Created         NEXI-246
   ********************************************************************************/
    @isTest
    public static void saveOrderItemIntegrazioneNoError( )
    {
        //START francesca ribezzi  19/12/2019    adding asset and bundleConf on item  
        Account merchantAccount = new Account();
        merchantAccount.Name = 'merchantAccount';
        merchantAccount.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Merchant' AND sObjectType = 'Account' LIMIT 1].id;
        merchantAccount.OB_Employees_Number__c = 'Minore di 10';
        merchantAccount.OB_VAT_Not_Present__c = true;
        merchantAccount.OB_DescriptionVATNotPresent__c = 'description'; 
        merchantAccount.NE__Fiscal_code__c = 'RSSMRA80A01F205X';
        merchantAccount.OB_BypassValidation__c = true;
        merchantAccount.OB_Status__c = 'Active';
        insert merchantAccount;
        NE__Order_Header__c orderHeader = OB_TestDataFactory.getOrderHeader( );
        insert orderHeader;
        NE__Order__c order = OB_TestDataFactory.getOrder( orderHeader );
        insert order;
        NE__Product__c product = OB_TestDataFactory.getProduct( );
        product.OB_Codice_sfdc__c = OB_UtilityCOnstants.M_POS;
        insert product;
        NE__OrderItem__c orderItem = OB_TestDataFactory.getOrderItem( order.Id );
        orderItem.NE__ProdId__c = product.Id;
        orderItem.NE__Status__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
        orderItem.ob_fulfilmentstatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
        orderItem.NE__Bundle_Configuration__c=orderItem.id;
        orderItem.NE__Root_Order_Item__c= null;
        insert orderItem;

             NE__OrderItem__c orderItem2 = new NE__OrderItem__c();	
		orderItem2.NE__Qty__c 	    = 10 ;
		orderItem2.NE__OrderId__c 	= order.id;
		orderItem2.NE__ProdId__c  	= product.id;
        orderItem2.OB_TermId__c = '01883677';
        orderItem2.NE__Root_Order_Item__c = null;
        orderItem2.NE__Bundle_Configuration__c = orderItem.id;
       //START francesca ribezzi  19/12/2019    adding asset and bundleConf on item    
        insert orderItem2;
        
		Asset assy = new Asset();
        assy.AccountId                       = merchantAccount.id;
        assy.IsCompetitorProduct             = false;
        assy.Name                            = 'Offerta Personalizzata';
        assy.NE__Action__c                   = 'Change';
        assy.NE__AssetItemEnterpriseId__c    = orderItem.id;
        assy.NE__BaseOneTimeFee__c           = 0;
        assy.NE__BaseRecurringCharge__c      = 0;
        assy.NE__Billing_Account__c          = merchantAccount.id;
        assy.NE__Commitment__c               = false;
        assy.NE__Discount_One_time__c        = 0;
        assy.NE__Discount__c                 = 0;
        assy.NE__Generate_Asset_Item__c      = true;
        assy.NE__Item_Code__c                = '';
        assy.NE__Order_Config__c             = order.Id;
        assy.NE__RecurringChargeFrequency__c = 'Monthly';
        assy.NE__Remove_from_total__c        = false;
        assy.NE__Service_Account__c          = merchantAccount.id;
      //  assy.NE__Service_Point__c            = servicePoint.id;
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
         //END francesca ribezzi  19/12/2019 
        Test.startTest( );
        Boolean result = OB_Maintenance_Consistenza_ConfItem_CC.saveOrderItemIntegrazione( OB_UtilityConstants.ORDERITEM_ACTION_ADD, '2019-01-01', '2020-01-01', orderItem.Id );
        Test.stopTest( );

        System.assertEquals( true, result );
    }

    /*******************************************************************************
    Purpose:  Method tests saveOrderItemIntegrazione method, no errors scenario,
                with the date format containing letter T

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Kinga Fornal            31/07/2019      Created         NEXI-246
    ********************************************************************************/
    @isTest
    public static void saveOrderItemIntegrazioneNoErrorDateFormat( )
    {
        NE__Order_Header__c orderHeader = OB_TestDataFactory.getOrderHeader( );
        insert orderHeader;
        NE__Order__c order = OB_TestDataFactory.getOrder( orderHeader );
        insert order;
        NE__Product__c product = OB_TestDataFactory.getProduct( ); 
        product.OB_Codice_sfdc__c = OB_UtilityCOnstants.M_POS;
        insert product;
        NE__OrderItem__c orderItem = OB_TestDataFactory.getOrderItem( order.Id );
        orderItem.NE__ProdId__c = product.Id;
        orderItem.NE__Status__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
        orderItem.ob_fulfilmentstatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
        //START francesca ribezzi  19/12/2019    adding asset and bundleConf on item  
        orderItem.NE__Root_Order_Item__c= null;
        orderItem.NE__OrderId__c = order.Id; 
        orderItem.NE__Bundle_Configuration__c=orderItem.id;

        insert orderItem;
        
            NE__OrderItem__c orderItem2 = new NE__OrderItem__c();	
		orderItem2.NE__Qty__c 	    = 10 ;
		orderItem2.NE__OrderId__c 	= order.id;
		orderItem2.NE__ProdId__c  	= product.id;
        orderItem2.OB_TermId__c = '01883677';
        orderItem2.NE__Root_Order_Item__c = null;
        orderItem2.NE__Bundle_Configuration__c = orderItem.id;
       //START francesca ribezzi  19/12/2019    adding asset and bundleConf on item    
        insert orderItem2;
        
		Asset assy = new Asset();
       // assy.AccountId                       = merchantAccount.id;
        assy.IsCompetitorProduct             = false;
        assy.Name                            = 'Offerta Personalizzata';
        assy.NE__Action__c                   = 'Change';
        assy.NE__AssetItemEnterpriseId__c    = orderItem.id;
        assy.NE__BaseOneTimeFee__c           = 0;
        assy.NE__BaseRecurringCharge__c      = 0; 
       // assy.NE__Billing_Account__c          = merchantAccount.id;
        assy.NE__Commitment__c               = false;
        assy.NE__Discount_One_time__c        = 0;
        assy.NE__Discount__c                 = 0;
        assy.NE__Generate_Asset_Item__c      = true;
        assy.NE__Item_Code__c                = '';
        assy.NE__Order_Config__c             = order.Id;
        assy.NE__RecurringChargeFrequency__c = 'Monthly';
        assy.NE__Remove_from_total__c        = false;
      //  assy.NE__Service_Account__c          = merchantAccount.id;
      //  assy.NE__Service_Point__c            = servicePoint.id; 
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
       //END francesca ribezzi  19/12/2019   
        Test.startTest( );
        Boolean result = OB_Maintenance_Consistenza_ConfItem_CC.saveOrderItemIntegrazione( OB_UtilityConstants.ORDERITEM_ACTION_ADD, '2019-08-12T20:17:46.384Z', '2020-08-12T20:17:46.384Z', orderItem.Id );
        Test.stopTest( );

        System.assertEquals( true, result ); 
    }
}