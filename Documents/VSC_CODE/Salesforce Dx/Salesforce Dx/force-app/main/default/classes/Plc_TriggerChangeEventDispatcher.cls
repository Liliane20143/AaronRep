/**
 * TriggerChangeEventDispatcher - Trigger Change Event dispatcher class
 *
 * @author CE
 * @date Creation 25/09/2019
 * @description
 * @testedIn Plc_StockSerial2ChangeEventTest
 * @errorcode [ERR:CL-088YYZZ]
 * @source
 */
public with sharing class Plc_TriggerChangeEventDispatcher {
    public static void run(ITriggerChangeEventHandler handler){
        // Check to see if the trigger has been disabled. If it has, return
        if (handler.isDisabled()){
            return;
        }

        List<Id> newItemsCreate = new List<Id>();
        List<Id> newItemsUpdate = new List<Id>();
        List<Id> newItemsDelete = new List<Id>();
        List<Id> newItemsUndelete = new List<Id>();

        String entityName;

        for (SObject changeEventElement : Trigger.New) {
            EventBus.ChangeEventHeader header = (EventBus.ChangeEventHeader) changeEventElement.get('ChangeEventHeader');
            entityName = header.getEntityName();

            if(header.changeType == 'CREATE'){
                newItemsCreate.addAll(header.getRecordIds());
            }
            if(header.changeType == 'UPDATE'){
                newItemsUpdate.addAll(header.getRecordIds());
            }
            if(header.changeType == 'DELETE'){
                newItemsDelete.addAll(header.getRecordIds());
            }
            if(header.changeType == 'UNDELETE'){                
                newItemsUndelete.addAll(header.getRecordIds());
            }
        }

        
        Map<Id, SObject> itemsMap = new Map<Id, SObject>();

        if(newItemsCreate.size()>0){
            String query = 'SELECT '+Plc_Utils.getAllFieldsApiNameFromObject(entityName)+' FROM '+entityName+' WHERE Id IN: newItemsCreate';
            for(sObject objectRetrieved : Database.query(query) ){
                itemsMap.put(objectRetrieved.Id,objectRetrieved);
            }
            handler.afterInsert(itemsMap);
            itemsMap.clear();
        }
        if(newItemsUpdate.size()>0){
            String query = 'SELECT '+Plc_Utils.getAllFieldsApiNameFromObject(entityName)+' FROM '+entityName+' WHERE Id IN: newItemsUpdate';
            for(sObject objectRetrieved : Database.query(query) ){
                itemsMap.put(objectRetrieved.Id,objectRetrieved);
            }
            handler.afterUpdate(itemsMap);
            itemsMap.clear();
        }
        if(newItemsDelete.size()>0){
            for(Id id : newItemsDelete){
                itemsMap.put(id,new Bit2Shop__Stock_Serials2__c() );
            }
            handler.afterDelete(itemsMap);
            itemsMap.clear();
        }
        if(newItemsUndelete.size()>0){
            String query = 'SELECT '+Plc_Utils.getAllFieldsApiNameFromObject(entityName)+' FROM '+entityName+' WHERE Id IN: newItemsUndelete';
            for(sObject objectRetrieved : Database.query(query) ){
                itemsMap.put(objectRetrieved.Id,objectRetrieved);
            }
            handler.afterUndelete(itemsMap);
            itemsMap.clear();
        }
    }
}