/**
 * Created by dilorenzo on 17/01/2019.
 */

public without sharing class Plc_StockSerialsMergeFromUndefinedCnt {

    private static Set<String> StockSerial2Fields = new Set<String>{
        'Id', 'Plc_ManufacturerSerialNumber__c','Plc_DllSerialNumber__c', 'Plc_EncodedSerialNumber__c'
    };

    public static Bit2Shop__Stock_Serials2__c currentStockSerial2 {get;set;}
    public static List<Bit2Shop__Stock_Serials2__c> listStockSerial2 {get;set;}

    @AuraEnabled
    public static Map<String, Object> retrieveInfoStockSerial(String stockSerialId){

        Map<String, Object> response = new Map<String, Object>();
        response.put('error', false);

        //Getting current Stock Serial
        try {
            List<Bit2Shop__Stock_Serials2__c> stockSerialList = [SELECT Id, Name, Bit2Shop__Warehouse_Id__r.Name, Bit2Shop__Warehouse_Id__r.Plc_Tipology__c, Plc_ManufacturerSerialNumber__c, Plc_DllSerialNumber__c, Plc_EncodedSerialNumber__c, Plc_Model__c, Bit2Shop__Product_Stock_Id__c,
                Bit2Shop__Shipment_Date__c, Plc_FirstInstallationDate__c, Plc_PurchaseDate__c, Bit2Shop__Purchase_Price__c, Plc_PurchaseWarrantyStartDate__c, Plc_PurchaseWarrantyEndDate__c,
                Plc_LastRepairCost__c, Plc_RepairWarrantyStartDate__c, Plc_RepairWarrantyEndDate__c, Plc_RentalStartDate__c, Plc_RentalEndDate__c, Plc_DepreciationDuration__c,
                Plc_DepreciationPercentage__c, Plc_DepreciationCompleted__c, Plc_PTSCode__c, Plc_PcipedModel__c, Plc_PCIPEDLetterOfApproval__c, Plc_PcipedApprovalNumber__c, Plc_PcipedVersion__c,
                Plc_PcipedExpiryDate__c, Plc_VoiceCode__c, Plc_Pin__c, Plc_Puk1__c, Plc_Puk2__c, Plc_Note__c, Plc_LinkedWithSerial__c, Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c, Bit2Shop__Product_Stock_Id__r.Name,
                Bit2Shop__Product_Stock_Id__r.Bit2Shop__Warehouse_Id__c,Bit2Shop__Status__c,Plc_Status2__c,Bit2Shop__Warehouse_Id__c, RecordTypeId, Plc_Manufacturer__c
            FROM Bit2Shop__Stock_Serials2__c
            WHERE Id = :stockSerialId];

            if (stockSerialList != null && stockSerialList.size() > 0) {
                response.put('stockSerial', stockSerialList.get(0));
            }
        }
        catch(Exception e) {
            response.put('error', true);
        }

        System.debug('### SIZE: ' + response.size());
        return response;
    }

    @AuraEnabled
    public static Map<String, Object> retrieveInfoStockSerialIndefiniti(String searchSerial){

        System.debug('Value Param ' + searchSerial);

        Map<String, Object> response = new Map<String, Object>();
        response.put('error', false);

        String last8Char = searchSerial.right(8);

        //Getting current Stock Serial
        List<Bit2Shop__Stock_Serials2__c> stockSerialListIndef = [SELECT Id, Name, Bit2Shop__Status__c, Bit2Shop__Warehouse_Id__r.Name, Bit2Shop__Warehouse_Id__r.Plc_Tipology__c, Plc_ManufacturerSerialNumber__c, Plc_DllSerialNumber__c, Plc_EncodedSerialNumber__c, Plc_Model__c, Bit2Shop__Product_Stock_Id__c,
            Bit2Shop__Shipment_Date__c, Plc_FirstInstallationDate__c, Plc_PurchaseDate__c, Bit2Shop__Purchase_Price__c, Plc_PurchaseWarrantyStartDate__c, Plc_PurchaseWarrantyEndDate__c,
            Plc_LastRepairCost__c, Plc_RepairWarrantyStartDate__c, Plc_RepairWarrantyEndDate__c, Plc_RentalStartDate__c, Plc_RentalEndDate__c, Plc_DepreciationDuration__c,Bit2Shop__Warehouse_Id__c,
            Plc_DepreciationPercentage__c,Plc_DepreciationCompleted__c, Plc_PTSCode__c, Plc_PcipedModel__c, Plc_PCIPEDLetterOfApproval__c, Plc_PcipedApprovalNumber__c, Plc_PcipedVersion__c,
            Plc_PcipedExpiryDate__c, Plc_VoiceCode__c, Plc_Pin__c, Plc_Puk1__c, Plc_Puk2__c, Plc_Note__c, Plc_LinkedWithSerial__c, Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c, Bit2Shop__Product_Stock_Id__r.Name,
            RecordTypeId, Plc_Status2__c, Plc_Manufacturer__c
        FROM Bit2Shop__Stock_Serials2__c
        WHERE ( ((Plc_EncodedSerialNumber__c = :searchSerial) OR (Plc_ManufacturerSerialNumber__c = :searchSerial) OR (Plc_DllSerialNumber__c = :searchSerial) OR (Plc_EncodedSerialNumber__c = :last8Char)) )];//

        if (!stockSerialListIndef.isEmpty()) {
            response.put('stockSerialIndef', stockSerialListIndef.get(0));
        }
        else{
            System.debug('ERROR FDL');
            response.put('error', true);
        }

        System.debug('### SIZE: ' + response.size());
        return response;
    }

    @AuraEnabled
    // public static Map<String, Object> updateStockSerial(Bit2Shop__Stock_Serials2__c stockSerial, String newWarehouseId, String newModelId,
    //   String newModelName, String newStatus, String newStatus2){

    public static Map<String, Object> updateStockSerialLAST(Bit2Shop__Stock_Serials2__c stockSerial, String newWarehouseId, String newModelId,
        String newModelName, Bit2Shop__Stock_Serials2__c stockSerialIndef){
        System.debug('SERIAL-#: '+stockSerialIndef);
        System.debug('### PARAM: Wid= ' + newWarehouseId + ' ModelId= ' + newModelId);
        Map<String, Object> response = new Map<String, Object>();
        response.put('error', false);
        Savepoint sp = Database.setSavepoint();
        try {

            Bit2Shop__Stock_Serials2__c stockSerialOldClone = stockSerial.clone();
            stockSerialOldClone.Id = stockSerial.Id;

            System.debug('PRIMA di PRODUCT STOCK');
            List<Bit2Shop__Product_Stock__c> productStockStSerial = retrieveAvailableProductStock(newWarehouseId, newModelId);//.get('productStockStSerial');

            System.debug('DOPO di PRODUCT STOCK');
            //A Product Stock was found in given warehouse
            if (productStockStSerial.size() > 0) {
                System.debug('DOPO IF ');
                stockSerial.Bit2Shop__Product_Stock_Id__c = productStockStSerial.get(0).Id;
            } else {
                System.debug('DOPO ELSE');
                //Otherwise Product Stock will be created
                Bit2Shop__Product_Stock__c newProductStock2 = new Bit2Shop__Product_Stock__c();
                newProductStock2.Name = newModelName;
                newProductStock2.Bit2Shop__External_Catalog_Item_Id__c = newModelId;
                newProductStock2.Bit2Shop__Warehouse_Id__c = newWarehouseId;

                System.debug('### INSERT PRODUCT STOCK');
                insert newProductStock2;

                stockSerial.Bit2Shop__Product_Stock_Id__c = newProductStock2.Id;
            }

            String tempEncodedSerial =  stockSerial.Plc_EncodedSerialNumber__c;
            String tempManufacturerSerial =  stockSerial.Plc_ManufacturerSerialNumber__c;
            String tempDllSerial =  stockSerial.Plc_DllSerialNumber__c;

            //TEMP
            String timeTemp = String.valueOf(System.Now());

            Bit2Shop__Stock_Serials2__c ss2temp4Update = new Bit2Shop__Stock_Serials2__c();
            SS2temp4Update.Id = stockSerial.Id;

            Bit2Shop__Stock_Serials2__c ss2temp4UpdateIndef = new Bit2Shop__Stock_Serials2__c();
            SS2temp4UpdateIndef.Id = stockSerialIndef.Id;

            if(ss2temp4Update.Plc_EncodedSerialNumberUnique__c != null || ss2temp4Update.Plc_EncodedSerialNumberUnique__c !=''){
                ss2temp4Update.Plc_EncodedSerialNumberUnique__c = 'tempEncod1'+timeTemp;//per evitare l'errore duplicatevalue. IL WF risetta i valori
            }
            if(ss2temp4UpdateIndef.Plc_EncodedSerialNumberUnique__c != null || ss2temp4UpdateIndef.Plc_EncodedSerialNumberUnique__c !=''){
                ss2temp4UpdateIndef.Plc_EncodedSerialNumberUnique__c = 'tempEncod2'+timeTemp;//per evitare l'errore duplicatevalue. IL WF risetta i valori
            }

            if(ss2temp4Update.Plc_ManufacturerSerialNumberUnique__c != null || ss2temp4Update.Plc_ManufacturerSerialNumberUnique__c !=''){
                ss2temp4Update.Plc_ManufacturerSerialNumberUnique__c = 'tempManuf1'+timeTemp;//per evitare l'errore duplicatevalue. IL WF risetta i valori
            }
            if(ss2temp4UpdateIndef.Plc_ManufacturerSerialNumberUnique__c != null || ss2temp4UpdateIndef.Plc_ManufacturerSerialNumberUnique__c !=''){
                ss2temp4UpdateIndef.Plc_ManufacturerSerialNumberUnique__c = 'tempManuf2'+timeTemp;//per evitare l'errore duplicatevalue. IL WF risetta i valori
            }
            if(ss2temp4Update.Plc_DllSerialNumberUnique__c != null || ss2temp4Update.Plc_DllSerialNumberUnique__c !=''){
                ss2temp4Update.Plc_DllSerialNumberUnique__c = 'tempDll1'+timeTemp;//per evitare l'errore duplicatevalue. IL WF risetta i valori
            }
            if(ss2temp4UpdateIndef.Plc_DllSerialNumberUnique__c != null || ss2temp4UpdateIndef.Plc_DllSerialNumberUnique__c !=''){
                ss2temp4UpdateIndef.Plc_DllSerialNumberUnique__c = 'tempDll2'+timeTemp;//per evitare l'errore duplicatevalue. IL WF risetta i valori
            }

            update ss2temp4Update;
            update ss2temp4UpdateIndef;


            System.debug(' NEW Produst Stock: ' +  newModelName);

            //       System.debug('### PROD Stock ID:' + stockSerial.Bit2Shop__Product_Stock_Id__c);
            System.debug('INIZIO BLOCC UPDATE');
            //Setting warehouse
            stockSerial.Bit2Shop__Warehouse_Id__c = newWarehouseId;

            //Setting status fields
            //      stockSerial.Bit2Shop__Status__c = newStatus;
            //      stockSerial.Plc_Status2__c = newStatus2;


            //Mod Field SS2 principale
            stockSerial.Plc_EncodedSerialNumber__c = stockSerialIndef.Plc_EncodedSerialNumber__c;
            stockSerial.Plc_ManufacturerSerialNumber__c = stockSerialIndef.Plc_ManufacturerSerialNumber__c;
            stockSerial.Plc_DllSerialNumber__c = stockSerialIndef.Plc_DllSerialNumber__c;

            stockSerial.Bit2Shop__Shipment_Date__c = stockSerialIndef.Bit2Shop__Shipment_Date__c;
            stockSerial.Plc_FirstInstallationDate__c = stockSerialIndef.Plc_FirstInstallationDate__c;
            stockSerial.Plc_PurchaseDate__c = stockSerialIndef.Plc_PurchaseDate__c;
            stockSerial.Bit2Shop__Purchase_Price__c = stockSerialIndef.Bit2Shop__Purchase_Price__c;

            stockSerial.Plc_PurchaseWarrantyStartDate__c = stockSerialIndef.Plc_PurchaseWarrantyStartDate__c;
            stockSerial.Plc_PurchaseWarrantyEndDate__c = stockSerialIndef.Plc_PurchaseWarrantyEndDate__c;

            stockSerial.Plc_LastRepairCost__c = stockSerialIndef.Plc_LastRepairCost__c;
            stockSerial.Plc_RepairWarrantyStartDate__c = stockSerialIndef.Plc_RepairWarrantyStartDate__c;
            stockSerial.Plc_RepairWarrantyEndDate__c = stockSerialIndef.Plc_RepairWarrantyEndDate__c;

            stockSerial.Plc_RentalStartDate__c = stockSerialIndef.Plc_RentalStartDate__c;
            stockSerial.Plc_RentalEndDate__c = stockSerialIndef.Plc_RentalEndDate__c;

            stockSerial.Plc_DepreciationDuration__c = stockSerialIndef.Plc_DepreciationDuration__c;
            stockSerial.Plc_DepreciationPercentage__c = stockSerialIndef.Plc_DepreciationPercentage__c;
            stockSerial.Plc_DepreciationCompleted__c = stockSerialIndef.Plc_DepreciationCompleted__c;

            stockSerial.Plc_PTSCode__c = stockSerialIndef.Plc_PTSCode__c;

            stockSerial.Plc_PcipedModel__c = stockSerialIndef.Plc_PcipedModel__c;
            stockSerial.Plc_PCIPEDLetterOfApproval__c = stockSerialIndef.Plc_PCIPEDLetterOfApproval__c;
            stockSerial.Plc_PcipedApprovalNumber__c = stockSerialIndef.Plc_PcipedApprovalNumber__c;
            stockSerial.Plc_PcipedVersion__c = stockSerialIndef.Plc_PcipedVersion__c;
            stockSerial.Plc_PcipedExpiryDate__c = stockSerialIndef.Plc_PcipedExpiryDate__c;

            stockSerial.Plc_VoiceCode__c = stockSerialIndef.Plc_VoiceCode__c;

            stockSerial.Plc_Pin__c = stockSerialIndef.Plc_Pin__c;
            stockSerial.Plc_Puk1__c = stockSerialIndef.Plc_Puk1__c;
            stockSerial.Plc_Puk2__c = stockSerialIndef.Plc_Puk2__c;

            stockSerial.Plc_Note__c = stockSerialIndef.Plc_Note__c;

            System.debug('### Update Origin: ' + stockSerial.Plc_EncodedSerialNumber__c);
            //update stockSerial;
            update stockSerial;

            Plc_Utils.productStockQties.updateProductStockQuantities(new Map<String, Bit2Shop__Stock_Serials2__c>{stockSerialOldClone.Id => stockSerialOldClone},
                                                                     new Map<String, Bit2Shop__Stock_Serials2__c>{stockSerial.Id => stockSerial});
            //MOD campi su SS2 degli indefiniti
            Bit2Shop__Stock_Serials2__c stockSerialIndefOld = stockSerialIndef.clone();

            Bit2Shop__Warehouse__c warehouseBonifiche = [SELECT Id FROM Bit2Shop__Warehouse__c WHERE Plc_Alias__c = '999014NEXI'];

            stockSerialIndef.Bit2Shop__Warehouse_Id__c = warehouseBonifiche.id;
            //stockSerialIndef.Bit2Shop__Status__c = 'Irrecoverable';
            stockSerialIndef.Plc_LinkedWithSerial__c = stockSerial.Id;
            stockSerialIndef.Plc_EncodedSerialNumber__c = tempEncodedSerial;
            stockSerialIndef.Plc_ManufacturerSerialNumber__c = tempManufacturerSerial;
            stockSerialIndef.Plc_DllSerialNumber__c = tempDllSerial;

            List<Bit2Shop__Product_Stock__c> productStockStSerialIndef = retrieveAvailableProductStock(warehouseBonifiche.id, stockSerialIndef.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c);
            
            if (productStockStSerialIndef.size() > 0) {
                stockSerialIndef.Bit2Shop__Product_Stock_Id__c = productStockStSerialIndef.get(0).Id;
            } else {
                //Otherwise Product Stock will be created
                Bit2Shop__Product_Stock__c newProductStock2 = new Bit2Shop__Product_Stock__c();
                newProductStock2.Name = stockSerialIndef.Bit2Shop__Product_Stock_Id__r.Name;
                newProductStock2.Bit2Shop__External_Catalog_Item_Id__c = stockSerialIndef.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c;
                newProductStock2.Bit2Shop__Warehouse_Id__c = warehouseBonifiche.id;
                System.debug('### INSERT PRODUCT STOCK2');
                insert newProductStock2;
                stockSerialIndef.Bit2Shop__Product_Stock_Id__c = newProductStock2.Id;
            }
            
            System.debug('##STOCK SERIAL pre UNDEFINED :'+stockSerialIndef);
            update stockSerialIndef;

            //FB 20190603 - Adding Global Context transition skip [START]

            wrts_prcgvr.Interfaces_1_2.IPhaseManagerIntegration PhaseManagerIntegration = (wrts_prcgvr.Interfaces_1_2.IPhaseManagerIntegration)
                                                                                           wrts_prcgvr.VersionManager.newClassInstance('PhaseManagerIntegration');
                List<wrts_prcgvr__PhaseTransition__c> ptAvailable = (List<wrts_prcgvr__PhaseTransition__c>) PhaseManagerIntegration.getTransitions(new Map<String, Object> {
                'object'=> stockSerialIndef,
                'type'=> 'A',
                'context'=> 'SkipIrrecoverableTransition'
                });
                
            Map<String, Object> result = (Map<String, Object>) PhaseManagerIntegration.applyTransition(new Map<String, Object> {
                'object'=> stockSerialIndef,
                'transition'=> ptAvailable[0],
                'context'=> 'SkipIrrecoverableTransition'
                });

            //FB 20190603 - Adding Global Context transition skip [END]

            System.debug('##STOCK SERIAL after UNDEFINED :'+stockSerialIndef);

            Plc_Utils.productStockQties.updateProductStockQuantities(new Map<String, Bit2Shop__Stock_Serials2__c>{stockSerialIndef.Id => stockSerialIndefOld},
                                                                     new Map<String, Bit2Shop__Stock_Serials2__c>{stockSerialIndef.Id => stockSerialIndef});

            
        } catch (Exception e) {
            System.debug(e.getMessage() + ' ' + e.getStackTraceString());
            Database.rollback(sp);
            response.put('error', true);
            response.put('errorMsg', e.getMessage());
        }
        System.debug('FINE Update quantity');

        return response;
    }

    /**
     * Method used to retrieve list of Product Stock according to given warehouse and model
     *
     * @code 04
     * @param  warehouseId Warehouse Id
     * @param  modelId     External Catalog Item Id
     * @return             List of Product Stock
     */
    @AuraEnabled
    //public Static Map<String, Object> retrieveAvailableProductStock(String warehouseId, String modelId){
    public Static List<Bit2Shop__Product_Stock__c> retrieveAvailableProductStock(String warehouseId, String modelId){

        //   Map<String, Object> response = new Map<String, Object>();
        // response.put('error', false);

        List<Bit2Shop__Product_Stock__c> productStockStSerial = [SELECT Id, Bit2Shop__Warehouse_Id__c, Bit2Shop__External_Catalog_Item_Id__c
        FROM Bit2Shop__Product_Stock__c
        WHERE Bit2Shop__Warehouse_Id__c = :warehouseId AND
        Bit2Shop__External_Catalog_Item_Id__c = :modelId];

        return productStockStSerial;
        //response.put('productStockStSerial', productStockStSerial);
        //return response;
    }
    //FINE MOD
    @AuraEnabled
    public static void updateMainSS2(Bit2Shop__Stock_Serials2__c ss2, Bit2Shop__Stock_Serials2__c ss2Indef){
        System.debug('### updateMainSS2: ' + ss2);
        System.debug('### SS2 Indef: ' + ss2Indef);

        //Bit2Shop__Stock_Serials2__c stockSerial, String newWarehouseId, String newModelId,
        // String newModelName, Bit2Shop__Stock_Serials2__c stockSerialIndef
        Map<String, Object> mappaSS2FromOriginUpdate = updateStockSerialLAST(ss2, ss2.Bit2Shop__Warehouse_Id__c, ss2.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c, ss2.Bit2Shop__Product_Stock_Id__r.Name ,ss2Indef);
    }

    @AuraEnabled
    public static void updateIndispSS2(Bit2Shop__Stock_Serials2__c ss2, Bit2Shop__Stock_Serials2__c ss2Indef){
        System.debug('### updateIndispSS2');
        Map<String, Object> mappaSS2FromIndefUpdate = updateStockSerialLAST(ss2, ss2.Bit2Shop__Warehouse_Id__c, ss2Indef.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c, ss2Indef.Bit2Shop__Product_Stock_Id__r.Name ,ss2Indef);
    }

    @AuraEnabled
    public static void updateIndispLkSS2(Bit2Shop__Stock_Serials2__c ss2, Bit2Shop__Stock_Serials2__c ss2Indef, B2WExtCat__External_Catalog_Item__c modelLookup){
        System.debug('### updateIndispLkSS2');
        Map<String, Object> mappaSS2FromIndefUpdate = updateStockSerialLAST(ss2, ss2.Bit2Shop__Warehouse_Id__c, modelLookup.Id, modelLookup.B2WExtCat__External_Catalog_Item_Name__c, ss2Indef);
    }

    /**
     * Method used in order to check whether selected serial is a fake one
     * @author FB
     * @return A Boolean indicating is the serial is fake
     */
    @AuraEnabled
    public static String preCheckSerial(Bit2Shop__Stock_Serials2__c stockSerial){
        if (FeatureManagement.checkPermission(Plc_Constants.CustomPermission.PlcMergeStockSerialFromUndefined)) {

            Bit2Shop__Stock_Serials2__c retrievedStockSerial = [SELECT Id, Plc_EncodedSerialNumber__c,
                                                                       Plc_ManufacturerSerialNumber__c,
                                                                       Plc_DllSerialNumber__c
                                                                FROM Bit2Shop__Stock_Serials2__c 
                                                                WHERE Id = :stockSerial.Id
                                                                LIMIT 1];

            System.debug(retrievedStockSerial);

            if((retrievedStockSerial.Plc_EncodedSerialNumber__c != null &&
                retrievedStockSerial.Plc_EncodedSerialNumber__c.startsWith('FIT'))
                || (retrievedStockSerial.Plc_ManufacturerSerialNumber__c != null && 
                    retrievedStockSerial.Plc_ManufacturerSerialNumber__c.startsWith('FIT'))
                || (retrievedStockSerial.Plc_DllSerialNumber__c != null && 
                    retrievedStockSerial.Plc_DllSerialNumber__c.startsWith('FIT'))) {
                    
                    return '';
                } else {
                    return Label.Plc_LightningComponentStockSerialsMergeFromUndefinedNotFakeSerial;
                    
                }
        } else {
            return Label.Plc_AllAllUserForbiddenOperation;
        }
    }

    /**
     * Method used in order to get some different system labels
     * @author FB
     * @createdDate 2019-09-11
     * @return A map containing pairs Api Name/Label
     */
    @AuraEnabled
    public static Map<String, String> retrieveTranslationMap(){
        Map<String, String> response = new Map<String,String>();
        //Getting Serial Stock 2 labels

        Schema.DescribeSObjectResult stockSerialSchema = Bit2Shop__Stock_Serials2__c.SObjectType.getDescribe();
        Map<String, Schema.SObjectField> stockSerialFieldsMap = stockSerialSchema.fields.getMap();
        response.put('Id', stockSerialFieldsMap.get('Id').getDescribe().getLabel());
        response.put('Name', stockSerialFieldsMap.get('Name').getDescribe().getLabel());
        response.put('Plc_EncodedSerialNumber__c', stockSerialFieldsMap.get('Plc_EncodedSerialNumber__c').getDescribe().getLabel());
        response.put('Plc_ManufacturerSerialNumber__c', stockSerialFieldsMap.get('Plc_ManufacturerSerialNumber__c').getDescribe().getLabel());
        response.put('Plc_DllSerialNumber__c', stockSerialFieldsMap.get('Plc_DllSerialNumber__c').getDescribe().getLabel());
        response.put('Plc_DepreciationDuration__c', stockSerialFieldsMap.get('Plc_DepreciationDuration__c').getDescribe().getLabel());
        response.put('Plc_DepreciationPercentage__c', stockSerialFieldsMap.get('Plc_DepreciationPercentage__c').getDescribe().getLabel());
        response.put('Plc_DepreciationCompleted__c', stockSerialFieldsMap.get('Plc_DepreciationCompleted__c').getDescribe().getLabel());
        response.put('Plc_VoiceCode__c', stockSerialFieldsMap.get('Plc_VoiceCode__c').getDescribe().getLabel());
        response.put('Plc_Pin__c', stockSerialFieldsMap.get('Plc_Pin__c').getDescribe().getLabel());
        response.put('Plc_Puk1__c', stockSerialFieldsMap.get('Plc_Puk1__c').getDescribe().getLabel());
        response.put('Plc_Puk2__c', stockSerialFieldsMap.get('Plc_Puk2__c').getDescribe().getLabel());
        response.put('Plc_Note__c', stockSerialFieldsMap.get('Plc_Note__c').getDescribe().getLabel());
        response.put('Bit2Shop__Product_Stock_Id__c', stockSerialFieldsMap.get('Bit2Shop__Product_Stock_Id__c').getDescribe().getLabel());
        response.put('Bit2Shop__Shipment_Date__c', stockSerialFieldsMap.get('Bit2Shop__Shipment_Date__c').getDescribe().getLabel());
        response.put('Plc_FirstInstallationDate__c', stockSerialFieldsMap.get('Plc_FirstInstallationDate__c').getDescribe().getLabel());
        response.put('Plc_PurchaseDate__c', stockSerialFieldsMap.get('Plc_PurchaseDate__c').getDescribe().getLabel());
        response.put('Bit2Shop__Purchase_Price__c', stockSerialFieldsMap.get('Bit2Shop__Purchase_Price__c').getDescribe().getLabel());
        response.put('Plc_PurchaseWarrantyStartDate__c', stockSerialFieldsMap.get('Plc_PurchaseWarrantyStartDate__c').getDescribe().getLabel());
        response.put('Plc_PurchaseWarrantyEndDate__c', stockSerialFieldsMap.get('Plc_PurchaseWarrantyEndDate__c').getDescribe().getLabel());
        response.put('Plc_LastRepairCost__c', stockSerialFieldsMap.get('Plc_LastRepairCost__c').getDescribe().getLabel());
        response.put('Plc_RepairWarrantyStartDate__c', stockSerialFieldsMap.get('Plc_RepairWarrantyStartDate__c').getDescribe().getLabel());
        response.put('Plc_RepairWarrantyEndDate__c', stockSerialFieldsMap.get('Plc_RepairWarrantyEndDate__c').getDescribe().getLabel());
        response.put('Plc_RentalStartDate__c', stockSerialFieldsMap.get('Plc_RentalStartDate__c').getDescribe().getLabel());
        response.put('Plc_RentalEndDate__c', stockSerialFieldsMap.get('Plc_RentalEndDate__c').getDescribe().getLabel());
        response.put('Plc_PTSCode__c', stockSerialFieldsMap.get('Plc_PTSCode__c').getDescribe().getLabel());
        response.put('Plc_PcipedModel__c', stockSerialFieldsMap.get('Plc_PcipedModel__c').getDescribe().getLabel());
        response.put('Plc_PCIPEDLetterOfApproval__c', stockSerialFieldsMap.get('Plc_PCIPEDLetterOfApproval__c').getDescribe().getLabel());
        response.put('Plc_PcipedApprovalNumber__c', stockSerialFieldsMap.get('Plc_PcipedApprovalNumber__c').getDescribe().getLabel());
        response.put('Plc_PcipedVersion__c', stockSerialFieldsMap.get('Plc_PcipedVersion__c').getDescribe().getLabel());
        response.put('Plc_PcipedExpiryDate__c', stockSerialFieldsMap.get('Plc_PcipedExpiryDate__c').getDescribe().getLabel());
        response.put('Plc_Manufacturer__c', stockSerialFieldsMap.get('Plc_Manufacturer__c').getDescribe().getLabel());
        response.put('Bit2Shop__Warehouse_Id__c', stockSerialFieldsMap.get('Bit2Shop__Warehouse_Id__c').getDescribe().getLabel());
        response.put('Bit2Shop__Status__c', stockSerialFieldsMap.get('Bit2Shop__Status__c').getDescribe().getLabel());
        response.put('Plc_Status2__c', stockSerialFieldsMap.get('Plc_Status2__c').getDescribe().getLabel());

        return response;
    }
}