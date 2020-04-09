({
	doInit : function(component, event, helper) {
        /*console.log(" sono nel doInit");
        var nextButton = document.getElementsByClassName("slds-button slds-button--brand");
        console.log("il documento è: " + document);
        console.log("nextButton " + nextButton.length);
		   for(var i=0; i<nextButton.length; i++){
                console.log("sono nel for del next");
                nextButton[i].setAttribute('onclick',"");
                nextButton[i].onclick = function(){
                    alert(JSON.stringify(document.getElementById("prova")));
                    //document.getElementById('prova').dispatchEvent(new Event('blur'));
                }
                
            }*/
	},
    insertFields: function(component,event,helper){
        
        /*console.log("sono nella insertContact");
        var objectDataMap = component.get("v.objectDataMap");
        var list = component.get("v.billingProfileList");
        console.log("objectDataMap: "+ JSON.stringify(objectDataMap));
        
        list.push(JSON.stringify(objectDataMap.BillingProfile1));
        list.push(JSON.stringify(objectDataMap.BillingProfile2));
        component.set("v.billingProfileList", list);
        
        var action = component.get("c.insertFieldsMethod");
        action.setParams({ contacts : component.get("v.billingProfileList")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("RESPONSE insertContact SUCCESS" + JSON.stringify(response.getReturnValue()));
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
    },*/
    
}
    })