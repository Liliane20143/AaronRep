trigger OB_Service_PointTrigger on NE__Service_Point__c (before insert, before update)
{
    //	micol.ferrari 04/11/2019 - DISABLE TRIGGER FROM CUSTOM SETTING - START
    Boolean triggerDisabled = false;
    if (!Test.isRunningTest())
    {
        OB_TriggerSupport__c triggerSupport = OB_TriggerSupport__c.getInstance(Label.OB_DISABLETRIGGERS); 
        triggerDisabled = triggerSupport.OB_DisableAll__c || triggerSupport.OB_DisableServicePointTrigger__c;
    }
    if (!triggerDisabled)
    {
        if ( Trigger.isInsert )
        {
            if ( Trigger.isBefore )
            {
                OB_Service_PointTriggerHandler triggerHandler = new OB_Service_PointTriggerHandler( );
                triggerHandler.setInvalidNameOnServicePointName( Trigger.New, Trigger.Old );
                triggerHandler.setInvalidServicePointName( Trigger.New, Trigger.Old );
    
                //	micol.ferrari 27/11/2018
                triggerHandler.setOBStatusServicePoint( Trigger.New, Trigger.Old );
    
                // ANDREA MORITTU START 2019.05.15 - R1F2-47
                triggerHandler.checkCoherencyWithSeasonalInput( Trigger.New, Trigger.Old );
                // ANDREA MORITTU END 2019.05.15 - R1F2-47
                //giovanni.spinelli <spinelli.giovanni@accenture.com> - start - method to make uppercase contact fields
                triggerHandler.uppercaseFieldsConversion( Trigger.new, Trigger.old, 'isInsert' );
                //giovanni.spinelli <spinelli.giovanni@accenture.com> - end - method to make uppercase contact fields
    
            }
        }
        else if ( Trigger.isUpdate )
        {
            if ( Trigger.isBefore )
            {
                OB_Service_PointTriggerHandler triggerHandler = new OB_Service_PointTriggerHandler( );
                triggerHandler.setInvalidNameOnServicePointName( Trigger.New, Trigger.Old );
                triggerHandler.setInvalidServicePointName( Trigger.New, Trigger.Old );
    
                // ANDREA MORITTU START 2019.05.15 - R1F2-47
                triggerHandler.checkCoherencyWithSeasonalInput( Trigger.New, Trigger.Old );
                // ANDREA MORITTU END 2019.05.15 - R1F2-47
                //giovanni.spinelli <spinelli.giovanni@accenture.com> - start - method to make uppercase contact fields
                triggerHandler.uppercaseFieldsConversion( Trigger.new, Trigger.old, 'isUpdate' );
                //giovanni.spinelli <spinelli.giovanni@accenture.com> - end - method to make uppercase contact fields
            }
        }
    }        
    //	micol.ferrari 04/11/2019 - DISABLE TRIGGER FROM CUSTOM SETTING - STOP   
}