({
    // Start AV 21/02/2019 retrieve field of configuration OB_ShowAttachedDocumentations__c to show or not to show Documents
    doInit : function(component, event, helper) {
		var action = component.get("c.showCmpDocs");
        action.setParams({"orderId" : component.get("v.recordId")});
        action.setCallback(this, function(response)
        {
            if (response.getState() === "SUCCESS")
            {
                //Start antonio.vatrano r1f3-54 13/09/2019
				var returnedMap = response.getReturnValue();
				console.log("@@@@returnedMap: "+returnedMap);
                if(returnedMap['ShowDoc'] == 'true'){
                    component.set("v.showComponentDocuments", true);
                    console.log("##SHOW DOCUMENTS");
                }else{
                    component.set("v.showComponentDocuments", false);
                    console.log("##HIDE DOCUMENTS");
                }
                if(returnedMap['Rejection_Reason'] == 'Documentazione Incompleta' || returnedMap['Rejection_Reason'] == 'Documentazione Assente' ){
                    component.set("v.rejectReasonBool", true);
                }else{
                    component.set("v.rejectReasonBool", false);
                }
                //End antonio.vatrano r1f3-54 13/09/2019
            }
            else if (response.getState() === "INCOMPLETE")
            {
                console.log('incomplete'); 
            }
            else if (response.getState() === "ERROR") 
            {
				console.log('error')
            }
        });
        $A.enqueueAction(action);
	}
	// END AV 21/02/2019 retrieve field of configuration OB_ShowAttachedDocumentations__c to show or not to show Documents


    



})