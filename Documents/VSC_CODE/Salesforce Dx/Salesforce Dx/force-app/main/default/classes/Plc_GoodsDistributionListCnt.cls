/** 
 * @author Francesco Bigoni
 * @date Creation 3/12/2018
 * @version 1.0
 * @description Controller of lightning component Plc_GoodsDistributionList
 * @errorcode [ERR:CL-013YYZZ]
 */
public without sharing class Plc_GoodsDistributionListCnt {

    /**
     * Method used in order to get some different system labels
     *
     * @code 01
     *
     * @return A map containing pairs Api Name/Label
     */
    @AuraEnabled
    public static Map<String, String> retrieveTranslationMap(){

        Map<String, String> response = new Map<String,String>();
        //Getting Product Stock labels
        Schema.DescribeSObjectResult productStockSchema = Bit2Shop__Product_Stock__c.SObjectType.getDescribe();
        Map<String, Schema.SObjectField> productStockFieldsMap = productStockSchema.fields.getMap();
        response.put('Bit2Shop__Product_Stock__c', productStockSchema.getLabel());
        response.put('ProductStockName', productStockFieldsMap.get('Name').getDescribe().getLabel());
        response.put('Plc_ProductSku__c', productStockFieldsMap.get('Plc_ProductSku__c').getDescribe().getLabel());
        response.put('Plc_Manufacturer__c', productStockFieldsMap.get('Plc_Manufacturer__c').getDescribe().getLabel());
        response.put('Plc_AvailableQty__c', productStockFieldsMap.get('Plc_AvailableQty__c').getDescribe().getLabel());
        response.put('Plc_OrderedQty__c', productStockFieldsMap.get('Plc_OrderedQty__c').getDescribe().getLabel());
        //Getting External catalog item labels
        Schema.DescribeSObjectResult modelSchema = B2WExtCat__External_Catalog_Item__c.SObjectType.getDescribe();
        Map<String, Schema.SObjectField> modelFieldsMap = modelSchema.fields.getMap();
        response.put('B2WExtCat__External_Catalog_Item__c', modelSchema.getLabel());
        response.put('Plc_MinimumStock__c', modelFieldsMap.get('Plc_MinimumStock__c').getDescribe().getLabel());
        Schema.DescribeSObjectResult dealerSchema = Bit2Shop__Dealer__c.SObjectType.getDescribe();
        response.put('Bit2Shop__Dealer__c', dealerSchema.getLabel());
        Schema.DescribeSObjectResult warehouseSchema = Bit2Shop__Warehouse__c.SObjectType.getDescribe();
        response.put('Bit2Shop__Warehouse__c', warehouseSchema.getLabel());
        Schema.DescribeSObjectResult solutionSchema = Plc_Solution__c.SObjectType.getDescribe();
        response.put('Plc_Solution__c', solutionSchema.getLabel());
        Schema.DescribeSObjectResult warehouseSolutionSchema = Plc_WarehouseSolution__c.SObjectType.getDescribe();
        Map<String, Schema.SObjectField> warehouseSolutionFieldsMap = warehouseSolutionSchema.fields.getMap();
        response.put('Plc_WarehouseSolution__c', warehouseSolutionSchema.getLabel());
        response.put('Plc_ReorderStock__c', warehouseSolutionFieldsMap.get('Plc_ReorderStock__c').getDescribe().getLabel());
        response.put('Plc_SecurityStock__c', warehouseSolutionFieldsMap.get('Plc_SecurityStock__c').getDescribe().getLabel());
        Schema.DescribeSObjectResult distributionListSchema = Plc_DistributionList__c.SObjectType.getDescribe();
        response.put('Plc_DistributionList__c', distributionListSchema.getLabel());
        Schema.DescribeSObjectResult distributionListItemSchema = Plc_DistributionListItem__c.SObjectType.getDescribe();
        Map<String, Schema.SObjectField> distributionListItemFieldsMap = distributionListItemSchema.fields.getMap();
        response.put('Plc_Note__c', distributionListItemFieldsMap.get('Plc_Note__c').getDescribe().getLabel());

        return response;
    }


    /**
    * Method used in order to get some utils and context data
    *
    * @code 02
    * 
    * @return Utils and context data
    */
    @AuraEnabled
    public static Map<String, Object> retrievePropertiesMap(){

        Map<String, Object> response = new Map<String, Object>();
        response.put('error', false);

        try {

            /* START
             * Initialization
             * ----------------------------------------------------------------------------------------------------------------------------------- */

            //Declaring used collections
            Map<String, Bit2Shop__Warehouse__c> warehousesMap = new Map<String, Bit2Shop__Warehouse__c>();
            Map<String, Bit2Shop__Dealer__c> dealersMap = new Map<String, Bit2Shop__Dealer__c>();
            Map<String, ProductSolutionWrp> productsMap = new Map<String, ProductSolutionWrp>();
            Map<String, String> solutionToWhSolutionMap = new Map<String, String>();
            Set<String> foundManufacturersSet = new Set<String>();
            Set<String> foundModelsSet = new Set<String>();
            Set<String> foundSolutionsSet = new Set<String>();

            //Everything starts from warehouses solutions. It is the pivot of on which every other data relies
            Map<String, Plc_WarehouseSolution__c> whSolutionsMap = new Map<String, Plc_WarehouseSolution__c>([SELECT Id, Name, Plc_Solution__r.Name, Plc_Warehouse__r.Bit2Shop__Dealer_Id__c,  
                                                                                                                     Plc_ReorderStock__c, Plc_SecurityStock__c, 
                                                                                                                     Plc_Warehouse__r.Bit2Shop__Dealer_Id__r.Name, Plc_Warehouse__c, 
                                                                                                                     Plc_Warehouse__r.Name
                                                                                                              FROM Plc_WarehouseSolution__c
                                                                                                              WHERE Plc_ReorderStock__c < 0 AND
                                                                                                                    Plc_Warehouse__r.Plc_Tipology__c = 'Generic' AND
                                                                                                                    Plc_Warehouse__r.Bit2Shop__Dealer_Id__r.Plc_Maintainer__c = true 
                                                                                                              ORDER BY Plc_Warehouse__r.Bit2Shop__Dealer_Id__r.Name, 
                                                                                                                       Plc_Warehouse__r.Name, Name ASC]);
            //Less recent draft distribution list is got, in order to populate requested values in the wizard
            List<Plc_DistributionList__c> distributionList = [SELECT Id, Name, OwnerId, Owner.Name
                                                              FROM Plc_DistributionList__c
                                                              WHERE Plc_Status__c = 'Draft' 
                                                              ORDER BY CreatedDate ASC 
                                                              LIMIT 1];
            //If a distribution list was found, then return main information to client
            //It is easy and lightweight to send both id and name separately, instead of putting everything in an object
            if (distributionList.size() > 0) {
                response.put('distributionsListId', distributionList.get(0).Id);
                response.put('distributionListName', distributionList.get(0).Name);

                if (UserInfo.getUserId() != distributionList.get(0).OwnerId) {
                    response.put('isUserOwner', false);
                    response.put('ownerName', distributionList.get(0).Owner.Name);
                } else {
                    response.put('isUserOwner', true);
                }
            } else {
                //If the distribution list must be created from scratch, then the wizard is enabled to editing
                //which means that current user is obviously the owner
                response.put('isUserOwner', true);
            }

            /* END
             * Initialization
             * ----------------------------------------------------------------------------------------------------------------------------------- */

            /* START
             * Starting from warehouses solutions, dealers and warehouses are got
             * ----------------------------------------------------------------------------------------------------------------------------------- */
            for (String id : whSolutionsMap.keySet()) {
                warehousesMap.put(
                    whSolutionsMap.get(id).Plc_Warehouse__c, 
                    new Bit2Shop__Warehouse__c(
                        Id = whSolutionsMap.get(id).Plc_Warehouse__c, 
                        Name = whSolutionsMap.get(id).Plc_Warehouse__r.Name,
                        Bit2Shop__Dealer_Id__c = whSolutionsMap.get(id).Plc_Warehouse__r.Bit2Shop__Dealer_Id__c)
                    );

                dealersMap.put(
                    whSolutionsMap.get(id).Plc_Warehouse__r.Bit2Shop__Dealer_Id__c,
                    new Bit2Shop__Dealer__c(
                        Id = whSolutionsMap.get(id).Plc_Warehouse__r.Bit2Shop__Dealer_Id__c,
                        Name = whSolutionsMap.get(id).Plc_Warehouse__r.Bit2Shop__Dealer_Id__r.Name)
                    );

                //It is needed to map the solution to match warehouse solution to solution for the given warehouse
                solutionToWhSolutionMap.put('' + whSolutionsMap.get(id).Plc_Warehouse__c + whSolutionsMap.get(id).Plc_Solution__c, id);
                //In addition the found solution is added to a specific collection, used as a filter later 
                foundSolutionsSet.add(whSolutionsMap.get(id).Plc_Solution__c);
            }
            /* END
             * Starting from warehouses solutions, dealers and warehouses are got
             * ----------------------------------------------------------------------------------------------------------------------------------- */
            
            /* START
             * Getting product stocks for each warehouse and solution found
             * ----------------------------------------------------------------------------------------------------------------------------------- */
            for (Bit2Shop__Product_Stock__c ps : [SELECT Id, Name, Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__c, Bit2Shop__Warehouse_Id__c, 
                                                         Plc_Manufacturer__c, Bit2Shop__Warehouse_Id__r.Bit2Shop__Dealer_Id__c,
                                                         Plc_ProductSku__c, Bit2Shop__External_Catalog_Item_Id__r.Plc_Manufacturer__r.Name, 
                                                         Plc_AvailableQty__c, Plc_OrderedQty__c, Bit2Shop__External_Catalog_Item_Id__r.Plc_MinimumStock__c
                                                  FROM Bit2Shop__Product_Stock__c
                                                  WHERE Bit2Shop__Warehouse_Id__c IN :warehousesMap.keySet() AND 
                                                        Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__c IN :foundSolutionsSet]) {
                //First build of list of products to return to client
                productsMap.put(ps.Id, new ProductSolutionWrp(
                    ps.Name + '', 
                    ps.Plc_ProductSku__c,
                    ps.Plc_Manufacturer__c ,
                    ps.Plc_AvailableQty__c ,
                    ps.Plc_OrderedQty__c ,
                    ps.Bit2Shop__External_Catalog_Item_Id__r.Plc_MinimumStock__c ,
                    ps.Bit2Shop__Warehouse_Id__c + '',
                    ps.Bit2Shop__External_Catalog_Item_Id__c + '',
                    ps.Bit2Shop__External_Catalog_Item_Id__r.Plc_Manufacturer__c,
                    solutionToWhSolutionMap.get('' + ps.Bit2Shop__Warehouse_Id__c + ps.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__c))
                );
                
                //In addition the manufacturers are got, in order to get further information later
                foundManufacturersSet.add(ps.Bit2Shop__External_Catalog_Item_Id__r.Plc_Manufacturer__c);
                foundModelsSet.add(ps.Bit2Shop__External_Catalog_Item_Id__c);
            }
            /* END
             * Getting product stocks for each warehouse and solution found
             *  ----------------------------------------------------------------------------------------------------------------------------------- */

            /* START 
             * Getting for each dealer the warehouse of new items
             * ------------------------------------------------------------------------------------------------------------------------------------ */
            Map<String, Bit2Shop__Warehouse__c> manufacturerToWarehouseOfNewItemsMap = new Map<String, Bit2Shop__Warehouse__c>();

            //for manufacturers it is needed to retrieve list of warehouses of new items
            for (Bit2Shop__Warehouse__c warehousesOfNewItems : [SELECT Id, Name, Bit2Shop__Dealer_Id__c,
                                                                       Bit2Shop__Dealer_Id__r.Bit2Shop__Parent_Dealer__c
                                                                FROM Bit2Shop__Warehouse__c
                                                                WHERE Plc_Tipology__c = 'New' AND 
                                                                      Bit2Shop__Dealer_Id__r.Bit2Shop__Parent_Dealer__c IN :foundManufacturersSet]) {
                manufacturerToWarehouseOfNewItemsMap.put('' + warehousesOfNewItems.Bit2Shop__Dealer_Id__r.Bit2Shop__Parent_Dealer__c, warehousesOfNewItems);
            }
            /* END 
             * Getting for each dealer the warehouse of new items
             * ----------------------------------------------------------------------------------------------------------------------------------- */

            /* START 
             * Preparing data for distribution list items for repaired items (which don't have a purchase order), in order to get quantities
             * ----------------------------------------------------------------------------------------------------------------------------------- */
            Map<String, Plc_DistributionListItem__c> modelDestinationWarehouseToDistributionItem = new Map<String, Plc_DistributionListItem__c>();

            if (distributionList.size() > 0) {
                for (Plc_DistributionListItem__c item : [SELECT Id, Name, Plc_DestinationWarehouse__c, Plc_PurchaseOrder__c, Plc_Product__c,
                                                                Plc_RequestedQty__c, Plc_OriginWarehouse__r.Bit2Shop__Dealer_Id__c, Plc_Note__c
                                                         FROM Plc_DistributionListItem__c
                                                         WHERE Plc_DistributionList__c = :distributionList.get(0).Id AND
                                                               Plc_PurchaseOrder__c = '']) {
                    //If the purchase order is empty it means that the distribution list items is from a repaired stock
                    String key =  '' + item.Plc_Product__c + item.Plc_DestinationWarehouse__c + item.Plc_OriginWarehouse__c;
                    modelDestinationWarehouseToDistributionItem.put(key, item);
                }
            }
            /* END 
             * Preparing data for distribution list items, in order to get quantities
             * ----------------------------------------------------------------------------------------------------------------------------------- */

            /* START 
             * Getting requested quantities, available quantities and notes for new items
             * ----------------------------------------------------------------------------------------------------------------------------------- */

            Map<String, Decimal> modelSkuToAvailableNewQty = new Map<String, Decimal>();
            Map<String, Decimal> modelSkuToRequestedNewQty = new Map<String, Decimal>();
            Map<String, String> modelSkuToRequestedNewNotes = new Map<String, String>();

            for (AggregateResult ar : [SELECT Plc_Model__r.Plc_ProductSku__c, SUM(Plc_RemainingQty__c)
                                       FROM Plc_PurchaseOrderItem__c
                                       WHERE Plc_Model__c IN :foundModelsSet AND
                                             Plc_PurchaseOrder__c != '' AND
                                             Plc_PurchaseOrder__r.Plc_Status__c = 'Open' 
                                       GROUP BY Plc_Model__r.Plc_ProductSku__c]) {

                modelSkuToAvailableNewQty.put((String)ar.get('Plc_ProductSku__c'), (Decimal)ar.get('expr0'));
            }

            //Only if a distribution list were found this section is executed. If no one was found it means that
            //there are not set values already
            if (distributionList.size() > 0 )  {
                for (AggregateResult ar : [SELECT Plc_DestinationWarehouse__c,
                                                  Plc_Product__r.Plc_ProductSku__c, SUM(Plc_RequestedQty__c)
                                           FROM Plc_DistributionListItem__c
                                           WHERE Plc_DistributionList__c = :distributionList.get(0).Id AND
                                                 Plc_PurchaseOrder__c != ''
                                           GROUP BY Plc_DestinationWarehouse__c,
                                                    Plc_Product__r.Plc_ProductSku__c]) {

                    modelSkuToRequestedNewQty.put('' + (String)ar.get('Plc_DestinationWarehouse__c') + 
                                                  (String)ar.get('Plc_ProductSku__c'), (Decimal)ar.get('expr0'));
                }

                for (AggregateResult ar : [SELECT Plc_DestinationWarehouse__c,
                                                  Plc_Product__r.Plc_ProductSku__c, Plc_Note__c
                                           FROM Plc_DistributionListItem__c
                                           WHERE Plc_DistributionList__c = :distributionList.get(0).Id AND
                                                 Plc_PurchaseOrder__c != ''
                                           GROUP BY Plc_DestinationWarehouse__c,
                                                    Plc_Product__r.Plc_ProductSku__c, Plc_Note__c]) {

                    modelSkuToRequestedNewNotes.put('' + (String)ar.get('Plc_DestinationWarehouse__c') + 
                                                    (String)ar.get('Plc_ProductSku__c'), (String)ar.get('Plc_Note__c'));
                }
            }

            /* END 
             * Getting requested and available quantities for new items
             * ----------------------------------------------------------------------------------------------------------------------------------- */

            /* START 
             * Evaluating products with available repaired items
             * ----------------------------------------------------------------------------------------------------------------------------------- */
            Map<String, List<WarehouseRepairedItemsRequestWrp>> productSkuToRepairedItemsMap = new Map<String, List<WarehouseRepairedItemsRequestWrp>>();
            Map<String, Decimal> modelSkuWarehouseToAvailableRepairedQty = new Map<String, Decimal>();
            //Getting the number of repaired items found in SF. Every repaired item is grouped by the warehouse (and the dealer)
            //and the SKU model identificator
            for (AggregateResult ar : [SELECT Bit2Shop__Warehouse_Id__c, Bit2Shop__Warehouse_Id__r.Name,
                                              Bit2Shop__Warehouse_Id__r.Bit2Shop__Dealer_Id__c DealerId,
                                              Bit2Shop__Warehouse_Id__r.Bit2Shop__Dealer_Id__r.Name DealerName,
                                              Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c, 
                                              Count(Id)
                                       FROM Bit2Shop__Stock_Serials2__c 
                                       WHERE Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__c IN :foundSolutionsSet AND
                                             Bit2Shop__Status__c = 'Repaired' AND 
                                             Bit2Shop__Warehouse_Id__r.Plc_Tipology__c = 'Repaired'
                                       GROUP BY Bit2Shop__Warehouse_Id__c, Bit2Shop__Warehouse_Id__r.Name,
                                                Bit2Shop__Warehouse_Id__r.Bit2Shop__Dealer_Id__c,
                                                Bit2Shop__Warehouse_Id__r.Bit2Shop__Dealer_Id__r.Name,
                                                Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c]) {

                //Creating the instance of the class that contains repaired items data for each warehouse
                WarehouseRepairedItemsRequestWrp whRepairedItems = new WarehouseRepairedItemsRequestWrp((String)ar.get('Bit2Shop__Warehouse_Id__c'), 
                                                                                                        (String)ar.get('Name'),
                                                                                                        (String)ar.get('DealerName'),
                                                                                                        (String)ar.get('DealerId'),
                                                                                                        (Integer)ar.get('expr0'),
                                                                                                        0);

                if (!productSkuToRepairedItemsMap.containsKey((String)ar.get('Plc_ProductSku__c'))) {
                    productSkuToRepairedItemsMap.put((String)ar.get('Plc_ProductSku__c'), new List<WarehouseRepairedItemsRequestWrp>());
                }
                //The following map will contain the list of repaired items data
                productSkuToRepairedItemsMap.get((String)ar.get('Plc_ProductSku__c')).add(whRepairedItems);
                modelSkuWarehouseToAvailableRepairedQty.put((String)ar.get('Bit2Shop__Warehouse_Id__c') + 
                                                            (String)ar.get('Plc_ProductSku__c'), 
                                                            (Integer)ar.get('expr0'));
            }
            /* END
             * Evaluating products with available repaired items
             * ----------------------------------------------------------------------------------------------------------------------------------- */

            /* START
             * Merging data into product wrappers
             * ----------------------------------------------------------------------------------------------------------------------------------- */
            for (String productId : productsMap.keySet()) {
                //After getting all related data to products a merge is needed. The following information will be included:
                // - Warehouse of new products
                // - Distribution list item data (therefore when users open the wizard, they will check saved information)
                String keySku = '' + productsMap.get(productId).PlcProductSku;
                String keySkuToWarehouse = '' +  productsMap.get(productId).Bit2ShopWarehouseId +
                                           productsMap.get(productId).PlcProductSku;
                String keyWarehousesNew = '' + productsMap.get(productId).PlcManufacturerId;

                //1) Setting available & saved repaired items
                //If the following map contains the calculated key, it means that for the given product were found 
                //available repaired items
                if (productSkuToRepairedItemsMap.containsKey(keySku)) {
                    for (WarehouseRepairedItemsRequestWrp whRepairedItemRequest : productSkuToRepairedItemsMap.get(keySku)) {

                        productsMap.get(productId).whRepairedItems = new List<WarehouseRepairedItemsRequestWrp>();
                        
                        WarehouseRepairedItemsRequestWrp whRepairedItemRequestClone = whRepairedItemRequest.clone();

                        String keyWarehousesRepaired = '' + productsMap.get(productId).Bit2ShopExternalCatalogItemId +
                                                       productsMap.get(productId).Bit2ShopWarehouseId + whRepairedItemRequest.Id;

                        productsMap.get(productId).numberOfRepaired += whRepairedItemRequestClone.availableQty;
                        //In addition, for each repaired items, there's could be a pending request. Therefore distribution list items are
                        //initialize
                        if (modelDestinationWarehouseToDistributionItem.containsKey(keyWarehousesRepaired)) {
                            whRepairedItemRequestClone.distributionListItemId = modelDestinationWarehouseToDistributionItem
                                                                          .get(keyWarehousesRepaired).Id;
                            whRepairedItemRequestClone.requestedQty = modelDestinationWarehouseToDistributionItem
                                                                      .get(keyWarehousesRepaired).Plc_RequestedQty__c;
                            whRepairedItemRequestClone.note = modelDestinationWarehouseToDistributionItem
                                                                      .get(keyWarehousesRepaired).Plc_Note__c;
                            productsMap.get(productId).repairedItems += modelDestinationWarehouseToDistributionItem
                                                                        .get(keyWarehousesRepaired).Plc_RequestedQty__c;
                            
                            productsMap.get(productId).whRepairedItems.add(whRepairedItemRequestClone);
                        } else {
                            productsMap.get(productId).whRepairedItems.add(whRepairedItemRequestClone);
                        }
                    }
                }

                //2) Setting warehouse and dealer of new products for the current product (calculated from the warehouses of the manufacturers)
                if (manufacturerToWarehouseOfNewItemsMap.containsKey(keyWarehousesNew)) {
                    productsMap.get(productId).warehouseNewProductsId = manufacturerToWarehouseOfNewItemsMap.get(keyWarehousesNew).Id;
                }
                
                //3) Setting available & saved new items quantities 
                if (modelSkuToAvailableNewQty.containsKey(keySku)) {
                    productsMap.get(productId).remainingQty = modelSkuToAvailableNewQty.get(keySku);
                    if (modelSkuToRequestedNewQty.containsKey(keySkuToWarehouse)) {
                        productsMap.get(productId).newItems = modelSkuToRequestedNewQty.get(keySkuToWarehouse);
                        if (modelSkuToRequestedNewNotes.containsKey(keySkuToWarehouse)) {
                            productsMap.get(productId).noteNew = modelSkuToRequestedNewNotes.get(keySkuToWarehouse);
                        }
                    }
                }

                if (productsMap.get(productId).repairedItems == 0 && productsMap.get(productId).remainingQty == 0) {
                    productsMap.remove(productId);
                }
            }
            /* END
             * Merging data into product wrappers
             * ----------------------------------------------------------------------------------------------------------------------------------- */

            response.put('whSolutionsMap', whSolutionsMap);
            response.put('warehousesMap', warehousesMap);
            response.put('dealersMap', dealersMap);
            response.put('productsMap', JSON.serialize(productsMap));
            response.put('modelSkuToAvailableNewQty', modelSkuToAvailableNewQty);
            response.put('modelSkuWarehouseToAvailableRepairedQty', modelSkuWarehouseToAvailableRepairedQty);
        } catch (Exception e) {
            response.put('error', true);
            response.put('errorMsg', '[ERR:CL-0130201] ' + e.getMessage());
        }
        return response;
    }

    /**
    * Method used to save distribution list
    *
    * @code 03
    * 
    * @param productSolutionAsString JSON representation of products on which user have been working on
    * @param distributionsListId Existing distribution list id (if defined, could be empty)
    *
    * 
    * @return Ok if everything goes well 
    */
    @AuraEnabled
    public static Map<String, Object> saveDistributionList(String productSolutionAsString, String distributionsListId) {

        Map<String, Object> response = new Map<String, Object>();
        response.put('error', false);
        Savepoint sp = Database.setSavepoint();
        
        try {
            //Parsing back list of products from client
            List<ProductSolutionWrp> productSolutionWrpList = (List<ProductSolutionWrp>)JSON.deserialize(productSolutionAsString, 
                                                                                                         List<ProductSolutionWrp>.class);
                
                List<Plc_DistributionListItem__c> distributionListItemsToUpsert = new List<Plc_DistributionListItem__c>();
                List<Plc_DistributionListItem__c> distributionListItemsToDelete = new List<Plc_DistributionListItem__c>();
                Plc_DistributionList__c distributionList = new Plc_DistributionList__c(Id = distributionsListId);
                Map<String, List<Plc_PurchaseOrderItem__c>> modelSkuToPurchaseOrderItems = new Map<String, List<Plc_PurchaseOrderItem__c>>();
                Map<String, List<Plc_DistributionListItem__c>> whModelSkuToDistributionListItems = new Map<String, List<Plc_DistributionListItem__c>>();

                //If distribution list id is empty a new one is created
                if (String.isBlank(distributionsListId)) {
                    distributionList.Id = null;
                    insert distributionList;
                } else {
                    List<Plc_DistributionList__c> distributionListLst = [SELECT Id, OwnerId
                                                                      FROM Plc_DistributionList__c
                                                                      WHERE Id = :distributionsListId
                                                                      LIMIT 1];

                    if (distributionListLst.size() > 0 && UserInfo.getUserId() != distributionListLst.get(0).OwnerId) { 
                        response.put('error', true);
                        response.put('errorMsg', Label.Plc_LightningComponentGoodsDistributionListCurrentUserOwnershipError);
                        return response;
                    }
                }

                response.put('distributionsListId', distributionList.Id);

                List<Bit2Shop__Dealer__c> dealersList = [SELECT Id
                                                         FROM Bit2Shop__Dealer__c
                                                         WHERE Plc_Alias__c = '000_001'];

                Bit2Shop__Dealer__c fakeDealer;

                if (dealersList.size() > 0) {
                    fakeDealer = dealersList.get(0);
                } else {
                    response.put('error', true);
                    response.put('errorMsg', Label.Plc_LightningComponentGoodsDistributionListMissingFakeDealerErrorMessage);
                    return response;
                }

                /* START
                 * Preparing data of existing available and requested new items
                 * ----------------------------------------------------------------------------------------------------------------------------------- */

                //Preparing all purchase order items in order to be matched with requests
                for (Plc_PurchaseOrderItem__c pi : [SELECT Plc_Model__r.Plc_ProductSku__c, Plc_RemainingQty__c,
                                                           Plc_PurchaseOrder__c, Plc_Quantity__c, Plc_OrderedQty__c 
                                                    FROM Plc_PurchaseOrderItem__c
                                                    WHERE Plc_PurchaseOrder__r.Plc_Status__c = 'Open' 
                                                    ORDER BY Plc_PurchaseOrder__r.Plc_StartDate__c ASC]) {

                    if (!modelSkuToPurchaseOrderItems.containsKey(pi.Plc_Model__r.Plc_ProductSku__c)) {
                        modelSkuToPurchaseOrderItems.put(pi.Plc_Model__r.Plc_ProductSku__c, 
                                                         new List<Plc_PurchaseOrderItem__c>());
                    }
                    modelSkuToPurchaseOrderItems.get(pi.Plc_Model__r.Plc_ProductSku__c).add(pi);
                }
                //Preparing all distribution list items in order to be update
                for (Plc_DistributionListItem__c dli : [SELECT Plc_DestinationWarehouse__c,
                                                               Plc_Product__r.Plc_ProductSku__c, Plc_RequestedQty__c
                                                        FROM Plc_DistributionListItem__c
                                                        WHERE Plc_DistributionList__c = :distributionList.Id AND 
                                                              Plc_PurchaseOrder__c != ''
                                                        ORDER BY Plc_PurchaseOrder__r.Plc_StartDate__c ASC]) {

                    String keySkuToWarehouse = '' +  dli.Plc_DestinationWarehouse__c +
                                               dli.Plc_Product__r.Plc_ProductSku__c;

                    if (!whModelSkuToDistributionListItems.containsKey(keySkuToWarehouse)) {
                        whModelSkuToDistributionListItems.put(keySkuToWarehouse, 
                                                              new List<Plc_DistributionListItem__c>());
                    }
                    whModelSkuToDistributionListItems.get(keySkuToWarehouse).add(dli);
                }

                System.debug(modelSkuToPurchaseOrderItems);
                System.debug(productSolutionWrpList);

                /* END
                 * Merging data into product wrappers
                 * ----------------------------------------------------------------------------------------------------------------------------------- */

                /* START
                 * Algorithm of saving/updating distribution list items according to data
                 * ----------------------------------------------------------------------------------------------------------------------------------- */

                for (ProductSolutionWrp productSolutionWrpItem : productSolutionWrpList) {
                    
                    String keySkuToWarehouse = '' +  productSolutionWrpItem.Bit2ShopWarehouseId +
                                               productSolutionWrpItem.PlcProductSku;
                    String keySku = '' + productSolutionWrpItem.PlcProductSku;
                    List<Integer> indexesToKeep = new List<Integer>();
                    Decimal residualQty = productSolutionWrpItem.newItems;
                    Integer distListItemIndex = 0;

                    //FIRST CHECK: part of new items
                    if (productSolutionWrpItem.newItems > 0) {
                        for (Integer index = 0; index < modelSkuToPurchaseOrderItems.get(keySku).size(); index++ ) {
                            
                            if (modelSkuToPurchaseOrderItems.get(keySku)[index].Plc_Quantity__c != 0) {

                                Decimal tempResidualQty = residualQty;

                                if (modelSkuToPurchaseOrderItems.get(keySku)[index].Plc_OrderedQty__c != null) {
                                    modelSkuToPurchaseOrderItems.get(keySku)[index].Plc_Quantity__c =
                                        modelSkuToPurchaseOrderItems.get(keySku)[index].Plc_Quantity__c - 
                                            modelSkuToPurchaseOrderItems.get(keySku)[index].Plc_OrderedQty__c;
                                }

                                residualQty -= modelSkuToPurchaseOrderItems.get(keySku)[index].Plc_Quantity__c;
                                //If residual quantity is greater than zero than it means that all the quantity of current purchase order
                                //item must be consumed.
                                if (residualQty > 0){
                                    //First case: check if a matching distribution list item ordered exists for current purchase order
                                    //(If data is correct ditribution list item is as ordered as referenced purchase order item). In this case 
                                    //update it
                                    System.debug(index);
                                    System.debug(whModelSkuToDistributionListItems.containsKey(keySkuToWarehouse));
                                    if (whModelSkuToDistributionListItems.containsKey(keySkuToWarehouse) &&
                                        whModelSkuToDistributionListItems.get(keySkuToWarehouse).size() > index) {
                                        whModelSkuToDistributionListItems.get(keySkuToWarehouse)[distListItemIndex].Plc_RequestedQty__c = 
                                            modelSkuToPurchaseOrderItems.get(keySku)[index].Plc_Quantity__c;
                                        System.debug(whModelSkuToDistributionListItems.get(keySkuToWarehouse)[distListItemIndex].Plc_RequestedQty__c);
                                        System.debug(modelSkuToPurchaseOrderItems.get(keySku)[index].Plc_Quantity__c);

                                        whModelSkuToDistributionListItems.get(keySkuToWarehouse)[distListItemIndex].Plc_Note__c = productSolutionWrpItem.noteNew;
                                        indexesToKeep.add(distListItemIndex);
                                        distributionListItemsToUpsert.add(whModelSkuToDistributionListItems.get(keySkuToWarehouse)[distListItemIndex]);
                                    } else {
                                        //otherwise create a new distribution list item
                                        distributionListItemsToUpsert.add(new Plc_DistributionListItem__c(
                                            Plc_DistributionList__c = distributionList.Id,
                                            Plc_DestinationWarehouse__c = productSolutionWrpItem.Bit2ShopWarehouseId,
                                            Plc_OriginDealer__c = fakeDealer.Id,
                                            Plc_Product__c = productSolutionWrpItem.Bit2ShopExternalCatalogItemId,
                                            Plc_PurchaseOrder__c = modelSkuToPurchaseOrderItems.get(keySku)[index].Plc_PurchaseOrder__c,
                                            Plc_OriginWarehouse__c = productSolutionWrpItem.warehouseNewProductsId,
                                            Plc_RequestedQty__c = modelSkuToPurchaseOrderItems.get(keySku)[index].Plc_Quantity__c,
                                            Plc_Note__c = productSolutionWrpItem.noteNew,
                                            Plc_Status__c = 'Draft'
                                        ));
                                    }

                                    modelSkuToPurchaseOrderItems.get(keySku)[index].Plc_Quantity__c = 0;
                                    
                                } else {
                                    //In the final step the residual quantity is less than zero, it means that not all current purchase order item
                                    //quantity is consumed. The cases are equals to prior ones

                                    if (whModelSkuToDistributionListItems.containsKey(keySkuToWarehouse) &&
                                        whModelSkuToDistributionListItems.get(keySkuToWarehouse).size() > index) {
                                        whModelSkuToDistributionListItems.get(keySkuToWarehouse)[distListItemIndex].Plc_RequestedQty__c = tempResidualQty;
                                        whModelSkuToDistributionListItems.get(keySkuToWarehouse)[distListItemIndex].Plc_Note__c = productSolutionWrpItem.noteNew;
                                        distributionListItemsToUpsert.add(whModelSkuToDistributionListItems.get(keySkuToWarehouse)[distListItemIndex]);
                                        indexesToKeep.add(distListItemIndex);
                                    } else {
                                        distributionListItemsToUpsert.add(new Plc_DistributionListItem__c(
                                            Plc_DistributionList__c = distributionList.Id,
                                            Plc_DestinationWarehouse__c =  productSolutionWrpItem.Bit2ShopWarehouseId,
                                            Plc_OriginDealer__c = fakeDealer.Id,
                                            Plc_Product__c = productSolutionWrpItem.Bit2ShopExternalCatalogItemId,
                                            Plc_PurchaseOrder__c = modelSkuToPurchaseOrderItems.get(keySku)[index].Plc_PurchaseOrder__c, 
                                            Plc_OriginWarehouse__c = productSolutionWrpItem.warehouseNewProductsId,
                                            Plc_RequestedQty__c = tempResidualQty,
                                            Plc_Note__c = productSolutionWrpItem.noteNew,
                                            Plc_Status__c = 'Draft'
                                        ));
                                    }

                                    modelSkuToPurchaseOrderItems.get(keySku)[index].Plc_Quantity__c -= tempResidualQty;
                                    //At the end, distribution list item on which we have been working on must be kept. In order to do that
                                    //they are removed to the list of found distribution list items
                                    for (Integer i = indexesToKeep.size() - 1; i >= 0; i--) {
                                        whModelSkuToDistributionListItems.get(keySkuToWarehouse).remove(indexesToKeep[i]);
                                    }

                                    //At the end go out of the for cycle
                                    break;
                                }
                                distListItemIndex ++;
                            }
                        }
                    } 

                    //At the end delete all related distribution list items that were not used
                    if (whModelSkuToDistributionListItems.containsKey(keySkuToWarehouse)) {
                        distributionListItemsToDelete.addAll(whModelSkuToDistributionListItems.get(keySkuToWarehouse));
                    }
                
                    //SECOND CHECK: part of repaired items
                    if (productSolutionWrpItem.whRepairedItems != null) {
                        for (WarehouseRepairedItemsRequestWrp whRepairedItemsRequest : productSolutionWrpItem.whRepairedItems ) {
                            //If the quantity is greater than zero then upsert distribution list item
                            if (whRepairedItemsRequest.requestedQty > 0) {
                                distributionListItemsToUpsert.add(new Plc_DistributionListItem__c(
                                    Id = whRepairedItemsRequest.distributionListItemId,
                                    Plc_DistributionList__c = distributionList.Id,
                                    Plc_DestinationWarehouse__c =  productSolutionWrpItem.Bit2ShopWarehouseId,
                                    Plc_Product__c = productSolutionWrpItem.Bit2ShopExternalCatalogItemId,
                                    //Plc_OriginDealer__c = whRepairedItemsRequest.dealerId,
                                    //Added 28-01-2019
                                    Plc_OriginDealer__c = fakeDealer.Id,
                                    Plc_OriginWarehouse__c = whRepairedItemsRequest.id,
                                    Plc_RequestedQty__c = whRepairedItemsRequest.requestedQty,
                                    Plc_Note__c = whRepairedItemsRequest.note,
                                    Plc_Status__c = 'Draft'
                                ));
                            } else {
                                //Otherwise, items whose requested repaired quantity is zero (if there are any related distribution list items)
                                //are deleted  
                                if (String.isNotBlank(whRepairedItemsRequest.distributionListItemId)) {
                                    distributionListItemsToDelete.add(new Plc_DistributionListItem__c(Id = whRepairedItemsRequest.distributionListItemId));
                                }
                            }
                        }
                    }
                }

                /* END
                 * Algorithm of saving/updating distribution list items according to data
                 * ----------------------------------------------------------------------------------------------------------------------------------- */

                try {
                    //Trying to upsert distribution list items. If some errors happens it means that data is no longer available 
                    upsert distributionListItemsToUpsert;
                    delete distributionListItemsToDelete;
                } catch (Exception e) {
                    response.put('error', true);
                    response.put('errorMsg', Label.Plc_LightningComponentGoodsDistributionListMissingRecordsErrorMessage);
                }
                

        } catch (Exception e) {
            response.put('error', true);
            //TODO Custom label
            response.put('errorMsg','[ERR:CL-0130301] ' + e.getMessage());
            //Rolling database to previous state in order to delete inserted items
            Database.rollback(sp);
        }

        return response;
    }

    /**
    * Method used to change ownership of distribution list and its items to current user
    *
    * @code 04
    *
    * @param distributionsListId Distribution list whose owner is changed
    * 
    * @return Ok if everything goes well 
    */
    @AuraEnabled
    public static Map<String, Object> changeDistributionListOwner(String distributionsListId) {

        Map<String, Object> response = new Map<String, Object>();
        response.put('error', false);
        
        try {
            Plc_DistributionList__c distributionList = new Plc_DistributionList__c(Id = distributionsListId);
            distributionList.OwnerId = UserInfo.getUserId();
            
            update distributionList;

        } catch (Exception e) {
            response.put('error', true);
            response.put('errorMsg', '[ERR:CL-0130401] ' + e.getMessage());
        }

        return response;
    }

    /**
    * Method used to retrieve current available models for given warehouse solutions
    *
    * @code 05
    * 
    * @param whSolutionId Warehuouse solution from which retrieve available models
    * 
    * @return Ok if everything goes well 
    */
    @AuraEnabled
    public static Map<String, Object> retrieveAvailableModels(String whSolutionId) {

        Map<String, Object> response = new Map<String, Object>();
        response.put('error', false);
        try {

            List<Plc_WarehouseSolution__c> whSolutions = [SELECT Id, Plc_Solution__c, Plc_Warehouse__c
                                                          FROM Plc_WarehouseSolution__c
                                                          WHERE Id = :whSolutionId];

            if (whSolutions.size() > 0) {

                Set<String> modelIdsFoundSet = new Set<String>();
                //Looking for products which are in the warehouse already
                for (Bit2Shop__Product_Stock__c ps : [SELECT Id, Bit2Shop__External_Catalog_Item_Id__c
                                                      FROM Bit2Shop__Product_Stock__c
                                                      WHERE Bit2Shop__Warehouse_Id__c = :whSolutions.get(0).Plc_Warehouse__c AND
                                                            Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__c = :whSolutions.get(0).Plc_Solution__c]) {
                    modelIdsFoundSet.add(ps.Bit2Shop__External_Catalog_Item_Id__c);
                }

                List<B2WExtCat__External_Catalog_Item__c> availableModels = [SELECT Id, Plc_ProductSku__c,
                                                                                    B2WExtCat__External_Catalog_Item_Name__c
                                                                            FROM B2WExtCat__External_Catalog_Item__c
                                                                            WHERE Plc_Solution__c = :whSolutions.get(0).Plc_Solution__c AND
                                                                                  Id NOT IN :modelIdsFoundSet];
                response.put('availableModels', availableModels);

            } 

        } catch (Exception e) {
            response.put('error', true);
            response.put('errorMsg', '[ERR:CL-0130501] ' + e.getMessage());
        }

        return response;
    }

    /**
    * Method used to create a product stock in given warehouse for specified model
    *
    * @code 06
    * 
    * @param modelId Model Id from which creating a new product stock
    * @param warehouseId Warehouse that will contain the product
    * @param dealerId Dealer of the warehouse that will contain the product
    * 
    * @return Ok if everything goes well 
    */
    @AuraEnabled
    public static Map<String, Object> createNewProductStock(String modelId, String warehouseId, String dealerId) {

        Map<String, Object> response = new Map<String, Object>();
        response.put('error', false);

        try {

            List<Bit2Shop__Reference_Period__c> referencePeriodsList = [SELECT Id 
                                                                        FROM Bit2Shop__Reference_Period__c
                                                                        WHERE Bit2Shop__Dealer_Id__c = :dealerId AND
                                                                              Bit2Shop__Status__c = 'Current'
                                                                        ORDER BY Bit2Shop__Start_Date__c ASC];

            List<B2WExtCat__External_Catalog_Item__c> modelsList = [SELECT Id, B2WExtCat__External_Catalog_Item_Name__c
                                                                    FROM B2WExtCat__External_Catalog_Item__c
                                                                    WHERE Id = :modelId];

            Bit2Shop__Product_Stock__c newProductStock = new Bit2Shop__Product_Stock__c();
            newProductStock.Bit2Shop__External_Catalog_Item_Id__c = modelId;
            newProductStock.Bit2Shop__Warehouse_Id__c = warehouseId;
            newProductStock.Bit2Shop__Inventory_Level__c = 'New';

            if (referencePeriodsList.size() > 0) {
                newProductStock.Bit2Shop__Inventory_Period__c = referencePeriodsList.get(0).Id;
            }

            if (modelsList.size() > 0) {
                newProductStock.Name = modelsList.get(0).B2WExtCat__External_Catalog_Item_Name__c;
            }

            insert newProductStock;

        } catch (Exception e) {
            response.put('error', true);
            response.put('errorMsg', '[ERR:CL-0130601] ' + e.getMessage());
        }

        return response;
    }

    /**
     * Wrapper class for products with additional information
     */
    class ProductSolutionWrp {
        //Bit2Shop__Product_Stock__c productStock;
        String warehouseSolutionId;
        Decimal remainingQty;
        String warehouseNewProductsId;
        Decimal numberOfRepaired;
        Decimal newItems;
        Decimal repairedItems;
        String noteNew;
        /****/
        String Name;
        String PlcProductSku;
        String PlcManufacturer;
        Decimal PlcAvailableQty;
        Decimal PlcOrderedQty;
        Decimal PlcMinimumStock;
        String Bit2ShopWarehouseId;
        String Bit2ShopExternalCatalogItemId;
        String PlcManufacturerId;
        /***/
        List<WarehouseRepairedItemsRequestWrp> whRepairedItems;

        public ProductSolutionWrp(String Name, String PlcProductSku, String PlcManufacturer,
                                  Decimal PlcAvailableQty, Decimal Plc_OrderedQty, Decimal PlcMinimumStock, 
                                  String Bit2ShopWarehouseId, String Bit2ShopExternalCatalogItemId,
                                  String PlcManufacturerId,
                                  String warehouseSolutionId) {
            /*****/
            this.Name = Name; 
            this.PlcProductSku = PlcProductSku; 
            this.PlcManufacturer = PlcManufacturer; 
            this.PlcAvailableQty = PlcAvailableQty; 
            this.PlcOrderedQty = PlcOrderedQty; 
            this.PlcMinimumStock = PlcMinimumStock; 
            this.Bit2ShopWarehouseId = Bit2ShopWarehouseId;
            this.Bit2ShopExternalCatalogItemId = Bit2ShopExternalCatalogItemId;
            this.PlcManufacturerId = PlcManufacturerId;
            /*****/ 
            //this.productStock = productStock;
            this.warehouseSolutionId = warehouseSolutionId;
            this.remainingQty = 0;
            this.numberOfRepaired = 0;
            this.newItems = 0;
            this.repairedItems = 0;
        }
    }

    /**
     * Wrapper class for repaired items warehouse with related information
     */
    class WarehouseRepairedItemsRequestWrp {
        String id;
        String name;
        String dealerName;
        String dealerId;
        Decimal availableQty;
        Decimal requestedQty;
        String distributionListItemId;
        String note;

        public WarehouseRepairedItemsRequestWrp(String id, String name, String dealerName,
                                                String dealerId, Decimal availableQty, 
                                                Integer requestedQty) {
            this.id = id;
            this.name = name;
            this.dealerName = dealerName;
            this.dealerId = dealerId;
            this.availableQty = availableQty;
            this.requestedQty = requestedQty;
        }
    }
}