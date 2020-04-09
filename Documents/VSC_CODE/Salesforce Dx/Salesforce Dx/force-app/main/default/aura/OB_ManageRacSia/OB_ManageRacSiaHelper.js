({
    /*------------------------------------------------------------
    Author:         Andrea Saracini
    Company:        Accenture Tecnology
    Description:    Check RAC SIA code is a correct format
    Inputs:         component, event
    History:
    <Date>          <Authors Name>      <Brief Description of Change>
    2019-03-13      Andrea Saracini     Creator
    ------------------------------------------------------------*/
	onChangeAttributeValueTerminalHelper:function(component, event) {
		var attributeIndex = event.getSource().getLocalId();																
		var getInputTag = component.find(attributeIndex);
																   
		var attrName = event.getSource().get("v.name");
		var errMsg = component.find(attributeIndex+"_TerminalError");
		component.set("v.siaNotValid",false);
						   
 
																  
 
		var inputNumNameMap = {};
		inputNumNameMap['Codice SIA'] = 7;
		inputNumNameMap['Codice Stabilimento SIA'] = 5;
		inputNumNameMap['Progressivo SIA'] = 3;
		inputNumNameMap['RAC SIA'] = 15;
 
		if(!$A.util.isEmpty(attrName)){
			var inputValue = component.find(attributeIndex).get("v.value");
			if(!isNaN(inputValue)){ 
				if(inputValue.length == inputNumNameMap[attrName]){                                                                  
					$A.util.removeClass(component.find(attributeIndex) , 'borderError'); 
					component.set("v.errMsg","");                                        
																		
					if('Codice SIA' === attrName)
					component.set("v.siaCode", inputValue);
					else if('Codice Stabilimento SIA' === attrName)
					component.set("v.establCode", inputValue);
					else if('Progressivo SIA' === attrName)
					component.set("v.progSia", inputValue);
		
					var siaCode = component.get("v.siaCode");
					var establCode = component.get("v.establCode");
					var progSia = component.get("v.progSia");
					var tot = siaCode.length + establCode.length + progSia.length;
					if(tot === inputNumNameMap['RAC SIA'])
					component.set("v.disableApply", false);

				}
				else{
					component.set("v.errMsg",attributeIndex);
					$A.util.addClass(component.find(attributeIndex), 'borderError'); 
					component.set("v.disableApply", true);
				}
			}else{
				component.find(attributeIndex).set("v.value", "");
			}
		
 
																																											  
																	 
										  
 
	
		}
		else{
	
			component.set("v.errMsg",attributeIndex);
			component.find(attributeIndex).set("v.value", "");
			$A.util.addClass(component.find(attributeIndex) , 'borderError'); 
			component.set("v.disableApply", true);
	
		}
		
	},
    /*------------------------------------------------------------
    Author:         Andrea Saracini
    Company:        Accenture Tecnology
    Description:    Save the RAC SIA code in order item attribute
    Inputs:         component, event, helper
    History:
    <Date>          <Authors Name>      <Brief Description of Change>
    2019-03-13      Andrea Saracini     Creator
    ------------------------------------------------------------*/
	applyRacSiaHelper: function(component, event){
		//objectDataMap	
		var objectDataString = component.get("v.objectDataMap");
		//START francesca.ribezzi 26/07/19 
		if(!objectDataString.isIbanValid && $A.util.isEmpty(objectDataString.BillingProfilePOS.OB_IBAN__c)){
			var type = 'warning';
			var infoMessage = 'é necessario inserire un iban';
			this.showInfoToast(component, event, infoMessage, type);
			return;
		}
		component.set("v.Spinner", true);
		//END francesca.ribezzi 26/07/19 
		//AttrValue
		var siaCode = component.get("v.siaCode");
		var establCode = component.get("v.establCode");
		var progSia = component.get("v.progSia");
		var sia = siaCode+establCode+progSia;
							   
		//Get Context and PosList

		var listOfItems = component.get("v.posList");
										  
		var itemsToUpdate = {};
		listOfItems.forEach(function(element) {
			if(element.fields.action === 'Add'){
				itemsToUpdate[element.fields.id] = element.fields.id;
			}
		});

		var inputSiaValuesMap = {};
        inputSiaValuesMap['Codice SIA'] = siaCode;
        inputSiaValuesMap['Codice Stabilimento SIA'] = establCode;
		inputSiaValuesMap['Progressivo SIA'] = progSia;
		//isReset
		var isReset = component.get("v.isReset"); 
   
													  
		
		//D.F. 18-03-2019 check if sia is in use by other merchant - START

		var act = component.get("c.checkSiaInUseOtherMerchant");
		act.setParams({ 
			objectDataString: JSON.stringify(objectDataString),
			sia: siaCode,
		});
		act.setCallback(this, function(response){
			var state = response.getState();		 
									
			if (state === "SUCCESS"){				
				var res = response.getReturnValue();
				component.set("v.errMsg","");
				if(!res){					
					var action = component.get("c.setAttributeRacSiaOnTerminal");
					action.setParams({ 
						objectDataString: JSON.stringify(objectDataString),
						sia: sia,
						inputSiaValuesMap: JSON.stringify(inputSiaValuesMap),
						itemsToUpdate: JSON.stringify(itemsToUpdate),
						isReset: isReset
					});
					action.setCallback(this, function(response){
						var state = response.getState();
									   
						if (state === "SUCCESS"){				
							var resp = response.getReturnValue();
							component.set("v.errMsg","");
							if(resp){
								var posNone = false;			
								var posAdd = false;		
								//START francesca.ribezzi 17/10/19 - WN-609 - checking if its terminali, ecommerce or moto:
								var terminaliRecordType = "Terminali";
								var terminaliRecordTypeEcommerce = "eCommerce";
								var terminaliRecordTypeMoto = "Moto";
								terminaliRecordType = terminaliRecordType.toLowerCase();
								terminaliRecordTypeEcommerce = terminaliRecordTypeEcommerce.toLowerCase();
								terminaliRecordTypeMoto = terminaliRecordTypeMoto.toLowerCase();
								//11/07/19 francesca.ribezzi using posList instead of contextOutput
								for(var i = 0; i < listOfItems.length; i++){
									var listOfAttr = listOfItems[i].listOfAttributes;
									//francesca.ribezzi 17/10/19 - WN-609 - checking if its terminali, ecommerce or moto:
									var currentItemRecordType = listOfItems[i].fields.RecordTypeName.toLowerCase();
									var isTerminal = (currentItemRecordType == terminaliRecordType ||currentItemRecordType == terminaliRecordTypeEcommerce || currentItemRecordType == terminaliRecordTypeMoto);
									if(listOfItems[i].fields.action === 'Add' && isTerminal){
										posAdd = true;
										for(var j = 0; j < listOfAttr.length; j++){
											if(!$A.util.isEmpty(inputSiaValuesMap[listOfAttr[j].fields.name])){
												listOfItems[i].listOfAttributes[j].fields.value = inputSiaValuesMap[listOfAttr[j].fields.name];
											}
										}
										//11/07/19 francesca.ribezzi removing changeAttributeEvent - NO ENGINE
									}
								//START francesca.ribezzi 30/09/19 - WN-528 - checking if it's the first pos 
									if(listOfItems[i].fields.action == 'None' && isTerminal){ //francesca.ribezzi 17/10/19 - WN-609 - checking if its terminali, ecommerce or moto: 
										posNone = true;
									}	

								}
								var isFirstPos 	= (posAdd && !posNone);
								component.set("v.isReset", isFirstPos); //only if it's the first pos, the user can reset the sia code.
								//END francesca.ribezzi 30/09/19 - WN-528
								component.set("v.listOfItems", listOfItems);//francesca.ribezzi 17/10/19 - WN-609 - adding set
								component.set("v.siaIsValid", true);
								component.set("v.siaNotValid",false);
								//30/09/19 francesca.ribezzi - WN-528 - not checking for errors here //this.handleRedBorderErrors
								component.set("v.Spinner", false);
								component.set("v.siaSetted", true);
							}
							else{
								component.set("v.siaNotValid",true);
								component.set("v.errMsg",$A.get("$Label.c.OB_SiaNotValid"));
								component.set("v.Spinner", false);
							} 		
						}
						else if (state === "ERROR") 
						{
							component.set("v.Spinner", false);
						}

					});
					$A.enqueueAction(action);
				}
				else{
					component.set("v.siaNotValid",true);
					component.set("v.errMsg",$A.get("$Label.c.OB_SiaAlreadyInUse"));
					component.set("v.Spinner", false);
				}		
			}
			else if (state === "ERROR") 
			{
				component.set("v.Spinner", false);
				var errors = response.getError();
				console.log("errors: "+errors);
			}
			
		});
		$A.enqueueAction(act);	 
	},
	//D.F. END

    /*------------------------------------------------------------
    Author:         Andrea Saracini
    Company:        Accenture Tecnology
    Description:    Save (blank) the RAC SIA code in order item attribute
    Inputs:         component, event, helper
    History:
    <Date>          <Authors Name>      <Brief Description of Change>
    2019-03-13      Andrea Saracini     Creator
    ------------------------------------------------------------*/
	resetRacSiaHelper: function(component, event){	
		//objectDataMap	
		var objectDataString = component.get("v.objectDataMap");
		//AttrValue
		component.set("v.siaCode", "");
		component.set("v.establCode", "");
		component.set("v.progSia", "");
		var sia = '';
							   

		var inputSiaValuesMap = {};
        inputSiaValuesMap['Codice SIA'] = '';
        inputSiaValuesMap['Codice Stabilimento SIA'] = '';
		inputSiaValuesMap['Progressivo SIA'] = '';

												  
		var listOfItems = component.get("v.posList");
										  
		var itemsToUpdate = {};
		listOfItems.forEach(function(element) {
			if(element.fields.action === 'Add'){
				itemsToUpdate[element.fields.id] = element.fields.id;
			}
		});
		//isReset
		var isReset = component.get("v.isReset"); 

		var action = component.get("c.setAttributeRacSiaOnTerminal");
		action.setParams({ 
			objectDataString: JSON.stringify(objectDataString),
			sia: sia,
			inputSiaValuesMap: JSON.stringify(inputSiaValuesMap),
			itemsToUpdate: JSON.stringify(itemsToUpdate),
			isReset: isReset
		});
		action.setCallback(this, function(response){
			var state = response.getState();	 
									
			if (state === "SUCCESS"){				
				var resp = response.getReturnValue();
				if(resp){			
					//START francesca.ribezzi  17/07/19  using posList instead of contextOutput	- performance
					var posList = component.get("v.posList");					
					for(var i=0; i<posList.length; i++){
						var listOfAttr = posList[i].listOfAttributes;
						if(posList[i].fields.action === 'Add' && posList[i].fields.RecordTypeName === 'Terminali'){
							for(var j=0; j<listOfAttr.length; j++){
								if(!$A.util.isEmpty(inputSiaValuesMap[listOfAttr[j].fields.name])){
									posList[i].listOfAttributes[j].fields.value = inputSiaValuesMap[listOfAttr[j].fields.name];
								}
							}
						}
					}												 
					component.set("v.posList", posList);
					//END francesca.ribezzi  17/07/19 
				}
				else{
					component.set("v.Spinner", false);
				} 		
			}
			else if (state === "ERROR") 
			{
				//ERROR
				component.set("v.Spinner", false);
				var errors = response.getError();
				console.log("errors: "+errors);
			}
			
		});
		$A.enqueueAction(action);
		component.set("v.siaIsValid", false);
		component.set("v.isReset", false);
		component.set("v.disableApply", true);
		component.set("v.Spinner", false);
		component.set("v.siaSetted", false);
	},

	//D.F. 18-03-2019 check if sia is in use by other merchant - START  
	checkSiaInUseHelper: function(component, event, helper){
		var objectDataString = component.get("v.objectDataMap");	
		var siaCode = component.get("v.siaCode");
													  
		
		var act = component.get("c.checkSiaInUseOtherMerchant");
		act.setParams({ 
			objectDataString: JSON.stringify(objectDataString),
			sia: siaCode,
		});
		act.setCallback(this, function(response){
			var state = response.getState();		 
									
			if (state === "SUCCESS"){				
				var resp = response.getReturnValue();
				component.set("v.errMsg","");
				if(!resp){
					return true;
				}
				else{
					return false;
				} 		
			}
			else if (state === "ERROR") 
			{
				component.set("v.Spinner", false);
				var errors = response.getError();
				console.log("errors: "+errors);
			}
			
		});
		$A.enqueueAction(act);
	},

	checkSiaCodeByIban: function(component, event){
		var objectDataString = component.get("v.objectDataMap");	
				
		var act = component.get("c.checkSiaCodeOnIbanInsert");
		act.setParams({ 
			objectDataString: JSON.stringify(objectDataString),
		});
		act.setCallback(this, function(response){
			var state = response.getState();		 
									
			if (state === "SUCCESS"){
				var resp = response.getReturnValue();
				component.set("v.racSiaList", resp);
				if(typeof resp !== 'undefined' && resp.length > 0){
					if(resp.length > 1){
						var siaList = [];
						for(var i=0; i<resp.length; i++){
							siaList.push({
								"full" : resp[i],
								"siaCode" : resp[i].substring(0, 7),
								"establCode" : resp[i].substring(7, 12),
								"progSia" : resp[i].substring(12, 15)
							});
						}
						component.set("v.racSiaList",siaList);
						component.set("v.showSiaSearch",true);
						component.set("v.siaSetted", true);//andrea.saracini - R1F2-247 - 12/06/2019
					}else{
						//Start antonio.vatrano 11/06/2019 r1f2-247
						component.set("v.multipleRacSia",false);
						//End antonio.vatrano 11/06/2019 r1f2-247
						var siaCode = resp[0].substring(0, 7);
						var establCode = resp[0].substring(7, 12);
						var progSia = resp[0].substring(12, 15);
						component.set("v.siaCode",siaCode);
						component.set("v.establCode",establCode);
						component.set("v.progSia",progSia);
						this.applyRacSiaHelper(component, event);//davide.franzini - R1F2-45 - 19/04/2019
						component.set("v.siaSetted", true);
						component.set("v.siaIsValid", true);//davide.franzini - R1F2-33 - 17/04/2019
					}
				}else{
					console.log('### No Rac Sia for IBAN');
					//Start andrea.saracini 12/06/2019 r1f2-247v2
					component.set("v.multipleRacSia",false);
					component.set("v.siaIsValid", true);
					//End andrea.saracini 12/06/2019 r1f2-247v2
				}
			}
			else if (state === "ERROR") 
			{
				component.set("v.Spinner", false);
				var errors = response.getError();
				console.log("errors: "+errors);
			}
		});
		$A.enqueueAction(act);
	},

	getSelectedOption: function(component, event){
																 
		var selectedSia = event.target.value;
		if(typeof selectedSia !== 'undefined' && selectedSia!= null && selectedSia!= ''){
			var siaCode = selectedSia.substring(0, 7);
			var establCode = selectedSia.substring(7, 12);
			var progSia = selectedSia.substring(12, 15);
			component.set("v.siaCode",siaCode);
			component.set("v.establCode",establCode);
			component.set("v.progSia",progSia);
			this.applyRacSiaHelper(component, event);
			component.set("v.showModal", false);
		}else{
			console.log("### no Rac Sia Selected or Undefined");
			component.set("v.showModal", false);
			component.set("v.Spinner", false);
		}
	},
	// D.F. END
	//26/07/19 francesca.ribezzi adding showInfoToast
	showInfoToast: function(component, event, infoMessage, type)
	{
	    _utils.debug("into showInfoToast");
    	var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: '',
            message: infoMessage,
            duration: '5000',
            key: 'info_alt',
            type: type,
            mode: 'pester'
        });
        toastEvent.fire();
    },
    /*
    *@author francesca.ribezzi
    *@date 31/07/2019
    *@task  setting red border to empty required fields - WN-211
	*@history 31/07/2019 Method created
	*		  01/10/2019 francesca.ribezzi - WN-547 - Method edited to handle mig sia codes with empty proSia values 
    */
   handleRedBorderErrors: function(component, event){
		var siaCode = component.find('siaCode');
		var estbCode = component.find('estbCode');
		var progSia = component.find('progSia');	
		var siaValue = component.find('siaCode').get("v.value");
		var estbValue = component.find('estbCode').get("v.value");
		var progValue = component.find('progSia').get("v.value");
		//if at least one value is not empty and the inputs are disabled --> remove errors!
		var isNotEmpty = (!$A.util.isEmpty(siaValue) || !$A.util.isEmpty(estbValue) || !$A.util.isEmpty(progValue));
		var requiredInputs = [siaCode,estbCode,progSia];
		var disabled = component.get("v.siaSetted");
		for(var i = 0; i <requiredInputs.length; i++){				
			if(isNotEmpty && disabled){	
				$A.util.removeClass(requiredInputs[i], "slds-has-error");
			}else{
				$A.util.addClass(requiredInputs[i], "slds-has-error");
			}
		}
	},
	
})