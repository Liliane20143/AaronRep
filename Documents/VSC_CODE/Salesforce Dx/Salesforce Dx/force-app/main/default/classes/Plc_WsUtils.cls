/**
 * @author Kebe Dam
 * @date Creation 15/10/2018
 * @version 1.0
 * @description Utils class for rest web services.
 */
public with sharing class Plc_WsUtils {

    public static final String TIMESTAMP_FORMAT = 'yyyy-MM-dd-hh.mm.ss.SSS';
    
    public static final String STATUS_SUCCESS = 'S';
    public static final String STATUS_WARNING = 'W';
    public static final String STATUS_EXCEPTION = 'E';
    /** Email regular expression */
    public static final String EMAIL_REGEX = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
    /** Map of error code to error message */
    public static final Map<String, Plc_ServiceWs.Result> ERROR_MESSAGE_MAP = new Map<String, Plc_ServiceWs.Result> {

        '600' => new Plc_ServiceWs.Result('E', '600',
                                           System.Label.Plc_ApexClass600UserFeedback,
                                           System.Label.Plc_ApexClass600TecnicalMessage),
        '602' => new Plc_ServiceWs.Result('E', '602',
                                           System.Label.Plc_ApexClass602UserFeedback,
                                           System.Label.Plc_ApexClass602TecnicalMessage),
        '603' => new Plc_ServiceWs.Result('E', '603',
                                           System.Label.Plc_ApexClass603UserFeedback,
                                           System.Label.Plc_ApexClass603TecnicalMessage),
        '604' => new Plc_ServiceWs.Result('E', '604',
                                           System.Label.Plc_ApexClass604UserFeedback,
                                           System.Label.Plc_ApexClass604TecnicalMessage),
        '605' => new Plc_ServiceWs.Result('E', '605',
                                           System.Label.Plc_ApexClass605UserFeedback,
                                           System.Label.Plc_ApexClass605TecnicalMessage),
        '606' => new Plc_ServiceWs.Result('E', '606',
                                           System.Label.Plc_ApexClass606UserFeedback,
                                           System.Label.Plc_ApexClass606TecnicalMessage),
        '200' => new Plc_ServiceWs.Result('S', '200',
                                           System.Label.Plc_ApexClass200UserFeedback,
                                           System.Label.Plc_ApexClass200TecnicalMessage),
        '201' => new Plc_ServiceWs.Result('S', '201',
                                           System.Label.Plc_ApexClass201UserFeedback,
                                           System.Label.Plc_ApexClass201TecnicalMessage),
        '202' => new Plc_ServiceWs.Result('W', '202',
                                           System.Label.Plc_ApexClass202UserFeedback,
                                           System.Label.Plc_ApexClass202TecnicalMessage),
        '203' => new Plc_ServiceWs.Result('W', '203',
                                           System.Label.Plc_ApexClass203UserFeedback,
                                           System.Label.Plc_ApexClass203TecnicalMessage),
        '204' => new Plc_ServiceWs.Result('W', '204',
                                           System.Label.Plc_ApexClass204UserFeedback,
                                           System.Label.Plc_ApexClass204TecnicalMessage),
        '205' => new Plc_ServiceWs.Result('W', '205',
                                           System.Label.Plc_ApexClass205UserFeedback,
                                           System.Label.Plc_ApexClass205TecnicalMessage),
        '206' => new Plc_ServiceWs.Result('W', '206',
                                           System.Label.Plc_ApexClass206UserFeedback,
                                           System.Label.Plc_ApexClass206TecnicalMessage),
        '207' => new Plc_ServiceWs.Result('W', '207',
                                           System.Label.Plc_ApexClass207UserFeedback,
                                           System.Label.Plc_ApexClass207TecnicalMessage),
        '208' => new Plc_ServiceWs.Result('W', '208',
                                           System.Label.Plc_ApexClass208UserFeedback,
                                           System.Label.Plc_ApexClass208TecnicalMessage),
        '209' => new Plc_ServiceWs.Result('W', '209',
                                           System.Label.Plc_ApexClass209UserFeedback,
                                           System.Label.Plc_ApexClass209TecnicalMessage),
        '210' => new Plc_ServiceWs.Result('W', '210',
                                           'OK - WARNING: ',
                                           '')
    };

    /**
     * [getRequestTimestamp description]
     *
     * @param timestamp record's timestamp
     *
     * @return timestamp in milliseconds
     *
     * @code 06
     */
    public static Long getRequestTimestamp(Datetime timestamp) {

        // Returns the number of milliseconds since January 1, 1970, 00:00:00 GMT represented by this DateTime object.
        return timestamp != null ? timestamp.getTime() : null;
    }

    /**
     * [getRequestTimestamp description]
     *
     * @return timestamp in milliseconds
     *
     * @code 06
     */
    public static Long getRequestTimestamp() {

        // Returns the number of milliseconds since January 1, 1970, 00:00:00 GMT represented by this DateTime object.
        return getRequestTimestamp(System.now());
    }

    public static Map<String, Bit2Shop__Product_Stock__c> retrieveProductStocks(Plc_Wrappers.GestioneDisponibilitaRequestBody payLoad){
        Map<String, Bit2Shop__Product_Stock__c> productStockMap = new Map<String, Bit2Shop__Product_Stock__c>();
         for(Bit2Shop__Product_Stock__c productStock : [SELECT Id, Plc_AvailableQty__c, Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c,Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__r.Plc_Alias__c, Bit2Shop__Warehouse_Id__r.Bit2Shop__Dealer_Id__r.OwnerId, Bit2Shop__Warehouse_Id__r.Plc_Alias__c
                                                         FROM Bit2Shop__Product_Stock__c
                                                         WHERE Plc_AvailableQty__c > 0 
                                                         AND
                                                         Bit2Shop__Warehouse_Id__r.Plc_Alias__c = :payLoad.warehouseAlias
                                                         AND
                                                         Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c = :payload.resourceAlias
                                                         ORDER BY Plc_AvailableQty__c ASC
                                                         ]){

        productStockMap.put(''+ productStock.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__r.Plc_Alias__c + productStock.Bit2Shop__Warehouse_Id__r.Plc_Alias__c,
            productStock);
        productStockMap.put('' + productStock.Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c + productStock.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__r.Plc_Alias__c + productStock.Bit2Shop__Warehouse_Id__r.Plc_Alias__c,
            productStock);
        }
        System.debug('Check Mappa 2: '+ productStockMap);
        return productStockMap;
    }
    
    public static Map<String, Bit2Shop__Product_Stock__c> retrieveProductStocks(List<String> resourceAliasList,List<String> warehouseAliasList){
      
      System.debug('resourceAliasList: ' + resourceAliasList);
      System.debug('warehouseAliasList: ' + warehouseAliasList);
      List<String> solutionList = new List<String>();
      Map<String, Bit2Shop__Product_Stock__c> productStockMap = new Map<String, Bit2Shop__Product_Stock__c>();
      for(Bit2Shop__Product_Stock__c productStock : [SELECT Id, Plc_AvailableQty__c, Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c, Bit2Shop__Warehouse_Id__r.Bit2Shop__Dealer_Id__r.OwnerId,Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__r.Plc_Alias__c, Bit2Shop__Warehouse_Id__r.Plc_Alias__c,Bit2Shop__External_Catalog_Item_Id__c
                                                         FROM Bit2Shop__Product_Stock__c
                                                         WHERE Bit2Shop__Warehouse_Id__r.Plc_Alias__c IN :warehouseAliasList
                                                         AND Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c  IN :resourceAliasList
                                                         ORDER BY Plc_AvailableQty__c ASC
                                                         ]){
          productStockMap.put(''+ productStock.Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c + productStock.Bit2Shop__Warehouse_Id__r.Plc_Alias__c,
              productStock);
        }
        System.debug('productStockMap: ' + productStockMap);
        for(B2WExtCat__External_Catalog_Item__c ex : [SELECT Plc_ProductSku__c, Plc_Solution__r.Plc_Alias__c
                                                         FROM B2WExtCat__External_Catalog_Item__c
                                                         WHERE Plc_ProductSku__c IN :resourceAliasList
                                                         ]){

            solutionList.add(ex.Plc_Solution__r.Plc_Alias__c);
        }

        System.debug('solutionList: ' + solutionList);
        for(Bit2Shop__Product_Stock__c productStock : [SELECT Plc_AvailableQty__c, Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__r.Plc_Alias__c, Bit2Shop__Product_Stock__c.Bit2Shop__Warehouse_Id__r.Plc_Alias__c,
                                                              Bit2Shop__Product_Stock__c.Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c, Bit2Shop__Warehouse_Id__r.Bit2Shop__Dealer_Id__r.OwnerId,Bit2Shop__External_Catalog_Item_Id__c
                                                         FROM Bit2Shop__Product_Stock__c
                                                         WHERE Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__r.Plc_Alias__c IN: solutionList
                                                         AND Bit2Shop__Warehouse_Id__r.Plc_Alias__c = :warehouseAliasList
                                                         ORDER BY Plc_AvailableQty__c ASC
                                                         ]){

            System.debug('resourceAlias+warehouseAlias: ' + ('' + productStock.Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c + productStock.Bit2Shop__Warehouse_Id__r.Plc_Alias__c));
            productStockMap.put(productStock.Bit2Shop__Warehouse_Id__r.Plc_Alias__c, productStock);
        }
        System.debug('productStockMap: ' + productStockMap);
        return productStockMap;
    }
    

    public static Map<String, Bit2Shop__Product_Stock__c> retrieveProductStocksCompatible (String resourceAlias, String warehouseAlias){
        
        Map<String, Bit2Shop__Product_Stock__c> productStockMap = new Map<String, Bit2Shop__Product_Stock__c>(); 
        

        List<B2WExtCat__External_Catalog_Item__c> externalCatalogItem = [SELECT Id,Plc_Solution__r.Plc_Alias__c FROM B2WExtCat__External_Catalog_Item__c 
                                                                        WHERE Plc_ProductSku__c =:resourceAlias
                                                                        LIMIT 1
                                                                        ];
        
        if(!externalCatalogItem.isEmpty()){ 

          for(Bit2Shop__Product_Stock__c productStock : [SELECT Plc_AvailableQty__c,Bit2Shop__External_Catalog_Item_Id__c, Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__r.Plc_Alias__c, Bit2Shop__Product_Stock__c.Bit2Shop__Warehouse_Id__r.Plc_Alias__c,
                                                                Bit2Shop__Product_Stock__c.Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c
                                                           FROM Bit2Shop__Product_Stock__c
                                                           WHERE Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__r.Plc_Alias__c = :externalCatalogItem.get(0).Plc_Solution__r.Plc_Alias__c
                                                           AND Bit2Shop__Warehouse_Id__r.Plc_Alias__c = :warehouseAlias AND Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c !=:resourceAlias
                                                           ORDER BY Plc_AvailableQty__c ASC
                                                           ]){
            String resourceKey = productStock.Bit2Shop__Warehouse_Id__r.Plc_Alias__c ;
            productStockMap.put(resourceKey, productStock);
          }

        }
        return productStockMap;
    }
    public static Map<String, Bit2Shop__Product_Stock__c> retrieveProductStocksCompatible (Set<String> resourceAlias, String warehouseAlias){
        
        Map<String, Bit2Shop__Product_Stock__c> productStockMap = new Map<String, Bit2Shop__Product_Stock__c>(); 
        

        List<Bit2Shop__Product_Stock__c> productStockItemList = [SELECT Plc_AvailableQty__c, Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__r.Plc_Alias__c
                                                         FROM Bit2Shop__Product_Stock__c
                                                         WHERE Bit2Shop__Warehouse_Id__r.Plc_Alias__c = :warehouseAlias
                                                         AND Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c IN:resourceAlias
                                                         LIMIT 1
                                                         ];

        System.debug('### resourceAlias ### '+ JSon.serialize(resourceAlias));
        System.debug('### productStockItemList ### '+ JSon.serialize(productStockItemList));
        
        if(!productStockItemList.isEmpty()){

          for(Bit2Shop__Product_Stock__c productStock : [SELECT Plc_AvailableQty__c,Bit2Shop__External_Catalog_Item_Id__c, Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__r.Plc_Alias__c, Bit2Shop__Product_Stock__c.Bit2Shop__Warehouse_Id__r.Plc_Alias__c,
                                                                Bit2Shop__Product_Stock__c.Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c
                                                           FROM Bit2Shop__Product_Stock__c
                                                           WHERE Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__r.Plc_Alias__c = :productStockItemList.get(0).Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__r.Plc_Alias__c
                                                           AND Bit2Shop__Warehouse_Id__r.Plc_Alias__c = :warehouseAlias AND Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c NOT IN:resourceAlias
                                                           ORDER BY Plc_AvailableQty__c ASC
                                                           ]){
            String resourceKey = productStock.Bit2Shop__Warehouse_Id__r.Plc_Alias__c ;
            productStockMap.put(resourceKey, productStock);
          }

        }
        return productStockMap;
    }

    public static Map<String, Bit2Shop__Warehouse__c> retriveWarehouseOwners (List<String> warehouseAliasList){

      Map<String, Bit2Shop__Warehouse__c> warehouseOwnersMap = new Map<String, Bit2Shop__Warehouse__c>();
      for(Bit2Shop__Warehouse__c warehouse : [SELECT Plc_Alias__c, Bit2Shop__Dealer_Id__r.OwnerId,Name FROM Bit2Shop__Warehouse__c WHERE Plc_Alias__c IN: warehouseAliasList]){

        warehouseOwnersMap.put(warehouse.Plc_Alias__c,warehouse);
      }
      System.debug('### warehouseOwnersMap: ' + warehouseOwnersMap);
      return warehouseOwnersMap;
    }/*
    public static Map<String, Bit2Shop__Warehouse__c> retriveWarehouseOwners (List<String> warehouseAliasList){

      Map<String, Bit2Shop__Warehouse__c> warehouseOwnersMap = new Map<String, Bit2Shop__Warehouse__c>();
      for(Bit2Shop__Warehouse__c warehouse : [SELECT Plc_Alias__c, Bit2Shop__Dealer_Id__r.OwnerId,Name FROM Bit2Shop__Warehouse__c WHERE Plc_Alias__c IN: warehouseAliasList]){

        warehouseOwnersMap.put(warehouse.Plc_Alias__c,warehouse);
      }
      System.debug('### warehouseOwnersMap: ' + warehouseOwnersMap);
      return warehouseOwnersMap;
    }*/

    public static String addTimeValue(String info, String value){

      return info + ': ' + value + ';\n';
    }

    public static String makeProcessingTime(Datetime initTimestamp, Datetime endTimestamp){

      return 'Init: ' + initTimestamp + ';\n' +
             'End: ' + endTimestamp + ';\n' + 
             'TotExec: ' + Integer.valueOf(endTimestamp.getTime() - initTimestamp.getTime());
    }

    /*
    //MEDIO
    public static Map<String, Bit2Shop__Product_Stock__c> retrieveProductStocks(List<String> resourceAliasList,List<String> warehouseAliasList){
      Map<String, Bit2Shop__Product_Stock__c> productStockMap = new Map<String, Bit2Shop__Product_Stock__c>();
      Set<String> foundWarehouseAlias = new Set<String>();
      Set<String> foundResourceAlias = new Set<String>();


      for(Bit2Shop__Product_Stock__c productStock : [SELECT Id, Bit2Shop__External_Catalog_Item_Id__r.Plc_Alias__c,
                                                             Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__r.Bit2Shop__Product_SKU__c, Bit2Shop__Warehouse_Id__r.Bit2Shop__Product_SKU__c
                                                         FROM Bit2Shop__Product_Stock__c
                                                         WHERE Plc_AvailableQty__c > 0 
                                                         AND Bit2Shop__Warehouse_Id__r.Bit2Shop__Product_SKU__c IN :warehouseAliasList
                                                         AND Bit2Shop__External_Catalog_Item_Id__r.Bit2Shop__Product_SKU__c  IN :resourceAliasList
                                                         ORDER BY Plc_AvailableQty__c ASC
                                                         ]){
          productStockMap.put(''+ productStock.Bit2Shop__External_Catalog_Item_Id__r.Bit2Shop__Product_SKU__c + productStock.Bit2Shop__Warehouse_Id__r.Bit2Shop__Product_SKU__c,
              productStock);
      foundWarehouseAlias.add(productStock.Bit2Shop__Warehouse_Id__r.Bit2Shop__Product_SKU__c);
      foundResourceAlias.add(productStock.Bit2Shop__External_Catalog_Item_Id__r.Bit2Shop__Product_SKU__c);


      }
      
      if(!foundWarehouseAlias.isEmpty()){
        foundResourceAlias.addAll(resourceAliasList.removeAll(foundResourceAlias));
        foundWarehouseAlias.addAll(warehouseAliasList.removeAll(foundWarehouseAlias));
      }
      return productStockMap;
      
    }
    //MEDIO
    */






    //OLD
    /*
    public static Map<String, Bit2Shop__Product_Stock__c> retrieveProductStocks(List<String> resourceAliasList,List<String> warehouseAliasList){
      
      Map<String, Bit2Shop__Product_Stock__c> productStockMap = new Map<String, Bit2Shop__Product_Stock__c>();
      for(Bit2Shop__Product_Stock__c productStock : [SELECT Id, Bit2Shop__External_Catalog_Item_Id__r.Bit2Shop__Product_SKU__c,
                                                             Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__r.Bit2Shop__Product_SKU__c, Bit2Shop__Warehouse_Id__r.Bit2Shop__Product_SKU__c
                                                         FROM Bit2Shop__Product_Stock__c
                                                         WHERE Plc_AvailableQty__c > 0 
                                                         AND Bit2Shop__Warehouse_Id__r.Bit2Shop__Product_SKU__c IN :warehouseAliasList
                                                         AND Bit2Shop__External_Catalog_Item_Id__r.Bit2Shop__Product_SKU__c  IN :resourceAliasList
                                                         ORDER BY Plc_AvailableQty__c ASC
                                                         ]){
          productStockMap.put(''+ productStock.Bit2Shop__External_Catalog_Item_Id__r.Bit2Shop__Product_SKU__c + productStock.Bit2Shop__Warehouse_Id__r.Plc_Alias__c,
              productStock);
        }
        return productStockMap;
    }
    */
    //OLD












    
}