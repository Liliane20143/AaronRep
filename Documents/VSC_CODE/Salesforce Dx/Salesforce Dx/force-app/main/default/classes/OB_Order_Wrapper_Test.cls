@isTest
public class OB_Order_Wrapper_Test {

    @testSetup static void setup() {
    // Create common test accounts

        NE__Product__c   product    = new NE__Product__c();
        product.OB_Codice_sfdc__c   = 'PRE-AUT';
        //product.OB_Codice_sfdc__c   = 'VISAMASTERCARD';
        product.OB_Acquirer__c      = 'NEXI';
        product.OB_Contract_Type__c = 'A. CANONE DI LOCAZIONE';
        product.OB_Pricing_Code__c  = ''; 
        Id recordTypeId             = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Terminali').getRecordTypeId();//Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Terminali').getRecordTypeId();
        product.RecordTypeId        = recordTypeId;    
        insert product;       

        //creating orderHeader
        NE__Order_Header__c oh = new NE__Order_Header__c();
        insert oh;

        //creating order
        NE__Order__c order = new NE__Order__c(NE__Order_Header__c = oh.Id);
        insert order;

        //creating parentOrderItem
        NE__OrderItem__c parentOrderItem = new NE__OrderItem__c();
        parentOrderItem.NE__OrderId__c = order.Id;
        parentOrderItem.NE__Qty__c     = 1;
        parentOrderItem.NE__ProdId__c  = product.id;
        insert parentOrderItem;

        //creating orderItem1, orderItem2, orderItem3
        NE__OrderItem__c orderItem = new NE__OrderItem__c(NE__OrderId__c = order.Id, 
                                        NE__Qty__c    = 1, 
                                        NE__ProdId__c = product.id);
        // i need a case in which the parentOrderItem is null!
        //  orderItem.NE__Parent_Order_Item__c = parentOrderItem.id;

        NE__OrderItem__c orderItem1 = new NE__OrderItem__c(NE__OrderId__c = order.Id, 
                                        NE__Qty__c    = 1, 
                                        NE__ProdId__c = product.id);
        orderItem1.NE__Parent_Order_Item__c = parentOrderItem.id;

        NE__OrderItem__c orderItem2 = new NE__OrderItem__c(NE__OrderId__c = order.Id, 
                                        NE__Qty__c    = 1, 
                                        NE__ProdId__c = product.id);
        orderItem2.NE__Parent_Order_Item__c = parentOrderItem.id;

        List<NE__OrderItem__c> configItemList = new List<NE__OrderItem__c>();
        configItemList.add(orderItem);
        configItemList.add(orderItem1);
        configItemList.add(orderItem2);
        insert configItemList;

