({
	doInit : function(component, event, helper) {
		//SET COLUMS
		console.log("response into data table: " + component.get("v.dataTableList"));
		console.log("response into data table string: " + JSON.stringify(component.get("v.dataTableList")));
							
		console.log(JSON.stringify(component.get("v.dataTableList")));

		component.set("v.dataTableColumns" , [
                    	{label: $A.get("$Label.c.Name"),           fieldName: 'id',		type: 'number'},
                    	{label: $A.get("$Label.c.Value_Added_Tax"),fieldName: 'shopName',	type: 'text'}
					]);
			 
	},
	
	//****METHOD TO CLOSE THE MODAL*****//
	closeModel: function(component, event, helper) {
		/*
		component.set("v.showMerchantModal", false);
		component.set("v.showOtherInput"   , true);  //show serve point input
		component.set("v.showMerchantData"     , true); //show input name, phone , email...
		component.set( "v.toggleSpinner"   , false); //stop spinner
		*/
		console.log('Chiusura finestra');
		$A.get("e.force:closeQuickAction").fire(); 
	},
	
	//****METHOD WHEN I SELECT A MERCHANT*****//
	getSelectedRow: function(component, event, helper) { 
		
		var selectedRows = event.getParam('selectedRows');
		if(selectedRows.length===1)
			component.set( "v.rowSelected" , selectedRows[0]);
 
	}			
	
});