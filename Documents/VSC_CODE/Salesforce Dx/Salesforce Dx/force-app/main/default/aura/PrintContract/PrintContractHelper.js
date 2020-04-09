({
    loadContacts : function(component) {
       /* var action = component.get("c.getContracts");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.contracts", response.getReturnValue());
                component.set("v.contractsList", response.getReturnValue());
                this.updateTotal(component);
            }
            
            // Display toast message to indicate load status
            var toastEvent = $A.get("e.force:showToast");
            if (state === 'SUCCESS'){
                toastEvent.setParams({
                    "title": "Success!",
                    "message": " Your contacts have been loaded successfully."
                });
            }
            else {
                toastEvent.setParams({
                    "title": "Error!",
                    "message": " Something has gone wrong."
                });
            }
            toastEvent.fire();
        });
        $A.enqueueAction(action);
    },
    updateTotal: function(cmp) {
        var contracts = cmp.get("v.contracts");
        cmp.set("v.totalContracts", contracts.length);*/
    }
    
    
})