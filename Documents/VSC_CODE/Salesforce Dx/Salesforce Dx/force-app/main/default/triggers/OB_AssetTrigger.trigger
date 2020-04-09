//	START 	micol.ferrari	27/11/2018
trigger OB_AssetTrigger on Asset (after update) 
{
	//	micol.ferrari 04/11/2019 - DISABLE TRIGGER FROM CUSTOM SETTING - START
    Boolean triggerDisabled = false;
    if (!Test.isRunningTest())
    {
        OB_TriggerSupport__c triggerSupport = OB_TriggerSupport__c.getInstance(Label.OB_DISABLETRIGGERS); 
        triggerDisabled = triggerSupport.OB_DisableAll__c || triggerSupport.OB_DisableAssetTrigger__c;
    }
    else 
    {
        triggerDisabled = false;
    }
    if (!triggerDisabled)
    {
        if (Trigger.isAfter && Trigger.isUpdate) 
        {
            OB_AssetTriggerHandler.merchantLifeCycle(Trigger.Newmap,Trigger.Oldmap);
        }
    }
    //	micol.ferrari 04/11/2019 - DISABLE TRIGGER FROM CUSTOM SETTING - STOP
}