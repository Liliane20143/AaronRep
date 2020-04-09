/* Andrea Morittu, Marco Armato
-------------------------------------------------
		Crezione di Lov con all'interno Link 
		per rendere la componente 
		OB_CommunitySideBar dinamica
-------------------------------------------------
*/
global with sharing class OB_CommunitySideBarController {

	@AuraEnabled
    public static List<NE__Lov__c> retrieveCommunityLovs() {
    	List<NE__Lov__c> toReturn = null;
    	try{
    		List<User> listOfUsers = new List<User>();
    		listOfUsers = [SELECT Id, Profile.UserLicense.Name, Contact.Account.OB_ABI__c, OB_CAB__c, Contact.Account.Phone, Contact.Account.Fax 
			    			FROM User 
			    			WHERE id =: UserInfo.getUserId() 
		    				LIMIT 1];
			System.debug('listOfUsers is: ' + listOfUsers);
    		
    		if(!listOfUsers.isEmpty()){
    			User currUser = listOfUsers.get(0);
    			System.debug('currUser is: ' + currUser);
    			if (currUser.Profile.UserLicense.Name == System.Label.OB_License_PartnerCommunity) {
    				System.debug('currUser.Profile.UserLicense.Name is: ' + currUser.Profile.UserLicense.Name);
	    			String ABI = currUser.Contact.Account.OB_ABI__c;
	    			System.debug('ABI is: ' + ABI);
	    			
	    			List<NE__Lov__c> homePageUtilsLovs 	= new List<NE__Lov__c>();
	    			homePageUtilsLovs= [SELECT Name, NE__Sub_Type__c, NE__Type__c, NE__Value1__c, NE__Value2__c, NE__Value3__c, NE__Active__c 
	    							  	FROM NE__Lov__c 
	    							  	WHERE NE__Sub_Type__c = 'TIPOLOGICHE'
	    							  	AND NE__Type__c = 'HomePageCommunity' 
	    							  	AND NE__Active__c = true
	    							  	AND NE__Value3__c = :ABI ];
		    		if(!homePageUtilsLovs.isEmpty()) {
		    			toReturn = new List<NE__Lov__c>();
		    			toReturn = homePageUtilsLovs; 
		    		}
    			}
    		} else {    			
    			System.debug('No User found!');
    		}
    	} catch(Exception ecc) {
    		System.debug('An exception occurred: ' + ecc.getMessage());
    	}
    	return toReturn;
    }
    
    @AuraEnabled
    public static User getBankInfo() {
    	User toReturn = null;
    	//List<Account> accs = new List<Account>();
    	try{
	    	List<User> listOfUsers = new List<User>();
			listOfUsers = [SELECT Id, Profile.UserLicense.Name,Contact.FirstName,Contact.LastName, Contact.Account.OB_ABI__c, OB_CAB__c, Contact.Account.Phone, Contact.Account.Fax 
			    			FROM User 
			    			WHERE Id =: UserInfo.getUserId() 
		    				LIMIT 1];
			System.debug('listOfUsers is: ' + JSON.serialize(listOfUsers));
		    if(!listOfUsers.isEmpty()){
				/*User currUser = listOfUsers.get(0);
				if (currUser.Profile.UserLicense.Name == 'Partner Community') {
					
					accs = [SELECT Id, Name, Phone, Fax  FROM Account Where Id =:currUser.Contact.AccountId LIMIT 1];
					System.debug('accs is : ' + accs );
					if (!accs.isEmpty()){
						toReturn = new Account();
						toReturn = accs.get(0);
						System.debug('Final List Lov is : ' + toReturn);
					}
					
				}*/
				User currUser = listOfUsers.get(0);
				toReturn =  currUser; 
		    }
    	} catch(Exception ecc) {
    		System.debug('An exception occurred: ' + ecc.getMessage());
    	}
		return toReturn;
    }
}