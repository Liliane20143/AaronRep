({
    doInit : function(component, event, helper) {
		console.log('I am in doInit ');
		helper.getTargetProcessStep(component, event);
		helper.getRejectionReasonList(component, event);
	},
//START gianluigi.virga 22/03/2019 - Check if the reject reason is equals to "Rifiuto definitivo"
	getLogRejectReason: function(component, event, helper){
		console.log("old value: " + event.getParam("oldValue"));
		console.log("current value: " + event.getParam("value"));
		var reason = false;
		var targetObjectId = event.getParam("value");
		if(targetObjectId != null){
			var getLogRequestRejectReason = component.get("c.getLogRequestRejectReason");
			getLogRequestRejectReason.setParams({	
				"targetObjectId" : targetObjectId
			});
			getLogRequestRejectReason.setCallback(this, function(a) {
				reason = a.getReturnValue();
				console.log("@@@DefinitivelyRejected: "+ reason);
				component.set("v.definitivelyRejected", reason);
			});
			$A.enqueueAction(getLogRequestRejectReason);
		}
	},
//END gianluigi.virga 22/03/2019
    
	closeClick : function(component, event, helper) {
		component.set("v.showMessage",false);
	},
    
   saveClick: function(component, event, helper) {
       
        helper.saveHelper(component,event);
	
	},


	onClick: function(component, event) {
		console.log('Radio button change!');
		var selected = event.target.value;;
        component.set("v.rejectionReason", selected);
    }


})