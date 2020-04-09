({
    init: function (component, event, helper) {
        
        if (component.get('v.objectId')) {
            helper.initialize(component, helper);
        } else {
            helper.retrieveTranslationMap(component, helper);
        }
    },
    handleSave: function (component, event, helper) {
        var titolo = component.get("v.title");
        console.log("Save clicked, titolo: " + titolo);
        var productQuantitySelected = component.get("v.selectedProductQuantity");
        var productSerialSelected = component.get("v.selectedProductSerial");
        if (productQuantitySelected.length == 0 && productSerialSelected.length == 0) {
            console.log("nessun prodotto selezionato, non si puo salvare");
            component.set("v.messagePopup", $A.get('$Label.c.Plc_NessunProdotto'));
            component.set("v.viewPopUp", true);
            return;
        }
        var action = component.get("c.save");
        var transferDetail = component.get("v.transferDetailSelected");
        var originWarehouse = component.get("v.originWarehouseSelected");
        var destinationWarehouse = component.get("v.destinationWareHouseSelected");
        var selectedProductSerial = component.get("v.selectedProductSerial");
        var selectedProductQuantity = component.get("v.selectedProductQuantity");
        var note = component.get("v.note");
        action.setParams({
            transferDetail: transferDetail,
            originWarehouse: originWarehouse,
            destinationWarehouse: destinationWarehouse,
            selectedProductSerial: selectedProductSerial,
            selectedProductQuantity: selectedProductQuantity,
            note: note
        });
        action.setCallback(this, function (res) {
            if (component.isValid() && res.getState() === "SUCCESS") {
                var StockOrderId = res.getReturnValue();
                component.set("v.showSpinner", false);
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": StockOrderId,
                    "slideDevName": "related"
                });
                navEvt.fire();
            } else if (component.isValid() && res.getState() === "INCOMPLETE") {
                console.log("Error: " + res.getError()[0].message);
            } else if (component.isValid() && res.getState() === "ERROR") {
                console.log("Sono qui Unknown error: " + res.getError()[0].message);
            }
        });
        component.set("v.showSpinner", true);
        $A.enqueueAction(action);
    },
    handleBack: function (component, event, helper) {
        var titolo = component.get("v.title");
        console.log("Back clicked, titolo: " + titolo);
    },
    handleNext: function (component, event, helper) {
        var titolo = component.get("v.title");
        console.log("Next clicked, titolo: " + titolo);
        //passo allo step 2
        component.set("v.step1", false);
        //mostro i campi di ricerca e inizializzo il component filter
        //component.set("v.uploadCsvIsVisible", false);
        //component.set("v.isFilterVisible", true);
        //nascondo il pulsante next e mostro il pulsante salva
        component.set("v.isNextVisible", false);
        component.set("v.isSaveVisible", true);
        component.set("v.isSaveEnabled", false);
        //inizializzo il component filter
        var filterSerialStatus = component.get("v.transferDetailSelected").Plc_FilterSerialStatus__c;
        if (filterSerialStatus == undefined) {
            console.log("filter undefined lo setto");
            filterSerialStatus = '';
        }
        console.log("filterSerialStatus vale: ", filterSerialStatus);
        var originWarehouse = component.get("v.originWarehouseSelected").Id;
        var configurationMap = {
            'fromGoodsHandling': 'GoodsHandling',
            'filterSerialStatus': filterSerialStatus,
            'originWarehouse': originWarehouse
        };
        component.set("v.warehouseId", originWarehouse);
        component.set("v.stockSerialStatus", filterSerialStatus);
        component.set("v.searchConfigurationMap", configurationMap);
        //FB 20191209 - Searching serials on demand [START]
        //component.set("v.searchOnLoad", true);
        //FB 20191209 - Searching serials on demand [END]
        //popolo le tabelle, ma ancora senza dati
        helper.populateTables(component, event, helper);
    },
    handleChangeOrderType: function (component, event, helper) {
        console.log("combo box 1 selected");
    },
    handleChangeTransferDetails: function (component, event, helper) {
        console.log("combo box 2 selected: ");
        //se sto tornando indietro sulle mie scelte allora devo resettare tutti i combo box successivi a parte quello subito prossimo già gestito nella callback e disabilitare il next
        if (component.get("v.step1_2")) {
            component.set("v.step1_2", false);
            var oW = component.find("originWareHouse");
            oW.set("v.value", '');
            var dW = component.find("destinationWarehouse");
            dW.set("v.value", '');
            component.set("v.destinationWarehouseOptions", null);
            component.set("v.isNextEnabled", false);
        }
        var selectedOptionValue = event.getParam("value");
        var transferDetails = component.get("v.transferDetails");
        var transferDetailSelected;
        var t;
        for (t = 0; t < transferDetails.length; t++) {
            if (transferDetails[t].Id == selectedOptionValue) {
                transferDetailSelected = transferDetails[t];
                break;
            }
        }
        component.set("v.transferDetailSelected", transferDetailSelected);
        console.log("transferDetailSelected value: ", transferDetailSelected);
        var action = component.get("c.selectOrigin");
        var filter = transferDetailSelected.Plc_FilterOriginWarehouse__c;
        console.log("filter vale:", filter);
        if (filter == undefined) {
            console.log("filter undefined lo setto");
            filter = '';
        }
        action.setParams({dealerId: component.get("v.recordId"), origin: filter});
        action.setCallback(this, function (res) {
            if (component.isValid() && res.getState() === "SUCCESS") {
                console.log("callback success");
                var result = res.getReturnValue();
                console.log("result vale: ", result);
                component.set("v.wareHouse", result);
                console.log("set eseguito: ");

                //setto la prima combobox dello step
                var dealer = component.get("v.dealer");
                var originDealerOptions = component.get("v.originDealerOptions");
                originDealerOptions[0] = {'label': dealer.Name, 'value': dealer.Id};
                //setto la seconda combobox dello step
                var originWareHouseOptions = [];
                var i;
                for (i = 0; i < result.length; i++) {
                    originWareHouseOptions[i] = {'label': result[i].Name, 'value': result[i].Id};
                }
                component.set("v.originWareHouseOptions", originWareHouseOptions);
                component.set("v.step1_1", true);
                component.set("v.showSpinner", false);
            } else if (component.isValid() && res.getState() === "INCOMPLETE") {
                console.log("Error: " + res.getError()[0].message);
            } else if (component.isValid() && res.getState() === "ERROR") {
                console.log("Sono qui Unknown error: " + res.getError()[0].message);
            }
        });
        component.set("v.showSpinner", true);
        $A.enqueueAction(action);
    },
    handleChangeOriginDealer: function (component, event, helper) {
        console.log("combo box 3 selected: ");
    },
    handleChangeOriginWareHouse: function (component, event, helper) {
        console.log("combo box 4 selected: ");
        //se sto tornando indietro sulle mie scelte allora devo resettare tutti i combo box successivi a parte quello subito prossimo già gestito nella callback e disabilitare il next
        if (component.get("v.step1_2")) {
            var dD = component.find("destinationDealer");
            dD.set("v.value", '');
            var dW = component.find("destinationWarehouse");
            dW.set("v.value", '');
            component.set("v.destinationWarehouseOptions", null);
            component.set("v.isNextEnabled", false);
        }
        var selectedOptionValue = event.getParam("value");
        var originWarehouse = component.get("v.wareHouse");
        var originWarehouseSelected;
        var t;
        for (t = 0; t < originWarehouse.length; t++) {
            if (originWarehouse[t].Id == selectedOptionValue) {
                originWarehouseSelected = originWarehouse[t];
                break;
            }
        }
        console.log("originWarehouseSelected vale: ", originWarehouseSelected);
        component.set("v.originWarehouseSelected", originWarehouseSelected);

        var action = component.get("c.selectDestinationDealer");
        console.log('transfer detail selected: ', component.get("v.transferDetailSelected"));
        var filter = component.get("v.transferDetailSelected").Plc_FilterDestinationDealer__c;

        /** [START MOD 19/02/2019 16:35]@Author:nunzio.capasso@/webresults.it @Description: fix NEXIPLC-364 **/
        if ($A.util.isEmpty(component.get("v.transferDetailSelected").Plc_FilterDestinationDealer__c)) {
            filter = component.get("v.transferDetailSelected").Plc_FilterDestinationWarehouse__c;
        }
        /** [END MOD 19/02/2019 17:06]@Author:nunzio.capasso@/webresults.it @Description: fix NEXIPLC-364 **/
        console.log("filter vale: ", filter);
        if (filter == undefined) {
            console.log("filter undefined lo setto");
            filter = '';
        }

        action.setParams({
            filterDestinationDealer: filter,
            tranferDetailId: component.get("v.transferDetailSelected").Id,
            originWarehouseId: originWarehouseSelected.Id
        });
        action.setCallback(this, function (res) {
            if (component.isValid() && res.getState() === "SUCCESS") {
                var result = res.getReturnValue();
                component.set("v.destinationDealer", result);
                var destinationDealerOptions = [];
                var i;
                for (i = 0; i < result.length; i++) {
                    destinationDealerOptions[i] = {'label': result[i].Name, 'value': result[i].Id};
                }
                component.set("v.destinationDealerOptions", destinationDealerOptions);
                component.set("v.step1_2", true);
                component.set("v.showSpinner", false);
            } else if (component.isValid() && res.getState() === "INCOMPLETE") {
                console.log("Error: " + res.getError()[0].message);
            } else if (component.isValid() && res.getState() === "ERROR") {
                console.log("Sono qui Unknown error: " + res.getError()[0].message);
            }
        });
        component.set("v.showSpinner", true);
        $A.enqueueAction(action);
    },
    handleChangeDestinationDealer: function (component, event, helper) {
        console.log("combo box 5 selected: ");
        var selectedOptionValue = event.getParam("value");
        var originWarehouse = component.get("v.wareHouse");
        var destinationDealerSelected;
        var destinationDealers = component.get("v.destinationDealer");
        var t;
        for (t = 0; t < destinationDealers.length; t++) {
            if (destinationDealers[t].Id == selectedOptionValue) {
                destinationDealerSelected = destinationDealers[t];
                break;
            }
        }
        console.log("destinationDealerSelected vale: ", destinationDealerSelected);
        component.set("v.destinationDealerSelected", destinationDealerSelected);

        var action = component.get("c.selectDestinationWarehouse");
        var filter = component.get("v.transferDetailSelected").Plc_FilterDestinationWarehouse__c;
        console.log("filter vale: ", filter);
        if (filter == undefined) {
            console.log("filter undefined lo setto");
            filter = '';
        }
        var codeC = component.get("v.transferDetailSelected").Bit2Shop__Code__c;
        console.log("code vale: ", codeC);
        var logisticDivisionC = component.get("v.originWarehouseSelected").Plc_LogisticDivision__c;
        console.log("logisticDivisionC vale: ", logisticDivisionC);
        var propertyC = component.get("v.originWarehouseSelected").Plc_Property__c;
        console.log("propertyC vale: ", propertyC);
        action.setParams({
            filterDestinationWarehouse: filter,
            dealerId: destinationDealerSelected.Id,
            code: codeC,
            logisticDivision: logisticDivisionC,
            property: propertyC
        });
        action.setCallback(this, function (res) {
            if (component.isValid() && res.getState() === "SUCCESS") {
                var dW = component.find("destinationWarehouse");
                dW.set("v.value", '');

                var result = res.getReturnValue();
                component.set("v.destinationWarehouse", result);
                //var destinationWarehouseOptions = component.get("v.destinationWarehouseOptions");
                var destinationWarehouseOptions = [];
                var i;
                for (i = 0; i < result.length; i++) {
                    destinationWarehouseOptions[i] = {'label': result[i].Name, 'value': result[i].Id};
                }
                component.set("v.destinationWarehouseOptions", destinationWarehouseOptions);
                component.set("v.showSpinner", false);
            } else if (component.isValid() && res.getState() === "INCOMPLETE") {
                console.log("Error: " + res.getError()[0].message);
            } else if (component.isValid() && res.getState() === "ERROR") {
                console.log("Sono qui Unknown error: " + res.getError()[0].message);
            }
        });
        component.set("v.showSpinner", true);
        $A.enqueueAction(action);
    },
    handleChangeDestinationWarehouse: function (component, event, helper) {
        console.log("combo box 6 selected: ");
        var selectedOptionValue = event.getParam("value");
        var destinationWarehouse = component.get("v.destinationWarehouse");
        var destinationWareHouseSelected;
        var t;
        for (t = 0; t < destinationWarehouse.length; t++) {
            if (destinationWarehouse[t].Id == selectedOptionValue) {
                destinationWareHouseSelected = destinationWarehouse[t];
                break;
            }
        }
        console.log("destinationWareHouseSelected vale: ", destinationWareHouseSelected);
        component.set("v.destinationWareHouseSelected", destinationWareHouseSelected);
        component.set("v.step1_3", true);
        component.set("v.isNextEnabled", true);
    },
    handleOnChangeTextarea: function (component, event, helper) {
        console.log("text area selected: ");
        //var text = event.getParam("value");
        //console.log("value: ", event.getParam("value"));
        component.set("v.note", event.getParam("value"));
    },
    handleFilterComponent: function (component, event, helper) {
        console.log("cerca clicked");
    },
    handleOnSaveProductQuantityTable: function (component, event, helper) {
        console.log("Save clicked");
        if (component.get("v.error")) {
            console.log("error in data entry");
            helper.displayError(component, helper, true, null);
            return;
        }
        var rowsChanged = event.getParam('draftValues');
        console.log("rowsChanged: ", rowsChanged);
        //aggiorno le tabelle dei prodotti a quantità
        helper.updateTablesProductQuantity(component, event, helper, rowsChanged);
        //annullo l'attributo delle rows cambiate per far sparire i pulsanti cancel e Save
        var tableP = component.find("ProductQuantityTable");
        tableP.set("v.draftValues", null);
    },
    handleOnSaveSelectedProductQuantityTable: function (component, event, helper) {
        console.log("handleOnSaveSelectedProductQuantityTable");
        if (component.get("v.error")) {
            console.log("error in data entry");
            helper.displayError(component, helper, true, null);
            return;
        }
        console.log("sono qui");
        var rowsChanged = event.getParam('draftValues');
        console.log("rowsChanged: ", rowsChanged);
        //aggiorno le tabelle dei prodotti a quantità
        helper.updateTablesProductQuantityFromSelected(component, event, helper, rowsChanged);
        //annullo l'attributo delle rows cambiate per far sparire i pulsanti cancel e Save
        var tableP = component.find("SelectedProductQuantityTable");
        tableP.set("v.draftValues", null);
    },
    handleOnCellchange: function (component, event, helper) {
        console.log("handleOnCellchange");
        var rowsChanged = event.getParam('draftValues');
        var rows = component.get("v.availableProductQuantity");
        console.log("rowsChanged: ", rowsChanged);
        var i;
        var j;
        for (i = 0; i < rowsChanged.length; i++) {
            for (j = 0; j < rows.length; j++) {
                if (rowsChanged[i].Id == rows[j].Id) {
                    if (rowsChanged[i].SelectedQuantity == null || rowsChanged[i].SelectedQuantity == '') {
                        component.set("v.error", true);
                        console.log("not valid vale true");
                        //console.log("j vale: ", j);
                        //console.log("rowsChanged vale: ", rowsChanged);
                        helper.displayError(component, helper, true, null);
                        return;
                    }
                    var stringToNumberSelected = parseInt(rowsChanged[i].SelectedQuantity, 10);
                    if (stringToNumberSelected > rows[j].Plc_AvailableQty__c || stringToNumberSelected < 0) {
                        component.set("v.error", true);
                        console.log("not valid vale false");
                        helper.displayError(component, helper, false, rows[j].Plc_AvailableQty__c);
                        return;
                    }
                    component.set("v.error", false);
                    break;
                }
            }
        }
    },
    closePopUp: function (component, event, helper) {
        component.set("v.viewPopUp", false);
    },
    handleOnCellchangeSelected: function (component, event, helper) {
        console.log("sono in handleOnCellchangeSelected");
        var rowsChanged = event.getParam('draftValues');
        var rows = component.get("v.selectedProductQuantity");
        console.log("rowsChanged: ", rowsChanged);
        var i;
        var j;
        for (i = 0; i < rowsChanged.length; i++) {
            for (j = 0; j < rows.length; j++) {
                if (rowsChanged[i].Id == rows[j].Id) {
                    if (rowsChanged[i].toRemoveQuantity == null || rowsChanged[i].toRemoveQuantity == '') {
                        component.set("v.error", true);
                        helper.displayError(component, helper, true, null);
                        return;
                    }
                    var stringToNumberSelected = parseInt(rowsChanged[i].toRemoveQuantity, 10);
                    if (stringToNumberSelected > rows[j].TotalSelectedQuantity || stringToNumberSelected < 0) {
                        component.set("v.error", true);
                        console.log("not valid vale false");
                        helper.displayError(component, helper, false, rows[j].TotalSelectedQuantity);
                        return;
                    }
                    component.set("v.error", false);
                    break;
                }
            }
        }
    },
    handleSelectProductSerial: function (component, event, helper) {
        console.log("handleSelectProductSerial");
        console.log('event >> ', event);
        component.set('v.showSpinner', true);

        if (event && event.getParam('row') != null) {

            var selectedRow = event.getParam('row');
            //var selectedRow = event.getParam('row');
            console.log("selectedRow: ", selectedRow);
            //rimuovo la riga selezionata dalla tabella dei prodotti disponibili
            var _productSerialAvailable = component.get("v.availableProductSerial");
            var j;
            for (j = 0; j < _productSerialAvailable.length; j++) {
                if (selectedRow.Id == _productSerialAvailable[j].Id) {
                    _productSerialAvailable.splice(j, 1);
                    component.find('tabs').set('v.selectedTabId', 'Selezionati');
                    break;
                }
            }

            setTimeout(function () {
                component.find('tabs').set('v.selectedTabId', 'Ricerca');
                component.set('v.showSpinner', false);
            }, 500);


            //aggiungo la riga selezionata nella tabella dei prodotti selezionati
            var _productSerialSelected = component.get("v.selectedProductSerial");
            _productSerialSelected.push(selectedRow);

            component.set("v.availableProductSerial", _productSerialAvailable);
            console.log("productSerialAvailable: ", _productSerialAvailable);

            component.set("v.selectedProductSerial", _productSerialSelected);
            console.log("productSerialSelected: ", _productSerialSelected);
        }
    },

    handleSelectProductSerialSelected: function (component, event, helper) {
        console.log("handleSelectProductSerialSelected");
        var selectedRow = event.getParam('row');
        console.log("selectedRow: ", selectedRow);
        //rimuovo la riga selezionata dalla tabella dei prodotti selezionati
        var productSerialSelected = component.get("v.selectedProductSerial");
        var j;
        for (j = 0; j < productSerialSelected.length; j++) {
            if (selectedRow.Id == productSerialSelected[j].Id) {
                productSerialSelected.splice(j, 1);
                break;
            }
        }
        //aggiungo la riga selezionata nella tabella dei prodotti disponibili
        var productSerialAvailable = component.get("v.availableProductSerial");
        productSerialAvailable.push(selectedRow);

        component.set("v.availableProductSerial", productSerialAvailable);
        console.log("productSerialAvailable: ", productSerialAvailable);

        component.set("v.selectedProductSerial", productSerialSelected);
        console.log("productSerialAvailable: ", productSerialAvailable);
    },
    handleActive: function (component, event, helper) {
        console.log("handleActive");
        var tab = event.getSource();
        switch (tab.get('v.selectedTabId')) {
            case 'Ricerca' :
                //mostro i campi di ricerca
                console.log("tab ricerca cliccato");
                //component.set("v.isFilterVisible", true);
                //disabilito il sace perchè lo abilito solo dal tab dei selezionati in modo da vedere chiaramente cosa sto salvando
                component.set('v.showFilterCmp', true);
                component.set("v.isSaveEnabled", false);
                break;
            case 'Selezionati' :
                //nascondo i campi di ricerca
                console.log("tab Selezionati cliccato");
                //component.set("v.isFilterVisible", false);
                component.set('v.showFilterCmp', false);
                component.set("v.isSaveEnabled", true);
                break;
        }
    },
    filterResult: function (component, event, helper) {
        console.log("filterResult");

        var firstLandingInTabSearch = component.get("v.firstLandingInTabSearch");
        var filterResult = event.getParam("searchResultsEvt");
        if (event.getParam("actionType") == "removeFilters") {
            console.log("filters removed");
            helper.refreshTables(component, event, helper);
            return;
        }
        if (event.getParam("actionType") == "applyFilters" || event.getParam("actionType") == "sendCsvResults") {
            console.log("filterResult: ", filterResult);
            var productQuantity;
            //popolo la tabella dei prodotti a quantità se non sto caricando da CSV
            if (event.getParam("actionType") == "applyFilters") {
                //aggiungo la colonna quantità da selezionare  e mi salvo la quantità vecchia
                productQuantity = filterResult.Bit2Shop__Product_Stock__c;
                var k;
                for (k = 0; k < productQuantity.length; k++) {
                    productQuantity[k].SelectedQuantity = 0;
                    productQuantity[k].OriginalQuantity = productQuantity[k].Plc_AvailableQty__c;
                }
                //devo verificare se la riga è già presente tra i prodotti selezionati, in tal caso devo aggiornare la quantità disponibile
                var productQuantitySelected = component.get("v.selectedProductQuantity");
                var i;
                var y;

                //FB 18-06-2019: Optimizing [START]
                
                var productQuantitySelectedMap = {};

                productQuantitySelected.forEach(function(item) {
                    productQuantitySelectedMap[item.Id] = item;
                });

                    for (y = 0; y < productQuantity.length; y++) {
                         if (productQuantitySelectedMap.hasOwnProperty(productQuantity[y].Id)) {
                            productQuantity[y].Plc_AvailableQty__c -= productQuantitySelectedMap[productQuantity[y].Id].TotalSelectedQuantity;
                            if (productQuantity[y].Plc_AvailableQty__c == 0) {
                                productQuantity.splice(y, 1);
                            }
                        }
                    }

                // for (i = 0; i < productQuantitySelected.length; i++) {
                //     for (y = 0; y < productQuantity.length; y++) {
                //         if (productQuantitySelected[i].Id == productQuantity[y].Id) {
                //             productQuantity[y].Plc_AvailableQty__c -= productQuantitySelected[i].TotalSelectedQuantity;
                //             if (productQuantity[y].Plc_AvailableQty__c == 0) {
                //                 productQuantity.splice(y, 1);
                //             }
                //             break;
                //         }
                //     }
                // }
                
                //FB 18-06-2019: Optimizing [END]
            }

            //popolo la tabella dei prodotti a seriale
            //devo verificare che non sia tra le righe della tabella dei prodotti selezionati, altrimenti la devo togliere dalla tabella dei disponibili
            var productSerialSelected = component.get("v.selectedProductSerial");
            var productSerial = [];
            //START FIX [#20190326AL] - 26 mar 2019 16:15 - Andrea Liverani (WR) - andrea.liverani@webresults.it
            var productSerialNotFiltered = [];
            //END FIX [#20190326AL] - 26 mar 2019 16:15 - Andrea Liverani (WR) - andrea.liverani@webresults.it

            var isFromCsv = false;
            if (event.getParam("actionType") == "applyFilters") {
                //START FIX [#20190326AL] - 26 mar 2019 16:16 - Andrea Liverani (WR) - andrea.liverani@webresults.it
                //productSerial = filterResult.Bit2Shop__Stock_Serials2__c;
                productSerialNotFiltered = filterResult.Bit2Shop__Stock_Serials2__c;

                for(var i = 0; i < productSerialNotFiltered.length; i++) {
                    if(productSerialNotFiltered[i].Plc_Status2__c == 'None') {
                        productSerial.push(productSerialNotFiltered[i]);
                    }
                }
                //END FIX [#20190326AL] - 26 mar 2019 16:16 - Andrea Liverani (WR) - andrea.liverani@webresults.it


            } else {
                isFromCsv = true;
                productSerial = filterResult.stockSerialFromCSV;
            }
            var j;
            var t;
            if (!isFromCsv) {

                //FB 18-06-2019: Optimizing [START]
                
                var productSerialSelectedMap = {};

                productSerialSelected.forEach(function(item) {
                    productSerialSelectedMap[item.Id] = item;
                });

                for (t = 0; t < productSerial.length; t++) {
                    if (productSerialSelectedMap.hasOwnProperty(productSerial[t].Id)) {
                        productSerial.splice(z, 1);
                    }
                }

                // for (j = 0; j < productSerialSelected.length; j++) {
                //     for (t = 0; t < productSerial.length; t++) {
                //         if (productSerial[t].Id == productSerialSelected[j].Id) {
                //             productSerial.splice(t, 1);
                //             break;
                //         }
                //     }
                // }

                //FB 18-06-2019: Optimizing [END]
            }
            //visualizzo le tabelle solo se hanno qualcosa da mostrare
            var noProductS = false;
            var noProductQ = false;
            if (productQuantity != null && productQuantity != '') {
                if (productQuantity.length > 0) {
                    component.set("v.productQuantityYes", true);
                } else {
                    noProductQ = true
                }
            }
            if (productSerial != null && productSerial != '') {
                if (productSerial.length > 0) {
                    if (productSerial.length == 1 && 
                        (productSerial[0].Plc_EncodedSerialNumber__c  == component.get('v.inputSearch') ||
                        productSerial[0].Plc_ManufacturerSerialNumber__c == component.get('v.inputSearch') ||
                        productSerial[0].Plc_DllSerialNumber__c ==component.get('v.inputSearch') 
                    ))  {
                        productSerialSelected.push(productSerial[0]);
                        component.set('v.selectedProductSerial', productSerialSelected);
                        component.set('v.inputSearch', '');
                        var filterCmp = component.find("filter-cmp");
                        filterCmp.searchFilters();
                        filterCmp.removeFilters();
                        

                    }
                    component.set("v.productSerialYes", true);
                } else {
                    noProductS = true;
                }
            }
            console.log( '### GET INFOS: ' +productSerial +  productQuantity +  component.get("v.selectedProductSerial"));
            if (((productSerial == null || productSerial == '') && (productQuantity == null || productQuantity == '')) && (component.get("v.selectedProductSerial") == '' || component.get("v.selectedProductSerial") == null)) {
                component.set("v.messagePopup", $A.get('$Label.c.Plc_NoProduct'));
                component.set("v.viewPopUp", true);
                console.log('### Enter first condition');
            }
            if (noProductS && noProductQ) {
                component.set("v.messagePopup", $A.get('$Label.c.Plc_NoProduct'));
                component.set("v.viewPopUp", true);
            }
            component.set("v.availableProductQuantity", productQuantity);

            /** [START MOD 25/02/2019 12:48]@Author:nunzio.capasso@/webresults.it @Description: records from csv are now going in the selected tab**/
            // component.set("v.availableProductSerial", productSerial);
            if (!isFromCsv) {
                component.set("v.availableProductSerial", productSerial);
            } else {
                component.set("v.selectedProductSerial", productSerial);
            }

            var _availableProductSerial = component.get("v.availableProductSerial");
            var _selectedProductSerial = component.get("v.selectedProductSerial");

            //FB 18-06-2019: Optimizing [START]
            var _selectedProductSerialMap = {};

            _selectedProductSerial.forEach(function(item) {
                _selectedProductSerialMap[item.Id] = item;
            });

            for (var z = 0; z < _availableProductSerial.length; z++) {
                if (_selectedProductSerialMap.hasOwnProperty(_availableProductSerial[z].Id)) {
                    _availableProductSerial.splice(z, 1);
                }
            }

            //check for duplicates
            // for (var x = 0; x < _selectedProductSerial.length; x++) {
            //     for (var z = 0; z < _availableProductSerial.length; z++) {
            //         if (_availableProductSerial[z].Id == _selectedProductSerial[x].Id) {
            //             _availableProductSerial.splice(z, 1);
            //         }
            //     }
            // }
            
            //FB 18-06-2019: Optimizing [END]
            
           
            console.log('@@@@@_availableProductSerial ', _availableProductSerial);
            component.set("v.availableProductSerial", _availableProductSerial);
            /** [END MOD 25/02/2019 12:48]@Author:nunzio.capasso@/webresults.it @Description: records from csv are now going in the selected tab **/

            if (firstLandingInTabSearch) {
                component.set("v.availableProductQuantityWithoutFilter", productQuantity);
                component.set("v.availableProductSerialWithoutFilter", productSerial);
                component.set("v.firstLandingInTabSearch", false);
            }
            component.set("v.showSpinner", false);
        }
    },

    //START FIX - Andrea Liverani - [20190403AL] - 04/03/2019
    handleChangeAvailableProductQuantity: function (component, event, helper) {
        var availableProductQuantity, quantityProductListAvailable;

        quantityProductListAvailable = 0;
        availableProductQuantity = component.get('v.availableProductQuantity');

        if (availableProductQuantity != null) {
            for (var i = 0; i < availableProductQuantity.length; i++) {
                quantityProductListAvailable += availableProductQuantity[i].Plc_AvailableQty__c;
            }
        }

        component.set('v.quantityProductListAvailable', quantityProductListAvailable);

    },

    handleChangeSelectedProductQuantity: function (component, event, helper) {
        var selectedProductQuantity, quantityProductListSelected;

        quantityProductListSelected = 0;
        selectedProductQuantity = component.get('v.selectedProductQuantity');

        if (selectedProductQuantity != null) {
            for (var i = 0; i < selectedProductQuantity.length; i++) {
                quantityProductListSelected += selectedProductQuantity[i].SelectedQuantity;
            }
        }

        component.set('v.quantityProductListSelected', quantityProductListSelected);
    },
    //END FIX - Andrea Liverani - [20190403AL] - 04/03/2019
    handleUpdateSelectedRows : function(component, event, helper) {
        var selectedRow = event.getParam('selectedRows')[0];
        component.set('v.propertiesMap.dealer', selectedRow);
    },

    handleDealersFilter : function(component, event, helper) {
        helper.retrieveAvailableDealers(component, helper);
    },

    handleBack : function(component, event, helper) {
        window.history.go(-1);
        window.close();
    },

    handleCloseTableModal : function(component, event, helper) {
        component.set('v.objectId', component.get('v.propertiesMap.dealer.Id'));
        helper.initialize(component);
        helper.closeModal(component, helper,'modal-dealers');
    },
})