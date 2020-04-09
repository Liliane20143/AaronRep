({
	saveDatePOS_Helper : function(component, event, helper) {
		var action = component.get('c.saveDatePOS');
		var targetId =  event.getSource().getLocalId();
		console.log('targetId'+targetId);
        action.setParams({ 
            startDatePOS :component.get("v.startDatePos"), 
            startDateAcquiring : component.get("v.startDateAcquiring")  ,
            logRequestId : component.get("v.recordId"),
            isAcquiring: targetId == 'saveAcquiring'?true:false,
            isPOS:  targetId == 'savePos'?true:false
        });
        action.setCallback(this, $A.getCallback(function (response) {
        	console.log("SUCCESS");
            var state = response.getState();
            if (state === "SUCCESS") {
              
	            console.log("SUCCESS");
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);    
    },
    saveDateAcquiring_Helper : function(component, event, helper) {
		var action = component.get('c.saveDateAcquiring');
		var targetId =  event.getSource().getLocalId();
		console.log('targetId'+targetId);
        action.setParams({   
            startDateAcquiring : component.get("v.startDateAcquiring")  ,
            logRequestId : component.get("v.recordId"),

        });
        action.setCallback(this, $A.getCallback(function (response) {
        	console.log("SUCCESS");
            var state = response.getState();
            if (state === "SUCCESS") {
              
	            console.log("SUCCESS");
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);    
	},

	rejectRequestPOS_Helper : function(component, event, helper) {
		var action = component.get('c.rejectRequestPOS');
		var targetId =  event.getSource().getLocalId();
		console.log('targetId'+targetId);
        action.setParams({ 
            logRequestId : component.get("v.recordId"),
      
        });
        action.setCallback(this, $A.getCallback(function (response) {
        	console.log("SUCCESS");
            var state = response.getState();
            if (state === "SUCCESS") {
              
	            console.log("SUCCESS");
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);    
    },
    rejectRequestAcquiring_Helper : function(component, event, helper) {
		var action = component.get('c.rejectRequestAcquiring');
		var targetId =  event.getSource().getLocalId();
		console.log('targetId'+targetId);
        action.setParams({ 
            logRequestId : component.get("v.recordId"),
      
        });
        action.setCallback(this, $A.getCallback(function (response) {
        	console.log("SUCCESS");
            var state = response.getState();
            if (state === "SUCCESS") {
              
	            console.log("SUCCESS");
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);    
	},
	showToast: function (component, event,title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },
    // Start antonio.vatrano 13/05/2019 RI-61 method to show error message about required fields
    showErrorMessage : function( component, event, res, validStartDate){
        var errorMex = $A.get("$Label.c.OB_MAINTENANCEMISSINGFIELDS") + ' ';
        if(res.length > 0){
            errorMex +=res;
            if(!validStartDate){
                errorMex+= ', Data inizio validità';
            }
        }else {
            errorMex += 'Data inizio validità';
        }
        this.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR"), errorMex, 'error');
    }
    // End antonio.vatrano 13/05/2019 RI-61 method to show error message about required fields
})