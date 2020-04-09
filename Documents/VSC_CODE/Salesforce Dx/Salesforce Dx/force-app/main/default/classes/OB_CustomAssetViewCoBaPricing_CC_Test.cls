@isTest
public class OB_CustomAssetViewCoBaPricing_CC_Test {

     /**
    *@author simone misani <simone.misani@accenture.com
    *@date 11/06/2019
    *@description Method returns String of order items without asset  with  product =Terminali
    *@params -
    *@return String of OrderItems
    */
    @isTest
     public static void getAssetInfoServerNoAsset(){

        List<NE__OrderItem__c> ItemsToDisplay = new List<NE__OrderItem__c>();
        Account acc = OB_TestDataFactory.getAccount();
        insert acc;


        NE__Service_Point__c sp = OB_TestDataFactory.getServicePoint( );
        insert sp;
        String spID = sp.Id;

        NE__Product__c prod =OB_TestDataFactory.getProduct( );
        Id termRt = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName( ).get('Terminali').getRecordTypeId();
        prod.RecordTypeId= termRt;
        prod.name='test';
        insert prod;
        system.debug('system.debug(termRt);'+termRt);
       
        NE__Order__c ord= OB_TestDataFactory.getOrder( );
        ord.OB_Service_Point__c = sp.id;
        insert ord;

        
        Asset asse =  OB_TestDataFactory.getAsset( );
        asse.NE__Order_Config__c = ord.Id;
        asse.NE__Service_Point__c=sp.Id;
        insert asse;
        String assId = asse.Id;

        NE__OrderItem__c ordItem = new NE__OrderItem__c();
        ordItem.NE__OrderId__c = asse.NE__Order_Config__c;
        // OB_TestDataFactory.getOrderItem(ord.Id);
        ordItem.NE__Root_Order_Item__c= null;
        ordItem.NE__Qty__c = 10;
        ordItem.NE__ProdId__c= prod.Id;
        ordItem.NE__Account__c = acc.id;
        
        insert ordItem;
        System.debug('sp: '+sp);
        System.debug('ord: '+ord);   
        System.debug('ordItem: '+ordItem); 
        System.debug('prod: '+prod);

        ItemsToDisplay.add(ordItem);
      
       
      
         OB_CustomAssetViewCoBaPricing_CC.orderItemWrapper wrap1= new OB_CustomAssetViewCoBaPricing_CC.orderItemWrapper();
        wrap1.accountHolder  =null;
        wrap1.codeServicepoint =null;
        wrap1.IBAN           =null;
        wrap1.index          =0;
        wrap1.isAcquiring    =false ;
        wrap1.isOperation    =true ;
        wrap1.isPartner      =false ;
        wrap1.isTerminal     =true;
        wrap1.name           ='aAccount';
        wrap1.pvCode         ='test';       
        wrap1.terminalId     = null;
       
        
      String finalWrapper = JSON.serialize(wrap1);
        System.assertNotEquals(null , finalWrapper);
        String finalOutput = OB_CustomAssetViewCoBaPricing_CC.getAssetInfoServer(spID, assId);
       
        System.debug('### finalOutput : '+finalOutput );
        List<OB_CustomAssetViewCoBaPricing_CC.orderItemWrapper>  finalOutPutPvcode = new List<OB_CustomAssetViewCoBaPricing_CC.orderItemWrapper>();
        finalOutPutPvcode = (List<OB_CustomAssetViewCoBaPricing_CC.orderItemWrapper>)JSON.deserialize(finalOutput,List<OB_CustomAssetViewCoBaPricing_CC.orderItemWrapper>.class);
     
         System.debug('### finalOutPutPvcode : '+finalOutPutPvcode );
        
       System.debug('finalOutPutPvcode is : ' + finalOutPutPvcode[0].pvCode);
       System.assertEquals(wrap1.pvCode,  finalOutPutPvcode[0].pvCode);
     }

     /**
    *@author simone misani <simone.misani@accenture.com
    *@date 11/06/2019
    *@description Method returns String of order items without asset  with  product =Acquiring
    *@params -
    *@return String of OrderItems
    */

