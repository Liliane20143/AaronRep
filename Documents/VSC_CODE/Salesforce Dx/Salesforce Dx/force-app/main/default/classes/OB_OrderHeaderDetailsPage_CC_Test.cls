@isTest
public class OB_OrderHeaderDetailsPage_CC_Test
{
    @isTest
    static void getInfo_apex_test( )
    {
        String orderHeaderId_value;
        Map<String, List<Object>> returnedMap = new Map<String, List<Object>>( );

        List<Account> listAcc   = new List<Account>( );
        List<NE__Order_Header__c> orderHeaderList = new List<NE__Order_Header__c>( );
        List<Contact> cntList = new List<Contact>( );
        Id rtMerchant = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName( ).get( 'Titolare_Effettivo' ).getRecordTypeId( );
        Id accoutRecord = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( ).get( 'Bank' ).getRecordTypeId( );
        Account acc = new Account( Name = 'TEST',
                RecordTypeId = accoutRecord,
                OB_Employees_Number__c = 'Minore di 10',
                OB_VAT_Not_Present__c = true,
                OB_DescriptionVATNotPresent__c = 'description',
                NE__Fiscal_code__c = 'RSSMRA80A01F205X',
                OB_BypassValidation__c = true,
                OB_Status__c = 'Active' );

        listAcc.add( acc );

        insert listAcc;


        NE__Order_Header__c orderHeader = new NE__Order_Header__c( NE__AccountId__c = acc.Id, OB_ProposerABI__c = acc.Id );
        orderHeader.OB_FulfilmentStatus__c = 'Draft';
        insert orderHeader;
        orderHeaderId_value = orderHeader.Id;
        NE__Order__c configuration = new NE__Order__c( NE__Order_Header__c = orderHeader.Id );
        insert configuration;
        orderHeaderList.add( orderHeader );
        NE__OrderItem__c orderItem = New NE__OrderItem__c( NE__Qty__c = 10, NE__OrderId__c = configuration.id );
        insert orderItem;
        List<NE__Order__c> configurations = new List<NE__Order__c>( );
        configurations.add( configuration );

        Contact cnt = new Contact( LastName = 'test',
                RecordTypeId = rtMerchant,
                AccountId = acc.Id,
                OB_Bank__c = orderHeader.OB_ProposerABI__c );

        cntList.add( cnt );

        insert cntList;
        bit2flow__Historic_Wizard_Data__c historicWD = new bit2flow__Historic_Wizard_Data__c( );
        historicWD.bit2flow__Wizard_Id__c = '12344';
        historicWD.bit2flow__Wizard_Label__c = 'abc';
        historicWD.bit2flow__Wizard_Name__c = 'abcd';
        historicWD.OB_OrderHeaderId__c = orderHeader.Id;
        insert historicWD;

        List <bit2flow__Historic_Wizard_Data__c> listOfHistoricWD = new List <bit2flow__Historic_Wizard_Data__c>( );
        listOfHistoricWD.add( historicWD );

        Test.startTest( );
        OB_OrderHeaderDetailsPage_CC.getInfo_apex( orderHeader.Id );
        Test.stopTest( );

    }

    @isTest
    static void getInfo_apex_testCatch( )
    {
        List<NE__Order_Header__c> orderHeaderList = new List<NE__Order_Header__c>( );

        NE__Order_Header__c orderHeader2 = new NE__Order_Header__c( );
        orderHeaderList.add( orderHeader2 );

        Test.startTest( );
        OB_OrderHeaderDetailsPage_CC.getInfo_apex( orderHeader2.Id );
        Test.stopTest( );
    }

