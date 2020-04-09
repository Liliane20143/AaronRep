/**
 * Plc_StockSerials2Hnd - Stock Serial 2 Trigger Handler
 *
 * @author AP
 * @date Creation 15/01/2019
 * @description 
 * @testedIn Plc_StockSerials2HndTest
 *
 * 2019-03-26 FB - Moving activities update to inner without sharing class
 */
public with sharing class Plc_StockSerials2Hnd implements ITriggerHandler {
    public Boolean IsDisabled(){
        TriggerSettings__c setting = TriggerSettings__c.getInstance();
        return setting.StockSerial2Trigger__c!= null
                && setting.StockSerial2Trigger__c > System.now();
    }

    public void BeforeInsert(List<SObject> newItems) {

    }

    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        //if(Test.isRunningTest()) {
        System.debug('### Plc_StockSerials2Hnd.BeforeUpdate');
        //>>PClick Phase Manager integration - DO NOT REMOVE
        wrts_prcgvr.Interfaces_1_2.IPhaseManagerIntegration PhaseManagerIntegration
                = (wrts_prcgvr.Interfaces_1_2.IPhaseManagerIntegration)
                    wrts_prcgvr.VersionManager.newClassInstance('PhaseManagerIntegration');
        PhaseManagerIntegration.beforeUpdate(new Map<String, Object>{
                'oldObjects' => trigger.old,
                'newObjects' => trigger.new
        });
           
        //}
        //<<PClick Phase Manager integration - DO NOT REMOVE

        //MZ 20199213 - Check for process flag on Stock Serial 2 - START

        Set<String> warehousesToRetrieveSet = new Set<String>();
        for (Bit2Shop__Stock_Serials2__c serial : (List<Bit2Shop__Stock_Serials2__c>) newItems.values()) {
            if (serial.Plc_ComeFromProcess__c) {
                serial.Plc_ComeFromProcess__c = false;
                serial.Plc_UpdateReason__c = 'PROCESS';
            } else {
                serial.Plc_UpdateReason__c = 'MANUAL';
            }
            warehousesToRetrieveSet.add(serial.Bit2Shop__Warehouse_Id__c);
        }
        //MZ 20199213 - Check for process flag on Stock Serial 2 - END

        //FB 24-10-2019: Updating property [START]
        //Loading items 
        Map<Id, Bit2shop__Warehouse__c> newItemsWarehouses = new Map<Id, Bit2shop__Warehouse__c>([SELECT Id, Plc_Property__c,
                                                                                                         Plc_Tipology__c
                                                                                                 FROM Bit2shop__Warehouse__c
                                                                                                 WHERE Id IN :warehousesToRetrieveSet]);

        System.debug('### newItemsWarehouses.size(): ' +  newItemsWarehouses.size());

        for (String key : newItems.keySet()) {
            Bit2Shop__Stock_Serials2__c newStockSerial = (Bit2Shop__Stock_Serials2__c)newItems.get(key);
            Bit2Shop__Stock_Serials2__c oldStockSerial = (Bit2Shop__Stock_Serials2__c)oldItems.get(key);

            if (oldStockSerial != null && oldStockSerial.Bit2Shop__Warehouse_Id__c != newStockSerial.Bit2Shop__Warehouse_Id__c) {
                if (newItemsWarehouses.containsKey(newStockSerial.Bit2Shop__Warehouse_Id__c) && 
                    newItemsWarehouses.get(newStockSerial.Bit2Shop__Warehouse_Id__c).Plc_Tipology__c == 'Generic') {
                        newStockSerial.Plc_Property__c = newItemsWarehouses.get(newStockSerial.Bit2Shop__Warehouse_Id__c).Plc_Property__c;

                    }
            }
        }
        //FB 24-10-2019: Updating property [END]


    }


    public void BeforeDelete(Map<Id, SObject> oldItems) {
        /** [START MOD 22/01/2019 16:28]@Author:nunzio.capasso@/webresults.it @Description: NEXIPLC-255 - Prevent modfied stockSerial from being deleted **/
        system.debug('=oldItemss=='+oldItems);
        system.debug('=oldtrigger=='+Trigger.old);
        //List<Bit2Shop__Stock_Serials2__c> stockSerials2Old = (List<Bit2Shop__Stock_Serials2__c>) Trigger.old;
        List<Bit2Shop__Stock_Serials2__c> stockSerials2Old = oldItems.values();
        for(Bit2Shop__Stock_Serials2__c stockSerials2 :stockSerials2Old) {
            //N.C fix NEXIPLC-286 start
            /*if (stockSerials2.Bit2Shop__Status__c != 'New' && stockSerials2.LastModifiedDate != stockSerials2.CreatedDate) {*/
            /*if (stockSerials2.Bit2Shop__Status__c != 'New' && String.isEmpty(stockSerials2.Plc_Status2__c)) {*/
            //N.C fix NEXIPLC-286 end
            //J.R fix NEXIPLC-286 start
            if ( !(stockSerials2.Bit2Shop__Status__c == 'New' && stockSerials2.Plc_Status2__c == 'None') ) {
                stockSerials2.addError('record '+stockSerials2.Name+' can\'t be deleted');
            }
            //J.R fix NEXIPLC-286 end
        }
        /** [END MOD 22/01/2019 16:28]@Author:nunzio.capasso@/webresults.it @Description:NEXIPLC-255 - Prevent modfied stockSerial from being deleted **/
    }

    public void AfterInsert(Map<Id, SObject> newItems) {
        //Plc_StockSerial2HistoryManager.manageInsertOperation(newItems);
    }

    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        ActivityManager actManager = new ActivityManager();
        actManager.updateActivities((Map<Id, Bit2Shop__Stock_Serials2__c>) newItems, 
                                     (Map<Id, Bit2Shop__Stock_Serials2__c>) oldItems);
        //FB 20190923: NEXIPLC-700 Making SLI update in sync mode [START]
        Plc_StockSerial2HistoryManager.updateSLIDate(newItems);
        //Plc_StockSerial2HistoryManager.manageUpdateOperation(newItems, oldItems);
        //FB 20190923: NEXIPLC-700 Making SLI update in sync mode [END]
        
    }

    public void AfterDelete(Map<Id, SObject> oldItems) {}
    public void AfterUndelete(Map<Id, SObject> oldItems) {}

    private without sharing class ActivityManager {

        void updateActivities(Map<Id, Bit2Shop__Stock_Serials2__c> newItems, Map<Id, Bit2Shop__Stock_Serials2__c> oldItems) {
            map<String, Object> activitiesMap = (map<String,Object>)((wrts_prcgvr.Interfaces_1_0.IActivityUtils) 
                                                 wrts_prcgvr.VersionManager.newClassInstance('ActivityUtils')).bulkSaveActivityContext(null);//ORIG
            List<wrts_prcgvr__Activity__c> activities = (List<wrts_prcgvr__Activity__c>) activitiesMap.get('Activities');

            if (activities.size() > 0) {
                for (wrts_prcgvr__Activity__c act : activities) {
                    act.Plc_StockSerial2__c = act.wrts_prcgvr__ObjectId__c;
                }
                update activities;
            }

            //FB 24-10-2019: Updating activities owner [START]
            Set<String> stockSerialsChangedWarehouseSet = new Set<String>();

            for (String key : newItems.keySet()) {
                if (oldItems.containsKey(key) && oldItems.get(key).Bit2Shop__Warehouse_Id__c != newItems.get(key).Bit2Shop__Warehouse_Id__c) {
                    stockSerialsChangedWarehouseSet.add(newItems.get(key).Id);
                }
            }

            System.debug('### stockSerialsChangedWarehouseSet.size(): ' + stockSerialsChangedWarehouseSet.size());
            List<wrts_prcgvr__Activity__c> activitiesToUpdate = new List<wrts_prcgvr__Activity__c>();

            for (wrts_prcgvr__Activity__c act : [SELECT Id, Plc_StockSerial2__r.Bit2Shop__Warehouse_Id__r.Bit2Shop__Dealer_Id__r.OwnerId, OwnerId
                                                 FROM wrts_prcgvr__Activity__c 
                                                 WHERE Plc_StockSerial2__c IN :stockSerialsChangedWarehouseSet AND
                                                       wrts_prcgvr__Status__c = 'Not Started']) {
                System.debug('### act.OwnerId [BEFORE]: ' + act.OwnerId);
                act.OwnerId = act.Plc_StockSerial2__r.Bit2Shop__Warehouse_Id__r.Bit2Shop__Dealer_Id__r.OwnerId;
                System.debug('### act.OwnerId [AFTER]: ' + act.OwnerId);
                activitiesToUpdate.add(act);
            }

            System.debug('### activitiesToUpdate.size(): ' + activitiesToUpdate.size());
            if (!activitiesToUpdate.isEmpty()) {
                update activitiesToUpdate;
            }
            //FB 24-10-2019: Updating activities owner [END]
        }
    }
}