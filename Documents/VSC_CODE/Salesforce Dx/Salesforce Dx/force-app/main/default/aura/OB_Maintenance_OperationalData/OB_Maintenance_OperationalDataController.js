({
	doInit : function(component, event, helper) {
		try
		{
			//start antonio.vatrano 12/06/2019 r1f2-247
			var businessModel = (component.get('v.objectDataMap.bankProfile.OB_Business_Model_Acquiring__c') == 'Bancario')? true : false;
			var gt = (component.get('v.objectDataMap.bankProfile.OB_GT__c') == 'Nexi') ? true : false;
			var applicantNEXI = (component.get('v.objectDataMap.bankProfile.OB_Applicant_RAC_Code_SIA__c') == 'Nexi') ? true : false;
			var applicantBANCA = (component.get('v.objectDataMap.bankProfile.OB_Applicant_RAC_Code_SIA__c') != 'Nexi') ? true : false;
			var conditionBanca =  businessModel && gt && applicantBANCA ;
			var conditionNexi = applicantNEXI;
			component.set('v.conditionBanca',conditionBanca);
			component.set('v.conditionNexi',conditionNexi);
			//End antonio.vatrano 12/06/2019 r1f2-247
			helper.currentUse(component, event, helper);// simone misani R1F2-115 15/05/2019
			console.log('init operational data '+Date.now()+ 'milliseconds');														
			// component.set("v.objectDataMap.unbind.goToNextStepSocieta", 'test');
			// START - 2019/05/14 - salvatore.pianura - Sostituzione Terminale
			var listOfId = component.get("v.objectDataMap.TerminalIdsChanged");
			component.set("v.listOfTerminalIdAvaiable",listOfId);
			// END - 2019/05/14 - salvatore.pianura - Sostituzione Terminale
			helper.getReportType(component,helper ,event ); 
			helper.doInitMethodApex(component,event,helper);
			var objectDataMap = component.get('v.objectDataMap'); 

			/*SIMONE MISANI 08/03/2019*/
			var yearConstitutionCompanyNull = $A.util.isEmpty(objectDataMap.merchant.OB_Year_constitution_company__c);
			if(yearConstitutionCompanyNull) {
				component.set("v.objectDataMap.merchant.OB_Year_constitution_company__c", null);
			}

			// Daniele Gandini <daniele.gandini@accenture.com> - 19/06/2019 - Logic for maintenance remove case - START
			helper.checkProfileLoggedUser_helper(component, event, helper);
			helper.offerModify_Helper(component, event, helper);
			// Daniele Gandini <daniele.gandini@accenture.com> - 19/06/2019 - Logic for maintenance remove case - END

			

			////console.log('VAT_NOT_PRESENT: ' + objectDataMap.merchant.OB_VAT_Not_Present__c); 
			 
			// component.set('v.objectDataMap' , objectDataMap);
			
	    	//console.log('BILLING_PROF_ID: ' + JSON.stringify(objectDataMap.BillingProfilePOS));
	    	//console.log('ORDER_LENGTH: ' + JSON.stringify((objectDataMap.orderItem.ACQUIRING).length));
	    	// objectDataMap.Configuration.NE__BillingProfId__c = '' ;
	    	//console.log('CONFIGURATION_ID: ' +objectDataMap.Configuration.OB_Report_Type__c);*/
	    	// //********************IBAN SECTION - START ********************//
	    	// //valuate if there is a new visa/mastercard and JCB/UPI
	    	// var isNewPOS	,	isNewVisaMastercard		,	isNewJCB	,	isNewUPI	, isPOSAtt_unatt;
	    	// isNewPOS = (objectDataMap.orderItem.POS).length>=1;
	    	// for(var key in objectDataMap.orderItem)
	    	// {
	    	// 	//console.log('KEy: ' + key);
	    	// 	//console.log('NODE_IN_MAP: ' + JSON.stringify(objectDataMap.orderItem[key]));
    		// 	for(var i=0; i<(objectDataMap.orderItem[key]).length; i++)
    		// 	{
    		// 		if(key == 'ACQUIRING' && objectDataMap.orderItem[key][i].NE__ProdId__r.OB_Codice_sfdc__c == 'VISAMASTERCARD')
		    // 		{
			// 			isNewVisaMastercard=true;
			// 			component.set('v.isNewVisaMastercard' , true);
		    // 		}
		    // 		if(key == 'ACQUIRING' && objectDataMap.orderItem[key][i].NE__ProdId__r.OB_Codice_sfdc__c == 'UPI')
		    // 		{
		    // 			isNewUPI=true;
		    // 		}
		    // 		if(key == 'ACQUIRING' && objectDataMap.orderItem[key][i].NE__ProdId__r.OB_Codice_sfdc__c == 'JCB')
		    // 		{
		    // 			isNewJCB=true;
		    // 		}
		    // 		if(key == 'POS' && (objectDataMap.orderItem[key][i].NE__ProdId__r.OB_Codice_sfdc__c=='POS_TERZI_ATTENDED'|| objectDataMap.orderItem[key][i].NE__ProdId__r.OB_Codice_sfdc__c=='POS_TERZI_UNATTENDED'))
		    // 		{
		    // 			isPOSAtt_unatt=true;
		    // 		}
    		// 	}
    		// }
	    	// var bankABI           = component.get("v.objectDataMap.bank.OB_ABI__c"),
			//     CAB               = component.get("v.objectDataMap.user.OB_CAB__c");
			// //console.log('ABI_INIT: ' + bankABI +' CAB_INIT: ' + CAB);
			// //console.log('isPOS: ' + isNewPOS + ' isVISA: ' + isNewVisaMastercard);
			// //console.log('isJCB: ' + isNewJCB + ' isUPI: '  + isNewUPI);
			// //console.log('isPOSAtt_unatt: ' + isPOSAtt_unatt );
	    	// //if there is an new POS, a new visa/mastercard and there isn't JCB or UPI show IBAN  
	    	// if((isNewPOS==true || isNewVisaMastercard==true)/*&&(isNewUPI!=true || isNewJCB!=true )*/)
	    	// {
	    	// 	//console.log('SHOW_IBAN');
	    	// 	component.set('v.showIBANSection' , true);
	    	// 	component.find('headerInternational').set('v.disabled' , false);
	    	// }
	    	// //if there is a new POS attended or anattended show the preliminary verification code
	    	// if(isPOSAtt_unatt==true)
	    	// {
	    	// 	component.set('v.objectDataMap.prelimVerifCodeRO' , false);//DEFAULT IS TRUE
	    	// }

	    	// // if(isNewPOS==true)
	    	// // {
	    		
	    	// // }
	    	// var showIBANSection =  component.get('v.showIBANSection');
			// //if i have IBAN section, replace same logic of setup flow
			// //console.log('SHOW_IBAN: ' + component.get('v.showIBANSection'));
	    	
			// //********************      IBAN SECTION - END    ********************//

			// //********************REPORT TYPE SECTION - START ********************//
			// //only if there is a new visa/mastercard show picklist
			//  // check && isNewPOS!=true && isNewUPI!=true && isNewJCB!=true
			// if(isNewVisaMastercard==true){
			// 	component.set('v.objectDataMap.reportTypeRO' , false);
			// }else{
			// 	component.set('v.objectDataMap.reportTypeRO' , true);
			// }
			// //********************REPORT TYPE SECTION - END   ********************//

	   
	    	
	    	var isNexi = component.get('v.objectDataMap.isNEXI');
	    	
	    	
				////_utils.debug("into_isMaintenance");
	        	var orderId = component.get("v.orderId");
		        if($A.util.isEmpty(orderId)){
		        	orderId = objectDataMap.Configuration.Id;
		        	component.set("v.orderId",orderId);
		        	//split items here
		        	helper.splitOrderItemPOS(component,event);
		        }
			//D.F. _ Manage Rac Sia v4 _ START
			component.set('v.isMaintenanceRac',true);
			helper.checkTerminalsIBAN(component,event);
			//D.F. _ END
		}
		catch(err){
			//console.log('GENERIC_ERROR_DOINIT:  ' + err.message );
		}
    	
		
	},
	doInitAfter: function(component, event, helper) {
		console.log('INIT AFTER');
		//console.log('call init:' + component.get('v.callInit'));
		console.log("t0 doInitAfter: " + performance.now());
		var t0 = performance.now();
		var objectDataMap = component.get('v.objectDataMap');
		// Daniele Gandini <daniele.gandini@accenture.com> - 19/06/2019 - Logic for maintenance remove case - START
		helper.removeCase_Helper(component, event, helper);
		// Daniele Gandini <daniele.gandini@accenture.com> - 19/06/2019 - Logic for maintenance remove case - END
		console.log('@@@@ ObjectDatamap doinitafter: ' + JSON.stringify(objectDataMap));
		var isNewVisaMastercard = component.get('v.isNewVisaMastercard');
		try 
		{	
			
			//g.s. 14/02/2019 - if there is the OB_HeaderInternational__c , set it with merchant name - end
			console.log('@@@@ Nel try del doInitAfter'); 
			// DG - 14/02/2019 - 1341 - START
			

			// Vars to have row time from timestamp
			var opening = objectDataMap.pv.OB_Opening_Time__c/1000/3600;
			var closing = objectDataMap.pv.OB_Ending_Time__c/1000/3600;
			var breakStart = objectDataMap.pv.OB_Break_Start_Time__c/1000/3600;
			var breakEnd = objectDataMap.pv.OB_Break_End_Time__c/1000/3600;
			console.log('@@@@ objectDataMap.pv.OB_Opening_Time__c ' + objectDataMap.pv.OB_Opening_Time__c);
			console.log('@@@@ objectDataMap.pv.OB_Ending_Time__c ' + objectDataMap.pv.OB_Ending_Time__c);
			console.log('@@@@ objectDataMap.pv.OB_Break_Start_Time__c ' + objectDataMap.pv.OB_Break_Start_Time__c);
			console.log('@@@@ objectDataMap.pv.OB_Break_End_Time__c ' + objectDataMap.pv.OB_Break_End_Time__c);


			// Vars to have right time values
			// OPENING 
			var openingHours =  Math.floor(opening);
			var openingMinutes =  ((opening - (Math.floor(opening)))*60/100);
			var openingTime = (openingHours + openingMinutes).toFixed(2);
			// CLOSURE
			var closingHours =  Math.floor(closing);
			var closingMinutes = ((closing - (Math.floor(closing)))*60/100);
			var closingTime = (closingHours + closingMinutes).toFixed(2);
			// BREAK START
			var breakStartHours =  Math.floor(breakStart);
			var breakStartMinutes = ((breakStart - (Math.floor(breakStart)))*60/100);
			var breakStartTime = (breakStartHours + breakStartMinutes).toFixed(2);
			// BREAK END
			var breakEndHours =  Math.floor(breakEnd);
			var breakEndMinutes = ((breakEnd - (Math.floor(breakEnd)))*60/100);
			var breakEndTime = (breakEndHours + breakEndMinutes).toFixed(2);

			if(objectDataMap.pv.OB_Opening_Time__c){
				objectDataMap.pv.OB_Opening_Time__c       = openingTime;
			}
			if(objectDataMap.pv.OB_Ending_Time__c){
				objectDataMap.pv.OB_Ending_Time__c        = closingTime;
			}
			if(objectDataMap.pv.OB_Break_Start_Time__c){
				objectDataMap.pv.OB_Break_Start_Time__c   = breakStartTime;
			}
			if(objectDataMap.pv.OB_Break_End_Time__c){
				objectDataMap.pv.OB_Break_End_Time__c     = breakEndTime;
			}

			console.log('SERVICE POINT AFTER SET: ' + JSON.stringify(objectDataMap.pv));
			console.log('@@@@ DATAMAP OBJECT TIME VALUES');
			console.log('@@@@ OPENING: ' + openingTime);
			console.log('@@@@ CLOSURE: ' + closingTime);
			console.log('@@@@ BREAKSTART: '+ breakStartTime);
			console.log('@@@@ BREAKEND: ' + breakEndTime);

			// DG - 14/02/2019 - 1341 - END

			console.log('objectDataMap.merchant.OB_Year_constitution_company__c BEFORE'+objectDataMap.merchant.OB_Year_constitution_company__c);
			//SET YEAR OF CONSTITUTION 
			if( objectDataMap.merchant.OB_Year_constitution_company__c == undefined || 
				objectDataMap.merchant.OB_Year_constitution_company__c == '' || 
				objectDataMap.merchant.OB_Year_constitution_company__c == 0 ) {
				console.log('sono nell if');
				objectDataMap.merchant.OB_Year_constitution_company__c = null;
				// component.set('v.objectDataMap.unbind.yearOfConstitutionCompany' ,'test');
			}
			// else{
			// 	component.set('v.objectDataMap.unbind.yearOfConstitutionCompany' , objectDataMap.merchant.OB_Year_constitution_company__c);
			// }
			component.set('v.objectDataMap.unbind.yearOfConstitutionCompany' , objectDataMap.merchant.OB_Year_constitution_company__c);
			console.log('objectDataMap.merchant.OB_Year_constitution_company__c'+objectDataMap.merchant.OB_Year_constitution_company__c);
			console.log('####'+component.get('v.objectDataMap.unbind.yearOfConstitutionCompany')); 
			console.log('UNBIND AFTER YEAR: ' + JSON.stringify(component.get('v.objectDataMap.unbind')));
			//set value for rule at next step -->show/hide description vat not present
			if(objectDataMap.merchant.OB_VAT_Not_Present__c==true){
				//console.log('iNTO IF TRUE');
				component.set( 'v.objectDataMap.unbind.VAT_notPresent_Main', 'true');
				
			}else if(objectDataMap.merchant.OB_VAT_Not_Present__c==false){
				//console.log('iNTO IF FALSE');
				component.set( 'v.objectDataMap.unbind.VAT_notPresent_Main', 'false');
				
			}
			//set value for rule at next step-->manage no profit field
			//IF LEGAL FORM IS NO PROFIT
			if(objectDataMap.merchant.OB_Legal_Form_Code__c == 'ORG_NO_PROFIT')
			{
				component.set('v.objectDataMap.unbind.OB_Legal_Form_Main' , 'NOPROFIT');
				if(objectDataMap.merchant.OB_No_Profit_Recipient_Class__c=='Altro'){
					component.set('v.objectDataMap.unbind.OB_No_Profit_Recipient_Class__c','Altro');
				}
			}
		//	//console.log('OBJECT_DATA_MAP_DOINIT_UNBIND' + JSON.stringify(component.get('v.objectDataMap.unbind') ));
			//********************IBAN SECTION - START ********************//
	    	//valuate if there is a new visa/mastercard and JCB/UPI
	    	var isNewPOS	,	isNewVisaMastercard		,	isNewJCB	,	isNewUPI	, isPOSAtt_unatt;
	    	for(var key in objectDataMap.orderItem)
	    	{
	    	//	//console.log('KEy: ' + key);
	    	//	//console.log('NODE_IN_MAP: ' + JSON.stringify(objectDataMap.orderItem[key]));
    			for(var i=0; i<(objectDataMap.orderItem[key]).length; i++)
    			{
    				if(key == 'ACQUIRING' && objectDataMap.orderItem[key][i].NE__ProdId__r.OB_Codice_sfdc__c == 'VISAMASTERCARD' && objectDataMap.orderItem[key][i].NE__Action__c == 'Add') //davide.franzini - 14/06/2019 - R1F2-283
		    		{
						isNewVisaMastercard=true;
						component.set('v.isNewVisaMastercard' , true);
		    		}
		    		if(key == 'ACQUIRING' && objectDataMap.orderItem[key][i].NE__ProdId__r.OB_Codice_sfdc__c == 'UPI' && objectDataMap.orderItem[key][i].NE__Action__c == 'Add') //davide.franzini - 14/06/2019 - R1F2-283
		    		{
		    			isNewUPI=true;
		    		}
		    		if(key == 'ACQUIRING' && objectDataMap.orderItem[key][i].NE__ProdId__r.OB_Codice_sfdc__c == 'JCB' && objectDataMap.orderItem[key][i].NE__Action__c == 'Add') //davide.franzini - 14/06/2019 - R1F2-283
		    		{
		    			isNewJCB=true;
					}
					if(key == 'POS' && objectDataMap.orderItem[key][i].NE__Action__c == 'Add')	//davide.franzini - 14/06/2019 - R1F2-283
					{
						isNewPOS = true;
					}
		    		if(key == 'POS' && (objectDataMap.orderItem[key][i].NE__ProdId__r.OB_Codice_sfdc__c=='POS_TERZI_ATTENDED'|| objectDataMap.orderItem[key][i].NE__ProdId__r.OB_Codice_sfdc__c=='POS_TERZI_UNATTENDED'))
		    		{
		    			isPOSAtt_unatt=true;
		    		}
    			}
    		}
	    	var bankABI           = component.get("v.objectDataMap.bank.OB_ABI__c"),
			    CAB               = component.get("v.objectDataMap.user.OB_CAB__c");
		/*	//console.log('ABI_INIT: ' + bankABI +' CAB_INIT: ' + CAB);
			//console.log('isPOS: ' + isNewPOS + ' isVISA: ' + isNewVisaMastercard);
			//console.log('isJCB: ' + isNewJCB + ' isUPI: '  + isNewUPI);
			//console.log('isPOSAtt_unatt: ' + isPOSAtt_unatt );*/
	    	//if there is an new POS, a new visa/mastercard and there isn't JCB or UPI show IBAN  
	    	if((isNewPOS==true || isNewVisaMastercard==true)/*&&(isNewUPI!=true || isNewJCB!=true )*/)
	    	{
	    		//console.log('SHOW_IBAN');
	    		component.set('v.showIBANSection' , true);
	    		component.find('headerInternational').set('v.disabled' , false);
	    	}
	    	//if there is a new POS attended or anattended show the preliminary verification code
	    	if(isPOSAtt_unatt==true)
	    	{
	    		component.set('v.objectDataMap.prelimVerifCodeRO' , false);//DEFAULT IS TRUE
	    	}

	    	
			var showIBANSection =  component.get('v.showIBANSection');
			//console.log('BANK PROFILE BEFORE IBAN: ' + JSON.stringify(objectDataMap.bankProfile));
			//if i have IBAN section, replace same logic of setup flow - start
			if(showIBANSection==true)
			{
				//g.s. 14/02/2019 - if there is the OB_HeaderInternational__c , set it with merchant name - start
				component.set('v.objectDataMap.BillingProfilePOS.OB_HeaderInternational__c' , objectDataMap.merchant.Name);
				
				if(objectDataMap.bankProfile.OB_AccountHolder__c==true){
					//console.log('ACCOUNT_HOLDER_TRUE');
					
					component.set("v.objectDataMap.BillingProfilePOS.OB_CABCode__c", CAB   );
					component.set("v.disabledCab",true);
					component.set("v.objectDataMap.BillingProfilePOS.OB_ABICode__c", bankABI   );
					component.set("v.disabledAbi",true);
				}else{
					//console.log('ACCOUNT_HOLDER_FALSE');
					
					component.set("v.disabledCab",false);
					component.set("v.disabledAbi",false);
					component.set("v.objectDataMap.BillingProfilePOS.OB_CABCode__c"					, '');
					component.set("v.objectDataMap.BillingProfilePOS.OB_ABICode__c"					, '');
					
			//		//console.log('OBJDATAMAP_BILLING_POS: ' + JSON.stringify(component.get('v.objectDataMap.BillingProfilePOS')));
				}
				component.set('v.objectDataMap.BillingProfilePOS.OB_EuroControlCode__c'			, '');
				component.set('v.objectDataMap.BillingProfilePOS.OB_CINCode__c'					, '');
				component.set('v.objectDataMap.BillingProfilePOS.OB_Bank_Account_Number__c'		, '');
			}
			//if i have IBAN section, replace same logic of setup flow - end
			//if i have IBAN section, replace same logic of setup flow
		//	//console.log('SHOW_IBAN: ' + component.get('v.showIBANSection'));
	    	
			//********************      IBAN SECTION - END    ********************//

			//********************REPORT TYPE SECTION - START ********************//
			//only if there is a new visa/mastercard show picklist
			 // check && isNewPOS!=true && isNewUPI!=true && isNewJCB!=true
			if(isNewVisaMastercard==true){
				component.set('v.objectDataMap.reportTypeRO' , false);
			}else{
				component.set('v.objectDataMap.reportTypeRO' , true);
			}
			//********************REPORT TYPE SECTION - END   ********************//
			//********************PRELIMINARY VERIFICATION CODE & SETT TYPE - START   ********************//
	    	for(var key in objectDataMap.orderItem)
	    	{
	    		//console.log('KEy: ' + key);
	    	//	//console.log('NODE_IN_MAP: ' + JSON.stringify(objectDataMap.orderItem[key]));
    			for(var i=0; i<(objectDataMap.orderItem[key]).length; i++)
    			{
    	//			//console.log('NODE_INNER_MAP: ' + JSON.stringify(objectDataMap.orderItem[key][i].NE__ProdId__r.OB_Codice_sfdc__c));

    				if(key == 'POS' && (objectDataMap.orderItem[key][i].NE__ProdId__r.OB_Codice_sfdc__c=='POS_TERZI_ATTENDED'|| objectDataMap.orderItem[key][i].NE__ProdId__r.OB_Codice_sfdc__c=='POS_TERZI_UNATTENDED'))
		    		{
		    //			//console.log('POS_ATTENDED');
		    			component.set('v.objectDataMap.prelimVerifCodeRO' , false);//DEFAULT IS TRUE
		    		}
		    		if(key == 'ACQUIRING' && objectDataMap.orderItem[key][i].NE__ProdId__r.OB_Acquirer__c == 'NEXI' )
		    		{
		    	//		//console.log('ACQUIRING LIST: ' + JSON.stringify(objectDataMap.orderItem[key]));
		    			component.set('v.objectDataMap.isNEXI' ,  true);
		    			if(isNewVisaMastercard){
		    				component.set('v.settlementType', objectDataMap.bankProfile.OB_SettlementType__c);
			    		}else{
			    			component.set('v.settlementType',objectDataMap.Configuration.OB_SettlementType__c);
			    		}
					}
				}
			}
			//********************PRELIMINARY VERIFICATION CODE & SETT TYPE - START   ********************//
			for(var key in objectDataMap.orderItem)
				{
					//elena.preteni - start - 30/01/2019
					for(var i=0; i<(objectDataMap.orderItem[key]).length; i++)
					{
						if(isNewVisaMastercard && objectDataMap.orderItem[key][i].NE__ProdId__r.OB_Acquirer__c == 'NEXI'){
					//		//console.log('OBJDATAMAP_KEYTOUSE: ' + objectDataMap.keyToUse);
							if(objectDataMap.keyToUse.servicePointCode != null && objectDataMap.keyToUse.Processor == 'EQUENS')
							{ 
					//			//console.log('PROCESSOR_EQUENS');
								if( objectDataMap.keyToUse.OBInternationalSettlementMethod != null )
								{
					//				//console.log('INT_SETT_METHOD_NOTNULL');
									if(objectDataMap.bankProfile.OB_Circuit__c == 'Pagobancomat bancario')
									{
					//					//console.log('BANKPROFILE_PAGOBANCOMAT_BANCARIO');
										component.set('v.objectDataMap.interSettMethRO',true);
										objectDataMap.Configuration.OB_PBSettlementMethod__c  = objectDataMap.keyToUse.OBPBSettlementMethod;
										objectDataMap.Configuration.OB_InternationalSettlementMethod__c =objectDataMap.keyToUse.OBInternationalSettlementMethod;
									}
									if(objectDataMap.bankProfile.OB_Circuit__c == 'Pagobancomat sub-licenza')
									{
					//					//console.log('BANKPROFILE_PAGOBANCOMAT_SUBLICENZA');
										if(objectDataMap.orderItem[key][i].NE__Root_Order_Item__c == null && objectDataMap.orderItem[key][i].NE__ProdId__r.RecordType.DeveloperName == 'Pagobancomat')
										{
											if(objectDataMap.Configuration.OB_PBSettlementMethod__c != undefined && objectDataMap.Configuration.OB_PBSettlementMethod__c !=null)
											{
					//							//console.log('SETT_MET_NOTNULL');
												objectDataMap.viewSettMeth = true;
												objectDataMap.settMethRO = false;
											
											}
											else if(objectDataMap.orderItem[key][i].RecordType.DeveloperName=='Pagobancomat') 
											{
					//							//console.log('DEVNAME==PAGOBANCOMAT');
												component.set('v.objectDataMap.interSettMethRO',true);
												objectDataMap.Configuration.OB_PBSettlementMethod__c  = objectDataMap.keyToUse.OBPBSettlementMethod;
												objectDataMap.Configuration.OB_InternationalSettlementMethod__c =objectDataMap.keyToUse.OBInternationalSettlementMethod;
											}
											else
											{
					//							//console.log('DEVNAME!=PAGOBANCOMAT');
												component.set('v.objectDataMap.interSettMethRO',true);
												objectDataMap.Configuration.OB_PBSettlementMethod__c  = objectDataMap.keyToUse.OBPBSettlementMethod;
												objectDataMap.Configuration.OB_InternationalSettlementMethod__c =objectDataMap.keyToUse.OBInternationalSettlementMethod;
											}
		
										}
									
									}
								}
							}
							//var valueNetto = 'BANCA (ACCREDITATO AL NETTO DELLE COMMISSIONI)';
							//var valueLordo = 'BANCA (ACCREDITATO AL LORDO DELLE COMMISSIONI)';
							var valueNetto = 'ACCREDITO AL NETTO DELLE COMMISSIONI';
							var valueLordo = 'ACCREDITO AL LORDO DELLE COMMISSIONI';
							if(objectDataMap.keyToUse.servicePointCode != null && objectDataMap.keyToUse.Processor == 'SIA')
							{
					//			//console.log('EQUENS_SIA');
								if( objectDataMap.keyToUse.OBInternationalSettlementMethod != null )
								{

									component.set('v.objectDataMap.interSettMethRO',true);
									objectDataMap.Configuration.OB_PBSettlementMethod__c  = objectDataMap.keyToUse.OBInternationalSettlementMethod;
									objectDataMap.Configuration.OB_InternationalSettlementMethod__c =objectDataMap.keyToUse.OBInternationalSettlementMethod;
								} 
								else
								{
									
									if( objectDataMap.bankProfile.OB_SettlementType__c == 'Prepagato')
									{
					//					//console.log('SETT_PREPAGATO');
										component.set('v.objectDataMap.interSettMethRO',true);
										objectDataMap.keyToUse.OB_InternationalSettlementMethod__c=valueNetto;
										objectDataMap.Configuration.OB_PBSettlementMethod__c  = valueNetto;
										objectDataMap.Configuration.OB_InternationalSettlementMethod__c =valueNetto;
									}
									if( objectDataMap.bankProfile.OB_SettlementType__c == 'Postpagato')
									{
					//					//console.log('SETT_POSTPAGATO');
										component.set('v.objectDataMap.showPicklistPostpagato',true);
										component.get('v.postPagatoPickList').push(valueNetto);
										component.get('v.postPagatoPickList').push(valueLordo);
										objectDataMap.Configuration.OB_PBSettlementMethod__c  = component.get('v.settMethodPostPagatoValue');
										objectDataMap.Configuration.OB_InternationalSettlementMethod__c =component.get('v.settMethodPostPagatoValue');;
									}
								}

							}
							if(typeof objectDataMap.keyToUse.servicePointCode === undefined || objectDataMap.keyToUse.servicePointCode == null)
							{
					//			//console.log('SERVICEPOINTCODE_NULL');
								if( objectDataMap.bankProfile.OB_SettlementType__c == 'Prepagato')
								{
					//				//console.log('SETT_PREPAGATO');
									component.set('v.objectDataMap.interSettMethRO',true);
									objectDataMap.keyToUse.OB_InternationalSettlementMethod__c=valueLordo;
									objectDataMap.Configuration.OB_PBSettlementMethod__c  = valueLordo;
									objectDataMap.Configuration.OB_InternationalSettlementMethod__c =valueLordo;
								}
								if( objectDataMap.bankProfile.OB_SettlementType__c == 'Postpagato')
								{
					//				//console.log('SETT_POSTPAGATO');
									component.set('v.objectDataMap.showPicklistPostpagato',true);
									component.get('v.postPagatoPickList').push(valueNetto);
									component.get('v.postPagatoPickList').push(valueLordo);
									objectDataMap.Configuration.OB_PBSettlementMethod__c  = component.get('v.settMethodPostPagatoValue');
									objectDataMap.Configuration.OB_InternationalSettlementMethod__c =component.get('v.settMethodPostPagatoValue');;
								}
							}
						}
					}
					//elena.preteni - end - 30/01/201
				
				} 
				//component.set("v.Spinner", false);
		}catch(err){
			component.set("v.Spinner", false);
			console.log('DOINTI_AFTER_ERROR: ' + err.message);
		}
		var t1 = performance.now();
		console.log("Call doInitAfter took " + (t1 - t0) + " milliseconds.");
	},
	logInit: function(component){
		_utils.logInit(component.getName());
	},

	generateTerminalId: function(component, event, helper) {
	
		//_utils.debug("into generateTerminalId");
       	//call service from here		
		helper.callService(component);		
	},
    onUpdateContext : function(component, event, helper) {
		var t0 = performance.now();

		_utils.debug('Inside onUpdateContext for TechDetailService');
		//francesca.ribezzi 11/04/19 commented cause of merge error:
		//component.set("v.Spinner", true);
		var objectDataMap = component.get("v.objectDataMap");
		var coreOutput = event.getParam("CartService_Output");
		
		var itemToUpdate =  component.get("v.itemToUpdate");
		var needConfig = component.get("v.needConfig");
		var isEnd = component.get("v.isEnd");
		var itemChildToUpdate = component.get("v.itemChildToUpdate");
		var configurePicklist = component.get("v.configurePicklist");
		var doneCheckout = component.get("v.doneCheckout");
			
		if(coreOutput != null){
			////_utils.debug("GOT THE CONTEXT? ", coreOutput);
		
			if(coreOutput.cart.length == 0){
				//error
				//_utils.debug("Cart is Empty!");
				component.set("v.Spinner",false);
			}
			//THIS IS THE END OF TIMEEEEE!!!!
			else if(isEnd){
				
				component.set("v.contextOutput", coreOutput);
				component.set("v.Spinner", false);
			}
			//
			else if(itemToUpdate != null && !needConfig){
				//20/03/19 francesca.ribezzi setting spinner to true only if we are updating an item's attribute
				component.set("v.Spinner", true);
				//_utils.debug("itemToUpdate has been changed!");
		    	////_utils.debug("coreOutput item updated? "+ JSON.stringify(coreOutput));
		    	
		    	if(itemChildToUpdate || configurePicklist){
			    	var closeConfEvent 	= 	$A.get("e.NE:Bit2Win_Event_ResetSaveConfiguration");
		            closeConfEvent.setParams({
		
					    "CartService_Output": coreOutput,
					    "type": "save"
		            });
	
		            closeConfEvent.fire();
		            component.set("v.itemChildToUpdate",null);
		            component.set("v.configurePicklist",false);  
		            component.set("v.isEnd",true);   
	            }
	            else{
	            	component.set("v.Spinner", false);
	            }
		            component.set("v.itemToUpdate", null);
			    	component.set("v.contextOutput", coreOutput);
			}
			
			else if(itemToUpdate != null && needConfig){
				//20/03/19 francesca.ribezzi setting spinner to true only if we are updating an item's attribute
				component.set("v.Spinner", true);
				if(!configurePicklist){
					//_utils.debug("itemToUpdate childItem has been changed!");
					itemChildToUpdate.fields.OB_enablement__c = component.get("v.itemChildCheck");
					
					var cartEventCheckout = $A.get("e.NE:Bit2win_Event_CartEvent");
		   
					var factsJSON = {"executeRules":true,
							   			"objectList": [{
							   				"action": "modify",
							   				"type": "cartitem",
							   				"uniqueid": "fields.itemCode",
							   				"value": itemChildToUpdate.fields.itemCode, 
							   				"instance": itemChildToUpdate
							   				} 
							   			]
							   		};
					   
					 cartEventCheckout.setParams({
						   'updateB2WGinEngine': factsJSON
					 });
					   
					 cartEventCheckout.fire();
				 }
				 else{//configuring picklist
					var cartEventCheckout = $A.get("e.NE:Bit2win_Event_CartEvent");
		   
					var factsJSON = {"executeRules":true,
							   			"objectList": [{
							   				"action": "modify",
							   				"type": "cartitem",
							   				"uniqueid": "fields.itemCode",
							   				"value": itemToUpdate.fields.itemCode, 
							   				"instance": itemToUpdate
							   				} 
							   			]
							   		};
					   
					 cartEventCheckout.setParams({
						   'updateB2WGinEngine': factsJSON
					 });
					   
					 cartEventCheckout.fire();
					 
				 } 
				 
				 component.set("v.needConfig",false);
				 
			}
			
			else{ //initial situation 
				//20/03/19 francesca.ribezzi setting spinner to true 
				component.set("v.Spinner", true);
				component.set("v.cartList", coreOutput.cart);
				var cart = component.get("v.cartList");
				var pos = [];
				var posAdd = []; //antonio.vatrano 30/05/2019 RI-88
		        var bancomat = [];
		        var vas = [];
		        var acquiring = [];
		        //var categoryName = [];
				var terminalIdItems = [];
				var server2server = [];//[09-05-2019 No Card Present Server2Server] Andrea Saracini
				var posInRemove = [];//[09-05-2019 Maintenance Remove Terminal] Andrea Saracini
				
				//recordTypes to match
				var terminaliRecordType = "Terminali";
				var terminaliRecordTypeGateway = "Gateway_Virtuale";
				var terminaliRecordTypeEcommerce = "eCommerce";
				var terminaliRecordTypeMoto = "Moto";
				var pagobancomatRecordType = "Pagobancomat";
				var acquiringRecordType = "Acquiring";
				var vasRecordType = "Vas";
				
				//check racSia
				var ob_racSiaNexi = "Nexi"; //nexi
				var ob_racSiaNexiToMatch = ob_racSiaNexi.toLowerCase();
				var ob_racSIACurrent = coreOutput.configuration.OB_Applicant_RAC_Code_SIA__c;	
				var ob_racSIACurrentToMatch = ob_racSIACurrent.toLowerCase();
				//end

				// <daniele.gandini@accenture.com> - 08/07/2019 - F2WAVE2-88 - start
				var serverIdList = [];
				// <daniele.gandini@accenture.com> - 08/07/2019 - F2WAVE2-88 - end
				
				terminaliRecordType = terminaliRecordType.toLowerCase();
				terminaliRecordTypeGateway = terminaliRecordTypeGateway.toLowerCase();
				terminaliRecordTypeEcommerce = terminaliRecordTypeEcommerce.toLowerCase();
				terminaliRecordTypeMoto = terminaliRecordTypeMoto.toLowerCase();
				pagobancomatRecordType = pagobancomatRecordType.toLowerCase(); 
				acquiringRecordType = acquiringRecordType.toLowerCase();
				vasRecordType = vasRecordType.toLowerCase();
				
				////_utils.debug(ob_racSIACurrentToMatch+" == "+ob_racSiaNexiToMatch);
				
				 //getting cart lists for each sections (pos, acquiring, vas and acquiring):
		        if(coreOutput.listOfBundles.length > 0){
			        for(var j = 0; j<coreOutput.listOfBundles.length; j++){  
			        	for(var x= 0; x<coreOutput.listOfBundles[j].bundleElements.length; x++){
			        		for(var i = 0; i< cart.length; i++){
			        			if(cart[i] != null){
			        				if(coreOutput.listOfBundles[j].bundleElements[x].fields.id == cart[i].fields.bundleElement){
			        					//if(coreOutput.listOfBundles[j].bundleElements[x].fields.name =="Gestione Terminali" ){
			        					////_utils.debug(cart[i].fields.RecordTypeName.toLowerCase()+ " == "+terminali.toLowerCase());
			        					var recordTypeToMatch = cart[i].fields.RecordTypeName.toLowerCase();
			        					if(recordTypeToMatch == terminaliRecordType || recordTypeToMatch == terminaliRecordTypeGateway  || recordTypeToMatch == terminaliRecordTypeEcommerce || recordTypeToMatch == terminaliRecordTypeMoto)
			        					{
			        						if(cart[i].listOfAttributes.length != 0)
			        						{
			        							for(var k = 0; k < cart[i].listOfAttributes.length; k++)
			        							{
			        								if(cart[i].listOfAttributes[k].fields.name == 'Terminal Id'){
			        									terminalIdItems.push(cart[i]);
			        								}
			        							}
			        							pos.push(cart[i]);	
											}
											//Start antonio.vatrano 30/05/2019 RI-88
											if(cart[i].fields.action == 'Add'){
												posAdd.push(cart[i]);
											}
											//End antonio.vatrano 30/05/2019 RI-88
			        					}
			        					//else if(coreOutput.listOfBundles[j].bundleElements[x].fields.name =="Gestione Pagobancomat" ){
			        					else if(recordTypeToMatch == pagobancomatRecordType && ob_racSIACurrentToMatch != ob_racSiaNexiToMatch ){
			        						if(cart[i].listOfAttributes.length != 0)
			        						{
			        							bancomat.push(cart[i]);
			        						}
			        					}
			        					//else if(coreOutput.listOfBundles[j].bundleElements[x].fields.name =="Selezione Acquiring" ){
			        					else if(recordTypeToMatch == acquiringRecordType ){
			        						if(cart[i].listOfAttributes.length != 0)
			        						{
			        							acquiring.push(cart[i]);
			        						}
			        					}
			        					//else if(coreOutput.listOfBundles[j].bundleElements[x].fields.name =="Selezione VAS" ){
			        					else if(recordTypeToMatch == vasRecordType ){
			        						if(cart[i].listOfAttributes.length != 0)
			        						{
			        							for(var k = 0; k < cart[i].listOfAttributes.length; k++)
			        							{
			        								if(cart[i].listOfAttributes[k].fields.name == 'Terminal Id'){
			        									cart[i].hasTerminalId = true;
			        									terminalIdItems.push(cart[i]);
			        								}
			        							}
			        							vas.push(cart[i]);
			        						}
			        					}
									}
			        			}
			        		}
						}
						//START [08-05-2019 No Card Present Server2Server] Andrea Saracini
						for(var i = 0; i< cart.length; i++){
							if(cart[i] != null){
								var codes2s = cart[i].fields.OBCodiceSfd;
								// <daniele.gandini@accenture.com> - 08/07/2019 - F2WAVE2-88 - start
								var serverId = cart[i].id;
								if('SERVER2SERVER' == codes2s && !serverIdList.includes(serverId)){ // d.g serverIdList condition added - 08/07/2019 - F2WAVE2-88 
									serverIdList.push(serverId);
								// <daniele.gandini@accenture.com> - 08/07/2019 - F2WAVE2-88 - end
									server2server.push(cart[i]);
									component.set("v.isServer2Server", true);	
								}
						 	}
					 	}
					 	//STOP [08-05-2019 No Card Present Server2Server] Andrea Saracini
		        	}	
			    }//END filling lists
			    //francesca.ribezzi - setting terminalIdItems
		        component.set("v.terminaIdItemsList", terminalIdItems);
			    //sort lists
			    pos.sort(function(a, b){
				return a.fields.sequence == b.fields.sequence ? 0 : +(a.fields.sequence > b.fields.sequence) || -1;
			    });
			    
			    var posChildItems;
			    //check attributes in pos
			    for(var i = 0; i < pos.length; i++){
			    	posChildItems = [];
	            	for(var j= 0; j < pos[i].childItems.length; j++){
	            		if( (pos[i].childItems[j].fields.visible == "true" || pos[i].childItems[j].fields.visible == true) && pos[i].childItems[j].fields.RecordTypeName !='Pricing'){
	            			posChildItems.push(pos[i].childItems[j]);
	            		}
            	}
            	//SORT pos children
            	posChildItems.sort(function(a, b){
            		return a.fields.sequence == b.fields.sequence ? 0 : +(a.fields.sequence > b.fields.sequence) || -1;
            	});
            	
            	pos[i].childItems = posChildItems;
			    }
			    
			   
			    bancomat.sort(function(a, b){
				return a.fields.sequence == b.fields.sequence ? 0 : +(a.fields.sequence > b.fields.sequence) || -1;
			    });
			    
			    vas.sort(function(a, b){
				return a.fields.sequence == b.fields.sequence ? 0 : +(a.fields.sequence > b.fields.sequence) || -1;
			    });
			    
			    /*
			    acquiringList.sort(function(a, b){
				return a.fields.OB_Sequence__c == b.fields.OB_Sequence__c ? 0 : +(a.fields.OB_Sequence__c > b.fields.OB_Sequence__c) || -1;
			    });
			    */
 
				////_utils.debug("acquiringList: " + JSON.stringify(acquiring));
				////_utils.debug("posList: ",pos);
				////_utils.debug("coreOutput: ",coreOutput);
				component.set("v.posList", pos);
				component.set("v.posListAdd", posAdd);	//antonio.vatrano 30/05/2019 RI-88
		        component.set("v.vasList", vas);
		        component.set("v.acquiringList", acquiring);
		        component.set("v.bancomatList", bancomat);
		        //francesca.ribezzi -  setting contextOutput:
				component.set("v.contextOutput", coreOutput);
				component.set("v.server2serverList", server2server);//[09-05-2019 No Card Present Server2Server] Andrea Saracini
				component.set("v.Spinner",false);
			}	
		}
		var t1 = performance.now();
		console.log("Call onUpdateContext operationData took " + (t1 - t0) + " milliseconds.");
		 //francesca.ribezzi 20/03/19 spinner false	
		component.set("v.Spinner",false);
	},
	handleAfterCheckOut : function(component,event, helper){
    	//_utils.debug("into handleAfterCheckOut");
		try
		{ 
    		var doCheckout = component.get("v.requestCheckout");
			//console.log('DOCHECKOUT: ' + doCheckout);
			var bitwinMap = {};
			bitwinMap = event.getParam("bitwinMap");
			//francesca.ribezzi 20/03/19 commenting methodDone -it was used for the spinner
		/*	if($A.util.isEmpty(bitwinMap)){
				component.set("v.methodDone", true); 
			}*/
    		if(doCheckout){
				//START francesca.ribezzi 16/04/19 checking chechout performance
				var checkoutPerformance = component.get("v.checkoutPerformance");
				var millis = Date.now() - checkoutPerformance;
				console.log("CHECKOUT performance = " + Math.floor(millis/1000));
				//END																														 												  																
    			//console.log('HANDLER_AFTER_CHECKOUT');
	    		////_utils.debug("bitwinMap: " + JSON.stringify(bitwinMap));
			//	console.log("bitwinMap.checkOutResponse: " + JSON.stringify(bitwinMap.checkOutResponse));
				var mapItemIdTerminalId = component.get("v.mapItemIdTerminalId");
				if(!$A.util.isEmpty(mapItemIdTerminalId)){
					helper.updateTerminalIds(component, event);
				}
				//19/02/19 francesca.ribezzi calling insertBillingProfilesUpdateOrderHeader here
				helper.insertBillingProfilesUpdate(component, event);
				//helper.showBit2flowNext(component, event);
				//19/02/19 francesca.ribezzi moving enrichOrder after calling insertBillingProfilesUpdateOrderHeader
	    	
	    		component.set("v.requestCheckout",false); 
			}
		}
		catch(err){
			//console.log('ERROR_MESSAGE_HANDLERCHECKOUT: ' + err.message);
		}
    },
	
	//this is called when an attribute value is changed. it fires an event that calls onUpdateContext function:
    onChangeAttributeValuePOS: function(component, event, helper){
    	//_utils.debug("into onChangeAttributeValuePOS");
    	var attributeIndex = JSON.stringify(event.target.id); 
        var listOfItems = component.get("v.posList");
        var parentIndex = document.getElementById(event.target.id).name;
        //_utils.debug("parentIndex: " + parentIndex);
       // var firstIndex = event.currentTarget.getAttribute('data-item'); 
       // //_utils.debug("listOfItems[firstIndex].childItems: " + JSON.stringify(listOfItems[firstIndex].childItems));
        ////_utils.debug("posList: " + JSON.stringify(listOfItems));
       // attributeIndex = parseInt(attributeIndex.split('_').pop());
        var pos1 = attributeIndex.indexOf("_")+1;
        var length1 = attributeIndex.indexOf("_",pos1)-1;
        var tempStr = attributeIndex.substr(length1);
        attributeIndex = tempStr.substr(0,tempStr.indexOf('_'));//firstIndex+'_'+index+'_POS'
    
        ////_utils.debug("attributeIndex POS: " + attributeIndex);
        
        //RESET Error Message if updating terminal ID
        var attName = document.getElementById(attributeIndex+'_attName').textContent;
        var itemToUpdate = listOfItems[parentIndex];
         var errMsg= document.getElementById(event.target.id+'_Error');
        //checking if this is the terminal id: 
     /*   if(attName == 'Terminal Id'){
        	 //_utils.debug("it is a terminal id!");
         	 //if it is not readonly and it is required
        	 if(itemToUpdate.listOfAttributes[attributeIndex].fields.required == 'Yes' && (itemToUpdate.listOfAttributes[attributeIndex].fields.readonly == false || itemToUpdate.listOfAttributes[attributeIndex].fields.readonly == 'false')){
        		 //_utils.debug("terminal id is required and must be 9 characters long!");
        		 errMsg.innerHTML = "terminal id is required and must be 9 characters long!"; 
        	 }else{
        		  //reset error Msg if result is correct
        		 errMsg.innerHTML = '';
        	 }
        }*/   
        var contextOutput = component.get("v.contextOutput");
        itemToUpdate.listOfAttributes[attributeIndex].fields.value =  event.target.value;
        //francesca.ribezzi - removing error class from input:
	     var inputValue = event.target.value;
	    /*  if(attName == 'Terminal Id'){   
	         if(/^[0-9]*([,][0-9]{1,3}|)$/.test(event.target.value)){ 
		        if(inputValue.length > 0){
		        	document.getElementById(event.target.id).classList.remove("borderError");
		        }
		        component.set("v.itemToUpdate", itemToUpdate);
		        //_utils.debug("itemToUpdate: ",itemToUpdate);  
		    	
		    	var changeAttributeEvent = 	$A.get("e.NE:Bit2win_Event_AttributeChanged");
					changeAttributeEvent.setParams({
						'itemChanged': itemToUpdate,
						'Context_Output':contextOutput
					});
			    											
			   changeAttributeEvent.fire(); 
			   errMsg.innerHTML = '';
			   component.set("v.Spinner", true);
	         }
	         else{
	        	 errMsg.innerHTML = 'the value is not valid.'
	        	 event.target.value = '';
	        	 document.getElementById(event.target.id).classList.add("borderError");
	         }
	    }*/
    		component.set("v.itemToUpdate", itemToUpdate);
	        //_utils.debug("itemToUpdate: ",itemToUpdate);  
	    	
	    	var changeAttributeEvent = 	$A.get("e.NE:Bit2win_Event_AttributeChanged");
				changeAttributeEvent.setParams({
					'itemChanged': itemToUpdate,
					'Context_Output':contextOutput
				});
		    											
		   changeAttributeEvent.fire(); 
		   errMsg.innerHTML = '';
		   component.set("v.Spinner", true);
	   //component.set("v.itemToUpdate", itemToUpdate);  
    },
     onChangeAttributeValuePOSPickList: function(component, event, helper){
        //_utils.debug("into onChangeAttributeValuePOSPicklist")
        
        var listOfItems = component.get("v.posList");
        
        
		//_utils.debug("attributeIndex: " + attributeIndex);
		//LUBRANO -- 2019/02/22 gestione attribute/parent index index
		var attributeIndex = event.target.name.replace(/"\""/g, ""); 
		//var parentIndex = attributeIndex.substring(1, attributeIndex.indexOf('_')); 
		var indexArray = attributeIndex.split('_');
		var parentIndex = indexArray[0]; 
     	//_utils.debug("parentIndex: " + parentIndex);
       	// var firstIndex = event.currentTarget.getAttribute('data-item'); 
       	// //_utils.debug("listOfItems[firstIndex].childItems: " + JSON.stringify(listOfItems[firstIndex].childItems));
		//_utils.debug("posList: " ,listOfItems);
		
        // var pos1 = attributeIndex.indexOf("_")+1;
		// var length1 = attributeIndex.indexOf("_",pos1)-1;
		
        //var tempStr = attributeIndex.substr(length1);
        //attributeIndex = tempStr.substr(0,tempStr.indexOf('_'));
		attributeIndex = indexArray[1];
		
        //attributeIndex = parseInt(attributeIndex.split('_').pop());
        
        var itemToUpdate = listOfItems[parseInt(parentIndex)];
        var contextOutput = component.get("v.contextOutput");
        itemToUpdate.listOfAttributes[attributeIndex].fields.value =  event.target.value;
        ////_utils.debug("attribute changed: " +itemToUpdate.listOfAttributes[attributeIndex] );
        
        component.set("v.itemToUpdate", itemToUpdate);
  	   
    	component.set("v.isEnd",false);
        //itemToUpdate.childItems[attributeIndex].fields.OB_enablement__c = status; 
	
		 var addRemoveFromCart = $A.get("e.NE:Bit2win_Event_AddRemoveFromCart");  
		 //before launching addRemoveFromCart to configure the item
		 	addRemoveFromCart.setParams({
            	"item": itemToUpdate,
                "action": "modify",
                "typeOfAdd": "multiAdd" 
        	});
		 addRemoveFromCart.fire(); 
		 
		 component.set("v.configurePicklist",true);
		 component.set("v.needConfig",true);
		 component.set("v.Spinner", true);
		//START gianluigi.virga 25/07/2019 - PRODOB-161
		if(itemToUpdate.listOfAttributes[attributeIndex].fields.name == $A.get("$Label.c.OB_SimCard")){
			if((itemToUpdate.listOfAttributes[attributeIndex].fields.action != $A.get("$Label.c.OB_ActionNone") && itemToUpdate.listOfAttributes[attributeIndex].fields.value != null && itemToUpdate.listOfAttributes[attributeIndex].fields.value != undefined && itemToUpdate.listOfAttributes[attributeIndex].fields.value != '')
					|| (itemToUpdate.listOfAttributes[attributeIndex].fields.action == $A.get("$Label.c.OB_ActionNone"))){
				itemToUpdate.listOfAttributes[attributeIndex].fields.simCardIsValid = true;
			}else{
				itemToUpdate.listOfAttributes[attributeIndex].fields.simCardIsValid = false;
			}
		}
		if(itemToUpdate.listOfAttributes[attributeIndex].fields.name == $A.get("$Label.c.OB_Property")){
			if((itemToUpdate.listOfAttributes[attributeIndex].fields.action != $A.get("$Label.c.OB_ActionNone") && itemToUpdate.listOfAttributes[attributeIndex].fields.value != null && itemToUpdate.listOfAttributes[attributeIndex].fields.value != undefined && itemToUpdate.listOfAttributes[attributeIndex].fields.value != '')
					|| (itemToUpdate.listOfAttributes[attributeIndex].fields.action == $A.get("$Label.c.OB_ActionNone"))){
				itemToUpdate.listOfAttributes[attributeIndex].fields.thirdPartyPropertyIsValid = true;
			}else{
				itemToUpdate.listOfAttributes[attributeIndex].fields.thirdPartyPropertyIsValid = false;
			}
		}
		//END gianluigi.virga 25/07/2019 - PRODOB-161
    },
    onChangeItemValuePOS: function(component, event, helper){
    	//_utils.debug("into onChangeItemValuePOS");
    	var attributeIndex = event.target.id; 
        var listOfItems = component.get("v.posList");

        
        var itemToUpdate = listOfItems[parseInt(attributeIndex)];
        var contextOutput = component.get("v.contextOutput");
        ////_utils.debug("itemToUpdate description",itemToUpdate);
        
        itemToUpdate.fields.OB_Description__c = event.srcElement.value;
        
        component.set("v.itemToUpdate", itemToUpdate);
        ////_utils.debug("itemToUpdate: ",itemToUpdate);  
    	
       //_utils.debug("uniqueId "+itemToUpdate.fields.itemCode);
	   var cartEventCheckout = $A.get("e.NE:Bit2win_Event_CartEvent");
	   
	   var factsJSON = {"executeRules":true,
			   			"objectList": [{
			   				"action": "modify",
			   				"type": "cartitem",
			   				"uniqueid": "fields.itemCode",
			   				"value": itemToUpdate.fields.itemCode, 
			   				"instance": itemToUpdate
			   				} 
			   			]
			   		};
	   
	   cartEventCheckout.setParams({
		   'updateB2WGinEngine': factsJSON
	   });
	   
	   cartEventCheckout.fire();

	   component.set("v.Spinner", true);
	   //component.set("v.itemToUpdate", itemToUpdate);  
    },
    
    onCheck :function(component, event, helper){
    
    	//_utils.debug("into onCheck");
    	//
    	component.set("v.isEnd",false);
    	//
    	var attributeIndex = JSON.stringify(event.target.id); 
        var listOfItems = component.get("v.posList");
       // var parentIndex = document.getElementById(event.target.id).name;
        //var parentIndex = event.currentTarget.getAttribute('data-item');
        var parentIndex = attributeIndex.substr(1, attributeIndex.indexOf('_')-1);
        //_utils.debug("parentIndex: " + parentIndex);
        
        var acq1 = attributeIndex.indexOf("_")+1;
        var length1 = attributeIndex.indexOf("_",acq1)-1;
        var tempStr = attributeIndex.substr(length1);
        attributeIndex = tempStr.substr(0,tempStr.indexOf('_'));	
       // attributeIndex = parseInt(attributeIndex.split('_').pop());
        //_utils.debug("attributeIndex "+attributeIndex);
        var itemToUpdate = listOfItems[parseInt(parentIndex)];
        var contextOutput = component.get("v.contextOutput");
        //_utils.debug("itemToUpdate ",itemToUpdate);
        var status;
        if(event.target.checked == true){
        	status = "Y";
        }
        else{
        	status = "N";
        }
        //itemToUpdate.childItems[attributeIndex].fields.OB_enablement__c = status;
        component.set("v.itemChildCheck",status);
        component.set("v.itemChildToUpdate",itemToUpdate.childItems[attributeIndex]);
        component.set("v.itemToUpdate", itemToUpdate);
        ////_utils.debug("itemToUpdate: ",itemToUpdate);  

		
		 var addRemoveFromCart = $A.get("e.NE:Bit2win_Event_AddRemoveFromCart");  
		 //before launching addRemoveFromCart to configure the item
		 	addRemoveFromCart.setParams({
            	"item": itemToUpdate.childItems[attributeIndex],
                "action": "modify",
                "typeOfAdd": "multiAdd" 
        	});
		 addRemoveFromCart.fire(); 
		
		 component.set("v.needConfig",true);
		 component.set("v.Spinner", true);
    
    },   
    //this is called when an attribute value is changed. it fires an event that calls onUpdateContext function:
    onChangeAttributeValueBancomat: function(component, event, helper){
    	//_utils.debug("into onChangeAttributeValueBancomat");
        var attributeIndex = JSON.stringify(event.target.id); 
        var listOfItems = component.get("v.bancomatList");
        var parentIndex = document.getElementById(event.target.id).name;
        ////_utils.debug("parentIndex: " + parentIndex);
       // var firstIndex = event.currentTarget.getAttribute('data-item'); 
       // //_utils.debug("listOfItems[firstIndex].childItems: " + JSON.stringify(listOfItems[firstIndex].childItems));
        //_utils.debug("bancomatList: " ,listOfItems);
        //attributeIndex = parseInt(attributeIndex.split('_').pop());
        var Bancomat1 = attributeIndex.indexOf("_")+1;
        var length1 = attributeIndex.indexOf("_",Bancomat1)-1;
        var tempStr = attributeIndex.substr(length1);
        attributeIndex = tempStr.substr(0,tempStr.indexOf('_'));//firstIndex+'_'+index+'_Bancomat'
        var errMsg = document.getElementById(event.target.id+'Error');
        
        var itemToUpdate = listOfItems[parentIndex];
        var inputNumNameMap = {};
        //francesca.ribezzi - creating map to check the correct input value length for each field:
        inputNumNameMap['Codice SIA'] = 7;
        inputNumNameMap['Codice Stabilimento SIA'] = 5;
        inputNumNameMap['Progressivo SIA'] = 3;
         
        if(itemToUpdate != null){
	        var contextOutput = component.get("v.contextOutput");
	        itemToUpdate.listOfAttributes[attributeIndex].fields.value =  event.target.value;
	        ////_utils.debug("attribute changed: " +itemToUpdate.listOfAttributes[attributeIndex] );
	        var inputValue = event.target.value;
	         //match the regex  /^[0-9]+$/
	        if(/^[0-9]+$/.test(event.target.value)){   	
	        	var nameToCheck = itemToUpdate.listOfAttributes[attributeIndex].fields.name;
				 if(inputValue.length == inputNumNameMap[nameToCheck]){
		        	document.getElementById(event.target.id).classList.remove("borderError");
		        	itemToUpdate.listOfAttributes[attributeIndex].fields.value =  event.target.value;
			        component.set("v.itemToUpdate", itemToUpdate);
			        //_utils.debug("itemToUpdate: ",itemToUpdate);  
			    	var changeAttributeEvent = 	$A.get("e.NE:Bit2win_Event_AttributeChanged");
						changeAttributeEvent.setParams({
							'itemChanged': itemToUpdate,
							'Context_Output':contextOutput
						});
				    											
				   changeAttributeEvent.fire(); 
				   errMsg.innerHTML = '';
				   component.set("v.Spinner", true);
			     }else{
			    	 if(inputValue.length == 0){
			    		 errMsg.innerHTML = '';
				    	 document.getElementById(event.target.id).classList.remove("borderError");
			    	 }else{
				    	 errMsg.innerHTML = $A.get("$Label.c.OB_invalidValue");
				    	 document.getElementById(event.target.id).classList.add("borderError");
				    }
			     }
			     
			}
			else{
				//show error message!!!
				 errMsg.innerHTML = $A.get("$Label.c.OB_invalidValue");
				event.target.value = '';
				document.getElementById(event.target.id).classList.add("borderError");
			}
        }
	 								
    },
    onChangeAttributeValueBancomatPickList: function(component, event, helper){
        //_utils.debug("into onChangeAttributeValueBancomatPicklist")
        
        var listOfItems = component.get("v.bancomatList");
        
        var attributeIndex = JSON.stringify(event.target.name); 
        //_utils.debug("attributeIndex: " + attributeIndex);
        var parentIndex = attributeIndex.substring(1, attributeIndex.indexOf('_')); 
        //_utils.debug("parentIndex: " + parentIndex);
       // var firstIndex = event.currentTarget.getAttribute('data-item'); 
       // //_utils.debug("listOfItems[firstIndex].childItems: " + JSON.stringify(listOfItems[firstIndex].childItems));
        //_utils.debug("vasList: " ,listOfItems);
        var bancomat1 = attributeIndex.indexOf("_")+1;
        var length1 = attributeIndex.indexOf("_", bancomat1)-1;
        var tempStr = attributeIndex.substr(length1);
        attributeIndex = tempStr.substr(0,tempStr.indexOf('_'));
        //attributeIndex = parseInt(attributeIndex.split('_').pop());
        
        var itemToUpdate = listOfItems[parseInt(parentIndex)];
        var contextOutput = component.get("v.contextOutput");
        itemToUpdate.listOfAttributes[attributeIndex].fields.value =  event.target.value;
        ////_utils.debug("attribute changed: " +itemToUpdate.listOfAttributes[attributeIndex] );
        
        component.set("v.itemToUpdate", itemToUpdate);
       // //_utils.debug("itemToUpdate: ",itemToUpdate);  
    	
    	var changeAttributeEvent = 	$A.get("e.NE:Bit2win_Event_AttributeChanged");
			changeAttributeEvent.setParams({
				'itemChanged': itemToUpdate,
				'Context_Output':contextOutput
			});
	    											
	   changeAttributeEvent.fire(); 
	   component.set("v.Spinner", true);
    },      
    //this is called when an attribute value is changed. it fires an event that calls onUpdateContext function:
    onChangeAttributeValueACQ: function(component, event, helper){
        //_utils.debug("into onChangeAttributeValueACQ")
        var attributeIndex = JSON.stringify(event.target.id); 
          //_utils.debug("attributeIndex: " + attributeIndex);
        var listOfItems = component.get("v.acquiringList");
        var parentIndex = document.getElementById(event.target.id).name;
        //_utils.debug("parentIndex: " + parentIndex);
       // var firstIndex = event.currentTarget.getAttribute('data-item'); 
       // //_utils.debug("listOfItems[firstIndex].childItems: " + JSON.stringify(listOfItems[firstIndex].childItems));
        //_utils.debug("acquiringList: " listOfItems);
        var acq1 = attributeIndex.indexOf("_")+1;
        var length1 = attributeIndex.indexOf("_",acq1)-1;
        var tempStr = attributeIndex.substr(length1);
        attributeIndex = tempStr.substr(0,tempStr.indexOf('_'));
       
        //attributeIndex = parseInt(attributeIndex.split('_').pop());
        
        var itemToUpdate = listOfItems[parentIndex];
        var errMsg= document.getElementById(event.target.id+'_Error');
        
        if(itemToUpdate != null){
	        var contextOutput = component.get("v.contextOutput");
	        itemToUpdate.listOfAttributes[attributeIndex].fields.value =  event.target.value;
	        var attName = itemToUpdate.listOfAttributes[attributeIndex].fields.name;
	        ////_utils.debug("attribute changed: " +itemToUpdate.listOfAttributes[attributeIndex] );
	         //match the regex
	        if(/^[0-9]*([,][0-9]{1,3}|)$/.test(event.target.value)){
	        	if(attName == 'Codice Convenzione'){
	        		if(event.target.value.length != 10 && event.target.value.length != 0){
	        			document.getElementById(event.target.id).classList.add("borderError");
	        			errMsg.innerHTML = $A.get("$Label.c.OB_TenCharsError");
	        		}else{
	        			errMsg.innerHTML = '';
	        			document.getElementById(event.target.id).classList.remove("borderError");
	        			
	        			component.set("v.itemToUpdate", itemToUpdate);
				        //_utils.debug("itemToUpdate: ",itemToUpdate);  
				    	var changeAttributeEvent = 	$A.get("e.NE:Bit2win_Event_AttributeChanged");
							changeAttributeEvent.setParams({
								'itemChanged': itemToUpdate,
								'Context_Output':contextOutput
							});
					    											
					   changeAttributeEvent.fire(); 
					   component.set("v.Spinner", true); 
	        		}
	        	}else{
	        		document.getElementById(event.target.id).classList.remove("borderError");
	        		errMsg.innerHTML = '';
			        component.set("v.itemToUpdate", itemToUpdate);
			        //_utils.debug("itemToUpdate: ",itemToUpdate);  
			    	var changeAttributeEvent = 	$A.get("e.NE:Bit2win_Event_AttributeChanged");
						changeAttributeEvent.setParams({
							'itemChanged': itemToUpdate,
							'Context_Output':contextOutput
						});
				    											
				   changeAttributeEvent.fire(); 
				   component.set("v.Spinner", true); 
				}
		   }
		   else{
			   event.target.value = '';
			   errMsg.innerHTML = $A.get("$Label.c.OB_invalidValue");
			   	document.getElementById(event.target.id).classList.add("borderError");
		   }
        }
    },
     onChangeAttributeValueVAS: function(component, event, helper){
    	//_utils.debug("into onChangeAttributeValueVAS");
    	var attributeIndex = JSON.stringify(event.target.id); 
         var listOfItems = component.get("v.vasList");
        var parentIndex = document.getElementById(event.target.id).name;
        //_utils.debug("parentIndex: " + parentIndex);
       // var firstIndex = event.currentTarget.getAttribute('data-item'); 
       // //_utils.debug("listOfItems[firstIndex].childItems: " + JSON.stringify(listOfItems[firstIndex].childItems));
        //_utils.debug("vasList: " ,listOfItems);
        //attributeIndex = parseInt(attributeIndex.split('_').pop());
        
        var vas1 = attributeIndex.indexOf("_")+1;
        var length1 = attributeIndex.indexOf("_",vas1)-1;
        var tempStr = attributeIndex.substr(length1);
        attributeIndex = tempStr.substr(0,tempStr.indexOf('_'));//firstIndex+'_'+index+'_VAS'
        var errMsg = document.getElementById(event.target.id+'Error');
        var itemToUpdate = listOfItems[parentIndex];
        if(itemToUpdate != null){
	        var contextOutput = component.get("v.contextOutput");
	        itemToUpdate.listOfAttributes[attributeIndex].fields.value =  event.target.value;
	        ////_utils.debug("attribute changed: " +itemToUpdate.listOfAttributes[attributeIndex] );
	         if(/^[0-9]*([,][0-9]{1,3}|)$/.test(event.target.value)){ 
		        //francesca.ribezzi - removing error class from input:
		        errMsg.innerHTML = '';
		        var inputValue = event.target.value;
		        if(inputValue.length > 0){
		        	document.getElementById(event.target.id).classList.remove("borderError");
		        }
		        component.set("v.itemToUpdate", itemToUpdate);
		        //_utils.debug("itemToUpdate: ",itemToUpdate);  
		    	
		    	var changeAttributeEvent = 	$A.get("e.NE:Bit2win_Event_AttributeChanged");
					changeAttributeEvent.setParams({
						'itemChanged': itemToUpdate,
						'Context_Output':contextOutput
					});
			    											
			   changeAttributeEvent.fire(); 
			   component.set("v.Spinner", true);
			 }
	         else{
	        	 errMsg.innerHTML = 'Enter a valid value.';
	        	 event.target.value = '';
	        	 document.getElementById(event.target.id).classList.add("borderError");
	         }
	    }
	   //component.set("v.itemToUpdate", itemToUpdate);  
    },
 
    onChangeAttributeValueVASPickList: function(component, event, helper){
        //_utils.debug("into onChangeAttributeValueVASPicklist")
        
        var listOfItems = component.get("v.vasList");
        
        var attributeIndex = JSON.stringify(event.target.name); 
        //_utils.debug("attributeIndex: " + attributeIndex);
        var parentIndex = attributeIndex.substring(1, attributeIndex.indexOf('_')); 
        //_utils.debug("parentIndex: " + parentIndex);
       // var firstIndex = event.currentTarget.getAttribute('data-item'); 
       // //_utils.debug("listOfItems[firstIndex].childItems: " + JSON.stringify(listOfItems[firstIndex].childItems));
        //_utils.debug("vasList: " ,listOfItems);
        
        var vas1 = attributeIndex.indexOf("_")+1;
        var length1 = attributeIndex.indexOf("_", vas1)-1;
        var tempStr = attributeIndex.substr(length1);
        attributeIndex = tempStr.substr(0,tempStr.indexOf('_'));
        //attributeIndex = parseInt(attributeIndex.split('_').pop());
        
        var itemToUpdate = listOfItems[parseInt(parentIndex)];
        var contextOutput = component.get("v.contextOutput");
        itemToUpdate.listOfAttributes[attributeIndex].fields.value =  event.target.value;
        ////_utils.debug("attribute changed: " +itemToUpdate.listOfAttributes[attributeIndex] );
        
        component.set("v.itemToUpdate", itemToUpdate);
       // //_utils.debug("itemToUpdate: ",itemToUpdate);  
    	
    	var changeAttributeEvent = 	$A.get("e.NE:Bit2win_Event_AttributeChanged");
			changeAttributeEvent.setParams({
				'itemChanged': itemToUpdate,
				'Context_Output':contextOutput
			});
	    											
	   changeAttributeEvent.fire(); 
	   component.set("v.Spinner", true);
    },

      checkout: function(component, event, helper){
		// Daniele Gandini <daniele.gandini@accenture.com> - 19/06/2019 - Logic for maintenance remove case added - START
		var isReplacement = component.get("v.objectDataMap.isReplacement");
		var isOperationLogged = component.get("v.isOperationLogged");
		var dateError = component.get("v.dateError");
		// Daniele Gandini <daniele.gandini@accenture.com> - 19/06/2019 - Logic for maintenance remove case added - END
    	var isOk = helper.checkRequiredInputs(component);  
    	var goToCheckout = true;
    	var mapItemIdSuccessTerminalCall = component.get("v.mapItemIdSuccessTerminalCall");
		
		//davide.franzini - RI-99 - 13/06/2019 - START
		var cartToCheck = component.get("v.contextOutput");
		var numberTerminalsToCheck = 0;
		var checkedTerminals = 0;

		for(var i=0; i<cartToCheck.cart.length; i++){
			var item = cartToCheck.cart[i];
			for(var j=0; j<item.listOfAttributes.length;j++){
				var att = item.listOfAttributes[j];
				if(att.fields.name == 'Terminal Id' && item.fields.action == 'Add'){
					numberTerminalsToCheck = numberTerminalsToCheck + 1;
				}
			}
		}

		var terminalsToCheck = component.get("v.terminalsToCheck");
    	if(terminalsToCheck != null && terminalsToCheck.length>0){		
			for(var i = 0; i< terminalsToCheck.length; i++){
				for(var j = 0; j<terminalsToCheck[i].listOfAttributes.length;j++){
					var att = terminalsToCheck[i].listOfAttributes[j];
					if(att.fields.name == 'Terminal Id'){
						checkedTerminals = checkedTerminals + 1;
						if($A.util.isEmpty(att.fields.value) || (checkedTerminals != numberTerminalsToCheck)){
							goToCheckout = false;
						}else{
							goToCheckout = true; 
						}
					}
				}
			}
		}else if(terminalsToCheck.length != numberTerminalsToCheck){
			goToCheckout = false;
		}
		//davide.franzini - RI-99 - 13/06/2019 - END

		if(goToCheckout){
    		//check mapItemIdSuccessTerminalCall;
    		for(var key in mapItemIdSuccessTerminalCall){
    			if(!mapItemIdSuccessTerminalCall[key]){
    				//_utils.debug("SuccessTerminalCall - false! do not checkout!");
    				goToCheckout = false;
    			}
    		}
    	}
		var siaIsValid = component.get("{!v.siaIsValid}");//[13-03-2019 Manage Rac Sia Code] Andrea Saracini
		//START [08-05-2019 No Card Present Server2Server] Andrea Saracini
		var itemServer2Server = component.get("v.server2serverList");
		var isServer2ServerVailid = true;
		var attrRequired = [];
        
        for(var j=0; j<itemServer2Server.length; j++){
            var item = itemServer2Server[j].listOfAttributes;
            for(var i=0; i<item.length; i++){
                if(item[i].fields.required == 'Yes' && (item[i].fields.value == '' || item[i].fields.value == null)){
                    attrRequired.push(item[i].fields.required);
                }
            }
        }      
        if(!$A.util.isEmpty(attrRequired)){
            isServer2ServerVailid = false;
		}
		//STOP [08-05-2019 No Card Present Server2Server] Andrea Saracini

		//START gianluigi.virga 25/07/2019 - PRODOB-161 - Added simCardIsValid condition in the if statement only when simCard is visible and not filled for at least one pos
		var listOfItems = component.get("v.posList");
		var simCardIsValid = true;
		var thirdPartyPropertyIsValid = true;
		for(var i = 0; i < listOfItems.length; i++){
			var currentPos = listOfItems[i];
			for(var j = 0; j < currentPos.listOfAttributes.length; j++){
				if(currentPos.listOfAttributes[j].fields.name == $A.get("$Label.c.OB_SimCard") && currentPos.listOfAttributes[j].fields.action != $A.get("$Label.c.OB_ActionNone")
						&& (currentPos.listOfAttributes[j].fields.simCardIsValid == undefined 
						|| currentPos.listOfAttributes[j].fields.simCardIsValid == null 
						|| currentPos.listOfAttributes[j].fields.simCardIsValid == ''
						|| currentPos.listOfAttributes[j].fields.simCardIsValid == false)){
					simCardIsValid = false;
				}
				if(currentPos.listOfAttributes[j].fields.name == $A.get("$Label.c.OB_Property")
						&& currentPos.fields.categoryname == $A.get("$Label.c.OB_TerminaliTerzi")
						&& currentPos.listOfAttributes[j].fields.action != $A.get("$Label.c.OB_ActionNone")
						&& (currentPos.listOfAttributes[j].fields.thirdPartyPropertyIsValid == undefined 
						|| currentPos.listOfAttributes[j].fields.thirdPartyPropertyIsValid == null 
						|| currentPos.listOfAttributes[j].fields.thirdPartyPropertyIsValid == ''
						|| currentPos.listOfAttributes[j].fields.thirdPartyPropertyIsValid == false)){
					thirdPartyPropertyIsValid = false;
				}
			}
		}
		// Daniele Gandini <daniele.gandini@accenture.com> - 17/05/2019 - TerminalsReplacement - added dateError condition - START
		var isValideCheckOut = (goToCheckout && isOk && siaIsValid && isServer2ServerVailid && simCardIsValid && thirdPartyPropertyIsValid);
		// Daniele Gandini <daniele.gandini@accenture.com> - 17/05/2019 - TerminalsReplacement - added dateError condition - END
		//END gianluigi.virga 25/07/2019 - PRODOB-161

		// Daniele Gandini <daniele.gandini@accenture.com> - 19/06/2019 - Logic for maintenance remove case added - START
		var isNoteOK = component.get("v.isNoteOK");
		var modificaOfferta = component.get("v.isModificaOfferta"); 
		var itemsInRemove = component.get("v.itemsInRemove");
		var modificaOffertaAndRemove = (modificaOfferta && itemsInRemove);
	
		if(isValideCheckOut && modificaOffertaAndRemove && !dateError && isNoteOK){
			var checkPenalty = 	$A.get("e.NE:Bit2win_Event_ApplyPenalty");
	        checkPenalty.setParams({
	            'action' 	: 	'checkout'
	        });
	        checkPenalty.fire();
			component.set("v.checkoutPerformance", Date.now());												  
	        component.set("v.requestCheckout",true); 
			component.set("v.Spinner",true); 
		}else if(isValideCheckOut && !modificaOffertaAndRemove){
		// Daniele Gandini <daniele.gandini@accenture.com> - 19/06/2019 - Logic for maintenance remove case added - END
			var checkPenalty = 	$A.get("e.NE:Bit2win_Event_ApplyPenalty");
	        checkPenalty.setParams({
	            'action' 	: 	'checkout'
	        });
			//_utils.debug('FIRE EVENT __Bit2win_Event_ApplyPenalty');
	        checkPenalty.fire();
	        //16/04/19 francesca.ribezzi setting attribute to calculate checkout performance:
			component.set("v.checkoutPerformance", Date.now());												  
	        component.set("v.requestCheckout",true); 
			//console.log('REQUEST_CHECKOUT: ' + component.get('v.requestCheckout'));
			component.set("v.Spinner",true); 
		}else{
			//console.log('ISNT_CHECKOUT');
        	var errorMessage = $A.get("$Label.c.OB_ErrorBannerRequiredFields");
        	helper.showErrorToast(component, event, errorMessage);
        }
    },
    
    /* NEW STUFF */
  	fieldCheck : function(component, event, helper) // onchange
	{
		// 25-09-2018-Salvatore P.-Check if fields are of max length and focus on next input
		var inputId 		= event.getSource().getLocalId();
		var inputValue 		= component.find(inputId).get("v.value");
		var maxLengthInput 	= component.find(inputId).get("v.maxlength");
		//_utils.debug("MAXLENGHT: "+maxLengthInput);

		try
		{
			inputValue=inputValue.toUpperCase();
		}
		catch(err)
		{
			//_utils.debug('err.message: ' + err.message);
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
		//_utils.debug("INPUD ID: "+inputId);
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
		//_utils.debug("iban length: "+ibanLength);
		
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
					//_utils.debug("errorIdValidation . " + errorIdValidation);
					document.getElementById(errorIdValidation).remove();
				}
				//_utils.debug("control if fields value is null (onblur)");
				$A.util.addClass(component.find(inputId) , 'slds-has-error');
				errorCustomLabel = $A.get("$Label.c.MandatoryField");
				//_utils.debug("ERROR CUSTOM Label: "+errorCustomLabel);
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
					//_utils.debug("errorID . " + errorId);
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
					//_utils.debug("errorID . " + errorId);
					document.getElementById(errorId).remove();
				}
				component.set("v.objectDataMap.BillingProfilePOS.OB_EuroControlCode__c", inputValue);
				//_utils.debug("euroControlCode value in object data map:  ",component.get("v.objectDataMap.BillingProfilePOS.OB_EuroControlCode__c"));
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
					//_utils.debug("errorIdValidation . " + errorIdValidation);
					document.getElementById(errorIdValidation).remove();
				}
				//_utils.debug("control if fields value is null (onblur)");
				$A.util.addClass(component.find(inputId) , 'slds-has-error');
				errorCustomLabel = $A.get("$Label.c.MandatoryField");
				//_utils.debug("ERROR CUSTOM Label: "+errorCustomLabel);
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
					//_utils.debug("errorID . " + errorId);
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
					//_utils.debug("errorID . " + errorId);
					document.getElementById(errorId).remove();
				}
				component.set("v.objectDataMap.BillingProfilePOS.OB_CINCode__c", inputValue);
				//_utils.debug("cin value in object data map:  ",component.get("v.objectDataMap.BillingProfilePOS.OB_CINCode__c"));
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
					//_utils.debug("errorIdValidation . " + errorIdValidation);
					document.getElementById(errorIdValidation).remove();
				}
				//_utils.debug("control if fields value is null (onblur)");
				$A.util.addClass(component.find(inputId) , 'slds-has-error');
				errorCustomLabel = $A.get("$Label.c.MandatoryField");
				//_utils.debug("ERROR CUSTOM Label: "+errorCustomLabel);
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
					//_utils.debug("errorID . " + errorId);
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
					//_utils.debug("errorID . " + errorId);
					document.getElementById(errorId).remove();
				}
				component.set("v.objectDataMap.BillingProfilePOS.OB_ABICode__c", inputValue);
				//_utils.debug("abi value in object data map:  ",component.get("v.objectDataMap.BillingProfilePOS.OB_ABICode__c"));
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
					//_utils.debug("errorIdValidation . " + errorIdValidation);
					document.getElementById(errorIdValidation).remove();
				}
				//_utils.debug("control if fields value is null (onblur)");
				$A.util.addClass(component.find(inputId) , 'slds-has-error');
				errorCustomLabel = $A.get("$Label.c.MandatoryField");
				//_utils.debug("ERROR CUSTOM Label: "+errorCustomLabel);
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
					//_utils.debug("errorID . " + errorId);
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
					//_utils.debug("errorID . " + errorId);
					document.getElementById(errorId).remove();
				}
				component.set("v.objectDataMap.BillingProfilePOS.OB_CABCode__c", inputValue);
				//_utils.debug("cab value in object data map:  ",component.get("v.objectDataMap.BillingProfilePOS.OB_CABCode__c"));
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
					//_utils.debug("errorIdValidation . " + errorIdValidation);
					document.getElementById(errorIdValidation).remove();
				}
				//_utils.debug("control if fields value is null (onblur)");
				$A.util.addClass(component.find(inputId) , 'slds-has-error');
				errorCustomLabel = $A.get("$Label.c.MandatoryField");
				//_utils.debug("ERROR CUSTOM Label: "+errorCustomLabel);
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
					//_utils.debug("errorID . " + errorId);
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
				//_utils.debug("errorID . " + errorId);
				document.getElementById(errorId).remove();
			}
			component.set("v.objectDataMap.BillingProfilePOS.OB_Bank_Account_Number__c", inputValue);
			//_utils.debug("bankAccountNumber value in object data map:  ",component.get("v.objectDataMap.BillingProfilePOS.OB_Bank_Account_Number__c"));
			if(ibanLength == 27)
			{
				helper.validateIban(component,event,helper,inputId);
			}
		}
		else if(inputId == 'headerInternational')
		{
			component.set("v.objectDataMap.BillingProfilePOS.OB_HeaderInternational__c", inputValue);
			var typeInputValue = false;
			if(/^[a-zA-Z0-9()""?!&% $£=^ °\/\\.'']+$/.test(inputValue))
			{
				typeInputValue = true;
			}
			if(!inputValue)
			{				
				if(document.getElementById(errorIdValidation))
				{
					document.getElementById(errorIdValidation).remove();
				}
			$A.util.addClass(component.find(inputId) , 'slds-has-error');
			errorCustomLabel = $A.get("$Label.c.MandatoryField");
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
					document.getElementById(errorId).remove();
				}
				component.set("v.objectDataMap.BillingProfilePOS.OB_HeaderInternational__c", inputValue);
			}
		}
	},

	setPickListValue : function(component,event,helper)
	{	var currentId = event.getSource().getLocalId();
		// 25-09-2018-Salvatore P.-Set of picklist value
		component.set("v.objectDataMap.Configuration.OB_Report_Type__c", component.get("v.objectDataMap.OrderHeader.OB_Report_Type__c"));
		$A.util.removeClass(component.find(currentId) , 'slds-has-error');
        //RECREATE THE SAME ID OF ERROR MESSAGE
        var errorId = 'errorId'+ currentId;
        if(document.getElementById(errorId)!=null){
            document.getElementById(errorId).remove();
        }
	},

	setRedBorderoperationalData: function(component, event, helper) 
	{
	 	helper.setRedBorderHelper(component,event,helper);
	},
	
	/* START 	micol.ferrari 01/10/2018 - CREATION OF BILLING PROFILES */
	confirmCreationBillingProfiles: function(component, event, helper) 
	{
		try{
			helper.confirmCreationBillingProfilesHelper(component,event,helper);
		}catch(err){
			console.log('ERROR_MESSAGE_CALL_HELPER: ' + 	err.message);
		}
		
	},
	/* END	 	micol.ferrari 01/10/2018 - CREATION OF BILLING PROFILES */
	
	picklistPrepagatoChange: function(component, event, helper) {
		var currentId = event.getSource().getLocalId();
		var postPagatoValue = component.get("v.settMethodPostPagatoValue");
		component.set("v.objectDataMap.Configuration.OB_PBSettlementMethod__c", postPagatoValue);
		component.set("v.objectDataMap.Configuration.OB_InternationalSettlementMethod__c", postPagatoValue);
		$A.util.removeClass(component.find(currentId) , 'slds-has-error');
        //RECREATE THE SAME ID OF ERROR MESSAGE
        var errorId = 'errorId'+ currentId;
        if(document.getElementById(errorId)!=null){
            document.getElementById(errorId).remove();
        }
	},
	removeRedBorder: function (component, event , helper){
       
        helper.removeRedBorder(component, event , helper);
    },
    
    notBlank: function (component, event , helper){
    	var dateValue = event.getSource().get("v.value");
    	var currentId = event.getSource().getLocalId();
    	if(!dateValue){
    		component.find(currentId).set("v.value", component.get("v.orderCreatedDate"));
    	} else {
    		 helper.removeRedBorderDate(component, event , helper);
    	}
    },
    
    //francesca.ribezzi -  checking if the value is a terminal id and if it is correct:
  /*  checkInputValue: function(component, event, helper) {
    	//_utils.debug("into checkInputValue");
    	var value = event.target.value;//event.getSource().get("v.value");
    	var attributeIndex = JSON.stringify(event.target.id); 
        var listOfItems = component.get("v.posList");
        var parentIndex = document.getElementById(event.target.id).name;
        //_utils.debug("parentIndex: " + parentIndex);
        var pos1 = attributeIndex.indexOf("_")+1;
        var length1 = attributeIndex.indexOf("_",pos1)-1;
        var tempStr = attributeIndex.substr(length1);
        attributeIndex = tempStr.substr(0,tempStr.indexOf('_'));
        var attName = document.getElementById(attributeIndex+'_attName').textContent;
        var itemToUpdate = listOfItems[parentIndex];
        var errMsg= document.getElementById(event.target.id+'_ErrorTerminalId');
        //checking if this is the terminal id: 
	 //   if(value.length > 2){
	    	if(value.length != 8){
	    		errMsg.innerHTML= 'Terminal ID must be 8 characters long.';
	    	}
	  //  }
		
    },*/
    onChangeAttributeValueTerminalId: function(component, event, helper){
    	//_utils.debug("into onChangeAttributeValueTerminalId");
    	var attributeIndex = JSON.stringify(event.target.id); 
    	//francesca.ribezzi - new list composed by vas and pos with terminal ids:
        var listOfItems = component.get("v.terminaIdItemsList");//component.get("v.posList");
        var parentIndex = document.getElementById(event.target.id).name;
        //_utils.debug("parentIndex: " + parentIndex);
        var pos1 = attributeIndex.indexOf("_")+1;
        var length1 = attributeIndex.indexOf("_",pos1)-1;
        var tempStr = attributeIndex.substr(length1);
        var mapItemIdSuccessTerminalCall = component.get("v.mapItemIdSuccessTerminalCall");
        
        attributeIndex = tempStr.substr(0,tempStr.indexOf('_'));//firstIndex+'_'+index+'_POS'
    
        //_utils.debug("attributeIndex : " + attributeIndex);
        
        //RESET Error Message if updating terminal ID
        var attName = document.getElementById(attributeIndex+'_attName').textContent;
        var itemToUpdate = listOfItems[parentIndex];
        var errMsg= document.getElementById(event.target.id+'_ErrorTerminalId');
        //checking if this is the terminal id: 

	    var contextOutput = component.get("v.contextOutput");

        //francesca.ribezzi - removing error class from input:
	     var inputValue = event.target.value;
	         if(/^[0-9]*([,][0-9]{1,3}|)$/.test(event.target.value)){ 
		        if(inputValue.length == 8){
		        	document.getElementById(event.target.id).classList.remove("borderError");
		        	itemToUpdate.listOfAttributes[attributeIndex].fields.value =  event.target.value;
			        component.set("v.itemToUpdate", itemToUpdate);
			        //_utils.debug("itemToUpdate: ",itemToUpdate);  
			    	//moving this logic to success response of callService method!
			    	/*var changeAttributeEvent = 	$A.get("e.NE:Bit2win_Event_AttributeChanged");
						changeAttributeEvent.setParams({
							'itemChanged': itemToUpdate,
							'Context_Output':contextOutput
						});
				    											
				   changeAttributeEvent.fire(); */
				   errMsg.innerHTML = '';
				  // component.set("v.Spinner", true);
			     }else{
			    	 if(inputValue.length == 0){
			    		 errMsg.innerHTML = '';
				    	 document.getElementById(event.target.id).classList.remove("borderError");
			    	 }else{
				    	 errMsg.innerHTML = $A.get("$Label.c.OB_EightCharError");
				    	 document.getElementById(event.target.id).classList.add("borderError");
				    }
			     }
			     

	         }
	         else{
	        	 var errorMessage = $A.get("$Label.c.OB_invalidValue");
	        	 errMsg.innerHTML = errorMessage;
	        	 //event.target.value = '';
	        	 document.getElementById(event.target.id).classList.add("borderError");
	         }
	         
	     mapItemIdSuccessTerminalCall[itemToUpdate.fields.id] = false;
	     //_utils.debug("mapItemIdSuccessTerminalCall: ", mapItemIdSuccessTerminalCall);
	     component.set("v.mapItemIdSuccessTerminalCall", mapItemIdSuccessTerminalCall);
	},
	goNextStep: function(component, event, helper){
		// //console.log('handler_next');
		// component.set("v.objectDataMap.unbind.goToNextStepSocieta", 'goToSocieta');
		// component.set("v.Spinner",false); 
	},

	/*handleAfterRestart: function(component, event, helper){
		var bitwinMap = event.getParam("bitwinMap");

	    if($A.util.isEmpty(bitwinMap)){
			component.set("v.methodDone", true); 
		}

	},*/
	//D.F. _ 26-03-2019 ManageRacSia v4 _ START
	showIbanSelModal: function(component, event, helper) {
    	component.set("v.showIbanSelModal", true);
    },
	closeIbanSelModal: function(component, event, helper) {
		component.set("v.showIbanSelModal",false);		
	},
	getSelectedIBAN: function(component, event, helper) {
        component.set("v.Spinner", true);
        helper.getSelectedOption(component, event);
	},
	//D.F. _ END
})