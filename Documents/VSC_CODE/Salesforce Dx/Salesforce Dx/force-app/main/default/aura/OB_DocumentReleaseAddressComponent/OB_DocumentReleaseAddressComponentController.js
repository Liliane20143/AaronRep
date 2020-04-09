({
	doInit : function(component, event, helper) {
		var objectDataMap = component.get("v.objectDataMap");
		var addressMapping = component.get("v.addressMapping");
		var inputobject = component.get("v.addressMapping.provinceinputobject");
		var sectionName = component.get("v.addressMapping.sectionName");
        if(sectionName == undefined || sectionName == null)
        	sectionName='';
	    var contactBank = objectDataMap[inputobject];
	    console.log('contactBank'+JSON.stringify(contactBank));
	    
	    component.set('v.birthDate', contactBank.OB_Birth_Date__c);
	    component.set('v.docNumber', contactBank.OB_Document_Number__c);
	    component.set('v.docType', contactBank.OB_Document_Type__c);
	    component.set('v.docAuth', contactBank.OB_Document_Release_Authority__c);
	    component.set('v.docRelDate', contactBank.OB_Document_Release_Date__c);
	    component.set('v.docExpDate', contactBank.OB_Document_Expiration_Date__c);
	    
	    if(contactBank.OB_Document_Type__c == 'Passaporto')
			component.set("v.addressMapping.withCountry", 'true');
		else 
			component.set("v.addressMapping.withCountry", 'false');
			
	    helper.getDocTypes(component,helper ,event );
	    if(!contactBank.OB_Document_Type__c){
	    	helper.getDocAuth(component,helper ,event );
	    }else{
																																																  
																																							 
																																														
   
			var docAuthList = [];
			//START gianluigi.virga 05/07/2019 - BACKLOG-50
			if(contactBank.OB_Document_Release_Country_Code__c == 'ITA'){
								   
			//END gianluigi.virga
				if(contactBank.OB_Document_Type__c == $A.get("$Label.c.OB_Passaporto")){
					docAuthList.push({value: $A.get("$Label.c.OB_Questura"), key: $A.get("$Label.c.OB_Questura")});
					component.set("v.docAuth", $A.get("$Label.c.OB_Questura"));
					component.set('v.objectDataMap.'+inputobject+'.OB_Document_Release_Authority__c', $A.get("$Label.c.OB_Questura"));
				} else if(contactBank.OB_Document_Type__c == $A.get("$Label.c.OB_CartaIdentita")){
					docAuthList.push({value: $A.get("$Label.c.OB_Comune"), key: $A.get("$Label.c.OB_Comune")});
					component.set("v.docAuth", $A.get("$Label.c.OB_Comune"));
					component.set('v.objectDataMap.'+inputobject+'.OB_Document_Release_Authority__c', $A.get("$Label.c.OB_Comune"));
				} else if(contactBank.OB_Document_Type__c == $A.get("$Label.c.OB_Patente")){
					docAuthList.push({value: $A.get("$Label.c.OB_Prefettura"), key: $A.get("$Label.c.OB_Prefettura")});
					docAuthList.push({value: $A.get("$Label.c.OB_Motorizzazione"), key: $A.get("$Label.c.OB_Motorizzazione")});
					docAuthList.push({value: $A.get("$Label.c.OB_UCO"), key: $A.get("$Label.c.OB_UCO")});
																								
					if(contactBank.OB_Document_Release_Authority__c == $A.get("$Label.c.OB_Comune") || contactBank.OB_Document_Release_Authority__c == $A.get("$Label.c.OB_Patente"))
						component.set('v.objectDataMap.'+inputobject+'.OB_Document_Release_Authority__c',"");
				}
				component.set("v.docAuthList", docAuthList);
			//START gianluigi.virga 05/07/2019 - BACKLOG-50
			}else{
														  
				docAuthList.push({value: $A.get("$Label.c.OB_Comune"), key: $A.get("$Label.c.OB_Comune")});
				docAuthList.push({value: $A.get("$Label.c.OB_Questura"), key: $A.get("$Label.c.OB_Questura")});																																					 															  
				docAuthList.push({value: $A.get("$Label.c.OB_Prefettura"), key: $A.get("$Label.c.OB_Prefettura")});
				docAuthList.push({value: $A.get("$Label.c.OB_Motorizzazione"), key: $A.get("$Label.c.OB_Motorizzazione")});
				docAuthList.push({value: $A.get("$Label.c.OB_UCO"), key: $A.get("$Label.c.OB_UCO")});
														  
				component.set("v.docAuthList", docAuthList);
																  
			}
			//END gianluigi.virga
		}
	    
	    component.set("v.birthDateId", 'birthDate'+sectionName);
	    component.set("v.docNumberId", 'documentNumber'+sectionName);
	    component.set("v.docRelDateId", 'documentReleaseDate'+sectionName);
	    component.set("v.docExpDateId", 'documentExpirationDate'+sectionName);
		component.set("v.docTypeId", 'documentType'+sectionName);
															   
		component.set("v.docAuthId", 'documentAuth'+sectionName);

		/*
		ANDREA MORITTU START 17-Sept-2019 - EVO_BACKLOG_10
		*/
		helper.checkIfBagopancomatArePresent(component, event, helper)
			.then(function(pagoBancomatArePresent) {
				console.log('pagoBancomatArePresent is : ' + pagoBancomatArePresent);
				if(!$A.util.isUndefined(pagoBancomatArePresent) && !$A.util.isEmpty(pagoBancomatArePresent)) {
					component.set('v.objectDataMap.pagoBancomatArePresent' , pagoBancomatArePresent );
				}
			}).catch(function(error) {
				console.log('AN EXCEPTION HAS OCCURED : ' + error.message);
			});	
			
		/*
		ANDREA MORITTU END 17-Sept-2019 - EVO_BACKLOG_10
		*/
	    
	},
	changeDocAuth : function(component, event, helper){
		var objectDataMap = component.get("v.objectDataMap");
		var inputobject = component.get("v.addressMapping.provinceinputobject");
		console.log('cambiodocauth'+JSON.stringify(objectDataMap[inputobject]));
		component.set('v.objectDataMap.'+inputobject+'.OB_Document_Release_Authority__c', component.get("v.docAuth"));
		console.log('dynamic name:' +event.getSource().get("v.name"));
		//START gianluigi.virga 09/07/2019 - BACKLOG-50
	    var inputobject = component.get("v.addressMapping.provinceinputobject");
		var countryDoc = objectDataMap[inputobject].OB_Document_Release_Country_Code__c;
		if(countryDoc == 'ITA'){
		//END gianluigi.virga
			helper.removeRedBorderDocPick(component, event, helper);
			helper.removeRedBorderDate(component, event, helper);
		
		}
	},
	changeDocTypes : function(component, event, helper) {
		var objectDataMap = component.get("v.objectDataMap");
		var addressMapping = component.get("v.addressMapping");
	    var inputobject = component.get("v.addressMapping.provinceinputobject");
		var docType = component.get('v.docType');
		component.set('v.objectDataMap.'+inputobject+'.OB_Document_Type__c', docType);
	    var contactBank = objectDataMap[inputobject];
		console.log('contactBank'+JSON.stringify(contactBank));
		console.log('contactBank'+contactBank.OB_Document_Type__c);
		if(contactBank.OB_Document_Type__c == 'Passaporto'){
			component.set("v.addressMapping.withCountry", 'true');
			//START gianluigi.virga 12/07/2019 - BACKLOG-50 
			//contactBank.OB_Document_Release_Country__c = 'ITALIA';
			//END gianluigi.virga
			}
		else{
			component.set("v.addressMapping.withCountry", 'false');
			//START gianluigi.virga 12/07/2019 - BACKLOG-50 
			//component.set("v.isEE", 'false');
			//END gianluigi.virga
		}
		
		var docAuthList = [];
		//START gianluigi.virga 05/07/2019 - BACKLOG-50
		if(contactBank.OB_Document_Release_Country_Code__c == 'ITA'){
							  
		//END gianluigi.virga
			if(contactBank.OB_Document_Type__c == $A.get("$Label.c.OB_Passaporto")){
				docAuthList.push({value: $A.get("$Label.c.OB_Questura"), key: $A.get("$Label.c.OB_Questura")});
				component.set("v.docAuth", $A.get("$Label.c.OB_Questura"));
				component.set('v.objectDataMap.'+inputobject+'.OB_Document_Release_Authority__c', $A.get("$Label.c.OB_Questura"));
			} else if(contactBank.OB_Document_Type__c == $A.get("$Label.c.OB_CartaIdentita")){
				docAuthList.push({value: $A.get("$Label.c.OB_Comune"), key: $A.get("$Label.c.OB_Comune")});
				component.set("v.docAuth", $A.get("$Label.c.OB_Comune"));
				component.set('v.objectDataMap.'+inputobject+'.OB_Document_Release_Authority__c', $A.get("$Label.c.OB_Comune"));
			} else if(contactBank.OB_Document_Type__c == $A.get("$Label.c.OB_Patente")){
				docAuthList.push({value: $A.get("$Label.c.OB_Prefettura"), key: $A.get("$Label.c.OB_Prefettura")});
				docAuthList.push({value: $A.get("$Label.c.OB_Motorizzazione"), key: $A.get("$Label.c.OB_Motorizzazione")});
				docAuthList.push({value: $A.get("$Label.c.OB_UCO"), key: $A.get("$Label.c.OB_UCO")});
				console.log('docAuthList'+docAuthList);
				component.set('v.objectDataMap.'+inputobject+'.OB_Document_Release_Authority__c',"");
			}
			component.set("v.docAuthList", docAuthList);
			//SET COUNTRY ITALIA
			helper.removeRedBorderDocPick(component, event, helper);
			helper.removeRedBorderDate(component, event, helper);
		//START gianluigi.virga 05/07/2019 - BACKLOG-50
		}else{
								 
			docAuthList.push({value: $A.get("$Label.c.OB_Comune"), key: $A.get("$Label.c.OB_Comune")});
			docAuthList.push({value: $A.get("$Label.c.OB_Questura"), key: $A.get("$Label.c.OB_Questura")});																																					 															  
			docAuthList.push({value: $A.get("$Label.c.OB_Prefettura"), key: $A.get("$Label.c.OB_Prefettura")});
			docAuthList.push({value: $A.get("$Label.c.OB_Motorizzazione"), key: $A.get("$Label.c.OB_Motorizzazione")});
			docAuthList.push({value: $A.get("$Label.c.OB_UCO"), key: $A.get("$Label.c.OB_UCO")});				  
			//component.set('v.objectDataMap.'+inputobject+'.OB_Document_Release_Authority__c',"");
			component.set("v.docAuthList", docAuthList);
		}
		//END gianluigi.virga
	},
	setRedBorderCompanyData : function(component, event, helper) {
		var mapFromNext = {};
		var objectDataMap = component.get("v.objectDataMap");
		//START gianluigi.virga 09/07/2019 - BACKLOG-50
	    var inputobject = component.get("v.addressMapping.provinceinputobject");
	    var contact = objectDataMap[inputobject];
		var countryDoc = contact.OB_Document_Release_Country_Code__c;
		//END gianluigi.virga
        console.log('setredbord'+objectDataMap.setRedBordercompanyDataValidation+ '    '+objectDataMap.setRedBordercompanyDataValidation);
        if(objectDataMap.setRedBordercompanyDataDoc == true || objectDataMap.setRedBordercompanyDataValidation == true){
			mapFromNext = component.get("v.objectDataMap.checkMapValues");
			mapFromNextValidation = component.get("v.objectDataMap.validationCheckMap");
	        console.log("mandatory field from map: " + JSON.stringify(mapFromNext));
	        
			console.log("INTO IF METHOD OF TRUE BOOLEAN");
			
            for (var keys in mapFromNext)
            {
                	var errorId = 'errorId' +keys;
               		console.log("key  = " + keys);
                
               		var myDiv;
                
               		myDiv = document.createElement('div');
               		myDiv.setAttribute('id',errorId);//SET AN ID TO EVERY MESSAGE
               		myDiv.setAttribute('aura:id',errorId);
                	myDiv.setAttribute('style','color:rgb(194, 57, 52); position: absolute; z-index: 1;');
               		myDiv.setAttribute('class' , 'messageError'+keys);
               	 	//SET THE MESSAGE
               		var errorMessage = document.createTextNode(mapFromNext[keys]);
               		myDiv.appendChild(errorMessage);
                
                	var idSet = document.getElementById(keys);
			   		console.log("ID SET : " + idSet + ", input: " + JSON.stringify(component.find(keys)));
					//CONTROL TO CATCH THE AURA ID IN LIGHTNING:SELECT 
					//THIS METHOD STARTS WHEN ON DISPLAY THERE ARE THE INPUTS TO EXAMINE
			   		if($A.util.isUndefinedOrNull(idSet) && !$A.util.isUndefinedOrNull(component.find(keys))){
				 		idSet = component.find(keys).getElement();
					} else if($A.util.isUndefinedOrNull(idSet)){
				  		idSet = document.getElementsByName(keys)[0];
				  		if($A.util.isUndefinedOrNull(idSet)){
							idSet = document.getElementsByClassName(keys)[0];
							if(idSet){
								idSet.style.border = "2px solid rgb(221, 219, 218)";
						 		idSet.style.borderColor = "rgb(194, 57, 52)";
					  		} 
						}
					} 
				
					console.log('idSet::: '+idSet);
					if(idSet!=null && idSet!= undefined)
					{ 
						if(!(document.getElementById(errorId)) && !(idSet.value))
						{
							console.log("METHOD TO SHOW ONLY A MESSAGE in mapFromNext");
							idSet.after(myDiv);
							//idSet.className="slds-has-error flow_required";
						}
						$A.util.addClass(idSet, 'slds-has-error flow_required');
					}
            }//END FOR
            
             for (var keys in mapFromNextValidation)
            {
            	//START gianluigi.virga 09/07/2019 - BACKLOG-50
				if(countryDoc == 'ITA' || (countryDoc != 'ITA' && (keys != 'documentNumberlegaleRappDoc' || keys != 'documentExpirationDatelegaleRappDoc' || keys != 'documentAuthlegaleRappDoc'))){
				//END gianluigi.virga
					var errorId = 'errorId' +keys;
					console.log("key  = " + keys);
					
					var myDiv;
					
					myDiv = document.createElement('div');
					myDiv.setAttribute('id',errorId);//SET AN ID TO EVERY MESSAGE
					myDiv.setAttribute('style','color:rgb(194, 57, 52); position: absolute; z-index: 1;');
					myDiv.setAttribute('class' , 'messageError'+keys);
					//SET THE MESSAGE
					var errorMessage = document.createTextNode(mapFromNextValidation[keys]);
					console.log('errorMessage:: '+JSON.stringify(errorMessage));
					myDiv.appendChild(errorMessage);
					
					var idSet = document.getElementById(keys);
				
					//CONTROL TO CATCH THE AURA ID IN LIGHTNING:SELECT 
					//THIS METHOD STARTS WHEN ON DISPLAY THERE ARE THE INPUTS TO EXAMINE
					if($A.util.isUndefinedOrNull(idSet) && !$A.util.isUndefinedOrNull(component.find(keys))){
						idSet = component.find(keys).getElement();
						} else if($A.util.isUndefinedOrNull(idSet)){
						idSet = document.getElementsByName(keys)[0];
						if($A.util.isUndefinedOrNull(idSet)){
							idSet = document.querySelectorAll('input[id$="'+keys+'"]')[0];
							if($A.util.isUndefinedOrNull(idSet)){
								idSet = document.getElementsByClassName(keys)[0];
							}
							if(idSet){
								idSet.style.border = "2px solid rgb(221, 219, 218)";
								idSet.style.borderColor = "rgb(194, 57, 52)";
							} 
						} 
					}
					console.log("ID SET : " + idSet + ", input: " + JSON.stringify(component.find(keys))); 
					if(idSet!=null && idSet!= undefined)
					{ 
						console.log('errorId doc'+(document.getElementById(errorId)));
						if(!(document.getElementById(errorId)))
						{
							console.log("METHOD TO SHOW ONLY A MESSAGE in mapFromNextValidation");
							idSet.after(myDiv);
							//idSet.className="slds-has-error flow_required";
						}
						$A.util.addClass(idSet, 'slds-has-error flow_required');
					}
				}
			}//END FOR
        }
	    objectDataMap.setRedBordercompanyDataDoc = false;
	    objectDataMap.setRedBordercompanyDataValidation = false;
	    console.log("boolean value after: " + component.get("v.objectDataMap.setRedBordercompanyDataDoc" ));
	},
	validateDocumentNumber : function(component, event, helper) {
		var inputobject = component.get("v.addressMapping.provinceinputobject");
		var inputId = event.target.id;
		var documentNumber = event.getSource().get("v.value"); 
		console.log('validate number'+documentNumber);
		console.log('inputId::'+inputId);
		var typeInputValue = false;
		var errorId = 'errorId' + inputId;
		var errorIdValidation = 'errorId' + inputId;
		var errorCustomLabel = '';
		if(/[^a-zA-Z0-9]/.test(documentNumber)){
			console.log("validationKO");
			typeInputValue = true;
		}
		//START gianluigi.virga 09/07/2019 - BACKLOG-50
		var objectDataMap = component.get("v.objectDataMap");
	    var contact = objectDataMap[inputobject];
		var countryDoc = contact.OB_Document_Release_Country_Code__c;
		/* ANDREA MORITTU START 26-Nov-2019 - PRODOB_552 - ADDING LOGIC ON DOCUMENT NUMBER LENGTH */
		if((objectDataMap[inputobject].OB_Document_Type__c).toLowerCase() == ($A.get("$Label.c.OB_IdentityCardLabel")).toLowerCase()) {
			/* ANDREA MORITTU START 26-Nov-2019 - PRODOB_552 - FIX PRODOB_522_FIX */
			if((countryDoc == 'ITA' && ( documentNumber.length < 8 || documentNumber.length > 9 ) || typeInputValue==true)) {
  				/* ANDREA MORITTU END 26-Nov-2019 - PRODOB_552 - FIX PRODOB_522_FIX */
				if(document.getElementById(errorId))
				{
					console.log("errorID . " + errorId);
					document.getElementById(errorId).remove();
				}
				$A.util.addClass(document.getElementById(inputId) , 'slds-has-error');
				errorCustomLabel = $A.get("$Label.c.OB_InvalidDocumentNumber");
				myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorIdValidation);
				myDiv.setAttribute('style','color:rgb(194, 57, 52); position: absolute; z-index: 1;');
				var errorMessage = document.createTextNode(errorCustomLabel);
				myDiv.appendChild(errorMessage);
				var divAfter = document.getElementById(inputId);
				divAfter.after(myDiv);
			}
			else
			{
				if(document.getElementById(errorId))
				{
					console.log("errorID . " + errorId);
					document.getElementById(errorId).remove();
				}
				console.log("bankAccountNumber value in object data map:  "+JSON.stringify(component.get("v.objectDataMap."+inputobject)));	
				helper.removeRedBorder(component, event, helper);
			}
		} else {
			if((countryDoc == 'ITA' && documentNumber.length != 10 &&  documentNumber.length != 9) || typeInputValue==true) //g.v. added countryDoc condition in the if statement only for the lenght
			{
			//END gianluigi.virga
				if(document.getElementById(errorId))
				{
					console.log("errorID . " + errorId);
					document.getElementById(errorId).remove();
				}
				$A.util.addClass(document.getElementById(inputId) , 'slds-has-error');
				errorCustomLabel = $A.get("$Label.c.OB_InvalidDocumentNumber");
				myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorIdValidation);
				myDiv.setAttribute('style','color:rgb(194, 57, 52); position: absolute; z-index: 1;');
				var errorMessage = document.createTextNode(errorCustomLabel);
				myDiv.appendChild(errorMessage);
				var divAfter = document.getElementById(inputId);
				divAfter.after(myDiv);
			}
			else
			{
				if(document.getElementById(errorId))
				{
					console.log("errorID . " + errorId);
					document.getElementById(errorId).remove();
				}
				console.log("bankAccountNumber value in object data map:  "+JSON.stringify(component.get("v.objectDataMap."+inputobject)));	
				helper.removeRedBorder(component, event, helper);
			}
		}
		/* ANDREA MORITTU END 26-Nov-2019 - PRODOB_552 - ADDING LOGIC ON DOCUMENT NUMBER LENGTH */
	},
	changeValue : function(component, event, helper) {
		var objectDataMap = component.get("v.objectDataMap");
		var inputobject = component.get("v.addressMapping.provinceinputobject");
		component.set('v.objectDataMap.'+inputobject+'.OB_Document_Number__c', component.get("v.docNumber"));
	},
	changeValueDate : function(component, event, helper) {
		var objectDataMap = component.get("v.objectDataMap");
		var inputobject = component.get("v.addressMapping.provinceinputobject");
		
		//[0-9]{2}\/[0-9]{2}\/[0-9]{4}
		/*var contactTemp = component.get('v.contact');
		console.log('cambio value contactemp: '+JSON.stringify(contactTemp));*/
		console.log('cambiovalue'+JSON.stringify(objectDataMap[inputobject]));
		component.set('v.objectDataMap.'+inputobject+'.OB_Birth_Date__c', component.get("v.birthDate"));
		component.set('v.objectDataMap.'+inputobject+'.OB_Document_Release_Date__c', component.get("v.docRelDate"));
		component.set('v.objectDataMap.'+inputobject+'.OB_Document_Expiration_Date__c', component.get("v.docExpDate"));
		//component.set('v.objectDataMap.'+inputobject, contactTemp);
	},
	removeRedBorder: function(component, event, helper) {
		
        helper.removeRedBorder(component, event, helper);
    },
    removeRedBorderDate: function(component, event, helper) {
        var elementDateClass = event.getSource().get("v.class");
		var idSet = document.getElementsByClassName(elementDateClass)[0];
		var errorId = 'errorId' +elementDateClass;
        console.log("key  = " + elementDateClass);
        
        var myDiv;
        
        myDiv = document.createElement('div');
        myDiv.setAttribute('id',errorId);//SET AN ID TO EVERY MESSAGE
        myDiv.setAttribute('style','color:rgb(194, 57, 52); position: absolute; z-index: 1;');
        myDiv.setAttribute('class' , 'messageError'+elementDateClass);
        //SET THE MESSAGE
        
        if(idSet.value){
			if(!/^[0-9]{2}\/[0-9]{2}\/[0-9]{4}$/.test(idSet.value)){
				var errorMessage = document.createTextNode($A.get("$Label.c.OB_InvalidDateFormat"));
	            console.log('errorMessage:: '+JSON.stringify(errorMessage));
	            myDiv.appendChild(errorMessage);
	
				if(idSet!=null && idSet!= undefined)
				{ 
					console.log('errorId doc'+(document.getElementById(errorId)));
					if(!(document.getElementById(errorId)))
					{
						console.log("METHOD TO SHOW ONLY A MESSAGE");
						idSet.after(myDiv);
						idSet.style.border = "2px solid rgb(221, 219, 218)";
						idSet.style.borderColor = "rgb(194, 57, 52)";
					}
				}
				component.set("v.objectDataMap.errorDateMap."+elementDateClass, true);
		    } else{
		    	
		        idSet.style.border = "";
				idSet.style.borderColor = "";
		        //RECREATE THE SAME ID OF ERROR MESSAGE
		        var errorId = 'errorId'+ elementDateClass;
		        if(document.getElementById(errorId)!=null){
		            console.log("errorID . " + errorId);
		            document.getElementById(errorId).remove();
		        }
		        component.set("v.objectDataMap.errorDateMap."+elementDateClass, false);
		    }
		    
		    var errorDate = component.get("v.objectDataMap.errorDateMap");
			var isError = false;
			
			
	        for(var error in errorDate){
	        	if(errorDate[error] == true){
	        		isError=true;
	        	}
	        }
	        if(isError == false){
		    	helper.removeRedBorderDate(component, event, helper);
		    }
		} 
		/*
		ANDREA MORITTU START 17-Sept-2019 - EVO_BACKLOG_10
		*/
		else {
			if(component.get('v.objectDataMap.pagoBancomatArePresent') && elementDateClass == 'documentExpirationDatelegaleRappDoc' && idSet.value.length == 0 ) {
				helper.removeRedBorderDate(component, event, helper);
			}
		}
		/*
		ANDREA MORITTU END 17-Sept-2019 - EVO_BACKLOG_10
		*/
        
    },
    validate: function(component, event, helper) {
    	var errorDate = component.get("v.objectDataMap.errorDateMap");
        var isError = false;
        for(var error in errorDate){
        	if(errorDate[error] == true){
        		isError=true;
        	}
        }
        
        if(isError==true){
        	component.set("v.validState", false);
		} else {
			component.set("v.validState", true);
		}
    }
})