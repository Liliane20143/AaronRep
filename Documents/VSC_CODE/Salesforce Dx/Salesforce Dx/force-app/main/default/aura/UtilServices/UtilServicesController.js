({
	/*callAjax : function(component, event, helper) {
		var request = new XMLHttpRequest();
        
		request.onreadystatechange = function(component){
			if(request.readyState == 4){
				console.log('Request: ' + request);
				params.callbackMethod.call(this,request);
			}
		};
		var params = event.getParam('arguments');
		if(params){
			console.log('Params: ' + params);
			request.open(params.method,params.url, params.asynch);
			request.send();
		}
	}*/
	getResponse : function(component, url, field) {
         var listaProvince = [];
        console.log('sono nel getResponse');
        console.log('url'+ url);
        console.log('field' + field);
		var action = component.get("c.getResult");
        console.log('action' + action);
        action.setParams({
            "url": url,
            "field": field
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.response", response.getReturnValue());
                var test = component.get("v.response");
                for (var key in test) {
                    listaProvince.push(test[key]);
                }
                component.set('v.province',listaProvince);
                console.log(component.get('v.province'));
            } else if (state === "INCOMPLETE") {
               
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
	}
})