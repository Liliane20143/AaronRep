({
	getAcqChanges : function(component, event) {
	//ANDREA MORITTU START 26/02/2019

	var url = window.location.href;
	//"https://dev1-nexionedev.cs88.force.com/s/ob-upload-documents?id=a0y9E000004N40x"
	console.log("url: "+url);
	
	if(url.includes("=")){
		var parts = url.split("=");
		//var part1 = parts[0]; 
		var part2 = parts[1];
		console.log("id: "+part2);
		
		component.set("v.confId", part2);
		var conId = component.get("v.confId"); //'a0y9E000004N40x';
		if(conId != undefined && conId != null && conId != ""){
		var acquiringHasChanges = false;
		var acquiringChanges = component.get("c.acquiringChangesServer");
		acquiringChanges.setParams({ configurationId : conId });

		acquiringChanges.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				acquiringHasChanges = response.getReturnValue();
				console.log('acquiringHasChanges is: ' + acquiringHasChanges);
			    this.getConfigurationData(component, event,acquiringHasChanges);
			}
			else if (state === "INCOMPLETE") {
			}
			else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						console.log("Error message: " + 
									errors[0].message);
					}
				} else {
				console.log("Unknown error");
			}
		}
		});
		$A.enqueueAction(acquiringChanges);
		//ANDREA MORITTU END 26/02/2019
			}
		}
	},


	getConfigurationData : function(component, event, acquiringHasChanges) {

		//***** 05/02/2019 SIMONE MISANI - GET  CONFID FORM URL -- START */

		var conId = component.get("v.confId");  
				console.log("dentro if");
				console.log("getObjectDataMapServer: "+component.get("c.setConfigurationToApprove"));
					
				var action = component.get("c.setConfigurationToApprove");
				
				action.setParams({ confId : conId });
			
			
				action.setCallback(this, function(response) {
					var state = response.getState();
					if (state === "SUCCESS") {

						console.log("From getObjectDataMapServer: " , response.getReturnValue());
						var data = response.getReturnValue();
						component.set("v.data", data);
						//E UN ALTRO BOOLEANO --> metodo apex che se restituisce true
						// var x = checkForAcquiringChanges
						if(data.OB_AgreedChanges__c && acquiringHasChanges){
							console.log("creatingObjectDataMap");
						
							//create objectdatamap and going to documentation cmp
							this.creatingObjectDataMap(component, event, data);
							console.log('After creatingObjectDataMap' + creatingObjectDataMap);
							
						}else{
							console.log("createLogRequest");
							
							console.log(component.get("v.objectDataMap"));
							//create log request and exit:
							this.createLogRequest(component, event);
							console.log("logreqID: "+ component.get("v.logReqId"));
							
							
						}
						
						
					}

					//***** 05/02/2019 SIMONE MISANI - GET  CONFID FORM URL -- END */
					
					else if (state === "INCOMPLETE") {
						console.log('INCOMPLETE');
					}
					else if (state === "ERROR") {
						var errors = response.getError();
						if (errors) {
							if (errors[0] && errors[0].message) {
								console.log("Error message: " + 
										errors[0].message);
							}
						} else {
							console.log("Unknown error");
						}
					}
				});

				$A.enqueueAction(action);
	},

	creatingObjectDataMap: function(component, event, data){
		console.log('Data: ' + data);
		//creating an objectDataMap:
	//	var isCommunity = true;
		var objectDataMap = {};
		var unbind = {};
		var Configuration = {};
		Configuration.Id = data.Id;
		var OrderHeader = {};
		OrderHeader.Id = data.NE__Order_Header__c;
		OrderHeader.OB_Sub_Process__c = data.NE__Order_Header__r.OB_Sub_Process__c;
		console.log("OB_Sub_Process__c: " + OrderHeader.OB_Sub_Process__c);
		var merchant = {};
		merchant.Id = data.NE__AccountId__c;
		merchant.OB_ATECO__c = data.NE__AccountId__r.OB_ATECO__c;//accountData.OB_ATECO__c; 
		merchant.OB_Legal_Form__c = data.NE__AccountId__r.OB_Legal_Form__c;//accountData.OB_Legal_Form__c;
		var pv = {};
		pv.OB_MCC__c = data.OB_Service_Point__r.OB_MCC__c; //order.OB_Service_Point__r.OB_MCC__c;
		pv.Id = data.OB_Service_Point__c;
		//used for product documents cmp:
		var order = {};
		order.OB_MCC__c =data.OB_MCC__c;//'7995';
		
		var bank = {};
		bank.OB_ABI__c = data.NE__Order_Header__r.OB_ProposerABI__r.OB_ABI__c;
		var abi = data.NE__Order_Header__r.OB_ProposerABI__r.OB_ABI__c;
		var cab = data.NE__Order_Header__r.OB_CAB__c;

		objectDataMap['unbind'] = unbind;
		objectDataMap['Configuration'] = Configuration;
		objectDataMap['OrderHeader'] = OrderHeader;
		objectDataMap['missingDocs'] =  false;//boolean
		objectDataMap['allCheckedLoad'] =  false;
		objectDataMap['merchant'] =  merchant;
		objectDataMap['pv'] =  pv;
		objectDataMap['order'] =  order;
	//	objectDataMap['isCommunityUser'] =  isCommunity;
		objectDataMap['abi'] =  abi;
		objectDataMap['cab'] =  cab;
		objectDataMap['bank'] =  bank;
		component.set("v.objectDataMap", objectDataMap);
		component.set("v.showDocuments",true);

	},

	createLogRequest: function(component, event){
		try{
		
		console.log("__into createLogRequest");

		var data = component.get("v.data");
		console.log("__into data: " , data);
    	var action = component.get("c.createLogRequestServer");
	        action.setParams({ 
	        	"merchantId": data.NE__AccountId__c,
	        	"servicePointId":  data.OB_Service_Point__c,
	        	"confId": data.Id,
	        	"abi" : data.OB_ABI__c,
				"cab": data.OB_CAB__c,
				"subProcess" : data.NE__Order_Header__r.OB_Sub_Process__c
			});
			
			console.log("response log request: "+ data.NE__AccountId__c);
			console.log("response log request: " +data.OB_Service_Point__c);
			console.log("response log request: " +data.Id);
			console.log("response log request: "+  data.OB_ABI__c);
			console.log("response log request: "+  data.OB_CAB__c);
			console.log("response log request: "+  data.NE__Order_Header__r.OB_Sub_Process__c);
	        action.setCallback(this, function(response) {
				var state = response.getState();
				console.log("dentro action.setCallback");
	            if (state === "SUCCESS") {
	                console.log("response log request: ", response.getReturnValue());
					var res = response.getReturnValue();
					console.log('res'+JSON.stringify(res));
	                if(res){	
						console.log('res'+JSON.stringify(res));
						//redirect to asset page --TEMP

						component.set("v.logReqId",res);

						// DG - 09/02/2019 - 1308 - START
						var stringUrl = component.get("c.getStringUrl");
						stringUrl.setCallback(this, function(response){
							var state = response.getState();
							if (state === "SUCCESS") 
							{
								var status = response.getReturnValue();
								console.log('@@@@@RESPONSE Status ' + status);
								console.log('@@@@ url to logRequest: ' + status+'/'+res);

								window.location.href = status+'/'+res;
								// DG - 09/02/2019 - 1308 - END

								//console.log("logReqId: "+"v.logReqId");
								var flowMaintenanceEvent = $A.get("e.c:OB_FlowCartMaintenanceEvent");
								flowMaintenanceEvent.setParams({goBackToMaintenanceDetails : true});
								flowMaintenanceEvent.fire();	
								var type = 'success';
								var infoMessage = 'Richiesta presa in carico';
								this.showInfoToast(component, event, infoMessage, type);
								

								
							} 
							else if (state === "INCOMPLETE"){ /* do something */}
							else if (state === "ERROR"){
								var errors = response.getError();
								if (errors) {
									if (errors[0] && errors[0].message) {
										console.log("Error message: " + errors[0].message);
									}
								} 
								else 
								{
									console.log("Unknown error");
								}
							}
						});
						$A.enqueueAction(stringUrl);
						
	                }
				}
	            else if (state === "INCOMPLETE") {
	            	component.set("v.spinner",false);
	            }
	            else if (state === "ERROR") {
	                    var errors = response.getError();
	                    if (errors) {
	                        if (errors[0] && errors[0].message) {
								console.log("Error message: " + 
								errors[0].message);
	                            // _utils.debug("Error message: " + 
	                                        // errors[0].message);
	                        }
	                    } else {
	                        // _utils.debug("Unknown error");
	                    }
	                    component.set("v.spinner",false);
	            }
	        });
	        $A.enqueueAction(action);
	        component.set("v.spinner", true);
		}catch(err){
			console.log(err);
		}
	
	},
	
	showInfoToast: function(component, event, infoMessage, type){
	    _utils.debug("into showInfoToast");
    	var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: '',
            message: infoMessage,
            //messageTemplateData: [name],
            duration: '5000',
            key: 'info_alt',
            type: type,
            mode: 'pester'
        });
        toastEvent.fire();
    },
    
})