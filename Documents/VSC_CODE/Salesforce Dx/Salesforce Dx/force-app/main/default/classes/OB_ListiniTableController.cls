public with sharing class OB_ListiniTableController {
	
	@AuraEnabled
	public static PageResult getListini(Decimal pageSize, Decimal pageNumber){
		
		Integer pSize = (Integer)pageSize;
        Integer offset = ((Integer)pageNumber - 1) * pSize;
        Integer totalRows = 0;
        try{
	        PageResult res = new PageResult();
	        res.pageSize = pSize;
	        res.page = (Integer) pageNumber;
	        //francesca.ribezzi:  recordType.DeveloperName added in the WHERE condition:
	        //WHERE NE__Active__c = true  removed
			res.listiniList = [
				SELECT Id,Name,NE__Active__c,NE__End_Date__c,NE__Start_Date__c,OB_Componente__r.NE__Item_Header__c, OB_ModelloAcquiring__c, OB_SchemaPrezzi__c    
				FROM NE__Matrix_Parameter__c 
				WHERE recordType.DeveloperName = 'OB_PriceList'
				ORDER BY CreatedDate desc LIMIT :pSize OFFSET :offset
			];
			
	        //francesca.ribezzi: WHERE NE__Active__c = true  removed
			res.total =  [SELECT Count() FROM NE__Matrix_Parameter__c WHERE recordType.DeveloperName = 'OB_PriceList'];
			
			return res;
        }
        catch(Exception e){
        	System.debug('Exception OB_ListiniTableController::getListini' + e.getMessage() + ' at line: ' + e.getLineNumber());
        	return null;
        }	 
	} 
	
	@AuraEnabled
	public static PageResult searchListiniServer(Decimal pageSize, Decimal pageNumber,String name, String fromDate, String toDate){
		
		Integer pSize = (Integer)pageSize;
        Integer offset = ((Integer)pageNumber - 1) * pSize;
        Integer totalRows = 0;
		String recordTypeName = 'OB_PriceList';
        
        try{
	        String query = 'SELECT Id,Name,NE__Active__c,NE__End_Date__c,NE__Start_Date__c,OB_Componente__r.NE__Item_Header__c, OB_ModelloAcquiring__c, OB_SchemaPrezzi__c FROM NE__Matrix_Parameter__c WHERE recordType.DeveloperName = :recordTypeName '; 
	        
	        if(!String.isBlank(name)){
	        	query += ' AND Name LIKE \'%'+String.escapeSingleQuotes(name)+'%\'';
	        }
	        if(String.isNotBlank(fromDate)){
	        	//String fromDateString = fromDate.format('yyyy-MM-dd');
	        	query += ' AND NE__Start_Date__c >='+fromDate;
	        }
	        if(String.isNotBlank(toDate)){
	        	//String toDateString = toDate.format('yyyy-MM-dd');
	        	query += ' AND NE__End_Date__c <='+toDate;
	        }
	        
	        query += ' ORDER BY CreatedDate desc LIMIT :pSize OFFSET :offset';
	        PageResult res = new PageResult();
	        res.pageSize = pSize;
	        res.page = (Integer) pageNumber;
	        System.debug('QUERY is: '+query);
			res.listiniList = Database.query(query);
			
			String queryTotal = 'SELECT Count() FROM NE__Matrix_Parameter__c WHERE recordType.DeveloperName = :recordTypeName';  
			
			if(!String.isBlank(name)){
	        	queryTotal += ' AND Name LIKE \'%'+String.escapeSingleQuotes(name)+'%\'';
	        }
	        if(String.isNotBlank(fromDate)){
	        	//String fromDateString = fromDate.format('yyyy-MM-dd');
	        	queryTotal += ' AND NE__Start_Date__c >='+fromDate;
	        }
	        if(String.isNotBlank(toDate)){
	        	//String toDateString = toDate.format('yyyy-MM-dd');
	        	queryTotal += ' AND NE__End_Date__c <='+toDate;
	        }
			
			res.total =  Database.countQuery(queryTotal);
			
			return res;
        }
        catch(Exception e){
        	System.debug('Exception OB_ListiniTableController::searchListiniServer' + e.getMessage() + ' at line: ' + e.getLineNumber());
        	return null;
        } 
	}
	
	@AuraEnabled
	public static PageResult creaListinoServer(Decimal pageSize, Decimal pageNumber,String name, String fromDate, String toDate){ // DateTime fromDate, DateTime toDate
		
		Integer pSize = (Integer)pageSize;
        Integer offset = ((Integer)pageNumber - 1) * pSize;
        Integer totalRows = 0;
        String recordTypeName = 'OB_PriceList';
      //  System.debug('fromDate: ' + fromDate + 'toDate: ' + toDate);
        // 14/01/19
        Date fromDateNotTime;
        Date toDateNotTime;
        if(String.isNotBlank(fromDate)){
        	fromDateNotTime = Date.valueOf(fromDate);
        }
        if(String.isNotBlank(toDate)){
       		toDateNotTime = Date.valueOf(toDate);
        }
        
        NE__Matrix_Parameter__c newMatrix = new NE__Matrix_Parameter__c();
        try{
	        //formal checks of required fields 
	        newMatrix.NE__Active__c = true;
	        
	        
	        if(!String.isBlank(name)){
	        	newMatrix.Name = String.escapeSingleQuotes(name);
	        }
	        if(fromDate != null){
	        	//Date fromDateNotTime = date.newinstance(fromDate.year(), fromDate.month(), fromDate.day());
	        	newMatrix.NE__Start_Date__c = fromDateNotTime;
	        }
	        if(toDate != null){
	        	//Date toDateNotTime = date.newinstance(toDate.year(), toDate.month(), toDate.day());
	        	newMatrix.NE__End_Date__c = toDateNotTime;
	        }
	        //francesca.ribezzi:
	        //before inserting the new record, you need to set its recordTypeId...
	        Id recordTypeId = Schema.SObjectType.NE__Matrix_Parameter__c.getRecordTypeInfosByName().get('OB_PriceList').getRecordTypeId();
	        newMatrix.RecordTypeId  = recordTypeId;
	        
	        PageResult res = new PageResult();
	        res.pageSize = pSize;
	        res.page = (Integer) pageNumber;
	        System.debug('New Matrix is: '+newMatrix);
			
			//check for duplicate entry
			List<NE__Matrix_Parameter__c> duplicateCheckList = [SELECT Id FROM NE__Matrix_Parameter__c WHERE Name = :newMatrix.Name AND NE__Start_Date__c = :newMatrix.NE__Start_Date__c AND NE__End_Date__c = :newMatrix.NE__End_Date__c ];
			
			if(duplicateCheckList.size() <= 0){
				Database.SaveResult sr = Database.insert(newMatrix);
				/*
				Id newId = sr.getId();
				NE__Matrix_Parameter__c MatrixToUpdate = [SELECT id,OB_Componente__c,OB_Componente__r.NE__Catalog_Id__r.NE__Catalog_Header__c,OB_Componente__r.NE__ProductId__c,OB_Componente__r.NE__Product_Name__c FROM NE__Matrix_Parameter__c WHERE id = :newId LIMIT 1];
				
				//give him the catalog header
				MatrixToUpdate.NE__Catalog_Header__c = MatrixToUpdate.OB_Componente__r.NE__Catalog_Id__r.NE__Catalog_Header__c;
				update  MatrixToUpdate;
				*/
			}
			else{
				System.debug('Duplicate Alert '+duplicateCheckList.size());
			}
			//francesca.ribezzi:  recordType.DeveloperName added in the WHERE condition:
	        //WHERE NE__Active__c = true  removed
			res.listiniList = [
				SELECT Id,Name,NE__Active__c,NE__End_Date__c,NE__Start_Date__c,  OB_ModelloAcquiring__c, OB_SchemaPrezzi__c 
				FROM NE__Matrix_Parameter__c 
				//WHERE NE__Active__c = true 
				WHERE recordType.DeveloperName = 'OB_PriceList'
				ORDER BY CreatedDate desc LIMIT :pSize OFFSET :offset
			];
			
			
			String queryTotal = 'SELECT Count() FROM NE__Matrix_Parameter__c WHERE recordType.DeveloperName = :recordTypeName';  
			
			res.total =  Database.countQuery(queryTotal);
			
			return res;
        }
        catch(Exception e){
        	System.debug('Exception OB_ListiniTableController::creaListinoServer' + e.getMessage() + ' at line: ' + e.getLineNumber());
        	return null;
        } 
	}
	
	@AuraEnabled
	public static PageResult deleteListinoServer(Decimal pageSize, Decimal pageNumber,NE__Matrix_Parameter__c listinoToDelete){
		
		Integer pSize = (Integer)pageSize;
        Integer offset = ((Integer)pageNumber - 1) * pSize;
        Integer totalRows = 0;
        String recordTypeName = 'OB_PriceList';
        
        try{
	        
	        PageResult res = new PageResult();
	        res.pageSize = pSize;
	        res.page = (Integer) pageNumber;
	        System.debug('Matrix to delete is: '+listinoToDelete);
			
			//check if you can actually delete....
			
			Database.delete(listinoToDelete); 
			//francesca.ribezzi:  recordType.DeveloperName added in the WHERE condition:
	        //WHERE NE__Active__c = true  removed
			res.listiniList = [
				SELECT Id,Name,NE__Active__c,NE__End_Date__c,NE__Start_Date__c, OB_ModelloAcquiring__c, OB_SchemaPrezzi__c
				FROM NE__Matrix_Parameter__c 
				//WHERE NE__Active__c = true 
				WHERE recordType.DeveloperName = 'OB_PriceList'
				ORDER BY CreatedDate desc LIMIT :pSize OFFSET :offset
			];
			
			
			String queryTotal = 'SELECT Count() FROM NE__Matrix_Parameter__c WHERE recordtype.developerName= :recordTypeName';  
			
			res.total =  Database.countQuery(queryTotal);
			
			return res;
        }
        catch(Exception e){
        	System.debug('Exception OB_ListiniTableController::deleteListinoServer' + e.getMessage() + ' at line: ' + e.getLineNumber());
        	return null;
        } 
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
        public List<NE__Matrix_Parameter__c> listiniList { get;set; }
    }
    
    /*
    private List<SelectOption> getObjectFields() 
 	{
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();

        Schema.SObjectType ObjectSchema = schemaMap.get(selectedObject);

        Map<String, Schema.SObjectField> fieldMap = ObjectSchema.getDescribe().fields.getMap();


        List<SelectOption> fieldNames = new List<SelectOption>();
        for (String fieldName: fieldMap.keySet()) 
        {  
          String fName = fieldMap.get(fieldName).getDescribe().getLabel();
          fieldNames.add(new SelectOption(fName, fName));

        }
        return fieldNames;
  	}
  	*/      
	
}