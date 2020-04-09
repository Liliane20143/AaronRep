({  
    /* Closing modal helper function*/
	closeModal : function(component, helper) {
        helper.redirectToObject(component.get('v.objectId'));
        $A.get('e.force:refreshView').fire();
	},
    /* Shows a custom message defined by parameters */
    showToast: function(title, message, type, mode) {
        /* show toast message
         * mode
         * sticky: it stays on screen until user action
         * dismissable: it disappears after some time automatically
         */
        var toastEvent = $A.get('e.force:showToast');
        toastEvent.setParams({
            'title': title,
            'message': message,
            'type': type,
            'mode': mode || 'dismissable',
            'duration': 3000
        });
        toastEvent.fire();
    },
    /* Redirects to a given id object page*/
    redirectToObject: function(objectId){
        var navEvt = $A.get('e.force:navigateToSObject');
        navEvt.setParams({
          'recordId': objectId,
          'slideDevName': 'detail',
        });
        navEvt.fire();
    },
    /* Function used to called server side update */
    updateStatus: function(component, helper) {
        var action = component.get("c.updateStatus");
        
        action.setParams({
            "dlId" : component.get('v.objectId')
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            if(state == "SUCCESS" && !result.error) {
                helper.showToast('', $A.get('$Label.c.Plc_LightningComponentDistributionListStatusUpdateOkMessage'), 'success');
                helper.closeModal(component, helper);
            } else if (component.isValid() && (response.getState() === "ERROR" || result.error)) {
                helper.showToast('', result.errorMsg, 'warning', 'sticky');
                console.error(result.errorMsg);
                helper.redirectToObject(component.get('v.objectId'));
            }
        });
        $A.enqueueAction(action);
    }
})