/**
 * Created by capasso on 13/03/2019.
 */
({
    h_initComponent: function (component,helper) {
        const action = component.get('c.getRelativeWarhouseAndModel');
        action.setParams({
            prodstockId: component.get('v.productStockId')
        });

        action.setCallback(this, function (res) {
            if (component.isValid() && res.getState() === "SUCCESS") {
                const results = res.getReturnValue();
                console.log("success callback h_initComponent: ", results);

                component.set('v.selectedModel', {Id:results.Bit2Shop__External_Catalog_Item_Id__c, B2WExtCat__External_Catalog_Item_Name__c: results.Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c});
                component.set('v.selectedWarehouse', {Id:results.Bit2Shop__Warehouse_Id__c, Name: results.Bit2Shop__Warehouse_Id__r.Name});
                component.set('v.selectedLogisticDivision',results.Bit2Shop__Warehouse_Id__r.Plc_LogisticDivision__c);
                component.set('v.placeHolderCombobox',results.Bit2Shop__Warehouse_Id__r.Plc_LogisticDivision__c);// results.Bit2Shop__Warehouse_Id__r.Plc_LogisticDivision__c);
                //** [START MOD 2019-08-21] @Author:Luca Belometti @Description: Added 2 new fields to show  */
                component.set('v.selectedSolution', {Id:results.Id, Name: results.Plc_Solution__c});
                
                //** [END MOD 2019-08-21] @Author:Luca Belometti @Description: Added 2 new fields to show  */

                results.Bit2Shop__Warehouse_Id__r.Plc_LogisticDivision__c


                component.set('v.showSpinner', false);

                console.log('@@@@@modelToShow: ', component.get('v.modelToShow'));
                console.log('@@@@@warehouseToShow: ', component.get('v.warehouseToShow'));

            } else if (component.isValid() && res.getState() === "INCOMPLETE") {
                console.log("Error in h_initComponent: " + res.getError()[0].message);

            } else if (component.isValid() && res.getState() === "ERROR") {
                console.log("Unknown error in h_initComponent: " + res.getError()[0].message);

            }
        });
        component.set('v.showSpinner', true);
        $A.enqueueAction(action);
    },

    //determine what data can be shown in the externalcatalog custom Picklist
    h_handleModelCustomPicklistValue: function (component) {

        const action = component.get('c.filterModelLookup');
        action.setParams({warehouseId: component.get('v.selectedWarehouse').Id});
        action.setCallback(this, function (res) {
            if (component.isValid() && res.getState() === "SUCCESS") {

                const results = res.getReturnValue();
                console.log("success callback h_handleModelCustomPicklistValue", results);

                //if result is empty show modal
                if (results === '') {
                    component.set('v.showModal', true);
                    component.set('v.modalMessage', $A.get("$Label.c.Plc_NoModelAvailable"));
                    //if result different form null enable next picklist
                } else if (results != null) {
                    component.set('v.IsModelLookupDisabled', false);
                    //if result null disable ModelLookup and reset model pickList
                } else {
                    //this.refreshModelPicklist(component);
                    setTimeout(() => component.set('v.IsModelLookupDisabled', true), 100);
                }

                component.set('v.externalCatItem', results);

                component.set('v.showSpinner', false);

            } else if (component.isValid() && res.getState() === "INCOMPLETE") {
                console.log("Error in h_handleModelCustomPicklistValue: " + res.getError()[0].message);

            } else if (component.isValid() && res.getState() === "ERROR") {
                console.log("Unknown error in h_handleModelCustomPicklistValue: " + res.getError()[0].message);

            }
        });
        component.set('v.showSpinner', true);
        $A.enqueueAction(action);
    },

    h_handleConferma: function (component) {
        console.log('@@@@@selectedModelId: ', component.get('v.selectedModel').Id);
        console.log('@@@@@selectedWarehouseId: ', component.get('v.selectedWarehouse').Id);
        console.log('@@@@@selectedSolution: ', component.get('v.selectedSolution').Name);
        console.log('@@@@@selectedLogisticDivision: ', component.get('v.selectedLogisticDivision').Plc_LogisticDivision__c);
        

        const action = component.get('c.getRelativeProductStock');
        action.setParams({
            extCatId: component.get('v.selectedModel').Id,
            warehouseId: component.get('v.selectedWarehouse').Id,
            //** [START MOD 2019-08-19] @Author:Luca Belometti @Description: Added 2 parameters to send to Apex Class */
            solutionName: component.get('v.selectedSolution').Name,
            logistickDivisionId: component.get('v.selectedLogisticDivision').Plc_LogisticDivision__c
            //** [END MOD 2019-08-19] @Author:Luca Belometti @Description: Added 2 parameters to send to Apex Class */
        });

        action.setCallback(this, function (res) {
            if (component.isValid() && res.getState() === "SUCCESS") {
                const results = res.getReturnValue();
                console.log("success callback h_handleConferma: ", results);

                if (!results) {//if result is null show popup
                    component.set('v.showModal', true);
                    component.set('v.modalMessage', $A.get("$Label.c.Plc_ProductStockNotFound"));
                    component.set('v.showSpinner', false);
                    return;
                }
                component.set('v.showStep1', false);
                component.set('v.showStep2', true);
                component.set('v.modelToShow', component.get('v.selectedModel').B2WExtCat__External_Catalog_Item_Name__c);
                component.set('v.warehouseToShow', component.get('v.selectedWarehouse').Name);
                //** [START MOD 2019-08-19] @Author:Luca Belometti @Description:  Added the fields Solutions and Logisti Division */
                component.set('v.logisticDivisionToShow', component.get('v.selectedLogisticDivision').Plc_LogisticDivision__c);
                component.set('v.solutionToShow', component.get('v.selectedSolution').Name);
                //** [END MOD 2019-08-19] @Author:Luca Belometti @Description: Added the fields Solutions and Logisti Division */

                component.set('v.productStockId', results.Id);

                component.set('v.showSpinner', false);

            } else if (component.isValid() && res.getState() === "INCOMPLETE") {
                console.log("Error in h_handleConferma: " + res.getError()[0].message);

            } else if (component.isValid() && res.getState() === "ERROR") {
                console.log("Unknown error in h_handleConferma: " + res.getError()[0].message);

            }
        });
        component.set('v.showSpinner', true);
        $A.enqueueAction(action);
    },
     
    /*
     * this function generate page list
     * */
    generatePageList : function(component, helper, pageNumber){
        pageNumber = parseInt(pageNumber);
        var pageList = [];
        var totalPages = component.get("v.totalPages");
        if(totalPages > 1){
            if(totalPages <= 10){
                var counter = 2;
                for(; counter < (totalPages); counter++){
                    pageList.push(counter);
                } 
            } else{
                if(pageNumber < 5){
                    pageList.push(2, 3, 4, 5, 6);
                } else{
                    if(pageNumber>(totalPages-5)){
                        pageList.push(totalPages-5, totalPages-4, totalPages-3, totalPages-2, totalPages-1);
                    } else{
                        pageList.push(pageNumber-2, pageNumber-1, pageNumber, pageNumber+1, pageNumber+2);
                    }
                }
            }
        }
        component.set("v.pageList", pageList);
    },

    h_handleCalculate: function (component,helper) {
        component.set('v.showSpinner', true);
        console.log('@@@@@h_handleCalculate-Start');
        component.set('v.data', '');
        component.set('v.dataToshow', []);
        component.set('v.data', []);

        const inputDateTime = component.get('v.inputDateTime');
        let dataTables = [{}];
        console.log('@@@@@inputDateTime: ', component.get("v.inputDateTime"));

        if(!inputDateTime){
            component.set('v.showSpinner', false);
            return;
        }

        const action = component.get('c.getData1');
        //action.setParams({productStockId: component.get('v.productStockId'), inputDate: inputDateTime});
        action.setParams({warehouseId: component.get('v.selectedWarehouse').Id,
                          externalCatalogItemId: component.get('v.selectedModel').Id,
                          logistickDivision: component.get('v.selectedLogisticDivision')/*.Plc_LogisticDivision__c*/,
                          solutionName: component.get('v.selectedSolution').Name,
                          inputDate: inputDateTime});

        action.setCallback(this, function (res) {
            const results = res.getReturnValue();
            if (results == null) {
                component.set('v.showModal', true);
                component.set('v.modalMessage', $A.get("$Label.c.Plc_NoDataFound"));
                component.set('v.isCalculatePerformed', false);
                component.set('v.showSpinner', false);
        }

            if (component.isValid() && res.getState() === "SUCCESS" && results != null) {

                const results = res.getReturnValue();
                const stockSerials = res.getReturnValue().stockSerials;
                const stockSerialsAvailable = res.getReturnValue().usableQuantity;
                const withdrawnSerials = res.getReturnValue().getWithdrawnSerials;
                const getCountSerials = res.getReturnValue().getCountSerials;
                const getListName = res.getReturnValue().getListName;
                const getListNameQuantity = res.getReturnValue().getListNameQuantity;
                const getListNameModel = res.getReturnValue().getListNameModelWrp;
                const getListSolution = res.getReturnValue().getListNameSolution;
                let countStockSerials = 0;

                console.log("success callback getData", results);
                //component.set('v.reservedQty', results.reservedQuantity);
                component.set('v.orderedQty', results.orderQuantity);
                component.set('v.stockSerialsTotalQty', countStockSerials); 

                    var dataObj = JSON.parse(results);
                    var valorePerPaginazione = 0;
                    var sommaStockQuantity = 0;
                    var sommaUsableQuantity = 0;
                    var sommaOrderedQuantity = 0;
                    var sommaWithdrawnQuantity = 0;
                    var sommaReservedQuantity = 0;
                    var sommaAvailableQuantity = 0;
                    var sommaOtherQuantity = 0;
                    
                    Object.keys(dataObj).forEach(function(key) {
                        //alert('test1');
                        valorePerPaginazione ++;
                        sommaStockQuantity += dataObj[key].stock;
                        sommaOrderedQuantity += dataObj[key].ordered;
                        sommaUsableQuantity += dataObj[key].usable;
                        sommaWithdrawnQuantity += dataObj[key].withdrawn;
                        sommaReservedQuantity += dataObj[key].reserved;
                        sommaOtherQuantity += dataObj[key].stock - (dataObj[key].usable + dataObj[key].withdrawn);
                        sommaAvailableQuantity += dataObj[key].usable + dataObj[key].withdrawn - dataObj[key].reserved;
                        var value = dataObj[key].withdrawn;
                        dataTables.push({
                        orderQuantity:  String(dataObj[key].ordered),
                        stockQuantity: String(dataObj[key].stock),
                        usableQuantity: String(dataObj[key].usable),
                        withdrawnQuantity: String(dataObj[key].withdrawn),
                        reservedQuantity: String(dataObj[key].reserved),
                        warehouseName: dataObj[key].warehouse,
                        logistickDivision: dataObj[key].logistickDivisionName,
                        getListNameModel: dataObj[key].modelName,
                        solutionName: dataObj[key].solutionName,
                        otherQuantity: String(dataObj[key].stock - (dataObj[key].usable + dataObj[key].withdrawn)),
                        availableQuantity: String(dataObj[key].usable + dataObj[key].withdrawn - dataObj[key].reserved)
                     });
                    });    
                    component.set('v.sumStockQty', sommaStockQuantity );
                    component.set('v.sumOrderedQty', sommaOrderedQuantity );
                    component.set('v.sumUsabledQty', sommaUsableQuantity );
                    component.set('v.sumWithdrawnQty', sommaWithdrawnQuantity );
                    component.set('v.sumOtherQty', sommaOtherQuantity );
                    component.set('v.sumReservedQty', sommaReservedQuantity );
                    component.set('v.sumAvailableQty', sommaAvailableQuantity );


                    //console.log(JSON.stringify(results));

                       /* for (let i = 0; i < results; i++) {

                        }*/
    
                        dataTables.splice(0, 1);
                        component.set('v.dataToshow', dataTables);
                        component.set("v.totalPages", Math.ceil(valorePerPaginazione/component.get("v.pageSize")));
                        component.set("v.allData", component.get('v.dataToshow'));

                component.set('v.isCalculatePerformed', true);
                component.set('v.showSpinner', false);
                

            } else if (component.isValid() && res.getState() === "INCOMPLETE") {
                console.log("Error in h_handleCalculate: " + res.getError()[0].message);

            } else if (component.isValid() && res.getState() === "ERROR") {
                console.log("Unknown error in h_handleCalculate: " + res.getError()[0].message);

            }

              
        //component.set('v.showSpinner', true);
        //** [START MOD 2019-08-21] @Author:Luca Belometti @Description: 
        component.set('v.toggleDownloadCsv', false);
        //** [END MOD 2019-08-21] @Author:Luca Belometti @Description:
        var data = [];
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var allData = component.get("v.allData");
        var x = (pageNumber-1)*pageSize;
        
        //creating data-table data
        for(; x<=(pageNumber)*pageSize; x++){
            if(allData[x]){
                data.push(allData[x]);
            }
        }
        component.set("v.data", data);

        pageNumber = parseInt(pageNumber);
        var pageList = [];
        var totalPages = component.get("v.totalPages");
        if (totalPages > 5) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "",
                "message":  $A.get("$Label.c.Plc_AllAllDownloadCsvData"),
                "type": "warning"
            });
            toastEvent.fire();              
        }
        if(totalPages > 1){
            if(totalPages <= 10){
                var counter = 2;
                for(; counter < (totalPages); counter++){
                    pageList.push(counter);
                } 
            } else{
                if(pageNumber < 5){
                    pageList.push(2, 3, 4, 5, 6);
                } else{
                    if(pageNumber>(totalPages-5)){
                        pageList.push(totalPages-5, totalPages-4, totalPages-3, totalPages-2, totalPages-1);
                    } else{
                        pageList.push(pageNumber-2, pageNumber-1, pageNumber, pageNumber+1, pageNumber+2);
                    }
                }
            }
        }
        
        });
        //component.set('v.showSpinner', false);
      
        //helper.generatePageList(component, pageNumber,helper);
        $A.enqueueAction(action);
       /* var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Warning!",
            "message": "Download the csv file to see all data retrieved.",
            "type": "warning"
        });*/
        //component.set('v.showSpinner', false);
    },

    h_handleBackButton: function (component) {
        console.log('@@@@@h_handleBackButton-Start ');
        const backStep = component.find('confirm-button');
        const myPageRef = component.get('v.pageReference');
        console.log('@@@@@actionType: ', myPageRef.state.c__actionType);

        if (backStep) {
            window.location = '/lightning/n/wrts_prcgvr__ServiceCatalogLtg';
        } else if (myPageRef.state.c__actionType) {
            history.back()
        } else {
            component.set('v.showStep2', false);
            component.set('v.showStep1', true);
            component.set('v.isCalculatePerformed', false);
        }

    },

    refreshModelPicklist: function (component) {
        console.log('@@@@@refreshModelPicklist ');
        component.set('v.selectedModel', '');
        component.set('v.externalCatItem', '');
        component.set('v.selectedLogisticDivision', '');
        component.set('v.selectedSolution', '');        
        component.set('v.resetModelPicklist', false);
        component.set('v.resetModelPicklist', true);

    },

        /* Usedto to create and download a generated csv */
        h_downloadCsv : function(component,fileName, csvAsString) {
            
            var csvStringResult = '';
            var counter;
            var columnDivider = component.get('v.selectedColumnDelimiter');
            var lineDivider = '\n';
            //alert(JSON.stringify(component.get('v.dataToshow')));
            console.log(component.get('v.dataToshow'));
            var listaSuCuiLavorare = component.get('v.dataToshow');
            //alert(JSON.stringify(component.get('v.dataToshow')));
            var serialStatus = listaSuCuiLavorare.map(function(serialStatusValue) {
                //return valore['serialStatus'];
                return serialStatusValue['serialStatus'];
              });
            
            var stockQuantity = listaSuCuiLavorare.map(function(stockQuantityValue) {
                //return valore['serialStatus'];
                return stockQuantityValue['stockQuantity'];
              });
            var solutionName = listaSuCuiLavorare.map(function(solutionNameValue) {
                //return valore['serialStatus'];
                return solutionNameValue['solutionName'];
              });
            var availableQuantity = listaSuCuiLavorare.map(function(availableQuantityValue) {
                //return valore['serialStatus'];
                return availableQuantityValue['availableQuantity'];
              });
            
            var withdrawnQuantity = listaSuCuiLavorare.map(function(withdrawnQuantityValue) {
                //return valore['serialStatus'];
                return withdrawnQuantityValue['withdrawnQuantity'];
              });

            var reservedQuantity = listaSuCuiLavorare.map(function(reservedQuantityValue) {
                //return valore['serialStatus'];
                return reservedQuantityValue['reservedQuantity'];
              });

            var orderQuantity = listaSuCuiLavorare.map(function(orderQuantityValue) {
                //return valore['serialStatus'];
                return orderQuantityValue['orderQuantity'];
              });

            var usableQuantity = listaSuCuiLavorare.map(function(usableQuantityValue) {
                //return valore['serialStatus'];
                return usableQuantityValue['usableQuantity'];
              });

            var otherQuantity = listaSuCuiLavorare.map(function(otherQuantityValue) {
                //return valore['serialStatus'];
                return otherQuantityValue['otherQuantity'];
              });


            var logistickDivision = listaSuCuiLavorare.map(function(logistickDivisionValue) {
                //return valore['serialStatus'];
                return logistickDivisionValue['logistickDivision'];
              });

            var getListNameModel = listaSuCuiLavorare.map(function(getListNameModelValue) {
                //return valore['serialStatus'];
                return getListNameModelValue['getListNameModel'];
              });

            var selectedModel = listaSuCuiLavorare.map(function(selectedModelValue) {
                //return valore['serialStatus'];
                return selectedModelValue['selectedModel'];
              });

            var getListName = listaSuCuiLavorare.map(function(getListNameValue) {
                //return valore['serialStatus'];
                return getListNameValue['getListName'];
              });

            var warehouseName = listaSuCuiLavorare.map(function(warehouseNameValue) {
                return warehouseNameValue['warehouseName'];
              });


            var headerList = [
                               'Warehouse',
                               'Model',
                               'Logistic Division',
                               'Solution',
                               'Stock Quantity',
                               'Reserved Quantity',
                               'Ordered Quantity'
                              ]

            var dateTimeFull = new Date(component.get('v.inputDateTime'));
            var month = parseInt(dateTimeFull.getMonth() + 1);
            if (month < 10) {
                month = '0' + month;
            }
            
            var dateToCsv =  dateTimeFull.getDate() + '/' + month + '/' + dateTimeFull.getFullYear();
            var hours = dateTimeFull.getHours();

            if (hours < 10) {
                hours = '0' + hours;                
            }

            var minutes = dateTimeFull.getMinutes();

            if (minutes < 10 ) {
                minutes = '0' + minutes;
            }

            var timeToCsv = hours + ':' + minutes;
            var dateTimeParameter = dateTimeFull.getFullYear() + '-' + month + '-' + dateTimeFull.getDate() + 'T'+
            hours+':'+ minutes+':'+'00.000Z';

            if (component.get('v.selectedWarehouse').Id == undefined) {
                component.set('v.selectedWarehouse', {Id:'', Name: ''});
            }
     
            var url = '/apex/Plc_ExportDataToCsv?warehouseId='+component.get('v.selectedWarehouse').Id+'&solutionName=' + component.get('v.selectedSolution').Name + 
            '&modelId=' + component.get('v.selectedModel').Id + 
            '&ldnName=' +component.get('v.selectedLogisticDivision') + 
            '&warehouseName=' + component.get('v.selectedWarehouse').Name + '&modelName=' + component.get('v.selectedModel').B2WExtCat__External_Catalog_Item_Name__c +
            '&date=' + dateToCsv + '&time=' + timeToCsv + '&dateAndTime='+dateTimeParameter;

            window.open(url, '_self');
        }
    //** [END MOD 2019-08-22] @Author:Luca Belometti @Description: */
});