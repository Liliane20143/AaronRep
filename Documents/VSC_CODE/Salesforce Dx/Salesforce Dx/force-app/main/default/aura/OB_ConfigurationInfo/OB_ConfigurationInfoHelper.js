({
	//		START 	micol.ferrari 21/01/2019 - FEEDBACK_BSN_PRICING
	toggleHelper : function(component,event) 
	{
    	var toggleText = component.find("tooltipConcordata");
    	$A.util.toggleClass(toggleText, "toggle");
   	},
   	//		END 	micol.ferrari 21/01/2019 - FEEDBACK_BSN_PRICING
   	
   	
   	updateAgreedChanges: function(component, event, checked) {

		console.log("conf: " + JSON.stringify(component.get("v.configuration")));
        console.log("confId: " +  component.get("v.configuration").id);
      	var action = component.get("c.updateAgreedChangesServer");
        action.setParams({ 
            "confId" : component.get("v.configuration").Id, 
            "orderHeader": component.get("v.configuration").NE__Order_Header__c,
            "checked" : checked             
        });
        	action.setCallback(this, function(response) {
            var state = response.getState();
          //  console.log('AgreedChanges value: ' + component.get('v.contextOutput.configuration.OB_AgreedChanges__c'));
            console.log('AgreedChanges value: ' + component.get('v.configuration.OB_AgreedChanges__c'));
            if (state === "SUCCESS") {
                console.log("success");
                component.set("v.configuration",  response.getReturnValue());
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
    
    validityMessageHelper : function(component,event){
		console.log("@@@variation is: " + component.get("v.variation"));
        var messageToShow = '';
        //LUBRANO 2019-02-21 -- SE CONCORDATA NON MOSTARE MESSAGGIO PEGGIORATIVA
        var checkCmp = component.find("agreedInputCheck");
        var checked =  checkCmp.get("v.value");
            if(checked){
                messageToShow = $A.get("$Label.c.OB_PositiveValidityDateMessage");
            }else if(component.get("v.variation") == 'PEGGIORATIVA'){
                messageToShow = $A.get("$Label.c.OB_NegativeValidityDateMessage");
            }else if(component.get("v.variation") == 'MIGLIORATIVA' || component.get("v.isEditCommissionModel")){
                messageToShow = $A.get("$Label.c.OB_PositiveValidityDateMessage");
            }
         if(component.get("v.hideValidityMessage")){
            messageToShow = '';
         }
		component.set("v.validityInfoMessage", messageToShow);

    }
   	
})