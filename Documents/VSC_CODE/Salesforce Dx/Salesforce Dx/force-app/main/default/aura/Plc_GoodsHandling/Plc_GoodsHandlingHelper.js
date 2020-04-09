({
	initialize : function(component, helper) {
        component.set("v.showSpinner", true);

        //nascondo i pulsanti che non voglio vedere
        component.set("v.isBackVisible", false);
        //component.set("v.isNextVisible", false);
        //component.set("v.isAnnullaVisible", false);
        component.set("v.isSaveVisible", false);

        //disabilito i pulsanti che sono visibili ma non devono essere attivi
        component.set("v.isNextEnabled", false);
        //component.set("v.isBackEnabled", false);
        //component.set("v.isAnnullaEnabled", false);
        //component.set("v.isSaveEnabled", false);

        //nascondo, se necessario, il componente dei filtri
        //component.set("v.isFilterVisible", false);

        //inizializzo i campi del componente filtro altrimenti per default tutti visibili: quelli che non voglio vedere gli passo qualcosa di diverso da show, ma non campo vuoto.
        /*
        var filterToShow = component.get("v.filterToShow");
        filterToShow['rangeSerial']='show';
        filterToShow['serialFilterType']='winput';
        //filterToShow['serialFilterType']='noinput';
        filterToShow['costructorsFilter']='show';
        //filterToShow['costructorsFilter']='ee';
        filterToShow['serialStatusFilter']='show';
        filterToShow['uploadCsv']='show';
        component.set("v.filterToShow", filterToShow);
        */

        //se diverso da quello di default setto l'object sul quale deve querare il componente filtro
        //component.set("v.objectToSearch", "apinameoggetto__c");

        //inzializzo il primo combo box
        var orderTypeOptions = [];
        orderTypeOptions[0] = {'label': 'Transfer', 'value': 'Transfer'};
        component.set("v.orderTypeOptions", orderTypeOptions);
        var objectId = component.get("v.objectId");
        console.log("1 objectId vale: " + objectId);
        if (objectId != null && objectId != '') {
            component.set("v.recordId", objectId);
        }


        var action = component.get("c.initComponent");
        action.setParams({dealerId: component.get("v.recordId")});
        action.setCallback(this, function (res) {
            if (component.isValid() && res.getState() === "SUCCESS") {
                var result = res.getReturnValue();

                //passo il titolo dell'header al base wizard
                var dealer = result.dealer;
                console.log("dealer vale: ", dealer);
                console.log("2 objectId vale: " + objectId);
                var Titolo = $A.get('$Label.c.Plc_AllAllCreate') + ' Stock Order • ' + dealer.Name;
                component.set("v.title", Titolo);
                component.set("v.dealer", result.dealer);

                var transferDetails = result.transferDetails;
                console.log("transferDetails vale: ", transferDetails);
                component.set("v.transferDetails", transferDetails);
                var transferDetailsOptions = component.get("v.transferDetailsOptions");
                var i;
                for (i = 0; i < transferDetails.length; i++) {
                    transferDetailsOptions[i] = {'label': transferDetails[i].Name, 'value': transferDetails[i].Id};
                }
                component.set("v.transferDetailsOptions", transferDetailsOptions);
                component.set("v.showSpinner", false);
            } else if (component.isValid() && res.getState() === "INCOMPLETE") {
                console.log("Error: " + res.getError()[0].message);
            } else if (component.isValid() && res.getState() === "ERROR") {
                console.log("Sono qui Unknown error: " + res.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    },

    populateTables : function(component, event, helper) {
        //popolo le colonne
        component.set('v.columnsProductQuantity', [
            {label: $A.get('$Label.c.Plc_SKUProdotto'), fieldName: 'Plc_ProductSku__c', type: 'text'},
            {label: $A.get('$Label.c.Plc_Modello'), fieldName: 'Bit2Shop__Product_Description__c', type: 'text'},
            {label: $A.get('$Label.c.Plc_Costruttore'), fieldName: 'Plc_Manufacturer__c', type: 'text'},
            {label: $A.get('$Label.c.Plc_QuantitaSelezionata'), fieldName: 'SelectedQuantity', type: 'number', cellAttributes: { alignment: 'left'}, editable : 'true'},
            {label: $A.get('$Label.c.Plc_QuantitaDisponibile'), fieldName: 'Plc_AvailableQty__c', type: 'number', cellAttributes: { alignment: 'left'}}
        ]);
        component.set('v.columnsProductQuantitySelected', [
            {label: $A.get('$Label.c.Plc_SKUProdotto'), fieldName: 'Plc_ProductSku__c', type: 'text'},
            {label: $A.get('$Label.c.Plc_Modello'), fieldName: 'Bit2Shop__Product_Description__c', type: 'text'},
            {label: $A.get('$Label.c.Plc_Costruttore'), fieldName: 'Plc_Manufacturer__c', type: 'text'},
            {label: $A.get('$Label.c.Plc_QuantitaRimuovere'), fieldName: 'toRemoveQuantity', type: 'number', cellAttributes: { alignment: 'left'}, editable : 'true'},
            {label: $A.get('$Label.c.Plc_QuantitaSelezionata'), fieldName: 'TotalSelectedQuantity', type: 'number', cellAttributes: { alignment: 'left'}}
        ]);
        component.set('v.columnsProductSerialSelected', [
            {label: '', type: 'button', initialWidth: 10, typeAttributes:
                                {
                                    label: {fieldName: 'removeButton'},
                                    title: '',
                                    name: 'removeButton',
                                    iconName: 'utility:undo',
                                    class: 'btn_remove'
                                }
            },
            {label: $A.get('$Label.c.Plc_SKUProdotto'), fieldName: 'Plc_ProductSku__c', type: 'text'},
            {label: $A.get('$Label.c.Plc_Modello'), fieldName: 'Plc_Model__c', type: 'text'},
            {label: $A.get('$Label.c.Plc_Costruttore'), fieldName: 'Plc_Manufacturer__c', type: 'text'},
            {label: $A.get('$Label.c.Plc_Stato'), fieldName: 'Bit2Shop__Status__c', type: 'text'},
            {label: $A.get('$Label.c.Plc_MatricolaNexy'), fieldName: 'Plc_EncodedSerialNumber__c', type: 'text'},
            {label: $A.get('$Label.c.Plc_MatricolaCostruttore'), fieldName: 'Plc_ManufacturerSerialNumber__c', type: 'text'},
            {label: $A.get('$Label.c.Plc_MatricolaDLL'), fieldName: 'Plc_DllSerialNumber__c', type: 'text'}
        ]);

        component.set('v.columnsProductSerial', [
            {label: '', type: 'button', initialWidth: 10, typeAttributes:
                                {
                                    label: {fieldName: 'removeButton'},
                                    title: '',
                                    name: 'removeButton',
                                    iconName: 'utility:add',
                                    class: 'btn_remove'
                                }
            },
            {label: $A.get('$Label.c.Plc_SKUProdotto'), fieldName: 'Plc_ProductSku__c', type: 'text'},
            {label: $A.get('$Label.c.Plc_Modello'), fieldName: 'Plc_Model__c', type: 'text'},
            {label: $A.get('$Label.c.Plc_Costruttore'), fieldName: 'Plc_Manufacturer__c', type: 'text'},
            {label: $A.get('$Label.c.Plc_Stato'), fieldName: 'Bit2Shop__Status__c', type: 'text'},
            {label: $A.get('$Label.c.Plc_MatricolaNexy'), fieldName: 'Plc_EncodedSerialNumber__c', type: 'text'},
            {label: $A.get('$Label.c.Plc_MatricolaCostruttore'), fieldName: 'Plc_ManufacturerSerialNumber__c', type: 'text'},
            {label: $A.get('$Label.c.Plc_MatricolaDLL'), fieldName: 'Plc_DllSerialNumber__c', type: 'text'}
        ]);

	},
	updateTablesProductQuantity : function(component, event, helper, rowsChanged){
	    console.log("updateTablesProductQuantity");
	    var rows = component.get("v.availableProductQuantity");
	    var rowsSelected = component.get("v.selectedProductQuantity");
	    var i;
	    var j;
	    for(i=0;i<rowsChanged.length;i++){
	        //verifico se la riga selezionata già è presente tra quelle selezionate, in tal caso ne aggiorno la quantità selezionata
            var z;
            for(z=0;z<rowsSelected.length;z++){
                if(rowsChanged[i].Id == rowsSelected[z].Id){
                    var stringToNumberSelected = parseInt(rowsChanged[i].SelectedQuantity, 10);
                    rowsSelected[z].TotalSelectedQuantity += stringToNumberSelected;
                    rowsSelected[z].Bit2Shop__Shipped_Qty__c += stringToNumberSelected;
                    rowsSelected[z].toRemoveQuantity = 0;
                    break;
                }
            }
	        for(j=0;j<rows.length;j++){
	            if(rows[j].Id == rowsChanged[i].Id){
	                //verifico se devo aggiungere la riga selezionata alla tabella dei prodotti selezionati
	                if(rows[j].OriginalQuantity == rows[j].Plc_AvailableQty__c){
	                    rowsSelected.push(rows[j]);
	                    rowsSelected[rowsSelected.length-1].toRemoveQuantity = 0;
	                    var stringToNumberSelected = parseInt(rowsChanged[i].SelectedQuantity, 10);
	                    rowsSelected[rowsSelected.length-1].TotalSelectedQuantity = stringToNumberSelected;
	                    rowsSelected[rowsSelected.length-1].Bit2Shop__Shipped_Qty__c = stringToNumberSelected;
                    }
	                //verifico se devo togliere la riga dai prodotti disponibili o solamente aggiornarne la quantità disponibile
	                if(rowsChanged[i].SelectedQuantity == rows[j].Plc_AvailableQty__c){
	                    rows.splice(j,1);
                    }else{
                        rows[j].Plc_AvailableQty__c -= rowsChanged[i].SelectedQuantity;
                    }
	                break;
                }
            }
        }
        component.set("v.availableProductQuantity", rows);
        component.set("v.selectedProductQuantity", rowsSelected);
    },
    displayError : function(component, helper, notValid, maxQuantity){
        console.log("displayError");
        if(notValid){
            console.log("notValid");
            component.set("v.messagePopup", "Devi inserire un valore corretto nella casella quantità");
        }else{
            if(maxQuantity != null){
                console.log("notValid");
                component.set("v.messagePopup", "Quantità inserita non corretta. Puoi inserire un valore compreso tra 1 e "+maxQuantity);
            }
        }
        component.set("v.viewPopUp", true);
    },
    updateTablesProductQuantityFromSelected : function(component, event, helper, rowsChanged){
        console.log("updateTablesProductQuantityFromSelected");
        var rows = component.get("v.availableProductQuantity");
        var rowsSelected = component.get("v.selectedProductQuantity");
        var i;
        var j;
        for(i=0;i<rowsChanged.length;i++){
            //verifico se la riga selezionata già è presente tra quelle disponibili, in tal caso ne aggiorno la quantità selezionata
            var z;
            for(z=0;z<rows.length;z++){
                if(rowsChanged[i].Id == rows[z].Id){
                    var stringToNumberSelected = parseInt(rowsChanged[i].toRemoveQuantity, 10);
                    rows[z].Plc_AvailableQty__c += stringToNumberSelected;
                    rows[z].SelectedQuantity = 0;
                    break;
                }
            }
            for(j=0;j<rowsSelected.length;j++){
                if(rowsSelected[j].Id == rowsChanged[i].Id){
                    //verifico se devo aggiungere la riga selezionata alla tabella dei prodotti disponibili da quiiiii
                    if(rowsSelected[j].OriginalQuantity == rowsSelected[j].TotalSelectedQuantity){
                        rows.push(rowsSelected[j]);
                        rows[rows.length-1].SelectedQuantity = 0;
                        var stringToNumberSelected = parseInt(rowsChanged[i].toRemoveQuantity, 10);
                        rows[rows.length-1].Plc_AvailableQty__c = stringToNumberSelected;
                    }
                    //verifico se devo togliere la riga dai prodotti selezionati o solamente aggiornarne la quantità totale selezionata
                    if(rowsChanged[i].toRemoveQuantity == rowsSelected[j].TotalSelectedQuantity){
                        rowsSelected.splice(j,1);
                    }else{
                        rowsSelected[j].TotalSelectedQuantity -= rowsChanged[i].toRemoveQuantity;
                        rowsSelected[j].Bit2Shop__Shipped_Qty__c -= rowsChanged[i].toRemoveQuantity;
                    }
                    break;
                }
            }
        }
        component.set("v.availableProductQuantity", rows);
        component.set("v.selectedProductQuantity", rowsSelected);
    },
    refreshTables : function(component, event, helper){
        console.log("refreshTables started");
        var productQuantity;
        //popolo la tabella dei prodotti a quantità se non sto caricando da CSV
        //aggiungo la colonna quantità da selezionare  e mi salvo la quantità vecchia
        productQuantity = component.get("v.availableProductQuantityWithoutFilter");
        var k;
        for(k=0;k<productQuantity.length;k++){
            productQuantity[k].SelectedQuantity = 0;
            productQuantity[k].OriginalQuantity = productQuantity[k].Plc_AvailableQty__c;
        }
        //devo verificare se la riga è già presente tra i prodotti selezionati, in tal caso devo aggiornare la quantità disponibile
        var productQuantitySelected = component.get("v.selectedProductQuantity");
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

        //popolo la tabella dei prodotti a seriale
        //devo verificare che non sia tra le righe della tabella dei prodotti selezionati, altrimenti la devo togliere dalla tabella dei disponibili
        var productSerialSelected = component.get("v.selectedProductSerial");
        var productSerial;
        productSerial = component.get("v.availableProductSerialWithoutFilter");
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
        //visualizzo le tabelle solo se hanno qualcosa da mostrare
        if(productQuantity != null && productQuantity != ''){
            if(productQuantity.length > 0){
                component.set("v.productQuantityYes", true);
            }
        }
        if(productSerial != null && productSerial != ''){
            if(productSerial.length > 0){
                component.set("v.productSerialYes", true);
            }
        }
        component.set("v.availableProductQuantity", productQuantity);
        component.set("v.availableProductSerial", productSerial);
        component.set("v.showSpinner", false);
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
    /*Defines the columns (for dealers) showed in the component */
    getDealerColumnDefinitions: function(component) {
        var columns = [
            { label: component.get('v.translationMap.dealerName'), fieldName: 'Name', type:'text', sortable: true },
            { label: component.get('v.translationMap.Plc_Maintainer__c'), fieldName: 'Plc_Maintainer__c', type:'boolean' },
            { label: component.get('v.translationMap.Plc_Manufacturer__c'), fieldName: 'Plc_Manufacturer__c', type: 'boolean' },
            { label: component.get('v.translationMap.Plc_Repairer__c'), fieldName: 'Plc_Repairer__c', type:'boolean'},
            { label: component.get('v.translationMap.Plc_Scrapyard__c'), fieldName: 'Plc_Scrapyard__c', type:'boolean'},
            { label: component.get('v.translationMap.Bit2Shop__City__c'), fieldName: 'Bit2Shop__City__c', type:'text', sortable: true }
        ];
        return columns;
    },
    /* Function used to get available dealers */
    retrieveAvailableDealers: function(component, helper) {
        console.log('retrieveAvailableDealers START');
        var action = component.get('c.retrieveAvailableDealers');
        helper.showSpinner(component, 'table-spinner');

        action.setParams({
            searchKey: component.get('v.propertiesMap.searchKey')
        });

        action.setCallback(this, function(response) {

            var result = response.getReturnValue();
            var state = response.getState();

            if (component.isValid() && state === 'SUCCESS'  && !result.error) {
                var result = response.getReturnValue();
                var dealersList = result.dealersList;

                component.set('v.dealersList', dealersList);
                if (result.dealersList.length > 0) {
                    component.set('v.propertiesMap.showNoDealerIllustration', false);
                } else {
                    component.set('v.propertiesMap.showNoDealerIllustration', true);
                }
            }  else if (component.isValid() && 
                        (response.getState() === 'ERROR' || result.error)){
                
                if (result) {
                    helper.showToast($A.get('$Label.c.Plc_AllAllError'), result.errorMsg, 'warning', 'sticky');
                    console.error(result.errorMsg);
                }
            }
            helper.hideSpinner(component, 'table-spinner');

            console.log('retrieveAvailableDealers AFTERCALLBACK FINISH');
        });
        $A.enqueueAction(action);
        console.log('retrieveAvailableDealers AFTER ACTION FINISH');
    },
    /* Gets from server a map that contains pairs api name/label. Used in order to get translations */
    retrieveTranslationMap: function(component, helper) {
        var action = component.get('c.retrieveTranslationMap');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === 'SUCCESS') {
                var result = response.getReturnValue();
                //Setting translation for dealer fields
                component.set('v.translationMap.Bit2Shop__Dealer__c', result.Bit2Shop__Dealer__c);
                component.set('v.translationMap.dealerName', result.dealerName);
                component.set('v.translationMap.Bit2Shop__Parent_Dealer__c', result.Bit2Shop__Parent_Dealer__c);
                component.set('v.translationMap.Plc_Maintainer__c', result.Plc_Maintainer__c);
                component.set('v.translationMap.Plc_Manufacturer__c', result.Plc_Manufacturer__c);
                component.set('v.translationMap.Plc_Repairer__c', result.Plc_Repairer__c);
                component.set('v.translationMap.Plc_Scrapyard__c', result.Plc_Scrapyard__c);
                component.set('v.translationMap.Bit2Shop__City__c', result.Bit2Shop__City__c);
            }

            helper.openModal(component, helper, 'modal-dealers');
            component.set('v.columns', helper.getDealerColumnDefinitions(component));
            helper.retrieveAvailableDealers(component, helper);

        });
        $A.enqueueAction(action);
    },
})