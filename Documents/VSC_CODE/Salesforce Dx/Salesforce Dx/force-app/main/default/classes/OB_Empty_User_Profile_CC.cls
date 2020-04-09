public with sharing class OB_Empty_User_Profile_CC 
{
	@AuraEnabled
	public static String retrieveStaticImg()
	{

		String toReturn = null;
//19-09-2018--SALVATORE P.-- Search a ABI code depending of logged user 
		String userId = UserInfo.getUserId();
		List<User> listOfUser = 
								[ 	
									SELECT Id, OB_ABI__c
									FROM User
									WHERE Id =: userId
									LIMIT 1
								];

		if(!listOfUser.isEmpty()) 
		{
			String userAbi = listOfUser[0].OB_ABI__c;
			System.debug('OB_Empty_User_Profile_CC.retrieveLogoId - userAbi: '+userAbi);

//19-09-2018--SALVATORE P.-- Returns the name of the static resource connected to the bank of the logged user
			toReturn = 'logo_'+userAbi;

		}
		return toReturn;
	}

	@AuraEnabled
	public static String getVFBaseURLServer() {
		User user = [SELECT fullPhotoUrl FROM User WHERE Id = : UserInfo.getUserID()]; //enrico.purificato - 4/7/2019 - performance
		String hostname = URL.getSalesforceBaseUrl().getHost();
		system.debug('hostname --> '+hostname);
		system.debug('base url: ' +URL.getSalesforceBaseUrl().toExternalForm());
		// The above query returns a URL like https://my-domain-dev-ed--c.na50.content.force.com/profilephoto/001/A
		// Let's use the two first fragments of that URL to create the VF base URL 
		system.debug('fullPhotoUrl --> '+user.fullPhotoUrl);
		List<String> fragments = user.fullPhotoUrl.split('\\.');

		//	START 	micol.ferrari 10/12/2018
		List<String> photourl = user.fullPhotoUrl.split('/');
		if (!photourl.isEmpty() && photourl.get(1)!='profilephoto')
		{
			hostname += '/'+photourl.get(1);
		}
		//	END 	micol.ferrari 10/12/2018 




		//	START 	micol.ferrari 17/01/2019 - GET CURRENT ORG NAME
		//String environment = !Test.isRunningTest() ? system.Label.OB_Environment : 'DEV1';
		String environment = !Test.isRunningTest() ? OB_UtilityCallingServices.returnCurrentOrg() : 'DEV1';
		//	END 	micol.ferrari 17/01/2019 - GET CURRENT ORG NAME

		OB_Integration_Configuration__c intConfig = OB_Integration_Configuration__c.getValues(environment);
		system.debug('intConfig.OB_Domain__c --> '+intConfig.OB_Domain__c);
		if(fragments[0].toLowerCase().contains(intConfig.OB_Domain__c))
		{
			system.debug('fragments[0]' + fragments[0].toLowerCase());
			system.debug('fragments[1]' + fragments[1].toLowerCase());    
			system.debug('fragments[0].toLowerCase().contains(intConfig.OB_Domain__c) --> '+fragments[0].toLowerCase() + '.' + fragments[1].toLowerCase() + '.visual.force.com');          
			return fragments[0].toLowerCase() + '.' + fragments[1].toLowerCase() + '.visual.force.com';
			//return 'https://nexi-payments--c.eu8.visual.force.com';
		}
		else
		{
			system.debug('hostname getVFBaseURL !contains(intConfig.OB_Domain__c) --> '+hostname);

			//if(Test.isRunningTest()){
				return 'https://'+hostname;
			//} else {
			//	system.debug(Network.getLoginUrl(Network.getNetworkId()).split('login').get(0));
			//	return Network.getLoginUrl(Network.getNetworkId()).split('login').get(0);
			//}

		}
	}
}