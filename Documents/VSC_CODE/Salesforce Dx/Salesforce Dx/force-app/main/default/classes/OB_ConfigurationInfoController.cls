public class OB_ConfigurationInfoController {
    
     @AuraEnabled    
    public static NE__order__c updateAgreedChangesServer(String confId, String orderHeader, Boolean checked){
    	System.debug('into updateAgreedChangesServer');
			System.debug('confId: ' + confId);
			System.debug('orderHeader: ' + orderHeader);
						System.debug('checked: ' + checked);
    //	String confToString = JSON.serialize(configuration);
    //	NE__order__c ord = (NE__order__c)JSON.deserialize(confToString, NE__order__c.class);
     	NE__order__c ord = new NE__order__c();
        ord.Id = confId;
		//ord.NE__Order_Header__c = orderHeader;
        ord.OB_AgreedChanges__c = checked;
			System.debug('ord: ' + ord);
    	try{ 
			System.debug('updating ord');
    		update ord;
    	}catch(Exception e){
    		System.debug('an error occured trying to update a configuration:: ' + e.getMessage() + ' at line: ' + e.getLineNumber());
    	}
    	
    	return ord;
    }
    
    
}