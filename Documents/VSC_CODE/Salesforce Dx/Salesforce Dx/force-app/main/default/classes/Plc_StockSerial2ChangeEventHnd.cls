/**
 * Plc_StockSerials2Hnd - Stock Serial 2 Trigger Handler
 *
 * @author CE
 * @date Creation 29/09/2019
 * @description 
 * @testedIn Plc_StockSerial2ChangeEventTest
* @errorcode [ERR:CL-08AYYZZ]
 *
 */

public with sharing class Plc_StockSerial2ChangeEventHnd implements ITriggerChangeEventHandler {
    public Boolean isDisabled(){
        TriggerSettings__c setting = TriggerSettings__c.getInstance();
        return setting.StockSerial2ChangeEventTrigger__c!= null
                && setting.StockSerial2ChangeEventTrigger__c > System.now();
         
    }

    public void afterInsert(Map<Id, SObject> newItemsMap){
        
        Plc_StockSerial2HistoryManager.manageInsertOperation(newItemsMap);
    }

    public void afterUpdate(Map<Id, SObject> newItemsMap){
        
        Plc_StockSerial2HistoryManager.manageUpdateOperation(newItemsMap);
    }

    public void afterDelete(Map<Id, SObject> newItemsMap){
        
    }

    public void afterUndelete(Map<Id, SObject> newItemsMap){
        
    }

}