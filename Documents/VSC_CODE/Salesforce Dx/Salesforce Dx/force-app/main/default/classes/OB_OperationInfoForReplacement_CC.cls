public with sharing class OB_OperationInfoForReplacement_CC {

    @AuraEnabled
	public static Map<String,String> getFieldValuesForPetitioner(){
		Map<String,String> pickListValuesList= new Map<String,String>();
		Schema.DescribeFieldResult fieldResult = NE__Order__c.OB_Petitioner__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple ){
		    pickListValuesList.put(pickListVal.getValue(), pickListVal.getLabel());
			System.debug('pickListValuesList petittioners ' + pickListValuesList);
		}
	   
		return pickListValuesList;
	}

    @AuraEnabled
	public static Map<String,String> getFieldValuesForUnistallationProcedure(){
		Map<String,String> pickListValuesList= new Map<String,String>();
		Schema.DescribeFieldResult fieldResult = NE__Order__c.OB_Unistallation_Procedure__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple ){
		    pickListValuesList.put(pickListVal.getValue(), pickListVal.getLabel());
			System.debug('pickListValuesList unistallation procedure ' + pickListValuesList);
		}
	   
		return pickListValuesList;
	}



}