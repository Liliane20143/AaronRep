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
	closeModal: function(component, modalName){ 
		var cmpTarget = component.find(modalName);
		var cmpBack = component.find('Modalbackdrop');
		$A.util.removeClass(cmpBack,'slds-backdrop--open');
		$A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
	},
	/* Hide modal function*/
	openModal: function(component, modalName) {
		var cmpTarget = component.find(modalName);
		var cmpBack = component.find('Modalbackdrop');
		$A.util.addClass(cmpTarget, 'slds-fade-in-open');
		$A.util.addClass(cmpBack, 'slds-backdrop--open'); 
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
	/* Redirects to a given id object page*/
	redirectToRecord: function(recordId) {

		window.open('/' + recordId, '_blank');

		/*
		var navEvt = $A.get('e.force:navigateToSObject');
		navEvt.setParams({
			'recordId': recordId,
			'slideDevName': 'detail',
		});
		navEvt.fire();
		*/
	},
	/* Gets from server a map that contains pairs api name/label. Used in order to get translations */
    retrieveTranslationsMap: function(component, helper) {
		var action = component.get('c.retrieveTranslationMap');
		helper.showSpinner(component, 'main-spinner');
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
				component.set('v.translationMap.WorkOrderLineItems', result.WorkOrderLineItems);
                component.set('v.translationMap.Status', result.Status);
                component.set('v.translationMap.Plc_SerialNumber__c', result.Plc_SerialNumber__c);
                component.set('v.translationMap.Quantity', result.Quantity);
				component.set('v.translationMap.Plc_ReplacedBy__c', result.Plc_ReplacedBy__c);
				component.set('v.translationMap.WorkOrder', result.WorkOrder);

				component.set('v.translationMap.Plc_Alias__c', result.Plc_Alias__c);
				component.set('v.translationMap.Plc_ServicePoint__c', result.Plc_ServicePoint__c);
				component.set('v.translationMap.Plc_LegacyServicePointId__c', result.Plc_LegacyServicePointId__c);
				component.set('v.translationMap.Plc_LegacyAccountId__c', result.Plc_LegacyAccountId__c);
				component.set('v.translationMap.Plc_FiscalCode__c', result.Plc_FiscalCode__c);
				component.set('v.translationMap.Plc_Vat__c', result.Plc_Vat__c);
				component.set('v.translationMap.Plc_SiaCode__c', result.Plc_SiaCode__c);
				component.set('v.translationMap.Street', result.Street);
				component.set('v.translationMap.City', result.City);
				component.set('v.translationMap.Zip', result.Zip);
				component.set('v.translationMap.State', result.State);
				component.set('v.translationMap.Country', result.Country);

                component.set('v.translationMap.Plc_TermId__c', result.Plc_TermId__c);
                component.set('v.translationMap.Plc_TermIdCode__c', result.Plc_TermIdCode__c);
                component.set('v.translationMap.Asset', result.Asset);
                component.set('v.translationMap.AssetName', result.AssetName);
                component.set('v.translationMap.ShipmentLineItem', result.ShipmentLineItem);
                component.set('v.translationMap.Contact', result.Contact);
                component.set('v.translationMap.ContactName', result.ContactName);
				component.set('v.translationMap.Bit2Shop__Destination_Warehouse_Id__c', result.Bit2Shop__Destination_Warehouse_Id__c);
				
				helper.hideSpinner(component, 'main-spinner');
            }
        });
        $A.enqueueAction(action);
    },

	/* [START]
     * Table column definitions
     * ----------------------------------------------------------------------------------------------------------------------------------- */

    /*Defines the columns (for serial stock items) showed in the component */
    getColumnDefinitionsSerialStock: function(component) {

		var woTipology = component.get('v.woTipology');

        var columns = [
            { label: component.get('v.translationMap.Plc_Model__c'), fieldName: 'Plc_Model__c', type: 'text', sortable: true },
            { label: component.get('v.translationMap.Plc_ProductSku__c'), fieldName: 'Plc_ProductSku__c', type:'text', sortable: true },
            { label: component.get('v.translationMap.Plc_ManufacturerSerialNumber__c'), fieldName: 'Plc_ManufacturerSerialNumber__c', type:'text', sortable: true },
            { label: component.get('v.translationMap.Plc_EncodedSerialNumber__c'), fieldName: 'Plc_EncodedSerialNumber__c', type: 'text', sortable: true },
            { label: component.get('v.translationMap.Plc_DllSerialNumber__c'), fieldName: 'Plc_DllSerialNumber__c', type: 'text', sortable: true },
            { label: component.get('v.translationMap.Plc_Manufacturer__c'), fieldName: 'Plc_Manufacturer__c', type: 'text', sortable: true },
			{ label: component.get('v.translationMap.Plc_Solution__c'), fieldName: 'Plc_Solution__c', type: 'text', sortable: true }
		];
		
		if (woTipology !== 'Installation') {
			columns.push({ label: component.get('v.translationMap.Plc_TermIdCode__c'), fieldName: 'Plc_TermId__c', type: 'text', sortable: true });
		} else {
			columns.push({ label: component.get('v.translationMap.Status'), fieldName: 'Bit2Shop__Status__c', type: 'text', sortable: true });
		}

        return columns;
	},
	
	/* [END]
     * Table column definitions
     * ----------------------------------------------------------------------------------------------------------------------------------- */

	/* Used to get available operations on wolis */
	retrieveEligibleOperations: function(component, helper) {

		var action = component.get("c.retrieveEligibleOperations");
		helper.showSpinner(component, 'main-spinner');

		action.setParams({  
			woTipology: component.get('v.woTipology')
		});

		action.setCallback(this, function(response) {

			var result = response.getReturnValue();
			var state = response.getState();

			if (component.isValid() && state === "SUCCESS"  && !result.error) {
				
				component.set('v.availableOperationTypesMap', result.availableOperationTypesMap)

			}  else if (component.isValid() && (response.getState() === "ERROR" || result.error)){
				if (result) {
					helper.showToast($A.get('$Label.c.Plc_AllAllError'), result.errorMsg, 'warning', 'sticky');
					console.error(result.errorMsg);
				}
			}
			helper.hideSpinner(component, 'main-spinner');
		});
		$A.enqueueAction(action);   
	},

	/* Gets from server a map of config and context data */
	retrievePropertiesMap: function(component, helper) {

		var action = component.get("c.retrievePropertiesMap");
		helper.showSpinner(component, 'main-spinner');

		action.setParams({  
			configMap: helper.createConfig()
		});

		action.setCallback(this, function(response) {

			var result = response.getReturnValue();
			var state = response.getState();

			if (component.isValid() && state === "SUCCESS"  && !result.error) {
				
			}  else if (component.isValid() && (response.getState() === "ERROR" || result.error)){
				if (result) {
					helper.showToast($A.get('$Label.c.Plc_AllAllError'), result.errorMsg, 'warning', 'sticky');
					console.error(result.errorMsg);
				}
			}
			helper.hideSpinner(component, 'main-spinner');
		});
		$A.enqueueAction(action);    
	},

	/* Gets available models shown in the table of items */
    retrieveAvailableSerials: function(component, helper) {
        helper.showSpinner(component, 'table-spinner');

		var warehouseAlias;
		var statusList;

		var modalTitle = $A.get('$Label.c.Plc_AllAllSelect') + ' ' + component.get('v.translationMap.Bit2Shop__Stock_Serials2__c') + ' • ';
		if (component.get('v.woTipology') === 'Installation') {
			warehouseAlias = component.get('v.selectedWarehouse').Plc_Alias__c;
			statusList = ['Withdrawn', 'Available', 'To Be Verified'];
			component.set('v.propertiesMap.modalSerialsLabel', modalTitle + component.get('v.selectedWarehouse').Name);
		} else {
			warehouseAlias = '999010NEXI';
			statusList = ['Installed'];
			component.set('v.propertiesMap.modalSerialsLabel', modalTitle + 'NEXI (Installati)');
		}

        var action = component.get("c.retrieveAvailableSerials");

        var params = {  
            warehouseAlias: warehouseAlias,
			searchKey: component.get('v.propertiesMap.searchKey'),
			searchLimit: component.get('v.propertiesMap.searchLimit'),
			consumedSerials: helper.collectConsumedSerials(component, helper),
			statusList: statusList,
			termId: component.get('v.selectedTermId').Id
		}
		
        action.setParams(params);

        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState();

            if (component.isValid() && state === "SUCCESS"  && !result.error) {
                helper.setAvailableSerials(component, helper, result.availableStockSerialsList, result.availableProductStocksList);
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
    setAvailableSerials: function(component, helper, availableStockSerialsList) {

        availableStockSerialsList
            .map(function(item) {
                if (item.Bit2Shop__Product_Stock_Id__c) {
                    item.Plc_Solution__c = item
                                           .Bit2Shop__Product_Stock_Id__r
                                           .Plc_Solution__c;
				}
				
				if (item.Plc_TermId__c) {
					item.Plc_TermId__c = item.Plc_TermId__r.Plc_TermIdCode__c;
				}

                return item;
            });

		component.set('v.availableStockSerialsList', availableStockSerialsList);
	},
	/* Function used to collect consumed serials */
	collectConsumedSerials: function(component, helper) {
		var itemsList = component.get('v.itemsList');
		var consumedSerials = [];

		itemsList.forEach(function(item) {
			consumedSerials.push(item.serialId);
		});

		return consumedSerials;
	},

	/* Function used to create the work order with the line items */
	createWorkOrder: function(component, helper) {
		var itemsList = component.get('v.itemsList');
		var hasErrors = false;
		var tipology = component.get('v.woTipology');
		var serialIdList = [];
		//checking whether the termId are indicated

		itemsList.forEach(function(item) {

			if (tipology === 'Installation' && !item.existingTermId.Id && !item.newTermIdCode) {
				helper.showToast('', $A.get('$Label.c.Plc_LightningComponentCreateMockWorkOrderSaveErrorMissingTermId'), 'warning');
				hasErrors = true;
			}
		});

		if (hasErrors) {
			return;
		}

		/* Splitting the single object to two different fields */
		itemsList.map(function(item) {
			serialIdList.push(item.serialId);
			item.existingTermIdCode = item.existingTermId.Plc_TermIdCode__c;
			item.existingTermIdId = item.existingTermId.Id;
			return item;
		});

		var action = component.get("c.createWorkOrder");
		helper.showSpinner(component, 'main-spinner');

		action.setParams({
			workOrderWrp: component.get('v.workOrderToCreate'),
			selectedWarehouse: component.get('v.selectedWarehouse'),
			tipology: tipology,
			woliAsString: JSON.stringify(itemsList),
			serialIdList: serialIdList
		});

		action.setCallback(this, function(response) {

			var result = response.getReturnValue();
			var state = response.getState();

			if (component.isValid() && state === "SUCCESS"  && !result.error) {
				$A.get('e.force:refreshView').fire();
				helper.showToast('', $A.get('$Label.c.Plc_AllAllWorkOrderCreated'), 'success');
				//Navigation to created Work Order
				var navEvt = $A.get('e.force:navigateToSObject');
				navEvt.setParams({
					'recordId': result.workOrderId,
					'slideDevName': 'detail',
				});
				navEvt.fire();

			} else if (component.isValid() && (response.getState() === "ERROR" || result.error)){
				if (result) {
					helper.showToast($A.get('$Label.c.Plc_AllAllError'), result.errorMsg, 'warning', 'sticky');
					console.error(result.errorMsg);
				}
			}
			helper.hideSpinner(component, 'main-spinner');
		});

		$A.enqueueAction(action);    
	},

	/* [START]
     * Managing the line items
     * ----------------------------------------------------------------------------------------------------------------------------------- */
	
	/* Used to diable or not the save button */
	setSaveButton: function(component, helper) {
		var itemsList = component.get('v.itemsList');
		var disableSave = false;

		if (itemsList.length == 0) {
			disableSave = true;
		} else {
			if (component.get('v.woTipology') === 'Installation') {
				itemsList
				.forEach(function(woli) {
					if (!woli.existingTermId.Id && !woli.newTermIdCode) {
						disableSave = true;
					}
				});
			}
			
		}
        component.set('v.propertiesMap.disableSave', disableSave);
	},
	/* Retrieves available options to show for line items */
    retrieveAvailableOptions: function(component) {

        var options = [];
        var availableOperationTypesMap = component.get('v.availableOperationTypesMap');

        Object
            .keys(availableOperationTypesMap)
            .forEach(function(key) {
				if (key !== 'NoOperation') {
					options.push({
						label: availableOperationTypesMap[key],
						value: key
					});
				}
            });

        return options;
    },

	/* Function used to draw selected serials */
	addItems: function(component, helper) {
		var selectedStockSerialsList = component.get('v.selectedStockSerialsList');
		var itemsList = component.get('v.itemsList');
		var woTipology = component.get('v.woTipology');

		selectedStockSerialsList.forEach(function(stockSerial) {
			itemsList.push(helper.createLineItemFromSerials(component, helper, stockSerial, woTipology));
		});

		component.set('v.itemsList', itemsList);
	},
	/* Function used to create line item from serial */
	createLineItemFromSerials: function(component, helper, stockSerial, type) {
		let woli = {};

		woli.serialId = stockSerial.Id;
		woli.serialStatus = stockSerial.Bit2Shop__Status__c;
		woli.productStockId = stockSerial.Bit2Shop__Product_Stock_Id__c;
		woli.serialNumber = stockSerial.Plc_ManufacturerSerialNumber__c
							|| stockSerial.Plc_EncodedSerialNumber__c 
							|| stockSerial.Plc_DllSerialNumber__c;
		woli.externalCatalogItemId = stockSerial
								     .Bit2Shop__Product_Stock_Id__r
								     .Bit2Shop__External_Catalog_Item_Id__c;
		woli.productSku = stockSerial
						  .Bit2Shop__Product_Stock_Id__r
					      .Plc_ProductSku__c;
		woli.productName = stockSerial
						  .Bit2Shop__Product_Stock_Id__r
						  .Bit2Shop__External_Catalog_Item_Id__r
						  .B2WExtCat__External_Catalog_Item_Name__c;

		woli.options = helper.retrieveAvailableOptions(component);
		if (woli.options.length > 0) {
			woli.operationType = woli.options[0].value;
		}

		//existingTermId is an object
		if (type === 'Installation') {
			woli.existingTermId = {Id: ''};
			woli.newTermIdCode = '';
			woli.disableExistingTermId = false;
			woli.disableNewTermId = false;
		} else {
			woli.existingTermId = {};
			if (stockSerial.Plc_TermId__c) {
				woli.existingTermId.Id = stockSerial.Plc_TermId__r.Id;
				woli.existingTermId.Plc_TermIdCode__c = stockSerial.Plc_TermId__r.Plc_TermIdCode__c
			}
			woli.newTermIdCode = stockSerial.Plc_TermId__c;
			woli.disableExistingTermId = true;
			woli.disableNewTermId = true;
		}

		return woli;
	},
	/* Function used to remove line items */
	removeItem: function(component, helper, positions) {
		var itemsList = component.get('v.itemsList');
		itemsList.splice(positions[0], 1);
		//WA In order to
        component.set('v.itemsList', itemsList);
	},

	/* [END]
     * Managing the line items
     * ----------------------------------------------------------------------------------------------------------------------------------- */
	
})