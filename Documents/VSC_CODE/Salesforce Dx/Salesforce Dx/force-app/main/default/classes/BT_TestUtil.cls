@isTest
public with sharing class BT_TestUtil {
	public static Account getAccount(String name, String abi, Boolean isReferral) {
		return new Account(Name=name, OB_ABI__c=abi, BT_IsReferral__c=isReferral);
	}

	public static Account getAccount(String name, String abi) {
		return getAccount(name, abi, false);
	}

	public static BT_ConfigSimulator__c getSimulationConfig(Id accountId, String abi, String rtDevName) {
		Map<String, Schema.RecordTypeInfo> rtMapByDevName = Schema.SObjectType.BT_ConfigSimulator__c.getRecordTypeInfosByDeveloperName();
		BT_ConfigSimulator__c cfg = getSimulationConfig(accountId, abi);
		if (rtMapByDevName.containsKey(rtDevName)) {
			cfg.RecordTypeId = rtMapByDevName.get(rtDevName).getRecordTypeId();
		}
		return cfg;
	}

	public static BT_ConfigSimulator__c getSimulationConfig(Id accountId, String abi) {
		return new BT_ConfigSimulator__c(BT_Account__c=accountId, BT_ABI__c=abi, BT_Disclaimer__c='Disc');
	}

	public static BT_Simulation__c getSimulation(Id accountId) {
		return new BT_Simulation__c(BT_Account__c=accountId);
	}
    
	public static Contact getContact(Id accountId, String firstName, String lastName) {
		return new Contact(AccountId=accountId, FirstName=firstName, LastName=lastName);
	}

	public static User getUser(String sLastName, String sUsername, Id profileId, Integer offset){
		User u;
		try {
			u = new User(alias = 'standt', email=sUsername,
			emailencodingkey='UTF-8', lastname=sLastName, languagelocalekey='en_US',
			localesidkey='en_US', profileid = profileId,
			timezonesidkey='America/Los_Angeles', username=sUsername);
		} catch (Exception ex) {
			u = [SELECT Id FROM User WHERE IsActive = true AND ProfileId = :profileId LIMIT 1 OFFSET :offset];
		}
		return u;
	}

	public static User getUser(Id contactId, String sLastName, String sUsername, String profileName, Integer offset){
		User u = getUser(sLastName, sUsername, profileName, offset);
		u.ContactId = contactId;
		return u;
	}

	public static User getUser(String sLastName, String sUsername, String profileName, Integer offset){
		Profile p = [select id from profile where name=:profileName];
		Datetime dt =  Datetime.now();
		Integer ms = dt.millisecond();
		User u = new User(alias = 'standt', email=sUsername,
			emailencodingkey='UTF-8', lastname=sLastName, languagelocalekey='en_US',
			localesidkey='en_US', profileid = p.Id,
			timezonesidkey='America/Los_Angeles', username=ms+sUsername);
		return u;
	}

	public static User getUser(String sLastName, String sUsername, String profileName){
		Profile p = [select id from profile where name=:profileName];
		User u = new User(alias = 'standt', email=sUsername,
			emailencodingkey='UTF-8', lastname=sLastName, languagelocalekey='en_US',
			localesidkey='en_US', profileid = p.Id,
			timezonesidkey='America/Los_Angeles', username=sUsername);

		return u;
	}
}