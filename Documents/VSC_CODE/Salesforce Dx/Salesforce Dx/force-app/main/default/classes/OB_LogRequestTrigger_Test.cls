@isTest
public class OB_LogRequestTrigger_Test
{
    /*******************************************************************************
    Purpose:  Method tests trigger insert

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien         02/10/2019       Created         NEXI-354
    ********************************************************************************/
    @isTest
    public static void insertTest( )
    {
        //	micol.ferrari 04/11/2019 - INSERT CUSTOM SETTING FOR DISABLE TRIGGER - START
        OB_TriggerSupport__c triggerSupport = new OB_TriggerSupport__c( );
        triggerSupport.Name = 'OB_DisableTriggers';
        triggerSupport.OB_DisableAll__c = false;
        triggerSupport.OB_DisableLogRequestTrigger__c = false;
        insert triggerSupport;
        //	micol.ferrari 04/11/2019 - INSERT CUSTOM SETTING FOR DISABLE TRIGGER - STOP
        	
        OB_LogRequest__c logRequest = OB_TestDataFactory.getLogRequest( );
        logRequest.OB_change_of_reporting_type__c = true;
        insert logRequest;
        System.assert( ![ SELECT Id FROM OB_LogRequest__c ].isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests trigger update

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien         02/10/2019       Created         NEXI-354
    ********************************************************************************/
    @isTest
    public static void updateTest( )
    {
        //	micol.ferrari 04/11/2019 - INSERT CUSTOM SETTING FOR DISABLE TRIGGER - START
        OB_TriggerSupport__c triggerSupport = new OB_TriggerSupport__c( );
        triggerSupport.Name = 'OB_DisableTriggers';
        triggerSupport.OB_DisableAll__c = false;
        triggerSupport.OB_DisableLogRequestTrigger__c = false;
        insert triggerSupport;
        //	micol.ferrari 04/11/2019 - INSERT CUSTOM SETTING FOR DISABLE TRIGGER - STOP
        
        OB_LogRequest__c logRequest = OB_TestDataFactory.getLogRequest( );
        logRequest.OB_Status__c = OB_UtilityConstants.LOGREQUEST_STATUS_INAPPROVAZIONE;
        insert logRequest;
        Test.startTest();
        logRequest.OB_Status__c = OB_UtilityConstants.LOGREQUEST_STATUS_CONFERMATO;
        update logRequest;
        Test.stopTest();
        System.assertEquals( OB_UtilityConstants.LOGREQUEST_STATUS_CONFERMATO, [ SELECT OB_Status__c FROM OB_LogRequest__c ].get( 0 ).OB_Status__c );
    }
}