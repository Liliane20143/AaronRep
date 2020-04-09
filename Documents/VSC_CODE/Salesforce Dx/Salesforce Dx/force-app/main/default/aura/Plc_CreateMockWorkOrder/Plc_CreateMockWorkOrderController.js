({
	/* [START]
     * Generic handlers
     * ----------------------------------------------------------------------------------------------------------------------------------- */

	/* Handler for initialization */
	handleInit: function(component, event, helper) {
		helper.retrieveTranslationsMap(component, helper);
		component.set('v.woTipologiesOptions', 
			[
				{'label': $A.get('$Label.c.Plc_AllAllInstallation'), 'value':'Installation'},
				{'label': $A.get('$Label.c.Plc_AllAllUninstallation'), 'value':'Uninstallation'},
				{'label': $A.get('$Label.c.Plc_AllAllDeactivation'), 'value':'Deactivation'}
			]);
        // helper.retrievePropertiesMap(component, helper);
	},

	/* Function called during initialization */
    handleRefresh: function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
	},

	/* Handler for closing modal of instructions */
    handleCloseInstructionsModal: function(component, event, helper){ 
        helper.closeModal(component, 'modal-instructions');
	},
	
    /* Handler for opening modal of instructions */
    handleShowInstructionsModal: function(component, event, helper) {
        helper.openModal(component, 'modal-instructions');
	},

	/* Handler for showing the serials modal */
	handleShowSerialsModal: function(component, event, helper) {
		helper.openModal(component, 'modal-serials');
		helper.retrieveAvailableSerials(component, helper);
		component.find('serials-table').set('v.selectedRows', []);
	},

	/* Handler for hiding the serials modal */
	handleHideSerialsModal: function(component, event, helper) {
		helper.closeModal(component, 'modal-serials');
	},
	/* Handler for opening a record page */
	handleOpenRecord: function(component, event, helper) {
		var selectedItem = event.currentTarget;
        var termId = selectedItem.dataset.record;
        helper.redirectToRecord(termId);
	},
	
	/* [END]
     * Generic handlers
     * ----------------------------------------------------------------------------------------------------------------------------------- */

	/* [START]
     * Serials modal handlers
     * ----------------------------------------------------------------------------------------------------------------------------------- */

	/* Handler for managing filter in modal of serials*/
	handleStockSerialsFilter: function(component, event, helper) {
		helper.retrieveAvailableSerials(component, helper);
	},

	/* Handler for managing the change of the selected termId in the modal */
	handleSelectedTermIdChange: function(component, event, helper) {
		helper.retrieveAvailableSerials(component, helper);
	},

	/* Handler for managing the table column sorting */
	handleUpdateSerialsColumnSorting: function(component, event, helper) {
		var items = component.get('v.availableStockSerialsList');
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        component.set('v.availableStockSerialsList', helper.sortData(component, fieldName, sortDirection, items));
	},

	/* Handler for updating the selected rows */
	handleUpdateSelectedRows: function(component, event, helper) {
		var selectedRows = event.getParam('selectedRows');
        component.set('v.selectedStockSerialsList', selectedRows);
	},

	/* [END]
     * Serials modal handlers
     * ----------------------------------------------------------------------------------------------------------------------------------- */

	/* [START]
     * Work Order related handlers
     * ----------------------------------------------------------------------------------------------------------------------------------- */

	/* Handler for showing full Work Order area */
	handleShowFullWoArea: function(component, event, helper) {
		component.set('v.propertiesMap.disableTipologyOption', true);
		component.set('v.propertiesMap.showWorkOrderInformationFullArea', true);

		if (component.get('v.woTipology') === 'Installation') {
			component.set('v.propertiesMap.warehouseSelectionLabel', $A.get('$Label.c.Plc_AllAllSelect') + ' ' + $A.get('$Label.c.Plc_AllAllSourceWarehouse'));
		} else {
			component.set('v.propertiesMap.warehouseSelectionLabel', $A.get('$Label.c.Plc_AllAllSelect') + ' ' + $A.get('$Label.c.Plc_AllAllDestinationWarehouse'));
		}

		//Setting label to show to user at the
		if (component.get('v.woTipology') === 'Installation') {
			component.set('v.propertiesMap.woTipologyLabel', $A.get('$Label.c.Plc_AllAllInstallation'));
		} else if (component.get('v.woTipology') === 'Uninstallation') {
			component.set('v.propertiesMap.woTipologyLabel', $A.get('$Label.c.Plc_AllAllUninstallation'));
		} else if (component.get('v.woTipology') === 'Deactivation') {
			component.set('v.propertiesMap.woTipologyLabel', $A.get('$Label.c.Plc_AllAllDeactivation'));
		}
		//Setting serials table columns after getting labels
		component.set('v.columns', helper.getColumnDefinitionsSerialStock(component));
	},

	/* Handler for showing confirmation modal */
	handleShowSaveConfirmation: function(component, event, helper) {
		helper.openModal(component, 'modal-save');
	},

	/* Handler for showing confirmation modal */
	handleHideSaveConfirmation: function(component, event, helper) {
		helper.closeModal(component, 'modal-save');
	},

	/* Handler for creating the new work order */
	handleCreateWorkOrder: function(component, event, helper) {
		helper.createWorkOrder(component, helper);
		helper.closeModal(component, 'modal-save');
	},

	/* [END]
     * Work Order related handlers
     * ----------------------------------------------------------------------------------------------------------------------------------- */

	/* [START]
     * Work Order Line Items related handlers
     * ----------------------------------------------------------------------------------------------------------------------------------- */

	/* Handler for showing Work Order Line Items area */
	handleshowWorkOrderLineItemsArea: function(component, event, helper) {
		component.set('v.propertiesMap.showWorkOrderLineItemsArea', true);
		helper.retrieveEligibleOperations(component, helper);
	},

	/* Handler for adding items */
	handleAddItems: function(component, event, helper) {
		helper.addItems(component, helper);
		helper.closeModal(component, 'modal-serials');
	},

	/* Handler for remove an item */
	handleRemoveItem: function(component, event, helper) {
		var positions = event.getSource().get('v.name').split(',');
        helper.removeItem(component, helper, positions);
	},

	/* Handler for items list change */
	handleItemsChange: function(component, event, helper) {
		helper.setSaveButton(component, helper);
	},

	/* Handler for managing the termId change */
	handleTermIdChange: function(component, event, helper) {
		//WA in order to refresh termId change
		console.log('HandleTermIdChange');
		var itemsList = component.get('v.itemsList');
		component.set('v.itemsList', itemsList);
		// helper.setSaveButton(component, helper);
	}
	/* [END]
     * Work Order Line Items related handlers
     * ----------------------------------------------------------------------------------------------------------------------------------- */
})