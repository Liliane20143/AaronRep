/**
 * Created by capasso on 13/03/2019.
 */
({
    initComponent: function (component,event,helper) {
        console.log('Plc_CheckStockQuantity - initComponent start');
        //sets dataTables columns mapping
        component.set('v.columnsData', [
            //{label: $A.get("$Label.c.Plc_serialsStatusColumnLabel"), fieldName: 'serialStatus', type: 'text'},
            {label: 'Logistic Division', fieldName: 'logistickDivision', type: 'text'},
            {label: 'Warehouse', fieldName: 'warehouseName', type: 'text'},
            {label: 'Solution', fieldName: 'solutionName', type: 'text'},
            {label: 'Model', fieldName: 'getListNameModel', type: 'text'},
            {label: $A.get("$Label.c.Plc_stockQuantityColumnLabel"), fieldName: 'stockQuantity', type: 'text'},
            {label: 'Available Quantity', fieldName: 'availableQuantity', type: 'text'},
            {label: 'Usable Quantity', fieldName: 'usableQuantity', type: 'text'},
            {label: 'Withdrawn Quantity', fieldName: 'withdrawnQuantity', type: 'text'},
            {label: 'Reserved Quantity', fieldName: 'reservedQuantity', type: 'text'},
            {label: 'Ordered Quantity', fieldName: 'orderQuantity', type: 'text'},
            {label: 'Other Quantity', fieldName: 'otherQuantity', type: 'text'}
        ]);

        const myPageRef = component.get('v.pageReference');
        console.log('@@@@@objectId: ', myPageRef.state.c__objectId);
        if (myPageRef.state.c__objectId) {
            component.set('v.showStep2', true);
            component.set('v.productStockId', myPageRef.state.c__objectId);
            helper.h_initComponent(component);

        } else {
            component.set('v.showStep2', true);

        }

    },

    handleCalculate: function (component, event, helper) {
        //helper.buildData(component, helper);
        //alert(component.get('v.selectedModel').B2WExtCat__External_Catalog_Item_Name__c);
        //alert(component.get('v.selectedWarehouse').Name);
        //alert(component.get('v.selectedSolution').Name);


        if ((component.get('v.selectedModel').B2WExtCat__External_Catalog_Item_Name__c == undefined || component.get('v.selectedModel').B2WExtCat__External_Catalog_Item_Name__c == '' )  && (component.get('v.selectedWarehouse').Name == undefined || component.get('v.selectedWarehouse').Name == '')  && (component.get('v.selectedSolution').Name == undefined || component.get('v.selectedSolution').Name == '')) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Warning!",
                "message": "You must select at least one filter to calculate the data for the table.",
                "type": "warning"
            });
            toastEvent.fire();
        
        }else{
            helper.h_handleCalculate(component);
        }

    },

    handleModelCustomPicklistValue: function (component, event, helper) {
        helper.h_handleModelCustomPicklistValue(component);
    },

    handleConferma: function (component, event, helper) {
        helper.h_handleConferma(component);
    },

    handleBackButton: function (component, event, helper) {
        helper.h_handleBackButton(component);
    },
    handleToggleCalculate:function (component,event,helper) {
        console.log('@@@@@toggleCalculate start');
        const inputDatetime = component.find('inputdatetime');
        const inputValue = component.find('inputdatetime').get('v.value');

        if (!inputDatetime.checkValidity()) {
            component.set('v.toggleCalculate',true);
        }else{
            inputDatetime.showHelpMessageIfInvalid();
            component.set('v.toggleCalculate',false);
        }

        if($A.util.isEmpty(inputValue)){
            component.set('v.toggleCalculate',true);
        }


    },
    handleDownloadCSV: function (component, event, helper) {
        //alert(component.get('v.selectedModel').B2WExtCat__External_Catalog_Item_Name__c);
        //alert(component.get('v.selectedWarehouse').Name);
        //alert(component.get('v.selectedSolution').Name);

        if ((component.get('v.selectedModel').B2WExtCat__External_Catalog_Item_Name__c == undefined || component.get('v.selectedModel').B2WExtCat__External_Catalog_Item_Name__c == '' )  && (component.get('v.selectedWarehouse').Name == undefined || component.get('v.selectedWarehouse').Name == '')  && (component.get('v.selectedSolution').Name == undefined || component.get('v.selectedSolution').Name == '')) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Warning!",
                "message": "You must select at least one filter to download the csv.",
                "type": "warning"
            });
            toastEvent.fire();            
        }else{
            helper.h_downloadCsv(component);            
        }
        
    },

    handleChange: function (component, event, helper) {
        // This will contain the string of the "value" attribute of the selected option
        var selectedOptionValue = event.getParam("value");
        //alert("Option selected with value: '" + selectedOptionValue + "'");
        component.set('v.selectedLogisticDivision', selectedOptionValue);
        //alert(component.get('v.selectedLogisticDivision'));
    },
    handleChangePagination: function (component, event, helper) {
        // This will contain the string of the "value" attribute of the selected option
        var selectedOptionValue = event.getParam("value");
        //alert("Option selected with value: '" + selectedOptionValue + "'");
        component.set('v.pageSize', selectedOptionValue);
        //alert(component.get('v.selectedLogisticDivision'));
    },

    onNext : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber+1);
        helper.h_handleCalculate(component);
        //helper.buildData(component, helper);
        
    },
    
    onPrev : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber-1);
        //helper.buildData(component, helper);
        helper.h_handleCalculate(component);
        },
    onFirst : function(component, event, helper) {        
        component.set("v.currentPageNumber", 1);
        //helper.buildData(component, helper);
        helper.h_handleCalculate(component);
    },
    
    onLast : function(component, event, helper) {        
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        //helper.buildData(component, helper);
        helper.h_handleCalculate(component);
    },
    processMe : function(component, event, helper) {
        component.set("v.currentPageNumber", parseInt(event.target.name));
        //helper.buildData(component, helper);
        helper.h_handleCalculate(component);
    }


});