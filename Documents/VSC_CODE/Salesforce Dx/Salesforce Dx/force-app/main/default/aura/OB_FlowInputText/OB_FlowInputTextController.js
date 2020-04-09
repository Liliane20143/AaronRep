({
	doInit : function(component, event, helper)
	{
		var addressMapping 	= component.get("v.addressMapping");
		var objectDataMap  	= component.get("v.objectDataMap");
		//var inputvalue 		= objectDataMap[addressMapping.objectDataNode][objectDataField];
		var auraId			= addressMapping.auraId;
		var objectDataNode  = addressMapping.objectDataNode;
		var objectDataField = addressMapping.objectDataField;
		console.log('addressMapping: ' + JSON.stringify(addressMapping));
		console.log('objectDataMap: ' + JSON.stringify(objectDataMap));
		var label = $A.getReference("$Label.c." + addressMapping.label);
		console.log('label:: '+label);
		component.set("v.customLabelFlow", label);
		//NEXI-229 Grzegorz Banach <grzegorz.banach@accenture.com> 23.07.2019 START
		let disabledFields = component.get( "v.disabledFields" );
		let isFieldDisabled = false;
		if ( !( $A.util.isEmpty( addressMapping.objectDataField ) || $A.util.isEmpty( disabledFields ) || $A.util.isEmpty( disabledFields[ addressMapping.objectDataField ] ) ) )
		{
		    isFieldDisabled = disabledFields[ addressMapping.objectDataField ];
		}
        //NEXI-229 Grzegorz Banach <grzegorz.banach@accenture.com> 23.07.2019 STOP
		$A.createComponent(
			"lightning:input",
			{
				"aura:id": auraId,
				"label": "",
				"variant":"label-hidden",
				"name": auraId,
				"id": auraId,
				"type": "text",
				"value": component.getReference("v.objectDataMap." +objectDataNode +"." + objectDataField),
				"onblur": component.getReference("c.handleBlur"),
				"onchange": component.getReference("c.handleOnChange"),
				"disabled": isFieldDisabled //NEXI-229 Grzegorz Banach <grzegorz.banach@accenture.com> 23.07.2019
			},
			function(newInput, status, errorMessage,auraId)
			{
				//Add the new button to the body array
				if (status === "SUCCESS") 
				{
					
					if (typeof _wizardController != "undefined")
					{
						console.log('notifyInit');
						_wizardController.notifyInit(newInput,newInput.getLocalId());	
					}
					var body = component.get("v.body");
					body.push(newInput);
					component.set("v.body", body);
				}
				else if (status === "INCOMPLETE") 
				{
					console.log("No response from server or client is offline.")
					// Show offline error
				}
				else if (status === "ERROR") 
				{
					console.log("Error: " + errorMessage);
					// Show error message
				}
			}
		);
		console.log('OB FLOWINPUTTEXT DOINIT');
	},

	handlePress : function(component, event, helper) 
	{
		if (typeof _wizardController != "undefined")
		{
			_wizardController.notifyClick(component, event, helper);	
		}
	},
	handleOnChange : function(component, event, helper) 
	{
		if (typeof _wizardController != "undefined")
		{
			//GIOVANNI SPINELLI - 14/12/2018 - SET UPPERCASE FISCAL CODE IN NEW EXECUTOR
			var addressMapping 	= component.get("v.addressMapping");
			var auraId			= addressMapping.auraId;
			var objectDataNode  = addressMapping.objectDataNode;
			var objectDataField = addressMapping.objectDataField;
			component.set(  "v.objectDataMap." +objectDataNode +"." + objectDataField , (component.find(auraId).get('v.value')).toUpperCase());
			console.log('objectDataMap on change  ' + JSON.stringify(component.get('v.objectDataMap.executor')));
			console.log('INSIDE ON BLUR handleOnInput');
			_wizardController.notifyOnChange(component, event, helper);	
		}
	},
	handleBlur : function(component, event, helper) 
	{
		console.log('INSIDE ON BLUR');
		if (typeof _wizardController != "undefined")
		{
			console.log('INSIDE ON BLUR notifyBlur');
			_wizardController.notifyBlur(component, event, helper);	
		}
		var objectDataMap  	= component.get("v.objectDataMap");
		console.log('objectDataMap2: ' + JSON.stringify(objectDataMap));
	},

	validate: function(component, event, helper) {
		var addressMapping 	= component.get("v.addressMapping");
		var auraId			= addressMapping.auraId;

		if (typeof _wizardController != "undefined")
		{
			console.log('INSIDE ON BLUR notifyBlur');
			_wizardController.notifyValidate(component,auraId, helper);	
		}
        
        //component.set("v.errMsg", 'the error message');
       
 	},
 	
 	removeRedBorderIfOK : function(component, event, helper) {
 		var addressMapping 	= component.get("v.addressMapping");
 		var indexContact =component.get("v.objectDataMap.lastContact");
 		var currentId = null;
 		if(indexContact){
 			currentId	= 'fiscalCodeContact'+indexContact;
		} else {
			currentId	= addressMapping.auraId;
		}
        var objectDataMap = component.get("v.objectDataMap");
        console.log('setredbord'+objectDataMap.setRedBordercompanyDataValidation+ '    '+objectDataMap.setRedBordercompanyDataValidation);
        if(objectDataMap.setRedBordercompanyDataValidation == true){
	 		var mapFromNextValidation = component.get("v.objectDataMap.validationCheckMap");
	 		console.log('mapFromNextValidation: '+JSON.stringify(mapFromNextValidation));
			console.log('mapFromNextValidation[currentId]'+mapFromNextValidation[currentId]);
			if(!mapFromNextValidation[currentId]){
				console.log("current id is: " + currentId);
		        $A.util.removeClass(document.getElementById(currentId) , 'slds-has-error');
		        //RECREATE THE SAME ID OF ERROR MESSAGE
		        var errorId = 'errorId'+ currentId;
		        if(document.getElementById(errorId)!=null){
		            console.log("errorID . " + errorId);
		            document.getElementById(errorId).remove();
		        }
		    } else {
		    	console.log('errorCF'+objectDataMap.isErrorCF);
		    	var errorId = 'errorId' +currentId;
                console.log("key  = " + currentId);
                
                
		    	if(objectDataMap.isErrorCF==true){
		    		if(document.getElementById(errorId)!=null){
			            console.log("errorID . " + errorId);
			            document.getElementById(errorId).remove();
		    		}
		    	}
                var myDiv;
                
                myDiv = document.createElement('div');
                myDiv.setAttribute('id',errorId);//SET AN ID TO EVERY MESSAGE
                myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
                myDiv.setAttribute('class' , 'messageError'+currentId);
                //SET THE MESSAGE
                var errorMessage = document.createTextNode(mapFromNextValidation[currentId]);
                console.log('errorMessage:: '+JSON.stringify(errorMessage));
                myDiv.appendChild(errorMessage);
                
               var idSet = document.getElementById(currentId);
               if($A.util.isUndefinedOrNull(idSet) && !$A.util.isUndefinedOrNull(component.find(keys))){
					idSet =  component.find(currentId).getElement();
				}
				if(idSet!=null && idSet!= undefined)
				{ 
					console.log('errorId doc'+(document.getElementById(errorId)));
					if(!(document.getElementById(errorId)))
					{
						console.log("METHOD TO SHOW ONLY A MESSAGE");
						idSet.after(myDiv);
						$A.util.addClass(idSet, 'slds-has-error flow_required');
						//idSet.className="slds-has-error flow_required";
					}
				}//END FOR
		    }
	    }
	    //REMOVE RED BORDER FROM FISCAL CODE
	    else if(objectDataMap.setRedBorderMaintenance == true)
	    {
	    	console.log('ELSE REMOVE BORDER FROM FISCAL CODE');
	    	$A.util.removeClass(document.getElementById(currentId) , 'slds-has-error');
	    	var errorId = 'errorId'+ currentId;
	    	if(document.getElementById(errorId)!=null){
				document.getElementById(errorId).remove();
	    	}
	    }
	 },
	 
	 //START gianluigi.virga 04/07/2019 - PRODOB-284 - Show error message when user try to submit duplicate fiscal code
	 showErrorMessage : function(component, event, helper) {
		var isDuplicate = component.get("v.objectDataMap.fiscalCodeisDuplicate");
		var duplicateFiscalCode = component.get("v.objectDataMap.duplicateFiscalCode");
		if(isDuplicate){
			var title = $A.getReference("$Label.c.OB_DuplicateFiscalCode");
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				"type": "info",
				"mode": 'dismissible',
				"title": title,
				"message": duplicateFiscalCode
			});
			toastEvent.fire();
			component.set("v.objectDataMap.fiscalCodeisDuplicate", false);
		}
	 }
	 //END gianluigi.virga 04/07/2019
})