    @isTest
    static void getInfoConfigurationItem_apex_test( )
    {
        List<NE__OrderItem__c> terminalList = new List<NE__OrderItem__c>( );
        List<NE__OrderItem__c> acquiringList = new List<NE__OrderItem__c>( );
        NE__Order__c configuration = new NE__Order__c( );
        Id recordTypeChild = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName( ).get( 'Terminali' ).getRecordTypeId( );

        insert configuration;
        NE__Bundle__c bundle = new NE__Bundle__c( Name = 'test',
                NE__Configuration_Type__c = 'Free',
                NE__BaseRecurringCharge__c = 12.00,
                NE__RecurringChargeFrequency__c = 'Annual',
                NE__Start_Date__c = system.now( ),
                NE__End_Date__c = system.now( ).addDays( 1 ) );
        insert bundle;

        NE__OrderItem__c configurationItem = new NE__OrderItem__c( );
        configurationItem.NE__Qty__c = 10;
        configurationItem.NE__OrderId__c = configuration.Id;
        configurationItem.NE__Bundle_Element__c = null;
        configurationItem.NE__Parent_Order_Item__c = null;
        configurationItem.NE__Bundle__c = bundle.Id;
        insert configurationItem;
        List<NE__OrderItem__c> orderItemFathersList = new List<NE__OrderItem__c>( );
        orderItemFathersList.add( configurationItem );

        NE__Product__c product = new NE__Product__c( RecordTypeId = recordTypeChild );
        insert product;
        Id recordTypeChild2 = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName( ).get( 'Acquiring' ).getRecordTypeId( );

        NE__Product__c product2 = new NE__Product__c( RecordTypeId = recordTypeChild2 );
        insert product2;

        NE__OrderItem__c configurationItemChild = new NE__OrderItem__c( );
        configurationItemChild.NE__Qty__c = 10;
        configurationItemChild.NE__OrderId__c = configuration.Id;
        configurationItemChild.NE__ProdId__c = product.Id;
        configurationItemChild.NE__Bundle__c = configurationItem.NE__Bundle__c;
        insert configurationItemChild;

        NE__OrderItem__c configurationItemChild2 = new NE__OrderItem__c( );
        configurationItemChild2.NE__Qty__c = 10;
        configurationItemChild2.NE__OrderId__c = configuration.Id;
        configurationItemChild2.NE__ProdId__c = product2.Id;
        configurationItemChild2.NE__Bundle__c = configurationItem.NE__Bundle__c;
        insert configurationItemChild2;

        List<NE__OrderItem__c> orderItemChildrenList = new List<NE__OrderItem__c>( );
        orderItemChildrenList.add( configurationItemChild );
        orderItemChildrenList.add( configurationItemChild2 );

        Test.startTest( );
        OB_OrderHeaderDetailsPage_CC.getInfoConfigurationItem_apex( configuration.Id );
        Test.stopTest( );
    }

    @isTest
    static void getInfoConfigurationItem_apex_test2( )
    {
        NE__Order__c configuration = new NE__Order__c( );
        Id recordTypeChild = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName( ).get( 'Acquiring' ).getRecordTypeId( );
        insert configuration;

        NE__OrderItem__c configurationItem = new NE__OrderItem__c( );
        configurationItem.NE__Qty__c = 10;
        configurationItem.NE__OrderId__c = configuration.Id;
        insert configurationItem;

        NE__Product__c product = new NE__Product__c( RecordTypeId = recordTypeChild );
        insert product;

        NE__OrderItem__c configurationItemChild = new NE__OrderItem__c( );
        configurationItemChild.NE__Qty__c = 10;
        configurationItemChild.NE__OrderId__c = configuration.Id;
        configurationItemChild.NE__ProdId__c = product.Id;
        insert configurationItemChild;

        Test.startTest( );
        OB_OrderHeaderDetailsPage_CC.getInfoConfigurationItem_apex( configuration.Id );
        Test.stopTest( );
    }

    @isTest
    public static void showCmpDocsTest( )
    {
        NE__Order_Header__c oh = new NE__Order_Header__c( );
        oh.OB_Rejection_Reason__c = 'Documentazione Incompleta';
        insert oh;

        NE__Order__c ord = new NE__Order__c( );
        ord.NE__Order_Header__c = oh.id;
        insert ord;

        String ordId = ord.id;

        Test.startTest( );
        OB_OrderHeaderDetailsPage_CC.showCmpDocs( oh.id );
        delete ord;
        OB_OrderHeaderDetailsPage_CC.showCmpDocs( oh.id );
        Test.stopTest( );
    }

    @isTest
    public static void checkRejectReasonTest( )
    {
        NE__Order_Header__c oh = new NE__Order_Header__c( );
        oh.OB_Rejection_Reason__c = 'Documentazione Incompleta';
        insert oh;

        String ohId = oh.id;

        Test.startTest( );
        OB_OrderHeaderDetailsPage_CC.checkRejectReason( ohId );
        delete oh;
        OB_OrderHeaderDetailsPage_CC.checkRejectReason( ohId );
        Test.stopTest( );
    }

