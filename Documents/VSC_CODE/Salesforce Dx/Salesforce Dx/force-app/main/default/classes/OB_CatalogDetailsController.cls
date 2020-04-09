public class OB_CatalogDetailsController {
	
	@AuraEnabled   
    public static List<NE__Matrix_Parameter_Row__c> getRowsByMatrixParameterId(NE__Matrix_Parameter__c matrixParameter){
    	List<NE__Matrix_Parameter_Row__c> rowList = new List<NE__Matrix_Parameter_Row__c>();
    	// 14/01/19 - adding new fields to query: RecordTypeId, RecordType.DeveloperName, NE__Matrix_Parameter__r.NE__Name__c, NE__Matrix_Parameter__r.OB_Offerta__r.Name, NE__Matrix_Parameter__r.OB_Componente__r.NE__ProductId__r.Name, NE__Active__c, NE__Matrix_Item_Identifier__c, NE__Parent_External_Id__c, NE__RequestId__c, NE__Source_External_Id__c, OB_Visible__c, OB_Default_Banca__c, OB_Utilizzato_per_la_BANCA__c, OB_Family__r.NE__Source_Family_Id__c, OB_ABI_BANCA__c, OB_DynamicPropertyDefinition__r.NE__Source_Dynamic_Property_Id__c, OB_Componente__r.NE__Id__c, OB_Product__r.NE__Source_Product_Id__c, OB_Cab__c, OB_Hidden__c, OB_Schema_Prezzi__c, OB_ModelloAcquiring__c, OB_SelfLookup__r.NE__RequestId__c 
    	
    	rowList = [
    		SELECT RecordTypeId, RecordType.DeveloperName, NE__Matrix_Parameter__r.NE__Name__c, NE__Matrix_Parameter__r.OB_Offerta__r.Name, NE__Matrix_Parameter__r.OB_Componente__r.NE__ProductId__r.Name, NE__Matrix_Item_Identifier__c, NE__Parent_External_Id__c, NE__RequestId__c, NE__Source_External_Id__c, OB_Visible__c, OB_Default_Banca__c, OB_Utilizzato_per_la_BANCA__c, OB_Family__r.NE__Source_Family_Id__c, OB_ABI_BANCA__c, OB_DynamicPropertyDefinition__r.NE__Source_Dynamic_Property_Id__c, OB_Componente__r.NE__Id__c, OB_Product__r.NE__Source_Product_Id__c, OB_Cab__c, OB_Hidden__c, OB_Schema_Prezzi__c, OB_ModelloAcquiring__c, OB_SelfLookup__r.NE__RequestId__c, OB_Codici__c, OB_PriceId__c, NE__Active__c, OB_DynamicPropertyDefinition__c,OB_DynamicPropertyDefinition__r.Name, OB_DynamicPropertyDefinition__r.NE__Description__c, OB_Family__c, OB_Family__r.Name, OB_ReadOnly__c,OB_Read_Only_banca__c,OB_SelfLookup__c,OB_Sequence__c, id, Name, OB_Componente__r.Ne__product_name__c,OB_Componente__r.Ne__productId__c, OB_Componente__r.Ne__productId__r.Ne__description__c, NE__Matrix_Parameter__r.Name,  NE__Matrix_Parameter__r.NE__Start_Date__c,  NE__Matrix_Parameter__r.NE__End_Date__c, NE__End_Date__c,NE__Start_Date__c, OB_Product__c, OB_Product__r.name, OB_Product__r.NE__Description__c, OB_Componente__c,OB_Massimale__c,OB_Massimo__c,OB_Minimo__c,OB_Soglia_Max_Approvazione__c,OB_Soglia_Min_Approvazione__c,OB_Valore_Default__c 
    		FROM NE__Matrix_Parameter_Row__c 
    		WHERE NE__Matrix_Parameter__c = :matrixParameter.Id 
    		AND recordType.DeveloperName = 'OB_PriceList'
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
    public static List<NE__Matrix_Parameter_Row__c>  insertCloneRow(NE__Matrix_Parameter_Row__c rowParent, List<NE__Matrix_Parameter_Row__c> rowChildren, List<NE__Catalog_Item__c> catalogItemsToClone){
		System.debug('@@@rowChildren: ' + rowChildren);
		List<NE__Matrix_Parameter_Row__c> rowsToUpsert =  new List<NE__Matrix_Parameter_Row__c>();
		NE__Matrix_Parameter_Row__c newRowParent = rowParent.clone(false, true, false, false);
		System.debug('@@@newRowParent: ' + newRowParent);
       	Id recordTypeId = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceNexi').getRecordTypeId();
		//ParentChildrenRows parentChildrenRows = new ParentChildrenRows();
		//Date todayDate = System.today();
		//newRowParent.NE__Start_Date__c = todayDate;
		Date parentStartDate = rowParent.NE__Start_Date__c;
		newRowParent.NE__Start_Date__c = parentStartDate.addDays(1);
		newRowParent.NE__End_Date__c = null;
		newRowParent.RecordTypeId = recordTypeId;
		//newRowParent.OB_Componente__c =  //query getCatalogItemsByProductIdServer
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
			for(Integer j = 0;j<catalogItemsToClone.size(); j++){
				NE__Matrix_Parameter_Row__c newRowChild = new NE__Matrix_Parameter_Row__c();
				//cloning rowChildren[i]
				newRowChild = rowChildren[i].clone(false, true, false, false);
				newRowChild.NE__Start_Date__c= parentStartDate.addDays(1);
				newRowChild.NE__End_Date__c= null;
				newRowChild.OB_SelfLookup__c = newId; //newRowParent Id
				newRowChild.OB_Componente__c = catalogItemsToClone[j].Id;
				newRowChild.RecordTypeId = recordTypeId;
				rowsToUpsert.add(newRowChild);
			}
		}
		try {   
		    upsert rowsToUpsert;    
		    /*
			for(Integer j = 0; j< rowsToUpsert.size(); j++){
				if(rowsToUpsert[j].OB_SelfLookup__c == ''){
					parentChildrenRows.parent = rowsToUpsert[j];	
				}else{
					parentChildrenRows.children.add(rowsToUpsert[j]);
				}
			}*/
		} catch(DmlException e) {
		    System.debug('The following exception has occurred: ' + e.getMessage());
		}
		rowsToUpsert.add(newRowParent);
    	return rowsToUpsert;
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
    public static List<NE__Catalog_Item__c> getCatalogItemsByProductIdServer(String productName){
    	//SELECT OB_Componente__r.Ne__product_name__c FROM NE__Matrix_Parameter_row__c where NE__Matrix_Parameter__c = 'a0r9E000002ITfuQAG' 
    	List<NE__Catalog_Item__c> catalogItems=[
	    	SELECT id, NE__product_Name__c, NE__ProductId__r.NE__Description__c, NE__ProductId__c 
	    	FROM NE__Catalog_Item__c
	    	where NE__Root_Catalog_Item__r.NE__product_Name__c = :productName 
	    	
    	];
    	return catalogItems;
    }
    @AuraEnabled
    public static List<NE__Catalog_Item__c> fetchCatalogItemsByProductIdServer(String productName, List<NE__Product__c> prodIdList){
    	//SELECT OB_Componente__r.Ne__product_name__c FROM NE__Matrix_Parameter_row__c where NE__Matrix_Parameter__c = 'a0r9E000002ITfuQAG' 
    	Set<NE__Product__c> prodIdSet = new Set<NE__Product__c>(prodIdList);
    	
    	List<NE__Catalog_Item__c> catalogItems=[
	    	SELECT id, NE__product_Name__c,NE__ProductId__r.NE__Description__c, NE__ProductId__c 
	    	FROM NE__Catalog_Item__c
	    	where NE__Root_Catalog_Item__r.NE__product_Name__c = :productName
	    	AND NE__ProductId__c in : prodIdSet 
    	];
    	return catalogItems;
    }
    
    
    @AuraEnabled
    public static List<NE__Product__c> getCommercialProducts(List<NE__Matrix_Parameter_Row__c> rows){	
    	List<NE__Product__c> productFamilyList = 
    	[
    		select id,Name, NE__Description__c
    		from NE__Product__c 
    		where recordtype.developername ='Pricing'
    	];
    	//fare una set della lista
    	return productFamilyList;
    }
    
    
    @AuraEnabled
    public static List<NE__Matrix_Parameter_Row__c> insertNewRowsServer(List<NE__Matrix_Parameter_Row__c> newRows,NE__Matrix_Parameter_Row__c newRow, String matrixParameterId, NE__Matrix_Parameter__c matrixParameter){
    	System.debug('insertNewRowsServer...');
    	System.debug('matrixParameter: ' + matrixParameter);
    	Id newId;
    	Id recordTypeId = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceList').getRecordTypeId();
    	newRow.RecordTypeId = recordTypeId;
    	newRow.NE__Matrix_Parameter__c = matrixParameterId;
    	newRow.OB_DynamicPropertyDefinition__c = newRows[0].OB_DynamicPropertyDefinition__c;
    	newRow.OB_Family__c = newRows[0].OB_Family__c;
    	newRow.NE__Active__c = true;
    	newRow.OB_ModelloAcquiring__c = matrixParameter.OB_ModelloAcquiring__c;
        newRow.OB_Schema_Prezzi__c = matrixParameter.OB_SchemaPrezzi__c;
    	
    	System.debug('newRow before insert: ' +newRow );
    	try {   
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
    		newRows[i].OB_Product__c = newRow.OB_Product__c;
    		newRows[i].NE__Matrix_Parameter__c = matrixParameterId;
    		newRows[i].RecordTypeId = newRow.RecordTypeId;
    		newRows[i].NE__Active__c = true;
    		newRows[i].OB_Sequence__c = newRow.OB_Sequence__c;
    		newRows[i].OB_ModelloAcquiring__c = matrixParameter.OB_ModelloAcquiring__c;
        	newRows[i].OB_Schema_Prezzi__c = matrixParameter.OB_SchemaPrezzi__c;
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
    public static List< NE__ProductFamily__c> getFamiliesServer(String productId){
		/*List<NE__family__c> families = [
		SELECT Name,NE__Description__c,NE__Hidden__c,NE__Number_of_attributes__c,NE__Type__c, 
			(SELECT id, name 
			FROM NE__ProductFamily__r 
			WHERE NE__ProdId__c =: productId) 
			FROM NE__family__c
    	];*/
    	List< NE__ProductFamily__c> families = [
			SELECT id,NE__FamilyId__c, NE__FamilyId__r.Name, NE__FamilyId__r.NE__Hidden__c, NE__FamilyId__r.NE__Number_of_attributes__c, name 
			FROM NE__ProductFamily__c
			WHERE NE__ProdId__c =: productId
			ORDER BY NE__FamilyId__r.Name
    	];
    	
    	return families;
    }
    //commentato il 14/01/19:
    @AuraEnabled
    public static List<NE__ProductFamilyProperty__c> retrieveAttributesFromFamilies(List<Id>  families){
		String soql = '	SELECT Name,NE__DefaultValue__c,NE__FamilyId__c,NE__FamilyId__r.Name,NE__Hidden__c,NE__PropId__c, NE__PropId__r.Name,  NE__PropId__r.NE__Description__c FROM NE__ProductFamilyProperty__c WHERE NE__FamilyId__c IN :families ORDER BY NE__FamilyId__r.Name';
    	List<NE__ProductFamilyProperty__c> attributes = Database.query(soql);/*[
			SELECT Name,NE__DefaultValue__c,NE__FamilyId__c,NE__FamilyId__r.Name,NE__Hidden__c,NE__PropId__c, NE__PropId__r.Name,  NE__PropId__r.NE__Description__c
			FROM NE__ProductFamilyProperty__c 
			WHERE NE__FamilyId__c 
			IN :families
			ORDER BY NE__FamilyId__r.Name
    	];*/
    	return attributes;
    }
    
    /*@AuraEnabled
    public static List<NE__ProductFamilyProperty__c> getChildrenAttributes(List<NE__family__c>  families){
        
        List<NE__ProductFamilyProperty__c> attributes = [
			SELECT Name,NE__DefaultValue__c,NE__FamilyId__c,NE__FamilyId__r.Name,NE__Hidden__c,NE__PropId__c, NE__PropId__r.Name,  NE__PropId__r.NE__Description__c
			FROM NE__ProductFamilyProperty__c 
			WHERE NE__FamilyId__c 
			IN :families
			ORDER BY NE__FamilyId__r.Name
    	];
    	return attributes;
    
    }*/
    
    @AuraEnabled
    public static List<NE__Product__c> searchForProducts(String searchText){
    	String searchInput = '%'+searchText+'%';
    	List<NE__Product__c> products = [
    		select id,Name
    		from NE__Product__c 
    		where recordtype.developername ='Pricing'
    		AND Name LIKE  :searchInput 
    	];
    	
    	return products;
    }
    @AuraEnabled
    public static void deleteSelectedRow(List<NE__Matrix_Parameter_Row__c> listToDelete){
    	try {   
		     delete listToDelete;
		} catch(DmlException e) {
		    System.debug('The following exception has occurred into insertNewRowsServer: ' + e.getMessage());
		}
    	
    }
    
    
    
    
 /*   public class ParentChildrenRows {
        @AuraEnabled
        public List<NE__Matrix_Parameter_Row__c>  children { get;set; }
        
        @AuraEnabled
        public NE__Matrix_Parameter_Row__c parent { get;set; }
       
        
    }*/
}