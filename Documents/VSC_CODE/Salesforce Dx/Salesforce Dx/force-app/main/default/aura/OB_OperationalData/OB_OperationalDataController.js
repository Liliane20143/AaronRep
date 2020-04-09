({
	doInit : function(component, event, helper) 
	{
		//25-09-2018-Salvatore P.-Set input values in object data map nodes
		var objectDataMap = component.get("v.objectDataMap");
		console.log("OBJECT DATA MAP IN OPERATIONAL DATA: " + JSON.stringify(objectDataMap));
		console.log('do init of Operational Data Controller');
		helper.getReportType(component,helper ,event );
		component.set("v.onfocusvar",false);
		// ****** Doris T. ** 08/10/2018 **** START **//
		var BillingProfileABI = component.get("v.objectDataMap.BillingProfilePOS.OB_ABICode__c");
		var bankABI           = component.get("v.objectDataMap.bank.OB_ABI__c");
		console.log("bank ABI = " + bankABI );
		console.log("BillingProfile ABI = " + BillingProfileABI);

		 var abiValue          = component.find("abi").get("v.value");
		 console.log("abi Value = " + abiValue);

		 if(BillingProfileABI == undefined || BillingProfileABI == null || BillingProfileABI == ''){
		 	//BillingProfileABI = bankABI;
		 	component.set("v.objectDataMap.BillingProfilePOS.OB_ABICode__c",bankABI);
		 	component.set("v.disabledAbi",true);
		}
		// ****** Doris T. ** 08/10/2018 **** END **//

		//	START 	micol.ferrari 12/10/2018 - SIT193
		component.set("v.objectDataMap.BillingProfilePOS.OB_HeaderInternational__c",objectDataMap.merchant.Name);
		//	END 	micol.ferrari 12/10/2018 - SIT193

	},

	fieldCheck : function(component, event, helper) // onchange
	{
		// 25-09-2018-Salvatore P.-Check if fields are of max length and focus on next input
		var inputId 		= event.getSource().getLocalId();
		var inputValue 		= component.find(inputId).get("v.value");
		var maxLengthInput 	= component.find(inputId).get("v.maxlength");
		console.log("MAXLENGHT: "+maxLengthInput);

		try
		{
			inputValue=inputValue.toUpperCase();
		}
		catch(err)
		{
			console.log('err.message: ' + err.message);
		}

		if(inputId == 'euroControlCode')
		{
			component.set("v.objectDataMap.BillingProfilePOS.OB_EuroControlCode__c",inputValue);
			nextInput=document.getElementById('cin');
			if(maxLengthInput==inputValue.length)
			{
				nextInput.focus();
			}

		}
		else if(inputId == 'cin')
		{
			component.set("v.objectDataMap.BillingProfilePOS.OB_CINCode__c",inputValue);
			nextInput=document.getElementById('abi');
			nextInput2=document.getElementById('cab');
			if(maxLengthInput==inputValue.length)
			{
				var disabledAbi = component.get("v.disabledAbi");
				if(disabledAbi == false)
				{	
					nextInput.focus();
				}
				else
				{
					nextInput2.focus();
				}
			}
		}
		else if(inputId == 'abi')
		{
			component.set("v.objectDataMap.BillingProfilePOS.OB_ABICode__c",inputValue);
			nextInput=document.getElementById('cab');
			if(maxLengthInput==inputValue.length)
			{
				nextInput.focus();
			}
		}
		else if(inputId == 'cab')
		{
			component.set("v.objectDataMap.BillingProfilePOS.OB_CABCode__c",inputValue);
			nextInput=document.getElementById('bankAccountNumber');
			if(maxLengthInput==inputValue.length)
			{
				nextInput.focus();
			}
		}
		else if(inputId == 'bankAccountNumber')
		{
			component.set("v.objectDataMap.BillingProfilePOS.OB_Bank_Account_Number__c",inputValue);
			nextInput=document.getElementById('headerInternational');
			if(maxLengthInput==inputValue.length)
			{
				// nextInput.focus();
			}
		}
	},

	completeIban : function(component,event,helper) //onblur
	{
// 25-09-2018-Salvatore P.-Check mandatory fields and validations 
		var inputId 				= event.getSource().getLocalId();
		console.log("INPUD ID: "+inputId);
		var inputValue 				= component.find(inputId).get("v.value");
		var errorId 				= 'errorId' + inputId;
		var errorIdValidation 		= 'errorId' + inputId;
		var errorCustomLabel 		= '';
		var myDiv;
		var arrayIban 				= [];
		var arrayConverted 			= [];
		var countryCodeValue 		=	component.get("v.objectDataMap.BillingProfilePOS.OB_CountryCode__c");
		var euroControlCodeValue 	=	component.get("v.objectDataMap.BillingProfilePOS.OB_EuroControlCode__c");
		var cinCodeValue 			=	component.get("v.objectDataMap.BillingProfilePOS.OB_CINCode__c");
		var abiCodeValue 			=	component.get("v.objectDataMap.BillingProfilePOS.OB_ABICode__c");
		var cabCodeValue 			=	component.get("v.objectDataMap.BillingProfilePOS.OB_CABCode__c");
		var bankAccountNumberValue 	= 	component.get("v.objectDataMap.BillingProfilePOS.OB_Bank_Account_Number__c");
		var ibanComplete 			=	countryCodeValue + euroControlCodeValue + cinCodeValue + abiCodeValue + cabCodeValue + bankAccountNumberValue;

		var ibanLength = ibanComplete.length;
		console.log("iban length: "+ibanLength);
		
		if(inputId == 'euroControlCode')
		{	
			var countryCode = component.find("countryCode").get("v.value");
			if(countryCode=="IT")
			{
				component.set("v.objectDataMap.BillingProfilePOS.OB_CountryCode__c","IT");
			}
			var typeInputValue = isNaN(inputValue);
			component.set("v.objectDataMap.BillingProfilePOS.OB_EuroControlCode__c", '');
			if(!inputValue)
			{				
				if(document.getElementById(errorIdValidation))
				{
					console.log("errorIdValidation . " + errorIdValidation);
					document.getElementById(errorIdValidation).remove();
				}
				console.log("control if fields value is null (onblur)");
				$A.util.addClass(component.find(inputId) , 'slds-has-error');
				errorCustomLabel = $A.get("$Label.c.MandatoryField");
				console.log("ERROR CUSTOM Label: "+errorCustomLabel);
				myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorId);
				myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
				var errorMessage = document.createTextNode(errorCustomLabel);
				myDiv.appendChild(errorMessage);
				var divAfter = component.find(inputId).getElement();
				divAfter.after(myDiv);

			}
			else if(inputValue.length > 0 && inputValue.length != 2 || typeInputValue==true)
			{
				if(document.getElementById(errorId))
				{
					console.log("errorID . " + errorId);
					document.getElementById(errorId).remove();
				}
				$A.util.addClass(component.find(inputId) , 'slds-has-error');
				errorCustomLabel = $A.get("$Label.c.TwoDigitLength");
				myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorIdValidation);
				myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
				var errorMessage = document.createTextNode(errorCustomLabel);
				myDiv.appendChild(errorMessage);
				var divAfter = component.find(inputId).getElement();
				divAfter.after(myDiv);
			}
			else
			{
				if(document.getElementById(errorId))
				{
					console.log("errorID . " + errorId);
					document.getElementById(errorId).remove();
				}
				component.set("v.objectDataMap.BillingProfilePOS.OB_EuroControlCode__c", inputValue);
				console.log("euroControlCode value in object data map:  "+JSON.stringify(component.get("v.objectDataMap.BillingProfilePOS.OB_EuroControlCode__c")));
				if(ibanLength == 27)
				{
					helper.validateIban(component,event,helper,inputId);
				}
			}
		}
		else if(inputId == "cin")
		{
			var typeInputValue = isNaN(inputValue);
			component.set("v.objectDataMap.BillingProfilePOS.OB_CINCode__c", '');
			if(!inputValue)
			{				
				if(document.getElementById(errorIdValidation))
				{
					console.log("errorIdValidation . " + errorIdValidation);
					document.getElementById(errorIdValidation).remove();
				}
				console.log("control if fields value is null (onblur)");
				$A.util.addClass(component.find(inputId) , 'slds-has-error');
				errorCustomLabel = $A.get("$Label.c.MandatoryField");
				console.log("ERROR CUSTOM Label: "+errorCustomLabel);
				myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorId);
				myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
				var errorMessage = document.createTextNode(errorCustomLabel);
				myDiv.appendChild(errorMessage);
				var divAfter = component.find(inputId).getElement();
				divAfter.after(myDiv);

			}
			else if(inputValue.length > 0 && inputValue.length != 1 || typeInputValue==false)
			{
				if(document.getElementById(errorId))
				{
					console.log("errorID . " + errorId);
					document.getElementById(errorId).remove();
				}
				$A.util.addClass(component.find(inputId) , 'slds-has-error');
				errorCustomLabel = $A.get("$Label.c.OneCharLength");
				myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorIdValidation);
				myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
				var errorMessage = document.createTextNode(errorCustomLabel);
				myDiv.appendChild(errorMessage);
				var divAfter = component.find(inputId).getElement();
				divAfter.after(myDiv);
			}
			else
			{
				if(document.getElementById(errorId))
				{
					console.log("errorID . " + errorId);
					document.getElementById(errorId).remove();
				}
				component.set("v.objectDataMap.BillingProfilePOS.OB_CINCode__c", inputValue);
				console.log("cin value in object data map:  "+JSON.stringify(component.get("v.objectDataMap.BillingProfilePOS.OB_CINCode__c")));
				if(ibanLength == 27)
				{
					helper.validateIban(component,event,helper,inputId);
				}
			}
		}
		else if(inputId == "abi")
		{
			var typeInputValue = isNaN(inputValue);
			component.set("v.objectDataMap.BillingProfilePOS.OB_ABICode__c", '');
			if(!inputValue)
			{				
				if(document.getElementById(errorIdValidation))
				{
					console.log("errorIdValidation . " + errorIdValidation);
					document.getElementById(errorIdValidation).remove();
				}
				console.log("control if fields value is null (onblur)");
				$A.util.addClass(component.find(inputId) , 'slds-has-error');
				errorCustomLabel = $A.get("$Label.c.MandatoryField");
				console.log("ERROR CUSTOM Label: "+errorCustomLabel);
				myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorId);
				myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
				var errorMessage = document.createTextNode(errorCustomLabel);
				myDiv.appendChild(errorMessage);
				var divAfter = component.find(inputId).getElement();
				divAfter.after(myDiv);

			}
			else if(inputValue.length > 0 && inputValue.length != 5 || typeInputValue==true)
			{
				if(document.getElementById(errorId))
				{
					console.log("errorID . " + errorId);
					document.getElementById(errorId).remove();
				}
				$A.util.addClass(component.find(inputId) , 'slds-has-error');
				errorCustomLabel = $A.get("$Label.c.FiveDigitLength");
				myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorIdValidation);
				myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
				var errorMessage = document.createTextNode(errorCustomLabel);
				myDiv.appendChild(errorMessage);
				var divAfter = component.find(inputId).getElement();
				divAfter.after(myDiv);
			}
			else
			{
				if(document.getElementById(errorId))
				{
					console.log("errorID . " + errorId);
					document.getElementById(errorId).remove();
				}
				component.set("v.objectDataMap.BillingProfilePOS.OB_ABICode__c", inputValue);
				console.log("abi value in object data map:  "+JSON.stringify(component.get("v.objectDataMap.BillingProfilePOS.OB_ABICode__c")));
				if(ibanLength == 27 && component.get("v.disabledAbi")==false)
				{
					helper.validateIban(component,event,helper,inputId);
				}
			}
		}
		else if(inputId == "cab")
		{
			var typeInputValue = isNaN(inputValue);
			component.set("v.objectDataMap.BillingProfilePOS.OB_CABCode__c", '');
			if(!inputValue)
			{				
				if(document.getElementById(errorIdValidation))
				{
					console.log("errorIdValidation . " + errorIdValidation);
					document.getElementById(errorIdValidation).remove();
				}
				console.log("control if fields value is null (onblur)");
				$A.util.addClass(component.find(inputId) , 'slds-has-error');
				errorCustomLabel = $A.get("$Label.c.MandatoryField");
				console.log("ERROR CUSTOM Label: "+errorCustomLabel);
				myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorId);
				myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
				var errorMessage = document.createTextNode(errorCustomLabel);
				myDiv.appendChild(errorMessage);
				var divAfter = component.find(inputId).getElement();
				divAfter.after(myDiv);

			}
			else if(inputValue.length > 0 && inputValue.length != 5 || typeInputValue==true)
			{
				if(document.getElementById(errorId))
				{
					console.log("errorID . " + errorId);
					document.getElementById(errorId).remove();
				}
				$A.util.addClass(component.find(inputId) , 'slds-has-error');
				errorCustomLabel = $A.get("$Label.c.FiveDigitLength");
				myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorIdValidation);
				myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
				var errorMessage = document.createTextNode(errorCustomLabel);
				myDiv.appendChild(errorMessage);
				var divAfter = component.find(inputId).getElement();
				divAfter.after(myDiv);
			}
			else
			{
				if(document.getElementById(errorId))
				{
					console.log("errorID . " + errorId);
					document.getElementById(errorId).remove();
				}
				component.set("v.objectDataMap.BillingProfilePOS.OB_CABCode__c", inputValue);
				console.log("cab value in object data map:  "+JSON.stringify(component.get("v.objectDataMap.BillingProfilePOS.OB_CABCode__c")));
				if(ibanLength == 27)
				{
					helper.validateIban(component,event,helper,inputId);
				}
			}
		}
		else if(inputId == "bankAccountNumber")
		{
			component.set("v.objectDataMap.BillingProfilePOS.OB_Bank_Account_Number__c", inputValue);
			var typeInputValue = false;
			if( /[^a-zA-Z0-9]/.test(inputValue))
			{
				typeInputValue = true;
			}
			if(!inputValue)
			{				
				if(document.getElementById(errorIdValidation))
				{
					console.log("errorIdValidation . " + errorIdValidation);
					document.getElementById(errorIdValidation).remove();
				}
				console.log("control if fields value is null (onblur)");
				$A.util.addClass(component.find(inputId) , 'slds-has-error');
				errorCustomLabel = $A.get("$Label.c.MandatoryField");
				console.log("ERROR CUSTOM Label: "+errorCustomLabel);
				myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorId);
				myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
				var errorMessage = document.createTextNode(errorCustomLabel);
				myDiv.appendChild(errorMessage);
				var divAfter = component.find(inputId).getElement();
				divAfter.after(myDiv);

			}
			else if(inputValue.length > 0 && inputValue.length != 12 || typeInputValue==true)
			{
				if(document.getElementById(errorId))
				{
					console.log("errorID . " + errorId);
					document.getElementById(errorId).remove();
				}
				$A.util.addClass(component.find(inputId) , 'slds-has-error');
				errorCustomLabel = $A.get("$Label.c.TwelveDigitLength");
				myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorIdValidation);
				myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
				var errorMessage = document.createTextNode(errorCustomLabel);
				myDiv.appendChild(errorMessage);
				var divAfter = component.find(inputId).getElement();
				divAfter.after(myDiv);
			}
			else if(document.getElementById(errorId))
			{
				console.log("errorID . " + errorId);
				document.getElementById(errorId).remove();
			}
			component.set("v.objectDataMap.BillingProfilePOS.OB_Bank_Account_Number__c", inputValue);
			console.log("bankAccountNumber value in object data map:  "+JSON.stringify(component.get("v.objectDataMap.BillingProfilePOS.OB_Bank_Account_Number__c")));
			if(ibanLength == 27)
			{
				helper.validateIban(component,event,helper,inputId);
			}
		}
		else if(inputId == 'headerInternational')
		{
			// console.log("reminder function: "+ helper.longIntegerReminder("96","97"));
			// console.log("reminder function 2: "+helper.longIntegerReminder("97","97"));
			// console.log("reminder function 3: "+helper.longIntegerReminder("290","15"));


			component.set("v.objectDataMap.BillingProfilePOS.OB_HeaderInternational__c", null);
			var typeInputValue = false;
			if(/^[a-zA-Z0-9()”?!&% $£  =^ °\/.'']+$/.test(inputValue))
			{
				typeInputValue = true;
			}
			if(!inputValue)
			{				
				if(document.getElementById(errorIdValidation))
				{
					console.log("errorIdValidation . " + errorIdValidation);
					document.getElementById(errorIdValidation).remove();
				}
			console.log("control if fields value is null (onblur)");
			$A.util.addClass(component.find(inputId) , 'slds-has-error');
			errorCustomLabel = $A.get("$Label.c.MandatoryField");
			console.log("ERROR CUSTOM Label: "+errorCustomLabel);
			myDiv = document.createElement('div');
			myDiv.setAttribute('id',errorId);
			myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
			var errorMessage = document.createTextNode(errorCustomLabel);
			myDiv.appendChild(errorMessage);
			var divAfter = component.find(inputId).getElement();
			divAfter.after(myDiv);
			}
			else if(typeInputValue==false)
			{
				if(document.getElementById(errorId))
				{
					console.log("errorID . " + errorId);
					document.getElementById(errorId).remove();
				}
				$A.util.addClass(component.find(inputId) , 'slds-has-error');
				errorCustomLabel = $A.get("$Label.c.errorSpecialCharacter");
				myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorIdValidation);
				myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
				var errorMessage = document.createTextNode(errorCustomLabel);
				myDiv.appendChild(errorMessage);
				var divAfter = component.find(inputId).getElement();
				divAfter.after(myDiv);
			}
			else
			{
				if(document.getElementById(errorId))
				{
					console.log("errorID . " + errorId);
					document.getElementById(errorId).remove();
				}
				component.set("v.objectDataMap.BillingProfilePOS.OB_HeaderInternational__c", inputValue);
				console.log("headerInternational value in object data map:  "+JSON.stringify(component.get("v.objectDataMap.BillingProfilePOS.OB_HeaderInternational__c")));
			}
		}
	},

	setPickListValue : function(component,event,helper)
	{
		// 25-09-2018-Salvatore P.-Set of picklist value
		var objectDataMap = component.get("v.objectDataMap");
		var reportType    = component.find("reportType").get("v.value");
		objectDataMap.OrderHeader.OB_Report_Type__c = reportType;
		console.log("Report type value in object data map:  "+JSON.stringify(component.get("v.objectDataMap.OrderHeader.OB_Report_Type__c")));
	},

	setRedBorderoperationalData: function(component, event, helper) 
	{
	 	helper.setRedBorderHelper(component,event,helper);
	},
	
	/* START 	micol.ferrari 01/10/2018 - CREATION OF BILLING PROFILES */
	confirmCreationBillingProfiles: function(component, event, helper) 
	{
		helper.confirmCreationBillingProfilesHelper(component,event,helper);
	},
	/* END	 	micol.ferrari 01/10/2018 - CREATION OF BILLING PROFILES */

})