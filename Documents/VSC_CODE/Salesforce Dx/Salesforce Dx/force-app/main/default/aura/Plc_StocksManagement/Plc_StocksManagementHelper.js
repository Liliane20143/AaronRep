/**
 * Created by liverani on 29/01/2019.
 */
({
    initialize: function (component) {
        console.log(`initialize --> start`);

        component.set('v.warehouseId', component.get('v.objectId'));

        component.set('v.firstTableColumns', [
            {
                label: '',
                type: 'button',
                initialWidth: 10,
                typeAttributes: {
                    label: {fieldName: 'removeButton'},
                    title: '',
                    name: 'removeButton',
                    iconName: 'utility:undo',
                    disabled: {fieldName: 'removeButtonDisabled'},
                    class: 'btn_remove'
                }
            },
            {label: $A.get('$Label.c.Plc_productSkuTableField'), fieldName: 'productSKU', type: 'text'},
            {label: $A.get('$Label.c.Plc_modelTableField'), fieldName: 'model', type: 'text'},
            {label: $A.get('$Label.c.Plc_manufacturerTableField'), fieldName: 'manufacturer', type: 'text'},
            {label: $A.get('$Label.c.Plc_nexiSerialNumberTableField'), fieldName: 'encodedSerialNumber', type: 'text'},
            {
                label: $A.get('$Label.c.Plc_manufacturerSerialNumberTableField'),
                fieldName: 'manufacturerSerialNumber',
                type: 'text'
            },
            {label: $A.get('$Label.c.Plc_dllSerialNumberTableField'), fieldName: 'dllSerialNumber', type: 'text'},
            {label: $A.get('$Label.c.Plc_technicianTableField'), fieldName: 'technicianName', type: 'text'},
        ]);

        component.set('v.secondTableColumns', [
            {
                label: '',
                type: 'button',
                initialWidth: 10,
                typeAttributes: {
                    label: {fieldName: 'addButton'},
                    title: '',
                    name: 'addButton',
                    iconName: 'action:approval',
                    disabled: {fieldName: 'addButtonDisabled'},
                    class: 'btn_add'
                }
            },
            {label: $A.get('$Label.c.Plc_productSkuTableField'), fieldName: 'productSKU', type: 'text'},
            {label: $A.get('$Label.c.Plc_modelTableField'), fieldName: 'model', type: 'text',},
            {label: $A.get('$Label.c.Plc_manufacturerTableField'), fieldName: 'manufacturer', type: 'text'},
            {label: $A.get('$Label.c.Plc_nexiSerialNumberTableField'), fieldName: 'encodedSerialNumber', type: 'text'},
            {
                label: $A.get('$Label.c.Plc_manufacturerSerialNumberTableField'),
                fieldName: 'manufacturerSerialNumber',
                type: 'text'
            },
            {label: $A.get('$Label.c.Plc_dllSerialNumberTableField'), fieldName: 'dllSerialNumber', type: 'text'},
            {label: $A.get('$Label.c.Plc_technicianTableField'), fieldName: 'technicianName', type: 'text'},
        ]);

        this.refreshData(component, 'initialize');

        let warehouseId, valueMap, searchConfigurationMap;

        warehouseId = component.get('v.warehouseId');
        valueMap = '(Bit2Shop__Warehouse_Id__c = \'' + warehouseId + '\')';
        searchConfigurationMap = {'Bit2Shop__Stock_Serials2__c': valueMap};

        component.set('v.searchConfigurationMap', searchConfigurationMap);
        component.set('v.titleFirstTable', $A.get('$Label.c.Plc_withdrawnTitle'));
        component.set('v.titleSecondTable', $A.get('$Label.c.Plc_goodsAvailableTitle'));
        component.set('v.title', $A.get('$Label.c.Plc_titleStocksManagement'));
        component.set('v.dataLoaded', true);

        console.log(`initialize --> end - warehouseId : ${warehouseId}, searchConfigurationMap : ${searchConfigurationMap}`);
    },

    changeTabFocus: function (component, tabToFocus) {
        console.log(`changeTabFocus --> start - tabToFocus : ${tabToFocus}`);

        let withdrawnManagementTab, availableManagementTab, technicianSelected, availableList, withdrawnList,
            availableSelectedList, withdrawnSelectedList, newAvailableList, quantityFirstTable, quantitySecondTable;

        withdrawnManagementTab = component.find('withdrawnManagementTab');
        availableManagementTab = component.find('availableManagementTab');
        technicianSelected = component.get('v.technicianSelected');
        availableList = component.get('v.availableList');
        withdrawnList = component.get('v.withdrawnList');
        availableSelectedList = component.get('v.availableSelectedList');
        withdrawnSelectedList = component.get('v.withdrawnSelectedList');
        newAvailableList = [];

        if (tabToFocus == 'WithdrawnManagement') {
            $A.util.addClass(withdrawnManagementTab, 'slds-is-active');
            $A.util.removeClass(availableManagementTab, 'slds-is-active');

            component.set('v.titleFirstTable', $A.get('$Label.c.Plc_withdrawnTitle'));
            component.set('v.titleSecondTable', $A.get('$Label.c.Plc_goodsAvailableTitle'));

            quantityFirstTable = availableSelectedList != null && availableSelectedList.length > 0 ? availableSelectedList.length : 0;
            quantitySecondTable = availableList != null && availableList.length > 0 ? availableList.length : 0;

            component.set('v.firstTableTotalQuantity', quantityFirstTable);
            component.set('v.secondTableTotalQuantity', quantitySecondTable);

            component.set('v.tabFocused', 'WithdrawnManagement');

            if (availableList != null) {
                if (technicianSelected == '' || technicianSelected == null) {

                    availableList = availableList.map(function (row) {
                        row.addButtonDisabled = true;
                        newAvailableList.push(row);
                    });
                    component.set('v.disableSelectAll', true)
                    component.set('v.disableApplyFilterButton', true);
                    component.set('v.disableManufacturerInput', true);
                    component.set('v.disableSearchInput', true);
                } else {

                    availableList = availableList.map(function (row) {
                        row.addButtonDisabled = false;
                        newAvailableList.push(row);
                    });
                    component.set('v.disableSelectAll', false);
                    component.set('v.disableApplyFilterButton', false);
                    component.set('v.disableManufacturerInput', false);
                    component.set('v.disableSearchInput', false);
                }
            } else {
                component.set('v.disableSelectAll', true);
                component.set('v.disableApplyFilterButton', true);
                component.set('v.disableManufacturerInput', true);
                component.set('v.disableSearchInput', true);
            }

            if (availableSelectedList != null && availableSelectedList.length > 0) {
                component.set('v.disableDeselectAll', false);
            } else {
                component.set('v.disableDeselectAll', true);
            }

        } else if (tabToFocus == 'AvailableManagement') {

            $A.util.addClass(availableManagementTab, 'slds-is-active');
            $A.util.removeClass(withdrawnManagementTab, 'slds-is-active');

            component.set('v.titleFirstTable', $A.get('$Label.c.Plc_availableTitle'));
            component.set('v.titleSecondTable', $A.get('$Label.c.Plc_goodsWithdrawnTitle'));
            component.set('v.tabFocused', 'AvailableManagement');
            component.set('v.disableApplyFilterButton', false);
            component.set('v.disableManufacturerInput', false);
            component.set('v.disableSearchInput', false);

            quantityFirstTable = withdrawnSelectedList != null && withdrawnSelectedList.length > 0 ? withdrawnSelectedList.length : 0;
            quantitySecondTable = withdrawnList != null && withdrawnList.length > 0 ? withdrawnList.length : 0;

            component.set('v.firstTableTotalQuantity', quantityFirstTable);
            component.set('v.secondTableTotalQuantity', quantitySecondTable);

            availableList = availableList.map(function (row) {
                row.addButtonDisabled = false;
                newAvailableList.push(row);
            });

            if (withdrawnList != null && withdrawnList.length > 0) {
                component.set('v.disableSelectAll', false);
            } else {
                component.set('v.disableSelectAll', true);
                component.set('v.disableApplyFilterButton', true);
                component.set('v.disableManufacturerInput', true);
                component.set('v.disableSearchInput', true);
            }

            if (withdrawnSelectedList != null && withdrawnSelectedList.length > 0) {
                component.set('v.disableDeselectAll', false);
            } else {
                component.set('v.disableDeselectAll', true);
            }

        }

        component.set('v.availableList', newAvailableList);

        console.log(`changeTabFocus --> end - newAvailableList : ${newAvailableList}`);
    },

    selectManagement: function (component, event) {
        console.log(`selectManagement --> start`);

        let objectId, availableSelectedList, withdrawnSelectedList, availableList, withdrawnList, tabFocused;

        objectId = event.getParam("row") != null ? event.getParam("row").Id : '';
        availableSelectedList = component.get('v.availableSelectedList');
        withdrawnSelectedList = component.get('v.withdrawnSelectedList');
        availableList = component.get('v.availableList');
        withdrawnList = component.get('v.withdrawnList');
        tabFocused = component.get('v.tabFocused');

        if (tabFocused == 'WithdrawnManagement') {
            if (availableList != null && availableList.length > 0) {
                for (var i = 0; i < availableList.length; i++) {
                    if (availableList[i] != null && availableList[i].Id == objectId) {
                        availableList[i].newTechnician = component.get("v.technicianSelected");
                        availableList[i].technicianName = component.get("v.technicianSelected").Name;
                        availableList[i].selected = true;
                        availableSelectedList.push(availableList[i]);
                        component.set("v.availableSelectedList", availableSelectedList);
                        availableList.splice(i, 1);
                        component.set("v.availableList", availableList);
                    }
                }
                console.log(`selectManagement --> availableSelectedList : ${availableSelectedList}`);
                console.log(`selectManagement --> availableList : ${availableList}`);
            } else {
                console.log(`selectManagement --> availableList is empty.`);
            }
        } else if (tabFocused == 'AvailableManagement') {
            if (withdrawnList != null && withdrawnList.length > 0) {
                for (var i = 0; i < withdrawnList.length; i++) {
                    if (withdrawnList[i] != null && withdrawnList[i].Id == objectId) {
                        withdrawnList[i].newTechnician = '';
                        withdrawnList[i].technicianName = '';
                        withdrawnList[i].selected = true;
                        withdrawnSelectedList.push(withdrawnList[i]);
                        component.set("v.withdrawnSelectedList", withdrawnSelectedList);
                        withdrawnList.splice(i, 1);
                        component.set("v.withdrawnList", withdrawnList);
                    }
                }
                console.log(`selectManagement --> withdrawnSelectedList : ${withdrawnSelectedList}`);
                console.log(`selectManagement --> withdrawnList : ${withdrawnList}`);
            } else {
                console.log(`selectManagement --> withdrawnList is empty.`);
            }
        }
    },

    removeManagement: function (component, event) {
        console.log(`removeManagement --> start`);

        let objectId, availableSelectedList, withdrawnSelectedList, availableList, withdrawnList, tabFocused,
            technicianPicklistValue;

        objectId = event.getParam("row") != null ? event.getParam("row").Id : '';
        availableSelectedList = component.get('v.availableSelectedList');
        withdrawnSelectedList = component.get('v.withdrawnSelectedList');
        availableList = component.get('v.availableList');
        withdrawnList = component.get('v.withdrawnList');
        tabFocused = component.get('v.tabFocused');
        technicianPicklistValue = component.find('technicianPicklist').get('v.value');

        if (tabFocused == 'WithdrawnManagement') {
            if (availableSelectedList != null && availableSelectedList.length > 0) {
                for (var i = 0; i < availableSelectedList.length; i++) {
                    if (availableSelectedList[i] != null && availableSelectedList[i].Id == objectId) {
                        availableSelectedList[i].newTechnician = '';
                        availableSelectedList[i].technicianName = '';
                        availableSelectedList[i].selected = false;
                        availableList.push(availableSelectedList[i]);
                        component.set("v.availableList", availableList);
                        availableSelectedList.splice(i, 1);
                        component.set("v.availableSelectedList", availableSelectedList);
                    }
                }
                console.log(`removeManagement --> availableList : ${availableList}`);
                console.log(`removeManagement --> availableSelectedList : ${availableSelectedList}`);
            } else {
                console.log(`removeManagement --> availableSelectedList is empty.`);
            }
        } else if (tabFocused == 'AvailableManagement') {
            if (withdrawnSelectedList != null && withdrawnSelectedList.length > 0) {
                for (var i = 0; i < withdrawnSelectedList.length; i++) {
                    if (withdrawnSelectedList[i] != null && withdrawnSelectedList[i].Id == objectId) {
                        withdrawnSelectedList[i].newTechnician = withdrawnSelectedList[i].oldTechnician;
                        withdrawnSelectedList[i].technicianName = withdrawnSelectedList[i].oldTechnician != null ? withdrawnSelectedList[i].oldTechnician.Name : '';
                        withdrawnSelectedList[i].selected = false;

                        if (technicianPicklistValue == '' || technicianPicklistValue == withdrawnSelectedList[i].newTechnician.Id) {
                            withdrawnList.push(withdrawnSelectedList[i]);
                            component.set("v.withdrawnList", withdrawnList);
                        }

                        withdrawnSelectedList.splice(i, 1);
                        component.set("v.withdrawnSelectedList", withdrawnSelectedList);
                    }
                }
                console.log(`removeManagement --> withdrawnList : ${withdrawnList}`);
                console.log(`removeManagement --> withdrawnSelectedList : ${withdrawnSelectedList}`);
            } else {
                console.log(`removeManagement --> withdrawnSelectedList is empty.`);
            }
        }
    },

    changeTechnicianPicklist: function (component) {
        console.log(`changeTechnicianPicklist --> start`);

        let technicianId, technicianList, tabFocused;

        technicianId = component.find('technicianPicklist').get('v.value');
        technicianList = component.get('v.technicianList');
        tabFocused = component.get('v.tabFocused');

        if (technicianId == null || technicianId == '') {

            component.set('v.technicianSelected', '');
            //FB 20190627 NEXIPLC-590 [START]
            component.set('v.uploadCsvConfigurationMap.technicianName', '');
            //FB 20190627 NEXIPLC-590 [END]
            if (tabFocused == 'WithdrawnManagement') {

                component.set('v.disableSelectAll', true);
                component.set('v.disableManufacturerInput', true);
                component.set('v.disableSearchInput', true);
            } else {
                component.set('v.disableSelectAll', false);
                component.set('v.disableManufacturerInput', false);
                component.set('v.disableSearchInput', false);
            }

        } else {

            component.set('v.disableSelectAll', false);
            component.set('v.disableManufacturerInput', true);
            component.set('v.disableSearchInput', true);
            for (var i = 0; i < technicianList.length; i++) {
                if (technicianList[i].Id == technicianId) {
                    component.set('v.technicianSelected', technicianList[i]);
                    //FB 20190627 NEXIPLC-590 [START]
                    component.set('v.uploadCsvConfigurationMap.technicianName', technicianList[i].Name);
                    //FB 20190627 NEXIPLC-590 [END]
                }
            }
        }

        this.getStockSerialWithdrawnList(component);
        console.log(`changeTechnicianPicklist --> end - technicianId : ${technicianId}`);
    },

    filterEvt: function (component, event) {
        console.log(`filterEvt --> start`);

        let actionType, warehouseId, resultsList, tabFocused, action, createWrapperListFromResults, globalList;

        actionType = event.getParam('actionType');
        warehouseId = component.get('v.warehouseId');
        resultsList = event.getParam('searchResultsEvt');
        tabFocused = component.get('v.tabFocused');
        action = tabFocused == 'AvailableManagement' ? 'refreshAvailableManagement' : 'refreshWithdrawnManagement';
        createWrapperListFromResults = component.get('c.createWrapperListFromResults');
        globalList = [];

        component.set('v.filterResult', resultsList);

        if (actionType == 'applyFilters') {
            createWrapperListFromResults.setParams({
                'resultsList': JSON.stringify(resultsList),
                'warehouseId': warehouseId,
                'tabFocused': tabFocused
            });

            createWrapperListFromResults.setCallback(this, function (response) {
                if (component.isValid() && response.getState() === "SUCCESS") {

                    if (response.getReturnValue() != null) {
                        globalList.push.apply(globalList, response.getReturnValue());
                        if (tabFocused == 'AvailableManagement') {
                            globalList.push.apply(globalList, component.get('v.availableList'));
                            globalList.push.apply(globalList, component.get('v.availableSelectedList'));

                            if (response.getReturnValue().length == 1) {
                                component.set('v.inputSearch', '');
                                component.set('v.resetInputsAfterSearching', true);
                                console.log('resetInputsAfterSearching >> ' + component.get('v.resetInputsAfterSearching'));
                                response.getReturnValue()[0].selected = true;
                                response.getReturnValue()[0].newTechnician = '';
                                response.getReturnValue()[0].technicianName = '';
                                var withdrawnSelectedList = component.get('v.withdrawnSelectedList');
                                var productFound = false;

                                if (withdrawnSelectedList != null && withdrawnSelectedList.length > 0) {
                                    for (var i = 0; i < withdrawnSelectedList.length; i++) {
                                        if (withdrawnSelectedList[i].Id == response.getReturnValue()[0].Id) {
                                            productFound = true;
                                        }
                                    }
                                    if (productFound == false) {
                                        withdrawnSelectedList.push(response.getReturnValue()[0]);
                                        component.set('v.withdrawnSelectedList', withdrawnSelectedList);
                                    } else {
                                        component.set('v.modalMessage', $A.get('$Label.c.Plc_ProductJustInserted.'));
                                        component.set('v.modalType', 'warning');
                                        component.set('v.showModal', true);
                                    }
                                } else {
                                    component.set('v.withdrawnSelectedList', response.getReturnValue()[0]);
                                }

                                var withdrawnList = component.get('v.withdrawnList');

                                for (var i = 0; i < withdrawnList.length; i++) {
                                    if (response.getReturnValue()[0].Id == withdrawnList[i].Id) {
                                        withdrawnList.splice(i, 1);
                                    }
                                }

                                component.set('v.withdrawnList', withdrawnList);
                            } else {
                                component.set('v.resetInputsAfterSearching', false);

                                var returnValueList = response.getReturnValue();

                                for (var i = 0; i < returnValueList.length; i++) {
                                    returnValueList[i].newTechnician = returnValueList[i].oldTechnician;
                                    returnValueList[i].technicianName = returnValueList[i].oldTechnician != null ? returnValueList[i].oldTechnician.Name : '';
                                }

                                console.log('returnValueList >> ' + JSON.stringify(returnValueList));
                                component.set('v.withdrawnList', returnValueList);
                            }

                        } else if (tabFocused == 'WithdrawnManagement') {
                            globalList.push.apply(globalList, component.get('v.withdrawnList'));
                            globalList.push.apply(globalList, component.get('v.withdrawnSelectedList'));
                            var searchedText = component.get('v.inputSearch');

                            if (response.getReturnValue().length == 1 && !$A.util.isEmpty(searchedText)
                            && (
                                (!$A.util.isEmpty(response.getReturnValue()[0].encodedSerialNumber) && response.getReturnValue()[0].encodedSerialNumber.toUpperCase() == searchedText)
                                || (!$A.util.isEmpty(response.getReturnValue()[0].manufacturerSerialNumber) && response.getReturnValue()[0].manufacturerSerialNumber.toUpperCase() == searchedText)
                                || (!$A.util.isEmpty(response.getReturnValue()[0].dllSerialNumber) && response.getReturnValue()[0].dllSerialNumber.toUpperCase() == searchedText)
                            )
                            ) {
                                component.set('v.resetInputsAfterSearching', true);
                                console.log('resetInputsAfterSearching >> ' + component.get('v.resetInputsAfterSearching'));
                                response.getReturnValue()[0].selected = true;
                                response.getReturnValue()[0].newTechnician = component.get('v.technicianSelected');
                                response.getReturnValue()[0].technicianName = component.get('v.technicianSelected').Name;

                                var availableSelectedList = component.get('v.availableSelectedList');
                                var productFound = false;

                                if (availableSelectedList != null && availableSelectedList.length > 0) {
                                    for (var i = 0; i < availableSelectedList.length; i++) {
                                        if (availableSelectedList[i].Id == response.getReturnValue()[0].Id) {
                                            productFound = true;
                                        }
                                    }
                                    if (productFound == false) {
                                        availableSelectedList.push(response.getReturnValue()[0]);
                                        component.set('v.availableSelectedList', availableSelectedList);
                                    } else {
                                        component.set('v.modalMessage', $A.get('$Label.c.Plc_ProductJustInserted'));
                                        component.set('v.modalType', 'warning');
                                        component.set('v.showModal', true);
                                    }
                                } else {
                                    component.set('v.availableSelectedList', response.getReturnValue()[0]);
                                }
                                var availableList = component.get('v.availableList');

                                for (var i = 0; i < availableList.length; i++) {
                                    if (response.getReturnValue()[0].Id == availableList[i].Id) {
                                        availableList.splice(i, 1);
                                    }
                                }

                                component.set('v.availableList', availableList);
                            } else {
                                component.set('v.resetInputsAfterSearching', false);
                                component.set('v.availableList', response.getReturnValue());
                            }
                        }
                        component.set('v.globalList', globalList);
                    } else {
                        component.set('v.modalMessage', $A.get('$Label.c.Plc_noRecordsFound'));
                        component.set('v.modalType', 'warning');
                        component.set('v.showModal', true);
                    }
                    component.set('v.showSpinner', false);

                } else if (component.isValid() && response.getState() === "INCOMPLETE") {
                    console.log("[CALLBACK] @H filterEvt >> INCOMPLETE -- " + response.getError()[0].message);
                } else if (component.isValid() && response.getState() === "ERROR") {
                    console.log("[CALLBACK] @H filterEvt >> ERROR -- " + response.getError()[0].message);
                }
            });
            component.set('v.showSpinner', true);
            $A.enqueueAction(createWrapperListFromResults);
        } else if (actionType == 'removeFilters') {
            this.refreshData(component, action);
        }

        //console.log(`filterComponent --> end - globalList : ${component.get('v.globalList')}, availableList : ${component.get('v.availableList')}, withdrawnList : ${component.get('v.withdrawnList')}`);
    },

    getStockSerialWithdrawnList: function (component) {
        console.log(`getStockSerialWithdrawnList --> start`);

        let technicianId, globalList, newWithdrawnFilteredList, totalWithdrawnList;

        technicianId = component.get('v.technicianSelected') != null ? component.get('v.technicianSelected').Id : '';
        globalList = component.get('v.globalList');
        newWithdrawnFilteredList = [];
        totalWithdrawnList = [];

        for (var i = 0; i < globalList.length; i++) {
            if (globalList[i].status == 'Withdrawn' && globalList[i].selected == false) {
                if (globalList[i].newTechnician != null && globalList[i].newTechnician.Id == technicianId) {
                    newWithdrawnFilteredList.push(globalList[i]);
                }
                totalWithdrawnList.push(globalList[i]);
            }
        }

        if (technicianId == null || technicianId == '') {
            component.set('v.withdrawnList', totalWithdrawnList);
        } else {
            component.set('v.withdrawnList', newWithdrawnFilteredList);
        }

        console.log(`getStockSerialWithdrawnList --> end - withdrawnList : ${component.get('v.withdrawnList')}`);
    },

    updateGlobaList: function (component, event) {
        console.log(`updateGlobaList --> start`);

        let globalList, objectList, availableSelectedList, withdrawnSelectedList, tabFocused, firstTableTotalQuantity, secondTableTotalQuantity;

        globalList = component.get('v.globalList');

        let globalListMap = {};
        globalList.forEach(function(item) {
            globalListMap[item.Id] = item;
        });

        objectList = event.getParam('value');
        availableSelectedList = component.get('v.availableSelectedList');
        withdrawnSelectedList = component.get('v.withdrawnSelectedList');
        tabFocused = component.get('v.tabFocused');
        if (objectList != null && objectList != '') {
            for (var x = 0; x < objectList.length; x++) {
                if (globalListMap != null && globalListMap != '') {
                    if (globalListMap.hasOwnProperty(objectList[x].Id)) {
                        globalListMap[objectList[x].Id].selected = objectList[x].selected;
                        globalListMap[objectList[x].Id].technicianName = objectList[x].newTechnician != null ? objectList[x].newTechnician.Name : '';
                    }
                }
            }
        }
        
        globalList = [];
        
        Object
            .keys(globalListMap)
            .forEach(function(key){
                globalList.push(globalListMap[key]);
            });

        component.set('v.globalList', globalList);

        if ((availableSelectedList != null && availableSelectedList != '') || (withdrawnSelectedList != null && withdrawnSelectedList != '')) {
            component.set('v.isSaveEnabled', true);
        } else {
            component.set('v.isSaveEnabled', false);
        }

        if (tabFocused == 'WithdrawnManagement') {

            firstTableTotalQuantity = availableSelectedList != null && availableSelectedList.length > 0 ? availableSelectedList.length : 0;
            secondTableTotalQuantity = component.get('v.availableList') != null && component.get('v.availableList').length > 0 ? component.get('v.availableList').length : 0;

            if (component.get('v.availableSelectedList') != null & component.get('v.availableSelectedList').length > 0) {
                component.set('v.disableDeselectAll', false);
            } else {
                component.set('v.disableDeselectAll', true);
            }
        } else if (tabFocused == 'AvailableManagement') {

            firstTableTotalQuantity = withdrawnSelectedList != null && withdrawnSelectedList.length > 0 ? withdrawnSelectedList.length : 0;
            secondTableTotalQuantity = component.get('v.withdrawnList') != null && component.get('v.withdrawnList').length > 0 ? component.get('v.withdrawnList').length : 0;

            if (component.get('v.withdrawnSelectedList') != null && component.get('v.withdrawnSelectedList').length > 0) {
                component.set('v.disableDeselectAll', false);
            } else {
                component.set('v.disableDeselectAll', true);
            }
        }

        component.set('v.firstTableTotalQuantity', firstTableTotalQuantity);
        component.set('v.secondTableTotalQuantity', secondTableTotalQuantity);

        // console.log(`updateGlobaList --> end - globalList : ${component.get('v.globalList')}`);
    },

    refreshData: function (component, action) {
        console.log(`refreshData --> start`);

        let globalList, warehouseId, initializeMethod, _helper;

        globalList = [];
        warehouseId = component.get('v.warehouseId');
        initializeMethod = component.get("c.initialize");
        _helper = this;

        initializeMethod.setParams({'warehouseId': warehouseId, 'action': action});
        initializeMethod.setCallback(this, function (response) {
            if (component.isValid() && response.getState() === "SUCCESS") {
                console.log('[CALLBACK] @H refreshData >> SUCCESS');

                if (action == 'initialize') {
                    globalList.push.apply(globalList, response.getReturnValue().availableList);
                    globalList.push.apply(globalList, response.getReturnValue().withdrawnList);

                    var withdrawnList = response.getReturnValue().withdrawnList;

                    if (withdrawnList != null) {
                        for (var i = 0; i < withdrawnList.length; i++) {
                            withdrawnList[i].technicianName = withdrawnList[i].newTechnician != null ? withdrawnList[i].newTechnician.Name : '';
                        }
                    }

                    component.set('v.availableList', response.getReturnValue().availableList);
                    component.set('v.withdrawnList', withdrawnList);
                    component.set('v.technicianList', response.getReturnValue().technicianList);

                    component.set('v.availableSelectedList', []);
                    component.set('v.withdrawnSelectedList', []);
                    _helper.changeTabFocus(component, 'WithdrawnManagement');

                    //FB 20190627 - NEXIPLC-590 [START]
                    if (response.getReturnValue().warehouse) {
                        component.set('v.title', component.get('v.title') + ' • ' + response.getReturnValue().warehouse.Name);
                    }
                    //FB 20190627 - NEXIPLC-590 [END]
                    
                } else if (action == 'refreshAvailableManagement') {

                    var withdrawnList = response.getReturnValue().withdrawnList;
                    var withdrawnSelectedList = component.get('v.withdrawnSelectedList');

                    for (var i = 0; i < withdrawnList.length; i++) {
                        for (var x = 0; x < withdrawnSelectedList.length; x++) {
                            if (withdrawnList[i].Id == withdrawnSelectedList[x].Id) {
                                withdrawnList.splice(i, 1);
                            }
                        }
                    }

                    globalList.push.apply(globalList, withdrawnList);
                    globalList.push.apply(globalList, withdrawnSelectedList);
                    globalList.push.apply(globalList, component.get('v.availableList'));
                    globalList.push.apply(globalList, component.get('v.availableSelectedList'));
                    //component.set('v.withdrawnSelectedList', []);
                    //_helper.getStockSerialWithdrawnList(component);

                } else if (action == 'refreshWithdrawnManagement') {

                    var availableList = response.getReturnValue().availableList;
                    var availableSelectedList = component.get('v.availableSelectedList');

                    for (var i = 0; i < availableList.length; i++) {
                        for (var x = 0; x < availableSelectedList.length; x++) {
                            if (availableList[i].Id == availableSelectedList[x].Id) {
                                availableList.splice(i, 1);
                            }
                        }
                    }

                    globalList.push.apply(globalList, availableList);
                    globalList.push.apply(globalList, availableSelectedList);
                    globalList.push.apply(globalList, component.get('v.withdrawnList'));
                    globalList.push.apply(globalList, component.get('v.withdrawnSelectedList'));
                    //component.set('v.availableSelectedList', []);

                }

                component.find('technicianPicklist').set('v.value', '');
                component.set('v.globalList', globalList);
                component.set('v.technicianSelected', '');

                if (action == 'refreshWithdrawnManagement') {
                    component.set('v.availableList', availableList);
                    _helper.changeTabFocus(component, 'WithdrawnManagement');
                } else if (action == 'refreshAvailableManagement') {
                    component.set('v.withdrawnList', withdrawnList);

                }

                if (action == 'refreshWithdrawnManagement' || action == 'refreshAvailableManagement') {
                    _helper.getStockSerialWithdrawnList(component);
                }

                component.set('v.showSpinner', false);

            } else if (component.isValid() && response.getState() === "INCOMPLETE") {
                console.log("[CALLBACK] @H refreshData >> INCOMPLETE -- " + response.getError()[0].message);
            } else if (component.isValid() && response.getState() === "ERROR") {
                console.log("[CALLBACK] @H refreshData >> ERROR -- " + response.getError()[0].message);
            }
        });
        component.set('v.showSpinner', true);
        $A.enqueueAction(initializeMethod);

        console.log(`updateGlobaList --> end`);
    },

    save: function (component) {
        console.log(`save --> start`);

        let availableSelectedList, withdrawnSelectedList, confirm;

        availableSelectedList = component.get('v.availableSelectedList');
        withdrawnSelectedList = component.get('v.withdrawnSelectedList');
        confirm = component.get('c.confirm');

        console.log(availableSelectedList);

        for (var i = 0; i < withdrawnSelectedList.length; i++) {
            withdrawnSelectedList[i].newTechnician = null;
        }

        component.set('v.withdrawnSelectedList', withdrawnSelectedList);

        confirm.setParams({
            'availableSelectedSerialized': JSON.stringify(availableSelectedList),
            'withdrawnSelectedSerialiazed': JSON.stringify(withdrawnSelectedList)
        });

        confirm.setCallback(this, function (response) {
            if (component.isValid() && response.getState() === "SUCCESS") {
                console.log('[CALLBACK] @H save >> SUCCESS');
                component.set('v.showSpinner', false);
                if (response.getReturnValue() == true) {
                    component.set('v.modalMessage', $A.get('$Label.c.Plc_succeededSaveMessage'));
                    component.set('v.modalType', 'success');
                    component.set('v.showModal', true);
                } else {
                    component.set('v.modalMessage', 'An error has occured during the save process.');
                    component.set('v.modalType', 'error');
                    component.set('v.showModal', true);
                }


            } else if (component.isValid() && response.getState() === "INCOMPLETE") {
                console.log("[CALLBACK] @H save >> INCOMPLETE -- " + response.getError()[0].message);
            } else if (component.isValid() && response.getState() === "ERROR") {
                console.log("[CALLBACK] @H save >> ERROR -- " + response.getError()[0].message);
            }
        });

        component.set('v.showSpinner', true);
        $A.enqueueAction(confirm);

        console.log(`save --> end`);
    },

    technicianUpdated: function (component, event) {
        console.log(`save --> techniciainUpdated`);

        let technicianId, tabFocused, availableList, newAvailableList;

        technicianId = event.getParam('value');
        tabFocused = component.get('v.tabFocused');
        availableList = component.get('v.availableList');
        newAvailableList = [];

        if (tabFocused == 'WithdrawnManagement') {
            if (technicianId != null && technicianId != '') {
                if (availableList != null) {
                    availableList = availableList.map(function (row) {
                        row.addButtonDisabled = false;
                        newAvailableList.push(row);
                    });

                }
                component.set('v.disableSearchInput', false);
                component.set('v.disableManufacturerInput', false);
                component.set('v.disableApplyFilterButton', false);
            } else if (availableList != null) {
                availableList = availableList.map(function (row) {
                    row.addButtonDisabled = true;
                    newAvailableList.push(row);
                })
                component.set('v.disableSearchInput', true);
                component.set('v.disableManufacturerInput', true);
                component.set('v.disableApplyFilterButton', true);
            }
        } else if (tabFocused == 'AvailableManagement') {
            if (availableList != null) {
                availableList = availableList.map(function (row) {
                    row.addButtonDisabled = false;
                    newAvailableList.push(row);
                });
            }
            component.set('v.disableSearchInput', false);
            component.set('v.disableManufacturerInput', false);
            component.set('v.disableApplyFilterButton', false);
        }

        component.set('v.availableList', newAvailableList);

        console.log(`save --> end - newAvailableList : ${newAvailableList}`);
    },

    closeModalSuccess: function (component) {
        console.log(`closeModal --> start`);

        let modalType = component.get('v.modalType');

        if (modalType == 'success') {
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": component.get("v.objectId"),
                "slideDevName": "related"
            });
            navEvt.fire();
            //this.refreshData(component, 'initialize');
        } else {
            component.set('v.showModal', false);
        }

        console.log(`closeModal --> end`);
    },

    selectAll: function (component) {
        console.log(`selectAll --> start`);

        let tabFocused, availableList, withdrawnList, availableSelectedList, withdrawnSelectedList, technicianSelected;

        tabFocused = component.get('v.tabFocused');
        availableList = component.get('v.availableList');
        withdrawnList = component.get('v.withdrawnList');
        availableSelectedList = component.get('v.availableSelectedList');
        withdrawnSelectedList = component.get('v.withdrawnSelectedList');
        technicianSelected = component.get('v.technicianSelected');


        if (tabFocused == 'WithdrawnManagement') {

            for (var i = 0; i < availableList.length; i++) {
                availableList[i].newTechnician = technicianSelected;
                availableList[i].technicianName = technicianSelected != null ? technicianSelected.Name : '';
                availableList[i].selected = true;
            }

            availableSelectedList = availableSelectedList.concat(availableList);
            component.set('v.availableSelectedList', availableSelectedList);
            component.set('v.availableList', []);
        } else if (tabFocused == 'AvailableManagement') {

            for (var i = 0; i < withdrawnList.length; i++) {
                withdrawnList[i].newTechnician = '';
                withdrawnList[i].technicianName = '';
                withdrawnList[i].selected = true;
            }

            withdrawnSelectedList = withdrawnSelectedList.concat(withdrawnList);
            component.set('v.withdrawnSelectedList', withdrawnSelectedList);
            component.set('v.withdrawnList', []);
        }

        console.log(`selectAll --> end`);
    },

    deselectAll: function (component) {
        console.log(`deselectAll --> start`);

        let tabFocused, availableList, withdrawnList, availableSelectedList, withdrawnSelectedList, technicianSelected;

        tabFocused = component.get('v.tabFocused');
        availableList = component.get('v.availableList');
        withdrawnList = component.get('v.withdrawnList');
        availableSelectedList = component.get('v.availableSelectedList');
        withdrawnSelectedList = component.get('v.withdrawnSelectedList');
        technicianSelected = component.get('v.technicianSelected');


        if (tabFocused == 'WithdrawnManagement') {

            for (var i = 0; i < availableSelectedList.length; i++) {
                availableSelectedList[i].technicianSelected = '';
                availableSelectedList[i].technicianName = '';
                availableSelectedList[i].selected = false;
            }

            availableList = availableList.concat(availableSelectedList);
            component.set('v.availableList', availableList);
            component.set('v.availableSelectedList', []);
        } else if (tabFocused == 'AvailableManagement') {

            for (var i = 0; i < withdrawnSelectedList.length; i++) {
                withdrawnSelectedList[i].technicianSelected = withdrawnSelectedList[i].oldTechnician;
                withdrawnSelectedList[i].technicianName = withdrawnSelectedList[i].oldTechnician != null ? withdrawnSelectedList[i].oldTechnician.Name : '';
                withdrawnSelectedList[i].selected = false;
            }

            withdrawnList = withdrawnList.concat(withdrawnSelectedList);
            component.set('v.withdrawnList', withdrawnList);
            component.set('v.withdrawnSelectedList', []);
        }

        console.log(`deselectAll --> end`);
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
    /*Defines the columns (for warehouses) showed in the component */
    getWarehouseColumnDefinitions: function(component) {
        var columns = [
            { label: component.get('v.translationMap.WarehouseName'), fieldName: 'Name', type:'text', sortable: true },
            { label: component.get('v.translationMap.Bit2Shop__Dealer_Id__c'), fieldName: 'Bit2Shop__Dealer_Name', type:'text', sortable: true },
            { label: component.get('v.translationMap.Plc_Tipology__c'), fieldName: 'Plc_Tipology__c', type:'text', sortable: true },
            { label: component.get('v.translationMap.Plc_LogisticDivision__c'), fieldName: 'Plc_LogisticDivision__c', type: 'text', sortable: true },
            { label: component.get('v.translationMap.Plc_Property__c'), fieldName: 'Plc_Property__c', type:'text', sortable: true },
            { label: component.get('v.translationMap.Bit2Shop__City__c'), fieldName: 'Bit2Shop__City__c', type:'text', sortable: true }
        ];
        return columns;
    },
    /* Function used to get available warehouses */
    retrieveAvailableWarehouses: function(component, helper) {

        var action = component.get('c.retrieveAvailableWarehouses');
        helper.showSpinner(component, 'table-spinner');

        action.setParams({
            searchKey: component.get('v.propertiesMap.searchKey')
        });

        action.setCallback(this, function(response) {

            var result = response.getReturnValue();
            var state = response.getState();

            if (component.isValid() && state === 'SUCCESS'  && !result.error) {
                var result = response.getReturnValue();
                var warehouseList = result.warehousesList
                                    .map(function(item) {
                                        if (item.Bit2Shop__Dealer_Id__c) {
                                            item.Bit2Shop__Dealer_Name = item.Bit2Shop__Dealer_Id__r.Name;
                                        }
                                        return item;
                                    });

                component.set('v.warehousesList', result.warehousesList);
                if (result.warehousesList.length > 0 ) {
                    component.set('v.propertiesMap.showNoWarehouseIllustration', false);
                } else {
                    component.set('v.propertiesMap.showNoWarehouseIllustration', true);
                }
            }  else if (component.isValid() && 
                        (response.getState() === 'ERROR' || result.error)){
                
                if (result) {
                    helper.showToast($A.get('$Label.c.Plc_AllAllError'), result.errorMsg, 'warning', 'sticky');
                    console.error(result.errorMsg);
                }
            }
            helper.hideSpinner(component, 'table-spinner');
        });
        $A.enqueueAction(action);
    },
    /* Gets from server a map that contains pairs api name/label. Used in order to get translations */
    retrieveTranslationMap: function(component, helper) {
        var action = component.get('c.retrieveTranslationMap');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === 'SUCCESS') {
                var result = response.getReturnValue();
                //Setting translation for serial stock fields
                component.set('v.translationMap.Bit2Shop__Stock_Serials2__c', result.Bit2Shop__Stock_Serials2__c);
                component.set('v.translationMap.SerialStockName', result.SerialStockName);
                component.set('v.translationMap.Plc_ManufacturerSerialNumber__c', result.Plc_ManufacturerSerialNumber__c);
                component.set('v.translationMap.Plc_EncodedSerialNumber__c', result.Plc_EncodedSerialNumber__c);
                component.set('v.translationMap.Plc_DllSerialNumber__c', result.Plc_DllSerialNumber__c);
                component.set('v.translationMap.Plc_ProductSku__c', result.Plc_ProductSku__c);
                component.set('v.translationMap.Bit2Shop__Warehouse_Id__c', result.Bit2Shop__Warehouse_Id__c);
                component.set('v.translationMap.Bit2Shop__Purchase_Price__c', result.Bit2Shop__Purchase_Price__c);
                component.set('v.translationMap.Plc_PcipedExpiryDate__c', result.Plc_PcipedExpiryDate__c);
                component.set('v.translationMap.Plc_Note__c', result.Plc_Note__c);
                component.set('v.translationMap.Bit2Shop__Status__c', result.Bit2Shop__Status__c);
                component.set('v.translationMap.Plc_Status2__c', result.Plc_Status2__c);
                //Setting translation for warehouse fields
                component.set('v.translationMap.Bit2Shop__Warehouse__c', result.Bit2Shop__Warehouse__c);
                component.set('v.translationMap.WarehouseName', result.WarehouseName);
                component.set('v.translationMap.Bit2Shop__Dealer_Id__c', result.Bit2Shop__Dealer_Id__c);
                component.set('v.translationMap.Plc_Property__c', result.Plc_Property__c);
                component.set('v.translationMap.Plc_LogisticDivision__c', result.Plc_LogisticDivision__c);
                component.set('v.translationMap.Bit2Shop__State_Province__c', result.Bit2Shop__State_Province__c);
                component.set('v.translationMap.Plc_Tipology__c', result.Plc_Tipology__c);
                component.set('v.translationMap.Bit2Shop__City__c', result.Bit2Shop__City__c);
                component.set('v.translationMap.Plc_Alias__c', result.Plc_Alias__c);
            }

            helper.openModal(component, helper, 'modal-warehouses');
            component.set('v.columns', helper.getWarehouseColumnDefinitions(component));
            helper.retrieveAvailableWarehouses(component, helper);

        });
        $A.enqueueAction(action);
    },
    // FB 20190627 NEXIPLC-589 [START]
    handleFilterResult: function(component, event, helper) {
        if (event.getParam('actionType') === 'hideModal') {
            component.set('v.showUploadCsvModal', false);
        } else if (event.getParam('actionType') === 'sendCsvResults') {
            component.set('v.showUploadCsvModal', false);

            let stockSerialFromCSV = event.getParam("searchResultsEvt").stockSerialFromCSV;
            var contactMap = event.getParam("searchResultsEvt").additionalData.contactMap;
            var serialIdToTechnicianMap = event.getParam("searchResultsEvt").additionalData.serialIdToTechnicianMap;

            let objectId, availableSelectedList, withdrawnSelectedList, availableList, withdrawnList, tabFocused;

            objectId = event.getParam("row") != null ? event.getParam("row").Id : '';

            availableSelectedList = component.get('v.availableSelectedList');
            withdrawnSelectedList = component.get('v.withdrawnSelectedList');
            availableList = component.get('v.availableList');
            withdrawnList = component.get('v.withdrawnList');
            tabFocused = component.get('v.tabFocused');

            var availableListMap = {};
            var withdrawnListMap = {};

            availableList.forEach(function(item, index) {
                item.index = index;
                availableListMap[item.Id] = item;
            });

            withdrawnList.forEach(function(item, index) {
                item.index = index;
                withdrawnListMap[item.Id] = item;
            });

            var availableSelectedListMap = {};
            var withdrawnSelectedListMap = {};

            availableSelectedList.forEach(function(item, index) {
                item.index = index;
                availableSelectedListMap[item.Id] = item;
            });

            withdrawnSelectedList.forEach(function(item, index) {
                item.index = index;
                withdrawnSelectedListMap[item.Id] = item;
            });

            var indexesToRemove = [];

            if (tabFocused == 'WithdrawnManagement') {

                stockSerialFromCSV.forEach(function(serial) {
                    var technicianName;
                    var technicianId;
                    if (component.get("v.technicianSelected")) {
                        technicianId = component.get("v.technicianSelected").Id;
                        technicianName = component.get("v.technicianSelected").Name;
                    } else {
                        technicianName = contactMap[serialIdToTechnicianMap[serial.Id].toUpperCase()].Name;
                        technicianId = contactMap[serialIdToTechnicianMap[serial.Id].toUpperCase()].Id;
                    }

                    if (availableListMap.hasOwnProperty(serial.Id)) {
                        availableListMap[serial.Id].newTechnician = {Id: technicianId, Name: technicianName};
                        availableListMap[serial.Id].technicianName = technicianName;
                        availableListMap[serial.Id].selected = true;
                        availableSelectedList.push(JSON.parse(JSON.stringify(availableListMap[serial.Id])));
                        indexesToRemove.push(availableListMap[serial.Id].index);
                    } else {
                        if (!availableSelectedListMap.hasOwnProperty(serial.Id)) {
                            var availableSerial = {}
                            availableSerial.newTechnician = {Id: technicianId, Name: technicianName};
                            availableSerial.technicianName = technicianName;
                            availableSerial.selected = true;
                            availableSerial.Id = serial.Id;
                            availableSerial.productSKU = serial.Plc_ProductSku__c;
                            availableSerial.model = serial.Plc_Model__c;
                            availableSerial.manufacturer = serial.Plc_Manufacturer__c;
                            availableSerial.encodedSerialNumber = serial.Plc_EncodedSerialNumber__c;
                            availableSerial.manufacturerSerialNumber = serial.Plc_ManufacturerSerialNumber__c;
                            availableSerial.dllSerialNumber = serial.Plc_DllSerialNumber__c;
                            availableSerial.status = serial.Bit2Shop__Status__c;
                            availableSelectedList.push(availableSerial);
                        } else {
                            availableSelectedList[availableSelectedListMap[serial.Id].index].newTechnician.Id = technicianId;
                            availableSelectedList[availableSelectedListMap[serial.Id].index].newTechnician.Name = technicianName;
                            availableSelectedList[availableSelectedListMap[serial.Id].index].technicianName = technicianName;
                        }
                    }
                });

                component.set("v.availableSelectedList", availableSelectedList);

                indexesToRemove.sort(function(a, b) { return b - a; });
                for (var i = 0; i < indexesToRemove.length; i++) {
                    availableList.splice(indexesToRemove[i], 1);
                }
                component.set("v.availableList", availableList);

            } else if (tabFocused == 'AvailableManagement') {
                stockSerialFromCSV.forEach(function(serial) {
                    if (withdrawnListMap.hasOwnProperty(serial.Id)) {
                        withdrawnListMap[serial.Id].newTechnician = '';
                        withdrawnListMap[serial.Id].technicianName = '';
                        withdrawnListMap[serial.Id].selected = true;
                        withdrawnSelectedList.push(withdrawnListMap[serial.Id]);
                        indexesToRemove.push(withdrawnListMap[serial.Id].index);
                    } else {
                        if (!withdrawnSelectedListMap.hasOwnProperty(serial.Id)) {
                            var withdrawnSerial = {}
                            withdrawnSerial.newTechnician = '';
                            withdrawnSerial.technicianName = '';
                            withdrawnSerial.selected = true;
                            withdrawnSerial.Id = serial.Id;
                            withdrawnSerial.productSKU = serial.Plc_ProductSku__c;
                            withdrawnSerial.model = serial.Plc_Model__c;
                            withdrawnSerial.manufacturer = serial.Plc_Manufacturer__c;
                            withdrawnSerial.encodedSerialNumber = serial.Plc_EncodedSerialNumber__c;
                            withdrawnSerial.manufacturerSerialNumber = serial.Plc_ManufacturerSerialNumber__c;
                            withdrawnSerial.dllSerialNumber = serial.Plc_DllSerialNumber__c;
                            withdrawnSerial.status = serial.Bit2Shop__Status__c;
                            withdrawnSelectedList.push(withdrawnSerial);
                        }
                    }
                });

                component.set("v.withdrawnSelectedList", withdrawnSelectedList);

                indexesToRemove.sort(function(a, b) { return b - a; });
                for (var i = 0; i < indexesToRemove.length; i++) {
                    withdrawnList.splice(indexesToRemove[i], 1);
                }
                component.set("v.withdrawnList", withdrawnList);
            }
        }
    }
    // FB 20190627 NEXIPLC-589 [END]
})