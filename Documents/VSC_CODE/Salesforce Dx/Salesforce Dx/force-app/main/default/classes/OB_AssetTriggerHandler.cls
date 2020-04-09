global without sharing class OB_AssetTriggerHandler 
{
	//	START 	micol.ferrari	27/11/2018
	global static void merchantLifeCycle(Map<Id,Asset> mapNewAssets,Map<Id,Asset> mapOldAssets)
	{
		//	DO SOMETHING
		Boolean doSomething 	= false;

		//	FINAL LIST TO UPDATE
		List<Account> toUpdateAccounts 						= new List<Account>();
		List<NE__Service_Point__c> toUpdateServicePoints 	= new List<NE__Service_Point__c>();

		//	LOGIC MERCHANT TO BE ACTIVE
		List<Id> listOfMerchantsToActive 		= new List<Id>();
		//	LOGIC MERCHANT TO BE INACTIVE
		List<Id> listOfMerchantsToInactive 		= new List<Id>();

		//	LOGIC SERVICEPOINT TO BE ACTIVE
		List<Id> listOfServicePointsToActive 	= new List<Id>();
		//	LOGIC SERVICEPOINT TO BE INACTIVE
		List<Id> listOfServicePointsToInactive 	= new List<Id>();

		Set<Id> rootSet							= new Set<Id>() ; //enrico.purificato 23/10/2019 performance

		//	LOOP ON NEW ASSETS
		for(Asset newAsset : mapNewAssets.values())
		{
			//enrico.purificato 23/10/2019 performance start
			if(newAsset.OB_B2W_Session__c == mapOldAssets.get(newAsset.Id).OB_B2W_Session__c){
				if(newAsset.NE__Bundle_Configuration__c != null){
					rootSet.add(newAsset.NE__Bundle_Configuration__c);
				} else
				{
					rootSet.add(newAsset.Id);
				}
			}
			//enrico.purificato 23/10/2019 performance end
			
			//	ASSET TO ACTIVE
			if (mapOldAssets.get(newAsset.Id).NE__Status__c != OB_UtilityConstants.STATUS_ACTIVE 
			&& mapNewAssets.get(newAsset.Id).NE__Status__c == OB_UtilityConstants.STATUS_ACTIVE)
			{
				//	RETRIEVE PARENT MERCHANT
				if (mapNewAssets.get(newAsset.Id).AccountId!=null)
				{
					listOfMerchantsToActive.add(mapNewAssets.get(newAsset.Id).AccountId);
					doSomething = true;
				}
				//	RETRIEVE PARENT SERVICEPOINT
				if (mapNewAssets.get(newAsset.Id).NE__Service_Point__c!=null)
				{
					listOfServicePointsToActive.add(mapNewAssets.get(newAsset.Id).NE__Service_Point__c);
					doSomething = true;
				}
			}
			else if (mapOldAssets.get(newAsset.Id).NE__Status__c != OB_UtilityConstants.ASSET_STATUS_DISCONNECTED 
			&& mapNewAssets.get(newAsset.Id).NE__Status__c == OB_UtilityConstants.ASSET_STATUS_DISCONNECTED)
			{
				//	RETRIEVE PARENT MERCHANT
				if (mapNewAssets.get(newAsset.Id).AccountId!=null)
				{
					listOfMerchantsToInactive.add(mapNewAssets.get(newAsset.Id).AccountId);
					system.debug(listOfMerchantsToInactive.size());
					doSomething = true;
				}
				//	RETRIEVE PARENT SERVICEPOINT
				if (mapNewAssets.get(newAsset.Id).NE__Service_Point__c!=null)
				{
					listOfServicePointsToInactive.add(mapNewAssets.get(newAsset.Id).NE__Service_Point__c);
					system.debug(listOfServicePointsToInactive.size());
					doSomething = true;
				}
			}
		}
		
		//enrico.purificato 23/10/2019 performance start
		
		if(rootSet.size()>0)
		{
			Map<Id,Asset> rootMap = new Map<Id,Asset>([SELECT Id from Asset WHERE ID = :rootSet AND NE__Status__c = 'Active']);
			if(rootMap.keyset().size()>0){
				//Simone Misani Perf-8 05/12/2019 START
				try{
					Database.executeBatch(new OB_CreateSessionFromAsset(rootMap.keyset()));
				}catch(Exception exc){	
						System.debug('OB_AssetTriggerHandler Database.executeBatch(new OB_CreateSessionFromAsset' + exc.getLineNumber()+ ' ' + exc.getMessage());
				}
				//Simone Misani Perf-8 05/12/2019 END
			}
			
		}
		//enrico.purificato 23/10/2019 performance start

		if (doSomething)
		{
			//	LOGIC ACTIVE
			//	LOGIC MERCHANT TO BE ACTIVE
			if (!listOfMerchantsToActive.isEmpty())
			{														
				List<Account> merchants = new List<Account>();
				merchants = [SELECT Id,RecordType.DeveloperName,OB_Status__c,OB_Year_constitution_company__c 
							FROM Account 
							WHERE Id IN: listOfMerchantsToActive AND RecordType.DeveloperName =: OB_UtilityConstants.ACC_RT_MERCHANT								
							AND OB_Status__c !=: OB_UtilityConstants.STATUS_ACTIVE];
				if(!merchants.isEmpty())
				{				
					for (Account currentAcc : merchants)
					{
						currentAcc.OB_Status__c = OB_UtilityConstants.STATUS_ACTIVE;
						currentAcc.OB_BypassValidation__c = true;
						currentAcc.OB_Year_constitution_company__c = currentAcc.OB_Year_constitution_company__c == 0 ? null : currentAcc.OB_Year_constitution_company__c;
						toUpdateAccounts.add(currentAcc);					
					}
				}
			}

			//	LOGIC SERVICEPOINT TO BE ACTIVE
			if (!listOfServicePointsToActive.isEmpty())
			{														
				List<NE__Service_Point__c> servicepoints = new List<NE__Service_Point__c>();
				servicepoints = [SELECT Id,RecordType.DeveloperName,OB_Status__c
								FROM NE__Service_Point__c 
								WHERE Id IN: listOfServicePointsToActive								
								AND OB_Status__c !=: OB_UtilityConstants.STATUS_ACTIVE];
				if(!servicepoints.isEmpty())
				{				
					for (NE__Service_Point__c currentSP : servicepoints)
					{
						currentSP.OB_Status__c = OB_UtilityConstants.STATUS_ACTIVE;
						currentSP.OB_BypassValidation__c = true;
						toUpdateServicePoints.add(currentSP);					
					}
				}
			}

			//	LOGIC INACTIVE
			//	LOGIC MERCHANT TO BE INACTIVE
			if (!listOfMerchantsToInactive.isEmpty())
			{
				List<Account> merchants = new List<Account>();
				merchants = [SELECT Id,RecordType.DeveloperName,OB_Status__c,
										(SELECT Id,NE__Status__c FROM Assets)
								FROM Account
								WHERE Id IN: listOfMerchantsToInactive AND RecordType.DeveloperName =: OB_UtilityConstants.ACC_RT_MERCHANT
								AND OB_Status__c =: OB_UtilityConstants.STATUS_ACTIVE];
				if(!merchants.isEmpty())
				{
					for (Account currentAcc : merchants)
					{
						//	CHECK IF ALL THE CHILDREN ASSET OF MERCHANT ARE DISCONNECTED
						if (!currentAcc.Assets.isEmpty())
						{
							Boolean allDisconnected = true;
							for (Asset currentAsset : currentAcc.Assets)
							{
								if (currentAsset.NE__Status__c!=OB_UtilityConstants.ASSET_STATUS_DISCONNECTED)
								{
									allDisconnected = false;
								}
							}
							if (allDisconnected)
							{
								currentAcc.OB_Status__c = OB_UtilityConstants.STATUS_INACTIVE;
								currentAcc.OB_BypassValidation__c = true;
								currentAcc.OB_Year_constitution_company__c = currentAcc.OB_Year_constitution_company__c == 0 ? null : currentAcc.OB_Year_constitution_company__c;
								toUpdateAccounts.add(currentAcc);
							}
						}
					}
				}			
			}

			//	LOGIC SERVICEPOINT TO BE INACTIVE
			if (!listOfServicePointsToInactive.isEmpty())
			{
				List<NE__Service_Point__c> servicepoints = new List<NE__Service_Point__c>();
				servicepoints = [SELECT Id,RecordType.DeveloperName,OB_Status__c,
										(SELECT Id,NE__Status__c FROM NE__Asset_Items_ServicePoint__r)
								FROM NE__Service_Point__c
								WHERE Id IN: listOfServicePointsToInactive
								AND OB_Status__c =: OB_UtilityConstants.STATUS_ACTIVE];
				if(!servicepoints.isEmpty())
				{
					for (NE__Service_Point__c currentSP : servicepoints)
					{
						//	CHECK IF ALL THE CHILDREN ASSET OF MERCHANT ARE DISCONNECTED
						if (!currentSP.NE__Asset_Items_ServicePoint__r.isEmpty())
						{
							Boolean allDisconnected = true;
							for (Asset currentAsset : currentSP.NE__Asset_Items_ServicePoint__r)
							{
								if (currentAsset.NE__Status__c!=OB_UtilityConstants.ASSET_STATUS_DISCONNECTED)
								{
									allDisconnected = false;
								}
							}
							if (allDisconnected)
							{
								currentSP.OB_Status__c = OB_UtilityConstants.STATUS_INACTIVE;
								currentSP.OB_BypassValidation__c = true;
								toUpdateServicePoints.add(currentSP);
							}
						}
					}
				}			
			}

			//	FINAL LISTS TO UPDATE (PASSING FROM A SET, TO REMOVE THE DUPLICATES)
			if(!toUpdateAccounts.isEmpty())
			{
				Set<Account> setOfAccounts 	= new Set<Account>();
				setOfAccounts.addAll(toUpdateAccounts);
				toUpdateAccounts 			= new List<Account>();
				toUpdateAccounts.addAll(setOfAccounts);
				update toUpdateAccounts;
			}
			if(!toUpdateServicePoints.isEmpty())
			{
				Set<NE__Service_Point__c> setOfServicePoints 	= new Set<NE__Service_Point__c>();
				setOfServicePoints.addAll(toUpdateServicePoints);
				toUpdateServicePoints 							= new List<NE__Service_Point__c>();
				toUpdateServicePoints.addAll(setOfServicePoints);
				update toUpdateServicePoints;
			}
		}
	}
	//	END 	micol.ferrari	27/11/2018
}