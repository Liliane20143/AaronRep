global class OB_AssetSessionDataRescue implements schedulable {
  
   global void execute(SchedulableContext sc) {
       
      List<Asset> assetToUpdate = [SELECT Id,OB_B2W_Session__c,LastModifiedDate 
                                    FROM Asset Where 
                                    NE__Bundle_Configuration__c = null 
                                    AND  NE__Status__c ='Active' 
                                    AND NE__CatalogItem__r.RecordType.DeveloperName = 'Tariff_Plan' 
                                    AND OB_B2W_Session__c='' 
                                    AND (OB_BW_Session_Done__c!= true 
                                    OR (OB_BW_Session_Done__c = true and LastModifiedDate < YESTERDAY)) LIMIT 10000];
      
      Set<Id> assetId = new Set<Id>();
      for(Asset currentAsset: assetToUpdate){
          currentAsset.OB_BW_Session_Done__c = true;
           assetId.Add(currentAsset.Id);
      }
      update assetToUpdate;
      OB_CreateSessionFromAsset b = new OB_CreateSessionFromAsset(assetId); 
      database.executebatch(b);
   }
}