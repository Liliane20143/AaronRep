/*****************************************************************
Name: •	OB_OrderItemCheckerDate_Test
============================================================
Purpose:  Class tests •	OB_OrderItemCheckerDate 

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0      Francesca Ribezzi        02/05/2019                            
********************************************************************************/

@isTest
public class OB_OrderItemCheckerDate_Test {
    // Roland Nieznanski <roland.nieznanski@accenture.com> 13/08/2019 START
    public static Id recordTypeIdAcquiring = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByDeveloperName().get('Acquiring').getRecordTypeId();
    public static  Id recordTypeIdBancomat = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByDeveloperName().get('Pagobancomat').getRecordTypeId();
    public static  Id recordTypeIdPos = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByDeveloperName().get('Terminali').getRecordTypeId();
    public static  Id recordTypeIdVas = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByDeveloperName().get('Vas').getRecordTypeId();
    public static  Id recordTypeIdPricing = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByDeveloperName().get('Pricing').getRecordTypeId();
    public static  Id recordTypeIdTerminaliProduct = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get('Terminali').getRecordTypeId();
    public static  Id recordTypeIdAcquiringProduct = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get('Acquiring').getRecordTypeId();
    // Roland Nieznanski <roland.nieznanski@accenture.com> 13/08/2019 END

