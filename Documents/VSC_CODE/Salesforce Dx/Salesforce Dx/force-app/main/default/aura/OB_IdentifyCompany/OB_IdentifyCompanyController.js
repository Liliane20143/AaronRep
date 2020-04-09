({
	doInit : function(component, event, helper)
	{
        var objectDataMap = component.get("v.objectDataMap");
        // ANDREA.MORITTU START 2019.05.02 --> Id_Stream_6_Subentro
        if(!$A.util.isUndefined(objectDataMap.offerAsset)) {
            helper.checkMerchantOnTakeoverProcess(component, event, helper, objectDataMap);
        }
        // ANDREA.MORITTU END 2019.05.02 --> Id_Stream_6_Subentro

        if(!objectDataMap.correctABI)
        {
            console.log('in setting order');
            component.set('v.objectDataMap.order' , {});
            component.set('v.objectDataMap.order2' , {});
            component.set('v.objectDataMap.order.OB_MCC__c' , '');
            component.set('v.objectDataMap.order2.OB_MCC__c' , '');
            component.set('v.objectDataMap.isL3Required' , false);
        }
        
		console.log('object data map doinit: ' + JSON.stringify(objectDataMap) );
		
		console.log('isCommunityUser ' + component.get('v.isCommunityUser') );
		//GET CURRENT DATE**START
		var today = new Date();
		var dd = today.getDate();
		var mm = today.getMonth()+1; //January is 0!
		var yyyy = today.getFullYear();
		if(dd<10) {
			dd = '0'+dd
		} 
		if(mm<10) {
			mm = '0'+mm
		} 
		today = yyyy + '-' + mm + '-' + dd;
		component.set("v.objectDataMap.OrderHeader.OB_OrderDate__c "  , today);
		console.log('today is: ' + objectDataMap.OrderHeader.OB_OrderDate__c );
		//GET CURRENT DATE**END

		//***SET VALUE OF MODAL NEW RESEARCJ***//
		component.set("v.Si",$A.get("$Label.c.OB_Yes"));
		component.set("v.No",$A.get("$Label.NE.NoSplit"));
		component.set("v.Close",$A.get("$Label.NE.close"));

		//**SET CHECK BX VAT NOT RPESENT IN PREVIOUS SCENARIO
		console.log("vat not present in previous: " + objectDataMap.merchant.OB_VAT_Not_Present__c);
		if(objectDataMap.merchant.OB_VAT_Not_Present__c==true)
		{
			   component.find('vatInput').set("v.checked" , true);
		}
		
		console.log(  'OB_IdentifyCompany doInit START');
		/* START micol.ferrari 23/08/2018 - PARAM TO PASS TO POSTEL COMPONENT (--> ADDRESSMAPPING) */
		var postelcomponentparams = {};
		postelcomponentparams.sectionaddress         = 'generaladdress'; 
		postelcomponentparams.provincedisabled       = 'false';
		postelcomponentparams.provinceinputobject    = 'pv';
		postelcomponentparams.provinceinputfield     = 'NE__Province__c'; 
		postelcomponentparams.citydisabled           = 'true';
		postelcomponentparams.cityinputobject        = 'pv';
		postelcomponentparams.cityinputfield         = 'NE__City__c';
		postelcomponentparams.districtdisabled       = 'true';
		postelcomponentparams.districtinputobject    = 'pv';
		postelcomponentparams.districtinputfield     = 'OB_District__c';
		postelcomponentparams.streetdisabled         = 'true';
		postelcomponentparams.streetinputobject      = 'pv';
		postelcomponentparams.streetinputfield       = 'NE__Street__c';
		postelcomponentparams.streetnumberdisabled   = 'false'; //gianluigi.virga 10/09/2019 - UX-55
		postelcomponentparams.streetnumberinputobject= 'pv';
		postelcomponentparams.streetnumberinputfield = 'OB_Street_Number__c';
		postelcomponentparams.zipcodedisabled        = 'false';
		postelcomponentparams.zipcodeinputobject     = 'pv';
		postelcomponentparams.zipcodeinputfield      = 'NE__Postal_Code__c';
		postelcomponentparams.countrydisabled        = 'false';
		postelcomponentparams.countryinputobject     = 'pv';
		postelcomponentparams.countryinputfield      = 'NE__Country__c';
		postelcomponentparams.countrycodeinputobject = 'pv';
		postelcomponentparams.countrycodeinputfield  = 'NE__Country_Code__c';
		postelcomponentparams.withCountry            = 'true';
		postelcomponentparams.provincecodeinputobject= 'pv';
		postelcomponentparams.provincecodeinputfield = 'OB_Province_Code__c';
		postelcomponentparams.isComplete             = 'true';
		postelcomponentparams.withDetail             = 'true';
		postelcomponentparams.pressoinputfield       = 'OB_Address_Detail__c';
		postelcomponentparams.pressoinputobject      = 'pv'; 

		postelcomponentparams.isPV                    = 'true';
		component.set("v.postelcomponentparams",postelcomponentparams);
		console.log('postelcomponentparams identify company');
		console.log(JSON.stringify(postelcomponentparams));
		/* END micol.ferrari 23/08/2018 - PARAM TO PASS TO POSTEL COMPONENT */
		if(component.get("v.objectDataMap.setShowSP")==true){
			component.set("v.showOtherInput" , true);
		}

		/*
            MANAGE THE READ ONLY FIELDS IN PREVIOUS SCENARIO
            DEPENDING BY THE NEW MERCHANT, OLD MERCHANT , 
            NEW SERVICE POINT, OLD SERVICE POINT
        */
        if(objectDataMap.isNewMerchant == true)
        {
        	component.set('v.booleanForNewMerchant' , true);
        }
        if(objectDataMap.isNewMerchant == false)
        {
        	var componentParm = component.get("v.postelcomponentparams");
        	// hideFiscalCode
        	// hideVat
	        if(objectDataMap.isOldMerchantNewSp == true)
	        {

	        }
	        if(objectDataMap.isOldMerchantOldSp == true)
	        {
	        	componentParm.provincedisabled       = 'true';
				componentParm.countrydisabled        = 'true';
		    	componentParm.citydisabled           = 'true';
		    	componentParm.districtdisabled       = 'true';
		    	componentParm.streetdisabled         = 'true';
		    	componentParm.streetnumberdisabled   = 'true';
		    	componentParm.zipcodedisabled        = 'true';
		    	componentParm.pressodisabled         = 'true';
		    	objectDataMap.disableButtonMcc       =  true;
		    	component.set("v.postelcomponentparams",postelcomponentparams);
	        }
	    }

		component.set("v.searchMerchantButton" , true);//disable the search merchant button
		
		var appEvent = $A.get("e.c:OB_EventNextButton");
		var stepName = component.find("stepId").get("v.value");
		appEvent.setParams({"idStep" : stepName  });
		appEvent.fire();
		//**********METHOD TO RETRIEVE THE USER AND BANK ID**********//
		var actionGetBankId = component.get("c.getBankIdByUser");
		component.set("v.nameVat" , $A.get("$Label.NE.VAT"));
		var bankId = component.get("v.bankId");
		actionGetBankId.setCallback(this, function(response) 
		{
			var state = response.getState();
			console.log("the state is: " + state);
			if (state === "SUCCESS")
			{
				var bankIdMap = response.getReturnValue();
				console.log("the map of bankId is: " + JSON.stringify(bankIdMap));
				component.set("v.bankId", component.get("v.objectDataMap.bankOwner"));	//davide.franzini - 29/07/2019 - WN-212
				console.log("il bank Id is: " + component.get("v.bankId"));
				bankId = component.get("v.bankId");
				if(bankId == null)
				{
					//BACK OFFICE
					component.set("v.isCommunityUser", component.get("v.objectDataMap.isCommunityUser")); //davide.franzini - 29/07/2019 - WN-212
					console.log("isCommunityUser? " + component.get("v.isCommunityUser"));
				}
				else
				{
					//davide.franzini - 29/07/2019 - WN-212 - START

					//COMMUNITY
					component.set("v.isCommunityUser", true);
					component.set("v.isCommunityUser", component.get("v.objectDataMap.isCommunityUser")); //davide.franzini - 29/07/2019 - WN-212
					component.set("v.showFiscalCodeSection", true);
					console.log("isCommunityUser? " + component.get("v.isCommunityUser"));
					//davide.franzini - 29/07/2019 - WN-212 - END
					//START gianluigi.virga 12/07/2019 - BACKLOG-153
					component.set("v.objectDataMap.bankProfile.OB_Show_check_in_date__c", response.getReturnValue()['OB_Show_check_in_date__c']);
					//END gianluigi.virga
					//ANDREA MORITTU START 11/02/2019
					if(component.get("v.objectDataMap.bankProfile.OB_NDG__c"))
					{
						if(typeof(component.find("NDGOrderHeader")) != undefined && component.find("NDGOrderHeader") != null && component.find("NDGOrderHeader") != "")
						{
							component.set("v.objectDataMap.OrderHeader.OB_NDG__c", component.find("NDGOrderHeader").get("v.value"));
						}
						else
						{
							component.set("v.objectDataMap.OrderHeader.OB_NDG__c", null );
						}
					}
					else
					{
						component.set("v.objectDataMap.OrderHeader.OB_NDG__c", null );
					}
					//ANDREA MORITTU END 11/02/2019
				}
				//SET THE RESPONSE TRUE OR FALSE IN AN OBJECTDATAMAP VALUE TO PASS TO OTHER COMPONENT
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
						console.log("Error message: " +errors[0].message);
					}
				}
				else
				{
					console.log("Unknown error");
				}
			}
		});
		$A.enqueueAction(actionGetBankId);

			//**********METHOD TO RETRIEVE THE EMPLOYEES NUMBER VALUE**********//
			helper.getEmployeesNumber(component , helper , event );
			component.set("v.valuePreviousEmplNumb" , (objectDataMap.merchant.OB_Employees_Number__c).replace(/_/g, ' '));

		console.log("ANNUAL REVENUE:" + component.get("v.annualRevenueList.value" )+'  '+ 'ANNUAL NEGOTIATED: ' + component.get('v.annualNegotiatedList.value') );

		//***CALL LEGAL FORM VALUE**//
		var actionGetLegalForm = component.get("c.getLegalFromValue");
		actionGetLegalForm.setCallback(this, function(response) 
									{
										var state = response.getState();
										console.log("the state is: " + state);
										
										if (state === "SUCCESS")
										{
											var legalFormMap = response.getReturnValue();
											component.set('v.legalFormMap' , legalFormMap);
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
		$A.enqueueAction(actionGetLegalForm);
		//***CALL LEGAL FORM VALUE**//
		var actionGetCountryValue = component.get("c.getCountryValue");
		actionGetCountryValue.setCallback(this, function(response) 
									{
										var state = response.getState();
										console.log("the state is: " + state);
										
									if (state === "SUCCESS")
									{
											var countryMap = response.getReturnValue();
											component.set('v.countryMap' , countryMap);
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
		$A.enqueueAction(actionGetCountryValue);
		component.set('v.isLoading', true);
		/**
		 * giovanni spinelli 27/09/2019 - start
		 * method only when the flow is fired from maintenance 
		 * in this case the url contains '.....?filter=FC_....._SP_....'
		 */
		var url = window.location.href;
		var urlSplit = url.split('filter=')[1];
		/**
		 * giovanni spinelli 02/10/2019 - start
		 * if url contains filter but only cab
		 * then set cab in user and set two attribute to fire an handler
		 * to get bank profile
		 */
		
		if(urlSplit && urlSplit.includes('ONLYCAB_')){
			component.set('v.objectDataMap.user.OB_CAB__c' , urlSplit.split('ONLYCAB_')[1]);
			component.set("v.correctCAB", true);
			component.set("v.correctABI", true);
		}
		//giovanni spinelli 02/10/2019 - end
		//if url contains filter but not sp id
		else if ( urlSplit && !urlSplit.includes('SP_') ) 
		{
			
			//manage if before user searched with FC or VAT and store correct value in objectdatamap
			if (urlSplit.includes('FC_')) {
				if(urlSplit.includes('_CAB_')){
					component.set('v.objectDataMap.merchant.NE__Fiscal_code__c', urlSplit.split('FC_')[1].split('_CAB_')[0]);
					component.set('v.objectDataMap.user.OB_CAB__c' , urlSplit.split('_CAB_')[1]);
					component.set("v.correctCAB", true);
					component.set("v.correctABI", true);
					
				}else{
					component.set('v.objectDataMap.merchant.NE__Fiscal_code__c', urlSplit.split('FC_')[1]);
				}
				
				component.set('v.hideVat', true);
			} else if (urlSplit.includes('VAT')) {
				if(urlSplit.includes('_CAB_')){
					component.set( 'v.objectDataMap.merchant.NE__VAT__c', urlSplit.split('VAT_')[1].split('_CAB_')[0] );
					component.set('v.objectDataMap.user.OB_CAB__c' , urlSplit.split('_CAB_')[1]);
					component.set("v.correctCAB", true);
					component.set("v.correctABI", true);
				}else{
					component.set('v.objectDataMap.merchant.NE__VAT__c', urlSplit.split('VAT_')[1]);
				}
				
				component.set('v.hideFiscalCode', true);
			}
			component.set('v.searchMerchantButton', false);
			component.set('v.isFromMaintenance' , true);
			
		}
		//if url contains filter and sp id
		else if( urlSplit && urlSplit.includes('SP_') )
		{
			
			component.set('v.isFromMaintenance' , true);
			//manage if before user searched with FC or VAT and store correct value in objectdatamap
			if (urlSplit.includes('FC_')) {
				component.set( 'v.objectDataMap.merchant.NE__Fiscal_code__c', urlSplit.split('FC_')[1].split('_SP_')[0] );
				component.set('v.hideVat', true);
			} else if (urlSplit.includes('VAT')) {
				component.set( 'v.objectDataMap.merchant.NE__VAT__c' , urlSplit.split('VAT_')[1].split('_SP_')[0] );
				component.set('v.hideFiscalCode', true);
			}
			/**
			 * get id of service point
			 * time0 attribute empty --> enter in if and store id in attribute
			 * fire helper method to autocomplet sp imputs
			 * re set attribut with 'STOP'
			 * time1 attribute not empty but 'STOP' --> not enter in if
			 * in this way the autocomplete sp start only once
			 */
			var automaticId =  component.get( 'v.automaticServicePointId' );
			if( automaticId != 'STOP'){
				var containsCAB = false;
				if(urlSplit.includes('_CAB_')){
					component.set('v.automaticServicePointId' , urlSplit.split('_SP_')[1].split('_CAB_')[0]);
					component.set('v.objectDataMap.user.OB_CAB__c' , urlSplit.split('_CAB_')[1]);
					containsCAB = true;	
				}else{
					component.set('v.automaticServicePointId' , urlSplit.split('_SP_')[1]);
				}
				
				automaticId =  component.get( 'v.automaticServicePointId' );
				helper.retrieveAutomaticSp(component, automaticId , containsCAB);
				component.set('v.automaticServicePointId' , 'STOP');
			}
			component.set('v.searchMerchantButton', false);
			//giovanni spinelli - 27/09/2019 - end
		}
		
	},
	/**
	*@author Giovanni Spinelli <spinelli.giovanni@accenture.com>
	*@date 27/09/2018
	*@description Method to call getMerchant after init only if flow is fired from maintenance
	*@params -
	*@return 
	*/
	onRender: function(component, event, helper){
		
		var url = window.location.href;
		var urlSplit = url.split('filter=')[1];
		
		if (urlSplit && component.get('v.isFromMaintenance') == true ) {
			
			var actionGetMerchant = component.get("c.handleClick");
			$A.enqueueAction(actionGetMerchant);
		}
	},
	//**********METHOT TO HAVE THE UPPERCASE INTO FISCAL CODE INPUT**********//
	//**********METHOD TO UNLOCK THE MERCHANT BUTTON IF VAT AND FC ARE CORRECT********//
	upperCaseMethod: function(component, event , helper)
	{
		var objectDataMap = component.get("v.objectDataMap");
		var fiscalCode=component.get("v.objectDataMap.merchant.NE__Fiscal_code__c");
		var vatId = component.get("v.objectDataMap.merchant.NE__VAT__c");
		//MANAGE FISCAL CODE AND VAT VALUE AFTER THE RESET RESEARCH
		fiscalCode==undefined ? fiscalCode='' : fiscalCode =component.get("v.objectDataMap.merchant.NE__Fiscal_code__c");
		vatId==undefined ? vatId ='' : vatId =component.get("v.objectDataMap.merchant.NE__VAT__c");
		//***DEFECT SIT004***//
		//***DISABLE THE VAT BUTTON WHEN I ENTER THE FIRST VALUE(AND CONTRARY)-START***//
		console.log('set uppercase method: ' + component.get("v.setUppercCaseMethod"));
		console.log('objectDataMap.isPrevious:: ' + objectDataMap.isPrevious);
		if(component.get("v.setUppercCaseMethod")==true && (objectDataMap.isPrevious==false || objectDataMap.isPrevious==undefined ))
		{
			try
			{
				if((component.find("fiscalCode").get("v.value")).length>=1 && (component.find("vat").get("v.value")).length==0)
				{
					console.log('HIDE VAT TRUE');
				   component.set("v.hideVat" , true);
				   component.set('v.isTimeOut' , false);//possibile errore
					/* Doris D.   07/03/2019 ------------- Start*/
					//BUTTON TO COPY THE VAT VALUE IN FISCAL CODE IS ATTIVED
					console.log(" fiscalCode.length>=1 && vat==0 setMerchantFC  false  ");
					component.set("v.setMerchantFC",true);
					/* Doris D.   07/03/2019 ------------- End*/
				}
				else
				{
					console.log('HIDE VAT FALSE');
					component.set("v.hideVat" , false);
				}
				if((component.find("vat").get("v.value")).length>=1 && (component.find("fiscalCode").get("v.value")).length==0)
				{
					console.log('HIDE FISCAL CODE TRUE');
					component.set("v.hideFiscalCode" , true);
					component.set('v.isTimeOut' , false);//possibile errore


				}
				else
				{
					console.log('HIDE FISCAL CODE FALSE');
					component.set("v.hideFiscalCode" , false);
				}
			}
			catch(err)
			{
				console.log('err.message: ' + err.message);
			}
		}
		//***DISABLE THE VAT BUTTON WHEN I ENTER THE FIRST VALUEAND CONTRARY)-END***//
		//USE THIS TRY-CATCH IF IN THE NEXT RESEARCH I USE VAT INSTEAD FISCAL CODE
		try 
			{
				var res = fiscalCode.toUpperCase();
			}
		catch(err) 
			{
				console.log('err.message: ' + err.message);
			}
		
		console.log("fiscal code in check method: "  + res);

		component.set("v.objectDataMap.merchant.NE__Fiscal_code__c", res);
		console.log("INTO CHECK CF FUNCTION");
		var fieldControlFiscalCode = new Map();
	   //MAKE THE SEARCH BUTTON DISABLED IF VAT OR FC ARE NOT VALID 
		if( (fiscalCode!= null && ControllaCF(fiscalCode , fieldControlFiscalCode) != null ) && (vatId!= null && ControllaCF(vatId , fieldControlFiscalCode) != null ))
		{
			//INCORRECT VAT OR FISCAL CODE"
			console.log("INCORRECT VAT OR FISCAL CODE");
			component.set("v.searchMerchantButton" , true);//disable the search merchant button
		}
		else
		{
			//CORRECT VAT OR FISCAL CODE"

			//MAKE ABLE THE SEARCH BUTTON ONLY IF VAT AND FC  AREN'T '00000000000'
			if(fiscalCode!='00000000000' &&  vatId!='00000000000')
			{
				component.set("v.searchMerchantButton" , false);//able the search merchant button
            }
			//IF TRUE I AM IN THE CASE OF NEW MERCHANT SO THIS SET AREN'T NECESSARY
			if(component.get("v.booleanForNewMerchant")!=true)
			{   
				/*SETTING USED DURING THE RESEARCH TO DISABLE VAT AND 
				  FISCAL CODE INPUT ONE BY ONE*/
				
				if(ControllaCF(fiscalCode , fieldControlFiscalCode) == null)
				{   
					//USE THE LENGTH CONTROL IN NEXT RESEARCH
						console.log("CLEAR VAT : " + component.get("v.objectDataMap.merchant.NE__VAT__c"));

						//DELETE THE CUSTOM ERROR MESSAGE OF VALIDATION
						if(component.get("v.ErrorMessageVat"))
						{
							component.set("v.ErrorMessageVat" , '') ;
							$A.util.removeClass(component.find('vat') , 'slds-has-error flow_required');
						}
						//code to delete red border......

						if(document.getElementById('errorIdvat')!=null)
						{
							//TRY TO DELETE THE MESSAGE
							try
							{
								$A.util.removeClass(component.find('vat') , 'slds-has-error flow_required');
								document.getElementById('errorIdvat').remove();
								document.getElementById('errorIdvat').remove();
								console.log("success delete");
							}
							catch(err)
							{
								console.log('err.message: ' + err.message);
							}
						 }
				}
				else
				{
					//USE THE LENGTH CONTROL IN NEXT RESEARCH
					if(vatId.length==11)
					{
						//DISABLE AND CLEAR FISCALCODE INPUT BECAUSE I SEARCH WITH VAT
						console.log("CLEAR FISCAL CODE : " + component.get("v.objectDataMap.merchant.NE__Fiscal_code__c"));
						component.set("v.hideFiscalCode" , true);
						component.set("v.objectDataMap.merchant.NE__Fiscal_code__c" , '');

						//DELETE THE CUSTOM ERROR MESSAGE OF VALIDATION
						if(component.get("v.ErrorMessageFiscalCode"))
						{
							component.set("v.ErrorMessageFiscalCode" , '') ;
							$A.util.removeClass(component.find('fiscalCode') , 'slds-has-error flow_required');
						}

						//code to delete red border......
						 if(document.getElementById('errorIdfiscalCode')!=null)
						{
							//TRY TO DELETE THE MESSAGE
							try
							{
							$A.util.removeClass(component.find('fiscalCode') , 'slds-has-error flow_required');
							document.getElementById('errorIdfiscalCode').remove();
							document.getElementById('errorIdfiscalCode').remove();
							console.log("success delete");
							}
						   catch(err)
							{
							console.log('err.message: ' + err.message);
						 }
						 }
					}
				}
			}
			//WHEN I INSERT E NEW MERCHANT AND WRITE FISCAL CODE AND VAT--->DISABLE THE SEARCH BUTTON
			if(component.get('v.booleanForNewMerchant')==true)
			{
				if( (fiscalCode!= null && ControllaCF(fiscalCode , fieldControlFiscalCode) == null) 
					|| (vatId!= null && ControllaCF(vatId , fieldControlFiscalCode) == null) )
				{
					component.set("v.searchMerchantButton" , true);
				}
			}
		}
	//**************************************GIOVANNI SPINELLI- 27/09/2018******************************************************//
	//******************METHOD TO FIRE THE CONTROL OF VAT WITH A ONCHANGE ONLY IF IT HAS 11 CHARACTERS-START*******************//
	if(vatId.length>=11 && ControllaCF(vatId , fieldControlFiscalCode) !=null)
	{
			console.log("control with vat ==11  ");
			$A.util.addClass(component.find('vat') , 'slds-has-error flow_required');
			component.set("v.ErrorMessageVat",ControllaCF(fiscalCode , fieldControlFiscalCode));
			component.set("v.ErrorBooleanVat",true);
            if(ControllaCF(vatId , fieldControlFiscalCode) == 1)
            {
				component.set("v.ErrorMessageVat" , $A.get("$Label.c.VATLengthError"));
				helper.removeRedBorder(component, event, helper);
				component.set("v.objectDataMap.errorFamily.errorFiscalCode", true);
				component.set( "v.toggleSpinner" , false);
			}
            if(ControllaCF(vatId , fieldControlFiscalCode) == 2)
            {
				component.set("v.ErrorMessageVat" , $A.get("$Label.c.VATCharactersError"));
				helper.removeRedBorder(component, event, helper);
				component.set("v.objectDataMap.errorFamily.errorVat", true);
				component.set( "v.toggleSpinner" , false);
			}
            if(ControllaCF(vatId , fieldControlFiscalCode) == 3)
            {
                if(vatId.length==16)
                {
					component.set("v.ErrorMessageVat" , $A.get("$Label.c.VATLengthError"));
					helper.removeRedBorder(component, event, helper);
					component.set("v.objectDataMap.errorFamily.errorFiscalCode", true);
					component.set( "v.toggleSpinner" , false);
				}
				component.set("v.ErrorMessageVat" , $A.get("$Label.c.VATFormattingError"));
				helper.removeRedBorder(component, event, helper);
				component.set("v.objectDataMap.errorFamily.errorVat", true);
				component.set( "v.toggleSpinner" , false);
			}
			 console.log("the error in vat input is: " + ControllaCF(vatId , fieldControlFiscalCode));
	}
	else
	{
			console.log("LESS THAN 11 CHARTS");
			component.set("v.ErrorMessageVat" , '');
			helper.removeRedBorder(component, event, helper);
			$A.util.removeClass(component.find('vat') , 'slds-has-error flow_required');
			component.set("v.objectDataMap.errorFamily.errorVat", false);
	}
	//******************METHOD TO FIRE THE CONTROL OF VAT WITH A ONCHANGE ONLY IF IT HAS 11 CHARACTERS-END*******************//

	//******************METHOD TO FIRE THE CONTROL OF FISCALCODE WITH A ONCHANGE ONLY IF IT HAS 11 CHARACTERS-START*******************//
	var valueFiscalCode = component.find('fiscalCode').get("v.value");
	/*
		IF THE FISCAL CODE CONTAINS MAX 4 ALPHABETIC CHARACTER
		IT IS VALUATED LIKE A VAT ELSE IT IS A FISCAL CODE
	*/

	var count = (valueFiscalCode.match(/[A-Z]/g)||[]).length;
	console.log("number of CHARACTER in fiscal code: " + count);
	//OLD FUNCTION---> (/^[0-9]+$/).test(valueFiscalCode)
	//IF THERE ARE 1-4 CHARACTERS AND MORE THE 11 NUMBERS IF THE VAT HAS MORE THAN 11 NUMBER
        if((fiscalCode.length>=11 && fiscalCode.length<16  && count>=1 && count<=4 && ControllaCF(fiscalCode , fieldControlFiscalCode) !=null)
         || (fiscalCode.length>=11 && count==0 && fiscalCode.length<16 && ControllaCF(fiscalCode , fieldControlFiscalCode) !=null))
	{
			/* Doris D.   07/03/2019 ------------- Start*/
			//BUTTON TO COPY THE VAT VALUE IN FISCAL CODE IS ATTIVED
			component.set("v.setMerchantFC",false);
			/* Doris D.   07/03/2019 ------------- End*/

			console.log("control formality of vat  ");
			$A.util.addClass(component.find('fiscalCode') , 'slds-has-error flow_required');
			component.set("v.ErrorMessageFiscalCode",ControllaCF(fiscalCode , fieldControlFiscalCode));
			component.set("v.ErrorBooleanFiscalCode",true);
            if(ControllaCF(fiscalCode , fieldControlFiscalCode) == 1)
            {
				component.set("v.ErrorMessageFiscalCode" , $A.get("$Label.c.VATLengthError"));
				helper.removeRedBorder(component, event, helper);
				component.set("v.objectDataMap.errorFamily.errorFiscalCode", true);
				component.set( "v.toggleSpinner" , false);
			}
            if(ControllaCF(fiscalCode , fieldControlFiscalCode) == 2  )
            {
				component.set("v.ErrorMessageFiscalCode" , $A.get("$Label.c.VATCharactersError"));
				helper.removeRedBorder(component, event, helper);
				component.set("v.objectDataMap.errorFamily.errorFiscalCode", true);
				component.set( "v.toggleSpinner" , false);
			}
            if(ControllaCF(fiscalCode , fieldControlFiscalCode) == 3)
            {
				component.set("v.ErrorMessageFiscalCode" , $A.get("$Label.c.VATFormattingError"));
				helper.removeRedBorder(component, event, helper);
				component.set("v.objectDataMap.errorFamily.errorFiscalCode", true);
				component.set( "v.toggleSpinner" , false);
			}
		console.log("the error in vat is: " + ControllaCF(fiscalCode , fieldControlFiscalCode));
	}

	//IF THE FISCAL CODE ISN'T RIGHT
	else if(fiscalCode.length>=16 && ControllaCF(fiscalCode , fieldControlFiscalCode) !=null)
	{
			/* Doris D.   07/03/2019 ------------- Start*/
			//BUTTON TO COPY THE VAT VALUE IN FISCAL CODE IS ATTIVED
			component.set("v.setMerchantFC",true);
			/* Doris D.   07/03/2019 ------------- End*/

			console.log("fiscalCode.length>=16 ");
			$A.util.addClass(component.find('fiscalCode') , 'slds-has-error flow_required');
			component.set("v.ErrorMessageFiscalCode",ControllaCF(fiscalCode , fieldControlFiscalCode));
			component.set("v.ErrorBooleanFiscalCode",true);
            if(ControllaCF(fiscalCode , fieldControlFiscalCode) == 1)
            {
				component.set("v.ErrorMessageFiscalCode" , $A.get("$Label.c.FiscalCodeLengthError"));
				helper.removeRedBorder(component, event, helper);
				component.set("v.objectDataMap.errorFamily.errorFiscalCode", true);
				component.set( "v.toggleSpinner" , false);
			}
            if(ControllaCF(fiscalCode , fieldControlFiscalCode) == 2)
            {
				component.set("v.ErrorMessageFiscalCode" , $A.get("$Label.c.FiscalCodeCharactersError"));
				helper.removeRedBorder(component, event, helper);
				component.set("v.objectDataMap.errorFamily.errorFiscalCode", true);
				component.set( "v.toggleSpinner" , false);
			}
            if(ControllaCF(fiscalCode , fieldControlFiscalCode) == 3)
            {
				component.set("v.ErrorMessageFiscalCode" , $A.get("$Label.c.FiscalCodeFormattingError"));
				helper.removeRedBorder(component, event, helper);
				component.set("v.objectDataMap.errorFamily.errorFiscalCode", true);
				component.set( "v.toggleSpinner" , false);
			}
	}
	else if(fiscalCode=='00000000000')
	{
				$A.util.addClass(component.find('fiscalCode') , 'slds-has-error flow_required');
				component.set("v.ErrorBooleanFiscalCode",true);
				component.set("v.ErrorMessageFiscalCode" , $A.get("$Label.c.VATFormattingError"));
				helper.removeRedBorder(component, event, helper);
				component.set("v.objectDataMap.errorFamily.errorFiscalCode", true);
				component.set( "v.toggleSpinner" , false);
	}
	else if(vatId=='00000000000')
	{
				$A.util.addClass(component.find('vat') , 'slds-has-error flow_required');
				component.set("v.ErrorBooleanVat",true);
				component.set("v.ErrorMessageVat" , $A.get("$Label.c.VATFormattingError"));
				helper.removeRedBorder(component, event, helper);
				component.set("v.objectDataMap.errorFamily.errorVat", true);
				component.set( "v.toggleSpinner" , false);
	}
	else
	{
			console.log("LESS THAN 11 CHARTS");
			component.set("v.ErrorMessageFiscalCode" , '');
			helper.removeRedBorder(component, event, helper);
			$A.util.removeClass(component.find('fiscalCode') , 'slds-has-error flow_required');
			component.set("v.objectDataMap.errorFamily.errorFiscalCode", false);
	}
	//******************METHOD TO FIRE THE CONTROL OF FISCALCODE WITH A ONCHANGE ONLY IF IT HAS 11 CHARACTERS-END*******************//
	},

	//**********METHOT WHEN I SEARCH A FISCAL CODE**********//
	handleClick: function(component, event , helper)
	{    
        /*
        -----------------------------------------------------------
        andrea.morittu START --> ADDING LOGIC ON OLD MERCHANT || ID_STREAM_6_Subentro
        -----------------------------------------------------------
        */
        var fiscalCode = !$A.util.isUndefined(component.find("fiscalCode")) ? component.find("fiscalCode").get("v.value") : null;
        var VAT        = !$A.util.isUndefined(component.find("vat")) ? component.find("vat").get("v.value") : null;
        var oldObjectsInfo = component.get("v.oldWrapperInformation");
        var oldObjectsInfoStringified = JSON.stringify(oldObjectsInfo);
        var objectDataMap = component.get("v.objectDataMap");
        if(!$A.util.isEmpty(objectDataMap.offerAsset.Id )) {
            var action = component.get("c.formalCheckOnOldData");
            action.setParams({  fiscalCode  : fiscalCode,
                                VAT         : VAT,
                                oldObjectsInfoStringified : oldObjectsInfoStringified     
                            });

            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var takeoverProcessError = response.getReturnValue();
                    if(!$A.util.isEmpty(takeoverProcessError)) {
                        if(takeoverProcessError.errorOnMerchantFISCALCODE) {
                            helper.showToast(component, event, helper, $A.get('{!$Label.c.OB_ImpossibleToProceed}') , $A.get('{!$Label.c.OB_OldFiscalCodeErrorLabel}'), "error");
                        } else if(takeoverProcessError.errorOnMerchantVAT) {
                            helper.showToast(component, event, helper, $A.get('{!$Label.c.OB_ImpossibleToProceed}') , $A.get('{!$Label.c.OB_OldVatCodeErrorLabel}'), "error");
                        }
                    } else {
                        helper.executeHandleClick(component, event, helper);
                    }
                    
                } else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                reject(Error("Error message: " + errors[0].message));
                            }
                        }
                } else {
                    console.log('Unknown Error');
                }
            });
            $A.enqueueAction(action);
        } else {
            helper.executeHandleClick(component, event, helper);
        }        
        /*
        -----------------------------------------------------------
        andrea.morittu END --> ADDING LOGIC ON OLD MERCHANT || ID_STREAM_6_Subentro
        -----------------------------------------------------------
        */
		/*
			ANDREA MORITTU - REMOVED ADDITIONAL CODE ON IDENTIFY CCOMPANY CONTROLLER.
			IT'S USED IN THE IDENTIFYCOMPANY.Helper
		*/
	},
	  
