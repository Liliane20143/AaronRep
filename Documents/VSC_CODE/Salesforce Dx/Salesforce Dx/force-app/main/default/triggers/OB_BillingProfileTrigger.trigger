trigger OB_BillingProfileTrigger on NE__Billing_Profile__c (before insert, before update) {
	
    //	micol.ferrari 04/11/2019 - DISABLE TRIGGER FROM CUSTOM SETTING - START
    Boolean triggerDisabled = false;
    if (!Test.isRunningTest())
    {
        OB_TriggerSupport__c triggerSupport = OB_TriggerSupport__c.getInstance(Label.OB_DISABLETRIGGERS); 
        triggerDisabled = triggerSupport.OB_DisableAll__c || triggerSupport.OB_DisableBillingProfileTrigger__c;
    }
    if (!triggerDisabled)
    {
        if (Trigger.isInsert) {
            if (Trigger.isBefore) {
                //for(NE__Billing_Profile__c billProf : Trigger.New){
                    OB_BillingProfileTriggerHandler triggerHandler = new OB_BillingProfileTriggerHandler();
                    //Insertion failed on BillingProfile.OB_IBAN__c (CAB, CID, )
                    triggerHandler.checkValidityOnIban(Trigger.New, Trigger.Old);
                    //Insertion failed on Account.Name
                    triggerHandler.testHeaderInternational(Trigger.New, Trigger.Old);
                //}
            }
        } else if (Trigger.isUpdate) {
            if (Trigger.isBefore) 		{
                //for(NE__Billing_Profile__c billProf : Trigger.New){
                    OB_BillingProfileTriggerHandler triggerHandler = new OB_BillingProfileTriggerHandler();
                    //Insertion failed on Account.Name
                    triggerHandler.checkValidityOnIban(Trigger.New, Trigger.Old);
                    triggerHandler.testHeaderInternational(Trigger.New, Trigger.Old);
                //}
            }
        }
    } 
    //	micol.ferrari 04/11/2019 - DISABLE TRIGGER FROM CUSTOM SETTING - STOP
}