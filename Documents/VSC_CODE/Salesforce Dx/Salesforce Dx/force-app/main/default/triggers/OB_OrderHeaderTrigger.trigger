trigger OB_OrderHeaderTrigger on NE__Order_Header__c ( before update, after update )
{
    //	micol.ferrari 04/11/2019 - DISABLE TRIGGER FROM CUSTOM SETTING - START
    Boolean triggerDisabled = false;
    if (!Test.isRunningTest())
    {
        OB_TriggerSupport__c triggerSupport = OB_TriggerSupport__c.getInstance(Label.OB_DISABLETRIGGERS); 
        triggerDisabled = triggerSupport.OB_DisableAll__c || triggerSupport.OB_DisableOrderHeaderTrigger__c;
    }
    if (!triggerDisabled)
    {
        //NEXI-217 Zuzanna Urban<z.urban@accenture.com>, 25/07/2019 Start, aprroval restart
        if ( Trigger.isBefore )
        {
            if ( Trigger.isUpdate )
            {
                OB_OrderHeaderTriggerHandler.restartApproval( Trigger.oldMap, Trigger.newMap );
            }
        }
        //NEXI-217 Zuzanna Urban<z.urban@accenture.com>, 25/07/2019 Stop, aprroval restart
        if ( Trigger.isAfter )
        {
            if ( Trigger.isUpdate )
            {
                OB_OrderHeaderTriggerHandler triggerHandler = new OB_OrderHeaderTriggerHandler( );
                triggerHandler.submitValidity( Trigger.oldMap, Trigger.newMap );
                triggerHandler.updateOrderNexiStatus( Trigger.oldMap, Trigger.newMap );// Simone Misani R1F2-159 30/05/2019
                OB_OrderHeaderTriggerHandler.setOrderStatus( Trigger.oldMap, Trigger.newMap ); // NEXI-52 wojciech.kucharek@accenture.com 15/05/2019
                OB_OrderHeaderTriggerHandler.callAVRSOSIfNeeded( Trigger.oldMap, Trigger.newMap ); //NEXI-214 <damian.krzyzaniak@accenture.com> 22.07.2019
            }
        }
    }        
    //	micol.ferrari 04/11/2019 - DISABLE TRIGGER FROM CUSTOM SETTING - STOP
}