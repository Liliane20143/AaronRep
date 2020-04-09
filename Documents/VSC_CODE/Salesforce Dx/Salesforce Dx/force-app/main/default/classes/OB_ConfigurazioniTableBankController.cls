public with sharing class OB_ConfigurazioniTableBankController {

	@AuraEnabled
	public static PageResult getConfigurazioni(Decimal pageSize, Decimal pageNumber,String offerta, String abi,String orderName, String sortDirection){
		
		Integer pSize = (Integer)pageSize;
        Integer offset = ((Integer)pageNumber - 1) * pSize;
        Integer totalRows = 0;
        try{
	        PageResult res = new PageResult();
	        res.pageSize = pSize;
	        res.page = (Integer) pageNumber;
	        
	         //francesca.ribezzi - query to get matrix parameters with the current abi and offerName:
	        //query from rows aggregata come quella sotto -> prendo l'abi grazie ai matrix parameter row
	        List<AggregateResult> arList = [
				select NE__Matrix_Parameter__c,
				count(id) 
				from NE__Matrix_Parameter_Row__c 
				where NE__Matrix_Parameter__r.OB_Offerta__r.Name = :offerta 
				AND OB_ABI_BANCA__c = :abi 
				AND recordType.DeveloperName = 'OB_PriceBankABI'
				group by NE__Matrix_Parameter__c
			];
	        System.debug('matrix parameter from aggrResult SIZE: ' + arList.size());
	        List<NE__Matrix_Parameter__c> newMatrixList = new List<NE__Matrix_Parameter__c>();
	        
	        for(AggregateResult ar : arList){
				//create new matrix  -> adding it to an empty matrix List:
				NE__Matrix_Parameter__c tempMatrix = new NE__Matrix_Parameter__c(
					Id = (id)ar.get('NE__Matrix_Parameter__c')
				);
				System.debug('tempMatrix: ' + tempMatrix);		
				newMatrixList.add(tempMatrix);
			}
			System.debug('newMatrixList SIZE: ' + newMatrixList.size());
			
			//giovanni spinelli start 03/04/2019
			List<NE__Matrix_Parameter__c> configurazioniListQuery = new List<NE__Matrix_Parameter__c>();
			String queryListCnf='SELECT Id,OB_Product__r.recordType.DeveloperName, Name,NE__Active__c,NE__End_Date__c,NE__Start_Date__c, OB_ModelloAcquiring__c, OB_SchemaPrezzi__c, OB_Componente__c, OB_Componente__r.NE__Product_Name__c,OB_Componente__r.NE__Item_Header__c, OB_Listino__r.Name\n'+
				'	FROM NE__Matrix_Parameter__c\n' +
				'	WHERE id in: newMatrixList\n';
			String orderBy = null;
			if(orderName!='OB_SchemaPrezzi__c'){
				if(String.isNotBlank(orderName)){
					orderBy = orderName + '	' +sortDirection; 
					queryListCnf+= '	ORDER BY '+orderBy+'  OFFSET ' +offset+'';	
				}else{
					orderBy=  'CreatedDate desc';
					queryListCnf+= '	ORDER BY '+orderBy+'  OFFSET ' +offset+'';
				}
			}
			configurazioniListQuery = Database.query(queryListCnf);
			if(orderName!='OB_SchemaPrezzi__c'){
				res.configurazioniList = configurazioniListQuery;
			}
			System.debug('STRING QUERY: '+ queryListCnf);	

			
	        //giovanni spinelli end 03/04/2019

			
			Schema.DescribeSObjectResult objSchema = NE__Matrix_Parameter__c.sObjectType.getDescribe();
			Map<String, Schema.SObjectField> fieldMap = objSchema.fields.getmap();
			List<Schema.Picklistentry>fld =fieldmap.get('OB_SchemaPrezzi__c').getDescribe().getpicklistValues();
			List<String> pickListPrezzi = new List<String>();
			
			for(Schema.Picklistentry pl : fld)
			{
			    pickListPrezzi.add(pl.getValue());
			}
			
			res.pickListPrezzi = pickListPrezzi;
			
			Map<String, Schema.SObjectField> fieldMap2 = objSchema.fields.getmap();
			List<Schema.Picklistentry>fld2 =fieldmap2.get('OB_ModelloAcquiring__c').getDescribe().getpicklistValues();
			List<String> pickListModelli = new List<String>();
			
			for(Schema.Picklistentry pl2 : fld2)
			{
			    pickListModelli.add(pl2.getValue());
			}
			
			res.pickListModelli = pickListModelli;
			//francesca.ribezzi - editing this query... getting matrix parameters contained in newMatrixList:
			res.total =  [
				SELECT Count() 
				FROM NE__Matrix_Parameter__c 
				WHERE //recordType.DeveloperName = 'OB_PriceBankABI'  
				//AND OB_Offerta__r.Name = :offerta 
				Id in: newMatrixList
			];
			//AND OB_Componente__r.NE__Parent_Catalog_Item__r.NE__Product_Category_Name__c='COMPONENTI DI PREZZO'
			
			return res;
        }
        catch(Exception e){
        	System.debug('Exception OB_ConfigurazioniTableController::getConfigurazioni' + e.getMessage() + ' at line: ' + e.getLineNumber());
        	return null;
        }	 
	} 
	
	@AuraEnabled
	public static PageResult searchConfigurazioniServer(Decimal pageSize, Decimal pageNumber,String name, String fromDate, String toDate,String offerta,String listino,List<String> schemaPrezzi, List<String> modello, String abi){
		System.debug('into searchConfigurazioniServer');
		Integer pSize = (Integer)pageSize;
        Integer offset = ((Integer)pageNumber - 1) * pSize;
        Integer totalRows = 0;
        String recordTypeName = 'OB_PriceNexi';
        
    /*    Date fromDateNotTime;
		Date toDateNotTime;
        if(String.isNotBlank(fromDate)){
        	fromDateNotTime = Date.valueOf(Date);
        }from
        if(String.isNotBlank(toDate)){
       		toDateNotTime = Date.valueOf(toDate);
        }*/
        
        try{
	        //francesca.ribezzi - query to get matrix parameters with the current abi and offerName:
		    //query from rows aggregata come quella sotto -> prendo l'abi grazie ai matrix parameter row
		    List<AggregateResult> arList = [
					select NE__Matrix_Parameter__c,
					count(id) 
					from NE__Matrix_Parameter_Row__c 
					where NE__Matrix_Parameter__r.OB_Offerta__r.Name =: offerta 
					AND OB_ABI_BANCA__c =: abi 
					AND recordType.DeveloperName = 'OB_PriceBankABI'
					group by NE__Matrix_Parameter__c
				];
	        System.debug('matrix parameter from aggrResult SIZE: ' + arList.size());
	        List<NE__Matrix_Parameter__c> newMatrixList = new List<NE__Matrix_Parameter__c>();
	        
	        for(AggregateResult ar : arList){
				//create new matrix  -> adding it to an empty matrix List:
				NE__Matrix_Parameter__c tempMatrix = new NE__Matrix_Parameter__c(
					Id = (id)ar.get('NE__Matrix_Parameter__c')
				);
				System.debug('tempMatrix: ' + tempMatrix);		
				newMatrixList.add(tempMatrix);
			}
			System.debug('newMatrixList SIZE: ' + newMatrixList.size());
			
			//francesca.ribezzi - getting matrix parameters contained in newMatrixList:
			String query = 'SELECT Id,OB_Product__r.recordType.DeveloperName,Name,NE__Active__c,NE__End_Date__c,NE__Start_Date__c, OB_ModelloAcquiring__c,'+ 
	        'OB_SchemaPrezzi__c, OB_Componente__r.NE__Product_Name__c,OB_Componente__r.NE__Item_Header__c,OB_Listino__r.Name'+
			' FROM NE__Matrix_Parameter__c WHERE id in :newMatrixList';
	        /*String query = 'SELECT Id,Name,NE__Active__c,NE__End_Date__c,NE__Start_Date__c, OB_ModelloAcquiring__c,'+ 
	        'OB_SchemaPrezzi__c, OB_Componente__r.NE__Product_Name__c,OB_Componente__r.NE__Item_Header__c,OB_Listino__r.Name'+
			' FROM NE__Matrix_Parameter__c WHERE OB_Offerta__r.Name = :offerta AND recordType.DeveloperName = :recordTypeName '; 
	        */
	        //AND OB_Componente__r.NE__Parent_Catalog_Item__r.NE__Product_Category_Name__c= :categoryName
	        
	        if(!String.isBlank(name)){
	        	query += ' AND OB_Componente__c = :name';
	        }
	        if(!String.isBlank(listino)){
	        	query += ' AND OB_Listino__c = :listino';
	        }
	       if(!schemaPrezzi.isEmpty() ){
	       		String schemaPrezziMultiPick = ''; 
	        	for(Integer i = 0; i <schemaPrezzi.size(); i++ ){
	        		if(i >0){
	        			schemaPrezziMultiPick += ';'; 
	        		}
	        		schemaPrezziMultiPick += schemaPrezzi[i]; 
	        	} 
	       		query += ' AND OB_SchemaPrezzi__c includes (:schemaPrezziMultiPick)';

	        }
	        if(!modello.isEmpty() ){
	        	String modelloMultiPick = ''; 
	        	for(Integer i = 0; i <modello.size(); i++ ){
	        		if(i >0){
	        			modelloMultiPick += ';'; 
	        		}
	        		modelloMultiPick += modello[i]; 
	        	}
	        	query += ' AND OB_ModelloAcquiring__c includes (:modelloMultiPick)';
	        }
	        if(String.isNotBlank(fromDate)){
	        //	String fromDateString = fromDate.format('yyyy-MM-dd');
	        	query += ' AND NE__Start_Date__c >='+fromDate; //fromDateString
	        }
	        if(String.isNotBlank(toDate)){
	        	//String toDateString = toDate.format('yyyy-MM-dd');
	        	query += ' AND NE__End_Date__c <='+toDate; //toDateString//
	        }
	        
	        query += ' ORDER BY CreatedDate desc LIMIT :pSize OFFSET :offset';
	        PageResult res = new PageResult();
	        res.pageSize = pSize;
	        res.page = (Integer) pageNumber;
	        System.debug('QUERY is: '+query);
			res.configurazioniList = Database.query(query);
		
			String queryTotal = 'SELECT Count() FROM NE__Matrix_Parameter__c WHERE OB_Offerta__r.Name = :offerta AND recordType.DeveloperName = :recordTypeName';  
			
			//AND OB_Componente__r.NE__Parent_Catalog_Item__r.NE__Product_Category_Name__c= :categoryName
			
			if(!String.isBlank(name)){
	        	queryTotal += ' AND OB_Componente__c = :name';
	        }
	        if(!String.isBlank(listino)){
	        	queryTotal += ' AND OB_Listino__c = :listino';
	        }
	        if(!schemaPrezzi.isEmpty() ){
	        	String schemaPrezziMultiPick = ''; 
	        	for(Integer i = 0; i <schemaPrezzi.size(); i++ ){
	        		if(i >0){
	        			schemaPrezziMultiPick += ';'; 
	        		}
	        		schemaPrezziMultiPick += schemaPrezzi[i]; 
	        	} 
	       		queryTotal += ' AND OB_SchemaPrezzi__c includes (:schemaPrezziMultiPick)';
	        }
	        if(!modello.isEmpty() ){
	        	String modelloMultiPick = ''; 
	        	for(Integer i = 0; i <modello.size(); i++ ){
	        		if(i >0){
	        			modelloMultiPick += ';'; 
	        		}
	        		modelloMultiPick += modello[i]; 
	        	}
	        	queryTotal += ' AND OB_ModelloAcquiring__c includes (:modelloMultiPick)';
	        }
	        if(String.isNotBlank(fromDate)){
	        //	String fromDateString = fromDate.format('yyyy-MM-dd');
	        	queryTotal += ' AND NE__Start_Date__c >='+fromDate; //fromDateString
	        }
	        if(String.isNotBlank(toDate)){
	        //	String toDateString = toDate.format('yyyy-MM-dd');
	        	queryTotal += ' AND NE__End_Date__c <='+toDate; //toDateString
	        }
	        
	        System.debug('name: ' + name + 'offerta' + offerta + 'recordType: ' +recordTypeName);
			System.debug('QueryToTal: ' + queryTotal);
			res.total =  Database.countQuery(queryTotal);

			return res;
        }
        catch(Exception e){
        	System.debug('Exception OB_ConfigurazioniTableController::searchConfigurazioniServer' + e.getMessage() + ' at line: ' + e.getLineNumber());
        	return null;
        } 
	}
	
	@AuraEnabled
	public static PageResult creaConfigurazioneServer(Decimal pageSize, Decimal pageNumber,String name, DateTime fromDate, DateTime toDate,Id offerta,String listino,List<String> schemaPrezzi, List<String> modello){
		
		Integer pSize = (Integer)pageSize;
        Integer offset = ((Integer)pageNumber - 1) * pSize;
        Integer totalRows = 0;
        String recordTypeName = 'OB_PriceBankABI';
        
        NE__Matrix_Parameter__c newMatrix = new NE__Matrix_Parameter__c();
        try{
	        //formal checks of required fields 
	        newMatrix.NE__Active__c = true;
	        Id recordTypeId = Schema.SObjectType.NE__Matrix_Parameter__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
    		newMatrix.RecordTypeId = recordTypeId;
	        //set offer from the one selected
	        newMatrix.OB_Offerta__c = offerta;
	           
	        if(!String.isBlank(name)){
	        	newMatrix.OB_Componente__c = String.escapeSingleQuotes(name);
	        	
	        } 
	        if(!String.isBlank(listino)){
	        	newMatrix.OB_Listino__c = String.escapeSingleQuotes(listino);
	        }
	        if(!schemaPrezzi.isEmpty() ){
	        	String schemaPrezziMultiPick = ''; 
	        	for(Integer i = 0; i <schemaPrezzi.size(); i++ ){
	        		if(i >0){
	        			schemaPrezziMultiPick += ';'; 
	        		}
	        		schemaPrezziMultiPick += schemaPrezzi[i]; 
	        	}
	        	newMatrix.OB_SchemaPrezzi__c = String.escapeSingleQuotes(schemaPrezziMultiPick);
	        }
	        if(!modello.isEmpty() ){
	        	String modelloMultiPick = ''; 
	        	for(Integer i = 0; i <modello.size(); i++ ){
	        		if(i >0){
	        			modelloMultiPick += ';'; 
	        		}
	        		modelloMultiPick += modello[i]; 
	        	}
	        	newMatrix.OB_ModelloAcquiring__c = String.escapeSingleQuotes(modelloMultiPick);
	        	//newMatrix.OB_ModelloAcquiring__c = String.escapeSingleQuotes(modello);
	        }
	        if(fromDate != null){
	        	Date fromDateNotTime = date.newinstance(fromDate.year(), fromDate.month(), fromDate.day());
	        	newMatrix.NE__Start_Date__c = fromDateNotTime;
	        }
	        if(toDate != null){
	        	Date toDateNotTime = date.newinstance(toDate.year(), toDate.month(), toDate.day());
	        	newMatrix.NE__End_Date__c = toDateNotTime;
	        }
	        
	        PageResult res = new PageResult();
	        res.pageSize = pSize;
	        res.page = (Integer) pageNumber;
	        System.debug('New Matrix is: '+newMatrix);
			
			//check for duplicate entry
			List<NE__Matrix_Parameter__c> duplicateCheckList = [
				SELECT Id,OB_Product__r.recordType.DeveloperName, OB_Componente__r.NE__Product_Name__c, OB_Componente__c, OB_Componente__r.NE__Item_Header__c
				FROM NE__Matrix_Parameter__c 
				WHERE OB_Componente__c = :newMatrix.OB_Componente__c 
				AND NE__Start_Date__c = :newMatrix.NE__Start_Date__c
				//AND OB_Listino__c = :newMatrix.OB_Listino__c
				AND OB_SchemaPrezzi__c = :newMatrix.OB_SchemaPrezzi__c
				AND OB_ModelloAcquiring__c = :newMatrix.OB_ModelloAcquiring__c 
				AND NE__End_Date__c = :newMatrix.NE__End_Date__c 
				AND OB_Offerta__c = :offerta
				AND recordType.DeveloperName = 'OB_PriceBankABI' 
				];
			
			//AND OB_Componente__r.NE__Parent_Catalog_Item__r.NE__Product_Category_Name__c='COMPONENTI DI PREZZO'
			
			if(duplicateCheckList.size() <= 0){
				Database.SaveResult sr = Database.insert(newMatrix); 
				
				//update some values after insert
				Id newId = sr.getId();
				NE__Matrix_Parameter__c MatrixToUpdate = [SELECT id,OB_Componente__c,OB_Componente__r.NE__Catalog_Id__r.NE__Catalog_Header__c,OB_Componente__r.NE__ProductId__c,OB_Componente__r.NE__Product_Name__c FROM NE__Matrix_Parameter__c WHERE id = :newId LIMIT 1];
				
				//System.debug('$TEST2$ '+MatrixToUpdate.OB_Componente__r.NE__Catalog_Id__r.NE__Catalog_Header__c);
				MatrixToUpdate.Name = MatrixToUpdate.OB_Componente__r.NE__Product_Name__c;
				MatrixToUpdate.NE__Catalog_Header__c = MatrixToUpdate.OB_Componente__r.NE__Catalog_Id__r.NE__Catalog_Header__c;
				MatrixToUpdate.OB_Product__c = MatrixToUpdate.OB_Componente__r.NE__ProductId__c;
				update MatrixToUpdate;
				
				res.configurazione = MatrixToUpdate;
				//END
			}
			else{
				System.debug('Duplicate Alert '+duplicateCheckList.size());
				res.configurazione = duplicateCheckList[0];
			}
			
			res.configurazioniList = [
				SELECT Id,Name,NE__Active__c,NE__End_Date__c,NE__Start_Date__c, OB_ModelloAcquiring__c, OB_SchemaPrezzi__c, OB_Componente__c,OB_Componente__r.NE__Product_Name__c,OB_Componente__r.NE__Item_Header__c,OB_Listino__r.Name
				FROM NE__Matrix_Parameter__c WHERE OB_Offerta__c = :offerta AND recordType.DeveloperName = 'OB_PriceBankABI'  
				ORDER BY CreatedDate desc LIMIT :pSize OFFSET :offset
			];
				
			String queryTotal = 'SELECT Count() FROM NE__Matrix_Parameter__c WHERE OB_Offerta__c = :offerta AND recordType.DeveloperName = :recordTypeName';  
			
			res.total =  Database.countQuery(queryTotal);
			
			return res;
        }
        catch(Exception e){
        	System.debug('Exception OB_ConfigurazioniTableController::creaListinoServer' + e.getMessage() + ' at line: ' + e.getLineNumber());
        	return null;
        } 
	}
	
	@AuraEnabled
	public static PageResult deleteconfigurazioneServer(Decimal pageSize, Decimal pageNumber,NE__Matrix_Parameter__c configurazioneToDelete,String offerta){
		
		Integer pSize = (Integer)pageSize;
        Integer offset = ((Integer)pageNumber - 1) * pSize;
        Integer totalRows = 0;
        String recordTypeName = 'OB_PriceBankABI';
        
        try{
	        
	        PageResult res = new PageResult();
	        res.pageSize = pSize;
	        res.page = (Integer) pageNumber;
	        System.debug('Matrix to delete is: '+configurazioneToDelete);
			
			//check if you can actually delete....
			//TODO
			
			Database.delete(configurazioneToDelete); 
			
			res.configurazioniList = [
				SELECT Id,Name,NE__Active__c,NE__End_Date__c,NE__Start_Date__c, OB_ModelloAcquiring__c, OB_SchemaPrezzi__c, OB_Componente__c,OB_Componente__r.NE__Product_Name__c,OB_Componente__r.NE__Item_Header__c,OB_Listino__r.Name
				FROM NE__Matrix_Parameter__c WHERE OB_Offerta__r.Name = :offerta AND recordType.DeveloperName = 'OB_PriceBankABI'
				ORDER BY CreatedDate desc LIMIT :pSize OFFSET :offset
			];
			
			
			String queryTotal = 'SELECT Count() FROM NE__Matrix_Parameter__c WHERE OB_Offerta__r.Name = :offerta AND recordType.DeveloperName = :recordTypeName ';   
			
			res.total =  Database.countQuery(queryTotal);
			
			return res;
        }
        catch(Exception e){
        	System.debug('Exception OB_ConfigurazioniTableController::deleteListinoServer' + e.getMessage() + ' at line: ' + e.getLineNumber());
        	return null;
        } 
	}
	
	@AuraEnabled
    public static List<NE__Catalog_Item__c> searchForProducts(String searchText){
    	String searchInput = '%'+searchText+'%';
    	
    	List<NE__Catalog_Item__c> products = [
    		SELECT Id, NE__Product_Name__c 
    		FROM NE__Catalog_Item__c 
    		WHERE NE__Root_Catalog_Item__c = null
    		AND NE__Catalog_Id__r.Name='Catalogo_Nexi' 
    		AND NE__Type__c  ='Product'
    		AND NE__Product_Name__c LIKE  :searchInput 
    	];
    	
    	return products;
    }
    
    @AuraEnabled
    public static List<NE__Matrix_Parameter__c> searchForCatalogs(String searchText){
    	String searchInput = '%'+searchText+'%';
    	
    	List<NE__Matrix_Parameter__c> listini = [
				SELECT Id,OB_Product__r.recordType.DeveloperName,Name,NE__Active__c,NE__End_Date__c,NE__Start_Date__c,OB_Componente__c,OB_Componente__r.NE__Item_Header__c   
				FROM NE__Matrix_Parameter__c 
				WHERE recordType.DeveloperName = 'OB_PriceList'
				];
				
    	return listini;
    }        
	 
   //PageResult class to handle pagination and results 
   public class PageResult {
        @AuraEnabled
        public Integer pageSize { get;set; }
        
        @AuraEnabled
        public Integer page { get;set; }
        
        @AuraEnabled
        public Integer total { get;set; }
        
        @AuraEnabled
        public List<NE__Matrix_Parameter__c> configurazioniList { get;set; }
        
        @AuraEnabled
        public List<String> pickListPrezzi { get;set; }
        
        @AuraEnabled
        public List<String> pickListModelli { get;set; }
        
        @AuraEnabled
        public NE__Matrix_Parameter__c configurazione { get;set; }
        
    }
    
	
}