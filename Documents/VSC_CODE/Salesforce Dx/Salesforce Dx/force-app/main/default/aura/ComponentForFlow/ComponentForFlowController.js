({
	doInit : function(component, event, helper) {
        var wizardWrapper = component.get("v.wizardWrapper");
        var objectDataMap = component.get("v.objectDataMap");
        var objectKey = component.get("v.objectKey");
        var identifier = component.get("v.identifier");
        var field = component.get("v.field"); 
        console.log("WizardWrapper:"+JSON.stringify(wizardWrapper));
        console.log("objectDataMap:"+JSON.stringify(objectDataMap));
        console.log("objectKey:"+JSON.stringify(objectKey));
        console.log("identifier:"+JSON.stringify(identifier));
        console.log("field:"+JSON.stringify(field));
		
	}
})