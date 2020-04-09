public with sharing class OB_Maintenance_Log_Request_Note_CC {
   
   @AuraEnabled
	public static OB_LogRequest__c retrieveLogRequest(Id logRequestId)
	{
		OB_LogRequest__c logRequestRetrived = new OB_LogRequest__c();
		try{
		List<OB_LogRequest__c> logrequests = [	SELECT 	Id,
														OB_Status__c,
														OB_Note__c
												FROM 	OB_LogRequest__c
												WHERE 	Id =:logRequestId	
												LIMIT 	1 ];
			if(!logrequests.isEmpty()){
					logRequestRetrived = logrequests.get(0);
					System.debug('LogRequest retrieved: ' + logRequestRetrived);
			} 
		}catch(Exception e){
             + e.getStackTraceString();
        }
		return logRequestRetrived;
	}

    @AuraEnabled
	public static String checkProfile(){
		String toReturn = '';
		String userId = UserInfo.getUserId();
		list<User> listOfUsers = [	SELECT 	Id, Profile.Name, Profile.UserLicense.Name
									FROM 	User
									WHERE 	Id =: userId
									LIMIT 	1	];
		if(!listOfUsers.isEmpty()){
			User user			= listOfUsers.get(0);
			String license 		= user.Profile.UserLicense.Name;
			String profile 		= user.Profile.Name;
			System.debug('license:  '+license);
			System.debug('profile:  '+profile);

			Boolean profileEnabled = false;
            Boolean profileReadOnly = false;
            String enabledProfiles = '';
            String readOnlyProfiles = '';
			OB_ConfigurationInformation__mdt confInfEnabled = new OB_ConfigurationInformation__mdt();
			OB_ConfigurationInformation__mdt[] listOfConfInfEnabled = [SELECT 	Id,
																				MasterLabel,
																				Label,
																				QualifiedApiName,
																				OB_String_Value__c
																				FROM 	OB_ConfigurationInformation__mdt 
																				WHERE 	QualifiedApiName =: 'OB_CheckProfileEnabledLogRequest'];
			
			OB_ConfigurationInformation__mdt confInfReadOnly = new OB_ConfigurationInformation__mdt();
            OB_ConfigurationInformation__mdt[] listOfConfInfReadOnly = [SELECT 	Id,
																				MasterLabel,
																				Label,
																				QualifiedApiName,
																				OB_String_Value__c
																				FROM 	OB_ConfigurationInformation__mdt 
																				WHERE 	QualifiedApiName =: 'OB_CheckProfilesReadOnlyLogRequest'];
            
            if(!listOfConfInfEnabled.isEmpty())
			{
				confInfEnabled = listOfConfInfEnabled.get(0);
				enabledProfiles = confInfEnabled.OB_String_Value__c;
				System.debug('enabledProfiles : ' +  enabledProfiles);
				profileEnabled = enabledProfiles.contains(profile);
				System.debug('profileEnabled : ' +  profileEnabled);

				if(profileEnabled == true)
				{
					toReturn = 'enabled';
				}
			}

            if(!listOfConfInfReadOnly.isEmpty())
			{
				confInfReadOnly = listOfConfInfReadOnly.get(0);
				readOnlyProfiles = confInfReadOnly.OB_String_Value__c;
				System.debug('readOnlyProfiles : ' +  readOnlyProfiles);
				profileReadOnly = readOnlyProfiles.contains(profile);
				System.debug('profileReadOnly : ' +  profileReadOnly);

				if(profileReadOnly == true)
				{
					toReturn = 'readOnly';
				}
			}
		}
		return toReturn;
	}

	@AuraEnabled
	public static boolean saveNotes(Id logRequestId, String notes){
		Boolean toReturn = false;
		try{
			OB_LogRequest__c logRequestRetrived = retrieveLogRequest(logRequestId);
			logRequestRetrived.OB_Note__c = notes;
			System.debug('logRequestRetrived : ' +  logRequestRetrived);
			toReturn = true;
			update logRequestRetrived;
		}catch(Exception exc){
        	System.debug('[EXCE] OB_Maintenance_Log_Request_Note_CC : saveNotes : '+ exc.getStackTraceString());
        }
		System.debug('toReturn : ' +  toReturn);
		return toReturn;
	}
}