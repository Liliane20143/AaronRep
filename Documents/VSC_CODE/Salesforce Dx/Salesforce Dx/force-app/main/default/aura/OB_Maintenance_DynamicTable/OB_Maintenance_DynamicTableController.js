({
		init : function(component, event, helper) {
     	console.log('dynamicTable init started ');
     	console.log("UserWrapper summary: " + JSON.stringify(component.get("v.currentUser")));     	
     	var test = component.get("v.recordparentid"); 
		helper.retrieveFieldsLabel(component, event, helper);
		var test = component.get("v.recordparentid"); 
    },

    itemsChange :  function(component, event, helper) {
     	var test = component.get("v.recordparentid"); 
     	//console.log("itemsChange aaabbbbbccccc "+test);
    	helper.retrieveFieldsLabel(component, event, helper);
    },

    handleRowAction : function(component, event, helper) {
		var action = event.getParam('action');
		var row = event.getParam('row');

		switch (action.name) {
			case 'view_Enablements':
				helper.updateEnablements(component, event, helper,row.Id );
				component.set("v.showEnablementsModal", true);
				break;
			case 'attributeBtn':
				helper.getAssetAttribute(component,row);
				break;
			//  ANDREA MORITTU START 27-Sept-2019 ADDED MODAL OF MCC DESCRIPTION
			case 'show_mcc_description':
				component.set('v.mccClicked', true);
				helper.buildMCCmodal(component, event, row);
				break;
			//  ANDREA MORITTU END 27-Sept-2019 ADDED MODAL OF MCC DESCRIPTION
		}
    },

    updateSelectedRow :  function(component, event, helper) {
    	var selectedRows = event.getParam('selectedRows');
       	var switchOnload = 	component.get('v.switchOnload'); 

       	    	var test = component.get("v.recordparentid"); 

		//console.log("offerAssetId in updateSelectedRow?? " + selectedRows[0].Id);
		component.set('v.selectedRow',''+selectedRows[0].Id);
		console.log("before firing offerAsset event");
		if('OFFER' == component.get('v.queryType')) {
				console.log("inside firing offerAsset event");
				console.log("offerAssetId: " +  selectedRows[0].Id);
			//francesca.ribezzi - firing event to father cmp:
					var offerAssetEvent = component.getEvent("showLabelEvent");
					// var offerAssetEvent = $A.get("e.c:OB_Maintenance_DynamicTableChildEvent");
	        offerAssetEvent.setParams({
						"offerAssetId":  selectedRows[0].Id,
						"offerAsset": selectedRows[0]
	        });
	        offerAssetEvent.fire();       
			component.set('v.switchOnload',!switchOnload);
		}

    },
    
        
    closeModal:  function(component, event, helper) {
    	component.set("v.showModal", false);
	},

	/*
		*	Author		:	Moritu	Andrea
		*	Task		:	PRODOB_469
		*	Date		:	27-Sep-2019
		*	Description	:	Close MCC modal
	*/
	closeMCCmodal : function(component, event, helper) {
    	component.set("v.mccClicked", false);
	},
	
    	
})