      @isTest
     public static void getAssetInfoServerNoAssetwithAcquiring(){
       
        List<NE__OrderItem__c> ItemsToDisplay = new List<NE__OrderItem__c>();
        Account acc = OB_TestDataFactory.getAccount();
        insert acc;


        NE__Service_Point__c sp = OB_TestDataFactory.getServicePoint( );
        insert sp;
        String spID = sp.Id;

        NE__Product__c prod =OB_TestDataFactory.getProduct( );
        Id termRt = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName( ).get('Acquiring').getRecordTypeId();
        prod.RecordTypeId= termRt;
        insert prod;
        system.debug('system.debug(termRt);'+termRt);
       
        NE__Order__c ord= OB_TestDataFactory.getOrder( );
        ord.OB_Service_Point__c = sp.id;
        insert ord;

        
        Asset asse =  OB_TestDataFactory.getAsset( );
        asse.NE__Order_Config__c = ord.Id;
        asse.NE__Service_Point__c=sp.Id;
        insert asse;
        String assId = asse.Id;

        NE__OrderItem__c ordItem = new NE__OrderItem__c();
        ordItem.NE__OrderId__c = asse.NE__Order_Config__c;
        // OB_TestDataFactory.getOrderItem(ord.Id);
        ordItem.NE__Root_Order_Item__c= null;
        ordItem.NE__Qty__c = 10;
        ordItem.NE__ProdId__c= prod.Id;
        ordItem.NE__Account__c = acc.id;
        
        insert ordItem;
        System.debug('sp: '+sp);
        System.debug('ord: '+ord);   
        System.debug('ordItem: '+ordItem); 
        System.debug('prod: '+prod);

        ItemsToDisplay.add(ordItem);

         OB_CustomAssetViewCoBaPricing_CC.orderItemWrapper wrap1= new OB_CustomAssetViewCoBaPricing_CC.orderItemWrapper();
       
        wrap1.name           ='lubrano';
        wrap1.pvCode         ='testProduct';
        wrap1.isTerminal     =true;
        wrap1.isAcquiring    =false ;
        wrap1.terminalId     = null;
        wrap1.IBAN           =null;
        wrap1.accountHolder  =null;
        wrap1.index          =0;
        wrap1.isPartner      =false ;
        wrap1.isOperation    =true ;
        wrap1.codeServicepoint =null;

      
       String finalWrapper = JSON.serialize(wrap1);
        System.assertNotEquals(null , finalWrapper);
        String finalOutput = OB_CustomAssetViewCoBaPricing_CC.getAssetInfoServer(spID, assId);
       
        System.debug('### finalOutput : '+finalOutput );
        List<OB_CustomAssetViewCoBaPricing_CC.orderItemWrapper>  finalOutPutPvcode = new List<OB_CustomAssetViewCoBaPricing_CC.orderItemWrapper>();
        finalOutPutPvcode = (List<OB_CustomAssetViewCoBaPricing_CC.orderItemWrapper>)JSON.deserialize(finalOutput,List<OB_CustomAssetViewCoBaPricing_CC.orderItemWrapper>.class);
    
         System.debug('### finalOutPutPvcode : '+finalOutPutPvcode );
       

       System.debug('finalOutPutPvcode is : ' + finalOutPutPvcode[0].pvCode);
       System.assertEquals(wrap1.pvCode,  finalOutPutPvcode[0].pvCode);
        
     }


     /**
    *@author simone misani <simone.misani@accenture.com
    *@date 11/06/2019
    *@description Method returns string asset without orderItems  with  product =Terminali
    *@params -
    *@return String of asset
    */

