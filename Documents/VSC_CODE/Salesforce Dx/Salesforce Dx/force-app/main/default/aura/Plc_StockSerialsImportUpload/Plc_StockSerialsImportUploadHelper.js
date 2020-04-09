({
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
    /* Shows a custom message defined by parameters */
    showToast: function(title, message, type, mode) {
        /* show toast message
         * mode
         * sticky: it stays on screen until user action
         * dismissable: it disappears after some time automatically
         */
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
    /* Gets from server a map that contains pairs api name/label. Used in order to get translations */
    retrieveTranslationMap: function(component, event, helper) {
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
            //After getting translations interface can be loaded
            //If a record was found then load interface binding it to
            //the upload component
            //Check also whether is edit mode
            
            var pageRef = component.get('v.pageReference');

            if (pageRef && pageRef.state && pageRef.state.c__additionalParameter) {
                let additionalParameters = JSON.parse(pageRef.state.c__additionalParameter);

                if (additionalParameters.isEditMode == 'true') {

                    component.set('v.isEditMode', true);
                    component.set('v.propertiesMap.warehouse', {Id: '', Plc_Alias__c: ''});
                    helper.resetData(component, event, helper);
                    helper.retrieveUpdateReportId(component, helper);

                } else {
                    helper.initializeInsertMode(component, helper);
                }
                
            } else {
                helper.initializeInsertMode(component, helper);
            }

        });
        $A.enqueueAction(action);
    },

    /* Used to initialize insert mode */
    initializeInsertMode: function(component, helper) {

        var pageRef = component.get('v.pageReference');

        if (pageRef && pageRef.state && pageRef.state.c__objectId) {
            component.set('v.recordId', pageRef.state.c__objectId);
            helper.retrievePropertiesMap(component, event, helper);
            helper.resetData(component, event, helper);
        } else {
            component.set('v.propertiesMap.showWarehouseSelection', true);
            helper.openModal(component, helper, 'modal-warehouses');
            component.set('v.columns', helper.getColumnDefinitions(component));
            helper.retrieveAvailableWarehouses(component, helper);
        }

    },
    retrieveUpdateReportId: function(component, helper) {

        var action = component.get('c.retrieveUpdateReport');

        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState();
            if (component.isValid() && state === 'SUCCESS'  && !result.error) {

                var result = response.getReturnValue();
                component.set('v.propertiesMap.updateReportId', result.updateReportId);

            }  else if (component.isValid() && 
                        (response.getState() === 'ERROR' || result.error)){
                if (result) {
                    helper.showToast($A.get('$Label.c.Plc_AllAllError'), result.errorMsg, 'warning', 'sticky');
                    console.error(result.errorMsg);
                }
            }
        });
        $A.enqueueAction(action);
    },
    /* Gets from server a map of config and context data */
    retrievePropertiesMap: function(component, event, helper) {
        var action = component.get('c.retrievePropertiesMap');

        action.setParams({  
            warehouseId: component.get('v.recordId')
        });

        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState();
            if (component.isValid() && state === 'SUCCESS'  && !result.error) {
                var result = response.getReturnValue();
                console.log(result.updateReportId);
                component.set('v.propertiesMap.warehouse', result.warehouse);
            }  else if (component.isValid() && 
                        (response.getState() === 'ERROR' || result.error)){
                //If some error happens then show the table to give the user
                //the chance to select the starting warehouse
                component.set('v.propertiesMap.showWarehouseSelection', true);
                helper.openModal(component, helper, 'modal-warehouses');
                component.set('v.columns', helper.getColumnDefinitions(component));
                helper.retrieveAvailableWarehouses(component, helper);
            }
        });
        $A.enqueueAction(action);
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
    /*Defines the columns (for warehouses) showed in the component */
    getColumnDefinitions: function(component) {
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
    /* Sorting column function for warehouse table */
    sortData: function(component, fieldName, sortDirection) {
        var data = component.get('v.warehousesList');
        var reverse = sortDirection !== 'asc';
        data = Object.assign([],
            data.sort(this.sortByHelper(fieldName, reverse ? -1 : 1))
        );
        component.set('v.warehousesList', data);
    },
    /* Sorting column function helper for warehouse table */
    sortByHelper: function(field, reverse, primer) {
        var key = primer
            ? function(x) { return primer(x[field]) }
            : function(x) { return x[field] };
        return function (a, b) {
            var A = key(a);
            var B = key(b);
            return reverse * ((A > B) - (B > A));
        };
    },
    /* Sorting result table function */
    sortTableBy: function(component, helper, fieldName) {
        var sortAsc = component.get('v.propertiesMap.sortAsc');
        var sortField = component.get('v.propertiesMap.sortField');
        var records = component.get('v.currentShowedDataList');
        sortAsc = !sortAsc;
        //Main sorting function
        try {
            records.sort(function(a, b){
                var valueA;
                var valueB;
                //As the warehouse is a nested object, the label must
                //be unnested
                if (fieldName == 'Bit2Shop__Warehouse_Id__c') {
                    valueA = a[fieldName].Name;
                    valueB = b[fieldName].Name;
                //The price is parsed to float
                } else if(fieldName == 'Bit2Shop__Purchase_Price__c') {
                    valueA = parseFloat(a[fieldName]);
                    valueB = parseFloat(b[fieldName]);
                //The date field is parsed to Date obj using a special function
                } else if (fieldName == 'Plc_PcipedExpiryDate__c') {
                    valueA = helper.parseItalianDateString(a[fieldName]);
                    valueB = helper.parseItalianDateString(b[fieldName]);
                } else {
                    //In all other cases just consider the field a text value
                    valueA = a[fieldName];
                    valueB = b[fieldName];
                }

                var t1 = valueA == valueB;
                var t2 = (!valueA && valueB) || (valueA < valueB);
                return t1 ? 0 : (sortAsc ? - 1: 1) * (t2 ? 1: -1);
            });
        } catch(e) {
            console.error(e);
        }

        component.set('v.propertiesMap.sortAsc', sortAsc);
        component.set('v.propertiesMap.sortField', fieldName);
        component.set('v.currentShowedDataList', records);
    },
    /* Helping function that convert a date string to a Date obj 
     * Valid date formats are 
     * - dd/mm/yyyy or dd/mm/yy
     * - dd-mm-yyyy or dd-mm-yy
     */
    parseItalianDateString: function(stringValue) {
        var value;
        //If the format is correct try to 
        //create the date...
        if (stringValue.split('/').length == 3 ) {
            value = new Date(stringValue.split('/')[2],
                             stringValue.split('/')[1] - 1,
                             stringValue.split('/')[0]);

        } else if (stringValue.split('-').length == 3) {
            value = new Date(stringValue.split('-')[2],
                             stringValue.split('-')[1] - 1,
                             stringValue.split('-')[0]);
        } else {
            //...Otherwise a very far date is set. In this case
            //the date does not influence sort result
            value = new Date(0, 0, 0);
        }
        value = (value instanceof Date && !isNaN(value)) ? value : new Date(0, 0, 0);
        return value;
    },
    /* Shows the sort arrow close to triggering field name */
    hideSortArrow: function(component) {
        component.set('v.propertiesMap.sortField', '');
        component.set('v.propertiesMap.onMouseOverField', '');
    },
    /* Redirects to a given id object page*/
    redirectToObject: function(objectId){

        window.open('/' + objectId, '_blank');
        // var navEvt = $A.get('e.force:navigateToSObject');
        // navEvt.setParams({
        //   'recordId': objectId,
        //   'slideDevName': 'detail',
        // });
        // navEvt.fire();
    },
    /* Function used to reset background and ui data */
    resetData: function(component, helper) {
        var pageSize = component.get('v.pageSize');
        component.set('v.modelSkuWarehouseToProductStockMap', {});
        component.set('v.propertiesMap.numberOfErrors', 0);
        component.set('v.propertiesMap.numberOfWarnings', 0);
        component.set('v.isAfterSaving', false);
        component.set('v.showedDataList', []);
        component.set('v.inputFileList', []);
        component.set('v.startPage', 0);
        component.set('v.endPage', pageSize - 1);
        component.find('file').set('v.value','');
    },
    /*
     * This function will be called when use clicks on next button and performs the 
     * calculation to show the next set of records
     */
    next: function(component, helper) {
        var end = component.get('v.endPage');
        var start = component.get('v.startPage');
        var pageSize = component.get('v.pageSize');
        //update utility pagination attributes shifting them
        start = start + pageSize;
        end = end + pageSize;
        component.set('v.startPage', start);
        component.set('v.endPage', end);
        helper.setShowedList(component, helper);
    },
    /* 
     * This function will be called when use clicks on previous button and performs the 
     * calculation to show the previous set of records
     */
    previous: function(component, helper) {
        var end = component.get('v.endPage');
        var start = component.get('v.startPage');
        var pageSize = component.get('v.pageSize');
        //update utility pagination attributes shifting them
        start = start - pageSize;
        end = end - pageSize;
        component.set('v.startPage', start);
        component.set('v.endPage', end);
        helper.setShowedList(component, helper);
    },
    /**
     * Function used to go to first page of data table
     */
    first: function(component, helper) {
        var pageSize = component.get('v.pageSize');
        component.set('v.startPage', 0);
        component.set('v.endPage', pageSize - 1);
        helper.setShowedList(component, helper);
    },
    /**
     * Function used to go to last page of data table
     */
    last: function(component, helper) {
        var pageSize = component.get('v.pageSize');
        let totalLength = component.get('v.showedDataList').length;
        let pageNumber = Math.floor(totalLength / pageSize);
        let remainder = totalLength % pageSize;
        if (remainder == 0) {
            pageNumber = pageNumber - 1;
        }
        component.set('v.startPage', pageNumber * pageSize);
        component.set('v.endPage', (pageNumber * pageSize) + pageSize - 1);
        helper.setShowedList(component, helper);

    },
    /* Set the slice of current showed items */
    setShowedList: function(component, helper) {
        var startIndex = component.get('v.startPage');
        var endIndex = Math.min(component.get('v.endPage') + 1, component.get('v.showedDataList').length)
        var currentShowedDataList = component.get('v.showedDataList').slice(startIndex, endIndex);
        component.set('v.currentShowedDataList', currentShowedDataList);
        helper.hideSortArrow(component);
    },
    /* Function used to set attribute that contains showed columns and errors of the html result table */
    splitAndSetShowedDataTableRows: function(component, dataTable, errorsMap, separator,
                                             warningsMap, stockSerialsIds, insertedStockSerials){

        var isAfterSaving = component.get('v.isAfterSaving');
        var warehouse = component.get('v.propertiesMap.warehouse');
        var warehouseAliasToWarehouseMap = component.get('v.warehouseAliasToWarehouseMap');
        var rowIndexToExistingIdMap = component.get('v.rowIndexToExistingIdMap');
        var insertFieldMapping = component.get('v.propertiesMap.insertFieldMapping');
        var updateFieldMapping = component.get('v.propertiesMap.updateFieldMapping');
        var stockSerialsMap = component.get('v.propertiesMap.stockSerialsMap');
        var isEditMode = component.get('v.isEditMode');
        var rowIndexToExistingIdMap = component.get('v.rowIndexToExistingIdMap');

        var dataTableToReturn = [];

        try {
        dataTable
        .forEach(function (rowAsString, rowIndex) {
            var rowToReturn = {};
            var row = rowAsString.split(separator);
            let field = '';
            //Index
            rowToReturn.index = rowIndex + 1;

            if (isEditMode) {
                field = updateFieldMapping.Plc_ManufacturerSerialNumber__c;
            } else {
                field = insertFieldMapping.Plc_ManufacturerSerialNumber__c;
            }
            //Manufacturer serial code
            rowToReturn.Plc_ManufacturerSerialNumber__c = (row[field] == undefined) ? '' : row[field];
            //Matricola calcolata (NEXI)
            if (isEditMode) {
                field = updateFieldMapping.Plc_EncodedSerialNumber__c;
            } else {
                field = insertFieldMapping.Plc_EncodedSerialNumber__c;
            }
            rowToReturn.Plc_EncodedSerialNumber__c = (row[field] == undefined) ? '' : row[field];
            //DLL Serial Number
            if (isEditMode) {
                field = updateFieldMapping.Plc_DllSerialNumber__c;
            } else {
                field = insertFieldMapping.Plc_DllSerialNumber__c;
            }
            rowToReturn.Plc_DllSerialNumber__c = (row[field] == undefined) ? '' : row[field];
            //Model (SKU)
            if (isEditMode) {
                field = updateFieldMapping.Plc_ProductSku__c;
            } else {
                field = insertFieldMapping.Plc_ProductSku__c;
            }
            rowToReturn.Plc_ProductSku__c = (row[field] == undefined) ? '' : row[field];
            //Warehouse
            // if (warehouse.Id) {
            //     rowToReturn.Bit2Shop__Warehouse_Id__c = warehouse;
            // } else {
            if (isEditMode) {
                field = updateFieldMapping.Plc_Alias__c;
            } else {
                field = insertFieldMapping.Plc_Alias__c;
            }

            if(warehouseAliasToWarehouseMap.hasOwnProperty(row[field])) {
                rowToReturn.Bit2Shop__Warehouse_Id__c = warehouseAliasToWarehouseMap[row[field]];
            } else {
                if (!row[field]) {
                    rowToReturn.Bit2Shop__Warehouse_Id__c = warehouse;
                } else {
                    rowToReturn.Bit2Shop__Warehouse_Id__c = {Id: '', Name: ''};
                }
            }
            // }
            //Warehouse alias
            rowToReturn.Plc_Alias__c =  (row[field] == undefined) ? '' : row[field];

            //Status
            if (isEditMode) {
                field = updateFieldMapping.Bit2Shop__Status__c;
            } else {
                field = insertFieldMapping.Bit2Shop__Status__c;
            }
            if (row[field]) {
                rowToReturn.Bit2Shop__Status__c = row[field];
            } else {
                if (rowIndexToExistingIdMap['' + rowIndex] == undefined ) {
                    if (isEditMode) {
                        rowToReturn.Bit2Shop__Status__c = '';
                    } else {
                        rowToReturn.Bit2Shop__Status__c = 'New';
                    }
                } else {
                    rowToReturn.Bit2Shop__Status__c = '';
                }
            }

            //Purchase Price
            if (isEditMode) {
                field = updateFieldMapping.Bit2Shop__Purchase_Price__c;
            } else {
                field = insertFieldMapping.Bit2Shop__Purchase_Price__c;
            }
            rowToReturn.Bit2Shop__Purchase_Price__c = (row[field] == undefined) ? '' : row[field];

            //Expiry Date
            if (isEditMode) {
                field = updateFieldMapping.Plc_PcipedExpiryDate__c;
            } else {
                field = insertFieldMapping.Plc_PcipedExpiryDate__c;
            }
            rowToReturn.Plc_PcipedExpiryDate__c = (row[field] == undefined) ? '' : row[field];

            if (!isEditMode) {
                //Note
                field = insertFieldMapping.Plc_Note__c;
                rowToReturn.Plc_Note__c = (row[field] == undefined) ? '' : row[field];
            } else {
                //Status 2
                field = updateFieldMapping.Plc_Status2__c;
                rowToReturn.Plc_Status2__c = (row[field] == undefined) ? '' : row[field];
            }
            
            //Check on errors. Build and show errors or warnings
            rowToReturn.icon = {};
            if (errorsMap[rowIndex] != null && errorsMap[rowIndex] != undefined) {
                rowToReturn.icon.iconName = 'utility:error';
                rowToReturn.icon.variant = 'error';
                rowToReturn.icon.size = 'small';
                rowToReturn.errors = errorsMap[rowIndex];

            } else {
                if (warningsMap[rowIndex] != null && warningsMap[rowIndex] != undefined) {
                    rowToReturn.icon.iconName = 'utility:warning';
                    rowToReturn.icon.variant = 'warning';
                    rowToReturn.icon.size = 'small';
                    rowToReturn.errors = warningsMap[rowIndex];
                } else {
                    rowToReturn.icon.iconName = 'action:approval';
                    rowToReturn.icon.variant = 'success';
                    rowToReturn.icon.size = 'xx-small';
                    rowToReturn.errors = '';
                }
            }

            if (isEditMode && rowIndexToExistingIdMap != undefined) {
                if (rowIndexToExistingIdMap.hasOwnProperty(rowIndex)) {
                    rowToReturn.stockSerial = stockSerialsMap[rowIndexToExistingIdMap[rowIndex]];
                }

            } else {
                //If it is in after insert then show calculated ids
                if (isAfterSaving && stockSerialsIds != 'undefined') {
                    rowToReturn.stockSerial = insertedStockSerials[stockSerialsIds[rowIndex]];
                }
            }

            dataTableToReturn.push(rowToReturn);
        });
        
        }catch (e) {
            console.log(e);
        }
        return dataTableToReturn;
    },
    /* Function that returns a template of csv file */
    retrieveCsvTemplateInsertMode : function(component, helper) {

        var csvStringResult = '';
        //declaring keys of csv file
        var keys = [
                     'Manufacturer Serial Number',
                     'Encoded Serial Number',
                     'Dll Serial Number',
                     'Product SKU',
                     'Warehouse Alias',
                     'Status',
                     'Purchase Price',
                     'PTS Code',
                     'PCIPED Model',
                     'PCIPED Letter of Approval',
                     'PCIPED Approval Nr.',
                     'PCIPED Version',
                     'PCIPED Expiry date',
                     'Note'
                    ];
        //declaring values of csv file
        var exampleValues = [ 
                             '1234',
                             '5678',
                             '9012',
                             'SKU007',
                             '012002NEXI',
                             'New',
                             '10',
                             'abc123',
                             'abc123',
                             'abc123',
                             'abc123',
                             'abc123',
                             '8/12/2018',
                             'Lorem Ipsum'
                            ];

        csvStringResult += keys.join(component.get('v.selectedColumnDelimiter'));
        csvStringResult += '\n';
        csvStringResult += exampleValues.join(component.get('v.selectedColumnDelimiter'));
        return csvStringResult;
    },
    /* Function that returns a template of csv file in update mode */
    retrieveCsvTemplateUpdateMode : function(component, helper) {

        var csvStringResult = '';
        //declaring keys of csv file
        var keys = [ 
                     'Stock Serial 2 ID',
                     'Warehouse Alias',
                     'Manufacturer Serial Number',
                     'Encoded Serial Number',
                     'Dll Serial Number',
                     'Product SKU',
                     'Status',
                     'Status 2',
                     'Purchase Price',
                     'PTS Code',
                     'PCIPED Model',
                     'PCIPED Letter of Approval',
                     'PCIPED Approval Nr.',
                     'PCIPED Version',
                     'PCIPED Expiry date'
                    ];
        //declaring values of csv file
        var exampleValues = [ 
                             'a1y1j000000CIJ0AAO',
                             '012002NEXI',
                             '012',
                             '345',
                             '678',
                             'abc123',
                             'New',
                             'None',
                             '10',
                             'abc123',
                             'abc123',
                             'abc123',
                             'abc123',
                             'abc123',
                             '8/12/2018'
                            ];

        csvStringResult += keys.join(component.get('v.selectedColumnDelimiter'));
        csvStringResult += '\n';
        csvStringResult += exampleValues.join(component.get('v.selectedColumnDelimiter'));
        return csvStringResult;
    },
    /* Creates a csv rapresentation of created datatable of insert mode */
    retrieveDataTableAsCsvStringInsertMode : function(component, helper) {
        var recordsToExport = component.get('v.showedDataList');
        var csvStringResult = '';
        var counter;
        var columnDivider = component.get('v.selectedColumnDelimiter');
        var lineDivider = '\n';

        var headerList = [
                           'Stock Serial 2 ID',
                           'Manufacturer Serial Number',
                           'Encoded Serial Number',
                           'DLL Serial Number',
                           'Product SKU',
                           'Warehouse Name',
                           'Warehouse Alias',
                           'Status',
                           'Purchase Price',
                           'PCIPED Expiry date',
                           'Note',
                           'Loading Status',
                           'Messages'
                          ]
        //Putting field names in the header of the file
        csvStringResult += headerList.join(columnDivider);
        csvStringResult += lineDivider;
        try {
            for (let i = 0; i < recordsToExport.length; i++) {
                if (recordsToExport[i].hasOwnProperty('stockSerial') && recordsToExport[i].stockSerial) {
                    csvStringResult += recordsToExport[i].stockSerial.Id == undefined ? '' :
                                       recordsToExport[i].stockSerial.Id;
                }
                
                csvStringResult += columnDivider;
                csvStringResult += recordsToExport[i].Plc_ManufacturerSerialNumber__c.trim() + columnDivider;
                csvStringResult += recordsToExport[i].Plc_EncodedSerialNumber__c.trim() + columnDivider;
                csvStringResult += recordsToExport[i].Plc_DllSerialNumber__c.trim() + columnDivider;
                csvStringResult += recordsToExport[i].Plc_ProductSku__c.trim() + columnDivider;
                if (recordsToExport[i].Bit2Shop__Warehouse_Id__c.Name) {
                    csvStringResult += recordsToExport[i].Bit2Shop__Warehouse_Id__c.Name.trim() + columnDivider;
                } else {
                    csvStringResult += columnDivider;
                }
                csvStringResult += recordsToExport[i].Plc_Alias__c.trim() + columnDivider;
                csvStringResult += recordsToExport[i].Bit2Shop__Status__c.trim() + columnDivider;
                csvStringResult += recordsToExport[i].Bit2Shop__Purchase_Price__c.trim() + columnDivider;
                csvStringResult += recordsToExport[i].Plc_PcipedExpiryDate__c.trim() + columnDivider;
                csvStringResult += recordsToExport[i].Plc_Note__c.trim() + columnDivider;
                csvStringResult += recordsToExport[i].icon.variant + columnDivider;
                if (recordsToExport[i].errors) {
                    csvStringResult += '"' + recordsToExport[i].errors.join('\n') + '"';
                } else if(recordsToExport[i].warnings) {
                    csvStringResult += '"' + recordsToExport[i].warnings.join('\n') + '"';
                }
                csvStringResult += lineDivider;
            }
        } catch (e) {
            console.error(e);
            return;
        } 

        return csvStringResult;
    },
    /* Creates a csv rapresentation of created datatable of update mode */
    retrieveDataTableAsCsvStringUpdateMode : function(component, helper) {
        var recordsToExport = component.get('v.showedDataList');
        var rowIndexToExistingIdMap = component.get('v.rowIndexToExistingIdMap');
        var csvStringResult = '';
        var counter;
        var columnDivider = component.get('v.selectedColumnDelimiter');
        var lineDivider = '\n';

        var headerList = [
                           'Stock Serial 2 ID',
                           'Warehouse Name',
                           'Warehouse Alias',
                           'Manufacturer Serial Number',
                           'Encoded Serial Number',
                           'DLL Serial Number',
                           'Product SKU',
                           'Status',
                           'Status2',
                           'Loading Status',
                           'Messages'
                          ]

        //Putting field names in the header of the file
        csvStringResult += headerList.join(columnDivider);
        csvStringResult += lineDivider;

        try {
            for (let i = 0; i < recordsToExport.length; i++) {
                if (rowIndexToExistingIdMap.hasOwnProperty('' + i) ) {
                    csvStringResult += rowIndexToExistingIdMap[i] == undefined ? '' :
                                       rowIndexToExistingIdMap[i];
                }
                csvStringResult += columnDivider;

                if (recordsToExport[i].Bit2Shop__Warehouse_Id__c.Name) {
                    csvStringResult += recordsToExport[i].Bit2Shop__Warehouse_Id__c.Name.trim() + columnDivider;
                } else {
                    csvStringResult += columnDivider;
                }
                csvStringResult += recordsToExport[i].Plc_Alias__c.trim() + columnDivider;
                csvStringResult += recordsToExport[i].Plc_ManufacturerSerialNumber__c.trim() + columnDivider;
                csvStringResult += recordsToExport[i].Plc_EncodedSerialNumber__c.trim() + columnDivider;
                csvStringResult += recordsToExport[i].Plc_DllSerialNumber__c.trim() + columnDivider;
                csvStringResult += recordsToExport[i].Plc_ProductSku__c.trim() + columnDivider;
                csvStringResult += recordsToExport[i].Bit2Shop__Purchase_Price__c.trim() + columnDivider;
                csvStringResult += recordsToExport[i].Plc_PcipedExpiryDate__c.trim() + columnDivider;
                csvStringResult += recordsToExport[i].Bit2Shop__Status__c.trim() + columnDivider;
                csvStringResult += recordsToExport[i].Plc_Status2__c.trim() + columnDivider;
                csvStringResult += recordsToExport[i].icon.variant + columnDivider;
                if (recordsToExport[i].errors) {
                    csvStringResult += '"' + recordsToExport[i].errors.join('\n') + '"';
                } else if(recordsToExport[i].warnings) {
                    csvStringResult += '"' + recordsToExport[i].warnings.join('\n') + '"';
                }
                csvStringResult += lineDivider;
            }
        } catch (e) {
            console.error(e);
            return;
        } 

        return csvStringResult;
    },
    /* Usedto to create and download a generated csv */
    downloadCsv : function(fileName, csvAsString) {
        if (csvAsString == null){
            return;
        }
        var link = document.createElement('a');
        link.href = 'data:text/csv;charset=utf-8,' + encodeURI(csvAsString);
        link.target = '_self';
        link.download = fileName + '.csv';  
        document.body.appendChild(link); 
        link.click();
        document.body.removeChild(link);
    },
    /* Uploads Csv data to server */
    uploadStockSerialData: function(component, event, helper) {

        var file = event.getSource().get('v.files')[0];
        component.set('v.propertiesMap.fileName', event.getSource().get('v.files')[0].name)
        var fr = new FileReader(); 
        var warehouse = component.get('v.propertiesMap.warehouse');
        var isEditMode = component.get('v.isEditMode');
        var columnDelimiter = component.get('v.selectedColumnDelimiter');
        component.set('v.propertiesMap.currentUploadedSelector', columnDelimiter);

        //bind lightning input to this function therefore when a file is loaded this function is called
        fr.onload = function (file) {
            var action = component.get('c.parseCsvInputfile');
            var base64Mark = 'base64,';
            var dataStart = fr.result.indexOf(base64Mark) + base64Mark.length;
            var fileContent = fr.result.substring(dataStart);
            helper.showToast('', $A.get('$Label.c.Plc_AllAllUploadingDataMessage') + '...', 'info');
            //Set parameters
            action.setParams({ 
                csvAsString: encodeURIComponent(fileContent),
                warehouseId: warehouse.Id,
                columnDelimiter: columnDelimiter,
                isEditMode: isEditMode
            });
            //showing loading spinner
            helper.showSpinner(component, 'main-spinner');
            //set callback
            action.setCallback(helper, function(response) {

                helper.resetData(component, helper);
                
                var result = response.getReturnValue();
                //if data is ok, then current user and list of orders obtained by CSV are downloaded
                if (component.isValid() && response.getState() === 'SUCCESS' && !result.error) {
                    //set result data
                    component.set('v.inputFileList', result.inputFileList);
                    component.set('v.disableSave', result.rowsWithErrorsSize > 0);
                    component.set('v.modelSkuWarehouseToProductStockMap', result.modelSkuWarehouseToProductStockMap);
                    component.set('v.productStockToInsert', result.productStockToInsert);
                    component.set('v.rowIndexToExistingIdMap', result.rowIndexToExistingIdMap);
                    component.set('v.warehouseAliasToWarehouseMap', result.warehouseAliasToWarehouseMap);
                    component.set('v.skuToManufacturerAlias', result.skuToManufacturerAlias);
                    component.set('v.propertiesMap.insertFieldMapping', result.insertFieldMapping);
                    component.set('v.propertiesMap.updateFieldMapping', result.updateFieldMapping);
                    component.set('v.propertiesMap.stockSerialsMap', result.stockSerialsMap);
                    component.set('v.showedDataList', helper.splitAndSetShowedDataTableRows(component, result.inputFileList, 
                                                                                            result.rowIndexErrorsListMap, 
                                                                                            columnDelimiter, result.rowIndexWarningsListMap));
                    helper.setShowedList(component, helper);
                    component.set('v.propertiesMap.numberOfWarnings', result.rowsWithWarningsSize);
                    //showing messages to user according to results
                    if (result.rowsWithErrorsSize > 0) {
                        component.set('v.propertiesMap.numberOfErrors', result.rowsWithErrorsSize);
                        helper.showToast('', 
                                         $A.get('$Label.c.Plc_LightningComponentStockSerialsImportUploadGenericRowsErrorMessage')
                                         .replace('{0}', result.rowsWithErrorsSize) +  
                                         '. ' +  $A.get('$Label.c.Plc_AllAllCheckRequest'), 
                                         'warning');
                    } else {
                        if (result.rowsWithWarningsSize > 0) {
                            helper.showToast('', 
                                              $A.get('$Label.c.Plc_LightningComponentStockSerialsImportUploadGenericRowsWarningMessage')
                                              .replace('{0}', result.rowsWithWarningsSize), 
                                              'info');
                        }

                        helper.showToast('', 
                                         $A.get('$Label.c.Plc_LightningComponentStockSerialsImportUploadOkUploadMessage'), 
                                         'success');
                    }

                } else if (component.isValid() && (response.getState() === 'ERROR' || result.error)){
                    if (result) {
                        helper.showToast($A.get('$Label.c.Plc_AllAllError'), result.errorMsg, 'warning', 'sticky');
                    } else {
                        if (response.getError() && response.getError().length > 0) {
                            helper.showToast($A.get('$Label.c.Plc_AllAllError'), 
                            response.getError()[0].exceptionType + ': ' + response.getError()[0].message, 'warning', 'sticky');
                            component.set('v.showedDataList', []);
                        }
                    }
                }
                //hide loading spinner
                helper.hideSpinner(component, 'main-spinner');
            });
            $A.enqueueAction(action);
        };
        fr.readAsDataURL(file);
    },
    /* Uploads Stock Serial data and save it to server */
    saveStockSerialData: function(component, helper) {

        var action = component.get('c.saveCsvData');
        component.set('v.isAfterSaving', true);
        var currentUploadedSelector = component.get('v.propertiesMap.currentUploadedSelector');
        //Set parameters
        action.setParams({ 
            csvAsList: component.get('v.inputFileList'),
            modelSkuWarehouseToProductStockUntypedMap: component.get('v.modelSkuWarehouseToProductStockMap'),
            productStockWrpToInsertString: component.get('v.productStockToInsert'),
            skuToManufacturerAlias: component.get('v.skuToManufacturerAlias'),
            warehouseId: component.get('v.propertiesMap.warehouse.Id'),
            rowIndexToExistingIdMap: component.get('v.rowIndexToExistingIdMap'),
            warehouseAliasToWarehouseMap : component.get('v.warehouseAliasToWarehouseMap'),
            columnDelimiter: currentUploadedSelector,
            isEditMode : component.get('v.isEditMode')
        });
        //showing loading spinner
        helper.showSpinner(component, 'main-spinner');
        component.set('v.disableSave', true);
        action.setCallback(this, function(response) {

            var result = response.getReturnValue();
            var state = response.getState();
            if (component.isValid() && state === 'SUCCESS' && !result.error) {
                var result = response.getReturnValue();
                //Set whether the response is given after saving step
                component.set('v.showedDataList', helper.splitAndSetShowedDataTableRows(component, component.get('v.inputFileList'), 
                                                                                        result.rowIndexErrorsListMap,
                                                                                        currentUploadedSelector, result.rowIndexWarningsListMap, 
                                                                                        result.stockSerialsIds, 
                                                                                        result.insertedStockSerials));
                helper.setShowedList(component, helper);
                component.set('v.propertiesMap.numberOfWarnings', result.rowsWithWarningsSize);
                if (result.rowsWithErrorsSize > 0) {
                    helper.showToast('', 
                                     $A.get('$Label.c.Plc_LightningComponentStockSerialsImportUploadKoImportMessage') + 
                                     '. ' + 
                                     $A.get('$Label.c.Plc_AllAllCheckRequest'), 
                                     'warning');
                } else {
                    if (result.rowsWithWarningsSize > 0) {
                        helper.showToast('', 
                                         $A.get('$Label.c.Plc_LightningComponentStockSerialsImportUploadGenericRowsWarningMessage')
                                         .replace('{0}', result.rowsWithWarningsSize), 
                                         'info');
                    } else {
                        if (component.get('v.isEditMode')) {
                            helper.showToast('', $A.get('$Label.c.Plc_AllAllSuccessfulSaving'), 'success');
                        } else {
                            helper.showToast($A.get('$Label.c.Plc_AllAllSuccessfulImportMessage'), 
                                         $A.get('$Label.c.Plc_LightningComponentStockSerialsImportUploadOkImportMessage'), 
                                         'success');
                        }
                    }
                }
            }  else if ((component.isValid() && 
                        (response.getState() === 'ERROR') || result.error)){
                
                if (result) {
                    //show errors otherwise
                    helper.showToast($A.get('$Label.c.Plc_AllAllError'), result.errorMsg, 'warning', 'sticky');
                    console.error(result.errorMsg);
                } else {
                    if (response.getError() && response.getError().length > 0) {
                        helper.showToast($A.get('$Label.c.Plc_AllAllError'), 
                        response.getError()[0].exceptionType + ': ' + response.getError()[0].message, 'warning', 'sticky');
                        component.set('v.showedDataList', []);
                    }
                }
            }
            //hide loading spinner
            helper.hideSpinner(component, 'main-spinner');
        });
        $A.enqueueAction(action);
    }
})