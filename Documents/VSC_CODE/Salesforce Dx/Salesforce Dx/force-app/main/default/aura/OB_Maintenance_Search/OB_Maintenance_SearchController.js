({
	init: function(component, event, helper) 
	{

		helper.toggleSpinner(component);
		helper.getCurrentUser(component);
		helper.toggleSpinner(component);

		// START Elena Preteni MAIN_62_R1F1
		helper.getAbi(component, helper,event );
		
		helper.getFieldToShow(component, helper,event);
		helper.getCabListFromLov(component, event, helper);
		// END Elena Preteni MAIN_62_R1F1
		//giovanni spinelli - start- 27/09/2019
		helper.getUrl( component );
		//giovanni spinelli - end- 27/09/2019
		
	},

	checkOnSearchButton : function(component,event,helper)
	{
		var target 		= event.getSource();
		var whichOne 	= target.getLocalId();
		var inputField 	= component.find(whichOne); 
		inputField.setCustomValidity(''); 
		inputField.showHelpMessageIfInvalid(); 
		helper.checkenableButton(component, event, helper); 
	},

	startSearch: function(component, event, helper) 
	{
		//28/01/19 francesca.ribezzi -  spinner must be on
		//helper.toggleSpinner(component);
		// ANDREA MORITTU START 2019-Aug-26 - UX.194 - Adding incoming parameter to helepr method
		helper.performSearch(component, event, helper, '');
		// ANDREA MORITTU END 2019-Aug-26 - UX.194 - Adding incoming parameter to helepr method

	},
	checkFiscalCode: function(component, event, helper)
	{
		var target = event.getSource();
		var whichOne = target.getLocalId();
		var inputField = component.find(whichOne);    

		var fiscalCode = target.get("v.value");//event.target.value;
		if(fiscalCode)
		{
			console.log('field filled');
			console.log ('checkFiscalCodeOrVatNumner whichOne is'+ whichOne);
			console.log ('checkFiscalCodeOrVatNumner cheked is'+ fiscalCode);
			var result;
			var fieldControlFiscalCode = new Map();
			result = helper.ControllaCF(fiscalCode,fieldControlFiscalCode);

			if(result){
				console.log('ERROR');
				console.log('inputField' +inputField);
				//inputField.set('v.class',inputField.get('v.class')+' slds-has-error');
				//inputField.set('v.value','err');
				// C.Q 31/11 specialized error message
				var labelToShow ='';
				if(result == 1)
					labelToShow = $A.get("$Label.c.FiscalCodeLengthError")  ;
				if(result == 2)
					labelToShow = $A.get("$Label.c.FiscalCodeCharactersError");
				if(result == 3)
					labelToShow =$A.get("$Label.c.FiscalCodeFormattingError");
				//var labelToShow = $A.get('$Label.c.OB_MAINTENANCE_FISCALCODEORPIVAWRONG');
				inputField.setCustomValidity(labelToShow); 
				inputField.showHelpMessageIfInvalid(); 

				// disbale search button 
				
				//button.set('v.disabled',true);

				//inputField.set('v.validity', {valid:false, badInput :true});
				//inputField.showHelpMessageIfInvalid();
			
			}
			else
			{
				inputField.setCustomValidity(''); 
				inputField.showHelpMessageIfInvalid(); 
				console.log('ok');
				//button.set('v.disabled',false);
			}
		}
		else
		{
			console.log('field blank');
			inputField.setCustomValidity(''); 
			inputField.showHelpMessageIfInvalid(); 
		}
		helper.checkenableButton(component, event, helper);
		console.log ('checkFiscalCodeOrVatNumner result is : '+ result);

	},
	checkIVA :  function(component, event, helper)
	{
		var target 		= event.getSource();
		//giovanni spinelli - start - 11/10/2019 delete space and reset value in input
		var partitaIva 	= target.get("v.value").trim();
		component.find("VatNumber").set("v.value", partitaIva);
		//giovanni spinelli - start - 11/10/2019 delete space and reset value in input
		var whichOne 	= target.getLocalId();
		var inputField 	= component.find(whichOne);

		if(partitaIva)
		{
			console.log ('fieldPopulated');
			console.log ('checkVatNumber whichOne is'+ whichOne);
			//var inputField = component.find('inputField');
			console.log ('checkFiscalCodeOrVatNumber cheked is'+ partitaIva);
			var result;
			var fieldControlFiscalCode = new Map();			
			if(partitaIva.length>11){
				result =1;
			}else{
				result = helper.checkPIVA(partitaIva);
			}
			//var button = component.find ("SearchButton");
			if(result)
			{
				console.log('ERROR');
				console.log('inputField' +inputField);
				//inputField.set('v.class',inputField.get('v.class')+' slds-has-error');
				//inputField.set('v.value'	
				//button.set('v.disabled',true);
				// C.Q 31/11 specialized error message
				var labelToShow ='';
				if(result == 1) 
					labelToShow = $A.get("$Label.c.VATLengthError")  ;
				if(result == 2)
					labelToShow = $A.get("$Label.c.VATCharactersError");
				if(result == 3)
					labelToShow =$A.get("$Label.c.VATFormattingError");
				//var labelToShow = $A.get('$Label.c.OB_MAINTENANCE_FISCALCODEORPIVAWRONG');
				inputField.setCustomValidity(labelToShow); 
				inputField.showHelpMessageIfInvalid(); 
				//inputField.set('v.validity', {valid:false, badInput :true});
				//inputField.showHelpMessageIfInvalid();
			}
			else{
				inputField.setCustomValidity(''); 
				inputField.showHelpMessageIfInvalid(); 
				console.log('ok');
				//button.set('v.disabled',false);
				//helper.enableButton(component, event, helper);
			}
		}
		else{
			inputField.setCustomValidity(''); 
			inputField.showHelpMessageIfInvalid(); 
		}
		helper.checkenableButton(component, event, helper);
		console.log ('checkFiscalCodeOrVatNumner result is'+ result);
		return result;
	},

	fieldChanged : function(component, event, helper)
	{
		/*var target = event.getSource();
		var whichOne = target.getLocalId();
		var inputField = component.find(whichOne); 
		var value = inputField.get("v.validity");
		var button = component.find ("SearchButton");
		console.log(value.valid);
		if( value.valid){
				button.set('v.disabled',false);
		}
		else{
			button.set('v.disabled',true);
		}*/
		helper.checkenableButton(component, event, helper);
	},

	checkInputValue : function(component,event,helper)
	{
		var target 		= event.getSource();
		var inputValue 	= target.get("v.value");
		var whichOne 	= target.getLocalId();
		var inputField 	= component.find(whichOne);
		var passTest 	= false;
		console.log("@Into checkInputValue : whichOne : " + whichOne);
		console.log("inputValue : " + inputValue);
		try
		{
			if(inputValue != "" && inputValue != null)
			{
				if(whichOne == "ServicePoint")
				{
					console.log("actual whichOne ServicePoint");
					if(/^[0-9]{9}$/.test(inputValue) == true)
					{
						passTest = true;
					}
				}
				else if(whichOne == "SIACode")
				{
					console.log("actual whichOne SIACode");
					if(/^[0-9]{7}$/.test(inputValue) == true)
					{
						passTest = true;
					}
				}
				else if(whichOne == "SiaEstablishment")
				{
					console.log("actual whichOne SiaEstablishment");
					if(/^[0-9]{5}$/.test(inputValue) == true)
					{
						passTest = true;
					}
				}
				else if(whichOne == "TerminalId")
				{
					console.log("actual whichOne TerminalId");
					if(/^[0-9]{8}$/.test(inputValue) == true)
					{
						passTest = true;
					}
				}
				else if(whichOne == "MoneticaCustomerCode")
				{
					console.log("actual whichOne MoneticaCustomerCode");
					if(/^[0-9]{6}$/.test(inputValue) == true)
					{
						passTest = true;
					}
				}
				else if(whichOne == "MoneticaEstablishmentCode")
				{
					console.log("actual whichOne MoneticaEstablishmentCode");
					if(/^[0-9]{5}$/.test(inputValue) == true)
					{
						passTest = true;
					}
				}
				else if(whichOne == "ABI")
				{
					console.log("actual whichOne ABI");
					if(/^[0-9]{5}$/.test(inputValue) == true)
					{
						passTest = true;
					}
				}
				//START Andrea Saracini 18/03/2019 Card No Present for future regex
				else if(whichOne == "url")
				{
					passTest = true;
				}
				else if(whichOne == "app")
				{
					passTest = true;
				}
				//END Andrea Saracini 18/03/2019 Card No Present for future regex
				//START MORITTU ANDREA 26-Aug-2019 - UX.194 - Adding new searchable input
				else if(whichOne == "merchantBusinessName") {
					var hasSpecialCharacters = function(input){
						const result='ERROR';
						var re = new RegExp('^[a-zA-Z0-9()\"?!&% $£ \" \\ =^ °\/\'.;]+$');
						if(!re.test(input)) {
							return result;
						} else {
							return null;
						}
					}

					let value = component.find(whichOne).get('v.value');
					var outcome = hasSpecialCharacters(value);
					// CHECK ON BUSINESS NAME . LENGTH (IF < 3 ERROR)
					if(value.length < 3) {
						outcome = 'ERROR';	
					}

					if(outcome == 'ERROR') {
						passTest = false;
					} else {
						passTest = true;
					}
				}
				//END MORITTU ANDREA 26-Aug-2019 - UX.194 - Adding new searchable input
				//START Andrea Saracini 18/03/2019 Card No Present 
				if(passTest == false)
				{
					var labelToShow = "";
					console.log("Has an error on : " + whichOne);
					labelToShow = $A.get("$Label.c.OB_invalidValue");
					inputField.setCustomValidity(labelToShow);
					inputField.showHelpMessageIfInvalid();
					helper.checkenableButton(component, event, helper);
				}
			}
			else
			{
				console.log("inputValue is null : " + inputValue);
				inputField.setCustomValidity(''); 
				inputField.showHelpMessageIfInvalid(); 
				helper.checkenableButton(component, event, helper); 
			}
		}
		catch(error)
		{
			console.log("[EXC] OB_Maintenance_SearchController.js : checkInputValue : " + error);
		}
	},
	// start elena.preteni 26/3/2019

	//  DG - 28/03/2019 - R1F2_RP_019 - START
	openCABSelection : function(component, event, helper){
		helper.createComponent(component, event);
	},

	handleShowModalEvent : function(component, event, helper) {
		//flowData is the new objectDataMap
        var flowData = event.getParam("objectDataMap");
        console.log("handleShowModalEvent event.getParam: " +JSON.stringify(flowData));
		component.set("v.FlowData", JSON.stringify(flowData));
		var cab = '';
		cab = flowData.userWrapper.cab;
		component.set("v.selectedCab", cab);
		var userWrapper = component.get("v.UserWrapper");
		userWrapper.userCAB = cab;
		component.set("v.UserWrapper", userWrapper);
		console.log("Final userWrapper" + JSON.stringify(component.get("v.UserWrapper")));
	},
	//  DG - 28/03/2019 - R1F2_RP_019 - END

	/* 
        *   Author      : Morittu Andrea
        *   Date        : 27/Aug/2019
        *   Description : Function Javascript to close the modal and clear input fields 
    */
	closeModal : function(component, event, helper) {
		component.set('v.showAccountsModal', false);
		helper.clearInputMaintenanceSearch(component, event, helper);
	},

	/* 
        *   Author      : Morittu Andrea
        *   Date        : 27/Aug/2019
        *   Description : Function on click of radio button account selection
    */
   selectionMerchant : function(component, event, helper) {
	   helper.selectionMerchant_Helper(component, event, helper);
	},
	/**
	*@author Giovanni Spinelli <spinelli.giovanni@accenture.com>
	*@date 27/09/2018
	*@description Method to fire flow from modal
	*@params -
	*@return 
	*/
	fireFlow : function(component, event, helper) {
		
		var AccountName      =  component.find("AccountName").get('v.value');
		var VatNumber        =  component.find("VatNumber").get('v.value');
		helper.redirectFlow(component , AccountName , VatNumber);
	},
	/**
	*@author Giovanni Spinelli <spinelli.giovanni@accenture.com>
	*@date 27/09/2018
	*@description Method to reload page and start search again
	*@params -
	*@return 
	*/
	refreshPage : function(component, event, helper) {
		location.reload();
	},
	// start francesca.ribezzi 21/06/19 - descoping-consistenza
	handleRefreshSearch: function(component, event, helper) {
		console.log('into handleRefreshSearch');
		var fiscalCode = component.get("v.fiscalCode");
		helper.performSearch(component, event, helper,fiscalCode);
	},
	// end francesca.ribezzi 21/06/19
})