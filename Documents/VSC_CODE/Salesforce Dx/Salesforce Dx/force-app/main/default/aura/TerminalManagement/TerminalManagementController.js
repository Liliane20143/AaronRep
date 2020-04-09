({
	doInit : function(component, event, helper) {
        var appEvent = $A.get("e.c:OB_EventNextButton");
        var stepName = component.find("stepId").get("v.value");
        appEvent.setParams({"idStep" : stepName });
        appEvent.fire();
        
        //previous button
       /* var neutralButtons = document.getElementsByClassName('slds-button slds-button--neutral');
        
        for(var j = 0; j < neutralButtons.length; j++){
            if(neutralButtons[j].textContent == "< Previous"){ 
            	 neutralButtons[j].setAttribute('style','visibility:visible;position:absolute;left:0px;');
                }
            }
        }*/
		
    }
})