        /* List<Id> idList = new List<Id>();
        idList.add(orderItem.id);
        idList.add(parentOrderItem.id);
        idList.add(order.id);
        idList.add(oh.id);

        Map<String,List<Id>>   configStringList = new Map<String,List<Id>>();
        configStringList.put('Pricing',idList);
        Map<Id,Map<String,List<Id>>> configurationMap  = new Map<Id,Map<String,List<Id>>>();
        configurationMap.put(order.id, configStringList);
        system.debug('configurationMap ---> ' + configurationMap);

        Map<Id,List<Id>>   childItemMap   = new Map<Id,List<Id>>();
        childItemMap.put(parentOrderItem.id, idList);
        system.debug('childItemMap ---> ' + childItemMap);*/
    }



    @isTest
    public static void OB_Order_WrapperTest(){
        // NE__Order_Header__c o = [select id from]
        NE__Order_Header__c oh = [select id from  NE__Order_Header__c limit 1];
        Test.startTest();
        OB_Order_Wrapper ow = new OB_Order_Wrapper(oh.Id);
        Test.stopTest();


    }

    /***************************/
    /*    DD ** 21 - 11 - 2018 */


    @isTest
    public static void printConfigurations_Test()
    {
        NE__Order_Header__c oh = new NE__Order_Header__c();
        insert oh;

        Test.startTest();
        OB_Order_Wrapper orderWrapper = new OB_Order_Wrapper(oh.id);
        orderWrapper.printConfigurations();
        Test.stopTest();
    }


    @isTest
    public static void getTerminali_Test()
    {
        NE__Order_Header__c oh = [select id from  NE__Order_Header__c limit 1];
        NE__Order__c ord = [select id from NE__Order__c limit 1];  
        NE__Product__c product = [select id from NE__Product__c limit 1];  
        //Id recordTypeId   = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Terminali').getRecordTypeId();
        Test.startTest();
        OB_Order_Wrapper orderWrapper = new OB_Order_Wrapper(oh.id); 
        orderWrapper.getTerminali(ord.id);
        Test.stopTest();

    }

    @isTest
    public static void getTerminaliPricing_Test()
    {
        NE__Order_Header__c oh = [select id from  NE__Order_Header__c limit 1];
        NE__Order__c ord = [select id from NE__Order__c limit 1];  
        NE__Product__c product = [select id from NE__Product__c limit 1];  
        Id recordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'NE__Product__c' AND DeveloperName = 'Pricing' LIMIT 1].id;
        product.recordTypeId = recordTypeId;
        update product;
        Test.startTest();
        OB_Order_Wrapper orderWrapper = new OB_Order_Wrapper(oh.id); 
        orderWrapper.getTerminali(ord.id);
        Test.stopTest();

    }

    @isTest
    public static void getTerminali_GatewayTest()
    {
        //Id recordTypeId   = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Gateway_Virtuale').getRecordTypeId();
        Id recordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'NE__Product__c' AND DeveloperName = 'Gateway_Virtuale' LIMIT 1].id;
        NE__Order_Header__c oh = [select id from  NE__Order_Header__c limit 1];
        NE__Order__c ord = [select id from NE__Order__c limit 1];  
        NE__Product__c product = [select id from NE__Product__c limit 1];  
        product.recordTypeId = recordTypeId;

        update product;

        Test.startTest();
        OB_Order_Wrapper orderWrapper = new OB_Order_Wrapper(oh.id); 
        orderWrapper.getTerminali(ord.id);
        Test.stopTest();
    }

    @isTest
    public static void getTerminali_MotoTest()
    {
        //Id recordTypeId   = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Gateway_Virtuale').getRecordTypeId();
        Id recordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'NE__Product__c' AND DeveloperName = 'Moto' LIMIT 1].id;
        NE__Order_Header__c oh = [select id from  NE__Order_Header__c limit 1];
        NE__Order__c ord = [select id from NE__Order__c limit 1];  
        NE__Product__c product = [select id from NE__Product__c limit 1];  
        product.recordTypeId = recordTypeId;

        update product;

        Test.startTest();
        OB_Order_Wrapper orderWrapper = new OB_Order_Wrapper(oh.id); 
        orderWrapper.getTerminali(ord.id);
        Test.stopTest();
    }
    @isTest
    public static void getTerminali_ECommerceTest()
    {
    //Id recordTypeId   = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Gateway_Virtuale').getRecordTypeId();
    Id recordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'NE__Product__c' AND DeveloperName = 'eCommerce' LIMIT 1].id;
    NE__Order_Header__c oh = [select id from  NE__Order_Header__c limit 1];
    NE__Order__c ord = [select id from NE__Order__c limit 1];  
    NE__Product__c product = [select id from NE__Product__c limit 1];  
    product.recordTypeId = recordTypeId;

    update product;

    Test.startTest();
    OB_Order_Wrapper orderWrapper = new OB_Order_Wrapper(oh.id); 
    orderWrapper.getTerminali(ord.id);
    Test.stopTest();
    }
    @isTest
    public static void getTerminali_PricingTest()
    {
        //Id recordTypeId   = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Gateway_Virtuale').getRecordTypeId();
        Id recordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'NE__Product__c' AND DeveloperName = 'Pricing' LIMIT 1].id;
        NE__Order_Header__c oh = [select id from  NE__Order_Header__c limit 1];
        NE__Order__c ord = [select id from NE__Order__c limit 1];  
        NE__Product__c product = [select id from NE__Product__c limit 1];  
        product.recordTypeId = recordTypeId;

        update product;

        Test.startTest();
        OB_Order_Wrapper orderWrapper = new OB_Order_Wrapper(oh.id); 
        orderWrapper.getTerminali(ord.id);
        Test.stopTest();
    }

    @isTest
    public static void getPCI_Test()
    {
        Id recordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'NE__Product__c' AND DeveloperName = 'PCI' LIMIT 1].id;
        NE__Order_Header__c oh = [select id from  NE__Order_Header__c limit 1];
        NE__Order__c ord = [select id from NE__Order__c limit 1];  
        NE__Product__c product = [select id from NE__Product__c limit 1];  
        product.recordTypeId = recordTypeId;

        update product;

        Test.startTest();
        OB_Order_Wrapper orderWrapper = new OB_Order_Wrapper(oh.id); 
        orderWrapper.getPCI(ord.id);
        Test.stopTest();

    }
    @isTest
    public static void getPCIPricing_Test()
    {
        Id recordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'NE__Product__c' AND DeveloperName = 'Pricing' LIMIT 1].id;
        NE__Order_Header__c oh = [select id from  NE__Order_Header__c limit 1];
        NE__Order__c ord = [select id from NE__Order__c limit 1];  
        NE__Product__c product = [select id from NE__Product__c limit 1];  
        product.recordTypeId = recordTypeId;

        update product;

        Test.startTest();
        OB_Order_Wrapper orderWrapper = new OB_Order_Wrapper(oh.id); 
        orderWrapper.getPCI(ord.id);
        Test.stopTest();

    }


    @isTest
    public static void getAcquiring_Test()
    {
        Id recordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'NE__Product__c' AND DeveloperName = 'Acquiring' LIMIT 1].id;
        NE__Order_Header__c oh = [select id from  NE__Order_Header__c limit 1];
        NE__Order__c ord = [select id from NE__Order__c limit 1];  
        NE__Product__c product = [select id from NE__Product__c limit 1];  
        product.recordTypeId = recordTypeId;

        update product;

        Test.startTest();
        OB_Order_Wrapper orderWrapper = new OB_Order_Wrapper(oh.id); 
        orderWrapper.getAcquiring(ord.id);
        Test.stopTest();

    }

    @isTest
    public static void getAcquiringPricing_Test()
    {
        Id recordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'NE__Product__c' AND DeveloperName = 'Pricing' LIMIT 1].id;
        NE__Order_Header__c oh = [select id from  NE__Order_Header__c limit 1];
        NE__Order__c ord = [select id from NE__Order__c limit 1];  
        NE__Product__c product = [select id from NE__Product__c limit 1];  
        product.recordTypeId = recordTypeId;

        update product;

        Test.startTest();
        OB_Order_Wrapper orderWrapper = new OB_Order_Wrapper(oh.id); 
        orderWrapper.getAcquiring(ord.id);
        Test.stopTest();

    }

    @isTest
    public static void getVas_Test()
    {

        Id recordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'NE__Product__c' AND DeveloperName = 'Vas' LIMIT 1].id;
        NE__Order_Header__c oh = [select id from  NE__Order_Header__c limit 1];
        NE__Order__c ord = [select id from NE__Order__c limit 1];  
        NE__Product__c product = [select id from NE__Product__c limit 1];  
        product.recordTypeId = recordTypeId;

        update product;

        Test.startTest();
        OB_Order_Wrapper orderWrapper = new OB_Order_Wrapper(oh.id); 
        orderWrapper.getVas(ord.id);
        Test.stopTest();

    }
    @isTest
    public static void getVasIntegrazione_Test()
    {

        Id recordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'NE__Product__c' AND DeveloperName = 'Integrazione' LIMIT 1].id;
        NE__Order_Header__c oh = [select id from  NE__Order_Header__c limit 1];
        NE__Order__c ord = [select id from NE__Order__c limit 1];  
        NE__Product__c product = [select id from NE__Product__c limit 1];  
        product.recordTypeId = recordTypeId;

        update product;

        Test.startTest();
        OB_Order_Wrapper orderWrapper = new OB_Order_Wrapper(oh.id); 
        orderWrapper.getVas(ord.id);
        Test.stopTest();

    }

    @isTest
    public static void getPagoBancomat_Test()
    {
        Id recordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'NE__Product__c' AND DeveloperName = 'Pagobancomat' LIMIT 1].id;
        NE__Order_Header__c oh = [select id from  NE__Order_Header__c limit 1];
        NE__Order__c ord = [select id from NE__Order__c limit 1];  
        NE__Product__c product = [select id from NE__Product__c limit 1];  
        product.recordTypeId = recordTypeId;

        update product;

        Test.startTest();
        OB_Order_Wrapper orderWrapper = new OB_Order_Wrapper(oh.id); 
        orderWrapper.getPagoBancomat(ord.id);
        Test.stopTest();
    }
    @isTest
    public static void getPagoBancomatPricing_Test()
    {
        Id recordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'NE__Product__c' AND DeveloperName = 'Pricing' LIMIT 1].id;
        NE__Order_Header__c oh = [select id from  NE__Order_Header__c limit 1];
        NE__Order__c ord = [select id from NE__Order__c limit 1];  
        NE__Product__c product = [select id from NE__Product__c limit 1];  
        product.recordTypeId = recordTypeId;
        NE__OrderItem__c orderItem= [select id, NE__ProdId__c from  NE__OrderItem__c limit 1];

        update product;
        orderItem.NE__ProdId__c = product.Id;
        update orderItem;

        Test.startTest();
        OB_Order_Wrapper orderWrapper = new OB_Order_Wrapper(oh.id); 
        orderWrapper.getPagoBancomat(ord.id);
        Test.stopTest();
    }

    // @isTest
    // public static void calculateAction_Test()
    // {
    // //  NE__Order_Header__c oh = [select id from  NE__Order_Header__c limit 1];
    // NE__OrderItem__c orderItem = [select id, NE__ProdId__r.RecordType.DeveloperName , NE__Parent_Order_Item__c from NE__OrderItem__c limit 1];  

    // Test.startTest();
    // //OB_Order_Wrapper orderWrapper = new OB_Order_Wrapper(oh.id);
    // OB_Order_Wrapper.calculateAction(orderItem);
    // Test.stopTest();
    // /* NE__Order_Header__c oh = new NE__Order_Header__c();
    // insert oh;
    // NE__Order__c order = new NE__Order__c(NE__Order_Header__c = oh.id); 
    // insert order;
    // NE__OrderItem__c orderItem = new NE__OrderItem__c(NE__OrderId__c = order.id, NE__Qty__c = 1);
    // insert orderItem;

    // Test.startTest();
    // OB_Order_Wrapper.calculateAction(orderItem);
    // Test.stopTest();*/
    // }


    @isTest
    public static void calculateEnablement_Test()
    {
        NE__OrderItem__c orderItem = [select id, NE__ProdId__c, OB_enablement__c, OB_Old_Enablement__c, NE__Action__c from NE__OrderItem__c limit 1];  
        /*  NE__Order_Header__c oh = new NE__Order_Header__c();
        insert oh;
        NE__Order__c order = new NE__Order__c(NE__Order_Header__c = oh.id); 
        insert order;
        NE__OrderItem__c orderItem = new NE__OrderItem__c(NE__OrderId__c = order.id, NE__Qty__c = 1);
        insert orderItem;*/

        Test.startTest();
        OB_Order_Wrapper.calculateEnablement(orderItem);
        Test.stopTest();
    }


    @isTest
    public static void serializeTerminals_Test()
    {
        NE__Order_Header__c oh = [select id from  NE__Order_Header__c limit 1];
        NE__Order__c ord = [select id from NE__Order__c limit 1];  
        NE__Product__c product = [select id from NE__Product__c limit 1];  

        /* NE__Order_Header__c oh = new NE__Order_Header__c();
        insert oh;
        NE__Order__c order = new NE__Order__c(NE__Order_Header__c = oh.id); 
        insert order;*/

        Test.startTest();
        OB_Order_Wrapper orderWrapper = new OB_Order_Wrapper(oh.id);
        orderWrapper.serializeTerminals(ord.id);
        Test.stopTest();
    }



    @isTest
    public static void serializeBancomat_Test()
    {
        Id recordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'NE__Product__c' AND DeveloperName = 'Pagobancomat' LIMIT 1].id;
        NE__Order_Header__c oh = [select id from  NE__Order_Header__c limit 1];
        NE__Order__c ord = [select id from NE__Order__c limit 1];  
        NE__Product__c product = [select id from NE__Product__c limit 1];  
        product.recordTypeId = recordTypeId;

        update product;
        /*NE__Order_Header__c oh = new NE__Order_Header__c();
        insert oh;
        NE__Order__c order = new NE__Order__c(NE__Order_Header__c = oh.id); 
        insert order;()*/

        Test.startTest();
        OB_Order_Wrapper orderWrapper = new OB_Order_Wrapper(oh.id);
        orderWrapper.serializeBancomat(ord.id);
        Test.stopTest();
    }


    @isTest
    public static void serializeVas_Test()
    {
        Id recordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'NE__Product__c' AND DeveloperName = 'Vas' LIMIT 1].id;
        NE__Order_Header__c oh = [select id from  NE__Order_Header__c limit 1];
        NE__Order__c ord = [select id from NE__Order__c limit 1];  
        NE__Product__c product = [select id from NE__Product__c limit 1];  
        product.recordTypeId = recordTypeId;

        update product;

        /*NE__Order_Header__c oh = new NE__Order_Header__c();
        insert oh;
        NE__Order__c order = new NE__Order__c(NE__Order_Header__c = oh.id); 
        insert order;*/

        Test.startTest();
        OB_Order_Wrapper orderWrapper = new OB_Order_Wrapper(oh.id);
        orderWrapper.serializeVas(ord.id);
        Test.stopTest();
    }


     @isTest
     public static void geAccountStatement_Test()
     {
    Id recordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'NE__Product__c' AND DeveloperName = 'Acquiring' LIMIT 1].id;
    NE__Order_Header__c oh = [select id from  NE__Order_Header__c limit 1];
    NE__Order__c ord = [select id, OB_Report_Type__c from NE__Order__c limit 1];  
    NE__Product__c product = [select id from NE__Product__c limit 1];  
    product.recordTypeId = recordTypeId;

    update product;
    // NE__Order_Header__c oh = new NE__Order_Header__c();
    // insert oh;
    NE__Order__c order = new NE__Order__c(NE__Order_Header__c = oh.id); 
    insert order;
    NE__OrderItem__c oi = new NE__OrderItem__c(NE__OrderId__c = order.id, NE__Qty__c = 1);
    insert oi;

    Test.startTest();
    OB_Order_Wrapper orderWrapper = new OB_Order_Wrapper(oh.id);
    orderWrapper.geAccountStatement(ord.id);
    Test.stopTest();

     }


    @isTest
    public static void serializeAcquiring_Test()
    {
        Id recordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'NE__Product__c' AND DeveloperName = 'Acquiring' LIMIT 1].id;
        NE__Order_Header__c oh = [select id from  NE__Order_Header__c limit 1];
        NE__Order__c ord = [select id from NE__Order__c limit 1];  
        NE__Product__c product = [select id from NE__Product__c limit 1];  
        product.recordTypeId = recordTypeId;
        update product;

        Test.startTest();
        OB_Order_Wrapper orderWrapper = new OB_Order_Wrapper(oh.id);
        orderWrapper.serializeAcquiring(ord.id);
        Test.stopTest();
    }



    @isTest
    public static void calculateActionTest()
    {
        id RecordTypeIdAcquiring = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get('Acquiring').getRecordTypeId();
        id RecordTypeIdPricing   = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get('Pricing').getRecordTypeId();
        id RecordTypeIdVas       = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get('Vas').getRecordTypeId();
        

        NE__Product__c productAcq = new NE__Product__c( Name = 'testProd1',RecordTypeId = RecordTypeIdAcquiring );
        insert productAcq; 
        NE__Product__c productPricing = new NE__Product__c( Name = 'testProd2', RecordTypeId = RecordTypeIdPricing);
        insert productPricing; 
        NE__Product__c productVas = new NE__Product__c( Name = 'testProd2', RecordTypeId = RecordTypeIdVas);
        insert productVas; 

        
         //-----------------------------------------  isSetup  -----------------------------------------------------------------------
        NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_Main_Process__c = 'Setup');
        insert orderHeader;
         NE__Order__c configuration = new NE__Order__c(NE__Order_Header__c=orderHeader.Id);
        insert configuration; 
        NE__OrderItem__c parentOrderItem = new NE__OrderItem__c(NE__Qty__c=1, NE__OrderId__c=configuration.id);
        insert parentOrderItem;
        NE__OrderItem__c oi = new NE__OrderItem__c(  NE__Qty__c = 1,
        NE__OrderId__c = configuration.id,
        NE__ProdId__c  = productAcq.id,
        NE__Parent_Order_Item__c = parentOrderItem.id);
        insert oi;
        NE__Order_Item_Attribute__c oiAttr = new NE__Order_Item_Attribute__c();
        oiAttr.Name              = 'modello';
        oiAttr.NE__Value__c      = 'Nexi';
        oiAttr.NE__Order_Item__c = oi.id;
        insert oiAttr;
        //------------------------------------------ isPricing -----------------------------------------------------------------------
         NE__Order_Header__c orderHeader1 = new NE__Order_Header__c();
        insert orderHeader1;       
        NE__Order__c configuration1 = new NE__Order__c(NE__Order_Header__c=orderHeader1.Id);
        insert configuration1;
        NE__OrderItem__c oi2 = new NE__OrderItem__c(  NE__Qty__c = 1,
        NE__OrderId__c = configuration1.id,
        NE__ProdId__c  = productPricing.id,
        NE__Parent_Order_Item__c = parentOrderItem.id);
        insert oi2;
        //----------------------------------------  isEnablement  -------------------------------------------------------------------

        NE__Order_Header__c orderHeader3 = new NE__Order_Header__c();
        insert orderHeader3;       
        NE__Order__c configuration3 = new NE__Order__c(NE__Order_Header__c=orderHeader3.Id);
        insert configuration3;
        NE__OrderItem__c oi3 = new NE__OrderItem__c(  NE__Qty__c = 1,
        NE__OrderId__c = configuration3.id,
        NE__ProdId__c  = productAcq.id,
        NE__Parent_Order_Item__c = parentOrderItem.id);
        insert oi3;
        //---------------------------------------------------------------------------------------------------------------------------       
                
        NE__OrderItem__c oiTest = [SELECT Id, Name, NE__ProdId__r.Recordtype.DeveloperName , NE__Parent_Order_Item__c, NE__OrderId__r.NE__Order_Header__r.OB_Main_Process__c, NE__Action__c, OB_enablement__c, OB_Old_Enablement__c
                                   FROM NE__OrderItem__c
                                   WHERE Id =: oi.id 
                                   LIMIT 1 ];
        NE__OrderItem__c oiTest2 = [SELECT Id, Name, NE__ProdId__r.Recordtype.DeveloperName , NE__Parent_Order_Item__c, NE__OrderId__r.NE__Order_Header__r.OB_Main_Process__c, NE__Action__c, OB_enablement__c, OB_Old_Enablement__c
                                   FROM NE__OrderItem__c
                                   WHERE Id =: oi2.id 
                                   LIMIT 1 ];    
         NE__OrderItem__c oiTest3 = [SELECT Id, Name, NE__ProdId__r.Recordtype.DeveloperName , NE__Parent_Order_Item__c, NE__OrderId__r.NE__Order_Header__r.OB_Main_Process__c, NE__Action__c, OB_enablement__c, OB_Old_Enablement__c
                                   FROM NE__OrderItem__c
                                   WHERE Id =: oi3.id 
                                   LIMIT 1 ];                                                       

        System.debug('oi :' +oi);
      
        Test.startTest();
        // OB_Order_Wrapper orderWrapper = new OB_Order_Wrapper(orderHeader.id);
        // orderWrapper.calculateAction(oi);
        OB_Order_Wrapper.calculateAction(oiTest);
        OB_Order_Wrapper.calculateAction(oiTest2);
        OB_Order_Wrapper.calculateAction(oiTest3);
        Test.stopTest();
    }


}