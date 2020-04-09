({  
    /* Function called during initialization */
    handleInit: function(component, event, helper) {
        helper.retrieveTranslationMap(component, helper);
    },
    /* Function called when Back button is hit */
    handleBack: function(component, event, helper) {
        window.history.go(-2);
    },
    /* Handler called when warehouse is changed */
    handleSelectedWarehouseChange: function(component, event, helper) {
        helper.retrieveProductStocks(component, helper);
    },
    /* Handler called to sort Product Stock table */
    handleUpdateProductStockColumnSorting: function(component, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        component.set('v.productStocksList', 
                      helper.sortData(component, fieldName, sortDirection, component.get('v.productStocksList')));
    },
    /* Handler for filtering Product Stocks in the table */
    handleProductStockFilter: function(component, event, helper) {
        helper.retrieveProductStocks(component, helper);
    },
    /* Handler used to show confirmation save modal */
    handleShowSaveModal: function(component, event, helper) {
        helper.openModal(component, helper, 'modal-save');
    },
    /* Handler used to hide confirmation save modal */
    handleCloseSaveModal: function(component, event, helper) {
        helper.closeModal(component, helper, 'modal-save');
    },
    /* Handler for saving Product Stocks Snapshot */
    handleSave: function(component, event, helper) {
        helper.createProductStockSnapshots(component, helper);
    },
    /* Handler for opening a new tab with the Product Stock */
    handleRedirectToProducStock:  function(component, event, helper) {
        helper.redirectToObject(event.getParam('row').Id);
    }
})