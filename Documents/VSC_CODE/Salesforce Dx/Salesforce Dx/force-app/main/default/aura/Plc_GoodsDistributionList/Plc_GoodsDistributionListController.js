({
    /* Handler called during initialization */
    handleInit: function(component, event, helper) {
        helper.retrieveTranslationMap(component, helper);
        helper.retrievePropertiesMap(component, event, helper, false);
    },
    /* Handler for opening all accordions */
    handleExpandAll: function(component, event, helper) {
        var sectionsToExpand = component.get('v.whSolutionIds')
                               .concat(component.get('v.warehouseIds')
                               .concat(component.get('v.dealerIds')));
        component.set('v.activeSections', sectionsToExpand);
    },
    /* Handler for closing all accordions */
    handleCompressAll: function(component, event, helper) {
        component.set('v.activeSections', []);
    },
    /* Handler for filtering dealers */
    handleDealerFilter: function(component, event, helper) {
        var nameToSearch = event.getSource().get("v.value").toLowerCase();
        helper.dealerFilter(component, helper, nameToSearch);
    },
    /* Handler for filtering warehouses */
    handleWarehouseFilter: function(component, event, helper) {
        var nameToSearch = event.getSource().get("v.value").toLowerCase();
        helper.warehouseFilter(component, helper, nameToSearch);
    },
    /* Handler for filtering warehouses solutions */
    handleWhSolutionFilter: function(component, event, helper) {
        var nameToSearch = event.getSource().get("v.value").toLowerCase();
        helper.whSolutionFilter(component, helper, nameToSearch);
    },
    /* Handler for filtering products */
    handleProductFilter: function(component, event, helper) {
        var nameToSearch = event.getSource().get("v.value").toLowerCase();
        helper.productFilter(component, helper, nameToSearch);
    },
    /* Handler for updating reorder values when quantities are changed */
    handleProductQtyChange: function(component, event, helper) {
        var positions = event.getSource().get('v.name').split(',');
        var value = event.getSource().get('v.value');
        helper.updateNewQuantities(component, helper, positions, value);
    },
    /* Handler for updating total repaired requested items quantity */
    handleProductRepairedQtyChange: function(component, event, helper) {
        var positions = event.getSource().get('v.name').split(',');
        var value = event.getSource().get('v.value');
        helper.updateRepairedQuantities(component, helper, positions, value);
    },
    /* Handler for showing collapsed warehouses list with repaired items */
    handleShowRepairedItems: function(component, event, helper) {
        var positions = event.getSource().get('v.name').split(',');
        helper.showRepairedItemsArea(component, helper, positions);
    },
    /* Handler for creating/updating note of repaired */
    handleNoteRepaired: function(component, event, helper) {
        var positions = event.getSource().get('v.name').split(',');
        helper.showNoteRepairedPopover(component, helper, positions);
    },
    /* Handler for creating/updating note of new */
    handleNoteNew: function(component, event, helper) {
        var positions = event.getSource().get('v.name').split(',');
        helper.showNoteNewPopover(component, helper, positions);
    },
    /* Handler for closing modal */
    handleCloseModal: function(component, event, helper){ 
        helper.closeModal(component, helper, 'modal-owner');
    },
    /* Handler for opening modal */
    handleShowModal: function(component, event, helper) {
        helper.openModal(component, helper);
    },
    /* Handler for showing new products section*/
    handleShowNewProductSection: function(component, event, helper) {
        var positions = event.getSource().get('v.name').split(',');
        helper.showNewProductSection(component, helper, positions);
    },
    /* Handler for creating a new product stock */
    handleCreateNewProductStock: function(component, event, helper) {
        var positions = event.getSource().get('v.name').split(',');
        helper.censusNewProductStock(component, helper, positions);
    },
    /*Handler for changing owner*/
    handleChangeOwner: function(component, event, helper) {
        helper.changeOwner(component, helper);
        helper.closeModal(component, helper, 'modal-owner');
    },
    /* Handler called when next button is hit */
    handleNext: function (component, event, helper) {
        helper.next(component, event, helper);
    },
    /* Handler called when previous button is hit */
    handlePrevious: function (component, event, helper) {
        helper.previous(component, event, helper);
    },
    /* Handler for saving distribution list and its items */
    handleSave: function(component, event, helper) {
        helper.saveDistributionList(component, helper, false);
    },
    /* Handler for saving distribution list and its items and going to distribution list */
    handleSaveAndExit: function(component, event, helper) {
        helper.saveDistributionList(component, helper, true);
    },
})