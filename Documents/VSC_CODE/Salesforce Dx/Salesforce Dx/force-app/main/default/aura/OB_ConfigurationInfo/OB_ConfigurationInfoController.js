({
	doInit: function(component, event, helper) {
		console.log("into doInit COnfigurationInfo");
		var hideValidityMessage = component.get("v.hideValidityMessage");
		var isEditCommissionModel = component.get("v.isEditCommissionModel"); 
		if(!hideValidityMessage && isEditCommissionModel){
			var   messageToShow = $A.get("$Label.c.OB_PositiveValidityDateMessage");
			component.set("v.validityInfoMessage", messageToShow);
		}
	},


	handleValidityMessage: function(component, event, helper) {
	//	var configuration = component.get("v.configuration");
		helper.validityMessageHelper(component, event);

	},
	
	// chiamare l'evento cart event del carrello per settare i valori finali del conf
	handleAgreedChanges: function(component, event, helper) {
		console.log("into handleAgreedChanges");
		 var checkCmp = component.find("agreedInputCheck");
		 console.log('agreedInputCheck: ' + checkCmp);
		 var configuration = component.get('v.configuration');
		// checkCmp.set("v.value", checkCmp.get("v.value"));
		// configuration.OB_AgreedChanges__c = checkCmp.get("v.value");
       //  component.set("v.configuration.OB_AgreedChanges__c", checkCmp.get("v.checked"));
		var checked =  checkCmp.get("v.value");
		console.log("checked: " + checkCmp.get("v.checked"));
		console.log("checked value: " + checkCmp.get("v.value"));
		 component.set("v.configuration.OB_AgreedChanges__c", checkCmp.get("v.checked"));
		var checked =  checkCmp.get("v.checked");
		component.set("v.checkAgreedChanges", checkCmp.get("v.checked"));
		var messageToShow;
		if(checked){
			//if concordata, setting positive validity date message
			messageToShow = $A.get("$Label.c.OB_PositiveValidityDateMessage");
			component.set("v.validityInfoMessage", messageToShow);
		}else{
			helper.validityMessageHelper(component, event);

		}
		console.log("calling updateAgreedChanges");
		//helper.updateAgreedChanges(component, event, checked);
		var configuration = component.get("v.configuration");
		configuration.OB_AgreedChanges__c = checked;
		console.log("agreedInput " + checked);
		var factsJSON = {"executeRules":true,
		   			"objectList": [{
		   				"action": "modify",
		   				"type": "configuration",
		   				"uniqueid": "id",
		   				"value": configuration.id, 
		   				"instance": configuration
		   				} 
		   			]
		   		};	
		//calling cart event to set configuration values:
          var cartEventCheckout =  $A.get("e.NE:Bit2win_Event_CartEvent");
          var checkOutMap  =  {};
          cartEventCheckout.setParams({
        	  'updateB2WGinEngine':   factsJSON
          });
          
          cartEventCheckout.fire();

	},

	//		START 	micol.ferrari 21/01/2019 - FEEDBACK_BSN_PRICING
	displayTooltipConcordata : function(component, event, helper) 
	{
    	component.set("v.showTooltipConcordata",true);
  	},

  	displayOutTooltipConcordata : function(component, event, helper) 
  	{
   		component.set("v.showTooltipConcordata",false);
  	}
  	//		END 	micol.ferrari 21/01/2019 - FEEDBACK_BSN_PRICING
})