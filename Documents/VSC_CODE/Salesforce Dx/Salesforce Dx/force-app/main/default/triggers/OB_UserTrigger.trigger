trigger OB_UserTrigger on User (after insert, after update) {
    
	//	micol.ferrari 04/11/2019 - DISABLE TRIGGER FROM CUSTOM SETTING - START
    Boolean triggerDisabled = false;
    if (!Test.isRunningTest())
    {
        OB_TriggerSupport__c triggerSupport = OB_TriggerSupport__c.getInstance(Label.OB_DISABLETRIGGERS); 
        triggerDisabled = triggerSupport.OB_DisableAll__c || triggerSupport.OB_DisableUserTrigger__c;
    }
    if (!triggerDisabled)
    {
        if ( Trigger.isAfter) {
            if(Trigger.isInsert || Trigger.isUpdate){
                OB_UserTriggerHandler.addQueueToUser(Trigger.oldMap , Trigger.newMap , Trigger.isUpdate);
                OB_UserTriggerHandler.userApprovalProcess(Trigger.oldMap , Trigger.newMap,Trigger.isInsert );//Simone Misani  19/06/2019 user approval process
            }
    
        }
	}        
    //	micol.ferrari 04/11/2019 - DISABLE TRIGGER FROM CUSTOM SETTING - STOP   
}