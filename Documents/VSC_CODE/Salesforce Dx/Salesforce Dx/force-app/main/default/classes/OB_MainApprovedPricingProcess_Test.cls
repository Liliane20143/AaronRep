@isTest
public  class OB_MainApprovedPricingProcess_Test {

    @isTest
    public static void setConfigurationToApprove_Test(){

        String confId='';       
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
        //bundleId 
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
       NE__Order__c ord        = new NE__Order__c(NE__Order_Header__c = oh.id);
        ord.NE__AccountId__c    = acc.id;
        ord.NE__BillAccId__c    = acc.Id;
        ord.NE__ServAccId__c    = acc.Id;
        ord.OB_MCCL2__c         = '0000';
        ord.OB_GT__c		    = 'Nexi';
        ord.OB_Service_Point__c = sp.id;    
        insert ord; 
        confId=ord.Id;
      
       Test.startTest();
       OB_MainApprovedPricingProcessController.setConfigurationToApprove(confId);
       Test.stopTest();
    }
        @isTest
        public static void  createLogRequestServer_Test(){
            String  merchantId ='';
            String  servicePointId ='';
            String  abi ='12345';
            String  cab='';
            Boolean hasPOS=false;
            
            Id recordTypeIdPricing     = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Pricing').getRecordTypeId();
            Id recordTypeIdTerminali   = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Terminali').getRecordTypeId();  
            Id recordTypeIdVAS         = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Vas').getRecordTypeId();            
            Id rtPricing               = Schema.SObjectType.OB_LogRequest__c.getRecordTypeInfosByDeveloperName().get('OB_Pricing').getRecordTypeId();            
            Id merchantRecordTypeId    = [SELECT Id FROM RecordType WHERE Name = 'merchant' AND SobjectType = 'Account' LIMIT 1].Id;
		    Id bankRecordTypeId        = [SELECT Id FROM RecordType WHERE Name = 'bank' AND SobjectType = 'Account' LIMIT 1].Id;

        
            NE__Order_Header__c orderHeader = new NE__Order_Header__c();
            insert orderHeader;
            NE__Order__c configuration = new NE__Order__c(NE__Order_Header__c=orderHeader.Id, OB_AdditionalDocumentationRequired__c = true, OB_ABI__c = '12345');
            insert configuration;	
            NE__Order__c configuration2 = new NE__Order__c(NE__Order_Header__c=orderHeader.Id, OB_AdditionalDocumentationRequired__c = false, OB_ABI__c = '12345');
            insert configuration2;
            NE__Product__c prod = new NE__Product__c (Name = 'testProd',NE__Description__c 	= '');  
            prod.RecordTypeId = recordTypeIdPricing;
            insert prod;
            NE__Product__c prod2 = new NE__Product__c (Name = 'testProd',NE__Description__c 	= '');  
            prod2.RecordTypeId = recordTypeIdTerminali;
            insert prod2;
            NE__Product__c prod3= new NE__Product__c (Name = 'testProd',NE__Description__c 	= '');  
            prod3.RecordTypeId = recordTypeIdVAS;
            insert prod3;

            
             
           ///////// the section if(orderItemPOS.size() > 0 )           
            NE__OrderItem__c orderItem = new NE__OrderItem__c();
            orderItem.NE__Qty__c    = 10 ;
            orderItem.NE__Action__c ='Add';
            orderItem.NE__OrderId__c= configuration.id;
		    orderItem.NE__ProdId__c = prod2.Id;            
            insert orderItem;   

            NE__OrderItem__c orderItemPOS = new NE__OrderItem__c();
            orderItemPOS.NE__Qty__c    = 10 ;
            orderItemPOS.NE__Action__c ='Add';
            orderItemPOS.NE__OrderId__c= configuration.id;
		    orderItemPOS.NE__ProdId__c = prod.Id;
            orderItemPOS.NE__Parent_Order_Item__c = orderItem.id;
            insert orderItemPOS; 

            NE__OrderItem__c orderItem2 = new NE__OrderItem__c ( NE__Qty__c=10 ,
                                                                NE__OrderId__c=configuration.id, 
                                                                NE__Parent_Order_Item__c=orderItem.Id);
            orderItem2.NE__Parent_Order_Item__c=orderItem.Id;
            orderItem2.NE__Action__c='Add';
            orderItem2.NE__OrderId__c=configuration.Id;
            insert orderItem2;

            ///////////the section if(orderItemAcqVAS.size() > 0 )

             NE__OrderItem__c orderItemAcqVAS = new NE__OrderItem__c();
            orderItemAcqVAS.NE__Qty__c    = 10 ;
            orderItemAcqVAS.NE__Action__c ='Add';
            orderItemAcqVAS.NE__OrderId__c= configuration.id;
		    orderItemAcqVAS.NE__ProdId__c = prod3.Id;            
            insert orderItemAcqVAS;   

            NE__OrderItem__c orderItemAcqVAS2 = new NE__OrderItem__c();
            orderItemAcqVAS2.NE__Action__c ='Add';
            orderItemAcqVAS2.NE__Qty__c    = 10 ;
            orderItemAcqVAS2.NE__OrderId__c= configuration.id;
		    orderItemAcqVAS2.NE__ProdId__c = prod.Id;
            orderItemAcqVAS2.NE__Parent_Order_Item__c = orderItemAcqVAS.id;
            insert orderItemAcqVAS2; 
            // List<NE__OrderItem__c> orderItemAcqVAS3 = new List<NE__OrderItem__c>();
            // orderItemAcqVAS3.add(orderItemAcqVAS2);
           
		        
            Account merchant = new Account( Name = 'merchant name', 
                                            RecordTypeId = merchantRecordTypeId, 
                                            OB_Employees_Number__c = 'Minore di 10', 
                                            NE__Fiscal_code__c = 'AAAAAA11A11A111A', 
                                            OB_VAT_Not_Present__c = true, 
                                            OB_DescriptionVATNotPresent__c = 'desc' );
                                            // OB_ABI__c= abi
                                           
            insert merchant;

            Account bank = new Account( Name = 'merchant name', 
                                            RecordTypeId = bankRecordTypeId, 
                                            OB_Employees_Number__c = 'Minore di 10', 
                                            NE__Fiscal_code__c = 'AAAAAA11A11A111A', 
                                            OB_VAT_Not_Present__c = true, 
                                            OB_DescriptionVATNotPresent__c = 'desc', 
                                            OB_ABI__c = '12345');
                                            // OB_ABI__c= abi
                                           
            insert bank;


            OB_Bank_Profile__c bp = new OB_Bank_Profile__c();

            bp.OB_Bank__c = bank.Id;
            bp.OB_Service_Type__c = 'Acquiring'; 
            bp.OB_Business_Model_POS__c = 'Bilaterale'; 
            bp.OB_Circuit__c = 'JCB'; 
            bp.OB_Other_Acquirer__c = 'Amex';
            bp.OB_Applicant_RAC_Code_SIA__c = 'Banca'; 
            bp.OB_Terminal_Id_Generator__c  = 'Banca'; 
            bp.OB_Technical_component_invoicing__c = 'TecMarket(servizio fatturazione per conto terzi)'; 
            bp.OB_GT__c = 'Nexi'; 
            bp.OB_Processor__c = 'SIA SMAC'; 
            bp.OB_Bilateral_Pricing__c = 'SI'; 
            bp.OB_Sending_Contract_to_Nexi__c = 'SI'; 
            bp.OB_SME_Factory__c = 'SI';
            bp.OB_NeedBIO__c     = true;
            bp.OB_Bank__c = bank.Id;
            insert bp;

           
            // List<OB_Bank_Profile__c> listOfBankProf  = new List<OB_Bank_Profile__c>();
            // OB_Bank_Profile__c.OB_NeedBIO__c  =
            

           

            NE__Service_Point__c sp = new NE__Service_Point__c();
            sp.NE__Account__c = merchant.Id;
			sp.Name           ='TEST';
			sp.OB_Status__c   ='Active';
		    insert sp;
		    OB_LogRequest__c  logRequest = new OB_LogRequest__c();
            logRequest.OB_AccountId__c      = merchant.Id;
            logRequest.OB_ServicePointId__c = sp.id;
            logRequest.RecordTypeId         = rtPricing;
            logRequest.OB_MaintenanceType__c= OB_UtilityConstants.PRICING;
            insert logRequest;
        
            Test.startTest();
            OB_MainApprovedPricingProcessController.createLogRequestServer(merchant.Id, sp.Id, configuration.id, abi, cab,'variazione economica');
            OB_MainApprovedPricingProcessController.createLogRequestServer(merchant.Id, sp.Id, configuration.id, abi, cab,'variazione operativa');
            OB_MainApprovedPricingProcessController.createLogRequestServer(merchant.Id, sp.Id, configuration2.id, abi, cab,'variazione operativa');
            Test.stopTest();

     }

