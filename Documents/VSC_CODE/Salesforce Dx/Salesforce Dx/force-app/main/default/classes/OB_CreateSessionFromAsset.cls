/*******************************************************************************
Purpose:  class to generate bit2win session from Asset - performance
Parameters: -
Returns: Boolean

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         enrico.purificato        23/10/2019      Created        

********************************************************************************/
global class OB_CreateSessionFromAsset implements Database.Batchable<sobject> {
    
	private String currentAsset;
	private Set<Id> assetSet;

    public static void setSessionInvalid(Asset rootAsset){
        String session = rootAsset.OB_B2W_Session__c;
       
        if(String.isNotBlank(session) && session.contains('#'))
        {
            List<String> sessionList = session.split('#');
            try{
                NE__Bit2Win_Session__c sessionObj = new NE__Bit2Win_Session__c(Id = sessionList[1], OB_Valid__c=false); 
                update sessionObj;
            }
            catch (Exception e){
            }
        } 
 
    }
   
    public OB_CreateSessionFromAsset(Set<Id> rootAssetSet)
    {

        this.currentAsset = (new list<Id>(rootAssetSet)[0]);
		if(rootAssetSet.remove(this.currentAsset))
		{
			assetSet = rootAssetSet;
		}
    }

   global Database.Querylocator start (Database.BatchableContext BC) {
      return Database.getQueryLocator('SELECT Id,OB_B2W_Session__c from Asset WHERE Id= :currentAsset LIMIT 1');
   }
   

   global void execute (Database.BatchableContext BC, List<sobject> scope) 
   {
        Asset rootAsset = (Asset)scope[0];

        setSessionInvalid(rootAsset);

        string configurationSubType='Standard';
        date orderDate = Date.today();
        NE.ChangeOrderUtilities co= new NE.ChangeOrderUtilities('b2w');
        string xml = co.getConfigurationXML(currentAsset, configurationSubType, orderDate);
        co.xmlParserApplyChange();

        String sessionId = co.createSession(); 

        //elena.preteni 20/12/2019 validazione pacchetto perf1
        List<Attachment> configurationAttachments = [SELECT Id from Attachment 
                                                WHERE parentId =:sessionId 
                                                AND Name ='NewConfigurationController.order' LIMIT 1];
        if(configurationAttachments.size()>0){                                                    
            rootAsset.OB_B2W_Session__c=configurationAttachments.get(0).Id+'#'+sessionId;
            update rootAsset;
        }
        //elena.preteni 20/12/2019 validazione pacchetto perf1
   }

   global void finish(Database.BatchableContext BC) {
	   if(assetSet.size()>0)
	   {
		   Database.executeBatch(new OB_CreateSessionFromAsset(assetSet));
	   } else{
           Database.executeBatch(new OB_DeleteUnusedSessions());
       }
   }
}