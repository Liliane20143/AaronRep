({
    /* Shows a custom message defined by parameters */
    showToast: function(title, message, type, mode) {
        // show toast message
        // mode
        // sticky: it stays on screen until user action
        // dismissable: it disappears after some time automatically
        var toastEvent = $A.get('e.force:showToast');
        toastEvent.setParams({
            'title': title,
            'message': message,
            'type': type,
            'mode': mode || 'dismissable',
            'duration': 3000
        }); 
        toastEvent.fire();
    },
    /* Close modal function*/
    closeModal: function(component, helper, modalName) { 
        var cmpTarget = component.find(modalName);
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
    },
    /* Hide modal function*/
    openModal: function(component, helper, modalName) {
        var cmpTarget = component.find(modalName);
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open'); 
    },
    /* Showing spinner function */
    showSpinner: function(component, spinnerName) {
        $A.util.removeClass(component.find(spinnerName), 'slds-hide');
    },
    /* Hiding loading spinner function */
    hideSpinner: function(component, spinnerName) {
        $A.util.addClass(component.find(spinnerName), 'slds-hide');
    },
    /* Redirects to a given id object page*/
    redirectToObject: function(objectId){

        window.open('/' + objectId, '_blank');
    },
    /* Sorting column function */
    sortData: function (component, fieldName, sortDirection, items) {
        var reverse = sortDirection !== 'asc';
        items = Object.assign([],
            items.sort(this.sortBy(fieldName, reverse ? -1 : 1))
        );
        return items;
    },
    /* Sorting column function helper*/
    sortBy: function (field, reverse, primer) {
        var key = primer
            ? function(x) { return primer(x[field]) }
            : function(x) { return x[field] };
        return function (a, b) {
            var A = key(a);
            var B = key(b);
            return reverse * ((A > B) - (B > A));
        };
    },
    /* Function used to reset data */
    resetData: function (component, helper) {
        component.set('v.productStocksList', []);
        component.set('v.snapshotToCreateSize', 0);
        component.set('v.searchKey', '');
    },
    /*Defines the columns (for product stock items) showed in the component */
    getColumnDefinitionsProductStock: function(component) {
        var columns = [
            { 
                label: component.get('v.translationMap.B2WExtCat__External_Catalog_Item_Name__c'),
                type: 'button',
                typeAttributes: {
                    label: {fieldName: 'B2WExtCat__External_Catalog_Item_Name__c'},
                    title: component.get('v.translationMap.B2WExtCat__External_Catalog_Item_Name__c'),
                    class: 'btn_linkProductStock',
                }
            },
            { label: component.get('v.translationMap.Plc_ProductSku__c'), fieldName: 'Plc_ProductSku__c', type: 'text', sortable: true },
            { label: component.get('v.translationMap.Plc_Manufacturer__c'), fieldName: 'Plc_Manufacturer__c', type:'text', sortable: true },
            { label: component.get('v.translationMap.Bit2Shop__Stock_Qty__c'), fieldName: 'Bit2Shop__Stock_Qty__c', type: 'number', sortable: true },
            { label: component.get('v.translationMap.Plc_AvailableQty__c'), fieldName:'Plc_AvailableQty__c', type: 'number', sortable: true },
            { label: component.get('v.translationMap.Plc_UsableQty__c'), fieldName:'Plc_UsableQty__c', type: 'number', sortable: true },
            { label: component.get('v.translationMap.Plc_WithdrawnQty__c'), fieldName:'Plc_WithdrawnQty__c', type: 'number', sortable: true },
            { label: component.get('v.translationMap.Plc_OtherQty__c'), fieldName:'Plc_OtherQty__c', type: 'number', sortable: true },
            { label: component.get('v.translationMap.Plc_ReservedQty__c'), fieldName:'Plc_ReservedQty__c', type: 'number', sortable: true },
            { label: component.get('v.translationMap.Plc_OrderedQty__c'), fieldName:'Plc_OrderedQty__c', type: 'number', sortable: true }
        ];
        return columns;
    },
    /* Gets from server a map that contains pairs api name/label. Used in order to get translations */
    retrieveTranslationMap: function(component, helper) {
        var action = component.get('c.retrieveTranslationMap');
        helper.showSpinner(component, 'main-spinner');
        action.setCallback(this, function(response) {
            var state = response.getState();

            if (component.isValid() && state === 'SUCCESS') {
                var result = response.getReturnValue();
                //setting translations
                component.set('v.translationMap.Bit2Shop__Product_Stock__c', result.Bit2Shop__Product_Stock__c);
                component.set('v.translationMap.PluralBit2Shop__Product_Stock__c', result.PluralBit2Shop__Product_Stock__c);
                component.set('v.translationMap.B2WExtCat__External_Catalog_Item_Name__c', result.B2WExtCat__External_Catalog_Item_Name__c);
                component.set('v.translationMap.Plc_ProductSku__c',  result.Plc_ProductSku__c);
                component.set('v.translationMap.Plc_Manufacturer__c', result.Plc_Manufacturer__c);
                component.set('v.translationMap.Bit2Shop__Stock_Qty__c', result.Bit2Shop__Stock_Qty__c);
                component.set('v.translationMap.Plc_AvailableQty__c', result.Plc_AvailableQty__c);
                component.set('v.translationMap.Plc_UsableQty__c', result.Plc_UsableQty__c);
                component.set('v.translationMap.Plc_WithdrawnQty__c', result.Plc_WithdrawnQty__c);
                component.set('v.translationMap.Plc_OtherQty__c', result.Plc_OtherQty__c);
                component.set('v.translationMap.Plc_ReservedQty__c', result.Plc_ReservedQty__c);
                component.set('v.translationMap.Plc_OrderedQty__c', result.Plc_OrderedQty__c);
                component.set('v.translationMap.Plc_ProductStockSnapshot__c', result.Plc_ProductStockSnapshot__c);
                component.set('v.translationMap.PluralPlc_ProductStockSnapshot__c', result.PluralPlc_ProductStockSnapshot__c);
                component.set('v.translationMap.Bit2Shop__Warehouse__c', result.Bit2Shop__Warehouse__c);
            }
            helper.hideSpinner(component, 'main-spinner');
        });
        $A.enqueueAction(action);
    },
    /* Function used to retrieve list of product stocks */
    retrieveProductStocks: function(component, helper) {

        var action = component.get('c.retrieveProductStocks');
        var selectedWarehouse = component.get('v.selectedWarehouse');
        var searchKey = component.get('v.searchKey');

        if (!selectedWarehouse.Id) {
            helper.resetData(component, helper);
            return;
        }

        helper.showSpinner(component, 'main-spinner');

        action.setParams({
            warehouseId: selectedWarehouse.Id,
            searchKey: searchKey
        });

        action.setCallback(this, function(response) {

            var result = response.getReturnValue();
            var state = response.getState();

            if (component.isValid() && state === 'SUCCESS'  && !result.error) {
                var result = response.getReturnValue();
                if (!searchKey) {
                    component.set('v.snapshotToCreateSize', result.productStocksList.length);
                    if (result.productStocksList.length == 0) {
                        component.set('v.propertiesMap.showNoWarehouseIllustration', true);
                        component.set('v.propertiesMap.illustrationMessage', $A.get('$Label.c.Plc_AllAllNoRecordsFound')
                                     .replace('{0}', component.get('v.translationMap.Bit2Shop__Product_Stock__c')));
                    } else {
                        component.set('v.propertiesMap.showNoWarehouseIllustration', false);
                    }
                } else {
                    if (result.productStocksList.length == 0) {
                        component.set('v.propertiesMap.showNoWarehouseIllustration', true);
                        component.set('v.propertiesMap.illustrationMessage', $A.get('$Label.c.Plc_AllAllNoRecordsFoundWithGivenFilters'));

                    } else {
                        component.set('v.propertiesMap.showNoWarehouseIllustration', false);
                    }
                }
                helper.buildData(component, helper, result.productStocksList);

            }  else if (component.isValid() && (response.getState() === 'ERROR' || result.error)){
                
                if (result) {
                    helper.showToast('', result.errorMsg, 'warning', 'sticky');
                    console.error(result.errorMsg);
                }
            }
            helper.hideSpinner(component, 'main-spinner');
        });
        $A.enqueueAction(action);

    },
    /* Function used to create Product Stock Snapshot */
    createProductStockSnapshots:  function(component, helper) {
        var action = component.get('c.createProductStockSnapshots');
        var selectedWarehouse = component.get('v.selectedWarehouse');

        helper.closeModal(component, helper, 'modal-save');
        helper.showSpinner(component, 'main-spinner');

        action.setParams({
            warehouseId: selectedWarehouse.Id
        });

        action.setCallback(this, function(response) {

            var result = response.getReturnValue();
            var state = response.getState();

            if (component.isValid() && state === 'SUCCESS'  && !result.error) {
                var result = response.getReturnValue();
                helper.showToast('', $A.get('$Label.c.Plc_AllAllSuccessfulSaving'), 'success');
                
                $A.get('e.force:refreshView').fire();
                
            }  else if (component.isValid() && (response.getState() === 'ERROR' || result.error)){
                
                if (result) {
                    helper.showToast('', result.errorMsg, 'warning', 'sticky');
                    console.error(result.errorMsg);
                }
            }
            helper.hideSpinner(component, 'main-spinner');
        });
        $A.enqueueAction(action);

    },
    /* Build data showed by component */
    buildData: function(component, helper, productStocksList) {

        productStocksList
            .map(function(item) {

                if (item.Bit2Shop__External_Catalog_Item_Id__c) {

                    item
                    .B2WExtCat__External_Catalog_Item_Name__c = item.Bit2Shop__External_Catalog_Item_Id__r
                                                                 .B2WExtCat__External_Catalog_Item_Name__c;
                }

                return item;
            });

        component.set('v.productStocksList', productStocksList);
        //Setting datatable columns
        component.set('v.columns', helper.getColumnDefinitionsProductStock(component));
    }
})