    // getStringUrl
      @isTest
    public static void getStringUrl_Test(){

        OB_Integration_Configuration__c ic = new OB_Integration_Configuration__c();
        ic.Name = 'DEV1';
        ic.OB_Domain__c = 'dev1';
        ic.OB_Token_1__c = 'eyJ0eXAiOiJKV1QiLCJjdHkiOiJKV1QiLCJhbGciOiJSU0EtT0FFUCIsImVuYyI6IkExMjhDQkMtSFMyNTYifQ.nynF9045u2M-1WGn007JxObPiM3PBK0Q4GM8EBwQS0o6fJutTABfMSTtekOlCpQEv4vKSLmj0-Rgk5rQgireCX-cOp_Vvh9IYLl6xfOJfUR8f5mLUmY4r7BGrWtLbaM5wwTIJXQs8kFpp2VIePragkN2MahtjIOtBp1vQW2y';
        ic.OB_timestamp__c = '1542902538147';
        ic.OB_Timeout_Continuation__c = '30';
        insert ic;

        String urlString = 'Empty or null Value';
        Test.startTest();
        OB_MainApprovedPricingProcessController.getStringUrl();// catch()
       // String urlString = OB_MainApprovedPricingProcessController.getStringUrl();// try()
        Test.stopTest();

     } 

