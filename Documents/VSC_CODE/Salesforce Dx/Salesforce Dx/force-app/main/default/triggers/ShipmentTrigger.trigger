/**
* @author ShipmentTrigger Omar Mejdi
* @date Creation 08/01/2019
* @description Plc_ShipmentTriggerHnd - trigger
* @uses  Plc_ShipmentTriggerHnd
*/

trigger ShipmentTrigger on Bit2Shop__Shipment__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
  Plc_TriggerDispatcher.Run(new Plc_ShipmentTriggerHnd());
}