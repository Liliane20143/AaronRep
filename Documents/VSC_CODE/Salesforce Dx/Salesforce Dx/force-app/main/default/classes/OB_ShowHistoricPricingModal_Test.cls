/* 
@author         : simone.misani@accenture.com
@description    : Test OB_ShowHistoricPricingModal class
@date           : 15/04/2019
*/
@isTest
public with sharing class OB_ShowHistoricPricingModal_Test {
    @isTest
    public static void retriveInfoTest() {

        // andrea.morittu --> INSTANCE OF THE MASTER CLASS WRAPPER
        OB_ShowHistoricPricingModal_CC.WrapperOrder wrap1 = new OB_ShowHistoricPricingModal_CC.WrapperOrder();
        wrap1.name = '';
        /*08/05/2019 ENRICO START
        wrap1.startdate=Date.newInstance( 1990, 11, 21 );*/
        wrap1.installationDate = (Date.newInstance(1990, 11, 21)).format(); //DEPLOYCLEAN2v z.urban@accenture.com 12.06.2019 fix date;
        /*08/05/2019 ENRICO END */
        wrap1.variation = '';
        wrap1.name = '';
        wrap1.prodName = '';
        wrap1.termId = '';
        wrap1.Id = '';
        /*monika.kocot 14/04/2019 --> added wrap1.agreed=''; */
        wrap1.agreed = '';

        //Simone.misani 15/04/2019 @start --> INSERTION OF PRODUCT START
        NE__Product__c prod = OB_TestDataFactory.getProduct();
        insert prod;

        NE__Product__c prod1 = OB_TestDataFactory.getProduct();
        insert prod1;
        //INSERTION OF PRODUCT END

        /*ANDREA.MORITTU START 17/04/2019 --> INSERTION OF ORDER HEADER START */
        NE__Order_Header__c ordHead = OB_TestDataFactory.getOrderHeader();
        /*monika.kocot 14/04/2019 --> ordHead.OB_Sub_Process__c ='variazione economica'; */
        ordHead.OB_Sub_Process__c = 'variazione economica';
        insert ordHead;
        //INSERTION OF ORDER HEADER END

        //ANDREA.MORITTU START 17/04/2019 --> INSERTION OF ORDER START
        NE__Order__c order = OB_TestDataFactory.getOrder();
        order.NE__Order_Header__c = ordHead.id;
        /*monika.kocot 14/04/2019 --> order.NE__Type__c = 'ChangeOrder'; */
        order.NE__Type__c = 'ChangeOrder';
        insert order;
        //INSERTION OF ORDER END

        /*monika.kocot START 14/04/2019 --> INSERTION OF ORDER ASSET START */
        Asset asset = OB_TestDataFactory.getAsset();
        asset.NE__ProdId__c = prod.id;
        asset.NE__Order_Config__c = order.id;
        String idAsset = asset.id;
        insert asset;
        List<Asset> assets = new List<Asset>();
        assets.add(asset);
        /*monika.kocot START 14/04/2019 --> INSERTION OF ORDER ASSET END */

        //ANDREA.MORITTU START 17/04/2019 --> INSERTION OF ORDER ITEMS START
        NE__OrderItem__c orderItem1 = OB_TestDataFactory.getOrderItem(order.id);
        orderItem1.NE__ProdId__c = prod.Id;
        /*monika.kocot 14/04/2019 --> added orderItem1.NE__AssetItemEnterpriseId__c =idAsset;  */
        orderItem1.NE__AssetItemEnterpriseId__c = idAsset;

        insert orderItem1;

        NE__OrderItem__c orderItem2 = OB_TestDataFactory.getOrderItem(order.id);
        orderItem2.NE__ProdId__c = prod.Id;
        /*monika.kocot 14/04/2019 --> added orderItem1.NE__AssetItemEnterpriseId__c =idAsset;  */
        orderItem2.NE__AssetItemEnterpriseId__c = idAsset;

        insert orderItem2;
        //INSERTION OF ORDER ITEM END

        List<NE__OrderItem__c> orderItemsList = new List<NE__OrderItem__c>();
        orderItemsList.add(orderItem1);
        orderItemsList.add(orderItem2);
        //ANDREA.MORITTU END 17/04/2019

        OB_ShowHistoricPricingModal_CC.WrapperOrder orderItemWrap = new OB_ShowHistoricPricingModal_CC.WrapperOrder();
        orderItemWrap.name= orderItem1.NE__OrderId__r.name;
        //insert orderItemWrap;

        List<OB_ShowHistoricPricingModal_CC.WrapperOrder> listOrder =new List<OB_ShowHistoricPricingModal_CC.WrapperOrder>();
        listOrder.add(orderItemWrap);
       
		Asset assert = OB_TestDataFactory.getAsset();
		insert assert;
        
        Test.startTest();
        OB_ShowHistoricPricingModal_CC.retriveInfo(prod.id, assert.Id);
        Test.stopTest();

        System.assertEquals(null,listOrder.get(0).id);
        //Simone.misani 15/04/2019 @end --> INSERTION OF PRODUCT START
    }

}