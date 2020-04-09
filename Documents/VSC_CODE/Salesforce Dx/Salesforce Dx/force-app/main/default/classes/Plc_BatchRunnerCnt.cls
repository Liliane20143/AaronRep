public with sharing class Plc_BatchRunnerCnt {
	
	@AuraEnabled
	public static String getBatchStatus(String schedulerName)
	{
		String status = Label.Plc_AllAlIdle;
		Plc_BatchSettings__mdt batchToRetrieve = [SELECT Plc_BatchClassName__c,Plc_SchedulerClassName__c,Label  FROM Plc_BatchSettings__mdt WHERE Plc_SchedulerClassName__c = :schedulerName LIMIT 1];
		List<AsyncApexJob> asyncJobs = [SELECT CompletedDate, Status
			FROM AsyncApexJob
			WHERE ApexClass.Name=:batchToRetrieve.Plc_BatchClassName__c
				AND Status != 'Aborted' AND Status != 'Failed'
				AND CompletedDate = NULL
			ORDER BY CreatedDate DESC
			LIMIT 1];
		if (!asyncJobs.isEmpty()) {
			status = Label.Plc_AllAllRunning;
		}
		return status;
	}

	@AuraEnabled
	public static List<Plc_Log__c> getBatchExecutionsStatuses(String schedulerName)
	{
		// Da modificare questa dicitura per poter recuperare le ultime query presenti a sistema.
		System.debug('SchedulerName LOG: '+schedulerName);
		List<Plc_Log__c> logRetrieved = [Select Id,CreatedDate,Plc_ResponseStatus__c,Plc_TotalExecutionTime__c,Plc_RequestBody__c,Plc_SchedulerName__c
			From Plc_Log__c
			WHERE RecordTypeId = :Plc_Utils.getRecordTypeId('Plc_Batch', 'Plc_Log__c') AND Plc_SchedulerName__c = :schedulerName
			ORDER BY CreatedDate DESC
			LIMIT 10];
		System.debug('Log Ricevuti: '+logRetrieved);
		return logRetrieved;
	}

	@AuraEnabled
	public static Boolean runBatchByName(String batchName)
	{
		try{
			Plc_BatchManagerService.executeBatch(batchName);
			return true;
		}catch(Exception ex){
			return false;
		}
	}

	@AuraEnabled
	public static Boolean stopBatch(String schedulerName)
	{
		System.debug('stopBatch QUERY');
		System.debug('SchedulerName: '+schedulerName);

		Plc_BatchSettings__mdt batchToRetrieve = [SELECT Plc_BatchClassName__c,Plc_SchedulerClassName__c,Label  FROM Plc_BatchSettings__mdt WHERE Plc_SchedulerClassName__c = :schedulerName LIMIT 1];
		System.debug('BATCHCLASS NAME: '+batchToRetrieve.Plc_BatchClassName__c);
		List<AsyncApexJob> jobToAbort = [SELECT Id
			FROM AsyncApexJob
			WHERE ApexClass.Name=:batchToRetrieve.Plc_BatchClassName__c AND CompletedDate=null
			LIMIT 1];
		
		try{
			if(jobToAbort.size()>0){
				Plc_BatchManagerService.abortCurrentJob(new List<String>{jobToAbort[0].Id});
			}
			return true;
		}catch(Exception ex){
			return false;
		}
	}

	@AuraEnabled
	public static Map<String,Object> getBatchAvailable()
	{
		Map<String,Map<String,String>> response = new Map<String,Map<String,String>>();
		Map<String,String> batch = new Map<String,String>();
		Map<String,String> invertedLabel = new Map<String,String>();
		Map<String,String> schedulableData = new Map<String,String>();
		Map<String,String> batchError = new Map<String,String>();

		for(Plc_BatchSettings__mdt batchSettings : [SELECT Plc_BatchClassName__c,Plc_SchedulerClassName__c,Label,Plc_CustomPermission__c,Plc_Schedulability__c  FROM Plc_BatchSettings__mdt]){
			Boolean hasCustomPermission = FeatureManagement.checkPermission(batchSettings.Plc_CustomPermission__c);
			if (hasCustomPermission) {
				batch.put(batchSettings.Label,batchSettings.Plc_SchedulerClassName__c);
				schedulableData.put(batchSettings.Label,batchSettings.Plc_Schedulability__c);
			}
		}

		response.put('itemBatch',batch);
		response.put('schedulableData',schedulableData);
		System.debug('SCHEDULABLE DATA: '+schedulableData);
		
		if(batch.size()==0){
			batchError.put('error','error');
			response.put('errorList',batchError);
		}
		

		return response;
	}

	@AuraEnabled
    public static Map<String, String> retrieveTranslationMap(){
		Map<String, String> response = new Map<String,String>();
        //Getting Product Stock labels
		response.put('SelecttheBatchthatyouwanttolaunch',Label.Plc_AllAllSelectTheBatchThatYouWantTolaunch);
		response.put('Status',Label.Plc_AllAllStatus);
		response.put('Last10executions',Label.Plc_AllAllLastExecutions.replace('{0}','10') );
		response.put('Runbatch', Label.Plc_AllAllRunBatch);	
		response.put('Stopbatch', Label.Plc_AllAllStopBatch);
		response.put('Accessunauthorized',Label.Plc_AllAllAccessUnauthorized);
		response.put('Theuserisnotenabledtousethisbatchornotexist',Label.Plc_AllAllTheUserIsNotEnabledToUseThisBatchOrNotExist);
		response.put('Nooldexecutionsinfoavailable',Label.Plc_AllAllNoOldExecutionsInfoAvailable);
		response.put('Idle',Label.Plc_AllAlIdle);
		response.put('Running',Label.Plc_AllAllRunning);

		response.put('Monday','Monday');//Lunedi
		response.put('Tuesday','Tuesday');//Martedi
		response.put('Wednesday','Wednesday');//Mercoledi
		response.put('Thursday','Thursday');//Giovedi
		response.put('Friday','Friday');//Venerdi
		response.put('Saturday','Saturday');//Sabato
		response.put('Sunday','Sunday');//Domenica

		return response;
	}
	@AuraEnabled
  public static Map<String, String> setSchedulable(String schedulerName, String cronoTime){
		Map<String, String> response = new Map<String,String>();
		Type abstractSchedulerClass = Type.forName(schedulerName);

		Object schedulerClass = abstractSchedulerClass.newInstance();

		//String jobID = System.schedule(''+schedulerName+'', cronoTime, schedulerClass);
		
		return response;
	}

}