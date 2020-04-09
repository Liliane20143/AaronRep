/*
    *   Author       :    Morittu Andrea   
    *   Date         :    22.Aug.2019
    *   Description  :    Class used as controller of OB_PrivacySectionComponent.bundle
*/
public class OB_PrivacySectionController {

    /*
    *   Author       :    Morittu Andrea   
    *   Date         :    22.Aug.2019
    *   Description  :    Method to retrieve label of privacy fields by his API name
    */
    @AuraEnabled
    public static Map<String, String> retrievePrivacyFieldName() {
        List<String> allAPIname = new List<String>();
        Map<String, String> toReturn = new Map<String, String>();

        List<Schema.SObjectType> objects = new List<Schema.SObjectType>{ NE__Service_point__c.SObjectType};


        String type='NE__Service_point__c';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(type);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();

        for (String fieldName: fieldMap.keySet()) {
            System.debug('##Field API Name='+fieldName);// list of all field API name
            switch on fieldMap.get(fieldName).getDescribe().getName() {
                when 'OB_Privacy_C3__c' {
                    toReturn.put(fieldName, fieldMap.get(fieldName).getDescribe().getLabel());
                }
                when 'OB_Privacy_C4__c'  {
                    toReturn.put(fieldName, fieldMap.get(fieldName).getDescribe().getLabel());
                }
                when 'OB_Privacy_C5__c' {
                    toReturn.put(fieldName, fieldMap.get(fieldName).getDescribe().getLabel());
                } 
            }
        }
        System.debug('toReturn is ' + toReturn);
        return toReturn;
    }

    /*
    *   Author       :    Morittu Andrea   
    *   Date         :    22.Aug.2019
    *   Description  :    Method to find out if there are PAGOBANCOMAT related to the configuration
    */
    @AuraEnabled
    public static Boolean pagoBancomatArePresent(String orderId) {
        // ATTRIBUTE SECTION
        List<NE__OrderItem__c> orderItems = new List<NE__OrderItem__c>();
        Boolean toReturn = true;
        try{
            if(!String.isEmpty(orderId)) {
                orderItems =    [
                                    SELECT  Id,
                                            Name,
                                            NE__ProdName__c,
                                            NE__ProdId__r.RecordType.DeveloperName,  
                                            RecordType.DeveloperName 
                                    FROM    NE__OrderItem__c 
                                    WHERE   NE__OrderId__c =: orderId 
                                    AND     NE__ProdId__r.RecordType.DeveloperName =:OB_UtilityConstants.ACQUIRING
                                ];
                if(orderItems.isEmpty()) {
                    toReturn = false;
                }
            }
        } catch(Exception exc) {
            System.debug('An error has occured in OB_PrivacySectionController.Method1 : ' + exc.getMessage() + ' at the following line : ' + exc.getLineNumber());
        }
        return toReturn;
    }
    /*******************************************************************************
	Purpose:  method to retrieve privacy fields from Service Point
    Parameters: Id service point
    Returns: -

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         gianluigi.virga         19/09/2019      Created         retrieve privacy fields on Service Point
	
 	********************************************************************************/
	@AuraEnabled
    public static Map<String,Boolean> retrievePrivacyServicePoint(String servicePointId){
        Map<String,Boolean> privacyValues = new Map<String,Boolean> ();
		List<NE__Service_Point__c> currentSp = [SELECT Id, 
													OB_Privacy_C3__c,
													OB_Privacy_C4__c,
													OB_Privacy_C5__c
													FROM NE__Service_Point__c
													WHERE Id =: servicePointId
													LIMIT 1];
		if(!currentSp.isEmpty() && currentSp != null){
			privacyValues.put('OB_Privacy_C3__c', currentSp[0].OB_Privacy_C3__c);
            privacyValues.put('OB_Privacy_C4__c', currentSp[0].OB_Privacy_C4__c);
            privacyValues.put('OB_Privacy_C5__c', currentSp[0].OB_Privacy_C5__c);
		}
        return privacyValues;
	}
}