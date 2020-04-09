({
	doInit : function(component, event, helper) {
		console.log('INSIDE DO INIT');
		var objectString = 'user'; //oggetto target -- da definire
		//objectDataMapTest: variabile mock per testare il componente se non si utilizza il wizard.
		//  var objectDataMapTest = {"merchant":{"sobjectType":"account","RecordTypeId":"","Id":"","Name":"", "OB_Legal_Address_State__c": "","Name": "","OB_Legal_Form__c": ""}};
		var objectDataMap = component.get("v.objectDataMap");
		//   component.set("v.objectDataMap", objectDataMapTest);
		//mappa = { apiName LOV : Label} -- in input
		var mappa = {
			// "Name": "MCC Description"
			"Name": "CAB"
		};
		console.log("doinit objectDataMap: " + JSON.stringify(objectDataMap));
		console.log("mappa " + JSON.stringify(mappa));
		component.set("v.mapLabelColumns", mappa);
		var mapLabelColumns = component.get("v.mapLabelColumns");
		console.log("mapLabelColumns " + JSON.stringify(mapLabelColumns));
		var mappa2 = {}; 
		//mappa2['OB_MCC_Description__c'] = 'Name';
		//mappa2['OB_MCC__c'] = 'NE__Value2__c';
		mappa2['OB_CAB__c'] = 'Name';
		mappa2['OB_ABI__c'] = 'NE__Value1__c';
		component.set("v.mapOfSourceFieldTargetField", mappa2);
		console.log("mappa 2 : " + JSON.stringify(mappa2));
		var mapOfSourceFieldTargetField = component.get("v.mapOfSourceFieldTargetField");
		console.log("mapOfSourceFieldTargetField " + JSON.stringify(mapOfSourceFieldTargetField));
		var type = component.get("v.type");
		//var subType = component.get("v.subType");
		//type = 'MCC';
		type = 'CAB';
		//SOSTITUIRE QUESTO VALORE SCHIANTATO CON IL VALORE DELL'INPUT ABI INSERITO MANUALMENTE
		//var abi = component.get("v.objectDataMap.bank.OB_ABI__c");
		//subType = abi;
		component.set("v.type", type);
		//component.set("v.subType", subType);
		component.set("v.objectString", objectString);
		component.set("v.orderBy", "Name");
		//helper.setCAB(component);
	},
	openModal_2: function(component, event, helper) {
		component.set("v.spinner", true); 
		helper.createComponent_2(component, event);
	},
	handleShowModalEvent : function(component, event, helper) {
		console.log("INTO HANDLE SHOW EVENT");
		var objectDataMap = event.getParam("objectDataMap");
		console.log("handleShowModalEvent event.getParam: " + objectDataMap);
		component.set("v.objectDataMap", objectDataMap);
	},
	
})