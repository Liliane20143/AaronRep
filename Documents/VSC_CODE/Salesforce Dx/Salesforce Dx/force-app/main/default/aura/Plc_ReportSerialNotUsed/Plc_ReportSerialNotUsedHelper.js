({
    initialize: function (component) {
        console.log(`initialize --> start`);

        this.getInitialDataset(component);
        this.setTableColumns(component);
        this.getOptionSeparatorCSV(component);
    },

    getInitialDataset: function (component) {
        const call_initialize = component.get('c.initialize');

        call_initialize.setCallback(this, function (response) {
            if (component.isValid() && response.getState() === "SUCCESS") {
                if (response.getReturnValue()) {
                    component.set('v.statusPicklistValues', response.getReturnValue().statusPicklistValues);
                    console.log('statusPicklistValues : ' + JSON.stringify(component.get('v.statusPicklistValues')));
                    component.set('v.dealerChildRecordTypeId', '\'' + response.getReturnValue().dealerChildRecordTypeId + '\'');
                    component.set('v.dealerParentRecordTypeId', '\'' + response.getReturnValue().dealerParentRecordTypeId + '\'');

                }
                component.set('v.showSpinner', false);
            } else if (component.isValid() && (response.getState() === "INCOMPLETE" || response.getState() === "ERROR")) {
                console.log("initialize --> exception: " + response.getError()[0].message);
            }
        });

        component.set('v.showSpinner', true);
        $A.enqueueAction(call_initialize);
    },

    getOptionSeparatorCSV : function(component) {

        let separatorsList = [{'label' : $A.get('$Label.c.Plc_Semicolon') + ' ;', 'value' : 'semicolon'},{'label' : $A.get('$Label.c.Plc_Comma') + ' ,', 'value' : 'comma'},{'label' : $A.get('$Label.c.Plc_Custom'), 'value' : 'custom'}];

        component.set('v.optionsSeparatorsCSV', separatorsList);
    },

    setTableColumns: function (component) {
        component.set('v.tableColumns', [
            {
                label: $A.get('$Label.c.Plc_Serial'),
                type: 'button',
                typeAttributes: {
                    label: {fieldName: 'name'},
                    title: 'name',
                    class: 'btn_linkSerial',
                }
            },
            {label: $A.get('$Label.c.Plc_ManufacturerSerialNumber'), fieldName: 'manufacturerSerialNumber', type: 'text'},
            {label: $A.get('$Label.c.Plc_EncodedSerialNumber'), fieldName: 'encodedSerialNumber', type: 'text'},
            {label: $A.get('$Label.c.Plc_DllSerialNumber'), fieldName: 'dllSerialNumber', type: 'text'},
            {label: $A.get('$Label.c.Plc_Model'), fieldName: 'model', type: 'text'},
            {label: $A.get('$Label.c.Plc_ParentDealer'), fieldName: 'parentDealer', type: 'text'},
            {label: $A.get('$Label.c.Plc_ChildDealer'), fieldName: 'childDealer', type: 'text'},
            {label: $A.get('$Label.c.Plc_warehouse'), fieldName: 'warehouse', type: 'text'}
        ]);
    },

    updateDealerSelectedId: function (component, dealerSelectedId, type) {
        console.log(`updateDealerSelectedId --> start - dealerSelectedId : ${dealerSelectedId}, type : ${type}`);

        const dealerSelectedIdStringify = '\'' + dealerSelectedId + '\'';

        if (!$A.util.isEmpty(dealerSelectedId)) {
            if (type === 'parent') {
                component.set('v.dealerParentSelectedId', dealerSelectedIdStringify);
            } else if (type === 'child') {
                component.set('v.dealerChildSelectedId', dealerSelectedIdStringify);
                component.set('v.whereConditionWarehouse', ' Name LIKE :searchKey AND Bit2Shop__Dealer_Id__c = ' + dealerSelectedIdStringify);
            }
        } else {
            if (type === 'parent') {
                component.set('v.dealerParentSelectedId', '');
            } else if (type === 'child') {
                component.set('v.dealerChildSelectedId', '');
                component.set('v.whereConditionWarehouse', ' Name LIKE :searchKey ');
            }
        }
    },

    updateWarehouseId: function (component, warehouseId) {
        console.log(`updateWarehouseId --> start - warehouseId : ${warehouseId}`);

        if (!$A.util.isEmpty(warehouseId)) {
            component.set('v.warehouseSelectedId', warehouseId);
        } else {
            component.set('v.warehouseSelectedId', '');
        }
    },

    applyFilter: function (component) {
        let startDate, endDate, status, dealerChildId, dealerParentId, warehouseId, _helper;

        startDate = component.get('v.startDate');
        endDate = component.get('v.endDate');
        status = component.get('v.statusSelected');
        dealerChildId = component.get('v.dealerChildSelectedId');
        dealerParentId = component.get('v.dealerParentSelectedId');
        warehouseId = component.get('v.warehouseSelectedId');
        _helper = this;

        console.log(`applyFilter --> start - startDate : ${startDate}, endDate : ${endDate}, status : ${status}, dealerChildId : ${dealerChildId}, dealerParentId : ${dealerParentId}, warehouseId : ${warehouseId}`);

        const call_applyFilter = component.get('c.applyFilter');

        call_applyFilter.setParams({
            startDate: startDate,
            endDate: endDate,
            status: status,
            dealerChildId: dealerChildId,
            dealerParentId: dealerParentId,
            warehouseId: warehouseId
        });

        call_applyFilter.setCallback(this, function (response) {
            if (component.isValid() && response.getState() === "SUCCESS") {
                if (response.getReturnValue() != null) {
                    component.set('v.stockSerialWrapperList', response.getReturnValue());
                    console.log('im here');
                } else {
                    _helper.openModalComponent(component, 'error', $A.get('$Label.c.Plc_NoResultFound'));
                    console.log('etwtew');
                }
                component.set('v.showSpinner', false);
            } else if (component.isValid() && (response.getState() === "INCOMPLETE" || response.getState() === "ERROR")) {
                console.log("applyFilter --> exception: " + response.getError()[0].message);
            }
        });

        component.set('v.showSpinner', true);
        $A.enqueueAction(call_applyFilter);

        console.log(`applyFilter --> startDate : ${startDate}, endDate : ${endDate}, status : ${status}, dealerChildId : ${dealerChildId}, dealerParentId : ${dealerParentId}, warehouseId : ${warehouseId}`);
    },

    closeModalInfoLimit: function (component) {

        let startDate, endDate, status, dealerChildId, dealerParentId, warehouseId;

        startDate = component.get('v.startDate');
        endDate = component.get('v.endDate');
        status = component.get('v.statusSelected');
        dealerChildId = component.get('v.dealerChildSelectedId');
        dealerParentId = component.get('v.dealerParentSelectedId');
        warehouseId = component.get('v.warehouseSelectedId');

        component.set('v.fireEvent', false);

        this.applyFilter(component, startDate, endDate, status, dealerChildId, dealerParentId, warehouseId);
    },

    changeStatusPicklistValue: function (component) {
        component.set('v.statusSelected', component.find('statusPicklist').get('v.value'));
        console.log(`changeStatusPicklistValue --> statusSelected : ${component.get('v.statusSelected')}`);
    },

    openModalComponent: function (component, type, message) {
        console.log(`openModalComponent --> type : ${type}, message : ${message}`);
        component.set('v.typeMessage', type);
        component.set('v.modalMessage', message);
        component.set('v.showModal', true);
    },

    showModalExportCSV: function (component) {
        component.set('v.showModalExportCSV', true);
    },

    closeModalExportCSV: function (component) {
        component.set('v.showModalExportCSV', false);
    },

    changeExportCsvSeparator: function (component, separator) {
        console.log(`changeExportCsvSelector --> separator : ${separator}`);
        component.set('v.separatorCSV', separator);
    },

    exportCSV: function (component) {

        let separatorCSV, customSeparatorValue, stockSerialWrapperList;

        separatorCSV = component.get('v.separatorCSV');
        customSeparatorValue = component.get('v.customSeparatorValue');
        stockSerialWrapperList = component.get('v.stockSerialWrapperList');

        console.log(`exportCSV --> separatorCSV : ${separatorCSV}, customSeparatorValue : ${customSeparatorValue}`);

        if (separatorCSV == 'custom') {
            if ($A.util.isEmpty(customSeparatorValue)) {
                this.openModalComponent(component, 'info', $A.get('$Label.c.Plc_InsertCustomSeparator'));
                return;
            }
        }

        const call_exportCSV = component.get('c.exportCSV');

        call_exportCSV.setParams({
            stockSerialWrapperList: stockSerialWrapperList,
            separatorCSV: separatorCSV == 'custom' ? customSeparatorValue : separatorCSV
        });

        call_exportCSV.setCallback(this, function (response) {
            if (component.isValid() && response.getState() === "SUCCESS") {
                if (!$A.util.isEmpty(response.getReturnValue())) {

                    let element = document.createElement('a');
                    let fileName = 'SerialsNotUsed_' + this.getDate();

                    element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(response.getReturnValue()));
                    element.setAttribute('download', fileName + '.csv');
                    element.style.display = 'none';

                    document.body.appendChild(element);
                    element.click();
                    document.body.removeChild(element);
                    component.set('v.showModalExportCSV', false);

                } else {
                    component.set('v.showModalExportCSV', false);
                    this.openModalComponent(component, 'error', $A.get('$Label.c.Plc_ErrorHasOccuredDuringCSV'));
                    return;
                }
                component.set('v.showSpinner', false);
            } else if (component.isValid() && (response.getState() === "INCOMPLETE" || response.getState() === "ERROR")) {
                console.log("call_exportCSV --> exception: " + response.getError()[0].message);
            }
        });

        component.set('v.showSpinner', true);
        $A.enqueueAction(call_exportCSV);
    },

    getDate: function () {
        let today = new Date();
        let dd = today.getDate();
        let mm = today.getMonth() + 1;
        let yyyy = today.getFullYear();
        let hh = today.getHours();
        let mn = today.getMinutes();
        let ss = today.getMilliseconds();

        if (dd < 10) {
            dd = '0' + dd
        }

        if (mm < 10) {
            mm = '0' + mm
        }

        today = yyyy + mm + dd + '_' + hh + mn + ss;
        let todaySubstr = today.substr(0, today.length - 1);
        return todaySubstr;
    },

    changeDate: function (component, value, type) {

        let inputStartDateCmp, inputEndDateCmp;

        inputStartDateCmp = component.find('inputStartDate');
        inputEndDateCmp = component.find('inputEndDate');

        if (!$A.util.isEmpty(value)) {
            if (type == 'start') {
                $A.util.removeClass(inputStartDateCmp, 'slds-has-error');
            } else if (type == 'end') {
                $A.util.removeClass(inputEndDateCmp, 'slds-has-error');
            }
        } else {
            if (type == 'start') {
                $A.util.addClass(inputStartDateCmp, 'slds-has-error');
            } else if (type == 'end') {
                $A.util.addClass(inputEndDateCmp, 'slds-has-error');
            }
        }
    },

    redirectToObject: function (component, event, type) {

        if (type == 'serviceCatalog') {
            const urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": "/lightning/n/wrts_prcgvr__ServiceCatalogLtg"
            });
            urlEvent.fire();

        } else if(type == 'serial') {
            let serialId = event.getParam('row').Id;
            window.open('/lightning/r/Bit2Shop__Stock_Serials2__c/' + serialId + '/view');
        }
    },

    checkFields : function(component) {

        let status, startDate, endDate, inputStartDateCmp, inputEndDateCmp, statusPicklistCmp;

        status = component.get('v.statusSelected');
        startDate = component.get('v.startDate');
        endDate = component.get('v.endDate');
        inputStartDateCmp = component.find('inputStartDate');
        inputEndDateCmp = component.find('inputEndDate');
        statusPicklistCmp = component.find('statusPicklist');

        if($A.util.isEmpty(status)) $A.util.addClass(statusPicklistCmp, 'slds-has-error');
        if($A.util.isEmpty(startDate)) $A.util.addClass(inputStartDateCmp, 'slds-has-error');
        if($A.util.isEmpty(endDate)) $A.util.addClass(inputEndDateCmp, 'slds-has-error');
    }
})