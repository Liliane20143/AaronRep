public with sharing class OB_CAB_OffersController {
    
    @AuraEnabled
    public static User getABIbyUserIdServer(String userId){
		User currentUser = [
			SELECT id, contact.Account.ob_abi__c, Profile.userlicense.name, Contact.Account.Name
			FROM User 
			WHERE Id = :userId
		];
		
		return currentUser;
	}
	
	
    @AuraEnabled
	public static List<NE__Lov__c> getCABListFromInput(String abi, String cab){
		String inputCab = cab + '%';
		List<NE__Lov__c> cabList = [
			SELECT Name, Ne__value1__c, NE__Value2__c
			FROM NE__Lov__c 
			WHERE NE__type__c = 'CAB' 
			AND Name LIKE: inputCab
			AND NE__Value1__c = :abi
		];
		//default="{'sobjectType':'NE__Lov__c', 'Name':'01623', 'NE__Value1__c': '05696', 'NE__Value2__c': 'Banca Popolare di Sondrio'}"
		return cabList;
	}
	@AuraEnabled
	public static List<NE__Bundle__c> getOffersByABIServer(String abi, String cab){
	
		String catalogName = 'Catalogo_Nexi';
		List<NE__Bundle__c> bankOffers = new List<NE__Bundle__c>();
	   // OfferResults res = new OfferResults();
       // res.offersToEnable =
		List<AggregateResult> arList = [
			select NE__Matrix_Parameter__r.OB_Offerta__c, NE__Matrix_Parameter__r.OB_Offerta__r.Name,
			count(id) 
			from NE__Matrix_Parameter_Row__c 
			where NE__Matrix_Parameter__r.OB_Offerta__r.Name != null 
			AND OB_ABI_BANCA__c = :abi 
			AND OB_CAB__c =:  cab
			group by NE__Matrix_Parameter__r.OB_Offerta__c, NE__Matrix_Parameter__r.OB_Offerta__r.Name
		];
		System.debug('arList: ' + arList);		
		for(AggregateResult ar : arList){
			//new bundle -> setting its value and add to offerList
			NE__Bundle__c tempBundle = new NE__Bundle__c(
				Id = (id)ar.get('OB_Offerta__c')
			);
			System.debug('tempBundle: ' + tempBundle);		
			bankOffers.add(tempBundle);
		}
		
		List<NE__Bundle__c> bundlesToReturn = 
		[
			SELECT Id, Name, NE__Start_Date__c, OB_Image__c, NE__Description__c, NE__End_Date__c, NE__Active__c
			FROM NE__Bundle__c
			WHERE id in:bankOffers
			ORDER BY Name
		];

		return bundlesToReturn;
	}
	
	@AuraEnabled
	public static List<NE__Bundle__c> getAllOffersToEnableServer(List<NE__Bundle__c> cabOffers, String cab, String abi){
		String catalogName = 'Catalogo_Nexi';
		List<NE__Bundle__c> offersToEnable = new List<NE__Bundle__c>();
		List<NE__Bundle__c> bankOffers = new List<NE__Bundle__c>();
	   // OfferResults res = new OfferResults();
       // res.offersToEnable =
		List<AggregateResult> arList = [
			select NE__Matrix_Parameter__r.OB_Offerta__c, NE__Matrix_Parameter__r.OB_Offerta__r.Name,
			count(id) 
			from NE__Matrix_Parameter_Row__c 
			where NE__Matrix_Parameter__r.OB_Offerta__r.Name != null 
			AND OB_ABI_BANCA__c = :abi 
			AND OB_CAB__c = null
			group by NE__Matrix_Parameter__r.OB_Offerta__c, NE__Matrix_Parameter__r.OB_Offerta__r.Name
		];
		System.debug('arList: ' + arList);		
		for(AggregateResult ar : arList){
			//new bundle -> setting its value and add to offerList
			NE__Bundle__c tempBundle = new NE__Bundle__c(
				Id = (id)ar.get('OB_Offerta__c')
			);
			System.debug('tempBundle: ' + tempBundle);		
			bankOffers.add(tempBundle);
		}

		for(NE__Bundle__c bundle : cabOffers){
			for(Integer i = 0; i<bankOffers.size(); i++){
				if(bankOffers[i] == bundle){
					//tutte le offerte meno quelle istanziate
					bankOffers.remove(i);
				}
			}
		}
		for(NE__Bundle__c key : bankOffers){
			offersToEnable.add(key);
		}
		
		List<NE__Bundle__c> bundlesToReturn = 
		[
			SELECT Id, Name, NE__Start_Date__c, OB_Image__c, NE__Description__c, NE__End_Date__c, NE__Active__c
			FROM NE__Bundle__c
			WHERE id in :offersToEnable
			ORDER BY Name
		];
		return bundlesToReturn;
	
	}
	
	@AuraEnabled
	public static List<NE__Bundle__c> searchForOffersToEnable(List<NE__Bundle__c> bankOffers, String searchText){
		String searchInput = '%'+searchText+'%';
		String catalogName = 'Catalogo_Nexi';
		List<NE__Bundle__c> offersToEnable = new List<NE__Bundle__c>();

		Map<id, NE__Bundle__c> mapIdOffer = new Map<id, NE__Bundle__c>([
			select Id,NE__Catalog_Item__r.NE__ProductId__r.Name, NE__Start_Date__c, OB_Image__c, NE__Description__c, Name,NE__End_Date__c, NE__Active__c
			from NE__Bundle__c  
			WHERE  NE__Catalog__r.Name = :catalogName
			AND Name LIKE:searchInput
			AND NE__Start_Date__c < TODAY AND (NE__End_Date__c >TODAY OR NE__End_Date__c = null)
			AND NE__Active__c = true
		]);
	
		for(NE__Bundle__c bundle : bankOffers){
			Id tempOffer = bundle.Id;
			if(mapIdOffer.containsKey(tempOffer)){
				//tutte le offerte meno quelle istanziate
				NE__Bundle__c tempBundle = mapIdOffer.remove(tempOffer);
			}
		}
		for(Id key : mapIdOffer.keyset()){
			offersToEnable.add(mapIdOffer.get(key));
		}
		return offersToEnable;
	}
	
	@AuraEnabled
    public static List<NE__bundle__c> getBundleOffers(String abi){
		//TO EDIT: List<NE__Matrix_Parameter_Row__c>
		/*String catalogName = 'Catalogo_Nexi';
		String query ='';
		List<NE__bundle__c> offers = new List<NE__bundle__c>();
	    query = 'SELECT name, CreatedDate, LastModifiedDate,NE__Start_Date__c, OB_Image__c, NE__Description__c, NE__End_Date__c,'+
			'NE__Active__c from NE__bundle__c WHERE NE__Active__c =true AND NE__Catalog__r.Name =\''+ catalogName+'\' AND NE__Start_Date__c < TODAY AND (NE__End_Date__c >TODAY OR NE__End_Date__c = null) ORDER BY Name';
		System.debug(query);
		offers = Database.query(query);
        return offers;*/
        String catalogName = 'Catalogo_Nexi';
		List<NE__Bundle__c> bankOffers = new List<NE__Bundle__c>();
	   // OfferResults res = new OfferResults();
       // res.offersToEnable =
		List<AggregateResult> arList = [
			select NE__Matrix_Parameter__r.OB_Offerta__c, NE__Matrix_Parameter__r.OB_Offerta__r.Name,
			count(id) 
			from NE__Matrix_Parameter_Row__c 
			where NE__Matrix_Parameter__r.OB_Offerta__r.Name != null 
			AND OB_ABI_BANCA__c =: abi 
			group by NE__Matrix_Parameter__r.OB_Offerta__c, NE__Matrix_Parameter__r.OB_Offerta__r.Name
		];
		System.debug('arList: ' + arList);		
		for(AggregateResult ar : arList){
			//new bundle -> setting its value and add to offerList
			NE__Bundle__c tempBundle = new NE__Bundle__c(
				Id = (id)ar.get('OB_Offerta__c')
			);
			System.debug('tempBundle: ' + tempBundle);		
			bankOffers.add(tempBundle);
		}
		
		List<NE__Bundle__c> bundlesToReturn = 
		[
			SELECT Id, Name, NE__Start_Date__c, OB_Image__c, NE__Description__c, NE__End_Date__c, NE__Active__c
			FROM NE__Bundle__c
			WHERE id in:bankOffers
			ORDER BY Name
		];

		return bundlesToReturn;
    }
    
    @AuraEnabled
    public static List<NE__Matrix_Parameter_Row__c> getBundleOffersOrderBy(String selectedValue, List<NE__Matrix_Parameter_Row__c> bundleOffers){
		//TO EDIT: List<NE__Matrix_Parameter_Row__c>
		String query ='';
		List<NE__Matrix_Parameter_Row__c> offers = new List<NE__Matrix_Parameter_Row__c>();
		query = 'SELECT id, NE__Active__c, Name,NE__Matrix_Parameter__r.OB_Offerta__c, NE__Matrix_Parameter__r.OB_Offerta__r.Name, NE__Matrix_Parameter__r.OB_Offerta__r.NE__Start_Date__c, NE__Matrix_Parameter__r.OB_Offerta__r.OB_Image__c, NE__Matrix_Parameter__r.OB_Offerta__r.NE__Description__c, NE__Matrix_Parameter__r.OB_Offerta__r.NE__End_Date__c, NE__Matrix_Parameter__r.OB_Offerta__r.NE__Active__c' 
		+' FROM NE__Matrix_Parameter_Row__c WHERE Id IN :bundleOffers ORDER BY '  + selectedValue;
		System.debug(query);
		offers = Database.query(query);
        return offers;
    }

    @AuraEnabled
    public static void cloneParametersAndRows(List<Id> activeOffers, String abi, String cab){
		System.debug('inside cloneParametersAndRows');
		//START francesca.ribezzi 30/07/19 - WN-216
		String service = 'CAB'; //string used for queueable class 
		List<OB_JobStorage__c> jobStorageList = new List<OB_JobStorage__c>();
		//getting all matrix parameters for every selected offer:
		List<NE__Matrix_Parameter__c> matrixParameters =
		[
			SELECT id, 
		 	Name,
			OB_ABI__c,
		  	NE__Active__c, 
		  	OB_ActiveBank__c,
		   	NE__End_Date__c,
            NE__Start_Date__c,
			OB_ModelloAcquiring__c,
			OB_SchemaPrezzi__c,
			OB_Componente__c, 
			OB_Componente__r.NE__Product_Name__c,
            OB_Componente__r.NE__Item_Header__c,
			OB_Listino__r.Name,
			OB_Componente__r.NE__ProductId__r.RecordType.DeveloperName,
            OB_MainMP__c,
			OB_Offerta__c,
			OB_ABIcatItemIdBundleId__c
			FROM NE__Matrix_Parameter__c 
			WHERE OB_ABI__c = :abi
			AND recordType.DeveloperName = 'OB_PriceBankABI'
			AND OB_Offerta__c in :activeOffers
			ORDER BY OB_Offerta__r.Name
		];
		//dividing matrix paramenters by offers and put those in offerIdMatrixParametersMap
		Map<String,List<NE__Matrix_Parameter__c>> offerIdMatrixParametersMap = new Map<String, List<NE__Matrix_Parameter__c>>();
        for(NE__Matrix_Parameter__c matrix : matrixParameters){ 
            for(Id offerId : activeOffers){
				if(offerIdMatrixParametersMap.containsKey(offerId)){
					List<NE__Matrix_Parameter__c> tempList = offerIdMatrixParametersMap.get(offerId);
					tempList.add(matrix); 
					offerIdMatrixParametersMap.put(offerId, tempList); 
				}else{
					offerIdMatrixParametersMap.put(offerId, new List<NE__Matrix_Parameter__c> {matrix});
				}
			}
        }
		system.debug(LoggingLevel.INFO, '## offerIdMatrixParametersMap: '+JSON.serializePretty(offerIdMatrixParametersMap));
		//Set composed by only one cab as we can only activate many offers for ONE cab each:
		Set<String> tempSet = new Set<String>();
		tempSet.add(cab);
		//calling queueble class as many times as how many the selected offers are:
		for(String offerId : offerIdMatrixParametersMap.keySet()){
			//clearing list and map at every offer
			List<NE__Matrix_Parameter__c>  tempMatrixParameters = new List<NE__Matrix_Parameter__c>();
			Map<String, Set<String>> tempMatrixIdCabListmap = new Map<String, Set<String>>(); 
			for(NE__Matrix_Parameter__c matrix : offerIdMatrixParametersMap.get(offerId)){
				tempMatrixParameters.add(matrix);
				tempMatrixIdCabListmap.put(matrix.Id, tempSet);
			}
			OB_CloneMatrixParameterQueueable updateJob = new OB_CloneMatrixParameterQueueable(tempMatrixParameters, tempMatrixIdCabListmap, abi, cab, service);
			ID jobID =    System.enqueueJob(updateJob);
			OB_JobStorage__c tempJob = new OB_JobStorage__c();
			tempJob.OB_JobId__c = jobID;
			tempJob.Name = abi +'_'+ jobID;
			jobStorageList.add(tempJob);
			System.debug('Job Is is : ' + jobID);
		}	
		 insert jobStorageList;
	}
	//deleting all the old stuff  (cloning of matrixParameterRows) - calling OB_CloneMatrixParameterQueueable instead
	//END francesca.ribezzi 30/07/19 - WN-216
    
}