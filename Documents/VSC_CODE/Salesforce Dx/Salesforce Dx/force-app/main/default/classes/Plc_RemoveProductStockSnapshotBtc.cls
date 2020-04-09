/**
 * @author Emanuele Campese
 * @date Creation 14/03/2019
 * @description Plc_RemoveProductStockSnapshotBtc - Batch 'Plc_RemoveProductStockSnapshotBtc'.
 */
public with sharing class Plc_RemoveProductStockSnapshotBtc extends Plc_MasterBatchable {
	List<Plc_ProductStockSnapshot__c> productStcokSnapshotToDeleteList = new List<Plc_ProductStockSnapshot__c>();
	
	Plc_SystemSettings__c PROCESS_SETTINGS = Plc_SystemSettings__c.getInstance();
	Decimal x = PROCESS_SETTINGS.Plc_MonthsToRemovePrdSnpShot__c;
	Double totalExecutionTime=0;

	DateTime dt = DateTime.now();	Integer numberOfMonths = Integer.valueOf(x);

	String myDate ;

	override public String getDynamicQuery() {

		System.debug('EMACAMPESE');
		myDate = dt.addMonths(-numberOfMonths).format('y-MM-dd')+'T'+'00:00:00-00:00';

		String query='SELECT Id,Plc_Timestamp__c';

		String queryCondition=' FROM Plc_ProductStockSnapshot__c WHERE Plc_Timestamp__c < '+myDate;

		return query+queryCondition;
	}
	
	override public String getBatchName() {

		return Plc_RemoveProductStockSnapshotBtc.class.getName();
	}

	public void execute(Database.BatchableContext batchableContext, List<Plc_ProductStockSnapshot__c> productStock)  {
										DateTime chunkTime = DateTime.now();

		for(Plc_ProductStockSnapshot__c newProductStockSnapshotFromList : productStock){
			
			if(Limits.getHeapSize() < (Limits.getLimitHeapSize()*0.9 ) ){
				productStcokSnapshotToDeleteList.add(newProductStockSnapshotFromList);
			}
			
		}
									totalExecutionTime = totalExecutionTime + Integer.valueOf(chunkTime.getTime() );


	}
	public void finish(Database.BatchableContext batchableContext) {

		try{
			if(productStcokSnapshotToDeleteList.size()>0 ){
				if(!Plc_Utils.checkCrudObjectPermission('Plc_ProductStockSnapshot__c','DELETE') ){
					throw new Plc_Exception('Plc_ProductStockSnapshot__c is not deletable');
				}
				delete productStcokSnapshotToDeleteList;
			}
			Plc_LogHelper.logStructure log = new Plc_LogHelper.logStructure();
			Plc_BatchSettings__mdt batchToRetrieve = [SELECT Plc_BatchClassName__c,Plc_SchedulerClassName__c,Label  FROM Plc_BatchSettings__mdt WHERE Plc_BatchClassName__c = :getBatchName() LIMIT 1];
			log.schedulerName=batchToRetrieve.Plc_SchedulerClassName__c;
			log.responseMessage='';
			log.responseStatus = 'S';
			log.executionTimeStep2 = totalExecutionTime;
			log.requestBody = 'Product Stock Snapshots deleted: ['+productStcokSnapshotToDeleteList.size()+']';
			log.recordType = 'Plc_Batch';
			Plc_LogHelper.logCall(log);
		}catch(Exception ex){
			Plc_LogHelper.logStructure log = new Plc_LogHelper.logStructure();
			Plc_BatchSettings__mdt batchToRetrieve = [SELECT Plc_BatchClassName__c,Plc_SchedulerClassName__c,Label  FROM Plc_BatchSettings__mdt WHERE Plc_BatchClassName__c = :getBatchName() LIMIT 1];
			log.schedulerName=batchToRetrieve.Plc_SchedulerClassName__c;
			log.responseMessage='';
			log.responseStatus = 'E';
			log.executionTimeStep2 = totalExecutionTime;log.requestBody = ex.getMessage();log.recordType = 'Plc_Batch';Plc_LogHelper.logCall(log);
		}
		
	}
}