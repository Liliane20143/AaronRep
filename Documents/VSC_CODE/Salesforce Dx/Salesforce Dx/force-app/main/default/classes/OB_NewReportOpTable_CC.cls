public without sharing class OB_NewReportOpTable_CC {
    
/*
		*@author Simone Misani <simone.misani@accenture.com>
		*@date 16/04/2019
		*@change  all method global on public
		
	*/ 
	@AuraEnabled
	public static Report getReport(String reportName)
	{
        try
        {
            System.debug('reportName: ' + reportName);
			return [SELECT Name , Id FROM Report where DeveloperName =:reportName LIMIT 1];
        }
        catch(Exception e)
        {
            System.debug('Exception in OB_NewReportOperationController.getReport at line ' + e.getLineNumber() + '. Message: ' + e.getMessage());
        	return null;
        }
	}

	@AuraEnabled
	public static String getSessionId()
	{
        try
        {
			System.debug(UserInfo.getSessionId());
			return UserInfo.getSessionId();
        }
        catch(Exception e)
        {
            System.debug('Exception in OB_NewReportOperationController.getSessionId at line ' + e.getLineNumber() + '. Message: ' + e.getMessage());
        	return null;
        }
	}

	/*
		*@author Simone Misani <simone.misani@accenture.com>
		*@date 25/03/2019
		*@description Method getFieldUserLogged  add query for use Custommetadata and return map user and Type(ABI-CAB-MULTICAB)
		*@history 25/03/2019 Method created
	*/ 
 
	@AuraEnabled
	public static Map<String,Object> getFieldUserLogged()
	{
		Map<String,Object> toReturn=new Map<String,Object>();
		try
		{
			//START    simone.misani 25/03/2019 - R1F2_RP_014 - Use CustomMetadata for controll 
		
			String userId = UserInfo.getUserId();
			System.debug(userId);
			String typeFilters;
			List<user> listUser = [SELECT id,OB_ABI__c,OB_CAB__c,Profile.Name, profile.userlicense.name FROM User WHERE id=:userId LIMIT 1];
			System.debug('listUser'+listUser);
			String nameMeta = '';
			if(!listUser.isEmpty()){
				User currentUser= listUser.get(0);
				System.debug('currentUser'+currentUser);
				String nameProfile = '%'+currentUser.Profile.name+'%';
				System.debug('nameProfile'+nameProfile);
				List<OB_ConfigurationInformation__mdt> listcustomMtd = [SELECT OB_String_Value__c,OB_String_Value_2__c 
																		FROM OB_ConfigurationInformation__mdt 
																		WHERE (QualifiedApiName = 'OB_ReportMultiCab' 
																		OR 	QualifiedApiName = 	'OB_ReportABIOnly' 
																		OR QualifiedApiName =  'OB_ReportABIOneCAB' )
																		AND OB_String_Value__c LIKE :nameProfile   LIMIT 1];
																		
				System.debug('listcustomMtd'+listcustomMtd);
				if(!listcustomMtd.isEmpty()){
					OB_ConfigurationInformation__mdt currentMeta= listcustomMtd.get(0);					
					typeFilters = currentMeta.OB_String_Value_2__c;
				}
									
				System.debug('columns'+typeFilters);
				toReturn.put('user',currentUser);
				toReturn.put('fields',typeFilters);
			}
			return toReturn;
			//END    simone.misani 25/03/2019 - R1F2_RP_014 - Use CustomMetadata for controll 
		}
		catch(exception e)
		{
            System.debug('Exception in OB_NewReportOperationController.getFieldUserLogged at line ' + e.getLineNumber() + '. Message: ' + e.getMessage());
			return null;
		} 
	}

	@AuraEnabled
	public static string getBaseURl(){
		
		
		String StringaUrl = OB_ContinuationController.getVFBaseURL();
		return StringaUrl;

	  
	}

	@AuraEnabled
	public static String getFilteredReport(String reportId, String listFilters){
		String filtersStr = listfilters;
		
		System.debug('getFilteredReport Method'+reportId); 
		System.debug('getFilteredReport lista'+listFilters);  
		try{
			List<OB_FilterWrapper> filters =(List<OB_FilterWrapper>) OB_FilterWrapper.parse(filtersStr);

			System.debug('FilterWrapper ----> '+filters); // DD.....02/01/2019
			Reports.ReportResults results = Reports.ReportManager.runReport(reportId);
			Reports.ReportMetadata rm = results.getReportMetadata();
			List<Reports.ReportFilter> myFilters = new List<Reports.ReportFilter>();
			for (OB_FilterWrapper filter : filters){
				if(filter.value != ''){
					Reports.ReportFilter filterReport = new Reports.ReportFilter(filter.column, 'equals', filter.value);
					myFilters.add(filterReport);
				}
			}
			
			rm.setReportFilters(myFilters);

			System.debug('Filters: ' + rm.getReportFilters());
			Reports.ReportResults resultsLater = Reports.ReportManager.runReport(reportId, rm, true);
			System.debug('ecco: ' + JSON.serialize(resultsLater));
			return JSON.serialize(resultsLater);
		}
		catch(exception e){
			System.debug('Error: '+e.getMessage());
			return e.getMessage();
		}

	}

	@AuraEnabled
	public static String getDescribeReport(String reportId){
		
		return JSON.serialize(Reports.ReportManager.describeReport(reportId));
		
	}
	/* simone.misani@accenture.com
	15/04/2019 
	add filter report  and use three custom metadata for Current report.*/

	@AuraEnabled
	public static Map<String,String> getCurrentReport(String reportId){
		 
		Map<String,String> toReturn = new Map<String,String>();
		List<Report> nameReport =[SELECT DeveloperName FROM Report where Id=: reportId LIMIT 1];

		Report devNameReport = nameReport.get(0);

		List<OB_ConfigurationInformation__mdt> reportMeta = [	SELECT OB_String_Value_2__c 
		 														FROM OB_ConfigurationInformation__mdt 
																WHERE QualifiedApiName LIKE 'OB_Report%' AND 	OB_String_Value__c=:devNameReport.DeveloperName];
		
		if(!reportMeta.isEmpty()){
			OB_ConfigurationInformation__mdt StringValueReport = reportMeta.get(0);
			system.debug('StringValueReport: '+StringValueReport.OB_String_Value_2__c);
			String value2  = StringValueReport.OB_String_Value_2__c;
			if(value2.contains(';')){
				String[] splitValue = value2.split(';');
				String splitAbi = splitValue[0];
				String [] filedAbi = splitAbi.split('-');			
				toReturn.put(filedAbi[0],filedAbi[1]);
				String splitCab = splitValue[1];				
				String [] filedCab = splitCab.split('-');		
				toReturn.put(filedAbi[0],filedAbi[1]);
				toReturn.put(filedCab[0],filedCab[1]);
			}
			else{
				String [] splitAbi = value2.split('-');
				toReturn.put(splitAbi[0],splitAbi[1]);
				toreturn.put('CAB',null);

			}
		
		}
		return toreturn; 		

		
	}
	

}