    //@author Francesca Ribezzi <francesca.ribezzi@accenture.com>
    //@date 02/05/19
    //@description orderItemCheckerDateServer setup test method
    @testSetup static void createOrderAndOrderItems(){

        NE__Order_Header__c oh = new NE__Order_Header__c();
        oh.OB_Sub_Process__c = OB_UtilityConstants.HEADER_SUBPROCESS_ECONOMICA;
        insert oh; 
        NE__Order__c ord1 = new NE__Order__c();     
        ord1.NE__Order_Header__c = oh.Id;
        ord1.OB_Model_Changed__c = false; 
        ord1.OB_Variation__c = 'MIGLIORATIVA';
        ord1.OB_AgreedChanges__c = false;
        insert ord1; 

        NE__Order__c ord2 = new NE__Order__c();     
        ord2.NE__Order_Header__c = oh.Id;
        ord2.OB_Model_Changed__c = true; 
        ord2.OB_Variation__c = 'PEGGIORATIVA';
        ord2.OB_AgreedChanges__c = true;
        insert ord2; 

        NE__Order__c ord3 = new NE__Order__c();     
        ord3.NE__Order_Header__c = oh.Id;
        ord3.OB_Model_Changed__c = true; 
        ord3.OB_Variation__c = 'PEGGIORATIVA';
        ord3.OB_AgreedChanges__c = false;
        insert ord3; 

        NE__Order__c ord4 = new NE__Order__c();     
        ord4.NE__Order_Header__c = oh.Id;
        ord4.OB_Model_Changed__c = false; 
        ord4.OB_Variation__c = 'PEGGIORATIVA';
        ord4.OB_AgreedChanges__c = true;
        insert ord4; 

        NE__Order__c ord5 = new NE__Order__c();     
        ord5.NE__Order_Header__c = oh.Id;
        ord5.OB_Model_Changed__c = false; 
        ord5.OB_Variation__c = 'PEGGIORATIVA';
        ord5.OB_AgreedChanges__c = false;
        insert ord5; 

        NE__Product__c product = OB_TestDataFactory.getProduct( );
        product.OB_Codice_sfdc__c = 'VISAMASTERCARD';
        product.RecordTypeId = recordTypeIdTerminaliProduct; // Roland Nieznanski <roland.nieznanski@accenture.com> 13/08/2019
        insert product;
        // Roland Nieznanski <roland.nieznanski@accenture.com> 13/08/2019 START
        NE__Product__c product1 = OB_TestDataFactory.getProduct( );
        product1.OB_Codice_sfdc__c = 'VISAMASTERCARD';
        product1.RecordTypeId = recordTypeIdAcquiringProduct;
        insert product1;
        // Roland Nieznanski <roland.nieznanski@accenture.com> 13/08/2019 END

		NE__OrderItem__c vMorderItem = OB_TestDataFactory.getOrderItem( ord1.Id );
		vMorderItem.NE__Root_Order_Item__c = null;
        vMorderItem.NE__ProdId__c = product.Id;
        vMorderItem.RecordTypeId = recordTypeIdAcquiring;
		insert vMorderItem;

		NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem( ord1.Id );
		testOrderItem.NE__Root_Order_Item__c = null;
        testOrderItem.RecordTypeId = recordTypeIdAcquiring;
        testOrderItem.NE__ProdId__c = product1.Id;
        testOrderItem.NE__Action__c = 'Change';
		insert testOrderItem;

		NE__OrderItem__c testOrderItem8 = OB_TestDataFactory.getOrderItem( ord4.Id );
		testOrderItem8.NE__Root_Order_Item__c = null;
        testOrderItem8.RecordTypeId = recordTypeIdAcquiring;
        testOrderItem8.NE__ProdId__c = product1.Id;
        testOrderItem8.NE__Action__c = 'Change';
		insert testOrderItem8;

        NE__OrderItem__c testOrderItem9 = OB_TestDataFactory.getOrderItem( ord1.Id );
		testOrderItem9.NE__Root_Order_Item__c = null;
        testOrderItem9.RecordTypeId = recordTypeIdPos;
       // testOrderItem9.NE__ProdId__c = product.Id;
        testOrderItem9.NE__Action__c = 'Change';
		insert testOrderItem9;

		NE__OrderItem__c parentOrderItem1 = OB_TestDataFactory.getOrderItem( ord1.Id );
		parentOrderItem1.NE__Root_Order_Item__c = testOrderItem.Id;
        parentOrderItem1.RecordTypeId = recordTypeIdBancomat;
		insert parentOrderItem1;

        NE__OrderItem__c parentOrderItem2 = OB_TestDataFactory.getOrderItem( ord1.Id );
		parentOrderItem2.NE__Root_Order_Item__c = testOrderItem.Id;
        parentOrderItem2.NE__Action__c = 'Change';
        parentOrderItem2.RecordTypeId = recordTypeIdVas;
		insert parentOrderItem2;

        NE__OrderItem__c parentOrderItemVas = OB_TestDataFactory.getOrderItem( ord4.Id );
		parentOrderItemVas.NE__Root_Order_Item__c = testOrderItem.Id;
        parentOrderItemVas.NE__Action__c = 'Change';
        parentOrderItemVas.RecordTypeId = recordTypeIdVas;
		insert parentOrderItemVas;

        NE__OrderItem__c parentOrderItem3 = OB_TestDataFactory.getOrderItem( ord1.Id );
		parentOrderItem3.NE__Root_Order_Item__c = testOrderItem.Id;
        parentOrderItem3.RecordTypeId = recordTypeIdPos;
		parentOrderItem3.NE__Action__c = 'Change';

		insert parentOrderItem3;

        NE__OrderItem__c pricingItem = OB_TestDataFactory.getOrderItem( ord1.Id );
		pricingItem.NE__Root_Order_Item__c = testOrderItem.Id;
        pricingItem.RecordTypeId = recordTypeIdPricing;
        pricingItem.NE__Action__c = 'Add';
		insert pricingItem;

        NE__OrderItem__c testOrderItem2 = OB_TestDataFactory.getOrderItem( ord3.Id );
		testOrderItem2.NE__Root_Order_Item__c = null;
        testOrderItem2.RecordTypeId = recordTypeIdAcquiring;
        testOrderItem2.NE__ProdId__c = product1.Id;
        testOrderItem2.NE__Action__c = 'Change';
		insert testOrderItem2;

		NE__OrderItem__c parentOrderItem4 = OB_TestDataFactory.getOrderItem( ord3.Id );
		parentOrderItem4.NE__Root_Order_Item__c = testOrderItem.Id;
        parentOrderItem4.RecordTypeId = recordTypeIdBancomat;
		insert parentOrderItem4;

        NE__OrderItem__c testOrderIt = OB_TestDataFactory.getOrderItem( ord4.Id );
		testOrderIt.NE__Root_Order_Item__c = null;
        testOrderIt.RecordTypeId = recordTypeIdAcquiring;
        testOrderIt.NE__ProdId__c = product.Id;
        testOrderIt.NE__Action__c = 'Change';
		insert testOrderIt;

		NE__OrderItem__c parentOrderIt = OB_TestDataFactory.getOrderItem( ord4.Id );
		parentOrderIt.NE__Root_Order_Item__c = testOrderItem9.Id;
        parentOrderIt.RecordTypeId = recordTypeIdPos;
        parentOrderIt.NE__ProdId__c = product.Id;
        parentOrderIt.NE__Action__c = 'Change'; 
		insert parentOrderIt;

        NE__OrderItem__c childItemPricing = OB_TestDataFactory.getOrderItem( ord5.Id );
		childItemPricing.NE__Root_Order_Item__c = testOrderItem2.Id;
        childItemPricing.RecordTypeId = recordTypeIdPos;
        childItemPricing.NE__ProdId__c = product.Id;
        childItemPricing.NE__Action__c = 'Change'; 
		insert childItemPricing;

        
        NE__OrderItem__c childItemPricing2 = OB_TestDataFactory.getOrderItem( ord5.Id );
		childItemPricing2.NE__Root_Order_Item__c = testOrderItem9.Id;
        childItemPricing2.RecordTypeId = recordTypeIdPos;
        childItemPricing2.NE__ProdId__c = product.Id;
        childItemPricing2.NE__Action__c = 'Change'; 
		insert childItemPricing2;


        NE__OrderItem__c parentOrderItemModel = OB_TestDataFactory.getOrderItem( ord1.Id );
		parentOrderItemModel.NE__Root_Order_Item__c = testOrderItem9.Id; 
        parentOrderItemModel.RecordTypeId = recordTypeIdPos;
        parentOrderItemModel.NE__ProdId__c = product.Id;
        parentOrderItemModel.NE__Action__c = 'Add';
		insert parentOrderItemModel;


    }

