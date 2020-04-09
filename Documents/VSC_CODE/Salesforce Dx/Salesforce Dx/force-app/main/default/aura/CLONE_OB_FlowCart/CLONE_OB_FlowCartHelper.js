({
	objectIsEmpty: function(obj) {
        return Object.keys(obj).length === 0;
    },
    
    showBit2flowNext: function(component, event) 
	{
                  
    	//hiding custom next button, showing bit2flow next. 
		/*
		var btns= document.getElementsByClassName("slds-button slds-button_neutral slds-hide slds-button--brand");
		console.log("btns length: " + btns.length);
		for(var i = 0; i< btns.length; i++){
			btns[i].style.display === "block";
			btns[i].classList.remove("slds-hide");
		}
		
		var buttonNextCustom = component.find('navigateStepBundle');
		$A.util.addClass(buttonNextCustom, 'hidden');
		 */
		var objectDataMap = component.get("v.objectDataMap");
		objectDataMap.unbind.goToNextStepCatalog  = "goToNextStepCatalog";
		component.set("v.objectDataMap", objectDataMap); 
		//dispatchEvent to fire bit2flow rule that automatically goes to next step.
		//document.getElementById('input:unbind:goToNextStepCatalog').dispatchEvent(new Event('blur'));   

		component.set("v.spinner",false); 
    },
    
    showBit2flowSaveAndExit: function(component, event) {
    	console.log("__into showBit2flowSaveAndExit");
    	
    	//param
    	var objectDataMap = component.get("v.objectDataMap");
    	
    	//TEMP
    	objectDataMap.JumpToStep = 4;
    	//TEMP
    	
    	var wizardWrapperVar = component.get("v.wizardWrapper");
    	var isCommunity = objectDataMap.isCommunityUser;
	    
	    if($A.util.isEmpty(isCommunity)){
	    	isCommunity = false;
	    }
    	
    	//remove the size key from object
    	delete wizardWrapperVar.mapFields["size"];
    	
    	//console.log("WW " + JSON.stringify(wizardWrapperVar) );
    	var strWizardWrapperVar = JSON.stringify(wizardWrapperVar);
    	
    	var action = component.get("c.saveAndExitBit2FlowCaller");
	        
	        action.setParams({ 
	        	data: objectDataMap,
	        	wizardWrapperString: strWizardWrapperVar,
	        	isCommunity: isCommunity
	        });
			
	        action.setCallback(this, function(response) {
	            var state = response.getState();
	            if (state === "SUCCESS") {
	                
	                console.log("response: ", response.getReturnValue());
	                var res = response.getReturnValue();
        	    	if( !($A.util.isEmpty(res)) ){

				    	//timeout
			    		window.setTimeout(
					    $A.getCallback(function() {
					       window.location.replace(res);
					    }), 2500
					    )
				    	
			    	}
			    	else{
			    		//error message
			    		//toast message error TODO	
			    	}
				}
	            else if (state === "INCOMPLETE") {
	            	component.set("v.spinner",false);
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
	                    component.set("v.spinner",false);
	            }
	        });
	        $A.enqueueAction(action);
	        component.set("v.spinner", true);
    },
    
    isUnusualStep: function(component, event,direction){
    	
    	console.log("__inside isUnusalStep");
    	
    	var bundleElementName = component.get("v.bundleElementName");
    	var bundleStep = component.get("v.bundleStep");
    	var isFirstStep = false;
    	console.log("bundleStep "+ bundleStep);
    	if(bundleStep == 0){
    		var isFirstStep = true; 
    	}
    	
    	if(direction == 'previous'){
    		bundleStep = parseInt(bundleStep)-1;
    	}
    	else if(direction == 'nextJump'){
    		bundleStep = parseInt(bundleStep)+2;
    	}
    	else{
    		bundleStep = parseInt(bundleStep)+1;
    	}
    	
    	//console.log("bundleElementName "+ bundleElementName);
    	
    	
    	if( bundleElementName != 'Gestione Pagobancomat' && bundleElementName != 'Gestione Terminali' && bundleElementName != 'Selezione Acquiring' && bundleElementName != 'Selezione VAS' && isFirstStep == false)
    	{
    		component.set("v.isUnusualStep",true);
    	}
    	else{
    		component.set("v.isUnusualStep",false);
    	}
    },
 
	
	setConfigurationToApprove: function(component,event,bitwinMap) {
	
		console.log("__into setConfigurationToApprove");
    	var ordId = component.get("v.orderId");
    	//DEBUG FOR CLONE
    	ordId = 'a0y9E000004OaFoQAK';
    	//DEBUG FOR CLONE
    	
    	var action = component.get("c.setConfigurationToApprove");
	        action.setParams({ 
	        	idOrder: ordId
	        });
	        action.setCallback(this, function(response) {
	            var state = response.getState();
	            if (state === "SUCCESS") {
	                
	                console.log("response: ", response.getReturnValue());
	                var res = response.getReturnValue();
	                
	                if(res){
	                	//NEED 
				    	this.showBit2flowSaveAndExit(component, event);
			    	}
			    	else{
			    		//error message
			    		//toast message error TODO	
			    	}
				}
	            else if (state === "INCOMPLETE") {
	            	component.set("v.spinner",false);
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
	                    component.set("v.spinner",false);
	            }
	        });
	        $A.enqueueAction(action);
	        component.set("v.spinner", true);
	},
})