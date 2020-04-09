/**
 * @author Emanuele Campese
 * @date Creation 15/03/2019
 * @description Plc_DeleteStockSerial2FromWarehouseBtc - Batch 'Plc_DeleteStockSerial2FromWarehouseBtc'.
 */
public with sharing class Plc_DeleteStockSerial2FromWarehouseBtc extends Plc_MasterBatchable {

	List<Bit2Shop__Stock_Serials2__c> stockSerialToDeleteList = new List<Bit2Shop__Stock_Serials2__c>();
	Double totalExecutionTime=0;
	Plc_ProcessSettings__c processSettings = Plc_ProcessSettings__c.getInstance();
	Integer numberOfDays = Integer.valueOf((Decimal) processSettings.Plc_DaysToDeleteStockSerial2New__c);

	override public String getDynamicQuery() {

		String myDate = DateTime.now().addDays(-numberOfDays).format('yyyy-MM-dd\'T00:00:00.000Z\'');// \'THH : mm: ss.SSSZ\'');
		//format('y-MM-dd')+'T'+'00:00:00-00:00';

		String query ='SELECT Id, CreatedDate, Bit2Shop__Status__c,Bit2Shop__Warehouse_Id__c FROM Bit2Shop__Stock_Serials2__c';

		String queryCondition =' WHERE Bit2Shop__Status__c =\'New\' AND Bit2Shop__Warehouse_Id__r.Plc_Tipology__c = \'New\' AND CreatedDate < ' + myDate;

		return query + queryCondition;
	}

	override public String getBatchName() {

		return Plc_DeleteStockSerial2FromWarehouseBtc.class.getName();
	}

	public void execute(Database.BatchableContext batchableContext, List<Bit2Shop__Stock_Serials2__c> stockSerial)  {
				        		DateTime chunkTime = DateTime.now();

		for(Bit2Shop__Stock_Serials2__c newStockSerialToDelete : stockSerial){
			stockSerialToDeleteList.add(newStockSerialToDelete);
		}
        		totalExecutionTime = totalExecutionTime + chunkTime.getTime();

	}
	public void finish(Database.BatchableContext batchableContext) {
		
		try{
			if(stockSerialToDeleteList.size()>0 ){
				if(!Plc_Utils.checkCrudObjectPermission('Bit2Shop__Stock_Serials2__c','DELETE') ){
					throw new Plc_Exception('Bit2Shop__Stock_Serials2__c is not deletable');
				}
				Database.delete(stockSerialToDeleteList,false);
			}		

			Plc_LogHelper.logStructure log = new Plc_LogHelper.logStructure();
			Plc_BatchSettings__mdt batchToRetrieve = [SELECT Plc_BatchClassName__c,Plc_SchedulerClassName__c,Label  FROM Plc_BatchSettings__mdt WHERE Plc_BatchClassName__c = :getBatchName() LIMIT 1];
			log.schedulerName=batchToRetrieve.Plc_SchedulerClassName__c;
			log.responseMessage='';
			log.responseStatus = 'S';
			log.executionTimeStep2 = totalExecutionTime;
			log.requestBody = 'Stock Serials deleted: ['+stockSerialToDeleteList.size()+']';
			log.recordType = 'Plc_Batch';
			Plc_LogHelper.logCall(log);
		}catch(Exception ex){
			Plc_LogHelper.logStructure log = new Plc_LogHelper.logStructure();
			Plc_BatchSettings__mdt batchToRetrieve = [SELECT Plc_BatchClassName__c,Plc_SchedulerClassName__c,Label  FROM Plc_BatchSettings__mdt WHERE Plc_BatchClassName__c = :getBatchName() LIMIT 1];log.schedulerName=batchToRetrieve.Plc_SchedulerClassName__c;log.responseMessage='';log.responseStatus = 'E';log.executionTimeStep2 = totalExecutionTime;log.requestBody = ex.getMessage();log.recordType = 'Plc_Batch';Plc_LogHelper.logCall(log);
		}
		
	}
}