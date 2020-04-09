/**
 * Created by liverani on 29/01/2019.
 */
({
    handleInitialize: function (component, event, helper) {
        if (component.get('v.objectId')) {
            helper.initialize(component);
        } else {
            helper.retrieveTranslationMap(component, helper);
        }
    },

    handleFocusOnAvailableManagement: function (component, event, helper) {
        // FB 20190627 NEXIPLC-589 [START]
        component.set('v.stockSerialStatus', 'Withdrawn');
        component.set('v.uploadCsvConfigurationMap.technicianWithdrawnManagement', false);
        // FB 20190627 NEXIPLC-589 [START]
        helper.changeTabFocus(component, 'AvailableManagement');
    },

    handleFocusOnWithdrawnManagement: function (component, event, helper) {
        // FB 20190627 NEXIPLC-589 [START]
        component.set('v.stockSerialStatus', 'Available');
        component.set('v.uploadCsvConfigurationMap.technicianWithdrawnManagement', true);
        // FB 20190627 NEXIPLC-589 [START]
        helper.changeTabFocus(component, 'WithdrawnManagement');
    },

    handleSelectManagement: function (component, event, helper) {
        helper.selectManagement(component, event);
    },

    handleRemoveManagement: function (component, event, helper) {
        helper.removeManagement(component, event);
    },

    handleChangeTechnicianPicklist: function (component, event, helper) {
        helper.changeTechnicianPicklist(component);
    },

    handleFilterEvt: function (component, event, helper) {
        helper.filterEvt(component, event);
    },

    handleUpdateGlobaList: function (component, event, helper) {
        helper.updateGlobaList(component, event);
    },

    handleSave: function (component, event, helper) {
        helper.save(component);
    },

    handleCloseModal: function (component, event, helper) {
        helper.closeModalSuccess(component);
        component.set('v.showModal', false);
    },

    handleTechnicianUpdated : function(component, event, helper) {
        helper.technicianUpdated(component, event);
    },

    handleSelectAll : function(component, event, helper) {
        helper.selectAll(component)
    },

    handleDeselectAll : function(component, event, helper) {
        helper.deselectAll(component);
    },

    handleUpdateSelectedRows : function(component, event, helper) {
        var selectedRow = event.getParam('selectedRows')[0];
        component.set('v.propertiesMap.warehouse', selectedRow);
    },

    handleWarehousesFilter : function(component, event, helper) {
        helper.retrieveAvailableWarehouses(component, helper);
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