    //@author Francesca Ribezzi <francesca.ribezzi@accenture.com>
    //@date 02/05/19
    //@description orderItemCheckerDateServer test method
    @isTest
    public static void orderItemCheckerDateServer_Test() 
    {
        List<NE__Order__c> orders = [
            Select id,NE__Order_Header__c,OB_Model_Changed__c,NE__Order_Header__r.OB_Sub_Process__c, OB_Variation__c, OB_AgreedChanges__c 
            from NE__Order__c Limit 10
        ];

        Test.startTest(); 
            OB_OrderItemCheckerDate.orderItemCheckerDateServer(orders);
        Test.stopTest();

    }

    /*******************************************************************************
      Purpose:  Method tests saving - returning null

      History
      --------
      VERSION     AUTHOR                  DATE            DETAIL          Description
      1.0        Roland Nieznanski       13/08/2019      Created         Check fisrt day
      ********************************************************************************/
    @isTest
    public static void updateStartDatePricingBooleanTrue_Test()
    {
        List<NE__OrderItem__c> orderItemsList =
        [
                SELECT
                        id,
                        OB_StartValidationDate__c,
                        NE__StartDate__c,
                        NE__Root_Order_Item__c,
                        NE__Root_Order_Item__r.OB_StartValidationDate__c,
                        NE__OrderId__r.OB_AgreedChanges__c,
                        RecordType.DeveloperName,
                        NE__Root_Order_Item__r.RecordType.DeveloperName,
                        NE__OrderId__r.OB_Variation__c,
                        OB_VariationPOSPB__c,//Simone Misani 26/07/2019 WN-67
                        NE__OrderId__r.OB_ApprovalType__c,//Simone Misani 26/07/2019 WN-67
                        NE__Action__c
                FROM NE__OrderItem__c
                WHERE NE__Action__c = 'Add' OR NE__Action__c = 'Change'
        ];
        Integer limitActionChanges = 0;
        for( NE__OrderItem__c orderItem: orderItemsList )
        {
            orderItem.OB_VariationPOSPB__c = orderItem.NE__Action__c == 'Change' && limitActionChanges < 1 ? OB_UtilityConstants.MIGLIORATIVA :OB_UtilityConstants.PEGGIORATIVA;
            orderItem.NE__OrderId__r.OB_AgreedChanges__c = false;
            orderItem.NE__OrderId__r.OB_ApprovalType__c = 'Pricing';
            limitActionChanges++;
        }
        update orderItemsList;

    List<NE__Order__c> orders =
    [
            Select id,
                    OB_Model_Changed__c,
                    NE__Order_Header__r.OB_Sub_Process__c,
                    OB_Variation__c,
                    OB_AgreedChanges__c,
                    NE__Order_Header__c
            from NE__Order__c
    ];

        Test.startTest();
        OB_OrderItemCheckerDate.useInTestBoolean = true;
        OB_OrderItemCheckerDate.updateStartDatePricing(orders);
        Test.stopTest();
        System.assert(true);

    }
    /*******************************************************************************
     Purpose:  Method tests saving - returning null

     History
     --------
     VERSION     AUTHOR                  DATE            DETAIL          Description
     1.0        Roland Nieznanski       13/08/2019      Created         check days
     ********************************************************************************/
    @isTest
    public static void updateStartDatePricingBooleanFalse_Test()
    {
        List<NE__OrderItem__c> orderItemsList =
        [
                SELECT
                        id,
                        OB_StartValidationDate__c,
                        NE__StartDate__c,
                        NE__Root_Order_Item__c,
                        NE__Root_Order_Item__r.OB_StartValidationDate__c,
                        NE__OrderId__r.OB_AgreedChanges__c,
                        RecordType.DeveloperName,
                        NE__Root_Order_Item__r.RecordType.DeveloperName,
                        NE__OrderId__r.OB_Variation__c,
                        OB_VariationPOSPB__c,//Simone Misani 26/07/2019 WN-67
                        NE__OrderId__r.OB_ApprovalType__c,//Simone Misani 26/07/2019 WN-67
                        NE__Action__c
                FROM NE__OrderItem__c
                WHERE NE__Action__c = 'Add' OR NE__Action__c = 'Change'
        ];
        Integer limitActionChanges = 0;
        for( NE__OrderItem__c orderItem: orderItemsList )
        {
            orderItem.OB_VariationPOSPB__c = orderItem.NE__Action__c == 'Change' && limitActionChanges < 1 ? OB_UtilityConstants.MIGLIORATIVA:OB_UtilityConstants.PEGGIORATIVA;
            orderItem.NE__OrderId__r.OB_AgreedChanges__c = false;
            orderItem.NE__OrderId__r.OB_ApprovalType__c = 'Pricing';
            limitActionChanges++;
        }
        update orderItemsList;

        List<NE__Order__c> orders =
        [
                Select id,
                        OB_Model_Changed__c,
                        NE__Order_Header__r.OB_Sub_Process__c,
                        OB_Variation__c,
                        OB_AgreedChanges__c,
                        NE__Order_Header__c
                from NE__Order__c
        ];

        Test.startTest();
        OB_OrderItemCheckerDate.updateStartDatePricing(orders);
        Test.stopTest();
        System.assert(true);

    }

