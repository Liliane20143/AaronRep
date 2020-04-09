({
	doInit : function(component, event, helper) {
        console.log('sono nel TEST princing component');
       var appEvent = $A.get("e.c:OB_EventNextButton");
        var stepName = component.find("stepId").get("v.value");
        console.log('name of step in princing test: ' + stepName);
        appEvent.setParams({"idStep" : stepName  });
        appEvent.fire();
		
	}
    
    
    
})