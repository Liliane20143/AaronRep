/**
 * Created by capasso on 04/02/2019.
 */
({
    initComponent: function (component, event, helper) {

        if(window.location.href.indexOf("Plc_GoodsHandling") > -1) {
            component.set('v.skipOriginalMethods', true);
            //console.log('############# VALORE BOOLEANO: '+component.get('v.skipOriginalMethods'));
         }

        console.log('Plc_UploadCsvCmp - initComponent start');
        //sets dataTables columns mapping
        //FB 20190627 - NEXIPLC-590 [START]
        if (component.get('v.configurationMap').technicianWithdrawnManagement) {
            component.set('v.columnsValidData', [
                {label: $A.get("$Label.c.Plc_SerialNumberColumn"), fieldName: 'serialNumbers', type: 'text'},
                {label: $A.get("$Label.c.Plc_ManufacturerAliasColumnLabel"), fieldName: 'manufacturerAlias', type: 'text'},
                {label: $A.get("$Label.c.Plc_ProductSkuColumnLabel"), fieldName: 'productSku', type: 'text'},
                {label: $A.get("$Label.c.Plc_technicianTableField"), fieldName: 'technician', type: 'text'},
                {label: $A.get("$Label.c.Plc_ErrorColumnLabel"), fieldName: 'error', type: 'text'}
            ]);
            component.set('v.columnsInvalidData', [
                {label: $A.get("$Label.c.Plc_SerialNumberColumn"), fieldName: 'serialNumbers', type: 'text'},
                {label: $A.get("$Label.c.Plc_ManufacturerAliasColumnLabel"), fieldName: 'manufacturerAlias', type: 'text'},
                {label: $A.get("$Label.c.Plc_ProductSkuColumnLabel"), fieldName: 'productSku', type: 'text'},
                {label: $A.get("$Label.c.Plc_technicianTableField"), fieldName: 'technician', type: 'text'},
                {label: $A.get("$Label.c.Plc_ErrorColumnLabel"), fieldName: 'error', type: 'text'},
            ]);
        } else {
            component.set('v.columnsValidData', [
                {label: $A.get("$Label.c.Plc_SerialNumberColumn"), fieldName: 'serialNumbers', type: 'text'},
                {label: $A.get("$Label.c.Plc_ManufacturerAliasColumnLabel"), fieldName: 'manufacturerAlias', type: 'text'},
                {label: $A.get("$Label.c.Plc_ProductSkuColumnLabel"), fieldName: 'productSku', type: 'text'},
                {label: $A.get("$Label.c.Plc_ErrorColumnLabel"), fieldName: 'error', type: 'text'}
            ]);
            component.set('v.columnsInvalidData', [
                {label: $A.get("$Label.c.Plc_SerialNumberColumn"), fieldName: 'serialNumbers', type: 'text'},
                {label: $A.get("$Label.c.Plc_ManufacturerAliasColumnLabel"), fieldName: 'manufacturerAlias', type: 'text'},
                {label: $A.get("$Label.c.Plc_ProductSkuColumnLabel"), fieldName: 'productSku', type: 'text'},
                {label: $A.get("$Label.c.Plc_ErrorColumnLabel"), fieldName: 'error', type: 'text'},
            ]);
        }
        
        //FB 20190627 - NEXIPLC-590 [END]
    },

    handleFilesChange: function (component, event, helper) {
        console.log('Plc_UploadCsvCmp - handleFilesChange start');
        helper.h_handleFilesChange(component, event, helper);
    },

    hideModal: function (component, event, helper) {
        console.log('Plc_UploadCsvCmp -hideModal start');
        helper.h_hideModal(component, event, helper);
    },

    handleButtonAcceptRecords: function (component, event, helper) {
        console.log('Plc_UploadCsvCmp -handleButtonAcceptRecords start');
        helper.h_handleButtonAcceptRecords(component,event,helper);
    },

    toggleHelpText : function (component,event,helper) {
        console.log('Plc_UploadCsvCmp -toggleHelpText start');
        if(component.get('v.helpButtonClicked')){
            component.set('v.helpButtonClicked',false);
        }else{
            component.set('v.helpButtonClicked',true);
        }

    },

    saveAsCSV :function (component) {
        var element = document.createElement('a');
        //FB 20190627 - NEXIPLC-590 [START]
        if (component.get('v.configurationMap').technicianWithdrawnManagement) {
            element.setAttribute('href',component.get('v.CSVSampleLinkWithTechnician'));
        } else {
            element.setAttribute('href',component.get('v.CSVSampleLink'));
        }
        
        element.setAttribute('download', 'CSV_Sample.csv');
        element.style.display = 'none';
        document.body.appendChild(element);
        element.click();
        document.body.removeChild(element);
    }

});




/*testevt: function (component, event, helper) {
       //event fire when the button 'load valid record' is pressed
       var evt = $A.get("e.c:Plc_FilterEvt");
       var actionType = event.getParam("actionType");
       var searchResultsEvt = event.getParam("searchResultsEvt");
       console.log('@@@@@', actionType + '\n@@@@@@@', searchResultsEvt)
   }*/