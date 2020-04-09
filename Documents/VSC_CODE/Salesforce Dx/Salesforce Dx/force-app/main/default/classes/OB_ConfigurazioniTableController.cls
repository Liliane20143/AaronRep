public without sharing class OB_ConfigurazioniTableController {

	@AuraEnabled
	public static PageResult getConfigurazioni(Decimal pageSize, Decimal pageNumber,String offerta, String orderName, String sortDirection){
		System.debug('getConfigurazioni --> '+ 'pageSize = ' +pageSize + 'pageNumber = '+pageNumber + 'offerta = '+offerta );
		Integer pSize = (Integer)pageSize;
        Integer offset = ((Integer)pageNumber - 1) * pSize;
        Integer totalRows = 0;
		//giovanni spinelli 27/03/2019  - change static query with dinamic query - start
		
		
        try{
	        PageResult res = new PageResult();
	        res.pageSize = pSize;
	        res.page = (Integer) pageNumber;
			List<NE__Matrix_Parameter__c> configurazioniListQuery = new List<NE__Matrix_Parameter__c>();
			String queryListCnf = 	'SELECT Id,Name,NE__Active__c,NE__End_Date__c,NE__Start_Date__c, OB_ModelloAcquiring__c, OB_SchemaPrezzi__c, OB_Componente__c, OB_Componente__r.NE__Product_Name__c,OB_Componente__r.NE__Item_Header__c, OB_Listino__r.Name \n'+
									'	FROM NE__Matrix_Parameter__c \n'+
									'	WHERE OB_Offerta__r.Name =:  offerta  AND recordType.DeveloperName = \'OB_PriceNexi\' ';
									//'	ORDER BY '+orderBy+'  OFFSET ' +offset+'';
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
			
			System.debug('STRING QUERY: '+ queryListCnf);
	        configurazioniListQuery = Database.query(queryListCnf);
			if(orderName!='OB_SchemaPrezzi__c'){
				res.configurazioniList = configurazioniListQuery;
			}
			//giovanni spinelli 27/03/2019  - change static query with dinamic query - end	
			
			
			//AND OB_Componente__r.NE__Parent_Catalog_Item__r.NE__Product_Category_Name__c='COMPONENTI DI PREZZO'
			
			//query to get listini
			/*
			res.configurazioniListTotal = [
				SELECT OB_ModelloAcquiring__c,OB_SchemaPrezzi__c,OB_Componente__c,OB_Componente__r.NE__Product_Name__c,OB_Componente__r.NE__Item_Header__c,Name,OB_Componente__r.NE__ProductId__c,OB_Listino__r.Name 
				FROM NE__Matrix_Parameter__c 
				WHERE recordType.DeveloperName = 'OB_PriceList'
				ORDER BY  OB_Componente__r.NE__Product_Name__c
			];
			//AND OB_Componente__r.NE__Parent_Catalog_Item__r.NE__Product_Category_Name__c='COMPONENTI DI PREZZO'
			*/
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
			 
			res.total =  [
				SELECT Count() 
				FROM NE__Matrix_Parameter__c 
				WHERE recordType.DeveloperName = 'OB_PriceNexi'  
				AND OB_Offerta__r.Name = :offerta 
			];
			//AND OB_Componente__r.NE__Parent_Catalog_Item__r.NE__Product_Category_Name__c='COMPONENTI DI PREZZO'
			
			return res;
        }
        catch(Exception e){
        	System.debug('Exception OB_ConfigurazioniTableController::getConfigurazioni' + e.getMessage() + ' at line: ' + e.getLineNumber());
        	return null;
        }	 
	} 



		//Doris D.    ...16/03/2019......Start.         //
	@AuraEnabled
    public static List<NE__Catalog_Item__c> listProducts() {

    	String catalogName = OB_offerCatalogController.catalogName;
    	List<NE__Catalog_Item__c> products = [
    		SELECT id, NE__Product_Name__c 
    		FROM NE__Catalog_Item__c 
    		WHERE NE__Root_Catalog_Item__c = null
    		AND NE__Catalog_Id__r.Name= :catalogName//'Catalogo_Nexi' 
    		AND NE__Type__c  ='Product'
			AND (  NE__ProductId__r.RecordType.DeveloperName = 'Terminali' 
				OR NE__ProductId__r.RecordType.DeveloperName = 'Vas'
				OR NE__ProductId__r.RecordType.DeveloperName = 'pagobancomat'
				OR NE__ProductId__r.RecordType.DeveloperName = 'Acquiring'
				OR NE__ProductId__r.RecordType.DeveloperName = 'Moto'
				OR NE__ProductId__r.RecordType.DeveloperName = 'eCommerce') //davide.franzini - WN-47 - 13/07/2019
			ORDER BY NE__Product_Name__c
			//davide.franzini - WN-66 - 23/07/2019 - added eCommerce and ordered
    		
    	];
    	
    	return products;
    }

	//Doris D.        ...16/03/2019.............. END //

	
	
	@AuraEnabled
	public static PageResult searchConfigurazioniServer(Decimal pageSize, Decimal pageNumber,List<String> nameProduct, String fromDate, String toDate,String offerta,String listino,List<String> schemaPrezzi, List<String> modello,String orderName, String sortDirection){
		// Doris D ..... 16/03/2019 : change String name to List<String> nameProduct
		Integer pSize = (Integer)pageSize;
        Integer offset = ((Integer)pageNumber - 1) * pSize;
        Integer totalRows = 0;
        String recordTypeName = 'OB_PriceNexi';
        
        try{
        	
	        String query = 'SELECT Id,Name,NE__Active__c,NE__End_Date__c,NE__Start_Date__c, OB_ModelloAcquiring__c,'+ 
	        'OB_SchemaPrezzi__c, OB_Componente__r.NE__Product_Name__c,OB_Componente__r.NE__Item_Header__c,OB_Listino__r.Name'+
			' FROM NE__Matrix_Parameter__c WHERE OB_Offerta__r.Name = :offerta AND recordType.DeveloperName = :recordTypeName '; 
	        
	        //AND OB_Componente__r.NE__Parent_Catalog_Item__r.NE__Product_Category_Name__c= :categoryName
	        
	        //.....................................................................//
	        // if(!String.isBlank(name)){
	        // 	query += ' AND OB_Componente__c = :name';
	        // }
			//.....................................................................//

			//Doris D. .....16/03/2019.......Start........// 
			 if(!nameProduct.isEmpty() ){	       	
	       		query += ' AND OB_Componente__r.NE__Product_Name__c in :nameProduct';
	        }
			//Doris D. .....16/03/2019.......end........// 
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
	        	//String fromDateString = fromDate.format('yyyy-MM-dd');
	        	query += ' AND NE__Start_Date__c >='+fromDate;
	        }
	        if(String.isNotBlank(toDate)){
	        	//String toDateString = toDate.format('yyyy-MM-dd');
	        	query += ' AND NE__End_Date__c <='+toDate;
	        }
	        //giovanni spinelli 27/03/2019  - order by not used for schema prezzi 
			String orderBy = null;
			if(orderName!='OB_SchemaPrezzi__c'){ 
				if(String.isNotBlank(orderName)){
					orderBy = orderName + '	' +sortDirection; 
					query+= '	ORDER BY '+orderBy+'  OFFSET ' +offset+'';	
				}else{
					orderBy=  'CreatedDate desc';
					query+= '	ORDER BY '+orderBy+'  OFFSET ' +offset+'';
				}
			}

	        //query += ' ORDER BY '+orderBy+'  OFFSET :offset';//giovanni spinelli remove LIMIT :pSize
	        PageResult res = new PageResult();
	        res.pageSize = pSize;
	        res.page = (Integer) pageNumber;
	        System.debug('QUERY is: '+query);
			//giovanni spinelli - skip if is order by schema prezzi
			if(orderName!='OB_SchemaPrezzi__c'){
				res.configurazioniList = Database.query(query);
			}
			
			
			String queryTotal = 'SELECT Count() FROM NE__Matrix_Parameter__c WHERE OB_Offerta__r.Name = :offerta  AND recordType.DeveloperName = :recordTypeName ';  
			
			//AND OB_Componente__r.NE__Parent_Catalog_Item__r.NE__Product_Category_Name__c= :categoryName
			
			// if(!String.isBlank(name)){
	        // 	queryTotal += ' AND OB_Componente__c = :name';
	        // }

			//Doris D. .....16/03/2019.......Start........// 
			 if(!nameProduct.isEmpty() ){	       		
	       		queryTotal += ' AND OB_Componente__r.NE__Product_Name__c in :nameProduct';
	        }
			//Doris D. .....16/03/2019.......end........//

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
	        	queryTotal += ' AND NE__Start_Date__c >='+fromDate;
	        }
	        if(String.isNotBlank(toDate)){
	        //	String toDateString = toDate.format('yyyy-MM-dd');
	        	queryTotal += ' AND NE__End_Date__c <='+toDate;
	        }
			
			res.total =  Database.countQuery(queryTotal);
						
			return res;
        }
        catch(Exception e){
        	System.debug('Exception OB_ConfigurazioniTableController::searchConfigurazioniServer' + e.getMessage() + ' at line: ' + e.getLineNumber());
        	return null;
        } 
	}
	
	@AuraEnabled
	public static PageResult creaConfigurazioneServer(Decimal pageSize, Decimal pageNumber,String name, String fromDate, String toDate,Id offerta,String listino,List<String> schemaPrezzi, List<String> modello){
		
		Date fromDateNotTime;
		Date toDateNotTime;
        if(String.isNotBlank(fromDate)){
        	fromDateNotTime = Date.valueOf(fromDate);
        }
        if(String.isNotBlank(toDate)){
       		toDateNotTime = Date.valueOf(toDate);
        }

		Integer pSize = (Integer)pageSize;
        Integer offset = ((Integer)pageNumber - 1) * pSize;
        Integer totalRows = 0;
        String recordTypeName = 'OB_PriceNexi';
        
        NE__Matrix_Parameter__c newMatrix = new NE__Matrix_Parameter__c();
        try{
	        //formal checks of required fields 
	        newMatrix.NE__Active__c = true;
	        Id recordTypeId = Schema.SObjectType.NE__Matrix_Parameter__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
	        Id recordTypeIdRow = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
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
	        	//fromDateNotTime = date.newinstance(fromDate.year(), fromDate.month(), fromDate.day());
	        	newMatrix.NE__Start_Date__c = fromDateNotTime;
	        }
	        if(toDate != null){
	        	//toDateNotTime = date.newinstance(toDate.year(), toDate.month(), toDate.day());
	        	newMatrix.NE__End_Date__c = toDateNotTime;
	        }
	        
	        PageResult res = new PageResult();
	        res.pageSize = pSize;
	        res.page = (Integer) pageNumber;
	        System.debug('New Matrix is: '+newMatrix);
			
			//check for duplicate entry
			List<NE__Matrix_Parameter__c> duplicateCheckList = [
				SELECT Id,OB_Componente__r.NE__Product_Name__c, OB_Componente__c, OB_Componente__r.NE__Item_Header__c
				FROM NE__Matrix_Parameter__c 
				WHERE OB_Componente__c = :newMatrix.OB_Componente__c 
				AND NE__Start_Date__c = :newMatrix.NE__Start_Date__c
				//AND OB_Listino__c = :newMatrix.OB_Listino__c
				AND OB_SchemaPrezzi__c = :newMatrix.OB_SchemaPrezzi__c
				AND OB_ModelloAcquiring__c = :newMatrix.OB_ModelloAcquiring__c 
				AND NE__End_Date__c = :newMatrix.NE__End_Date__c 
				AND OB_Offerta__c = :offerta
				AND recordType.DeveloperName = 'OB_PriceNexi' 
				];
			
			//AND OB_Componente__r.NE__Parent_Catalog_Item__r.NE__Product_Category_Name__c='COMPONENTI DI PREZZO'
			Id newId;
			if(duplicateCheckList.size() <= 0){
				Database.SaveResult sr = Database.insert(newMatrix); 
				
				//update some values after insert
				newId = sr.getId();
				NE__Matrix_Parameter__c MatrixToUpdate = [SELECT id,OB_SchemaPrezzi__c, OB_Listino__r.Name,OB_ModelloAcquiring__c,NE__Start_Date__c, NE__End_Date__c, OB_Componente__c,OB_Componente__r.NE__Catalog_Id__r.NE__Catalog_Header__c,OB_Listino__c,OB_Componente__r.NE__ProductId__c,OB_Componente__r.NE__Product_Name__c, OB_Componente__r.NE__Item_Header__c FROM NE__Matrix_Parameter__c WHERE id = :newId LIMIT 1];
				
				//System.debug('$TEST2$ '+MatrixToUpdate.OB_Componente__r.NE__Catalog_Id__r.NE__Catalog_Header__c);
				MatrixToUpdate.Name = MatrixToUpdate.OB_Componente__r.NE__Product_Name__c;
				MatrixToUpdate.NE__Catalog_Header__c = MatrixToUpdate.OB_Componente__r.NE__Catalog_Id__r.NE__Catalog_Header__c;
				MatrixToUpdate.OB_Product__c = MatrixToUpdate.OB_Componente__r.NE__ProductId__c;
				update MatrixToUpdate;
				
				res.configurazione = MatrixToUpdate;
				//END
				//francesca.ribezzi: selecting matrix parameter rows associated with the selected price list:
				List<NE__Matrix_Parameter_Row__c> rowList =
		    	 [
		    		SELECT RecordTypeId, RecordType.DeveloperName, NE__Matrix_Parameter__r.NE__Name__c, NE__Matrix_Parameter__r.OB_Offerta__r.Name, NE__Matrix_Parameter__r.OB_Componente__r.NE__ProductId__r.Name, NE__Matrix_Item_Identifier__c, NE__Parent_External_Id__c, NE__Source_External_Id__c, OB_Visible__c, OB_Default_Banca__c, OB_Utilizzato_per_la_BANCA__c, OB_Family__r.NE__Source_Family_Id__c, OB_ABI_BANCA__c, OB_DynamicPropertyDefinition__r.NE__Source_Dynamic_Property_Id__c, OB_Componente__r.NE__Id__c, OB_Product__r.NE__Source_Product_Id__c, OB_Cab__c, OB_Hidden__c, OB_Schema_Prezzi__c, OB_ModelloAcquiring__c, OB_SelfLookup__r.NE__RequestId__c,OB_Codici__c, NE__Active__c, OB_DynamicPropertyDefinition__c,OB_DynamicPropertyDefinition__r.Name, OB_DynamicPropertyDefinition__r.NE__Description__c, OB_Family__c, OB_Family__r.Name, OB_ReadOnly__c,OB_Read_Only_banca__c,OB_SelfLookup__c, OB_Sequence__c, id, Name, OB_Componente__r.Ne__product_name__c,OB_Componente__r.Ne__productId__c, OB_Componente__r.Ne__productId__r.Ne__description__c, OB_Componente__r.NE__Item_Header__c,NE__RequestId__c,NE__Matrix_Parameter__r.Name, NE__Matrix_Parameter__c, NE__Matrix_Parameter__r.NE__Start_Date__c,  NE__Matrix_Parameter__r.NE__End_Date__c, NE__End_Date__c,NE__Start_Date__c, OB_Product__c, OB_Product__r.name, OB_Product__r.NE__Description__c, OB_Componente__c,OB_Massimale__c,OB_Massimo__c,OB_Minimo__c,OB_Soglia_Max_Approvazione__c,OB_Soglia_Min_Approvazione__c,OB_Valore_Default__c   
		    		FROM NE__Matrix_Parameter_Row__c 
		    		WHERE recordType.DeveloperName = 'OB_PriceList'
		    		AND NE__Matrix_Parameter__c = :listino
		    		ORDER BY OB_SelfLookup__c ASC
		    	];
		    	System.debug('newId: ' + newId);
		    	System.debug('rowList: ' + rowList);
		    	
		    	//creating list of parent rows:
		    	List<NE__Matrix_Parameter_Row__c> parentRows =  new List<NE__Matrix_Parameter_Row__c>();
		    	for(NE__Matrix_Parameter_Row__c parentRow : rowList){
		    		if(parentRow.OB_SelfLookup__c == null){
		    			NE__Matrix_Parameter_Row__c newRow = parentRow.clone(false, true, false, false);
		    			newRow.recordTypeId = recordTypeIdRow;
						newRow.NE__Matrix_Parameter__c = newId;
                        newRow.NE__Active__c = true;
						//creating an external id composed by the externalId and matrix parameter's id:
		    			newRow.NE__RequestId__c += '_'+newId;
		    			parentRows.add(newRow);
		    		}
		    	}
		    	try{
					insert parentRows;
				}catch(Exception e){
					System.debug('Exception OB_ConfigurazioniTableController::creaListinoServer' + e.getMessage() + ' at line: ' + e.getLineNumber());
				}
		    	//mappa string id, externalid
		    	Map<String, String> mapExternalIdrowId = new Map<String, String>();
		    	for(NE__Matrix_Parameter_Row__c row : parentRows){
		    		mapExternalIdrowId.put(row.NE__RequestId__c, row.id);
		    		
		    	}
		    	
				//francesca.ribezzi: adding the current matrix parameter id to the matrix parameter row child list:
				List<NE__Matrix_Parameter_Row__c> rowsToInsert =  new List<NE__Matrix_Parameter_Row__c>();
				for(Integer i = 0; i<rowList.size(); i++){
					if(rowList[i].OB_SelfLookup__c != null){
						NE__Matrix_Parameter_Row__c newRow = rowList[i].clone(false, true, false, false);
						//creating a new row with external id equals to parent's externalId plus matrixParameterId:
						//NE__Matrix_Parameter_Row__c parentReference = new NE__Matrix_Parameter_Row__c(NE__RequestId__c = newRow.OB_SelfLookup__r.NE__RequestId__c +'_'+ newId);
						newRow.OB_SelfLookup__c = mapExternalIdrowId.get(newRow.OB_SelfLookup__r.NE__RequestId__c +'_'+ newId);
						//newRow.OB_SelfLookup__r = parentReference;
						newRow.recordTypeId = recordTypeIdRow;
						newRow.NE__Matrix_Parameter__c = newId;
						newRow.OB_Schema_Prezzi__c = newMatrix.OB_SchemaPrezzi__c;
						newRow.OB_ModelloAcquiring__c = newMatrix.OB_ModelloAcquiring__c;
                        newRow.NE__Active__c = true;
						rowsToInsert.add(newRow);
					}
				}
				
				System.debug('rowsToInsert: ' + rowsToInsert);
				//updating the rowlist with its matrixparameterId:
				try{
					insert rowsToInsert;
				}catch(Exception e){
					System.debug('Exception OB_ConfigurazioniTableController::creaListinoServer' + e.getMessage() + ' at line: ' + e.getLineNumber());
				}
			
				System.debug('new rowsToInsert: ' + rowsToInsert);
				
			
			}
			else{
				System.debug('Duplicate Alert '+duplicateCheckList.size());
				res.configurazione = duplicateCheckList[0];
			}
			
			
			
			res.configurazioniList = [
				SELECT Id,Name,NE__Active__c,NE__End_Date__c,NE__Start_Date__c, OB_ModelloAcquiring__c, OB_SchemaPrezzi__c, OB_Componente__c,OB_Componente__r.NE__Product_Name__c,OB_Componente__r.NE__Item_Header__c,OB_Listino__r.Name
				FROM NE__Matrix_Parameter__c WHERE OB_Offerta__c = :offerta AND recordType.DeveloperName = 'OB_PriceNexi'  
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
        String recordTypeName = 'OB_PriceNexi';
        
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
				FROM NE__Matrix_Parameter__c WHERE OB_Offerta__r.Name = :offerta AND recordType.DeveloperName = 'OB_PriceNexi'
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
    	String searchInput = searchText+'%';
    	String catalogName = OB_offerCatalogController.catalogName;//'Catalogo_Nexi';
    	List<NE__Catalog_Item__c> products = [
    		SELECT Id, NE__Product_Name__c 
    		FROM NE__Catalog_Item__c 
    		WHERE NE__Root_Catalog_Item__c = null
    		AND NE__Catalog_Id__r.Name= :catalogName
    		AND NE__Type__c  ='Product'
    		AND NE__Product_Name__c LIKE  :searchInput 
    	];
    	
    	return products;
    }
    
    @AuraEnabled
    public static List<NE__Matrix_Parameter__c> searchForCatalogs(String searchText){
    	String searchInput = searchText+'%';
    	
    	List<NE__Matrix_Parameter__c> listini = [
				SELECT Id,Name,NE__Active__c,NE__End_Date__c,NE__Start_Date__c,OB_Componente__c,OB_Componente__r.NE__Item_Header__c   
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
		// Doris D. 18/03/2019....
		 @AuraEnabled
        public List<NE__Catalog_Item__c> products { get;set; }
		 
		// Doris D. 18/03/2019....end
        
    }
    
	
}