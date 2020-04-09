({
    doInit : function(component, event, helper) {
        try{
            var retrieveLogRequest = component.get("c.retrieveLogRequest");
			retrieveLogRequest.setParams
			({
				"logRequestId": component.get("v.recordId")
			});
			retrieveLogRequest.setCallback(this,function(response)
			{
				var state = response.getState();
				if (state === "SUCCESS") 
				{
					var contextLogRequest = response.getReturnValue();
                    component.set("v.contextLogRequest", contextLogRequest);
                    var logRequest = component.get("v.contextLogRequest");
                    console.log('logRequest is:  ' + logRequest);
                    component.set("v.notes",contextLogRequest.OB_Note__c);
                    console.log('logRequest.OB_Status__c is: ' + logRequest.OB_Status__c);
                    if(logRequest.OB_Status__c === $A.get("$Label.c.OB_MAINTENANCE_LOGREQUEST_STATUS_DRAFT") || logRequest.OB_Status__c === $A.get("$Label.c.OB_MAINTENANCE_LOGREQUEST_STATUS_PENDING"))
                    {
                        component.set("v.status", true);
                    }
                }
            });
            $A.enqueueAction(retrieveLogRequest);
            
            var checkProfile = component.get("c.checkProfile");
            checkProfile.setCallback(this,function(response)
            {
                var state = response.getState();
                if(state === "SUCCESS")
                {
                    var contextProfile = response.getReturnValue();
                    component.set("v.profile", contextProfile);
                    var profile = component.get("v.profile");
                    console.log('User Profile is: '+ profile);
                }
            });
            $A.enqueueAction(checkProfile);
		}catch(err){
			console.log('[EXCE] OB_Maintenance_Log_Request_NotesController.js : doInit : ' + err.message);
		}
    },

    insert : function(component, event, helper) {
        var showModal = component.get("v.showModal");
		if (showModal == false){
			component.set("v.showModal", true);
		}  
    },

    save : function(component, event, helper) {
        try{
            helper.saveLogNotes(component, event);
            helper.retrieveNotes(component, event);
        }catch(err){
         console.log('[EXCE] OB_Maintenance_Log_Request_NotesController.js : saveNotes : ' + err.message);
        }
    },

    hideModal : function (component, event, helper){
        helper.retrieveNotes(component, event);
        var showModal = component.get("v.showModal");
		if (showModal == true){
			component.set("v.showModal", false);
		}
    }
})