/**
    * @author Andrea Liverani - andrea.liverani@webresults.it
    * @description Controller Apex for Plc_ManufacturerGoodsHandling
    * @history 08/02/2019 - Andrea Liverani - andrea.liverani@webresults.it - Class created.
*/

public without sharing class Plc_ManufacturerGoodsHandlingCnt {
    public Plc_ManufacturerGoodsHandlingCnt() {
    }

    public class dliWrapper {
        @AuraEnabled
        public String id { get; set; }

        @AuraEnabled
        public String productSKU { get; set; }

        @AuraEnabled
        public String model { get; set; }

        @AuraEnabled
        public String qtToBeSent { get; set; }

        @AuraEnabled
        public String qtSelected { get; set; }

        @AuraEnabled
        public String qtStorage { get; set; }

        @AuraEnabled
        public Boolean serialRequired { get; set; }

        @AuraEnabled
        public List<stockSerialWrapper> stockSerialWrapperList { get; set; }

        @AuraEnabled
        public String productStockId { get; set; }

        @AuraEnabled
        public Boolean isExpanded { get; set; }

        @AuraEnabled
        public String rdaNumber { get; set; }

        public dliWrapper(String id, String productSKU, String model, String qtToBeSent, String qtSelected, String qtStorage, Boolean serialRequired, List<stockSerialWrapper> stockSerialWrapperList, String productStockId, Boolean isExpanded, String rdaNumber) {
            this.id = id;
            this.productSKU = productSKU;
            this.model = model;
            this.qtToBeSent = qtToBeSent;
            this.qtSelected = qtSelected;
            this.qtStorage = qtStorage;
            this.serialRequired = serialRequired;
            this.stockSerialWrapperList = stockSerialWrapperList;
            this.productStockId = productStockId;
            this.isExpanded = isExpanded;
            this.rdaNumber = rdaNumber;
        }
    }

    public class stockSerialWrapper {
        @AuraEnabled
        public String id { get; set; }

        @AuraEnabled
        public String productSKU { get; set; }

        @AuraEnabled
        public String model { get; set; }

        @AuraEnabled
        public String manufacturerSerialNumber { get; set; }

        @AuraEnabled
        public String nexiSerialNumber { get; set; }

        @AuraEnabled
        public String status { get; set; }

        @AuraEnabled
        public String productStockId { get; set; }

        @AuraEnabled
        public String dllSerialNumber { get; set; }

        public stockSerialWrapper(String id, String productSKU, String model, String manufacturerSerialNumber, String nexiSerialNumber, 
                                  String status, String productStockId, String dllSerialNumber) {
            this.id = id;
            this.productSKU = productSKU;
            this.model = model;
            this.manufacturerSerialNumber = manufacturerSerialNumber;
            this.nexiSerialNumber = nexiSerialNumber;
            this.status = status;
            this.productStockId = productStockId;
            this.dllSerialNumber = dllSerialNumber;
        }
    }

    /**
    * @createdBy Andrea Liverani
    * @date 11/02/2019
    * @description
    * @param
    * @return
    */

    @AuraEnabled(cacheable = true)
    public static Object initialize(String distributionListId) {

        try {
            System.debug('[START] @A - initialize');
            System.debug('[PROCESSING] @A - initialize - distributionListId >> ' + distributionListId);

            Map<String, Object> result = new Map<String, Object>();

            result.put('dliIdList', getDliIdsListByDistributionListId(distributionListId));
            result.put('transferDetailsList', getTransferDetailsList());
            result.put('distributionListName', getDistributionListName(distributionListId));

            System.debug('[PROCESSING] @A - initialize - result >> ' + result);
            System.debug('[END] @A - initialize');
            return result;
        } catch (Exception error) {
            String errorMessage = '[EXCEPTION] @A - initialize >> Error in : ' + error.getMessage() + ' at line: ' + error.getLineNumber() + ' stack trace: ' + error.getStackTraceString();
            System.debug(errorMessage);
        }

        return null;
    }

    /**
    * @createdBy Andrea Liverani
    * @date 11/02/2019
    * @description
    * @param
    * @return
    */
    @AuraEnabled(cacheable = true)
    public static String getDistributionListName(String distributionListId) {

        try {
            System.debug('[START] @A - getDistributionListName');
            System.debug('[PROCESSING] @A - getDistributionListName - distributionListId >> ' + distributionListId);

            Plc_DistributionList__c dl = [SELECT Id, Name FROM Plc_DistributionList__c WHERE Id = :distributionListId];

            if (dl != null) {
                System.debug('[END] @A - getDistributionListName');
                return dl.Name;
            } else {
                System.debug('[END] @A - getDistributionListName - distributionList is null.');
            }

        } catch (Exception error) {
            String errorMessage = '[EXCEPTION] @A - getDistributionListName >> Error in : ' + error.getMessage() + ' at line: ' + error.getLineNumber() + ' stack trace: ' + error.getStackTraceString();
            System.debug(errorMessage);
        }

        return null;
    }

    /**
    * @createdBy Andrea Liverani
    * @date 11/02/2019
    * @description
    * @param
    * @return
    */
    @AuraEnabled(cacheable = true)
    public static List<String> getDliIdsListByDistributionListId(String distributionListId) {

        try {
            System.debug('[START] @A - getInitialDataSet');
            System.debug('[PROCESSING] @A - getInitialDataSet - distributionListId >> ' + distributionListId);

            List<String> dliIdsList = new List<String>();
            List<Plc_DistributionListItem__c> dliList = new List<Plc_DistributionListItem__c>();

            dliList = [SELECT Id FROM Plc_DistributionListItem__c WHERE Plc_DistributionList__c = :distributionListId AND Plc_Status__c = 'Requested'];

            if (!dliList.isEmpty()) {
                for (Plc_DistributionListItem__c dli : dliList) {
                    dliIdsList.add(dli.Id);
                }
            } else {
                System.debug('[PROCESSING] @A - getInitialDataSet - dliList >> List is empty.');
            }

            if (!dliIdsList.isEmpty()) {
                System.debug('[END] @A - getInitialDataSet');
                return dliIdsList;
            } else {
                System.debug('[PROCESSING] @A - getInitialDataSet - dliIdsList >> List is empty.');
            }

        } catch (Exception error) {
            String errorMessage = '[EXCEPTION] @A - getInitialDataSet >> Error in : ' + error.getMessage() + ' at line: ' + error.getLineNumber() + ' stack trace: ' + error.getStackTraceString();
            System.debug(errorMessage);
        }
        return null;
    }

    /**
    * @createdBy Andrea Liverani
    * @date 11/02/2019
    * @description
    * @param
    * @return
    */
    @AuraEnabled(cacheable = true)
    public static List<Bit2Shop__TransferDetail__c> getTransferDetailsList() {

        try {
            System.debug('[START] @A - getTransferDetailsList');
            List<Bit2Shop__TransferDetail__c> transferDetailsList = new List<Bit2Shop__TransferDetail__c>();

            transferDetailsList = [
                    SELECT Id,
                            Name,
                            Bit2Shop__Code__c,
                            Plc_FilterDestinationDealer__c,
                            Bit2Shop__Transfer_Type__c,
                            Plc_FilterDestinationWarehouse__c,
                            Plc_FilterOriginDealer__c,
                            Plc_FilterOriginWarehouse__c
                    FROM Bit2Shop__TransferDetail__c
                    WHERE Bit2Shop__Code__c IN ('RESO_RIP', 'APPR')
            ];

            if (!transferDetailsList.isEmpty()) {
                System.debug('[END] @A - getTransferDetailsList');
                return transferDetailsList;
            } else {
                System.debug('[PROCESSING] @A - getTransferDetailsList - transferDetails >> List is empty.');
            }

        } catch (Exception error) {
            String errorMessage = '[EXCEPTION] @A - getTransferDetailsList >> Error in : ' + error.getMessage() + ' at line: ' + error.getLineNumber() + ' stack trace: ' + error.getStackTraceString();
            System.debug(errorMessage);
        }
        return null;
    }

    /**
    * @createdBy Andrea Liverani
    * @date 11/02/2019
    * @description
    * @param
    * @return
    */
    @AuraEnabled(cacheable = true)
/** [START MOD 23/02/2019 18:52]@Author:marco.lebellini@/webresults.it @Description: **/
    //public static List<Bit2Shop__Dealer__c> getOriginDealer(List<String> dliIdList, String filter) {
    public static List<Bit2Shop__Dealer__c> getOriginDealer(List<String> dliIdList, String filter, String transferDetailCode) {
/** [END MOD 23/02/2019 18:52]@Author:marco.lebellini@/webresults.it @Description: **/
        try {
            System.debug('[START] @A - getOriginDealer');
            System.debug('[PROCESSING] @A - getOriginDealer - dliIdList >> ' + dliIdList);
            System.debug('[PROCESSING] @A - getOriginDealer - filter >> ' + filter);

            List<Plc_DistributionListItem__c> dliList = new List<Plc_DistributionListItem__c>();
            List<Bit2Shop__Dealer__c> originDealerList = new List<Bit2Shop__Dealer__c>();
            List<String> originDealerIdList = new List<String>();

            if (!dliIdList.isEmpty()) {

                /** [START MOD 23/02/2019 17:58]@Author:marco.lebellini@/webresults.it @Description: **/
                //dliList = [SELECT Id, Plc_OriginDealer__c FROM Plc_DistributionListItem__c WHERE Plc_OriginDealer__r.Bit2Shop__Dealer_Type__c = :filter AND Id IN :dliIdList];

                String queryString = 'SELECT Id, Plc_OriginDealer__c FROM Plc_DistributionListItem__c';
                Set<String> filterSet = new Set<String>();
                filterSet.addAll(filter.split(';'));

                String sObjectType = 'Bit2Shop__Dealer__c';
                Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                Schema.SObjectType leadSchema = schemaMap.get(sObjectType);
                Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();

                String maintainer = fieldMap.get('Plc_Maintainer__c').getDescribe().getName();
                String manufacturer = fieldMap.get('Plc_Manufacturer__c').getDescribe().getName();
                String repairer = fieldMap.get('Plc_Repairer__c').getDescribe().getName();
                String scrapyard = fieldMap.get('Plc_Scrapyard__c').getDescribe().getName();

                Boolean Finded = false;
                for (String st : filterSet) {
                    if (st == maintainer) {
                        if (Finded == false) {
                            queryString += ' WHERE Plc_OriginDealer__r.Plc_Maintainer__c = true';
                            Finded = true;
                        } else {
                            queryString += ' OR Plc_OriginDealer__r.Plc_Maintainer__c = true';
                        }
                    }
                    if (st == manufacturer) {
                        if (Finded == false) {
                            queryString += ' WHERE Plc_OriginDealer__r.Plc_Manufacturer__c = true';
                            Finded = true;
                        } else {
                            queryString += ' OR Plc_OriginDealer__r.Plc_Manufacturer__c = true';
                        }
                    }
                    if (st == repairer) {
                        if (Finded == false) {
                            queryString += ' WHERE Plc_OriginDealer__r.Plc_Repairer__c = true';
                            Finded = true;
                        } else {
                            queryString += ' OR Plc_OriginDealer__r.Plc_Repairer__c = true';
                        }
                    }
                    if (st == scrapyard) {
                        if (Finded == false) {
                            queryString += ' WHERE Plc_OriginDealer__r.Plc_Scrapyard__c = true';
                            Finded = true;
                        } else {
                            queryString += ' OR Plc_OriginDealer__r.Plc_Scrapyard__c = true';
                        }
                    }
                }

                if (Finded) {
                    queryString += ' AND Id IN:dliIdList';
                } else {
                    queryString += ' WHERE Id IN:dliIdList';
                }
                //TODO Implement logic like Goods handling Nunzio Capasso Fix

                queryString += ' AND Id IN:dliIdList';
                System.debug('queryString >> ' + queryString);

                dliList = Database.query(queryString);
                /** [END MOD 23/02/2019 17:58]@Author:marco.lebellini@/webresults.it @Description: **/

                if (!dliList.isEmpty()) {
                    for (Plc_DistributionListItem__c dli : dliList) {
                        originDealerIdList.add(dli.Plc_OriginDealer__c);
                    }

                    if (!originDealerIdList.isEmpty()) {
                        originDealerList = [SELECT Id, Name FROM Bit2Shop__Dealer__c WHERE Id IN :originDealerIdList];

                        if (!originDealerList.isEmpty()) {
                            System.debug('[END] @A - getOriginDealer');
                            return originDealerList;
                        } else {
                            System.debug('[PROCESSING] @A - getOriginDealer - originDealerList >> List is empty.');
                        }
                    } else {
                        System.debug('[PROCESSING] @A - getOriginDealer - originDealerIdList >> List is empty.');
                    }
                } else {
                    System.debug('[PROCESSING] @A - getOriginDealer - dliList >> List is empty.');
                }
            } else {
                System.debug('[PROCESSING] @A - getOriginDealer - dliIdList >> List is empty.');
            }

            System.debug('[PROCESSING] @A - getOriginDealer - dliList >> ' + dliList);
            System.debug('[PROCESSING] @A - getOriginDealer - originDealerList >> ' + originDealerList);

        } catch (Exception error) {
            String errorMessage = '[EXCEPTION] @A - getOriginDealer >> Error in : ' + error.getMessage() + ' at line: ' + error.getLineNumber() + ' stack trace: ' + error.getStackTraceString();
            System.debug(errorMessage);
        }
        return null;
    }

    /**
    * @createdBy Andrea Liverani
    * @date 11/02/2019
    * @description
    * @param
    * @return
    */
    @AuraEnabled(cacheable = true)
    public static List<Bit2Shop__Warehouse__c> getOriginWarehouse(List<String> dliIdList, String originDealerId, String filter) {

        try {
            System.debug('[START] @A - getOriginWarehouse');
            System.debug('[PROCESSING] @A - getOriginWarehouse - dliIdList >> ' + dliIdList);
            System.debug('[PROCESSING] @A - getOriginWarehouse - originDealerId >> ' + originDealerId);
            System.debug('[PROCESSING] @A - getOriginWarehouse - filter >> ' + filter);

            List<Plc_DistributionListItem__c> dliList = new List<Plc_DistributionListItem__c>();
            List<String> originWarehouseIdList = new List<String>();
            List<Bit2Shop__Warehouse__c> originWarehouseList = new List<Bit2Shop__Warehouse__c>();

            if (!String.isBlank(originDealerId)) {
                if (filter != null) {
                    dliList = [SELECT Id, Plc_OriginWarehouse__c FROM Plc_DistributionListItem__c WHERE Plc_OriginWarehouse__r.Plc_Tipology__c = :filter AND Id IN :dliIdList AND Plc_OriginDealer__c = :originDealerId];
                } else {
                    dliList = [SELECT Id, Plc_OriginWarehouse__c FROM Plc_DistributionListItem__c WHERE Id IN :dliIdList AND Plc_OriginDealer__c = :originDealerId];
                }
            } else {
                System.debug('[PROCESSING] @A - getOriginWarehouse - originDealerId is null.');
            }

            if (!dliList.isEmpty()) {
                for (Plc_DistributionListItem__c dli : dliList) {
                    originWarehouseIdList.add(dli.Plc_OriginWarehouse__c);
                }

                if (!originWarehouseIdList.isEmpty()) {
                    originWarehouseList = [SELECT Id, Name FROM Bit2Shop__Warehouse__c WHERE Id IN :originWarehouseIdList];

                    if (!originWarehouseList.isEmpty()) {
                        System.debug('[END] @A - getOriginWarehouse');
                        return originWarehouseList;
                    } else {
                        System.debug('[PROCESSING] @A - getOriginWarehouse - originWarehouseList >> List is empty.');
                    }
                } else {
                    System.debug('[PROCESSING] @A - getOriginWarehouse - originWarehouseIdList >> List is empty.');
                }
            } else {
                System.debug('[PROCESSING] @A - getOriginWarehouse - dliList >> List is empty.');
            }

            System.debug('[PROCESSING] @A - getOriginWarehouse - dliList >> ' + dliList);
            System.debug('[PROCESSING] @A - getOriginWarehouse - originWarehouseList >> ' + originWarehouseList);

        } catch (Exception error) {
            String errorMessage = '[EXCEPTION] @A - getOriginDealer >> Error in : ' + error.getMessage() + ' at line: ' + error.getLineNumber() + ' stack trace: ' + error.getStackTraceString();
            System.debug(errorMessage);
        }
        return null;
    }

    /**
    * @createdBy Andrea Liverani
    * @date 11/02/2019
    * @description
    * @param
    * @return
    */
    @AuraEnabled(cacheable = true)
/** [START MOD 24/02/2019 09:42]@Author:marco.lebellini@/webresults.it @Description: **/
    //public static List<Bit2Shop__Dealer__c> getDestinationDealer(List<String> dliIdList, String originWarehouseId, String filter) {
    public static List<Bit2Shop__Dealer__c> getDestinationDealer(List<String> dliIdList, String originWarehouseId, String filter, String transferDetailCode) {
/** [END MOD 24/02/2019 09:42]@Author:marco.lebellini@/webresults.it @Description: **/
        try {
            System.debug('[START] @A - getDestinationDealer');
            System.debug('[PROCESSING] @A - getDestinationDealer - dliIdList >> ' + dliIdList);
            System.debug('[PROCESSING] @A - getDestinationDealer - originWarehouseId >> ' + originWarehouseId);
            System.debug('[PROCESSING] @A - getDestinationDealer - filter >> ' + filter);
            System.debug('[PROCESSING] @A - getDestinationDealer - transferDetailCode >> ' + transferDetailCode);

            List<Plc_DistributionListItem__c> dliList = new List<Plc_DistributionListItem__c>();
            List<Bit2Shop__Dealer__c> destinationDealerList = new List<Bit2Shop__Dealer__c>();
            List<String> destinationDealerNameList = new List<String>();

            if (!String.isBlank(originWarehouseId)) {
                dliList = [SELECT Id, Plc_DestinationDealer__c FROM Plc_DistributionListItem__c WHERE Id IN :dliIdList AND Plc_OriginWarehouse__c = :originWarehouseId];

                if (!dliList.isEmpty()) {
                    for (Plc_DistributionListItem__c dli : dliList) {
                        destinationDealerNameList.add(dli.Plc_DestinationDealer__c);
                    }
                } else {
                    System.debug('[PROCESSING] @A - getDestinationDealer - dliList >> List is empty.');
                }
            } else {
                System.debug('[PROCESSING] @A - getDestinationDealer - originWarehouseId is null.');
            }


            /** [START MOD 23/02/2019 19:22]@Author:marco.lebellini@/webresults.it @Description: **/
            Set<String> filterSet = new Set<String>();
            String queryString = 'SELECT Id, Name FROM Bit2Shop__Dealer__c';
            Boolean Finded = false;

            if (!destinationDealerNameList.isEmpty()) {

                filterSet.addAll(filter.split(';'));
                String type = 'Bit2Shop__Dealer__c';

                Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                Schema.SObjectType leadSchema = schemaMap.get(type);
                Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();

                String maintainer = fieldMap.get('Plc_Maintainer__c').getDescribe().getName();
                String manufacturer = fieldMap.get('Plc_Manufacturer__c').getDescribe().getName();
                String repairer = fieldMap.get('Plc_Repairer__c').getDescribe().getName();
                String scrapyard = fieldMap.get('Plc_Scrapyard__c').getDescribe().getName();

                for (String st : filterSet) {
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
                    if (st == scrapyard) {
                        if (Finded == false) {
                            queryString += ' WHERE Plc_Scrapyard__c = true';
                            Finded = true;
                        } else {
                            queryString += ' OR Plc_Scrapyard__c = true';
                        }
                    }
                }
            }

            List<Bit2Shop__TransferDetail__c> transferDetail = [
                    SELECT Plc_FilterDestinationDealer__c,
                            Plc_FilterDestinationWarehouse__c,
                            Bit2Shop__Code__c
                    FROM Bit2Shop__TransferDetail__c
                    WHERE Bit2Shop__Code__c = :transferDetailCode
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
                    destinationDealerList = Database.query(queryString);
                    System.debug('###### QueryString >> ' + queryString);

                    if (!destinationDealerList.isEmpty()) {

                        for (Bit2Shop__Dealer__c dealer : destinationDealerList) {
                            destinationDealerNameList.add(dealer.Name);
                        }

                    } else {
                        destinationDealerNameList.addAll(dealers);
                    }
                }

                String queryStringWarehouse = 'SELECT Id, Name, Bit2Shop__Dealer_Id__c, Bit2Shop__Dealer_Id__r.Name, Plc_LogisticDivision__c, Plc_Property__c FROM Bit2Shop__Warehouse__c WHERE Bit2Shop__Dealer_Id__c IN :destinationDealerHolder';

                if (code == 'SPOS_DL' || code == 'SPOS_DL_S2OS' || code == 'SPOS_DL_MATRDISP_S2S' || code == 'SPOS_DL_MATRDISP_S2OS' || code == 'SPOS_DL_MATRDISP') {
                    queryStringWarehouse += ' AND Plc_LogisticDivision__c !=: logisticDivision';
                }
                if (code == 'SPOS_PRO' || code == 'SPOS_PRO_S2OS' || code == 'SPOS_PRO_MATRDISP_S2S' || code == 'SPOS_PRO_MATRDISP_S2OS' || code == 'SPOS_PRO_MATRDISP') {
                    queryStringWarehouse += ' AND Plc_LogisticDivision__c !=: logisticDivision AND Plc_Property__c !=: property';
                }

                System.debug('###### QueryString >> ' + queryStringWarehouse);
                List<Bit2Shop__Warehouse__c> destinationWarehouse = Database.query(queryStringWarehouse);
                List<String> secondaryDestinationDealerNameList = new List<String>();

                for (Bit2Shop__Warehouse__c wh : destinationWarehouse) {
                    secondaryDestinationDealerNameList.add(wh.Bit2Shop__Dealer_Id__r.Name);
                }

                destinationDealerNameList.addAll(secondaryDestinationDealerNameList);

                if (!Finded) {
                    queryString += ' WHERE Name in :destinationDealerNameList';
                    Finded = true;
                } else {
                    queryString += ' AND Name in :destinationDealerNameList';
                }
            } else if (!Finded) {
                queryString += ' WHERE Id in :dealers';
            }

            if (Finded) {
                queryString += ' AND Name IN :destinationDealerNameList';
            } else {
                queryString += ' WHERE Name IN :destinationDealerNameList';
            }
            /** [END MOD 23/02/2019 19:22]@Author:marco.lebellini@/webresults.it @Description: **/

            //START FIX [#20190225AL] - 25 feb 2019 15:50 - Andrea Liverani (WR) - andrea.liverani@webresults.it
            queryString += ' AND RecordTypeId = \'' + Schema.SObjectType.Bit2Shop__Dealer__c.getRecordTypeInfosByDeveloperName().get('Plc_ChildDealer').getRecordTypeId() + '\'';
            //END FIX [#20190225AL] - 25 feb 2019 15:50 - Andrea Liverani (WR) - andrea.liverani@webresults.it

            /** [START MOD 23/02/2019 19:36]@Author:marco.lebellini@/webresults.it @Description: **/
            /*if (!String.isBlank(filter) && !destinationDealerNameList.isEmpty()) {
                destinationDealerList = [SELECT Id, Name FROM Bit2Shop__Dealer__c WHERE Bit2Shop__Dealer_Type__c = :filter AND Name IN :destinationDealerNameList];
            } else if (!destinationDealerNameList.isEmpty()) {
                destinationDealerList = [SELECT Id, Name FROM Bit2Shop__Dealer__c WHERE Name IN :destinationDealerNameList];
                System.debug('[PROCESSING] @A - getDestinationDealer - filter is blank.');
            } else {
                System.debug('[PROCESSING] @A - getDestinationDealer - destinationDealerNameList >> List is empty.');
            }*/
            System.debug('###### QueryString >> ' + queryString);
            if (!destinationDealerNameList.isEmpty()) {

                destinationDealerList = Database.query(queryString);
            } else {
                System.debug('[PROCESSING] @A - getDestinationDealer - destinationDealerNameList >> List is empty.');
            }
            /** [END MOD 23/02/2019 19:38]@Author:marco.lebellini@/webresults.it @Description: **/

            if (!destinationDealerList.isEmpty()) {
                System.debug('[END] @A - getDestinationDealer');
                return destinationDealerList;
            } else {
                System.debug('[PROCESSING] @A - getDestinationDealer - destinationDealerList >> List is empty.');
                return null;
            }

        } catch (Exception error) {
            String errorMessage = '[EXCEPTION] @A - getDestinationDealer >> Error in : ' + error.getMessage() + ' at line: ' + error.getLineNumber() + ' stack trace: ' + error.getStackTraceString();
            System.debug(errorMessage);
        }
        return null;
    }

    /**
    * @createdBy Andrea Liverani
    * @date 11/02/2019
    * @description
    * @param
    * @return
    */
    @AuraEnabled(cacheable = true)
    public static List<Bit2Shop__Warehouse__c> getDestinationWarehouse(List<String> dliIdList, String destinationDealerId, String filter) {

        try {
            System.debug('[START] @A - getDestinationWarehouse');
            System.debug('[PROCESSING] @A - getDestinationWarehouse - dliIdList >> ' + dliIdList);
            System.debug('[PROCESSING] @A - getDestinationWarehouse - destinationDealerId >> ' + destinationDealerId);
            System.debug('[PROCESSING] @A - getDestinationWarehouse - filter >> ' + filter);

            List<Plc_DistributionListItem__c> dliList = new List<Plc_DistributionListItem__c>();
            List<Bit2Shop__Warehouse__c> destinationWarehouseList = new List<Bit2Shop__Warehouse__c>();
            List<String> destinationWarehouseIdList = new List<String>();
            Bit2Shop__Dealer__c destinationDealer = new Bit2Shop__Dealer__c();

            destinationDealer = [SELECT Id, Name FROM Bit2Shop__Dealer__c WHERE Id = :destinationDealerId LIMIT 1];

            if (!String.isBlank(filter) && destinationDealer != null && !dliIdList.isEmpty()) {
                dliList = [SELECT Id, Plc_DestinationWarehouse__c FROM Plc_DistributionListItem__c WHERE Plc_DestinationWarehouse__r.Plc_Tipology__c = :filter AND Id IN :dliIdList AND Plc_DestinationDealer__c = :destinationDealer.Name];
            } else if (destinationDealer != null && !dliIdList.isEmpty()) {
                dliList = [SELECT Id, Plc_DestinationWarehouse__c FROM Plc_DistributionListItem__c WHERE Id IN :dliIdList AND Plc_DestinationDealer__c = :destinationDealer.Name];
                System.debug('[PROCESSING] @A - getDestinationDealer - filter is blank.');
            } else {
                System.debug('[PROCESSING] @A - getDestinationWarehouse - destinationDealer >> ' + destinationDealer);
                System.debug('[PROCESSING] @A - getDestinationWarehouse - dliIdList >> ' + dliIdList);
            }

            if (!dliList.isEmpty()) {
                for (Plc_DistributionListItem__c dli : dliList) {
                    destinationWarehouseIdList.add(dli.Plc_DestinationWarehouse__c);
                }

                if (!destinationWarehouseIdList.isEmpty()) {
                    destinationWarehouseList = [SELECT Id, Name FROM Bit2Shop__Warehouse__c WHERE Id IN :destinationWarehouseIdList];

                    if (!destinationWarehouseList.isEmpty()) {
                        System.debug('[END] @A - getDestinationWarehouse');
                        return destinationWarehouseList;
                    } else {
                        System.debug('[PROCESSING] @A - getDestinationWarehouse - destinationWarehouseList >> List is empty.');
                    }
                } else {
                    System.debug('[PROCESSING] @A - getDestinationWarehouse - destinationWarehouseIdList >> List is empty.');
                }

            } else {
                System.debug('[PROCESSING] @A - getDestinationWarehouse - dliList >> List is empty.');
            }

        } catch (Exception error) {
            String errorMessage = '[EXCEPTION] @A - getDestinationWarehouse >> Error in : ' + error.getMessage() + ' at line: ' + error.getLineNumber() + ' stack trace: ' + error.getStackTraceString();
            System.debug(errorMessage);
        }
        return null;
    }

    /**
    * @createdBy Andrea Liverani
    * @date 11/02/2019
    * @description
    * @param
    * @return
    */
    @AuraEnabled(cacheable = true)
    public static List<dliWrapper> getDliWrapper(String originDealerId, String originWarehouseId, String destinationDealerId, String destinationWarehouseId, String distributionListId) {

        try {
            System.debug('[START] @A - getProductStockWrapper');
            System.debug('[PROCESSING] @A - getProductStockWrapper - originDealerId >> ' + originDealerId);
            System.debug('[PROCESSING] @A - getProductStockWrapper - originWarehouseId >> ' + originWarehouseId);
            System.debug('[PROCESSING] @A - getProductStockWrapper - destinationDealerId >> ' + destinationDealerId);
            System.debug('[PROCESSING] @A - getProductStockWrapper - destinationWarehouseId >> ' + destinationWarehouseId);
            System.debug('[PROCESSING] @A - getProductStockWrapper - distributionListId >> ' + distributionListId);

            List<dliWrapper> dliWrapperList = new List<dliWrapper>();
            List<stockSerialWrapper> stockSerialWrapperList = new List<stockSerialWrapper>();
            List<Plc_DistributionListItem__c> dliList = new List<Plc_DistributionListItem__c>();
            List<Bit2Shop__Product_Stock__c> productStockList = new List<Bit2Shop__Product_Stock__c>();
            List<String> externalCatalogItemIdsList = new List<String>();
            List<String> originWarehouseIdsList = new List<String>();
            Bit2Shop__Dealer__c dealer = new Bit2Shop__Dealer__c();

            if (!String.isBlank(destinationDealerId)) {
                dealer = [SELECT Id, Name FROM Bit2Shop__Dealer__c WHERE Id = :destinationDealerId];

                if (!String.isBlank(originDealerId) && !String.isBlank(originWarehouseId) && !String.isBlank(destinationWarehouseId) && dealer != null && !String.isBlank(distributionListId)) {
                    dliList = [
                            SELECT Id, Plc_PurchaseOrder__r.Plc_StartDate__c,
                                    Plc_RdaNumber__c, Plc_PurchaseOrder__r.CreatedDate, Plc_Product__c,
                                    Plc_OriginWarehouse__c, Plc_DistributionList__c,
                                    Plc_ProductName__c, Plc_Product__r.Bit2Shop__Required_Serial__c,
                                    Plc_RequestedQty__c, Plc_ShippedQty__c, Plc_SKUCode__c
                            FROM Plc_DistributionListItem__c
                            WHERE Plc_OriginDealer__c = :originDealerId
                            AND Plc_OriginWarehouse__c = :originWarehouseId
                            AND Plc_DestinationDealer__c = :dealer.Name
                            AND Plc_DestinationWarehouse__c = :destinationWarehouseId
                            AND Plc_DistributionList__c = :distributionListId
                            AND Plc_Status__c = 'Requested'
                            ORDER BY Plc_PurchaseOrder__r.CreatedDate, Plc_ProductName__c
                    ];

                    /*Map<Id, Plc_DistributionListItem__c> dliMap = new Map<Id, Plc_DistributionListItem__c>();

                    for(Plc_DistributionListItem__c dli : sourceDliList) {
                        if (!dliMap.containsKey(dli.Plc_ProductName__c)) {

                            dliMap.put(dli.Plc_ProductName__c, dli);
                        } else if (dliMap.get(dli.Plc_ProductName__c).Plc_PurchaseOrder__r.CreatedDate > dli.Plc_PurchaseOrder__r.CreatedDate) {

                            dliMap.put(dli.Plc_ProductName__c, dli);
                        }
                    }
                    List<Plc_DistributionListItem__c> dliList = dliMap.values();*/

                    if (!dliList.isEmpty()) {
                        for (Plc_DistributionListItem__c dli : dliList) {
                            externalCatalogItemIdsList.add(dli.Plc_Product__c);
                            originWarehouseIdsList.add(dli.Plc_OriginWarehouse__c);
                        }

                        if (!externalCatalogItemIdsList.isEmpty() && !originWarehouseIdsList.isEmpty()) {
                            productStockList = [SELECT Id, Bit2Shop__External_Catalog_Item_Id__c, Bit2Shop__Stock_Qty__c, Plc_ProductSku__c FROM Bit2Shop__Product_Stock__c WHERE Bit2Shop__External_Catalog_Item_Id__c = :externalCatalogItemIdsList AND Bit2Shop__Warehouse_Id__c IN :originWarehouseIdsList];

                            if (!productStockList.isEmpty()) {
                                for (Plc_DistributionListItem__c dli : dliList) {
                                    for (Bit2Shop__Product_Stock__c productStock : productStockList) {
                                        if (dli.Plc_Product__c == productStock.Bit2Shop__External_Catalog_Item_Id__c && dli.Plc_DistributionList__c == distributionListId) {

                                            //START FIX [#20190311AL] - 11 mar 2019 11:16 - Andrea Liverani (WR) - andrea.liverani@webresults.it
                                            Decimal qtToBeSent = 0;

                                            if (String.isNotBlank(String.valueOf(dli.Plc_RequestedQty__c)) && String.isNotBlank(String.valueOf(dli.Plc_ShippedQty__c))) {
                                                qtToBeSent = dli.Plc_RequestedQty__c - dli.Plc_ShippedQty__c;
                                            } else if (String.isBlank(String.valueOf(dli.Plc_ShippedQty__c))) {
                                                qtToBeSent = dli.Plc_RequestedQty__c;
                                            }

                                            dliWrapperList.add(new dliWrapper(dli.Id, dli.Plc_SKUCode__c, dli.Plc_ProductName__c, String.valueOf(qtToBeSent), '0', String.valueOf(productStock.Bit2Shop__Stock_Qty__c), dli.Plc_Product__r.Bit2Shop__Required_Serial__c, stockSerialWrapperList, productStock.Id, false, dli.Plc_RdaNumber__c));

                                            /*dliWrapperList.add(new dliWrapper(dli.Id, dli.Plc_SKUCode__c, dli.Plc_ProductName__c, String.valueOf(dli.Plc_RequestedQty__c), '0', String.valueOf(productStock.Bit2Shop__Stock_Qty__c), dli.Plc_Product__r.Bit2Shop__Required_Serial__c, stockSerialWrapperList, productStock.Id, false, dli.Plc_RdaNumber__c));*/
                                            //END FIX [#20190311AL] - 11 mar 2019 11:16 - Andrea Liverani (WR) - andrea.liverani@webresults.it
                                        }
                                    }
                                }

                                if (!dliWrapperList.isEmpty()) {
                                    System.debug('[END] @A - getProductStockWrapper');
                                    return dliWrapperList;
                                } else {
                                    System.debug('[PROCESSING] @A - getProductStockWrapper - dliWrapperList >> List is empty.');
                                }
                            } else {
                                System.debug('[PROCESSING] @A - getProductStockWrapper - productStockList >> List is empty.');
                            }
                        } else {
                            System.debug('[PROCESSING] @A - getProductStockWrapper - externalCatalogItemIdsList >> ' + externalCatalogItemIdsList);
                            System.debug('[PROCESSING] @A - getProductStockWrapper - originWarehouseIdsList >> ' + originWarehouseIdsList);
                        }
                    } else {
                        System.debug('[PROCESSING] @A - getProductStockWrapper - dliList >> List is empty.');
                    }
                } else {
                    System.debug('[PROCESSING] @A - getProductStockWrapper - originDealerId >> ' + originDealerId);
                    System.debug('[PROCESSING] @A - getProductStockWrapper - originWarehouseId >> ' + originWarehouseId);
                    System.debug('[PROCESSING] @A - getProductStockWrapper - destinationWarehouseId >> ' + destinationWarehouseId);
                    System.debug('[PROCESSING] @A - getProductStockWrapper - dealer >> ' + dealer);
                    System.debug('[PROCESSING] @A - getProductStockWrapper - distributionListId >> ' + distributionListId);
                }
            } else {
                System.debug('[PROCESSING] @A - getProductStockWrapper - destinationDealerId is blank.');
            }

        } catch (Exception error) {
            String errorMessage = '[EXCEPTION] @A - getProductStockWrapper >> Error in : ' + error.getMessage() + ' at line: ' + error.getLineNumber() + ' stack trace: ' + error.getStackTraceString();
            System.debug(errorMessage);
        }
        return null;
    }

    /**
    * @createdBy Andrea Liverani
    * @date 12/02/2019
    * @description
    * @param
    * @return
    */
    @AuraEnabled(cacheable = true)
    public static List<stockSerialWrapper> createSerialWrapperFromResults(String resultsList, List<String> modelList, Boolean createFromCSV) {

        try {
            System.debug('[START] @A - createSerialWrapperFromResults');
            System.debug('[PROCESSING] @A - createSerialWrapperFromResults - modelList >> ' + modelList);
            System.debug('[PROCESSING] @A - createSerialWrapperFromResults - resultsList >> ' + resultsList);

            Map<String, List<Bit2Shop__Stock_Serials2__c>> stockSerialsFilteredMap = (Map<String, List<Bit2Shop__Stock_Serials2__c>>) JSON.deserialize(resultsList, Map<String, List<Bit2Shop__Stock_Serials2__c>>.class);
            List<Bit2Shop__Stock_Serials2__c> stockSerialFilteredList = (List<Bit2Shop__Stock_Serials2__c>) (!createFromCSV ? stockSerialsFilteredMap.get('Bit2Shop__Stock_Serials2__c') : stockSerialsFilteredMap.get('stockSerialFromCSV'));
            List<stockSerialWrapper> stockSerialWrapperList = new List<stockSerialWrapper>();
            System.debug('[PROCESSING] @A - createSerialWrapperFromResults - stockSerialFilteredList >> ' + stockSerialFilteredList);


            if (!stockSerialFilteredList.isEmpty()) {
                for (Bit2Shop__Stock_Serials2__c stockSerial : stockSerialFilteredList) {
                    System.debug('[PROCESSING] @A - createSerialWrapperFromResults - stockSerial.Plc_Model__c >> ' + stockSerial.Plc_Model__c);
                    System.debug('[PROCESSING] @A - createSerialWrapperFromResults - stockSerial.Bit2Shop__Product_Stock_Id__r.Bit2Shop__Warehouse_Id__c >> ' + stockSerial.Bit2Shop__Product_Stock_Id__r.Bit2Shop__Warehouse_Id__c);
                    //START FIX [#20190326AL] - 26 mar 2019 11:49 - Andrea Liverani (WR) - andrea.liverani@webresults.it
                    if (modelList.contains(stockSerial.Plc_Model__c) && stockSerial.Plc_Status2__c == 'None') {
                        //if (modelList.contains(stockSerial.Plc_Model__c)) {
                        //END FIX [#20190326AL] - 26 mar 2019 11:49 - Andrea Liverani (WR) - andrea.liverani@webresults.it
                        stockSerialWrapperList.add(new stockSerialWrapper(stockSerial.Id, stockSerial.Plc_ProductSku__c, stockSerial.Plc_Model__c, stockSerial.Plc_ManufacturerSerialNumber__c, stockSerial.Plc_EncodedSerialNumber__c, 
                                                                          stockSerial.Bit2Shop__Status__c, stockSerial.Bit2Shop__Product_Stock_Id__c, stockSerial.Plc_DllSerialNumber__c));
                    }
                }
                return stockSerialWrapperList;
            } else {
                System.debug('[PROCESSING] @A - createSerialWrapperFromResults - stockSerialFilteredList >> List is empty.');
            }
            System.debug('[END] @A - createSerialWrapperFromResults');

        } catch (Exception error) {
            String errorMessage = '[EXCEPTION] @A - createSerialWrapperFromResults >> Error in : ' + error.getMessage() + ' at line: ' + error.getLineNumber() + ' stack trace: ' + error.getStackTraceString();
            System.debug(errorMessage);
        }
        return null;
    }

    /**
    * @createdBy Andrea Liverani
    * @date 13/02/2019
    * @description
    * @param
    * @return
    */
    @AuraEnabled
    public static Id save(String transferDetailSelected, String originWarehouseSelected, String destinationWarehouseSelected, String originDealerSelected, String destinationDealerSelected, String objQuantityList, String objSerialList, String note, String distributionListId, String stockOrderId) {

        Savepoint sp = Database.setSavepoint();

        try {

            System.debug('[START] @A - save');
            System.debug('[PROCESSING] @A - save - transferDetailSelected >> ' + transferDetailSelected);
            System.debug('[PROCESSING] @A - save - originWarehouseSelected >> ' + originWarehouseSelected);
            System.debug('[PROCESSING] @A - save - destinationWarehouseSelected >> ' + destinationWarehouseSelected);
            System.debug('[PROCESSING] @A - save - originDealerSelected >> ' + originDealerSelected);
            System.debug('[PROCESSING] @A - save - destinationDealerSelected >> ' + destinationDealerSelected);
            System.debug('[PROCESSING] @A - save - objQuantityList >> ' + objQuantityList);
            System.debug('[PROCESSING] @A - save - objSerialList >> ' + objSerialList);
            System.debug('[PROCESSING] @A - save - note >> ' + note);
            System.debug('[PROCESSING] @A - save - distributionListId >> ' + distributionListId);
            System.debug('[PROCESSING] @A - save - stockOrderId >> ' + stockOrderId);

            List<String> dliQuantityIdsList = new List<String>();
            List<String> dliSerialIdsList = new List<String>();
            List<String> stockSerialIdsList = new List<String>();

            List<Plc_DistributionListItem__c> dliQuantityList = new List<Plc_DistributionListItem__c>();
            List<Plc_DistributionListItem__c> dliSerialList = new List<Plc_DistributionListItem__c>();
            List<Bit2Shop__Stock_Serials2__c> stockSerialList = new List<Bit2Shop__Stock_Serials2__c>();
            List<Bit2Shop__Product_Stock__c> productStockList = new List<Bit2Shop__Product_Stock__c>();

            List<dliWrapper> dliWrapperQuantityList = (List<dliWrapper>) JSON.deserialize(objQuantityList, List<dliWrapper>.class);
            List<dliWrapper> dliWrapperSerialList = (List<dliWrapper>) JSON.deserialize(objSerialList, List<dliWrapper>.class);

            //START FIX [#20190308AL] - 08 mar 2019 13:21 - Andrea Liverani (WR) - andrea.liverani@webresults.it
            Map<String, String> objectIdToRdaLookupMap = new Map<String, String>();
            //END FIX [#20190308AL] - 08 mar 2019 13:21 - Andrea Liverani (WR) - andrea.liverani@webresults.it


            System.debug('dliWrapperQuantityList >> ' + dliWrapperQuantityList);
            System.debug('dliWrapperSerialList >> ' + dliWrapperSerialList);
            System.debug('originDealerSelected >> ' + originDealerSelected);

            //Map<String, String> dliQuantityWrapperMap = new Map<String, String>();
            //Map<String, String> dliSerialWrapperMap = new Map<String, String>();

            if (!dliWrapperQuantityList.isEmpty()) {
                for (dliWrapper dliQuantity : dliWrapperQuantityList) {
                    if (Decimal.valueOf(dliQuantity.qtSelected) > 0) {
                        //dliQuantityWrapperMap.put(dliQuantity.id, dliQuantity.qtSelected);
                        objectIdToRdaLookupMap.put(dliQuantity.productStockId, dliQuantity.rdaNumber);
                        productStockList.add(new Bit2Shop__Product_Stock__c(Id = dliQuantity.productStockId, Bit2Shop__Shipped_Qty__c = Decimal.valueOf(dliQuantity.qtSelected), Bit2Shop__Stock_Qty__c = Decimal.valueOf(dliQuantity.qtStorage)));
                    }
                }
                upsert productStockList;
            }

            if (!dliWrapperSerialList.isEmpty()) {
                for (dliWrapper dliSerial : dliWrapperSerialList) {
                    if (Decimal.valueOf(dliSerial.qtSelected) > 0) {
                        objectIdToRdaLookupMap.put(dliSerial.productStockId, dliSerial.rdaNumber);
                        //dliSerialWrapperMap.put(dliSerial.id, dliSerial.qtSelected);
                        for (stockSerialWrapper serialWrapper : dliSerial.stockSerialWrapperList) {
                            //START FIX [#20190308AL] - 08 mar 2019 13:23 - Andrea Liverani (WR) - andrea.liverani@webresults.it
                            objectIdToRdaLookupMap.put(serialWrapper.id, dliSerial.rdaNumber);
                            //END FIX [#20190308AL] - 08 mar 2019 13:23 - Andrea Liverani (WR) - andrea.liverani@webresults.it
                            stockSerialIdsList.add(serialWrapper.id);
                        }
                    }
                }
            }

            List<Plc_PurchaseOrder__c> purchaseOrderList = [SELECT Id, Plc_RdaNumber__c FROM Plc_PurchaseOrder__c WHERE Plc_RdaNumber__c IN :objectIdToRdaLookupMap.values()];

            /*dliQuantityList = [SELECT Id, Plc_ShippedQty__c FROM Plc_DistributionListItem__c WHERE Id IN :dliQuantityWrapperMap.keySet()];
            dliSerialList = [SELECT Id, Plc_ShippedQty__c FROM Plc_DistributionListItem__c WHERE Id IN :dliSerialWrapperMap.keySet()];

            for (Plc_DistributionListItem__c dliQuantity : dliQuantityList) {
                if (dliQuantity.Plc_ShippedQty__c != null) {
                    dliQuantity.Plc_ShippedQty__c += Decimal.valueOf(dliQuantityWrapperMap.get(dliQuantity.Id));
                } else {
                    dliQuantity.Plc_ShippedQty__c = Decimal.valueOf(dliQuantityWrapperMap.get(dliQuantity.Id));
                }
            }

            for (Plc_DistributionListItem__c dliSerial : dliSerialList) {
                dliSerial.Plc_ShippedQty__c += Decimal.valueOf(dliSerialWrapperMap.get(dliSerial.Id));
            }


            System.debug('dliQuantityList >> ' + dliQuantityList);
            System.debug('stockSerialIdsList >> ' + stockSerialIdsList);
            System.debug('warehouseId >> ' + originWarehouseId);

            upsert dliQuantityList;
            upsert dliSerialList;*/

            if (!stockSerialIdsList.isEmpty()) {
                stockSerialList = [SELECT Id, Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c, Bit2Shop__Product_Stock_Id__r.Name FROM Bit2Shop__Stock_Serials2__c WHERE Id IN :stockSerialIdsList];
            }

            Bit2Shop__StockOrder__c stockOrderToCreate = new Bit2Shop__StockOrder__c();
            NE__Order__c configurationToCreate;

            if (String.isBlank(stockOrderId)) {
                Bit2Shop__Warehouse__c destinationWarehouse = [SELECT Id, Bit2Shop__Dealer_Id__c, Bit2Shop__Dealer_Id__r.Bit2Shop__Account_Id__c, Bit2Shop__Dealer_Id__r.OwnerId FROM Bit2Shop__Warehouse__c WHERE Name = :destinationWarehouseSelected OR Id = :destinationWarehouseSelected];
                Bit2Shop__Warehouse__c originWarehouse = [SELECT Id, Bit2Shop__Dealer_Id__c, Bit2Shop__Dealer_Id__r.Bit2Shop__Account_Id__c, Bit2Shop__Dealer_Id__r.OwnerId FROM Bit2Shop__Warehouse__c WHERE Name = :originWarehouseSelected OR Id = :originWarehouseSelected];
                /** [START MOD 23/02/2019 17:45]@Author:marco.lebellini@/webresults.it @Description: **/
                //Bit2Shop__TransferDetail__c transferDetail = [SELECT Id, Bit2Shop__Transfer_Type__c FROM Bit2Shop__TransferDetail__c WHERE Name = :transferDetailSelected];
                Bit2Shop__TransferDetail__c transferDetail = [
                        SELECT Id, Plc_FilterDestinationDealer__c, Bit2Shop__Transfer_Type__c
                        FROM Bit2Shop__TransferDetail__c
                        WHERE Bit2Shop__Code__c = :transferDetailSelected
                ];
                /** [END MOD 23/02/2019 17:45]@Author:marco.lebellini@/webresults.it @Description: **/
                //Stock Order
                stockOrderToCreate.Bit2Shop__Status__c = Plc_Constants.B2S_StockOrder.B2S_Status_Generated;
                stockOrderToCreate.Bit2Shop__Destination_Warehouse_Id__c = destinationWarehouse.Id;
                stockOrderToCreate.Bit2Shop__Warehouse_Id__c = originWarehouse.Id;
                stockOrderToCreate.Bit2Shop__Transfer_Type__c = transferDetail.Bit2Shop__Transfer_Type__c;
                stockOrderToCreate.Plc_TransferDetail__c = transferDetail.Id;
                stockOrderToCreate.Bit2Shop__Point_Of_Sales_Id__c = originWarehouse.Bit2Shop__Dealer_Id__c;
                stockOrderToCreate.Bit2Shop__Holding_Id__c = originWarehouse.Bit2Shop__Dealer_Id__r.Bit2Shop__Account_Id__c;
                stockOrderToCreate.Bit2Shop__Destination_Point_Of_Sales_Id__c = destinationWarehouse.Bit2Shop__Dealer_Id__c;

                //START FIX [#20190327AL] - 27 mar 2019 11:40 - Andrea Liverani (WR) - andrea.liverani@webresults.it
                List<Bit2Shop__Dealer_User__c > dealerUserList = [SELECT Id, Bit2Shop__User_Id__c FROM Bit2Shop__Dealer_User__c WHERE Bit2Shop__Dealer_Id__c = :originWarehouse.Bit2Shop__Dealer_Id__c];
                String currentUserId = UserInfo.getUserId();
                Boolean containsUserId = false;

                if (!dealerUserList.isEmpty()) {
                    for (Bit2Shop__Dealer_User__c dealerUser : dealerUserList) {
                        if (dealerUser.Bit2Shop__User_Id__c == currentUserId) {
                            containsUserId = true;
                            continue;
                        }
                    }
                }

                if (currentUserId != originWarehouse.Bit2Shop__Dealer_Id__r.OwnerId && !containsUserId) {
                    stockOrderToCreate.OwnerId = originWarehouse.Bit2Shop__Dealer_Id__r.OwnerId;
                } else {
                    stockOrderToCreate.OwnerId = currentUserId;
                }

                //stockOrderToCreate.OwnerId = originWarehouse.Bit2Shop__Dealer_Id__r.OwnerId;
                //END FIX [#20190327AL] - 27 mar 2019 11:40 - Andrea Liverani (WR) - andrea.liverani@webresults.it

                stockOrderToCreate.Plc_DistributionList__c = distributionListId;
                stockOrderToCreate.RecordtypeId = Plc_Utils.getRecordTypeId(Plc_Constants.B2S_StockOrder.RecordType_Transfer,
                        Bit2Shop__StockOrder__c.SObjectType.getDescribe().name);
                if (note != null) {
                    stockOrderToCreate.Bit2Shop__Note__c = note;
                }
                insert stockOrderToCreate;

                //Configuration
                configurationToCreate = new NE__Order__c(
                        RecordTypeId = Plc_Utils.getRecordTypeId(Plc_Constants.NE_Order.RecordType_StockOrder, NE__Order__c.SObjectType.getDescribe().name),
                        Bit2Shop__StockOrder__c = stockOrderToCreate.Id,
                        Bit2Shop__Cost_Total__c = 0,
                        NE__AccountId__c = stockOrderToCreate.Bit2Shop__Holding_Id__c,
                        NE__OrderStatus__c = 'Pending',
                        NE__ConfigurationStatus__c = Plc_Constants.NE_Order.NE_ConfigurationStatus_InProgress,
                        NE__Version__c = 1

                );
                insert configurationToCreate;

            } else {
                stockOrderToCreate = [SELECT Id, Bit2Shop__Holding_Id__c, OwnerId, Bit2Shop__Destination_Warehouse_Id__c, Plc_TransferDetail__c FROM Bit2Shop__StockOrder__c WHERE Id = :stockOrderId];
                //recupero il configuration
                configurationToCreate = [SELECT Id FROM NE__Order__c WHERE Bit2Shop__StockOrder__c = :StockOrderId].get(0);
                //recupero i configuration Items
                List<NE__OrderItem__c> configurationItems = [SELECT Id FROM NE__OrderItem__c WHERE NE__OrderId__c = :configurationToCreate.Id];
                //recupero gli shipment
                Map<Id, Bit2Shop__Shipment__c> shipments = new Map<Id, Bit2Shop__Shipment__c>([SELECT Id FROM Bit2Shop__Shipment__c WHERE Bit2Shop__Stock_Order_Id__c = :StockOrderId]);
                List<Bit2Shop__Shipment__c> shipmentsToDelete = shipments.values();
                //recupero tutti gli SLI
                List<Bit2Shop__Shipment_Line_Item__c> shipmentLineItems = [SELECT Id FROM Bit2Shop__Shipment_Line_Item__c WHERE Bit2Shop__Shipment_Id__c IN:shipments.keySet()];
                //Elimino la struttura esistente
                delete shipmentLineItems;
                delete shipmentsToDelete;
                delete configurationItems;

            }

            System.debug('save - stockSerialList >> ' + stockSerialList);
            System.debug('save - configurationToCreate >> ' + configurationToCreate);
            System.debug('save - stockOrderToCreate >> ' + stockOrderToCreate);
            //creo la struttura da configuration item in giu per i prodotti a seriale
            Plc_Utils.shipmentsUtils.createProductSerialStructure(stockSerialList, configurationToCreate, stockOrderToCreate, false);

            //creo la struttura da configuration item in giu per i prodotti a quantità
            Plc_Utils.shipmentsUtils.createProductQuantityStructure(productStockList, configurationToCreate, stockOrderToCreate, false);

            //START FIX [#20190308AL] - 08 mar 2019 14:06 - Andrea Liverani (WR) - andrea.liverani@webresults.it
            List<Bit2Shop__Shipment_Line_Item__c> serialSliList = [SELECT Id, Plc_StockSerial__c FROM Bit2Shop__Shipment_Line_Item__c WHERE Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__c = :stockOrderToCreate.Id AND Bit2Shop__Type__c = 'Serial'];

            List<Bit2Shop__Shipment_Line_Item__c> productSliList = [SELECT Id, Bit2Shop__Product_Stock_Id__c FROM Bit2Shop__Shipment_Line_Item__c WHERE Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__c = :stockOrderToCreate.Id AND Bit2Shop__Type__c = 'Product'];

            Map<String, String> stockSerialIdToSliId = new Map<String, String>();

            for (Bit2Shop__Shipment_Line_Item__c sli : serialSliList) {
                for (Plc_PurchaseOrder__c purchaseOrder : purchaseOrderList) {
                    if (objectIdToRdaLookupMap.get(sli.Plc_StockSerial__c) == purchaseOrder.Plc_RdaNumber__c) {
                        sli.Plc_PurchaseOrder__c = purchaseOrder.Id;
                        stockSerialIdToSliId.put(sli.Plc_StockSerial__c, sli.Id);
                    }

                }
            }

            List<Bit2Shop__Stock_Serials2__c> stockSerialListToUpdate = [SELECT Id FROM Bit2Shop__Stock_Serials2__c WHERE Id IN :stockSerialIdToSliId.keySet()];

            if (!stockSerialListToUpdate.isEmpty()) {
                for (Bit2Shop__Stock_Serials2__c stockSerial : stockSerialListToUpdate) {
                    stockSerial.Bit2Shop__Shipment_Line_Item_Id__c = stockSerialIdToSliId.get(stockSerial.Id);
                }
                update stockSerialListToUpdate;
            }

            for (Bit2Shop__Shipment_Line_Item__c sli : productSliList) {
                for (Plc_PurchaseOrder__c purchaseOrder : purchaseOrderList) {
                    if (objectIdToRdaLookupMap.get(sli.Bit2Shop__Product_Stock_Id__c) == purchaseOrder.Plc_RdaNumber__c) {
                        sli.Plc_PurchaseOrder__c = purchaseOrder.Id;
                    }

                }
            }

            update productSliList;
            update serialSliList;
            //END FIX [#20190308AL] - 08 mar 2019 14:06 - Andrea Liverani (WR) - andrea.liverani@webresults.it

            System.debug('[END] @A - save');

            if (String.isBlank(stockOrderId)) {
                return stockOrderToCreate.Id;
            } else {
                return stockOrderId;
            }

        } catch (Exception error) {
            Database.rollback(sp);
            String errorMessage = '[EXCEPTION] @A - save >> Error in : ' + error.getMessage() + ' at line: ' + error.getLineNumber() + ' stack trace: ' + error.getStackTraceString();
            System.debug(errorMessage);
        }

        return null;
    }

    //START FIX [#20190410AL] - 10 apr 2019 15:59 - Andrea Liverani (WR) - andrea.liverani@webresults.it
    @AuraEnabled
    public static List<String> save_new(String transferDetailSelected, String originWarehouseSelected, String destinationWarehouseSelected, String originDealerSelected, String destinationDealerSelected, String objQuantityList, String objSerialList, String note, String distributionListId, String stockOrderId) {

        Savepoint sp = Database.setSavepoint();

        try {
            List<dliWrapper> dliWrapperQuantityList = (List<dliWrapper>) JSON.deserialize(objQuantityList, List<dliWrapper>.class);
            List<dliWrapper> dliWrapperSerialList = (List<dliWrapper>) JSON.deserialize(objSerialList, List<dliWrapper>.class);

            Map<String, List<Bit2Shop__Product_Stock__c>> rdaNumberToProductStockListMap = new Map<String, List<Bit2Shop__Product_Stock__c>>();
            Map<String, List<Bit2Shop__Stock_Serials2__c>> rdaNumberToStockSerialListMap = new Map<String, List<Bit2Shop__Stock_Serials2__c>>();
            List<String> stockSerialIdsList = new List<String>();

            List<dliWrapper> dliWrapperTotalList = new List<dliWrapper>();
            dliWrapperTotalList.addAll(dliWrapperSerialList);
            dliWrapperTotalList.addAll(dliWrapperQuantityList);

            for (dliWrapper dli : dliWrapperTotalList) {
                rdaNumberToProductStockListMap.put(dli.rdaNumber, new List<Bit2Shop__Product_Stock__c>());
                rdaNumberToStockSerialListMap.put(dli.rdaNumber, new List<Bit2Shop__Stock_Serials2__c>());
            }

            for (String rdaNumber : rdaNumberToProductStockListMap.keySet()) {
                for (dliWrapper dli : dliWrapperTotalList) {
                    List<Bit2Shop__Product_Stock__c> productStockListRelatedToRdaNumber = new List<Bit2Shop__Product_Stock__c>();
                    List<Bit2Shop__Stock_Serials2__c> stockSerialListRelatedToRdaNumber = new List<Bit2Shop__Stock_Serials2__c>();
                    if (dli.rdaNumber == rdaNumber) {
                        productStockListRelatedToRdaNumber.add(new Bit2Shop__Product_Stock__c(Id = dli.productStockId, Bit2Shop__Shipped_Qty__c = Decimal.valueOf(dli.qtSelected), Bit2Shop__Stock_Qty__c = Decimal.valueOf(dli.qtStorage)));
                        if (dli.stockSerialWrapperList != null && dli.stockSerialWrapperList.size() > 0) {
                            for (stockSerialWrapper serialWrapper : dli.stockSerialWrapperList) {
                                stockSerialListRelatedToRdaNumber.add(new Bit2Shop__Stock_Serials2__c(Id = serialWrapper.Id, Bit2Shop__Product_Stock_Id__c = serialWrapper.productStockId));
                            }
                        }

                    }

                    if(!stockSerialListRelatedToRdaNumber.isEmpty()) {
                        rdaNumberToStockSerialListMap.get(rdaNumber).addAll(stockSerialListRelatedToRdaNumber);
                    }

                    if(!productStockListRelatedToRdaNumber.isEmpty()) {
                        rdaNumberToProductStockListMap.get(rdaNumber).addAll(productStockListRelatedToRdaNumber);
                    }
                }
            }

            Map<String, Object> objectIdToRdaLookupMap = new Map<String, Object>();
            for (List<Bit2Shop__Stock_Serials2__c> stockSerialList : rdaNumberToStockSerialListMap.values()) {
                for (Bit2Shop__Stock_Serials2__c stockSerial : stockSerialList) {
                    objectIdToRdaLookupMap.put(stockSerial.Id, stockSerial);
                }
            }

            for (List<Bit2Shop__Product_Stock__c> productStockList : rdaNumberToProductStockListMap.values()) {
                for (Bit2Shop__Product_Stock__c productStock : productStockList) {
                    objectIdToRdaLookupMap.put(productStock.Id, productStock);
                }
            }

            List<String> rdaNumberList = new List<String>();
            for (String rda : rdaNumberToStockSerialListMap.keySet()) {
                rdaNumberList.add(rda);
            }

            for (String rda : rdaNumberToProductStockListMap.keySet()) {
                rdaNumberList.add(rda);
            }

            List<Plc_PurchaseOrder__c> purchaseOrderList = [SELECT Id, Plc_RdaNumber__c FROM Plc_PurchaseOrder__c WHERE Plc_RdaNumber__c IN :rdaNumberList];
            List<Bit2Shop__StockOrder__c> stockOrderList = new List<Bit2Shop__StockOrder__c>();
            List<NE__Order__c> configurationList = new List<NE__Order__c>();
            List<String> stockOrderIdsList = new List<String>();

            if (String.isBlank(stockOrderId)) {
                if (!purchaseOrderList.isEmpty()) {

                    Bit2Shop__Warehouse__c destinationWarehouse = [SELECT Id, Bit2Shop__Dealer_Id__c, Bit2Shop__Dealer_Id__r.Bit2Shop__Account_Id__c, Bit2Shop__Dealer_Id__r.OwnerId FROM Bit2Shop__Warehouse__c WHERE Name = :destinationWarehouseSelected OR Id = :destinationWarehouseSelected];
                    Bit2Shop__Warehouse__c originWarehouse = [SELECT Id, Bit2Shop__Dealer_Id__c, Bit2Shop__Dealer_Id__r.Bit2Shop__Account_Id__c, Bit2Shop__Dealer_Id__r.OwnerId FROM Bit2Shop__Warehouse__c WHERE Name = :originWarehouseSelected OR Id = :originWarehouseSelected];
                    Bit2Shop__TransferDetail__c transferDetail = [SELECT Id, Plc_FilterDestinationDealer__c, Bit2Shop__Transfer_Type__c FROM Bit2Shop__TransferDetail__c WHERE Bit2Shop__Code__c = :transferDetailSelected];

                    //START FIX [#20190327AL] - 27 mar 2019 11:40 - Andrea Liverani (WR) - andrea.liverani@webresults.it
                    List<Bit2Shop__Dealer_User__c > dealerUserList = [SELECT Id, Bit2Shop__User_Id__c FROM Bit2Shop__Dealer_User__c WHERE Bit2Shop__Dealer_Id__c = :originWarehouse.Bit2Shop__Dealer_Id__c];
                    String currentUserId = UserInfo.getUserId();
                    String stockOrderOwnerId = '';
                    Boolean containsUserId = false;

                    if (!dealerUserList.isEmpty()) {
                        for (Bit2Shop__Dealer_User__c dealerUser : dealerUserList) {
                            if (dealerUser.Bit2Shop__User_Id__c == currentUserId) {
                                containsUserId = true;
                                continue;
                            }
                        }
                    }

                    if (currentUserId != originWarehouse.Bit2Shop__Dealer_Id__r.OwnerId && !containsUserId) {
                        stockOrderOwnerId = originWarehouse.Bit2Shop__Dealer_Id__r.OwnerId;
                    } else {
                        stockOrderOwnerId = currentUserId;
                    }
                    //stockOrder.OwnerId = originWarehouse.Bit2Shop__Dealer_Id__r.OwnerId;
                    //END FIX [#20190327AL] - 27 mar 2019 11:40 - Andrea Liverani (WR) - andrea.liverani@webresults.it

                    for (Plc_PurchaseOrder__c purchaseOrder : purchaseOrderList) {

                        Bit2Shop__StockOrder__c stockOrder = new Bit2Shop__StockOrder__c();
                        stockOrder.Bit2Shop__Status__c = Plc_Constants.B2S_StockOrder.B2S_Status_Generated;
                        stockOrder.Bit2Shop__Destination_Warehouse_Id__c = destinationWarehouse.Id;
                        stockOrder.Bit2Shop__Warehouse_Id__c = originWarehouse.Id;
                        stockOrder.Bit2Shop__Transfer_Type__c = transferDetail.Bit2Shop__Transfer_Type__c;
                        stockOrder.Plc_TransferDetail__c = transferDetail.Id;
                        stockOrder.Bit2Shop__Point_Of_Sales_Id__c = originWarehouse.Bit2Shop__Dealer_Id__c;
                        stockOrder.Bit2Shop__Holding_Id__c = originWarehouse.Bit2Shop__Dealer_Id__r.Bit2Shop__Account_Id__c;
                        stockOrder.Bit2Shop__Destination_Point_Of_Sales_Id__c = destinationWarehouse.Bit2Shop__Dealer_Id__c;
                        stockOrder.Plc_PurchaseOrder__c = purchaseOrder.Id;
                        stockOrder.OwnerId = stockOrderOwnerId;
                        stockOrder.Plc_DistributionList__c = distributionListId;
                        stockOrder.RecordtypeId = Plc_Utils.getRecordTypeId(Plc_Constants.B2S_StockOrder.RecordType_Transfer, Bit2Shop__StockOrder__c.SObjectType.getDescribe().name);
                        if (note != null) {
                            stockOrder.Bit2Shop__Note__c = note;
                        }

                        NE__Order__c configuration = new NE__Order__c();
                        configuration.RecordTypeId = Plc_Utils.getRecordTypeId(Plc_Constants.NE_Order.RecordType_StockOrder, NE__Order__c.SObjectType.getDescribe().name);
                        configuration.Bit2Shop__Cost_Total__c = 0;
                        configuration.NE__OrderStatus__c = 'Pending';
                        configuration.NE__ConfigurationStatus__c = Plc_Constants.NE_Order.NE_ConfigurationStatus_InProgress;
                        configuration.NE__Version__c = 1;
                        configuration.Bit2Shop__StockOrder__c = stockOrder.Id;
                        configuration.NE__AccountId__c = stockOrder.Bit2Shop__Holding_Id__c;

                        stockOrderList.add(stockOrder);
                        stockOrderIdsList.add(stockOrder.Id);
                        configurationList.addAll(configurationList);

                        createProductSerialStructureFuture(JSON.serialize(rdaNumberToStockSerialListMap.get(purchaseOrder.Plc_RdaNumber__c)), JSON.serialize(configuration), JSON.serialize(stockOrder), false);
                        createProductQuantityStructureFuture(JSON.serialize(rdaNumberToProductStockListMap.get(purchaseOrder.Plc_RdaNumber__c)), JSON.serialize(configuration), JSON.serialize(stockOrder), false);
                    }

                    insert stockOrderList;
                    insert configurationList;
                }
            } else {
                stockOrderIdsList.add(stockOrderId);
                Bit2Shop__StockOrder__c stockOrderToCreate = [SELECT Id, Bit2Shop__Holding_Id__c, OwnerId, Bit2Shop__Destination_Warehouse_Id__c, Plc_TransferDetail__c, Plc_PurchaseOrder__c, Plc_PurchaseOrder__r.Plc_RdaNumber__c FROM Bit2Shop__StockOrder__c WHERE Id = :stockOrderId];
                NE__Order__c configurationToCreate = [SELECT Id FROM NE__Order__c WHERE Bit2Shop__StockOrder__c = :StockOrderId].get(0);
                List<NE__OrderItem__c> configurationItems = [SELECT Id FROM NE__OrderItem__c WHERE NE__OrderId__c = :configurationToCreate.Id];
                Map<Id, Bit2Shop__Shipment__c> shipments = new Map<Id, Bit2Shop__Shipment__c>([SELECT Id FROM Bit2Shop__Shipment__c WHERE Bit2Shop__Stock_Order_Id__c = :StockOrderId]);
                List<Bit2Shop__Shipment__c> shipmentsToDelete = shipments.values();
                List<Bit2Shop__Shipment_Line_Item__c> shipmentLineItems = [SELECT Id FROM Bit2Shop__Shipment_Line_Item__c WHERE Bit2Shop__Shipment_Id__c IN:shipments.keySet()];

                delete shipmentLineItems;
                delete shipmentsToDelete;
                delete configurationItems;
                
                createProductSerialStructureFuture(JSON.serialize(rdaNumberToStockSerialListMap.get(stockOrderToCreate.Plc_PurchaseOrder__r.Plc_RdaNumber__c)), JSON.serialize(configurationToCreate), JSON.serialize(stockOrderToCreate), false);
                createProductQuantityStructureFuture(JSON.serialize(rdaNumberToProductStockListMap.get(stockOrderToCreate.Plc_PurchaseOrder__r.Plc_RdaNumber__c)), JSON.serialize(configurationToCreate), JSON.serialize(stockOrderToCreate), false);
            }

            //START FIX [#20190308AL] - 08 mar 2019 14:06 - Andrea Liverani (WR) - andrea.liverani@webresults.it
            List<Bit2Shop__Shipment_Line_Item__c> serialSliList = [SELECT Id, Plc_StockSerial__c FROM Bit2Shop__Shipment_Line_Item__c WHERE Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__c IN :stockOrderIdsList AND Bit2Shop__Type__c = 'Serial'];
            List<Bit2Shop__Shipment_Line_Item__c> productSliList = [SELECT Id, Bit2Shop__Product_Stock_Id__c FROM Bit2Shop__Shipment_Line_Item__c WHERE Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__c IN :stockOrderIdsList AND Bit2Shop__Type__c = 'Product'];

            Map<String, String> stockSerialIdToSliId = new Map<String, String>();

            for (Bit2Shop__Shipment_Line_Item__c sli : serialSliList) {
                for (Plc_PurchaseOrder__c purchaseOrder : purchaseOrderList) {
                    if (objectIdToRdaLookupMap.get(sli.Plc_StockSerial__c) == purchaseOrder.Plc_RdaNumber__c) {
                        sli.Plc_PurchaseOrder__c = purchaseOrder.Id;
                        stockSerialIdToSliId.put(sli.Plc_StockSerial__c, sli.Id);
                    }
                }
            }

            List<Bit2Shop__Stock_Serials2__c> stockSerialListToUpdate = [SELECT Id FROM Bit2Shop__Stock_Serials2__c WHERE Id IN :stockSerialIdToSliId.keySet()];

            if (!stockSerialListToUpdate.isEmpty()) {
                for (Bit2Shop__Stock_Serials2__c stockSerial : stockSerialListToUpdate) {
                    stockSerial.Bit2Shop__Shipment_Line_Item_Id__c = stockSerialIdToSliId.get(stockSerial.Id);
                }
                update stockSerialListToUpdate;
            }

            for (Bit2Shop__Shipment_Line_Item__c sli : productSliList) {
                for (Plc_PurchaseOrder__c purchaseOrder : purchaseOrderList) {
                    if (objectIdToRdaLookupMap.get(sli.Bit2Shop__Product_Stock_Id__c) == purchaseOrder.Plc_RdaNumber__c) {
                        sli.Plc_PurchaseOrder__c = purchaseOrder.Id;
                    }
                }
            }

            update productSliList;
            update serialSliList;
            //END FIX [#20190308AL] - 08 mar 2019 14:06 - Andrea Liverani (WR) - andrea.liverani@webresults.it

            System.debug('[END] @A - save : stockOrderIdToBeReturned >>' + stockOrderIdsList);
            return stockOrderIdsList;
        } catch (Exception error) {
            Database.rollback(sp);
            String errorMessage = '[EXCEPTION] @A - save >> Error in : ' + error.getMessage() + ' at line: ' + error.getLineNumber() + ' stack trace: ' + error.getStackTraceString();
            System.debug(errorMessage);
        }
        return null;
    }

    @future(callout = true)
    public static void createProductSerialStructureFuture(String selectedProductSerialSerialized, String configurationToCreateSerialized, String stockOrderSerialized, Boolean toClose) {

        List<Bit2Shop__Stock_Serials2__c> selectedProductSerial = (List<Bit2Shop__Stock_Serials2__c>) JSON.deserialize(selectedProductSerialSerialized, List<Bit2Shop__Stock_Serials2__c>.class);
        NE__Order__c configurationToCreate = (NE__Order__c) JSON.deserialize(configurationToCreateSerialized, NE__Order__c.class);
        Bit2Shop__StockOrder__c stockOrder = (Bit2Shop__StockOrder__c) JSON.deserialize(stockOrderSerialized, Bit2Shop__StockOrder__c.class);

        Plc_Utils.shipmentsUtils.createProductSerialStructure(selectedProductSerial, configurationToCreate, stockOrder, toClose);
    }

    @future(callout = true)
    public static void createProductQuantityStructureFuture(String selectedProductQuantitySerialized, String configurationToCreateSerialized, String stockOrderSerialized, Boolean toClose) {

        List<Bit2Shop__Product_Stock__c> selectedProductQuantity = (List<Bit2Shop__Product_Stock__c>) JSON.deserialize(selectedProductQuantitySerialized, List<Bit2Shop__Product_Stock__c>.class);
        NE__Order__c configurationToCreate = (NE__Order__c) JSON.deserialize(configurationToCreateSerialized, NE__Order__c.class);
        Bit2Shop__StockOrder__c stockOrder = (Bit2Shop__StockOrder__c) JSON.deserialize(stockOrderSerialized, Bit2Shop__StockOrder__c.class);

        Plc_Utils.shipmentsUtils.createProductQuantityStructure(selectedProductQuantity, configurationToCreate, stockOrder, toClose);
    }
    //END FIX [#20190410AL] - 10 apr 2019 15:59 - Andrea Liverani (WR) - andrea.liverani@webresults.it


    /**
    * @createdBy Andrea Liverani
    * @date 19/02/2019
    * @description
    * @param
    * @return
    */
    @AuraEnabled(cacheable = true)
    public static Map<String, Object> loadDataForEdit(String stockOrderId) {

        try {
            System.debug('[START] @A - loadDataForEdit');
            System.debug('[PROCESSING] @A - loadDataForEdit - stockOrderId >> ' + stockOrderId);

            Map<String, Object> dataLoadedMap = new Map<String, Object>();

            if (!String.isBlank(stockOrderId)) {
                Bit2Shop__StockOrder__c stockOrder = [
                        SELECT Id, Bit2Shop__Destination_Warehouse_Id__c, Bit2Shop__Destination_Point_Of_Sales_Id__c,
                                Bit2Shop__Warehouse_Id__c, Plc_DistributionList__c, Bit2Shop__Point_Of_Sales_Id__c, Bit2Shop__Warehouse_Id__r.Name,
                                Bit2Shop__Destination_Warehouse_Id__r.Name, Bit2Shop__Destination_Point_Of_Sales_Id__r.Name,
                                Bit2Shop__Point_Of_Sales_Id__r.Name, Plc_TransferDetail__r.Name, Plc_TransferDetail__r.Bit2Shop__Code__c
                        FROM Bit2Shop__StockOrder__c
                        WHERE Id = :stockOrderId
                ];

                System.debug('stockOrder >> ' + stockOrder);
                System.debug('stockOrder >> ' + stockOrder.Bit2Shop__Destination_Warehouse_Id__r.Name);

                dataLoadedMap.put('destinationWarehouseSelected', stockOrder.Bit2Shop__Destination_Warehouse_Id__r.Name);
                dataLoadedMap.put('destinationDealerSelected', stockOrder.Bit2Shop__Destination_Point_Of_Sales_Id__r.Name);
                dataLoadedMap.put('originWarehouseSelected', stockOrder.Bit2Shop__Warehouse_Id__r.Name);
                dataLoadedMap.put('originDealerSelected', stockOrder.Bit2Shop__Point_Of_Sales_Id__r.Name);
                /** [START MOD 24/02/2019 11:30]@Author:marco.lebellini@/webresults.it @Description: **/
                //dataLoadedMap.put('transferDetailSelected', stockOrder.Plc_TransferDetail__r.Name);
                dataLoadedMap.put('transferDetailSelected', stockOrder.Plc_TransferDetail__r.Bit2Shop__Code__c);
                //dataLoadedMap.put('originalTransferDetailSelected', stockOrder.Plc_TransferDetail__r.Name);
                /** [END MOD 24/02/2019 11:30]@Author:marco.lebellini@/webresults.it @Description: **/
                //dataLoadedMap.put('transferDetailSelected', stockOrder.Plc_TransferDetail__r.Bit2Shop__Code__c);
                dataLoadedMap.put('transferDetailSelected', stockOrder.Plc_TransferDetail__r.Name);
                dataLoadedMap.put('destinationWarehouseSelectedId', stockOrder.Bit2Shop__Destination_Warehouse_Id__c);
                dataLoadedMap.put('destinationDealerSelectedId', stockOrder.Bit2Shop__Destination_Point_Of_Sales_Id__c);
                dataLoadedMap.put('originWarehouseSelectedId', stockOrder.Bit2Shop__Warehouse_Id__c);
                dataLoadedMap.put('originDealerSelectedId', stockOrder.Bit2Shop__Point_Of_Sales_Id__c);

                if (stockOrder != null) {
                    Plc_DistributionList__c distributionList = [SELECT Id, Name FROM Plc_DistributionList__c WHERE Id = :stockOrder.Plc_DistributionList__c];

                    dataLoadedMap.put('distributionListId', distributionList.Id);
                    dataLoadedMap.put('distributionListName', distributionList.Name);
                }
            }

            System.debug('[PROCESSING] @A - loadDataForEdit - dataLoadedMap >> ' + dataLoadedMap);
            System.debug('[END] @A - loadDataForEdit');
            return dataLoadedMap;

        } catch (Exception error) {
            String errorMessage = '[EXCEPTION] @A - loadDataForEdit >> Error in : ' + error.getMessage() + ' at line: ' + error.getLineNumber() + ' stack trace: ' + error.getStackTraceString();
            System.debug(errorMessage);
        }
        return null;
    }

    @AuraEnabled(cacheable = true)
    public static Map<String, Object> feedWrappers(String stockOrderId, String objQuantityList, String objSerialList) {

        try {
            System.debug('[START] @A - feedWrappers');
            System.debug('[PROCESSING] @A - feedWrappers - stockOrderId >> ' + stockOrderId);
            System.debug('[PROCESSING] @A - feedWrappers - objQuantityList >> ' + objQuantityList);
            System.debug('[PROCESSING] @A - feedWrappers - objSerialList >> ' + objSerialList);


            Map<String, Object> dataLoadedMap = new Map<String, Object>();

            List<dliWrapper> dliWrapperQuantityList = (List<dliWrapper>) JSON.deserialize(objQuantityList, List<dliWrapper>.class);
            List<dliWrapper> dliWrapperSerialList = (List<dliWrapper>) JSON.deserialize(objSerialList, List<dliWrapper>.class);
            List<String> shipmentIdsList = new List<String>();

            List<Bit2Shop__Shipment__c> outboundShipmentList = [SELECT Id FROM Bit2Shop__Shipment__c WHERE Bit2Shop__Sub_Type__c = 'Outbound' AND Bit2Shop__Stock_Order_Id__c = :stockOrderId];

            for (Bit2Shop__Shipment__c shipment : outboundShipmentList) {
                shipmentIdsList.add(shipment.Id);
            }

            List<Bit2Shop__Shipment_Line_Item__c> sliList = [SELECT Id, Plc_PurchaseOrder__r.Plc_RdaNumber__c, Bit2Shop__Requested_Quantity__c, Bit2Shop__Type__c, Bit2Shop__Target_Line_Item__c, 
                                                                    Bit2Shop__Product_Stock_Id__c, Plc_StockSerial__c, Plc_StockSerial__r.Plc_ProductSku__c,Plc_StockSerial__r.Plc_Model__c, 
                                                                    Plc_StockSerial__r.Plc_ManufacturerSerialNumber__c, Plc_StockSerial__r.Plc_EncodedSerialNumber__c, 
                                                                    Plc_StockSerial__r.Bit2Shop__Status__c, Bit2Shop__Target_Line_Item__r.Bit2Shop__Product_Stock_Id__c,
                                                                    Plc_StockSerial__r.Plc_DllSerialNumber__c
                                                             FROM Bit2Shop__Shipment_Line_Item__c 
                                                             WHERE Bit2Shop__Shipment_Id__c IN :shipmentIdsList];

            System.debug('[PROCESSING] @A - feedWrappers - sliList >> ' + sliList);

            List<Bit2Shop__Shipment_Line_Item__c> sliProductList = new List<Bit2Shop__Shipment_Line_Item__c>();
            List<Bit2Shop__Shipment_Line_Item__c> sliSerialList = new List<Bit2Shop__Shipment_Line_Item__c>();

            for (Bit2Shop__Shipment_Line_Item__c sli : sliList) {
                if (sli.Bit2Shop__Type__c == 'Product' && sli.Bit2Shop__Target_Line_Item__c == null) {
                    sliProductList.add(sli);
                } else if (sli.Bit2Shop__Type__c == 'Serial') {
                    sliSerialList.add(sli);
                }
            }

            System.debug('[PROCESSING] @A - feedWrappers - sliProductList >> ' + sliProductList);

            if (!sliProductList.isEmpty()) {
                for (dliWrapper dliProduct : dliWrapperQuantityList) {
                    for (Bit2Shop__Shipment_Line_Item__c sliProduct : sliProductList) {
                        if (dliProduct.productStockId == sliProduct.Bit2Shop__Product_Stock_Id__c) {
                            dliProduct.qtSelected = String.valueOf(sliProduct.Bit2Shop__Requested_Quantity__c);
                            //dliProduct.qtToBeSent = String.valueOf(Decimal.valueOf(dliProduct.qtToBeSent) + sliProduct.Bit2Shop__Requested_Quantity__c);
                        }
                    }
                }
            }

            System.debug('[PROCESSING] @A - feedWrappers - sliSerialList >> ' + sliSerialList);


            if (!sliSerialList.isEmpty()) {
                for (Bit2Shop__Shipment_Line_Item__c sliSerial : sliSerialList) {
                    for (dliWrapper dliSerial : dliWrapperSerialList) {
                        System.debug('[PROCESSING] @A - feedWrappers - dliSerial.productStockId >> ' + dliSerial.productStockId);
                        System.debug('[PROCESSING] @A - feedWrappers - sliSerial.productStockId >> ' + sliSerial.Bit2Shop__Target_Line_Item__r.Bit2Shop__Product_Stock_Id__c);
                        //START FIX [#20190308AL] - 08 mar 2019 14:07 - Andrea Liverani (WR) - andrea.liverani@webresults.it
                        //if (dliSerial.productStockId == sliSerial.Bit2Shop__Target_Line_Item__r.Bit2Shop__Product_Stock_Id__c) {
                        if (dliSerial.productStockId == sliSerial.Bit2Shop__Target_Line_Item__r.Bit2Shop__Product_Stock_Id__c && dliSerial.rdaNumber == sliSerial.Plc_PurchaseOrder__r.Plc_RdaNumber__c) {
                            //END FIX [#20190308AL] - 08 mar 2019 14:07 - Andrea Liverani (WR) - andrea.liverani@webresults.it
                            System.debug('[PROCESSING] @A - feedWrappers - im here >> ');
                            dliSerial.stockSerialWrapperList.add(new stockSerialWrapper(sliSerial.Plc_StockSerial__c, sliSerial.Plc_StockSerial__r.Plc_ProductSku__c, sliSerial.Plc_StockSerial__r.Plc_Model__c, sliSerial.Plc_StockSerial__r.Plc_ManufacturerSerialNumber__c, 
                                                                                        sliSerial.Plc_StockSerial__r.Plc_EncodedSerialNumber__c, sliSerial.Plc_StockSerial__r.Bit2Shop__Status__c, sliSerial.Bit2Shop__Product_Stock_Id__c, sliSerial.Plc_StockSerial__r.Plc_DllSerialNumber__c));

                            dliSerial.qtSelected = dliSerial.stockSerialWrapperList != null ? String.valueOf(dliSerial.stockSerialWrapperList.size()) : '0';
                            //dliSerial.qtToBeSent = dliSerial.stockSerialWrapperList != null ? String.valueOf(Decimal.valueOf(dliSerial.qtToBeSent) + Decimal.valueOf(dliSerial.qtSelected)) : '0';
                        }
                    }
                }
            }

            dataLoadedMap.put('dliSerialList', dliWrapperSerialList);
            dataLoadedMap.put('dliQuantityList', dliWrapperQuantityList);

            System.debug('[PROCESSING] @A - feedWrappers - dliWrapperSerialList >> ' + dliWrapperSerialList);
            System.debug('[PROCESSING] @A - feedWrappers - dliWrapperQuantityList >> ' + dliWrapperQuantityList);
            System.debug('[END] @A - feedWrappers');
            return dataLoadedMap;

        } catch (Exception error) {
            String errorMessage = '[EXCEPTION] @A - feedWrappers >> Error in : ' + error.getMessage() + ' at line: ' + error.getLineNumber() + ' stack trace: ' + error.getStackTraceString();
            System.debug(errorMessage);
        }
        return null;
    }
}