({
    handleInit: function (component, event, helper) {
        console.log("[START] @C - handleInit");
        helper.init(component);
        console.log("[END] @C - handleInit");
    },

    handleNext : function (component, event, helper) {
        console.log("[START] @C - handleNext");
        helper.next(component);
        console.log("[END] @C - handleNext");
    },

    handleQuantitySelection : function (component, event, helper) {
        console.log("[START] @C - handleQuantitySelection");
        component.set('v.selectedRow', event.getParam('row'));
        component.set('v.showQuantityPopup', true);
        console.log("[END] @C - handleQuantitySelection");
    },

    handleChangeTransferDetail : function (component, event, helper) {
        console.log("[START] @C - handleChangeTransferDetail");
        helper.changeTransferDetail(component);
        console.log("[END] @C - handleChangeTransferDetail");
    },

    handleChangeOriginDealer : function (component, event, helper) {
        console.log("[START] @C - handleChangeOriginDealer");
        helper.changeOriginDealer(component);
        console.log("[END] @C - handleChangeOriginDealer");
    },

    handleChangeOriginWarehouse : function (component, event, helper) {
        console.log("[START] @C - handleChangeOriginWarehouse");
        helper.changeOriginWarehouse(component);
        console.log("[END] @C - handleChangeOriginWarehouse");
    },

    handleChangeDestinationDealer : function (component, event, helper) {
        console.log("[START] @C - handleChangeDestinationDealer");
        helper.changeDestinationDealer(component);
        console.log("[END] @C - handleChangeDestinationDealer");
    },

    handleChangeDestinationWarehouse : function (component, event, helper) {
        console.log("[START] @C - handleChangeDestinationWarehouse");
        helper.changeDestinationWarehouse(component);
        console.log("[END] @C - handleChangeDestinationWarehouse");
    },

    handleClosePopupByCancel : function (component, event, helper) {
        console.log("[START] @C - handleClosePopupByCancel");
        component.set('v.showQuantityPopup', false);
        console.log("[END] @C - handleClosePopupByCancel");
    },

    handleClosePopUpByOk : function (component, event, helper) {
        console.log("[START] @C - handleClosePopUpByOk");
        helper.closePopUpByOk(component);
        component.set('v.showQuantityPopup', false);
        console.log("[END] @C - handleClosePopUpByOk");
    },

    handleCloseModal : function (component, event, helper) {
        console.log("[START] @C - handleCloseModal");
        component.set('v.showModal', false);
        if(component.get('v.modalMessage') == 'Incorrect quantity selected.') {
            component.set('v.showQuantityPopup', true);
            component.set('v.selectedQuantity', 0);
        }

        if(component.get('v.modalType') == 'success') {
            helper.redirectToPageObject(component);
        }
        console.log("[END] @C - handleCloseModal");
    },

    handleFilterComponent : function (component, event, helper) {
        console.log("[START] @C - handleFilterComponent");
        helper.filterComponent(component, event);
        console.log("[END] @C - handleFilterComponent");
    },

    handleChangeStockSerialWrapperList : function (component, event, helper) {
        console.log("[START] @C - handleChangeStockSerialWrapperList");
        helper.changeStockSerialWrapperList(component);
        console.log("[END] @C - handleChangeStockSerialWrapperList");
    },

    handleRemoveStockSerial : function (component, event, helper) {
        console.log("[START] @C - handleRemoveStockSerial");
        helper.removeStockSerial(component, event);
        console.log("[END] @C - handleRemoveStockSerial");
    },

    handleSave: function (component, event, helper) {
        console.log("[START] @C - handleSave");
        helper.save(component);
        console.log("[END] @C - handleSave");
    },

    handleChangeDliQuantityList : function (component, event, helper) {
        console.log("[START] @C - handleChangeDliQuantityList");
        helper.changeDliQuantityList(component);
        console.log("[END] @C - handleChangeDliQuantityList");
    },

    handleChangePicklistSelection : function (component, event, helper) {
        console.log("[START] @C - handleChangePicklistSelection");
        if(component.get('v.editWizard') == false) {
            helper.changePicklistSelection(component);
        }
        console.log("[END] @C - handleChangePicklistSelection");
    },

    handleChangeVisibility : function (component, event, helper) {
        console.log("[START] @C - handleChangeVisibility");
        helper.changeVisibility(component, event);
        console.log("[END] @C - handleChangeVisibility");
    }

})