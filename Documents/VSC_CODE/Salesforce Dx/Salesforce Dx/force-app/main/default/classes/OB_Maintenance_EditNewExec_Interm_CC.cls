public with sharing class OB_Maintenance_EditNewExec_Interm_CC {
	
	@AuraEnabled
	public static void saveDraft (String logId){
		String toReturn = '@@@ update Draft'; 
		try{
			OB_LogRequest__c logrequest = [select id,OB_Status__c from OB_LogRequest__c where id = : logId limit 1];
			logrequest.OB_Status__c = System.Label.OB_MAINTENANCE_LOGREQUEST_STATUS_DRAFT;
			logrequest.OB_Save_as_Draft__c = true; //antonio.vatrano 26/07/2019 logic to show BTN Upload documents
			update(logrequest);
		}
		catch(Exception e){
			toReturn =  '@@@ not update Draft';
		}
		System.debug(toReturn);
	}

	@AuraEnabled
	public static void checkOnLogRequest(String logRequestId)
	{
		try
		{
			if(!String.isBlank(logRequestId))
			{
				OB_Utility.checkLogRequest(logRequestId);
				System.debug('@Called OB_Utility.checkLogRequest from OB_Maintenance_EditNewExec_Interm_CC');
			}
		}
		catch(Exception ecc)
		{
			System.debug('[EXCE] OB_Maintenance_EditNewExec_Interm_CC.checkOnLogRequest '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
		}
	}
}