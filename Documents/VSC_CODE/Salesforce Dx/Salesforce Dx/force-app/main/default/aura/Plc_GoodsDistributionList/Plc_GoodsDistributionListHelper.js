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
    redirectToObject: function(objectId) {
        var navEvt = $A.get('e.force:navigateToSObject');
        navEvt.setParams({
          'recordId': objectId,
          'slideDevName': 'detail',
        });
        navEvt.fire();
    },
    /*
     * This function will be called when use clicks on next button and performs the 
     * calculation to show the next set of records
     */
    next: function(component, event, helper) {
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        //update utility pagination attributes shifting them
        start = start + pageSize;
        end = end + pageSize;
        component.set("v.startPage", start);
        component.set("v.endPage", end);
    },
    /* 
     * This function will be called when use clicks on previous button and performs the 
     * calculation to show the previous set of records
     */
    previous: function(component, event, helper) {
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        //update utility pagination attributes shifting them
        start = start - pageSize;
        end = end - pageSize;
        component.set("v.startPage", start);
        component.set("v.endPage", end);
    },
    /* Function used to reset pagination indexes */
    resetPaginationIndexes: function(component) {
        var pageSize = component.get("v.pageSize");
        component.set("v.startPage", 0);
        component.set("v.endPage", pageSize - 1);
    },
    /* Gets from server a map that contains pairs api name/label. Used in order to get translations */
    retrieveTranslationMap: function(component, helper) {
        var action = component.get('c.retrieveTranslationMap');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === 'SUCCESS') {
                var result = response.getReturnValue();
                //setting translations
                component.set('v.translationMap.Bit2Shop__Product_Stock__c', result.Bit2Shop__Product_Stock__c);
                component.set('v.translationMap.ProductStockName', result.ProductStockName);
                component.set('v.translationMap.Plc_ProductSku__c', result.Plc_ProductSku__c);
                component.set('v.translationMap.Plc_Manufacturer__c', result.Plc_Manufacturer__c);
                component.set('v.translationMap.Plc_AvailableQty__c', result.Plc_AvailableQty__c);
                component.set('v.translationMap.Plc_OrderedQty__c', result.Plc_OrderedQty__c);
                component.set('v.translationMap.B2WExtCat__External_Catalog_Item__c', result.B2WExtCat__External_Catalog_Item__c);
                component.set('v.translationMap.Plc_MinimumStock__c', result.Plc_MinimumStock__c);
                component.set('v.translationMap.Bit2Shop__Dealer__c', result.Bit2Shop__Dealer__c);
                component.set('v.translationMap.Bit2Shop__Warehouse__c', result.Bit2Shop__Warehouse__c);
                component.set('v.translationMap.Plc_Solution__c', result.Plc_Solution__c);
                component.set('v.translationMap.Plc_WarehouseSolution__c', result.Plc_WarehouseSolution__c);
                component.set('v.translationMap.Plc_ReorderStock__c', result.Plc_ReorderStock__c);
                component.set('v.translationMap.Plc_SecurityStock__c', result.Plc_SecurityStock__c);
                component.set('v.translationMap.Plc_DistributionList__c', result.Plc_DistributionList__c);
                component.set('v.translationMap.Plc_Note__c', result.Plc_Note__c);
            }
        });
        $A.enqueueAction(action);
    },
    /* Gets from server a map of config and context data */
    retrievePropertiesMap: function(component, event, helper, isAfterUpsert, 
                                     isDistributionListUpdated, isAfterNewCensus,
                                     isAfterOwnerChange) {
        var action = component.get("c.retrievePropertiesMap");
        helper.showSpinner(component, 'main-spinner');

        action.setCallback(this, function(response) {

            var result = response.getReturnValue();
            var state = response.getState();

            if (component.isValid() && state === "SUCCESS"  && !result.error) {
                var result = response.getReturnValue();

                var dealersMap = result.dealersMap;
                var warehousesMap = result.warehousesMap;
                var whSolutionsMap = result.whSolutionsMap;
                var productsMap = JSON.parse(result.productsMap);

                component.set('v.distributionsListId', result.distributionsListId);
                component.set('v.propertiesMap.isUserOwner', result.isUserOwner);
                helper.resetPaginationIndexes(component);

                if (result.distributionListName) {
                    component.set('v.propertiesMap.title', result.distributionListName);
                } else {
                    component.set('v.propertiesMap.title', $A.get('$Label.c.Plc_LightningComponentGoodsDistributionListCreateNew'));
                }

                helper.buildData(component, event, dealersMap, warehousesMap, whSolutionsMap, productsMap,
                                 result.modelSkuToAvailableNewQty, result.modelSkuWarehouseToAvailableRepairedQty);

                if (isAfterUpsert) {
                    if (isDistributionListUpdated) {
                        helper.showToast('', $A.get('$Label.c.Plc_LightningComponentGoodsDistributionListUpdateCreation'), 'success');
                    } else {
                        helper.showToast('', $A.get('$Label.c.Plc_LightningComponentGoodsDistributionListUpdateCreation'), 'success');
                    }
                } else if(isAfterNewCensus) {
                     helper.showToast('', $A.get('$Label.c.Plc_LightningComponentGoodsDistributionListProductCreation'), 'success');                
                } else if(isAfterOwnerChange) {
                     helper.showToast('', $A.get('$Label.c.Plc_LightningComponentGoodsDistributionListOwnershipChangeMessage'), 'success');
              
                } else {

                    if (result.distributionsListId) {
                        if (result.isUserOwner) {
                            helper.showToast('', $A.get('$Label.c.Plc_LightningComponentGoodsDistributionListFoundDraftMessage'), 'info');
                        } else {
                            component.set('v.propertiesMap.ownerName', result.ownerName);
                            helper.openModal(component, helper, 'modal-owner');
                        }
                    }
                }
                
            }  else if (component.isValid() && (response.getState() === "ERROR" || result.error)){
                if (result) {
                    helper.showToast($A.get('$Label.c.Plc_AllAllError'), result.errorMsg, 'error', 'sticky');
                    console.error(result.errorMsg);
                }
            }
            helper.hideSpinner(component, 'main-spinner');
        });
        $A.enqueueAction(action);
    },
    /* Saves distribution list */
    saveDistributionList: function(component, helper, exitWizard) {

        var action = component.get("c.saveDistributionList");
        var itemsList = component.get('v.itemsListAllToFilter');
        var hasErrors = false;

        helper.showSpinner(component, 'main-spinner');

        var productsToHandle = [];
        itemsList
            .forEach(function(dealer) {
                if (hasErrors) {
                    return;
                }
                dealer.warehouses
                    .forEach(function(warehouse) {
                        if (hasErrors) {
                            return;
                        }
                        warehouse.whSolutions
                            .forEach(function(whSolution) {
                                if (hasErrors) {
                                    return;
                                }
                                whSolution.products
                                    .forEach(function(product) {
                                        if (component.get('v.distributionsListId') 
                                            || product.newItems != 0 
                                            || product.repairedItems != 0) {
                                            var areRepairedRequestValid = true;
                                            if (product.whRepairedItems) {
                                            product.whRepairedItems
                                                .forEach(function(item) {
                                                    if (item.requestedQty < 0 ||
                                                        item.requestedQty > item.availableQty) {
                                                        areRepairedRequestValid = false;
                                                        return;
                                                    }
                                                });
                                            }

                                            let minimumStock = (product.PlcMinimumStock == null ? 0 : 
                                                                product.PlcMinimumStock);
                                            if ((product.newItems != 0 &&
                                                product.newItems < minimumStock) || 
                                                product.newItems > product.remainingQty ||
                                                areRepairedRequestValid == false) {
                                                    hasErrors = true;
                                                    return;
                                            } else {
                                                productsToHandle.push(product);
                                            }
                                        }
                                    });
                            });
                    });
            });

        if (hasErrors) {
            helper.hideSpinner(component, 'main-spinner');
            helper.showToast('', $A.get('$Label.c.Plc_LightningComponentGoodsDistributionListWrongDataErrorMessage') + '. ' +
                                 $A.get('$Label.c.Plc_AllAllCheckRequest') , 'warning');
            return;
        }

        if (productsToHandle.length == 0) {
            helper.hideSpinner(component, 'main-spinner');
            helper.showToast('', $A.get('$Label.c.Plc_LightningComponentGoodsDistributionListMissingQuantitiesErrorMessage') + '. ' +
                                 $A.get('$Label.c.Plc_AllAllCheckRequest') , 'warning');
            return;
        }

        var modelSkuToAvailableNewQty = component.get('v.modelSkuToAvailableNewQty');
        var modelSkuWarehouseToAvailableRepairedQty = component.get('v.modelSkuWarehouseToAvailableRepairedQty');

        Object
            .keys(modelSkuToAvailableNewQty)
            .forEach(function(key, index) {
                if (modelSkuToAvailableNewQty[key].requested > modelSkuToAvailableNewQty[key].available) {
                    helper.showToast('', $A.get('$Label.c.Plc_LightningComponentGoodsDistributionListNewItemsQuantityErrorMessage')
                                         .replace('{0}', '"' + key + '"')
                                         .replace('{1}', modelSkuToAvailableNewQty[key].requested)
                                         .replace('{2}', modelSkuToAvailableNewQty[key].available),
                                     'warning', 'sticky');

                    hasErrors = true;
                    return;
                }
            });

        Object
            .keys(modelSkuWarehouseToAvailableRepairedQty)
            .forEach(function(key, index) {
                if (modelSkuWarehouseToAvailableRepairedQty[key].requested > modelSkuWarehouseToAvailableRepairedQty[key].available) {
                    helper.showToast('', $A.get('$Label.c.Plc_LightningComponentGoodsDistributionListNewItemsQuantityErrorMessage')
                                         .replace('{0}', '"' + modelSkuWarehouseToAvailableRepairedQty[key].sku + '"')
                                         .replace('{1}', modelSkuWarehouseToAvailableRepairedQty[key].warehouse)
                                         .replace('{2}', modelSkuWarehouseToAvailableRepairedQty[key].requested)
                                         .replace('{3}', modelSkuWarehouseToAvailableRepairedQty[key].available),
                                     'warning', 'sticky');

                    hasErrors = true;
                    return;
                }
            });

        if (hasErrors) {
            helper.hideSpinner(component, 'main-spinner');
            return;
        }

        action.setParams({  
            productSolutionAsString: JSON.stringify(productsToHandle),
            distributionsListId: component.get('v.distributionsListId')
        });

        action.setCallback(this, function(response) {

            var result = response.getReturnValue();
            var state = response.getState();

            if (component.isValid() && state === "SUCCESS"  && !result.error) {
                var result = response.getReturnValue();
                helper.retrievePropertiesMap(component, event, helper, true, 
                                             component.get('v.distributionsListId'));
                if (exitWizard) {
                    helper.redirectToObject(result.distributionsListId);
                }
                
            }  else if (component.isValid() && (response.getState() === "ERROR" || result.error)) {

                if (result) {
                    helper.showToast($A.get('$Label.c.Plc_AllAllError'), result.errorMsg, 'warning', 'sticky');
                    console.error(result.errorMsg);
                    helper.hideSpinner(component, 'main-spinner');
                }
            }
        });
        $A.enqueueAction(action);
    },
    /* Saves distribution list */
    changeOwner: function(component, helper) {
        var action = component.get("c.changeDistributionListOwner");

        action.setParams({  
            distributionsListId: component.get('v.distributionsListId')
        });

        action.setCallback(this, function(response) {

            var result = response.getReturnValue();
            var state = response.getState();

            if (component.isValid() && state === "SUCCESS"  && !result.error) {
                var result = response.getReturnValue();
                helper.retrievePropertiesMap(component, event, helper, false, 
                                             component.get('v.distributionsListId'), false,
                                             true);

            }  else if (component.isValid() && (response.getState() === "ERROR" || result.error)) {

                if (result) {
                    helper.showToast($A.get('$Label.c.Plc_AllAllError'), result.errorMsg, 'warning', 'sticky');
                    console.error(result.errorMsg);
                    helper.hideSpinner(component, 'main-spinner');
                }
            }
        });
        $A.enqueueAction(action);
    },
    /* Fiters the showed dealers according to search name */
    dealerFilter: function(component, helper, nameToSearch) {

        try {
            var itemsList = component.get('v.itemsList');
            var itemsListAllToFilter = component.get('v.itemsListAllToFilter');

            itemsList = itemsListAllToFilter
                .filter(function(dealer) {
                    return dealer.Name.toLowerCase().includes(nameToSearch) || nameToSearch == '';
                });

            component.set('v.itemsList', itemsList);
            helper.resetPaginationIndexes(component);
        } catch (e) {
            console.log('Error while creating lightning:input');
        }
    },
    /* Fiters the showed warehouses according to search name */
    warehouseFilter: function(component, helper, nameToSearch) {
        var itemsList = component.get('v.itemsList');
        //Filter each dealer warehouse according to search key
        itemsList
            .forEach(function(dealer) {
                dealer.warehouses
                    .map(function(warehouse) {
                        if (warehouse.Name.toLowerCase().includes(nameToSearch)) {
                            warehouse.isVisible = true;
                        } else {
                            warehouse.isVisible = false;
                        }
                        return warehouse;
                    });
            });

        component.set('v.itemsList', itemsList);
        var sectionsToExpand = component.get('v.whSolutionIds').concat(component.get('v.warehouseIds').concat(component.get('v.dealerIds')));
        component.set('v.activeSections', sectionsToExpand);
    },
    /* Fiters the showed warehouses solutions according to search name */
    whSolutionFilter: function(component, helper, nameToSearch) {
        var itemsList = component.get('v.itemsList');
        //Getting for each item the list of warehouses. Then filter solutions according to search key
        itemsList
            .forEach(function(dealer) {
                dealer.warehouses
                    .forEach(function(warehouse) {
                        warehouse.whSolutions
                            .map(function(whSolution) {
                                //if (whSolution.Name.toLowerCase().includes(nameToSearch)) {
                                if ( (whSolution.Plc_Warehouse__r.Name + ' - ' + whSolution.Plc_Solution__r.Name ).toLowerCase().includes(nameToSearch)) {
                                    whSolution.isVisible = true;
                                } else {
                                    whSolution.isVisible = false;
                                }
                                return whSolution;
                            });
                    });
            });

        component.set('v.itemsList', itemsList);
        var sectionsToExpand = component.get('v.whSolutionIds').concat(component.get('v.warehouseIds').concat(component.get('v.dealerIds')));
        component.set('v.activeSections', sectionsToExpand);
    },
    /* Fiters the showed products according to search name */
    productFilter: function(component, helper, nameToSearch) {
        var itemsList = component.get('v.itemsList');
        var whSolutionToExpand = [];
        //getting for each item the list of warehouses, solutions. Then filter products according to search key
        //The filter matches the name, the manufacturer name and the product Sku identifier
        itemsList
            .forEach(function(dealer) {
                dealer.warehouses
                    .forEach(function(warehouse) {
                        warehouse.whSolutions
                            .forEach(function(whSolution) {
                                console.log(whSolution.products);
                                whSolution.products
                                    .map(function(product) {
                                        console.log(product)
                                        let sku = product.PlcProductSku ? 
                                                  product.PlcProductSku : '';
                                        if (product.Name.toLowerCase().includes(nameToSearch) ||
                                            sku.toLowerCase().includes(nameToSearch)) {
                                            product.isVisible = true;
                                            whSolutionToExpand.push(product.warehouseSolutionId);
                                        } else {
                                            product.isVisible = false;
                                        }
                                        return product;
                                    });
                            });
                    });
            });

        component.set('v.itemsList', itemsList);
        var sectionsToExpand = whSolutionToExpand.concat(component.get('v.warehouseIds').concat(component.get('v.dealerIds')));
        component.set('v.activeSections', sectionsToExpand);
    },
    /* Updates the reorder value in the given positions */
    setReorderValue: function(component, positions, changedValue) {
        var itemsList = component.get('v.itemsList');

        if (changedValue) {

            var sumOfValues = 0;
            var products = itemsList[positions[0]]
                           .warehouses[positions[1]]
                           .whSolutions[positions[2]]
                           .products;

            products
                .forEach(function(item) {
                    
                    sumOfValues = sumOfValues + parseInt(item.newItems == '' ? 0 : item.newItems) + 
                                                parseInt(item.repairedItems == '' ? 0 : item.repairedItems);
                });

            itemsList[positions[0]]
            .warehouses[positions[1]]
            .whSolutions[positions[2]].reorderValue = parseInt(itemsList[positions[0]]
                                                               .warehouses[positions[1]]
                                                               .whSolutions[positions[2]]
                                                               .Plc_ReorderStock__c) + sumOfValues;
            try {
                component.set('v.itemsList', itemsList);
            } catch(e) {
                console.error(e);
            }
        }
    },
    /* Shows the section for new product census */
    showNewProductSection: function(component, helper, positions) {
        var itemsList = component.get('v.itemsList');

        itemsList[positions[0]]
        .warehouses[positions[1]]
        .whSolutions[positions[2]].isNewProductSectionVisible = !itemsList[positions[0]]
                                                                .warehouses[positions[1]]
                                                                .whSolutions[positions[2]].isNewProductSectionVisible == true;
        try {
            component.set('v.itemsList', itemsList);

            if (itemsList[positions[0]]
                .warehouses[positions[1]]
                .whSolutions[positions[2]].isNewProductSectionVisible){

                helper.getAvailableModels(component, helper, 
                    itemsList[positions[0]]
                    .warehouses[positions[1]]
                    .whSolutions[positions[2]].Id,
                    positions);
            }
            
        } catch(e) {
            console.error(e);
        }
    },
    /* Retrieve current available product for selected solution */
    getAvailableModels: function(component, helper, whSolutionId, positions) {
        var action = component.get("c.retrieveAvailableModels");
        var itemsList = component.get('v.itemsList');

        action.setParams({  
            whSolutionId: whSolutionId
        });

        action.setCallback(this, function(response) {

            var result = response.getReturnValue();
            var state = response.getState();

            if (component.isValid() && state === "SUCCESS"  && !result.error) {
                var result = response.getReturnValue();
                itemsList[positions[0]]
                .warehouses[positions[1]]
                .whSolutions[positions[2]].availableModels = result.availableModels.map(function(item) {
                    item.value = item.Id;
                    item.label = item.B2WExtCat__External_Catalog_Item_Name__c;
                    return item;
                });

                component.set('v.itemsList', itemsList);

            }  else if (component.isValid() && (response.getState() === "ERROR" || result.error)) {

                if (result) {
                    helper.showToast($A.get('$Label.c.Plc_AllAllError'), result.errorMsg, 'warning', 'sticky');
                    console.error(result.errorMsg);
                    helper.hideSpinner(component, 'main-spinner');
                }
            }
        });

        $A.enqueueAction(action);
    },
    /* Retrieve current available product for selected solution */
    censusNewProductStock: function(component, helper, positions) {
        var action = component.get("c.createNewProductStock");
        var itemsList = component.get('v.itemsList');
        var whSolution = itemsList[positions[0]]
                        .warehouses[positions[1]]
                        .whSolutions[positions[2]];

        action.setParams({  
            modelId: whSolution.selectedAvailableModel,
            warehouseId: whSolution.Plc_Warehouse__c,
            dealerId: whSolution.Plc_Warehouse__r.Bit2Shop__Dealer_Id__c
        });

        action.setCallback(this, function(response) {

            var result = response.getReturnValue();
            var state = response.getState();

            if (component.isValid() && state === "SUCCESS"  && !result.error) {
                
                helper.retrievePropertiesMap(component, event, helper, false, 
                                             component.get('v.distributionsListId'), true);

            }  else if (component.isValid() && (response.getState() === "ERROR" || result.error)) {

                if (result) {
                    helper.showToast($A.get('$Label.c.Plc_AllAllError'), result.errorMsg, 'warning', 'sticky');
                    console.error(result.errorMsg);
                    helper.hideSpinner(component, 'main-spinner');
                }
            }
        });

        $A.enqueueAction(action);
    },
    /* Shows the area with the repaired items quantity */
    showRepairedItemsArea: function(component, helper, positions) { 
        var itemsList = component.get('v.itemsList');

        itemsList[positions[0]]
        .warehouses[positions[1]]
        .whSolutions[positions[2]]
        .products[positions[3]].isRepairedSectionVisible = !itemsList[positions[0]]
                                                            .warehouses[positions[1]]
                                                            .whSolutions[positions[2]]
                                                            .products[positions[3]]
                                                            .isRepairedSectionVisible;
        try {
            component.set('v.itemsList', itemsList);
        } catch(e) {
            console.error(e);
        }
    },
    /* Updates the new quantity count */
    updateNewQuantities: function(component, helper, positions, changedValue) {
        var itemsList = component.get('v.itemsList');
        var modelSkuToAvailableNewQty = component.get('v.modelSkuToAvailableNewQty');
        var modelSkuToOldRequestedNewQty = component.get('v.modelSkuToOldRequestedNewQty');

        var product = itemsList[positions[0]]
                        .warehouses[positions[1]]
                        .whSolutions[positions[2]]
                        .products[positions[3]];
        var key = product.Bit2ShopWarehouseId + product.PlcProductSku;
        var sku = product.PlcProductSku;

        try {
            if (changedValue) {
                if (modelSkuToAvailableNewQty.hasOwnProperty(sku)) {
                    if (modelSkuToOldRequestedNewQty.hasOwnProperty(key)) {
                        modelSkuToAvailableNewQty[sku].requested = modelSkuToAvailableNewQty[sku].requested - 
                                                                   parseInt(modelSkuToOldRequestedNewQty[key]) + parseInt(changedValue);
                    } else {
                        modelSkuToAvailableNewQty[sku].requested = modelSkuToAvailableNewQty[sku].requested + parseInt(changedValue);
                    }
                } 
                modelSkuToOldRequestedNewQty[key] = parseInt(changedValue);
                component.set('v.modelSkuToAvailableNewQty', modelSkuToAvailableNewQty);
                component.set('v.modelSkuToOldRequestedNewQty', modelSkuToOldRequestedNewQty);
            } 
        } catch (e) {
            console.err(e);
        }

        helper.setReorderValue(component, positions, changedValue);
    },
    /* Updates the main repaired quantity count according to children items */
    updateRepairedQuantities: function(component, helper, positions, changedValue) {
        var itemsList = component.get('v.itemsList');
        var modelSkuWarehouseToAvailableRepairedQty = component.get('v.modelSkuWarehouseToAvailableRepairedQty');
        var modelSkuWarehouseToOldRequestedRepairedQty = component.get('v.modelSkuWarehouseToOldRequestedRepairedQty');

        var product = itemsList[positions[0]]
                        .warehouses[positions[1]]
                        .whSolutions[positions[2]]
                        .products[positions[3]];

        var whRepairedRequest = itemsList[positions[0]]
                                .warehouses[positions[1]]
                                .whSolutions[positions[2]]
                                .products[positions[3]]
                                .whRepairedItems[positions[4]];

        var key = whRepairedRequest.id + product.Bit2ShopWarehouseId + 
                  product.PlcProductSku;
        var originWarehouseSku = whRepairedRequest.id + 
                                 product.PlcProductSku;

        try {
            if (changedValue) {

                if (modelSkuWarehouseToAvailableRepairedQty.hasOwnProperty(originWarehouseSku)) {
                    if (modelSkuWarehouseToOldRequestedRepairedQty.hasOwnProperty(key)) {
                        modelSkuWarehouseToAvailableRepairedQty[originWarehouseSku].requested = modelSkuWarehouseToAvailableRepairedQty[originWarehouseSku].requested - 
                                                                   parseInt(modelSkuWarehouseToOldRequestedRepairedQty[key]) + parseInt(changedValue);
                    } else {
                        modelSkuWarehouseToAvailableRepairedQty[originWarehouseSku].requested = modelSkuWarehouseToAvailableRepairedQty[originWarehouseSku].requested + parseInt(changedValue);
                    }
                } 

                modelSkuWarehouseToOldRequestedRepairedQty[key] = parseInt(changedValue);
                
                var sumOfValues = 0;
                var repairedItems = itemsList[positions[0]]
                                    .warehouses[positions[1]]
                                    .whSolutions[positions[2]]
                                    .products[positions[3]]
                                    .whRepairedItems;

                repairedItems
                    .forEach(function(item) {
                        sumOfValues = sumOfValues + parseInt(item.requestedQty == '' 
                                                             ? 0 : item.requestedQty);
                    });

                itemsList[positions[0]]
                    .warehouses[positions[1]]
                    .whSolutions[positions[2]]
                    .products[positions[3]].repairedItems = sumOfValues;

                component.set('v.itemsList', itemsList);
                component.set('v.modelSkuWarehouseToAvailableRepairedQty', modelSkuWarehouseToAvailableRepairedQty);
                component.set('v.modelSkuWarehouseToOldRequestedRepairedQty', modelSkuWarehouseToOldRequestedRepairedQty);
                helper.setReorderValue(component, positions, changedValue);
            }
        } catch (e) {
            console.error(e);
        }
    },
    /* Used to show note popover of repaired*/
    showNoteRepairedPopover: function(component, helper, positions) {
        var itemsList = component.get('v.itemsList');
        
        itemsList[positions[0]]
        .warehouses[positions[1]]
        .whSolutions[positions[2]]
        .products[positions[3]]
        .whRepairedItems[positions[4]].isPopupVisible = !itemsList[positions[0]]
                                                        .warehouses[positions[1]]
                                                        .whSolutions[positions[2]]
                                                        .products[positions[3]]
                                                        .whRepairedItems[positions[4]].isPopupVisible;

        itemsList[positions[0]]
        .warehouses[positions[1]]
        .whSolutions[positions[2]]
        .products[positions[3]]
        .whRepairedItems.map(function(item, index) {

                if (index != positions[4]) {
                    item.isPopupVisible = false;
                }
                return item;
            });

        try {
            component.set('v.itemsList', itemsList);
        } catch(e) {
            console.error(e)
        }

    },
    /* Used to show note popover of new*/
    showNoteNewPopover: function(component, helper, positions) {
        var itemsList = component.get('v.itemsList');
        
        itemsList[positions[0]]
        .warehouses[positions[1]]
        .whSolutions[positions[2]]
        .products[positions[3]].isPopupVisible = !itemsList[positions[0]]
                                                    .warehouses[positions[1]]
                                                    .whSolutions[positions[2]]
                                                    .products[positions[3]].isPopupVisible;

        itemsList[positions[0]]
        .warehouses[positions[1]]
        .whSolutions[positions[2]]
        .products.map(function(item, index) {
            if (index != positions[3]) {
                item.isPopupVisible = false;
            }
            return item;
        });

        try {
            component.set('v.itemsList', itemsList);
        } catch(e) {
            console.error(e)
        }

    },
    /* Used during initialization for merging together all retrieved structures */
    buildData: function(component, helper, dealers, 
                        warehouses, whSolutions, products,
                        modelSkuToAvailableNewQty,
                        modelSkuWarehouseToAvailableRepairedQty) {

        //The ids of the items will be gathered in order to have the keys 
        //for the accordion collapse/expand functionalities
        var dealerIds = [];
        var warehouseIds = [];
        var whSolutionIds = [];

        var modelSkuToOldRequestedNewQty = {};
        var modelSkuWarehouseToOldRequestedRepairedQty = {};

        Object
            .keys(modelSkuToAvailableNewQty)
            .forEach(function(key, index) {
                modelSkuToAvailableNewQty[key] = {
                    available: modelSkuToAvailableNewQty[key],
                    requested: 0
                };
            });

        Object
            .keys(modelSkuWarehouseToAvailableRepairedQty)
            .forEach(function(key, index) {
                modelSkuWarehouseToAvailableRepairedQty[key] = {
                    available: modelSkuWarehouseToAvailableRepairedQty[key],
                    requested: 0
                };
            });

        Object
            .keys(dealers)
            .forEach(function(key, index) {
                dealers[key].warehouses = [];
            });

        Object
            .keys(warehouses)
            .forEach(function(key, index) {
              warehouses[key].whSolutions = [];
            });
        
        Object
            .keys(whSolutions)
            .forEach(function(key, index) {
              whSolutions[key].products = [];
              whSolutions[key].reorderValue = whSolutions[key].Plc_ReorderStock__c; 
            });

        Object
            .keys(products)
            .forEach(function(key, index) {
                var product = products[key];
                if (product.warehouseSolutionId) {
                    product.isVisible = true;
                    product.isRepairedSectionVisible = false;
                    whSolutions[product.warehouseSolutionId].products.push(product);
                    whSolutions[product.warehouseSolutionId].reorderValue += parseInt(product.newItems) + 
                                                                             parseInt(product.repairedItems);

                    //Setting requested quantities for new items in the map that matches overall new items
                    if (product.newItems > 0) {
                        modelSkuToAvailableNewQty[product.PlcProductSku].requested += product.newItems;
                        modelSkuToOldRequestedNewQty[product.Bit2ShopWarehouseId + product.PlcProductSku] = product.newItems;
                    }

                    //Setting requested quantities for repaired items in the map that matches overall repaired items
                    if (product.whRepairedItems) {
                        product.whRepairedItems.
                            forEach(function(whRepairedRequest, index) {
                                var originWarehouseSku = whRepairedRequest.id + 
                                    product.PlcProductSku;

                                if (whRepairedRequest.requestedQty > 0) {
                                    modelSkuWarehouseToAvailableRepairedQty[originWarehouseSku].requested += whRepairedRequest.requestedQty;
                                    modelSkuWarehouseToOldRequestedRepairedQty[whRepairedRequest.id + 
                                        product.Bit2ShopWarehouseId + 
                                        product.PlcProductSku] = whRepairedRequest.requestedQty;
                                }

                                if (modelSkuWarehouseToAvailableRepairedQty.hasOwnProperty(originWarehouseSku)) {
                                    modelSkuWarehouseToAvailableRepairedQty[originWarehouseSku].sku = product.PlcProductSku;
                                    modelSkuWarehouseToAvailableRepairedQty[originWarehouseSku].warehouse = whRepairedRequest.name;
                                }
                            });
                    }
                }
          });

        Object
            .keys(whSolutions)
            .forEach(function(key, index) {
                var whSolution = whSolutions[key];
                whSolution.isVisible = true;
                whSolutionIds.push(whSolution.Id);
                if (whSolution.Plc_Warehouse__c) {
                    warehouses[whSolution.Plc_Warehouse__c].whSolutions.push(whSolution);
                }
            });

        Object
            .keys(warehouses)
            .forEach(function(key, index) {
                var warehouse = warehouses[key];
                warehouse.isVisible = true;
                warehouseIds.push(warehouse.Id);
                if (warehouse.Bit2Shop__Dealer_Id__c) {
                    dealers[warehouse.Bit2Shop__Dealer_Id__c].warehouses.push(warehouse);
                }
            });

        var dealersList = [];

        Object
            .keys(dealers)
            .forEach(function(key, index) {
                var dealer = dealers[key];
                dealer.isVisible = true;
                dealerIds.push(dealer.Id)
                dealersList.push(dealer);
            });

        if (dealersList.length == 0) {
            component.set('v.propertiesMap.showEmptyDealersIllustration', true);
        }

        component.set('v.dealerIds', dealerIds)
        component.set('v.warehouseIds', warehouseIds);
        component.set('v.whSolutionIds', whSolutionIds);
        component.set('v.itemsList', dealersList);
        component.set('v.itemsListAllToFilter', dealersList);
        //Stuctures used to check if the overall sums of item is ok
        component.set('v.modelSkuToAvailableNewQty', modelSkuToAvailableNewQty);
        component.set('v.modelSkuToOldRequestedNewQty', modelSkuToOldRequestedNewQty);
        component.set('v.modelSkuWarehouseToAvailableRepairedQty', modelSkuWarehouseToAvailableRepairedQty);
        component.set('v.modelSkuWarehouseToOldRequestedRepairedQty', modelSkuWarehouseToOldRequestedRepairedQty);
    }
})