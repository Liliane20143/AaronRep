/*Andrea Morittu*/
global without sharing class OB_BankOrderDashController {
	
	global String ABI 											{get; set;}
	global String CAB 											{get; set;}
	global String reportId										{get; set;}
	global String filter										{get; set;}
	global Boolean showReport 									{get; set;}
	global String currentUser									{get; set;}
	global String lcBaseURL										{get; set;}

   global OB_BankOrderDashController(){ 
		system.debug('OB_BankOrderDashController CONSTRUCTOR');
		String reportName = ApexPages.currentPage().getParameters().get('reportName');
		String ABIField = ApexPages.currentPage().getParameters().get('ABIField');
		String CABField = ApexPages.currentPage().getParameters().get('CABField');

		String userId = Userinfo.getuserid();
		List<User> listOfUsers = [SELECT Id, ContactId, Contact.AccountId, Contact.Account.OB_ABI__c, Profile.UserLicense.Name, OB_CAB__C, OB_ABI__c
									FROM User
									WHERE Id =: userId
									LIMIT 1];
		
		//	CHECK USERLICENSE
		if(!listOfUsers.isEmpty() && listOfUsers.get(0).Profile.UserLicense.Name == 'Partner Community') {
			User currentUser = listOfUsers.get(0);        
			ABI = currentUser.Contact.Account.OB_ABI__c;
			// ANDREA MORITTU START 22-11-2019 - PROD_159
            CAB = currentUser.OB_CAB__c.contains(';') ? currentUser.OB_CAB__c.replace(';', ',') : currentUser.OB_CAB__c; 
			// ANDREA MORITTU END 22-11-2019 - PROD_159   
			   
			showReport = false; 
			try{
				
				//if(!String.isBlank(ABIField)){
				if(ABI!=null && ABI!=''){
					filter = '[{column: \'' + ABIField + '\',operator : \'equals\', value : \''+ABI+'\'}';
					//if(!String.isBlank(CABField)){
					//giovanni spinelli - start - 14/10/2019 - add if condition to show report to L3
					if(CAB!=null && CAB!='' && cab != '99999'){
					//giovanni spinelli - end - 14/10/2019 - add if condition to show report to L3
						filter += ',{column: \'' + CABField + '\',operator : \'equals\', value : \''+CAB+'\'}';
					}
					filter +=']';
					reportId  = [SELECT Id, DeveloperName FROM Report where DeveloperName =:reportName LIMIT 1].Id;
					showReport = true;
				}    	
			} catch(exception ecc) {
				System.debug(ecc.getMessage());
			}
			String hostname = URL.getSalesforceBaseUrl().getHost();
			System.debug('@@@@hostname: '+ hostname);
			Integer position = hostname.indexOf('--c');
			String mydomain='';
			String endUrl = '';
			if(position!=-1){
				mydomain = hostname.substring(0, position);
				endUrl = '.lightning.force.com'; 
			} else { 
				mydomain = hostname;
			}
			lcBaseURL = 'https://' + mydomain + endUrl;
			Map<String, String> headers = Apexpages.currentPage().getHeaders(); 
			headers.put('X-Frame-Options', 'ALLOW-FROM ' + lcBaseURL);
			headers.put('Content-Security-Policy', 'frame-ancestors ' + lcBaseURL);
			System.debug('@@@ lcBaseURL: ' + lcBaseURL);
		}
	}

	@AuraEnabled
	public static String getFinalUrl(){
		System.debug('OB_BankOrderDashController.getFinalUrl - INSIDE');
		User user = [SELECT fullPhotoUrl FROM User WHERE userType = 'Standard' LIMIT 1]; 
		String hostname = URL.getSalesforceBaseUrl().getHost();
		
		List<String> fragments = user.fullPhotoUrl.split('\\.');
        
		//	START 	micol.ferrari 10/12/2018
		List<String> photourl = user.fullPhotoUrl.split('/');
		if (!photourl.isEmpty() && photourl.get(1)!='profilephoto')
		{
			hostname += '/'+photourl.get(1);
		}
		
		Integer position = hostname.indexOf('--c');
		String mydomain='';
		String endUrl = '';
		if(position!=-1){
			mydomain = hostname.substring(0, position);
			endUrl = '.lightning.force.com'; 
		} else { 
			mydomain = hostname;
		}
		String lcBaseURL = 'https://' + mydomain + endUrl;	    
		System.debug('OB_BankOrderDashController.getFinalUrl - lcBaseURL: '+lcBaseURL);
		return lcBaseURL;
	}
	
}