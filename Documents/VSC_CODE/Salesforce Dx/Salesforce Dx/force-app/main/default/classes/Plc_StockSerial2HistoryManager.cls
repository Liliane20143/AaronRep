/**
 * Plc_StockSerial2HistoryManager - Manage history records for Serial Stock History2 entity
 *
 * @author MZ
 * @date Creation 24/01/2019
 * @errorcode [ERR:CL-053YYZZ]
 * @description 
 * @testedIn Plc_StockSerial2HistoryManagerTest
 */


public without sharing class Plc_StockSerial2HistoryManager {
    //disabled the "manageInsertOperation" operations in after insert (used for massive StockSerials2 insert):
    //as there are WF that triggers after inserting the record, the after update is called as well so
    //there could be a double history creation
    public static Boolean DisableManageInsertOperation = false;
    private static List<Bit2Shop__StockHistory2__c> fakeStockHistory2s_val;
    public static List<Bit2Shop__StockHistory2__c> fakeStockHistory2s {
        get{
            if(fakeStockHistory2s_val == null){
                fakeStockHistory2s_val = new List<Bit2Shop__StockHistory2__c>();
                fakeStockHistory2s_val.addAll([SELECT Id FROM Bit2Shop__StockHistory2__c WHERE Name = 'FAKE' LIMIT 1 FOR UPDATE]);
            }
            return fakeStockHistory2s_val;
        }
    }

    // Entry point for AfterInsert trigger scenario
    //@code 01
    public static void manageInsertOperation(Map<Id, SObject> newItems) {
        LogTracker.debugLog('Plc_StockSerial2HistoryManager', 'manageInsertOperation', 'enabled: ' + DisableManageInsertOperation);
        LogTracker.debugLogBegin('Plc_StockSerial2HistoryManager', 'manageInsertOperation');
        if(DisableManageInsertOperation != true){
            //FB 20190923: NEXIPLC-700 Making SLI update in sync mode [START]
            //checkForHistoryValidRecord(newItems);
            //FB 20190923: NEXIPLC-700 Making SLI update in sync mode [END]
            performInsertOperation(newItems, 'AFTER INSERT');
        }
        LogTracker.debugLogEnd('Plc_StockSerial2HistoryManager', 'manageInsertOperation');
    }

    // Entry point for AfterUpdate trigger scenario
    //@code 02
    public static void manageUpdateOperation(Map<Id, SObject> newItems) {
        LogTracker.debugLogBegin('Plc_StockSerial2HistoryManager', 'manageUpdateOperation');
        //FB 20190923: NEXIPLC-700 Making SLI update in sync mode [START]
        //updateSLIDate(newItems,oldItems);
        //checkForHistoryValidRecord(newItems);
        //FB 20190923: NEXIPLC-700 Making SLI update in sync mode [END]
        
        performInsertOperation(newItems, 'AFTER UPDATE');
        LogTracker.debugLogEnd('Plc_StockSerial2HistoryManager', 'manageUpdateOperation');
    }

    // Check if some SS2 records have existing SSH2 records in valid status
    //@code 03
    private static List<Bit2Shop__Serial_Stock_History2__c> checkForHistoryValidRecord(Map<Id, SObject> newItems) {
        List<Bit2Shop__Serial_Stock_History2__c> checkList = [SELECT Id FROM Bit2Shop__Serial_Stock_History2__c WHERE Plc_IsValid__c = true AND Bit2Shop__Serial_Number_Id__c IN :newItems.keyset()];

        for (Bit2Shop__Serial_Stock_History2__c recordToClose : checkList) {
            recordToClose.Plc_RecordEndDate__c = Datetime.now();
            recordToClose.Plc_IsValid__c = false;
        }
        return checkList;
    }

    // Check if dummy record exists in SH2 and if this is not the case create the same. Then create the new SSH2 record
    //@code 04
    private static void performInsertOperation(Map<Id, SObject> newItems, String sourceOperation) {
        LogTracker.debugLogBegin('Plc_StockSerial2HistoryManager', 'performInsertOperation');
        List<String> fieldsToCheck;
        LogTracker.debugLog('Plc_StockSerial2HistoryManager', 'performInsertOperation', '## Plc_StockSerial2HistoryManager ##:' + sourceOperation);
        LogTracker.debugLog('Plc_StockSerial2HistoryManager', 'performInsertOperation', '## Plc_StockSerial2HistoryManager:HOWMANY ##:' + newItems.size());

        //List<Bit2Shop__StockHistory2__c> fakeStockHistory2s = [SELECT Id FROM Bit2Shop__StockHistory2__c WHERE Name = 'FAKE' LIMIT 1];
        // MZ: Check if Stock History DUMMY record exists and if not we create it!
        //Integer dummyCount = [SELECT COUNT() FROM Bit2Shop__StockHistory2__c WHERE Name = 'FAKE' LIMIT 1];
        if (fakeStockHistory2s.isEmpty()) {
            //fakeStockHistory2s = new List<Bit2Shop__StockHistory2__c>();
            // MZ: Dummy record does not esist so we create the same
            Bit2Shop__StockHistory2__c dummy = new Bit2Shop__StockHistory2__c();
            dummy.Name = 'FAKE';
            dummy.Bit2Shop__Action_Code__c = 'FAKE';
            dummy.Bit2Shop__Qty__c = 0;
            Bit2Shop__Warehouse__c dummyWarehouse = [SELECT Id FROM Bit2Shop__Warehouse__c WHERE Plc_Alias__c = '000001NEXI' LIMIT 1];
            dummy.Bit2Shop__Warehouse_Id__c = dummyWarehouse.Id;


            fieldsToCheck = new List<String>{'Name','Bit2Shop__Action_Code__c','Bit2Shop__Qty__c','Bit2Shop__Warehouse_Id__c'};
            String resultFound = Plc_Utils.checkCrudFieldPermission('Bit2Shop__StockHistory2__c', fieldsToCheck, 'insert');
            if(resultFound != null){
                LogTracker.debugLog('Plc_StockSerial2HistoryManager', 'performInsertOperation', 'Exception checkCrudFieldPermission');
                throw new Plc_Exception(resultFound);
            }
            insert dummy;
            fakeStockHistory2s.add(dummy);
        }

        Bit2Shop__StockHistory2__c realDummy = fakeStockHistory2s[0];//[SELECT Id FROM Bit2Shop__StockHistory2__c WHERE Name = 'FAKE' LIMIT 1];

        // MZ: Fill the referenced entities START -----
        /*Set<Id> refProductStocksId = new Set<Id>();
        Set<Id> refTermId = new Set<Id>();
        Set<Id> refStockOrderId = new Set<Id>();
        Set<Id> refWarehouseId = new Set<Id>();*/

        /*for (Bit2Shop__Stock_Serials2__c serial : (List<Bit2Shop__Stock_Serials2__c>) newItems.values()) {
            if (serial.Bit2Shop__Product_Stock_Id__c != null) {refProductStocksId.add(serial.Bit2Shop__Product_Stock_Id__c);}
            if (serial.Plc_TermId__c != null) {refTermId.add(serial.Plc_TermId__c);}
            if (serial.Bit2Shop__Transfer_Order_Id__c != null) {refStockOrderId.add(serial.Bit2Shop__Transfer_Order_Id__c);}
            if (serial.Bit2Shop__Warehouse_Id__c != null) {refWarehouseId.add(serial.Bit2Shop__Warehouse_Id__c);}
        }
        List<Bit2Shop__Product_Stock__c> refProductStocks =
        [SELECT Bit2Shop__External_Catalog_Item_Id__c, Plc_ProductSku__c, Bit2Shop__Warehouse_Id__r.Plc_LogisticDivision__c, Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c
        FROM Bit2Shop__Product_Stock__c
        WHERE Id IN :refProductStocksId];
        List<Plc_TermId__c> refTermIds =
        [SELECT Plc_TermIdCode__c
        FROM Plc_TermId__c
        WHERE Id IN :refTermId];
        List<Bit2Shop__StockOrder__c> refStockOrderIds =
        [SELECT Plc_WorkOrder__c, Plc_DdmNumber__c, Plc_TransferDetail__c, Plc_WorkOrder__r.Plc_Alias__c
        FROM Bit2Shop__StockOrder__c
        WHERE Id IN :refStockOrderId];
        List<Bit2Shop__Warehouse__c> refWarehouseIds =
        [SELECT Name
        FROM Bit2Shop__Warehouse__c
        WHERE Id IN :refWarehouseId];*/

        //(EM) query all related objects at once
        List<Bit2Shop__Stock_Serials2__c> newItemsReloaded = [Select Id,
                Bit2Shop__Product_Stock_Id__c,
                Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c,
                Bit2Shop__Product_Stock_Id__r.Plc_ProductSku__c,
                Bit2Shop__Product_Stock_Id__r.Bit2Shop__Warehouse_Id__r.Plc_LogisticDivision__c,
                Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c,

                Plc_TermId__c, Plc_TermId__r.Plc_TermIdCode__c,

                Bit2Shop__Transfer_Order_Id__c,
                Bit2Shop__Transfer_Order_Id__r.Plc_WorkOrder__c,
                Bit2Shop__Transfer_Order_Id__r.Plc_DdmNumber__c,
                Bit2Shop__Transfer_Order_Id__r.Plc_TransferDetail__c,
                Bit2Shop__Transfer_Order_Id__r.Plc_WorkOrder__r.Plc_Alias__c,

                Bit2Shop__Warehouse_Id__c,
                Bit2Shop__Warehouse_Id__r.Name
        From Bit2Shop__Stock_Serials2__c WHERE ID IN :newItems.values()];

        Map<Id, Bit2Shop__Product_Stock__c> refProductStocksMap = new Map<Id, Bit2Shop__Product_Stock__c>();//(refProductStocks);
        Map<Id, Plc_TermId__c> refTermIdsMap = new Map<Id, Plc_TermId__c>();//(refTermIds);
        Map<Id, Bit2Shop__StockOrder__c> refStockOrderMap = new Map<Id, Bit2Shop__StockOrder__c>();//(refStockOrderIds);
        Map<Id, Bit2Shop__Warehouse__c> refWarehouseMap = new Map<Id, Bit2Shop__Warehouse__c>();//(refWarehouseIds);


        for(Bit2Shop__Stock_Serials2__c item : newItemsReloaded){
            refProductStocksMap.put(item.Bit2Shop__Product_Stock_Id__c, item.Bit2Shop__Product_Stock_Id__r);
            refTermIdsMap.put(item.Plc_TermId__c, item.Plc_TermId__r);
            refStockOrderMap.put(item.Bit2Shop__Transfer_Order_Id__c, item.Bit2Shop__Transfer_Order_Id__r);
            refWarehouseMap.put(item.Bit2Shop__Warehouse_Id__c, item.Bit2Shop__Warehouse_Id__r);
        }

        // MZ: Fill the referenced entities END -----

        // MZ: init list of records to be saved
        List<Bit2Shop__Serial_Stock_History2__c> serialStoryList = new List<Bit2Shop__Serial_Stock_History2__c>();

        // MZ: loop inside serials collection
        for (Bit2Shop__Stock_Serials2__c serial : (List<Bit2Shop__Stock_Serials2__c>) newItems.values()) {
            // MZ: istantiate new serial history object
            Bit2Shop__Serial_Stock_History2__c oneSerialStory = insertSerialStockHistory(serial, realDummy, refProductStocksMap, refTermIdsMap, refStockOrderMap, refWarehouseMap);

            // MZ: update collection
            serialStoryList.add(oneSerialStory);
        }

        fieldsToCheck = new List<String>{'Bit2Shop__Stock_History_Id__c','Bit2Shop__Product_Stock_Id__c','Bit2Shop__Serial_Number_Id__c','Plc_EncodedSerialNumber__c','Plc_ManufacturerSerialNumber__c','Plc_DllSerialNumber__c','Plc_Model__c','Plc_ModelName__c','Plc_ProductSku__c','Plc_LogisticDivision__c','Plc_Model__c','Plc_ProductSku__c','Plc_LogisticDivision__c','Plc_ModelName__c','Plc_ModelName__c','Bit2Shop__Warehouse_Id__c','Plc_Warehouse__c','Plc_Warehouse__c','Plc_Property__c','Bit2Shop__New_Status__c','Plc_NewStatus2__c','Plc_TermId_Id__c','Plc_TermId__c','Plc_PTSCode__c','Plc_RepairWarrantyStartDate__c','Plc_RepairWarrantyEndDate__c','Bit2Shop__User_Id__c','Bit2Shop__Transfer_Order_Id__c','Plc_WorkOrder_Id__c','Plc_DdmNumber__c','Plc_OdlNumber__c','Plc_TransferDetail__c','Plc_WorkOrder_Id__c','Plc_DdmNumber__c','Plc_TransferDetail__c','Plc_OdlNumber__c','Plc_OdlNumber__c','Plc_DepreciationPercentage__c','Plc_DepreciationCompleted__c','Plc_DepreciationDuration__c','Plc_DllSerialNumberUnique__c','Plc_EncodedSerialNumberUnique__c','Plc_FirstInstallationDate__c','Plc_LastRepairCost__c','Plc_LinkedWithSerial__c','Plc_Manufacturer__c','Plc_ManufacturerSerialNumberUnique__c','Plc_PcipedApprovalNumber__c','Plc_PcipedExpiryDate__c','Plc_PcipedLetterOfApproval__c','Plc_PcipedModel__c','Plc_PcipedVersion__c','Plc_Pin__c','Plc_Puk1__c','Plc_Puk2__c','Plc_PurchaseDate__c','Plc_PurchaseOrderItem__c','Plc_PurchasePrice__c','Plc_PurchaseWarrantyEndDate__c','Plc_PurchaseWarrantyStartDate__c','Plc_RentalEndDate__c','Plc_RentalStartDate__c','Plc_Resolved__c','Plc_StockSerial2Alias__c','Plc_Tag__c','Plc_VoiceCode__c','Plc_SerialNumberIdSnapshot__c','Plc_WarehouseIdSnapshot__c','Plc_TermIdSnapshot__c','Plc_TransferOrderIdSnapshot__c','Bit2Shop__Action_Code__c','Bit2Shop__Action_Date__c','Plc_RecordStartDate__c','Plc_RecordEndDate__c','Plc_UpdateReason__c'};
        String resultFound = Plc_Utils.checkCrudFieldPermission('Bit2Shop__Serial_Stock_History2__c', fieldsToCheck, 'insert');
        if(resultFound != null){
            LogTracker.debugLog('Plc_StockSerial2HistoryManager', 'performInsertOperation', 'Exception checkCrudFieldPermission');
            throw new Plc_Exception(resultFound);
		}

        //FB 20190923: NEXIPLC-700 Logging upsert results [START]
        serialStoryList.addAll(checkForHistoryValidRecord(newItems));
        List<Database.UpsertResult> upsertResults = Database.upsert(serialStoryList, false);

        List<Plc_Log__c> logsList = new List<Plc_Log__c>();
        String apexErrorRecordTypeId = Plc_Utils.getRecordTypeId('Plc_ApexError', 'Plc_Log__c');
        for (Integer index = 0; index < upsertResults.size(); index++) { 
            Database.UpsertResult saveResult = upsertResults[index];

            if (!saveResult.isSuccess()) {
                Plc_Log__c log = new Plc_Log__c (
                    Plc_RequestBody__c        = JSON.serialize(serialStoryList[index]),
                    Plc_ResponseBody__c       = JSON.serialize(saveResult.getErrors()),
                    Plc_Timestamp__c          = String.valueOf(Datetime.now()),
                    Plc_RequestURI__c         = 'Plc_StockSerial2HistoryManager.performInsertOperation',
                    Plc_ResponseStatus__c     = 'E',
                    Plc_ResponseStackTrace__c = '[ERR:CL-0530401]',
                    Plc_ContextEntity__c      = '/lightning/r/Bit2Shop__Stock_Serials2__c/' + serialStoryList[index].Bit2Shop__Serial_Number_Id__c + '/view',
                    Plc_StockSerial__c        = serialStoryList[index].Bit2Shop__Serial_Number_Id__c,
                    RecordTypeId              = apexErrorRecordTypeId
                );

                logsList.add(log);
            }
        }

        LogTracker.debugLog('Plc_StockSerial2HistoryManager', 'performInsertOperation', '## logsList.size() ' + logsList.size());

        if (!logsList.isEmpty()) {
            insert logsList;
        }

        //FB 20190923: NEXIPLC-700 Logging upsert results [END]
        LogTracker.debugLogEnd('Plc_StockSerial2HistoryManager', 'performInsertOperation');
    }

    // Populate new SSH2 valid record
    //@code 05
    private static Bit2Shop__Serial_Stock_History2__c insertSerialStockHistory(
            Bit2Shop__Stock_Serials2__c serial,
            Bit2Shop__StockHistory2__c dummy,
            Map<Id, Bit2Shop__Product_Stock__c> refProductStocksMap,
            Map<Id, Plc_TermId__c> refTermIdsMap,
            Map<Id, Bit2Shop__StockOrder__c> refStockOrderMap,
            Map<Id, Bit2Shop__Warehouse__c> refWarehouseIdsMap
    ) {
        List<String> fieldsToCheck;
        // MZ: istantiate new serial history object
        Bit2Shop__Serial_Stock_History2__c oneSerialStory = new Bit2Shop__Serial_Stock_History2__c();

        // MZ: populate serial history object START ------------------------------------
        // Reference to master record of master-detail relationship
        oneSerialStory.Bit2Shop__Stock_History_Id__c = dummy.Id;

        // Set reference to product stock
        oneSerialStory.Bit2Shop__Product_Stock_Id__c = serial.Bit2Shop__Product_Stock_Id__c;

        // Standard fields
        oneSerialStory.Bit2Shop__Serial_Number_Id__c = serial.Id;
        oneSerialStory.Plc_EncodedSerialNumber__c = serial.Plc_EncodedSerialNumber__c;
        oneSerialStory.Plc_ManufacturerSerialNumber__c = serial.Plc_ManufacturerSerialNumber__c;
        oneSerialStory.Plc_DllSerialNumber__c = serial.Plc_DllSerialNumber__c;

        if (serial.Bit2Shop__Product_Stock_Id__c == null) {
            oneSerialStory.Plc_Model__c = null;
            oneSerialStory.Plc_ModelName__c = null;
            oneSerialStory.Plc_ProductSku__c = null;
            oneSerialStory.Plc_LogisticDivision__c = null;
        }
        else
        {
            oneSerialStory.Plc_Model__c = refProductStocksMap.get(serial.Bit2Shop__Product_Stock_Id__c).Bit2Shop__External_Catalog_Item_Id__c;
            oneSerialStory.Plc_ProductSku__c = refProductStocksMap.get(serial.Bit2Shop__Product_Stock_Id__c).Plc_ProductSku__c;
            oneSerialStory.Plc_LogisticDivision__c = refProductStocksMap.get(serial.Bit2Shop__Product_Stock_Id__c).Bit2Shop__Warehouse_Id__r.Plc_LogisticDivision__c;

            if (refProductStocksMap.get(serial.Bit2Shop__Product_Stock_Id__c).Bit2Shop__External_Catalog_Item_Id__c == null) {
                oneSerialStory.Plc_ModelName__c = null;
            }
            else
            {
                oneSerialStory.Plc_ModelName__c = refProductStocksMap.get(serial.Bit2Shop__Product_Stock_Id__c).Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c;
            }
        }

        oneSerialStory.Bit2Shop__Warehouse_Id__c = serial.Bit2Shop__Warehouse_Id__c;

        if (serial.Bit2Shop__Warehouse_Id__c == null) {
            oneSerialStory.Plc_Warehouse__c = null;
        }
        else
        {
            oneSerialStory.Plc_Warehouse__c = refWarehouseIdsMap.get(serial.Bit2Shop__Warehouse_Id__c).Name;
        }

        oneSerialStory.Plc_Property__c = serial.Plc_Property__c;
        oneSerialStory.Bit2Shop__New_Status__c = serial.Bit2Shop__Status__c;
        oneSerialStory.Plc_NewStatus2__c = serial.Plc_Status2__c;
        oneSerialStory.Plc_TermId_Id__c = serial.Plc_TermId__c;

        if (serial.Plc_TermId__c == null) {
            oneSerialStory.Plc_TermId__c = null;
        }
        else
        {
            oneSerialStory.Plc_TermId__c = refTermIdsMap.get(serial.Plc_TermId__c).Plc_TermIdCode__c;
        }

        oneSerialStory.Plc_PTSCode__c = serial.Plc_PTSCode__c;
        oneSerialStory.Plc_RepairWarrantyStartDate__c = serial.Plc_RepairWarrantyStartDate__c;
        oneSerialStory.Plc_RepairWarrantyEndDate__c = serial.Plc_RepairWarrantyEndDate__c;
        oneSerialStory.Bit2Shop__User_Id__c = serial.CreatedById;

        // Reason fields
        oneSerialStory.Bit2Shop__Transfer_Order_Id__c = serial.Bit2Shop__Transfer_Order_Id__c;

        if (serial.Bit2Shop__Transfer_Order_Id__c == null) {
            oneSerialStory.Plc_WorkOrder_Id__c = null;
            oneSerialStory.Plc_DdmNumber__c = null;
            oneSerialStory.Plc_OdlNumber__c = null;
            oneSerialStory.Plc_TransferDetail__c = null;
        }
        else
        {
            oneSerialStory.Plc_WorkOrder_Id__c = refStockOrderMap.get(serial.Bit2Shop__Transfer_Order_Id__c).Plc_WorkOrder__c;
            oneSerialStory.Plc_DdmNumber__c = refStockOrderMap.get(serial.Bit2Shop__Transfer_Order_Id__c).Plc_DdmNumber__c;
            oneSerialStory.Plc_TransferDetail__c = refStockOrderMap.get(serial.Bit2Shop__Transfer_Order_Id__c).Plc_TransferDetail__c;

            if (refStockOrderMap.get(serial.Bit2Shop__Transfer_Order_Id__c).Plc_WorkOrder__c == null) {
                oneSerialStory.Plc_OdlNumber__c = null;
            }
            else
            {
                oneSerialStory.Plc_OdlNumber__c = refStockOrderMap.get(serial.Bit2Shop__Transfer_Order_Id__c).Plc_WorkOrder__r.Plc_Alias__c;
            }
        }

        // Other fields
        oneSerialStory.Plc_DepreciationPercentage__c = serial.Plc_DepreciationPercentage__c;
        oneSerialStory.Plc_DepreciationCompleted__c = serial.Plc_DepreciationCompleted__c;
        oneSerialStory.Plc_DepreciationDuration__c = serial.Plc_DepreciationDuration__c;
        oneSerialStory.Plc_DllSerialNumberUnique__c = serial.Plc_DllSerialNumberUnique__c;
        oneSerialStory.Plc_EncodedSerialNumberUnique__c = serial.Plc_EncodedSerialNumberUnique__c;
        oneSerialStory.Plc_FirstInstallationDate__c = serial.Plc_FirstInstallationDate__c;
        oneSerialStory.Plc_LastRepairCost__c = serial.Plc_LastRepairCost__c;
        oneSerialStory.Plc_LinkedWithSerial__c = serial.Plc_LinkedWithSerial__c;
        oneSerialStory.Plc_Manufacturer__c = serial.Plc_Manufacturer__c;
        oneSerialStory.Plc_ManufacturerSerialNumberUnique__c = serial.Plc_ManufacturerSerialNumberUnique__c;
        oneSerialStory.Plc_PcipedApprovalNumber__c = serial.Plc_PcipedApprovalNumber__c;
        
        oneSerialStory.Plc_PcipedExpiryDate__c = serial.Plc_PcipedExpiryDate__c;
        oneSerialStory.Plc_PcipedLetterOfApproval__c = serial.Plc_PcipedLetterOfApproval__c;
        oneSerialStory.Plc_PcipedModel__c = serial.Plc_PcipedModel__c;
        oneSerialStory.Plc_PcipedVersion__c = serial.Plc_PcipedVersion__c;
        oneSerialStory.Plc_Pin__c = serial.Plc_Pin__c;
        oneSerialStory.Plc_Puk1__c = serial.Plc_Puk1__c;
        oneSerialStory.Plc_Puk2__c = serial.Plc_Puk2__c;
        oneSerialStory.Plc_PurchaseDate__c = serial.Plc_PurchaseDate__c;
        oneSerialStory.Plc_PurchaseOrderItem__c = serial.Plc_PurchaseOrderItem__c;
        oneSerialStory.Plc_PurchasePrice__c = serial.Plc_PurchasePrice__c;
        oneSerialStory.Plc_PurchaseWarrantyEndDate__c = serial.Plc_PurchaseWarrantyEndDate__c;
        oneSerialStory.Plc_PurchaseWarrantyStartDate__c = serial.Plc_PurchaseWarrantyStartDate__c;
        oneSerialStory.Plc_RentalEndDate__c = serial.Plc_RentalEndDate__c;
        oneSerialStory.Plc_RentalStartDate__c = serial.Plc_RentalStartDate__c;
        oneSerialStory.Plc_Resolved__c = serial.Plc_Resolved__c;
        oneSerialStory.Plc_StockSerial2Alias__c = serial.Plc_Alias__c;
        oneSerialStory.Plc_Tag__c = serial.Plc_Tag__c;
        oneSerialStory.Plc_VoiceCode__c = serial.Plc_VoiceCode__c;

        // Snapshot fields
        oneSerialStory.Plc_SerialNumberIdSnapshot__c = serial.Id;
        oneSerialStory.Plc_WarehouseIdSnapshot__c = serial.Bit2Shop__Warehouse_Id__c;
        oneSerialStory.Plc_TermIdSnapshot__c = serial.Plc_TermId__c;
        oneSerialStory.Plc_TransferOrderIdSnapshot__c = serial.Bit2Shop__Transfer_Order_Id__c;
        //
        oneSerialStory.Bit2Shop__Action_Code__c = 'Trigger';
        oneSerialStory.Bit2Shop__Action_Date__c = Date.today();

        // Validity fields
        oneSerialStory.Plc_RecordStartDate__c = DateTime.now();
        oneSerialStory.Plc_RecordEndDate__c = Date.ValueOf('2999-12-31');

        // Update Reason
        oneSerialStory.Plc_UpdateReason__c = serial.Plc_UpdateReason__c;

        // fieldsToCheck = new List<String>{'Bit2Shop__Stock_History_Id__c','Bit2Shop__Product_Stock_Id__c','Bit2Shop__Serial_Number_Id__c','Plc_EncodedSerialNumber__c','Plc_ManufacturerSerialNumber__c','Plc_DllSerialNumber__c','Plc_Model__c','Plc_ModelName__c','Plc_ProductSku__c','Plc_LogisticDivision__c','Plc_Model__c','Plc_ProductSku__c','Plc_LogisticDivision__c','Plc_ModelName__c','Plc_ModelName__c','Bit2Shop__Warehouse_Id__c','Plc_Warehouse__c','Plc_Warehouse__c','Plc_Property__c','Bit2Shop__New_Status__c','Plc_NewStatus2__c','Plc_TermId_Id__c','Plc_TermId__c','Plc_TermId__c','Plc_PTSCode__c','Plc_RepairWarrantyStartDate__c','Plc_RepairWarrantyEndDate__c','Bit2Shop__User_Id__c','Bit2Shop__Transfer_Order_Id__c','Plc_WorkOrder_Id__c','Plc_DdmNumber__c','Plc_OdlNumber__c','Plc_TransferDetail__c','Plc_WorkOrder_Id__c','Plc_DdmNumber__c','Plc_TransferDetail__c','Plc_OdlNumber__c','Plc_OdlNumber__c','Plc_DepreciationPercentage__c','Plc_DepreciationCompleted__c','Plc_DepreciationDuration__c','Plc_DllSerialNumberUnique__c','Plc_EncodedSerialNumberUnique__c','Plc_FirstInstallationDate__c','Plc_LastRepairCost__c','Plc_LinkedWithSerial__c','Plc_Manufacturer__c','Plc_ManufacturerSerialNumberUnique__c','Plc_PcipedApprovalNumber__c','Plc_PcipedExpiryDate__c','Plc_PcipedLetterOfApproval__c','Plc_PcipedModel__c','Plc_PcipedVersion__c','Plc_Pin__c','Plc_Puk1__c','Plc_Puk2__c','Plc_PurchaseDate__c','Plc_PurchaseOrderItem__c','Plc_PurchasePrice__c','Plc_PurchaseWarrantyEndDate__c','Plc_PurchaseWarrantyStartDate__c','Plc_RentalEndDate__c','Plc_RentalStartDate__c','Plc_Resolved__c','Plc_StockSerial2Alias__c','Plc_Tag__c','Plc_VoiceCode__c','Plc_SerialNumberIdSnapshot__c','Plc_WarehouseIdSnapshot__c','Plc_TermIdSnapshot__c','Plc_TransferOrderIdSnapshot__c','Bit2Shop__Action_Code__c','Bit2Shop__Action_Date__c','Plc_RecordStartDate__c','Plc_RecordEndDate__c','Plc_UpdateReason__c'};
        // String resultFound = Plc_Utils.checkCrudFieldPermission('Bit2Shop__Serial_Stock_History2__c', fieldsToCheck, 'insert');
        // if(resultFound != null){
        //     System.debug('Exception checkCrudFieldPermission');
        //     throw new Plc_Exception(resultFound);
		// }

        return oneSerialStory;
        // MZ: populate serial history object END ----------------------------------------
    }
    //@code 06
    public static void updateSLIDate(Map<Id, SObject> newItems){
        LogTracker.debugLogBegin('Plc_StockSerial2HistoryManager', 'updateSLIDate');
        List<String> fieldsToCheck ;

        List<String> sso = new List<String>();

        //RETRIEVE DATA FROM STOCK SERIAL 2 HISTORY TO FIND THE LAST STATE OF EACH SERIAL
        Map<String,String> serialsOldState = new Map<String,String>();
        for(Bit2Shop__Serial_Stock_History2__c hs: [SELECT Id,Bit2Shop__New_Status__c,Bit2Shop__Serial_Number_Id__c FROM Bit2Shop__Serial_Stock_History2__c WHERE Bit2Shop__Serial_Number_Id__c IN:newItems.keySet() ORDER BY CreatedDate DESC]){
            if(!serialsOldState.containsKey(hs.Bit2Shop__Serial_Number_Id__c)){
                serialsOldState.put(hs.Bit2Shop__Serial_Number_Id__c,hs.Bit2Shop__New_Status__c);
            }
        }
        // DAL BULK DELLE MATRICOLE VENGONO FILTRATE SOLO QUELLE CON VARIAZIONE DI STATO
        // NB: Potrebbe essere un filtro più restrittivo aggiungendo anche le tipologia di transizione di stato ammesse ma inficiando
        // così la valorizzazione dell'ultimo stato ( generica ) sull'ultimo shipment line item
        for(Id ssoId: newItems.keySet()){
            if( (newItems.get(ssoId).get('Bit2Shop__Status__c') != serialsOldState.get(ssoId)) /*&& (newItems.get(ssoId).get('Bit2Shop__Status__c') == 'Available')*/ ){
                sso.add((String) newItems.get(ssoId).get('Id'));
            }
        }
        // NB :ATTENZIONE, LA QUERY POTREBBE ESSERE ULTERIORMENTE RIDOTTA FILTRANDO SOLO PER LE TIPOLOGIE DI MOVIMENTO STRETTAMENTE LEGATE
        // AGLI INBOUND DI TIPO "INSTALLED" to "<other>".
        // Mantenendo la query generica è possibile tracciare sull'ultimo shipment line item legato alla matricola l'ultimo STATUS della stessa.
        // Filtrando la query di partenza ovviamente si riduce il perimetro dei movimenti sui quali potenzialmente intervenire
        // NB: IMPORTANTE L'ORDINAMENTO PER MANTENERE CORRETTAMENTE L'ELABORAZIONE PER ROTTURA DI CHIAVE
        List<Bit2Shop__Shipment_Line_Item__c> sli = [SELECT Id, Bit2Shop__Target_Line_Item__c,
                Plc_HandlingStatusDate__c,
                Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Warehouse_Id__r.Plc_Tipology__c,
                Bit2Shop__Shipment_Id__r.RecordTypeId,
                Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Plc_WorkOrder__r.Status,
                Plc_StockSerial__c,
                Plc_StockSerialTransitionType__c,
                Plc_StockSerial__r.Bit2Shop__Status__c,
                Plc_LastStockSerialStatus__c
        FROM Bit2Shop__Shipment_Line_Item__c
        WHERE Plc_StockSerial__c IN :sso ORDER BY Plc_StockSerial__c, Plc_HandlingStatusDate__c DESC, CreatedDate DESC];

        LogTracker.debugLog('Plc_StockSerial2HistoryManager', 'updateSLIDate', '## Plc_StockSerial2HistoryManager:updateSLIDate : sli#:'+sli.size());

        List<List<Bit2Shop__Shipment_Line_Item__c>> sliListToUpdate = new List<List<Bit2Shop__Shipment_Line_Item__c>>();
        List<Bit2Shop__Shipment_Line_Item__c> sliToUpdate = new List<Bit2Shop__Shipment_Line_Item__c>();
        sliListToUpdate.add(sliToUpdate);

        ID inboundRecordTypeId = Plc_Utils.getRecordTypeId('Inbound_Shipment', 'Bit2Shop__Shipment__c');
        Integer MAX_DML_ROWS_CHUNK_SIZE = 10000;
        String PLC_SS2_STATUS_TTYPE = 'CONS01';
        String PLC_SS2_STATUS_TO_BE_VERIFIED = 'To be verified';
        String PLC_SS2_STATUS_AVAILABLE = 'Available';
        String PLC_WAREHOUSE_TYPE_INSTALLED = 'Installed';
        String PLC_WORKORDER_STATUS_CLOSED = 'Closed';
        String actualStockSerial = null;

        
        // LOOP PER ROTTURA DI CHIAVE, NECESSARIO PER UTILIZO BULK DEL PROCESSO
        // SI PROCESSA SOLO IL PROMO RECORD PER OGNI MATRICOLA ( RAPPRESENTA LO SLI PIU' RECENTE )
        for(Bit2Shop__Shipment_Line_Item__c sliRecord : sli){
            //Processo a rottura di chiave ( matricola )
            if (sliRecord.Plc_StockSerial__c!=actualStockSerial)
            {

                String ssoKey = sliRecord.Plc_StockSerial__c;
                String ss2NewStatus = String.valueOf(newItems.get(ssoKey).get('Bit2Shop__Status__c'));
                String ss2OldStatus = serialsOldState.get(sliRecord.Plc_StockSerial__c);

                LogTracker.debugLog('Plc_StockSerial2HistoryManager', 'updateSLIDate', '## Plc_StockSerial2HistoryManager:updateSLIDate : processing id :' + sliRecord.id );
                LogTracker.debugLog('Plc_StockSerial2HistoryManager', 'updateSLIDate', '## Plc_StockSerial2HistoryManager:updateSLIDate : status old :' + ss2OldStatus);
                LogTracker.debugLog('Plc_StockSerial2HistoryManager', 'updateSLIDate', '## Plc_StockSerial2HistoryManager:updateSLIDate : status new :' + ss2NewStatus);
                LogTracker.debugLog('Plc_StockSerial2HistoryManager', 'updateSLIDate', '## Plc_StockSerial2HistoryManager:updateSLIDate : Plc_Tipology__c :'+sliRecord.Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Warehouse_Id__r.Plc_Tipology__c+', ['+(sliRecord.Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Warehouse_Id__r.Plc_Tipology__c==PLC_WAREHOUSE_TYPE_INSTALLED)+']');

                // verifica della transizione di stato ammessa per il calcolo dei consumati
                if( ss2OldStatus==PLC_SS2_STATUS_TO_BE_VERIFIED && ss2NewStatus == PLC_SS2_STATUS_AVAILABLE ){
                    LogTracker.debugLog('Plc_StockSerial2HistoryManager', 'updateSLIDate', 'TRANSIZIONE CALCOLO CONSUMATI');
                    // verifica della tipologia di movimento per il calcolo dei consumati ( rientrati e passati in stato available )
                    if(sliRecord.Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Warehouse_Id__r.Plc_Tipology__c == PLC_WAREHOUSE_TYPE_INSTALLED
                            && sliRecord.Bit2Shop__Shipment_Id__r.RecordTypeId == inboundRecordTypeId/*outboundRecordTypeId*/
                            && sliRecord.Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Plc_WorkOrder__r.Status == PLC_WORKORDER_STATUS_CLOSED)
                    {

                        sliRecord.Plc_HandlingStatusDate__c = DateTime.now();   // modifica della Handlingstatusdate per riportare lo SLI in processo al batch consumati
                        //sliRecord.Plc_StockSerialTransitionType__c += String.isBlank(sliRecord.Plc_StockSerialTransitionType__c)?
                        //                                                              ss2NewStatus : ';'+ss2NewStatus;
                        sliRecord.Plc_StockSerialTransitionType__c = PLC_SS2_STATUS_TTYPE;  // tracciamento della transizione di stato
						//FB 24-10-2019: Moving inside the if [START]
                        sliToUpdate.add(sliRecord);
                        //FB 24-10-2019: Moving inside the if [START]
                    }


                }
                //FB 24-10-2019: Commenting [START]
                //sliRecord.Plc_LastStockSerialStatus__c = sliRecord.Plc_StockSerial__r.Bit2Shop__Status__c;
                // sliToUpdate.add(sliRecord);
                //FB 24-10-2019: Commenting [START]
                actualStockSerial = sliRecord.Plc_StockSerial__c;
                if(sliToUpdate.size()==MAX_DML_ROWS_CHUNK_SIZE){
                    sliListToUpdate.add(sliToUpdate);
                    sliToUpdate = new List<Bit2Shop__Shipment_Line_Item__c>();
                }
            }
        }

        fieldsToCheck = new List<String>{'plc_laststockserialstatus__c','plc_stockserialtransitiontype__c','plc_handlingstatusdate__c'};
        String resultFound = Plc_Utils.checkCrudFieldPermission('Bit2Shop__Shipment_Line_Item__c', fieldsToCheck, 'update');
        if(resultFound != null){
            LogTracker.debugLog('Plc_StockSerial2HistoryManager', 'updateSLIDate', 'Exception checkCrudFieldPermission');
            throw new Plc_Exception(resultFound);
		}
        // aggiornamento bulk + chunk
        for(List<Bit2Shop__Shipment_Line_Item__c> sliList : sliListToUpdate){
            update sliList;
        }

        LogTracker.debugLogEnd('Plc_StockSerial2HistoryManager', 'updateSLIDate');
    }
}