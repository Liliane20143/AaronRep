@isTest
 public class OB_Maintenance_Consistenza_LogR_Test {
    
     @isTest
    public static void retrieveLogRequestConsistenzaTest(){ 
        
        Id merchantRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Merchant').getRecordTypeId();
        Account acc = new Account(Name = 'acc');
        acc.RecordTypeId = merchantRecordTypeId;
        acc.OB_BypassValidation__c = true;
        insert acc;
        OB_LogRequest__c lr = new OB_LogRequest__c();
        lr.OB_AccountId__c = acc.id;
        lr.OB_ChangeLegalRepresentative__c = true;
        lr.OB_NewLegalRepresentative__c = true;
        lr.OB_RejectReason__c = 'Cancelled';
        lr.OB_ApprovalProcessStatus__c = 'Rigettato';
        insert lr;
        Id logrequestId = lr.id;
        Test.startTest();
        OB_Maintenance_Consistenza_LogRequest_CC.retrieveLogRequestConsistenza(logrequestId);
        Test.stopTest();
     }
   
     @isTest
     static void checkProfileOnLogRequestConsistenzaTest(){
       
         Test.startTest();
         OB_Maintenance_Consistenza_LogRequest_CC.checkProfileOnLogRequestConsistenza();
         Test.stopTest();
     }

    
    @isTest
    public static void getConfigurationServer_Test(){

        NE__Order_Header__c orderHeader = new NE__Order_Header__c();
		insert orderHeader;
        NE__Order__c configuration = new NE__Order__c(NE__Order_Header__c=orderHeader.Id);
        configuration.OB_CTI_Code__c = '';
		insert configuration; 
        NE__Order__c config = new NE__Order__c(NE__Order_Header__c=orderHeader.Id);
		insert config;      
        List<NE__Order__c> configurations = new List<NE__Order__c>();
        configurations.add(configuration);
        configurations.add(config);
               
        test.StartTest();
        OB_Maintenance_Consistenza_LogRequest_CC.getConfigurationServer(configuration.Id);
        test.StopTest();  
    }




    // .............  getConfigItemsServer & getSortedConfigItemsServer .......................//
    @isTest
    public static void getConfigItemsServer_Test(){

        Id recordTypeIdTerminale    = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByName().get(OB_UtilityConstants.POS_RT).getRecordTypeId();
        Id recordTypeIdAcquaring    = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByName().get(OB_UtilityConstants.ACQUIRING).getRecordTypeId();
        Id recordTypeIdvas          = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByName().get(OB_UtilityConstants.PRODUCT_RECORDTYPE_VAS).getRecordTypeId();
        Id recordTypeIdPagobancomat = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByName().get(OB_UtilityConstants.PRODUCT_RECORDTYPE_PAGOBANCOMAT).getRecordTypeId();
        Id rtIdPagobancomat         = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Pagobancomat').getRecordTypeId();
        Id rtIdAcquiring            = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Acquiring').getRecordTypeId();
        Id rtIdVas                  = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Vas').getRecordTypeId();
        Id rtIdTerminali            = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get(OB_UtilityConstants.POS_RT).getRecordTypeId();

    //-------------------------------------- PRODUCTS ------------------------------------------------------------//        
        NE__Product__c prodPagobancomat = new NE__Product__c( Name = 'testProd',RecordTypeId = rtIdPagobancomat);
		insert prodPagobancomat;
        NE__Product__c prodacquaring = new NE__Product__c( 	Name = 'testProd',RecordTypeId   = rtIdAcquiring);
		insert prodAcquaring;
        NE__Product__c prodVas = new NE__Product__c( Name = 'testProd',RecordTypeId = rtIdVas);
		insert prodVas;
         NE__Product__c prodPos = new NE__Product__c(Name = 'testProd',RecordTypeId = rtIdTerminali);
		insert prodPos;
    //------------------------------------------------------------------------------------------------------------//
        NE__Order_Header__c orderHeader = new NE__Order_Header__c();
        insert orderHeader;
        NE__Order__c configuration  = new NE__Order__c(NE__Order_Header__c=orderHeader.Id);
        insert configuration; 

        NE__OrderItem__c orderItem1 = new NE__OrderItem__c (NE__Qty__c=10,NE__OrderId__c= configuration.Id);
        orderItem1.RecordTypeId  = recordTypeIdTerminale;
        orderItem1.NE__ProdId__c = prodPagobancomat.id;
        orderItem1.OB_enablement__c = 'N';
        orderItem1.OB_Old_Enablement__c = 'Y';
        orderItem1.NE__Action__c = 'Add';
        insert orderItem1;

        NE__OrderItem__c orderItem2 = new NE__OrderItem__c (NE__Qty__c=10,NE__OrderId__c= configuration.Id);
        orderItem2.RecordTypeId         = recordTypeIdAcquaring;
        orderItem2.NE__ProdId__c        = prodacquaring.id;
        orderItem2.OB_enablement__c     = 'N';
        orderItem2.OB_Old_Enablement__c = 'Y';
        orderItem2.NE__Action__c        = 'Add';
        insert orderItem2;

        NE__OrderItem__c orderItem3 = new NE__OrderItem__c (NE__Qty__c=10,NE__OrderId__c= configuration.Id);
        orderItem3.RecordTypeId         = recordTypeIdvas;
        orderItem3.NE__ProdId__c        = prodVas.id;
        orderItem3.OB_enablement__c     = 'N';
        orderItem3.OB_Old_Enablement__c = 'Y';
        orderItem3.NE__Action__c        = 'Add';
        insert orderItem3;

        NE__OrderItem__c orderItem4 = new NE__OrderItem__c (NE__Qty__c=10,NE__OrderId__c= configuration.Id);
        orderItem4.RecordTypeId         = recordTypeIdPagobancomat;
        orderItem4.NE__ProdId__c        = prodPos.id;
        orderItem4.OB_enablement__c     = 'N';
        orderItem4.OB_Old_Enablement__c = 'Y';
        orderItem4.NE__Action__c        = 'Add';
        insert orderItem4;

        NE__OrderItem__c orderItem = new NE__OrderItem__c (NE__Qty__c=10,NE__OrderId__c= configuration.Id);
        orderItem.RecordTypeId           = recordTypeIdAcquaring;
        orderItem.NE__ProdId__c          = prodPagobancomat.id;
        orderItem.NE__Root_Order_Item__c = orderItem1.id;
        orderItem.NE__Action__c          = 'Add';
        insert orderItem;

        List<NE__OrderItem__c> listOfItemsTerm = new List<NE__OrderItem__c> ();
        //listOfItemsTerm.add(orderItem);
        listOfItemsTerm.add(orderItem1);
        listOfItemsTerm.add(orderItem2);
        listOfItemsTerm.add(orderItem3);
        listOfItemsTerm.add(orderItem4);
        listOfItemsTerm.add(orderItem);

       
        NE__Order_Item_Attribute__c ordItemAttr = new NE__Order_Item_Attribute__c();
		ordItemAttr.Name = 'Sono un test';
		ordItemAttr.NE__Order_Item__c = orderItem1.Id; 
        OB_Maintenance_Consistenza_LogRequest_CC.WrapperTerminalwithVAS wrapperTerm = new OB_Maintenance_Consistenza_LogRequest_CC.WrapperTerminalwithVAS();
        wrapperTerm.VAS          =  orderItem3;
        wrapperTerm.terminalList =  listOfItemsTerm;
        test.StartTest();
        OB_Maintenance_Consistenza_LogRequest_CC.getConfigItemsServer(configuration.Id);
        OB_Maintenance_Consistenza_LogRequest_CC.getSortedConfigItemsServer(configuration.Id);
        test.StopTest();  
    }
    
      @isTest
    public static void getConfigItemsServerTest2(){
        NE__Order_Header__c orderHeader = new NE__Order_Header__c();
        insert orderHeader;
        NE__Order__c configuration = new NE__Order__c(NE__Order_Header__c=orderHeader.Id);
        insert configuration; 
        NE__OrderItem__c conf =new NE__OrderItem__c (NE__Qty__c=10,NE__OrderId__c= configuration.Id);
        Id recordTypeId= Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByName().get(OB_UtilityConstants.ACQUIRING).getRecordTypeId();
        conf.RecordTypeId=recordTypeId;
        String configurationId= configuration.id;
        insert conf;
        List<NE__OrderItem__c> listOfItemsTerm = new List<NE__OrderItem__c> ();
        listOfItemsTerm.add(conf);
        
        test.StartTest();
        OB_Maintenance_Consistenza_LogRequest_CC.getConfigItemsServer(configurationId);
        test.StopTest();  
    }
    
    
        @isTest
        public static void getConfigurationItemAttributeServerTest(){

            Id recordTypeIdPagobancomat = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByName().get(OB_UtilityConstants.PRODUCT_RECORDTYPE_PAGOBANCOMAT).getRecordTypeId();
            Id recordTypeIdProd         = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Pagobancomat').getRecordTypeId();
            
            NE__Product__c prod = new NE__Product__c( 	Name 				= 'testProd',
														RecordTypeId        = recordTypeIdProd
                                                        );
		    insert prod;
            NE__Order_Header__c orderHeader = new NE__Order_Header__c();
            insert orderHeader;
            NE__Order__c config = new NE__Order__c(NE__Order_Header__c=orderHeader.Id);
            insert config; 
            NE__OrderItem__c orderItem = new NE__OrderItem__c (NE__Qty__c=10,NE__OrderId__c= config.Id);
            orderItem.NE__ProdId__c = prod.id;
            orderItem.RecordTypeId = recordTypeIdPagobancomat;
            insert orderItem;

            NE__Order_Item_Attribute__c oiAttribute1 = new NE__Order_Item_Attribute__c(NE__Order_Item__c=orderItem.id);
            oiAttribute1.Name = 'Codice Stabilimento SIA';
            insert oiAttribute1;

            NE__Order_Item_Attribute__c oiAttribute2 = new NE__Order_Item_Attribute__c(NE__Order_Item__c=orderItem.id);
            oiAttribute2.Name = 'Codice Progressivo SIA';
            insert oiAttribute2;

            NE__Order_Item_Attribute__c oiAttribute3 = new NE__Order_Item_Attribute__c(NE__Order_Item__c=orderItem.id);
            oiAttribute3.Name = 'Codice SIA';
            insert oiAttribute3;

            List <NE__Order_Item_Attribute__c> configurationItemAttributes = new List <NE__Order_Item_Attribute__c>();
            configurationItemAttributes.add(oiAttribute1);
            configurationItemAttributes.add(oiAttribute2);
            configurationItemAttributes.add(oiAttribute3);
        
            List<String> configurationItemIds = new  List<String> ();
            configurationItemIds.add(orderItem.Id);
        
            Test.StartTest();
            OB_Maintenance_Consistenza_LogRequest_CC.getConfigurationItemAttributeServer(configurationItemIds);
            Test.StopTest();

        }

        @isTest
        public static void getSortedConfigItemsServer2Test()
        {
            NE__Order_Header__c orderHeader = new NE__Order_Header__c();
            insert orderHeader;
            NE__Order__c order = new NE__Order__c(NE__Order_Header__c=orderHeader.Id);
            insert order;


            
            
            Id acquiringProductRecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Acquiring').getRecordTypeId();
            NE__Product__c acquiringProduct = new NE__Product__c(Name = 'pagoBancomatProduct', RecordTypeId = acquiringProductRecordTypeId);
		    insert acquiringProduct;
            Id acquiringOrderItemRecordTypeId = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByName().get('Acquiring').getRecordTypeId();
            NE__OrderItem__c acquiringOrderItem = new NE__OrderItem__c (NE__Qty__c=10, NE__OrderId__c = order.Id, NE__ProdId__c = acquiringProduct.id, RecordTypeId = acquiringOrderItemRecordTypeId);
            insert acquiringOrderItem;

            Id vasProductRecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Vas').getRecordTypeId();
            NE__Product__c vasProduct = new NE__Product__c(Name = 'pagoBancomatProduct', RecordTypeId = vasProductRecordTypeId);
		    insert vasProduct;
            Id vasOrderItemRecordTypeId = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByName().get('Vas').getRecordTypeId();
            NE__OrderItem__c vasOrderItem = new NE__OrderItem__c (NE__Qty__c = 10, NE__OrderId__c = order.Id, NE__ProdId__c = vasProduct.id, RecordTypeId = vasOrderItemRecordTypeId);
            insert vasOrderItem; 

            Id pagobancomatProductRecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Pagobancomat').getRecordTypeId();
            NE__Product__c pagobancomatProduct = new NE__Product__c(Name = 'pagoBancomatProduct', RecordTypeId = pagobancomatProductRecordTypeId);
		    insert pagobancomatProduct;
            Id pagobancomatOrderItemRecordTypeId = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByName().get(OB_UtilityConstants.PRODUCT_RECORDTYPE_PAGOBANCOMAT).getRecordTypeId();
            NE__OrderItem__c pagobancomatOrderItem = new NE__OrderItem__c (NE__Qty__c=10, NE__OrderId__c = order.Id, NE__ProdId__c = pagobancomatProduct.id, RecordTypeId = pagobancomatOrderItemRecordTypeId);
            insert pagobancomatOrderItem;
            NE__Order_Item_Attribute__c orderItemAttribute = new NE__Order_Item_Attribute__c(NE__Order_Item__c = pagobancomatOrderItem.id, NE__Value__c = 'NE__Value__c');
            insert orderItemAttribute;

            Id terminaliProductRecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Terminali').getRecordTypeId();
            NE__Product__c terminaliProduct = new NE__Product__c(Name = 'pagoBancomatProduct', RecordTypeId = terminaliProductRecordTypeId);
		    insert terminaliProduct;
            Id terminaliOrderItemRecordTypeId = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByName().get(OB_UtilityConstants.PRODUCT_RECORDTYPE_PAGOBANCOMAT).getRecordTypeId();
            NE__OrderItem__c terminaliOrderItem = new NE__OrderItem__c (NE__Action__c = 'Add', NE__Qty__c=10, NE__OrderId__c = order.Id, NE__ProdId__c = terminaliProduct.id, RecordTypeId = terminaliOrderItemRecordTypeId);
            insert terminaliOrderItem;
      

            String configurationId = order.id;
            Test.startTest();
            OB_Maintenance_Consistenza_LogRequest_CC.getSortedConfigItemsServer2(configurationId);
            Test.stopTest();
        }


    @isTest
    public static void compatibilityTechnicalConfigurator_Test()
    {

        NE__Order_Header__c orderHeader = OB_TestDataFactory.getOrderHeader();
        insert orderHeader;
        NE__Order__c order =  OB_TestDataFactory.getOrder(orderHeader);
        insert order;
        String configurationId = order.id;

        Id terminaliProductRecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Terminali').getRecordTypeId();
        NE__Product__c terminaliProduct = OB_TestDataFactory.getProduct(); 
        terminaliProduct.RecordTypeId = terminaliProductRecordTypeId;
        insert terminaliProduct;
        Id terminaliOrderItemRecordTypeId = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByName().get(OB_UtilityConstants.PRODUCT_RECORDTYPE_PAGOBANCOMAT).getRecordTypeId();
        NE__OrderItem__c terminaliOrderItem = OB_TestDataFactory.getOrderItem(order.id);
        terminaliOrderItem.NE__Action__c = 'None';
        terminaliOrderItem.NE__ProdId__c = terminaliProduct.id; 
        terminaliOrderItem.RecordTypeId = terminaliOrderItemRecordTypeId;
        insert terminaliOrderItem;

        Id acquiringProductRecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Acquiring').getRecordTypeId();
        NE__Product__c acquiringProduct = OB_TestDataFactory.getProduct();
        acquiringProduct.RecordTypeId = acquiringProductRecordTypeId;
		insert acquiringProduct;
      
        Id acquiringOrderItemRecordTypeId = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByName().get('Acquiring').getRecordTypeId();
        NE__OrderItem__c acquiringOrderItem = OB_TestDataFactory.getOrderItem(order.id);  
        acquiringOrderItem.NE__ProdId__c = acquiringProduct.id; 
        acquiringOrderItem.RecordTypeId = acquiringOrderItemRecordTypeId;
        acquiringOrderItem.NE__Root_Order_Item__c = terminaliOrderItem.Id;
        insert acquiringOrderItem;
        
           
        Test.startTest();
            OB_Maintenance_Consistenza_LogRequest_CC.compatibilityTechnicalConfigurator(configurationId);
        Test.stopTest();
        
    }

    @isTest
    public static void createSecondLogrequestTechnicalConfigurator_test()
    {   

        NE__Service_Point__c spToLog = OB_TestDataFactory.getServicePoint();
        
        insert spToLog;

        OB_LogRequest__c log = OB_TestDataFactory.getLogRequest();
        log.OB_ServicePointId__c = spToLog.Id;
        insert log;
        
        NE__Service_Point__c sp = OB_TestDataFactory.getServicePoint();
        sp.Id          = log.OB_ServicePointId__c;
        sp.OB_MCC__c = '0001';
        upsert sp;
         Id terminaliProductRecordTypeId = Schema.SObjectType.OB_LogRequest__c.getRecordTypeInfosByName().get('Consistenza').getRecordTypeId();
        OB_LogRequest__c log1 = OB_TestDataFactory.getLogRequest();
        log1.OB_AccountId__c		    	= 	        log.OB_AccountId__c;
        log1.OB_ServicePointId__c   	    = 	        log.OB_ServicePointId__c;
        log1.OB_OrderId__c          	    = 	        log.OB_OrderId__c;
        log1.OB_ABI__c			        	=		    log.OB_ABI__c;
        log1.OB_CAB__c			        	=		    log.OB_CAB__c;
        log1.OB_MaintenanceType__c  	    =           log.OB_MaintenanceType__c;
        log1.OB_Status__c			      	=		    OB_UtilityConstants.BOZZA;
        log1.OB_HasAcquiring__c   		    =           log.OB_HasAcquiring__c;
        log1.OB_HasPos__c           	    =           log.OB_HasPos__c;
        log1.OB_HasVas__c           	    =           log.OB_HasVas__c;
        log1.OB_OrderId__c          	    =           log.OB_OrderId__c;
        log1.RecordTypeId			      	=		    terminaliProductRecordTypeId;			
        log1.OB_isNotIntegrated__c  	    =           log.OB_isNotIntegrated__c;
        insert log1;
        Test.startTest();
            OB_Maintenance_Consistenza_LogRequest_CC.createSecondLogrequestTechnicalConfigurator(log.id);
        Test.stopTest();
        
    }


    @isTest
    public static void updateRequestSia_Test()
    {
         OB_LogRequest__c log = OB_TestDataFactory.getLogRequest();
        insert log;
        Test.startTest();
            OB_Maintenance_Consistenza_LogRequest_CC.updateRequestSia(log);
        Test.stopTest();
    }

    

 }