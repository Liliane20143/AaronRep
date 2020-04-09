({
    doInit : function(cmp, event, helper) {
        var wizardId = cmp.get("v.wizardId");
        var objectType = cmp.get("v.objectType");
        var recordId = cmp.get("v.recordID");
        console.log("Wizard da mostrare:"+wizardId);
        $A.createComponent(
            "bit2flow:dynWizardMain",
            {
                "wizardConfigurationId": wizardId,
                "sourceVF": true,
                "objectId": recordId,
                "objectType":objectType
            },
            
            function(newCmp, status, errorMessage){
                if (status === "SUCCESS") {
                    var body = cmp.get("v.body");
                    body.push(newCmp);
                    cmp.set("v.body", body);
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                }
                    else if (status === "ERROR") {
                        console.log("Error: " + errorMessage);
                    }
            }     
        );
    }
})