({
	searchOrder : function(component, event) {
        var orderId = component.get("v.order");
        var action = component.get("c.retrieveOrder");
        console.log("Param: " + orderId);
        action.setParams({
            "orderId": orderId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
               console.log("success!");
       		   component.set("v.orderItems", response.getReturnValue());   
               var orderItems = component.get("v.orderItems");
               console.log("order Items: " + JSON.stringify(orderItems));
                  console.log("order Items: " + orderItems.length);

                }

        });
        $A.enqueueAction(action);
    },
})