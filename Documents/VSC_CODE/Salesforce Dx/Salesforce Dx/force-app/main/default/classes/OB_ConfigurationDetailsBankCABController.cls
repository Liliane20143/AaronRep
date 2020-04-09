public class OB_ConfigurationDetailsBankCABController {

//ALL THESE QUERIES ARE IN PROGRESS....
    @AuraEnabled
	public static List<NE__Matrix_Parameter_Row__c> getRowsByMatrixParameterId(String offerName, String abi, NE__Matrix_Parameter__c matrixParameter){
		List<NE__Matrix_Parameter_Row__c> rowList=
			[
				SELECT OB_Codici__c,NE__Active__c, OB_DynamicPropertyDefinition__c,OB_DynamicPropertyDefinition__r.Name, OB_DynamicPropertyDefinition__r.NE__Description__c, OB_Family__c, OB_Family__r.Name, OB_ReadOnly__c,OB_Read_Only_banca__c,OB_SelfLookup__c,OB_Sequence__c, id, Name, OB_Componente__r.Ne__product_name__c,OB_Componente__r.Ne__productId__c, OB_Componente__r.Ne__productId__r.Ne__description__c, NE__Matrix_Parameter__r.Name,  NE__Matrix_Parameter__r.NE__Start_Date__c,  NE__Matrix_Parameter__r.NE__End_Date__c, NE__End_Date__c,NE__Start_Date__c, OB_Product__c, OB_Product__r.name, OB_Product__r.NE__Description__c, OB_Componente__c,OB_Massimale__c,OB_Massimo__c,OB_Minimo__c,OB_Soglia_Max_Approvazione__c,OB_Soglia_Min_Approvazione__c,OB_Valore_Default__c 
				FROM NE__Matrix_Parameter_Row__c 
				WHERE NE__Matrix_Parameter__r.OB_Offerta__r.Name = :offerName 		 
				AND NE__Matrix_Parameter__c=:matrixParameter.Id 
				//AND OB_SelfLookup__c = ''
				AND OB_ABI_BANCA__c =: abi 
				AND recordType.DeveloperName = 'OB_PriceBankCAB'
				ORDER BY OB_SelfLookup__c ASC
			];
			
			return rowList;
	}
	
	@AuraEnabled
    public static Date calculateDate(String startDate){
		Date newDate = Date.valueof(startDate);
		Date endDateParent = newDate.addDays(-1);
		return endDateParent;
    }
	
	  @AuraEnabled
    public static List<NE__Matrix_Parameter_Row__c>  insertCloneRow(NE__Matrix_Parameter_Row__c rowParent, List<NE__Matrix_Parameter_Row__c> rowChildren){
		
		List<NE__Matrix_Parameter_Row__c> rowsToUpsert =  new List<NE__Matrix_Parameter_Row__c>();
		NE__Matrix_Parameter_Row__c newRowParent = rowParent.clone(false, true, false, false);
		//ParentChildrenRows parentChildrenRows = new ParentChildrenRows();
		//Date todayDate = System.today();
		//newRowParent.NE__Start_Date__c = todayDate;
		Date parentStartDate = rowParent.NE__Start_Date__c;
		newRowParent.NE__Start_Date__c = parentStartDate.addDays(+1);
		newRowParent.NE__End_Date__c = null;
		Id newId;
		try {   
		    Database.SaveResult sr = Database.insert(newRowParent); 
			newId = sr.getId(); 
		} catch(DmlException e) {
			System.debug('The following exception has occurred: ' + e.getMessage());
		}
		//setting date as yesterday:
		//rowParent.NE__End_Date__c = dateToClone.addDays(-1);
		
		for(Integer i = 0; i <rowChildren.size(); i++){	
			NE__Matrix_Parameter_Row__c newRowChild = new NE__Matrix_Parameter_Row__c();
			//cloning rowChildren[i]
			newRowChild = rowChildren[i].clone(false, true, false, false);
			newRowChild.NE__Start_Date__c= parentStartDate.addDays(+1);
			newRowChild.NE__End_Date__c= null;
			newRowChild.OB_SelfLookup__c = newId;
			rowsToUpsert.add(newRowChild);
		}
		try {   
		    upsert rowsToUpsert;
		} catch(DmlException e) {
		    System.debug('The following exception has occurred: ' + e.getMessage());
		}
		rowsToUpsert.add(newRowParent);
    	return rowsToUpsert;
    }
    
   @AuraEnabled //da utilizzare con il NEW 
    public static List<NE__Catalog_Item__c> getCatalogItems(String searchText){	
    	searchText = searchText+'%';
    	List<NE__Catalog_Item__c> catalogItems = 
    	[
	    	SELECT id, NE__product_Name__c,NE__ProductId__r.NE__Description__c, NE__ProductId__c, NE__ProductId__r.Name
	    	from NE__Catalog_Item__c 
	    	where NE__Root_Catalog_Item__c = null 
	    	and NE__Type__c  ='Product' 
	    	and NE__Product_Name__c LIKE :searchText
	    	AND NE__Catalog_Id__r.Name='Catalogo_Nexi' 
    	];
    	return catalogItems;
    }
    
    
      public static List<NE__Catalog_Item__c> getChildCatalogItems(String productId){	//id prodotto -> es: figli del pos
    	List<NE__Catalog_Item__c> catalogItems = 
    	[
	    	select Id, NE__Product_Name__c 
	    	from NE__Catalog_Item__c 
	    	where NE__Root_Catalog_Item__c = :productId 
	    	and NE__Type__c  ='Product' //and NE__Root_Catalog_Item__c in :posId
    	];
    	return catalogItems;
    }
    
    	
    @AuraEnabled
    public static List<NE__Matrix_Parameter_Row__c> updateRows(List<NE__Matrix_Parameter_Row__c> rowList){
      	System.debug('into updateRows...');

		if(rowList.size()>0){
	    	try {   
			    update rowList;
			} catch(DmlException e) {
			    System.debug('The following exception has occurred: ' + e.getMessage());
			}
		}
    	return rowList;
    }

     @AuraEnabled
    public static List<NE__Matrix_Parameter_Row__c> insertNewRowsServer(List<NE__Matrix_Parameter_Row__c> newRows,NE__Matrix_Parameter_Row__c newRow, String matrixParameterId){
    	System.debug('insertNewRowsServer...');
    	Id newId;
    	Id recordTypeId = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceBankCAB').getRecordTypeId();
    	newRow.RecordTypeId = recordTypeId;
    	newRow.NE__Matrix_Parameter__c = matrixParameterId;
    	//checking if newRows is not empty
    	if(newRows.size() > 0){
	    	newRow.OB_DynamicPropertyDefinition__c = newRows[0].OB_DynamicPropertyDefinition__c;
	    	newRow.OB_Family__c = newRows[0].OB_Family__c;
    	}
    	newRow.NE__Active__c = true;
    	
    	System.debug('newRow before insert: ' +newRow );
    	try {   
    	//inserting parent row to get its ID and setting it as its children selflookup:
		    Database.SaveResult sr = Database.insert(newRow); 
			newId = sr.getId(); 
		} catch(DmlException e) {
		    System.debug('The following exception has occurred into insertNewRowsServer: ' + e.getMessage());
		    return null;
		}
    	System.debug('ID newRow after insert: ' +newId );
    	
    	for(Integer i = 0; i<newRows.size(); i++){
    		newRows[i].OB_SelfLookup__c = newId;
    		newRows[i].NE__Start_Date__c = newRow.NE__Start_Date__c;
    		//newRows[i].OB_Product__c = newRow.OB_Product__c;
    		newRows[i].NE__Matrix_Parameter__c = matrixParameterId;
    		newRows[i].RecordTypeId = newRow.RecordTypeId;
    		newRows[i].NE__Active__c = true;
    	}
    	System.debug('list newRows before insert: ' +newRows );
		try {   
		    insert newRows;
			 return newRows;
		} catch(DmlException e) {
		    System.debug('The following exception has occurred into insertNewRowsServer: ' + e.getMessage());
		    return null;
		}
    
    }
    
    
    @AuraEnabled
    public static NE__Matrix_Parameter_Row__c insertNewRowServer(NE__Matrix_Parameter_Row__c newRow, String componente, NE__Matrix_Parameter__c matrixParameter){
    //	newRow.OB_Product__c = productId;
    	
    	newRow.NE__Matrix_Parameter__c =matrixParameter.Id;
    	newRow.OB_Componente__c = componente;
    	//newRow.OB_Componente__r.NE__Item_Header__c = matrixParameter.OB_Componente__r.NE__Item_Header__c;
    	//newRow.OB_Componente__r.NE__Parent_Catalog_Item__r.NE__Product_Category_Name__c='COMPONENTI DI PREZZO';
    	System.debug('newRow apex: ' +newRow );
		try {   
		    insert newRow;
			 return newRow;
		} catch(DmlException e) {
		    System.debug('The following exception has occurred: ' + e.getMessage());
		    return null;
		}
    
    }
    
     @AuraEnabled
    public static List< NE__ProductFamily__c> getFamiliesServer(String productId){

    	List< NE__ProductFamily__c> families = [
			SELECT id,NE__FamilyId__c, NE__FamilyId__r.Name, NE__FamilyId__r.NE__Hidden__c, NE__FamilyId__r.NE__Number_of_attributes__c, name 
			FROM NE__ProductFamily__c
			WHERE NE__ProdId__c =: productId
			ORDER BY NE__FamilyId__r.Name
    	];
    	
    	return families;
    }
    @AuraEnabled
    public static List<NE__ProductFamily__c> getFamiliesForChildrenRowsServer(List<NE__Product__c> products ){
	
    	List< NE__ProductFamily__c> families = [
		SELECT id,NE__FamilyId__c,NE__ProdId__c,NE__ProdId__r.Name, NE__FamilyId__r.Name, NE__FamilyId__r.NE__Hidden__c, NE__FamilyId__r.NE__Number_of_attributes__c, name 
		FROM NE__ProductFamily__c
		WHERE NE__ProdId__c IN :products
		ORDER BY NE__FamilyId__r.Name
		];
		//Set<NE__ProductFamily__c> famSet = new Set<NE__ProductFamily__c>(families);
		//List<NE__ProductFamily__c> listToReturn = new List<NE__ProductFamily__c>(famSet);
		List<NE__ProductFamily__c> listToReturn = new List<NE__ProductFamily__c>();
		
		Set<String> myset = new Set<String>();
        for(NE__ProductFamily__c f : families) {
            if(myset.add(f.NE__FamilyId__r.Name)){
                listToReturn.add(f);
            }
        }	
		return listToReturn;
    
    }
    @AuraEnabled
    public static List<NE__ProductFamilyProperty__c> retrieveAttributesFromFamilies(List<NE__family__c>  families){

    	List<NE__ProductFamilyProperty__c> attributes = [
			SELECT Name,NE__DefaultValue__c,NE__FamilyId__c,NE__FamilyId__r.Name,NE__Hidden__c,NE__PropId__c, NE__PropId__r.Name,  NE__PropId__r.NE__Description__c
			FROM NE__ProductFamilyProperty__c 
			WHERE NE__FamilyId__c 
			IN :families
			ORDER BY NE__FamilyId__r.Name
    	];
    	return attributes;
    }
    
        @AuraEnabled
    public static void deleteSelectedRow(List<NE__Matrix_Parameter_Row__c> listToDelete){
    	try {   
		     delete listToDelete;
		} catch(DmlException e) {
		    System.debug('The following exception has occurred into insertNewRowsServer: ' + e.getMessage());
		}
    	
    }
	
}