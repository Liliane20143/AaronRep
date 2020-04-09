/*
    * Author : Simone Misani
    * Date : 02/04/2019
    * Description : controller for Shortcut executor
    *   
    */
public without sharing class OB_Maintenance_Shortcut_Executor_CC {
	 public class SearchResultWrapper {
        @AuraEnabled
        public string outcome {get;set;}
        @AuraEnabled
        public string errorMessage {get;set;}
        @AuraEnabled
        public Account acc {get;set;}
        @AuraEnabled
        public Contact executor {get;set;}
        @AuraEnabled
        public Contact legalOffice {get;set;}
        @AuraEnabled
        public list<NE__Service_Point__c> listOfServicePoint {get;set;}
        @AuraEnabled
        public string selectedServicePoint{get;set;}
        @AuraEnabled
        public string selectedServicePointExt{get;set;}
        @AuraEnabled
        public boolean executorModifiedAllowed{get;set;}
        @AuraEnabled
        public string selectedMerchantExt{get;set;}
        @AuraEnabled
        public string selectedMerchantAsset{get;set;}
        @AuraEnabled
        public string selectedServicePointAsset{get;set;}
        @AuraEnabled
        public Asset selectedAsset {get;set;}
        @AuraEnabled
        public List<String> selectServicePointListId {get;set;}
        @AuraEnabled
        public List<NE__Lov__c> lovList {get;set;}
    }

    //      *@author Simone Misani <simone.misani@accenture.com>
//         *@date 18/04/2019
//         *@Method for retrive info on executor
//         
	@AuraEnabled
	public static String retriveInfo (String contactId) {
		System.debug('recordiId: '+contactId);
		SearchResultWrapper result = new SearchResultWrapper();		
		String contactQuery = 'select id, Phone,Email,OB_PEC__c,FirstName,LastName,OB_Company_Link_Type__c,OB_Fiscal_code__c,OB_Sex__c, OB_Country_Birth__c,OB_Country_Birth_Code__c,'
                                +'OB_Birth_State_Code__c,OB_Birth_Date__c,OB_Birth_City__c,OB_Birth_State__c,OB_Address_Country__c,OB_Citizenship__c,mobilephone,fax,OB_Document_Release_Country__c,'
                                +'OB_Document_Release_Country_Code__c, OB_Document_Release_State_Code__c,OB_Document_Release_State__c,OB_Document_Type__c,OB_Document_Number__c,OB_Document_Release_Authority__c,'
                                +'OB_Document_Release_Date__c,OB_Document_Expiration_Date__c,OB_Document_Release_City__c,OB_PEP__c,OB_Address_Street__c,OB_Address_Street_Number__c,OB_Address_City__c,'
                                +'OB_Address_State__c,OB_Address_PostalCode__c,OB_Address_Hamlet__c,OB_Address_State_Code__c,OB_Address_Country_Code__c,OB_Contact_State__c,accountid,recordtypeid'
                                +' from contact where id =  \''+contactId +'\'';
        List<Contact> infocontact =Database.query(contactQuery);
		if(!infocontact.isEmpty()){
			result.executor = infocontact.get(0);
			List<Account> accountQuery = [SELECT Id FROM Account WHERE id = : infocontact.get(0).accountid];
			result.acc = accountQuery.get(0);
		}
		String toReturn = JSON.serialize(result);
		System.debug('results: '+toReturn);
		return toReturn;
		
	}
//        *@author Simone Misani <simone.misani@accenture.com>
//         *@date 18/04/2019
//         *@Method for retrive current User and type  contact
//         
@AuraEnabled
	public static Map<String,String> contextUser(String contactId){
		String currentUserId = UserInfo.getUserId();
        //simone misani 10/05/2019 delete where condition 
        List<Contact> rtExecutor = [SELECT recordType.developername 
                                    FROM Contact 
                                    WHERE id =: contactId 
                                    AND recordType.developername = 'Esecutore'
                                    LIMIT 1];
		List<User>  currUser = [SELECT Id, Profile.Name 
                                FROM User 
                                WHERE Id =: currentUserId LIMIT 1];
        Contact con = rtExecutor.get(0);
		User us = currUser.get(0);
        map<String,String> info = new map<String,String>();
		string nameProfile = us.Profile.Name;
        string typeContact = con.recordType.developername;
        info.put('user',nameProfile);
        info.put('developername',typeContact);
		return info;

	}
}