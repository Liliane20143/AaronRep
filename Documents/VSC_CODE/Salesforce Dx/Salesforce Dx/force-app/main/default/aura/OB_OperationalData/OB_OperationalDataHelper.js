({
	getReportType : function (component , helper , event )
	{
		//25-09-2018-Salvatore P.- Get picklist values for Report Type field
		var actionGetReportTypeValues = component.get("c.getReportTypeValues");
		var objectDataMap = component.get("v.objectDataMap");
		actionGetReportTypeValues.setCallback(this, function(response)
		{
			 var state = response.getState();
			 if (state === "SUCCESS") 
			 {
				 var  tempMap =[];
				 var  responseMap= response.getReturnValue();
				 for(var key in responseMap)
				 {
					tempMap.push({value:responseMap[key], key:key});
				 }
				 component.set( "v.reportTypeList",  tempMap);
				 console.log("Value of picklist report type: "+tempMap);
			 } 
			 else if (state === "INCOMPLETE") 
			 {
				 // do something
			 }
			 else if (state === "ERROR") 
			 {
				var errors = response.getError();
				if (errors) 
				{
					if (errors[0] && errors[0].message) 
					{
						console.log("Error message: " + errors[0].message);
					}
				}
				else 
				{
					console.log("Unknown error");
				}
			 }
		 });
		$A.enqueueAction(actionGetReportTypeValues); 
	},

	/* START 	micol.ferrari 01/10/2018 - CREATION OF BILLING PROFILES */
	confirmCreationBillingProfilesHelper: function(component, event, helper) 
	{
		var objectDataMap 			= component.get("v.objectDataMap");
		var merchantId 				= objectDataMap.merchant.Id;
		var actualBankId 			= objectDataMap.actualBank;
		var objBillingProfilePOS 	= JSON.stringify(objectDataMap.BillingProfilePOS);
		var objOrderHeader 			= JSON.stringify(objectDataMap.OrderHeader);

		//	CLONE OF BILLINGPROFILEPOS TO BILLINGPROFILEACQUIRING		
		var countrycode 		= objectDataMap.BillingProfilePOS.OB_CountryCode__c;
		var eurocontrolcode 	= objectDataMap.BillingProfilePOS.OB_EuroControlCode__c;
		var cin 				= objectDataMap.BillingProfilePOS.OB_CINCode__c;
		var abi 				= objectDataMap.BillingProfilePOS.OB_ABICode__c;
		var cab					= objectDataMap.BillingProfilePOS.OB_CABCode__c;
		var bankaccountnumber 	= objectDataMap.BillingProfilePOS.OB_Bank_Account_Number__c;
		var headerinternational = objectDataMap.BillingProfilePOS.OB_HeaderInternational__c;
		
		objectDataMap.BillingProfileAcquiring.OB_CountryCode__c 			= countrycode;
		objectDataMap.BillingProfileAcquiring.OB_EuroControlCode__c 		= eurocontrolcode;
		objectDataMap.BillingProfileAcquiring.OB_CINCode__c 				= cin;
		objectDataMap.BillingProfileAcquiring.OB_ABICode__c 				= abi;
		objectDataMap.BillingProfileAcquiring.OB_CABCode__c 			= cab;
		objectDataMap.BillingProfileAcquiring.OB_Bank_Account_Number__c 	= bankaccountnumber;
		objectDataMap.BillingProfileAcquiring.OB_HeaderInternational__c 	= headerinternational;

		component.set("v.objectDataMap",objectDataMap);
		// console.log('## BillingProfileAcquiring '+component.get("v.objectDataMap.BillingProfileAcquiring");

		console.log('## merchantId '+merchantId);
		console.log('## actualBankId '+actualBankId);
		console.log('## objBillingProfilePOS '+objBillingProfilePOS);
		console.log('## objOrderHeader '+objOrderHeader);

		//	INSERT OF TWO BILLING PROFILES
		var createBillingProfiles = component.get("c.insertBillingProfilesUpdateOrderHeader");
		createBillingProfiles.setParams({
											"objectDataString": JSON.stringify(objectDataMap),
											"merchantId": merchantId,
											"actualBankId": actualBankId
										});
		createBillingProfiles.setCallback(this,function(response) 
		{
			var state = response.getState();			 
			if (state === "SUCCESS") 
			{	
				console.log('SUCCESS confirmCreationBillingProfilesHelper');				
				var responseData		= {};
				responseData 			= response.getReturnValue();
				component.set("v.objectDataMap",responseData);
				console.log('responseData AFTER METHOD: ');
				console.log(JSON.stringify(responseData));

				var objectDataMapAfter	= component.get("v.objectDataMap");				

				//	CHECK MANDATORY FIELDS KO
				if (objectDataMapAfter.setRedBorderoperationalData==true)
				{
					objectDataMapAfter.BillingProfileAcquiring.OB_CountryCode__c 			= "";
					objectDataMapAfter.BillingProfileAcquiring.OB_EuroControlCode__c 		= "";
					objectDataMapAfter.BillingProfileAcquiring.OB_CINCode__c 				= "";
					objectDataMapAfter.BillingProfileAcquiring.OB_ABICode__c 				= "";
					objectDataMapAfter.BillingProfileAcquiring.OB_CABCode__c 				= "";
					objectDataMapAfter.BillingProfileAcquiring.OB_Bank_Account_Number__c 	= "";
					objectDataMapAfter.BillingProfileAcquiring.OB_HeaderInternational__c 	= "";
					component.set("v.objectDataMap",objectDataMapAfter);
					this.setRedBorderHelper(component,event,helper);
				}
				else
				{
					//---------------------------------------------------------

					//			SHOW CATALOG

					//---------------------------------------------------------
				}				
			}
			else if (state === "INCOMPLETE") 
			{
				//	INCOMPLETE
				console.log('INCOMPLETE confirmCreationBillingProfilesHelper');
			}
			else if (state === "ERROR") 
			{
				//	ERROR TBD
				console.log('ERROR confirmCreationBillingProfilesHelper');
			}
		});
		$A.enqueueAction(createBillingProfiles); 
	},

	setRedBorderHelper: function(component, event, helper) 
	{
		// 26-09-2018-Salvatore P.-Check mandatory fields on next button
		var mapFromNext 	= {};
		var objectDataMap 	= component.get("v.objectDataMap");
		console.log('setredbord'+objectDataMap.setRedBorderoperationalData);
		if(objectDataMap.setRedBorderoperationalData == true)
		{
			mapFromNext = component.get("v.objectDataMap.checkMapValuesoperationalData");
			console.log("mandatory field from map: " + JSON.stringify(mapFromNext));
			
			console.log("INTO IF METHOD OF TRUE BOOLEAN");
			for (var keys in mapFromNext)
			{
	
				var errorId = 'errorId' +keys;
				console.log("key  = " + keys);
				
				var myDiv;
				
				myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorId);//SET AN ID TO EVERY MESSAGE
				myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
				myDiv.setAttribute('class' , 'messageError'+keys);
				//SET THE MESSAGE
				var errorMessage = document.createTextNode(mapFromNext[keys]);
				myDiv.appendChild(errorMessage);

				var idSet = document.getElementById(keys);
				console.log("ID SET : " + idSet + ", input: " + component.find(keys));
				//CONTROL TO CATCH THE AURA ID IN LIGHTNING:SELECT 
				//THIS METHOD STARTS WHEN ON DISPLAY THERE ARE THE INPUTS TO EXAMINE
				if($A.util.isUndefinedOrNull(idSet) && !$A.util.isUndefinedOrNull(component.find(keys)))
				{
					idSet = component.find(keys).getElement();
				}
				if(idSet!=null && idSet!= undefined)
				{ 
					if(!(document.getElementById(errorId)) && !(idSet.value))
					{
						console.log("METHOD TO SHOW ONLY A MESSAGE");
						idSet.after(myDiv);
						idSet.className="slds-has-error";
					}
				}//END FOR
			}
			component.set("v.objectDataMap.setRedBorderoperationalData" , false);
			console.log("boolean value after: " + component.get("v.objectDataMap.setRedBorderoperationalData" ));
		}
	},
	/* END	 	micol.ferrari 01/10/2018 - CREATION OF BILLING PROFILES */

	greaterThan: function(x,y)
	{
		if (x.length > y.length)
		{
			y= this.padS(y,x.length);
		}
		if (x.length < y.length)
		{
			x= this.padS(x,y.length);
		}
		return (x > y);
	},

	padS: function(s,size){
			while (s.length < (size || 1)) {s = "0" + s;}
			return s;
	},

	lessThan: function(x,y){
		if (x.length>y.length)
		{
			y= this.padS(y,x.length);
		}
		if (x.length<y.length)
		{
			x= this.padS(x,y.length);
		}

		return (x < y);
	},

	equal: function(x,y)
	{
		
		return (!(this.greaterThan(x,y) || this.lessThan(x,y)));
	},

	longIntegerReminder: function(x,y)
	{
		var firstDigit;
		var lastDigit;

		if(this.lessThan(x,y)){
			return parseInt(x);
		}

		if(this.equal(x,y)) return 0;


		for(var i = 1;i <= x.length;i++)
		{	
			firstDigit = x.substring(0,i);
			lastDigit = x.substring(i,x.length);
			console.log('i: ' + i);
			console.log('firstDigit: ' + firstDigit);
			console.log('y: ' + y);
			console.log('lastDigit: ' + lastDigit);
			
			if(this.greaterThan(firstDigit,y)|| this.equal(firstDigit,y)) {
				console.log('break');
				break;
			} 


		}		
		console.log('firstDigit: ' + firstDigit);
		console.log('lastDigit: ' + lastDigit);

		var reminder = parseInt(firstDigit) % parseInt(y);
		console.log("reminder: "+ reminder);


		
		var newNumb = reminder.toString() + lastDigit.toString();
		console.log('newNumb: ' + newNumb);

			console.log("Y: "+y);
		
		return parseInt(this.longIntegerReminder(newNumb.toString(),y));
	},

		validateIban : function(component,event, helper,inputId)
	{
// 04-10-2018-Salvatore P.-Validation of complete IBAN
		var errorId 				= 'errorId' + inputId;
		var errorCustomLabel 		= '';
		var myDiv;
		var arrayIban 				= [];
		var arrayConverted 			= [];
		var countryCodeValue 		= component.get("v.objectDataMap.BillingProfilePOS.OB_CountryCode__c");
		var euroControlCodeValue 	= component.get("v.objectDataMap.BillingProfilePOS.OB_EuroControlCode__c");
		var cinCodeValue 			= component.get("v.objectDataMap.BillingProfilePOS.OB_CINCode__c");
		var abiCodeValue 			= component.get("v.objectDataMap.BillingProfilePOS.OB_ABICode__c");
		var cabCodeValue 			= component.get("v.objectDataMap.BillingProfilePOS.OB_CABCode__c");
		var bankAccountNumberValue 	= component.get("v.objectDataMap.BillingProfilePOS.OB_Bank_Account_Number__c");
		var ibanComplete 			= countryCodeValue 	+ euroControlCodeValue 	+ cinCodeValue + abiCodeValue 			+ cabCodeValue 		+ bankAccountNumberValue;		
		var ibanToConverte 			= cinCodeValue		+ abiCodeValue			+ cabCodeValue + bankAccountNumberValue	+ countryCodeValue 	+ euroControlCodeValue;
		var ibanLength 				= ibanComplete.length;
		arrayIban.push(ibanToConverte);
		console.log("ibanToConverte: "+ ibanToConverte);
		console.log("Array of iban where do convertation: "+ arrayIban);
		var element;
		for (var i = 0; i < arrayIban.length; i++)
			{
				arrayIban[i] = arrayIban[i].replace(/A/g,"10");
				arrayIban[i] = arrayIban[i].replace(/B/g,"11");
				arrayIban[i] = arrayIban[i].replace(/C/g,"12");
				arrayIban[i] = arrayIban[i].replace(/D/g,"13");
				arrayIban[i] = arrayIban[i].replace(/E/g,"14");
				arrayIban[i] = arrayIban[i].replace(/F/g,"15");
				arrayIban[i] = arrayIban[i].replace(/G/g,"16");
				arrayIban[i] = arrayIban[i].replace(/H/g,"17");
				arrayIban[i] = arrayIban[i].replace(/I/g,"18");
				arrayIban[i] = arrayIban[i].replace(/J/g,"19");
				arrayIban[i] = arrayIban[i].replace(/K/g,"20");
				arrayIban[i] = arrayIban[i].replace(/L/g,"21");
				arrayIban[i] = arrayIban[i].replace(/M/g,"22");
				arrayIban[i] = arrayIban[i].replace(/N/g,"23");
				arrayIban[i] = arrayIban[i].replace(/O/g,"24");
				arrayIban[i] = arrayIban[i].replace(/P/g,"25");
				arrayIban[i] = arrayIban[i].replace(/Q/g,"26");
				arrayIban[i] = arrayIban[i].replace(/R/g,"27");
				arrayIban[i] = arrayIban[i].replace(/S/g,"28");
				arrayIban[i] = arrayIban[i].replace(/T/g,"29");
				arrayIban[i] = arrayIban[i].replace(/U/g,"30");
				arrayIban[i] = arrayIban[i].replace(/V/g,"31");
				arrayIban[i] = arrayIban[i].replace(/W/g,"32");
				arrayIban[i] = arrayIban[i].replace(/X/g,"33");
				arrayIban[i] = arrayIban[i].replace(/Y/g,"34");
				arrayIban[i] = arrayIban[i].replace(/Z/g,"35");

				arrayConverted.push(arrayIban[i]);
				console.log("arrayConverted: "+ arrayConverted);
			}
			var ibanToValidate='';
			for (var i = 0; i < arrayConverted.length; i++)
			{
				ibanToValidate += arrayConverted[i];
			}
			
			var reminder 			= this.longIntegerReminder(ibanToValidate,'97');
			var errorInvalidIban 	= document.getElementById("errorIbanNotValid");
			var ibanError 			= document.getElementById("iban");
			var eccError 			= document.getElementById("euroControlCode");
			var cinError 			= document.getElementById("cin");
			var abiError 			= document.getElementById("abi");
			var cabError 			= document.getElementById("cab");
			var banError 			= document.getElementById("bankAccountNumber");
			if(reminder == "1")
			{
				//remove eventual errors
				errorInvalidIban.setAttribute('class','slds-hide');
				eccError.classList.remove("slds-has-error");
				cinError.classList.remove("slds-has-error");
				abiError.classList.remove("slds-has-error");
				cabError.classList.remove("slds-has-error");
				banError.classList.remove("slds-has-error");
				ibanError.classList.remove("iban-has-error");
			}
			else
			{
				//show error
				if(document.getElementById(errorId))
				{
					console.log("errorID . " + errorId);
					document.getElementById(errorId).remove();
				}
				$A.util.addClass(eccError, 'slds-has-error');
				$A.util.addClass(cinError, 'slds-has-error');
				var disabledAbi = component.get('v.disabledAbi');
				if(disabledAbi == false)
				{
					$A.util.addClass(abiError, 'slds-has-error');
				}
				$A.util.addClass(cabError, 'slds-has-error');
				$A.util.addClass(banError, 'slds-has-error');
				$A.util.addClass(ibanError, 'iban-has-error');
				errorInvalidIban.setAttribute('class','slds-show errorIbanInvalid');
			}
	

		component.set("v.objectDataMap.BillingProfilePOS.OB_IBAN__c", ibanComplete);

		console.log("IBAN IN OBJECT DATA MAP: "+JSON.stringify(component.get("v.objectDataMap.BillingProfilePOS.OB_IBAN__c")));
	}

})