({

    
	init : function(component, event, helper) {
		/* 	
       *@author Simone Misani <simone.misani@accenture.com>
        *@date 18/04/2019
        *@Function  call method apex for  retrive flowdata.         
    */   
		var recordId= component.get("v.recordId");
		helper.searchUser(component, event, helper);
        var retrieveInformations = component.get("c.retriveInfo");
        retrieveInformations.setParams({ 
            contactId : recordId
        });
        retrieveInformations.setCallback(this, $A.getCallback(function (response) {
			var state = response.getState();
            if (state === "SUCCESS") 
            {
				var results = response.getReturnValue();
               	component.set("v.FlowData",results);
				component.set("v.retrieveDone",true);
			}
				
		}));
		$A.enqueueAction(retrieveInformations);   
	},
	
	showModalModify : function(component, event, helper){
		/*
        *@author Simone Misani <simone.misani@accenture.com>
        *@date 18/04/2019
        *@Function for see the modal        
    */  
		component.set("v.showModal",true);
	}
})