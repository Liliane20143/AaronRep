/*
Andrea Morittu -- 22/10/2018 
Trigger Handler
*/
global without sharing class OB_AccountTriggerHandler {
	
	//	START 	micol.ferrari 23/11/2018
	//public String userId = Userinfo.getuserid();
	//public list<User> listOfUsers = [SELECT id, contactId , contact.accountId, Profile.UserLicense.Name, OB_CAB__C, OB_ABI__c
	//						FROM User
	//						WHERE Id =: userId
	//						LIMIT 1];
	//	END 	micol.ferrari 23/11/2018		  
							
	public String acceptedSpecialChar = OB_UtilityConstants.ACCEPTEDSPECIALCHAR;
	
	/* ------------------------------------------------------------------------------------------------------------------------------ 		*/
	/*USER COULD INSERT THESE SPECIAL CHAR : (	)	”	?	!	&	% 	$	£  	=	^ 	°	\ 	/	AlphabeticChars and Numeric Chars    	*/
	/* -----------------------------------------------------------------------------------------------------------------------------	 	*/
					 
	global void setInvalidNameOnAccount(List<Account> accs, List<Account> oldAccs){
		
		//	START 	micol.ferrari 23/11/2018
		Boolean userSkipValidation = false;
		if (!accs.isEmpty())
		{
			userSkipValidation = accs.get(0).OB_UserSkipValidation__c;
		}
		//	END 	micol.ferrari 23/11/2018	
		if (!userSkipValidation)
		{
			System.debug('@@@ IM IN THE MEHOD OF VALIDATE NAME ');
			//if(listOfUsers.isEmpty() || (!listOfUsers.isEmpty() && listOfUsers.get(0).OB_CAB__c != 'SKIP')){
				Map<Id, Account> mapOfOldAcc = new Map<Id, Account>();
				if (null!=oldAccs && !oldAccs.isEmpty()) {
					for(Account oldAcc : oldAccs){
						mapOfOldAcc.put(oldAcc.Id, oldAcc);
						System.debug('mapOfOldAcc ' + mapOfOldAcc);
					}
				}
			
				for(Account acc : accs){
					System.debug('OB_BypassValidation__c '+acc.OB_BypassValidation__c);
					try {
						String name = acc.Name;
						if(acc.OB_BypassValidation__c == false && acc.OB_RecordType__c.equalsIgnoreCase(OB_UtilityConstants.ACC_RT_MERCHANT)) {
							System.debug('acc.OB_BypassValidation__c is ' + acc.OB_BypassValidation__c);
							Boolean enableValidation 	= !mapOfOldAcc.containsKey(acc.Id) || (mapOfOldAcc.containsKey(acc.Id) && mapOfOldAcc.get(acc.Id).OB_BypassValidation__c==acc.OB_BypassValidation__c);
							Boolean enableUpdate 		= !mapOfOldAcc.containsKey(acc.Id) || (mapOfOldAcc.containsKey(acc.Id) && mapOfOldAcc.get(acc.Id).Name!=acc.Name);
							
							if(!String.isEmpty(name)) {
								// LOOP OF SPECIAL CHARS ACCEPTED
								name = name.toLowerCase();
								/* IF THERE'S NOT A LETTER; A NUMBER, A SPACE OR IF NOT CONTAINS ACCEPTED SPECIAL CHARS --> ERROR!*/
								if(!name.containsOnly(acceptedSpecialChar)) {
									acc.Name.addError(Label.OB_PresenceOfAnInvalidCharacter);
									break; 
								}
							}
						}
					} catch(DmlException exc) {
						System.debug('[EXCE] OB_AccountTriggerHandler.setInvalidNameOnAccount - The following exception has occurred: ' + exc.getMessage());
					}
				}
			//}
		}
	}				 			
											

	
	global void setInvalidCCIAA(List<Account> accs, List<Account> oldAccs){
		
		//	START 	micol.ferrari 23/11/2018
		Boolean userSkipValidation = false;
		if (!accs.isEmpty())
		{
			userSkipValidation = accs.get(0).OB_UserSkipValidation__c;
		}
		//	END 	micol.ferrari 23/11/2018	

		if (!userSkipValidation)
		{
			//if(listOfUsers.isEmpty() || (!listOfUsers.isEmpty() && listOfUsers.get(0).OB_CAB__c != 'SKIP')){
				Map<Id, Account> mapOfOldAcc = new Map<Id, Account>();
				if (null!=oldAccs && !oldAccs.isEmpty()){
					for(Account oldAcc : oldAccs){
						mapOfOldAcc.put(oldAcc.Id, oldAcc);
					}
				}
				for(Account acc : accs){
					System.debug('OB_BypassValidation__c '+acc.OB_BypassValidation__c);
					
					try {
						if(acc.OB_BypassValidation__c == false && acc.OB_RecordType__c.equalsIgnoreCase(OB_UtilityConstants.ACC_RT_MERCHANT)) {
							Boolean insertionScenario 		= !mapOfOldAcc.containsKey(acc.Id) || (mapOfOldAcc.containsKey(acc.Id) && mapOfOldAcc.get(acc.Id).OB_BypassValidation__c==acc.OB_BypassValidation__c);
							Boolean updateScenario	= 		  !mapOfOldAcc.containsKey(acc.Id) || (mapOfOldAcc.containsKey(acc.Id) && mapOfOldAcc.get(acc.Id).OB_CCIAA__c !=acc.OB_CCIAA__c && acc.OB_CCIAA__c != mapOfOldAcc.get(acc.Id).OB_CCIAA__c);
							
							String accCCIAA = acc.OB_CCIAA__c ;
							if(!(String.isBlank(accCCIAA))){
								accCCIAA = accCCIAA.toLowerCase();
							/* IF THERE'S NOT A LETTER; A NUMBER, A SPACE OR IF NOT CONTAINS ACCEPTED SPECIAL CHARS --> ERROR!*/
								if(!accCCIAA.containsOnly(acceptedSpecialChar)){
									acc.OB_CCIAA__c.addError(Label.OB_PresenceOfAnInvalidCharacter);
									break; 
								}
							}
						}
					} catch(DmlException exc) {
							System.debug('[EXCE] OB_AccountTriggerHandler.setInvalidCCIAA - The following exception has occurred: ' + exc.getMessage());
					}
				 }
				
			//}
		}
	}

	//	START 	micol.ferrari 16/11/2018
	global void setAccountNumberWithABI(List<Account> listOfNewAccount, List<Account> listOfOldAccount)
	{
		for (Account currentAccount : listOfNewAccount)
		{
			if (currentAccount.OB_ABI__c!=null)
			{
				currentAccount.AccountNumber = currentAccount.OB_ABI__c;
			}
		}
	}
	//	END 	micol.ferrari 16/11/2018
	
	//	START 	andrea.morittu 26/11/2018
	global void setLogicForRecordType(Map<Id,Account> mapNewAccounts,Map<Id,Account> mapOldAccounts){
		//	DO SOMETHING
		Boolean doSomething = false;

		//	FINAL LIST TO UPDATE
		List<Account> toUpdate 						= new List<Account>();
		
		//	LOGIC MASTER MERCHANT AND GROUP TO BE ACTIVE
		List<Id> listOfMasterMerchantsToActive 		= new List<Id>();
		List<Id> listOfGroupsToActive				= new List<Id>();
		
		//	LOGIC MASTER MERCHANT AND GROUP TO BE INACTIVE
		List<Id> listOfMasterMerchantsToInactive 	= new List<Id>();
		List<Id> listOfGroupsToInactive			 	= new List<Id>();

		//	LOGIC HOLDING TO BE ACTIVE
		List<Id> listOfHoldingToActive				= new List<Id>();
		//	LOGIC HOLDING TO BE INACTIVE
		List<Id> listOfHoldingToInactive			= new List<Id>();
		
		//	LOOP ON NEW ACCOUNTS
		for(Account newAccount : mapNewAccounts.values()){
			//	MERCHANT
			if( newAccount.OB_RecordType__c == OB_UtilityConstants.ACC_RT_MERCHANT){
				//	MERCHANT FROM PROSPECT/INACTIVE TO ACTIVE
				if (mapOldAccounts.get(newAccount.Id).OB_Status__c != OB_UtilityConstants.STATUS_ACTIVE 
				&& mapNewAccounts.get(newAccount.Id).OB_Status__c == OB_UtilityConstants.STATUS_ACTIVE) {
					//	RETRIEVE PARENT MASTERMERCHANTS
					if (mapNewAccounts.get(newAccount.Id).OB_Master_Merchant_ID__c!=null){
						listOfMasterMerchantsToActive.add(mapNewAccounts.get(newAccount.Id).OB_Master_Merchant_ID__c);
						doSomething = true;
					}
					//	RETRIEVE PARENT GROUPS
					if (mapNewAccounts.get(newAccount.Id).ParentId!=null){
						listOfGroupsToActive.add(mapNewAccounts.get(newAccount.Id).ParentId);
						doSomething = true;
					}
				//	MERCHANT FROM ACTIVE TO INACTIVE
				} else if(mapOldAccounts.get(newAccount.Id).OB_Status__c == OB_UtilityConstants.STATUS_ACTIVE
				&& mapNewAccounts.get(newAccount.Id).OB_Status__c == OB_UtilityConstants.STATUS_INACTIVE){
					//	RETRIEVE PARENT MASTERMERCHANTS
					if (mapNewAccounts.get(newAccount.Id).OB_Master_Merchant_ID__c!=null){
						listOfMasterMerchantsToInactive.add(mapNewAccounts.get(newAccount.Id).OB_Master_Merchant_ID__c);
						doSomething = true;
					}
					//	RETRIEVE PARENT GROUPS
					if (mapNewAccounts.get(newAccount.Id).ParentId!=null){
						listOfGroupsToInactive.add(mapNewAccounts.get(newAccount.Id).ParentId);
						doSomething = true;
					}
				}
			//	GROUP
			}else if(newAccount.OB_RecordType__c == OB_UtilityConstants.ACC_RT_GROUP){
				//	GROUP FROM PROSPECT/INACTIVE TO ACTIVE
				if (mapOldAccounts.get(newAccount.Id).OB_Status__c != OB_UtilityConstants.STATUS_ACTIVE 
				&& mapNewAccounts.get(newAccount.Id).OB_Status__c == OB_UtilityConstants.STATUS_ACTIVE) {
					//	RETRIEVE PARENT HOLDING
					if (mapNewAccounts.get(newAccount.Id).ParentId!=null){
						listOfHoldingToActive.add(mapNewAccounts.get(newAccount.Id).ParentId);
						doSomething = true;
					}
				//	GROUP FROM ACTIVE TO INACTIVE
				}else if(mapOldAccounts.get(newAccount.Id).OB_Status__c == OB_UtilityConstants.STATUS_ACTIVE
				&& mapNewAccounts.get(newAccount.Id).OB_Status__c == OB_UtilityConstants.STATUS_INACTIVE){
					//	RETRIEVE PARENT HOLDING
					if (mapNewAccounts.get(newAccount.Id).ParentId!=null){
						listOfHoldingToInactive.add(mapNewAccounts.get(newAccount.Id).ParentId);
						doSomething = true;
					}
				}
			}
		}
		
		if (doSomething){
			//	LOGIC MASTER MERCHANT AND GROUP TO BE ACTIVE
			if (!listOfMasterMerchantsToActive.isEmpty() || !listOfGroupsToActive.isEmpty()){	
				List<Account> mastergroup = new List<Account>();
				mastergroup = [SELECT Id,RecordType.DeveloperName,OB_Status__c 
								FROM Account 
								WHERE ((Id IN: listOfMasterMerchantsToActive) 
								OR (Id IN: listOfGroupsToActive AND RecordType.DeveloperName = :OB_UtilityConstants.ACC_RT_GROUP))									
								AND OB_Status__c !=: OB_UtilityConstants.STATUS_ACTIVE];
				if(!mastergroup.isEmpty()){				
					for (Account currentAcc : mastergroup){
						currentAcc.OB_Status__c = OB_UtilityConstants.STATUS_ACTIVE;
						toUpdate.add(currentAcc);					
					}
				}
			}
			
			//	LOGIC MASTER MERCHANT AND GROUP TO BE INACTIVE
			if (!listOfMasterMerchantsToInactive.isEmpty() || !listOfGroupsToInactive.isEmpty()){	
				List<Account> mastergroup = new List<Account>();
				mastergroup = [SELECT Id,RecordType.DeveloperName,OB_Status__c,
										(SELECT Id,OB_Status__c FROM Anagrafiche__r WHERE RecordType.DeveloperName=:OB_UtilityConstants.ACC_RT_MERCHANT),
										(SELECT Id,OB_Status__c FROM ChildAccounts WHERE RecordType.DeveloperName=:OB_UtilityConstants.ACC_RT_MERCHANT)
								FROM Account
								WHERE ((Id IN: listOfMasterMerchantsToInactive) 
								OR (Id IN: listOfGroupsToInactive AND RecordType.DeveloperName = :OB_UtilityConstants.ACC_RT_GROUP))
								AND OB_Status__c =: OB_UtilityConstants.STATUS_ACTIVE];
				if(!mastergroup.isEmpty()){				
					for (Account currentAcc : mastergroup){
						//	CHECK IF ALL THE CHILDREN OF MASTER MERCHANT ARE INACTIVE
						if (currentAcc.RecordType.DeveloperName==OB_UtilityConstants.ACC_RT_MASTERMERCHANT){
							if (!currentAcc.Anagrafiche__r.isEmpty()){
								Boolean allInactive = true;
								for (Account merch : currentAcc.Anagrafiche__r){
									if (merch.OB_Status__c!=OB_UtilityConstants.STATUS_INACTIVE){
										allInactive = false;
									}
								}
								if (allInactive){
									currentAcc.OB_Status__c = OB_UtilityConstants.STATUS_INACTIVE;
									toUpdate.add(currentAcc);
								}
							}
						}
						//	CHECK IF ALL THE CHILDREN OF GROUP ARE INACTIVE
						if (currentAcc.RecordType.DeveloperName==OB_UtilityConstants.ACC_RT_GROUP){
							if (!currentAcc.ChildAccounts.isEmpty()){
								Boolean allInactive = true;
								for (Account merch : currentAcc.ChildAccounts){
									if (merch.OB_Status__c!=OB_UtilityConstants.STATUS_INACTIVE){
										allInactive = false;
									}
								}
								if (allInactive){
									currentAcc.OB_Status__c = OB_UtilityConstants.STATUS_INACTIVE;
									toUpdate.add(currentAcc);
								}
							}
						}
					}
				}
			}

			//	LOGIC HOLDING TO BE ACTIVE
			if (!listOfHoldingToActive.isEmpty()){														
				List<Account> holdings = new List<Account>();
				holdings = [SELECT Id,RecordType.DeveloperName,OB_Status__c 
							FROM Account 
							WHERE (Id IN: listOfHoldingToActive AND RecordType.DeveloperName = :OB_UtilityConstants.ACC_RT_HOLDING)									
							AND OB_Status__c !=: OB_UtilityConstants.STATUS_ACTIVE];
				if(!holdings.isEmpty()){				
					for (Account currentAcc : holdings){
						currentAcc.OB_Status__c = OB_UtilityConstants.STATUS_ACTIVE;
						toUpdate.add(currentAcc);					
					}
				}
			}
			//	LOGIC HOLDING TO BE INACTIVE
			if (!listOfHoldingToInactive.isEmpty()){	
				List<Account> holdings = new List<Account>();
				holdings = [SELECT Id,RecordType.DeveloperName,OB_Status__c,
								(SELECT Id,OB_Status__c FROM ChildAccounts WHERE RecordType.DeveloperName=:OB_UtilityConstants.ACC_RT_GROUP)
							FROM Account 
							WHERE (Id IN: listOfHoldingToInactive AND RecordType.DeveloperName = :OB_UtilityConstants.ACC_RT_HOLDING)									
							AND OB_Status__c =: OB_UtilityConstants.STATUS_ACTIVE];
				if(!holdings.isEmpty()){	
					for (Account currentAcc : holdings){
						//	CHECK IF ALL THE CHILDREN OF HOLDING ARE INACTIVE
						if (!currentAcc.ChildAccounts.isEmpty()){
							Boolean allInactive = true;
							for (Account merch : currentAcc.ChildAccounts){
								if (merch.OB_Status__c!=OB_UtilityConstants.STATUS_INACTIVE){
									allInactive = false;
								}
							}
							if (allInactive){
								currentAcc.OB_Status__c = OB_UtilityConstants.STATUS_INACTIVE;
								toUpdate.add(currentAcc);
							}
						}
					}
				}
			}

			//	FINAL LIST TO UPDATE (PASSING FROM A SET, TO REMOVE THE DUPLICATES)
			if(!toUpdate.isEmpty()){
				Set<Account> setOfAccounts 	= new Set<Account>();
				setOfAccounts.addAll(toUpdate);
				toUpdate 					= new List<Account>();
				toUpdate.addAll(setOfAccounts);
				update toUpdate;
			}
		}
	}
	//	END 	andrea.morittu 26/11/2018

	//	START 	micol.ferrari 27/11/2018
	global void setOBStatusAccount(List<Account> listOfNewAccount, List<Account> listOfOldAccount)
	{
		for (Account currentAccount : listOfNewAccount)
		{
			if (currentAccount.OB_RecordType__c.equalsIgnoreCase(OB_UtilityConstants.ACC_RT_BANK) || currentAccount.OB_RecordType__c.equalsIgnoreCase(OB_UtilityConstants.ACC_RT_BANKGROUP))
			{
				currentAccount.OB_Status__c = OB_UtilityConstants.STATUS_ACTIVE;
			}
			else
			{
				//	START 	micol.ferrari 14/01/2018 - NS_07
				if (currentAccount.NE__Status__c!=null && currentAccount.NE__Status__c!='')
				{
					currentAccount.OB_Status__c = currentAccount.NE__Status__c;
				}
				else
				{
					currentAccount.OB_Status__c = OB_UtilityConstants.STATUS_PROSPECT;
				}
				//	END 	micol.ferrari 14/01/2018 - NS_07	
			}
		}
	}
	//	END 	micol.ferrari 27/11/2018

	/*
	* Author : Giovanni Spinelli
	* Date : 23/07/2019
	* Description : Method to convert some fields to uppercase.
	*   Input : list new objects and old object
	*   Output : -
	*   Note: 	this method is called from triggers class
	*/
	
	public  void uppercaseFieldsConversion(List<Account> newAcc, List<Account> oldAcc ,String status){
		try{
			System.debug('uppercaseFieldsConversion merchant');
			System.debug('status: ' + status);
			System.debug('newAcc: ' + newAcc);
			System.debug('oldAcc: ' + oldAcc);
			/*
			create two list to copy the trigger.new and trigger.old
			because I can't remove record from these
			*/
			List<Account> newAccCopy = new List<Account> ();
			List<Account> oldAccCopy = new List<Account> ();
			// newAccCopy.addAll(newAcc) ;
			// if(status == 'isUpdate'){
			// 	oldAccCopy.addAll(oldAcc);
			// }
			
			// System.debug('newAccCopy: ' + newAccCopy);
			// System.debug('oldAccCopy: ' + oldAccCopy);
			/*
			creation of a method that takes only the recordtypes of some objects on which to do uppercase
			*/
			Map<String , String> developerNameMap = new Map<String , String>();
			/*
			list of developer name used to check records
			*/
			List<String> availabeDeveloperName = new List<String>{OB_UtilityConstants.MERCHANTRT};
			/*
			list of recordtypeId from previous list
			*/
			List<RecordType> recordTypeList = [SELECT Id, Name, DeveloperName FROM RecordType WHERE DeveloperName IN:availabeDeveloperName AND SobjectType ='Account'];

			System.debug('recordTypeList: ' + recordTypeList);
			for(RecordType rt : recordTypeList){
				developerNameMap.put(String.valueOf(rt.Id) , rt.DeveloperName );
			}
			System.debug('developerNameMap: ' + developerNameMap);
			for(Integer i=0; i<newAcc.size(); i++){
				Account  singleAccNew = newAcc.get(i);
				Account  singleAccOld = new Account();
				if(status == 'isUpdate'){
					oldAcc.get(i);
				}
				System.debug('singleAccNew: ' + singleAccNew);
				String recordtypeId = singleAccNew.RecordTypeId;
				if(developerNameMap.containsKey(recordtypeId)){
					/*
					add  records that  have the appropriate recordtype from both the old and the new list
					*/
					newAccCopy.add(singleAccNew);
					if(status == 'isUpdate'){
						oldAccCopy.add(singleAccOld);
					}
				}
			}
			System.debug('newAccCopy after add: ' + newAccCopy);
			System.debug('oldAccCopy after add: ' + oldAccCopy);
			/*
			skip validations by reading a field on the object that depends on who is doing inserts and updates (migration or other)
			*/
			Boolean userSkipValidation = false;
			if (!newAccCopy.isEmpty())
			{
				userSkipValidation = newAccCopy.get(0).OB_UserSkipValidation__c;
			}
			/*
			if validation is false, call method to do uppercase
			*/
			if(!userSkipValidation){
				List<String> fieldsListToUppercase = new List<String>{'Name','OB_No_Profit_Recipient_Other__c','OB_Administrative_Office_Street_number__c','OB_Legal_Address_Street_Number__c','OB_Administrative_Office_Address_Details__c','OB_Legal_Address_Country_Code__c'};
				if(status=='isUpdate'){
					System.debug('into update method uppercase');
					OB_Utility.toUppercaseUpdate(newAccCopy , oldAccCopy , fieldsListToUppercase);
				}
				if(status=='isInsert'){
					System.debug('into insert method uppercase');
					OB_Utility.toUppercaseInsert(newAccCopy , fieldsListToUppercase);
				}
			}
		}catch(Exception ecc){
			System.debug(logginglevel.ERROR , 'Generic Error validate: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
		}
		
	}
}