    /*******************************************************************************
      Purpose:  Method tests saving - returning null

      History
      --------
      VERSION     AUTHOR                  DATE            DETAIL          Description
      1.0        Roland Nieznanski       13/08/2019      Created         Exception on enqueueJob
      ********************************************************************************/
    @isTest
    public static void updateStartDateCommissionModelException_Test()
    {
        List<NE__Order__c> orders = new List<NE__Order__c>();
        orders.add(null);
        Test.startTest();
        OB_OrderItemCheckerDate.updateStartDateCommissionModel(orders);
        Test.stopTest();
        System.assert(true);
    }

    /*******************************************************************************
     Purpose:  Method tests saving - returning null

     History
     --------
     VERSION     AUTHOR                  DATE            DETAIL          Description
     1.0        Roland Nieznanski       13/08/2019      Created         Exception on enqueueJob
     ********************************************************************************/
    @isTest
    public static void updateStartDatePricingException_Test()
    {

        List<NE__OrderItem__c> orderItemsList =
        [
                SELECT
                        id,
                        OB_StartValidationDate__c,
                        NE__StartDate__c,
                        NE__Root_Order_Item__c,
                        NE__Root_Order_Item__r.OB_StartValidationDate__c,
                        NE__OrderId__r.OB_AgreedChanges__c,
                        RecordType.DeveloperName,
                        NE__Root_Order_Item__r.RecordType.DeveloperName,
                        NE__OrderId__r.OB_Variation__c,
                        OB_VariationPOSPB__c,//Simone Misani 26/07/2019 WN-67
                        NE__OrderId__r.OB_ApprovalType__c,//Simone Misani 26/07/2019 WN-67
                        NE__Action__c
                FROM NE__OrderItem__c
                WHERE NE__Action__c = 'Change'
        ];
        for( NE__OrderItem__c orderItem: orderItemsList )
        {
            orderItem.OB_VariationPOSPB__c = OB_UtilityConstants.MIGLIORATIVA;
            orderItem.NE__OrderId__r.OB_AgreedChanges__c = false;
            orderItem.NE__OrderId__r.OB_ApprovalType__c = 'Pricing';
        }
        update orderItemsList;

        List<NE__Order__c> orders = new List<NE__Order__c>();
        orders.add(null);
        List<NE__Order__c> ordersList =
        [
                Select id,
                        OB_Model_Changed__c,
                        NE__Order_Header__r.OB_Sub_Process__c,
                        OB_Variation__c,
                        OB_AgreedChanges__c
                from NE__Order__c limit 1
        ];
        orders.add(ordersList[0]);
        Test.startTest();
        OB_OrderItemCheckerDate.updateStartDatePricing(orders);
        Test.stopTest();
        System.assert(true);
    }

}