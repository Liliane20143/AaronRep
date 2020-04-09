({
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
    }
})