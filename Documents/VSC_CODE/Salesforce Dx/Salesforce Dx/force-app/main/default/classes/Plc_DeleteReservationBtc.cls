/**
* author Pietro Santochirico
* @date Creation 28/02/2019
* @ModifiedBy Campese Emanuele 01/03/2019
* @version 1.0
* @description Plc_DeleteReservationBtc - Batch
*/
public with sharing class Plc_DeleteReservationBtc extends Plc_MasterBatchable { 
	List<Plc_Reservation__c> listToDelete = new List<Plc_Reservation__c>();
		Double totalExecutionTime=0;

	override public String getDynamicQuery(){
		Plc_ProcessSettings__c csMaxDays = Plc_ProcessSettings__c.getOrgDefaults();
		Integer days = (Integer)csMaxDays.Plc_MaxDaysToRetainReservations__c;

		String query = ' SELECT Id, Plc_Status__c, ';
		//Commented by shahid
	  /*  String subQuery='(SELECT Id,WorkOrderId.Status FROM WorkOrderLineItem WHERE (WorkOrderId.Status != \'Closed\' OR WorkOrderId.Status != \'Canceled\')  )';
		String queryConditions = ' FROM Plc_Reservation__c ' + 
			' WHERE (Plc_Status__c=\'NotReserved\') and CreatedDate < LAST_N_DAYS:' + days; */
		 String subQuery='(SELECT Id, WorkOrder.Status FROM Plc_WorkOrderLineItems__r WHERE WorkOrder.Status = \'Closed\' OR WorkOrder.Status = \'Canceled\')';
		String queryConditions = ' FROM Plc_Reservation__c ' + 
			'WHERE Plc_Status__c=\'NotReserved\' and CreatedDate < LAST_N_DAYS:' + days;
		
		query = query + subQuery + queryConditions;
		
		LogTracker.debugLog(getBatchName(), 'getDynamicQuery', query);
		return query;
	}
	override public String getBatchName() {
		
		return Plc_DeleteReservationBtc.class.getName();
	}
	
	public void execute(Database.BatchableContext batchableContext, List<Plc_Reservation__c> plcReservation)  {
		DateTime chunkTime = DateTime.now();

		LogTracker.debugLog('Plc_DeleteReservationBtc','execute','###START!###');
		for(Plc_Reservation__c reservation : plcReservation){
			if(reservation.Plc_WorkOrderLineItems__r.size()>0){
				listToDelete.add(reservation);
			}
		}
				totalExecutionTime = totalExecutionTime + chunkTime.getTime();

	}

	public void finish(Database.BatchableContext batchableContext) {
		try{
			if(listToDelete.size()>0){
				delete listToDelete;
			}
			Plc_LogHelper.logStructure log = new Plc_LogHelper.logStructure();
			Plc_BatchSettings__mdt batchToRetrieve = [SELECT Plc_BatchClassName__c,Plc_SchedulerClassName__c,Label  FROM Plc_BatchSettings__mdt WHERE Plc_BatchClassName__c = :getBatchName() LIMIT 1];
			log.schedulerName=batchToRetrieve.Plc_SchedulerClassName__c;
			log.responseMessage='';
			log.responseStatus = 'S';
			log.executionTimeStep2 = totalExecutionTime;
			log.requestBody = 'Reservation deleted: ['+listToDelete.size()+']';
			log.recordType = 'Plc_Batch';
			Plc_LogHelper.logCall(log);
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