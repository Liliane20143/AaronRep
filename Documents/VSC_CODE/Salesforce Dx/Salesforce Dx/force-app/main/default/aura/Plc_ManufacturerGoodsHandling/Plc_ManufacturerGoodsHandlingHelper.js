({
    init: function (component) {
        console.log("[START] @H init");

        component.set('v.columnsDliQuantity', [
            {
                label: '', type: 'button', initialWidth: 10, typeAttributes:
                    {
                        label: {fieldName: 'selectQuantityButton'},
                        title: '',
                        name: 'selectQuantityButton',
                        iconName: 'utility:standard_objects',
                        disabled: {fieldName: 'selectQuantityButtonDisabled'},
                        class: 'btn_selectQuantity'
                    }
            },
            {label: $A.get('$Label.c.Plc_productSkuTableField'), fieldName: 'productSKU', type: 'text'},
            {label: $A.get('$Label.c.Plc_modelTableField'), fieldName: 'model', type: 'text'},
            {label: $A.get('$Label.c.Plc_QtSelected'), fieldName: 'qtSelected', type: 'text'},
            {label: $A.get('$Label.c.Plc_QtToBeSent'), fieldName: 'qtToBeSent', type: 'text'},
            {label: $A.get('$Label.c.Plc_QtInStorage'), fieldName: 'qtStorage', type: 'text'},
            {label: 'Rda Number', fieldName: 'rdaNumber', type: 'text'}
        ]);

        component.set('v.columnsDliSerial', [
            {label: $A.get('$Label.c.Plc_productSkuTableField'), fieldName: 'productSKU', type: 'text'},
            {label: $A.get('$Label.c.Plc_modelTableField'), fieldName: 'model', type: 'text'},
            {label: $A.get('$Label.c.Plc_QtSelected'), fieldName: 'qtSelected', type: 'text'},
            {label: $A.get('$Label.c.Plc_QtToBeSent'), fieldName: 'qtToBeSent', type: 'text'},
            {label: $A.get('$Label.c.Plc_QtInStorage'), fieldName: 'qtStorage', type: 'text'},
            {label: 'Rda Number', fieldName: 'rdaNumber', type: 'text'}
        ]);

        component.set('v.columnsStockSerial', [
            {
                label: '', type: 'button', initialWidth: 10, typeAttributes:
                    {
                        label: {fieldName: 'removeButton'},
                        title: '',
                        name: 'removeButton',
                        iconName: 'action:remove',
                        class: 'btn_remove'
                    }
            },
            {
                label: $A.get('$Label.c.Plc_ManufacturerSerialNumber'),
                fieldName: 'manufacturerSerialNumber',
                type: 'text'
            },
            {label: $A.get('$Label.c.Plc_EncodedSerialNumber'), fieldName: 'nexiSerialNumber', type: 'text'},
            {label: $A.get('$Label.c.Plc_Status'), fieldName: 'status', type: 'text'}
        ]);

        var valueMap = '(Bit2Shop__Status__c IN (\'New\',\'Repaired\'))';
        var searchConfigurationMap = {'Bit2Shop__Stock_Serials2__c': valueMap};
        var myPageRef = component.get("v.pageReference");
        var action = myPageRef.state.c__action;
        var _helper = this;


        component.set('v.searchConfigurationMap', searchConfigurationMap);

        console.log('action >> ' + action);


        if (action == 'edit') {
            component.set('v.editWizard', true);
            component.set('v.stockOrderId', component.get('v.objectId'));
            _helper.loadDataForEdit(component);
        } else {
            component.set('v.distributionListId', component.get('v.objectId'));
            _helper.initializeData(component);
        }
    },

    next: function (component) {
        console.log("[START] @H next");

        component.set('v.isSaveVisible', true);
        component.set('v.isNextVisible', false);
        component.set('v.shipmentTab', true);

        console.log("[END] @H next");
    },

    changeTransferDetail: function (component) {
        console.log("[START] @H changeTransferDetail");

        var transferDetailsList = component.get('v.transferDetailsList');
        var transferDetailSelected = component.find('transferDetailsPicklist').get('v.value');
        var dliIdList = component.get('v.dliIdList');

        for (var i = 0; i < transferDetailsList.length; i++) {
            /** [START MOD 24/02/2019 11:24]@Author:marco.lebellini@/webresults.it @Description: **/
            //if (transferDetailsList[i].Name == transferDetailSelected) {
            if (transferDetailsList[i].Bit2Shop__Code__c == transferDetailSelected) {
                /** [END MOD 24/02/2019 11:24]@Author:marco.lebellini@/webresults.it @Description: **/
                component.set('v.filterOriginDealer', transferDetailsList[i].Plc_FilterOriginDealer__c);
                component.set('v.filterOriginWarehouse', transferDetailsList[i].Plc_FilterOriginWarehouse__c);
                component.set('v.filterDestinationDealer', transferDetailsList[i].Plc_FilterDestinationDealer__c);
                component.set('v.filterDestinationWarehouse', transferDetailsList[i].Plc_FilterDestinationWarehouse__c);
                component.set('v.transferDetailSelected', transferDetailSelected);
            }
        }

        var getOriginDealer = component.get('c.getOriginDealer');

        /** [START MOD 23/02/2019 18:50]@Author:marco.lebellini@/webresults.it @Description: **/
        //getOriginDealer.setParams({'dliIdList': dliIdList, 'filter': component.get('v.filterOriginDealer')});
        getOriginDealer.setParams({
            'dliIdList': dliIdList,
            'filter': component.get('v.filterOriginDealer'),
            'transferDetailCode': transferDetailSelected
        });
        /** [END MOD 23/02/2019 18:50]@Author:marco.lebellini@/webresults.it @Description: **/

        getOriginDealer.setCallback(this, function (response) {
            if (component.isValid() && response.getState() === "SUCCESS") {
                console.log('[CALLBACK] @H getOriginDealer >> SUCCESS');

                component.set('v.originDealerList', response.getReturnValue());
                component.set('v.summaryTab_2', true);
                component.set('v.summaryTab_3', false);
                component.set('v.originDealerSelected', null);
                component.set('v.showSpinner', false);

            } else if (component.isValid() && response.getState() === "INCOMPLETE") {
                console.log("[CALLBACK] @H getOriginDealer >> INCOMPLETE -- " + response.getError()[0].message);
            } else if (component.isValid() && response.getState() === "ERROR") {
                console.log("[CALLBACK] @H getOriginDealer >> ERROR -- " + response.getError()[0].message);
            }
        });

        component.set('v.showSpinner', true);
        $A.enqueueAction(getOriginDealer);

        console.log("[END] @H changeTransferDetail");
    },

    changeOriginDealer: function (component) {
        console.log("[START] @H changeOriginDealer");

        var filter = component.get('v.filterOriginWarehouse');
        var originDealerId = component.find('originDealerPicklist').get('v.value');
        var dliIdList = component.get('v.dliIdList');

        var getOriginWarehouse = component.get('c.getOriginWarehouse');
        getOriginWarehouse.setParams({'dliIdList': dliIdList, 'originDealerId': originDealerId, 'filter': filter});
        getOriginWarehouse.setCallback(this, function (response) {
            if (component.isValid() && response.getState() === "SUCCESS") {
                console.log('[CALLBACK] @H getOriginWarehouse >> SUCCESS');

                component.set('v.originWarehouseList', response.getReturnValue());
                component.set('v.summaryTab_3', false);
                component.set('v.originWarehouseSelected', null);
                component.set('v.showSpinner', false);

            } else if (component.isValid() && response.getState() === "INCOMPLETE") {
                console.log("[CALLBACK] @H getOriginWarehouse >> INCOMPLETE -- " + response.getError()[0].message);
            } else if (component.isValid() && response.getState() === "ERROR") {
                console.log("[CALLBACK] @H getOriginWarehouse >> ERROR -- " + response.getError()[0].message);
            }
        });
        component.set('v.showSpinner', true);
        $A.enqueueAction(getOriginWarehouse);

        console.log("[END] @H changeOriginDealer");
    },

    changeOriginWarehouse: function (component) {
        console.log("[START] @H changeOriginWarehouse");

        var filter = component.get('v.filterDestinationDealer');
        var originWarehouseId = component.find('originWarehousePicklist').get('v.value');
        var dliIdList = component.get('v.dliIdList');
        var getDestinationDealer = component.get('c.getDestinationDealer');
        /** [START MOD 24/02/2019 09:55]@Author:marco.lebellini@/webresults.it @Description: **/
        var transferDetailSelected = component.get('v.transferDetailSelected');
        /** [END MOD 24/02/2019 09:55]@Author:marco.lebellini@/webresults.it @Description: **/

        getDestinationDealer.setParams({
            'dliIdList': dliIdList,
            'originWarehouseId': originWarehouseId,
            'filter': filter,
            /** [START MOD 24/02/2019 09:55]@Author:marco.lebellini@/webresults.it @Description: **/
            'transferDetailCode': transferDetailSelected
            /** [END MOD 24/02/2019 09:55]@Author:marco.lebellini@/webresults.it @Description: **/
        });

        getDestinationDealer.setCallback(this, function (response) {
            if (component.isValid() && response.getState() === "SUCCESS") {
                console.log('[CALLBACK] @H getDestinationDealer >> SUCCESS');

                component.set('v.summaryTab_3', true);
                component.set('v.destinationDealerList', response.getReturnValue());
                component.set('v.destinationDealerSelected', null);
                component.set('v.showSpinner', false);

            } else if (component.isValid() && response.getState() === "INCOMPLETE") {
                console.log("[CALLBACK] @H getDestinationDealer >> INCOMPLETE -- " + response.getError()[0].message);
            } else if (component.isValid() && response.getState() === "ERROR") {
                console.log("[CALLBACK] @H getDestinationDealer >> ERROR -- " + response.getError()[0].message);
            }
        });
        component.set('v.showSpinner', true);
        $A.enqueueAction(getDestinationDealer);

        console.log("[END] @H changeOriginWarehouse");
    },

    changeDestinationDealer: function (component) {
        console.log("[START] @H changeDestinationDealer");

        var filter = component.get('v.filterDestinationWarehouse');
        var destinationDealerId = component.find('destinationDealerPicklist').get('v.value');
        var dliIdList = component.get('v.dliIdList');
        var getDestinationWarehouse = component.get('c.getDestinationWarehouse');

        getDestinationWarehouse.setParams({
            'dliIdList': dliIdList,
            'destinationDealerId': destinationDealerId,
            'filter': filter
        });

        getDestinationWarehouse.setCallback(this, function (response) {
            if (component.isValid() && response.getState() === "SUCCESS") {
                console.log('[CALLBACK] @H getDestinationWarehouse >> SUCCESS');

                component.set('v.destinationWarehouseList', response.getReturnValue());
                component.set('v.destinationWarehouseSelected', null);
                component.set('v.showSpinner', false);

            } else if (component.isValid() && response.getState() === "INCOMPLETE") {
                console.log("[CALLBACK] @H getDestinationWarehouse >> INCOMPLETE -- " + response.getError()[0].message);
            } else if (component.isValid() && response.getState() === "ERROR") {
                console.log("[CALLBACK] @H getDestinationWarehouse >> ERROR -- " + response.getError()[0].message);
            }
        });
        component.set('v.showSpinner', true);
        $A.enqueueAction(getDestinationWarehouse);

        console.log("[END] @H changeDestinationDealer");
    },

    changeDestinationWarehouse: function (component) {
        console.log("[START] @H changeDestinationWarehouse");

        component.set('v.originDealerSelected', component.find('originDealerPicklist').get('v.value'));
        component.set('v.originWarehouseSelected', component.find('originWarehousePicklist').get('v.value'));
        component.set('v.destinationDealerSelected', component.find('destinationDealerPicklist').get('v.value'));
        component.set('v.destinationWarehouseSelected', component.find('destinationWarehousePicklist').get('v.value'));
        component.set('v.isNextEnabled', true);

        var originDealerId = component.get('v.originDealerSelected');
        var originWarehouseId = component.get('v.originWarehouseSelected');
        var destinationDealerId = component.get('v.destinationDealerSelected');
        var destinationWarehouseId = component.get('v.destinationWarehouseSelected');

        this.getDliWrapper(component, originDealerId, originWarehouseId, destinationDealerId, destinationWarehouseId);
        console.log("[END] @H changeDestinationWarehouse");
    },

    closePopUpByOk: function (component) {
        console.log("[START] @H closePopUpByOk");
        var selectedRow = component.get('v.selectedRow');
        var dliQuantityList = component.get('v.dliQuantityList');
        var qtToBeSent = parseInt(selectedRow.qtToBeSent);
        var qtStorage = parseInt(selectedRow.qtStorage)

        if (qtToBeSent < component.get('v.selectedQuantity') || qtStorage < component.get('v.selectedQuantity')) {
            component.set('v.showModal', true);
            component.set('v.modalType', 'warning');
            component.set('v.modalMessage', 'Incorrect quantity selected.');
        } else {
            selectedRow.qtSelected = component.get('v.selectedQuantity');

            for (var i = 0; i < dliQuantityList.length; i++) {
                if (dliQuantityList[i].id == selectedRow.id) {
                    dliQuantityList[i].qtSelected = selectedRow.qtSelected;
                }
            }

            component.set('v.selectedRow', selectedRow);
            component.set('v.dliQuantityList', dliQuantityList);
        }
        component.set('v.selectedQuantity', 0);
        console.log("[END] @H closePopUpByOk");
    },

    filterComponent: function (component, event) {

        var actionType = event.getParam('actionType');
        var dliSerialList = component.get('v.dliSerialList');
        var modelList = [];
        var resultsList = event.getParam('searchResultsEvt');
        var arraysList = component.get('v.arraysList');
        var warehouseId = component.get('v.originWarehouseSelected');
        var createSerialWrapperFromResults = component.get('c.createSerialWrapperFromResults');
        var arraysListToAdd = [];
        var _helper = this;

        for (var i = 0; i < dliSerialList.length; i++) {
            modelList.push(dliSerialList[i].model);
        }

        if (actionType == 'applyFilters') {
            createSerialWrapperFromResults.setParams({
                'resultsList': JSON.stringify(resultsList),
                'modelList': modelList,
                'createFromCSV': false,
                'warehouseId': warehouseId
            });

            var stockWrapper;
            var founded = false;

            createSerialWrapperFromResults.setCallback(this, function (response) {
                if (component.isValid() && response.getState() === "SUCCESS") {
                    console.log('success');
                    console.log('response >> ', response.getReturnValue());
                    var searchedText = component.get('v.inputSearch');

                    if (response.getReturnValue() != null && response.getReturnValue().length == 1 && !$A.util.isEmpty(searchedText)
                    && (
                        (!$A.util.isEmpty(response.getReturnValue()[0].nexiSerialNumber) && response.getReturnValue()[0].nexiSerialNumber.toUpperCase() == searchedText)
                        || (!$A.util.isEmpty(response.getReturnValue()[0].manufacturerSerialNumber) && response.getReturnValue()[0].manufacturerSerialNumber.toUpperCase() == searchedText)
                        || (!$A.util.isEmpty(response.getReturnValue()[0].dllSerialNumber) && response.getReturnValue()[0].dllSerialNumber.toUpperCase() == searchedText)
                    )
                    ) {
                        component.set('v.inputSearch', '');
                        stockWrapper = response.getReturnValue()[0];
                        founded = false;
                        for (var i = 0; i < arraysList.length; i++) {
                            var dliSerial = arraysList[i][0];

                            for (var x = 0; x < dliSerial.stockSerialWrapperList.length; x++) {
                                if (dliSerial.stockSerialWrapperList[x].id == stockWrapper.id) {
                                    founded = true;
                                }
                            }
                        }

                        if (founded) {
                            component.set('v.showModal', true);
                            component.set('v.modalType', 'warning');
                            component.set('v.modalMessage', $A.get('$Label.c.Plc_SerialNumberAlreadyEntered'));
                        } else {
                            component.set('v.stockSerialWrapperList', response.getReturnValue());
                            _helper.changeStockSerialWrapperList(component, stockWrapper);
                        }

                    } else if (response.getReturnValue() != null && response.getReturnValue().length > 1) {
                        component.set('v.showModal', true);
                        component.set('v.modalType', 'error');
                        component.set('v.modalMessage', $A.get('$Label.c.Plc_EnterUniqueSerialNumber'));
                    } else {
                        component.set('v.showModal', true);
                        component.set('v.modalType', 'error');
                        component.set('v.modalMessage', $A.get('$Label.c.Plc_NoStockSerialFounded'));
                    }
                    component.set('v.showSpinner', false);

                } else if (component.isValid() && response.getState() === "INCOMPLETE") {
                    console.log("[CALLBACK] @H filterComponent >> INCOMPLETE -- " + response.getError()[0].message);
                } else if (component.isValid() && response.getState() === "ERROR") {
                    console.log("[CALLBACK] @H filterComponent >> ERROR -- " + response.getError()[0].message);
                }
            });
            component.set('v.showSpinner', true);
            $A.enqueueAction(createSerialWrapperFromResults);

        } else if (actionType == 'sendCsvResults') {
            createSerialWrapperFromResults.setParams({
                'resultsList': JSON.stringify({"stockSerialFromCSV": resultsList.stockSerialFromCSV}),
                'modelList': modelList,
                'createFromCSV': true
            });
            createSerialWrapperFromResults.setCallback(this, function (response) {
                if (component.isValid() && response.getState() === "SUCCESS") {
                    console.log('success');
                    if (response.getReturnValue() != null && response.getReturnValue().length > 0) {
                        var stockSerialWrapperList = response.getReturnValue();

                        for (var x = 0; x < stockSerialWrapperList.length; x++) {
                            for (var i = 0; i < arraysList.length; i++) {
                                var dliSerial = arraysList[i][0];
                                var founded = false;
                                for (var y = 0; y < dliSerial.stockSerialWrapperList.length; y++) {
                                    console.log('dliSerial.stockSerialWrapperList[y].id >> ' + dliSerial.stockSerialWrapperList[y].id);
                                    console.log('stockSerialWrapperList[x].id >> ' + stockSerialWrapperList[x].id);
                                    if (dliSerial.stockSerialWrapperList[y].id == stockSerialWrapperList[x].id) {
                                        founded = true;
                                    }
                                }
                                if (founded == false) {
                                    arraysListToAdd.push(stockSerialWrapperList[x]);
                                    break;
                                } else {
                                    component.set('v.showModal', true);
                                    component.set('v.modalType', 'error');
                                    component.set('v.modalMessage', $A.get('$Label.c.Plc_NotAllStockSerialInserted'));
                                }
                            }
                        }

                        console.log('arraysListToAdd >> ', arraysListToAdd);
                        component.set('v.stockSerialWrapperList', arraysListToAdd);
                        _helper.changeStockSerialWrapperList(component, null);
                    } else {
                        component.set('v.showModal', true);
                        component.set('v.modalType', 'error');
                        component.set('v.modalMessage', $A.get('$Label.c.Plc_NoStockSerialFoundedRelated'));
                    }
                    component.set('v.showSpinner', false);

                } else if (component.isValid() && response.getState() === "INCOMPLETE") {
                    console.log("[CALLBACK] @H filterComponent >> INCOMPLETE -- " + response.getError()[0].message);
                } else if (component.isValid() && response.getState() === "ERROR") {
                    console.log("[CALLBACK] @H filterComponent >> ERROR -- " + response.getError()[0].message);
                }
            });
            component.set('v.showSpinner', true);
            $A.enqueueAction(createSerialWrapperFromResults);
        }
        console.log("[END] @H filterComponent");
    },

    changeStockSerialWrapperList: function (component, stockWrapper) {
        console.log("[START] @H changeStockSerialWrapperList");

        var stockSerialWrapperList = component.get('v.stockSerialWrapperList');
        console.log('stockSerialWrapperList >> ' + JSON.stringify(stockSerialWrapperList));
        var arraysList = component.get('v.arraysList');

        //component.set('v.isSaveEnabled', false);

        for (var x = 0; x < arraysList.length; x++) {
            var dliSerial = arraysList[x][0];
            console.log('dliSerial >> ', dliSerial);
            console.log("***********ARRAY LIST: "+JSON.stringify(arraysList));
            for (var i = 0; i < stockSerialWrapperList.length; i++) {
                if (stockSerialWrapperList[i].model == dliSerial.model && stockSerialWrapperList[i].productStockId == dliSerial.productStockId && stockSerialWrapperList[i].pushed != true && dliSerial.isFull != true) {

                    dliSerial.stockSerialWrapperList.push(stockSerialWrapperList[i]);
                    stockSerialWrapperList[i].pushed = true;
                    dliSerial.qtSelected = dliSerial.stockSerialWrapperList.length.toString();

                    if (Number(dliSerial.qtSelected) > Number(dliSerial.qtToBeSent) || Number(dliSerial.qtSelected) > Number(dliSerial.qtStorage)) {
                        component.set('v.showModal', true);
                        component.set('v.modalType', 'error');
                        component.set('v.modalMessage', $A.get('$Label.c.Plc_MaxQtyToBeSentReached'));

                        var index = dliSerial.stockSerialWrapperList.length - 1;
                        dliSerial.stockSerialWrapperList.splice(index, 1);
                        dliSerial.qtSelected = dliSerial.stockSerialWrapperList.length.toString();
                    }

                    if (Number(dliSerial.qtSelected) > 0) {
                        component.set('v.isSaveEnabled', true);
                    }

                    if (dliSerial.qtSelected == dliSerial.qtToBeSent) {
                        dliSerial.isFull = true;
                        break;
                    } else {
                        dliSerial.isFull = false;
                    }
                }
            }

            component.set('v.stockSerialWrapperList', stockSerialWrapperList);
            component.set('v.arraysList', arraysList);
        }

        if (stockWrapper != null) {
            console.log('stockWrapper >> ' + JSON.stringify(stockWrapper));
            var inserted = false;
            for (var i = 0; i < component.get('v.arraysList').length; i++) {
                var dliSerial = component.get('v.arraysList')[i][0];

                if (dliSerial.stockSerialWrapperList != null) {
                    for (var x = 0; x < dliSerial.stockSerialWrapperList.length; x++) {
                        var stockSerial = dliSerial.stockSerialWrapperList[x];
                        console.log('prova');
                        if (stockWrapper.id == stockSerial.id) {
                            inserted = true;
                        }
                    }
                }
            }

            if (inserted == false) {
                component.set('v.showModal', true);
                component.set('v.modalType', 'error');
                component.set('v.modalMessage', $A.get('$Label.c.Plc_MaxQtyToBeSentReached'));
            }
        }

        console.log("[END] @H changeStockSerialWrapperList");
    },

    removeStockSerial: function (component, event) {
        console.log("[START] @H removeStockSerial");

        var stockSerial = event.getParam("row");
        var arraysList = component.get('v.arraysList');

        for (var i = 0; i < arraysList.length; i++) {
            var dliSerial = arraysList[i][0];
            for (var x = 0; x < dliSerial.stockSerialWrapperList.length; x++) {
                if (dliSerial.stockSerialWrapperList[x].id == stockSerial.id) {
                    dliSerial.stockSerialWrapperList.splice(x, 1);
                    dliSerial.qtSelected = dliSerial.stockSerialWrapperList.length.toString();
                }
            }
        }
        component.set('v.arraysList', arraysList);
        console.log("[END] @H removeStockSerial");
    },

    save: function (component) {
        console.log("[START] @H save");

        var arraysList = component.get('v.arraysList');
        var transferDetailSelected = component.get('v.transferDetailSelected');
        var originalTransferDetailSelected = component.get('v.originalTransferDetailSelected');
        var originWarehouseSelected = component.get('v.originWarehouseSelected');
        var destinationWarehouseSelected = component.get('v.destinationWarehouseSelected');
        var destinationDealerSelected = component.get('v.destinationDealerSelected');
        var originDealerSelected = component.get('v.originDealerSelected');
        var dliQuantiyList = component.get('v.dliQuantityList');
        var distributionListId = component.get('v.distributionListId');
        var dliSerialList = [];
        var stockOrderId = component.get('v.stockOrderId');
        var note = component.get('v.note');

        for (var i = 0; i < arraysList.length; i++) {
            dliSerialList.push(arraysList[i][0]);
        }

        var save = component.get('c.save');

        save.setParams({
            'transferDetailSelected': transferDetailSelected,
            'originWarehouseSelected': originWarehouseSelected,
            'destinationWarehouseSelected': destinationWarehouseSelected,
            'destinationDealerSelected': destinationDealerSelected,
            'originDealerSelected': originDealerSelected,
            'objQuantityList': JSON.stringify(dliQuantiyList),
            'objSerialList': JSON.stringify(dliSerialList),
            'note': note,
            'distributionListId': distributionListId,
            'stockOrderId': stockOrderId,
            'originalTransferDetailSelected': originalTransferDetailSelected
        });

        save.setCallback(this, function (response) {
            if (component.isValid() && response.getState() === "SUCCESS") {
                if (response.getReturnValue() != null) {
                    console.log('[CALLBACK] @H save >> SUCCESS');
                    component.set('v.modalMessage', $A.get('$Label.c.Plc_succeededSaveMessage'));
                    component.set('v.modalType', 'success');
                    component.set('v.showModal', true);
                    component.set('v.stockOrderId', response.getReturnValue());
                } else {
                    component.set('v.modalMessage', $A.get('$Label.c.Plc_AnErrorHasOccured'));
                    component.set('v.modalType', 'error');
                    component.set('v.showModal', true);
                }
                component.set('v.showSpinner', false);
            } else if (component.isValid() && response.getState() === "INCOMPLETE") {
                console.log("[CALLBACK] @H save >> INCOMPLETE -- " + response.getError()[0].message);
            } else if (component.isValid() && response.getState() === "ERROR") {
                console.log("[CALLBACK] @H save >> ERROR -- " + response.getError()[0].message);
            }
        });
        component.set('v.showSpinner', true);
        $A.enqueueAction(save);

        console.log("[END] @H save");
    },

    redirectToPageObject: function (component) {
        console.log("[START] @H redirectToPageObject");

        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.stockOrderId"),
            "slideDevName": "related"
        });
        navEvt.fire();

        console.log("[END] @H redirectToPageObject");
    },

    changeDliQuantityList: function (component) {
        console.log("[START] @H changeDliQuantityList");

        component.set('v.isSaveEnabled', false);

        var dliQuantityList = component.get('v.dliQuantityList');

        for (var i = 0; i < dliQuantityList.length; i++) {
            if (Number(dliQuantityList[i].qtSelected) > 0) {
                component.set('v.isSaveEnabled', true);
            }
        }

        console.log("[END] @H changeDliQuantityList");
    },

    changePicklistSelection: function (component) {
        console.log("[START] @H changePicklistSelection");

        if (!component.get('v.transferDetailSelected') || component.get('v.transferDetailSelected') == '') {
            component.set('v.originDealerSelected', null);
            component.set('v.summaryTab_2', false);
            component.set('v.summaryTab_3', false);
        } else {
            component.set('v.summaryTab_2', true);
        }

        if (!component.get('v.originDealerSelected')) {
            component.set('v.originWarehouseSelected', null);
        }

        if (!component.get('v.originWarehouseSelected')) {
            component.set('v.destinationDealerSelected', null);
            component.set('v.summaryTab_3', false);
        } else {
            component.set('v.summaryTab_3', true);
        }

        if (!component.get('v.destinationDealerSelected')) {
            component.set('v.destinationWarehouseSelected', null);
        }

        if (!component.get('v.destinationWarehouseSelected')) {
            component.set('v.isNextEnabled', false);
        } else {
            component.set('v.isNextEnabled', true);
        }

        console.log("[END] @H changePicklistSelection");
    },

    changeVisibility: function (component, event) {
        console.log("[START] @H changeVisibility");

        var eventValue = event.getSource().get("v.value");
        var arraysList = component.get('v.arraysList');

        console.log('eventValue >> ' + JSON.stringify(eventValue));
        console.log('arraysList >> ', arraysList);

        if (arraysList) {
            for (var i = 0; i < arraysList.length; i++) {
                var dliSerial = arraysList[i][0];

                if (eventValue == dliSerial.id) {
                    dliSerial.isExpanded = !dliSerial.isExpanded;
                }
            }
            component.set('v.arraysList', arraysList);
        }

        console.log("[END] @H changeVisibility");
    },

    setDliModelsForFilterCmp: function (component) {
        console.log("[START] @H setDliModelsForFilterCmp");

        var dliSerialList = component.get('v.dliSerialList');
        var models = '';

        for (var i = 0; i < dliSerialList.length; i++) {
            models += dliSerialList[i].model + ';';
        }

        component.set('v.distributionListItemModels', models);

        console.log("[END] @H setDliModelsForFilterCmp");
    },

    initializeData: function (component) {
        console.log("[START] @H initializeData");

        var initialize = component.get('c.initialize');

        initialize.setParams({'distributionListId': component.get('v.distributionListId')});
        initialize.setCallback(this, function (response) {
            if (component.isValid() && response.getState() === "SUCCESS") {
                console.log('[CALLBACK] @H initialize >> SUCCESS');

                component.set('v.dliIdList', response.getReturnValue().dliIdList);
                component.set('v.transferDetailsList', response.getReturnValue().transferDetailsList);
                component.set('v.distributionListName', response.getReturnValue().distributionListName);

                var title = $A.get('$Label.c.Plc_ManufacturerGoodsHandling') + ' -- ' + component.get('v.distributionListName');
                component.set('v.title', title);
                component.set('v.showSpinner', false);

            } else if (component.isValid() && response.getState() === "INCOMPLETE") {
                console.log("[CALLBACK] @H initialize >> INCOMPLETE -- " + response.getError()[0].message);
            } else if (component.isValid() && response.getState() === "ERROR") {
                console.log("[CALLBACK] @H initialize >> ERROR -- " + response.getError()[0].message);
            }
        });

        component.set('v.showSpinner', true);

        $A.enqueueAction(initialize);

        console.log("[END] @H initializeData");
    },

    loadDataForEdit: function (component) {
        console.log("[START] @H loadDataForEdit");

        var _helper = this;
        var loadDataForEdit = component.get('c.loadDataForEdit');

        loadDataForEdit.setParams({'stockOrderId': component.get('v.stockOrderId')});
        loadDataForEdit.setCallback(this, function (response) {
            if (component.isValid() && response.getState() === "SUCCESS") {
                console.log('[CALLBACK] @H loadDataForEdit >> SUCCESS');

                if (response.getReturnValue() != null) {

                    component.set('v.destinationWarehouseSelected', response.getReturnValue().destinationWarehouseSelected);
                    component.set('v.destinationDealerSelected', response.getReturnValue().destinationDealerSelected);
                    component.set('v.originWarehouseSelected', response.getReturnValue().originWarehouseSelected);
                    component.set('v.originDealerSelected', response.getReturnValue().originDealerSelected);
                    component.set('v.transferDetailSelected', response.getReturnValue().transferDetailSelected);
                    component.set('v.originalTransferDetailSelected', response.getReturnValue().originalTransferDetailSelected);

                    component.set('v.destinationWarehouseSelectedId', response.getReturnValue().destinationWarehouseSelectedId);
                    component.set('v.destinationDealerSelectedId', response.getReturnValue().destinationDealerSelectedId);
                    component.set('v.originWarehouseSelectedId', response.getReturnValue().originWarehouseSelectedId);
                    component.set('v.originDealerSelectedId', response.getReturnValue().originDealerSelectedId);

                    component.set('v.distributionListId', response.getReturnValue().distributionListId);
                    component.set('v.distributionListName', response.getReturnValue().distributionListName);

                    console.log('dealerId >> ' + component.get('v.destinationDealerSelectedId'));

                    var originDealerId = component.get('v.originDealerSelectedId');
                    var originWarehouseId = component.get('v.originWarehouseSelectedId');
                    var destinationDealerId = component.get('v.destinationDealerSelectedId');
                    var destinationWarehouseId = component.get('v.destinationWarehouseSelectedId');

                    _helper.getDliWrapper(component, originDealerId, originWarehouseId, destinationDealerId, destinationWarehouseId);
                    //component.set('v.dliSerialList', response.getReturnValue().dliSerialList);
                    //component.set('v.dliQuantityList', response.getReturnValue().dliQuantityList);

                    console.log('editWizard >> ' + component.get('v.editWizard'));
                    console.log('dliSerialList >> ' + JSON.stringify(component.get('v.dliSerialList')));

                    /*var dliSerialListReturned = response.getReturnValue().dliSerialList;
                    var dliSerialList = [];
                    var tmpList = [];
                    var arraysList = [];

                    for (var i = 0; i < dliSerialListReturned.length; i++) {
                        dliSerialList.push(dliSerialListReturned[i]);
                        tmpList.push(dliSerialListReturned[i]);
                        arraysList.push(tmpList);
                        tmpList = [];
                    }

                    component.set('v.arraysList', arraysList);*/
                    var title = $A.get('$Label.c.Plc_ManufacturerGoodsHandling') + ' -- ' + component.get('v.distributionListName');
                    component.set('v.title', title);
                    component.set('v.isSaveVisible', true);
                    component.set('v.isNextVisible', false);
                    component.set('v.summaryTab_2', true);
                    component.set('v.summaryTab_3', true);
                    component.set('v.shipmentTab', true);

                }
                component.set('v.showSpinner', false);

            } else if (component.isValid() && response.getState() === "INCOMPLETE") {
                console.log("[CALLBACK] @H loadDataForEdit >> INCOMPLETE -- " + response.getError()[0].message);
            } else if (component.isValid() && response.getState() === "ERROR") {
                console.log("[CALLBACK] @H loadDataForEdit >> ERROR -- " + response.getError()[0].message);
            }
        });

        component.set('v.showSpinner', true);
        $A.enqueueAction(loadDataForEdit);

        console.log("[END] @H loadDataForEdit");
    },

    feedWrappers: function (component) {
        console.log("[START] @H feedWrappers");

        var _helper = this;
        var feedWrappers = component.get('c.feedWrappers');
        var dliQuantityList = component.get('v.dliQuantityList');
        var dliSerialList = component.get('v.dliSerialList');

        feedWrappers.setParams({
            'stockOrderId': component.get('v.stockOrderId'),
            'objQuantityList': JSON.stringify(dliQuantityList),
            'objSerialList': JSON.stringify(dliSerialList)
        });

        feedWrappers.setCallback(this, function (response) {
            if (component.isValid() && response.getState() === "SUCCESS") {
                console.log('[CALLBACK] @H feedWrappers >> SUCCESS');

                if (response.getReturnValue() != null) {
                    component.set('v.dliQuantityList', response.getReturnValue().dliQuantityList);
                    component.set('v.dliSerialList', response.getReturnValue().dliSerialList);

                    var dliSerialListReturned = response.getReturnValue().dliSerialList;
                    var dliSerialList = [];
                    var tmpList = [];
                    var arraysList = [];

                    for (var i = 0; i < dliSerialListReturned.length; i++) {
                        dliSerialList.push(dliSerialListReturned[i]);
                        tmpList.push(dliSerialListReturned[i]);
                        arraysList.push(tmpList);
                        tmpList = [];
                    }

                    component.set('v.arraysList', arraysList);

                    console.log('dliQuantityList >> ' + JSON.stringify(component.get('v.dliQuantityList')));
                    console.log('dliSerialList >> ' + JSON.stringify(component.get('v.dliSerialList')));
                    console.log('arraysList >> ' + JSON.stringify(component.get('v.arraysList')));
                }

                component.set('v.showSpinner', false);

            } else if (component.isValid() && response.getState() === "INCOMPLETE") {
                console.log("[CALLBACK] @H feedWrappers >> INCOMPLETE -- " + response.getError()[0].message);
            } else if (component.isValid() && response.getState() === "ERROR") {
                console.log("[CALLBACK] @H feedWrappers >> ERROR -- " + response.getError()[0].message);
            }
        });

        component.set('v.showSpinner', true);
        $A.enqueueAction(feedWrappers);

        console.log("[END] @H feedWrappers");
    },

    getDliWrapper: function (component, originDealerId, originWarehouseId, destinationDealerId, destinationWarehouseId) {
        var _helper = this;
        var getDliWrapper = component.get('c.getDliWrapper');

        getDliWrapper.setParams({
            'originDealerId': originDealerId,
            'originWarehouseId': originWarehouseId,
            'destinationDealerId': destinationDealerId,
            'destinationWarehouseId': destinationWarehouseId,
            'distributionListId': component.get('v.distributionListId')
        });

        getDliWrapper.setCallback(this, function (response) {
            if (component.isValid() && response.getState() === "SUCCESS") {
                console.log('[CALLBACK] @H getDliWrapper >> SUCCESS');
                console.log('response >> ' + JSON.stringify(response.getReturnValue()));

                if (response.getReturnValue() != null && response.getReturnValue().length > 0) {
                    var returnValueList = response.getReturnValue();
                    var dliQuantityList = [];
                    var dliSerialList = [];
                    var tmpList = [];
                    var arraysList = [];

                    for (var i = 0; i < returnValueList.length; i++) {
                        if (returnValueList[i].serialRequired == true) {
                            dliSerialList.push(returnValueList[i]);
                            tmpList.push(returnValueList[i]);
                            arraysList.push(tmpList);
                            tmpList = [];
                        } else {
                            dliQuantityList.push(returnValueList[i]);
                        }
                    }

                    component.set('v.arraysList', arraysList);
                    component.set('v.dliSerialList', dliSerialList);
                    component.set('v.dliQuantityList', dliQuantityList);

                    _helper.setDliModelsForFilterCmp(component);

                    if (component.get('v.editWizard') == true) {
                        _helper.feedWrappers(component);
                    }
                } else {
                    component.set('v.modalMessage', $A.get('$Label.c.Plc_NoProductStockRelatedToDL'));
                    component.set('v.modalType', 'error');
                    component.set('v.showModal', true);
                }

                component.set('v.showSpinner', false);

            } else if (component.isValid() && response.getState() === "INCOMPLETE") {
                console.log("[CALLBACK] @H getDliWrapper >> INCOMPLETE -- " + response.getError()[0].message);
            } else if (component.isValid() && response.getState() === "ERROR") {
                console.log("[CALLBACK] @H getDliWrapper >> ERROR -- " + response.getError()[0].message);
            }
        });
        component.set('v.showSpinner', true);
        $A.enqueueAction(getDliWrapper);
    }
})