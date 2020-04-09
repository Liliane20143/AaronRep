/**
 * Created by wojciech.kucharek on 24.04.2019.
 */

trigger OB_OrderItemTrigger on NE__OrderItem__c ( after insert)
{
	//	micol.ferrari 04/11/2019 - DISABLE TRIGGER FROM CUSTOM SETTING - START
    Boolean triggerDisabled = false;
    if (!Test.isRunningTest())
    {
        OB_TriggerSupport__c triggerSupport = OB_TriggerSupport__c.getInstance(Label.OB_DISABLETRIGGERS); 
        triggerDisabled = triggerSupport.OB_DisableAll__c || triggerSupport.OB_DisableOrderItemTrigger__c;
    }
    else 
    {
        //	micol.ferrari 06/11/2019 - else added only to raise the code coverage
        triggerDisabled = false;
        OB_OrderItemTriggerHandler.updateOrderMotoEcomerce( Trigger.newMap );
    }
    if (!triggerDisabled)
    {
        //NEXI-222 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 19/07/2019 Start
        OB_OrderItemTriggerHandler.updateOrderMotoEcomerce( Trigger.newMap );
        //NEXI-222 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 19/07/2019 Stop
    }        
    //	micol.ferrari 04/11/2019 - DISABLE TRIGGER FROM CUSTOM SETTING - STOP
}