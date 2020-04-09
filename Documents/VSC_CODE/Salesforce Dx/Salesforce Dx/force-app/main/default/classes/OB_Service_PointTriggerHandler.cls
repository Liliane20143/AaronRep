/*
--------------------------   						MORITTU ANDREA: Trigger on Service point. 							----------------------------
-------------------------- 		NB. CotnainsOnly method match if chars are present in a string. If not, run an error.  	----------------------------
*/

public without sharing class OB_Service_PointTriggerHandler {
 
 	String space = ' ';
 	String quote =  '\'';
 	
 	//	START 	micol.ferrari 23/11/2018
	//public String userId = Userinfo.getuserid();
	//public list<User> listOfUsers = [SELECT id, contactId , contact.accountId, Profile.UserLicense.Name, OB_CAB__C, OB_ABI__c
	//						FROM User
	//						WHERE Id =: userId
	//						LIMIT 1];
	//	END 	micol.ferrari 23/11/2018

	/* ------------------------------------------------------------------------------------------------------------------------------ 		*/
	/*USER COULD INSERT THESE SPECIAL CHAR : (	)	”	?	!	&	% 	$	£  	=	^ 	°	\ 	/	AlphabeticChars and Numeric Chars    	*/
	/* -----------------------------------------------------------------------------------------------------------------------------	 	*/
	public String acceptedSpecialChar = OB_UtilityConstants.ACCEPTEDSPECIALCHAR;
						 
	public void setInvalidNameOnServicePointName(List<NE__Service_Point__c> Spoints, List<NE__Service_Point__c> oldSPoints){

		//	START 	micol.ferrari 23/11/2018
		Boolean userSkipValidation = false;
		if (!Spoints.isEmpty())
		{
			userSkipValidation = Spoints.get(0).OB_UserSkipValidation__c;
		}
		//	END 	micol.ferrari 23/11/2018	
	 	
	 	if (!userSkipValidation)
		{
		 	System.debug('@@@ IM IN THE METHOD ');
		 	//if(currentUser.OB_CAB__c != 'SKIP'){
		 		Map<Id, NE__Service_Point__c> mapOfOldSP = new Map<Id, NE__Service_Point__c>();
		 		if (null!=oldSPoints && !oldSPoints.isEmpty()) {
		    		for(NE__Service_Point__c oldSP : oldSPoints){
		    			mapOfOldSP.put(oldSP.Id, oldSP);
		    			System.debug('mapOfOldSP ' + mapOfOldSP);
		    		}
			 		for(NE__Service_Point__c SP : Spoints){
				 		try {
							if(SP.OB_BypassValidation__c == false ) {
								Boolean enableValidation 	= !mapOfOldSP.containsKey(SP.Id) || (mapOfOldSP.containsKey(SP.Id) && mapOfOldSP.get(SP.Id).OB_BypassValidation__c==SP.OB_BypassValidation__c);
	 							Boolean enableUpdate 		= !mapOfOldSP.containsKey(SP.Id) || (mapOfOldSP.containsKey(SP.Id) && mapOfOldSP.get(SP.Id).Name!=SP.Name);
								String SPName = SP.Name;
								SPName = SPName.toLowerCase();
								if(enableValidation && enableUpdate){
							 		if(String.isNotBlank(SPName)) {
										// The name must not contain accented char!
							 			if(!SPName.containsOnly(acceptedSpecialChar) ) { 
						 					System.debug('Error has occured with special chars!');
						 					SP.Name.addError(Label.OB_InvalidAccountName);
						 				}
						 			} 
								}
				 			}
						} catch(DmlException exc) {
								System.debug('[EXCE] OB_AccountTriggerHandler.setInvalidNameOnAccount - The following exception has occurred: ' + exc.getMessage());
						}
				 	}
				}
		 	//}
		 }
	}
			
	public void setInvalidServicePointName(List<NE__Service_Point__c> Spoints, List<NE__Service_Point__c> oldSPoints){
		//	START 	micol.ferrari 23/11/2018
		Boolean userSkipValidation = false;
		if (!Spoints.isEmpty())
		{
			userSkipValidation = Spoints.get(0).OB_UserSkipValidation__c;
		}
		//	END 	micol.ferrari 23/11/2018

		if (!userSkipValidation)
		{
			System.debug('@@@ IM IN THE METHOD ');
		 	//if(currentUser.OB_CAB__c != 'SKIP'){
		 		Map<Id, NE__Service_Point__c> mapOfOldSP = new Map<Id, NE__Service_Point__c>();
		 		if (null!=oldSPoints && !oldSPoints.isEmpty()) {
		    		for(NE__Service_Point__c oldSP : oldSPoints){
		    			mapOfOldSP.put(oldSP.Id, oldSP);
		    		}
		    		
			 		for(NE__Service_Point__c SP : Spoints){
				 		try {
				 			String servicePointName = SP.OB_Service_Point_Name__c;
							if(SP.OB_BypassValidation__c == false ) {
								Boolean enableValidation 	= !mapOfOldSP.containsKey(SP.Id) || (mapOfOldSP.containsKey(SP.Id) && mapOfOldSP.get(SP.Id).OB_BypassValidation__c==SP.OB_BypassValidation__c);
	 							Boolean enableUpdate 		= !mapOfOldSP.containsKey(SP.Id) || (mapOfOldSP.containsKey(SP.Id) && mapOfOldSP.get(SP.Id).Name!=SP.Name);
	 							if(enableValidation && enableUpdate){
									if(!String.isEmpty(servicePointName)){
										servicePointName= servicePointName.toLowerCase();
										//IF SERVICEPOINTNAME DOES NOT CONTAIN ANY ACCEPTED CHARS, LAUNCH AN ERROR!
						 				if(!servicePointName.containsOnly(acceptedSpecialChar) ) { 
								 			SP.OB_Service_Point_Name__c.addError(Label.OB_InvalidAccountName);
							 			}
						 			}
	 							}
							}
						} catch(DmlException exc) {
								System.debug('[EXCE] OB_AccountTriggerHandler.setInvalidNameOnAccount - The following exception has occurred: ' + exc.getMessage());
						}
				 	}
				}
		 	//}
		}
	}

	//	START 	micol.ferrari 27/11/2018
	public void setOBStatusServicePoint(List<NE__Service_Point__c> listOfNewSP, List<NE__Service_Point__c> listOfOldSP)
	{
		for (NE__Service_Point__c currentSP : listOfNewSP)
		{
			//	ROLLBACK
			//	START 	micol.ferrari 14/01/2018 - NS_07
			//if (currentSP.NE__Status__c!=null && currentSP.NE__Status__c!='')
			//{
			//	currentSP.OB_Status__c = currentSP.NE__Status__c;
			//}
			//else
			//{
			//	currentSP.OB_Status__c = OB_UtilityConstants.STATUS_PROSPECT;
			//}
			//	END 	micol.ferrari 14/01/2018 - NS_07

			//	START 	micol.ferrari 16/01/2018
			if (currentSP.OB_Status__c==null || currentSP.OB_Status__c=='')
			{
				currentSP.OB_Status__c = OB_UtilityConstants.STATUS_PROSPECT;
			}
			//	END 	micol.ferrari 16/01/2018
		}
	}
	//	END 	micol.ferrari 27/11/2018

	/*
		@Author	:	Morittu Andrea	 
		@Date	:	2019.05.15
		@Task	:	Fix R1F2-47 - Adding logic on seasonal Input
	*/
	public void checkCoherencyWithSeasonalInput(List<NE__Service_Point__c> Spoints, List<NE__Service_Point__c> oldSPoints) {

		//	START 	micol.ferrari 23/11/2018
		Boolean userSkipValidation = false;
		if (!Spoints.isEmpty()) {
			userSkipValidation = Spoints.get(0).OB_UserSkipValidation__c;
		}
	 	if (!userSkipValidation) {
			Map<Id, NE__Service_Point__c> mapOfOldSP = new Map<Id, NE__Service_Point__c>();
			System.debug('oldSPoints: ' + oldSPoints);
			if (null!=oldSPoints && !oldSPoints.isEmpty()) {
				for(NE__Service_Point__c oldSP : oldSPoints){
					mapOfOldSP.put(oldSP.Id, oldSP);
				}
				for(NE__Service_Point__c SP : Spoints){
					try {
						if(SP.OB_BypassValidation__c == false ) {
							String startSeasonalSP 		= SP.OB_Start_Seasonal__c;
							String endSeasonalSP 		= SP.OB_End_Seasonal__c;

							Boolean enableValidation 	= 	!mapOfOldSP.containsKey(SP.Id) || (mapOfOldSP.containsKey(SP.Id) && mapOfOldSP.get(SP.Id).OB_BypassValidation__c==SP.OB_BypassValidation__c);
							Boolean enableUpdate 		= 	!mapOfOldSP.containsKey(SP.Id) || 	((mapOfOldSP.containsKey(SP.Id))  && (mapOfOldSP.get(SP.Id).OB_Start_Seasonal__c!=SP.OB_Start_Seasonal__c) ||
																								(mapOfOldSP.get(SP.Id).OB_End_Seasonal__c!=SP.OB_End_Seasonal__c) );
							System.debug('## enableValidation is: ' + enableValidation);
							System.debug('enableUpdate is : ' + enableUpdate);
							
							if(enableValidation && enableUpdate){
								if(String.isBlank(startSeasonalSP) && !String.isBlank(endSeasonalSP) ) {
									SP.OB_Start_Seasonal__c.addError(Label.MandatoryField);
								} else if( !String.isBlank(startSeasonalSP) && String.isBlank(endSeasonalSP) ) {
									SP.OB_End_Seasonal__c.addError(Label.MandatoryField);
								} 
							}
						}
					} catch(DmlException exc) {
						System.debug('[EXCE] OB_Service_PointTriggerHandler.checkCoherencyWithSeasonalInput - The following exception has occurred: ' + exc.getMessage());
					}
				}
			}
		}
	}
	/*
		@Author		:	Morittu Andrea	
				   END 
		*/
	/*
	* Author : Giovanni Spinelli
	* Date : 23/07/2019
	* Description : Method to convert some fields to uppercase.
	*   Input : list new objects and old object
	*   Output : -
	*   Note: 	this method is called from triggers class
	*/
	public  void uppercaseFieldsConversion(List<NE__Service_Point__c> newSP, List<NE__Service_Point__c> oldSP ,String status){
		try{
			System.debug('uppercaseFieldsConversion');
			System.debug('status: ' + status);
			
			System.debug('newSP: ' + newSP);
			System.debug('oldSP: ' + oldSP);
			Boolean userSkipValidation = false;
			if (!newSP.isEmpty())
			{
				userSkipValidation = newSP.get(0).OB_UserSkipValidation__c;
			}
			if(!userSkipValidation){
				List<String> fieldsListToUppercase = new List<String>{'Name' , 'OB_Street_Number__c','OB_AlternativeAddress__c','OB_Address_Detail__c'};
				if(status=='isUpdate'){
					System.debug('into update method uppercase');
					OB_Utility.toUppercaseUpdate(newSP , oldSP , fieldsListToUppercase);
				}
				if(status=='isInsert'){
					System.debug('into insert method uppercase');
					OB_Utility.toUppercaseInsert(newSP , fieldsListToUppercase);
				}
			}
		}catch(Exception ecc){
			System.debug(logginglevel.ERROR , 'Generic Error servicepoint trigger handler: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
		}
	}
    
}