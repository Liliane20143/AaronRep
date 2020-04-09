public with sharing class OB_OfferCatalogBankController {
      @AuraEnabled
	public static User getUserCABandABIServer(Id userId){
		User userInfo  = [
            SELECT id, contact.Account.ob_abi__c, Profile.userlicense.name, Contact.Account.Name from User where id = :userId
		];
		return userInfo;
	}
    
	@AuraEnabled
	public static List<NE__Bundle__c> getOffersByABIServer(String abi){
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
    public static List<NE__bundle__c> getBundleOffers(){
		//TO EDIT: List<NE__Matrix_Parameter_Row__c>
		String catalogName = OB_offerCatalogController.catalogName;
		String query ='';
		List<NE__bundle__c> offers = new List<NE__bundle__c>();
	    query = 'SELECT name, CreatedDate, LastModifiedDate,NE__Start_Date__c, OB_Image__c, NE__Description__c, NE__End_Date__c,'+
			'NE__Active__c from NE__bundle__c WHERE NE__Active__c =true AND NE__Catalog__r.Name =\''+ catalogName+'\' AND NE__Start_Date__c < TODAY AND (NE__End_Date__c >TODAY OR NE__End_Date__c = null)';

		System.debug(query);
		offers = Database.query(query);
        return offers;
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
    public static List<NE__Matrix_Parameter_Row__c> searchForOffer(String searchText, String selectedABI, String selectedCAB){
    	/*Date todayDate = Date.today();
    	String searchInput = '%'+searchText+'%';
    	List<NE__bundle__c> offers = [SELECT name,NE__Start_Date__c, OB_Image__c, NE__Description__c, 
        NE__End_Date__c, NE__Active__c from NE__bundle__c WHERE name LIKE :searchInput AND NE__Active__c = true AND NE__Catalog__r.Name = 'Catalogo_Nexi'
        AND NE__Start_Date__c <: todayDate AND (NE__End_Date__c >:  todayDate OR NE__End_Date__c = null)];*/
        String searchInput = searchText+'%';
        	List<NE__Matrix_Parameter_Row__c> offers = [
			SELECT id, NE__Active__c, Name,NE__Matrix_Parameter__r.OB_Offerta__c, NE__Matrix_Parameter__r.OB_Offerta__r.Name, NE__Matrix_Parameter__r.OB_Offerta__r.NE__Start_Date__c, NE__Matrix_Parameter__r.OB_Offerta__r.OB_Image__c, NE__Matrix_Parameter__r.OB_Offerta__r.NE__Description__c, NE__Matrix_Parameter__r.OB_Offerta__r.NE__End_Date__c, NE__Matrix_Parameter__r.OB_Offerta__r.NE__Active__c
			FROM NE__Matrix_Parameter_Row__c 
			WHERE OB_ABI_BANCA__c =: selectedABI 
            AND OB_Cab__c =: selectedCAB
			AND NE__Active__c = true
			AND NE__Matrix_Parameter__r.OB_Offerta__r.NE__Active__c = true
			AND NE__Matrix_Parameter__r.NE__Active__c = true
			AND NE__Matrix_Parameter__r.OB_Offerta__r.name LIKE :searchInput
			ORDER BY NE__Matrix_Parameter__r.OB_Offerta__r.Name
		];
    	
    	return offers;
    }
    
   /* @AuraEnabled
    public static void updateRowsWithBundles(Map<String, Boolean> activeOffersMap,  List<NE__Matrix_Parameter_Row__c> rows, String selectedABI){
		
		List<NE__Matrix_Parameter_Row__c> listToUpdate = new List<NE__Matrix_Parameter_Row__c>();
		List<NE__Bundle__c> activeOffers = new	List<NE__Bundle__c>();
		//System.debug('before for');
		for(Integer i = 0; i<rows.size(); i++){
			for(String key : activeOffersMap.keyset()){
				if(rows[i].NE__Matrix_Parameter__r.OB_Offerta__c == key && activeOffersMap.get(key) == false){
					//remove Active from all parameters rows.
					rows[i].NE__Active__c = false;
					listToUpdate.add(rows[i]);
				}else if(rows[i].NE__Matrix_Parameter__r.OB_Offerta__c != key  && activeOffersMap.get(key) == true){
					NE__Bundle__c bundle = 	new NE__Bundle__c();
					bundle.Id = key;
					activeOffers.add(bundle);
				}				
			}
		}
		//System.debug('after for');
		System.debug('listToUpdate: ' + listToUpdate);
		System.debug('activeOffers: ' + activeOffers);
		//calling cloneParametersAndRows
		OB_ABI_OffersController.cloneParametersAndRows(activeOffers, selectedABI, listToUpdate);
		
    }*/
       
    @AuraEnabled
    public static List<NE__Matrix_Parameter_Row__c> cloneParametersAndRows(List<NE__Bundle__c> activeOffers, String selectedABI,String selectedCAB, List<NE__Matrix_Parameter_Row__c> listToUpdate){
		System.debug('inside cloneParametersAndRows');
    	List<NE__Matrix_Parameter_Row__c> rowsToClone = [
			SELECT id, NE__Active__c, Name,NE__Matrix_Parameter__r.OB_Offerta__c, NE__Matrix_Parameter__r.OB_Offerta__r.Name, NE__Matrix_Parameter__r.OB_Offerta__r.NE__Start_Date__c, NE__Matrix_Parameter__r.OB_Offerta__r.OB_Image__c, NE__Matrix_Parameter__r.OB_Offerta__r.NE__Description__c, NE__Matrix_Parameter__r.OB_Offerta__r.NE__End_Date__c, NE__Matrix_Parameter__r.OB_Offerta__r.NE__Active__c
			FROM NE__Matrix_Parameter_Row__c 
			WHERE OB_ABI_BANCA__c = ''
			AND OB_Cab__c = ''
			AND NE__Active__c = true
			AND NE__Matrix_Parameter__r.OB_Offerta__c in :activeOffers
			ORDER BY NE__Matrix_Parameter__r.OB_Offerta__r.Name
    	];
    	System.debug('rowsToClone: ' + rowsToClone);
    	List<NE__Matrix_Parameter_Row__c> newRows = rowsToClone.deepclone(false, false, false);
    	for(Integer i = 0; i<newRows.size(); i++){
    		newRows[i].OB_ABI_BANCA__c = selectedABI;
            newRows[i].OB_Cab__c = selectedCAB;
    	}
    	if(listToUpdate.size() > 0){
	    	for(Integer j = 0; j< listToUpdate.size(); j++){
	    		newRows.add(listToUpdate[j]);		
	    	}
    	}
    	/*try {   
		    upsert newRows;
		} catch(DmlException e) {
		    System.debug('The following exception has occurred on cloneParametersAndRows method: ' + e.getMessage());
		}   */
		
    	return newRows;
    }
}