/**
*@author Marta Stempień <marta.stempien@accenture.com>
*@date 03/04/2019
*@description Test OB_Activate_Asset_View class
*/
@isTest

public with sharing class OB_Active_Asset_View_Test
{
    /**@author Marta Stempień <marta.stempien@accenture.com>
    *@date 03/04/2019
    *@description Tests getAttributes(String orderItemId) method
    */

    @isTest
    static void getAttributes_Test(){
        Asset newAsset = OB_TestDataFactory.getAsset();
        newAsset.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1].id;
        insert newAsset;

        NE__AssetItemAttribute__c testItemAttribute = OB_TestDataFactory.getAssetItemAttribute(newAsset.Id);
        insert testItemAttribute;

        /*08/05/2019 ENRICO P START */
        String attributesList = OB_Active_Asset_View.getAttributes(newAsset.Id);
        /*08/05/2019 ENRICO P END */
    }

    /**@author Marta Stempień <marta.stempien@accenture.com>
    *@date 03/04/2019
    *@description Tests getAttributesItem(String orderItemId) method
    */

    @isTest
    static void getAttributesItem_Test(){
        NE__Order__c newOrder = OB_TestDataFactory.getOrder();
        insert newOrder;
        NE__OrderItem__c newOrderItem = OB_TestDataFactory.getOrderItem( newOrder.Id);
        insert newOrderItem;

        NE__Order_Item_Attribute__c testOrderItemAttribute = OB_TestDataFactory.getOrderItemAttribute(newOrderItem.Id);
        insert testOrderItemAttribute;

        /*08/05/2019 ENRICO P START */
        String orderItemAttributesList = OB_Active_Asset_View.getAttributesItem(newOrderItem.Id);
        /*08/05/2019 ENRICO P END */
    }

    /**@author Marta Stempień <marta.stempien@accenture.com>
    *@date 03/04/2019
    *@description Tests getAttributesItem(String orderItemId) method
    */

    @isTest
    static void getAttributesAsset_Test(){
        Asset testAsset = OB_TestDataFactory.getAsset();
        testAsset.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1].id;
        insert testAsset;
        NE__AssetItemAttribute__c newAssetItemAttribute = OB_TestDataFactory.getAssetItemAttribute(testAsset.Id);
        newAssetItemAttribute.NE__Asset__c = testAsset.Id;
        insert newAssetItemAttribute;

        List<NE__AssetItemAttribute__c> assetItemAttributesList = OB_Active_Asset_View.getAttributesAsset(testAsset.Id);
        //System.assertEquals(assetItemAttributesList.size(),1);
    }


    //Doris Dongmo - 14/06/2019 - START

    
    /*********************************************************************
    *   @author : Doris Dongmo <doris.tatiana.dongmo@accenture.com>,
    *   @date   : 14/06/2019 
    *   @description Tests getActiveAssets(String servicePointId) method
    **********************************************************************/
    @isTest
    static void getActiveAssets_Test(){
        
        Id recordTypeIdTerminali     = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Terminali').getRecordTypeId();            
        Id recordTypeIdPagobancomat  = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Pagobancomat').getRecordTypeId();            
        Id recordTypeIdAcquiring     = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Acquiring').getRecordTypeId();            
        Id recordTypeIdVAS           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Vas').getRecordTypeId();            

        NE__Service_Point__c sp = OB_TestDataFactory.getServicePoint();	
        insert sp;       
        
        NE__Product__c productTerminali = OB_TestDataFactory.getProduct();	
        productTerminali.RecordTypeId   = recordTypeIdTerminali;
        insert productTerminali;
        NE__Product__c productPagobancomat = OB_TestDataFactory.getProduct();	
        productPagobancomat.RecordTypeId   = recordTypeIdPagobancomat;
        insert productPagobancomat;
        NE__Product__c productAcquiring = OB_TestDataFactory.getProduct();	
        productAcquiring.RecordTypeId   = recordTypeIdAcquiring;
        insert productAcquiring;
        NE__Product__c productAcquiring1 = OB_TestDataFactory.getProduct();	
        productAcquiring1.RecordTypeId   = recordTypeIdAcquiring;
        productAcquiring1.Name           = 'Visa/Mastercard';
        insert productAcquiring1;
        NE__Product__c productVAS = OB_TestDataFactory.getProduct();	
        productVAS.RecordTypeId   = recordTypeIdVAS;
        insert productVAS;

        NE__Order__c newOrder = OB_TestDataFactory.getOrder();
        newOrder.OB_FulfilmentStatus__c = 'Completed';        
        insert newOrder;
        NE__OrderItem__c newOrderItem = OB_TestDataFactory.getOrderItem( newOrder.Id);
        newOrderItem.NE__Service_Point__c = sp.id;
        newOrderItem.OB_FulfilmentStatus__c = 'Cancelled';
        newOrderItem.NE__ProdId__c = productPagobancomat.id;
        insert newOrderItem;

        NE__OrderItem__c newOrderItem1 = OB_TestDataFactory.getOrderItem( newOrder.Id);
        newOrderItem1.NE__Service_Point__c = sp.id;
        newOrderItem1.OB_FulfilmentStatus__c = 'Cancelled';
        newOrderItem1.NE__ProdId__c = productTerminali.id;
        insert newOrderItem1;
      
        List<NE__OrderItem__c> orderItemList = new List<NE__OrderItem__c> ();
        //orderItemList.add(newOrderItem); 
        orderItemList.add(newOrderItem1);      

        Asset asset1 = OB_TestDataFactory.getAsset();	
        asset1.NE__Service_Point__c = sp.id;
        asset1.NE__Status__c = 'Active';
        asset1.NE__ProdId__c = productPagobancomat.id;
        asset1.NE__Order_Config__c = newOrder.id;
        insert asset1;
        Asset asset2 = OB_TestDataFactory.getAsset();	
        asset2.NE__Service_Point__c = sp.id;
        asset2.NE__Status__c = 'Disconnected';
        asset2.NE__ProdId__c = productAcquiring.id;
        insert asset2;
        Asset asset3 = OB_TestDataFactory.getAsset();	
        asset3.NE__Service_Point__c = sp.id;
        asset3.NE__Status__c = 'in progress';
        asset1.NE__ProdId__c = productTerminali.id;
        insert asset3;
        
        List<Asset> assetList = new List<Asset>();
        assetList.add(asset1);
        assetList.add(asset2);
        assetList.add(asset3);
        
        NE__Order_Item_Attribute__c orderItemAttributeList = OB_TestDataFactory.getOrderItemAttribute(newOrderItem.id);
        orderItemAttributeList.Name = 'Codice Sia';
        insert orderItemAttributeList;

        NE__AssetItemAttribute__c listAssetAttributes = OB_TestDataFactory.getAssetItemAttribute(asset1.id);
        listAssetAttributes.Name = 'Codice Sia';
        insert  listAssetAttributes ;        

        String servicePointId   = OB_Active_Asset_View.getActiveAssets(sp.Id);
        Test.startTest();
        String servicePointTest = OB_Active_Asset_View.getActiveAssets(sp.Id);
        Test.stopTest();
        System.assertEquals(servicePointId, servicePointTest);

        
    }

    /*********************************************************************
    *   @author : Doris Dongmo <doris.tatiana.dongmo@accenture.com>,
    *   @date   : 14/06/2019 
    *   @description Tests getOfferId(String servicePointId, String configId ) method
    **********************************************************************/

    @isTest
    static void getOfferId_Test(){
        
        NE__Service_Point__c sp = OB_TestDataFactory.getServicePoint();	
        insert sp;	
        NE__Order__c newOrder = OB_TestDataFactory.getOrder();
        insert newOrder;
        Asset asset1 = OB_TestDataFactory.getAsset();	
        insert asset1;
        Asset asset = OB_TestDataFactory.getAsset();	
        asset.NE__Service_Point__c = sp.id;
        asset.NE__Order_Config__c  = newOrder.id;
        asset.NE__Bundle_Configuration__c = asset1.id;
        asset.NE__Root_Order_Item__c  = asset1.id;
        asset.OB_enablement__c = 'Y';
        insert asset;
        List<Asset> assetList = new  List<Asset>();
        assetList.add(asset);

        String valueToReturn = OB_Active_Asset_View.getOfferId(sp.Id, newOrder.id);
         System.assertEquals(valueToReturn, String.valueOf(asset.NE__Bundle_Configuration__c));
        
    }
    

    /*********************************************************************
    *   @author : Doris Dongmo <doris.tatiana.dongmo@accenture.com>,
    *   @date   : 14/06/2019 
    *   @description Tests getEnablements(String assetId ) method
    **********************************************************************/
    @isTest
    static void getEnablements_Test(){

        Id recordTypeIdAcquiring    = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Acquiring').getRecordTypeId();            
        Id recordTypeIdPagobancomat = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Pagobancomat').getRecordTypeId();            

        String assetId;
        NE__Product__c product = OB_TestDataFactory.getProduct();	
        product.RecordTypeId   = recordTypeIdAcquiring;
        insert product;

        NE__Product__c product1 = OB_TestDataFactory.getProduct();	
        product1.RecordTypeId   = recordTypeIdPagobancomat;
        insert product1;
        
        Asset asset1 = OB_TestDataFactory.getAsset();	
        insert asset1;
        assetId = String.valueOf(asset1.id);
        NE__Order__c order = OB_TestDataFactory.getOrder();	
        insert order;
        NE__OrderItem__c orderItemTest = OB_TestDataFactory.getOrderItem(order.id);
        insert orderItemTest;

        Asset asset = OB_TestDataFactory.getAsset();
        asset.OB_enablement__c = 'Y';
        asset.NE__Bundle_Configuration__c = asset1.id;  
        asset.NE__Root_Order_Item__c   = asset1.id;
        asset.NE__ProdId__c = product.id;	
        insert asset;  
        Asset asset2 = OB_TestDataFactory.getAsset();
        asset2.OB_enablement__c = 'Y';
        asset2.NE__Bundle_Configuration__c = asset1.id;  
        asset2.NE__Root_Order_Item__c   = asset1.id;
        asset2.NE__ProdId__c = product1.id;	
        insert asset2;

        List<Asset> enablementsListAsset = new  List<Asset> ();
        enablementsListAsset.add(asset);
        enablementsListAsset.add(asset2);      
        String valueToReturn    = OB_Active_Asset_View.getEnablements(asset1.Id);
        Test.startTest();
        String resultTest = OB_Active_Asset_View.getEnablements(asset1.Id);
        Test.stopTest();
        System.assertEquals(valueToReturn, resultTest);


               
       
    }

     /*********************************************************************
    *   @author : Doris Dongmo <doris.tatiana.dongmo@accenture.com>,
    *   @date   : 14/06/2019 
    *   @description Tests getTerminalFromAsset(String assetId ) method
    **********************************************************************/
    @isTest
    static void getTerminalFromAsset_Test(){
        
        Asset asset1 = OB_TestDataFactory.getAsset();	
        insert asset1;

        Asset asset = OB_TestDataFactory.getAsset();
        asset.OB_enablement__c = 'Y';
        asset.NE__Bundle_Configuration__c = asset1.id;  
        asset.NE__Root_Order_Item__c   = asset1.id;
        insert asset; 
        List<Asset> enablementsList = new  List<Asset> ();
        enablementsList.add(asset);

        String valueToReturn = OB_Active_Asset_View.getTerminalFromAsset(asset1.Id);
        Test.startTest();
        String resultTest = OB_Active_Asset_View.getTerminalFromAsset(asset1.Id);
        Test.stopTest();
        System.assertEquals(valueToReturn, resultTest);
        
    }


    /*********************************************************************
    *   @author : Doris Dongmo <doris.tatiana.dongmo@accenture.com>,
    *   @date   : 14/06/2019 
    *   @description Tests getAcquiringFromAsset(String assetId ) method
    **********************************************************************/
    @isTest
    static void getAcquiringFromAsset_Test(){
        
        Asset asset = OB_TestDataFactory.getAsset();	
        insert asset;	       

        String valueToReturn = OB_Active_Asset_View.getAcquiringFromAsset(asset.Id);
        Test.startTest();
        String resultTest = OB_Active_Asset_View.getAcquiringFromAsset(asset.Id);
        Test.stopTest();
        System.assertEquals(valueToReturn, resultTest);
        
    }

    /*********************************************************************
    *   @author : Doris Dongmo <doris.tatiana.dongmo@accenture.com>,
    *   @date   : 14/06/2019 
    *   @description Tests search(string jsonWrap) method
    **********************************************************************/
    @isTest
    static void search_Test(){    
        String jsonWrap = '{"AccountName":"STFVLR80A01F205Z","VatNumber":"12345673441","ServicePoint":"","SIACode":"","SiaEstablishment":"","TerminalId":""}';
        String valueToReturn = OB_Active_Asset_View.search(jsonWrap);
        Test.startTest();
        String resultTest = OB_Active_Asset_View.search(jsonWrap);
        Test.stopTest();
        System.assertEquals(valueToReturn, resultTest);
        
        
    }

 
    //Doris Dongmo - 14/06/2019 - END

}