/**
 * Created by liverani on 29/01/2019.
 */
({
    handleSave: function (component, event, helper) {
        helper.save(component);
    },

    handleCloseModal: function (component, event, helper) {
        helper.closeModalSuccess(component);
        //component.set('v.showModal', false);
        window.history.go(-1);
        window.close(); 
    },


    handleUpdateSelectedRows : function(component, event, helper) {
        var selectedRow = event.getParam('selectedRows')[0];
        component.set('v.propertiesMap.warehouse', selectedRow);
    },


    handleBack : function(component, event, helper) {
        window.history.go(-1);
        window.close(); 
    },

    handleCloseTableModal : function(component, event, helper) {
        component.set('v.objectId', component.get('v.propertiesMap.warehouse.Id'));
        helper.initialize(component);
        helper.closeModal(component, helper,'modal-warehouses');
    },
    // FB 20190627 NEXIPLC-589 [START]
    handleShowCsvModal: function(component, event, helper) {
        component.set('v.showUploadCsvModal', true);
    },
    filterResult: function (component, event, helper) {
        helper.handleFilterResult(component, event, helper);
    },
    // FB 20190627 NEXIPLC-589 [END]
})