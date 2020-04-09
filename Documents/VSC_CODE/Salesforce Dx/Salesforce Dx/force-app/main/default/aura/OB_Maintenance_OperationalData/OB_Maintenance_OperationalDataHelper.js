({

	callService : function(component) {
		component.set("v.Spinner", true);
		var objectDataMap = component.get("v.objectDataMap");
		var isMaintenance = component.get("v.isMaintenance");
		//get the abi from datamap
		var Abi;
		if(isMaintenance)
		{
			Abi = component.get("v.bankABI");
		}
		else
		{
			Abi = objectDataMap.bank.OB_ABI__c;//'03512' banca reale:
		 }
		//_utils.debug("ABI to send "+ Abi);
		
		var contractId;
		var ordId;
		if(isMaintenance){
			contractId = component.get("v.orderId");
			ordId = component.get("v.orderId");
		}
		else{
			//get contract id from datamap
			contractId =objectDataMap.Configuration.Id; //'a0y9E0000043M72QAE';  //'a0y9E0000043nUlQAI';// 'a0y9E000003zJQSQA2';  		
			//get order Id
			ordId = objectDataMap.Configuration.Id;// 'a0y9E0000043M72QAE';//'a0y9E0000043nUlQAI';//'a0y9E000003zJQSQA2';
		}
		//_utils.debug("contractId: " + contractId);
		//_utils.debug("ordId: " + ordId);
		var terminalId;
		var readOnly;
		var postype;
		var Isgenerated = false;
		var skipServiceCall = false;
		
		var attributeIndex = event.target.name;  //firstIndex+'_VAS_generateBtn		
        //var listOfItems = component.get("v.terminaIdItemsList");//component.get("v.posList");

        attributeIndex = JSON.stringify(event.target.name);
        //_utils.debug("@@@attributeIndex0: "+ attributeIndex);
        attributeIndex = attributeIndex.substr(0,attributeIndex.indexOf('-'));
        var itemName = attributeIndex.split("_").pop(); //VAS or POS
        attributeIndex = attributeIndex.substr(1,attributeIndex.indexOf('_')-1);
        _utils.debug("@@@itemName: "+ itemName);
        _utils.debug("@@@attributeIndex: "+ attributeIndex);
	    //francesca.ribezzi - new list composed by vas and pos with terminal ids:
	    var listOfItems = [];
	    if(itemName == 'VAS'){
	    	listOfItems = component.get("v.vasList");
	    }
	    else if(itemName == 'POS'){
	    		listOfItems = component.get("v.posList");
	    } 
		var itemToUpdate = listOfItems[parseInt(attributeIndex)];

		//got the correct item
		_utils.debug("itemToUpdate: ",itemToUpdate);
		
		//francesca.ribezzi - getting how many terminal ids there are:
		var terminalIds = component.get("v.terminaIdItemsList").length;//component.get("v.posList").length;
		var clickedBtn = parseInt(attributeIndex);//event.target.name;
		//list that contains clicked btns:
		var clickedBtnsList = component.get("v.clickedBtnsList");
		//boolean to check if there is at least one readOnly terminalID. if so, the callback must be successful!! 
		var terminalIDnotReadOnly = false;
		var allTerminalIdsAreRequired = false;
		var allBtnsClicked = false;
		var btnId = event.target.id;
		var mapItemIdSuccessTerminalCall = component.get("v.mapItemIdSuccessTerminalCall");
		var mapItemIdTerminalId = component.get("v.mapItemIdTerminalId");
		
		for(var i = 0; i < itemToUpdate.listOfAttributes.length; i++){
			//get the terminal id
			if(itemToUpdate.listOfAttributes[i].fields.name == 'Terminal Id'){
				terminalId = itemToUpdate.listOfAttributes[i].fields.value;
				readOnly = itemToUpdate.listOfAttributes[i].fields.readonly;	
				//francesca.ribezz: checking if terminal id is required. If it is, checking if the user clicked every terminal id btns!!
				if(itemToUpdate.listOfAttributes[i].fields.required == 'Yes'){
					if(clickedBtnsList.length > 0)
					{
						if(clickedBtnsList.indexOf(clickedBtn) == -1)
						{
							//pushing the new clicked btn into the list
							//_utils.debug("pushing a new generateId btn into the list..");
							clickedBtnsList.push(clickedBtn);
							//_utils.debug("clickedBtnsList length is " + clickedBtnsList.length);
						}
					}
					else
					{
						clickedBtnsList.push(clickedBtn);
					}
					
					if(clickedBtnsList.length == terminalIds)
					{
						//_utils.debug("the user clicked every general Id button!!");
						allBtnsClicked = true;
					}
					else
					{
						allBtnsClicked = false;
						//_utils.debug("the user DIDNT clicked every general Id button!!");
					}
					component.set("v.allBtnsClicked", allBtnsClicked);
					component.set("v.clickedBtnsList", clickedBtnsList);
					/*if(itemToUpdate.listOfAttributes[i].fields.readonly == 'false' || itemToUpdate.listOfAttributes[i].fields.readonly == false){
						terminalIDnotReadOnly = true;
						//this terminal id is required and not readonly so its length must be of 9 chars:
						var terminalIdValue = itemToUpdate.listOfAttributes[i].fields.value;
						if(terminalIdValue.length < 9){
							//_utils.debug("error! terminal id length must be of 9 chars in this case!");
						}
					}*/
				}
			}
		}
		//get pos Type
		//get record id if is terminali will be "fisico" else it will be "virtuale"
		var terminaliRecordType = "Terminali";
		terminaliRecordType = terminaliRecordType.toLowerCase();
		
		var recordTypeToMatch = itemToUpdate.fields.RecordTypeName.toLowerCase();
		
		if(recordTypeToMatch != terminaliRecordType){
			postype = 'virtuale';
		}
		else{
			postype = 'fisico';
		}
		//_utils.debug("postype: " + postype);
		//try to grasp if we need to verify or generate
		if( $A.util.isEmpty(terminalId) && (readOnly == true || readOnly == 'true') ){ 
			Isgenerated = true;
			//skipServiceCall = false;
			document.getElementById(btnId).classList.remove("slds-button_neutral");
			document.getElementById(btnId).classList.add("slds-button_brand");
			var regenerateLabel = $A.get("$Label.c.OB_RegenerateTerminalIdLabel"); 
			document.getElementById(btnId).innerHTML = regenerateLabel;
		}
		else if( !($A.util.isEmpty(terminalId)) && (readOnly == true || readOnly == 'true') ){
			skipServiceCall = true;
		}
		else if( $A.util.isEmpty(terminalId) && (readOnly != true || readOnly != 'true') ){
			 
			
			var errorLabel = $A.get("$Label.c.OB_CustomErrorLabelTech");
			var specialErrorLabel = $A.get("$Label.c.OB_SpecialErrorLabelTech");
			var obj = this.getTerminalIdInputError(component, event, clickedBtn, itemName,listOfItems );//
			if(obj.input.value.length != 8){
				obj.errMsg.innerHTML = errorLabel+' '+specialErrorLabel; 
				skipServiceCall = true;
				component.set("v.Spinner", false); //davide.franzini - F2WAVE2-150 - 16/07/2019
			}
		}
		else if( !($A.util.isEmpty(terminalId)) && (readOnly != true || readOnly != 'true') ){
			//Isgenerated = false;
			//skipServiceCall = false;
			//var errorLabel = 'Terminal ID must be 8 characters long.';
			//var errMsg = document.getElementById(event.target.id+'_ErrorTerminalId');
			//errMsg.innerHTML = errorLabel; 
			document.getElementById(btnId).classList.remove("slds-button_neutral");
			document.getElementById(btnId).classList.add("slds-button_brand");
			var regenerateLabel = $A.get("$Label.c.OB_RegenerateTerminalIdLabel"); 
			document.getElementById(btnId).innerHTML = regenerateLabel;
			//francesca.ribezzi just added:
			var errorLabel = $A.get("$Label.c.OB_CustomErrorLabelTech");
			var specialErrorLabel = $A.get("$Label.c.OB_SpecialErrorLabelTech");
			var obj = this.getTerminalIdInputError(component, event, clickedBtn, itemName,listOfItems);
			if(obj.input.value.length != 8){
				obj.errMsg.innerHTML = errorLabel+' '+specialErrorLabel; 
				skipServiceCall = true;
			}
		}
		
		if(!skipServiceCall){
	        var action = component.get("c.callTerminalIdService");
	        action.setParams({ 
	        	isToGenerate: Isgenerated,
	        	orderId: ordId,
	        	proposerAbi: Abi,
	        	posType: postype,
	        	terminalId: terminalId,
	        	contractId: contractId 
	        });
	        action.setCallback(this, function(response) {
	            var state = response.getState();
	            if (state === "SUCCESS") {
	                //manage the resp 
	                //_utils.debug("response: ", response.getReturnValue());
	                
	                var res =  response.getReturnValue();
	               	var contextOutput = component.get("v.contextOutput");
	                
	                //_utils.debug("res.terminalId "+res.terminalId);
	                
	                if( (res.terminalId != "null" && res.terminalId != '0' && res.terminalId != undefined) || res.result == 'OK'){

	                	if(Isgenerated){
	                	
	                		//reset error Msg if result is correct
		                	var errMsg = document.getElementById(attributeIndex+'_'+itemName+'_ErrorTerminalId');
							errMsg.innerHTML = '';
	                	
			                for(var j = 0; j < itemToUpdate.listOfAttributes.length; j++){
			                	if(itemToUpdate.listOfAttributes[j].fields.name == 'Terminal Id'){
			                		itemToUpdate.listOfAttributes[j].fields.value = res.terminalId;
			                		break;
			                	}
							}
							
							//davide.franzini - RI-99 - 13/06/2019 - START  
							var tempTerminalList = [];
							tempTerminalList = component.get("v.terminalsToCheck");
							tempTerminalList.push(itemToUpdate);
							component.set("v.terminalsToCheck",tempTerminalList);
							//davide.franzini - Ri-99 - 13/06/2019 - END

		                }
		                else{
		                	//reset error Msg if result is correct
		                	var obj = this.getTerminalIdInputError(component, event, clickedBtn, itemName, listOfItems);
							obj.errMsg.innerHTML = ''; 
							//davide.franzini - RequiredFieldsInOperationalData - 21/06/2019 - START  
							var tempTerminalList = [];
							tempTerminalList = component.get("v.terminalsToCheck");
							tempTerminalList.push(itemToUpdate);
							component.set("v.terminalsToCheck",tempTerminalList);
							//davide.franzini - RequiredFieldsInOperationalData - 21/06/2019 - END
		                }
		                
		                //set the new item in the list
		                //Andrea Saracini F2WAVE2-4 START 18-07-2019
                        if(itemName == 'VAS'){
                            component.set("v.vasList",listOfItems);
                        }
                        else if(itemName == 'POS'){
                            component.set("v.posList",listOfItems);
                        }
                        //Andrea Saracini F2WAVE2-4 STOP 18-07-2019 
		                component.set("v.isEnd", true);        
						mapItemIdSuccessTerminalCall[itemToUpdate.fields.id] = true;   
						//14/03/19 francesca.ribezzi disable button after generating/verifying a terminalId:
						 document.getElementById(btnId).disabled = true;
						mapItemIdTerminalId[itemToUpdate.fields.id] = res.terminalId;   
		                var changeAttributeEvent = 	$A.get("e.NE:Bit2win_Event_AttributeChanged");
						changeAttributeEvent.setParams({
							'itemChanged': itemToUpdate,
							'Context_Output':contextOutput
						});
			    											
						changeAttributeEvent.fire();
						
						
					}
					else{
						//manage errors
						//_utils.debug("error in calling the external service");
						var errorLabel = $A.get("$Label.c.OB_CustomErrorLabelTech");
						
						if(Isgenerated){
							var x = document.getElementById(attributeIndex+'_'+itemName+'_ErrorTerminalId');
							x.innerHTML = errorLabel+' '+res.result;
						}
						else{
							var x = this.getTerminalIdInputError(component, event, clickedBtn, itemName,listOfItems);
							x.errMsg.innerHTML = errorLabel+' '+res.result;					
						}
	
						mapItemIdSuccessTerminalCall[itemToUpdate.fields.id] = false;
						component.set("v.Spinner",false);
					}
	            }
	            else if (state === "INCOMPLETE") {
	            	mapItemIdSuccessTerminalCall[itemToUpdate.fields.id] = false;
	            	component.set("v.Spinner",false);
	            }
	            else if (state === "ERROR") {
                       //START elena.preteni 28/05/2019 generate random value for termid TO DELETE WHEN IT SARTSWORKING AGAIN
					var errMsg = document.getElementById(attributeIndex+'_'+itemName+'_ErrorTerminalId');
					errMsg.innerHTML = '';
					var max = Math.ceil(5999);
					var min = Math.floor(3000);
					var fakeTermId= Math.floor(Math.random() * (max - min + 1)) + min;
				
					for(var j = 0; j < itemToUpdate.listOfAttributes.length; j++){
						if(itemToUpdate.listOfAttributes[j].fields.name == 'Terminal Id'){
							itemToUpdate.listOfAttributes[j].fields.value = '0188'+JSON.stringify(fakeTermId);
							break;
						}
					} 
					component.set("v.posList",listOfItems);
					component.set("v.isEnd", true);        
					mapItemIdSuccessTerminalCall[itemToUpdate.fields.id] = true;      
					document.getElementById(btnId).disabled = true;
					var changeAttributeEvent = 	$A.get("e.NE:Bit2win_Event_AttributeChanged");
					changeAttributeEvent.setParams({
						'itemChanged': itemToUpdate,
						'Context_Output':contextOutput
					});
														
					changeAttributeEvent.fire();
					//END elena.preteni 28/05/2019 generate random value for termid TO DELETE WHEN IT SARTSWORKING AGAIN
	            	if(terminalIDnotReadOnly){
	            		//_utils.debug("ERROR - the callback must be successful!");
	            		var obj = this.getTerminalIdInputError(component, event, clickedBtn, itemName,listOfItems);
						//START gianluigi.virga 12/08/2019 - UX-197
						var errorLabel = $A.get("$Label.c.OB_ServiceUnavailable"); //"ERROR - the callback must be successful!"
						//END gianluigi.virga 12/08/2019 - UX-197
						obj.errMsg.innerHTML = errorLabel;
	            	}
	                    var errors = response.getError();
	                    if (errors) {
	                        if (errors[0] && errors[0].message) {
	                            //_utils.debug("Error message: " + errors[0].message);
	                            var obj = this.getTerminalIdInputError(component, event, clickedBtn, itemName,listOfItems);
	                            //START gianluigi.virga 12/08/2019 - UX-197
								obj.errMsg.innerHTML = $A.get("$Label.c.OB_ServiceUnavailable"); // "error in calling the external service";           
								//END gianluigi.virga 12/08/2019 - UX-197           
	                        }
	                    } else {
	                        //_utils.debug("Unknown error");
	                    }
	                    component.set("v.Spinner",false);
	                    mapItemIdSuccessTerminalCall[itemToUpdate.fields.id] = false;
					}
				component.set("v.mapItemIdSuccessTerminalCall", mapItemIdSuccessTerminalCall);
				component.set("v.mapItemIdTerminalId", mapItemIdTerminalId);
	        });
	        $A.enqueueAction(action);
	        component.set("v.Spinner", true);
	    }    
	},	
	initializeBit2Win: function(component){
		
		//_utils.debug("__init attributes");
		
		//_utils.debug("FIRE EVENT NE:Bit2win_Event_RetrieveContext");
		var updateContext				=	$A.get("e.NE:Bit2win_Event_RetrieveContext");
            updateContext.setParams({
                'componentRequest'		:	'catalog',
                'page'					:	 0 //getting cart
            });
         updateContext.fire(); 
	},
    
    enrichOrder: function(component, event) {
    
    	try
	    	{
	    	var ordId = component.get("v.objectDataMap.Configuration.Id");
	    	//console.log('ORD_ID: ' + ordId);
	    	//_utils.debug("__into enrichOrder with order id: "+ordId);
	    	var isMaintenance = component.get("v.isMaintenance");
	    	////console.log('IS_MAINTENANCE: '+isMaintenance);
	    	var actionEnrich = component.get("c.enrichOrderWrapper");
		    actionEnrich.setParams({ idOrder: ordId });
		    //console.log('AFTER_SET_actionEnrich; '+ JSON.stringify(actionEnrich));
			actionEnrich.setCallback(this, function(response) 
			{
				//console.log('IN CALL BACK ENRICH');
				var state = response.getState();
				//console.log('STATE_HANDLER: ' +state);
				if (state === "SUCCESS") 
				{
					//console.log('INTO_SUCCESS_ENRICH');
					//_utils.debug("response: ", response.getReturnValue());
					var res = response.getReturnValue();	                
					//console.log('RES_HANDLER_CHECKOUT: ' + response.getReturnValue());
					if(res)
					{
						// if(isMaintenance){
						// 	this.redirectMaintenance(component,event);
						// }
						// else{
						//component.set('v.goNext' ,  true);
						//component.set("v.objectDataMap.unbind.goToNextStepSocieta", 'goToSocieta');
						//console.log('CALL_NEXT_PAGE');					
						this.showBit2flowNext(component, event);
							
						// }	
					}
					else
					{
						//error message
						//toast message error TODO
						//console.log('STAY_IN_PAGE');
						component.set("v.Spinner",false);	
					}
				}
				else if (state === "INCOMPLETE") {
					component.set("v.Spinner",false);
				}
				else if (state === "ERROR") {
						var errors = response.getError();
						if (errors) {
							if (errors[0] && errors[0].message) {
								//_utils.debug("Error message: " + 
											//errors[0].message);
							}
						} else {
							//_utils.debug("Unknown error");
						}
						component.set("v.Spinner",false);
				}
		        });
		        $A.enqueueAction(actionEnrich);
				//console.log('after_callback');
			}
			catch(err)
			{
		    	//console.log('ERR:MESSAGE_CALL_ENRICH: ' + err.message);
		    }
	},
	
	showBit2flowNext: function(component, event) 
	{
		try
		{
			//_utils.debug("into showBit2flowNext");
			//START francesca.ribezzi 21/03/19 checking if there's any changes on cartItems:
			var contextOutput = component.get("v.contextOutput");
			var objectDataMap = component.get("v.objectDataMap");
			var cart = contextOutput.cart;
			var orderItems = [];
			for(var i = 0; i<cart.length; i++){
				for(var j = 0; j<cart[i].childItems.length; j++){
					if(cart[i].childItems[j].fields.action == 'Add' || cart[i].childItems[j].fields.action == 'Change'){
						orderItems.push(cart[i].childItems[j]);
					}
				}
			}
			//if theres a change, going to step società
			if(orderItems.length > 0){
				console.log('OBJ_NEXT: ' +	JSON.stringify(component.get('v.objectDataMap.unbind')));
				objectDataMap.unbind.goToNextStepSocieta='goToSocieta';
			}else{
			//if there are no changes, going to carica documenti step
				objectDataMap.unbind.goToFinalStep='true';

			}
			component.set("v.objectDataMap", objectDataMap); 
			//END francesca.ribezzi	

			//dispatchEvent to fire bit2flow rule that automatically goes to next step.
			//document.getElementById('input:unbind:goToNextStepSocieta').dispatchEvent(new Event('blur'));   
	
			component.set("v.Spinner",false); 
		}catch(err){
			//console.log('ERR_MESSAGE_NEXTSTEP: ' + err.message);
		}
	    
    },
    
    splitOrderItemPOS: function(component,event) {
		//_utils.debug("__into splitOrderItemPOS");
		var t0 = performance.now();
		console.log("s0: "+ performance.now());
    	var ordId = component.get("v.orderId");
    	
    	var action = component.get("c.splitOrderItem2");
	        action.setParams({ 
	        	idOrder: ordId
	        });
	        action.setCallback(this, function(response) {
	            var state = response.getState();
	            if (state === "SUCCESS") {
	                console.log("s1: "+ performance.now());
	                //_utils.debug("response: ", response.getReturnValue());
	                var res = response.getReturnValue();
	                
	                if(res){
						component.set("v.startEngine", true);
						//18/02/19 francesca.ribezzi adding clear cart
					/*	var clearCartEvent = $A.get("e.NE:Bit2win_Event_ApplyPenalty");  
						clearCartEvent.setParams({
							"action": "clearCart" 
						});
						clearCartEvent.fire();*/
				    	//if(component.get("v.isMaintenance")){
				    		//this.initializeBit2Win(component);
				    	//}
						//else nothing....
						console.log("s2: "+ performance.now());
			    	}
			    	else{
			    		//error message
			    		//toast message error TODO	
					}
					//05/03/19 francesca.ribezzi spinner commentato:
					component.set("v.Spinner",false);
					var t1 = performance.now();
		console.log("Call splitOrderItemPOS took " + (t1 - t0) + " milliseconds.");
					
				}
	            else if (state === "INCOMPLETE") {
	            	component.set("v.Spinner",false);
	            }
	            else if (state === "ERROR") {
	                    var errors = response.getError();
	                    if (errors) {
	                        if (errors[0] && errors[0].message) {
	                            //_utils.debug("Error message: " + 
	                                        //errors[0].message);
	                        }
	                    } else {
	                        //_utils.debug("Unknown error");
	                    }
	                    component.set("v.Spinner",false);
	            }
	        });
	        $A.enqueueAction(action);
			component.set("v.Spinner", true);
			
	},

	getTerminalIdInputError : function(component, event, firstIndex, itemName, listOfItems){
		//errorID : firstIndex+'_'+index+'_POS_ErrorTerminalId event.target.name = firstIndex
		//_utils.debug("into getTerminalIdInputError");
		var obj = {};
		//   var listOfItems = component.get("v.terminaIdItemsList");
		   var itemToUpdate = listOfItems[firstIndex];
		   var index;
		   for(var i = 0; i<itemToUpdate.listOfAttributes.length; i++){
			   var att = itemToUpdate.listOfAttributes[i];
			   if(att.fields.name == 'Terminal Id'){
				   index = i;
				   break;
			   }
		   }
		   obj.errMsg = document.getElementById(firstIndex+'_'+index+'_'+itemName+'_ErrorTerminalId');
		   obj.input = document.getElementById(firstIndex+'_'+index+'_'+itemName);
		  // //_utils.debug("obj: " , obj);
		   //_utils.debug("obj.input.value.length: " , obj.input.value.length);
		   return obj;

	},
	
	checkRequiredInputs: function(component){
		var isOk;
		var requiredIsOk = true;
		var cart = component.get("v.cartList");
			if(!$A.util.isEmpty(cart)){
				for(var i = 0;i< cart.length; i++){
				if(cart[i].listOfAttributes.length != 0){
					for(var k = 0; k < cart[i].listOfAttributes.length; k++){
						if((cart[i].listOfAttributes[k].fields.required == 'Yes' ||  cart[i].listOfAttributes[k].fields.required == 'true') && $A.util.isEmpty(cart[i].listOfAttributes[k].fields.value)){
							requiredIsOk = false;
							break;
						}
					}		
				}
				var errors = document.getElementsByClassName('borderError');
				//_utils.debug("borderErrors? "+ errors.length);
				if(errors.length > 0 && dateError){
					isOk = false;
				}else{
					isOk = true;
				}
				return (isOk && requiredIsOk);
				}
			}else{
				var operationFailed = $A.get("$Label.c.OB_OperationFailedLabel");
				this.showToast(component,event,operationFailed);
			}
	},
	
	// redirectMaintenance: function(component,event){
	
	// 	//_utils.debug("enrich Order Complete");
	// 	component.set("v.Spinner",false);
		
	// },
	

	/*  OB OPERATIONAL DATA   */   
	getReportType : function (component , helper , event ) 
	{
		//25-09-2018-Salvatore P.- Get picklist values for Report Type field
		console.log("t0 getReportType: "+ performance.now());
		var actionGetReportTypeValues = component.get("c.getReportTypeValues");
		var objectDataMap = component.get("v.objectDataMap");
		actionGetReportTypeValues.setCallback(this, function(response)
		{
			 var state = response.getState();
			 if (state === "SUCCESS") 
			 {
				console.log("t1: "+ performance.now());
				 var  tempMap =[];
				 var  responseMap= response.getReturnValue();
				 for(var key in responseMap)
				 {
					tempMap.push({value:responseMap[key], key:key});
				 }
				 component.set( "v.reportTypeList",  tempMap);
				 console.log("t2: "+ performance.now());
				 //_utils.debug("Value of picklist report type: "+tempMap);
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
						//_utils.debug("Error message: " + errors[0].message);
					}
				}
				else 
				{
					//_utils.debug("Unknown error");
				}
			 }
		 });
		$A.enqueueAction(actionGetReportTypeValues); 
	},

	/* START 	micol.ferrari 01/10/2018 - CREATION OF BILLING PROFILES */
	confirmCreationBillingProfilesHelper: function(component, event, helper) 
	{
		console.log('@@@@ INTO HELPER');
		//francesca.ribezzi 20/03/19 commenting methodDone -it was used for the spinner
		//var methodFinished = component.get("v.methodDone");
		
		try
		{
			//component.set("v.methodDone", false);
			component.set("v.Spinner", true);
			//18/02/19 francesca.ribezzi adding restart cart
			var param	=	'&ordId='+ component.get("v.orderId"); //enrico.purificato - 04/07/2019 - performance;
			console.log("param?? " + param);
			var processOptions			=	{};
			processOptions.parameters	=	param;
			
			var restartEvent =       $A.get("e.NE:Bit2win_Event_CartEvent");
			restartEvent.setParams({
				'process'			:	'Restart',
				'processOptions'	:	processOptions
			});
			restartEvent.fire();  

			console.log('into helper confirm');
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
			//console.log('INTERMEDIATE');
			objectDataMap.BillingProfileAcquiring.OB_CountryCode__c 			= countrycode;
			objectDataMap.BillingProfileAcquiring.OB_EuroControlCode__c 		= eurocontrolcode;
			objectDataMap.BillingProfileAcquiring.OB_CINCode__c 				= cin;
			objectDataMap.BillingProfileAcquiring.OB_ABICode__c 				= abi;
			objectDataMap.BillingProfileAcquiring.OB_CABCode__c 				= cab;
			objectDataMap.BillingProfileAcquiring.OB_Bank_Account_Number__c 	= bankaccountnumber;
			objectDataMap.BillingProfileAcquiring.OB_HeaderInternational__c 	= headerinternational;

			component.set("v.objectDataMap",objectDataMap);

			
			//console.log('BEFORE CALLBACK');
			var showIBANSection = component.get('v.showIBANSection');
			//console.log('SHOW_IBAN_IN_CONFIRM: ' +showIBANSection );
			//	START 	micol.ferrari 30/01/2019
			if (showIBANSection==true)
			{
				//	INSERT OF TWO BILLING PROFILES
				//19/92/19 francesca.ribezzi moving call server side to handleAfterCheckout
				var createBillingProfiles = component.get("c.insertBillingProfilesUpdateOrderHeader");
				//console.log('PARAMS_CONFIRM: ' + merchantId + ' '+actualBankId);
				createBillingProfiles.setParams({
													"objectDataString": JSON.stringify(objectDataMap),
													"merchantId": merchantId,
													"actualBankId": actualBankId,
													"isCheckout": false
												});
				createBillingProfiles.setCallback(this,function(response) 
				{
					var state = response.getState();
					//console.log('STATE_CONFIRM_IS: ' + state);			 
					if (state === "SUCCESS") 
					{	
						//console.log('INTO_SUCCESS_CONFIRM');
						//_utils.debug('SUCCESS confirmCreationBillingProfilesHelper');	 			
						var responseData		= {};
						responseData 			= response.getReturnValue();
						
						console.log('@@@@ ResponseData: ', JSON.stringify(responseData));
						console.log("responseData.unbind.OB_Year_constitution_company__c"+JSON.stringify(responseData.unbind.yearOfConstitutionCompany));
						// Simone  Misani START 25/06/2019  change the conditions on if 
						if( responseData.unbind.yearOfConstitutionCompany == undefined || responseData.unbind.yearOfConstitutionCompany== null || responseData.unbind.yearOfConstitutionCompany =='' ) {
							console.log('in the if');
							responseData.unbind.yearOfConstitutionCompany= "";
							responseData.merchant.OB_Year_constitution_company__c = "";
							// component.set('v.objectDataMap.unbind.yearOfConstitutionCompany' ,'test');
						}
						// Simone Misani END 25/06/2019 change the conditions on if 
						console.log('@@@@ ResponseData: ', JSON.stringify(responseData));
						component.set("v.objectDataMap",responseData);
						
						//19/02/19 francesca.ribezzi setting objDataMap:
						//component.set("v.objectDataMap",objectDataMap);

						//console.log('SPINNER: ' +component.get('v.Spinner'));
						// //console.log('POS_LIST: ' +JSON.stringify(component.get('v.posList')));
						// //console.log('BANCOMAT_LIST: ' +JSON.stringify(component.get('v.bancomatList'))); 
						// //console.log('ACQUIRING_LIST: ' +JSON.stringify(component.get('v.acquiringList')));
						// //console.log('VAS_LIST: ' +JSON.stringify(component.get('v.vasList')));
						//_utils.debug('responseData AFTER METHOD: ');
						//_utils.debug(responseData);

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

							

							//19/02/19 francesca.ribezzi setting confirmOperationalData to true here
							objectDataMap.confirmOperationalData = true;
							//---------------------------------------------------------

							//			SHOW CATALOG

							//---------------------------------------------------------
						}
						// G.S. 14/02/2019
						component.set("v.Spinner", false);
					//	methodFinished = true;
					//	component.set('v.methodDone', true);	
						
					}
					else if (state === "INCOMPLETE") 
					{
						//	INCOMPLETE
						//_utils.debug('INCOMPLETE confirmCreationBillingProfilesHelper');
					}
					else if (state === "ERROR") 
					{
						//	ERROR TBD
						//_utils.debug('ERROR confirmCreationBillingProfilesHelper');
					}
				});
				$A.enqueueAction(createBillingProfiles); 
			}
			else
			{	
				console.log('INTO_ELSE_CONFIRM');
				// Simone MisaniStart 25/06/2019   add  the code for change unbind.yearOfConstitutionCompany = Null in unbind.yearOfConstitutionCompany='' and merchant.OB_Year_constitution_company__c = null chnage in merchant.OB_Year_constitution_company__c = ""
				objectDataMap1= component.get("v.objectDataMap");
				console.log('@@@@ objectDataMap1 else: ', JSON.stringify(objectDataMap1));
				console.log("else responseData.unbind.yearOfConstitutionCompany"+JSON.stringify(objectDataMap1.unbind.yearOfConstitutionCompany));
				if( objectDataMap1.unbind.yearOfConstitutionCompany == undefined || objectDataMap1.unbind.yearOfConstitutionCompany== null || objectDataMap1.unbind.yearOfConstitutionCompany =='' ) {
					console.log('in the if');
					objectDataMap1.unbind.yearOfConstitutionCompany= "";
					objectDataMap1.merchant.OB_Year_constitution_company__c = "";
					// component.set('v.objectDataMap.unbind.yearOfConstitutionCompany' ,'test');
				}
				// Simone Misani Start  25/06/2019   add  the code for change unbind.yearOfConstitutionCompany = Null in unbind.yearOfConstitutionCompany='' and merchant.OB_Year_constitution_company__c = null chnage in merchant.OB_Year_constitution_company__c = "". 
				console.log('@@@@ objectDataMap1: ', JSON.stringify(objectDataMap1));
				
				
				objectDataMap1.confirmOperationalData = true;
				component.set("v.objectDataMap",objectDataMap1);
				// SIMONE END 25/06/2019 
				//console.log('CONFIRM_OPERATIONAL_DATA: ' + JSON.stringify(objectDataMap.confirmOperationalData));
				component.set("v.Spinner", false);	
			}
			//	END 	micol.ferrari 30/01/2019
		}catch(err){
			console.log('ERROR_MESSAGE_CONFIRM_DATA: ' + err.message);
		}
	},

	setRedBorderHelper: function(component, event, helper) 
	{
		// 26-09-2018-Salvatore P.-Check mandatory fields on next button
		var mapFromNext 	= {};
		var objectDataMap 	= component.get("v.objectDataMap");
		//_utils.debug('setredbord'+objectDataMap.setRedBorderoperationalData);
		if(objectDataMap.setRedBorderoperationalData == true)
		{
			mapFromNext = component.get("v.objectDataMap.checkMapValuesoperationalData");
			//_utils.debug("mandatory field from map: " ,mapFromNext);
			
			//_utils.debug("INTO IF METHOD OF TRUE BOOLEAN");
			for (var keys in mapFromNext)
			{
	
				var errorId = 'errorId' +keys;
				//_utils.debug("key  = " + keys);
				
				var myDiv;
				
				if(keys != 'prelimVerifCode'){  // ID 155,  Doris Dongmo <doris.tatiana.dongmo@accenture.com>, 26/04/2109 - Adds if condition

				myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorId);//SET AN ID TO EVERY MESSAGE
				myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
				myDiv.setAttribute('class' , 'messageError'+keys);
				//SET THE MESSAGE
				var errorMessage = document.createTextNode(mapFromNext[keys]);
				myDiv.appendChild(errorMessage);

				var idSet = document.getElementById(keys);
				//_utils.debug("ID SET : " + idSet + ", input: " + component.find(keys));
				//CONTROL TO CATCH THE AURA ID IN LIGHTNING:SELECT 
				//THIS METHOD STARTS WHEN ON DISPLAY THERE ARE THE INPUTS TO EXAMINE
				if($A.util.isUndefinedOrNull(idSet) && !$A.util.isUndefinedOrNull(component.find(keys)))
				{
					idSet = component.find(keys).getElement();
					if($A.util.isUndefinedOrNull(idSet)){
					   idSet = document.getElementsByClassName(keys)[0];
					   if(idSet){
						  idSet.style.border = "2px solid rgb(221, 219, 218)";
						  idSet.style.borderColor = "rgb(194, 57, 52)";
					  } 
				   }
				}
				if(idSet!=null && idSet!= undefined)
				{ 
					if(!(document.getElementById(errorId)) && !(idSet.value))
					{
						//_utils.debug("METHOD TO SHOW ONLY A MESSAGE");
						idSet.after(myDiv);
						idSet.className="slds-has-error";
					}
				}//END FOR
				} // ID 155,  Doris Dongmo <doris.tatiana.dongmo@accenture.com>, 26/04/2109 - close if condition
			}
			// ID 155, Doris Dongmo <doris.tatiana.dongmo@accenture.com>, 29/04/2109 - START
			var inputIdVar          = component.find('prelimVerifCode');
			var inputValue 	        = inputIdVar.get("v.value");

			//START gianluigi.virga 12/06/2019 - PRODOB-209 - If the field is disabled it isn't mandatory
			var inputDisabled 	    = inputIdVar.get("v.disabled");
			if(!inputValue && !inputDisabled)
			//END gianluigi.virga 12/06/2019 - PRODOB-209
			{					
				// BOOLEAN TO SHOW ERROR MESSAGE 
				component.set("v.isMandatoryField",true);
				//ADD CLASS
				$A.util.addClass(inputIdVar, 'slds-has-error');	
			}
			// ID 155,  Doris Dongmo <doris.tatiana.dongmo@accenture.com>, 29/04/2109 - END
			
			component.set("v.objectDataMap.setRedBorderoperationalData" , false);
			//_utils.debug("boolean value after: " + component.get("v.objectDataMap.setRedBorderoperationalData" ));
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
			//_utils.debug('i: ' + i);
			//_utils.debug('firstDigit: ' + firstDigit);
			//_utils.debug('y: ' + y);
			//_utils.debug('lastDigit: ' + lastDigit);
			
			if(this.greaterThan(firstDigit,y)|| this.equal(firstDigit,y)) {
				//_utils.debug('break');
				break;
			} 


		}		
		//_utils.debug('firstDigit: ' + firstDigit);
		//_utils.debug('lastDigit: ' + lastDigit);

		var reminder = parseInt(firstDigit) % parseInt(y);
		//_utils.debug("reminder: "+ reminder);


		
		var newNumb = reminder.toString() + lastDigit.toString();
		//_utils.debug('newNumb: ' + newNumb);

			//_utils.debug("Y: "+y);
		
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
		//_utils.debug("ibanToConverte: "+ ibanToConverte);
		//_utils.debug("Array of iban where do convertation: "+ arrayIban);
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
				//_utils.debug("arrayConverted: "+ arrayConverted);
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
				
				component.set("v.objectDataMap.isIbanValid",true);
			}
			else
			{
				//show error
				if(document.getElementById(errorId))
				{
					//_utils.debug("errorID . " + errorId);
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
				
				component.set("v.objectDataMap.isIbanValid",false);
			} 
	

		component.set("v.objectDataMap.BillingProfilePOS.OB_IBAN__c", ibanComplete);

		//_utils.debug("IBAN IN OBJECT DATA MAP: ",component.get("v.objectDataMap.BillingProfilePOS.OB_IBAN__c"));
	},

	doInitMethodApex: function(component, event, helper) 
	{ 
		console.log("a1: " + performance.now());
		//28/02/19 francesca.ribezzi adding spinner
		component.set("v.Spinner", true);
		var a1 = performance.now();
		var objectDataMap 			= component.get("v.objectDataMap");
		component.set('v.objectDataMap.keyToUse' , {});
	//	//console.log('OBJECT_DATA_MAP_BEFORE: ' +JSON.stringify(objectDataMap));
		var doInitMethod = component.get("c.doInitMethod");
		var keyToUseTmp;
		doInitMethod.setParams({	"objectDataString": JSON.stringify(objectDataMap)
										});
		doInitMethod.setCallback(this,function(response) 
		{
			var state = response.getState();
			//console.log('STATE_IS: ' + state);			 
			if (state === "SUCCESS") 
			{	
				console.log("a2: " + performance.now());
				//_utils.debug('SUCCESS doInitMethod');				
				// responseData		= {};
				var responseData 			= response.getReturnValue(); 
				//console.log('RESPONSE: ' + JSON.stringify(response.getReturnValue()));
				keyToUseTmp = response.getReturnValue()['keyToUse'];
				console.log('RESPONSE_KEYTOUSE_BEFORE: ' + keyToUseTmp);
				// //console.log('RESPONSE_KEYTOUSE_REPLACE: ' + keyToUseTmp.replace('\"' , '"'));
				//console.log('RESPONSE_MERCHANT: ' + JSON.stringify(response.getReturnValue()['merchant']));
				component.set("v.objectDataMap",responseData);
				////console.log('SHOW IBAN IN HELPER: ' + component.get('v.showIBANSection'));
				//var showIBANSection =  component.get('v.showIBANSection');
				
				if(keyToUseTmp)
				{
					//console.log('INTO SET INIT AFTER');
					component.set('v.callInit' , true);
				}
				console.log('OBJDATAMAP_SET_INIT : ' + JSON.stringify(component.get('v.objectDataMap')));
				//_utils.debug('responseData AFTER doInitMethodApex: ');
				//_utils.debug(responseData);
				console.log("a3: " + performance.now());

				console.log("Call doInitMethodApex : " + (performance.now() - a1) + " milliseconds.");
				//05/03/19 francesca.ribezzi spinner commentato
				//component.set("v.Spinner", false);
			}
			else if (state === "INCOMPLETE") 
			{
				//	INCOMPLETE
				component.set("v.Spinner", false);
				//_utils.debug('INCOMPLETE confirmCreationBillingProfilesHelper');
			}
			else if (state === "ERROR") 
			{
				component.set("v.Spinner", false);
				//	ERROR TBD
				//_utils.debug('ERROR confirmCreationBillingProfilesHelper');
			}
		});
		$A.enqueueAction(doInitMethod);
		
		 
		
	},

      showErrorToast: function(component, event, errorMessage) {
      
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: '',
            message: errorMessage,
            //messageTemplateData: [name],
            duration: '5000',
            key: 'info_alt',
            type: 'error',
            mode: 'dismissible'
        });
        toastEvent.fire();
    },
	removeRedBorder: function (component, event , helper){
       
        //GET THE CURRENT ID FROM INPUT 
        var currentId = event.target.id; 
        //_utils.debug("current id is: " + currentId);
        $A.util.removeClass(document.getElementById(currentId) , 'slds-has-error');
        //RECREATE THE SAME ID OF ERROR MESSAGE
        var errorId = 'errorId'+ currentId;
        if(document.getElementById(errorId)!=null){
            //_utils.debug("errorID . " + errorId);
            document.getElementById(errorId).remove();
        }
    },
    removeRedBorderDate: function(component, event, helper) {
        var elementDateClass = event.getSource().get("v.class");
		var idSet = document.getElementsByClassName(elementDateClass)[0];
		var errorId = 'errorId' +elementDateClass;
        //_utils.debug("key  = " + elementDateClass);
        
        var myDiv;
        
        myDiv = document.createElement('div');
        myDiv.setAttribute('id',errorId);//SET AN ID TO EVERY MESSAGE
        myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
        myDiv.setAttribute('class' , 'messageError'+elementDateClass);
        //SET THE MESSAGE
        
        if(idSet.value){
			if(!/^[0-9]{2}\/[0-9]{2}\/[0-9]{4}$/.test(idSet.value)){
				var errorMessage = document.createTextNode($A.get("$Label.c.OB_InvalidDateFormat"));
	            //_utils.debug('errorMessage:: ',errorMessage);
	            myDiv.appendChild(errorMessage);
	
				if(idSet!=null && idSet!= undefined)
				{ 
					//_utils.debug('errorId doc'+(document.getElementById(errorId)));
					if(!(document.getElementById(errorId)))
					{
						//_utils.debug("METHOD TO SHOW ONLY A MESSAGE");
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
		            //_utils.debug("errorID . " + errorId);
		            document.getElementById(errorId).remove();
		        }
		        component.set("v.objectDataMap.errorDateMap."+elementDateClass, false);
		    }
		 }
        
    },
    
    createFakeContextOutput: function(component, event,orderId){
    	//_utils.debug("into createFakeContextOutput");
    	
    	var action = component.get("c.createCartListFromMap");
    	 action.setParams({ 
	        	"orderId" : orderId,
	    });
    	
		action.setCallback(this, function(response)
		{
			if (response.getState() === "SUCCESS")
			{
				//_utils.debug("OB_TechDetailService.createFakeContextOutput - SUCCESS"); 

				var context = {};
				context 	= response.getReturnValue();
				
				/*
				for(var key in context)
				{
					//_utils.debug("context[key].fields.parent ",context[key].fields.parent);
					if(context[key].fields.parent != null)
					{
						for(var parentKey in context)
						{
							//_utils.debug(context[parentKey].fields.productcatalogitem+" == ", context[key].fields.parent);
							if(context[parentKey].fields.productcatalogitem == context[key].fields.productcatalogitem && context[parentKey].fields.parent == null)
							{
								var arrayChild = context[parentKey].childItems;
								
								if($A.util.isEmpty(arrayChild))
								{
									arrayChild = [];
								}
								arrayChild.push(context[key]);
								context[parentKey].childItems = arrayChild;
								break;
							}
						}
						delete context[key];
					}
				}
				*/
				//_utils.debug("OB_TechDetailService.createFakeContextOutput - : ",context); 
				
				var cart = [];
				for(var key in context){
		    		cart.push(context[key]);
		    	}
				//context must be set in cartList
				//component.set("v.cartList", context);
				this.buildPageLists(component,event,cart)
				
			}
			else if (response.getState() === "INCOMPLETE")
			{
				//_utils.debug("OB_TechDetailService.createFakeContextOutput - INCOMPLETE"); 
			}
			else if (response.getState() === "ERROR") 
			{
				var errors = response.getError();
				if (errors) 
				{ 
					if (errors[0] && errors[0].message) 
					{
						//_utils.debug("OB_TechDetailService.createFakeContextOutput - Error message: " + errors[0].message);
					}
				}
				else 
				{
					//_utils.debug("OB_TechDetailService.createFakeContextOutput - UNKNOWN ERROR"); 
				}
			}
		});
		$A.enqueueAction(action);
    },
    
    buildPageLists : function(component,event,cart){
    	
    	var pos = [];
        var bancomat = [];
        var vas = [];
        var acquiring = [];
        //var categoryName = [];
        var terminalIdItems = [];
		
		//recordTypes to match
		var terminaliRecordType = "Terminali";
		var terminaliRecordTypeGateway = "Gateway_Virtuale";
		var terminaliRecordTypeEcommerce = "eCommerce";
		var terminaliRecordTypeMoto = "Moto";
		var pagobancomatRecordType = "Pagobancomat";
		var acquiringRecordType = "Acquiring";
		var vasRecordType = "Vas";
		
		terminaliRecordType = terminaliRecordType.toLowerCase();
		terminaliRecordTypeGateway = terminaliRecordTypeGateway.toLowerCase();
		terminaliRecordTypeEcommerce = terminaliRecordTypeEcommerce.toLowerCase();
		terminaliRecordTypeMoto = terminaliRecordTypeMoto.toLowerCase();
		pagobancomatRecordType = pagobancomatRecordType.toLowerCase(); 
		acquiringRecordType = acquiringRecordType.toLowerCase();
		vasRecordType = vasRecordType.toLowerCase();
		
		//_utils.debug(ob_racSIACurrentToMatch+" == "+ob_racSiaNexiToMatch);
		
		 //getting cart lists for each sections (pos, acquiring, vas and acquiring):
	        		for(var i = 0; i< cart.length; i++){
	        			if(cart[i] != null){
	        					//if(coreOutput.listOfBundles[j].bundleElements[x].fields.name =="Gestione Terminali" ){
	        					//_utils.debug(cart[i].fields.RecordTypeName.toLowerCase()+ " == "+terminali.toLowerCase());
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
	        					}
	        					//else if(coreOutput.listOfBundles[j].bundleElements[x].fields.name =="Gestione Pagobancomat" ){
	        					else if(recordTypeToMatch == pagobancomatRecordType ){
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
 
		//_utils.debug("acquiringList: " + JSON.stringify(acquiring));
		//_utils.debug("posList: ",pos);
		//_utils.debug("coreOutput: ",coreOutput);
		component.set("v.posList", pos);
        component.set("v.vasList", vas);
        component.set("v.acquiringList", acquiring);
        component.set("v.bancomatList", bancomat);
		component.set("v.Spinner",false);
	},	
	
	
	insertBillingProfilesUpdate: function(component,event){
		_utils.debug('into insertBillingProfilesUpdate');
		var objectDataMap = component.get("v.objectDataMap");
		var merchantId = 	objectDataMap.merchant.Id;
		var actualBankId =  objectDataMap.actualBank;
		var createBillingProfiles = component.get("c.insertBillingProfilesUpdateOrderHeader");
		//console.log('PARAMS_CONFIRM: ' + merchantId + ' '+actualBankId);
		createBillingProfiles.setParams({
											"objectDataString": JSON.stringify(objectDataMap),
											"merchantId": merchantId,
											"actualBankId": actualBankId, 
											"isCheckout": true
										});
		createBillingProfiles.setCallback(this,function(response) 
		{
			var state = response.getState();
			//console.log('STATE_CONFIRM_IS: ' + state);			 
			if (state === "SUCCESS") 
			{	
				//console.log('INTO_SUCCESS_CONFIRM');
				//_utils.debug('SUCCESS confirmCreationBillingProfilesHelper');	 			
				var responseData		= {};
				responseData 			= response.getReturnValue();
				component.set("v.objectDataMap",responseData);
				//console.log('SPINNER: ' +component.get('v.Spinner'));
				// //console.log('POS_LIST: ' +JSON.stringify(component.get('v.posList')));
				// //console.log('BANCOMAT_LIST: ' +JSON.stringify(component.get('v.bancomatList'))); 
				// //console.log('ACQUIRING_LIST: ' +JSON.stringify(component.get('v.acquiringList')));
				// //console.log('VAS_LIST: ' +JSON.stringify(component.get('v.vasList')));
				//_utils.debug('responseData AFTER METHOD: ');
				//_utils.debug(responseData);

				var objectDataMapAfter	= component.get("v.objectDataMap");			
				this.enrichOrder(component,event);	
				// G.S. 14/02/2019
				component.set("v.Spinner", false);	
				
			}
			else if (state === "INCOMPLETE") 
			{
				//	INCOMPLETE
				//_utils.debug('INCOMPLETE confirmCreationBillingProfilesHelper');
			}
			else if (state === "ERROR") 
			{
				//	ERROR TBD
				//_utils.debug('ERROR confirmCreationBillingProfilesHelper'); 
			}
		});
		$A.enqueueAction(createBillingProfiles); 
	},updateTerminalIds: function(component,event){
		_utils.debug('into updateTerminalIds');
		var mapItemIdTerminalId = component.get("v.mapItemIdTerminalId");
		_utils.debug('mapItemIdTerminalId: ', mapItemIdTerminalId);	 	
		var action = component.get("c.updateTerminalIdServer");
		action.setParams({	
			"mapItemIdTerminalId": mapItemIdTerminalId	}
		);
		action.setCallback(this,function(response) 
		{
			var state = response.getState();
			//console.log('STATE_CONFIRM_IS: ' + state);			 
			if (state === "SUCCESS") 
			{	
				//console.log('INTO_SUCCESS_CONFIRM');
			    _utils.debug('updateTerminalIds SUCCESS? ' + response.getReturnValue());	 			
				
			}
			else if (state === "INCOMPLETE") 
			{
				//	INCOMPLETE
			}
			else if (state === "ERROR") 
			{
				//	ERROR TBD
			}
		});
		$A.enqueueAction(action); 
	},

	//D.F. _ 26-03-2019 ManageRacSia v4 _ START
	checkTerminalsIBAN: function(component, event){
		var objectDataString = component.get("v.objectDataMap");	

		var act = component.get("c.checkActiveTerminalsIBAN");
		act.setParams({ 
			objectDataString: JSON.stringify(objectDataString),
		});
		act.setCallback(this, function(response){
			var state = response.getState();
			console.log("state: "+state);			 
			if (state === "SUCCESS"){
				var resp = response.getReturnValue();
				component.set("v.ibanList", resp);
				if(typeof resp !== 'undefined' && resp.length > 0){
					if(resp.length > 1){
						console.log('### multiple iban, open Modal');
						var ibanList = [];
						for(var i=0; i<resp.length; i++){
							ibanList.push({
								"full" : resp[i],
								"countryCode" : resp[i].substring(0, 2),
								"euroControlCode" : resp[i].substring(2, 4),
								"cin" : resp[i].substring(4, 5),
								"abi" : resp[i].substring(5, 10),
								"cab" : resp[i].substring(10, 15),
								"bankAccountNumber" : resp[i].substring(15, 27)
							});
						}
						component.set("v.ibanList",ibanList);
						component.set("v.ibanDisabled", true);
						component.set("v.showSearchIban",true);
						//START----> Simone Misani 25/06/2019 R1F2-181
						if(!$A.util.isEmpty(component.get("v.objectDataMap.BillingProfilePOS.OB_HeaderInternational__c"))){
							component.set("v.headerIntDisabled", true);
						}
						//END----> Simone Misani 25/06/2019 R1F2-181
					}else{
						console.log('### single Iban, autopopulate');
						component.set("v.showSearchIban",false);
						var countryCode = resp[0].substring(0, 2);
						var euroControlCode = resp[0].substring(2, 4);
						var cin = resp[0].substring(4, 5);
						var abi = resp[0].substring(5, 10);
						var cab = resp[0].substring(10, 15);
						var bankAccountNumber = resp[0].substring(15, 27);
						component.set("v.objectDataMap.BillingProfilePOS.OB_CountryCode__c",countryCode);
						component.set("v.objectDataMap.BillingProfilePOS.OB_EuroControlCode__c",euroControlCode);
						component.set("v.objectDataMap.BillingProfilePOS.OB_CINCode__c",cin);
						component.set("v.objectDataMap.BillingProfilePOS.OB_ABICode__c",abi);
						component.set("v.objectDataMap.BillingProfilePOS.OB_CABCode__c",cab);
						component.set("v.objectDataMap.BillingProfilePOS.OB_Bank_Account_Number__c",bankAccountNumber);
						component.set("v.objectDataMap.BillingProfilePOS.OB_IBAN__c",resp[0]);//davide.franzini - 19/04/2019 - RI-12_RI-18 - fullIban setted in obj datamap
						component.set("v.ibanDisabled", true);
						if(!$A.util.isEmpty(component.get("v.objectDataMap.BillingProfilePOS.OB_HeaderInternational__c"))){//davide.franzini 13/06/2019 - RI-104
							component.set("v.headerIntDisabled", true);//ANDREA SARACINI 23/05/2019 CR R1F2-181
						}
						component.set("v.showIbanSelModal", false);
						component.set("v.objectDataMap.isIbanValid",true);
					}
				}else{
					component.set("v.ibanDisabled", false);
					console.log('### No IBAN founded');
				}
			}
			else if (state === "ERROR") 
			{
				component.set("v.ibanDisabled", false);
				component.set("v.Spinner", false);
			}
			
		});
		$A.enqueueAction(act);
	},
	
	getSelectedOption: function(component, event){
		console.log("### selectedRecord value: " + event.target.value);
		var selectedIban = event.target.value;
		if(typeof selectedIban !== 'undefined' && selectedIban!= null && selectedIban!= ''){
			var countryCode = selectedIban.substring(0, 2);
			var euroControlCode = selectedIban.substring(2, 4);
			var cin = selectedIban.substring(4, 5);
			var abi = selectedIban.substring(5, 10);
			var cab = selectedIban.substring(10, 15);
			var bankAccountNumber = selectedIban.substring(15, 27);
			component.set("v.objectDataMap.BillingProfilePOS.OB_CountryCode__c",countryCode);
			component.set("v.objectDataMap.BillingProfilePOS.OB_EuroControlCode__c",euroControlCode);
			component.set("v.objectDataMap.BillingProfilePOS.OB_CINCode__c",cin);
			component.set("v.objectDataMap.BillingProfilePOS.OB_ABICode__c",abi);
			component.set("v.objectDataMap.BillingProfilePOS.OB_CABCode__c",cab);
			component.set("v.objectDataMap.BillingProfilePOS.OB_Bank_Account_Number__c",bankAccountNumber);
			component.set("v.objectDataMap.BillingProfilePOS.OB_IBAN__c",selectedIban);//davide.franzini - 19/04/2019 - RI-12_RI-18 - fullIban setted in obj datamap
			component.set("v.showIbanSelModal", false);
			component.set("v.objectDataMap.isIbanValid",true);
		}else{
			console.log("### no Iban Selected or Undefined");
			component.set("v.showIbanSelModal", false);
			component.set("v.Spinner", false);
		}
	},
	//D.F. _ END
	
	// Daniele Gandini <daniele.gandini@accenture.com> - 19/06/2019 - Logic for Request Details Section - START
	checkProfileLoggedUser_helper : function(component, event, helper){
        var action = component.get("c.checkProfileLoggedUser");
        action.setCallback(this, function(response)
        {
            var state = response.getState();
            if (state === "SUCCESS")
            {
                var isOperationLogged = response.getReturnValue();
                component.set( "v.isOperationLogged",  isOperationLogged);
            }
            else if (state === "INCOMPLETE")
            {
            }
            else if (state === "ERROR")
            {
                    var errors = response.getError();
                    if (errors)
                    {
                        if (errors[0] && errors[0].message)
                        {
                        }
                    } else {
                    }
            }
        });
        $A.enqueueAction(action);
	},
	// Daniele Gandini <daniele.gandini@accenture.com> - 19/06/2019 - Logic for Request Details Section - END

		//start------simone misani R1F2-115 15/05/2019 function for current user
		currentUse : function(component, event, helper){

			var act = component.get("c.getUserInformation");
			
			act.setCallback(this, function(response){
				var state = response.getState();
				console.log("state: "+state);			 
				if (state === "SUCCESS"){
					var resp = response.getReturnValue();
					console.log('response currentUse: '+JSON.stringify(resp));
					console.log('response currentUse: '+JSON.stringify(resp.isOperation));
					component.set('v.isOp',resp.isOperation);
	
	
				}
			
			});
			$A.enqueueAction(act);
		},
		
	//end------simone misani R1F2-115 15/05/2019 function for current user
		
		// ID 155, Doris Dongmo <doris.tatiana.dongmo@accenture.com>, 30/04/2019 - END
		controlIsSpecialCharacterHelper: function(component,isMandatoryField, isSpecialCharacter, inputIdVar){
			try{
				component.set("v.isMandatoryField",isMandatoryField);
				component.set("v.isSpecialCharacter",isSpecialCharacter);
				
				if(isMandatoryField == true ||  isSpecialCharacter == true){
					
					$A.util.addClass(inputIdVar, 'slds-has-error');					
				   
				}
				
				else {
					
					$A.util.removeClass(inputIdVar, 'slds-has-error');
				}
	
			}catch(err){
				console.log( " ERROR " +err.message);
			}
	
		},

		// Daniele Gandini <daniele.gandini@accenture.com> - 19/06/2019 - method for understanding if in remove POS case - START
		removeCase_Helper : function(component, event, helper){
			var itemsInRemove = component.get("v.objectDataMap.itemsInRemove");
			if(itemsInRemove != undefined && itemsInRemove != '' && itemsInRemove != null){
				component.set("v.itemsInRemove", true);
			}
		},
		// Daniele Gandini <daniele.gandini@accenture.com> - 19/06/2019 - method for understanding if in remove POS case - END

		// Daniele Gandini <daniele.gandini@accenture.com> - 19/06/2019 - method for understanding if in modify offer stream - START
		offerModify_Helper  : function(component, event, helper){
			var dataMap = component.get("v.objectDataMap");
			if(dataMap.OrderHeader.OB_Main_Process__c == 'Maintenance' && dataMap.OrderHeader.OB_Sub_Process__c == 'variazione operativa'){
				component.set("v.isModificaOfferta", true);
			}
		}
		// Daniele Gandini <daniele.gandini@accenture.com> - 19/06/2019 - method for understanding if in modify offer stream - END
	
		// ID 155, Doris Dongmo <doris.tatiana.dongmo@accenture.com>, 30/04/2019 - END
	
})