//*************************************************METHODS TO MANAGE FORMAL AND MANDATORY CONTROL - START******************************************************//
	//**********METHOT TO REMOVE THE RED BORDER**********//
	removeRedBorder: function(component, event, helper)
	{
		helper.removeRedBorder(component, event, helper);
		//************************************METHOD FOR FORMAL CONTROL OF NAME MERCHANT-START**********************************//
		//THE FOLLOWING METHOD STARTS ONLY WHEN I HAVE ON DISPLAY THE NAME FIELD//
		if(component.find('name'))
		{
			var name = component.find('name').get("v.value");
			//CREATE A DIV WITH A CUSTOM ERROR MESSAGE
			var myDiv;
			myDiv = document.createElement('div');
			var errorMessage = document.createTextNode($A.get("$Label.c.errorSpecialCharacter")); 
			console.log("error message: " + JSON.stringify(errorMessage));
			myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
			myDiv.setAttribute('id','customErrorIdName');
			myDiv.appendChild(errorMessage);
			var idTest;
			//IF THERE IS THE INPUT
		   if(component.find('name'))
		   {
			   idTest  = component.find('name').getElement();
		   }
			//WRONG CHARACTER
			if(specialCharacter(name)=='ERROR' && name.length>0  )
			{
				$A.util.addClass(component.find('name') , 'slds-has-error flow_required');
				//ADD THE ERROR MESSAGE
				if(!document.getElementById('customErrorIdName'))
				{
					 idTest.after(myDiv);
				}
				//BOOLEANT TO REST IN PAGE
				component.set("v.objectDataMap.errorFamily.errorNameMerchant", true);
			}
			//RIGHT CHARACTER
			else if(specialCharacter(name)==null || name.length==0)
			{
				// $A.util.removeClass(component.find('name') , 'slds-has-error flow_required');
				 if(document.getElementById('customErrorIdName'))
				 {
					document.getElementById('customErrorIdName').remove();
				 }
				component.set("v.objectDataMap.errorFamily.errorNameMerchant", false);
			}
		}
		//************************************METHOD FOR FORMAL CONTROL OF NAME MERCHANT-END**********************************//
	},

	//**********METHOT TO REMOVE THE RED BORDER FROM FISCAL CODE**********//
	redBorderFiscalCode: function(component, event, helper)
	{
		console.log("1) INTO REMOVE BORDER FROM FISCAL CODE");
		var fiscalCode=component.get("v.objectDataMap.merchant.NE__Fiscal_code__c");
		console.log("2) FISCAL CODE FROM REMOVE BORDER " + fiscalCode);
		var fieldControlFiscalCode = new Map();
		var valueFiscalCode = component.find('fiscalCode').get("v.value");
		var count = (valueFiscalCode.match(/[A-Z]/g)||[]).length;
		if( ((fiscalCode!= null && ControllaCF(fiscalCode , fieldControlFiscalCode) != null) && fiscalCode.length!=11)
		|| (count>=5 && fiscalCode.length==11))
		{
			$A.util.addClass(component.find('fiscalCode') , 'slds-has-error flow_required');
			
			component.set("v.ErrorMessageFiscalCode",ControllaCF(fiscalCode , fieldControlFiscalCode));
			component.set("v.ErrorBooleanFiscalCode",true);
			console.log('Risult of function Javascript :' +  ControllaCF(fiscalCode , fieldControlFiscalCode));
			
			if(ControllaCF(fiscalCode , fieldControlFiscalCode ) == 1)
			{
				component.set("v.ErrorMessageFiscalCode" , $A.get("$Label.c.FiscalCodeLengthError"))  ;
				helper.removeRedBorder(component, event, helper);
				$A.util.addClass(component.find('fiscalCode') , 'slds-has-error flow_required');
				component.set("v.objectDataMap.errorFamily.errorFiscalCode", true);
				component.set( "v.toggleSpinner" , false);
			}
			
			if(ControllaCF(fiscalCode , fieldControlFiscalCode) == 2)
			{
				component.set("v.ErrorMessageFiscalCode" , $A.get("$Label.c.FiscalCodeCharactersError"));
				helper.removeRedBorder(component, event, helper);
				component.set("v.objectDataMap.errorFamily.errorFiscalCode", true);
				component.set( "v.toggleSpinner" , false);
			}
			
			if(ControllaCF(fiscalCode , fieldControlFiscalCode) == 3)
			{
				component.set("v.ErrorMessageFiscalCode" , $A.get("$Label.c.FiscalCodeFormattingError"));
				helper.removeRedBorder(component, event, helper);
				component.set("v.objectDataMap.errorFamily.errorFiscalCode", true);
				component.set( "v.toggleSpinner" , false);
			}

			//REMOVE ERROR MESSAGE AND RED BORDER WHEN FISCAL CODE LENGHTH IS 0
			if(fiscalCode.length == 0)
			{
			component.set("v.ErrorMessageFiscalCode" , '');
			helper.removeRedBorder(component, event, helper);
			component.set("v.objectDataMap.errorFamily.errorFiscalCode", false);
			$A.util.removeClass(component.find('fiscalCode') , 'slds-has-error flow_required');
			}
		}
		//BLOCK THE VALUE 00000000000
		else if(fiscalCode=='00000000000')
		{
					$A.util.addClass(component.find('fiscalCode') , 'slds-has-error flow_required');
					component.set("v.ErrorBooleanFiscalCode",true);
					component.set("v.ErrorMessageFiscalCode" , $A.get("$Label.c.VATFormattingError"));
					helper.removeRedBorder(component, event, helper);
					component.set("v.objectDataMap.errorFamily.errorIdfiscalCode", true);
					component.set( "v.toggleSpinner" , false);
		}
		//SET A SAME ERROR MESSAGE OF ONCHANGE EVENT CONSIDERING 11 CHART AS A VAT
		else if(fiscalCode.length == 11 &&
			     (count>=1 && count<=4 && ControllaCF(fiscalCode , fieldControlFiscalCode) !=null)
			     || (fiscalCode.length>=11 && count==0 && fiscalCode.length<16 && ControllaCF(fiscalCode , fieldControlFiscalCode) !=null))
		{
			$A.util.addClass(component.find('fiscalCode') , 'slds-has-error flow_required');
			
			component.set("v.ErrorMessageFiscalCode",ControllaCF(fiscalCode , fieldControlFiscalCode));
			component.set("v.ErrorBooleanFiscalCode",true);
			if(ControllaCF(fiscalCode , fieldControlFiscalCode ) == 1)
			{
				component.set("v.ErrorMessageFiscalCode" , $A.get("$Label.c.VATLengthError"))  ;
				helper.removeRedBorder(component, event, helper);
				$A.util.addClass(component.find('vat') , 'slds-has-error flow_required');
				component.set("v.objectDataMap.errorFamily.errorFiscalCode", true);
				component.set( "v.toggleSpinner" , false);
			}
			
			if(ControllaCF(fiscalCode , fieldControlFiscalCode) == 2)
			{
				component.set("v.ErrorMessageFiscalCode" , $A.get("$Label.c.VATCharactersError"));
				helper.removeRedBorder(component, event, helper);
				component.set("v.objectDataMap.errorFamily.errorFiscalCode", true);
				component.set( "v.toggleSpinner" , false);
			}
			
			if(ControllaCF(fiscalCode , fieldControlFiscalCode) == 3)
			{
				component.set("v.ErrorMessageFiscalCode" , $A.get("$Label.c.VATFormattingError"));
				helper.removeRedBorder(component, event, helper);
				component.set("v.objectDataMap.errorFamily.errorFiscalCode", true);
				component.set( "v.toggleSpinner" , false);
			}
		}
		//REMOVE ERROR MESSAGE AFTER AN INSERT OF CORRECT VAT/FISCAL CODE
		else if(ControllaCF(fiscalCode , fieldControlFiscalCode) == null)
		{
			console.log("CORRECT FISCAL CODE");
			component.set("v.ErrorMessageFiscalCode" , '');
			helper.removeRedBorder(component, event, helper);
		}
	},

	//**********METHOT TO REMOVE THE RED BORDER FROM VAT**********//
	redBorderVat: function(component, event, helper)
	{
		var vatId = component.get("v.objectDataMap.merchant.NE__VAT__c");
		var fieldControlFiscalCode = new Map();
		if( (vatId!= null && vatId!='' && ControllaCF(vatId , fieldControlFiscalCode) != null) )
		{
			$A.util.addClass(component.find('vat') , 'slds-has-error flow_required');
			
			component.set("v.ErrorMessageVat",ControllaCF(fiscalCode , fieldControlFiscalCode));
			component.set("v.ErrorBooleanVat",true);
			if(ControllaCF(vatId , fieldControlFiscalCode ) == 1)
			{
				component.set("v.ErrorMessageVat" , $A.get("$Label.c.VATLengthError"))  ;
				helper.removeRedBorder(component, event, helper);
				$A.util.addClass(component.find('vat') , 'slds-has-error flow_required');
				component.set("v.objectDataMap.errorFamily.errorVat", true);
				component.set( "v.toggleSpinner" , false);
			}
			
			if(ControllaCF(vatId , fieldControlFiscalCode) == 2)
			{
				component.set("v.ErrorMessageVat" , $A.get("$Label.c.VATCharactersError"));
				helper.removeRedBorder(component, event, helper);
				component.set("v.objectDataMap.errorFamily.errorVat", true);
				component.set( "v.toggleSpinner" , false);
			}
			
			if(ControllaCF(vatId , fieldControlFiscalCode) == 3)
			{
				component.set("v.ErrorMessageVat" , $A.get("$Label.c.VATFormattingError"));
				helper.removeRedBorder(component, event, helper);
				component.set("v.objectDataMap.errorFamily.errorVat", true);
				component.set( "v.toggleSpinner" , false);
			}
		}
		else if(vatId=='00000000000')
		{
					$A.util.addClass(component.find('vat') , 'slds-has-error flow_required');
					component.set("v.ErrorBooleanVat",true);
					component.set("v.ErrorMessageVat" , $A.get("$Label.c.VATFormattingError"));
					helper.removeRedBorder(component, event, helper);
					component.set("v.objectDataMap.errorFamily.errorVat", true);
					component.set( "v.toggleSpinner" , false);
		}
		//REMOVE ERROR MESSAGE AFTER AN INSERT OF CORRECT VAT/FISCAL CODE
		////ANDREA MORITTU START 23-Jul-19 WN-178 - Fix length of fiscal code
		else if(vatId!= null && vatId!='' && vatId.length == 11 && !isNaN(vatId) )
            //ControllaCF(vatId , fieldControlFiscalCode) == null
		{
            	component.set("v.ErrorMessageVat" , '');
				helper.removeRedBorder(component, event, helper);
                component.set('v.ErrorMessageVat', '');
                component.find('btnSearch').set('v.disabled', false);
        } else if(vatId == null || vatId == '' || vatId.length != 12 || isNaN(vatId)) {
            	component.set('v.ErrorBooleanVat', true);
                var errorVatLabel = $A.get("$Label.c.OB_VAT_Error_Label")
                $A.util.addClass(component.find('vat'), 'slds-has-error flow_required');
                component.set('v.ErrorMessageVat', errorVatLabel);
                component.find('btnSearch').set('v.disabled', true);
        }
        //ANDREA MORITTU END 23-Jul-19 WN-178 - Fix length of fiscal code
		//REMOVE ERROR MESSAGE AND RED BORDER WHEN VAT LENGTH IS 0
		else if(vatId.length == 0)
		{
			component.set("v.ErrorMessageVat" , '');
			helper.removeRedBorder(component, event, helper);
			$A.util.removeClass(component.find('vat') , 'slds-has-error flow_required');
			component.set("v.objectDataMap.errorFamily.errorVat", false);
		}
	},

	//REMOVE ERROR MESSAGE AND RED BORDER FROM DESCRIPTION VAT NOT PRESENT AFTER MAKING A CHOICE 
	removeErrorMeassagefromVatNotPresent: function(component, event, helper)
	{
		var objectDataMap = component.get("v.objectDataMap");
		console.log('bankprofile in remove error: ' + JSON.stringify(objectDataMap.bankProfile));
		//IF THE INPUT IS COMPLETED 
		if( objectDataMap.merchant.OB_DescriptionVATNotPresent__c != '')
		{
			console.log('objectDataMap.merchant.OB_DescriptionVATNotPresent__c ' + objectDataMap.merchant.OB_DescriptionVATNotPresent__c);
			//REMOVE RED BORDER
			$A.util.removeClass(document.getElementById('typeOfCompany') , 'slds-has-error flow_required');

			//IF THERE IS THE ERROR MESSAGE
			if(document.getElementById('errorIdtypeOfCompany'))
			{
				var errorMessage = document.getElementsByClassName('messageErrortypeOfCompany').length;
				console.log("lunghezza: " + errorMessage);
				//TRY TO DELETE THE MESSAGE
				try 
				{
					for(var i=0 ; i<errorMessage ; i++)
						{
							document.getElementById('errorIdtypeOfCompany').remove();
						}
				console.log("success delete");
				}
			   catch(err)
				{
				console.log('err.message: ' + err.message);
			 }
			 }
		}
	},

