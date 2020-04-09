trigger OB_LogRequestTrigger on OB_LogRequest__c (before update, before insert, after insert, after update) //NEXI-254 Marta Stempien <marta.stempien@accenture.com> 02/10/2019 Added after update
{
    //	micol.ferrari 04/11/2019 - DISABLE TRIGGER FROM CUSTOM SETTING - START
    Boolean triggerDisabled = false;
    if (!Test.isRunningTest())
    {
        OB_TriggerSupport__c triggerSupport = OB_TriggerSupport__c.getInstance(Label.OB_DISABLETRIGGERS); 
        triggerDisabled = triggerSupport.OB_DisableAll__c || triggerSupport.OB_DisableLogRequestTrigger__c;
    }
    if (!triggerDisabled)
    {
        // NEXI-97 Marta Stempien <marta.stempien@accenture.com> Added if/else conditions  11/06/2019 Start
        if ( Trigger.isBefore )
        {
            if ( Trigger.isUpdate )
            {
                //NEXI-354 Marta Stempien <marta.stempien@accenture.com>, 02/10/2019 Start
                //NEXI-217 Zuzanna Urban<z.urban@accenture.com>, 25/07/2019 Start, approval restart
                OB_LogRequestTriggerHandler.restartApproval( Trigger.oldMap, Trigger.newMap );
                //NEXI-217 Zuzanna Urban<z.urban@accenture.com>, 25/07/2019 Stop, approval restart
                OB_LogRequestTriggerHandler.logRequestResolution( Trigger.newMap, Trigger.oldMap ); //NEXI-64 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 06/06/2019
                OB_LogRequestTriggerHandler.setStatuses( Trigger.newMap, Trigger.oldMap );
                //NEXI-354 Marta Stempien <marta.stempien@accenture.com>, 02/10/2019 Stop
            }
        }
        //NEXI-185 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 10/07/2019 Start
        else
        {
            System.debug( LoggingLevel.FINE, 'OB_LogRequestTrigger after' );
            if ( Trigger.isInsert )
            {
                OB_LogRequestTriggerHandler.afterInsertHandler( Trigger.new );
            }
            //NEXI-354 Marta Stempien <marta.stempien@accenture.com> 02/10/2019 Start
            else if ( Trigger.isUpdate )
            {
                System.debug( LoggingLevel.FINE, 'OB_LogRequestTrigger after isUpdate' );
                OB_LogRequestTriggerHandler.checkApprovalAction( Trigger.oldMap, Trigger.newMap );
            }
            //NEXI-354 Marta Stempien <marta.stempien@accenture.com> 02/10/2019 Stop
        }
        // NEXI-185 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 10/07/2019 Stop
        // NEXI-97 Marta Stempien <marta.stempien@accenture.com> Added if/else conditions  11/06/2019 Stop
    }        
    //	micol.ferrari 04/11/2019 - DISABLE TRIGGER FROM CUSTOM SETTING - STOP
}