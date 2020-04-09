({
	saveHelper : function(component,event) {
		var getField       = component.get("c.saveRejectReason");
		var targetObjectId = component.get("v.targetObjectId"); 
        var  commentInput  =  component.find("commentsId"); 
        if(!$A.util.isUndefined(commentInput)){
			var comments = component.find("commentsId").get("v.value");
        }
		var selectedReason = component.get("v.rejectionReason");
		console.log('targetObjectId: '+targetObjectId);
		console.log('selectedReason: '+selectedReason);
		console.log('Comments: '+comments);

		getField.setParams({	targetObjectId : targetObjectId,  
								comments       : comments,
								selectedReason : selectedReason
							}); 
				
		getField.setCallback(this, function(response) 
		{
			var state = response.getState();
			if (state === "SUCCESS") 
			{
                //console.log("response.getReturnValue()  *--* " + JSON.stringify(response.getReturnValue()));
                // showMessage : boolean to show the message //
                component.set("v.hideRejectReason",true);
                
                component.set("v.showMessage", true);
                
								
			}  
			else if (state === "ERROR")
			{
				var errors = response.getError();
				if (errors) 
				{
					if (errors[0] && errors[0].message)
					{
						console.log("Error message: " + 
								 errors[0].message);
					}
				}
				else
				{
					console.log("Unknown error");
				}
			}
		});
		$A.enqueueAction(getField); 
       
	},
    
    getTargetProcessStep: function(component,event){
        
        var getField    = component.get("c.getTargetProcessStep");        
		getField.setParams({ processId : component.get("v.recordId")}); 
        
		getField.setCallback(this, function(response) 
		{
			var state = response.getState();
			if (state === "SUCCESS") 
			{
				console.log("response.getReturnValue() ---- " + JSON.stringify(response.getReturnValue()));
				//ANDREA START 23.02.2019
				if(response.getReturnValue() != undefined || response.getReturnValue() != null) {
					//ANDREA END 23.02.2019
					component.set("v.targetObjectId",response.getReturnValue().ProcessInstance.TargetObjectId);
					component.set("v.status",response.getReturnValue().ProcessInstance.Status);
					component.set("v.targetObjectType",response.getReturnValue().ProcessInstance.TargetObject.Type);
					var status = component.get("v.status");
					if(status != 'Rejected'){
						component.set("v.hideRejectReason",true);
					}
				} else {
					component.set("v.hideRejectReason", true);
				}
     				
			}  
			else if (state === "ERROR")
			{
				var errors = response.getError();
				if (errors) 
				{
					if (errors[0] && errors[0].message)
					{
						console.log("Error message: " + 
								 errors[0].message);
					}
				}
				else
				{
					console.log("Unknown error");
				}
			}
		});
		$A.enqueueAction(getField);
        
        
    },
    
    getRejectionReasonList: function(component, event){        
        
		//getPickList values function
		var action = component.get("c.getRejectionReasonList");
		action.setCallback(this, function(a) {
		
			component.set("v.rejectionReasonList", a.getReturnValue());

		});
		$A.enqueueAction(action); 

		//retrieve profile
		var actiongetprofile = component.get("c.retrieveUserProfile");
		actiongetprofile.setCallback(this, function(response)
		{
			var state = response.getState();
			// console.log("the state is: "+state);
			if (state === "SUCCESS") 
			{
				var profilename = response.getReturnValue();
				component.set("v.profileName", profilename);
                var targetObjectType = component.get("v.targetObjectType");
                 var status = component.get("v.status");
                
                if(profilename == 'Approvatore Risk Evaluation' && targetObjectType == 'OB_LogRequest__c' && status == 'Rejected'){
            		this.saveHelper(component,event);
       			 }
                
			}
			else
			{
				console.log("NO USER");
			}
		});
		$A.enqueueAction(actiongetprofile);
        
        
		}
})