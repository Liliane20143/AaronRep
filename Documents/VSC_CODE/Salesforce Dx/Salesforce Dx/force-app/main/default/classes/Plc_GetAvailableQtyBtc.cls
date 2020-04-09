/**
* author Campese Emanuele
* @date Creation 28/02/2019
* @version 1.0
* @description Plc_GetAvailableQtyBtc - Batch
*/
public with sharing class Plc_GetAvailableQtyBtc extends Plc_MasterBatchable {

	Map<String,Decimal> availableQtyMap = new Map<String,Decimal>();
	Map<String,Decimal> orderedQtyMap = new Map<String,Decimal>();
	Map<String,Plc_WarehouseSolution__c> wareHouseSolutionMap = new Map<String,Plc_WarehouseSolution__c>();
	Map<Id,String> solutionName = new Map<Id,String>();
	Map<Id,String> warehouseName = new Map<Id,String>();
	Double totalExecutionTime;
	Boolean retrieveWareHouseSolution = true;
	Datetime LastConsumedExecutionDate;

    override public String getDynamicQuery(){

        String query = 'SELECT Plc_AvailableQty__c,Plc_OrderedQty__c,Bit2Shop__Warehouse_Id__c, Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__c,'+
														'Bit2Shop__Warehouse_Id__r.Name,Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__r.Name'+
														' FROM Bit2Shop__Product_Stock__c';
        
        LogTracker.debugLog(getBatchName(), 'getDynamicQuery', query);
        return query;
    }
    override public String getBatchName() {
        
        return Plc_GetAvailableQtyBtc.class.getName();
    }
    
    public void execute(Database.BatchableContext batchableContext, List<Bit2Shop__Product_Stock__c> productStockList)  {
		if(totalExecutionTime == null){
			totalExecutionTime = 0;
		}
		DateTime chunkTime = DateTime.now();

        LogTracker.debugLog('Plc_GetAvailableQtyBtc','execute','###START!###');

		//FOR EACH WAREHOUSE SOLUTION
		// MM todo
		// TODO Questa query è assimilabile alle prcedenti eseguite su Plc_WarehouseSolution__c
		if(retrieveWareHouseSolution){
			Boolean foundLastConsumedExecutionDate = false;
			for(Plc_WarehouseSolution__c wareHouseSolution : [SELECT Id,Plc_Solution__c,Plc_Warehouse__c,Plc_AvailableQty__c,
														         Plc_ConsumedQty__c,Plc_CorrectionQty__c,
														         Plc_OrderedQty__c,Plc_Warehouse__r.Name,
														         Name,Plc_Solution__r.Name,Plc_ConsumedExecutionDate__c
														  FROM Plc_WarehouseSolution__c ORDER BY Plc_ConsumedExecutionDate__c DESC]){
				//POPULATE THE MAP WITH KEY(SOLUTION ID,WAREHOSUE ID) AND THE WarehouseSolution Object
				if(!foundLastConsumedExecutionDate){
					LastConsumedExecutionDate = wareHouseSolution.Plc_ConsumedExecutionDate__c;
					foundLastConsumedExecutionDate = true;
				}
				if(!wareHouseSolutionMap.containsKey(wareHouseSolution.Plc_Solution__c+'_'+wareHouseSolution.Plc_Warehouse__c)){
					wareHouseSolutionMap.put(wareHouseSolution.Plc_Solution__c+'_'+wareHouseSolution.Plc_Warehouse__c,wareHouseSolution);
				}
			}
			retrieveWareHouseSolution=false;
		}

        //FOR EACH PRODUCT STOCK 
		for (Bit2Shop__Product_Stock__c productStock : productStockList){

			if(availableQtyMap.containsKey(productStock.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__c+'_'+productStock.Bit2Shop__Warehouse_Id__c))
			{	
				//CREATE A MAP WITH THE AVAILABLE QTY AND ORDERED QTY - KEY(SOLUTION ID,WAREHOUSE ID) AND Integer QTY
				availableQtyMap.put(productStock.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__c+'_'+productStock.Bit2Shop__Warehouse_Id__c,
									availableQtyMap.get(productStock.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__c+'_'+productStock.Bit2Shop__Warehouse_Id__c)+productStock.Plc_AvailableQty__c);
			
				orderedQtyMap.put(productStock.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__c+'_'+productStock.Bit2Shop__Warehouse_Id__c,
									orderedQtyMap.get(productStock.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__c+'_'+productStock.Bit2Shop__Warehouse_Id__c)+productStock.Plc_OrderedQty__c);
			}
			else
			{	
				//CREATE A MAP WITH THE AVAILABLE QTY AND ORDERED QTY - KEY(SOLUTION ID,WAREHOUSE ID) AND Integer QTY
				availableQtyMap.put(productStock.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__c+'_'+productStock.Bit2Shop__Warehouse_Id__c,productStock.Plc_AvailableQty__c);
			
				orderedQtyMap.put(productStock.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__c+'_'+productStock.Bit2Shop__Warehouse_Id__c,productStock.Plc_OrderedQty__c);
			}
				warehouseName.put(productStock.Bit2Shop__Warehouse_Id__c,productStock.Bit2Shop__Warehouse_Id__r.Name);
				solutionName.put(productStock.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__c,productStock.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__r.Name);

		}
		
		

		for(String keySolWhouse : availableQtyMap.keySet()){
			//System.debug('HERE : keySolWhouse '+keySolWhouse);
			if(wareHouseSolutionMap.containsKey(keySolWhouse))
			{
				wareHouseSolutionMap.get(keySolWhouse).Plc_AvailableQty__c=availableQtyMap.get(keySolWhouse);
				wareHouseSolutionMap.get(keySolWhouse).Plc_OrderedQty__c=orderedQtyMap.get(keySolWhouse);
			}
			else
			{	
				Plc_WarehouseSolution__c tempWareHouseSolution = new Plc_WarehouseSolution__c();
				tempWareHouseSolution.Plc_AvailableQty__c=availableQtyMap.get(keySolWhouse);
				tempWareHouseSolution.Plc_OrderedQty__c=orderedQtyMap.get(keySolWhouse);
				tempWareHouseSolution.Plc_ConsumedQty__c=0;
				tempWareHouseSolution.Plc_CorrectionQty__c=0;
				tempWareHouseSolution.Plc_SpecificConsumedQty__c = 0;
				String[] addressFull = keySolWhouse.split('_');
				System.debug('**** addressFull[0]: '+addressFull[0]);
				System.debug('**** addressFull[1]: '+addressFull[1]);
				if(String.isNotBlank(addressFull[0]) && addressFull[0]!=null){
					tempWareHouseSolution.Plc_Solution__c=addressFull[0];
					tempWareHouseSolution.Plc_Warehouse__c=addressFull[1];
					tempWareHouseSolution.Name=warehouseName.get(tempWareHouseSolution.Plc_Warehouse__c)+' '+solutionName.get(tempWareHouseSolution.Plc_Solution__c);

					System.debug('**** add to list: '+addressFull[0]+'_'+addressFull[1]);
				}else{
					System.debug('**** ATTENZIONE MANCA SOLUTION PER WAREHOUSE: '+tempWareHouseSolution.Name);	
				}
				tempWareHouseSolution.Plc_ConsumedExecutionDate__c = LastConsumedExecutionDate;
				wareHouseSolutionMap.put(keySolWhouse,tempWareHouseSolution);
			}
		}
		
        		totalExecutionTime = totalExecutionTime + chunkTime.getTime();
    }

    public void finish(Database.BatchableContext batchableContext) {
    	LogTracker.debugLog('Plc_GetAvailableQtyBtc','execute','###FINISH!###');
		System.debug('DIMENSIONE LISTA TOTALE: '+ wareHouseSolutionMap.values().size() );
		System.debug('DIMENSIONE MAPPA SOLUZIONE WAREHOUSE: '+availableQtyMap.size() );
    	try{
			if(wareHouseSolutionMap.size() > 0){
    			upsert wareHouseSolutionMap.values();
    		}
			availableQtyMap.clear();
			orderedQtyMap.clear();
			wareHouseSolutionMap.clear();
			wareHouseSolutionMap.clear();
			Plc_LogHelper.logStructure log = new Plc_LogHelper.logStructure();
			Plc_BatchSettings__mdt batchToRetrieve = [SELECT Plc_BatchClassName__c,Plc_SchedulerClassName__c,Label  FROM Plc_BatchSettings__mdt WHERE Plc_BatchClassName__c = :getBatchName() LIMIT 1];
			log.schedulerName=batchToRetrieve.Plc_SchedulerClassName__c;
			log.responseMessage='';
			log.responseStatus = 'S';
			log.executionTimeStep2 = totalExecutionTime;
			log.requestBody = 'WarehouseSolution updated: ['+wareHouseSolutionMap.values().size()+']';
			log.recordType = 'Plc_Batch';
			Plc_LogHelper.logCall(log);

			Plc_BatchManagerService.executebatch('Plc_WarehouseSolutionConsumedQtyJob');
		}catch(Exception ex){
			Plc_LogHelper.logStructure log = new Plc_LogHelper.logStructure();
			Plc_BatchSettings__mdt batchToRetrieve = [SELECT Plc_BatchClassName__c,Plc_SchedulerClassName__c,Label  FROM Plc_BatchSettings__mdt WHERE Plc_BatchClassName__c = :getBatchName() LIMIT 1];
			log.schedulerName=batchToRetrieve.Plc_SchedulerClassName__c;
			log.responseMessage='';
			log.responseStatus = 'E';
			log.executionTimeStep2 = totalExecutionTime;
			log.requestBody = ex.getMessage();
			log.recordType = 'Plc_Batch';
			Plc_LogHelper.logCall(log);
		}
		

		
    }
    
}