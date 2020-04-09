({
	doInit : function(component, event, helper) {
		//SET COLUMS
        console.log("response into data table: " + component.get("v.dataTableList"));
        component.set("v.dataTableColumns" , [
                     {label: /*$A.get("$Label.c.Name")*/ "Shop Name ",           fieldName: 'merchantName',         type: 'text'},
                     {label: /*$A.get("$Label.c.Value_Added_Tax")*/ "MCC Code",fieldName: 'mccCode'         ,   type: 'text'}
                     ]);
          
	},
	//****METHOD TO CLOSE THE MODAL*****//
	closeModel: function(component, event, helper) { 
		component.set("v.showMerchantModal", false);
		component.set("v.showOtherInput"   , true);  //show serve point input
		component.set("v.showMerchantData"     , true); //show input name, phone , email...
		component.set( "v.toggleSpinner"   , false); //stop spinner
	},
	//****METHOD WHEN I SELECT A MERCHANT*****//
	getSelectedMerchant: function(component, event, helper) { 
		var selectedRows = event.getParam('selectedRows');
		var objectDataMap = component.get("v.objectDataMap");
		var selectServicePointArray = [];
		for (var i = 0; i < selectedRows.length; i++){
			// component.set("v.selectServicePoint", selectedRows[i]);
			selectServicePointArray.push(selectedRows[i]);
		}
		var selectServicePoint = selectServicePointArray;
		if(selectedRows.length===1){
			component.set("v.showMerchantModal", false);
			var selectedMerchant = selectedRows[selectedRows.length-1];
			//set objectDataMap with selected merchant
			component.set("v.showButtons"          , true); //show button search and new
			component.set("v.showMerchantData"     , true); //show input name, phone , email...
			component.set( "v.toggleSpinner"       , false); //stop spinner
			component.set("v.hideFiscalCode"       , true); //disable fiscal code  input
			component.set("v.hideVat"              , true); //disable vat  input
			objectDataMap.merchant.Name       = selectedMerchant.merchantName;
			objectDataMap.merchant.NE__VAT__c = selectedMerchant.vatNumber;
			objectDataMap.merchant.OB_Legal_Form__c = selectedMerchant.legalForm;
			console.log("name merchant selected is: " + objectDataMap.merchant.Name);

			component.set("v.objectDataMap" , objectDataMap);
		}
	}
})