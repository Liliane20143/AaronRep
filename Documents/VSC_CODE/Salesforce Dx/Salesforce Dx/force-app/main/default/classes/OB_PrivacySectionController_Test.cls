/*
    *   Author      :   Morittu Andrea  
    *   Date        :   23-Aug-2019
    *   Description :   Test class for OB_PrivacySectionController
*/
@isTest
public class OB_PrivacySectionController_Test {

    /*
        *   Author      :   Morittu Andrea  
        *   Date        :   23-Aug-2019
        *   Description :   Test class for OB_PrivacySectionController.retrievePrivacyFieldName()
    */
    @isTest
    public static void retrievePrivacyFieldName_Test() {
		Test.startTest();
        	OB_PrivacySectionController.retrievePrivacyFieldName();
        Test.stopTest();
    }

    /*
        *   Author      :   Morittu Andrea  
        *   Date        :   23-Aug-2019
        *   Description :   Test class for OB_PrivacySectionController.pagoBancomatArePresent()
    */
    @isTest
    public static void pagoBancomatArePresent_Test() {
        // INCOMING PARAMETER
        String orderId;
        
        //ORDER HEADER
        NE__Order_Header__c orderHeader = OB_TestDataFactory.getOrderHeader();
        insert orderHeader;

        //PRODUCT
        Id RecordTypeIdRow = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get(OB_UtilityConstants.ACQUIRING).getRecordTypeId();
        NE__Product__c product = OB_TestDataFactory.getProduct();
        product.RecordTypeId = RecordTypeIdRow;
        insert product;

        // ORDER
        NE__Order__c order = OB_TestDataFactory.getOrder(orderHeader);
        insert order;
        //ITEM
        List<NE__OrderItem__c> orderItemList = new List<NE__OrderItem__c>();
        for(Integer i = 10; i<10; i++) {
            NE__OrderItem__c orderItem = OB_TestDataFactory.getOrderItem(order.Id);
			orderItem.NE__ProdId__c = product.Id;
            orderItemList.add(orderItem);
        }
        insert orderItemList;

        Test.startTest();
            OB_PrivacySectionController.pagoBancomatArePresent(order.Id);
        Test.stopTest();

    }

    //START gianluigi.virga 20/09/2019
    @isTest
    public static void retrievePrivacyServicePoint_Test() {
        NE__Service_Point__c sp = new NE__Service_Point__c();
        sp.OB_Privacy_C3__c = true;
        insert sp;
        List<String> checkSizeMap = new List<String>();
        Test.startTest();
        Map<String,Boolean> spPrivacy = OB_PrivacySectionController.retrievePrivacyServicePoint(sp.Id);
        String checkValue = String.valueOf(spPrivacy.get('OB_Privacy_C3__c'));
        System.assertEquals(true, !String.isEmpty(checkValue));
        Test.stopTest();
    }
    //END gianluigi.virga 20/09/2019
    
}