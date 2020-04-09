({
	searchRecordsHelper : function(component, event, helper, value) {
        component.set('v.showNoDataFound', false);
        component.set('v.showDataTable', false);
        component.set('v.showSpinner', true);
        component.set('v.recordsList',[]);
        component.set("v.filteredData", []);
        component.set('v.data', []); 
        
		$A.util.removeClass(component.find("Spinner"), "slds-hide");
        component.set('v.message','');
        component.set('v.recordsList',null);
        component.get('v.picklistOptions');
		// Calling Apex Method
    	var action = component.get('c.fetchRecords');
        action.setStorable();
            component.set('v.iconName', 'custom:custom21');
            component.set('v.objectName', 'Bit2Shop__Stock_Serials2__c');
            component.set('v.fieldName', 'Bit2Shop__Serial_Number__c');
            component.set('v.selectFields', 'Bit2WorkOrderNumber, Plc_Alias__c, Status, Plc_LegacyAccountId__c, Plc_LegacyServicePointId__c, Plc_ServicePoint__c, Plc_SourceLegacySystem__c, StartDate, EndDateShop__Serial_Number__c');
            component.set('v.picklistOptions', component.get('v.picklistOptions'));
            component.set('v.searchSerialNumber', component.get('v.searchSerialNumber'));
            
            action.setParams({
                'searchSerialNumber' : component.get('v.searchSerialNumber'),
                'searchTermId' : component.get('v.searchTermId'),
                'searchWorkOrder' : component.get('v.searchWorkOrder'),
                'picklistValue' : component.get('v.picklistValue')
            });            


        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            var showDataTable = component.get('v.showDataTable');
            var showNoDataFound = component.get('v.showNoDataFound');
            //alert(JSON.stringify(result));
        	if(response.getState() === 'SUCCESS') {
                // To check if any records are found for searched keyword
    			if(result.length > 0) {
    				// To check if value attribute is prepopulated or not
					if( $A.util.isEmpty(value) ) {
                        component.set('v.showSpinner', false);
                        component.set('v.recordsList',result);
                        component.set("v.filteredData", result);
                        component.set('v.data', result); 
                        component.set('v.showDataTable', true);
                        component.set('v.showNoDataFound', false);
                        //component.set('v.resultLength', result.length);
                        
                        var records =response.getReturnValue();
                        records.forEach(function(record){
                            record.label = '/'+record.value;
                        });
                        component.set("v.filteredData", records);                             
                         
                         // initialize data
					} else {
                        var result = response.getReturnValue();
                        //component.set('v.resultLength', result.length);
						var index = result.findIndex(x => x.value === value)
                        if(index != -1) {
                            var selectedRecord = result[index];
                        }
                        component.set('v.selectedRecord',selectedRecord);
                            
                        
					}
    			} else {
                    var result = response.getReturnValue();
                    component.set('v.message','No Records Found.');
                    //component.set('v.resultLength', result.length);
                    component.set("v.filteredData", []);
                    component.set('v.showDataTable', false);
                    component.set('v.showSpinner', false);
                    component.set('v.showNoDataFound', true);
    			}
        	} else if(response.getState() === 'INCOMPLETE') {
                component.set('v.message','No Server Response or client is offline');
            } else if(response.getState() === 'ERROR') {
                // If server throws any error
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    component.set('v.message', errors[0].message);
                }
            }
            // To open the drop down list of records
         
        });
        $A.enqueueAction(action);
  
        
        $A.util.removeClass(component.find("Spinner"), "slds-hide");

    },
    redirectToObject: function(objectId){

        window.open('/' + objectId, '_blank');
    },

    showWarningToast : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : $A.get("{!$Label.c.Plc_AllAllCompileOneField}"),
            message: ' ',
            duration: '3000',
            type: 'warning',
            mode: 'dismissible'
        });
        toastEvent.fire();
    }
})