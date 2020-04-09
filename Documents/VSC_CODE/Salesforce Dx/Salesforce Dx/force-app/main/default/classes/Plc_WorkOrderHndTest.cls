/**
 * WorkOrderHndTest - Test class for WorkOrderHnd
 *
 * @author EM
 * @date Creation 28/12/2018
 * @description
 */
@IsTest
private class Plc_WorkOrderHndTest {

    /**
     *
     * @author Moussa FOFANA
     * @date Creation 16/02/2019
     * @description Test Data
     */
    @testSetup static void setup(){
        Plc_TestFactory.initProcessClickPackage();
        
        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;        
         
        Contact contact = new Contact(FirstName='Test', LastName='Test');
        insert contact;

        WorkOrder workOrder = Plc_TestFactory.createWorkOrder('state', account, contact, 'abi',
                                          'bankDescription', 'legacyAccountId', 'legacyAccount',
                                          'siaCode', 'legacyServicePointId', 'servicePoint',
                                          'cti', 'customerCare', 'fCode');
        
        workOrder.Plc_Alias__c = '123456789';
        workOrder.Plc_FiscalCode__c='00032017';

        workOrder.RecordTypeId = Plc_Utils.getRecordTypeId('Installation', 'WorkOrder');
        insert workOrder;
    }

    /**
     * @author Moussa FOFANA
     * @date Creation 16/02/2019
     * @description Test IsDisable() method
     */
    @isTest static void isDisabledTrueTest(){
        
        Test.startTest();
                    
            TriggerSettings__c setting = TriggerSettings__c.getInstance();
            setting.WorkOrderTrigger__c = System.now().addDays(5);
            insert setting;
            
            Plc_WorkOrderHnd  workOrderHnd = new Plc_WorkOrderHnd();
            Boolean result = workOrderHnd.IsDisabled();
            
        Test.stopTest();
        System.assertEquals(result,true);
        
    }

    /**
     *
     * @author Moussa FOFANA
     * @date Creation 16/02/2019
     * @description Test AfterUpdate() method
     */
    @isTest static void afterUpdateTest(){

        WorkOrder oldW=[SELECT ID,Status,Plc_FiscalCode__c FROM WorkOrder];

        Plc_WorkOrderHnd workOrderHnd = new Plc_WorkOrderHnd();

        Map<Id,SObject> newItems=new Map<Id,SObject>();
        Map<Id,SObject> oldItems=new Map<Id,SObject>(); 

        WorkOrder newW=oldW.clone();  
        newW.Status='Closed';
        insert newW;

        newItems.put(newW.Id, newW);
        oldItems.put(newW.Id, oldW);

        System.debug('==new Wo map== '+newItems);
        System.debug('==old Wo map== '+oldItems);

        for(WorkOrder newWO : (List<WorkOrder>)newItems.values()){
            
            WorkOrder oldWO = (WorkOrder)oldItems.get(newWO.Id);
            System.debug('==old items values== '+oldItems.values());

            System.debug('==Oldwo get== '+oldItems.get(newWO.Id));
            System.debug('==newWo== '+newWO.Status);
            System.debug('==oldWO== '+oldWO.Status);

           /* if(Plc_WorkOrderApxAct.alreadyCalculated.contains(newWO.Id)) continue;

            if(newWO.Status != oldWO.Status
                    && newWO.Status == 'Closed'){
                Plc_WorkOrderApxAct.alreadyCalculated.add(newWO.Id);
            }else if(newWO.Status != oldWO.Status
                    && newWO.Status == 'Canceled'){
                Plc_WorkOrderApxAct.alreadyCalculated.add(newWO.Id);
            }
           */
        }

        System.debug('wolist '+(List<WorkOrder>)newItems.values());

        Test.startTest();
            workOrderHnd.AfterUpdate(newItems,oldItems);
            newW.Status='Canceled';
            //update newW;
            newItems.put(newW.Id, newW);
            Plc_WorkOrderApxAct.alreadyCalculated.clear();
            workOrderHnd.AfterUpdate(newItems,oldItems);
        Test.stopTest();

    }

     /**
     * @author Mame Diarra
     * @date Creation 22/02/2019
     * @description Test of BeforeUpdate method.
     */
     @isTest static void BeforeUpdateTest(){
        Map<Id, SObject> newItems= new Map<Id, SObject>();
        Map<Id, SObject> oldItems= new Map<Id, SObject>();
        Plc_WorkOrderHnd workOrderHnd = new Plc_WorkOrderHnd();
        Test.startTest();
        workOrderHnd.BeforeUpdate(newItems,oldItems);
        Test.stopTest();
     }    

     /**
     * @author Luca Belometti
     * @date Creation 05/04/2019
     * @description Test of beforeDelete method.
     */
     @isTest static void beforeDeleteTest(){
        Map<Id, SObject> oldItems= new Map<Id, SObject>();
        Plc_WorkOrderHnd workOrderHnd = new Plc_WorkOrderHnd();
        Test.startTest();
        workOrderHnd.beforeDelete(oldItems);
        Test.stopTest();
     }    

     /**
     * @author Luca Belometti
     * @date Creation 05/04/2019
     * @description Test of beforeDelete method.
     */
     @isTest static void afterDeleteTest(){
        Map<Id, SObject> oldItems= new Map<Id, SObject>();
        Plc_WorkOrderHnd workOrderHnd = new Plc_WorkOrderHnd();
        Test.startTest();
        workOrderHnd.afterDelete(oldItems);
        Test.stopTest();
     }

    /**
     * @author Luca Belometti
     * @date Creation 05/04/2019
     * @description Test of afterUndelete method.
     */
     @isTest static void afterUndeleteTest(){
        Map<Id, SObject> oldItems= new Map<Id, SObject>();
        Plc_WorkOrderHnd workOrderHnd = new Plc_WorkOrderHnd();
        Test.startTest();
        workOrderHnd.afterUndelete(oldItems);
        Test.stopTest();
     }


}