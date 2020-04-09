({
    handleInitialize: function (component, event, helper) {
        helper.initialize(component);
    },

    handleChangeDealerParent: function (component, event, helper) {
        helper.updateDealerSelectedId(component, event.getParam('value').Id, 'parent');
    },

    handleChangeDealerChild: function (component, event, helper) {
        helper.updateDealerSelectedId(component, event.getParam('value').Id, 'child');
    },

    handleRemoveFilter: function (component, event, helper) {
        document.location.reload(true);
    },

    handleApplyFilter: function (component, event, helper) {

        let startDate, endDate, status, dealerChildId, dealerParentId, warehouseId;

        startDate = component.get('v.startDate');
        endDate = component.get('v.endDate');
        status = component.get('v.statusSelected');
        dealerChildId = component.get('v.dealerChildSelectedId');
        dealerParentId = component.get('v.dealerParentSelectedId');
        warehouseId = component.get('v.warehouseSelectedId');

        if ($A.util.isEmpty(status) || $A.util.isEmpty(startDate) || $A.util.isEmpty(endDate)) {
            helper.openModalComponent(component, 'error',  $A.get('$Label.c.Plc_CompileMandatoryFields'));
            helper.checkFields(component);

        } else if ($A.util.isEmpty(dealerChildId) && $A.util.isEmpty(dealerParentId) && $A.util.isEmpty(warehouseId)) {
            helper.openModalComponent(component, 'info',  $A.get('$Label.c.Plc_LimitWillBeApplied'));
            component.set('v.fireEvent', true);
        } else {
            helper.applyFilter(component);
        }
    },

    handleChangeStatusPicklistValue: function (component, event, helper) {
        helper.changeStatusPicklistValue(component);
    },

    handleChangeWarehouse: function (component, event, helper) {
        helper.updateWarehouseId(component, event.getParam('value').Id);
    },

    handleShowModalExportCSV: function (component, event, helper) {
        helper.showModalExportCSV(component);
    },

    handleCloseModalExportCSV: function (component, event, helper) {
        helper.closeModalExportCSV(component);
    },

    handleChangeExportCsvSeparator: function (component, event, helper) {
        helper.changeExportCsvSeparator(component, event.getParam('value'));
    },

    handleExportCSV: function (component, event, helper) {
        helper.exportCSV(component);
    },

    handleCloseModalInfoLimit: function (component, event, helper) {
        helper.closeModalInfoLimit(component);
    },

    handleCancelButton: function (component, event, helper) {
        helper.redirectToObject(component, event, 'serviceCatalog');
    },

    handleChangeStartDate: function (component, event, helper) {
        helper.changeDate(component, event.getParam('value'), 'start');
    },

    handleChangeEndDate: function (component, event, helper) {
        helper.changeDate(component, event.getParam('value'), 'end');
    },

    handleRedirectToSerialLink: function (component, event, helper) {
        helper.redirectToObject(component, event, 'serial');
    }
})