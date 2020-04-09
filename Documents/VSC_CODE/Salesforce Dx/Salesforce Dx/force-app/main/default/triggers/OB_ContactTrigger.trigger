trigger OB_ContactTrigger on Contact (before insert, before update, after insert , after update) {
	
    //	micol.ferrari 04/11/2019 - DISABLE TRIGGER FROM CUSTOM SETTING - START
    Boolean triggerDisabled = false;
    if (!Test.isRunningTest())
    {
        OB_TriggerSupport__c triggerSupport = OB_TriggerSupport__c.getInstance(Label.OB_DISABLETRIGGERS); 
        triggerDisabled = triggerSupport.OB_DisableAll__c || triggerSupport.OB_DisableContactTrigger__c;
    }
    if (!triggerDisabled)
    {
        if (Trigger.isInsert) {
            if (Trigger.isBefore) {
                OB_ContactTriggerHandler triggerHandler = new OB_ContactTriggerHandler();
                triggerHandler.testFiscalCode(Trigger.New, Trigger.Old);
                triggerHandler.testCoerencyDocumentNumber(Trigger.New, Trigger.Old);
                triggerHandler.testCoerencyDocumentExpirationDate(Trigger.New, Trigger.Old);
                //giovanni.spinelli <spinelli.giovanni@accenture.com> - start - method to make uppercase contact fields
                triggerHandler.uppercaseFieldsConversion(Trigger.new , Trigger.old , 'isInsert' );
                //giovanni.spinelli <spinelli.giovanni@accenture.com> - end - method to make uppercase contact fields
                
            }
            //Start antonio.vatrano 03/06/2019 share contacts when Operation CREATE Contacts r1f2-183
            else if(Trigger.isAfter){
                OB_ContactTriggerHandler triggerHandler = new OB_ContactTriggerHandler();
                triggerHandler.shareContact(Trigger.New, Trigger.Old);
                
            } 
            //End antonio.vatrano 03/06/2019 share contacts when Operation CREATE Contacts r1f2-183
        } 
        else if (Trigger.isUpdate) { 
            if (Trigger.isBefore) 		{
                OB_ContactTriggerHandler triggerHandler = new OB_ContactTriggerHandler();
                triggerHandler.testFiscalCode(Trigger.New, Trigger.Old);
                triggerHandler.testCoerencyDocumentNumber(Trigger.New, Trigger.Old);
                triggerHandler.testCoerencyDocumentExpirationDate(Trigger.New, Trigger.Old);
                //giovanni.spinelli <spinelli.giovanni@accenture.com> - start - method to make uppercase contact fields
                triggerHandler.uppercaseFieldsConversion(Trigger.new , Trigger.old , 'isUpdate');
                //giovanni.spinelli <spinelli.giovanni@accenture.com> - end - method to make uppercase contact fields
            }
        }
    }        
    //	micol.ferrari 04/11/2019 - DISABLE TRIGGER FROM CUSTOM SETTING - STOP
}