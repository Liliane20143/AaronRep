/**
 * Created by dilorenzo on 01/02/2019.
 */

public with sharing class Plc_ActivityCompileReportCnt {

    @AuraEnabled
    public static Map<String, Object> retrieveInfoStockSerial(String stockSerialId){

        Map<String, Object> response = new Map<String, Object>();
        response.put('error', false);

        //Getting current Stock Serial
        try {

            //Getting Serial Stock 2 labels
            Schema.DescribeSObjectResult serialStockSchema = Bit2Shop__Stock_Serials2__c.SObjectType.getDescribe();
            Map<String, Schema.SObjectField> serialStockFieldsMap = serialStockSchema.fields.getMap();
            response.put('StockSerialName', serialStockSchema.getLabel());

            //Getting Serial Stock 2 labels
            Schema.DescribeSObjectResult activitySchema = wrts_prcgvr__Activity__c.SObjectType.getDescribe();
            Map<String, Schema.SObjectField> activityFieldsMap = activitySchema.fields.getMap();
            response.put('ActivityName', activitySchema.getLabel());

            List<Bit2Shop__Stock_Serials2__c> stockSerialList = [SELECT Id, Name, Bit2Shop__Warehouse_Id__r.Plc_Tipology__c, Plc_ManufacturerSerialNumber__c, Plc_DllSerialNumber__c,
                Plc_EncodedSerialNumber__c, Plc_Model__c, Bit2Shop__Product_Stock_Id__c, Bit2Shop__Status__c,
                Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c, Bit2Shop__Product_Stock_Id__r.Name, Bit2Shop__Product_Stock_Id__r.Bit2Shop__Warehouse_Id__c,Plc_Status2__c,Bit2Shop__Warehouse_Id__c
            FROM Bit2Shop__Stock_Serials2__c
            WHERE Id = :stockSerialId];

            if (stockSerialList != null && stockSerialList.size() > 0) {
                response.put('stockSerial', stockSerialList.get(0));
            }
            //response.put('statusAvailableOptionsMap', stockSerialList.get(0));
        }
        catch(Exception e) {
            response.put('error', true);
            //response.put('errorMsg', e.getMessage());
        }

        System.debug('### SIZE: ' + response.size());
        return response;
    }

    //get values picklist Status__c from SS2
    @AuraEnabled
    public static Map<String,Object> picklistValuesStatus(){

        //List<String> response = new List<String>();
        Map<String, Object> response = new Map<String, Object>();
        //response.put('error', false);

        List<String> listPickListValues= new List<String>();
        Schema.DescribeFieldResult fieldResult = Bit2Shop__Stock_Serials2__c.Bit2Shop__Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        /*
        for( Schema.PicklistEntry pickListVal : ple){
            //response.put('picklistStatus', pickListVal.getLabel());
            response.put(pickListVal.getValue(),pickListVal.getLabel());
            //response.add(pickListVal.getLabel());
        }
    */
        response.put('statusAvailableOptionsMap', retrieveActivePickListValues('Bit2Shop__Stock_Serials2__c', 'Bit2Shop__Status__c'));

        System.debug('### MAPPA valori status: ' + response);
        return response;
    }

    @AuraEnabled
    public static Map<String,Object> picklistValuesTag(){

        //List<String> response = new List<String>();
        Map<String, Object> response = new Map<String, Object>();
        //response.put('error', false);

        List<String> listPickListValues= new List<String>();
        Schema.DescribeFieldResult fieldResult = Bit2Shop__Stock_Serials2__c.Plc_Tag__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        response.put('tagAvailableOptionsMap', retrieveActivePickListValues('Bit2Shop__Stock_Serials2__c', 'Plc_Tag__c'));

        System.debug('### MAPPA valori status: ' + response);
        return response;
    }

    private Static Map<String, String> retrieveActivePickListValues(String sObjectType, String fieldName){
        Map<String, String> picklistMapToReturn = new Map<String, String>();
        Schema.DescribeFieldResult objectFieldMap = Schema.getGlobalDescribe()
            .get(sObjectType)
            .getDescribe()
            .fields.getMap()
            .get(fieldName)
            .getDescribe();

        List<String> listStatus4ActivityReport = new List<String>();

        if(fieldName == 'Bit2Shop__Status__c'){

            //String valuesPicklist = 'Available;To be decommissioned;To be reconditioned;Broken;Received failure;To update release;Tampered with';
            String valuesPicklist = Plc_SystemSettings__c.getInstance().Plc_StatusPicklistValueForSS2__c;//CS con i possibili valori della picklist disponibile

            //Split
            listStatus4ActivityReport = valuesPicklist.split(';');
            valuesPicklist = listStatus4ActivityReport[listStatus4ActivityReport.size()-1];

            System.debug('List picklist values: ' + listStatus4ActivityReport);

            for (Schema.PicklistEntry picklistEntry : objectFieldMap.getPicklistValues()) {
                if (picklistEntry.isActive() && listStatus4ActivityReport.contains(picklistEntry.getValue())) {
                    picklistMapToReturn.put(picklistEntry.getValue(), picklistEntry.getLabel());
                }
            }
        }
        else  if(fieldName == 'Plc_Tag__c'){

            System.debug('List picklist Tag values: ');

            Schema.SObjectType objType = Schema.getGlobalDescribe().get('Bit2Shop__Stock_Serials2__c');
            Schema.DescribeSObjectResult describeResult = objType.getDescribe();

            Map<Object,List<String>> dependValuesByControlValue = getDependentPicklistValues( Bit2Shop__Stock_Serials2__c.Plc_Tag__c);
            System.debug('### MAPPA: ' + dependValuesByControlValue);

            List<String> listValueDependencyPk = dependValuesByControlValue.get('To be decommissioned');
            System.debug('### LISTA: ' + listValueDependencyPk);

            for (Schema.PicklistEntry picklistEntry : objectFieldMap.getPicklistValues()) {
                if (picklistEntry.isActive() && listValueDependencyPk.contains(picklistEntry.getValue())) {
                    picklistMapToReturn.put(picklistEntry.getValue(), picklistEntry.getLabel());
                }
            }
        }
        return picklistMapToReturn;
    }

    //Method to show the dependency of a picklist
    public static Map<Object,List<String>> getDependentPicklistValues( Schema.sObjectField dependToken ){
        Schema.DescribeFieldResult depend = dependToken.getDescribe();
        Schema.sObjectField controlToken = depend.getController();
        if ( controlToken == null ) return null;
        Schema.DescribeFieldResult control = controlToken.getDescribe();
        List<Schema.PicklistEntry> controlEntries =
            (   control.getType() == Schema.DisplayType.Boolean
                ?   null
                :   control.getPicklistValues()
            );

        String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
        Map<Object,List<String>> dependentPicklistValues = new Map<Object,List<String>>();
        for ( Schema.PicklistEntry entry : depend.getPicklistValues() ) if ( entry.isActive() )
        {
            List<String> base64chars =
                String.valueOf
                    (   ((Map<String,Object>) JSON.deserializeUntyped( JSON.serialize( entry ) )).get( 'validFor' )
                    ).split( '' );
            for ( Integer index = 0; index < (controlEntries != null ? controlEntries.size() : 2); index++ )
            {
                Object controlValue =
                    (   controlEntries == null
                        ?   (Object) (index == 1)
                        :   (Object) (controlEntries[ index ].isActive() ? controlEntries[ index ].getLabel() : null)
                    );
                Integer bitIndex = index / 6, bitShift = 5 - Math.mod( index, 6 );
                if  (   controlValue == null
                    ||  (base64map.indexOf( base64chars[ bitIndex ] ) & (1 << bitShift)) == 0
                    ) continue;
                if ( !dependentPicklistValues.containsKey( controlValue ) )
                {
                    dependentPicklistValues.put( controlValue, new List<String>() );
                }
                dependentPicklistValues.get( controlValue ).add( entry.getLabel() );
            }
        }
        return dependentPicklistValues;
    }

    @AuraEnabled
    public static Map<String, Object> updateSS2(Bit2Shop__Stock_Serials2__c ss2, String newStatus, String valueTag){
        System.debug('Update Status: ' + ss2.Id + ' NEW value: ' + newStatus);

        Map<String, Object> response = new Map<String, Object>();
        response.put('error', false);

        try {
            Bit2Shop__Stock_Serials2__c tempSS2 = ss2;
            Bit2Shop__Stock_Serials2__c tempSS2OldClone = ss2.clone();

            tempSS2.Bit2Shop__Status__c = newStatus;

            if(valueTag != '') {
                System.debug('update TAG: ' + valueTag);
                tempSS2.Plc_Tag__c = valueTag;
            }

            update tempSS2;

            Plc_Utils.productStockQties.updateProductStockQuantities(new Map<String, Bit2Shop__Stock_Serials2__c>{'' + tempSS2.Id => tempSS2OldClone},
                                                                     new Map<String, Bit2Shop__Stock_Serials2__c>{'' + tempSS2.Id => tempSS2});

        } catch (Exception e) {
            response.put('error', true);
            response.put('errorMsg', e.getMessage());
        }
        return response;
    }

    @AuraEnabled
    public static void updateSS2FDL(Bit2Shop__Stock_Serials2__c ss2, String newStatus){
        System.debug('Update Status: ' + ss2.Id + ' NEW value: ' + newStatus);
        Bit2Shop__Stock_Serials2__c tempSS2 = ss2;
        tempSS2.Bit2Shop__Status__c = newStatus;

        update tempSS2;
    }

    @AuraEnabled
   // public static String getCSStatus(){
    public static String getCS4TagLk(){
        String valueStatus4Tag = Plc_SystemSettings__c.getInstance().Plc_StatusStockSerialForTagPicklist__c;
        System.debug('### Value CS: ' + valueStatus4Tag);
        //aggiungere ad una lista

        String valueStatusWithoutFillReport = Plc_SystemSettings__c.getInstance().Plc_StatusStockSerialWithoutFillReport__c;
        System.debug('### Value CS: ' + valueStatusWithoutFillReport);
        //aggiungere ad una lista

        //return una lista e parsarla correttamente nel componente e JS
        return valueStatus4Tag;
    }

    @AuraEnabled
    public static Map<String, Object> lastActivityPClickCreated(String stockSerialId, String newStatusSelected){
        wrts_prcgvr__Activity__c lastActivity = null;

        Map<String, Object> response = new Map<String, Object>();
        response.put('error', false);

        try {

            System.debug('### Id SS2: ' +stockSerialId + ' New status: ' + newStatusSelected);

            List<wrts_prcgvr__Activity__c> listActivityPCss2 = [SELECT Id,wrts_prcgvr__ObjectId__c, LastModifiedDate, Plc_StockSerial2__r.Bit2Shop__Status__c
                    FROM wrts_prcgvr__Activity__c
                    WHERE RecordTypeId = :Plc_Utils.getRecordTypeId('Plc_Report', 'wrts_prcgvr__Activity__c') AND wrts_prcgvr__ObjectId__c = :stockSerialId
                          AND Plc_ChecklistExecuted__c = false
                    ORDER BY LastModifiedDate DESC NULLS LAST];

            System.debug('### Lista Activity PC ss2: ' + listActivityPCss2);

            if(!listActivityPCss2.isEmpty()){
                lastActivity = listActivityPCss2.get(0);

                lastActivity.Plc_StatusStockSerial__c = newStatusSelected;
                lastActivity.Plc_StockSerial2__c = stockSerialId;
                if (newStatusSelected == 'Available') {
                    lastActivity.Plc_ChecklistExecuted__c = true;
                    lastActivity.wrts_prcgvr__Description__c = lastActivity.Plc_StatusStockSerial__c;
                }

                update lastActivity;
            }

            System.debug('### lastActivity: ' + lastActivity);
            response.put('activityId', lastActivity.Id);

        } catch (Exception e) {
            response.put('error', true);
            response.put('errorMsg', e.getMessage());
        }
        return response;
    }

    @InvocableMethod
    public static void updateStatusSS2(List<String> idSS2){
        System.debug('Update Status from Process Builder: ' + idSS2.get(0));

    //   wrts_prcgvr__Activity__c activityCreated = [SELECT Id, Plc_StatusStockSerial__c, wrts_prcgvr__ObjectId__c FROM wrts_prcgvr__Activity__c WHERE Id = :idSS2 LIMIT 1];

        try {
            List<wrts_prcgvr__Activity__c> listCurrentActivity = [SELECT Id, Plc_StatusStockSerial__c, wrts_prcgvr__ObjectId__c, wrts_prcgvr__Status__c,CreatedDate, Plc_ActivityReportDateReportFault__c 
                                                                  FROM wrts_prcgvr__Activity__c 
                                                                  WHERE wrts_prcgvr__ObjectId__c = :idSS2.get(0)
                                                                  ORDER BY LastModifiedDate DESC NULLS LAST];

        //usare CS
            wrts_prcgvr__Activity__c tempActivity = listCurrentActivity.get(0);

            String statusActivity = Plc_SystemSettings__c.getInstance().Plc_StatusActivityAfterReport__c;

            tempActivity.wrts_prcgvr__Status__c = 'Completed';        
            //tempActivity.wrts_prcgvr__Status__c = statusActivity;

            tempActivity.Plc_ActivityReportDateReportFault__c = Date.valueOf(tempActivity.CreatedDate);
            update tempActivity;

            List<Bit2Shop__Stock_Serials2__c> listSS2ToUpdate = [SELECT Id, Bit2Shop__Status__c, Bit2Shop__Warehouse_Id__c, Bit2Shop__Product_Stock_Id__c,
                Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c, Bit2Shop__Product_Stock_Id__r.Name
                FROM Bit2Shop__Stock_Serials2__c WHERE Id = :idSS2];

            Bit2Shop__Stock_Serials2__c tempSS2 = listSS2ToUpdate.get(0);
            Bit2Shop__Stock_Serials2__c tempSS2OldClone = listSS2ToUpdate.get(0).clone();

            tempSS2.Bit2Shop__Status__c = tempActivity.Plc_StatusStockSerial__c;

            System.debug('Update Status from Process Builder & Code' + listSS2ToUpdate.get(0).Id);
            //listSS2ToUpdate.get(0).Bit2Shop__Status__c = newStatusSS2;
            //update tempSS2;
            Bit2Shop__Stock_Serials2__c stockSerialOldClone = tempSS2.clone();
            update tempSS2;
            
            String modelName =tempSS2.Bit2Shop__Product_Stock_Id__r.Name;
            String modelId = tempSS2.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c;
            String warehouseId = tempSS2.Bit2Shop__Warehouse_Id__c;

            stockSerialOldClone.Id = tempSS2.Id;

            System.debug('PRIMA di PRODUCT STOCK');
            List<Bit2Shop__Product_Stock__c> productStockList = retrieveAvailableProductStock(warehouseId, modelId);

            System.debug('DOPO di PRODUCT STOCK');
            //A Product Stock was found in given warehouse
            if (productStockList.size() > 0) {
                System.debug('DOPO IF ');
                tempSS2.Bit2Shop__Product_Stock_Id__c = productStockList.get(0).Id;
            } else {
                System.debug('DOPO ELSE');
                //Otherwise Product Stock will be created
                Bit2Shop__Product_Stock__c newProductStock = new Bit2Shop__Product_Stock__c();
                newProductStock.Name = modelName;
                newProductStock.Bit2Shop__External_Catalog_Item_Id__c = modelId;
                newProductStock.Bit2Shop__Warehouse_Id__c = warehouseId;

                System.debug('### INSERT PRODUCT STOCK');
                insert newProductStock;

                tempSS2.Bit2Shop__Product_Stock_Id__c = newProductStock.Id;
            }

            Plc_Utils.productStockQties.updateProductStockQuantities(new Map<String, Bit2Shop__Stock_Serials2__c>{stockSerialOldClone.Id => stockSerialOldClone},
                                                                     new Map<String, Bit2Shop__Stock_Serials2__c>{tempSS2.Id => tempSS2});
        } catch (Exception e) {
            throw new Plc_Exception(e);
        }

        //updateSS2FromActivity(tempActivity.wrts_prcgvr__ObjectId__c, tempActivity.Plc_StatusStockSerial__c);
    }

    public static String preCheckSerial(Bit2Shop__Stock_Serials2__c stockSerial) {

        List<Bit2Shop__Stock_Serials2__c> stockSerialListId = [SELECT Id, Bit2Shop__Status__c
            FROM Bit2Shop__Stock_Serials2__c
            WHERE Id = :stockSerial.Id];

        List<wrts_prcgvr__Activity__c> listActivityPCss2 = [SELECT Id
                                                            FROM wrts_prcgvr__Activity__c
                                                            WHERE RecordTypeId = :Plc_Utils.getRecordTypeId('Plc_Report', 'wrts_prcgvr__Activity__c') AND 
                                                                  wrts_prcgvr__ObjectId__c = :stockSerial.Id AND 
                                                                  Plc_ChecklistExecuted__c = false
                                                            ORDER BY LastModifiedDate 
                                                            DESC NULLS LAST];
        if (listActivityPCss2.isEmpty()) {
            return label.Plc_LightningComponentActivityCompileReportNoRelatedOpenActivities + ' [' + stockSerial.Id + ']';
        } else {
            if (stockSerialListId[0].Bit2Shop__Status__c != 'To be verified') {
                return label.Plc_LightningComponentActivityCompileReportSerialStatusNotToBeVerified + ' [' + stockSerial.Id + ']';                
            }else {
                return null;                
            }
        }
    }

    public Static List<Bit2Shop__Product_Stock__c> retrieveAvailableProductStock(String warehouseId, String modelId){

        List<Bit2Shop__Product_Stock__c> productStockList = [SELECT Id, Bit2Shop__Warehouse_Id__c, Bit2Shop__External_Catalog_Item_Id__c
        FROM Bit2Shop__Product_Stock__c
        WHERE Bit2Shop__Warehouse_Id__c = :warehouseId AND
        Bit2Shop__External_Catalog_Item_Id__c = :modelId];

        return productStockList;
    }
}