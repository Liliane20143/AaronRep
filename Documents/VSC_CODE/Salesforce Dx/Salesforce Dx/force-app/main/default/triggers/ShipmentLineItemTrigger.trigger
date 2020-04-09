/**
* @author ShipmentLineItemTrigger Fabio Di Lorenzo
* @date Creation 08/01/2019
* @description Plc_ShipmentLineItemTriggerHnd - trigger
*  @uses  Plc_ShipmentLineItemTriggerHnd
*/

trigger ShipmentLineItemTrigger on Bit2Shop__Shipment_Line_Item__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    Plc_TriggerDispatcher.Run(new Plc_ShipmentLineItemTriggerHnd());
    /*switch on Trigger.operationType {

        when AFTER_UPDATE {
            Plc_TriggerDispatcher.Run(new Plc_ShipmentLineItemTriggerHnd());
            //Plc_ShipmentLineItemTriggerHnd.handleTrigger(Trigger.old, Trigger.oldMap, Trigger.new, Trigger.newMap);
        }
    }*/
}