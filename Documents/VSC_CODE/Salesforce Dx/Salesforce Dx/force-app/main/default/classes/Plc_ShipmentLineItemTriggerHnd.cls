/**
* @author Plc_ShipmentLineItemTriggerHnd Fabio Di Lorenzo
* @date Creation 08/01/2019
* @errorcode [ERR:CL-043YYZZ]
* 
* @description Plc_ShipmentLineItemTriggerHnd - Apex handler for trigger Plc_ShipmentLineItemTrigger
*/
public with sharing class Plc_ShipmentLineItemTriggerHnd implements ITriggerHandler{
    public static String TMP = '';
	public static Boolean disableTemporary = false;
    /**
     * @author Fabio Di Lorenzo
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
        return setting.ShipmentLineItemTrigger__c != null
                && setting.ShipmentLineItemTrigger__c > System.now();
    }

    public void BeforeInsert(List<SObject> newItems){
        System.debug('## Plc_ShipmentLineItemTriggerHnd.BeforeInsert');
    }

    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){
        System.debug('## Plc_ShipmentLineItemTriggerHnd.BeforeUpdate');
    }

    public void BeforeDelete(Map<Id, SObject> oldItems){
        System.debug('## Plc_ShipmentLineItemTriggerHnd.BeforeDelete');
    }

    public void AfterInsert(Map<Id, SObject> newItems){

        System.debug('## Plc_ShipmentLineItemTriggerHnd.AfterInsert');

    }

    /**
     * Used to handle after update mode
     * 
     * @code 01
     * 
     * @param newItems Map of new items
     * @param oldItems Map of old items
     */
    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        List<ID> shipmentIdsForActions = new List<ID>();
        List<ID> inboundShipmentIds = new List<ID>();
        //looks for shipment status change to trigger its actions
        for (Bit2Shop__Shipment_Line_Item__c newItem : (List<Bit2Shop__Shipment_Line_Item__c>) newItems.values()) {
            Bit2Shop__Shipment_Line_Item__c oldItem = (Bit2Shop__Shipment_Line_Item__c) oldItems.get(newItem.Id);
			
            System.debug('#### Contains: '+Plc_StockActionsHnd.alreadyCalculated.contains(newItem.Id));
            System.debug('#### newItem.Id: '+newItem.Id);
            System.debug('#### Plc_StockActionsHnd.alreadyCalculated: '+Plc_StockActionsHnd.alreadyCalculated);
            System.debug('#### newItem.Bit2Shop__Status__c: '+newItem.Bit2Shop__Status__c);
            System.debug('#### oldItem.Bit2Shop__Status__c: '+oldItem.Bit2Shop__Status__c);
            System.debug('#### newItem.Bit2Shop__Received_Status__c: '+newItem.Bit2Shop__Received_Status__c);
            System.debug('#### oldItem.Bit2Shop__Received_Status__c: '+oldItem.Bit2Shop__Received_Status__c);
				
            if (newItem.Bit2Shop__Status__c != oldItem.Bit2Shop__Status__c
                    || newItem.Bit2Shop__Received_Status__c != oldItem.Bit2Shop__Received_Status__c) {

                if(Plc_StockActionsHnd.alreadyCalculated.contains(newItem.Id+'_'
                        +newItem.Bit2Shop__Status__c+'_'
                        + newItem.Bit2Shop__Received_Status__c)){ continue; }

                if(newItem.Plc_ShipmentType__c == Plc_WorkOrderApxAct.SHIPMENT_SUBTYPE_INBOUND
                        && newItem.Bit2Shop__Status__c == Plc_WorkOrderApxAct.SHIPMENT_STATUS_CLOSED
                        && newItem.Bit2Shop__Received_Status__c != null)
                {
                    inboundShipmentIds.add(newItem.Id);
                }
                shipmentIdsForActions.add(newItem.Id);
                Plc_StockActionsHnd.alreadyCalculated.add(newItem.Id+'_'
                        +newItem.Bit2Shop__Status__c+'_'
                        + newItem.Bit2Shop__Received_Status__c);
            }
        }

        System.debug('### inboundShipmentIds: '+inboundShipmentIds);
        //updates the status of the outbound shipment line items to be "closed/received" if the inbound has been closed/received
        //To avoid retriggering of the ShipmentLineItemTriggerHnd, the trigger of the update on the outbound shipment line items is blocked 
        //temporary by "Plc_ShipmentLineItemTriggerHnd.disableTemporary = true;"
        if(!inboundShipmentIds.isEmpty()){
            Plc_ShipmentLineItemTriggerHnd.disableTemporary = true;
            List<Bit2Shop__Shipment_Line_Item__c> outboundIdSet = Plc_StockActionsHnd.moveOutboundShipments(inboundShipmentIds);
            Plc_ShipmentLineItemTriggerHnd.disableTemporary = false;
            System.debug('### outboundIdSet: '+outboundIdSet);
            if(outboundIdSet != null && !outboundIdSet.isEmpty()){
                for(Bit2Shop__Shipment_Line_Item__c outShipmentItems : outboundIdSet){
                	shipmentIdsForActions.add(outShipmentItems.Id);
                	Plc_StockActionsHnd.alreadyCalculated.add(outShipmentItems.Id
                            +'_'+outShipmentItems.Bit2Shop__Status__c
                            +'_'+outShipmentItems.Bit2Shop__Received_Status__c);
                }
            }
        }

        if(!shipmentIdsForActions.isEmpty()) {
            Plc_StockActionsHnd.executeActions(null, shipmentIdsForActions);
        }

        /*if(UserInfo.getUserId() == '0051j000000lNxVAAU' && Plc_StockActionsHnd.alreadyCalculated.size() > 3) {
            system.assert(false, 'TEST: '+Plc_ShipmentLineItemTriggerHnd.TMP+ ' \n\n'+Plc_StockActionsHnd.alreadyCalculated);
        }*/
        
        //When all the SLI Serial are closed, the SLI Product "parent" is closed too.
        //When ale the SLI Product are closed, the Shipment Parent is closed too.
        
        //Chek if all shipment line item of a Shipment are closed and closes the shipment (SLI = Shipment Line Item)
        Map<Id, Boolean> shipmentsLineItemProductMap = new Map<Id, Boolean>();
        list<Bit2Shop__Shipment_Line_Item__c> shipmentsLineItemSerial;
        Map<Id, Boolean> shipmentsMap = new Map<Id, Boolean>();
        list<Bit2Shop__Shipment_Line_Item__c> shipmentsLineItemProduct;

        //Get SLI Product of the SLI Serial which are closed 
        for (Bit2Shop__Shipment_Line_Item__c newItem : (List<Bit2Shop__Shipment_Line_Item__c>) newItems.values()) {
            Bit2Shop__Shipment_Line_Item__c oldItem = (Bit2Shop__Shipment_Line_Item__c) oldItems.get(newItem.Id);
            if (newItem.Bit2Shop__Type__c=='Serial' && newItem.Plc_ShipmentType__c=='Inbound' &&  newItem.Bit2Shop__Status__c!= oldItem.Bit2Shop__Status__c && newItem.Bit2Shop__Status__c=='Closed') {
                shipmentsLineItemProductMap.put(newItem.Bit2Shop__Target_Line_Item__c, true);
            }
            if (newItem.Bit2Shop__Type__c=='Product' && newItem.Plc_ShipmentType__c=='Inbound' &&  newItem.Bit2Shop__Status__c!= oldItem.Bit2Shop__Status__c && newItem.Bit2Shop__Status__c=='Closed') {
                shipmentsMap.put(newItem.Bit2Shop__Shipment_Id__c, true);
            }
        }
        System.debug('shipmentsLineItemProductMap #1: '+ shipmentsLineItemProductMap);
        //Get all the SLI Serial related to the SLI Product retrived before and check them false if the status is not 'Closed'
        if(!shipmentsLineItemProductMap.isEmpty()){
            shipmentsLineItemSerial = [SELECT id, Bit2Shop__Status__c, Bit2Shop__Target_Line_Item__c FROM Bit2Shop__Shipment_Line_Item__c WHERE Bit2Shop__Target_Line_Item__c in : shipmentsLineItemProductMap.keySet() AND Bit2Shop__Type__c='Serial'];
            System.debug('shipmentsLineItemSerial: '+ shipmentsLineItemSerial);
            for(Id parentId : shipmentsLineItemProductMap.keySet()) {
                for(Bit2Shop__Shipment_Line_Item__c serial : shipmentsLineItemSerial) {
                    if(serial.Bit2Shop__Target_Line_Item__c == parentId) {
                        if(serial.Bit2Shop__Status__c == 'Pending') {
                            System.debug('ShipmentLineItemProduct'+ parentId);
                            shipmentsLineItemProductMap.put(parentId, false);
                        }
                    }
                }
            }
        }
        System.debug('shipmentsLineItemProductMap #2: '+ shipmentsLineItemProductMap);
        //Update all the SLI Product to 'Closed' if all the SLI Serial are closed
        List<Bit2Shop__Shipment_Line_Item__c> toUpdate = new List<Bit2Shop__Shipment_Line_Item__c>();
        for(Id parent : shipmentsLineItemProductMap.keySet()) {
            if(shipmentsLineItemProductMap.get(parent) == true) {
                System.debug('Parent: '+ parent + ', Value: ' + shipmentsLineItemProductMap.get(parent));
                Bit2Shop__Shipment_Line_Item__c newParent = new Bit2Shop__Shipment_Line_Item__c();
                newParent.Id = parent;
                newParent.Bit2Shop__Status__c = 'Closed';
                toUpdate.add(newParent);
            }
        }
        System.debug('toUpdate: '+ toUpdate);

        if(!toUpdate.isEmpty()) {
            try{
                List<String> fieldsToCheck = new List<String>{'Bit2Shop__Status__c'};
                String resultFound = Plc_Utils.checkCrudFieldPermission('Bit2Shop__Shipment_Line_Item__c', fieldsToCheck, 'update');
                if(resultFound != null){
                    System.debug('Exception checkCrudFieldPermission');
                    throw new Plc_Exception(resultFound);
                }
                update toUpdate;
            } catch(Exception e) {
                String errorMessage = '[EXCEPTION] - ShipmentLineItemTrigger on AfterUpdate >> Error in : ' + e.getMessage() + ' at line: ' + e.getLineNumber() + ' stack trace: ' + e.getStackTraceString();
                System.debug(errorMessage);
                throw new Plc_Exception('[ERR:CL-040101] ' + e.getMessage() + ' ' + e.getStackTraceString());
            }
        }

        if(!shipmentsMap.isEmpty()){
            shipmentsLineItemProduct = [SELECT id, Bit2Shop__Status__c, Bit2Shop__Target_Line_Item__c FROM Bit2Shop__Shipment_Line_Item__c WHERE Bit2Shop__Target_Line_Item__c in : shipmentsMap.keySet() AND Bit2Shop__Type__c='Product'];
            System.debug('shipmentsLineItemProduct: '+ shipmentsLineItemProduct);
            for(Id parentId : shipmentsMap.keySet()) {
                for(Bit2Shop__Shipment_Line_Item__c product : shipmentsLineItemProduct) {
                    if(product.Bit2Shop__Target_Line_Item__c == parentId) {
                        if(product.Bit2Shop__Status__c == 'Pending') {
                            System.debug('ShipmentLineItemProduct'+ parentId);
                            shipmentsMap.put(parentId, false);
                        }
                    }
                }
            }
        }
        System.debug('shipmentsMap #2: '+ shipmentsMap);
        //Update all the SLI Product to 'Closed' if all the SLI Serial are closed
        List<Bit2Shop__Shipment__c> shipmentToUpdate = new List<Bit2Shop__Shipment__c>();
        for(Id parent : shipmentsMap.keySet()) {
            if(shipmentsMap.get(parent) == true) {
                System.debug('Parent: '+ parent + ', Value: ' + shipmentsMap.get(parent));
                Bit2Shop__Shipment__c newParent = new Bit2Shop__Shipment__c();
                newParent.Id = parent;
                newParent.Bit2Shop__Status__c = 'Closed';
                shipmentToUpdate.add(newParent);
            }
        }
        System.debug('shipmentToUpdate: '+ shipmentToUpdate);

        if(!shipmentToUpdate.isEmpty()) {
            try{
                List<String> fieldsToCheck = new List<String>{'Bit2Shop__Status__c'};
                String resultFound = Plc_Utils.checkCrudFieldPermission('Bit2Shop__Shipment__c', fieldsToCheck, 'update');
                if(resultFound != null){
                    System.debug('Exception checkCrudFieldPermission');
                    throw new Plc_Exception(resultFound);
                }
                update shipmentToUpdate;
            } catch (exception e) {
                String errorMessage = '[EXCEPTION] - ShipmentLineItemTrigger on AfterUpdate >> Error in : ' + e.getMessage() + ' at line: ' + e.getLineNumber() + ' stack trace: ' + e.getStackTraceString();
                System.debug(errorMessage);
                throw new Plc_Exception('[ERR:CL-040102] ' + e.getMessage() + ' ' + e.getStackTraceString());
            }
        }
    }
    
    public void AfterDelete(Map<Id, SObject> oldItems){
        System.debug('## Plc_ShipmentLineItemTriggerHnd.AfterDelete');
    }

    public void AfterUndelete(Map<Id, SObject> oldItems){
        System.debug('## Plc_ShipmentLineItemTriggerHnd.AfterUndelete');
    }

}