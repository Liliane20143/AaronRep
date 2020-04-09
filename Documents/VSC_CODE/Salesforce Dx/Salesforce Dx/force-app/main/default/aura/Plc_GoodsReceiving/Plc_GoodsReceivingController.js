/**
 * Created by lebellini on 31/01/2019.
 */
({
    handleInit: function (component, event, helper) {

        console.log("Plc_GoodsReceiving.cmp --> Init Component Invoked");
        helper.initializeData(component);
    },

    handleBack: function (component, event, helper) {
        console.log("Plc_GoodsReceiving.cmp --> HandleBack Invoked");
    },

    handleNext: function (component, event, helper) {
        console.log("Plc_GoodsReceiving.cmp --> HandleNext Invoked");
    },

    handleAnnulla: function (component, event, helper) {
        console.log("Plc_GoodsReceiving.cmp --> HandleAnnull Invoked");
    },

    handleSave: function (component, event, helper) {
        console.log("Plc_GoodsReceiving.cmp 1 --> HandleSave Invoked");

        var titolo = component.get("v.title");
        console.log("Save clicked, titolo: " + titolo);

        var availableGoods = component.get('v.availableGoods');
        var acceptedGoods = component.get('v.acceptedGoods');
        var rejectedGoods = component.get('v.rejectedGoods');
        var sourceId = component.get('v.objectId');

        console.log('sourceId:' + sourceId);
        console.log('availableGoods:', availableGoods);
        console.log('acceptedGoods:',  acceptedGoods);
        console.log('rejectedGoods:', rejectedGoods);

        var action = component.get("c.saveGoods");

        action.setParams({
            serializedAvailableGoods: JSON.stringify(availableGoods),
            serializedAcceptedGoods: JSON.stringify(acceptedGoods),
            serializedRejectedGoods: JSON.stringify(rejectedGoods),
            sourceRecordId: sourceId
        });
        action.setCallback(this, function (res) {

            component.set("v.showSpinner", false);
            if (component.isValid() && res.getState() === "SUCCESS") {


                var errorMessage = res.getReturnValue().errorMessage;
                if (errorMessage != '') {
                    component.set("v.savingErrorMessage", errorMessage);
                } else {
                    component.set("v.savingErrorMessage", '');
                }

                console.log("errorMessage : " + errorMessage);
                helper.displayPopup(component, 'savingResult', null);
            } else if (component.isValid() && res.getState() === "INCOMPLETE") {

                console.log("Incomplete callback: " + res.getError()[0].message);
            } else if (component.isValid() && res.getState() === "ERROR") {

                console.log("Callback in error: " + res.getError()[0].message);
                helper.displayPopup(component, 'catchSystemError', null);
                component.set('v.popupMessage', 'Error: ' + res.getError()[0].message);
                component.set("v.showSpinner", false);
            }
        });
        component.set("v.showSpinner", true);
        $A.enqueueAction(action);
    },

    handleClosePopUpByOk: function (component, event, helper) {

        console.log("Plc_GoodsReceiving.cmp --> handleClosePopUp Invoked");

        var actionName = component.get('v.actionTypeOnAvailableGood');
        var selectedRow = component.get('v.selectedRow');

        if (actionName != null) {

            switch (actionName) {
                case 'acceptGood':
                    helper.checkQuantityInputError(component);
                    if (component.get('v.errorsOnWizard')) {
                        return;
                    }

                    helper.handleAcceptGood(component);
                    break;
                case 'rejectGood':
                    helper.checkQuantityInputError(component);
                    if (component.get('v.errorsOnWizard')) {
                        return;
                    }

                    helper.handleRejectGood(component);
                    break;
                default:
                    break;
            }

        }

        component.set('v.showPopup', false);
        component.set('v.showQuantityPopup', false);

        component.set('v.actionTypeOnAvailableGood', '');
        component.set('v.selectedRow', null);
        component.set('v.selectedQuantityVal', 0);

        helper.checkSaveButtonVisibility(component);

        if (component.get('v.popupMessage') == $A.get('$Label.c.Plc_SavingSuccess')) {
            //FB 20191203 NEXIPLC-742 [START]

            let availableGoods = component.get('v.availableGoods');

            if (availableGoods && availableGoods.length > 0) {
                //$A.get('e.force:refreshView').fire();
                component.set('v.dataLoaded', false);
                component.set('v.wizardDataAreChanged', false);
                component.set('v.showTableSpinner', true);
                helper.initializeData(component);
            } else {
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": component.get("v.objectId"),
                    "slideDevName": "related"
                });
                navEvt.fire();
            }
            //FB 20191203 NEXIPLC-742 [END]
        }
    },

    handleClosePopupByCancel: function (component, event, helper) {

        console.log("Plc_GoodsReceiving.cmp --> handleClosePopUp Invoked");
        component.set('v.showPopup', false);
        component.set('v.showQuantityPopup', false);
    },
    handleFilterComponent: function (component, event, helper) {

        console.log("Plc_GoodsReceiving.cmp --> handleFilterComponent Invoked");
        var searchResult = event.getParam('searchResultsEvt');
        var actionType = event.getParam('actionType');
        var searchedText = event.getParam('inputSearchValue');

        if(searchedText != null) {
            searchedText = searchedText.toUpperCase();
        }

        component.set("v.filterResult", searchResult);
        component.set('v.searchInputValue', searchedText);

        console.log('searchResult --> ', searchResult);
        console.log('actionType --> ' + actionType);
        console.log('searchedText --> ' + searchedText);
        console.log('searchConfigurationMap --> ', component.get('v.searchConfigurationMap'));

        if (actionType == 'applyFilters') {

            helper.feedGoodsDataOnTables(component);
        } else if (actionType == 'removeFilters') {

            component.set('v.searchOnLoad', false);
            component.set('v.searchOnLoad', true);
        }

    },

    handleAvailableGoodsRowAction: function (component, event, helper) {
        console.log("Plc_GoodsReceiving.cmp --> handleInboundGoodsRowAction Invoked");

        var action = event.getParam('action');
        var row = event.getParam('row');
        component.set('v.selectedRow', row);

        console.log('Action --> ', action);
        console.log('row --> ' + row);

        component.set('v.actionTypeOnAvailableGood', action.name);
        component.set('v.selectedRow', row);

        if (row.availableQuantity == 1) {
            if (action.name == 'acceptGood') {
                helper.handleAcceptGood(component);
            } else if (action.name == 'rejectGood') {
                helper.handleRejectGood(component);
            }
            helper.checkSaveButtonVisibility(component)
        } else {
            helper.displayPopup(component, 'quantitySelection', null);
        }

    },

    handleAcceptedGoodsRowAction: function (component, event, helper) {
        console.log("Plc_GoodsReceiving.cmp --> handleAcceptedGoodsRowAction Invoked");

        var action = event.getParam('action');
        var row = event.getParam('row');

        console.log('Action --> ', action);
        console.log('row --> ', row);

        switch (action.name) {
            case 'undo':
                if (row.locked) {
                    helper.displayPopup(component, 'undoForbidden', null);
                } else {
                    helper.handleUndoGoodsAcceptance(component, event);
                }
                break;
            default:
                break;
        }

        helper.checkSaveButtonVisibility(component)

    },

    handleRejectedGoodsRowAction: function (component, event, helper) {
        console.log("Plc_GoodsReceiving.cmp --> handleRejectedGoodsRowAction Invoked");

        var action = event.getParam('action');
        var row = event.getParam('row');
        component.set('v.selectedRow', row);

        console.log('Action --> ', event);
        console.log('row --> ', row);

        switch (action.name) {
            case 'undo':
                if (row.locked) {
                    helper.displayPopup(component, 'undoForbidden', null);
                } else {
                    helper.handleUndoGoodsRejection(component, event);
                }
                break;
            default:
                break;
        }

        helper.checkSaveButtonVisibility(component)

    },

    handleOnCellChange: function (component, event, helper) {
        console.log("Plc_GoodsReceiving.cmp --> handleOnCellchange Invoked");

        helper.validateTableDataEntryValues(component, event);
    },

    handleOnSaveAvailableGoodsTable: function (component, event, helper) {
        console.log("Plc_GoodsReceiving.cmp --> handleOnSaveAvailableGoodsTable Invoked");

        var errorsOnWizard = component.get("v.errorsOnWizard");

        if (errorsOnWizard) {
            console.log("error in data entry");
            helper.displayPopup(component, 'errorOnSaveTable', null);
            return;
        }

        var changedRows = event.getParam('draftValues');
        console.log("rowsChanged: ", changedRows);
        //annullo l'attributo delle rows cambiate per far sparire i pulsanti cancel e Save
        //var tableP = component.find("SelectedProductQuantityTable");
        //tableP.set("v.draftValues", null);
    },

    checkQuantitySelection: function (component, event, helper) {
        console.log("Plc_GoodsReceiving.cmp --> handleOnSaveAvailableGoodsTable Invoked");
        helper.checkQuantityInputError(component);
    },

    //STARTFIX - Andrea Liverani - [20190306AL] - 06/03/2019
    handleChangeAvailableGoods : function (component, event, helper) {
        helper.updateQuantity(component, component.get('v.availableGoods'), 'available');
    },

    handleChangeAcceptedGoods : function (component, event, helper) {
        helper.updateQuantity(component, component.get('v.acceptedGoods'), 'accepted');
    },

    handleChangeRejectedGoods : function (component, event, helper) {
        helper.updateQuantity(component, component.get('v.rejectedGoods'), 'rejected');
    },
    //ENDFIX - Andrea Liverani - [20190306AL] - 06/03/2019
    //FB 22-08-2019 : NEXIPLC-673 [START]
    handleAcceptAll: function (component, event, helper) {
        helper.acceptAll(component, helper);
        helper.checkSaveButtonVisibility(component)
    },
    handleAcceptSelected: function (component, event, helper) {
        helper.acceptSelected(component, helper);
        helper.checkSaveButtonVisibility(component)
    },
    handleDeselectAllAccepted: function (component, event, helper) {
        helper.deselectAllAccepted(component, helper);
        helper.checkSaveButtonVisibility(component)
    },
    handleDeselectAllRejected: function (component, event, helper) {
        helper.deselectAllRejected(component, helper);
        helper.checkSaveButtonVisibility(component)
    },
    handleAvailableRowSelection: function (component, event, helper) {
        var selectedRows = event.getParam('selectedRows');
        component.set('v.availableSelectedRows', selectedRows);
    }
    //FB 22-08-2019 : NEXIPLC-673 [END]
})