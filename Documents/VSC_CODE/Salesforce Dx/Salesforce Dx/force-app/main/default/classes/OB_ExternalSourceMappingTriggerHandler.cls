public class OB_ExternalSourceMappingTriggerHandler {
	public static void updateMerchant(Map<Id, ExternalSourceMapping__c> oldExternal ,Map<Id, ExternalSourceMapping__c> newExternal){
		//METHOD TO SET THE FIELD toBeChecked IN ACCOUNT WHEN I MODIFY THE FIELD toBeChecked IN THE RELATED EXTERNAL SOURCE MAPPING
		Map<ExternalSourceMapping__c ,  Boolean> booleanExtMap = new Map<ExternalSourceMapping__c ,  Boolean>();
		Set<Id> setMerchantId = new Set<Id>();
		try
		{
			//ITERATION THROUGH THE NEW MAP (VALUE FROM TRUE TO FALSE)
			for(ExternalSourceMapping__c ext : newExternal.values()){
				if(oldExternal.get(ext.id).OB_ToBeChecked__c==true && ext.OB_ToBeChecked__c==false){
					//IF I MODIFY THE VALUE, STORE THE OBJECT IN A MAP AND STORE THE MERCHANT ID
					booleanExtMap.put(ext , true);
					setMerchantId.add(ext.OB_Merchant_ID__c);
				}
			}
			//IF THE MAP ISN'T EMPTY
			if(booleanExtMap.size()>0)
			{
				//FIND ALL EXTERNAL RELATED WITH PREVIOUS MERCHANT ID
				List<ExternalSourceMapping__c> relatedExternal = [SELECT id,OB_ToBeChecked__c,OB_Merchant_ID__c,OB_Description__c FROM ExternalSourceMapping__c WHERE OB_Merchant_ID__c IN: setMerchantId];
				List<Id> listIdToUpdate = new List<Id>();
				
				for(Id merchantId : setMerchantId){
					Boolean updateBoolean = true;
					for(ExternalSourceMapping__c extRelated : relatedExternal){
						//IF THE FLAG IS TRUE--> DO NOTHING
						if(extRelated.OB_Merchant_ID__c==merchantId && extRelated.OB_ToBeChecked__c == true){
							updateBoolean=false;
						}
					}
					//ELSE STORE THE ID IN THE LIST
					if(updateBoolean==true){
						listIdToUpdate.add(merchantId);
					}
				}
				//FIND THE MERCHANT WITH ID INTO PREVIOUS LIST
				if(listIdToUpdate.size()>0)
				{
					List<Account> listMerchantToCheck  = [SELECT Id,OB_ToBeChecked__c  FROM Account WHERE Id IN: listIdToUpdate];
					List<Account> listMerchantToUpdate = new List<Account>();
					for(Account acc : listMerchantToCheck){
						//SET THE VALUE IN MERCHANT ONLY IF THE MERCHANT HAS ALL EXTERNAL SOURCE WITH VALUE 'FALSE'
						acc.OB_ToBeChecked__c = false;
						listMerchantToUpdate.add(acc);
					}
					update listMerchantToUpdate;
				}
				
			}
		}catch(DmlException ecc)
		{
			System.debug('[E] OB_ExternalSourceMappingTriggerHandler.updateMerchant '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
		}
	}

	public static void modifyDescription(Map<Id, ExternalSourceMapping__c> oldExternal ,Map<Id, ExternalSourceMapping__c> newExternal){
		//MODIFY THE FIELD ob_description__c AFTER MODIFY OF toBeChecked (FROM TRUE TO FALSE)
		for(ExternalSourceMapping__c ext : newExternal.values())
		{
			if(oldExternal.get(ext.id).OB_ToBeChecked__c==true && ext.OB_ToBeChecked__c==false)
			{
				ext.OB_Description__c='';
			}
		}
	}

}