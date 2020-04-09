/**
 * Created by lebellini on 31/01/2019.
 */
({

    initializeData: function (component, helper) {

        console.log("[START] Helper --> initilizeData");

        component.set('v.availableGoodsGridColumns', [
            {
                label: $A.get('$Label.c.Plc_Accept'), type: 'button', initialWidth: 77, typeAttributes:
                    {
                        label: {fieldName: 'actionLabel'},
                        title: $A.get('$Label.c.Plc_AcceptGood'),
                        name: 'acceptGood',
                        iconName: 'action:approval',
                        disabled: {fieldName: 'actionDisabled'},
                        class: 'btn_next'
                    }
            },
            {
                label: $A.get('$Label.c.Plc_Reject'), type: 'button', initialWidth: 77, typeAttributes:
                    {
                        label: {fieldName: 'actionLabel'},
                        title: $A.get('$Label.c.Plc_RejectGood'),
                        name: 'rejectGood',
                        iconName: 'action:close',
                        disabled: {fieldName: 'actionDisabled'}
                    }
            },
            {label: $A.get('$Label.c.Plc_AvailableQt'), fieldName: 'availableQuantity', type: 'text'},
            // {label: $A.get('$Label.c.Plc_CatalogName'), fieldName: 'catalogName', type: 'text'},
            {label: $A.get('$Label.c.Plc_ProductSku'), fieldName: 'productSKU', type: 'text'},
            {label: $A.get('$Label.c.Plc_Model'), fieldName: 'model', type: 'text',},
            // {label: $A.get('$Label.c.Plc_Manufacturer'), fieldName: 'manufacturer', type: 'text'},
            {label: $A.get('$Label.c.Plc_NexiSerialNumber'), fieldName: 'encodedSerialNumber', type: 'text'},
            {
                label: $A.get('$Label.c.Plc_ManufacturerSerialNumber'),
                fieldName: 'manufacturerSerialNumber',
                type: 'text'
            }
            // {label: $A.get('$Label.c.Plc_DllSerialNumber'), fieldName: 'dllSerialNumber', type: 'text'}
        ]);

        component.set('v.acceptedGoodsGridColumns', [
            {
                label: $A.get('$Label.c.Plc_Undo'), type: 'button', initialWidth: 77, typeAttributes:
                    {
                        label: {fieldName: 'actionLabel'},
                        title: $A.get('$Label.c.Plc_UndoAcceptance'),
                        name: 'undo',
                        iconName: 'action:lead_convert',
                        disabled: {fieldName: 'actionDisabled'},
                        class: 'btn_next'
                    }
            },
            {label: $A.get('$Label.c.Plc_QuantitySelection'), fieldName: 'selectedQuantity', type: 'text'},
            {label: $A.get('$Label.c.Plc_ReceivedQt'), fieldName: 'acceptedQuantity', type: 'text'},
            // {label: $A.get('$Label.c.Plc_CatalogName'), fieldName: 'catalogName', type: 'text'},
            {label: $A.get('$Label.c.Plc_ProductSku'), fieldName: 'productSKU', type: 'text'},
            {label: $A.get('$Label.c.Plc_Model'), fieldName: 'model', type: 'text',},
            // {label: $A.get('$Label.c.Plc_Manufacturer'), fieldName: 'manufacturer', type: 'text'},
            {label: $A.get('$Label.c.Plc_NexiSerialNumber'), fieldName: 'encodedSerialNumber', type: 'text'},
            {
                label: $A.get('$Label.c.Plc_ManufacturerSerialNumber'),
                fieldName: 'manufacturerSerialNumber',
                type: 'text'
            }
            // {label: $A.get('$Label.c.Plc_DllSerialNumber'), fieldName: 'dllSerialNumber', type: 'text'}
        ]);

        component.set('v.rejectedGoodsGridColumns', [
            {
                label: $A.get('$Label.c.Plc_Undo'), type: 'button', initialWidth: 77, typeAttributes:
                    {
                        label: {fieldName: 'actionLabel'},
                        title: $A.get('$Label.c.Plc_UndoAcceptance'),
                        name: 'undo',
                        iconName: 'action:lead_convert',
                        disabled: {fieldName: 'actionDisabled'},
                        class: 'btn_next'
                    }
            },
            {label: $A.get('$Label.c.Plc_QuantitySelection'), fieldName: 'selectedQuantity', type: 'text'},
            {label: $A.get('$Label.c.Plc_NotReceivedQt'), fieldName: 'rejectedQuantity', type: 'text'},
            // {label: $A.get('$Label.c.Plc_CatalogName'), fieldName: 'catalogName', type: 'text'},
            {label: $A.get('$Label.c.Plc_ProductSku'), fieldName: 'productSKU', type: 'text'},
            {label: $A.get('$Label.c.Plc_Model'), fieldName: 'model', type: 'text',},
            // {label: $A.get('$Label.c.Plc_Manufacturer'), fieldName: 'manufacturer', type: 'text'},
            {label: $A.get('$Label.c.Plc_NexiSerialNumber'), fieldName: 'encodedSerialNumber', type: 'text'},
            {
                label: $A.get('$Label.c.Plc_ManufacturerSerialNumber'),
                fieldName: 'manufacturerSerialNumber',
                type: 'text'
            }
            // {label: $A.get('$Label.c.Plc_DllSerialNumber'), fieldName: 'dllSerialNumber', type: 'text'}
        ]);

        var objectId = component.get('v.objectId');

        var initializeMethod = component.get("c.initData");
        console.log('init data objectId' + objectId);

        initializeMethod.setParams({'objectId': objectId});

        initializeMethod.setCallback(this, function (response) {
            if (component.isValid() && response.getState() === "SUCCESS") {
                console.log('[CALLBACK] H init >> SUCCESS');

                var sliIdsList = response.getReturnValue().idsList;
                var queryFilterForStockSerials = response.getReturnValue().queryFilterForStockSerials;
                var queryFilterForProductStock = response.getReturnValue().queryFilterForProductStocks;
                var sourceWH = response.getReturnValue().sourceWH;
                var sourceDealer = response.getReturnValue().sourceDealer;
                var transferDetail = response.getReturnValue().transferDetail;
                var sourceShipment = response.getReturnValue().sourceShipment;
                var wizardTitle = response.getReturnValue().wizardTitle;
                /** [START MOD 05/03/2019 17:20]@Author:nunzio.capasso@/webresults.it @Description: hide "no data found" popup when process is in read-only mode **/
                var stockOrderStatus = response.getReturnValue().stockOrderStatus;
                component.set('v.stockOrderStatus', stockOrderStatus);
                console.log('@@@@@stockOrderStatus: ', stockOrderStatus);
                /** [END MOD 05/03/2019 17:20]@Author:nunzio.capasso@/webresults.it @Description: hide "no data found" popup when process is in read-only mode **/

                //TODO
                component.set('v.queryFilterForStockSerials', queryFilterForStockSerials);
                component.set('v.queryFilterForProductStock', queryFilterForProductStock);
                component.set('v.title', wizardTitle);

                console.log('sliIdsList >> ' + sliIdsList);
                console.log('queryFilterForStockSerials >> ' + queryFilterForStockSerials);
                console.log('queryFilterForProductStock >> ' + queryFilterForProductStock);

                var configurationMap = {};

                if (queryFilterForStockSerials != '' && queryFilterForProductStock != '') {
                    configurationMap = {
                        'SLI_StockSerials': queryFilterForStockSerials,
                        'SLI_ProductStocks': queryFilterForProductStock
                    };
                } else if (queryFilterForStockSerials != '') {
                    configurationMap = {
                        'SLI_StockSerials': queryFilterForStockSerials
                    };
                } else if (queryFilterForProductStock != '') {
                    configurationMap = {
                        'SLI_ProductStocks': queryFilterForProductStock
                    };
                }

                console.log('configurationMap --> ', configurationMap);

                component.set('v.columns', response.getReturnValue().dataGridsColumns);
                component.set('v.searchConfigurationMap', configurationMap);
                component.set('v.sourceWH', sourceWH);
                component.set('v.sourceDealer', sourceDealer);
                component.set('v.transferDetail', transferDetail);
                component.set('v.sourceShipment', sourceShipment);

                //FB 14-06-2019: Optimizing performance on init [START]
                // component.set('v.searchOnLoad', true); 
                component.set('v.filterResult', {});
                component.set('v.filterResult.SLI_StockSerials', response.getReturnValue().sliStockSerials);
                component.set('v.filterResult.SLI_ProductStocks', response.getReturnValue().sliProductStocks);

                let availableGoods = [];
                let acceptedGoods = [];
                let rejectedGoods = [];

                console.log('### ' + response.getReturnValue().sliStockSerials);

                response.getReturnValue().sliStockSerials.forEach(function(sli) {
                    let requestedQt = sli.Bit2Shop__Requested_Quantity__c != null ? sli.Bit2Shop__Requested_Quantity__c : 1;
                    let receivedQt = sli.Bit2Shop__Received_Quantity__c != null ? sli.Bit2Shop__Received_Quantity__c : 0;
                    let notReceivedQt = sli.Plc_NotReceivedQty__c != null ? sli.Plc_NotReceivedQty__c : 0;
                    let availableQt = requestedQt - receivedQt - notReceivedQt;

                    let row = {
                        sliId: sli.Id,
                        goodId: sli.Plc_StockSerial__c,
                        status: sli.Bit2Shop__Status__c,
                        productSKU: sli.Plc_StockSerial__r.Plc_ProductSku__c,
                        model: sli.Plc_StockSerial__r.Plc_Model__c,
                        // catalogName: sli.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c,
                        // manufacturer: sli.Plc_StockSerial__r.Plc_Manufacturer__c,
                        encodedSerialNumber: sli.Plc_StockSerial__r.Plc_EncodedSerialNumber__c,
                        manufacturerSerialNumber: sli.Plc_StockSerial__r.Plc_ManufacturerSerialNumber__c,
                        // dllSerialNumber: sli.Plc_StockSerial__r.Plc_DllSerialNumber__c,
                        requestedQuantity: requestedQt +'',
                        availableQuantity: availableQt +'',
                        acceptedQuantity : receivedQt +'',
                        rejectedQuantity : notReceivedQt +'',
                        requestedQuantity: requestedQt +'',
                        closed: sli.Bit2Shop__Status__c == 'Closed'
                    }

                    if (availableQt > 0) {
                        row.locked = false;
                        row.selectedQuantity = '1';
                        availableGoods.push(row);
                    }

                    if (receivedQt > 0) {
                        row.locked = true;
                        row.selectedQuantity = '0';
                        acceptedGoods.push(row);
                    }

                    if (notReceivedQt > 0) {
                        row.locked = true;
                        row.selectedQuantity = '0';
                        rejectedGoods.push(row);
                    }

                });

                component.set('v.availableGoods', availableGoods);

                if ($A.util.isEmpty(availableGoods) && component.get('v.dataLoaded')
                    /** [START MOD 05/03/2019 17:20]@Author:nunzio.capasso@/webresults.it @Description: hide "no data found" popup when process is in read-only mode **/
                    && component.get('v.stockOrderStatus') != 'Closed')
                /** [END MOD 05/03/2019 17:20]@Author:nunzio.capasso@/webresults.it @Description: hide "no data found" popup when process is in read-only mode **/
                {
                    this.displayPopup(component, 'noDataFound', null);
                }

                if (!component.get('v.dataLoaded')) {
                    component.set('v.acceptedGoods', acceptedGoods);
                    component.set('v.rejectedGoods', rejectedGoods);
                    component.set('v.dataLoaded', true);
                }

                //FB 14-06-2019: Optimizing performance on init [END]
                
                console.log('searchOnLoad set to >> ' + component.get('v.searchOnLoad'));

                //FB 22-08-2019: NEXIPLC-673 [START]
                component.set('v.showAcceptAllButton', response.getReturnValue().Plc_GoodsRecevingAcceptAll);
                //FB 22-08-2019: NEXIPLC-673 [END]

                //FB 20191203 NEXIPLC-742 [START]
                component.set('v.showTableSpinner', false);
                //FB 20191203 NEXIPLC-742 [END]
                
            } else if (component.isValid() && response.getState() === "INCOMPLETE") {

                console.log("[CALLBACK] H init >> INCOMPLETE -- " + response.getError()[0].message);
            } else if (component.isValid() && response.getState() === "ERROR") {

                console.log("[CALLBACK] H init >> ERROR -- " + response.getError()[0].message);
            }
        });

        $A.enqueueAction(initializeMethod);
        console.log("[END] Helper --> initializeData");
    },

    feedGoodsDataOnTables: function (component) {
        console.log("[START] Helper --> feedGoodsDataOnTables");

        var searchResult = component.get('v.filterResult');

        var shipmentStockSerials = searchResult['SLI_StockSerials'];
        var shipmentProductStocks = searchResult['SLI_ProductStocks'];
        var availableGoods = component.get('v.availableGoods');
        var acceptedGoods = component.get('v.acceptedGoods');
        var rejectedGoods = component.get('v.rejectedGoods');

        console.log('SLI_StockSerials --> ', shipmentStockSerials);
        console.log('SLI_ProductStocks --> ', shipmentProductStocks);
        console.log('availableGoods --> ', availableGoods);

        var saveMethod = component.get("c.fetchDataForTables");

        saveMethod.setParams({
            'shipmentStockSerials': JSON.stringify(shipmentStockSerials),
            'shipmentProductStocks': JSON.stringify(shipmentProductStocks),
            'availableGoodsFromWizard': JSON.stringify(availableGoods),
            'acceptedGoodsFromWizard': JSON.stringify(acceptedGoods),
            'rejectedGoodsFromWizard': JSON.stringify(rejectedGoods)
        });

        saveMethod.setCallback(this, function (response) {
            var productSerial = [];
            if (component.isValid() && response.getState() === "SUCCESS") {
                console.log('[CALLBACK] from fetchDataForTables >> SUCCESS');
                var valueLabel = component.get('v.availableGoodsQuantity');
                if (valueLabel == 1) {
                    component.set('v.skipCheck', true);
                }
                

                var availableGoods = response.getReturnValue().availableGoods;
                var acceptedGoods = response.getReturnValue().acceptedGoods;
                var rejectedGoods = response.getReturnValue().rejectedGoods;

                console.log('availableGoods --> ', availableGoods);
                console.log('acceptedGoods --> ', acceptedGoods);
                console.log('rejectedGoods --> ', rejectedGoods);

                component.set('v.availableGoods', availableGoods);

                if ($A.util.isEmpty(availableGoods) && component.get('v.dataLoaded')
                    /** [START MOD 05/03/2019 17:20]@Author:nunzio.capasso@/webresults.it @Description: hide "no data found" popup when process is in read-only mode **/
                    && component.get('v.stockOrderStatus') != 'Closed')
                /** [END MOD 05/03/2019 17:20]@Author:nunzio.capasso@/webresults.it @Description: hide "no data found" popup when process is in read-only mode **/
                {
                    this.displayPopup(component, 'noDataFound', null);
                }

                if (!component.get('v.dataLoaded')) {
                    component.set('v.acceptedGoods', acceptedGoods);
                    component.set('v.rejectedGoods', rejectedGoods);
                    component.set('v.dataLoaded', true);
                }

                component.set('v.wizardDataAreChanged', false);
                component.set('v.errorsOnWizard', false);

                console.log('availableGoods --> ', availableGoods);
                console.log('$A.util.isEmpty(availableGoods) --> ', $A.util.isEmpty(availableGoods));

               /* var searchedText = component.get('v.inputSearch');

                if (productSerial.length == 1 &&
                //Laser Shot Automatic Receiving Management
                (availableGoods && availableGoods.length == 1
                    && !$A.util.isEmpty(searchedText)
                    && (
                        (!$A.util.isEmpty(availableGoods[0].encodedSerialNumber) && availableGoods[0].encodedSerialNumber.toUpperCase() == searchedText)
                        || (!$A.util.isEmpty(availableGoods[0].manufacturerSerialNumber) && availableGoods[0].manufacturerSerialNumber.toUpperCase() == searchedText)
                        || (!$A.util.isEmpty(availableGoods[0].dllSerialNumber) && availableGoods[0].dllSerialNumber.toUpperCase() == searchedText)
                    )
                ) ) 
                */
                //Laser Shot Automatic Receiving Management
                var searchedText = component.get('v.inputSearch')
                if (availableGoods && availableGoods.length == 1
                    && !$A.util.isEmpty(searchedText)
                    && (
                        (!$A.util.isEmpty(availableGoods[0].encodedSerialNumber) && availableGoods[0].encodedSerialNumber.toUpperCase() == searchedText)
                        || (!$A.util.isEmpty(availableGoods[0].manufacturerSerialNumber) && availableGoods[0].manufacturerSerialNumber.toUpperCase() == searchedText)
                        || (!$A.util.isEmpty(availableGoods[0].dllSerialNumber) && availableGoods[0].dllSerialNumber.toUpperCase() == searchedText)
                    )
                ) {
                    var checkLabel = component.get('v.availableGoodsQuantity');
                    component.set('v.selectedRow', availableGoods[0]);
                    
                    this.handleAcceptGood(component);
                    this.checkSaveButtonVisibility(component);
                    var acceptedGoods = component.get('v.acceptedGoods');
                    //var availableGoods = component.get('v.availableGoods');
                    var availableGoods = response.getReturnValue().availableGoods;
                    var checkLabel = component.get('v.skipCheck');
                    
                    
                    if (acceptedGoods.length != 0 && checkLabel == false &&(
                        (!$A.util.isEmpty(availableGoods[0].encodedSerialNumber) && availableGoods[0].encodedSerialNumber.toUpperCase() == searchedText)
                        || (!$A.util.isEmpty(availableGoods[0].manufacturerSerialNumber) && availableGoods[0].manufacturerSerialNumber.toUpperCase() == searchedText)
                        || (!$A.util.isEmpty(availableGoods[0].dllSerialNumber) && availableGoods[0].dllSerialNumber.toUpperCase() == searchedText)
                    ) ) {
                        var filterCmp = component.find("filter-cmp");
                        filterCmp.removeFilters();
                    }else{
                        component.set('v.inputSearch', '');
                        component.set('v.skipCheck', false);
                    }
                }

            } else if (component.isValid() && response.getState() === "INCOMPLETE") {
                console.log("[CALLBACK] H init >> INCOMPLETE -- " + response.getError()[0].message);
            } else if (component.isValid() && response.getState() === "ERROR") {
                console.log("[CALLBACK] H init >> ERROR -- " + response.getError()[0].message);
            }
            this.checkSaveButtonVisibility(component);
        });

        $A.enqueueAction(saveMethod);

        console.log("[END] Helper --> feedGoodsDataOnTables");
    },


    handleAcceptGood: function (component) {
        console.log("[START] Helper -->  handleAcceptGood");

        var availableGoods = component.get('v.availableGoods');
        var acceptedGoods = component.get('v.acceptedGoods');

        var row = component.get('v.selectedRow');

        var mapAcceptedGoods = [{}];

        for (var i = 0; i < acceptedGoods.length; i++) {
            mapAcceptedGoods.push({sliId: acceptedGoods[i].sliId, oldQt: acceptedGoods[i].selectedQuantity});
        }

        var selectedQt = parseInt(component.get('v.selectedQuantityVal'), 10);
        selectedQt = selectedQt === 0 ? 1 : selectedQt;

        console.log('availableGoods before movement --> ', availableGoods);
        console.log('acceptedGoods before movement --> ', acceptedGoods);
        console.log('selectedRow --> ' + JSON.stringify(row));

        for (var i = 0; i < availableGoods.length; i++) {

            if (availableGoods[i].sliId == row.sliId) {

                console.log('availableGood --> ', availableGoods[i]);

                var availableQt = parseInt(availableGoods[i].availableQuantity, 10);
                availableQt = availableQt - selectedQt;

                availableGoods[i].availableQuantity = String(availableQt);
                availableGoods[i].selectedQuantity = String(selectedQt);

                console.log('available good selectedQt --> ' + selectedQt);
                console.log('available good availableQt --> ' + availableQt);

                var goodWasFound = false;
                for (var j = 0; j < acceptedGoods.length; j++) {
                    if (acceptedGoods[j].sliId == row.sliId && !acceptedGoods[j].locked) {

                        var goodPreviousSelectedQt;

                        for (var k = 0; k < mapAcceptedGoods.length; k++) {
                            if (acceptedGoods[j].sliId == mapAcceptedGoods[k].sliId) {
                                goodPreviousSelectedQt = parseInt(mapAcceptedGoods[k].oldQt);
                                break;
                            }
                        }

                        console.log('goodPreviousSelectedQt --> ' + goodPreviousSelectedQt);

                        selectedQt += goodPreviousSelectedQt;

                        acceptedGoods[j].availableQuantity = String(availableQt);
                        acceptedGoods[j].selectedQuantity = String(selectedQt);
                        console.log('accepted good selectedQt --> ' + selectedQt);
                        console.log('accepted good availableQt --> ' + availableQt);

                        goodWasFound = true;

                    }
                }

                availableGoods[i].selectedQuantity = String(selectedQt);
                availableGoods[i].availableQuantity = String(availableQt);

                if (!goodWasFound) {
                    acceptedGoods.push({
                        acceptedQuantity: availableGoods[i].acceptedQuantity,
                        availableQuantity: availableGoods[i].availableQuantity,
                        catalogName: availableGoods[i].catalogName,
                        closed: availableGoods[i].closed,
                        dllSerialNumber: availableGoods[i].dllSerialNumber,
                        encodedSerialNumber: availableGoods[i].encodedSerialNumber,
                        goodId: availableGoods[i].goodId,
                        locked: availableGoods[i].locked,
                        manufacturer: availableGoods[i].manufacturer,
                        manufacturerSerialNumber: availableGoods[i].manufacturerSerialNumber,
                        model: availableGoods[i].model,
                        productSKU: availableGoods[i].productSKU,
                        rejectedQuantity: availableGoods[i].rejectedQuantity,
                        requestedQuantity: availableGoods[i].requestedQuantity,
                        selectedQuantity: availableGoods[i].selectedQuantity,
                        sliId: availableGoods[i].sliId,
                        status: availableGoods[i].status
                    });
                }

                if (isNaN(availableGoods[i].availableQuantity)
                    || availableGoods[i].availableQuantity == 0
                    || availableGoods[i].availableQuantity == ''
                    || availableGoods[i].availableQuantity == null) {
                    availableGoods.splice(i, 1);
                }
            }
        }

        console.log('availableGoods after movement --> ', availableGoods);
        console.log('acceptedGoods after movement --> ', acceptedGoods);

        component.set('v.availableGoods', availableGoods);

        //component.set('v.acceptedGoods', acceptedGoods);
        this.sortAndRefreshGoods(component, acceptedGoods, 'accepted');

        component.set('v.actionTypeOnAvailableGood', null);
        component.set('v.selectedRow', null);

        console.log("[END] Helper -->  handleAcceptGood");
    },

    handleRejectGood: function (component) {
        console.log("[START] Helper -->  HandleRejectGoods");

        var availableGoods = component.get('v.availableGoods');
        var rejectedGoods = component.get('v.rejectedGoods');
        var row = component.get('v.selectedRow');

        var mapRejectedGoods = [{}];

        for (var i = 0; i < rejectedGoods.length; i++) {
            mapRejectedGoods.push({sliId: rejectedGoods[i].sliId, oldQt: rejectedGoods[i].selectedQuantity});
        }


        var selectedQt = parseInt(component.get('v.selectedQuantityVal'), 10);
        selectedQt = selectedQt === 0 ? 1 : selectedQt;

        console.log('availableGoods before movement --> ', availableGoods);
        console.log('rejectedGoods before movement --> ', rejectedGoods);

        for (var i = 0; i < availableGoods.length; i++) {
            if (availableGoods[i].sliId == row.sliId) {

                console.log('availableGood --> ', availableGoods[i]);

                var availableQt = parseInt(availableGoods[i].availableQuantity, 10);
                availableQt = availableQt - selectedQt;

                availableGoods[i].availableQuantity = String(availableQt);
                availableGoods[i].selectedQuantity = String(selectedQt);

                console.log('available good selectedQt --> ' + selectedQt);
                console.log('available good availableQt --> ' + availableQt);

                var goodWasFound = false;
                for (var j = 0; j < rejectedGoods.length; j++) {
                    if (rejectedGoods[j].sliId == row.sliId && !rejectedGoods[j].locked) {

                        var goodPreviousSelectedQt;

                        for (var k = 0; k < mapRejectedGoods.length; k++) {
                            if (rejectedGoods[j].sliId == mapRejectedGoods[k].sliId) {
                                goodPreviousSelectedQt = parseInt(mapRejectedGoods[k].oldQt);
                                break;
                            }
                        }

                        selectedQt += goodPreviousSelectedQt;

                        rejectedGoods[j].availableQuantity = String(availableQt);
                        rejectedGoods[j].selectedQuantity = String(selectedQt);

                        console.log('rejected good selectedQt --> ' + selectedQt);
                        console.log('rejected good availableQt --> ' + availableQt);

                        goodWasFound = true;

                    }
                }

                availableGoods[i].selectedQuantity = String(selectedQt);
                availableGoods[i].availableQuantity = String(availableQt);

                if (!goodWasFound) {
                    rejectedGoods.push({
                        acceptedQuantity: availableGoods[i].acceptedQuantity,
                        availableQuantity: availableGoods[i].availableQuantity,
                        catalogName: availableGoods[i].catalogName,
                        closed: availableGoods[i].closed,
                        dllSerialNumber: availableGoods[i].dllSerialNumber,
                        encodedSerialNumber: availableGoods[i].encodedSerialNumber,
                        goodId: availableGoods[i].goodId,
                        locked: availableGoods[i].locked,
                        manufacturer: availableGoods[i].manufacturer,
                        manufacturerSerialNumber: availableGoods[i].manufacturerSerialNumber,
                        model: availableGoods[i].model,
                        productSKU: availableGoods[i].productSKU,
                        rejectedQuantity: availableGoods[i].rejectedQuantity,
                        requestedQuantity: availableGoods[i].requestedQuantity,
                        selectedQuantity: availableGoods[i].selectedQuantity,
                        sliId: availableGoods[i].sliId,
                        status: availableGoods[i].status
                    });
                }

                if (isNaN(availableGoods[i].availableQuantity)
                    || availableGoods[i].availableQuantity == 0
                    || availableGoods[i].availableQuantity == ''
                    || availableGoods[i].availableQuantity == null) {

                    availableGoods.splice(i, 1);
                }
            }
        }

        console.log('availableGoods after movement --> ', availableGoods);
        console.log('rejectedGoods after movement --> ', rejectedGoods);

        component.set('v.availableGoods', availableGoods);
        this.sortAndRefreshGoods(component, rejectedGoods, 'rejected');

        component.set('v.selectedRow', null);
        component.set('v.actionTypeOnAvailableGood', null);
        console.log("[END] Helper -->  HandleRejectGoods");
    },

    handleUndoGoodsAcceptance: function (component, event) {
        console.log("[START] Helper -->  handleUndoGoodsAcceptance");

        var availableGoods = component.get('v.availableGoods');
        var acceptedGoods = component.get('v.acceptedGoods');
        var row = event.getParam('row');

        console.log('row --> ', row);

        console.log('availableGoods before movement --> ', availableGoods);
        console.log('acceptedGoods before movement --> ', acceptedGoods);

        for (var i = 0; i < acceptedGoods.length; i++) {

            console.log('acceptedGoods outside --> ', acceptedGoods[i]);

            if (acceptedGoods[i].sliId == row.sliId) {
                console.log('acceptedGoods inside --> ', acceptedGoods[i]);

                var undoneQt = parseInt(acceptedGoods[i].selectedQuantity, 10);
                var availableQt = parseInt(acceptedGoods[i].availableQuantity, 10);

                console.log('accepted good undoneQt --> ' + undoneQt);
                console.log('accepted good availableQt --> ' + availableQt);

                availableQt = availableQt + undoneQt;

                acceptedGoods[i].availableQuantity = String(availableQt);
                acceptedGoods[i].selectedQuantity = String(undoneQt);

                var goodWasFound = false;
                for (var j = 0; j < availableGoods.length; j++) {
                    if (availableGoods[j].sliId == row.sliId) {

                        availableGoods[j].availableQuantity = String(availableQt);
                        console.log('available good availableQt --> ' + availableQt);

                        goodWasFound = true;

                    }
                }

                console.log('##### availableGoods[j] --> ', availableGoods[j]);
                console.log('##### acceptedGoods[i] --> ', acceptedGoods[i]);

                if (!(goodWasFound)) {
                    //availableGoods.push(acceptedGoods[i]);
                    availableGoods.push({
                        acceptedQuantity: acceptedGoods[i].acceptedQuantity,
                        availableQuantity: acceptedGoods[i].availableQuantity,
                        catalogName: acceptedGoods[i].catalogName,
                        closed: acceptedGoods[i].closed,
                        dllSerialNumber: acceptedGoods[i].dllSerialNumber,
                        encodedSerialNumber: acceptedGoods[i].encodedSerialNumber,
                        goodId: acceptedGoods[i].goodId,
                        locked: acceptedGoods[i].locked,
                        manufacturer: acceptedGoods[i].manufacturer,
                        manufacturerSerialNumber: acceptedGoods[i].manufacturerSerialNumber,
                        model: acceptedGoods[i].model,
                        productSKU: acceptedGoods[i].productSKU,
                        rejectedQuantity: acceptedGoods[i].rejectedQuantity,
                        requestedQuantity: acceptedGoods[i].requestedQuantity,
                        selectedQuantity: acceptedGoods[i].selectedQuantity,
                        sliId: acceptedGoods[i].sliId,
                        status: acceptedGoods[i].status
                    });

                }
                acceptedGoods.splice(i, 1);

            }
        }

        component.set('v.availableGoods', availableGoods);
        component.set('v.acceptedGoods', acceptedGoods);

        console.log('availableGoods after movement --> ', availableGoods);
        console.log('acceptedGoods after movement --> ', acceptedGoods);

        console.log("[END] Helper -->  handleUndoGoodsAcceptance");
    },

    handleUndoGoodsRejection: function (component, event) {
        console.log("[START] Helper -->  handleUndoGoodsRejection");

        var availableGoods = component.get('v.availableGoods');
        var rejectedGoods = component.get('v.rejectedGoods');
        var row = event.getParam('row');

        console.log('row --> ', row);
        console.log('availableGoods before movement --> ', availableGoods);
        console.log('rejectedGoods before movement --> ', rejectedGoods);

        for (var i = 0; i < rejectedGoods.length; i++) {

            if (rejectedGoods[i].sliId == row.sliId) {
                console.log('rejectedGoods --> ', rejectedGoods[i]);

                var undoneQt = parseInt(rejectedGoods[i].selectedQuantity, 10);
                var availableQt = parseInt(rejectedGoods[i].availableQuantity, 10);

                console.log('rejected good undoneQt --> ' + undoneQt);
                console.log('rejected good availableQt --> ' + availableQt);

                availableQt = availableQt + undoneQt;

                rejectedGoods[i].availableQuantity = String(availableQt);
                rejectedGoods[i].selectedQuantity = String(undoneQt);

                var goodWasFound = false;
                for (var j = 0; j < availableGoods.length; j++) {
                    if (availableGoods[j].sliId == row.sliId) {

                        availableGoods[j].availableQuantity = String(availableQt);
                        console.log('available good availableQt --> ' + availableQt);

                        goodWasFound = true;
                    }
                }

                console.log('###### availableGoods[j] --> ', availableGoods[j]);
                console.log('###### rejectedGoods[i] --> ', rejectedGoods[i]);

                if (!(goodWasFound)) {
                    //availableGoods.push(rejectedGoods[i]);
                    availableGoods.push({
                        acceptedQuantity: rejectedGoods[i].acceptedQuantity,
                        availableQuantity: rejectedGoods[i].availableQuantity,
                        catalogName: rejectedGoods[i].catalogName,
                        closed: rejectedGoods[i].closed,
                        dllSerialNumber: rejectedGoods[i].dllSerialNumber,
                        encodedSerialNumber: rejectedGoods[i].encodedSerialNumber,
                        goodId: rejectedGoods[i].goodId,
                        locked: rejectedGoods[i].locked,
                        manufacturer: rejectedGoods[i].manufacturer,
                        manufacturerSerialNumber: rejectedGoods[i].manufacturerSerialNumber,
                        model: rejectedGoods[i].model,
                        productSKU: rejectedGoods[i].productSKU,
                        rejectedQuantity: rejectedGoods[i].rejectedQuantity,
                        requestedQuantity: rejectedGoods[i].requestedQuantity,
                        selectedQuantity: rejectedGoods[i].selectedQuantity,
                        sliId: rejectedGoods[i].sliId,
                        status: rejectedGoods[i].status
                    });

                }
                rejectedGoods.splice(i, 1);
            }
        }

        console.log('availableGoods after movement --> ', availableGoods);
        console.log('rejectedGoods after movement --> ', rejectedGoods);

        component.set('v.availableGoods', availableGoods);
        component.set('v.rejectedGoods', rejectedGoods);

        console.log("[END] Helper -->  handleUndoGoodsRejection");
    },

    checkQuantityInputError: function (component) {

        console.log("[START] Helper -->  checkQuantityInputError");

        var selectedRow = component.get('v.selectedRow');
        var originalGoodsList = component.get('v.availableGoods');
        var selectedQuantityInput = component.get('v.selectedQuantityVal');
        var qtInputCmp = component.find('qtSelectionInput');
        var errorMessage = '';

        console.log(' selectedRow --> ', selectedRow);
        console.log(' originalGoodsList --> ', originalGoodsList);
        console.log(' selectedQuantityInput --> ' + selectedQuantityInput);

        for (var i = 0; i < originalGoodsList.length; i++) {

            if (selectedRow.sliId == originalGoodsList[i].sliId) {

                if (selectedQuantityInput == null || selectedQuantityInput == '') {

                    errorMessage = $A.get('$Label.c.Plc_IncorrectFormat');
                    qtInputCmp.set('v.errors', [{message: errorMessage}]);
                    component.set("v.errorsOnWizard", true);
                    console.log("not valid value format");
                    return;
                }

                if (parseInt(selectedQuantityInput, 10) > parseInt(originalGoodsList[i].availableQuantity, 10) || selectedQuantityInput <= 0) {

                    errorMessage = $A.get('$Label.c.Plc_IncorrectQuantity') + ' ' + originalGoodsList[i].availableQuantity;
                    qtInputCmp.set('v.errors', [{message: errorMessage}]);
                    component.set("v.errorsOnWizard", true);
                    console.log("not valid value quantity");
                    return;
                }

                qtInputCmp.set('v.errors', null);
                component.set("v.errorsOnWizard", false);
                break;
            }
        }

        console.log("[END] Helper -->  validateTableDataEntryValues");
    },

    displayPopup: function (component, popupType, maxQuantity) {
        console.log("[START] Helper -->  displayPopup");

        if (popupType == 'errorOnSaveTable') {
            component.set("v.popupMessage", $A.get('$Label.c.Plc_ErrorOnSaveTable'));
            component.set("v.showPopupAnnullButton", false);
        } else if (popupType == 'incorrectFormat') {

            component.set("v.popupMessage", $A.get('$Label.c.Plc_IncorrectFormat'));
            component.set("v.showPopupAnnullButton", false);
        } else if (popupType == 'incorrectQuantity') {

            if (maxQuantity != null) {
                component.set("v.popupMessage", $A.get('$Label.c.Plc_IncorrectQuantity') + maxQuantity);
                component.set("v.showPopupAnnullButton", false);
            }
        } else if (popupType == 'searchWarning') {

            component.set('v.popupMessage', $A.get('$Label.c.Plc_SearchWarning'));
            component.set("v.showPopupAnnullButton", true);
        } else if (popupType == 'undoForbidden') {

            component.set('v.popupMessage', $A.get('$Label.c.Plc_UndoForbidden'));
            component.set("v.showPopupAnnullButton", false);
        } else if (popupType == 'quantitySelection') {

            component.set('v.showQuantityPopup', true);
            component.set("v.showPopupAnnullButton", true);
        } else if (popupType == 'savingResult') {
            if (component.get('v.savingErrorMessage') != '') {
                component.set('v.popupMessage', component.get('v.savingErrorMessage'));
            } else {
                component.set('v.popupMessage', $A.get('$Label.c.Plc_SavingSuccess'));
            }
            component.set("v.showPopupAnnullButton", false);
        } else if (popupType == 'savingError') {

            component.set('v.popupMessage', $A.get('$Label.c.Plc_SavingError'));
            component.set("v.showPopupAnnullButton", false);
        } else if (popupType == 'noDataFound') {

            component.set('v.popupMessage', $A.get('$Label.c.Plc_NoDataFound'));
            component.set("v.showPopupAnnullButton", false);
        }

        component.set("v.showPopup", true);

        console.log("[END] Helper -->  displayPopup");
    },

    checkSaveButtonVisibility: function (component) {
        console.log("[START] Helper -->  checkSaveButtonVisibility");

        var availableGoods = component.get('v.availableGoods');
        var acceptedGoods = component.get('v.acceptedGoods');
        var rejectedGoods = component.get('v.rejectedGoods');

        var dataAreChanged = false;
        for (var i = 0; i < acceptedGoods.length; i++) {
            if (!acceptedGoods[0].locked) {
                dataAreChanged = true;
                break;
            }
        }

        if (!dataAreChanged) {
            for (var i = 0; i < rejectedGoods.length; i++) {
                if (!rejectedGoods[0].locked) {
                    dataAreChanged = true;
                    break;
                }
            }
        }

        component.set('v.wizardDataAreChanged', dataAreChanged);

        console.log("[END] Helper -->  checkSaveButtonVisibility");
    },

    sortAndRefreshGoods: function (component, goods, goodsType) {
        console.log("[START] Helper --> sortGoods");

        var compare = function (firstItem, secondItem) {
            if (firstItem.locked > secondItem.locked)
                return -1;
            if (firstItem.locked < secondItem.locked)
                return 1;
            return 0;
        }

        goods.sort(compare).reverse();

        if (goodsType == 'available') {
            component.set('v.availableGoods', goods);
        } else if (goodsType == 'accepted') {
            component.set('v.acceptedGoods', goods);
        } else if (goodsType == 'rejected') {
            component.set('v.rejectedGoods', goods);
        }

        console.log("[END] Helper -->  sortGoods");

    },

    //STARTFIX - Andrea Liverani - [20190306AL] - 06/03/2019
    updateQuantity: function (component, goodsList, type) {

        let quantity = 0;

        if (goodsList != null) {
            for (var i = 0; i < goodsList.length; i++) {
                if (type == 'available') {
                    quantity += Number(goodsList[i].availableQuantity);
                } else if (type == 'accepted') {
                    //START FIX [#20190315AL] - 15 mar 2019 16:52 - Andrea Liverani (WR) - andrea.liverani@webresults.it
                    //quantity += Number(goodsList[i].selectedQuantity);
                    if(goodsList[i].selectedQuantity != null && goodsList[i].selectedQuantity > 0) {
                        quantity += Number(goodsList[i].selectedQuantity);
                    } else {
                        quantity += Number(goodsList[i].acceptedQuantity);
                    }
                    //END FIX [#20190315AL] - 15 mar 2019 16:52 - Andrea Liverani (WR) - andrea.liverani@webresults.it
                } else if (type == 'rejected') {
                    //START FIX [#20190315AL] - 15 mar 2019 16:52 - Andrea Liverani (WR) - andrea.liverani@webresults.it
                    //quantity += Number(goodsList[i].selectedQuantity);
                    if(goodsList[i].selectedQuantity != null && goodsList[i].selectedQuantity > 0) {
                        quantity += Number(goodsList[i].selectedQuantity);
                    } else {
                        quantity += Number(goodsList[i].rejectedQuantity);
                    }
                    //END FIX [#20190315AL] - 15 mar 2019 16:52 - Andrea Liverani (WR) - andrea.liverani@webresults.it
                }
            }
        }

        if (type == 'available') {
            component.set('v.availableGoodsQuantity', quantity);
        } else if (type == 'accepted') {
            component.set('v.acceptedGoodsQuantity', quantity);
        } else if (type == 'rejected') {
            component.set('v.rejectedGoodsQuantity', quantity);
        }
    },
    //ENDFIX - Andrea Liverani - [20190306AL] - 06/03/2019
    //FB 22-08-2019 : NEXIPLC-673 [START]
    acceptAll: function (component, helper, acceptSelected) {
        var availableGoods = component.get('v.availableGoods');
        var acceptedGoods = component.get('v.acceptedGoods');
        var availableSelectedRows = component.get('v.availableSelectedRows');
        //FB 05-11-2019 : NEXIPLC-742 [START]
        var rowsToAcceptSize = component.get('v.rowsToAcceptSize');
        //FB 05-11-2019 : NEXIPLC-742 [END]

        var mapAcceptedGoods = {};
        var mapAvailableSelectedRows = {};

        for (var i = 0; i < acceptedGoods.length; i++) {
            mapAcceptedGoods[acceptedGoods[i].sliId] = {
                oldQt: acceptedGoods[i].selectedQuantity,
                locked: acceptedGoods[i].locked,
                index: i
            }
        }

        if (acceptSelected) {
            for (var i = 0; i < availableSelectedRows.length; i++) {
                mapAvailableSelectedRows[availableSelectedRows[i].sliId] = {
                    index: i
                }
            }
        }

        var selectedQt;
        var indexesToRemove = [];

        //FB 05-11-2019 : NEXIPLC-742 [START]
        for (var i = 0; i < availableGoods.length && (acceptSelected || i < rowsToAcceptSize); i++) {
        //FB 05-11-2019 : NEXIPLC-742 [END]
            
            //if it is only accept selected mode and the yhe selected rows don't contain current item
            //then skip it
            if (acceptSelected && !mapAvailableSelectedRows.hasOwnProperty(availableGoods[i].sliId)) {
                continue;
            }

            var availableQt = parseInt(availableGoods[i].availableQuantity, 10);
            selectedQt = availableQt;
            availableQt = availableQt - selectedQt;

            availableGoods[i].availableQuantity = String(availableQt);
            availableGoods[i].selectedQuantity = String(selectedQt);

            var goodWasFound = false;

            if (mapAcceptedGoods.hasOwnProperty(availableGoods[i].sliId) &&
                !mapAcceptedGoods[availableGoods[i].sliId].locked) {

                    var goodPreviousSelectedQt = mapAcceptedGoods[availableGoods[i].sliId].oldQt;
                    selectedQt += goodPreviousSelectedQt;
                    
                    acceptedGoods[mapAcceptedGoods[availableGoods[i].sliId].index].availableQuantity = String(availableQt);
                    acceptedGoods[mapAcceptedGoods[availableGoods[i].sliId].index].selectedQuantity = String(selectedQt);
                    goodWasFound = true;
            }

            availableGoods[i].selectedQuantity = String(selectedQt);
            availableGoods[i].availableQuantity = String(availableQt);

            if (!goodWasFound) {
                acceptedGoods.push({
                    acceptedQuantity: availableGoods[i].acceptedQuantity,
                    availableQuantity: availableGoods[i].availableQuantity,
                    catalogName: availableGoods[i].catalogName,
                    closed: availableGoods[i].closed,
                    dllSerialNumber: availableGoods[i].dllSerialNumber,
                    encodedSerialNumber: availableGoods[i].encodedSerialNumber,
                    goodId: availableGoods[i].goodId,
                    locked: availableGoods[i].locked,
                    manufacturer: availableGoods[i].manufacturer,
                    manufacturerSerialNumber: availableGoods[i].manufacturerSerialNumber,
                    model: availableGoods[i].model,
                    productSKU: availableGoods[i].productSKU,
                    rejectedQuantity: availableGoods[i].rejectedQuantity,
                    requestedQuantity: availableGoods[i].requestedQuantity,
                    selectedQuantity: availableGoods[i].selectedQuantity,
                    sliId: availableGoods[i].sliId,
                    status: availableGoods[i].status
                });
            }

            if (isNaN(availableGoods[i].availableQuantity)
                || availableGoods[i].availableQuantity == 0
                || availableGoods[i].availableQuantity == ''
                || availableGoods[i].availableQuantity == null) {
                indexesToRemove.push(i);
                //availableGoods.splice(i, 1);
            }
            
        }

        indexesToRemove.sort(function(a, b) { return b - a; });
        for (var i = 0; i < indexesToRemove.length; i++) {
            availableGoods.splice(indexesToRemove[i], 1);
        }

        component.set('v.availableGoods', availableGoods);
        this.sortAndRefreshGoods(component, acceptedGoods, 'accepted');
        component.set('v.actionTypeOnAvailableGood', null);
    },

    acceptSelected: function (component, helper) {
        helper.acceptAll(component, helper, true);
    },

    deselectAllAccepted: function (component, helper) {

        var availableGoods = component.get('v.availableGoods');
        var acceptedGoods = component.get('v.acceptedGoods');

        var availableGoodsMap = {};
        var indexesToRemove = [];

        for (var i = 0; i < availableGoods.length; i++) {
            availableGoodsMap[availableGoods[i].sliId] = {
                availableQuantity: availableGoods[i].availableQuantity,
                index: i
            }
        }

        var hasUnlockedRows = false;
        
        for (var i = 0; i < acceptedGoods.length; i++) {
            
            if (!acceptedGoods[i].locked) {

                hasUnlockedRows = true;

                var undoneQt = parseInt(acceptedGoods[i].selectedQuantity, 10);
                var availableQt = parseInt(acceptedGoods[i].availableQuantity, 10);

                availableQt = availableQt + undoneQt;

                acceptedGoods[i].availableQuantity = String(availableQt);
                acceptedGoods[i].selectedQuantity = String(undoneQt);

                var goodWasFound = false;

                if (availableGoodsMap.hasOwnProperty(acceptedGoods[i].sliId)) {
                    availableGoods[availableGoodsMap[acceptedGoods[i].sliId].index].availableQuantity = String(availableQt);
                    goodWasFound = true;
                }

                if (!(goodWasFound)) {
                    availableGoods.push({
                        acceptedQuantity: acceptedGoods[i].acceptedQuantity,
                        availableQuantity: acceptedGoods[i].availableQuantity,
                        catalogName: acceptedGoods[i].catalogName,
                        closed: acceptedGoods[i].closed,
                        dllSerialNumber: acceptedGoods[i].dllSerialNumber,
                        encodedSerialNumber: acceptedGoods[i].encodedSerialNumber,
                        goodId: acceptedGoods[i].goodId,
                        locked: acceptedGoods[i].locked,
                        manufacturer: acceptedGoods[i].manufacturer,
                        manufacturerSerialNumber: acceptedGoods[i].manufacturerSerialNumber,
                        model: acceptedGoods[i].model,
                        productSKU: acceptedGoods[i].productSKU,
                        rejectedQuantity: acceptedGoods[i].rejectedQuantity,
                        requestedQuantity: acceptedGoods[i].requestedQuantity,
                        selectedQuantity: acceptedGoods[i].selectedQuantity,
                        sliId: acceptedGoods[i].sliId,
                        status: acceptedGoods[i].status
                    });

                }
                indexesToRemove.push(i);
            }
        }

        if (!hasUnlockedRows) {
            helper.displayPopup(component, 'undoForbidden', null);
        }

        indexesToRemove.sort(function(a, b) { return b - a; });
        for (var i = 0; i < indexesToRemove.length; i++) {
            acceptedGoods.splice(indexesToRemove[i], 1);
        }

        component.set('v.availableGoods', availableGoods);
        component.set('v.acceptedGoods', acceptedGoods);
    },

    deselectAllRejected: function (component, helper) {
        var availableGoods = component.get('v.availableGoods');
        var rejectedGoods = component.get('v.rejectedGoods');

        var availableGoodsMap = {};
        var indexesToRemove = [];

        for (var i = 0; i < availableGoods.length; i++) {
            availableGoodsMap[availableGoods[i].sliId] = {
                availableQuantity: availableGoods[i].availableQuantity,
                index: i
            }
        }
        var hasUnlockedRows = false;

        for (var i = 0; i < rejectedGoods.length; i++) {
            
            if (!rejectedGoods[i].locked) {

                hasUnlockedRows = true;

                var undoneQt = parseInt(rejectedGoods[i].selectedQuantity, 10);
                var availableQt = parseInt(rejectedGoods[i].availableQuantity, 10);

                availableQt = availableQt + undoneQt;

                rejectedGoods[i].availableQuantity = String(availableQt);
                rejectedGoods[i].selectedQuantity = String(undoneQt);

                var goodWasFound = false;

                if (availableGoodsMap.hasOwnProperty(rejectedGoods[i].sliId)) {
                    availableGoods[availableGoodsMap[rejectedGoods[i].sliId].index].availableQuantity = String(availableQt);
                    goodWasFound = true;
                }

                if (!(goodWasFound)) {
                    availableGoods.push({
                        acceptedQuantity: rejectedGoods[i].acceptedQuantity,
                        availableQuantity: rejectedGoods[i].availableQuantity,
                        catalogName: rejectedGoods[i].catalogName,
                        closed: rejectedGoods[i].closed,
                        dllSerialNumber: rejectedGoods[i].dllSerialNumber,
                        encodedSerialNumber: rejectedGoods[i].encodedSerialNumber,
                        goodId: rejectedGoods[i].goodId,
                        locked: rejectedGoods[i].locked,
                        manufacturer: rejectedGoods[i].manufacturer,
                        manufacturerSerialNumber: rejectedGoods[i].manufacturerSerialNumber,
                        model: rejectedGoods[i].model,
                        productSKU: rejectedGoods[i].productSKU,
                        rejectedQuantity: rejectedGoods[i].rejectedQuantity,
                        requestedQuantity: rejectedGoods[i].requestedQuantity,
                        selectedQuantity: rejectedGoods[i].selectedQuantity,
                        sliId: rejectedGoods[i].sliId,
                        status: rejectedGoods[i].status
                    });
                }
                indexesToRemove.push(i);
            }
        }

        if (!hasUnlockedRows) {
            helper.displayPopup(component, 'undoForbidden', null);
        }

        indexesToRemove.sort(function(a, b) { return b - a; });
        for (var i = 0; i < indexesToRemove.length; i++) {
            rejectedGoods.splice(indexesToRemove[i], 1);
        }

        component.set('v.availableGoods', availableGoods);
        component.set('v.rejectedGoods', rejectedGoods);
    },
})