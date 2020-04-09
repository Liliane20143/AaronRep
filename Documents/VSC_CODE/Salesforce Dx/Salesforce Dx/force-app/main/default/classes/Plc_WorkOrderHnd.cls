/**
 * WorkOrderHnd - Work Order Trigger Handler
 *
 * @author EM
 * @date Creation 28/12/2018
 * @description
 * @testedIn WorkOrderHndTest
 */
public with sharing class Plc_WorkOrderHnd implements ITriggerHandler{

    public Boolean isDisabled(){

        LogTracker.debugLogBegin('Plc_WorkOrderHnd', 'IsDisabled');
        TriggerSettings__c setting = TriggerSettings__c.getInstance();
        Boolean disabled = setting.WorkOrderTrigger__c != null
                && setting.WorkOrderTrigger__c > System.now();
        LogTracker.debugLog('Plc_WorkOrderHnd', 'IsDisabled', '## disabled: ' + disabled);
        LogTracker.debugLogEnd('Plc_WorkOrderHnd', 'IsDisabled');
        return disabled;
    }

    public void beforeInsert(List<SObject> newItems){
        System.debug('Plc_WorkOrderHnd.BeforeInsert');
    }

    public void beforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){

        LogTracker.debugLogBegin('Plc_WorkOrderHnd', 'BeforeUpdate');
        //>>PClick Phase Manager integration - DO NOT REMOVE
        wrts_prcgvr.Interfaces_1_2.IPhaseManagerIntegration PhaseManagerIntegration
                = (wrts_prcgvr.Interfaces_1_2.IPhaseManagerIntegration)
                        wrts_prcgvr.VersionManager.newClassInstance('PhaseManagerIntegration');
        PhaseManagerIntegration.beforeUpdate(new Map<String, Object>{
            'oldObjects' => trigger.old,
            'newObjects' => trigger.new
        });
        //<<PClick Phase Manager integration - DO NOT REMOVE
        LogTracker.debugLogEnd('Plc_WorkOrderHnd', 'BeforeUpdate');
    }

    public void beforeDelete(Map<Id, SObject> oldItems){
        System.debug('Plc_WorkOrderHnd.BeforeDelete');
    }

    public void afterInsert(Map<Id, SObject> newItems){
        System.debug('Plc_WorkOrderHnd.AfterInsert');
    }

    public void afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){
        //move the "close" login that was in the ApexAction of the Phase Manager in this part
        LogTracker.debugLogBegin('Plc_WorkOrderHnd', 'AfterUpdate');
        List<WorkOrder> closingWOList = new List<WorkOrder>();
        List<WorkOrder> cancellingWOList = new List<WorkOrder>();
        for(WorkOrder newWO : (List<WorkOrder>)newItems.values()){
            WorkOrder oldWO = (WorkOrder)oldItems.get(newWO.Id);
            system.debug('=newItemss=='+newItems); system.debug('=oldItemss=='+oldItems); system.debug('=alreadyCo=='+Plc_WorkOrderApxAct.alreadyCalculated);
            if(Plc_WorkOrderApxAct.alreadyCalculated.contains(newWO.Id)){ continue; }

            if(newWO.Status != oldWO.Status
                    && newWO.Status == 'Closed'){
                Plc_WorkOrderApxAct.alreadyCalculated.add(newWO.Id);
                closingWOList.add(newWO);
            }else if(newWO.Status != oldWO.Status
                    && newWO.Status == 'Canceled'){
                Plc_WorkOrderApxAct.alreadyCalculated.add(newWO.Id);
                cancellingWOList.add(newWO);
            }
        }
        
        //FB 23-05-2019 - Handling low level exceptions [START]
        try {
            if (!closingWOList.isEmpty()) {
                Plc_WorkOrderApxAct.oncloseWorkOrder(closingWOList);
            }
            if (!cancellingWOList.isEmpty()) {
                Plc_WorkOrderApxAct.oncancelWorkOrder(cancellingWOList);
            }
        } catch (Exception e) {
           for (WorkOrder wo : (List<WorkOrder>)newItems.values()) { 
                wo.addError(e);
           }
        }
        //FB 23-05-2019 - Handling low level exceptions [END]

        LogTracker.debugLogEnd('Plc_WorkOrderHnd', 'AfterUpdate');
    }

    public void afterDelete(Map<Id, SObject> oldItems){
        System.debug('Plc_WorkOrderHnd.AfterDelete');
    }

    public void afterUndelete(Map<Id, SObject> oldItems){
        System.debug('Plc_WorkOrderHnd.AfterUndelete');
    }

}