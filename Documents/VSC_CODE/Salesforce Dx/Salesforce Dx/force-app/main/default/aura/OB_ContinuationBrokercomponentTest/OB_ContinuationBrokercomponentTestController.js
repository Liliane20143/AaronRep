({
	onContinuationRequest : function(component, event, helper) {
        console.log('sono nel onContinuationRequest');
        var methodName = event.getParam("methodName");
        var methodParams = event.getParam("methodParams");
        methodParams = JSON.parse(JSON.stringify(methodParams));
        var call = event.getParam("callback");
        console.log('sono nel onContinuationRequest, methodName'+methodName);
        console.log('sono nel onContinuationRequest, methodParams'+methodParams);
        console.log('sono nel onContinuationRequest, callback'+call);
        component.find("proxy").invoke(methodName, methodParams, call);
    }
})