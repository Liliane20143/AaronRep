({
    handleClick: function(component, event , helper) 
    {
        console.log("sono nel js");
        var recordId = component.get("v.recordId");
        console.log('recordId' + JSON.stringify(recordId));
        
        helper.getInfoServicePointFromSalesforce(component, event, helper);
        helper.serviceCaller(component);
        helper.updateServicePoint(component);
    }
})