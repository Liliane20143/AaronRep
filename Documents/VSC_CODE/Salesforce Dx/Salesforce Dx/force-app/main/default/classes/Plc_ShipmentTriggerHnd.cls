/**
* @author Plc_ShipmentTriggerHnd Omar Mejdi
* @date Creation 08/01/2019
* @description Plc_ShipmentTriggerHnd - Apex handler for trigger Plc_ShipmentTrigger
*/
public with sharing class Plc_ShipmentTriggerHnd implements ITriggerHandler{

    public static Boolean disableTemporary = false;

    /**
     * @author Omar Mejdi
     * @date 08/01/2019
     * @description Retrieve changed and inserted records
     *
     * @param oldRecords    List of the old versions of the sObject records
     * @param oldRecordsMap Map of the old versions of the sObject records
     * @param newRecords    List of the new versions of the sObject records
     * @param newRecordsMap Map of the new versions of the sObject records
     */

    public Boolean IsDisabled(){
        if(disableTemporary == true){ return true; }
        TriggerSettings__c setting = TriggerSettings__c.getInstance();
        return setting.ShipmentTrigger__c != null
            && setting.ShipmentTrigger__c > System.now();
    }

    public void BeforeInsert(List<SObject> newItems){

    }

    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){

    }

    public void BeforeDelete(Map<Id, SObject> oldItems){

    }

    public void AfterInsert(Map<Id, SObject> newItems){

    }

    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
         //Chek if all shipment of a Stock Order are closed and closes the Stock Order 
        Map<Id, Boolean> stockOrderMap = new Map<Id, Boolean>();
        list<Id> stockOrderClosedResidual= new list<id>();
        list<Bit2Shop__Shipment__c> shipments;
        //Get Shipment of the Stock Order which are closed and inbound 
       for (Bit2Shop__Shipment__c newItem : (List<Bit2Shop__Shipment__c>) newItems.values()) {
            Bit2Shop__Shipment__c oldItem = (Bit2Shop__Shipment__c) oldItems.get(newItem.Id);
            if (newItem.Bit2Shop__Sub_Type__c=='Inbound' && newItem.Bit2Shop__Status__c=='Closed') {
                stockOrderMap.put(newItem.Bit2Shop__Stock_Order_Id__c, false);
            }
        }
        System.debug('stockOrderMap #1: '+ stockOrderMap);
        //Get all the Shipment related to the Stock Order retrived before and check them true if the status is 'Closed'
        if(!stockOrderMap.isEmpty()){
            shipments = [SELECT id, Bit2Shop__Status__c, Bit2Shop__Stock_Order_Id__c,Bit2Shop__Unreceived_qty__c FROM Bit2Shop__Shipment__c WHERE Bit2Shop__Stock_Order_Id__c in : stockOrderMap.keySet() AND Bit2Shop__Sub_Type__c='Inbound'];
            System.debug('shipments: '+ shipments);
            for(Id parentId : stockOrderMap.keySet()) {
                for(Bit2Shop__Shipment__c ship : shipments) {
                    if(ship.Bit2Shop__Stock_Order_Id__c == parentId) {
                        if(ship.Bit2Shop__Status__c == 'Pending') {
                            System.debug('Shipment'+ parentId);
                            stockOrderMap.put(parentId, true);
                        }
                    }
                    
                }
            }
        }
        System.debug('stockOrderClosedResidual'+ stockOrderClosedResidual);
        System.debug('stockOrderMap #2: '+ stockOrderMap);
        //Update all the Stock Order to 'Closed' if all the related Shimpment are closed
        List<Bit2Shop__StockOrder__c> toUpdate = new List<Bit2Shop__StockOrder__c>();
        for(Id parent : stockOrderMap.keySet()) {
            if(stockOrderMap.get(parent) == false) {
                Bit2Shop__StockOrder__c newParent;
                //if one of the Shipment have unrecived qty the Stock Order is closed with residual line
                for(Bit2Shop__Shipment__c ship : shipments){
                    if(ship.Bit2Shop__Stock_Order_Id__c == parent){
                        newParent = new Bit2Shop__StockOrder__c();
                        newParent.Id = parent;
                        if(ship.Bit2Shop__Unreceived_qty__c > 0){
                            newParent.Bit2Shop__Status__c = 'Closed with residual lines';
                        }else{
                            newParent.Bit2Shop__Status__c = 'Closed';
                        }
                    }
            }
                toUpdate.add(newParent);
            }
        }
        System.debug('toUpdate: '+ toUpdate);
        
        if(!toUpdate.isEmpty()) {
            try{
                List<String> fieldsToCheck = new list<String>{'Bit2Shop__Status__c'};
                String resultFound = Plc_Utils.checkCrudFieldPermission('Bit2Shop__StockOrder__c', fieldsToCheck, 'update');
                if(resultFound != null){
                    System.debug('Exception checkCrudFieldPermission');
                    throw new Plc_Exception(resultFound);
				}
                update toUpdate;
            }catch(exception error){
                String errorMessage = '[EXCEPTION] - ShipmentTrigger on AfterUpdate >> Error in : ' + error.getMessage() + ' at line: ' + error.getLineNumber() + ' stack trace: ' + error.getStackTraceString();
                System.debug(errorMessage);
            }
            
        }

    }

    public void AfterDelete(Map<Id, SObject> oldItems){

    }

    public void AfterUndelete(Map<Id, SObject> oldItems){

    }

}