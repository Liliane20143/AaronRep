/*
Andrea Morittu:
Trigger Based On Account
*/
trigger OB_AccountTrigger on Account (before insert, before update, after update) {
    
    //  micol.ferrari 04/11/2019 - DISABLE TRIGGER FROM CUSTOM SETTING - START
    Boolean triggerDisabled = false;
    if (!Test.isRunningTest())
    {
        OB_TriggerSupport__c triggerSupport = OB_TriggerSupport__c.getValues(System.Label.OB_DISABLETRIGGERS);
        triggerDisabled = triggerSupport.OB_DisableAll__c || triggerSupport.OB_DisableAccountTrigger__c;
    }
    if (!triggerDisabled)
    {
        if (Trigger.isInsert) {
            if (Trigger.isBefore) {
                OB_AccountTriggerHandler triggerHandler = new OB_AccountTriggerHandler();
                //Insertion failed on Account.Name
                triggerHandler.setInvalidNameOnAccount(Trigger.New, Trigger.Old);
                // Insertion Failed on Account.OB_CCIAA__c
                triggerHandler.setInvalidCCIAA(Trigger.New, Trigger.Old);
    
                //  micol.ferrari 16/11/2018
                triggerHandler.setAccountNumberWithABI(Trigger.New, Trigger.Old);
    
                //  micol.ferrari 27/11/2018
                triggerHandler.setOBStatusAccount(Trigger.New, Trigger.Old);
                //giovanni.spinelli <spinelli.giovanni@accenture.com> - start - method to make uppercase contact fields
                triggerHandler.uppercaseFieldsConversion(Trigger.new , Trigger.old , 'isInsert' );
                //giovanni.spinelli <spinelli.giovanni@accenture.com> - end - method to make uppercase contact fields
            }
        } else if (Trigger.isUpdate) {
            if (Trigger.isBefore)       {
                OB_AccountTriggerHandler triggerHandler = new OB_AccountTriggerHandler();
                //Update failure on Invalid Account.Name
                triggerHandler.setInvalidNameOnAccount(Trigger.New, Trigger.Old);
                //Update failure on Account.OB_CCIAA__c
                triggerHandler.setInvalidCCIAA(Trigger.New, Trigger.Old);
                //giovanni.spinelli <spinelli.giovanni@accenture.com> - start - method to make uppercase contact fields
                triggerHandler.uppercaseFieldsConversion(Trigger.new , Trigger.old , 'isUpdate');
                //giovanni.spinelli <spinelli.giovanni@accenture.com> - end - method to make uppercase contact fields
            } else if(Trigger.isAfter) {
                OB_AccountTriggerHandler triggerHandler = new OB_AccountTriggerHandler();
                triggerHandler.setLogicForRecordType(Trigger.Newmap,Trigger.Oldmap);
            }
        }
    }
    //  micol.ferrari 04/11/2019 - DISABLE TRIGGER FROM CUSTOM SETTING - STOP
}