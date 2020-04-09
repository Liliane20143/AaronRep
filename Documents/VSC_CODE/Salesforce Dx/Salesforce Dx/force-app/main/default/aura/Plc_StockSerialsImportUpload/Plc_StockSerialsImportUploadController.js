({
    /* Function called during initialization */
    handleInit: function(component, event, helper) {
        helper.retrieveTranslationMap(component, event, helper);
    },
    /* Function called during initialization */
    handleRefresh: function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    },
    /* Handler called after a file is being selected */
    handleFileInput: function(component, event, helper) {
        helper.uploadStockSerialData(component, event, helper);
    },
    /* Handler called when next button is hit */
    handleNext: function (component, event, helper) {
        helper.next(component, helper);
    },
    /* Handler called when previous button is hit */
    handlePrevious: function (component, event, helper) {
        helper.previous(component, helper);
    },
    /* Handler called when first page button is hit */
    handleFirst: function (component, event, helper) {
        helper.first(component, helper);
    },
    /* Handler called when last page button is hit */
    handleLast: function (component, event, helper) {
        helper.last(component, helper);
    },
    /* Handler for closing modal of instructions */
    handleCloseInstructionsModal: function(component, event, helper){ 
        helper.closeModal(component, helper,'modal-instructions');
    },
    /* Handler for opening modal of instructions */
    handleShowInstructionsModal: function(component, event, helper) {
        helper.openModal(component, helper, 'modal-instructions');
    },
    /* Handler for closing modal when user select "multiple warehouse from file" */
    handleCloseTableModalWithoutWarehouse: function(component, event, helper) {
        helper.closeModal(component, helper,'modal-warehouses');
        component.set('v.propertiesMap.warehouse', {Id: '', Plc_Alias__c: ''});
    },
    /* Handler for closing modal of warehouses */
    handleCloseTableModal: function(component, event, helper){ 
        helper.closeModal(component, helper,'modal-warehouses');
    },
    /* Handler used to upload summary stock serials data */
    handleSave : function(component, event, helper) {
        helper.saveStockSerialData(component, helper);
    },
    /* Handler used to open a stock serial when id is selected */
    handleIdClick : function(component, event, helper) {
        var selectedItem = event.currentTarget;
        var Id = selectedItem.dataset.record;
        helper.redirectToObject(Id);
    },
    /* Handler for filtering showed warehouses */
    handleWarehousesFilter: function(component, event, helper) {
        helper.retrieveAvailableWarehouses(component, helper);
    },
    /* Handler used to update warehouse column sorting */
    handleUpdateWarehouseColumnSorting: function(component, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        helper.sortData(component, fieldName, sortDirection);
    },
    /* Handler for getting selected datatable rows */
    handleUpdateSelectedRows: function(component, event, helper) {
        var selectedRow = event.getParam('selectedRows')[0];
        component.set('v.propertiesMap.warehouse', selectedRow);
    },
    /* Handler used to export csv template */
    handleExportCsvTemplate: function(component, event, helper) {
        if (component.get('v.isEditMode')) {
            var csvAsString = helper.retrieveCsvTemplateUpdateMode(component, helper);
            helper.downloadCsv('ExampleUpdateTemplate', csvAsString);
        } else {
            var csvAsString = helper.retrieveCsvTemplateInsertMode(component, helper);
            helper.downloadCsv('ExampleInsertTemplate', csvAsString);
        }
    },
    /* Handler used to export resulting datatable */
    handleExportShowedDatatable: function(component, event, helper) {
        var csvAsString;
        if (component.get('v.isEditMode')) {
            csvAsString = helper.retrieveDataTableAsCsvStringUpdateMode(component, helper);
        } else {
            csvAsString = helper.retrieveDataTableAsCsvStringInsertMode(component, helper);
        }
        
        helper.downloadCsv('ExportResult', csvAsString);
    },
    /* Handler used to sort a clicked column */
    handleSortTableSorting: function(component, event, helper) {
        var selectedItem = event.currentTarget;
        var fieldName = selectedItem.dataset.record;
        helper.sortTableBy(component, helper, fieldName);
    },
    /* Handler used to show the sort arrow */
    handleHeaderOnOver: function(component, event, helper) {
        var selectedItem = event.currentTarget;
        var fieldName = selectedItem.dataset.record;
        component.set("v.propertiesMap.onMouseOverField", fieldName);
    },
    /* Handler used to hide arrow on mouse leave of header cell */
    handleHeaderOnOut: function(component, event, helper) {
        component.set("v.propertiesMap.onMouseOverField", '');
    },
    /* Handler for going back when user is viewing warehouse table */
    handleCancel: function(component, event, helper) {
        window.history.go(-2);
        window.close(); 
    },
    setSelectorArea: function(component, event, helper) {
        component.set('v.propertiesMap.showSelectorArea', !component.get('v.propertiesMap.showSelectorArea'));
    },
    openReportTemplate: function(component, event, helper) {
        helper.redirectToObject(component.get('v.propertiesMap.updateReportId'));
    }
})