       @isTest
     public static void getAssetInfoServerNoOrderItem(){
      

        List<NE__OrderItem__c> ItemsToDisplay = new List<NE__OrderItem__c>();
        Account acc = OB_TestDataFactory.getAccount();
        insert acc;
        

        NE__Service_Point__c sp = OB_TestDataFactory.getServicePoint( );
        insert sp;
        String spID = sp.Id;

        NE__Product__c prod =OB_TestDataFactory.getProduct( );
        Id termRt = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName( ).get('Terminali').getRecordTypeId();
        prod.RecordTypeId= termRt;
        insert prod;
        system.debug('system.debug(termRt);'+termRt);
       
        NE__Order__c ord= OB_TestDataFactory.getOrder( );
        ord.OB_Service_Point__c = sp.id;
        insert ord;

        
        Asset asse =  OB_TestDataFactory.getAsset( );
        asse.NE__Order_Config__c = ord.Id;
        asse.NE__Service_Point__c=sp.Id;
        asse.NE__Root_Order_Item__c= null;
        asse.NE__ProdId__c=prod.Id;
        insert asse;
        String assId = asse.Id;


          OB_CustomAssetViewCoBaPricing_CC.orderItemWrapper wrap1= new OB_CustomAssetViewCoBaPricing_CC.orderItemWrapper();
       
        wrap1.name           ='lubrano';
        wrap1.pvCode         ='testProduct';
        wrap1.isTerminal     =true;
        wrap1.isAcquiring    =false ;
        wrap1.terminalId     ='00866351';
        wrap1.IBAN           ='IT31Q0313812300000000000000';
        wrap1.accountHolder  ='st';
        wrap1.index          =0;
        wrap1.isPartner      =false ;
        wrap1.isOperation    =true ;
        wrap1.codeServicepoint ='Offerta Personalizzata';
      
      
       String finalWrapper = JSON.serialize(wrap1);
        System.assertNotEquals(null , finalWrapper);
        String finalOutput = OB_CustomAssetViewCoBaPricing_CC.getAssetInfoServer(spID, assId);
       
        System.debug('### finalOutput : '+finalOutput );
        List<OB_CustomAssetViewCoBaPricing_CC.orderItemWrapper>  finalOutPutPvcode = new List<OB_CustomAssetViewCoBaPricing_CC.orderItemWrapper>();
        finalOutPutPvcode = (List<OB_CustomAssetViewCoBaPricing_CC.orderItemWrapper>)JSON.deserialize(finalOutput,List<OB_CustomAssetViewCoBaPricing_CC.orderItemWrapper>.class);     
         System.debug('### finalOutPutPvcode : '+finalOutPutPvcode );         

       System.debug('finalOutPutPvcode is : ' + finalOutPutPvcode[0].pvCode);
       System.assertEquals(wrap1.pvCode,  finalOutPutPvcode[0].pvCode);
     }


/**
    *@author simone misani <simone.misani@accenture.com
    *@date 11/06/2019
    *@description Method returns string asset without orderItems  with  product =Acquiring
    *@params -
    *@return String of asset
    */
      @isTest
     public static void getAssetInfoServerNoOrderItemWithAcquiring(){
        

        List<NE__OrderItem__c> ItemsToDisplay = new List<NE__OrderItem__c>();
        Account acc = OB_TestDataFactory.getAccount();
        insert acc;


        NE__Service_Point__c sp = OB_TestDataFactory.getServicePoint( );
        insert sp;
        String spID = sp.Id;

        NE__Product__c prod =OB_TestDataFactory.getProduct( );
        Id termRt = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName( ).get('Acquiring').getRecordTypeId();
        prod.RecordTypeId= termRt;
        insert prod;
       
        NE__Order__c ord= OB_TestDataFactory.getOrder( );
        ord.OB_Service_Point__c = sp.id;
        insert ord;

        
        Asset asse =  OB_TestDataFactory.getAsset( );
        asse.NE__Order_Config__c = ord.Id;
        asse.NE__Service_Point__c=sp.Id;
        asse.NE__Root_Order_Item__c= null;
        asse.NE__ProdId__c=prod.Id;
        insert asse;
        String assId = asse.Id;


        OB_CustomAssetViewCoBaPricing_CC.orderItemWrapper wrap1= new OB_CustomAssetViewCoBaPricing_CC.orderItemWrapper();
       
        wrap1.name           ='lubrano';
        wrap1.pvCode         ='testProduct';
        wrap1.isTerminal     =true;
        wrap1.isAcquiring    =false ;
        wrap1.terminalId     ='00866351';
        wrap1.IBAN           ='IT31Q0313812300000000000000';
        wrap1.accountHolder  ='st';
        wrap1.index          =0;
        wrap1.isPartner      =true ;
        wrap1.isOperation    =false ;
        wrap1.codeServicepoint ='Offerta Personalizzata';

        String finalWrapper = JSON.serialize(wrap1);
        System.assertNotEquals(null , finalWrapper);
        String finalOutput = OB_CustomAssetViewCoBaPricing_CC.getAssetInfoServer(spID, assId);
       
        System.debug('### finalOutput : '+finalOutput );
        List<OB_CustomAssetViewCoBaPricing_CC.orderItemWrapper>  finalOutPutPvcode = new List<OB_CustomAssetViewCoBaPricing_CC.orderItemWrapper>();
        finalOutPutPvcode = (List<OB_CustomAssetViewCoBaPricing_CC.orderItemWrapper>)JSON.deserialize(finalOutput,List<OB_CustomAssetViewCoBaPricing_CC.orderItemWrapper>.class);
         System.debug('### finalOutPutPvcode : '+finalOutPutPvcode );        
       System.debug('finalOutPutPvcode is : ' + finalOutPutPvcode[0].pvCode);
       System.assertEquals(wrap1.pvCode,  finalOutPutPvcode[0].pvCode);
        
     }



}