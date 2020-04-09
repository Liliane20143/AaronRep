public class OB_RedirectPageFlow_CC {
    
	public Boolean isCommunity{get;set;}
	public String theUrl{get;set;}
	public String theId{get; set;}

	public OB_RedirectPageFlow_CC()
    {
    	//try
    	//{
    		
	    //	List<User> users = [SELECT Id, Profile.UserLicense.Name FROM User WHERE Id = :UserInfo.getUserId()];
	    //    if(!users.isEmpty())
	    //    {
	    //    	isCommunity = (users.get(0).Profile.UserLicense.Name == Label.OB_License_PartnerCommunity) ? true : false;
	    //    	theUrl = (isCommunity) ? '\'https://' + String.valueOf([SELECT Domain FROM Domain LIMIT 1].Domain) + '\'' : '\'' + String.valueOf(System.URL.getSalesforceBaseUrl().toExternalForm()) +'\'';
	    //    }
    	//}
       	try
    	{
			//System.debug('GLOBAL VARIABLE: ' + OB_FlowControlClass.orderHeaderId);
			
    		//	START 	micol.ferrari 17/01/2019 - GET CURRENT ORG NAME
			//String environment = !Test.isRunningTest() ? system.Label.OB_Environment : 'DEV1';
			String environment = !Test.isRunningTest() ? OB_UtilityCallingServices.returnCurrentOrg() : 'DEV1';
			//	END 	micol.ferrari 17/01/2019 - GET CURRENT ORG NAME

			OB_Integration_Configuration__c intConfig = OB_Integration_Configuration__c.getValues(environment);
    		List<User> users = [SELECT fullPhotoUrl FROM User WHERE Id = :UserInfo.getUserId()]; 
    		if(!users.isEmpty())
    		{
    			String hostname = URL.getSalesforceBaseUrl().getHost();
				if (!users[0].fullPhotoUrl.split('/').isEmpty() && users[0].fullPhotoUrl.split('/').get(1)!='profilephoto')
				{
					hostname += '/' + users[0].fullPhotoUrl.split('/').get(1);
					System.debug('hostname: ' + hostname);
				}
	 			List<String> fragments = users[0].fullPhotoUrl.split('\\.');
 	        	isCommunity = (fragments[0].toLowerCase().contains(intConfig.OB_Domain__c)) ? false : true;
 	        	if(isCommunity)
 	        	{
 	        		System.debug('###!isCommunity');
 	        		//theUrl = '\'' + 'https://nexi-payments--dev1.cs88.my.salesforce.com/setup/ui/profilelist.jsp?setupid=Profiles&retURL=%2Fui%2Fsetup%2FSetup%3Fsetupid%3DUsers' + '\'';
 	        		theUrl = '\'' + 'https://' + hostname + '\'';
 	        	}
 	        	else
 	        	{
 	        		theUrl = '\'' + String.valueOf(System.URL.getSalesforceBaseUrl().toExternalForm()) + '\''; 
 	        	}
 	        }
    	}
	    catch(Exception e)
	    {
	    	System.debug('Exception ' + e.getMessage() + ' at line ' + e.getLineNumber());
	    }
	}
}