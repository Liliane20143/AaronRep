({
	


	fieldsToCheckCopy : function(fieldName) {
		var excludedFields= {

			// "OB_Document_Release_State_Code__c": false,
			// "OB_Birth_State_Code__c": false,
			// "OB_Address_State_Code__c": false,
			// "OB_Business_Qualification__c": false,
			// "Role__c": false,
			// "AccountId": false,
			// "OB_PEP__c": false,
			// "OB_Address_Hamlet__c": false,
			"OB_Company_Link_Type__c" : false,
			"Id": false,
			"RecordTypeId" : false,
			"OB_SkipCadastralCodeCheck__c" : false    //Antonio Vatrano 12/12/18 checkbox controllo Cod Catastale
		}


		return !Object.prototype.hasOwnProperty.call(excludedFields, fieldName);
	},

	fieldsToCheckAdd: function(fieldName) {
		var excludedFields= {
			"Fax": false,
			"OB_Document_Release_State_Code__c": false,
			"OB_Birth_State_Code__c": false,
			"OB_Address_State_Code__c": false,
			"OB_Address_Country_Code__c" : false,
			"OB_Address_PostalCode__c" : false,
			"OB_Document_Release_Country_Code__c" : false,
			"OB_Business_Qualification__c": false,
			"Role__c": false,
			"OB_Citizenship__c": false,
			"AccountId": false,
			"RecordTypeId" : false,
			"OB_PEP__c": false,
			"OB_Address_Hamlet__c": false,
			"Id": false,
			"OB_Company_Link_Type__c" : false,
			"OB_Details_Address__c" : false,
			"sobjectType" : false,
			"OB_Contact_State__c" : false,
			"OB_SkipCadastralCodeCheck__c" : false    //Antonio Vatrano 12/12/18 checkbox controllo Cod Catastale
 

		}

		return !Object.prototype.hasOwnProperty.call(excludedFields, fieldName);
	},




	legaleRapp: function(component, event,helper){
		var objectDataMap = component.get("v.objectDataMap");
		if(document.getElementById("checkbox-19").checked){
			for(var key in objectDataMap['legale_rappresentante']){
				if(this.fieldsToCheckCopy(key)){
					objectDataMap['contact1'][key]= objectDataMap['legale_rappresentante'][key];
				}
			}
			component.set("v.objectDataMap",objectDataMap);
			var myEvent = $A.get("e.c:OB_EventAutoCompleteReInit");
			console.log("firing evt");
			myEvent.fire();
			console.log("fire evt");
		} 
		else {
			for(var key in objectDataMap['contact1']){
				if(key!= "RecordTypeId"){
					objectDataMap['contact1'][key]="";
					console.log('clear '+ key);
				}
			}
			component.set("v.objectDataMap",objectDataMap);
			var myEvent = $A.get("e.c:OB_EventAutoCompleteReInit");
			console.log("firing evt");
			myEvent.fire();
			console.log("fire evt");
		}
	},

	


	elementsRequired : function(component, lastIndex){
		var objectDataMap=component.get("v.objectDataMap");
		var contactToCheck= objectDataMap['contact'+lastIndex];
		console.log('contact req'+contactToCheck);
		
		var countryFull= contactToCheck.OB_Address_Country__c;
		var countryDoc= contactToCheck.OB_Document_Release_Country__c;
		var countryBirth= contactToCheck.OB_Country_Birth__c;
		var idState = null;
		var idCity = null;
		var idStreet = null;
		var idNumber = null;
		var idStateDoc = null;
		var idCityDoc = null;
		var idStateBirth = null;
		var idCityBirth = null;
		
		if(countryFull == 'ITALIA'){
			idState = "provinciacontact"+lastIndex+"Full";
			idCity = "comunecontact"+ lastIndex+"Full";
			idStreet = "stradacontact"+lastIndex+"Full";
			idNumber = "civicocontact"+lastIndex+"Full";
		} else {
			//idState = "provinceEEcontact"+lastIndex+"Full";
			idCity = "cityEEcontact"+ lastIndex+"Full";
			idStreet = "streetEEcontact"+lastIndex+"Full";
			idNumber = "civicoEEcontact"+lastIndex+"Full";
		}
		
		if(countryDoc == 'ITALIA'){
			idStateDoc = "provinciacontact"+lastIndex+"Doc";
			idCityDoc = "comunecontact"+ lastIndex+"Doc";
		} else {
			//idStateDoc = "provinceEEcontact"+lastIndex+"Doc";
			idCityDoc = "cityEEcontact"+ lastIndex+"Doc";
		}
		
		if(countryBirth == 'ITALIA'){
			idStateBirth = "provinciacontact"+lastIndex+"Birth";
			idCityBirth = "comunecontact"+ lastIndex+"Birth";
		} else {
			//idStateBirth = "provinceEEcontact"+lastIndex+"Birth";
			idCityBirth = "cityEEcontact"+ lastIndex+"Birth";
		}
		
		var idFirstName = "input:contact"+lastIndex+":FirstName";
		var idLastName = "input:contact"+lastIndex+":LastName";
		var idFiscalCode = "fiscalCodeContact"+lastIndex;
		var idSex = "input:contact"+lastIndex+":OB_Sex__c";
		var idBirthDate = "birthDatecontact"+lastIndex+"Doc";
		var idDocumentType = "documentTypecontact"+lastIndex+"Doc";
		var idDocumentNumber = "documentNumbercontact"+lastIndex+"Doc";
		var idDocumentAuth = "documentAuthcontact"+lastIndex+"Doc";
		var idDocumentReleaseDate = "documentReleaseDatecontact"+lastIndex+"Doc";
		var idDocumentExpirationDate = "documentExpirationDatecontact"+lastIndex+"Doc";
		
		console.log('firstName:: '+document.querySelectorAll('input[id$="'+idFirstName+'"]')[0]);
		var name = document.querySelectorAll('input[id$="'+idFirstName+'"]')[0];
		var lastname = document.querySelectorAll('input[id$="'+idLastName+'"]')[0];
		var fiscalcode = document.getElementById(idFiscalCode);
		var sex = document.getElementById(idSex);
		if(idState)
			var state = document.getElementById(idState);
		var city = document.getElementById(idCity);
		var street = document.getElementById(idStreet);
		var number = document.getElementById(idNumber);
		if(idStateDoc)
			var stateDoc = document.getElementById(idStateDoc);
		var cityDoc = document.getElementById(idCityDoc);
		if(idStateBirth)
			var stateBirth = document.getElementById(idStateBirth);
		var cityBirth = document.getElementById(idCityBirth);
		var birthdate = document.getElementsByClassName(idBirthDate)[0];
		var documenttype = document.getElementsByName(idDocumentType)[0];
		var documentnumber = document.getElementById(idDocumentNumber);
		var documentauth = document.getElementsByName(idDocumentAuth)[0];
		var documentreleasedate = document.getElementsByClassName(idDocumentReleaseDate)[0];
		var documentexperationdate = document.getElementsByClassName(idDocumentExpirationDate)[0];


		var map = {};
		if(!name.value){
			// map[idFirstName] = $A.get("$Label.c.MandatoryField");
			// .setAttribute("style", "border-color: rgb(194, 57, 52); box-shadow: rgb(194, 57, 52) 0 0 0 1px inset;");
			name.focus();
			name.blur();
		}
		if(!lastname.value){
			// map[idLastName] = $A.get("$Label.c.MandatoryField");
			// .setAttribute("style", "border-color: rgb(194, 57, 52); box-shadow: rgb(194, 57, 52) 0 0 0 1px inset;");
			lastname.focus();
			lastname.blur();
		}
		if(!fiscalcode.value){
			map[idFiscalCode] = $A.get("$Label.c.MandatoryField");
			// .setAttribute("style", "border-color: rgb(194, 57, 52); box-shadow: rgb(194, 57, 52) 0 0 0 1px inset;");
			//fiscalcode.focus();
			//fiscalcode.blur();
		}
		if(!sex.value){
			map[idSex] = $A.get("$Label.c.MandatoryField");
			// .setAttribute("style", "border-color: rgb(194, 57, 52); box-shadow: rgb(194, 57, 52) 0 0 0 1px inset;");
			// sex.focus();
			// component.set("v.objectDataMap.contact"+lastIndex+".OB_Sex__c", "M");
			// sex.blur();
			// sex.focus();
			// component.set("v.objectDataMap.contact"+lastIndex+".OB_Sex__c", "");
			// sex.blur();
			
		}
		if(state && !state.value){
			map[idState] = $A.get("$Label.c.MandatoryField");
		}
		if(!city.value){
			map[idCity] = $A.get("$Label.c.MandatoryField");
		}
		if(!street.value){
			map[idStreet] = $A.get("$Label.c.MandatoryField");
		}
		if(!number.value){
			map[idNumber] = $A.get("$Label.c.MandatoryField");	
		}
		if(stateDoc && !stateDoc.value){
			map[idStateDoc] = $A.get("$Label.c.MandatoryField");
		}
		if(!cityDoc.value){
			map[idCityDoc] = $A.get("$Label.c.MandatoryField");
		}
		if(stateBirth && !stateBirth.value){
			map[idStateBirth] = $A.get("$Label.c.MandatoryField");
		}
		if(!cityBirth.value){
			map[idCityBirth] = $A.get("$Label.c.MandatoryField");
		}
		if(!birthdate.value){
			map[idBirthDate] = $A.get("$Label.c.MandatoryField");
		}
		if(!documenttype.value){
			map[idDocumentType] = $A.get("$Label.c.MandatoryField");
		}
		if(!documentnumber.value){
			map[idDocumentNumber] = $A.get("$Label.c.MandatoryField");
		}
		if(!documentauth.value){
			map[idDocumentAuth] = $A.get("$Label.c.MandatoryField");
		}
		if(!documentreleasedate.value){
			map[idDocumentReleaseDate] = $A.get("$Label.c.MandatoryField");
		}
		if(!documentexperationdate.value){
			map[idDocumentExpirationDate] = $A.get("$Label.c.MandatoryField");
		}
		console.log('objectDataMap::: '+JSON.stringify(objectDataMap));
		component.set("v.objectDataMap.checkMapValues", map);

	},




	checkValidation : function (component, lastIndexNum, isAddOwner){
		var objectDataMap=component.get("v.objectDataMap");
		var contact = component.get("v.objectDataMap.contact"+lastIndexNum);
		if(contact["OB_Birth_Date__c"]==""){
			contact["OB_Birth_Date__c"] =null;
		}
		if(contact["OB_Document_Release_Date__c"]==""){
			contact["OB_Document_Release_Date__c"] = null;
		}
		if(contact["OB_Document_Expiration_Date__c"]==""){
			contact["OB_Document_Expiration_Date__c"] = null;
		}
		var contactString = JSON.stringify(contact);
		var lastIndex = lastIndexNum.toString();
		var action = component.get("c.validationCheck");
		console.log('typeof cont'+typeof contact+'   type lastIndex'+typeof lastIndex);
		action.setParams({contactString : contactString, lastIndex: lastIndex, data : objectDataMap});
		action.setCallback(this, function(response){
			var state = response.getState();
			if (state === "SUCCESS"){
				var  responseMap= response.getReturnValue();
				console.log("****responseMap: "+ JSON.stringify(responseMap));
				if(responseMap && Object.keys(responseMap).length != 0){
					component.set("v.objectDataMap.isErrorCF", true);
					component.set("v.objectDataMap.setRedBordercompanyDataValidation", true);
					component.set("v.objectDataMap.validationCheckMap ", responseMap);
					var myEvent = $A.get("e.c:OB_EventAutoCompleteRedBorder");
					console.log("*****objectDataMap: " + JSON.stringify(component.get("v.objectDataMap")));
					console.log("firing evt");
					myEvent.fire();
					console.log("fire evt");
					if(isAddOwner == true){
						component.set('v.addOwner','true');
					} else {
						component.set('v.changeOwner','true');
					}
				} else {
					if(isAddOwner == true){
						component.set('v.addOwner','false');
					} else {
						component.set('v.changeOwner','false');
					}
				}
				// component.set( "v.validationMap",  responseMap);
			} 
			else if (state === "INCOMPLETE"){
                // do something
            }
            else if (state === "ERROR"){
            	var errors = response.getError();
            	if (errors) {
            		if (errors[0] && errors[0].message){
            			console.log("Error message: " + errors[0].message);
            		}
            	}
            	else{
            		console.log("Unknown error");
            	}
            }
        });
		$A.enqueueAction(action);
		
	},


	addOwnerMethod2 : function(component, event, helper){
		console.log('boolean check'+ component.get('v.addOwner'));
		var objectDataMap=component.get("v.objectDataMap");
		var sections= component.get("v.sections");
		var lastIndex = sections.length;
		var lastContact = sections[lastIndex-1];
		var contactToCheck= objectDataMap['contact'+lastIndex];
		$A.util.addClass(component.find("legRapp"), 'slds-hide');
		$A.util.removeClass(component.find("legRapp"), 'slds-show');
		sections[lastIndex-1] = contactToCheck;
		var nextIndex=lastIndex+1;
		sections[lastIndex] = objectDataMap['contact'+nextIndex];
		
		for (var i = 1 ; i<=6; i++){
			if(i>sections.length){
				objectDataMap['unbind']['clean'+i]='hide';
				var btn= component.find("button"+i);
				btn.set("v.disabled",true);
			}
			if(i<=sections.length){
				var btn= component.find("button"+i);
				// $A.util.addClass(btn, 'button');
				btn.set("v.disabled",false);
				if(i==sections.length) {
					// $A.util.removeClass(btn, 'button');
					objectDataMap['unbind']['clean'+i]='show';
					objectDataMap['unbind']['required'+i]='required';
					// $A.util.removeClass(btn, 'button');

				} else {
					objectDataMap['unbind']['clean'+i]='hide';
					$A.util.addClass(btn, 'button');
				}
			}
		}
		component.set('v.objectDataMap', objectDataMap);
		component.set('v.sections', sections);
		if(sections.length==6){
			var addOwnerBtn= component.find('AddOwnerBtn');
			addOwnerBtn.set('v.disabled', true);
		}
		component.set('v.hasMessage', false);
		console.log('sections.length: '+sections.length)
		component.set('v.objectDataMap.lastContact', sections.length);
		var currentBTN = component.find("button"+nextIndex);
		$A.util.removeClass(currentBTN, 'button');
	},
	
	skipMandatory: function(key, contactToCheck){
		var ignoreMandatory = false;
		if(contactToCheck.OB_Address_Country__c != 'ITALIA' && key == 'OB_Address_State__c'){
			ignoreMandatory=true;
		}else if(contactToCheck.OB_Document_Release_Country__c != 'ITALIA' && key == 'OB_Document_Release_State__c'){
			ignoreMandatory=true;
		}else if(contactToCheck.OB_Country_Birth__c != 'ITALIA' && key == 'OB_Birth_State__c'){
			ignoreMandatory=true;
		}
		return ignoreMandatory;
	},
	checkMandatorySection: function(component, index){
		component.set("v.objectDataMap.checkMapValues", {});
		component.set('v.changeOwner','');
		component.set('v.objectDataMap.contactToGo', index);
		var objectDataMap=component.get("v.objectDataMap");
		var lastIndex = component.get('v.objectDataMap.lastContact');
		var contactToCheck= objectDataMap['contact'+lastIndex];
		var sectionFullFilled=false;
		var errorDate = component.get("v.objectDataMap.errorDateMap");
        for(var error in errorDate){
        	if(errorDate[error] == true){
        		sectionFullFilled=true;
        	}
        }
        
		for(var key in objectDataMap['contact'+lastIndex]){
			if(this.fieldsToCheckAdd(key)){
				if(objectDataMap['contact'+lastIndex][key]==null || objectDataMap['contact'+lastIndex][key]==''){
					if(!this.skipMandatory(key, contactToCheck)){
						console.log("missing field : "+ key);
						sectionFullFilled=true;
						break;
					}
				}
			}
		}
		
		if(sectionFullFilled){
			objectDataMap.setRedBordercompanyData = true;
			this.elementsRequired(component, lastIndex);
			var myEvent = $A.get("e.c:OB_EventAutoCompleteRedBorder");
			console.log("*****objectDataMap: " + JSON.stringify(component.get("v.objectDataMap")));
			console.log("firing evt");
			myEvent.fire();
			console.log("fire evt");
		}else {
			// helper.checkedTaxValue(component, lastIndex);
			this.checkValidation(component, lastIndex, false);
			console.log('section check val'+(component.get("v.objectDataMap.setRedBordercompanyDataValidation")));
			sectionFullFilled = (component.get("v.objectDataMap.setRedBordercompanyDataValidation"));
		}
		
	},
	
	changeOwnerMethod2: function(component,event,helper){
		component.set('v.objectDataMap.lastContact',component.get('v.objectDataMap.contactToGo'));
		var objectDataMap=component.get("v.objectDataMap");
		var index = component.get('v.objectDataMap.lastContact');
		objectDataMap['unbind']['clean'+index] = 'show';
		for (var i = 1 ; (i<=6); i++){
			var btn= component.find("button"+i);
			var isDisabled = btn.get("v.disabled");
			console.log('isDisabled: '+isDisabled);
			if(i != index){
				objectDataMap['unbind']['clean'+i]='hide';
				if (isDisabled==false)
				{
					$A.util.addClass(btn, 'button');
				}
			}
			else{
				$A.util.removeClass(btn, 'button');
			}
		}
		var legRapp= component.find('legRapp');
		if(index != 1){
			$A.util.addClass(component.find("legRapp"), 'slds-hide');
			$A.util.removeClass(component.find("legRapp"), 'slds-show');
		} else {
			$A.util.addClass(component.find("legRapp"), 'slds-show');
			$A.util.removeClass(component.find("legRapp"), 'slds-hide');
		}
		component.set("v.objectDataMap", objectDataMap);
		console.log("****objectDataMap: "+JSON.stringify(objectDataMap));
		component.set('v.hasMessage', false);
	},
	
	
    removeRedBorderAll: function (component, event , helper) {
    	var errorElements = document.getElementsByClassName("slds-has-error");
		var length = errorElements.length;
		for (i = 0; i < length; i++) {
		   $A.util.removeClass(errorElements[0] , 'slds-has-error');
		}
		
		var errorsListLabel = document.querySelectorAll("[id^='errorId']");
		for (i = 0; i < errorsListLabel.length; i++) {
	        if(errorsListLabel[i]!=null){
	            console.log("errorID . " + errorsListLabel[i].id);
	            errorsListLabel[i].remove();
	        }
	    }     
	    component.set('v.hasMessage', false);
	},
	
	//START gianluigi.virga 02/09/2019 - match titolari effettivi from objectDatamap with server 
	retrieveTitolariEffettiviFromServer: function (component, event , helper) {
		var accId = component.get('v.objectDataMap.merchant.Id');
		var abi = component.get('v.objectDataMap.bank.OB_ABI__c'); //g.v. 29/11/2019 - changed objectDataMap node from user to bank
		var action = component.get("c.retrieveTitolariEffettiviFromServer");
		action.setParams({accId : accId, ABI : abi});
		action.setCallback(this, function(response){
			var state = response.getState();
			if (state === "SUCCESS"){
				try{
					var responseList= response.getReturnValue();
					var obj = {};
					var list = [];
					list.obj = responseList;
					console.log('list.obj is ' + JSON.stringify(list.obj));
					console.log('list.length ' + list.obj.length);
					if(list.obj.length >= 1){
						for(var j in list.obj){
							var contactFromServer = list.obj[j];
							var contactAlreadyExist = false;
							for (var i = 1 ; i<=6; i++){
								var contact = component.get('v.objectDataMap.contact'+i);
								if(contact.OB_Fiscal_Code__c == contactFromServer.OB_Fiscal_Code__c && contact.FirstName !='' && contact.LastName !=''){
									component.set("v.objectDataMap.contact"+i, contactFromServer);
									component.set("v.objectDataMap.contact"+i+".Account.Id", component.get("v.objectDataMap.merchant.Id"));
									component.set("v.objectDataMap.contact"+i+".Account.Name", component.get("v.objectDataMap.merchant.Name"));
									var myEvent = $A.get("e.c:OB_EventAutoCompleteReInit");
									myEvent.fire();
									contactAlreadyExist = true;
								}
							}
							if(contactAlreadyExist == false){
								for(var k = 1 ; k<=6; k++){
									var emptyContact = component.get("v.objectDataMap.contact"+k);
									if(emptyContact.OB_Fiscal_Code__c == '' && emptyContact.FirstName == '' && emptyContact.LastName == ''){
										component.set("v.objectDataMap.contact"+k, contactFromServer);
										component.set("v.objectDataMap.contact"+k+".Account.Id", component.get("v.objectDataMap.merchant.Id"));
										component.set("v.objectDataMap.contact"+k+".Account.Name", component.get("v.objectDataMap.merchant.Name"));
										var myEvent = $A.get("e.c:OB_EventAutoCompleteReInit");
										myEvent.fire();
										break;
									}
								}
							}
						}	
					}
					console.log('datamap AFTER DO INIT: '+ JSON.stringify(component.get('v.objectDataMap')));
					Promise.all([
					    helper.setTitolariEffettivi(component, event, helper)
					]).then(
					    function(response) {
					        component.set("v.isInitialized", true);//NEXI-323 Grzegorz Banach <grzegorz.banach@accenture.com> 11/09/2019
                        }
                    ).catch(
						function(error) {
							component.set("v.status" ,error ) ;
							console.log(error);
						}
					);
				}catch(e){
					console.log ("ERROR :" +e.message);
				}
			} 
			else if (state === "INCOMPLETE"){
                // do something
            }
            else if (state === "ERROR"){
            	var errors = response.getError();
            	if(errors){
            		if(errors[0] && errors[0].message){
            			console.log("Error message: " + errors[0].message);
            		}
            	}
            	else{
            		console.log("Unknown error");
            	}
            }
        });
		$A.enqueueAction(action);
	},
	setTitolariEffettivi: function (component, event , helper) {
		var objectDataMap = component.get('v.objectDataMap');
		var sections = component.get('v.sections');
		sections.push(objectDataMap['contact1']);
		for (var i = 2 ; i<=6; i++){
			var contact = objectDataMap['contact'+i];
			if(contact.FirstName !='' && contact.LastName !=''){
				sections.push(contact);
			}
		}		
		// console.log("length sections: "+ sections.length);
		for (var i = 1 ; i<=6; i++){
			var btn= component.find("button"+i);
			if(i>sections.length){
				objectDataMap['unbind']['clean'+i]='hide';
				// var btn= component.find("button"+i);
				// $A.util.addClass(btn, 'button');
				btn.set("v.disabled",true);
			}

			if(i<=sections.length){
				// var btnSelect= component.find("button"+i);
				btn.set("v.disabled",false);
				$A.util.addClass(btn, "button");
				objectDataMap['unbind']['required'+i]='required';
				if(i==sections.length) {
					// objectDataMap['unbind']['clean'+i]='show';
					// objectDataMap['unbind']['required'+i]='required';
					
				} else {
					objectDataMap['unbind']['clean'+i]='hide';
					$A.util.addClass(btn, "button");
				}
			}
		}
		component.set('v.objectDataMap', objectDataMap);
		component.set('v.sections',sections);
		component.set('v.objectDataMap.lastContact', 1);
	}
	//END gianluigi.virga
})