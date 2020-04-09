({  

    /** // Added by FB on 29th March, 2019
     * 
     * Gets from server a map that contains pairs api name/label. Used in order to get translations 
     *
     */
    retrieveTranslationsMap: function(component, helper) {
        var action = component.get('c.retrieveTranslationsMap');

        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (component.isValid() && state === 'SUCCESS') {
                var result = response.getReturnValue();
                //Setting translations
                component.set('v.translationsMap.Plc_WarehouseProvince__c', result.Plc_WarehouseProvince__c);
                component.set('v.translationsMap.Bit2Shop__Warehouse__c', result.Bit2Shop__Warehouse__c);
                component.set('v.translationsMap.WarehouseName', result.WarehouseName);
                component.set('v.translationsMap.Plc_Alias__c', result.Plc_Alias__c);
            }
        });
        $A.enqueueAction(action);
    },
    /**
     * function called to initialize the province and initialized the list of warehouses.
     * refreshWareHouseList
     */
	initWareHouses : function(component, key) {
        var actionGetAllWarehouse = component.get('c.findWareHouses');
        actionGetAllWarehouse.setParams({'key': key});
        actionGetAllWarehouse.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var data = response.getReturnValue();
                if(data.error == 'false'){
                	var warehouses = JSON.parse(data.warehouses);
                    component.set("v.warehouses", warehouses);
                    //this.handleRefreshWarehouses(component);
                    this.initLeftTable(component);
                    this.initRightTable(component);
           	    } else {
            		console.log('error'); 
                }
            }
        });
        $A.enqueueAction(actionGetAllWarehouse);
	},

	initLeftTable : function(component){
        component.set('v.tableLeftColumns', [
            {
                label: $A.get('$Label.c.Plc_AllAllAction'), type: 'button',
                initialWidth: 75, typeAttributes: {
                    label: {fieldName: 'actionLabel'},
                    title: 'Select Warehouse',
                    name: 'assWarehouseToProvince',
                    iconName: 'action:approval',
                    disabled: {fieldName: 'actionDisabled'},
                    class: 'btn_next',
                    size: "XX-small"
                }
            },
            {label: component.get('v.translationsMap.Plc_Alias__c'), fieldName: 'Plc_Alias__c', type: 'text',
                initialWidth: 175, typeAttributes: { class: 'plc_alias'}
            },
            {label: component.get('v.translationsMap.WarehouseName'), fieldName: 'Name',
                type: 'text', typeAttributes: { class: 'plc_warehouse'}
            }
        ]);
    },

    initRightTable : function(component){
        component.set('v.tableRightColumns', [
            {
                label: $A.get('$Label.c.Plc_AllAllAction'), type: 'button', initialWidth: 75, typeAttributes: {
                    label: {fieldName: 'actionLabel'},
                    title: 'Remove Warehouse',
                    name: 'remWarehouseToProvince',
                    iconName: 'action:close',
                    disabled: {fieldName: 'actionDisabled'},
                    class: 'btn_next bt_add',
                    size: "XX-small"
                }
            },
            {label: component.get('v.translationsMap.Plc_Alias__c'), fieldName: 'Plc_ExternalWarehouse__c',
                type: 'text', initialWidth: 175, typeAttributes: { class: 'plc_alias'}
            },
            {label: component.get('v.translationsMap.WarehouseName'), fieldName: 'Plc_ViewName__c',
                type: 'text', typeAttributes: { class: 'plc_warehouse'}
            },
            {label: '%', initialWidth: 90, fieldName: 'Plc_DistributionPercentage__c', type: 'number', editable:'true',
                typeAttributes: {
                    required: true,
                    default: 0,
                    class: 'plc_percent'
                }
            }

        ]);
    },

    /**
     * refresh the list of warehouses when a province is selected
     */
    handleRefreshWarehouses : function(component) {
        component.set('v.warehousesToSelect', []);
        var select = document.getElementById('province');
        var province = select.options[select.selectedIndex].value;
        component.set('v.province', province);
        if(province){
            var warehouseProvinces = component.get('v.warehouseProvinces');
            var warehousesSelected = component.get('v.warehousesSelected');
            var action = component.get('c.findWarehouseProvincesByProvince');
            action.setParam('province', province);
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var data = response.getReturnValue();
                    if(data.error == 'false'){
                        var warehouseProvinces = JSON.parse(data.warehouseProvinces);

                        var warehousesSelected = this.getWarehousesFromWarehouseProvinces(component, warehouseProvinces, 'warehouseSelected');
                        Promise.resolve(component.set('v.warehousesSelected', warehousesSelected)).then(() => this.handleSumPercentage(component, event));

                        var warehouses = new Set(component.get("v.warehouses"));
                        warehouses.forEach(function(item){
                            warehousesSelected.forEach(function(warehouseSelected){
                                if (item.Id == warehouseSelected.Id) {
                                    warehouses.delete(item);
                                }
                            });
                        });
                        component.set("v.warehouses", Array.from(warehouses));
                        component.set("v.warehouseProvinces", this.wrapperWarehouseProvinces(warehouseProvinces));
                        component.set("v.warehousesToSelect", Array.from(warehouses));
                    }
                }
            });
            $A.enqueueAction(action);
        } else {
            component.set("v.warehousesToSelect", []);
            component.set("v.warehouseProvinces", []);
        }
    },

    handleFilterWareHouse : function(component){
        var data = component.get("v.warehouses");
        var dataTemp;
        var key = component.get('v.searchKey');

        //key = key.replace(/[^a-zA-Z0-9]/g, '');
        var regex;
        if ($A.util.isEmpty(key)) {
            component.set("v.warehousesToSelect", data);
        } else {
            //key = key.trim();
            //key = "^" + key;
            try {
                    regex = new RegExp(key, "i");
                    // filter checks each row, constructs new array where function returns true
                    /*

                    data = data.filter(row => regex.test(row.Name)
                                            || regex.test(row.Plc_Alias__c)
                                            || regex.test(row.Bit2Shop__State_Province__c)
                                            || regex.test(row.Bit2Shop__Dealer_Id__r.Bit2Shop__State_Province__c)
                                      );
                                      */
                    dataTemp = data.filter(function(row) {

                        if (row.Name) {
                            return row.Name.toLowerCase().includes(key.toLowerCase());
                        } 
                        if (row.Plc_Alias__c) {
                            return row.Plc_Alias__c.toLowerCase().includes(key.toLowerCase());
                        }
                        if (row.Bit2Shop__State_Province__c) {
                            return row.Bit2Shop__State_Province__c.toLowerCase().includes(key.toLowerCase());
                        }
                        if (row.Bit2Shop__Dealer_Id__r.Bit2Shop__State_Province__c) {
                            return row.Bit2Shop__Dealer_Id__r.Bit2Shop__State_Province__c.toLowerCase().includes(key.toLowerCase());
                        }

                        return false;
                        });

            } catch (e) {
                console.error(e);
            }
           	component.set("v.warehousesToSelect", dataTemp);
        }
    },
    
    handleSelectWarehouse : function(component, event){
        //var index = event.target.id;
        //var action = event.getParam('action');
        var warehouse = event.getParam('row');
        var warehousesToSelect = component.get('v.warehousesToSelect');
        var index = warehousesToSelect.indexOf(warehouse);
		//var warehouse = warehousesToSelect[index];
        this.handleWarehouseAssignedToProvince(component, warehouse);
        Promise.resolve( Promise.resolve(delete warehousesToSelect[index]).then(() => (warehousesToSelect = this.filterArray(warehousesToSelect) )))
                .then(() => component.set('v.warehousesToSelect', warehousesToSelect));
        var warehouses = new Set(component.get("v.warehouses"));
        warehouses.forEach(function(item){
            if (item.Id == warehouse.Id) {
                warehouses.delete(warehouse);
            }
        });
        component.set("v.warehouses", Array.from(warehouses));
    },

    handleRemoveWarehouseAssignedToProvince : function(component, event){
        var warehouseProvinces = component.get('v.warehouseProvinces');
        var warehouseProvinceToRemove = event.getParam('row');
        var warehouseSelected = component.get('v.warehouseSelected');
        warehouseSelected = warehouseProvinceToRemove.Plc_Warehouse__r;

        Promise.resolve(warehouseProvinces = warehouseProvinces.filter(item => item.Plc_Warehouse__c != warehouseProvinceToRemove.Plc_Warehouse__c))
                .then(() => component.set('v.warehouseProvinces', this.wrapperWarehouseProvinces(warehouseProvinces)));

        var warehousesToSelect = component.get('v.warehousesToSelect');
        Promise.resolve(warehousesToSelect.push(warehouseSelected)).then(() => component.set('v.warehousesToSelect', warehousesToSelect));
        component.set('v.warehouseSelected', {'sobjectType': 'Bit2Shop__Warehouse__c',
                                              'Name': '',
                                              'Plc_Alias__c': '',
                                              'Id': '',
                                              'Bit2Shop__State_Province__c': ''
                                              });

        var warehouses = new Set(component.get("v.warehouses"));
        warehouses.add(warehouseSelected);
        component.set("v.warehouses", Array.from(warehouses));
    },

    handleSumPercentage : function(component, event){
        try {
            if (!event) {
                this.calculateSumPercentage(component);
                return;
            }
            var draftValues = event.getParam('draftValues');
            var index = draftValues[0].wPId.split('-')[1];
            var warehouseProvinces = component.get('v.warehouseProvinces');
            warehouseProvinces[index].Plc_DistributionPercentage__c = draftValues[0].Plc_DistributionPercentage__c;
            warehouseProvinces = this.wrapperWarehouseProvinces(warehouseProvinces);
            component.set('v.warehouseProvinces', warehouseProvinces);
            var errors = this.validateWarehouseProvinces(warehouseProvinces);
            if(errors.rows != null){
                component.set('v.errors', errors);
                component.set('v.sumPercent', 0);
            } else {
                this.calculateSumPercentage(component);
                component.set('v.errors', []);
            }
        } catch(error){
            console.log('error', error);
            var warehouseProvinces = component.get('v.warehouseProvinces');
            var errors = this.validateWarehouseProvinces(warehouseProvinces);
            if(errors.rows != null){
                component.set('v.errors', errors);
                component.set('v.sumPercent', 0);
            } else {
                this.calculateSumPercentage(component);
                component.set('v.errors', []);
            }

        }
    },

    showToast : function(message, type){
    	var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
        	message: message,
            type : type
        });
        toastEvent.fire();
	},

	handleSave : function(component){

        var plcWarehouseProvinces = component.get('v.warehouseProvinces');
        plcWarehouseProvinces.forEach(function(plcWarehouseProvince, index){
            plcWarehouseProvince.Plc_ExternalWarehouse__c = '';
            plcWarehouseProvince.Plc_ViewName__c = '';
            plcWarehouseProvinces[index] = plcWarehouseProvince;
        });

        var action = component.get('c.saveWarehouses');
        action.setParams({ 'jsonWareHouseProvinces': JSON.stringify(plcWarehouseProvinces) });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var resultMap = response.getReturnValue();
                if(resultMap['error'] == 'false'){
                    this.showToast(resultMap['message'], 'SUCCESS');
                    component.find("wToProvince").set("v.draftValues", []);
                    this.handleRefreshWarehouses(component);
                } else {
                    this.showToast(resultMap['message'], 'ERROR');
                }
            } else if(state === 'ERROR') {
                var errors = response.getError();
                this.showToast(errors[0].message, 'ERROR');
            } else {
                this.showToast('the operation has failed', 'ERROR');
            }
        });
        $A.enqueueAction(action);
    },
    
    /**
     * This function assign warehouse to a province
     */
    handleWarehouseAssignedToProvince : function(component, warehouse){
        var select = document.getElementById('province');
        var province = select.options[select.selectedIndex].value;
    	var warehouseProvinces = component.get('v.warehouseProvinces');
    	var plcWarehouseProvince = component.get('v.warehouseProvince');
        plcWarehouseProvince.Plc_Warehouse__r = warehouse;
        plcWarehouseProvince.Plc_Warehouse__c = warehouse.Id;
        plcWarehouseProvince.Plc_Province__c = province;
        plcWarehouseProvince.Plc_DistributionPercentage__c = 0;
        Promise.resolve(warehouseProvinces.push(plcWarehouseProvince)).then(() => component.set('v.warehouseProvinces', this.wrapperWarehouseProvinces(warehouseProvinces)));
        component.set('v.warehouseProvince', {'sobjectType': 'Plc_WarehouseProvince__c',
                                                           'Plc_Province__c': '',
                                                           'Plc_Warehouse__c': '',
                                                           'Plc_DistributionPercentage__c': '' });
	},
    
    getWarehousesFromWarehouseProvinces : function(component, warehouseProvinces, nameAttribute){
        var warehousesSelected = [];
        warehouseProvinces.forEach(function(warehouseProvince){
            var warehouseSelected = component.get('v.'+nameAttribute);
            warehouseSelected = warehouseProvince.Plc_Warehouse__r;
            warehouseSelected.Id = warehouseProvince.Plc_Warehouse__c;
            warehousesSelected.push(warehouseSelected);
            component.set('v.'+nameAttribute, {'sobjectType': 'Bit2Shop__Warehouse__c',
                                               'Name': '',
                                               'Plc_Alias__c': '',
                                               'Id': '',
                                               'Bit2Shop__State_Province__c': ''
                                                                                     });
        });
        
        return warehousesSelected;
    },

    filterArray: function(array){
        array = array.filter(item => item != null);
        return array;
    },

    calculateSumPercentage: function(component){
        var sumPercent = new Number(0);
        var percent = new Number(0);

        var warehouseProvinces = component.get('v.warehouseProvinces');
        if(warehouseProvinces.length == 0){
            component.set('v.sumPercent', 0);
        } else {
            warehouseProvinces.forEach(function(warehouseProvince, index){
                percent = parseInt(warehouseProvince.Plc_DistributionPercentage__c);
                sumPercent += percent;
                percent = 0;
            });
            component.set('v.sumPercent', sumPercent);
        }
    },

    wrapperWarehouseProvinces : function(warehouseProvinces){
        warehouseProvinces.map(function(warehouseProvince){
            warehouseProvince.Plc_ExternalWarehouse__c = warehouseProvince.Plc_Warehouse__r.Plc_Alias__c;
            if(warehouseProvince.Plc_Warehouse__r.Bit2Shop__Dealer_Id__r.Bit2Shop__State_Province__c
                && warehouseProvince.Plc_Warehouse__r.Bit2Shop__State_Province__c){
                warehouseProvince.Plc_ViewName__c = warehouseProvince.Plc_Warehouse__r.Name +' - '+ warehouseProvince.Plc_Warehouse__r.Bit2Shop__State_Province__c;
            }else if(warehouseProvince.Plc_Warehouse__r.Bit2Shop__Dealer_Id__r.Bit2Shop__State_Province__c){
                warehouseProvince.Plc_ViewName__c = warehouseProvince.Plc_Warehouse__r.Name +' - '+ warehouseProvince.Plc_Warehouse__r.Bit2Shop__Dealer_Id__r.Bit2Shop__State_Province__c;
            } else if(warehouseProvince.Plc_Warehouse__r.Bit2Shop__State_Province__c){
                warehouseProvince.Plc_ViewName__c =warehouseProvince.Plc_Warehouse__r.Name +' - '+ warehouseProvince.Plc_Warehouse__r.Bit2Shop__State_Province__c;
            } else {
                warehouseProvince.Plc_ViewName__c =warehouseProvince.Plc_Warehouse__r.Name;
            }
        });

        return warehouseProvinces;
    },

    validateWarehouseProvinces: function (warehouseProvinces) {
        var totalErrors = 0;
        var errors = {};// new Map<String, Object>();
        var rowsError = {}// new Map<String, Object>();

        warehouseProvinces.forEach(function (warehouseProvince, index) {
            var rowErrorMessages = [];
            var rowErrorFieldNames = [];

            var percent = parseFloat(warehouseProvince.Plc_DistributionPercentage__c);
            //isNaN(percent) ||
            if(!Number.isInteger(percent)){
                rowErrorMessages.push($A.get('$Label.c.Plc_AllAllTheValueMustBeAnInteger'));
                rowErrorFieldNames.push('Plc_DistributionPercentage__c');
            }
            if(percent < 1 || percent > 100){
                rowErrorMessages.push($A.get('$Label.c.Plc_AllAllValueMustBeBetweenRange').replace('{0}', 1).replace('{1}', 100));
                rowErrorFieldNames.push('Plc_DistributionPercentage__c');
            }
            if (rowErrorMessages.length > 0) {
                totalErrors += rowErrorMessages.length;
                //warehouseProvince.wPId
                rowsError['row-'+index] = {
                    messages: rowErrorMessages,
                    fieldNames: rowErrorFieldNames,
                    title : warehouseProvince.Plc_ViewName__c + ' ' + $A.get('$Label.c.Plc_AllAllHasNErrors').replace('{0}',rowErrorMessages.length)
                };
            }
        });

        if (totalErrors > 0) {
            var tableMessages = [];// new List<String>();
            var rowErrorValues = Object.values(rowsError);
            rowErrorValues.forEach(function (rowError) {
                tableMessages.push(rowError.title);
            });

            errors = {
                /**
                 * Information to be displayed on each row that has an edition with an error.
                 * This is an object in the form:
                 * {
                 *      'row-id': {
                 *          // displayed in the help text of the icon in the row with id "row-id" indicating that the edition has error(s)
                 *          title: 'Error title',
                 *          // an array of messages
                 *          messages: [],
                 *          // an array of field names to which message corresponds
                 *          fieldNames: [],
                 *      }
                 * }
                 */
                rows: rowsError,
                table: { // displayed at the end of the table
                    title : $A.get('$Label.c.Plc_AllAllSomeRecordsHaveErrors'), // the title of the popover
                    messages : tableMessages // A list of messages to be displayed as the popover content
                }
            }
        }
        return errors;
    }
})