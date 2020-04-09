({


	searchUser : function(component, event, helper) {
		 //@author Simone Misani <simone.misani@accenture.com>
		 //@date 18/04/2019
		 //@function-Helper return the current User		
		var recordId= component.get("v.recordId");
		var action = component.get("c.contextUser");
		action.setParams({ 
            contactId : recordId
        });
	  	action.setCallback(this, $A.getCallback(function (response) {
		var state = response.getState();
        if (state === "SUCCESS") 
        {
			var results = response.getReturnValue();
			if(results['user'] != null && results['user'] =="Operation" && (results['developername'] =="Titolare_Effettivo" || results['developername'] =="Esecutore" )){
        		component.set("v.operation",true);
        	}
        }			
	}));
	$A.enqueueAction(action);   
	}
})