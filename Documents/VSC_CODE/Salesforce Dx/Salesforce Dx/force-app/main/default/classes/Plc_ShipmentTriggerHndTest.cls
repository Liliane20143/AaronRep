/**
 * @author Mame Diarra
 * @date Creation 11/02/2019
 * @version 1.0
 * @description Test of Plc_ShipmentTriggerHnd.
 */
@isTest
public class Plc_ShipmentTriggerHndTest {
    /**
     * @author Mame Diarra
     * @date Creation 11/02/2019
     * @Modified 21/03/2019 by Mame Diarra
     * @version 1.0
     * @description Test of the method .
     */
    @isTest
    static void afterUpdateTest(){
        
        // Start test
        Test.startTest();
        Bit2Shop__Shipment__c shipment = new Bit2Shop__Shipment__c(Bit2Shop__Status__c='Closed',Bit2Shop__Shipment_Document_Number__c='3');
        insert shipment;
        
        shipment.Bit2Shop__Status__c='Pending';
		update shipment;
        Plc_ShipmentTriggerHnd shipmentTriggerHnd = new Plc_ShipmentTriggerHnd();
        Map<Id, SObject> newItems= new Map<Id, SObject>();
        Map<Id, SObject> oldItems= new Map<Id, SObject>();
        Database.delete(shipment.Id);
        Database.undelete(shipment.Id);
        // Stop test
        Test.stopTest();
    }    

}