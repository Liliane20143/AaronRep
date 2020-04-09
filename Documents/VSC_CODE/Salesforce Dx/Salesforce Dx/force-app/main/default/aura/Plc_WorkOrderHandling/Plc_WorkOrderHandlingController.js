({
    /* Handler called during initialization */
    handleInit: function(component, event, helper) {
        helper.retrieveTranslationMap(component, helper);
        helper.retrievePropertiesMap(component, helper);
    },
    /* Handler called when a menu item is selected */
    handleSaveItems: function(component, event, helper) {
        helper.closeModal(component, helper, 'modal-save');
        helper.saveItems(component, helper);
    },
    /* Handler used to open the selected term id record page */
    handleOpenRecord: function(component, event, helper) {
        var selectedItem = event.currentTarget;
        var termId = selectedItem.dataset.record;
        helper.redirectToObject(component, helper, termId);
    },
    /* Handler for opening save modal */
    handleOpenSaveModal: function(component, event, helper) {
        helper.openModal(component, helper, 'modal-save');
    },
    /* Handler for closing save modal */
    handleCloseSaveModal: function(component, event, helper) {
        helper.closeModal(component, helper, 'modal-save');
    },
    /* Handler used to show/hide sections */
    handleManageSection: function(component, event, helper) {
        var positions = event.getSource().get('v.name').split(',');
        var itemsList = component.get('v.itemsList');
        itemsList[positions[0]].isExpanded = !itemsList[positions[0]].isExpanded;
        component.set('v.itemsList', itemsList);
    },
    /* Handler for managing the change of the structure */
    handleItemsChange: function(component, event, helper) {
        helper.setSaveButton(component, helper);
    },

    /* START
     * Handlers for opening modals of material selections
     * ----------------------------------------------------------------------------------------------------------------------------------- */

    /* Handler for opening modal for new products */
    handleNewProductItem: function(component, event, helper) {
        component.set('v.propertiesMap.modalTitle', $A.get('$Label.c.Plc_LightningComponentWorkOrderHandlingSelectProduct'));
        component.set('v.isStoreNewProductFlag', true);
        component.set('v.isNewAccessoryFlag', false);
        component.set('v.isAssetSubstitutionFlag', false);
        component.set('v.currentSelectedMaterialType', 'Product')
        component.set('v.currentSelectedItemIndex', []);
        helper.retrieveAvailableModels(component, helper);
        helper.openModal(component, helper, 'modal-add-item');
    },
    /* Handler for opening modal for new accessory */
    handleNewAccessoryItem: function(component, event, helper) {
        var positions = event.getParam("value").split(',');
        component.set('v.propertiesMap.modalTitle', $A.get('$Label.c.Plc_LightningComponentWorkOrderHandlingSelectAccessory'));
        component.set('v.isStoreNewProductFlag', false);
        component.set('v.isNewAccessoryFlag', true);
        component.set('v.isAssetSubstitutionFlag', false);
        component.set('v.currentSelectedMaterialType', 'Accessory');
        component.set('v.currentSelectedItemIndex', positions);
        helper.retrieveAvailableModels(component, helper);
        helper.openModal(component, helper, 'modal-add-item');
    },
    /* Handler for new substitutes */
    handleNewAccessorySubstitute: function(component, event, helper) {
        var positions = event.getSource().get('v.name').split(',');
        component.set('v.propertiesMap.modalTitle', $A.get('$Label.c.Plc_LightningComponentWorkOrderHandlingSelectAccessory'));
        component.set('v.isStoreNewProductFlag', false);
        component.set('v.isAccessorySubstitutionFlag', true);
        component.set('v.isAssetSubstitutionFlag', false);
        component.set('v.currentSelectedMaterialType', 'Accessory');
        component.set('v.currentSelectedItemIndex', positions);
        helper.retrieveAvailableModels(component, helper);
        helper.openModal(component, helper, 'modal-add-item');
    },
    /* Handler for asset substitution */
    handleNewAssetSubstitute: function(component, event, helper) {
        var positions = event.getSource().get('v.name').split(',');
        component.set('v.propertiesMap.modalTitle', $A.get('$Label.c.Plc_LightningComponentWorkOrderHandlingSelectAccessory'));
        component.set('v.isStoreNewProductFlag', false);
        component.set('v.isAccessorySubstitutionFlag', false);
        component.set('v.isAssetSubstitutionFlag', true);
        component.set('v.currentSelectedMaterialType', 'Product');
        component.set('v.currentSelectedItemIndex', positions);
        helper.retrieveAvailableModels(component, helper);
        helper.openModal(component, helper, 'modal-add-item');
    },
    /* Handler for accessory status change */
    handleAccessoryStatusChange: function(component, event, helper) {
        var positions = event.getSource().get('v.name').split(',');
        helper.resetReplacedByAccessory(component, positions);
    },
    /* Handler for asset (store product) status change */
    handleStoreProductStatusChange: function(component, event, helper) {
        var positions = event.getSource().get('v.name').split(',');
        helper.resetReplacedByStoreProduct(component, positions);
        helper.setChildAccessoriesStatus(component, helper, positions);
    },
    /* END
     * Handlers for opening modals of material selections
     * ----------------------------------------------------------------------------------------------------------------------------------- */

    /* START
     * Handlers for removing items
     * ----------------------------------------------------------------------------------------------------------------------------------- */

    /* Handler used to remove items */
    handleRemoveProductItem: function(component, event, helper) {
        var positions = event.getSource().get('v.name').split(',');
        helper.removeProductItem(component, helper, positions);
        helper.setNoDataImageAndNumberOfItems(component, helper);
    },
    /* Handler used to remove items */
    handleRemoveAccessoryItem: function(component, event, helper) {
        var positions = event.getSource().get('v.name').split(',');
        helper.removeAccessoryItem(component, helper, positions);
    },

    /* END
     * Handlers for removing items
     * ----------------------------------------------------------------------------------------------------------------------------------- */

    /* START
     * Material modal table functions
     * ----------------------------------------------------------------------------------------------------------------------------------- */

    /* Handler for adding a new item based on a product */
    handleAddItem: function(component, event, helper) {
        helper.addItem(component, helper);
        helper.setNoDataImageAndNumberOfItems(component, helper);
    },
    /* Handler used to show in the data table serial stock records */
    handleShowSerialStockMaterials: function(component, event, helper) {
        helper.showSerialStockMaterials(component, helper);
    },
    /* Handler used to show in the data table product stock records */
    handleShowProductStockMaterials: function(component, event, helper) {
        helper.showProductStockMaterials(component, helper);
    },
    /* Handler for filtering showed materials */
    handleMaterialsFilter: function(component, event, helper) {
        helper.retrieveAvailableModels(component, helper);
    },
    /* Handler for getting selected datatable rows */
    handleUpdateSelectedRows: function(component, event, helper) {
        var selectedRow = event.getParam('selectedRows')[0];
        component.set('v.selectedMaterial', selectedRow);
        if (selectedRow) {
            component.set('v.selectedMaterialRequestedQty', selectedRow.Plc_MinimumStock__c);
        } else {
            component.set('v.selectedMaterialRequestedQty', 1);
        }
    },
    /* Handler for closing modal */
    handleCloseItemsModal: function(component, event, helper) {
        helper.closeModal(component, helper, 'modal-add-item');
        helper.resetFlags(component, helper);
    },
    /* Handler used to update column sorting */
    handleUpdateModelColumnSorting: function(component, event, helper) {
        var items = component.get('v.modelsList');
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        component.set('v.modelsList', helper.sortData(component, fieldName, sortDirection, items));
    },

    /* END
     * Material modal table functions
     * ----------------------------------------------------------------------------------------------------------------------------------- */

    /* START
     * Assets modal table functions
     * ----------------------------------------------------------------------------------------------------------------------------------- */

    /* Handler for selecting asset from given store*/
    handleSelectProductAsset: function(component, event, helper) {
        helper.retrieveAvailableAssets(component, helper);
        helper.openModal(component, helper, 'modal-product-assets');
    },
    /* Handler for closing modal for selecting assets */
    handleCloseProductAssetsModal: function(component, event, helper) {
        helper.closeModal(component, helper, 'modal-product-assets');
        helper.resetFlags(component, helper);
    },
    /* Handler for adding a new asset product */
    handleAddProductAsset: function(component, event, helper) {
        helper.addProductAsset(component, helper);
    },
    /* Handler for updating selected asset*/
    handleUpdateAssetSelectedRows: function(component, event, helper) {
        var selectedRow = event.getParam('selectedRows')[0];
        component.set('v.selectedAsset', selectedRow);
    },
    /* Handler for filtering assets */
    handleAssetFilter: function(component, event, helper) {
        helper.retrieveAvailableAssets(component, helper);
    },
    handleUpdateAssetColumnSorting: function(component, event, helper) {
        var items = component.get('v.availableAssetList');
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        component.set('v.availableAssetList', helper.sortData(component, fieldName, sortDirection, items));
    },

    /* END
     * Assets modal table functions
     * ----------------------------------------------------------------------------------------------------------------------------------- */

    /* START
     * Managing stock orders 
     * ----------------------------------------------------------------------------------------------------------------------------------- */
     /* Handler for accepting the material */
     handleAcceptMaterial: function(component, event, helper) {
        var positions = event.getSource().get('v.name').split(',');
        component.set('v.currentSelectedItemIndex', positions);
        helper.precheckSliAction(component, helper, positions, 'accept');
     },
     /* Handler for refusing the material */    
     handleRefuseMaterial: function(component, event, helper) {
        var positions = event.getSource().get('v.name').split(',');
        component.set('v.currentSelectedItemIndex', positions);
        helper.precheckSliAction(component, helper, positions, 'refuse');
     },

    /* END
     * Managing stock orders 
     * ----------------------------------------------------------------------------------------------------------------------------------- */

    /* START
     * Managing activity compile report
     * ----------------------------------------------------------------------------------------------------------------------------------- */
    /* Handler used to show activity compilre report window */
    handleOpenActivityReport: function(component, event, helper) {
        var positions = event.getSource().get('v.name').split(',');
        helper.openActivityReport(component, event, positions);
    },
    /* END
     * Managing activity compile report
     * ----------------------------------------------------------------------------------------------------------------------------------- */

    /* START
     * Managing contact selection
     * ----------------------------------------------------------------------------------------------------------------------------------- */

    /* Handler used for showing modal for selecting the contact */
    handleOpenSelectContactModal: function(component, event, helper) {
        var positions = event.getSource().get('v.name').split(',');
        component.set('v.currentSelectedItemIndex', positions);
        helper.preCheckSelectUserAction(component, helper, positions);
    },
    /* Hanler used for closing the selection contact modal */
    handleCloseSelectContactModal: function(component, event, helper) {
        component.set('v.selectedContact', {Id: ''});
        helper.closeModal(component, helper, 'modal-select-contact');
    },
    /* Hanler used for saving the selection contact on given Stock Serial */
    handleSelectContact: function(component, event, helper) {
        helper.closeModal(component, helper, 'modal-select-contact');
        helper.updateSerialToWithdrawn(component, helper, component.get('v.currentSelectedItemIndex'));
    }
    /* END
     * Managing contact selection
     * ----------------------------------------------------------------------------------------------------------------------------------- */
})