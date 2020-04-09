({  
    /* START
     * Utility functions
     * ----------------------------------------------------------------------------------------------------------------------------------- */

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
    /* Showing spinner function */
    showSpinner: function(component, spinnerName) {
        $A.util.removeClass(component.find(spinnerName), 'slds-hide');
    },
    /* Hiding loading spinner function */
    hideSpinner: function(component, spinnerName) {
        $A.util.addClass(component.find(spinnerName), 'slds-hide');
    },
    /* Close modal function*/
    closeModal: function(component, helper, modalName){ 
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
    /* Redirects to a given id object page*/
    redirectToObject : function(component, helper, objectId){

        window.open('/' + objectId, '_blank');

        // var navEvt = $A.get("e.force:navigateToSObject");
        // navEvt.setParams({
        //   "recordId": objectId,
        //   "slideDevName": "detail",
        // });
        // navEvt.fire();
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
    /* Shows items list empty image and sets length */
    setNoDataImageAndNumberOfItems: function(component, helper) {
        var itemsList = component.get('v.itemsList');
        if (itemsList == undefined || itemsList.length == 0) {
            component.set('v.propertiesMap.showNoDataIllustration', true);
            component.set('v.propertiesMap.mainItemsSize', 0);
        } else {
            component.set('v.propertiesMap.showNoDataIllustration', false);
            component.set('v.propertiesMap.mainItemsSize', itemsList.length);
        }
    },
    /* Reset all flags used to identify cases */
    resetFlags: function(component, helper) {
        component.set('v.propertiesMap.navigationSelectedItem', 'gestioneMatricola');
        component.set('v.isSerialStockDataTableFlag', true);
        component.set('v.isStoreNewProductFlag', false);
        component.set('v.isNewAccessoryFlag', false);
        component.set('v.isAssetSubstitutionFlag', false);
        component.set('v.propertiesMap.searchKey', '');
        component.find('models-table').set('v.selectedRows', []);
        component.find('assets-table').set('v.selectedRows', []);
        component.set('v.selectedMaterial', null);
        component.set('v.selectedAsset', null);
    },
    /* Makes the save button selectable if there are any pending changes */
    setSaveButton: function(component, helper) {
        var itemsList = component.get('v.itemsList');
        var workOrder = component.get('v.propertiesMap.workOrder');

        var disableSave = true;

        // FB 27-09-2019: NEXIPLC-702 [START]
        if (component.get('v.propertiesMap.woStatus') != 'Canceled') {
            // FB 27-09-2019: NEXIPLC-702 [END]
            itemsList
                .forEach(function(woliProduct) {

                    if (woliProduct.id == '' && woliProduct.operationType != 'NoOperation') {
                        disableSave = false;
                    }

                    if (woliProduct.childWorkOrderLineItems.length > 0) {
                        woliProduct.childWorkOrderLineItems.forEach(function(woliAccessory) {
                            if (woliAccessory.id == '' && woliAccessory.operationType != 'NoOperation') {
                                disableSave = false;
                            }
                        });
                    }
                });
        }
        
        component.set('v.propertiesMap.disableSave', disableSave);
    },
    /* END
     * Utility functions
     * ----------------------------------------------------------------------------------------------------------------------------------- */

    /* START
     * Table column definitions
     * ----------------------------------------------------------------------------------------------------------------------------------- */

    /*Defines the columns (for serial stock items) showed in the component */
    getColumnDefinitionsSerialStock: function(component) {

        var columns = [
            { label: component.get('v.translationMap.Plc_Model__c'), fieldName: 'Plc_Model__c', type: 'text', sortable: true },
            { label: component.get('v.translationMap.Plc_ProductSku__c'), fieldName: 'Plc_ProductSku__c', type:'text', sortable: true },
            { label: component.get('v.translationMap.Plc_ManufacturerSerialNumber__c'), fieldName: 'Plc_ManufacturerSerialNumber__c', type:'text', sortable: true },
            { label: component.get('v.translationMap.Plc_EncodedSerialNumber__c'), fieldName: 'Plc_EncodedSerialNumber__c', type: 'text', sortable: true },
            { label: component.get('v.translationMap.Plc_DllSerialNumber__c'), fieldName: 'Plc_DllSerialNumber__c', type: 'text', sortable: true },
            { label: component.get('v.translationMap.Plc_Manufacturer__c'), fieldName: 'Plc_Manufacturer__c', type: 'text', sortable: true },
            { label: component.get('v.translationMap.Plc_Solution__c'), fieldName: 'Plc_Solution__c', type: 'text', sortable: true }
        ];
        return columns;
    },
    /*Defines the columns (for product stock items) showed in the component */
    getColumnDefinitionsProductStock: function(component) {
        var columns = [
            { label: component.get('v.translationMap.Plc_Model__c'), fieldName: 'Name', type: 'text', sortable: true },
            { label: component.get('v.translationMap.Plc_Manufacturer__c'), fieldName: 'Plc_Manufacturer__c', type:'text', sortable: true },
            { label: component.get('v.translationMap.Plc_ProductSku__c'), fieldName: 'Plc_ProductSku__c', type: 'text', sortable: true },
            { label: component.get('v.translationMap.Plc_Solution__c'), fieldName: 'Plc_Solution__c', type: 'text', sortable: true },
            { label: component.get('v.translationMap.Plc_MinimumStock__c'), fieldName: 'Plc_MinimumStock__c', type: 'number', sortable: true },
            { label: component.get('v.translationMap.Bit2Shop__Stock_Qty__c'), fieldName: 'Plc_AvailableQty__c', type: 'number', sortable: true },
            { label: $A.get('$Label.c.Plc_AllAllRequestedQty'), fieldName:'requestedQty', type: 'number', sortable: true },
            { label: component.get('v.translationMap.Plc_AvailableQty__c'), fieldName:'availableQty', type: 'number', sortable: true }
        ];
        return columns;
    },
    /*Defines the columns (for product stock items) showed in the component */
    getColumnDefinitionsAsset: function(component) {
        var columns = [
            { label: 'Name', fieldName: 'Name', type: 'text', sortable: true },
            { label: component.get('v.translationMap.Plc_ProductSku__c'), fieldName: 'Plc_ProductSku__c', type: 'text', sortable: true },
            { label: component.get('v.translationMap.Plc_Subcategory__c'), fieldName: 'Plc_Subcategory__c', type: 'text', sortable: true },
        ];
        return columns;
    },

    /* END
     * Table column definitions
     * ----------------------------------------------------------------------------------------------------------------------------------- */

    /* START
     * Initialization functions
     * ----------------------------------------------------------------------------------------------------------------------------------- */

    /* Gets from server a map that contains pairs api name/label. Used in order to get translations */
    retrieveTranslationMap: function(component, helper) {
        var action = component.get('c.retrieveTranslationMap');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === 'SUCCESS') {
                var result = response.getReturnValue();

                //Setting translation for serial stock fields
                component.set('v.translationMap.Bit2Shop__Stock_Serials2__c', result.Bit2Shop__Stock_Serials2__c);
                component.set('v.translationMap.SerialStock', result.SerialStock);
                component.set('v.translationMap.SerialStockName', result.SerialStockName);
                component.set('v.translationMap.Plc_ManufacturerSerialNumber__c', result.Plc_ManufacturerSerialNumber__c);
                component.set('v.translationMap.Plc_EncodedSerialNumber__c', result.Plc_EncodedSerialNumber__c);
                component.set('v.translationMap.Plc_DllSerialNumber__c', result.Plc_DllSerialNumber__c);
                component.set('v.translationMap.Plc_ProductSku__c', result.Plc_ProductSku__c);
                component.set('v.translationMap.Plc_Manufacturer__c', result.Plc_Manufacturer__c);
                component.set('v.translationMap.Plc_Solution__c', result.Plc_Solution__c);
                component.set('v.translationMap.Plc_Model__c', result.Plc_Model__c);
                component.set('v.translationMap.Bit2Shop__Product_Stock__c', result.Bit2Shop__Product_Stock__c);
                component.set('v.translationMap.ProductStockName', result.ProductStockName);
                component.set('v.translationMap.Plc_AvailableQty__c', result.Plc_AvailableQty__c);
                component.set('v.translationMap.Bit2Shop__Stock_Qty__c', result.Bit2Shop__Stock_Qty__c);
                component.set('v.translationMap.B2WExtCat__External_Catalog_Item__c', result.B2WExtCat__External_Catalog_Item__c);
                component.set('v.translationMap.Plc_Category__c', result.Plc_Category__c);
                component.set('v.translationMap.Plc_Subcategory__c', result.Plc_Subcategory__c);
                component.set('v.translationMap.Plc_MinimumStock__c', result.Plc_MinimumStock__c);
                component.set('v.translationMap.WorkOrderLineItem', result.WorkOrderLineItem);
                component.set('v.translationMap.Status', result.Status);
                component.set('v.translationMap.Plc_SerialNumber__c', result.Plc_SerialNumber__c);
                component.set('v.translationMap.Quantity', result.Quantity);
                component.set('v.translationMap.Plc_ReplacedBy__c', result.Plc_ReplacedBy__c);
                component.set('v.translationMap.Plc_TermId__c', result.Plc_TermId__c);
                component.set('v.translationMap.Plc_TermIdCode__c', result.Plc_TermIdCode__c);
                component.set('v.translationMap.Asset', result.Asset);
                component.set('v.translationMap.AssetName', result.AssetName);
                component.set('v.translationMap.ShipmentLineItem', result.ShipmentLineItem);
                component.set('v.translationMap.Contact', result.Contact);
                component.set('v.translationMap.ContactName', result.ContactName);
                component.set('v.translationMap.Bit2Shop__Destination_Warehouse_Id__c', result.Bit2Shop__Destination_Warehouse_Id__c);
            }
        });
        $A.enqueueAction(action);
    },
    /* Gets from server a map of config and context data */
    retrievePropertiesMap: function(component, helper) {
        var action = component.get("c.retrievePropertiesMap");

        component.set('v.propertiesMap.isSerialStockDataTable', true);
        component.set('v.propertiesMap.searchKey', '');
        component.set('v.propertiesMap.navigationSelectedItem', 'gestioneMatricola');
        component.set('v.propertiesMap.disableSave', true);

        helper.showSpinner(component, 'main-spinner');

        action.setParams({  
            workOrderId: component.get('v.recordId')
        });

        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState();

            if (component.isValid() && state === "SUCCESS"  && !result.error) {
                component.set('v.propertiesMap.warehouseAlias', result.warehouseAlias);
                component.set('v.propertiesMap.servicePointLegacyId', result.servicePointLegacyId);
                component.set('v.propertiesMap.woStatus', result.woStatus);
                component.set('v.propertiesMap.disableNewProductItem', result.disableNewProductItem);
                component.set('v.propertiesMap.disableNewProductAsset', result.disableNewProductAsset);
                component.set('v.propertiesMap.workOrder', result.workOrder);
                component.set('v.propertiesMap.accessoryAvailableOperationTypesMap', 
                    result.accessoryAvailableOperationTypesMap);
                component.set('v.propertiesMap.availableOperationTypesMap', 
                    result.availableOperationTypesMap);

                component.set('v.woliToSerialMap', result.woliToSerialMap);
                component.set('v.stockSerialsMap', result.stockSerialsMap);

                helper.buildData(component, helper, JSON.parse(result.woliProductsMap), 
                                 JSON.parse(result.woliAccessoriesList), result.serialToShipmentLineItemMap,
                                 result.serialToOpenActivityMap, result.serialToClosedActivityMap);

            }  else if (component.isValid() && (response.getState() === "ERROR" || result.error)){
                if (result) {
                    helper.showToast('', result.errorMsg, 'warning', 'sticky');
                    console.error(result.errorMsg);
                }
            }
            helper.hideSpinner(component, 'main-spinner');
        });
        $A.enqueueAction(action);
    },

    /* END
     * Initialization functions
     * ----------------------------------------------------------------------------------------------------------------------------------- */

    /* START
     * Retrieving Materials logic
     * ----------------------------------------------------------------------------------------------------------------------------------- */

    /* Gets available models shown in the table of items */
    retrieveAvailableModels: function(component, helper) {
        helper.showSpinner(component, 'table-spinner');

        var action = component.get("c.retrieveAvailableModels");
        var positions = component.get('v.currentSelectedItemIndex');
        var currentMaterialType = component.get('v.currentSelectedMaterialType');
        var itemsList = component.get('v.itemsList');
        var productId = '';
        /* Getting current product on which it's being added an accessory in order to 
           filter all compatible ones */
          
        if (positions.length > 0 && currentMaterialType == 'Accessory') {
            if (itemsList[positions[0]].operationType == 'ToSubstitute' || itemsList[positions[0]].operationType == 'ToSubstituteCorr') {
                if (itemsList[positions[0]].replacedByExternalCatalogItemId) {
                    productId = itemsList[positions[0]].replacedByExternalCatalogItemId;
                } else {
                    productId = itemsList[positions[0]].externalCatalogItemId;
                }
            } else {
                productId = itemsList[positions[0]].externalCatalogItemId;
            }
            
        }

        var params = {  
            warehouseAlias: component.get('v.propertiesMap.warehouseAlias'),
            searchKey: component.get('v.propertiesMap.searchKey'),
            category: component.get('v.currentSelectedMaterialType'),
            consumedSerials: helper.collectConsumedSerials(component, helper),
            productId: productId,
            consumedExternalCatalogItems: helper.collectConsumedExternalCatalogItems(itemsList[positions[0]], positions)
        }

        //Checking if it is in the substitution, in this case must also check the solution
        if (component.get('v.isAccessorySubstitutionFlag') && positions.length > 1) {
            params.subItemSolutionId = itemsList[positions[0]].childWorkOrderLineItems[positions[1]].solutionId;
        } else if (component.get('v.isAssetSubstitutionFlag')) {
            params.subItemSolutionId = itemsList[positions[0]].solutionId;
        } else {
            params.subItemSolutionId = '';
        }

        action.setParams(params);

        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState();

            if (component.isValid() && state === "SUCCESS"  && !result.error) {
                helper.setAvailableModels(component, helper, result.availableStockSerialsList, result.availableProductStocksList);
            }  else if (component.isValid() && (response.getState() === "ERROR" || result.error)){
                if (result) {
                    helper.showToast('', result.errorMsg, 'warning', 'sticky');
                    console.error(result.errorMsg);
                }
            }
            helper.hideSpinner(component, 'table-spinner');
        });
        $A.enqueueAction(action);
    },

    /* Function used to unnest parent fields of available materials and to set them */
    setAvailableModels:  function(component, helper, 
                                  availableStockSerialsList,
                                  availableProductStocksList) {

        var consumedProducts = helper.collectConsumedProducts(component, helper);
        availableStockSerialsList
            .map(function(item) {
                if (item.Bit2Shop__Product_Stock_Id__c) {
                    item.Plc_Solution__c = item
                                           .Bit2Shop__Product_Stock_Id__r
                                           .Plc_Solution__c;
                }
                return item;
            });

        availableProductStocksList
            .map(function(item) {

                if (item.Bit2Shop__External_Catalog_Item_Id__c &&
                    item.Bit2Shop__External_Catalog_Item_Id__r.Plc_MinimumStock__c) {
                    item.Plc_MinimumStock__c = item
                                               .Bit2Shop__External_Catalog_Item_Id__r
                                               .Plc_MinimumStock__c
                } else {
                    item.Plc_MinimumStock__c = 1;
                }

                if (consumedProducts.hasOwnProperty(item.Bit2Shop__External_Catalog_Item_Id__c)){
                    item.requestedQty = consumedProducts[item.Bit2Shop__External_Catalog_Item_Id__c]
                                        .requestedQty;
                    item.availableQty = item.Plc_AvailableQty__c - consumedProducts[item.Bit2Shop__External_Catalog_Item_Id__c]
                                                                   .requestedQty;
                } else {
                    item.requestedQty = 0;
                    item.availableQty = item.Plc_AvailableQty__c;
                }
            });

        component.set('v.availableStockSerialsList', availableStockSerialsList);
        component.set('v.availableProductStocksList', availableProductStocksList);
        if (component.get('v.isSerialStockDataTableFlag')) {
            helper.showSerialStockMaterials(component, helper);
        } else {
            helper.showProductStockMaterials(component, helper);
        }
    },
    /* Function used to show serial stocks in the data table */
    showSerialStockMaterials: function(component, helper) {
        component.set('v.isSerialStockDataTableFlag', true);
        component.set('v.columns', helper.getColumnDefinitionsSerialStock(component));
        component.set('v.modelsList', component.get('v.availableStockSerialsList'));

        if (component.get('v.availableStockSerialsList').length == 0){
            component.set('v.propertiesMap.showNoMaterialIllustration', true); 
        } else {
            component.set('v.propertiesMap.showNoMaterialIllustration', false); 
        }
    },
    /* Function used to show product stocks in the data table */
    showProductStockMaterials: function(component, helper) {
        component.set('v.isSerialStockDataTableFlag', false);
        component.set('v.columns', helper.getColumnDefinitionsProductStock(component));
        component.set('v.modelsList', component.get('v.availableProductStocksList'));
        if (component.get('v.availableProductStocksList').length == 0){
            component.set('v.propertiesMap.showNoMaterialIllustration', true); 
        } else {
            component.set('v.propertiesMap.showNoMaterialIllustration', false); 
        }
    },

    /* END
     * Retrieving Materials logic
     * ----------------------------------------------------------------------------------------------------------------------------------- */

    /* START
     * Retrieving Assets logic
     * ----------------------------------------------------------------------------------------------------------------------------------- */

    /* Gets available models shown in the table of items */
    retrieveAvailableAssets: function(component, helper) {
        helper.showSpinner(component, 'assets-table-spinner');

        var action = component.get("c.retrieveAvailableAssets");

        action.setParams({  
            servicePointLegacyId: component.get('v.propertiesMap.servicePointLegacyId'),
            searchKey: component.get('v.propertiesMap.searchKey'),
            consumedAssets: helper.collectConsumedAssets(component, helper)
        });

        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState();

            if (component.isValid() && state === "SUCCESS"  && !result.error) {
                helper.setAvailableAsset(component, helper, result.assetList)
            }  else if (component.isValid() && (response.getState() === "ERROR" || result.error)){
                if (result) {
                    helper.showToast('', result.errorMsg, 'warning', 'sticky');
                    console.error(result.errorMsg);
                }
            }
            helper.hideSpinner(component, 'assets-table-spinner');
        });
        $A.enqueueAction(action);
    },
    /* Sets available assets */
    setAvailableAsset : function(component, helper, 
                                 availableAssetList) {

        component.set('v.columns', helper.getColumnDefinitionsAsset(component));
        availableAssetList
            .map(function(item) {

                if (item.Plc_ProductStock__c) {
                    item.Plc_ProductSku__c = item
                                             .Plc_ProductStock__r
                                             .Plc_ProductSku__c;
                    if (item.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r) {
                        item.Plc_Subcategory__c = item
                                                  .Plc_ProductStock__r
                                                  .Bit2Shop__External_Catalog_Item_Id__r
                                                  .Plc_Subcategory__c;
                    }
                } else {
                    item.Plc_MinimumStock__c = 1;
                }

            });

        if (availableAssetList.length == 0) {
            component.set('v.propertiesMap.showNoAssetIllustration', true);
        } else {
            component.set('v.propertiesMap.showNoAssetIllustration', false);
        }
        component.set('v.availableAssetList', availableAssetList);
    },
    /* Function for adding a selected asset as woli */
    addProductAsset: function(component, helper) {
        try {
            var selectedAsset = component.get('v.selectedAsset');
            var itemsList = component.get('v.itemsList');

            helper.showSpinner(component, 'main-spinner');

            var action = component.get("c.retrieveChildStoreProductAssets");

            action.setParams({  
                assetId: selectedAsset.Id,
            });

            action.setCallback(this, function(response) {
                var result = response.getReturnValue();
                var state = response.getState();

                if (component.isValid() && state === "SUCCESS"  && !result.error) {

                    var newWoliAsset = {};
                    var availableOperationTypesMap = helper.retrieveAvailableOptionsForAccessory(component);
                    var operationType = helper.retrieveAvailableOptionsForAccessory(component)[0].key;
                    var operationType = helper.retrieveAvailableOptionsForAccessory(component)[0].value;

                    newWoliAsset.childWorkOrderLineItems = [];
                    newWoliAsset.id = '';
                    newWoliAsset.replacedBySerialId = '';
                    newWoliAsset.replacedByExternalCatalogItemId = '';
                    // newWoliAsset.label = component.get('v.translationMap.Asset') + ' • ' + selectedAsset.Name;
                    newWoliAsset.label = 'New'
                    newWoliAsset.productName = selectedAsset.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r
                                              .B2WExtCat__External_Catalog_Item_Name__c;
                    newWoliAsset.enableRemove = true;
                    newWoliAsset.operationType = operationType;
                    newWoliAsset.requestedQty = 1;
                    newWoliAsset.status = 'New';
                    newWoliAsset.serialId = selectedAsset.Plc_StockSerial__c;

                    newWoliAsset.assetId = selectedAsset.Id;
                    newWoliAsset.options = helper.retrieveAvailableOptionsForAccessory(component);
                    newWoliAsset.disableAddAccessory = true;
                    newWoliAsset.enableSubstitute = true;
                    newWoliAsset.isExpanded = true;

                    newWoliAsset.termId = selectedAsset.Plc_TermId__c;

                    if (selectedAsset.Plc_StockSerial__c) {
                        newWoliAsset.serialNumber = selectedAsset.Plc_StockSerial__r.Plc_EncodedSerialNumber__c
                                                    || selectedAsset.Plc_StockSerial__r.Plc_ManufacturerSerialNumber__c
                                                    || selectedAsset.Plc_StockSerial__r.Plc_EncodedSerialNumber__c;
                    }

                    if (selectedAsset.Plc_TermId__c) {
                        newWoliAsset.termIdName = selectedAsset.Plc_TermId__r.Name;
                        newWoliAsset.termIdCode = selectedAsset.Plc_TermId__r.Plc_TermIdCode__c;
                    }

                    newWoliAsset
                        .externalCatalogItemId = selectedAsset
                                                 .Plc_ProductStock__r
                                                 .Bit2Shop__External_Catalog_Item_Id__c;
                    newWoliAsset
                        .category = selectedAsset
                                    .Plc_ProductStock__r
                                    .Bit2Shop__External_Catalog_Item_Id__r
                                    .Plc_Category__c;

                    newWoliAsset
                        .subCategory = selectedAsset
                                       .Plc_ProductStock__r
                                       .Bit2Shop__External_Catalog_Item_Id__r
                                       .Plc_Subcategory__c;

                    newWoliAsset
                        .solutionId =  selectedAsset
                                       .Plc_ProductStock__r
                                       .Bit2Shop__External_Catalog_Item_Id__r
                                       .Plc_Solution__c;             

                    newWoliAsset
                        .requiredSerial = selectedAsset
                                          .Plc_ProductStock__r
                                          .Bit2Shop__External_Catalog_Item_Id__r
                                          .Bit2Shop__Required_Serial__c
                    newWoliAsset
                        .productSku = selectedAsset
                                      .Plc_ProductStock__r
                                      .Plc_ProductSku__c;

                    //Setting children found assets
                    JSON.parse(result.woliAccessoriesList).forEach(function(woliAccessory) {
                        newWoliAsset
                            .childWorkOrderLineItems.push(helper.transformAccessory(component, helper, woliAccessory));
                    }); 

                    itemsList.push(newWoliAsset);
                    component.set('v.itemsList', itemsList);
                    helper.closeModal(component, helper, 'modal-product-assets');
                    helper.resetFlags(component, helper);

                }  else if (component.isValid() && (response.getState() === "ERROR" || result.error)){
                    if (result) {
                        helper.showToast('', result.errorMsg, 'warning', 'sticky');
                        console.error(result.errorMsg);
                    }
                }
                helper.hideSpinner(component, 'main-spinner');
            });

            $A.enqueueAction(action);

            
        } catch (e) {
            console.error(e);
        }
    },

    /* END
     * Retrieving Assets logic
     * ----------------------------------------------------------------------------------------------------------------------------------- */

    /* START
     * Logic of adding items
     * ----------------------------------------------------------------------------------------------------------------------------------- */

    /* Dispatcher point used to add new product items */
    addItem: function(component, helper) {
        var itemsList = component.get('v.itemsList');
        var positions = component.get('v.currentSelectedItemIndex');
        try {
            if (component.get('v.isSerialStockDataTableFlag')) {

                var woliSerialStock = helper.createNewWoliSerialStock(component, helper, 'ToInstall');

                if (component.get('v.isNewAccessoryFlag') || 
                    component.get('v.isAssetSubstitutionFlag')) {

                    woliSerialStock.termId = itemsList[positions[0]].termId;
                    woliSerialStock.termIdName = itemsList[positions[0]].termIdName;
                    woliSerialStock.termIdCode = itemsList[positions[0]].termIdCode;
                } 

                if (component.get('v.isStoreNewProductFlag')) {
                    woliSerialStock.disableAddAccessory = true;
                    itemsList.push(woliSerialStock);
                } else if (component.get('v.isNewAccessoryFlag')) {
                    itemsList[positions[0]].childWorkOrderLineItems.push(woliSerialStock);
                } else if (component.get('v.isAccessorySubstitutionFlag')) {
                    var selectedMaterial = component.get('v.selectedMaterial');
                    itemsList[positions[0]].childWorkOrderLineItems[positions[1]].replacedBySerial = selectedMaterial.Plc_EncodedSerialNumber__c
                                                                                                     || selectedMaterial.Plc_ManufacturerSerialNumber__c 
                                                                                                     || selectedMaterial.Plc_DllSerialNumber__c;
                    itemsList[positions[0]].childWorkOrderLineItems[positions[1]].replacedBySerialId = selectedMaterial.Id;
                    itemsList[positions[0]].childWorkOrderLineItems[positions[1]].replacedByExternalCatalogItemId = selectedMaterial
                                                                                                                    .Bit2Shop__Product_Stock_Id__r
                                                                                                                    .Bit2Shop__External_Catalog_Item_Id__c;
                    itemsList[positions[0]].childWorkOrderLineItems[positions[1]].replacedByProductSku = selectedMaterial
                                                                                                         .Bit2Shop__Product_Stock_Id__r
                                                                                                         .Plc_ProductSku__c;
                    itemsList[positions[0]].childWorkOrderLineItems[positions[1]].replacedByProductName = selectedMaterial
                                                                                                          .Bit2Shop__Product_Stock_Id__r
                                                                                                          .Bit2Shop__External_Catalog_Item_Id__r
                                                                                                          .B2WExtCat__External_Catalog_Item_Name__c;

                } else if (component.get('v.isAssetSubstitutionFlag')) {
                    var selectedMaterial = component.get('v.selectedMaterial');
                    itemsList[positions[0]].replacedBySerial = selectedMaterial.Plc_EncodedSerialNumber__c
                                                                 || selectedMaterial.Plc_ManufacturerSerialNumber__c 
                                                                 || selectedMaterial.Plc_DllSerialNumber__c;
                    itemsList[positions[0]].replacedBySerialId = selectedMaterial.Id;
                    itemsList[positions[0]].replacedByExternalCatalogItemId = selectedMaterial
                                                                              .Bit2Shop__Product_Stock_Id__r
                                                                              .Bit2Shop__External_Catalog_Item_Id__c;
                    itemsList[positions[0]].replacedByProductSku = selectedMaterial
                                                                   .Bit2Shop__Product_Stock_Id__r
                                                                   .Plc_ProductSku__c;

                    itemsList[positions[0]].replacedByProductName = selectedMaterial.Bit2Shop__Product_Stock_Id__r
                                                                    .Bit2Shop__External_Catalog_Item_Id__r
                                                                    .B2WExtCat__External_Catalog_Item_Name__c;
                }
            } else {

                var woliProductStock = helper.createNewWoliProductStock(component, helper, 'ToInstall');
                if (woliProductStock == false) {
                    return;
                }

                if (component.get('v.isStoreNewProductFlag')) {
                    woliProductStock.disableAddAccessory = true;
                    itemsList.push(woliProductStock);
                } else if (component.get('v.isNewAccessoryFlag')) {
                    itemsList[positions[0]].childWorkOrderLineItems.push(woliProductStock);

                    woliProductStock.termId = itemsList[positions[0]].termId;
                    woliProductStock.termIdName = itemsList[positions[0]].termIdName;
                    woliProductStock.termIdCode = itemsList[positions[0]].termIdCode;
                }
            }

            component.set('v.itemsList', itemsList);
            helper.closeModal(component, helper, 'modal-add-item');
            helper.resetFlags(component, helper);

        } catch (e) {
            console.error(e);
            helper.closeModal(component, helper, 'modal-add-item');
        }
    },

    /* Creates a work order line item as store product from serial stock */
    createNewWoliSerialStock: function(component, helper, operationType) {
        var selectedMaterial = component.get('v.selectedMaterial');
        var newWoliSerialStock = {};
        var availableOperationTypesMap = component.get('v.propertiesMap.availableOperationTypesMap');

        newWoliSerialStock.childWorkOrderLineItems = [];
        // newWoliSerialStock.label = component.get('v.translationMap.WorkOrderLineItem') 
        //                            + ' • New';
        newWoliSerialStock.label = 'New';
        newWoliSerialStock.enableRemove = true;
        newWoliSerialStock.operationType = operationType;
        newWoliSerialStock.requestedQty = 1;
        newWoliSerialStock.status = 'New';
        newWoliSerialStock.id = ''
        newWoliSerialStock.serialNumber = selectedMaterial.Plc_EncodedSerialNumber__c
                                          || selectedMaterial.Plc_ManufacturerSerialNumber__c 
                                          || selectedMaterial.Plc_DllSerialNumber__c;
        newWoliSerialStock.serialId = selectedMaterial.Id;
        newWoliSerialStock.isExpanded = true;

        // newWoliSerialStock.termId = selectedMaterial.Plc_TermId__c;

        // if (selectedMaterial.Plc_TermId__c) {
        //     newWoliSerialStock.termIdName = selectedMaterial.Plc_TermId__r.Name;
        //     newWoliSerialStock.termIdCode = selectedMaterial.Plc_TermId__r.Plc_TermIdCode__c;
        // }

        newWoliSerialStock.options = [
            {label: availableOperationTypesMap['ToInstall'], value: "ToInstall"}
        ];

        newWoliSerialStock
            .externalCatalogItemId = selectedMaterial
                                     .Bit2Shop__Product_Stock_Id__r
                                     .Bit2Shop__External_Catalog_Item_Id__c;
        newWoliSerialStock
            .category = selectedMaterial
                        .Bit2Shop__Product_Stock_Id__r
                        .Bit2Shop__External_Catalog_Item_Id__r
                        .Plc_Category__c;

        newWoliSerialStock
            .subCategory = selectedMaterial
                           .Bit2Shop__Product_Stock_Id__r
                           .Bit2Shop__External_Catalog_Item_Id__r
                           .Plc_Subcategory__c;

        newWoliSerialStock
            .solutionId =  selectedMaterial
                           .Bit2Shop__Product_Stock_Id__r
                           .Bit2Shop__External_Catalog_Item_Id__r
                           .Plc_Solution__c; 

        newWoliSerialStock
            .productSku = selectedMaterial
                          .Bit2Shop__Product_Stock_Id__r
                          .Plc_ProductSku__c;
        // newWoliSerialStock
        //     .label += ' • ' +
        //               selectedMaterial
        //               .Bit2Shop__Product_Stock_Id__r
        //               .Name
        
        newWoliSerialStock.productName = selectedMaterial
                      .Bit2Shop__Product_Stock_Id__r
                      .Bit2Shop__External_Catalog_Item_Id__r
                      .B2WExtCat__External_Catalog_Item_Name__c;

        return newWoliSerialStock;
    },
    /* Creates a work order line item as store product from product stock */
    createNewWoliProductStock: function(component, helper, operationType) {

        var selectedMaterial = component.get('v.selectedMaterial');
        var isSelectedMaterialValid = component.get('v.isSelectedMaterialValid').valid;
        var selectedMaterialRequestedQty = component.get('v.selectedMaterialRequestedQty');
        var availableOperationTypesMap = component.get('v.propertiesMap.availableOperationTypesMap');

        if (!isSelectedMaterialValid) {
            return false;
        }
        
        var newWoliProductStock = {};
        newWoliProductStock.childWorkOrderLineItems = [];
        // newWoliProductStock.label = component.get('v.translationMap.WorkOrderLineItem') + ' • New';
        newWoliProductStock.label = 'New';
        newWoliProductStock.id = ''
        newWoliProductStock.isExpanded = true;
        newWoliProductStock.enableRemove = true;
        newWoliProductStock.status = 'New';
        newWoliProductStock.Plc_SerialNumber__c = '-';
        newWoliProductStock.operationType = operationType;
        newWoliProductStock.requestedQty = parseInt(selectedMaterialRequestedQty);
        newWoliProductStock.options = [
            {label: availableOperationTypesMap['ToInstall'], value: "ToInstall"}
        ];
        
        newWoliProductStock
            .externalCatalogItemId = selectedMaterial
                                    .Bit2Shop__External_Catalog_Item_Id__c;

        newWoliProductStock
            .category = selectedMaterial
                        .Bit2Shop__External_Catalog_Item_Id__r
                        .Plc_Category__c;

        newWoliProductStock
            .subCategory = selectedMaterial
                           .Bit2Shop__External_Catalog_Item_Id__r
                           .Plc_Subcategory__c;
        newWoliProductStock
            .solutionId =  selectedMaterial
                           .Bit2Shop__External_Catalog_Item_Id__r
                           .Plc_Solution__c; 

        newWoliProductStock
            .productSku = selectedMaterial
                          .Plc_ProductSku__c;

        // newWoliProductStock
        //     .label += ' • ' +
        //               selectedMaterial
        //               .Name
        productName
            .productName = selectedMaterial.Name;

        return newWoliProductStock;
    },

    /* END
     * Logic of adding items
     * ----------------------------------------------------------------------------------------------------------------------------------- */

    /* START
     * Logic of removing items
     * ----------------------------------------------------------------------------------------------------------------------------------- */

    /* Used to remove product items at given positions */
    removeProductItem: function(component, helper, positions) {
        var itemsList = component.get('v.itemsList');
        itemsList.splice(positions[0], 1);
        component.set('v.itemsList', itemsList);
    },
    /* Used to remove accessory items at given positions */
    removeAccessoryItem: function(component, helper, positions) {
        var itemsList = component.get('v.itemsList');
        itemsList[positions[0]].childWorkOrderLineItems.splice(positions[1], 1);
        component.set('v.itemsList', itemsList);
    },

    /* END
     * Logic of removing items
     * ----------------------------------------------------------------------------------------------------------------------------------- */

    /* START
     * Saving items logic
     * ----------------------------------------------------------------------------------------------------------------------------------- */

    /* Function used to save items generated by the wizard */
    saveItems: function(component, helper) {
        var action = component.get("c.saveItems");
        var itemsList = component.get('v.itemsList');
        var hasErrors = false;
        helper.showSpinner(component, 'main-spinner');
        
        itemsList
            .forEach(function(product) {
                if (hasErrors) {
                    return;
                }
                if ((product.operationType == 'ToSubstitute' || product.operationType == 'ToSubstituteCorr')&& 
                    product.replacedBySerialId == '' &&
                    product.id == '') {

                    helper.showToast('', $A.get('$Label.c.Plc_LightningComponentWorkOrderMissingSubstituteErrorMessage'), 'warning');
                    hasErrors = true; 
                    return;
                }

                if (product.childWorkOrderLineItems.length > 0) {
                    product.childWorkOrderLineItems.forEach(function(accessory) {
                        if ((accessory.operationType == 'ToSubstitute' || accessory.operationType == 'ToSubstituteCorr')&& 
                            accessory.replacedBySerialId == '') {
                            helper.showToast('', $A.get('$Label.c.Plc_LightningComponentWorkOrderMissingSubstituteErrorMessage'), 'warning');
                            hasErrors = true; 
                            return;
                        }
                    });
                }
            });

        if (hasErrors) {
            helper.hideSpinner(component, 'main-spinner');
            return;
        }

        action.setParams({  
            wo: component.get('v.propertiesMap.workOrder'),
            woliAsString: JSON.stringify(component.get('v.itemsList')),
        });

        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState();

            if (component.isValid() && state === "SUCCESS"  && !result.error) {
                helper.showToast('', $A.get('$Label.c.Plc_AllAllSuccessfulSaving'), 'success');
                // helper.saveAccessories(component, helper, result.woliAccessoryToInsertList);
            } else if (component.isValid() && (response.getState() === "ERROR" || result.error)){
                if (result) {
                    helper.showToast('', result.errorMsg, 'warning', 'sticky');
                    console.error(result.errorMsg);
                }
                // helper.retrievePropertiesMap(component, helper);
            }
            helper.retrievePropertiesMap(component, helper);
        });
        $A.enqueueAction(action);
    },
    /* Function called after first save of products */
    // saveAccessories: function(component, helper, woliAccessoryToInsertList) {
    //     var action = component.get("c.saveAccessories");
    //     helper.showSpinner(component, 'main-spinner');
        
    //     action.setParams({
    //         wo: component.get('v.propertiesMap.workOrder'),
    //         woliAccessoryToInsertList: woliAccessoryToInsertList
    //     });

    //     action.setCallback(this, function(response) {
    //         var result = response.getReturnValue();
    //         var state = response.getState();

    //         if (component.isValid() && state === "SUCCESS"  && !result.error) {

    //             helper.showToast('', $A.get('$Label.c.Plc_AllAllSuccessfulSaving'), 'success');

    //         } else if (component.isValid() && (response.getState() === "ERROR" || result.error)){
    //             if (result) {
    //                 helper.showToast('', result.errorMsg, 'warning', 'sticky');
    //                 console.error(result.errorMsg);
    //             }
    //         }
    //         helper.retrievePropertiesMap(component, helper);
    //     });
    //     $A.enqueueAction(action);
    // },
    /* Collects current accessories external catalog items */
    collectConsumedExternalCatalogItems: function(product, positions) {
        // var itemsList = component.get('v.itemsList');
        var consumedExternalCatalogItems = [];
        var substitutedAccessoryIndex = -1;
        if (positions.length == 0) {
            return [];
        }
        if (positions.length > 1) {
            substitutedAccessoryIndex = positions[1];
        }

        if (product.childWorkOrderLineItems.length > 0) {
            product.childWorkOrderLineItems
            .forEach(function(child, index) {
                if (index != substitutedAccessoryIndex) {
                    if (child.id) {
                        if ((child.operationType == 'ToInstall' || child.operationType == 'NoOperation') 
                            && child.externalCatalogItemId) {
                            consumedExternalCatalogItems.push(child.externalCatalogItemId);
                        } else if ((child.operationType == 'ToSubstitute' || child.operationType == 'ToSubstituteCorr') && child.replacedByExternalCatalogItemId) {
                            consumedExternalCatalogItems.push(child.replacedByExternalCatalogItemId);
                        }
                    } else {
                        consumedExternalCatalogItems.push(child.externalCatalogItemId);
                        if (child.replacedByExternalCatalogItemId) {
                            consumedExternalCatalogItems.push(child.replacedByExternalCatalogItemId);
                        }
                    }
                }
            });
        }
        return consumedExternalCatalogItems;
    },
    /* Collects current consumed serial stocks */
    collectConsumedSerials: function(component, helper) {
        var itemsList = component.get('v.itemsList');
        var consumedSerials = [];
        itemsList
            .forEach(function(parent) {
                if (parent.serialId){
                    consumedSerials.push(parent.serialId);
                }
                if (parent.replacedBySerialId) {
                    consumedSerials.push(parent.replacedBySerialId);
                }

                if (parent.childWorkOrderLineItems.length > 0) {
                    parent.childWorkOrderLineItems
                    .forEach(function(child) {
                        if (child.serialId){
                            consumedSerials.push(child.serialId);
                        }
                        if (child.replacedBySerialId) {
                            consumedSerials.push(child.replacedBySerialId);
                        }
                    });
                }
            });
        return consumedSerials;
    },
    /* Collects current consumed product stocks */
    collectConsumedProducts: function(component, helper) {
        var itemsList = component.get('v.itemsList');
        var consumedProducts = {};

        itemsList
            .forEach(function(parent) {

                if (!parent.serialNumber) {
                    if (consumedProducts.hasOwnProperty(parent.externalCatalogItemId)) {
                        consumedProducts[parent.externalCatalogItemId].requestedQty += parseInt(parent.requestedQty);
                    } else {
                        consumedProducts[parent.externalCatalogItemId] = {};
                        consumedProducts[parent.externalCatalogItemId].requestedQty = parseInt(parent.requestedQty);
                    }
                }
                if (parent.childWorkOrderLineItems.length > 0) {
                    parent.childWorkOrderLineItems
                    .forEach(function(child) {
                        if (!child.serialNumber){
                            if (consumedProducts.hasOwnProperty(child.externalCatalogItemId)) {
                                consumedProducts[child.externalCatalogItemId].requestedQty += child.requestedQty;
                            } else {
                                consumedProducts[child.externalCatalogItemId] = {};
                                consumedProducts[child.externalCatalogItemId].requestedQty = child.requestedQty
                            }
                        }
                    });
                }
            });
        return consumedProducts;
    },
    /* Collects current consumed Assets */
    collectConsumedAssets: function(component, helper) {
        var itemsList = component.get('v.itemsList');
        var consumedAssets = [];
        itemsList
            .forEach(function(parent) {
                if (parent.assetId){
                    consumedAssets.push(parent.assetId);
                }
                // if (parent.childWorkOrderLineItems.length > 0) {
                //     parent.childWorkOrderLineItems
                //     .forEach(function(child) {
                //         if (child.serialId){
                //             consumedAssets.push(child.serialId);
                //         }
                        
                //     });
                // }
            });
        return consumedAssets;
    },

    /* END
     * Saving items logic
     * ----------------------------------------------------------------------------------------------------------------------------------- */

    /* START
     * Drawing algorithm work order line items
     * ----------------------------------------------------------------------------------------------------------------------------------- */

    /* Function used to reset replaced by serial (Accessory) */
    resetReplacedByAccessory: function(component, positions) {
        var itemsList = component.get('v.itemsList');
        itemsList[positions[0]].childWorkOrderLineItems[positions[1]].replacedBySerial = '';
        itemsList[positions[0]].childWorkOrderLineItems[positions[1]].replacedBySerialId = '';
        itemsList[positions[0]].childWorkOrderLineItems[positions[1]].replacedByProductName = '';
        itemsList[positions[0]].childWorkOrderLineItems[positions[1]].replacedByProductSku = '';
        itemsList[positions[0]].childWorkOrderLineItems[positions[1]].replacedByExternalCatalogItemId = '';
        component.set('v.itemsList', itemsList);
    },
    /* Function used to reset replaced by serial (Store Product) */
    resetReplacedByStoreProduct: function(component, positions) {
        var itemsList = component.get('v.itemsList');
        itemsList[positions[0]].replacedBySerial = '';
        itemsList[positions[0]].replacedBySerialId = '';
        itemsList[positions[0]].replacedByProductName = '';
        itemsList[positions[0]].replacedByProductSku = '';
        itemsList[positions[0]].replacedByExternalCatalogItemId = '';
        component.set('v.itemsList', itemsList);
    },
    /* Functin used to set accessories status according to product status*/
    setChildAccessoriesStatus: function(component, helper, positions) {
        var itemsList = component.get('v.itemsList');

        var product = itemsList[positions[0]];
        itemsList[positions[0]]
        .childWorkOrderLineItems.map(function(item) {

            if (product.operationType == 'ToRemove') {
                item.options = item.options.filter(function(option) {
                    return option.value == 'ToRemove' || option.value == 'ToDeactivate';
                })
                if (item.options.length > 0) {
                    item.operationType = item.options[0].value;
                }
                
            } else {
                item = helper.transformAccessory(component, helper, item);
            }
            return item;
        });
        component.set('v.itemsList', itemsList);
    },
    /* Retrieve fixed option in the radio group buttons */
    retrieveOptionFixed: function(component, operationType) {

        var options = [];
        var availableOperationTypesMap = component.get('v.propertiesMap.availableOperationTypesMap');

        options.push({
            label: availableOperationTypesMap[operationType],
            value: operationType
        })
        
        return options
    },
    /* Retrieves available options to show for accessories */
    retrieveAvailableOptionsForAccessory: function(component) {

        var options = [];
        var accessoryAvailableOperationTypesMap = component.get('v.propertiesMap.accessoryAvailableOperationTypesMap');

        Object
            .keys(accessoryAvailableOperationTypesMap)
            .forEach(function(key) {
                options.push({
                    label: accessoryAvailableOperationTypesMap[key],
                    value: key
                });
            });

        return options;
    },
    /* Set whether to show add accessories for products */
    retrieveDisableAddAccessory: function(operationType) { 
        switch (operationType) {
            case 'NoOperation':
                return false;
                break;
            case 'ToInstall':
                return false;
                break;
            case 'ToSubstitute':
                return false;
                break;
            case 'ToSubstituteCorr':
                return false;
                break;
            default:
                return true;
        }
    },
    /* Function used to set accessory woli operations user is enabled to */
    transformAccessory: function(component, helper, woliAccessory) {
        woliAccessory.label = woliAccessory.lineItemNumber;
        if (!woliAccessory.id) {
            woliAccessory.options = helper.retrieveAvailableOptionsForAccessory(component);
            if (woliAccessory.options.length > 0) {
                woliAccessory.operationType = woliAccessory.options[0].value;
            }
            if (woliAccessory.operationType == 'NoOperation' || woliAccessory.operationType == 'ToSubstitute' || woliAccessory.operationType == 'ToSubstituteCorr') {
                woliAccessory.enableSubstitute = true;
            }

        } else {
            woliAccessory.options = helper.retrieveOptionFixed(component, woliAccessory.operationType)
        }
        return woliAccessory;
    },

    setMaterialsButtons: function(component, woli, serialToShipmentLineItemMap, 
                                  serialToOpenActivityMap, serialToClosedActivityMap) {

        var woliToSerialMap = component.get('v.woliToSerialMap');
        var stockSerialsMap = component.get('v.stockSerialsMap');

        if (woliToSerialMap.hasOwnProperty(woli.id)) {

            woli.disableFillReportButton = true;

            //Checking Shipment Line item
            if (serialToShipmentLineItemMap.hasOwnProperty(woliToSerialMap[woli.id])) {
                let sli = serialToShipmentLineItemMap[woliToSerialMap[woli.id]];
                woli.shipmentLineItemId = sli.Id;
                woli.destinationWarehouseId = sli.Bit2Shop__Shipment_Id__r
                                               .Bit2Shop__Stock_Order_Id__r
                                               .Bit2Shop__Destination_Warehouse_Id__c;
                woli.destinationWarehouse = sli.Bit2Shop__Shipment_Id__r
                                               .Bit2Shop__Stock_Order_Id__r
                                               .Bit2Shop__Destination_Warehouse_Id__r.Name;
                

                woli.disableSliButtons = false;
                if (sli.Bit2Shop__Status__c == 'Closed') {
                    if (sli.Bit2Shop__Received_Status__c == 'Received') {
                        woli.isAccepted = true;
                        woli.isRefused = false;
                        woli.disableFillReportButton = false;
                    } else {
                        woli.isAccepted = false;
                        woli.isRefused = true;
                        // woli.disableFillReportButton = true;
                    } 
                } else {
                    // woli.disableFillReportButton = true;
                }
            } else {
                woli.destinationWarehouse = '';
                woli.disableSliButtons = true;
                // woli.disableFillReportButton = true;
            }   

            if (!serialToOpenActivityMap.hasOwnProperty(woliToSerialMap[woli.id])) {
                if (serialToClosedActivityMap.hasOwnProperty(woliToSerialMap[woli.id])) {
                    woli.isReportFilled = true;
                } else {
                    woli.disableFillReportButton = true;
                }
            } else {
                //Checking whether received serial is 'To be verified'
                if (stockSerialsMap[woliToSerialMap[woli.id]].Bit2Shop__Status__c == 'To be verified' 
                    && woli.isAccepted == true) {
                    woli.disableFillReportButton = false;
                } else {
                    woli.disableFillReportButton = true;
                }
            }

            //Checking whether serial is withdrawn
            if (stockSerialsMap.hasOwnProperty(woliToSerialMap[woli.id])) {

                if (stockSerialsMap[woliToSerialMap[woli.id]].Bit2Shop__Status__c == 'Available') {
                    woli.isSerialAvailable = true;
                }

                if (stockSerialsMap[woliToSerialMap[woli.id]].Bit2Shop__Status__c == 'Withdrawn') {
                    woli.isSerialWithdrawn = true;
                }
            }

        } else {
            woli.disableSliButtons = true;
            woli.disableFillReportButton = true;
        }

        return woli;
    },
    /* This functions swaps the serials on the product woli if the woli is substitution */
    swapSubstitutedWoliProductsSerial: function(component, helper, woli) {

        var woliToSerialMap = component.get('v.woliToSerialMap');
        var stockSerialsMap = component.get('v.stockSerialsMap');

        if (woli.operationType == 'ToSubstitute' || woli.operationType == 'ToSubstituteCorr') {

            woli.replacedBySerial = woli.serialNumber;
            woli.replacedBySerialId = woli.serialId;
            woli.replacedByExternalCatalogItemId = woli.externalCatalogItemId;
            woli.replacedByProductSku = woli.productSku;
            woli.replacedByProductName = woli.productName;

            if (woliToSerialMap.hasOwnProperty(woli.id)) {
                woli.serialId = stockSerialsMap[woliToSerialMap[woli.id]].Id;
                woli.serialNumber = stockSerialsMap[woliToSerialMap[woli.id]].Plc_ManufacturerSerialNumber__c 
                                    || stockSerialsMap[woliToSerialMap[woli.id]].Plc_EncodedSerialNumber__c
                                    || stockSerialsMap[woliToSerialMap[woli.id]].Plc_DllSerialNumber__c;

                woli.externalCatalogItemId = stockSerialsMap[woliToSerialMap[woli.id]]
                                             .Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c;
                woli.productSku = stockSerialsMap[woliToSerialMap[woli.id]]
                                  .Plc_ProductSku__c;
                woli.productName = stockSerialsMap[woliToSerialMap[woli.id]]
                                   .Bit2Shop__Product_Stock_Id__r.Name;
            } else {
                woli.serialId = '';
                woli.serialNumber = '';
                woli.externalCatalogItemId = '';
                woli.productSku = '';
                woli.productName = '';
            }
        }
        return woli;
    },
    /* Build data showed by component */
    buildData: function(component, helper, woliProductsMap, woliAccessoriesList, serialToShipmentLineItemMap, 
                        serialToOpenActivityMap, serialToClosedActivityMap) {

        var itemsList = [];

        Object
            .keys(woliProductsMap)
            .forEach(function(key, index) {
                woliProductsMap[key].childWorkOrderLineItems = [];
            });

        woliAccessoriesList.forEach(function(woliAccessory) {
            
            woliAccessory = helper.setMaterialsButtons(component, woliAccessory, serialToShipmentLineItemMap, 
                                                       serialToOpenActivityMap, serialToClosedActivityMap);
            
            woliProductsMap[woliAccessory.parentWorkOrderLineItemId]
                .childWorkOrderLineItems.push(helper.transformAccessory(component, helper, woliAccessory));
        });  

        Object
            .keys(woliProductsMap)
            .forEach(function(key, index) {
                var woliProduct = woliProductsMap[key];

                woliProduct = helper.setMaterialsButtons(component, woliProduct, serialToShipmentLineItemMap, 
                                                         serialToOpenActivityMap, serialToClosedActivityMap);
                woliProduct = helper.swapSubstitutedWoliProductsSerial(component, helper, woliProduct);

                woliProduct.disableAddAccessory = helper.retrieveDisableAddAccessory(woliProduct.operationType);
                woliProduct.label = woliProduct.lineItemNumber;
                woliProduct.options = helper.retrieveOptionFixed(component, woliProduct.operationType);
                woliProduct.isExpanded = true;
                itemsList.push(woliProduct);
            });

        component.set('v.itemsList', itemsList);
        helper.setNoDataImageAndNumberOfItems(component, helper);
    },

    /* END
     * Drawing algorithm work order line items
     * ----------------------------------------------------------------------------------------------------------------------------------- */

     /* START
     * Managing stock orders 
     * ----------------------------------------------------------------------------------------------------------------------------------- */

    /* Function used to check whether the work order line item serial can be accepted or refused */
    precheckSliAction: function(component, helper, positions, operation) {
        var itemsList = component.get('v.itemsList');
        var woli;

        if (positions.length == 1) {
            woli = itemsList[positions[0]];
            if (woli && (!woli.isAccepted && !woli.isRefused)) {
                helper.manageShipmentLineItem(component, helper, woli, operation, positions, itemsList);
            }

        } else if (positions.length == 2) {
            woli = itemsList[positions[0]].childWorkOrderLineItems[positions[1]];

            if (woli && (!woli.isAccepted && !woli.isRefused)) {
                helper.manageShipmentLineItem(component, helper, woli, operation, positions, itemsList);
            }
        }
    },
    /* Function used to manage shipment line item */
    manageShipmentLineItem: function(component, helper, woli, operation, positions, itemsList) {
        var action = component.get("c.manageSLI");
        helper.showSpinner(component, 'main-spinner');
        action.setParams({  
            shipmentLineItemId: woli.shipmentLineItemId,
            operation: operation
        });

        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS"  && !result.error) {

                // if (operation == 'accept') {
                //     if (positions.length == 1) {
                //         itemsList[positions[0]].isAccepted = true;
                //     } else {
                //         itemsList[positions[0]].childWorkOrderLineItems[positions[1]].isAccepted = true;
                //     }
                // } else if (operation == 'refuse') {
                //     if (positions.length == 1) {
                //         itemsList[positions[0]].isRefused = true;
                //     } else {
                //         itemsList[positions[0]].childWorkOrderLineItems[positions[1]].isRefused = true;
                //     }
                // }
                // 
                // component.set('v.itemsList', itemsList);
                //
                
                helper.hideSpinner(component, 'main-spinner');

                helper.retrievePropertiesMap(component, helper);
                
                helper.showToast('', $A.get('$Label.c.Plc_AllAllRecordUpdatedGeneric').replace('{0}', 
                                     component.get('v.translationMap.ShipmentLineItem')), 'success');

            } else if (component.isValid() && (response.getState() === "ERROR" || result.error)){
                if (result) {
                    helper.showToast('', result.errorMsg, 'warning', 'sticky');
                    console.error(result.errorMsg);
                }
                helper.hideSpinner(component, 'main-spinner');
            }
            
        });
        $A.enqueueAction(action);
    },
     /* END
     * Managing stock orders 
     * ----------------------------------------------------------------------------------------------------------------------------------- */

    /* START
     * Managing activity compile report
     * ----------------------------------------------------------------------------------------------------------------------------------- */

    openActivityReport: function(component, helper, positions) {

        var itemsList = component.get('v.itemsList');
        var woliToSerialMap = component.get('v.woliToSerialMap');
        var woli;

        if (positions.length == 1) {
            woli = itemsList[positions[0]];

        } else if (positions.length == 2) {
            woli = itemsList[positions[0]].childWorkOrderLineItems[positions[1]];
        }

        if (!woli.isReportFilled) {
            component.set('v.serialIdToVerify', woliToSerialMap[woli.id])
            var activityCompileReport = component.find("fill-report");
            activityCompileReport.initComponent();
        }
    },
    /* END
     * Managing activity compile report
     * ----------------------------------------------------------------------------------------------------------------------------------- */

    /* START
     * Managing contact selection
     * ----------------------------------------------------------------------------------------------------------------------------------- */

    preCheckSelectUserAction: function(component, helper, positions) {
        var itemsList = component.get('v.itemsList');
        var woliToSerialMap = component.get('v.woliToSerialMap');
        var stockSerialsMap = component.get('v.stockSerialsMap');

        var woli;

        if (positions.length == 1) {
            woli = itemsList[positions[0]];

        } else if (positions.length == 2) {
            woli = itemsList[positions[0]].childWorkOrderLineItems[positions[1]];
        }

        if (!woli.isSerialWithdrawn && woliToSerialMap.hasOwnProperty(woli.id)) {

            //Getting technician who has installed the 'replaced by' Serial i order to
            //compile already the name of the techician
            if (woli.replacedBySerialId && (woli.operationType == 'ToSubstitute' || woli.operationType == 'ToSubstituteCorr')) {

                var action = component.get('c.retrieveWithdrawingTechnician');

                action.setParams({  
                    stockSerialId: woli.replacedBySerialId,
                });

                action.setCallback(this, function(response) {
                    var result = response.getReturnValue();
                    var state = response.getState();

                    if (component.isValid() && state === "SUCCESS"  && !result.error) {

                        //Setting technician if existing
                        if (result.ContactId) {
                            component.set('v.selectedContact', {Id : result.ContactId, Name: result.ContactName})
                        }

                    } else if (component.isValid() && (response.getState() === "ERROR" || result.error)){
                        if (result) {
                            console.error(result.errorMsg);
                        }
                    }
                    helper.hideSpinner(component, 'main-spinner');
                });

                $A.enqueueAction(action);
            }

            helper.openModal(component, helper, 'modal-select-contact');
            component.set('v.propertiesMap.serialForWithdrawing', stockSerialsMap[woliToSerialMap[woli.id]]);
        }
    },

    updateSerialToWithdrawn: function(component, helper, positions) {
        var action = component.get('c.changeSerialToWithdrawn');
        var itemsList = component.get('v.itemsList');

        helper.showSpinner(component, 'main-spinner');

        action.setParams({  
            stockSerialId: component.get('v.propertiesMap.serialForWithdrawing').Id,
            contactId: component.get('v.selectedContact').Id
        });

        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS"  && !result.error) {

                if (positions.length == 1) {
                    itemsList[positions[0]].isSerialWithdrawn = true;
                } else {
                    itemsList[positions[0]].childWorkOrderLineItems[positions[1]].isSerialWithdrawn = true;
                }

                component.set('v.itemsList', itemsList);
                helper.showToast('', $A.get('$Label.c.Plc_AllAllRecordUpdatedGeneric').replace('{0}', 
                                     component.get('v.translationMap.SerialStock')), 'success');

            } else if (component.isValid() && (response.getState() === "ERROR" || result.error)){
                if (result) {
                    helper.showToast('', result.errorMsg, 'warning', 'sticky');
                    console.error(result.errorMsg);
                }
            }
            helper.hideSpinner(component, 'main-spinner');
        });
        $A.enqueueAction(action);

    }
    /* END
     * Managing contact selection
     * ----------------------------------------------------------------------------------------------------------------------------------- */
})