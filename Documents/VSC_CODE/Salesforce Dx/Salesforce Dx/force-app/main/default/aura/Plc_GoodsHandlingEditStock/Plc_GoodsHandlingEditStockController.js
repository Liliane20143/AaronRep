({
	init : function(component, event, helper) {
        component.set("v.showSpinner", true);

        //nascondo i pulsanti che non voglio vedere
        component.set("v.isBackVisible", false);
        component.set("v.isNextVisible", false);
        //component.set("v.isAnnullaVisible", false);
        component.set("v.isSaveVisible", true);
        var objectId = component.get("v.objectId");
        if(objectId != null && objectId != ''){
            component.set("v.recordId", objectId);
        }

        var action = component.get("c.initComponent");
        action.setParams({stockOrderId : component.get("v.recordId")});
        action.setCallback(this, function(res){
            if(component.isValid() && res.getState() === "SUCCESS") {
                var result = res.getReturnValue();

                //passo il titolo dell'header al base wizard
                var dealer = result.dealer;
                console.log("dealer vale: ", dealer);
                console.log("2 objectId vale: "+objectId);
                var Titolo = $A.get('$Label.c.Plc_AllAllCreate') + ' Stock Order • ' + dealer;
                component.set("v.title", Titolo);

                //popolo le tabelle, ma ancora senza dati
                helper.populateTables(component, event, helper);

                // popolo le tabelle dei prodotti selected
                var productQuantitySelected = result.productQuantity;
                var productSerialSelected = result.productSerial;
                console.log('productQuantitySelected vale: ',productQuantitySelected);
                var i;
                for(i=0;i<productQuantitySelected.length;i++){
                    productQuantitySelected[i].TotalSelectedQuantity = productQuantitySelected[i].Bit2Shop__Shipped_Qty__c;
                    productQuantitySelected[i].toRemoveQuantity = 0;
                }
                console.log('productSerialSelected vale: ',productSerialSelected);
                component.set("v.selectedProductSerial", productSerialSelected);
                component.set("v.selectedProductQuantity", productQuantitySelected);

                //inizializzo il componente filter
                var filterSerialStatus = result.transferFilter;
                if(filterSerialStatus == undefined){
                    console.log("filter undefined lo setto");
                    filterSerialStatus = '';
                }
                console.log("filterSerialStatus vale: ", filterSerialStatus);
                var originWarehouse = result.originWarehouse;
                console.log("originWarehouse vale: ", originWarehouse);
                var configurationMap = {
                                            'fromGoodsHandling' : 'GoodsHandling',
                                            'filterSerialStatus' : filterSerialStatus,
                                            'originWarehouse' : originWarehouse
                                        };
                component.set("v.warehouseId", originWarehouse);
                component.set("v.stockSerialStatus", filterSerialStatus);
                component.set("v.searchConfigurationMap", configurationMap);
                //FB 20191209 - Searching serials on demand [START]
                //component.set("v.searchOnLoad", true);
                //FB 20191209 - Searching serials on demand [END]

                component.set('v.dealer', result.dealer);
                component.set('v.transferDetailSelected', result.transferFilter);

                component.set('v.transferDetailHeader', result.transferFilterHeader);
                component.set('v.originTransferDetailHeader', result.originTransferFilterHeader);
                component.set('v.originWarehouseHeader', result.originWarehouseHeader);
                component.set('v.destinationWarehouseHeader', result.destinationWarehouseHeader);
                component.set('v.destinationDealerHeader', result.destinationDealerHeader);

                component.set("v.showSpinner", false);
            }else if(component.isValid() && res.getState() === "INCOMPLETE") {
                    console.log("Error: " + res.getError()[0].message);
                }else if(component.isValid() && res.getState() === "ERROR"){
                    console.log("Sono qui Unknown error: "+res.getError()[0].message);
                }
        });
        $A.enqueueAction(action);
    },
    filterResult : function(component, event, helper){
        console.log("filterResult");
        var firstLandingInTabSearch = component.get("v.firstLandingInTabSearch");
        var filterResult = event.getParam("searchResultsEvt");
        if(event.getParam("actionType") == "removeFilters"){
            console.log("filters removed");
            helper.refreshTables(component, event, helper);
            return;
        }
        if(event.getParam("actionType") == "applyFilters" || event.getParam("actionType") == "sendCsvResults"){
            console.log("filterResult: ", filterResult);
            var productQuantity;
            var productQuantitySelected = component.get("v.selectedProductQuantity");
            //popolo la tabella dei prodotti a quantità se non sto caricando da CSV
            if(event.getParam("actionType") == "applyFilters"){
                productQuantity = filterResult.Bit2Shop__Product_Stock__c;
                //visualizzo la tabelle dei prodotti a quantità solo se ha qualcosa da mostrare o comunque ha dei prodotti già selezionati
                var noProductQ = false;
                if(productQuantity != null && productQuantity != ''){
                    if(productQuantity.length > 0){
                        component.set("v.productQuantityYes", true);
                    }else{
                        noProductQ = true;
                    }
                }
                //aggiungo la colonna quantità da selezionare  e mi salvo la quantità vecchia
                var k;
                for(k=0;k<productQuantity.length;k++){
                    productQuantity[k].SelectedQuantity = 0;
                    productQuantity[k].OriginalQuantity = productQuantity[k].Plc_AvailableQty__c;
                }
                //devo verificare se la riga è già presente tra i prodotti selezionati, in tal caso devo aggiornare la quantità disponibile
                var i;
                var y;
                for(i=0;i<productQuantitySelected.length;i++){
                    for(y=0;y<productQuantity.length;y++){
                        if(productQuantitySelected[i].Id == productQuantity[y].Id){
                            productQuantity[y].Plc_AvailableQty__c -= productQuantitySelected[i].TotalSelectedQuantity;
                            if(productQuantity[y].Plc_AvailableQty__c == 0){
                                productQuantity.splice(y,1);
                            }
                            break;
                        }
                    }
                }
            }

            //popolo la tabella dei prodotti a seriale
            //devo verificare che non sia tra le righe della tabella dei prodotti selezionati, altrimenti la devo togliere dalla tabella dei disponibili
            var productSerialSelected = component.get("v.selectedProductSerial");
            var productSerial;
            if(event.getParam("actionType") == "applyFilters"){
                productSerial = filterResult.Bit2Shop__Stock_Serials2__c;
            }else{
                productSerial = filterResult.stockSerialFromCSV;
            }
            //visualizzo le tabelle solo se hanno qualcosa da mostrare
            var noProductS = false;
            if(productSerial != null && productSerial != ''){
                if(productSerial.length > 0){
                    component.set("v.productSerialYes", true);
                }else{
                   noProductS = true
                }
            }
            var j;
            var t;
            for(j=0;j<productSerialSelected.length;j++){
                for(t=0;t<productSerial.length;t++){
                    if(productSerial[t].Id == productSerialSelected[j].Id){
                        productSerial.splice(t,1);
                        break;
                    }
                }
            }
            if((productSerial == null || productSerial == '') && (productQuantity == null || productQuantity == '')){
                component.set("v.messagePopup", $A.get('$Label.c.Plc_NoProduct'));
                component.set("v.viewPopUp", true);
            }
            if(noProductS && noProductQ){
                component.set("v.messagePopup", $A.get('$Label.c.Plc_NoProduct'));
                component.set("v.viewPopUp", true);
            }
            component.set("v.availableProductQuantity", productQuantity);
            component.set("v.availableProductSerial", productSerial);
            if(firstLandingInTabSearch){
                component.set("v.availableProductQuantityWithoutFilter", productQuantity);
                component.set("v.availableProductSerialWithoutFilter", productSerial);
                component.set("v.firstLandingInTabSearch", false);
            }
            component.set("v.showSpinner", false);
        }
    },
    handleActive : function(component, event, helper){
        console.log("handleActive");
        var tab = event.getSource();
        switch (tab.get('v.selectedTabId')) {
            case 'Ricerca' :
                //mostro i campi di ricerca
                console.log("tab ricerca cliccato");
                //disabilito il sace perchè lo abilito solo dal tab dei selezionati in modo da vedere chiaramente cosa sto salvando
                component.set('v.showFilterCmp', true);
                component.set("v.isSaveEnabled", false);
                break;
            case 'Selezionati' :
                //nascondo i campi di ricerca
                console.log("tab Selezionati cliccato");
                component.set('v.showFilterCmp', false);
                component.set("v.isSaveEnabled", true);
                break;
        }
    },
    handleSelectProductSerial : function(component, event, helper){
        console.log("handleSelectProductSerial");
        var selectedRow = event.getParam('row');
        console.log("selectedRow: ",selectedRow);
        //rimuovo la riga selezionata dalla tabella dei prodotti disponibili
        var productSerialAvailable = component.get("v.availableProductSerial");
        var j;
        for(j=0;j<productSerialAvailable.length;j++){
            if(selectedRow.Id == productSerialAvailable[j].Id){
                productSerialAvailable.splice(j,1);
            }
        }
        //aggiungo la riga selezionata nella tabella dei prodotti selezionati
        var productSerialSelected = component.get("v.selectedProductSerial");
        productSerialSelected.push(selectedRow);
        component.set("v.availableProductSerial", productSerialAvailable);
        component.set("v.selectedProductSerial", productSerialSelected);
    },
    handleSelectProductSerialSelected : function(component, event, helper){
        console.log("handleSelectProductSerialSelected");
        var selectedRow = event.getParam('row');
        console.log("selectedRow: ",selectedRow);
        //rimuovo la riga selezionata dalla tabella dei prodotti selezionati
        var productSerialSelected = component.get("v.selectedProductSerial");
        var j;
        for(j=0;j<productSerialSelected.length;j++){
            if(selectedRow.Id == productSerialSelected[j].Id){
                productSerialSelected.splice(j,1);
            }
        }
        //aggiungo la riga selezionata nella tabella dei prodotti disponibili
        var productSerialAvailable = component.get("v.availableProductSerial");
        productSerialAvailable.push(selectedRow);
        component.set("v.availableProductSerial", productSerialAvailable);
        component.set("v.selectedProductSerial", productSerialSelected);
    },
    handleOnSaveSelectedProductQuantityTable : function(component, event, helper){
        console.log("handleOnSaveSelectedProductQuantityTable");
        if(component.get("v.error")){
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
    handleOnSaveProductQuantityTable : function(component, event, helper){
        console.log("Save clicked");
        if(component.get("v.error")){
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
    handleOnCellchange : function(component, event, helper){
        console.log("handleOnCellchange");
        var rowsChanged = event.getParam('draftValues');
        var rows = component.get("v.availableProductQuantity");
        console.log("rowsChanged: ", rowsChanged);
        var i;
        var j;
        for(i=0;i<rowsChanged.length;i++){
            for(j=0;j<rows.length;j++){
                if(rowsChanged[i].Id == rows[j].Id){
                    if(rowsChanged[i].SelectedQuantity == null || rowsChanged[i].SelectedQuantity == ''){
                        component.set("v.error", true);
                        console.log("not valid vale true");
                        //console.log("j vale: ", j);
                        //console.log("rowsChanged vale: ", rowsChanged);
                        helper.displayError(component, helper, true, null);
                        return;
                    }
                    var stringToNumberSelected = parseInt(rowsChanged[i].SelectedQuantity, 10);
                    if(stringToNumberSelected > rows[j].Plc_AvailableQty__c || stringToNumberSelected < 0){
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
    closePopUp : function(component, event, helper){
        component.set("v.viewPopUp", false);
    },
    handleOnCellchangeSelected : function(component, event, helper){
        console.log("sono in handleOnCellchangeSelected");
        var rowsChanged = event.getParam('draftValues');
        var rows = component.get("v.selectedProductQuantity");
        console.log("rowsChanged: ", rowsChanged);
        var i;
        var j;
        for(i=0;i<rowsChanged.length;i++){
            for(j=0;j<rows.length;j++){
                if(rowsChanged[i].Id == rows[j].Id){
                    if(rowsChanged[i].toRemoveQuantity == null || rowsChanged[i].toRemoveQuantity == ''){
                        component.set("v.error", true);
                        helper.displayError(component, helper, true, null);
                        return;
                    }
                    var stringToNumberSelected = parseInt(rowsChanged[i].toRemoveQuantity, 10);
                    if(stringToNumberSelected > rows[j].TotalSelectedQuantity || stringToNumberSelected < 0){
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
    handleSave : function(component, event, helper){
        var titolo = component.get("v.title");
        console.log("Save clicked, titolo: "+titolo);
        var productQuantitySelected = component.get("v.selectedProductQuantity");
        var productSerialSelected = component.get("v.selectedProductSerial");
        if(productQuantitySelected.length == 0 && productSerialSelected.length == 0){
            console.log("nessun prodotto selezionato, non si puo salvare");
            component.set("v.messagePopup", $A.get('$Label.c.Plc_NessunProdotto'));
            component.set("v.viewPopUp", true);
            return;
        }
        var action = component.get("c.save");
        //var transferDetail = component.get("v.transferDetailSelected");
        //var originWarehouse = component.get("v.originWarehouseSelected");
        //var destinationWarehouse = component.get("v.destinationWareHouseSelected");
        var selectedProductSerial = component.get("v.selectedProductSerial");
        var selectedProductQuantity = component.get("v.selectedProductQuantity");
        //var note = component.get("v.note");
        action.setParams({selectedProductSerial : selectedProductSerial, selectedProductQuantity : selectedProductQuantity, StockOrderId : component.get("v.recordId")});
        action.setCallback(this, function(res){
            if(component.isValid() && res.getState() === "SUCCESS") {
                var StockOrderId = res.getReturnValue();
                component.set("v.showSpinner", false);
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                  "recordId": StockOrderId,
                  "slideDevName": "related"
                });
                navEvt.fire();
            }else if(component.isValid() && res.getState() === "INCOMPLETE") {
                    console.log("Error: " + res.getError()[0].message);
                }else if(component.isValid() && res.getState() === "ERROR"){
                    console.log("Sono qui Unknown error: "+res.getError()[0].message);
                }
        });
        component.set("v.showSpinner", true);
        $A.enqueueAction(action);
    }
})