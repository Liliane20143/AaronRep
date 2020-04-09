global without sharing class OB_NewReportController 
{
	//  START   micol.ferrari 22/11/2018
	//global String lcBaseURL {get; set;}

	//global OB_NewReportController()
	//{
	//	String hostname = URL.getSalesforceBaseUrl().getHost();
	//	System.debug('@@@@hostname: '+ hostname);
	//	Integer position = hostname.indexOf('--c');
	//	String mydomain='';
	//	String endUrl = '';
	//	if(position!=-1){
	//		mydomain = hostname.substring(0, position);
	//		endUrl = '.lightning.force.com'; 
	//	} else { 
	//		mydomain = hostname;
	//	}
	//	String lcBaseURL = 'https://' + mydomain + endUrl;
	//	Map<String, String> headers = Apexpages.currentPage().getHeaders(); 
	//	headers.put('X-Frame-Options', 'ALLOW-FROM ' + lcBaseURL);
	//	headers.put('Content-Security-Policy', 'frame-ancestors ' + lcBaseURL);
	//	System.debug('@@@ lcBaseURL: ' + lcBaseURL);
	//}
	//  END   micol.ferrari 22/11/2018

	@AuraEnabled
	global static Report getReport(String reportName)
	{	
		List<Report> reportList = [SELECT Name, Id FROM Report where DeveloperName =:reportName LIMIT 1];
		System.debug('ReportName = '+ reportList[0]);
		return reportList[0];
		
	}

	@AuraEnabled
	global static String getSessionId()
	{
		System.debug(UserInfo.getSessionId());
		return UserInfo.getSessionId();         
	}
 
	@AuraEnabled
	global static User getFieldUserLogged(String columns)
	{
		try
		{
			System.debug('Entrato get'+columns);
			String userId = UserInfo.getUserId();
			System.debug(userId);

			//  START   micol.ferrari 22/11/2018 - ADDED CASE COLUMNS IS NULL, SO NO PARAM
			if (columns==null || columns=='')
			{
				columns = 'Id';
			}
			String query = 'select '+columns+' from User where id =\'' + userId+ '\' LIMIT 1';
			//  END   micol.ferrari 22/11/2018 - ADDED CASE COLUMNS IS NULL, SO NO PARAM

			System.debug('query string:'+query); 
		
			User records = Database.query(query);
			return records;
		}
		catch(exception e)
		{
			System.debug('The following exception has occurred: ' + e.getMessage());
			return null;
		} 
	}
}