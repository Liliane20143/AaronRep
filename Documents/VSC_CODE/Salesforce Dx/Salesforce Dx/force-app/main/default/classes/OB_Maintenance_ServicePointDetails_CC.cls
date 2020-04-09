public with sharing class OB_Maintenance_ServicePointDetails_CC 
{
    @AuraEnabled
    public static OB_LogRequest__c getServicePointDetails(String logRequestId)
    {
        OB_LogRequest__c toReturn = null;
        List<OB_LogRequest__c> logRequests = [SELECT OB_ServicePointId__c,
                                                     OB_ServicePointId__r.Name,
                                                     OB_ServicePointId__r.OB_AddressFormula__c
                                              FROM   OB_LogRequest__c
                                              WHERE  id = :logRequestId];

                            

        if(!logRequests.isEmpty())
        {
            if(logRequests.get(0).OB_ServicePointId__c != null)
            {
                toReturn = logRequests.get(0);
            }
        }
        return toReturn;
    }
}