    @isTest
    public static void callCancelOrderTest( )
    {
        NE__Order_Header__c oh = new NE__Order_Header__c( );
        oh.OB_Rejection_Reason__c = 'Documentazione Incompleta';
        insert oh;

        NE__Order__c ord = new NE__Order__c( );
        ord.NE__Order_Header__c = oh.id;
        insert ord;

        NE__OrderItem__c oi = new NE__OrderItem__c( );
        oi.NE__OrderId__c = ord.id;
        oi.NE__Qty__c = 1;
        insert oi;

        Test.startTest( );
        OB_OrderHeaderDetailsPage_CC.callCancelOrder( null );
        OB_OrderHeaderDetailsPage_CC.callCancelOrder( ord.id );
        delete oi;
        OB_OrderHeaderDetailsPage_CC.callCancelOrder( ord.id );
        Test.stopTest( );
    }

    /*******************************************************************************
   Purpose:  Method tests setting fields (status and timestamp) of NE__Order__c - 'Draft - Incomplete Order'
             - success scenario

   History
   --------
   VERSION     AUTHOR                  DATE            DETAIL          Description
   1.0         Joanna Mielczarek       07/05/2019      Created         NEXI-20_order_status_handleLogic
    ********************************************************************************/
    @isTest static void setOrderStatusDraftIncompleteOrderSuccess( )
    {
        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        insert testOrderHeader;

        NE__Order__c testOrder = OB_TestDataFactory.getOrder( testOrderHeader );
        insert testOrder;

        OB_OrderHeaderDetailsPage_CC.setOrderStatusDraftIncompleteOrder( testOrderHeader.Id );

        List<NE__Order__c> testOrders =
        [
                SELECT Id
                FROM NE__Order__c
                WHERE OB_Nexi_OrderStatus__c = :OB_Order_ChangeStatus.ORDER_STATUS_DRAFT_INCOMPLETE_ORDER
        ];
        System.assertEquals( 1, testOrders.size( ) );
    }

