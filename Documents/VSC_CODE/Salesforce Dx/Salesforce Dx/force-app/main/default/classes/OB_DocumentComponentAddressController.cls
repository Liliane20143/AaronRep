public with sharing class OB_DocumentComponentAddressController {
    @AuraEnabled
	 public static Map<String,String> getDocTypeValues(){
		Map<String,String> pickListValuesList= new Map<String,String>();
		Schema.DescribeFieldResult fieldResult = Contact.OB_Document_Type__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple){
		   pickListValuesList.put(pickListVal.getValue(),pickListVal.getLabel());
			 System.debug('pickListValuesList docTypes ' + pickListValuesList);
		}
	   
		return pickListValuesList;
	}
	@AuraEnabled
	public static Map<String,String> getDocAuthValues(){
		Map<String,String> pickListValuesList= new Map<String,String>();
		Schema.DescribeFieldResult fieldResult = Contact.OB_Document_Release_Authority__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple){
		   pickListValuesList.put(pickListVal.getValue(),pickListVal.getLabel());
			 System.debug('pickListValuesList docAuth ' + pickListValuesList);
		}
	   
		return pickListValuesList;
	}	

	/*
    *   Author       :    Morittu Andrea   
    *   Date         :    17.Sept.2019
    *   Description  :    Specific Exception Class
    */

	public virtual class ApplicationException extends Exception {

	}

	/*
		*   Author       :    Morittu Andrea   
		*   Date         :    17.Sept.2019
		*   Description  :    Method to find out if there are PAGOBANCOMAT related to the configuration
    */
	@AuraEnabled
	public static Boolean pagoBancomatArePresent(String orderId){
		Boolean toReturn = false;
		List<NE__OrderItem__c> orderItems = new List<NE__OrderItem__c>();
        try {
        	orderItems = [ 	SELECT  Id, 
                                    NE__ProdId__r.RecordType.DeveloperName
                            FROM	NE__OrderItem__c
                            WHERE 	NE__OrderId__c =: orderId 
                            AND 	NE__ProdId__r.RecordType.DeveloperName = 'Acquiring'
            	
        			];
				if(orderItems.isEmpty()) {
					toReturn = true;
				}
		} catch(ApplicationException aExc) {
			System.debug('An error has occured : ' + aExc.getMessage());
		}
		return toReturn;
	}
}