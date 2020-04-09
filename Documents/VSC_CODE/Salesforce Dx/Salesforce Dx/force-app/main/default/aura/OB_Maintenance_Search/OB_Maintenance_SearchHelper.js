({
	toggleSpinner: function (component) {        
		var spinner = component.find("spinnerComponent");
		console.log( 'spinner ' + spinner);
		$A.util.removeClass(spinner, "slds-show");
    	$A.util.addClass(spinner, "slds-hide"); 
		console.log( 'called ' + spinner);
	},

	 getCurrentUser : function(component) {
		//set up Action
		var action = component.get('c.isInternalUSer');
		
		//enqueue Action
		action.setCallback(this, $A.getCallback(function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var valueReturns = response.getReturnValue();
				console.log(' method response is '+valueReturns);
				component.set('v.InternalUser', ''+response.getReturnValue());
			} else if (state === "ERROR") {
				var errors = response.getError();
				console.error(errors);
			}
		}));
		$A.enqueueAction(action);
	},
	checkenableButton :  function(component, event, helper){
		console.log('checkenableButton START');
		var myInputs = component.find("MainDiv").find({instancesOf : "lightning:input"});
		var oneFieldFilled= false;
		var oneFieldNotValid= false;
		for(var i = 0; i < myInputs.length; i++){
			console.log(myInputs[i]);
			var valore = myInputs[i].get("v.value");
			var validity = myInputs[i].get("v.validity").valid;
			if(valore)
				oneFieldFilled = true;
			if(!validity)
				oneFieldNotValid = true;
			console.log('valore is '+valore);
			console.log('validity is '+validity);
		   // myInputs[i].set('v.disabled',dis);
		}
		var button = component.find ("SearchButton");
		console.log('oneFieldFilled is '+oneFieldFilled);
		console.log('oneFieldNotValid is '+oneFieldNotValid);

		if( oneFieldFilled && !oneFieldNotValid){
			button.set('v.disabled',false);
			
		}
		else{
			button.set('v.disabled',true);
			
		}
		/*var disabledFields = component.get('v.DisabledFields');
		for(var i in disabledFields){
			component.find(disabledFields[i]).set('v.disabled',true);
		}*/
	},
  
	validateFiscalCode : function(component) {return true;},
	validateVatNumber : function(component) {return true;},
	validateABI : function(component) {return true;},

	showToast: function (component, event, helper,title, message, type) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			"title": title,
			"message": message,
			"type": type
		});
		toastEvent.fire();
	},

	/*
		*	History	:	Morittu Andrea - Added incoming parameter to helper method 
	*/
	performSearchOnServer : function(component, event, helper, wrapper, multipleAccountObj ){
	console.log('performSearchOnServer start');
	console.log('performSearchOnServer wrapper is '+wrapper);
	//START francesca.ribezzi 22/03/19 show spinner
    var spinner = component.find("spinnerComponent");
    $A.util.removeClass(spinner, "slds-hide");
    $A.util.addClass(spinner, "slds-show");
    //END 
	try{
		var action = component.get('c.search');
		action.setParams({ 
			"jsonWrap" : wrapper
		});
		action.setCallback(this, $A.getCallback(function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var valueReturns = response.getReturnValue();
				console.log('performSearchOnServer --> '+valueReturns);
				var result = JSON.parse( valueReturns );
				if(result.outcome == $A.get("$Label.c.OB_MAINTENANCE_NOERROR")){
					console.log('no error on outcome');
					var userWrapper = {};
					var L2 = component.get("v.isL2Profile");
					var L3 = component.get("v.isL3Profile");
					if(!L2 && !L3){
						userWrapper.cab = component.get("v.UserWrapper.userCAB");	
						console.log("cab if L2 or L3" + userWrapper.cab);
					}else{
						userWrapper.cab = component.get("v.selectedCab");	
						console.log("cab if L1 or user" + userWrapper.cab);
					}	
					// if(component.get("v.selectedCab" == null) || component.get("v.selectedCab") == ''){
					// 	this.showToast(component, event, helper, $A.get("$Label.c.OB_MAINTENANCE_TOASTERROR"), $A.get("$Label.c.CAB") , "Missing Field");
					// }

					/* START MORITTU ANDREA - 27-Aug-2019 - UX.194 - Adding new input maintenance search */
					if(!$A.util.isUndefined(result.accountIds) && (result.accountIds).length > 1 && (!multipleAccountObj.merchantIsSelected && $A.util.isUndefinedOrNull(result.acc) )  ) {
						let assetFilters = component.get('v.assetFilters');
						console.log('Asset filters are : ' + assetFilters );
						let flowData = JSON.parse(valueReturns);
						/**
						 *  giovanni spinelli 26/09/2019 - start 
						 * store information  about how I made search
						 * if is FC or VAT 
						 */
						this.storeFilter( component );
						//giovanni spinelli  26/09/2019 - end
						

						let retrieveObjectLabel_Server = component.get('c.retrieveObjectFieldsDetails');
						let objectType = 'Account';
						retrieveObjectLabel_Server.setParams( { objectType : objectType});
						Promise.all([
							helper.retrieveObjectLabel(component, retrieveObjectLabel_Server, objectType),
						]).then(function(response) {
								console.log('responseArray is : ' + response);
								
								var tableData = component.get('v.tableData');
								component.set('v.tableAccountsData', result.accountList);
								//SETTING HEADER OF DYNAMIC TABLE
								component.set('v.columnsMultipleAccounts', response[0]);
								component.set('v.showAccountsModal', true);
								helper.toggleSpinner(component);
								
							} 
						).catch(
							function(error) {
								component.set("v.status" ,error ) ; 
								console.log(error);
							}
						);


						helper.createPreMaintenanceModal(component, event, helper, assetFilters, result.accountIds);
					} else {
					/* END MORITTU ANDREA - 27-Aug-2019 - UX.194 - Adding new input maintenance search */
						component.set("v.FlowData",valueReturns);
						var flowData = JSON.parse(component.get("v.FlowData"));
						/**
						 *  giovanni spinelli 26/09/2019 - start 
						 * store information  about how I made search
						 * if is FC or VAT 
						 */
						this.storeFilter( component );
						//giovanni spinelli  26/09/2019 - end
						flowData['userWrapper'] = userWrapper;
						component.set("v.FlowData",JSON.stringify(flowData));
						console.log('@@@# FlowData: ' , component.get("v.FlowData"));
						component.set("v.FlowStep", $A.get("$Label.c.OB_MAINTENANCE_STEP_SUMMARY"));
						//console.log(  component.find("OB_Maintenance_Summary"));
						//SAVE FILTERS TO ASSET COMPONENT
						var SIACode          =  component.find("SIACode").get('v.value');
						var SiaEstablishment =  component.find("SiaEstablishment").get('v.value');
						var TerminalId       =  component.find("TerminalId").get('v.value');
						//START Andrea Saracini 18/03/2019 Card No Present
						var url       =  component.find("url").get('v.value');
						var app       =  component.find("app").get('v.value');
						//STOP Andrea Saracini 18/03/2019 Card No Present
						/* START MORITTU ANDREA - 27-Aug-2019 - UX.194 - Adding new input maintenance search */
						var businessName       =  component.find("merchantBusinessName").get('v.value');
						/* END MORITTU ANDREA - 27-Aug-2019 - UX.194 - Adding new input maintenance search */
						var assetFilters     = {};
						assetFilters.SIACode = SIACode;
						assetFilters.SiaEstablishment = SiaEstablishment;
						assetFilters.TerminalId = TerminalId;
						//START Andrea Saracini 18/03/2019 Card No Present
						assetFilters.url = url;
						assetFilters.app = app;
	
						/* START MORITTU ANDREA - 27-Aug-2019 - UX.194 - Adding new input maintenance search */
						assetFilters.businessName = businessName;
						/* END MORITTU ANDREA - 27-Aug-2019 - UX.194 - Adding new input maintenance search */
						
						//STOP Andrea Saracini 18/03/2019 Card No Present
						component.set('v.assetFilters'          , assetFilters);
						//START francesca.ribezzi 22/03/19 remove spinner
			         	$A.util.removeClass(spinner, "slds-show");
			         	$A.util.addClass(spinner, "slds-hide");
			         	//END
						console.log('ASSET FILTERS: ' + JSON.stringify(assetFilters));
					}
					/* END MORITTU ANDREA - 27-Aug-2019 - UX.194 - Adding new input maintenance search */

					
				}
				else{
					console.log('error on outcome'); 
					//giovanni spinelli remove toast 02/10/2019
					//this.showToast(component, event, helper,$A.get("$Label.c.OB_MAINTENANCE_TOASTERROR"), result.errorMessage, "error");
					//this.toggleSpinner(component);//START Andrea Saracini 18/03/2019 Card No Present
					//START francesca.ribezzi 22/03/19 remove spinner
					$A.util.removeClass(spinner, "slds-show");
					$A.util.addClass(spinner, "slds-hide");
					//END 
					//giovanni spinelli - start - 27/09/2019 -open modal if no merchant was found
					component.set('v.showModalFlow' , true);
					//giovanni spinelli - end - 27/09/2019
					
					
				}
				//component.set('v.InternalUser', response.getReturnValue());
			} else if (state === "ERROR") {
				var errors = response.getError();
				console.error(errors);
				//START francesca.ribezzi 22/03/19 remove spinner
				$A.util.removeClass(spinner, "slds-show");
				$A.util.addClass(spinner, "slds-hide");
				//END
			}
		}));
		$A.enqueueAction(action);   
		}catch(err) {
				console.log ('SEARCH ERROR EXCEPTION:'+ err);
		} 
	},

	/* START MORITTU ANDREA - 27-Aug-2019 - UX.194 - Added incoming parameter to helper method */
	performSearch : function(component, event, helper,  multipleAccountObj){
		console.log('performSearch start');
		// DG - 02/04/19 - Check on CAB field
		var L2 = component.get("v.isL2Profile");
		var L3 = component.get("v.isL3Profile");
		var CABfilled = component.get("v.selectedCab");
		if((L2 || L3) && (CABfilled == null || CABfilled == "" || CABfilled == undefined)){
			this.showToast(component, event, helper,$A.get("$Label.c.OB_MAINTENANCE_TOASTERROR"), $A.get("$Label.c.OB_MAINTENANCE_MISSING_CAB") , "error");
		}else{
			//28/01/19 francesca.ribezzi - spinner must be on
		    var spinner = component.find("spinnerComponent");
		    $A.util.removeClass(spinner, "slds-hide");
		    $A.util.addClass(spinner, "slds-show"); 
		    //  console.log( 'spinner ' + spinner);
		    //  $A.util.toggleClass(spinner, "slds-hide"); 
			/* START MORITTU ANDREA - 27-Aug-2019 - UX.194 - Adding new input maintenance search */
			if(!$A.util.isEmpty(multipleAccountObj)) {
				component.find("AccountName").set('v.value', multipleAccountObj.fiscalCode);
			} 
			/* END MORITTU ANDREA - 27-Aug-2019 - UX.194 - Adding new input maintenance search */
			var AccountName      =  component.find("AccountName").get('v.value');
			// antonio.vatrano wn-417 17/09/2019 remove codes 
			var VatNumber        =  component.find("VatNumber").get('v.value');
			var ServicePoint     =  component.find("ServicePoint").get('v.value');
			var SIACode          =  component.find("SIACode").get('v.value');
			var SiaEstablishment =  component.find("SiaEstablishment").get('v.value');
			var TerminalId       =  component.find("TerminalId").get('v.value');
			//START Andrea Saracini 18/03/2019 Card No Present
			var url =  component.find("url").get('v.value');
			var app =  component.find("app").get('v.value');
			//STOP Andrea Saracini 18/03/2019 Card No Present

			//START MORITTU ANDREA 26-Aug-2019 - UX.194 - Adding new searchable input
			let businessAccountName =  component.find("merchantBusinessName").get('v.value');
			//END MORITTU ANDREA 26-Aug-2019 - UX.194 - Adding new searchable input
			
			var InternalUser = component.get("v.InternalUser");  
			var MoneticaCustomerCode;
			var MoneticaEstablishmentCode;
			var ABI;
			if( InternalUser == true || InternalUser =='true'){
				MoneticaCustomerCode =  component.find("MoneticaCustomerCode").get('v.value');
				MoneticaEstablishmentCode =     component.find("MoneticaEstablishmentCode").get('v.value');
				ABI =   component.find("ABI").get('v.value');
			}

			var validationResult1 = true;
			var validationResult2 = true;
			var validationResult3 = true;
			//START Andrea Saracini 18/03/2019 Card No Present: add APP and URL attributes in the 'wrapper' 
			//var wrapper = {AccountName:AccountName, VatNumber:VatNumber, ServicePoint:ServicePoint,SIACode : SIACode, SiaEstablishment: SiaEstablishment,TerminalId: TerminalId,MoneticaCustomerCode : MoneticaCustomerCode, MoneticaEstablishmentCode : MoneticaEstablishmentCode, ABI : ABI };
			/* START MORITTU ANDREA - 27-Aug-2019 - UX.194 - Added wrapper's variable */
			var wrapper = {AccountName:AccountName, VatNumber:VatNumber, ServicePoint:ServicePoint,SIACode : SIACode, SiaEstablishment: SiaEstablishment,TerminalId: TerminalId, url: url, app: app, MoneticaCustomerCode : MoneticaCustomerCode, MoneticaEstablishmentCode : MoneticaEstablishmentCode, ABI : ABI, businessAccountName:businessAccountName, selectedMerchantId : multipleAccountObj.merchantId };
			/* END MORITTU ANDREA - 27-Aug-2019 - UX.194 - Added wrapper's variable */
			//START Andrea Saracini 18/03/2019 Card No Present

			var JSONwrap =  JSON.stringify(wrapper);
			console.log('JSONwrap is '+JSONwrap);
			//GIOVANNI SPINELLI - IF I HAVE THE SIA ESTABLISHMENT AND NOT SIA CODE---> NO QUERY 
			if(!SIACode && SiaEstablishment){
				this.showToast(component, event, helper,$A.get("$Label.c.OB_MAINTENANCE_TOASTERROR"), $A.get("$Label.c.OB_MAINTENANCE_SIACODEERROR"), "error");		   
				//START francesca.ribezzi 22/03/19 remove spinner
		     	$A.util.removeClass(spinner, "slds-show");
		     	$A.util.addClass(spinner, "slds-hide");
		     	//END 
			}		
			else{
				//START Andrea Saracini 18/03/2019 Card No Present: add error message
				//Andrea Saracini 18/04/2019 RI-21 START 
				if((SIACode || TerminalId) && (url || app)){
					this.showToast(component, event, helper,$A.get("$Label.c.OB_MAINTENANCE_TOASTERROR"), $A.get("$Label.c.OB_MAINTENANCE_URLAPPERROR"), "error");
					$A.util.removeClass(spinner, "slds-show");
			     	$A.util.addClass(spinner, "slds-hide");
				}else{
					/* START MORITTU ANDREA - 27-Aug-2019 - UX.194 - Added wrapper's variable */
					this.performSearchOnServer(component, event, helper,JSONwrap, multipleAccountObj);
					/* END MORITTU ANDREA - 27-Aug-2019 - UX.194 - Added wrapper's variable */
				}
				//Andrea Saracini 18/04/2019 RI-21 START
				//START Andrea Saracini 18/03/2019 Card No Present
			}			
		}
	},
    // START Elena Preteni MAIN_62_R1F1
    getAbi : function(component, helper,event){
    	var actionAbi = component.get('c.getAbi');
	    actionAbi.setCallback(this, function (response) {
	        var state = response.getState();
	        console.log('STATE L2: ' + state);
	        if (state === "SUCCESS") 
	        {	
	            component.set('v.proposerABI',response.getReturnValue());
	            console.log('PROPOSER ABI --> '+component.get("v.proposerABI"));
	        }
	        else if (state === "ERROR") 
	        {
	                var errors = response.getError();
	                console.log(errors);
	        }
	    });
        $A.enqueueAction(actionAbi);
   	},
	// END Elena Preteni MAIN_62_R1F1
	//start elena.preteni 26/3/2019
	getFieldToShow : function(component, helper,event){
		var action = component.get('c.getInputToShow');
	    action.setCallback(this, function (response) {
	        var state = response.getState();
			console.log('STATE : ' + state);
			console.log('STATE response.getReturnValue(): ' + JSON.stringify(response.getReturnValue()));
	        if (state === "SUCCESS") 
	        {	
				var getInputResponse = response.getReturnValue();
				if (getInputResponse!=null)
				{
					for(var i=0;i<response.getReturnValue().length;i++){
						if(response.getReturnValue().includes('multiCAB')){
							component.set('v.isL2Profile',true);
						}else if(response.getReturnValue().includes('LOV')){
							component.set('v.isL3Profile',true);
						}
					}
				}	
				var actionValues =  component.get('c.getUserWrapper');
				actionValues.setCallback(this, function (response) {
					var state = response.getState();
					console.log('STATE actionValues: ' + state);
					console.log('STATE actionValues response.getReturnValue(): ' + JSON.stringify(response.getReturnValue()));
					if (state === "SUCCESS") 
					{	
						var parseObject = JSON.parse(response.getReturnValue());
						console.log('UserLogged: ' + response.getReturnValue());
						// DG - 29/93/19 - RP_019/20 - START
						component.set('v.userCAB', parseObject.userCAB);
						component.set('v.UserWrapper', parseObject);
						console.log('userWrapper: ' + JSON.stringify(component.get("v.UserWrapper")));
						// DG - 29/93/19 - RP_019/20 - END

					
					}
					else if (state === "ERROR") 
					{
							var errors = response.getError();
							console.log(errors);
					}
				});
				$A.enqueueAction(actionValues);
	        }
	        else if (state === "ERROR") 
	        {
	                var errors = response.getError();
	                console.log(errors);
	        }
	    });
        $A.enqueueAction(action);
	},
	//end elena.preteni 26/3/2019

	// DG - 28/03/2019 - R1F2_RP_019 - START
	getCabListFromLov : function (component, event, helper){
		var action = component.get('c.getCABbyLov');
	    action.setCallback(this, function (response) {
	        var state = response.getState();
			console.log('getCabList STATE : ' + state);
			console.log('STATE response.getCabList(): ' + JSON.stringify(response.getReturnValue()));
	        if (state === "SUCCESS") 
	        {	
				component.set("v.currentList", response.getReturnValue());
				// this.createComponent(component, event);
	        }
	        else if (state === "ERROR") 
	        {
	                var errors = response.getError();
	                console.log(errors);
	        }
	    });
        $A.enqueueAction(action);
	},

	createComponent : function(component, event) {
		console.log("userCab before createComponent: " + component.get("v.userCAB"));
		var cabValue = component.get("v.userCAB");
		var flowData = {};
		var userWrapper = {};
		userWrapper.cab = '';
		flowData['userWrapper'] = userWrapper;
		var ABIvalue = !$A.util.isEmpty(component.get("v.UserWrapper.userABI")) ?  component.get("v.UserWrapper.userABI") : null;
		var mapLabelColumns = {
			"Name" : "CAB"
		};
		var mapOfSourceFieldTargetField = {}; 
		mapOfSourceFieldTargetField['cab'] = 'Name';

		var columns = [];
		columns.push({"label": "CAB","fieldName" : "Name", "type": "text", "sortable": true});
		$A.createComponent(
			"c:modalLookupWithPagination",
			{
			"aura:id": "modal",
			// String with value 'CAB'
			"type":"CAB", 
			// String with value 'Tipologiche'
			'subType' : 'Tipologiche',
			// String with the ABI value of the logged user
			'ABIvalue' : ABIvalue,
			"mapLabelColumns":mapLabelColumns,
			// Colums for the datatable
			"mycolumns":columns,
			// String with the CAB value of the logged user, if present (empty for L3)
			"cabStringValues" : cabValue,
			// Boolean for entering in method getCabForApproverLevelServer in ModalLookupController.cls
			"searchLovs":false,
			"objectString":"userWrapper",
			// "input":component.get("v.objectDataMap.puntoVendita.OB_MCC_Description__c"),
			"mapOfSourceFieldTargetField":mapOfSourceFieldTargetField,
			"objectDataMap":flowData
			// "messageIsEmpty":'',
			// "orderBy":component.get("v.orderBy")
		},

		function(newModal, status, errorMessage){
			if (status === "SUCCESS") {
				var body = component.get("v.body");
				body.push(newModal);
				component.set("v.body", body);
			}
			else if (status === "INCOMPLETE") {
				console.log("No response from server or client is offline.")
			}
			else if (status === "ERROR") {
				console.log("Error: " + errorMessage);
			}
		}
		);
 	},

 // DG - 28/03/2019 - R1F2_RP_019 - START

	/* 
        *   Author      : Morittu Andrea
        *   Date        : 27/Aug/2019
        *   Description : Function Javascript retrieve account field details
    */
 retrieveObjectLabel : function(component, action, objectType) {
		return new Promise(function(resolve, reject) { 
            action.setCallback(this, function(response) {
				var state = response.getState();
				if (state === "SUCCESS") {
					var objectDetails = response.getReturnValue();
					resolve(objectDetails);
				} else {
					var error = new Error(response.getError());
					reject(error);
				}
			}); 
            $A.enqueueAction(action);
        });
	},

	searchOnServer : function(component, event, helper, merchantId) {
		var wrapper = {AccountName:AccountName, VatNumber:VatNumber, ServicePoint:ServicePoint,SIACode : SIACode, SiaEstablishment: SiaEstablishment,TerminalId: TerminalId, url: url, app: app, MoneticaCustomerCode : MoneticaCustomerCode, MoneticaEstablishmentCode : MoneticaEstablishmentCode, ABI : ABI, businessAccountName:businessAccountName  };
		try{
		var action = component.get('c.search');
		action.setParams({ 
			"jsonWrap" : wrapper
		});
		action.setCallback(this, $A.getCallback(function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var valueReturns = response.getReturnValue();
				console.log('performSearchOnServer --> '+valueReturns);
				var result = JSON.parse( valueReturns );
				if(result.outcome == $A.get("$Label.c.OB_MAINTENANCE_NOERROR")){
					console.log('no error on outcome');
					var userWrapper = {};
					var L2 = component.get("v.isL2Profile");
					var L3 = component.get("v.isL3Profile");
					if(!L2 && !L3){
						userWrapper.cab = component.get("v.UserWrapper.userCAB");	
						console.log("cab if L2 or L3" + userWrapper.cab);
					}else{
						userWrapper.cab = component.get("v.selectedCab");	
						console.log("cab if L1 or user" + userWrapper.cab);
					}	

					/* START MORITTU ANDREA - 27-Aug-2019 - UX.194 - Adding new input maintenance search */
					if(!$A.util.isUndefined(result.accountIds) && (result.accountIds).length > 1) {
						let assetFilters = component.get('v.assetFilters');
						console.log('Asset filters are : ' + assetFilters );
						let flowData = JSON.parse(valueReturns);
						console.log('### flowData is : ' + JSON.stringify(flowData));

						let retrieveObjectLabel_Server = component.get('c.retrieveObjectFieldsDetails');
						let objectType = 'Account';
						retrieveObjectLabel_Server.setParams( { objectType : objectType});
						Promise.all([
							helper.retrieveObjectLabel(component, retrieveObjectLabel_Server, objectType),
						]).then(function(response) {
								console.log('responseArray is : ' + response);
							if( (result.acc !=null || result.acc != undefined) && (result.accountIds).length > 1 ) {
								var tableData = component.get('v.tableData');
								component.set('v.tableAccountsData', result.accountList);
								//SETTING HEADER OF DYNAMIC TABLE
								component.set('v.columnsMultipleAccounts', response[0]);
								component.set('v.showAccountsModal', true);
								helper.toggleSpinner(component);
							}
						}).catch(
							function(error) {
								component.set("v.status" ,error ) ; 
								console.log(error);
							}
						);
	
	
						helper.createPreMaintenanceModal(component, event, helper, assetFilters, result.accountIds);
					} else {
							component.set("v.FlowData",valueReturns);
							var flowData = JSON.parse(component.get("v.FlowData"));
							flowData['userWrapper'] = userWrapper;
							component.set("v.FlowData",JSON.stringify(flowData));
							console.log('@@@# FlowData: ' , component.get("v.FlowData"));
							component.set("v.FlowStep", $A.get("$Label.c.OB_MAINTENANCE_STEP_SUMMARY"));
							//console.log(  component.find("OB_Maintenance_Summary"));
							//SAVE FILTERS TO ASSET COMPONENT
							var SIACode          =  component.find("SIACode").get('v.value');
							var SiaEstablishment =  component.find("SiaEstablishment").get('v.value');
							var TerminalId       =  component.find("TerminalId").get('v.value');
							//START Andrea Saracini 18/03/2019 Card No Present
							var url       =  component.find("url").get('v.value');
							var app       =  component.find("app").get('v.value');
							//STOP Andrea Saracini 18/03/2019 Card No Present
							// ANDREA MORITTU START 30/08/2019 - UX.194
							var businessName       =  component.find("merchantBusinessName").get('v.value');
							// ANDREA MORITTU END 30/08/2019 - UX.194
		
							var assetFilters     = {};
							assetFilters.SIACode = SIACode;
							assetFilters.SiaEstablishment = SiaEstablishment;
							assetFilters.TerminalId = TerminalId;
							//START Andrea Saracini 18/03/2019 Card No Present
							assetFilters.url = url;
							assetFilters.app = app;
		
							/* START MORITTU ANDREA - 27-Aug-2019 - UX.194 - Adding new input maintenance search */
							assetFilters.businessName = businessName;
							/* END MORITTU ANDREA - 27-Aug-2019 - UX.194 - Adding new input maintenance search */
							
							//STOP Andrea Saracini 18/03/2019 Card No Present
							component.set('v.assetFilters'          , assetFilters);
							//START francesca.ribezzi 22/03/19 remove spinner
				         	$A.util.removeClass(spinner, "slds-show");
				         	$A.util.addClass(spinner, "slds-hide");
				         	//END
							console.log('ASSET FILTERS: ' + JSON.stringify(assetFilters));
						}
						/* END MORITTU ANDREA - 27-Aug-2019 - UX.194 - Adding new input maintenance search */
	
						
					}
					else{
						console.log('error on outcome'); 
						this.showToast(component, event, helper,$A.get("$Label.c.OB_MAINTENANCE_TOASTERROR"), result.errorMessage, "error");
						//this.toggleSpinner(component);//START Andrea Saracini 18/03/2019 Card No Present
						//START francesca.ribezzi 22/03/19 remove spinner
						$A.util.removeClass(spinner, "slds-show");
						$A.util.addClass(spinner, "slds-hide");
						//END 
						
					}
					//component.set('v.InternalUser', response.getReturnValue());
				} else if (state === "ERROR") {
					var errors = response.getError();
					console.error(errors);
					//START francesca.ribezzi 22/03/19 remove spinner
					$A.util.removeClass(spinner, "slds-show");
					$A.util.addClass(spinner, "slds-hide");
					//END
				}
			}));
			$A.enqueueAction(action);   
		}catch(err) {
				console.log ('SEARCH ERROR EXCEPTION:'+ err);
		} 
	},
	
	/* 
        *   Author      : Morittu Andrea
        *   Date        : 27/Aug/2019
        *   Description : Function Javascript to clearInputMaintenanceSearch inpouts 
    */
	clearInputMaintenanceSearch : function (component, event, helper) {

			let AccountName      =  component.find("AccountName").set('v.value', '');
			let VatNumber        =  component.find("VatNumber").set('v.value', '');
			let ServicePoint     =  component.find("ServicePoint").set('v.value', '');
			let SIACode          =  component.find("SIACode").set('v.value', '');
			let SiaEstablishment =  component.find("SiaEstablishment").set('v.value', '');
			let TerminalId       =  component.find("TerminalId").set('v.value', '');
			let url 			=  component.find("url").set('v.value', '');
			let app 			=  component.find("app").set('v.value', '');
			let businessAccountName =  component.find("merchantBusinessName").set('v.value', '');
	},

	/* 
        *   Author      : Morittu Andrea
        *   Date        : 27/Aug/2019
        *   Description : Function Javascript to grab id and fiscal vode of mercahnt
    */
	selectionMerchant_Helper : function(component, event, helper) {
		var flowData = component.get('v.flowData');
		console.log('flowData IS : ' + flowData);
		var whichMerchant = event.currentTarget.id;
		console.log('Selected Merchant Id : ' + whichMerchant);
		let merchantId = whichMerchant.split('_')[0];
		var fiscalCode	=	whichMerchant.split('_')[1];
		var multipleAccountObj = {};
		multipleAccountObj.merchantIsSelected = true;
		multipleAccountObj.merchantId = merchantId;
		multipleAccountObj.fiscalCode = fiscalCode;
		multipleAccountObj.VatNumber = component.find;
		if(!$A.util.isUndefinedOrNull(whichMerchant)) {
			helper.performSearch(component, event, helper, multipleAccountObj);
		}
	},
	/**
	*@author Giovanni Spinelli <spinelli.giovanni@accenture.com>
	*@date 20/03/2018
	*@description 	Method get current url and store it in
					an attribute to pass in child component
	*@params -
	*@return set an attribute with url
	*/
	getUrl: function(component ){
		var myBaseURL, filter;
		var getBaseURL = component.get("c.getBaseURl");
			getBaseURL.setCallback(this, function (response) {
				var state = response.getState();
				if (state === "SUCCESS") {
					myBaseURL = response.getReturnValue();
					component.set( 'v.myBaseURL' , myBaseURL );
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
		
	},
	/**
	*@author Giovanni Spinelli <spinelli.giovanni@accenture.com>
	*@date 20/03/2018
	*@description 	Method store in an attribute the filter with
					which I made the merchant search (FC or VAT)
	*@params -
	*@return set an attribute with filter
	*/
	storeFilter: function( component ){
		var AccountName      =  component.find("AccountName").get('v.value');
		var VatNumber        =  component.find("VatNumber").get('v.value');
		var filter;
		if(AccountName){
			filter = 'FC_'+AccountName ; 
		}else if(VatNumber){
			filter = 'VAT_'+VatNumber; 
		}
		component.set('v.filterToRedirect' , filter);
		//giovanni spinelli - start - 02/10/2019 add filter cab if user is L2 or L3
		var UserWrapper =  component.get("v.UserWrapper") ;
		//if user is Nexi Partner Approver L2 add _CAB_ in url
		if(UserWrapper.userProfile == 'Nexi Partner Approver L2' || UserWrapper.userProfile == 'Nexi Partner Approver L3'){
			filter = filter + '_CAB_'+ UserWrapper.userCAB;
			component.set('v.userProfile' ,UserWrapper.userProfile );
			
		}
		//giovanni spinelli - end - 02/10/2019
		
	},
	/**
	*@author Giovanni Spinelli <spinelli.giovanni@accenture.com>
	*@date 20/03/2018
	*@description 	Method to fire flow if there is filter or not
	*@params -
	*@return 
	*@version 2.0 add check if user is Nexi Partner Approver L2
	*/
	redirectFlow: function (component, AccountName, VatNumber) {
		var myBaseURL = component.get('v.myBaseURL');
		console.log('myBaseURL: ' + myBaseURL);
		var filter;
		if (AccountName) {
			filter = 'FC_' + AccountName;
		} else if (VatNumber) {
			filter = 'VAT_' + VatNumber;
		}
		var UserWrapper =  component.get("v.UserWrapper") ;
		//if user is Nexi Partner Approver L2 add _CAB_ in url
		if(UserWrapper.userProfile == 'Nexi Partner Approver L2' || UserWrapper.userProfile == 'Nexi Partner Approver L3'){
			if(filter){
				filter = filter + '_CAB_'+ UserWrapper.userCAB;
			}else{
				filter = 'ONLYCAB_'+ UserWrapper.userCAB;
			}
				
			
		}
		console.log('filter: ' + filter);

		if (filter) {
			window.open(myBaseURL + '/s/ob-catalogo-nuovo-contratto?filter=' + filter, '_self');
		} else {
			window.open(myBaseURL + '/s/ob-catalogo-nuovo-contratto', '_self');
		}
	}
})