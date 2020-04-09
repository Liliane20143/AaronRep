({
    /* Showing spinner function */
    showSpinner: function(component, spinnerName) {
        $A.util.removeClass(component.find(spinnerName), 'slds-hide');
    },
    /* Hiding loading spinner function */
    hideSpinner: function(component, spinnerName) {
        $A.util.addClass(component.find(spinnerName), 'slds-hide');
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
    /* Showing warning area function */
    showWarningArea: function(component) {
        component.set('v.propertiesMap.showWarningArea', true);
    },
    /* Hiding warning area function */
    hideWarningArea: function(component) {
        component.set('v.propertiesMap.showWarningArea', false);
    },
    /* Shows a custom message defined by parameters */
    showToast: function(title, message, type, mode) {
        /* show toast message
         * mode
         * sticky: it stays on screen until user action
         * dismissable: it disappears after some time automatically
         */
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
    /* Redirects to a given id object page*/
    redirectToObject: function(recordId){
        var navEvt = $A.get('e.force:navigateToSObject');
        navEvt.setParams({
          'recordId': recordId,
          'slideDevName': 'detail',
        });
        navEvt.fire();
    },
    /* Function that check whether children custom lookup are filled in (for required fields)*/
    validateData: function(component, helper) {
        
        var isDataValid;
        var formData = component.find('serial-form');
        
        if(!Array.isArray(formData)){
            isDataValid = formData.checkValidity();
        } else{
            isDataValid = formData.reduce(function (validSoFar, inputCmp) {
            return inputCmp.checkValidity() && validSoFar;
            }, true); 
        }

        return isDataValid;       
    },
    /* Function used to understand whether a Product Stock exists in the given warehouse for given model */
    checkProductStockExistance: function(component, helper) {
        var selectedWarehouse = component.get('v.selectedWarehouse');
        var selectedModel = component.get('v.selectedModel');
        
        if (selectedModel.Id && selectedWarehouse.Id) {
            var action = component.get('c.retrieveAvailableProductStock');

            action.setParams({  
                warehouseId: selectedWarehouse.Id,
                modelId: selectedModel.Id
            });

            action.setCallback(this, function(response) {
                var state = response.getState();
                if (component.isValid() && state === 'SUCCESS') {
                    var result = response.getReturnValue();
                    if (result.productStockList.length > 0) {
                        helper.hideWarningArea(component);
                    } else {
                        helper.showWarningArea(component);
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },
    /* Gets from server a map that contains pairs api name/label. Used in order to get translations */
    retrieveTranslationMap: function(component, helper) {
        var action = component.get('c.retrieveTranslationMap');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === 'SUCCESS') {
                var result = response.getReturnValue();
                //Setting translation 
                component.set('v.translationMap.Bit2Shop__Stock_Serials2__c', result.Bit2Shop__Stock_Serials2__c);
                component.set('v.translationMap.Bit2Shop__Warehouse_Id__c', result.Bit2Shop__Warehouse_Id__c);
                component.set('v.translationMap.Bit2Shop__Status__c', result.Bit2Shop__Status__c);
                component.set('v.translationMap.Plc_Status2__c', result.Plc_Status2__c);
                component.set('v.translationMap.B2WExtCat__External_Catalog_Item__c', result.B2WExtCat__External_Catalog_Item__c);
                component.set('v.translationMap.Bit2Shop__Product_Stock__c', result.Bit2Shop__Product_Stock__c);
            }
        });
        $A.enqueueAction(action);
    },
    /* Gets from server a map of config and context data */
    retrievePropertiesMap: function(component, helper) {
        var action = component.get('c.retrievePropertiesMap');
        helper.showSpinner(component, 'main-spinner');
        
        action.setParams({  
            stockSerialId: component.get('v.recordId')
        });

        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState();
            if (component.isValid() && state === 'SUCCESS'  && !result.error) {
                var result = response.getReturnValue();

                component.set('v.propertiesMap.stockSerial', result.stockSerial);
                component.set('v.propertiesMap.showInputWarehouse', result.showInputWarehouse);
                
                if (result.currentWarehouse) {
                    component.set('v.selectedWarehouse', result.currentWarehouse);
                }
                if (result.currentModel) {
                    component.set('v.selectedModel', result.currentModel);
                }
                component.set('v.selectedStatus', result.stockSerial.Bit2Shop__Status__c);
                component.set('v.selectedStatus2', result.stockSerial.Plc_Status2__c);

                helper.setAvailableOptions(component, helper, 
                                           result.statusAvailableOptionsMap,
                                           result.status2AvailableOptionsMap);

            }  else if (component.isValid() && 
                       (response.getState() === 'ERROR' || result.error)){
                if(result) {
                    console.error(result.errorMsg);
                }
            }
            helper.hideSpinner(component, 'main-spinner');
        });
        $A.enqueueAction(action);
    }, 
    /* Sets available options for Stock Serial 2 picklists */
    setAvailableOptions: function(component, helper, 
                                  statusAvailableOptionsMap, 
                                  status2AvailableOptionsMap) {
        var statusOptions = [];
        var status2Options = [];

        Object
            .keys(statusAvailableOptionsMap)
            .forEach(function(key) {
                let newStatusOption = {};
                newStatusOption.value = key;
                newStatusOption.label = statusAvailableOptionsMap[key];
                statusOptions.push(newStatusOption);
            });

        Object
            .keys(status2AvailableOptionsMap)
            .forEach(function(key) {
                let newStatus2Option = {};
                newStatus2Option.value = key;
                newStatus2Option.label = status2AvailableOptionsMap[key];
                status2Options.push(newStatus2Option);
            });

        component.set('v.propertiesMap.statusOptions', statusOptions);
        component.set('v.propertiesMap.status2Options', status2Options);
    },
    /* Function used to save stock serial */
    updateStockSerial: function(component, helper) {
        //If data is not correct then abort saving
        if (!helper.validateData(component, helper)) {
            return;
        }

        var action = component.get('c.updateStockSerial');
        helper.showSpinner(component, 'main-spinner');

        action.setParams({  
            stockSerial: component.get('v.propertiesMap.stockSerial'),
            newWarehouseId: component.get('v.selectedWarehouse.Id'),
            newModelId: component.get('v.selectedModel.Id'),
            newModelName: component.get('v.selectedModel.B2WExtCat__External_Catalog_Item_Name__c'),
            newStatus: component.get('v.selectedStatus'),
            newStatus2: component.get('v.selectedStatus2')
        });

        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState();

            if (component.isValid() && state === 'SUCCESS'  && !result.error) {
                var result = response.getReturnValue();

                //$A.get('e.force:refreshView').fire();
                helper.redirectToObject(component.get('v.recordId'));
                helper.showToast('', $A.get('$Label.c.Plc_LightningComponentStockSerialUpdateUpdatedSerialSuccessMessage'), 'success');

            }  else if (component.isValid() && 
                        (response.getState() === 'ERROR' || result.error)){
                if(result) {
                    console.error(result.errorMsg);
                    helper.showToast('', $A.get('$Label.c.Plc_AllAllError') + ': ' + result.errorMsg, 'warning', 'sticky');
                }
            }

            helper.hideSpinner(component, 'main-spinner');
            // $A.get("e.force:closeQuickAction").fire();
            helper.redirectToObject(component.get('v.recordId'));
        });
        $A.enqueueAction(action);
    }
})