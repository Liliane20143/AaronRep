({
	getOrderItems : function(component, event) {
		var orderId = component.get("v.orderId");
        var action = component.get("c.getLineAttributes");
        action.setParams({ orderId : orderId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("RESPONSE " + response.getReturnValue());
                component.set("v.orderItems", response.getReturnValue());   
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
	
})