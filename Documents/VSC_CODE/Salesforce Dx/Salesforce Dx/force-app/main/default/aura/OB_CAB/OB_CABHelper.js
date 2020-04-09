({
    createComponent_2 : function(component, event) {
        console.log("INTO HELPER METHOD OF MODAL 2");
        $A.createComponent(
            "c:modalLookupWithPagination",
            {
                "aura:id": "modal",
                "objectString":component.get("v.objectString"),
                "type":component.get("v.type"),
                "subType":component.get("v.subType"),
                //merchant or bank????
                "input":component.get("v.objectDataMap.user.OB_CAB__c"),
                "mapOfSourceFieldTargetField":component.get("v.mapOfSourceFieldTargetField"),
                "mapLabelColumns":component.get("v.mapLabelColumns"),
                "objectDataMap":component.get("v.objectDataMap"),
                "messageIsEmpty":component.get("v.messageIsEmpty"),
                "orderBy":component.get("v.orderBy")
            },
            function(newModal, status, errorMessage){
                if (status === "SUCCESS") {
                    var body = component.get("v.body");
                    body.push(newModal);
                    component.set("v.body", body);
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                }
                    else if (status === "ERROR") {
                        console.log("Error: " + errorMessage);
                    }
            }
        ); 
    },
    
    setCAB: function(component) {
		console.log("setCAB");
		var CABvalue = component.find("CAB").get("v.value");
		console.log("cab : "+ JSON.stringify(component.get("v.objectDataMap.user.OB_CAB__c")));
		//SET THE SUBTYPE (ABI) TO FILTER THE CAB
		var subType = component.get("v.subType");
		var cab = component.get("v.objectDataMap.user.OB_CAB__c");
		console.log(" setCAB: "+ cab);
		subType = cab;
		component.set("v.subType", subType);
        console.log("subType after set: " + component.get("v.subType"));

	  	
	  	// micol.ferrari 14/08/2018
		// if(CABvalue!='' && CABvalue!= undefined){
	/*	if(undefined!==CABvalue && CABvalue!= ''){
			console.log("IF SET CAB");
			document.getElementById("input:unbind:UNBIND6").value='value';
			document.getElementById('input:unbind:UNBIND6').dispatchEvent(new Event('blur'));
		}else{
			document.getElementById("input:unbind:UNBIND6").value='';
			document.getElementById('input:unbind:UNBIND6').dispatchEvent(new Event('blur')); 
		} */

	}

})