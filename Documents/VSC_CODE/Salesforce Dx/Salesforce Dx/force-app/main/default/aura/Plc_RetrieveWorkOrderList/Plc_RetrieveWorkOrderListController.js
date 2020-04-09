({
    // To prepopulate the seleted value pill if value attribute is filled
	doInit : function( component, event, helper ) {
    	/*$A.util.toggleClass(component.find('resultsDiv'),'slds-is-open');
		if( !$A.util.isEmpty(component.get('v.value')) ) {
			helper.searchRecordsHelper( component, event, helper, component.get('v.value') );
		}*/
    },
    
    // When a keyword is entered in search box
	searchRecords : function( component, event, helper ) {
        component.set('v.showNoDataFound', false);
        component.set('v.showDataTable', false);
        component.set('v.showSpinner', true);
        component.set('v.recordsList',[]);
        component.set("v.filteredData", []);
        component.set('v.data', []); 
        var searchWorkOrder = component.get('v.searchWorkOrder');
        var searchTermId = component.get('v.searchTermId');
        var searchSerialNumber = component.get('v.searchSerialNumber');   


             if ( searchWorkOrder == '' && searchTermId == '' && searchSerialNumber == '' ) {
                helper.showWarningToast( component, event, helper, '' );
                component.set('v.showSpinner', false);               
             }
             if( searchWorkOrder != '' || searchTermId != '' || searchSerialNumber != ''  ) {
                helper.searchRecordsHelper( component, event, helper, '' );
            }
    },

    // When an item is selected
	selectItem : function( component, event, helper ) {
        if(!$A.util.isEmpty(event.currentTarget.id)) {
    		var recordsList = component.get('v.recordsList');
    		var index = recordsList.findIndex(x => x.value === event.currentTarget.id)
            if(index != -1) {
                var selectedRecord = recordsList[index];
            }

            $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
        }
	},

    // To remove the selected item.
	removeItem : function( component, event, helper ){
        component.set('v.selectedRecord','');
        component.set('v.value','');
        component.set('v.searchSerialNumber','');
        component.set('v.searchTermId','');
        component.set('v.searchWorkOrder','');
        component.set('v.fieldName', '');
        component.set('v.objectName', '');
        setTimeout( function() {
            component.find( 'inputLookup1' ).focus();
            component.find( 'inputLookup2' ).focus();
            component.find( 'inputLookup3' ).focus();
        }, 250);
    },

    // To close the dropdown if clicked outside the dropdown.
    blurEvent : function( component, event, helper ){
        /*component.set('v.recordsList', []);*/
        //component.set('v.showSpinner', false);

    },

    init: function(component, event, helper) {
        component.set('v.placeholder', $A.get("{!$Label.c.Plc_AllAllSearchLabel}")+'..');
        component.set("v.picklistOptions", [
            {'label': $A.get("{!$Label.c.Plc_LightningComponentRetrieveWorkOrderListAll}"), 'value': 'all'},
            {'label': $A.get("{!$Label.c.Plc_LightningComponentRetrieveWorkOrderListPresentOpen}"), 'value': 'stockOrderPresentOpen'},
            {'label': $A.get("{!$Label.c.Plc_LightningComponentRetrieveWorkOrderListClosedOrLines}"), 'value': 'stockOrderPresentClosed'},
            ]);
      //  alert(JSON.stringify(component.get('v.options')));
        component.set("v.columns", [
/*
            {label: 'WO Number', fieldName: 'label', type: 'url', 
            typeAttributes: {label: { fieldName: 'woNumber' }, target: '_blank'}},*/
            { 
                label: 'WO Number',
                type: 'button',
                fieldName: 'label',
                typeAttributes: {
                    label: {fieldName: 'woNumber'},
                    class: 'btn_linkProductStock',
                }
            },
            //{type:"text",label:"WO Number",fieldName:"woNumber"},
            {type:"text",label:"Work Order Alias",fieldName:"alias"},
            {type:"text",label:"Status",fieldName:"status"},
            //{type:"text",label:"Status 2",fieldName:"status2"},
            {type:"text",label:"Legacy Account Id",fieldName:"legacyAccountId"},
            {type:"text",label:"Legacy Service Point Id",fieldName:"legacyServicePointId"},
            {type:"text",label:"Service Point",fieldName:"servicepoint"},
            {type:"text",label:"Source Legacy System",fieldName:"sourceLegacySystem"},
            {label:"Start Date",fieldName:"startDate", type: 'date', typeAttributes: {  
                day: 'numeric',  
                month: 'numeric',  
                year: 'numeric',  
                hour: '2-digit',  
                minute: '2-digit',  
                hour12: false}},
            {label:"End Date",fieldName:"endDate", type: 'date', typeAttributes: {  
                day: 'numeric',  
                month: 'numeric',  
                year: 'numeric',  
                hour: '2-digit',  
                minute: '2-digit',  
                hour12: false}}]);

    },
    filter: function(component, event, helper) {
        var data = component.get("v.data"),
            term = component.get("v.filter"),
            results = data, regex;
        try {
            regex = new RegExp(term, "i");
            // filter checks each row, constructs new array where function returns true
            results = data.filter(row=>regex.test(row.woNumber) || regex.test(row.alias.toString()));
        } catch(e) {
            // invalid regex, use full list
        }
        component.set("v.filteredData", results);
    },
    handleRedirect:  function(component, event, helper) {
        helper.redirectToObject(event.getParam('row').value);
    },
    keyCheck: function (component, event, helper) {
        console.log('FilterCmp- keyCheck');
        //seatch on keyPress (13 = enter key)
        if (event.which === 13) {
            component.set('v.showNoDataFound', false);
            component.set('v.showDataTable', false);
            component.set('v.showSpinner', true);
            component.set('v.recordsList',[]);
            component.set("v.filteredData", []);
            component.set('v.data', []); 
            var a = component.get('c.searchRecords');
            $A.enqueueAction(a);
        }
    },


    handleChange: function(component, event, helper){
     /*   component.set('v.options',[]);
        component.set('v.options',[{'label': 'All', 'value': 'all'}]);
        alert*/
       //alert(component.get('v.picklistValue'));
       if (component.get('v.picklistValue')=='all') {
        var cmpTarget = component.find('comboboxListValue');
        $A.util.removeClass(cmpTarget, 'comboboxValueClosedAndLines');
        $A.util.removeClass(cmpTarget, 'comboboxValueOpen');
        $A.util.removeClass(cmpTarget, 'comboboxValueAll');
        $A.util.addClass(cmpTarget, 'comboboxValueAll');
       }
       if (component.get('v.picklistValue')=='stockOrderPresentOpen') {
        var cmpTarget = component.find('comboboxListValue');
        $A.util.removeClass(cmpTarget, 'comboboxValueClosedAndLines');
        $A.util.removeClass(cmpTarget, 'comboboxValueOpen');
        $A.util.removeClass(cmpTarget, 'comboboxValueAll');
        $A.util.addClass(cmpTarget, 'comboboxValueOpen');
       }
       if (component.get('v.picklistValue')=='stockOrderPresentClosed') {
        var cmpTarget = component.find('comboboxListValue');
        $A.util.removeClass(cmpTarget, 'comboboxValueClosedAndLines');
        $A.util.removeClass(cmpTarget, 'comboboxValueOpen');
        $A.util.removeClass(cmpTarget, 'comboboxValueAll');
        $A.util.addClass(cmpTarget, 'comboboxValueClosedAndLines');
       }
    }
})