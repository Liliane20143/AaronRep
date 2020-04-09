({  
    /* Handler used during initialization */
    handleInit: function(component, event, helper) {
        var pageRef = component.get("v.pageReference");
        component.set('v.recordId', pageRef.state.c__objectId);
        helper.retrieveTranslationMap(component, helper);
        helper.retrievePropertiesMap(component, helper);
    },
    /* Handler used to close modal */
    handleCancel: function(component, event, helper) {
        //$A.get("e.force:closeQuickAction").fire();
        helper.redirectToObject(component.get('v.recordId'));
    },
    /* Handler used for saving */
    handleSave: function(component, event, helper) {
        helper.updateStockSerial(component, helper);
    },
    /* Handler called when model is changed */
    handleSelectedModelChange: function(component, event, helper) {
        helper.hideWarningArea(component);
        helper.checkProductStockExistance(component, helper);
    },
    /* Handler called when warehouse is changed */
    handleSelectedWarehouseChange: function(component, event, helper) {
        helper.hideWarningArea(component);
        helper.checkProductStockExistance(component, helper);
    }
})