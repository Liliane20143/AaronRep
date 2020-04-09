global class BT_PartnerUsersManagement implements Database.Batchable<sObject>, Database.stateful {
	
	String query;
	private String obj;
	private Boolean allOrOne;
	private String whereCondition;
	private Id profileId;
	private Id roleId;
	public static final String ACC = 'account';
	public static final String CTC = 'contact';
	private static final String USR = 'user';

	//External static variables
	public static Map<String, List<String>> mapFields = new Map<String, List<String>>{
		ACC => new String[]{'id','name'},
		CTC => new String[]{'id','firstname','lastname','email'}
	};
	public static User userTemplate = new User(emailencodingkey='UTF-8',languagelocalekey='it',localesidkey='it_IT',timezonesidkey='Europe/Rome');
	public static Map<String, String> fieldsContatctToUser = new Map<String, String>{
		'firstname' => 'firstname', 
		'lastname' => 'lastname', 
		'email' => 'email'
	};

	public class PartnerUsersManagementException extends Exception {}
	
	global BT_PartnerUsersManagement(String obj, String whereCondition, Boolean allOrOne, Id profileId, Id roleId) {
		this.obj = (obj == null) ? '' : obj.toLowerCase();
		if (!mapFields.keySet().contains(obj)) {
			throw new PartnerUsersManagementException('Object not supported - obj='+obj);
		}
   		if (obj == CTC && profileId == null) {
			throw new PartnerUsersManagementException('ProfileId is mandatory for '+obj+' conversion');
   		}
		this.profileId = profileId;
		this.roleId = roleId; //Not mandatory
		this.allOrOne = allOrOne;
		this.whereCondition = whereCondition;
		queryComposition();
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
   		if (obj == ACC) { convertAccount(scope); }
   		if (obj == CTC) { convertContact(scope); }
	}
	
	global void finish(Database.BatchableContext BC) {}

//-------UTILITY FUNCTIONS

	@TestVisible
	private String queryComposition() {
		String query = 'SELECT ' + String.join(mapFields.get(obj), ',') + ' FROM '+obj+' WHERE '+whereCondition;
		System.debug('query: '+query);
		this.query = query;
		return query;
	}

	private void convertAccount(List<Account> accounts) {
		for (Account a : accounts) {
			a.IsPartner = true;
		}
		Database.SaveResult[] srList = Database.update(accounts, allOrOne);
		debugSaveResult(srList, ACC);
	}

	@TestVisible
	private void convertContact(List<Contact> contacts) {
		List<User> users = new List<User>();
		for (Contact c : contacts) {
			User u = userTemplate.clone(false, false, false, false);
			for (String fieldFrom : fieldsContatctToUser.keySet()) {
				u.put(fieldFrom, c.get(fieldFrom));
			}
			if (this.roleId != null) { u.UserRoleId = this.roleId; }
			u.UserName = u.Email;
			u.ProfileId = profileId;
			u.Alias = generateAliasFromContact(c);
			u.ContactId = c.Id;
			users.add(u);
		}
		Database.SaveResult[] srList = Database.insert(users, allOrOne);
		debugSaveResult(srList, USR);

	}

	@TestVisible
	private static void debugSaveResult(Database.SaveResult[] srList, String obj) {
		for (Database.SaveResult sr : srList) {
		    if (sr.isSuccess()) {
		        System.debug('Success operation '+obj+'. Id: ' + sr.getId());
		    }
		    else {     
		        for(Database.Error err : sr.getErrors()) {
		            System.debug('The following error has occurred on '+obj);                    
		            System.debug(err.getStatusCode() + ': ' + err.getMessage());
		            System.debug(obj+' fields that affected this error: ' + err.getFields());
		        }
		    }
		}
	}

	@TestVisible
	//This could be not perfect for alias generation
	private static String generateAliasFromContact(Contact c) {
		String alias;
		c.firstname = (c.firstname != null) ? c.firstname : ''; //Security check
		String firstNamePart = c.firstname.substring(0, Math.min(c.firstname.length(), 4));
		String lastNamePart = c.lastname.substring(0, Math.min(c.lastname.length(), 4));
		alias = (firstNamePart + lastNamePart).toLowerCase();
		return alias;
	}
}