({
	handleInit: function(component, event, helper) {
		component.set('v.objectId', component.get("v.pageReference").state.c__objectId);
	},
    /* Handler for updating distribution list */
	handleProceed : function(component, event, helper) {
        helper.updateStatus(component, helper);
	},
    /* Handler for closing the modal */
    handleCancel : function(component, event, helper) {
        helper.redirectToObject(component.get('v.objectId'));
    }
})