//*************************************************METHODS TO MANAGE FORMAL AND MANDATORY CONTROL - END******************************************************//
	//**********METHOT OF VAT CHECKBOX **********//
	vatCheck: function(component, event, helper)
	{
		var objectDataMap = component.get("v.objectDataMap");
		var mapFromNext = {};
		 mapFromNext = component.get("v.objectDataMap.checkMapValues");
		var vatInput= document.getElementById("vatInput");
		console.log("the vat Input is: " + vatInput.checked);
		var hideVat = component.find("vat2");
		var hideVatLabel= component.find("vatLabel"); 
		
		//IF I CHECK THE CHECKBOX//
		if(vatInput.checked)
		{
			/*
			DELETE THE VAT ID WHEN SELECT A VAT NOT PRESENT
			OTHERWISE EVERY TIME THAT I CHECK THE CHECKBOX,
			THE METHOD CALCULATES A MANDATORY VAT AND ADD THE 
			RED BORDER AND ERROR MESSAGE
			*/
			if(!$A.util.isUndefinedOrNull(mapFromNext))
			{
			  delete mapFromNext.vat;  
			}
			
			//DELETE THE CUSTOM MESSAGE OF VAT
			component.set("v.ErrorMessageVat" , '');
			//OPEN THE MODAL
			component.set( "v.showModal" , true);
			//DISABLE VAT INPUT
			component.set("v.hideVat"    , true);
			//CANCEL VALUE OF VAT
			component.find("vat").set("v.value" , ''); //clear the vat value if it is written
			objectDataMap.merchant.NE__VAT__c = '';
			objectDataMap.merchant.OB_VAT_Not_Present__c=true;
			$A.util.addClass(hideVat , 'slds-hide');
			$A.util.removeClass(hideVat , 'slds-show');
			$A.util.addClass(hideVatLabel , 'slds-hide');
			objectDataMap.merchant.OB_VAT_Not_Present__c=true;
			console.log("boolean of vat not present: "+ objectDataMap.merchant.OB_VAT_Not_Present__c);
			objectDataMap.unbind.VAT_notPresent = 'true';
		}
		else //IF I DONT CHECK THE CHECKBOX//
		{
			objectDataMap.merchant.OB_VAT_Not_Present__c=false;
			console.log("into the checkbox else");
			component.set( "v.showModal" , false);
			component.set("v.hideVat"    , false)
			$A.util.addClass(hideVat , 'slds-show');
			$A.util.removeClass(hideVat , 'slds-hide');
			$A.util.addClass(hideVatLabel , 'slds-show');
			$A.util.removeClass(hideVatLabel , 'slds-hide');
			objectDataMap.merchant.OB_DescriptionVATNotPresent__c='';
			console.log("THE VAT INTO UNCHECKED IS: " +  objectDataMap.merchant.NE__VAT__c) ;
			component.find("vat").set("v.value" , '');
			objectDataMap.unbind.VAT_notPresent = 'false';
		}
		//SET AN UNBIND TO SEND THE VALUE INTO STEP 'DATI SOCIETA';
		//IF UNBIND TRUE, I HAVE A 'VAT NOT PRESENT' ;
		//IF UNBIND FALSE, I HAVENT A 'VAT NOT PRESENT'-->I HAVE A VAT NUMBER;
		component.set("v.objectDataMap" , objectDataMap);
		console.log("objectDataMap in check vat not present:  "+ JSON.stringify(objectDataMap));
		//*********************************************REMOVE RED BORDER AND MESSAGE OF FISCAL CODE AND VAT-START*********************************************//
		helper.removeBorderFromVatAndFiscalCode(component, event, helper);
		//*********************************************REMOVE RED BORDER AND MESSAGE OF FISCAL CODE AND VAT-END*********************************************//
	},

	//**********METHOD TO RETRIEVE AN ATTRIBUTE FROM A CHILD COMPONENT**********//
	//when I click a button into child component, the error message disappears  //
	handleErrorEvent: function(component, event, helper)
	{
		console.log("INTO THE PARENT EVENT");
		component.set( "v.showPvErrorMessage", false);
	},
	
	//**********METHOD TO SET THE PICKLIST VALUE INTO OBJDATAMAP**********//
	setPickListValue: function(component, event, helper) {
		var objectDataMap = component.get("v.objectDataMap");
		var employeesNumber  = component.find("employeesNumber").get("v.value");
		objectDataMap.merchant.OB_Employees_Number__c  = employeesNumber;

		helper.removeBorderPicklist(component, event, helper);
		/*
		  CALL THE STATIC RESOURCE METHOD TO REMOVE THE MANDATORY FIELD MESSAGE FROM ANNUAL 
		  REVENUE PICKLIST WHEN I TRY TO FIND A SERVICE POINT-->IT NEED THE STATIC RESOURCE 
		  BECAUSE THE MESSAGE IS FIRED BY A CHILD COMPONENT
		*/
		//***REMOVE RED BORDER FROM VAT AND FISCAL CODE WHEN SELECT A PICKLIST***//

		console.log("set annual revenue into objdatamap: "    + objectDataMap.merchant.OB_Annual_Revenue__c);
		console.log("set annual negotiated into objdatamap: " + objectDataMap.merchant.OB_Annual_Negotiated__c);
		console.log("set employees number into objdatamap: "  + objectDataMap.merchant.OB_Employees_Number__c);
	},

	//searching ABI
	openModal : function(component, event, helper)
	{
		console.log("INTO OPEN MODAL");
		component.set("v.searchABI", true);
		component.set("v.spinner", true);  
		helper.setModalAttributes(component, event);
	},

	//searching CAB
	openModal_2: function(component, event, helper)
	{
		console.log("INTO OPEN MODAL CAB");
		component.set("v.searchABI", false);
		component.set("v.spinner", true); 
		helper.setModalAttributesCAB(component, event);
	},
	
	handleShowModalEventIdentifyCompany : function(component, event, helper)
	{
		//davide.franzini - 29/07/2019 - WN-212 - START remove method
	},

	//Francesca: checking ABI or CAB value while user is typing.
	checkInputValue: function(component, event, helper)
	{
		var id = event.target.id;
		var value = '';
		if(id == "ABI")
		{
			value = event.target.value;
			if(value.length == 5)
			{
				helper.checkABI(component, event, value);
			}else
			{
				component.set("v.correctABI", false);
			}
		}else if(id == "CAB")
		{
			value = event.target.value;
			if(value.length == 5)
			{
				helper.checkCAB(component, event, value);
			}else
			{
				component.set("v.correctCAB", false);
			}	
		}
	},

	//Francesca: passing ABI and CAB value to apex method to get bankId
	getBankProfile: function(component, event, helper)
	{
		if(component.get('v.isCommunityUser')==false)
		{
		    helper.searchBankProfile(component); // NEXI-277 Marta Stempien <marta.stempien@accenture.com> 28/08/2019 Call helper.searchBankProfile method
			//davide.franzini - 29/07/2019 - WN-212 - START
			component.set("v.bankId", component.get("v.objectDataMap.bankOwner"));
			component.set("v.searchABI", component.get("v.objectDataMap.user.OB_ABI__c"));
			//davide.franzini - 29/07/2019 - WN-212 - END
        }
	},

	//METHOD TO CLEAR THE VAT IF I SELECT A NO VAT COMPANY
	clearVat: function(component, event, helper)
	{
		if(!$A.util.isEmpty(component.get("v.objectDataMap.merchant.OB_DescriptionVATNotPresent__c")))
		{
			//CLEARING VAT INPUT
			//GIOVANNI SPINELLI 05/10/2018 -- COMMENT THE NEXT LINE TO HAVE THE VALUE IN THE INPUT IN PREVIOUS SCENARIO
			//document.getElementById("vat").value='';
			console.log("obj vat is:" + component.get("v.objectDataMap.merchant.NE__VAT__c")+' and value input is: ' + document.getElementById("vat").value);
		}
	},
	
	//****METHOD TO SET RED BORDER WHEN I HAVE A MANDATORY O FORMAL FIELD CONTROL AT NEXT****//
	setRedBorder: function(component, event, helper)
	{
		var objectDataMap = component.get("v.objectDataMap");
		console.log('compare setredborder: BACKUP '+objectDataMap.setRedBorderBackup+'   NEW '+objectDataMap.setRedBorder);

			if(objectDataMap.setRedBorder==true)
			{
			component.set("v.redBorderChild" , true);
			var mapFromNext = {};
			mapFromNext = objectDataMap.checkMapValues;
			console.log("mandatory field from map: " + JSON.stringify(mapFromNext));
				//*****SET RED BORDER TO SHOP SIGN - 17/11/2018 START******//
                var myDiv;
                myDiv = document.createElement('div');
                myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
                var errorMessage = document.createTextNode( $A.get("$Label.c.MandatoryField"));
                myDiv.appendChild(errorMessage);
                if(objectDataMap.isShopSignBlank==true )
                {
                    myDiv = document.createElement('div');
                    myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
                    var errorMessage = document.createTextNode( $A.get("$Label.c.MandatoryField"));
                    myDiv.appendChild(errorMessage);

                    if((document.getElementById('ShopSignWithModal')) && !(document.getElementById('errorIdShopSignWithModal')))
                    {
                        var idSet = document.getElementById('ShopSignWithModal');
                        var errorId = 'errorId' +'ShopSignWithModal';
                        myDiv.setAttribute('id',errorId);//SET AN ID TO EVERY MESSAGE
                        myDiv.setAttribute('class' , 'messageError'+'ShopSignWithModal');
                        idSet.after(myDiv);
                        console.log('idset in modal: ' + JSON.stringify(idSet));
                        idSet.className="slds-has-error flow_required";
                    }
					else if((document.getElementById('ShopSign')) && !(document.getElementById('errorIdShopSign')))
					{
						var idSet = document.getElementById('ShopSign');
						var errorId = 'errorId' +'ShopSign';
						myDiv.setAttribute('id',errorId);//SET AN ID TO EVERY MESSAGE
						myDiv.setAttribute('class' , 'messageError'+'ShopSign');
						idSet.after(myDiv);
                        console.log('idset in modal: ' + JSON.stringify(idSet));
						idSet.className="slds-has-error flow_required";
					}
				}
                //NEXI-116 Wojciech Szuba <wojciech.szuba@accenture.com>, 01/07/2019, START
                if( objectDataMap.isMCCL2Wrong == true && objectDataMap.isMCCL2Blank == false &&
                    !$A.util.isEmpty( component.get( "v.objectDataMap.order.OB_MCC_Description__c" ) ) &&
                    component.get( "v.objectDataMap.order.OB_MCC_Description__c" ) != 'ALBERGHI' )
                {
                    let myDiv = document.createElement( 'div' );
                    $A.util.addClass( myDiv, 'red-border' );
                    let idSet = document.getElementById( 'mccDescription2' );
                    let errorId = 'errorId' + 'mccDescription2';
                    myDiv.setAttribute( 'id',errorId );
                    myDiv.setAttribute( 'class' , 'messageError'+'mccDescription2' );
                    idSet.after( myDiv );
                    idSet.className="slds-has-error flow_required";
                    let toastEvent = $A.get( "e.force:showToast" );
                    toastEvent.setParams({
                        message: $A.get( "$Label.c.OB_WrongMCCL2NonAlberghi" ),
                        key: 'info_alt',
                        type: 'error',
                        mode: 'sticky'
                    });
                    toastEvent.fire( );
                }
                //NEXI-116 Wojciech Szuba <wojciech.szuba@accenture.com>, 01/07/2019, STOP
                //NEXI-280 Kinga Fornal <kinga.fornal@accenture.com>, 28/08/2019, START
                if( (objectDataMap.isCityWrong == true || objectDataMap.isCityWrong == 'true') &&
                   !$A.util.isEmpty( component.get( "v.objectDataMap.pv.NE__City__c" ) ) &&
                   component.get( "v.objectDataMap.pv.NE__City__c" ) != 'LIVIGNO' )
                {
                    let errorId = 'errorId' + 'comune';
                    let myDiv = document.createElement( 'div' );
                    myDiv.setAttribute( 'id',errorId );
                    myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
                    let errorMessage = document.createTextNode($A.get( "$Label.c.OB_LIVIGNO_CHECK_ERROR" ));
                    myDiv.appendChild(errorMessage);

                    let idSet = document.getElementById( 'comune' );
                    idSet.after( myDiv );
                    idSet.className="slds-has-error flow_required";

                    let toastEvent = $A.get( "e.force:showToast" );
                    toastEvent.setParams({
                        message: $A.get( "$Label.c.OB_LIVIGNO_CHECK_ERROR" ),
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire( );
                }
                 //NEXI-280 Kinga Fornal <kinga.fornal@accenture.com>, 28/08/2019, STOP
            if(document.getElementById('mccDescription2') && objectDataMap.isMCCL2Blank == true && !(document.getElementById('errorIdmccDescription2')))
            {
                    var myDiv1 = document.createElement('div');
                    myDiv1.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
                    var errorMessage1 = document.createTextNode( $A.get("$Label.c.MandatoryField"));
                    myDiv1.appendChild(errorMessage1);
                    var idSet = document.getElementById('mccDescription2');
                    var errorId = 'errorId' +'mccDescription2';
                    myDiv1.setAttribute('id',errorId);
                    myDiv1.setAttribute('class' , 'messageError'+'mccDescription2');
                    idSet.after(myDiv1);
                    idSet.className="slds-has-error flow_required";
                }
            if(document.getElementById('mccDescription3') && objectDataMap.isMCCL3Blank == true  && !(document.getElementById('errorIdmccDescription3')))
            {
                    var myDiv2 = document.createElement('div');
                    myDiv2.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
                    var errorMessage2 = document.createTextNode( $A.get("$Label.c.MandatoryField"));
                    myDiv2.appendChild(errorMessage2);
                    var idSet = document.getElementById('mccDescription3');
                    var errorId = 'errorId' +'mccDescription3';
                    myDiv2.setAttribute('id',errorId);
                    myDiv2.setAttribute('class' , 'messageError'+'mccDescription3');
                    idSet.after(myDiv2);
                    idSet.className="slds-has-error flow_required";
                }
				//*****SET RED BORDER TO SHOP SIGN - 17/11/2018 END******//
				for (var keys in mapFromNext)
				{
					var errorId = 'errorId' +keys;
					console.log("OB_IdentifyCompany key  = " + keys);

					// Doris dongmo, 14/05/2019 - ADDED TOAST TO INSERT PV ADDRESS - START
					try{
						//START gianluigi.virga 19/07/2019 - PRODOB-380 - Added 'doubleCheck' conditions in the if statement
						var doubleCheck = false;
						if((objectDataMap.ShopSign != undefined && objectDataMap.ShopSign != null && objectDataMap.ShopSign != '')
								&& (objectDataMap.order.OB_MCC_Description__c != undefined && objectDataMap.order.OB_MCC_Description__c != null && objectDataMap.order.OB_MCC_Description__c != '')){
							doubleCheck = true;
						}
						if((keys.includes('provincia') || keys.includes('comune') || keys.includes('strada')
							|| keys.includes('civico') || keys.includes('zipcode')) && doubleCheck == true){
						//END gianluigi.virga 19/07/2019 - PRODOB-380
							var toastEvent = $A.get("e.force:showToast");
							toastEvent.setParams({
								title :  $A.get("$Label.c.OB_CustomErrorLabelTech"),// Doris Dongmo, added label - 16/05/2019
								message: $A.get("$Label.c.OB_InsertValidAddress"),
								duration:' 10000',
								key: 'info_alt',
								type: 'error',
								mode: 'pester'
							});
							toastEvent.fire();
						}
					}catch(e){
						console.log ("ERROR :" +e.message);
					}
					// Doris dongmo, 14/05/2019 -  ADDED TOAST TO INSERT PV ADDRESS - END

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

					//CONTROL IF THERE ARE HIDE FIELDS->IN THIS CASE BYPASS THE CONTROL
					if(idSet!=null && idSet!= undefined)
					{
						//ARRAY THAT CONTAINS THE CUSTOM ERROR MESSAGE-->IF ONE OF THIS IS COMPLETED, THE 'MANDATORY FIELD' DOESN'T APPEAR
						var arrayMessage=[component.get("v.ErrorMessageVat") , component.get("v.ErrorMessagePhone") , component.get("v.ErrorMessageVat")];
						for(var i=0 ; i<arrayMessage.length; i++)
						{
							if( arrayMessage[i]=='')
							{
								/*ADD THE 'MANDATORY FIELD' MESSAGE AND THE RED BORDER
								  ONLY IF THERE ISN'T ALREDY ONE AND IF THE FIELD IS EMPTY------
								  !!!IMPORTANT!!!! MAYBE IT DOESN'T ALWAYS WORK*/

								if(!(document.getElementById(errorId)) && !(idSet.value))
								{
									console.log("METHOD TO SHOW ONLY A MESSAGE");
									idSet.after(myDiv);
									idSet.className="slds-has-error flow_required";
								}
								/***************DEFECT SIT013 SOLVED***************/
								//SHOW AN ERROR MESSAGE TO FORCE USER TO DO A RESEARCH----START//
                            if(((component.find("vat")&& component.find("fiscalCode").get("v.value")=='' )&& !component.find('name'))
                            || (( component.find("fiscalCode")&& component.find("vat").get("v.value")==''))&&!component.find('name'))
								{
									if(document.getElementById(errorId))
									{
										document.getElementById(errorId).remove();
									}
								   $A.util.removeClass(component.find('vat') , 'slds-has-error flow_required');
								   $A.util.removeClass(component.find('fiscalCode') , 'slds-has-error flow_required');
								   //OPEN BANNER MESSAGE
								   component.set( "v.hasMessage", true);
								   //SET THE ERROR MESSAGE
								   component.set("v.messagetoshow" , $A.get("$Label.c.MandatoryResearch"));
								   //SET CUSTOM ERROR MESSAGES
								   component.set('v.ErrorMessageFiscalCode','');
								   component.set('v.ErrorMessageVat'       ,'');
								   //ADD A RED BORDER TO SEARCH BUTTON

								   var btnsearch = component.find('btnSearch').getElement();
								   btnsearch.setAttribute('style','background-color: rgb(255, 255, 255)!important;border: 1px solid rgb(221, 219, 218)!important;border-color: rgb(194, 57, 52)!important;  box-shadow: rgb(194, 57, 52) 0 0 0 1px inset!important;background-clip: padding-box!important;');
								}
								//SHOW AN ERROR MESSAGE TO FORCE USER TO DO A RESEARCH----END//

								//SHOW AN ERROR MESSAGE TO FORCE USER TO DO A RESEARCH OF A SERVICE POINT----START//
								console.log("button is true? "+ component.get("v.showButtons") + ' * '+ 'otherinput is false/undefined? ' + component.get("v.showOtherInput") + ' * '+ 'name id is undefined? ' + component.find('namePv'));
								if(component.get("v.showButtons")==true  && (component.get("v.showOtherInput")==false || component.get("v.showOtherInput")==undefined))
								{
									//CONTROL IF I HAVE THE ADDRESS INPUT, THE BAANNER DOESN'T APPEAR
									if(!document.getElementById('frazione') && !document.getElementById('mccDescription'))
									{
										component.set("v.hasMessage" , true);
										component.set("v.messagetoshow" , $A.get("$Label.c.OB_MandatoryServicePoint"));
									}
								}
								//SHOW AN ERROR MESSAGE TO FORCE USER TO DO A RESEARCH OF A SERVICE POINT----END  //
							}
						}
					}
            }
        }
			component.set("v.redBorderChild" , false);

			objectDataMap.setRedBorder = false;
			objectDataMap.setRedBorderBackup = objectDataMap.setRedBorder;
			objectDataMap.checkMapValues = mapFromNext;
			console.log("boolean to child value after: " + component.get("v.redBorderChild" ));
	},

	//****METHOD TO DO A NEW RESEARCH****//
	resetResearch: function(component, event, helper)
	{
		//open a popup to confirm the choice;
		component.set("v.showAlertNewReasearch" , true);
		//if yes delete values from merchant and service point
	},

	//***METHOD FOR YES OR NO CHOICE ABOUT NEW RESEARCH***//
	getSelection : function(component,event,helper)
	{
		var selectedValue = event.target.value;
		
		if(selectedValue == 'Si')
		{
			/**
			 * giovanni spinelli - 30/09/2019 - start
			 * different behaviour if user is partner community or not
			 * if community --> redirect in maintenance
			 * if not community --> start a new research in flow
			 */
			
			var isCommunityUser = component.get('v.objectDataMap.isCommunityUser');
			if (isCommunityUser) 
			{
				var myBaseURL;
				var getBaseURL = component.get("c.getBaseURl");
				getBaseURL.setCallback(this, function (response) {
					var state = response.getState();
					if (state === "SUCCESS") {
						myBaseURL = response.getReturnValue();
						window.open(myBaseURL+'/s/ob-variazione-anagrafica-consistenza', '_self');
					}
					else if (state === "ERROR") {
						var errors = response.getError();
						if (errors) {
							if (errors[0] && errors[0].message) {
								console.log("Error message: " +
									errors[0].message);
							}
						}
						else {
							console.log("Unknown error");
						}
					}
				});
				$A.enqueueAction(getBaseURL);
				
			}else{
			console.log("OBJECTDATAMAP MERCHANT BEFORE RESET: " + JSON.stringify(component.get("v.objectDataMap")));
			console.log("true response");
			component.set("v.setUppercCaseMethod"   , true ); //set the boolean to make able the method into uppercasemethod
			component.set("v.ErrorMessageVat"       , ''   ); //blank the custom errrod of vat
			component.set("v.ErrorMessageFiscalCode", ''   ); //blank the custom errrod of fiscal code
			component.set("v.showMerchantData"      , false);
			component.set("v.showOtherInput"        , false);
			component.set("v.hideFiscalCode"        , false);
			component.set("v.showButtons"           , false);
			component.set("v.hideField"             , false);
			component.set("v.hideField"             , false);
			component.set("v.hideVat"               , false);
			component.set("v.objectDataMap.disabledInput_sp"               , false);//disabled the name sp input
			component.set("v.booleanForNewMerchant" , false);
			component.set("v.hasMessage"            , false); //hide the banner
			component.set("v.redBorderChild"        , false); //set false the boolean that fires the control in child component
			component.set("v.showHidePicklist"      , false); //to show the picklist in previous scenario
			component.set("v.valuePreviousAnnRev"   , '');
			component.set("v.valuePreviousAnnNeg"   , '');
			component.set("v.valuePreviousEmplNumb" , '');
			/* Doris D.   07/03/2019 ------------- Start*/
			//BUTTON TO COPY THE VAT VALUE IN FISCAL CODE IS DISABLED
			component.set("v.setMerchantFC"         ,true);
			/* Doris D.   07/03/2019 ------------- End*/


			console.log("LIST OF ANNUAL REVENUE " + component.get("v.annualRevenueList"));

			//BLANK THE OBJDATA SERVICE POINT FIELDS
			component.set("v.objectDataMap.pv.Id"                      , '');
			component.set("v.objectDataMap.pv.Name"                    , '');
			component.set("v.objectDataMap.pv.OB_MCC_Description__c"   , '');
			component.set("v.objectDataMap.pv.OB_MCC__c"               , '');
			component.set("v.objectDataMap.pv.OB_Typology__c"          , '');
			component.set("v.objectDataMap.pv.NE__City__c"             , '');
			component.set("v.objectDataMap.pv.NE__Province__c"         , '');
			component.set("v.objectDataMap.pv.NE__Street__c"           , '');
			// giovanni spinelli - start - 21/05/2019 - change NE__Postal_Code__c in NE__Zip_Code__c and add OB_Street_Number__c
			component.set("v.objectDataMap.pv.NE__Zip_Code__c"         , '');
			component.set("v.objectDataMap.pv.OB_Street_Number__c"     , '');
			// giovanni spinelli - start - 21/05/2019 - change NE__Postal_Code__c in NE__Zip_Code__c and add OB_Street_Number__c
			component.set("v.objectDataMap.pv.OB_Address_Hamlet__c"    , '');
			component.set("v.objectDataMap.pv.OB_Address_Detail__c"    , '');
			component.set("v.objectDataMap.pv.OB_Annual_Negotiated__c" , '');
			component.set("v.objectDataMap.pv.OB_Annual_Revenue__c"    , '');
			//giovanni.spinelli 28/02/2019 blank status field formula
			component.set("v.objectDataMap.pv.OB_Stato_IT_Service_Point__c"    , '');

			component.set("v.objectDataMap.pv.OB_Opening_Time__c"           , null);
			component.set("v.objectDataMap.pv.OB_Ending_Time__c"           , null);
			component.set("v.objectDataMap.pv.OB_Break_Start_Time__c"           , null);
			component.set("v.objectDataMap.pv.OB_Break_End_Time__c"           , null);
			//giovanni spinelli 27/06/2019 add fields - start
			//Start antonio.vatrano 29/08/2019 r1f3_2 Set default value when do a new search of merchant
			component.set("v.objectDataMap.pv.OB_Opening_Monday_Morning__c"           , true);
			component.set("v.objectDataMap.pv.OB_Opening_Monday_Afternoon__c"         , true);
			component.set("v.objectDataMap.pv.OB_Opening_Tuesday_Morning__c"          , true);
			component.set("v.objectDataMap.pv.OB_Opening_Tuesday_Afternoon__c"        , true);
			component.set("v.objectDataMap.pv.OB_Opening_Wednesday_Morning__c"        , true);
			component.set("v.objectDataMap.pv.OB_Opening_Wednesday_Afternoon__c"      , true);
			component.set("v.objectDataMap.pv.OB_Opening_Thursday_Morning__c"         , true);
			component.set("v.objectDataMap.pv.OB_Opening_Thursday_Afternoon__c"       , true);
			component.set("v.objectDataMap.pv.OB_Opening_Friday_Morning__c"           , true);
			component.set("v.objectDataMap.pv.OB_Opening_Friday_Afternoon__c"         , true);
			component.set("v.objectDataMap.pv.OB_Opening_Saturday_Morning__c"         , true);
			component.set("v.objectDataMap.pv.OB_Opening_Saturday_Afternoon__c"       , true);
			component.set("v.objectDataMap.pv.OB_Opening_Sunday_Morning__c"           , true);
			component.set("v.objectDataMap.pv.OB_Opening_Sunday_Afternoon__c"         , true);
			//End antonio.vatrano 29/08/2019 r1f3_2
			component.set("v.objectDataMap.pv.OB_Start_Seasonal__c"					  , '');
			component.set("v.objectDataMap.pv.OB_End_Seasonal__c"					  , '');
			//giovanni spinelli 27/06/2019 add fields - end
			
			//BLANK THE OBJDATA MERCHANT FIELDS
			component.set("v.objectDataMap.merchant.Id"                             , '');
			component.set("v.objectDataMap.merchant.NE__Fiscal_code__c"             , '');
			component.set("v.objectDataMap.merchant.NE__VAT__c"                     , '');
			component.set("v.objectDataMap.merchant.Name"                           , ''); 
			component.set("v.objectDataMap.merchant.OB_DescriptionVATNotPresent__c" , '');
			component.set("v.objectDataMap.merchant.OB_VAT_Not_Present__c"       , false);
			component.set("v.showModal"                                          , false);
			component.set("v.objectDataMap.merchant.NE__E_mail__c"                  , '');
			component.set("v.objectDataMap.merchant.Phone"                          , '');
			component.set("v.objectDataMap.merchant.OB_Annual_Revenue__c"           , '');
			component.set("v.objectDataMap.merchant.OB_Annual_Negotiated__c"        , '');
			component.set("v.objectDataMap.merchant.OB_Employees_Number__c"         , '');
			component.set("v.objectDataMap.merchant.OB_Legal_Form__c"               , '');

			//	START 	micol.ferrari 31/01/2019 - FIX PRODUCTION FOR NEW RESEARCH
			component.set("v.objectDataMap.merchant.OB_Legal_Form_Code__c"          , '');
			component.set("v.objectDataMap.merchant.OB_Year_constitution_company__c", '');
			component.set("v.objectDataMap.merchant.OB_CCIAA__"         			, '');
			component.set("v.objectDataMap.merchant.OB_CCIAA_Province__c"         	, '');
			component.set("v.objectDataMap.merchant.OB_SAE_Code__c"         		, '');
			component.set("v.objectDataMap.merchant.OB_ATECO__c"         			, '');
			component.set("v.objectDataMap.merchant.OB_Legal_Address_State_Code__c" , ''); 
			component.set("v.objectDataMap.merchant.OB_Legal_Address_Country_Code__c", '');
			var ExternalAccount = [];
   			component.set("v.objectDataMap.ExternalAccount" , ExternalAccount);
			var externalAccountBackup = [];
			component.set("v.objectDataMap.externalAccountBackup", externalAccountBackup);
			// 	END 	micol.ferrari 31/01/2019 - FIX PRODUCTION FOR NEW RESEARCH

			component.set("v.objectDataMap.merchant.OB_Legal_Address_Street__c"        , '');
            component.set("v.objectDataMap.merchant.OB_Legal_Address_Street_Number__c"  , '');
            component.set("v.objectDataMap.merchant.OB_Legal_Address_Detail__c"         , '');
            component.set("v.objectDataMap.merchant.OB_Legal_Address_ZIP__c"            , '');
            component.set("v.objectDataMap.merchant.OB_Legal_Address_City__c"           , '');
            component.set("v.objectDataMap.merchant.OB_Legal_Address_State__c"          , '');
            component.set("v.objectDataMap.merchant.OB_Legal_Address_Country__c"        , '');
         
            component.set("v.objectDataMap.merchant.BillingStreet"                      , '');
            component.set("v.objectDataMap.merchant.BillingPostalCode"                  , '');
            component.set("v.objectDataMap.merchant.BillingCity"                        , '');
            component.set("v.objectDataMap.merchant.BillingState"                       , '');
            component.set("v.objectDataMap.merchant.BillingCountry"                     , ''); 
         
            component.set("v.objectDataMap.merchant.OB_Administrative_Office_Street__c"            , '');
            component.set("v.objectDataMap.merchant.OB_Administrative_Office_Street_number__c"     , '');
            component.set("v.objectDataMap.merchant.OB_Administrative_Office_Address_Details__c"   , '');
            component.set("v.objectDataMap.merchant.OB_Administrative_Office_ZIP__c"               , '');
            component.set("v.objectDataMap.merchant.OB_Administrative_Office_City__c"              , '');
            component.set("v.objectDataMap.merchant.OB_Administrative_Office_State__c"             , '');
			component.set("v.objectDataMap.merchant.OB_Administrative_Office_Country__c"           , '');

            //BLANK THE OBJECT DATA MAP ORDER
            component.set('v.objectDataMap.order' , {} );
            component.set('v.objectDataMap.order2' , {} );
            component.set("v.objectDataMap.order.OB_MCC__c","");
            component.set("v.objectDataMap.order.OB_MCC_Description__c","");
            component.set("v.objectDataMap.order2.OB_MCC__c","");
            component.set("v.objectDataMap.order2.OB_MCC_Description__c","");
            //HIDE LEVEL 3
            component.set('v.objectDataMap.isL3Required' , false );
            component.set('v.showLevel3' , false );
            
            //BLANK SHOP SIGN(MODAL AND NO MODAL)
            component.set('v.objectDataMap.ShopSign' , '');
            //ENABLE FIELD TYPOLOGY
            component.set('v.objectDataMap.hideFieldTypology' , false);
            //MAKE ENABLE THE BUTTON FOR MCC L1
            component.set('v.objectDataMap.disableButtonMcc' , false);
            //MAKE ENABLE VAT NOT PRESENT
            component.set('v.disableDescriptionVat'      , false);

			/* Doris D.   27/02/2019 ------------- Start*/

			component.set("v.objectDataMap.isNewPV"        ,  false);
			component.set("v.objectDataMap.unbind.isNewPV" ,  'false');

			/* Doris D.   27/02/2019 ------------- End*/

			helper.removeBorderFromVatAndFiscalCode(component, event, helper);
			console.log("OBJECTDATAMAP MERCHANT AFTER RESET: " + JSON.stringify(component.get("v.objectDataMap")));
			console.log("OBJECTDATAMAP PV AFTER RESET: "       + JSON.stringify(component.get("v.objectDataMap.pv")));
			console.log("OBJECTDATAMAP FISCAL CODE AFTER RESET: "       + JSON.stringify(component.get("v.objectDataMap.merchant.NE__Fiscal_code__c")));
		}	
		//giovanni spinelli - 30/09/2019 - end	
		}

		component.set("v.showAlertNewReasearch" , false);
	},

	//****METHOD TO CONTROL THE VALIDITY OF PHONE NUMBER****//
	//IF I ENTER A NOT NUMERICAL CHARACTERS, I HAVE AN ERROR MESSAGE
	validate: function(component, evt, helper)
	{
	var phoneValue = component.find("phone").get("v.value");
	//IF THERE ARE NOT NUMERICAL CHARACTERS AND INPUT HAS MIN 5 AND MAX 10 NUMBERS
	if(phoneValue)
	{
		if(onlyNumberPhone(phoneValue)=='ERROR')
		{
			console.log("INTO CHECK NUMBER");
			component.set("v.ErrorBooleanPhone",true);
			$A.util.addClass(component.find('phone') , 'slds-has-error flow_required');
			component.set("v.ErrorMessagePhone" , $A.get("$Label.c.MinFiveMaxTenDigitLength"))  ;
			if( document.getElementById('errorIdphone'))
			{
				document.getElementById('errorIdphone').remove();
			}
			//BLOCK THE STEP TO GO AT STEP 2
			component.set("v.objectDataMap.errorFamily.errorPhone", true);
			//francesca.ribezzi 05/09/19 - WN-366 - setting service point's phone number to empty if there's an error
			component.set("v.objectDataMap.pv.OB_Phone_Number__c" , '');
		}
		else
		{
			//REMOVE ERROR MESSAGE AND RED BORDER WHEN I ENTER A CORRECT PHONE NUMBER
			console.log("INTO CHECK NUMBER 1");
			component.set("v.ErrorBooleanPhone",false);
			helper.removeRedBorder(component, event);
			//UNLOCK THE STEP TO GO AT STEP 2
			component.set("v.objectDataMap.errorFamily.errorPhone" , false);
			//francesca.ribezzi 05/09/19 - WN-366 - setting service point's phone number
			component.set("v.objectDataMap.pv.OB_Phone_Number__c" , phoneValue);
			
		}
	}
	else
	{
		//REMOVE ERROR MESSAGE AND RED BORDER
		console.log("INTO CHECK NUMBER 2");
		component.set("v.ErrorBooleanPhone",false);
		helper.removeRedBorder(component, event);
		//UNLOCK THE STEP TO GO AT STEP 2
		component.set("v.objectDataMap.errorFamily.errorPhone" , false);
	}
    },

//****METHOD TO CONTROL THE VALIDITY OF EMAIL ADDRESS****//
    validateEmail: function(component, evt, helper)
    {
		var email=component.find("eMail").get("v.value");
		//CONTROL THE CORRECT FORMAT OF INPUT AND IF IT HAS AT LEAST ONE CHARACTER
		try
		{
			if(emailControl(email)=='ERROR' && email.length>0)
			{
                //WRONG EMAIL
                $A.util.addClass(component.find('eMail') , 'slds-has-error flow_required');
                component.set("v.ErrorBooleanEmail",true);
                component.set("v.ErrorMessageEmail" , $A.get("$Label.c.EmailNotValid"))  ;
				component.set("v.objectDataMap.errorFamily.errorEmail", true);
				//francesca.ribezzi 05/09/19 - WN-366 - setting service point's email to empty if there's an error
				component.set("v.objectDataMap.pv.OB_Email__c", ''); 
			}
            else
            {
				//CORRECT EMAIL
				$A.util.removeClass(component.find('eMail') , 'slds-has-error flow_required');
				component.set("v.ErrorBooleanEmail",false);
				component.set("v.ErrorMessageEmail" , '')  ;
				component.set("v.objectDataMap.errorFamily.errorEmail", false);
				/*---- Doris D. ------ 25/02/2019-------------------------- Start */
				component.set("v.objectDataMap.sede_legale.Email", component.get("v.objectDataMap.merchant.NE__E_mail__c"));
				/*---- Doris D. ------ 25/02/2019-------------------------- End   */
				//francesca.ribezzi 05/09/19 - WN-366 - setting service point's email  
				component.set("v.objectDataMap.pv.OB_Email__c", component.get("v.objectDataMap.merchant.NE__E_mail__c"));

			}
//REMOVE RED BORDER AND MESSAGE FROM MANDATOY CONTROL
        }catch(err)
        {
	console.log('err.message e mail: ' + err.message);
}
helper.removeRedBorder(component, event, helper);
    },

//****METHOD TO CONTROL TTHE NEGATIVE VALUE OF ANNUAL REVENUE****//
    validateAnnualRevenue: function(component, evt, helper)
    {
	var annualRevenueValue = component.find("annualRevenue").get("v.value");
	console.log('annualRevenueValue: ' + annualRevenueValue);
	var currentId = event.target.id;
	//giovanni spinelli 18/02/2019
	console.log('CURRENT ID: ' + currentId);
	var currentIdValue = component.find(currentId).get('v.value');
	console.log('currentIdValue: ' + currentIdValue);

	//giovanni spinelli 18/02/2019 control if annual negotiated isn't greater than annual revenue - start
        if(currentIdValue < 0)
        {
		$A.util.addClass(component.find(currentId) , 'slds-has-error flow_required');
		component.set("v.ErrorBoolean"+currentId,true);
		component.set("v.ErrorMessage"+currentId , $A.get("$Label.c.OB_AnnualRevenueNotValid"))  ;
		component.set("v.objectDataMap.errorFamily.errorAnnualRevenueNegotiated", true);
	}
        else
        {
            if(currentId=='annualNegotiated')
            {
                if(component.find('annualRevenue'))
                {
				//convert string in number
				var numberAnnualRevenue 	= Number(component.find('annualRevenue').get('v.value'));
				var numberAnnualNegotiated 	= Number(currentIdValue);
                    if( numberAnnualRevenue < numberAnnualNegotiated)
                    {
					$A.util.addClass(component.find(currentId) , 'slds-has-error flow_required');
					component.set("v.ErrorBoolean"+currentId,true);
					component.set("v.ErrorMessage"+currentId , $A.get("$Label.c.OB_AnnualValueNotValid"))  ;//<--CHANGE LABEL
					component.set("v.objectDataMap.errorFamily.errorAnnualRevenueNegotiated", true);
                    }else
                    {
					//success
					$A.util.removeClass(component.find(currentId) , 'slds-has-error flow_required');
					component.set("v.ErrorBoolean"+currentId,false);
					component.set("v.ErrorBoolean"+currentId , '')  ;
					component.set("v.objectDataMap.errorFamily.errorAnnualRevenueNegotiated", false);
					/*remove red border and error message from annual revenue if it is greater than 0
					  else set true the boolean to stay in page*/
                        if(numberAnnualRevenue>=0)
                        {
						$A.util.removeClass(component.find('annualRevenue') , 'slds-has-error flow_required');
						component.set("v.ErrorBooleanannualRevenue",false);
                        }
                        else
                        {
						component.set("v.objectDataMap.errorFamily.errorAnnualRevenueNegotiated", true);
					}
				}
			}
		}
            if(currentId=='annualRevenue')
            {
                if(component.find('annualNegotiated'))
                {
				//convert string in number
				var  numberAnnualNegotiated = Number(component.find('annualNegotiated').get('v.value'));
				var  numberAnnualRevenue	= Number(currentIdValue);
                    if(numberAnnualNegotiated > numberAnnualRevenue)
                    {
					//error
					$A.util.addClass(component.find(currentId) , 'slds-has-error flow_required');
					component.set("v.ErrorBoolean"+currentId,true);
					component.set("v.ErrorMessage"+currentId , $A.get("$Label.c.OB_AnnualValueNotValid"))  ;//<--CHANGE LABEL
					component.set("v.objectDataMap.errorFamily.errorAnnualRevenueNegotiated", true);
                    }
                    else
                    {
					//success
					$A.util.removeClass(component.find(currentId) , 'slds-has-error flow_required');
					component.set("v.ErrorBoolean"+currentId,false);
					component.set("v.ErrorBoolean"+currentId , '')  ;
					component.set("v.objectDataMap.errorFamily.errorAnnualRevenueNegotiated", false);
					/*remove red border and error message from annual negotiated if it is greater than 0
					  else set true the boolean to stay in page*/
                        if(numberAnnualNegotiated>=0)
                        {
						$A.util.removeClass(component.find('annualNegotiated') , 'slds-has-error flow_required');
						component.set("v.ErrorBooleanannualNegotiated",false);
                        }
                        else
                        {
						component.set("v.objectDataMap.errorFamily.errorAnnualRevenueNegotiated", true);
					}
				}
				//Doris D. .... 03/04/2019....START
				// autocomplet of annual Negotiated with 30% of annual revenue
				if(numberAnnualRevenue > 0){
					component.set("v.objectDataMap.merchant.OB_Annual_Negotiated__c" ,Math.round(numberAnnualRevenue*0.3));
				//Doris D. .... 03/04/2019....END
				}
			}
		}
	}
	//giovanni spinelli 18/02/2019 control if annual negotiated isn't greater than annual revenue - end
	helper.removeRedBorder(component, event, helper);
    },

//****METHOD TO SHOW BANNER IF THERE IS ALREADY A SERVICE POINT WITH THE VALUE MERCHANT ID, MCC AND ADDRESS****//
    showBannerSameSp: function(component, evt, helper)
    {
	var objectDataMap       = component.get("v.objectDataMap");
	if(component.get("v.hasMessage")==false )
	{
            if(objectDataMap.pvAlreadyExist == true)
            {
		component.set("v.hasMessage" , true);
		component.set("v.messagetoshow" ,  $A.get("$Label.c.OB_SpAlreadyExist") );
            }
            else
            {
			component.set("v.hasMessage" , false);
			component.set("v.messagetoshow" , '');
		}
	}
	objectDataMap.pvAlreadyExist = false;
},

//****METHOD TO REFRESH PAGE AFTER ERROR SERVER****//
    refreshPage : function(component, evt, helper)
    {
	location.reload();
},

//IF IT IS IN TIMEOUT-->QUERY ON SFDC
    isTimeOutMethod : function(component, evt, helper)
    {
	console.log('into isTimeOutMethod 1');
        if(component.get('v.isTimeOut')==true)
        {
		console.log('into isTimeOutMethod 2');
		helper.getMerchantFromSFDC(component);
	}
    },

// ANDREA MORITTU START 12/02/2019
    checkvalidityNDG : function(component, event, helper)
    {
		helper.checkvalidityNDGHelper(component, event, helper);
	},
// ANDREA MORITTU END 12/02/2019

    /* Doris D.   07/03/2019 ------------- Start*/
    handleClickBack:function(component, event, helper) {

        var objectDataMap  = component.get("v.objectDataMap");
        var fiscalCode     = component.get("v.objectDataMap.merchant.NE__Fiscal_code__c");
        var vatId          = component.get("v.objectDataMap.merchant.NE__VAT__c");
        console.log("-------------------------------");
        console.log("Fiscale code  ---> "+fiscalCode);
        console.log("Fiscale code  ---> "+vatId);
        console.log("-------------------------------");
        if(component.get('v.booleanForNewMerchant') == true){

            if(vatId){

                component.set("v.objectDataMap.merchant.NE__Fiscal_code__c",vatId);
                console.log("Fiscale code new value ---> "+component.get("v.objectDataMap.merchant.NE__Fiscal_code__c"));
            }
            else if(fiscalCode && fiscalCode.length == 11){

                component.set("v.objectDataMap.merchant.NE__VAT__c",fiscalCode);
                console.log("NE__VAT__c new value ---> "+component.get("v.objectDataMap.merchant.NE__VAT__c"));
            }

        }

    },

    open : function (component,event,helper)
    {
        component.set("v.showMessage", true);
    },

    close : function (component,event,helper)
    {
        component.set("v.showMessage", false);
    },
    /* Doris D.   07/03/2019 ------------- END*/

    /* Doris D.   22/03/2019 ------------- START*/
	openTooltipResetButton : function (component,event,helper){

		component.set("v.showMessageresetButton", true);


    },
    /* Doris D.   07/03/2019 ------------- END*/

	
	closeTooltipResetButton : function (component,event,helper){
		component.set("v.showMessageresetButton", false);

	},
    /* Doris D.   22/03/2019 ------------- END*/

    //START gianluigi.virga 11/06/2019 - PRODOB-173 - PRODOB-173
	CheckLength : function(component, event, helper) {
		var val = component.find("annualRevenue").get('v.value');
		if(val.length > 12){
			var comp = component.find("annualRevenue");
			comp.set('v.value',val.substring(0,12));
		}
	},

	CheckMaxLength : function(component, event, helper) {
		var val = component.find("annualNegotiated").get('v.value');
		if(val.length > 12){
			var comp = component.find("annualNegotiated");
			comp.set('v.value',val.substring(0,12));
		}
	},
    //END gianluigi.virga 11/06/2019 - PRODOB-173

    //START gianluigi.virga 15/07/2019 - BACKLOG-153
        changeValueDate : function(component, event, helper) {
            component.set('v.objectDataMap.Configuration.OB_Check_in_date__c', component.get("v.checkInDate"));
        },
        removeRedBorderDate: function(component, event, helper) {
            helper.checkvalidityCheckInDate(component, event, helper);
        },
    //END gianluigi.virga - BACKLOG-153


    /**
     * @author Grzegorz Banach <grzegorz.banach@accenture.com>
     * @date 06/05/2019
     * @description method sets an attribute responsible for Document modal visibility
     * @Task: NEXI-30
     * @return -
     **/
    openDocumentInfoModal : function( component, event )
    {
        component.set( "v.isDocumentInfoModalVisible", true );
    },

    handleDocumentInfoEvent : function( component, event, helper )
    {
        helper.handleDocumentInfoEvent( component, event );
	},
	removeRedBorderDate: function(component, event, helper) {
		helper.checkvalidityCheckInDate(component, event, helper); 
    },
//END gianluigi.virga - BACKLOG-153
})