    /*******************************************************************************
	Purpose:  Method tests setting fields (status and timestamp) of NE__Order__c - 'Draft - Incomplete Order'
	          - failed scenario - invalid data

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Joanna Mielczarek       07/05/2019      Created         NEXI-20_order_status_handleLogic
 	********************************************************************************/
    @isTest static void setOrderStatusDraftIncompleteOrderFailed( )
    {
        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        insert testOrderHeader;

        OB_OrderHeaderDetailsPage_CC.setOrderStatusDraftIncompleteOrder( testOrderHeader.Id );

        List<NE__Order__c> testOrders =
        [
                SELECT Id
                FROM NE__Order__c
                WHERE OB_Nexi_OrderStatus__c = :OB_Order_ChangeStatus.ORDER_STATUS_DRAFT_INCOMPLETE_ORDER
        ];
        System.assertEquals( 0, testOrders.size( ) );
    }
    /*******************************************************************************
	Purpose:  Method tests checkValidityFlow test - OB_CheckResumeFlow__c blank scenario

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Giovanni spinelli     23/08/2019      Created        
 	********************************************************************************/
    @isTest static void checkValidityFlowTest( )
    {
        NE__Order_Header__c ohOrderHeader = OB_TestDataFactory.getOrderHeader();
        insert ohOrderHeader;
        NE__Order__c order = OB_TestDataFactory.getOrder( ohOrderHeader );
        insert order;
        Test.startTest( );
        OB_OrderHeaderDetailsPage_CC.checkValidityFlow( order.Id );
        Test.stopTest( );
    }
    /*******************************************************************************
	Purpose:  Method tests checkValidityFlow test - OB_CheckResumeFlow__c not blank scenario

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Giovanni spinelli     23/08/2019      Created        
 	********************************************************************************/
    @isTest static void checkValidityFlowTest2( )
    {
        NE__Order_Header__c ohOrderHeader = OB_TestDataFactory.getOrderHeader();
        insert ohOrderHeader;
        NE__Order__c order = OB_TestDataFactory.getOrder( ohOrderHeader );
        order.OB_CheckResumeFlow__c='test_23/08/2019 11.09';
        insert order;
        Test.startTest( );
        OB_OrderHeaderDetailsPage_CC.checkValidityFlow( order.Id );
        Test.stopTest( );
    }
    /*******************************************************************************
	Purpose:  Method tests checkValidityFlow test - OB_CheckResumeFlow__c not blank scenario 2

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Giovanni spinelli     23/08/2019      Created        
 	********************************************************************************/
    @isTest static void checkValidityFlowTest3( )
    {
        NE__Order_Header__c ohOrderHeader = OB_TestDataFactory.getOrderHeader();
        insert ohOrderHeader;
        NE__Order__c order = OB_TestDataFactory.getOrder( ohOrderHeader );
        order.OB_CheckResumeFlow__c='test_23/08/2019 20.09';
        insert order;
        Test.startTest( );
        OB_OrderHeaderDetailsPage_CC.checkValidityFlow( order.Id );
        Test.stopTest( );
    }
    /*******************************************************************************
	Purpose:  Method tests retrievePriceHistory method 

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Giovanni spinelli     09/09/2019      Created        
 	********************************************************************************/
     @isTest static void retrievePriceHistory_Test( )
    {
        Id rtPricing 			= Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get( OB_UtilityConstants.RTPRICINGPRODUCT ).getRecordTypeId();
        NE__Order_Header__c ohOrderHeader = OB_TestDataFactory.getOrderHeader();
        insert ohOrderHeader;

        NE__Order__c order = OB_TestDataFactory.getOrder( ohOrderHeader );
        order.OB_ABI__c ='03138';
        
        insert order;
        
        NE__OrderItem__c orderItem = OB_TestDataFactory.getOrderItem( order.Id );
        insert orderItem;

        NE__Product__c product = OB_TestDataFactory.getProduct();
        product.name = 'Pos Tradizionale Smart';
        product.RecordTypeId = rtPricing;
        insert product;
        

        NE__OrderItem__c orderItemRoot = OB_TestDataFactory.getOrderItem( order.Id );
        orderItemRoot.NE__ProdId__c = product.Id;
        insert orderItemRoot;

        orderItem.NE__Root_Order_Item__c = orderItemRoot.Id;
        orderItem.NE__OrderId__c = order.Id;
        orderItem.NE__ProdId__c = product.id;
        update orderItem;
        
        NE__Order_Item_Attribute__c itemAttribute = OB_TestDataFactory.getOrderItemAttribute( orderItem.Id );
        itemAttribute.OB_Attribute_Code__c='IMPORTO';
        itemAttribute.NE__FamPropExtId__c ='ImportoEGratuita:Importo';
        insert itemAttribute;
        
        //insert mpr
        NE__Catalog__c catalogo = new NE__Catalog__c(Name='Catalogo_Nexi');
        insert catalogo;  

        NE__Bundle__c bundle  = new NE__Bundle__c(Name='Offerta Personalizzata', NE__BaseRecurringCharge__c=1, NE__RecurringChargeFrequency__c='Annual', NE__Catalog__c=catalogo.Id, NE__Start_Date__c=System.now().addDays(-1), NE__End_Date__c=System.now().addDays(1), NE__Active__c = true);
        insert bundle;
        

        NE__Catalog_Item__c parentCatalogItem = OB_TestDataFactory.getCatalogItem(catalogo.Id , product.Id);
        parentCatalogItem.NE__Catalog_Id__c = catalogo.Id;
        parentCatalogItem.NE__ProductId__c            = product.Id;
        insert parentCatalogItem;

        NE__Catalog_Item__c catalogItem = OB_TestDataFactory.getCatalogItem( catalogo.Id , product.Id );
        catalogItem.NE__Catalog_Id__c           = catalogo.Id;
        catalogItem.NE__Parent_Catalog_Item__c  = parentCatalogItem.id;
        catalogItem.NE__ProductId__c            = product.Id;
        insert catalogItem;
        

        NE__Matrix_Parameter__c mp = OB_TestDataFactory.getMatrixParameter();
        mp.OB_Componente__c = catalogItem.Id;
        mp.OB_Offerta__c    = bundle.Id;
        insert mp;
        

        NE__Matrix_Parameter_Row__c mpr = OB_TestDataFactory.getMatrixParameterRow( mp.Id );
        mpr.OB_Codici__c        =   'IMPORTO';
        mpr.OB_ABI_BANCA__c     =   order.OB_ABI__c;
        mpr.OB_Componente__c    =   catalogItem.Id;
        mpr.recordTypeId        =   Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByDeveloperName().get( OB_UtilityConstants.RTPRICEBANKABI ).getRecordTypeId();
        insert mpr;

        Test.startTest( );
        String toReturn = OB_OrderHeaderDetailsPage_CC.retrievePriceHistory(order.Id,'Pos Tradizionale Smart','Offerta Personalizzata',product.Id);
        String expetedReturn ='{"Pos Tradizionale Smart":[{"previousValue":null,"newValue":null,"name":"Importo","id":'+'"'+itemAttribute.Id+'"'+',"defaultValue":null,"attributeCode":"IMPORTO"}]}';
        System.assertEquals( expetedReturn , toReturn);
        Test.stopTest( );
    }
    /*******************************************************************************
	Purpose:  Test method for setOrderStatusDraft

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         gianluigi.virga         20/09/2019      Created        
 	********************************************************************************/
    @isTest static void setOrderStatusDraft_Test( )
    {
        NE__Order_Header__c ohOrderHeader = OB_TestDataFactory.getOrderHeader();
        insert ohOrderHeader;

        NE__Order__c order = OB_TestDataFactory.getOrder( ohOrderHeader );
        order.OB_ABI__c ='03138';
        insert order;

        String status = System.Label.OB_OrderStatusDraft; 
        Test.startTest( );
        OB_OrderHeaderDetailsPage_CC.setOrderStatusDraft( order.Id );

        List<NE__Order__c> testOrders =
        [
                SELECT Id
                FROM NE__Order__c
                WHERE OB_Nexi_OrderStatus__c =: status
        ];
        System.assertNotEquals( 0, testOrders.size( ) );
        Test.stopTest( );
    }
    /*******************************************************************************
	Purpose:  Test method for changeOrderStatusServer

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         gianluigi.virga         20/09/2019      Created        
 	********************************************************************************/
    @isTest static void changeOrderStatusServer_Test( )
    {
        String userId = UserInfo.getUserId();

        NE__Order_Header__c ohOrderHeader = OB_TestDataFactory.getOrderHeader();
        insert ohOrderHeader;

        NE__Order__c order = OB_TestDataFactory.getOrder( ohOrderHeader );
        order.OB_ABI__c ='03138';
        insert order;

        String status = System.Label.OB_OrderStatusDraft; 

        Test.startTest( );
        Boolean trueOrFalse = OB_OrderHeaderDetailsPage_CC.changeOrderStatusServer( order.Id, userId );

        List<NE__Order__c> testOrders =
        [
                SELECT Id
                FROM NE__Order__c
                WHERE OB_Bank_OrderStatus__c =: status
        ];
        System.assertNotEquals( 0, testOrders.size( ) );
        Test.stopTest( );
    }
    /*******************************************************************************
	Purpose:  Test method for changeOrderStatusServer

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         gianluigi.virga         20/09/2019      Created        
 	********************************************************************************/
    @isTest static void changeJumpToStepHistoricAttachment_Test( )
    {
        String userId = UserInfo.getUserId();

        NE__Order_Header__c ohOrderHeader = OB_TestDataFactory.getOrderHeader();
        insert ohOrderHeader;

        NE__Order__c order = OB_TestDataFactory.getOrder( ohOrderHeader );
        order.OB_ABI__c ='03138';
        insert order;

        bit2flow__Historic_Wizard_Data__c historicWD = new bit2flow__Historic_Wizard_Data__c( );
        historicWD.bit2flow__Wizard_Id__c = '12344';
        historicWD.bit2flow__Wizard_Label__c = 'abc';
        historicWD.bit2flow__Wizard_Name__c = 'abcd';
        historicWD.OB_OrderHeaderId__c = ohOrderHeader.Id;
        insert historicWD;

        Test.startTest( );
        Id wizId = OB_OrderHeaderDetailsPage_CC.changeJumpToStepHistoricAttachment( historicWD.Id );
        System.assertEquals(null, wizId );
        Test.stopTest( );
    }

    /*******************************************************************************
	Purpose:  Test method for retrieveHistoricWizardData

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         gianluigi.virga         20/09/2019      Created        
 	********************************************************************************/
    @isTest static void retrieveHistoricWizardData_Test( )
    {
        NE__Order_Header__c ohOrderHeader = OB_TestDataFactory.getOrderHeader();
        insert ohOrderHeader;

        NE__Order__c order = OB_TestDataFactory.getOrder( ohOrderHeader );
        order.OB_ABI__c ='03138';
        insert order;

        List<NE__Order__c> orders = new List<NE__Order__c>();
        orders.add(order);

        Test.startTest( );
        Map<String,String> mapOrderWizard = OB_OrderHeaderDetailsPage_CC.retrieveHistoricWizardData( orders );
        System.assertNotEquals( null, mapOrderWizard );
        Test.stopTest( );
    }


}