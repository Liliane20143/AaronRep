({
	doInit : function(component, event, helper) {
	       console.log("sono nel LINE ITEM ATTRIBUTE");
        var objMap = component.get("v.objectDataMap");
         console.log("objMap: " + JSON.stringify(objMap));
         var orderId = objMap.orderId.orderId;
            console.log("valore Unbind prima del set: " + orderId);
        component.set("v.orderId", orderId);
        
        var order = component.get("v.orderId");
        console.log("valore Unbind dopo il set: " + order);
        
		//var orderId = component.get("v.orderId");
		console.log("id dell'order: " + order);
		helper.getOrderItems(component, event);
	}
})