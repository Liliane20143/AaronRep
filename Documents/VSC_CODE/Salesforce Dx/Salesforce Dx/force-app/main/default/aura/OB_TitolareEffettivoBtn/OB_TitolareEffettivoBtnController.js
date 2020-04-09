({
	handleClick : function(component, event) {


		// console.log("****handleClick Cleaning Data****");

		// var objectDataMap = component.get("v.objectDataMap");
		var addressMapping = component.get("v.addressMapping");


		// console.log("***position from attribute: "+JSON.stringify(addressMapping.position));

		var unbindToModify = "clean" + component.get("v.addressMapping").position;


		console.log("UNBIND: "+unbindToModify);
		// objectDataMap.unbind[unbindToModify] = "hide";
		// if(unbindToModify=="clean2"){
		// 	console.log("***************If clean2");
		// 	objectDataMap.unbind[unbindToModify] = "hide2"; 
		// 	component.set("v.objectDataMap", objectDataMap);
		// 	console.log('unbind clean : ' +objectDataMap.unbind[unbindToModify]);
		// }
		// else{
		// 	console.log("***************If clean");
		// 	objectDataMap.unbind[unbindToModify] = "hide"; 
		// 	component.set("v.objectDataMap", objectDataMap);
		// 	console.log('unbind clean : ' +objectDataMap.unbind[unbindToModify]);

		// }

		var myEvent = $A.get("e.c:OB_DeleteContact");
		console.log("firing evt");
        myEvent.setParams({"position": component.get("v.addressMapping").position});
        
        myEvent.fire();
        console.log("fire evt");



	}
})