     @isTest
    public static void getStringUrl_Exception_Test(){

        String urlString = 'Empty or null Value';
        Test.startTest();
        OB_MainApprovedPricingProcessController.getStringUrl();// catch()
       // String urlString = OB_MainApprovedPricingProcessController.getStringUrl();// try()
        Test.stopTest();

     } 

     @isTest
     public static void acquiringChangesServerTest()
     {
        NE__Order_Header__c oh = new NE__Order_Header__c();
        insert oh;
        NE__Order__c order = new NE__Order__c();
        order.NE__Order_Header__c = oh.Id;
        order.OB_AdditionalDocumentationRequired__c = true;
        insert order;	
        NE__Product__c prod = new NE__Product__c();
        prod.Name = 'prod';  
        prod.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'NE__Product__c' AND DeveloperName = 'Commissione' LIMIT 1].id;
        insert prod;
        NE__OrderItem__c oi = new NE__OrderItem__c();
        oi.NE__Qty__c = 1;
        oi.NE__Action__c ='Add';
        oi.NE__OrderId__c = order.id;
        oi.NE__ProdId__c = prod.Id;            
        insert oi;    
        Test.startTest();
        List<Id> configurationId = new List<Id>();
        OB_MainApprovedPricingProcessController.acquiringChangesServer(configurationId);
        configurationId.add(order.id);
        OB_MainApprovedPricingProcessController.acquiringChangesServer(null);
        OB_MainApprovedPricingProcessController.acquiringChangesServer(configurationId);
        Test.stopTest();
     }
     
}