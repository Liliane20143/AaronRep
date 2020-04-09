/**
    * @Giampaolo Mei
    * @date 30/01/2019
    * @description Controller componente lightning Plc_GoodsHandling
 */

public without sharing class Plc_GoodsHandlingCnt {
    /**
    * @Giampaolo Mei
    * @date 30/01/2019
    * @description Initialize lightning component
    * @Param DealerId context record (Dealer Id)
    * @Return Map<String, Object> containing wrapper data to initialize lightning component
    */
    @AuraEnabled
    public static Map<String, Object> initComponent(String dealerId) {
        System.debug('Plc_GoodsHandlingCnt initComponent start');
        Map<String, Object> result = new Map<String, Object>();

        //recupero il dealer
        Bit2Shop__Dealer__c dealer = [SELECT Id, Name, Plc_Maintainer__c, Plc_Manufacturer__c, Plc_Repairer__c, Plc_Scrapyard__c FROM Bit2Shop__Dealer__c WHERE Id = :DealerId];
        result.put('dealer', dealer);
        String type = 'Bit2Shop__Dealer__c';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(type);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        List<String> dealerType = new List<String>();
        if (dealer.Plc_Maintainer__c) dealerType.add(fieldMap.get('Plc_Maintainer__c').getDescribe().getName());
        if (dealer.Plc_Manufacturer__c) dealerType.add(fieldMap.get('Plc_Manufacturer__c').getDescribe().getName());
        if (dealer.Plc_Repairer__c) dealerType.add(fieldMap.get('Plc_Repairer__c').getDescribe().getName());

        /** [START MOD 18/02/2019 18:04]@Author:marco.lebellini@/webresults.it @Description: **/
        if (dealer.Plc_Scrapyard__c) dealerType.add(fieldMap.get('Plc_Scrapyard__c').getDescribe().getName());
        /** [END MOD 18/02/2019 18:04]@Author:marco.lebellini@/webresults.it @Description: **/

        System.debug('Plc_GoodsHandlingCnt initComponent dealerType: ' + dealerType);

        //recupero il profilo dello user
        String userProfile = [SELECT Name FROM Profile WHERE Id = :userinfo.getProfileId()].Name;
        System.debug('Plc_GoodsHandlingCnt initComponent userProfile: ' + userProfile);
        String queryString = 'SELECT Id, Name, Plc_AvailableForProfiles__c,Plc_FilterOriginDealer__c, Plc_FilterDestinationDealer__c, Plc_FilterOriginWarehouse__c, Plc_FilterDestinationWarehouse__c, Bit2Shop__Transfer_Type__c, Plc_FilterSerialStatus__c, Bit2Shop__Code__c FROM Bit2Shop__TransferDetail__c WHERE (Plc_FilterOriginDealer__c = null OR Plc_FilterOriginDealer__c IN: dealerType) AND Plc_IsVisibleFromWizard__c = true';
        //if (userProfile != 'System Administrator' && userProfile != 'Amministratore del sistema') {
        if(!FeatureManagement.checkPermission(Plc_Constants.CustomPermission.Plc_HandleAllTransferDetails)) {
            queryString += ' AND (Plc_AvailableForProfiles__c = null OR Plc_AvailableForProfiles__c INCLUDES (:userProfile))';
        }
        queryString += ' ORDER BY Name';
        System.debug('Plc_GoodsHandlingCnt initComponent transferDetails: ' + queryString);

        List<Bit2Shop__TransferDetail__c> transferDetails = Database.query(queryString);
        System.debug('Plc_GoodsHandlingCnt initComponent transferDetails: ' + transferDetails);
        result.put('transferDetails', transferDetails);


        return result;
    }

    /**
    * @Giampaolo Mei
    * @date 31/01/2019
    * @description It Retrieves the warehouse related to dealer
    * @Param DealerId context record (Dealer Id)
    * @Param origin type of origin warehouse
    * @Return List<Bit2Shop__Warehouse__c> dealer's warehouse
    */
    @AuraEnabled
    public static List<Bit2Shop__Warehouse__c> selectOrigin(String dealerId, String origin) {
        System.debug('Plc_GoodsHandlingCnt selectOrigin start');
        //recupero tutti i warehouse del dealer
        Set<String> filter = new Set<String>();
        String queryString = 'SELECT Id, Name, Bit2Shop__Dealer_Id__c, Bit2Shop__Dealer_Id__r.Bit2Shop__Account_Id__c, Bit2Shop__Dealer_Id__r.OwnerId, Plc_LogisticDivision__c, Plc_Property__c FROM Bit2Shop__Warehouse__c WHERE Bit2Shop__Dealer_Id__c = ' + '\''  + String.escapeSingleQuotes(dealerId) + '\'';
        if (origin != null && origin != '') {
            System.debug('Plc_GoodsHandlingCnt selectOrigin origin: ' + origin);
            filter.addAll(origin.split(';'));
            queryString += ' AND Plc_Tipology__c IN: filter';
        }
        queryString += ' ORDER BY Name';
        System.debug('Plc_GoodsHandlingCnt queryString: ' + queryString);
        List<Bit2Shop__Warehouse__c> wareHouse = Database.query(queryString);

        return wareHouse;
    }

    /**
    * @Giampaolo Mei
    * @date 31/01/2019
    * @description It Retrieves the destination dealer
    * @Param filterDestinationDealer Type of dealer
    * @Return List<Bit2Shop__Dealer__c> destination dealers
    */
    @AuraEnabled
    public static List<Bit2Shop__Dealer__c> selectDestinationDealer(String filterDestinationDealer, String tranferDetailId, String originWarehouseId) {
        System.debug('Plc_GoodsHandlingCnt selectDestinationDealer start');

        List<String> destinationDealerHolder = new List<String>();
        List<Bit2Shop__Dealer__c> destinationDealer = new List<Bit2Shop__Dealer__c>();

        Set<String> filter = new Set<String>();
        String queryString = 'SELECT Id, Name FROM Bit2Shop__Dealer__c';
        if (filterDestinationDealer != null && filterDestinationDealer != '') {
            System.debug('Plc_GoodsHandlingCnt selectDestinationDealer filterDestinationDealer: ' + filterDestinationDealer);
            filter.addAll(filterDestinationDealer.split(';'));
            String type = 'Bit2Shop__Dealer__c';
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType leadSchema = schemaMap.get(type);
            Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
            String maintainer = fieldMap.get('Plc_Maintainer__c').getDescribe().getName();
            String manufacturer = fieldMap.get('Plc_Manufacturer__c').getDescribe().getName();
            String repairer = fieldMap.get('Plc_Repairer__c').getDescribe().getName();
            /** [START MOD 18/02/2019 18:04]@Author:marco.lebellini@/webresults.it @Description: **/
            String scrapyard = fieldMap.get('Plc_Scrapyard__c').getDescribe().getName();
            /** [END MOD 18/02/2019 18:04]@Author:marco.lebellini@/webresults.it @Description: **/
            Boolean Finded = false;
            for (String st : filter) {
                if (st == maintainer) {
                    if (Finded == false) {
                        queryString += ' WHERE Plc_Maintainer__c = true';
                        Finded = true;
                    } else {
                        queryString += ' OR Plc_Maintainer__c = true';
                    }
                }
                if (st == manufacturer) {
                    if (Finded == false) {
                        queryString += ' WHERE Plc_Manufacturer__c = true';
                        Finded = true;
                    } else {
                        queryString += ' OR Plc_Manufacturer__c = true';
                    }
                }
                if (st == repairer) {
                    if (Finded == false) {
                        queryString += ' WHERE Plc_Repairer__c = true';
                        Finded = true;
                    } else {
                        queryString += ' OR Plc_Repairer__c = true';
                    }
                }
                /** [START MOD 18/02/2019 18:03]@Author:marco.lebellini@/webresults.it @Description: **/
                if (st == scrapyard) {
                    if (Finded == false) {
                        queryString += ' WHERE Plc_Scrapyard__c = true';
                        Finded = true;
                    } else {
                        queryString += ' OR Plc_Scrapyard__c = true';
                    }
                }
                /** [END MOD 18/02/2019 18:03]@Author:marco.lebellini@/webresults.it @Description: **/
            }


            /** [START MOD 19/02/2019 17:34]@Author:nunzio.capasso@/webresults.it @Description: fix NEXIPLC-364 **/
            List<Bit2Shop__TransferDetail__c> transferDetail = [
                    SELECT Plc_FilterDestinationDealer__c,
                            Plc_FilterDestinationWarehouse__c,
                            Bit2Shop__Code__c
                    FROM Bit2Shop__TransferDetail__c
                    WHERE Id = :tranferDetailId
            ];

            List<String> whType = new List<String>();

            if (String.isEmpty(transferDetail[0].Plc_FilterDestinationDealer__c)) {
                whType.addAll(transferDetail[0].Plc_FilterDestinationWarehouse__c.split(';'));
            } else {
                whType.addAll(transferDetail[0].Plc_FilterDestinationDealer__c.split(';'));
            }


            List<Bit2Shop__Warehouse__c> warehouse = [
                    SELECT Bit2Shop__Dealer_Id__c
                    FROM Bit2Shop__Warehouse__c
                    WHERE Plc_Tipology__c IN :whType
            ];

            List<String> dealers = new List<String>();

            for (Bit2Shop__Warehouse__c wh : warehouse) {
                dealers.add(wh.Bit2Shop__Dealer_Id__c);
            }



            /** [START MOD 21/02/2019 10:43]@Author:nunzio.capasso@/webresults.it @Description:NEXIPLC-388 **/
            String code = transferDetail[0].Bit2Shop__Code__c;

            if (code == 'SPOS_DL' || code == 'SPOS_DL_S2OS' || code == 'SPOS_DL_MATRDISP_S2S'
                    || code == 'SPOS_DL_MATRDISP_S2OS' || code == 'SPOS_DL_MATRDISP' || code == 'SPOS_PRO'
                    || code == 'SPOS_PRO_S2OS' || code == 'SPOS_PRO_MATRDISP_S2S'
                    || code == 'SPOS_PRO_MATRDISP_S2OS' || code == 'SPOS_PRO_MATRDISP') {


                List<Bit2Shop__Warehouse__c> originWarehouse = [
                        SELECT Id,
                                Name,
                                Bit2Shop__Dealer_Id__c,
                                Plc_LogisticDivision__c,
                                Plc_Property__c
                        FROM Bit2Shop__Warehouse__c
                        WHERE Id = :originWarehouseId
                ];
                System.debug('##########originWarehouse ' + originWarehouse);
                String logisticDivision = originWarehouse[0].Plc_LogisticDivision__c;
                String property = originWarehouse[0].Plc_Property__c;


                if (Finded) {
                    destinationDealer = Database.query(queryString);

                    if (!destinationDealer.isEmpty()) {

                        for (Bit2Shop__Dealer__c deal : destinationDealer) {
                            destinationDealerHolder.add(deal.Id);
                        }

                    } else {
                        destinationDealerHolder.addAll(dealers);
                    }
                }

                String queryStringWarehouse = 'SELECT Id, Name, Bit2Shop__Dealer_Id__c, Plc_LogisticDivision__c, Plc_Property__c FROM Bit2Shop__Warehouse__c WHERE Bit2Shop__Dealer_Id__c IN :destinationDealerHolder';

                if (code == 'SPOS_DL' || code == 'SPOS_DL_S2OS' || code == 'SPOS_DL_MATRDISP_S2S' || code == 'SPOS_DL_MATRDISP_S2OS' || code == 'SPOS_DL_MATRDISP') {
                    queryStringWarehouse += ' AND Plc_LogisticDivision__c !=: logisticDivision';
                }
                if (code == 'SPOS_PRO' || code == 'SPOS_PRO_S2OS' || code == 'SPOS_PRO_MATRDISP_S2S' || code == 'SPOS_PRO_MATRDISP_S2OS' || code == 'SPOS_PRO_MATRDISP') {
                    queryStringWarehouse += ' AND Plc_LogisticDivision__c !=: logisticDivision AND Plc_Property__c !=: property';
                }

                List<Bit2Shop__Warehouse__c> destinationWarehouse = Database.query(queryStringWarehouse);
                List<String>destinationDealerList = new List<String>();

                for (Bit2Shop__Warehouse__c wh : destinationWarehouse) {
                    destinationDealerList.add(wh.Bit2Shop__Dealer_Id__c);
                }

                if (!Finded) {
                    queryString += ' where id in :destinationDealerList ';
                    Finded = true;
                } else {
                    queryString += ' AND id in :destinationDealerList ';
                }
            }
            /** [END MOD 21/02/2019 10:43]@Author:nunzio.capasso@/webresults.it @Description:NEXIPLC-388 **/

            else if (!Finded) {
                queryString += ' where id in :dealers ';
            }
            /** [END MOD 19/02/2019 17:34]@Author:nunzio.capasso@/webresults.it @Description: fix NEXIPLC-364**/
            /**START** @giampaolo.mei@webresults.it-@Modification date  27/02/2019 13:20-@description: aggiunto else per tag WHERE **START**/
            queryString += ' AND RecordTypeId = \'' + Schema.SObjectType.Bit2Shop__Dealer__c.getRecordTypeInfosByDeveloperName().get('Plc_ChildDealer').getRecordTypeId() + '\'';
        }else{

            //START FIX [#20190225AL] - 25 feb 2019 15:50 - Andrea Liverani (WR) - andrea.liverani@webresults.it
            queryString += ' WHERE RecordTypeId = \'' + Schema.SObjectType.Bit2Shop__Dealer__c.getRecordTypeInfosByDeveloperName().get('Plc_ChildDealer').getRecordTypeId() + '\'';
            //END FIX [#20190225AL] - 25 feb 2019 15:50 - Andrea Liverani (WR) - andrea.liverani@webresults.it
        }
            /**END**   @giampaolo.mei@webresults.it-@Modification date  27/02/2019 13:21 **END**/

        queryString += ' ORDER BY Name';
        System.debug('Plc_GoodsHandlingCnt queryString: ' + queryString);
        destinationDealer = Database.query(queryString);
        return destinationDealer;
    }


    /**
    * @Giampaolo Mei
    * @date 31/01/2019
    * @description It Retrieves the destination dealer
    * @Param filterDestinationWarehouse Type of warehouse
    * @Param dealerId Id of dealer related to warehouse
    * @Return List<Bit2Shop__Warehouse__c> destination warehouse
    */
    @AuraEnabled
    public static List<Bit2Shop__Warehouse__c> selectDestinationWarehouse(String filterDestinationWarehouse, String dealerId, String code, String logisticDivision, String property) {
        System.debug('Plc_GoodsHandlingCnt selectDestinationWarehouse start');
        System.debug('Plc_GoodsHandlingCnt selectDestinationWarehouse dealerId: ' + dealerId);
        System.debug('Plc_GoodsHandlingCnt selectDestinationWarehouse code: ' + code);
        System.debug('Plc_GoodsHandlingCnt selectDestinationWarehouse logisticDivision: ' + logisticDivision);
        System.debug('Plc_GoodsHandlingCnt selectDestinationWarehouse property: ' + property);
        Set<String> filter = new Set<String>();
        String queryString = 'SELECT Id, Name, Bit2Shop__Dealer_Id__c, Plc_LogisticDivision__c, Plc_Property__c FROM Bit2Shop__Warehouse__c WHERE Bit2Shop__Dealer_Id__c = ' + '\''  + String.escapeSingleQuotes(dealerId) + '\'';
        if (filterDestinationWarehouse != null && filterDestinationWarehouse != '') {
            System.debug('Plc_GoodsHandlingCnt selectOrigin filterDestinationWarehouse: ' + filterDestinationWarehouse);
            filter.addAll(filterDestinationWarehouse.split(';'));
            queryString += ' AND Plc_Tipology__c IN: filter';
        }
        if (code != null && code != '') {
            if (code == 'SPOS' || code == 'SPO_S2OS' || code == 'SPOS_MATRDISP_S2S' || code == 'SPOS_MATRDISP_S2OS') {
                queryString += ' AND Plc_LogisticDivision__c =: logisticDivision';
            }
            if (code == 'SPOS_DL' || code == 'SPOS_DL_S2OS' || code == 'SPOS_DL_MATRDISP_S2S' || code == 'SPOS_DL_MATRDISP_S2OS'
                    /** [START MOD 21/02/2019 10:43]@Author:nunzio.capasso@/webresults.it @Description:NEXIPLC-388 **/
                    || code == 'SPOS_PRO_MATRDISP') {
                /** [END MOD 21/02/2019 10:43]@Author:nunzio.capasso@/webresults.it @Description:NEXIPLC-388 **/
                queryString += ' AND Plc_LogisticDivision__c !=: logisticDivision';
            }
            if (code == 'SPOS_PRO' || code == 'SPOS_PRO_S2OS' || code == 'SPOS_PRO_MATRDISP_S2S' || code == 'SPOS_PRO_MATRDISP_S2OS'
                    /** [START MOD 21/02/2019 10:43]@Author:nunzio.capasso@/webresults.it @Description:NEXIPLC-388 **/
                    || code == 'SPOS_PRO_MATRDISP') {
                /** [END MOD 21/02/2019 10:43]@Author:nunzio.capasso@/webresults.it @Description:NEXIPLC-388 **/
                queryString += ' AND Plc_LogisticDivision__c !=: logisticDivision AND Plc_Property__c !=: property';
            }
        }
        queryString += ' ORDER BY Name';
        System.debug('Plc_GoodsHandlingCnt queryString: ' + queryString);
        List<Bit2Shop__Warehouse__c> wareHouse = Database.query(queryString);
        System.debug('Plc_GoodsHandlingCnt selectDestinationWarehouse wareHouse: ' + wareHouse);
        return wareHouse;
    }

    /**
    * @Giampaolo Mei
    * @date 06/02/2019
    * @description Create Stock order and objects related
    * @Param transferDetail Status of serial product
    * @Param originWarehouse warehouse of product
    * @Param destinationWarehouse warehouse of product
    * @Return Map<String, Object> Serial and quantity type products retrieved
    */
    @AuraEnabled
    public static Id save(Bit2Shop__TransferDetail__c transferDetail, Bit2Shop__Warehouse__c originWarehouse, Bit2Shop__Warehouse__c destinationWarehouse, List<Bit2Shop__Stock_Serials2__c> selectedProductSerial, List<Bit2Shop__Product_Stock__c> selectedProductQuantity, String note) {
        System.debug('#### [time] START: ' + System.Datetime.now());
        System.debug('Plc_GoodsHandlingCnt save start');
        System.debug('Plc_GoodsHandlingCnt transferDetail: ' + transferDetail);
        System.debug('Plc_GoodsHandlingCnt originWarehouse: ' + originWarehouse);
        System.debug('Plc_GoodsHandlingCnt destinationWarehouse: ' + destinationWarehouse);
        System.debug('Plc_GoodsHandlingCnt selectedProductSerial: ' + selectedProductSerial);
        System.debug('Plc_GoodsHandlingCnt selectedProductQuantity: ' + selectedProductQuantity);
        System.debug('Plc_GoodsHandlingCnt note: ' + note);

        //Stock Order
        Bit2Shop__StockOrder__c stockOrderToCreate = new Bit2Shop__StockOrder__c();
        stockOrderToCreate.Bit2Shop__Status__c = Plc_WorkOrderApxAct.STOCK_ORDER_STATUS_GENERATED;
        stockOrderToCreate.Bit2Shop__Destination_Warehouse_Id__c = destinationWarehouse.Id;
        stockOrderToCreate.Bit2Shop__Warehouse_Id__c = originWarehouse.Id;
        stockOrderToCreate.Bit2Shop__Transfer_Type__c = transferDetail.Bit2Shop__Transfer_Type__c;
        stockOrderToCreate.Plc_TransferDetail__c = transferDetail.Id;
        stockOrderToCreate.Bit2Shop__Point_Of_Sales_Id__c = originWarehouse.Bit2Shop__Dealer_Id__c;
        stockOrderToCreate.Bit2Shop__Holding_Id__c = originWarehouse.Bit2Shop__Dealer_Id__r.Bit2Shop__Account_Id__c;
        stockOrderToCreate.Bit2Shop__Destination_Point_Of_Sales_Id__c = destinationWarehouse.Bit2Shop__Dealer_Id__c;

        //START FIX [#20190326AL] - 26 mar 2019 15:12 - Andrea Liverani (WR) - andrea.liverani@webresults.it - NEXIPLC-496
        List<Bit2Shop__Dealer_User__c > dealerUserList = [SELECT Id, Bit2Shop__User_Id__c  FROM Bit2Shop__Dealer_User__c WHERE Bit2Shop__Dealer_Id__c =:originWarehouse.Bit2Shop__Dealer_Id__c];
        String currentUserId = UserInfo.getUserId();
        Boolean containsUserId = false;

        if(!dealerUserList.isEmpty()) {
            for(Bit2Shop__Dealer_User__c dealerUser : dealerUserList) {
                if(dealerUser.Bit2Shop__User_Id__c == currentUserId) {
                    containsUserId = true;
                    continue;
                }
            }
        }

        if(currentUserId != originWarehouse.Bit2Shop__Dealer_Id__r.OwnerId && !containsUserId) {
            stockOrderToCreate.OwnerId = originWarehouse.Bit2Shop__Dealer_Id__r.OwnerId;
        } else {
            stockOrderToCreate.OwnerId = currentUserId;
        }

        //stockOrderToCreate.OwnerId = originWarehouse.Bit2Shop__Dealer_Id__r.OwnerId;
        //END FIX [#20190326AL] - 26 mar 2019 15:12 - Andrea Liverani (WR) - andrea.liverani@webresults.it - NEXIPLC-496

        stockOrderToCreate.RecordtypeId = Plc_Utils.getRecordTypeId(Plc_WorkOrderApxAct.STOCK_ORDER_RECORDTYPE_TRANSFER,
                Bit2Shop__StockOrder__c.SObjectType.getDescribe().name);
        if (note != null) {
            stockOrderToCreate.Bit2Shop__Note__c = note;
        }
        insert stockOrderToCreate;

        //Configuration
        NE__Order__c configurationToCreate = new NE__Order__c(
                RecordTypeId = Plc_Utils.getRecordTypeId(Plc_WorkOrderApxAct.CONFIGURATION_RECORDTYPE_STOCK_ORDER, NE__Order__c.SObjectType.getDescribe().name),
                Bit2Shop__StockOrder__c = stockOrderToCreate.Id,
                Bit2Shop__Cost_Total__c = 0,
                NE__AccountId__c = stockOrderToCreate.Bit2Shop__Holding_Id__c,
                NE__OrderStatus__c = Plc_Constants.NE_Order.NE_OrderStatus_Pending,
                NE__ConfigurationStatus__c = Plc_WorkOrderApxAct.CONFIGURATION_STATUS_INPROGRESS,
                NE__Version__c = 1

        );
        insert configurationToCreate;

        //creo la struttura da configuration item in giu per i prodotti a seriale
        Plc_Utils.shipmentsUtils.createProductSerialStructure(selectedProductSerial, configurationToCreate, stockOrderToCreate,false);

        //creo la struttura da configuration item in giu per i prodotti a quantità
        Plc_Utils.shipmentsUtils.createProductQuantityStructure(selectedProductQuantity, configurationToCreate, stockOrderToCreate,false);
		System.debug('#### [time] END: ' + System.Datetime.now());
        return stockOrderToCreate.Id;
    }

    /**
    * @Giampaolo Mei
    * @date 31/01/2019
    * @description It Retrieves Products (Serial and Quantity type) to move
    * @Param filterSerial Status of serial product
    * @Param originWarehouseId warehouse of product
    * @Return Map<String, Object> Serial and quantity type products retrieved
    */
    @AuraEnabled
    public static Map<String, Object> loadData(String filterSerial, String originWarehouseId) {
        Map<String, Object> result = new Map<String, Object>();
        List<Bit2Shop__Product_Stock__c> productQuantity = [SELECT Id, Plc_ProductSku__c, Bit2Shop__Product_Description__c, Plc_Manufacturer__c, Plc_AvailableQty__c FROM Bit2Shop__Product_Stock__c WHERE Plc_Required_Serial__c = false AND Bit2Shop__Warehouse_Id__c = :originWarehouseId AND Plc_AvailableQty__c > 0];
        result.put('productQuantity', productQuantity);

        String queryString = 'SELECT Id, Plc_ProductSku__c, Plc_Model__c, Plc_Manufacturer__c, Plc_EncodedSerialNumber__c, Plc_ManufacturerSerialNumber__c, Plc_DllSerialNumber__c FROM Bit2Shop__Stock_Serials2__c WHERE Bit2Shop__Warehouse_Id__c =: originWarehouseId';

        //START FIX [#20190326AL] - 26 mar 2019 12:01 - Andrea Liverani (WR) - andrea.liverani@webresults.it
        queryString += ' AND Plc_Status2__c = \'None\'';
        //END FIX [#20190326AL] - 26 mar 2019 12:01 - Andrea Liverani (WR) - andrea.liverani@webresults.it


        Set<String> filter = new Set<String>();
        if (filterSerial != null && filterSerial != '') {
            System.debug('Plc_GoodsHandlingCnt loadData filterSerial: ' + filterSerial);
            filter.addAll(filterSerial.split(';'));
            queryString += ' AND Bit2Shop__Status__c IN: filter';
        }
        
        List<Bit2Shop__Stock_Serials2__c> productSerial = Database.query(queryString);
        result.put('productSerial', productSerial);
        return result;
    }

    /**
     * Used to retrieve list of available dealers
     *
     * @createdBy FB
     * @date 24/04/2019
     * 
     * @param  searchKey String used to match the name
     * @return           List of available dealers
     */
    @AuraEnabled
    public Static Map<String, Object> retrieveAvailableDealers(String searchKey){

        Map<String, Object> response = new Map<String, Object>();
        response.put('error', false);
        try {

            searchKey = '%' + (searchKey == null ? '' :  searchKey) + '%';
            Plc_GoodsHandlingUtils du = new Plc_GoodsHandlingUtils(); 
            List<Bit2Shop__Dealer__c> dealersList = du.retrieveAvailableDealers(searchKey);
            response.put('dealersList', dealersList);

        } catch (Exception e) {
            response.put('error', true);
            response.put('errorMsg', e.getMessage());
            System.debug(e.getMessage() + '' + e.getStackTraceString());
        }
        return response;
    }

    public with sharing class Plc_GoodsHandlingUtils {
        public List<Bit2Shop__Dealer__c> retrieveAvailableDealers(String searchKey) {
            return [SELECT Id, Name,
                           Plc_Maintainer__c, Plc_Manufacturer__c,
                           Plc_Repairer__c, Plc_Scrapyard__c,
                           Bit2Shop__City__c
                       FROM Bit2Shop__Dealer__c
                       WHERE RecordType.DeveloperName = :Plc_Constants.B2S_Dealer.RecordType_PlcChildDealer AND
                             (Name LIKE :searchKey OR
                              Bit2Shop__Parent_Dealer__r.Name LIKE :searchKey OR
                              Bit2Shop__City__c LIKE :searchKey)];
        }
    }

    /**
     * Method used in order to get some different system labels
     *
     * @createdBy FB
     * @date 24/04/2019
     *
     * @return A map containing pairs Api Name/Label
     */
    @AuraEnabled
    public static Map<String, String> retrieveTranslationMap(){
        Map<String, String> response = new Map<String,String>();
        //Getting dealer labels
        Schema.DescribeSObjectResult dealerSchema = Bit2Shop__Dealer__c.SObjectType.getDescribe();
        Map<String, Schema.SObjectField> dealerFieldsMap = dealerSchema.fields.getMap();
        response.put('Bit2Shop__Dealer__c', dealerSchema.getLabel());
        response.put('dealerName', dealerFieldsMap.get('Name').getDescribe().getLabel());
        response.put('Bit2Shop__Parent_Dealer__c', dealerFieldsMap.get('Bit2Shop__Parent_Dealer__c').getDescribe().getLabel());
        response.put('Plc_Maintainer__c', dealerFieldsMap.get('Plc_Maintainer__c').getDescribe().getLabel());
        response.put('Plc_Manufacturer__c', dealerFieldsMap.get('Plc_Manufacturer__c').getDescribe().getLabel());
        response.put('Plc_Repairer__c', dealerFieldsMap.get('Plc_Repairer__c').getDescribe().getLabel());
        response.put('Plc_Scrapyard__c', dealerFieldsMap.get('Plc_Scrapyard__c').getDescribe().getLabel());
        response.put('Bit2Shop__City__c', dealerFieldsMap.get('Bit2Shop__City__c').getDescribe().getLabel());
        return response;
    }
}