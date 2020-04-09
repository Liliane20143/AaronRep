trigger OB_ExternalSourceMappingTrigger on ExternalSourceMapping__c (after update , before update) {
	
    //	micol.ferrari 04/11/2019 - DISABLE TRIGGER FROM CUSTOM SETTING - START
    Boolean triggerDisabled = false;
    if (!Test.isRunningTest())
    {
        OB_TriggerSupport__c triggerSupport = OB_TriggerSupport__c.getInstance(Label.OB_DISABLETRIGGERS); 
        triggerDisabled = triggerSupport.OB_DisableAll__c || triggerSupport.OB_DisableExternalSourceMappingTrigger__c;
    }
    if (!triggerDisabled)
    {
        System.debug('INTO TRIGGER');
        
        if ( Trigger.isUpdate ) {
            if(Trigger.isAfter){
                System.debug('INTO IF TRIGGER');
                OB_ExternalSourceMappingTriggerHandler.updateMerchant(Trigger.oldMap , Trigger.newMap );
            }
            if(Trigger.isBefore){
                OB_ExternalSourceMappingTriggerHandler.modifyDescription(Trigger.oldMap , Trigger.newMap );
            }
        }
    }        
    //	micol.ferrari 04/11/2019 - DISABLE TRIGGER FROM CUSTOM SETTING - STOP
}