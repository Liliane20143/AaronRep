({	
	//START andrea.saracini 25/02/2018 - obsolete
	/*
	callCancelOrder : function(component, event) {
		component.set("v.spinner", true);
		var action = component.get("c.callCancelOrder");
        action.setParams({ 
			"offerAssetId" : component.get("v.offerAssetId")
		});
        action.setCallback(this, function(response) {
			var state = response.getState();
            if (state === "SUCCESS") {
				var cancelled = response.getReturnValue();
				component.set("v.spinner", false);
				if(!cancelled){
					var infoMessage = $A.get("$Label.c.OB_NoCancel");
					
					this.showInfoMessage(component, event, infoMessage);
				}
			} else if (state === "INCOMPLETE") {
					// do something
				component.set("v.spinner", false);
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
				component.set("v.spinner", false);
			}
		});

        $A.enqueueAction(action);
	},
	*/
	//END andrea.saracini 25/02/2018 - obsolete
	callAssetToOrder : function(component, event) {
		console.log("into callAssetToOrder");
		var t0 = performance.now();
		component.set("v.spinner", true);
		/*var flowCart = component.find("flowCartCmp");
		flowCart.destroy();*/
		//console.log("into AccountData: " + JSON.stringify(component.get("v.AccountData")));
		var accountData = component.get("v.AccountData");
		var accId = component.get("v.AccountData").Id;
		//francesca.ribezzi 21/06/19 adding fiscalCode
		var fiscalCode = component.get("v.AccountData").NE__Fiscal_code__c; 
		//START [01-04-2019 No Card Present] Andrea Saracini
		//var clickedBtn = event.getSource().getLocalId();
		var clickedBtn = component.get("v.typologiesValue");//[01-04-2019 No Card Present] Andrea Saracini

		// ANDREA MORITTU START - 18-Sept-2019 - EVO_PRODOB_452
		if(!$A.util.isUndefined(component.get('v.buttonChosenInNewCartPriceSummary')) && !$A.util.isEmpty(component.get('v.buttonChosenInNewCartPriceSummary')) ) {
			clickedBtn = component.get('v.buttonChosenInNewCartPriceSummary');
		}
		// ANDREA MORITTU END - 18-Sept-2019 - EVO_PRODOB_452

		console.log('clickedBtn is: ' + clickedBtn);
		var isSkipToIntBE = (clickedBtn == 'editIntBtn');
		//STOP [01-04-2019 No Card Present] Andrea Saracini
		var isPricing = (clickedBtn == 'pricingBtn' || clickedBtn == 'editCommissionBtn');
		// ANDREA MORITTU START - 18-Sept-2019 - EVO_PRODOB_452
		component.set('v.isPricing', isPricing);
		// ANDREA MORITTU END - 18-Sept-2019 - EVO_PRODOB_452
		var isEditCommissionModel = (clickedBtn == 'editCommissionBtn');
		var isTerminateOffer = (clickedBtn == 'terminateOfferBtn');
		/*ANDREA MORITTU START 2019.04.02*/
		var showCoBa = (clickedBtn == 'showCoBa');
		var currentUser = component.get("v.currentUser");
		console.log("currentUser", currentUser);
		var userABI = component.get("v.proposerABI");
		var userCAB = '';
		// Daniele Gandini <daniele.gandini@accenture.com>	- 02/05/2019 - TerminalsReplacement - START
		var isReplacement = (clickedBtn == 'replacementAction');
		if (isReplacement){
			component.set("v.isReplacement", isReplacement);
		}
		// Daniele Gandini <daniele.gandini@accenture.com>	- 02/05/2019 - TerminalsReplacement - END

		if(component.get("v.isCommunity")){
			// DG - 02/04/19
			
			userABI = currentUser.userABI; //Contact.Account.OB_ABI__c; 
			
			userCAB = currentUser.userCAB; //OB_CAB__c; 
			
			console.log("userABI: " + userABI);
			console.log("userCAB: " + userCAB);
			console.log("accId: " + accId);
		}
		console.log("isPricing: "+ isPricing);
		var action = component.get("c.callAssetToOrderServer");
		// Daniele Gandini <daniele.gandini@accenture.com>	- 02/05/2019 - TerminalsReplacement - isReplacement parameter added because of method signature modified - START
        console.log("into callAssetToOrderServer - offerAssetId: "+ component.get("v.offerAssetId") );
        action.setParams({ 
			"isReplacement" : isReplacement,
			"offerAssetId" : component.get("v.offerAssetId"),
			"isEditCommissionModel":isEditCommissionModel,
        	"isPricing" : isPricing,
        	"userABI": userABI,
        	"userCAB": userCAB,
			"accId": accId,
			"isTerminate": isTerminateOffer,
			"isSkipToIntBE": isSkipToIntBE //[01-04-2019 No Card Present] Andrea Saracini add OB_isSkipToIntBE__c
		});
		// Daniele Gandini <daniele.gandini@accenture.com>	- 02/05/2019 - TerminalsReplacement - isReplacement parameter added because of method signature modified - END
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
				//g.s 13/02/2019 get attribute from event to hide previous button if I open catalog
				try{
					var myEvent = component.getEvent("backSet");
					myEvent.setParams({"hideBackButton": true});
					myEvent.fire();
				}catch(err){
					console.log('ERROR EVENT: ' + err.message);
				}
                console.log("From server: "+ JSON.stringify(response.getReturnValue()));
				var t1 = performance.now();
				console.log("Call assetToOrder took " + (t1 - t0) + " milliseconds.")
				if(response.getReturnValue() != null){
					var objWrapper = response.getReturnValue(); // <daniele.gandini@accenture.com> - replacement - 02/05/2019
	                var bankABI =	objWrapper.newOrder.OB_ABI__c;
	                console.log("From server bankABI: "+ bankABI);
	                component.set("v.order", objWrapper.newOrder);
	                component.set("v.showPriceSummary", true);
	                var order = objWrapper.newOrder;
	                var isCommunity = component.get("v.isCommunity");
					//creating an objectDataMap:
					var objectDataMap = {};
					var unbind = {};
					var bank = {};
					bank.OB_ABI__c = bankABI;
					unbind.goToNextStepCatalog = '';
					unbind.offertaId = objWrapper.bundleId;
					//START - elena.preteni 10/07/2019 F2WAVE2-118
					unbind.isCompanyDataModified = 'false';
					//END - elena.preteni 10/07/2019 F2WAVE2-118
					var Configuration = {};
					Configuration.Id = order.Id;
					component.set('v.orderid',order.Id); // <daniele.gandini@accenture.com> - replacement - 02/05/2019
					Configuration.NE__Parameters__c = 'lightningFromVF='+isCommunity+';ordId='+order.Id;
					Configuration.OB_AdditionalDocumentationRequired__c = order.OB_AdditionalDocumentationRequired__c;
					var OrderHeader = {};
					OrderHeader.Id = order.NE__Order_Header__c;
					OrderHeader.OB_Sub_Process__c = objWrapper.variationType;
					console.log("OB_Sub_Process__c: " + OrderHeader.OB_Sub_Process__c);
					var merchant = {};
					merchant.Id = accId;
					merchant.OB_ATECO__c = accountData.OB_ATECO__c;//; 
					merchant.OB_Legal_Form__c = accountData.OB_Legal_Form__c;//;
					//francesca.ribezzi 21/06/19 adding fiscalCode
					merchant.NE__Fiscal_code__c = fiscalCode;
					var pv = {};
					pv.OB_MCC__c = order.OB_Service_Point__r.OB_MCC__c; //;
					pv.Id = component.get("v.ServicePointSelectedRow");
					//used for product documents cmp:
					//order.OB_MCC__c ='' ;//'7995';
					var bankProfile = {};
					bankProfile.OB_NeedBIO__c = objWrapper.needBIO;
					objectDataMap['unbind'] = unbind;
					objectDataMap['Configuration'] = Configuration;
					objectDataMap['OrderHeader'] = OrderHeader;
					objectDataMap['missingDocs'] =  false;//boolean
					objectDataMap['allCheckedLoad'] =  false;
					objectDataMap['merchant'] =  merchant;
					objectDataMap['pv'] =  pv;
					objectDataMap['order'] =  order;
					objectDataMap['abi'] =  userABI;
					objectDataMap['cab'] =  userCAB;
					objectDataMap['isCommunityUser'] =  isCommunity;
					objectDataMap['bank'] =  bank;
					objectDataMap['bankProfile'] =  bankProfile;
					console.log('###objectDataMap', objectDataMap);
					try{
					var bankAccountMap = new Map();
					// DG - 02/04/19
					bankAccountMap['OB_ABI__c']=component.get("v.currentUser").userABI; //Contact.Account.OB_ABI__c;
					var actionShare = component.get("c.share");
					actionShare.setParams({ 
						"bankAccountMap" : bankAccountMap,
						"orh":objectDataMap['OrderHeader'],
						"sp" : objectDataMap['pv'],
						"acc": objectDataMap['merchant'],
						"isCommunity": objectDataMap['isCommunityUser']
					});
					actionShare.setCallback(this, function(response){
						var state = response.getState();
						if (state === "SUCCESS") {
							console.log('SUCCESS');
						} else if (state === "INCOMPLETE") {
							// do something
							component.set("v.spinner", false);
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
							component.set("v.spinner", false);
						}
					});
					
					$A.enqueueAction(actionShare);
				}catch(err){
					console.log(err);
				}
		
		
					var step = 0;
					var bundleStep = 0;
					var isMaintenancePricing = false;
					var isEditCommissionModel = false;
					var isMaintenanceOffer = false;
					var isReplacement = false; // Daniele Gandini <daniele.gandini@accenture.com> - 29/04/2019 - TerminalsReplacement - If replacementAction case

					component.set("v.offertaId", objWrapper.bundleId);
					component.set("v.isMaintenance", true);
					component.set("v.bankABI", bankABI);
					component.set("v.objectDataMap", objectDataMap);
					
					if(clickedBtn == 'showCoBa') {
						component.set('v.showCoBaModal', true);
					} else if(clickedBtn == 'pricingBtn'){  
	                	step = 2;
	                	isMaintenancePricing = true;
					//START [21-05-2019 No Card Present] Andrea Saracini
					}else if(clickedBtn == 'editIntBtn'){  
						step = 1;
					//STOP [21-05-2019 No Card Present] Andrea Saracini
	                }else if(clickedBtn == 'editOfferBtn'){
						step = 1;
						isMaintenanceOffer = true;
					// Daniele Gandini <daniele.gandini@accenture.com>	- 29/04/2019 - TerminalsReplacement -  START - If replacementAction follow the maintenance offert flow
					}else if(clickedBtn == 'replacementAction'){
						step = 1;
						isReplacement = true;
						var dataMap = component.get("v.objectDataMap");
						dataMap["isReplacement"] = 'true';
						component.set("v.objectDataMap", dataMap);
					// Daniele Gandini <daniele.gandini@accenture.com>	- 29/04/2019 - TerminalsReplacement -  END - If replacement follow the maintenance offert flow
	                //this.createFlowCartComponent(component, event,order, objWrapper.bundleId, isCommunity, objectDataMap, bankABI);
					//START francesca.ribezzi 09/07/19 - WN-57 - adding editCommissionBtn condition
					}else if(clickedBtn == 'editCommissionBtn'){
						step = 1;
						isEditCommissionModel = true;
					}
					//END francesca.ribezzi  09/07/19 - WN-57 
					/*REMOVED TERMIATE OFFER CODE*/
	                component.set("v.step", step);
	                component.set("v.bundleStep", bundleStep);
	                component.set("v.isEditCommissionModel", isEditCommissionModel);
					component.set("v.isMaintenancePricing", isMaintenancePricing);
                    var ordId = objectDataMap.Configuration.Id;
					console.log("objWrapper.bundleId: " + objWrapper.bundleId);
					   component.set("v.spinner", false);
					   console.log('Perf31 Session id'+objWrapper.sessionId);
                    var maintenancePreloadEvent = $A.get("e.c:OB_MaintenancePreLoadEvent");
					//component.getEvent("maintenancePreloadEvent");
					// Daniele Gandini <daniele.gandini@accenture.com>	- 29/04/2019 - TerminalsReplacement -  START - isReplacement parameter added for event If replacementAction case
			        maintenancePreloadEvent.setParams({
			        	"ordIdParam": ordId,
						"isMaintenancePricing":isMaintenancePricing,
						"isMaintenanceOffer":isMaintenanceOffer,
			           	"objectDataMap"  : objectDataMap,
			           	"bankABI"  : bankABI,
						"bundleStep" : bundleStep,
						"step" : step,
						"isEditCommissionModel"  :isEditCommissionModel,
						"offertaId" : component.get("v.offertaId"),
						"isMaintenance": true,
						"isReplacement" : isReplacement,
						"assetId": component.get("v.offerAssetId"),
						"sessionId": objWrapper.sessionId
						
					});
					//console.log('preload perf 31 : '+JSON.stringify(maintenancePreloadEvent.getParams()));
					// Daniele Gandini <daniele.gandini@accenture.com>	- 29/04/2019 - TerminalsReplacement -  END - isReplacement parameter added for event If replacementAction case
					maintenancePreloadEvent.fire();
					var t2 = performance.now();
					console.log("Call assetToOrder end: " + (t2 - t0) + " milliseconds.");
	                
	           }else{
	        	   //showing error message
	        	   var errorMessage =  $A.get("$Label.c.OB_ServerErrorMessage"); //changeLabel 
	        	   this.showErrorBanner(component, errorMessage);
				   component.set("v.spinner", false);
				   // ANDREA MORITTU START 19-Sept-2019 - EVO_PRODOB_452 - Hide cancel request button
				   component.set('v.isPricing', false);
				   				   				   // ANDREA MORITTU END 19-Sept-2019 - EVO_PRODOB_452 - Hide cancel request button
	           }
            }
            else if (state === "INCOMPLETE") {
                // do something
                component.set("v.spinner", false);
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
                component.set("v.spinner", false);
            }
        });

        $A.enqueueAction(action);
		
	},
	
	
	createPriceSummaryComponent : function(component, event, order, bundleId,isCommunity,objectDataMap, bankABI) {
        console.log('### inside createPriceSummaryComponent()');
        $A.createComponent(
           "c:OB_FlowCart",
       {
        	"aura:id": "flowCartCmp",
            "step": 2, 
			"offertaId": bundleId,//offerdaId del Bundle
            "orderParameter":'lightningFromVF='+isCommunity+';ordId='+order.Id,
            "isMaintenance": true,
            "isMaintenancePricing": true,
           	"objectDataMap": objectDataMap,
           	"bankABI": bankABI
       },
           function(newCmp, status, errorMessage){
               if (status === "SUCCESS") {
                   var body = component.get("v.body");
                   body.push(newCmp);
                   component.set("v.body", body);
                   //francesca.ribezzi - firing event to father cmp:
		            var maintenanceEvent = component.getEvent("maintenanceEvent");
			        maintenanceEvent.setParams({
			        	"showPriceSummary": component.get("v.showPriceSummary")
			        });
			        maintenanceEvent.fire();
                   component.set("v.spinner", false);
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
	
	createFlowCartComponent: function(component, event, order, bundleId, isCommunity,objectDataMap, bankABI) {
		console.log("about to create FlowCart component...");
		console.log("offerid bundle: " + bundleId);
		console.log("order: ", order);
		console.log("objectDataMap: ", objectDataMap);
		console.log("bankABI: " + bankABI);

        $A.createComponent(
           "c:OB_FlowCart",
       {
        	"aura:id": "flowCartCmp",
           	"step": 1, 
			"bundleStep": 0, 
			"offertaId": bundleId,//offerdaId del Bundle
            "orderParameter":objectDataMap.Configuration.NE__Parameters__c,
            "isMaintenance": true,
            "objectDataMap": objectDataMap,
            "bankABI": bankABI
       },
           function(newCmp, status, errorMessage){
               if (status === "SUCCESS") {
                   var body = component.get("v.body");
                   body.push(newCmp);
                   component.set("v.body", body);
                   //francesca.ribezzi - firing event to father cmp:
		            var maintenanceEvent = component.getEvent("maintenanceEvent");
			        maintenanceEvent.setParams({
			        	"goToFlowCart": true,
			        	"showPriceSummary": true 
			        });
			        maintenanceEvent.fire();
                   component.set("v.spinner", false);
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
	
	getCommission: function(component, event, offerAsset){

		var commissionBtn = component.find('editCommissionBtn');
		console.log('commissionBtn'+commissionBtn);
		if( commissionBtn!=undefined && commissionBtn!=null){
			console.log("offer name: " +  offerAsset.Name);
			var action = component.get("c.getCommissionServer");
			action.setParams({ 
				offerAssetId : offerAsset.Id,
				offerName : offerAsset.Name
			});

			action.setCallback(this, function(response) {
				var state = response.getState();
				if (state === "SUCCESS") {
					console.log("From server getCommission: ", response.getReturnValue());
					var isAcqCommission = response.getReturnValue();
					//var offerAsset = component.get("v.offerAsset");
					commissionBtn.set('v.disabled',!isAcqCommission);
					
					
				//	if(offerAsset.NE__Status__c != 'In Progress' && !isAcqCommission){
				//		commissionBtn.set('v.disabled',false);
				//	}
				
				}
				else if (state === "INCOMPLETE") {
					// do something
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
		}
	},
	
	goToAcquiringStep: function(component, event, order, bundleId, isCommunity,objectDataMap, bankABI) {
		console.log("going to Acquiring Step...");

        $A.createComponent(
           "c:OB_FlowCart",
       {
        	"aura:id": "flowCartCmp",
           	"step": 1, 
			//"bundleStep": 2, //acquiring step
			"offertaId": bundleId,//offerdaId del Bundle
            "orderParameter":objectDataMap.Configuration.NE__Parameters__c,
            "isMaintenance": true,
            "objectDataMap": objectDataMap,
            "bankABI": bankABI,
            "isEditCommissionModel": true,
            "isMaintenance": true
        
           // "isMaintenanceCommission": true
       },
           function(newCmp, status, errorMessage){
               if (status === "SUCCESS") {
                   var body = component.get("v.body");
                   body.push(newCmp);
                   component.set("v.body", body);
                   //francesca.ribezzi - firing event to father cmp:
		            var maintenanceEvent = component.getEvent("maintenanceEvent");
			        maintenanceEvent.setParams({
			        	"goToFlowCart": true,
			        	"showPriceSummary": true 
			        });
			        maintenanceEvent.fire();
                   component.set("v.spinner", false);
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

	checkForPendingOrders : function(component, errorMessage){
		var offerAssetId = component.get("v.offerAssetId");


	},
	showErrorBanner : function(component, errorMessage){
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

	showInfoMessage : function(component, event, infoMessage){
		console.log("into show info message");
	    var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: '',
            message: infoMessage,
            //messageTemplateData: [name],
            duration: '5000',
            key: 'info_alt',
            type: 'info',
            mode: 'dismissible'
        });
        toastEvent.fire();
	},
	/* andrea.morittu start 29.04.2019 - ID_Stream_6_Subentro - calling bit2flow method*/
	getTakeoverFromAsset : function(component, event) {
		console.log('inside getTakeoverFromAsset function');
		var offerAssetId = component.get("v.offerAssetId");
		return new Promise(function(resolve, reject){
			var action = component.get("c.getMerchantTakeoverFromAsset");
			action.setParams({ offerAssetId : offerAssetId });
			action.setCallback(this, function(response){
			   if(response.getState() === 'SUCCESS'){
					var merchantTakeOver =response.getReturnValue();
					resolve(merchantTakeOver);  
			   } else {
				  reject();
			   }
			});
			$A.enqueueAction(action);
		 });
	  },
	/* andrea.morittu start 29.04.2019 ID_Stream_6_Subentro* - INSIDE CHANGE COMPANY NAME*/
	showCompanyFunction : function(component, event, helper) {
		console.log('inside showCompanyFunction function');
		var merchantTakeoverAsset = false;
		helper.getTakeoverFromAsset(component, event).then($A.getCallback(function(merchantTakeOver){
			merchantTakeoverAsset = merchantTakeOver;
			console.log('merchantTakeoverAsset is : ' + merchantTakeoverAsset);
			if(merchantTakeoverAsset) {
				var infoMessage = $A.get("{!$Label.c.OB_MerchantTakeOverInProcess}");
				helper.showInfoMessage(component, event, infoMessage);
			} else {
				helper.callbit2FlowSetup(component,event, helper);
			}
		}));
	},
	/* andrea.morittu end 29.04.2019 ID_Stream_6_Subentro* - INSIDE CHANGE COMPANY NAME*/

	callbit2FlowSetup : function(component, event, helper) {
		console.log('inside callbit2FlowSetup function');
		var assetId = component.get("v.offerAssetId");
		var offerAssetId = component.get("v.offerAssetId");
		var wizardName = component.get("v.wizardAPIname");
		var objectType = 'Asset';
		
		var action = component.get("c.launchMaintenanceWizard");
		action.setParams({
			"wizardName": wizardName
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
				var wizId = response.getReturnValue();
				var objectId = assetId;
                component.set("v.wizardConfigurationId", wizId);
				var wizardConfigurationId = component.get("v.wizardConfigurationId");

				console.log("objectType: " + objectType);
                console.log("wizardConfigurationId: " + wizId);
                console.log("inputParameters: " + 'Id::'+objectId);
				component.set("v.merchantTakeOverBoolean", true);
				console.log('WIZARD: ' + wizId);
				console.log('WIZARD: ' + objectId);
				console.log('WIZARD: ' + objectType);
				console.log('WIZARD: ' + objectId);
                $A.createComponent
                (
                    "bit2flow:dynWizardMain",
                    {
                            "wizardConfigurationId": wizId,
                            "sourceVF": true,
                            "objectId": objectId,//,
                            "objectType": objectType,//objectType,
                            "displayMenu" : false,
                            "params" : 'Id::'+objectId,
                            "showMainToast": false
                    },

                    function(newCmp, status, errorMessage)
                    {
                        if (status === "SUCCESS" && newCmp.isValid())
                        {
                            var body = component.get("v.body");
                            //MAS && AAP 24/08/2018  avoid launching more than one wizard at the same time and window
                            if ($A.util.isUndefinedOrNull (body) || body.length > 0)
                            {
                                body = [];
                                component.set("v.body", body);
                            }
							//END MAS && AAP 24/08/2018
							var mainComponent = component.find("mainComponentDiv");
							mainComponent.destroy();
                            body.push(newCmp);
							component.set("v.body", body)
							component.set("v.bodyComponent", body);
                            var t1 = performance.now();
							helper.destroyMainWholeComponent(component,event,helper);
                        } else if (status === "INCOMPLETE") {
                            //TODO:Error handling
                        } else if (status === "ERROR") {
                            //TODO:Error handling
                        }
                    }.bind(this)
                );
                component.set("v.blockCheckOut", true);
            } else if (state === "ERROR") {
            	_utils.debug('GET WIZARD ID FROM API NAME ERROR');
            }
        });
		$A.enqueueAction(action);
	},

	/*
		@Author	: Morittu Andrea
		@Date 	: 2019.05.07
		@Task	: ID_Stream_6_Subentro
	*/
	destroyMainWholeComponent : function(component, event, helper) {
		
		var merchantTakeOver = $A.get("e.c:OB_DestroyMaintenanceSummary");
		var isTrue = true;
		component.set("v.showBit2Flow", isTrue);
		var body = component.get("v.bodyComponent");
		merchantTakeOver.setParams	({"merchantTakeoverProcess" : isTrue,
									  "bodyAttribute"			: body
									});
		merchantTakeOver.fire();
	},
	/* Andrea.Morittu END 2019.05.07 */
	/*
		@Author	:	Morittu Andrea
		@Date	:	2019.05.09
		@Task	:	ID_Stream_6_Subentro
	*/
	updateAssetABIandCAB : function(component, event, helper) {

		var offerAssetId	= 	!$A.util.isEmpty(component.get("v.offerAssetId")) ? component.get("v.offerAssetId") : null ;
		var selectedCAB = !$A.util.isEmpty(component.get("v.currentUser").userCAB) ? component.get("v.currentUser").userCAB : null ;
		var action = component.get("c.updateABIandCABInsideAssetObj");
		action.setParams({ 	offerAssetId 	:		offerAssetId,
							selectedCAB		: 		selectedCAB
						});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				console.log('ABI && CAB was updated succesfully on Asset');
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
		$A.enqueueAction(action);
	},

	/*
		@Author	:	Morittu Andrea
		@Date	:	2019.05.09
		@Task	:	Fix F2WAVE2-75
	*/
	terminateOffer : function(component, event, helper) {
		var userABI = component.get("v.proposerABI");
		var currentUser = component.get("v.currentUser");
		var userCAB = currentUser.userCAB;
		var accId = component.get("v.AccountData").Id;

		try {
			var action = component.get("c.callAssetToOrderServer");
		action.setParams({ 	"isReplacement" : false,
							"offerAssetId" : component.get("v.offerAssetId"),
							"isEditCommissionModel": false,
							"isPricing" : false,
							"userABI": userABI,
							"userCAB": userCAB,
							"accId": accId,
							"isTerminate": true,
							"isSkipToIntBE": false
						});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
				var response = response.getReturnValue();
				helper.createLogHelper(component, event, helper,userABI, userCAB, response);
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

		$A.enqueueAction(action);
		
			
		} catch(e) {
			console.log('An error has occured : ' + e.message);
		}

	},

	/*
		@Author	:	Morittu Andrea
		@Date	:	05-Jun-19
		@Task	:	Fix F2WAVE2-75
	*/
	closeTerminateOfferModal : function(component, event, helper) {
		component.set('v.showTerminalOfferModal', false);
	},
	/*
		@Author	:	Morittu Andrea
		@Date	:	05-Jun-19
		@Task	:	Fix F2WAVE2-75
	*/
	createLogHelper : function(component, event, helper, userABI, userCAB, response) {
		var objectDataMap = component.get('v.objectDataMap');
		var pv = objectDataMap.pv;
		var objWrapper = response;
		var configurationId = objWrapper.newOrder.Id;
		var accId = component.get("v.AccountData").Id;

		try {
			var createLog = component.get("c.createLogRequest");
			createLog.setParams({ 
				"merchantId":	accId, 
				"servicePointId": component.get("v.ServicePointSelectedRow"), 
				"confId": configurationId, 
				"abi":	userABI, 
				"cab":	userCAB, 
				"subProcess": "termina offerta"//Simone Misani 107 13/07/2019
			});
			createLog.setCallback(this, function(response){
				var state = response.getState();
				if (state === "SUCCESS") {
					var res = response.getReturnValue();
					if(res==""){
						component.set("v.spinner", false);
						return;
					} 
					
					window.location.href = res;
					return;
				} else if (state === "INCOMPLETE") {
					// do something
					component.set("v.spinner", false);
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
					component.set("v.spinner", false);
				}
			});
			
			$A.enqueueAction(createLog);
			return;
		}catch(e) {
			console.log('An error has occured : '+ e.message);
		}
	},
	/*
	*	Author		:	Morittu Andrea	
	*	Date		:	27-Sep-2019
	*	Task		:	EVO_PRODOB_469
	*	Description	:	Retrieve all mcc where the type is MCC
	*/
	getLOVnameByMCC : function(component, event) 
	{
		return new Promise($A.getCallback(function(resolve, reject) 
		{
			var action = component.get("c.getMCCdescriptionByLOV");
			action.setCallback(this, function(response) {
				var state = response.getState();
				if (state === "SUCCESS") {
					let MCClovs = response.getReturnValue();
					if(!$A.util.isUndefinedOrNull(MCClovs)) {
						console.log('MCClovs  is ' , MCClovs);
						component.set('v.mccLOVSList', MCClovs );
						resolve(MCClovs);
					}
				} 
				else if (state === "INCOMPLETE") 
				{
				}
				else if (state === "ERROR") 
				{
					var errors = response.getError();
					let error = new Error(response.getError());
					reject(error);
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
		}));
	},
		/*
	*	Author		:	Francesca Ribezzi	
	*	Date		:	11-11-2019
	*	Task		:	PROD-42
	*	Description	:	setting abi and cab on currentUser when Operation
	*/

	handleCurrentUser: function(component, event, orderId) {
		try {
			var action = component.get("c.getCABandABIfromOrder");
			action.setParams({ 
				"orderId":	orderId
			});
			action.setCallback(this, function(response){
				var state = response.getState();
				if (state === "SUCCESS") {
					var res = response.getReturnValue();
					component.set("v.currentUser", res);
				} else if (state === "INCOMPLETE") {
					// do something
					component.set("v.spinner", false);
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
					component.set("v.spinner", false);
				}
			});
			
			$A.enqueueAction(action);
			return;
		}catch(e) {
			console.log('An error has occured : '+ e.stack);
		}
	
	},

	/*
	*	Author		:	Gianluigi Virga	
	*	Date		:	25-11-2019
	*	Task		:	Performance
	*	Description	:	retrieve line items and Line items attributes
	*/
	retrieveLineItemsAndLineItemAttributes : function(component, event) {
		var offerAssetId = component.get("v.offerAssetId");
		var offerAssetSelected = component.get("v.offerAssetSelected");
		try {
			var action = component.get("c.retrieveLineItemsAndItemAttributes");
			action.setParams({ 
				"offerAssetId":	offerAssetId,
				"orderId": offerAssetSelected.NE__Order_Config__c
			});
			action.setCallback(this, function(response){
				var state = response.getState();
				if (state === "SUCCESS") {
					component.set("v.callRetrieveItemsAndItemAttributes", true);
				}
				if (state === "ERROR") {
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							console.log("Error message: " + errors[0].message);
						}
					} else {
						console.log("Unknown error");
					}
				}
			});
			$A.enqueueAction(action);
		}catch(e) {
			console.log('An error has occured : '+ e.stack);
		}
	}
})