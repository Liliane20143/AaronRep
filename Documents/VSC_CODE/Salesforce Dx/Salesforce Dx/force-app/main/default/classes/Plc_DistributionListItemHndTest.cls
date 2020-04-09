/**
 * @author Mame Diarra
 * @date Creation 01/02/2019
 * @version 1.0
 * @description Test of Plc DistributionListItemHnd.
 * @Last modified on 02 February 2019 By Moussa Fofafa
 */
@isTest
public class Plc_DistributionListItemHndTest {
    
    @testSetup
    static void setup(){	
        Datetime dt = DateTime.newInstanceGMT(System.now().year(),System.now().month()+1,System.now().day(), System.now().hour(),System.now().minute(),System.now().second());
        TriggerSettings__c setting =new TriggerSettings__c();
        setting.DistributionListItemTrigger__c=dt.addDays(10);
        insert setting;
    }
    
    /**
    * @author Mame Diarra
    * @date Creation 01/02/2019
    * @version 1.0
    * @description Test of the method IsDisabled.
    */
	@isTest
    static void getIsDisabledTest(){
        Plc_DistributionListItemHnd plcDistListItemHnd= new Plc_DistributionListItemHnd();
       // Start test
       Test.startTest();
       Boolean result = plcDistListItemHnd.IsDisabled();
       // Stop test
       Test.stopTest();
     
    }
    
    /**
    * @author Mame Diarra
    * @date Creation 01/02/2019
    * @version 1.0
    * @description Test of the method AfterDelete.
    */
	@isTest
    static void getAfterDeleteTest(){
        Plc_DistributionListItemHnd plcDistListItemHnd= new Plc_DistributionListItemHnd();
        Map<Id, SObject> oldItems= new Map<Id, SObject>();
       // Start test
       Test.startTest();
       plcDistListItemHnd.AfterDelete(oldItems);
       // Stop test
       Test.stopTest();
    }
    
    /**
    * @author Mame Diarra
    * @date Creation 01/02/2019
    * @version 1.0
    * @description Test of the method AfterUndelete.
    */
	@isTest
    static void getAfterUndeleteTest(){
        Plc_DistributionListItemHnd plcDistListItemHnd= new Plc_DistributionListItemHnd();
        Map<Id, SObject> oldItems= new Map<Id, SObject>();
       // Start test
       Test.startTest();
       plcDistListItemHnd.AfterUndelete(oldItems);
       // Stop test
       Test.stopTest();
     
    }
    
    /**
    * @author Mame Diarra
    * @date Creation 01/02/2019
    * @version 1.0
    * @description Test of the method BeforeInsert.
    */
	@isTest
    static void getBeforeInsertTest(){
       Plc_DistributionListItemHnd plcDistListItemHnd= new Plc_DistributionListItemHnd();
       List<SObject> oldItems= new List<SObject>();
       // Start test
       Test.startTest();
       plcDistListItemHnd.BeforeInsert(oldItems);
       // Stop test
       Test.stopTest();
     
    }
    
    /**
    * @author Mame Diarra
    * @date Creation 01/02/2019
    * @version 1.0
    * @description Test of the method BeforeUpdate.
    */
	@isTest
    static void getBeforeUpdateTest(){
       Plc_DistributionListItemHnd plcDistListItemHnd= new Plc_DistributionListItemHnd();
       Map<Id, SObject> newItems = new Map<Id, SObject>();
       Map<Id, SObject> oldItems = new Map<Id, SObject>();
       // Start test
       Test.startTest();
       plcDistListItemHnd.BeforeUpdate(newItems,oldItems);
       // Stop test
       Test.stopTest();
     
    }
    
    /**
    * @author Mame Diarra
    * @date Creation 01/02/2019
    * @version 1.0
    * @description Test of the method BeforeDelete.
    */
	@isTest
    static void getBeforeDeleteTest(){
       Plc_DistributionListItemHnd plcDistListItemHnd= new Plc_DistributionListItemHnd();
       Map<Id, SObject> oldItems = new Map<Id, SObject>();
       // Start test
       Test.startTest();
       plcDistListItemHnd.BeforeDelete(oldItems);
       // Stop test
       Test.stopTest();
    }
    
    /**
    * @author Mame Diarra
    * @date Creation 01/02/2019
    * @version 1.0
    * @description Test of the method AfterInsert.
    */
	@isTest
    static void getAfterInsertTest(){
       Plc_DistributionListItemHnd plcDistListItemHnd= new Plc_DistributionListItemHnd();
       Map<Id, SObject> newItems = new Map<Id, SObject>();
       // Start test
       Test.startTest();
       plcDistListItemHnd.AfterInsert(newItems);
       // Stop test
       Test.stopTest();
    }
    
    /**
    * @author Mame Diarra
    * @date Creation 01/02/2019
    * @version 1.0
    * @description Test of the method AfterUpdate.
    */
	@isTest
    static void getAfterUpdateTest(){
       Plc_DistributionListItemHnd plcDistListItemHnd= new Plc_DistributionListItemHnd();
       Map<Id, SObject> newItems = new Map<Id, SObject>();
       Map<Id, SObject> oldItems = new Map<Id, SObject>();
       // Start test
       Test.startTest();
       plcDistListItemHnd.AfterUpdate(newItems,oldItems);
       // Stop test
       Test.stopTest();
    }
    
}