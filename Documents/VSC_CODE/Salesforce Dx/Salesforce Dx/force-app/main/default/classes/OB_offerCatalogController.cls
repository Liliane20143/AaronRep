public with sharing class OB_offerCatalogController {
	
	public static String catalogName = 'Catalogo_Nexi'; // Catalogo_Test
	
    @AuraEnabled
    public static List<NE__bundle__c> getBundleOffers(String selectedValue, List<NE__bundle__c> bundleOffers){

		String empty = '';
		//String catalogName = //'Catalogo_Nexi';
		String query ='';
		List<NE__bundle__c> offers = new List<NE__bundle__c>();
		if(String.isEmpty(selectedValue)){
	      query = 'SELECT name, CreatedDate, LastModifiedDate,NE__Start_Date__c, OB_Image__c, NE__Description__c, NE__End_Date__c,'+
			'NE__Active__c from NE__bundle__c WHERE NE__Active__c =true AND NE__Catalog__r.Name =\''+ catalogName+'\' AND NE__Start_Date__c < TODAY AND (NE__End_Date__c >TODAY OR NE__End_Date__c = null)';
		}else{
			/* query = 'SELECT name,NE__Start_Date__c, OB_Image__c, NE__Description__c, NE__End_Date__c,'+
			'NE__Active__c from NE__bundle__c WHERE NE__Active__c = true AND NE__Catalog__r.Name=\''+ catalogName+'\'  AND NE__Start_Date__c <TODAY AND (NE__End_Date__c >TODAY OR NE__End_Date__c = null) ORDER BY '  + selectedValue;*/
			query = 'SELECT Id, name,NE__Start_Date__c, OB_Image__c, NE__Description__c, NE__End_Date__c,'+
			'NE__Active__c from NE__bundle__c WHERE Id IN :bundleOffers ORDER BY '  + selectedValue;
		}
		System.debug(query);
		offers = Database.query(query);
        return offers;
    }
    
	//davide.franzini - 01/07/2019 - F2WAVE2-15 - START
	@AuraEnabled
    public static List<NE__bundle__c> searchForOffer(String searchAbi){
    	Date todayDate = Date.today();
    	String searchInput = '%'+searchAbi+'%';
		List<NE__bundle__c> offers = new List<NE__bundle__c>();
		Set<String> activeOffers = new Set<String>();
		
		List<NE__Matrix_Parameter__c> activeMPList = [SELECT Id, 
                                                            OB_Offerta__c,
															OB_Offerta__r.Name
                                                    FROM NE__Matrix_Parameter__c 
                                                    WHERE OB_ABI__c LIKE :searchInput
                                                        AND NE__Active__c = true
														AND NE__Start_Date__c <: todayDate 
														AND (NE__End_Date__c >:  todayDate OR NE__End_Date__c = null)];

		for(NE__Matrix_Parameter__c mp : activeMPList){
			activeOffers.add(mp.OB_Offerta__r.Name);
		}	

		if(activeOffers!= null && !activeOffers.isEmpty()){
			offers = [SELECT name, 
							NE__Start_Date__c, 
							OB_Image__c, 
							NE__Description__c, 
							NE__End_Date__c, 
							NE__Active__c 
						FROM NE__bundle__c 
						WHERE name IN :activeOffers 
							AND NE__Active__c = true 
							AND NE__Catalog__r.Name = :catalogName
							AND NE__Start_Date__c <: todayDate 
							AND (NE__End_Date__c >:  todayDate OR NE__End_Date__c = null)];
		}
    	return offers;
    }
	//davide.franzini - 01/07/2019 - F2WAVE2-15 - END
    
    @AuraEnabled
    public static List<NE__bundle__c> orderBundleOffers(String selectedValue, List<NE__bundle__c> bundleOffers){
    	   //Datetime dt = Datetime.newInstance(2999, 12, 31, 00, 00, 00); // if ascending
			List<NE__bundle__c> afterSort = new List<NE__bundle__c>();
            Datetime dt = Datetime.newInstance(1900, 12, 31, 00, 00, 00); // if decending
            String fieldNameToSort = '';
            if(selectedValue == 'CreatedDate'){
            	for (Integer i = 0; i < bundleOffers.size() ; i ++){
	            	if(bundleOffers[i].CreatedDate > dt){ // if decending
                        dt = bundleOffers[i].CreatedDate;
                        afterSort.add(bundleOffers[i]);
	                }else continue;
	      
	           // bundleOffers.remove(mini);
    			}  
            }else if(selectedValue == 'LastModifiedDate'){
            	for (Integer i = 0; i != bundleOffers.size() ; i ++){
	            	if(bundleOffers[i].LastModifiedDate > dt){ // if decending
                        dt = bundleOffers[i].LastModifiedDate;
                        afterSort.add(bundleOffers[i]);
	                 }else continue;
	           
	            //bundleOffers.remove(mini);
    			}  
            }
      		
    		return afterSort;
		
	}
	//@author Francesca Ribezzi <francesca.ribezzi@accenture.com>
	//@date 13/05/19
	//@description adding method to get all abi list to show on a modal:
	@AuraEnabled
    public static List<NE__Lov__c>  getAbiList(String offerId, String inputABI){
		System.debug('offerId: ' + offerId);	

		List<AggregateResult> arList = [
				select count(id), 
				OB_ABI_BANCA__c  
				from NE__Matrix_Parameter_Row__c  
				where OB_Offerta__c = :offerId   
				group by OB_ABI_BANCA__c 
			];
		System.debug('arList: ' + arList);	
		List<String> abiList = new List<String>();    
	        for(AggregateResult ar : arList){
				String tempABI =  (String)ar.get('OB_ABI_BANCA__c');
				System.debug('tempABI: ' + tempABI);	 
				//if condition used to get all ABI by selected offer:	 
				if(tempABI != null && inputABI == null){
					abiList.add(tempABI);  
				//else if condition used to get ABI searched by user:
				}else if(tempABI == inputABI && inputABI != null){
					abiList.add(tempABI);
				}
			}  
        List<NE__Lov__c> abiLovs = [
                SELECT Id, Name, Ne__value1__c
                FROM NE__Lov__c
                WHERE NE__type__c = 'ABI'  
				AND Name IN :abiList 
        ];
        return abiLovs;
	}
    
}