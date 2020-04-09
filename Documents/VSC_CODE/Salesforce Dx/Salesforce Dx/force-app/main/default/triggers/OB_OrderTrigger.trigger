trigger OB_OrderTrigger on NE__Order__c ( before update, after update)
{
    //	micol.ferrari 04/11/2019 - DISABLE TRIGGER FROM CUSTOM SETTING - START
    Boolean triggerDisabled = false;
    if (!Test.isRunningTest())
    {
        OB_TriggerSupport__c triggerSupport = OB_TriggerSupport__c.getInstance(Label.OB_DISABLETRIGGERS); 
        triggerDisabled = triggerSupport.OB_DisableAll__c || triggerSupport.OB_DisableOrderTrigger__c;
    }
    if (!triggerDisabled)
    {
        // NEXI-20 joanna.mielczarek@accenture.com START 10/05/2019
        if ( Trigger.isBefore )
        {
            if ( Trigger.isUpdate )
            {
                // NEXI-46 marta.stempien@accenture.com START 13/05/2019
                OB_OrderTriggerHandler.setOrderNexiOrBankStatus(Trigger.newMap, Trigger.oldMap);
                // NEXI-46 marta.stempien@accenture.com STOP 13/05/2019
                //giovanni spinelli start 20/08/2019
                OB_OrderTriggerHandler.uppercaseFieldsConversion(Trigger.new, Trigger.old);
                //giovanni spinelli end 20/08/2019
            }
        }
        else
        {
            if ( Trigger.isUpdate )
            {
                OB_OrderTriggerHandler triggerHandler = new OB_OrderTriggerHandler( );
                triggerHandler.fulfilmentStatusAfterUpdate( Trigger.oldMap, Trigger.newMap );
                triggerHandler.changeLogRequestStatusAfterBio( Trigger.oldMap, Trigger.newMap );
                //micol.ferrari
                triggerHandler.createLogRequestAfterPricing( Trigger.oldMap, Trigger.newMap );
            }
        }
        // NEXI-20 joanna.mielczarek@accenture.com STOP 10/05/2019
    }        
    //	micol.ferrari 04/11/2019 - DISABLE TRIGGER FROM CUSTOM SETTING - STOP     
}