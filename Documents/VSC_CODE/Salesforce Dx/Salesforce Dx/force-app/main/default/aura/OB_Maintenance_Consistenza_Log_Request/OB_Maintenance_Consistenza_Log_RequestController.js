({
	doInit: function (component, event, helper) 
	{

		console.log('doInit log request maintenance');
				try
		{
			var actionToRetrieveLogRequest = component.get("c.retrieveLogRequestConsistenza");
			actionToRetrieveLogRequest.setParams({ 
				"logRequestId": component.get("v.recordId")
			});
			actionToRetrieveLogRequest.setCallback(this,function(response)
			{
				var state = response.getState();
				if (state === "SUCCESS") 
				{
					//SET ATTRIBUTES VALUE
					var contextLogRequest = response.getReturnValue();
					
					component.set("v.contextLogRequest"		,	contextLogRequest);
					/*ANDERA START 25/01/2019*/
					var logRequest = component.get("v.contextLogRequest");
					//START Simone Misani 03/07/2019  F2WAVE2-82
					if(!logRequest.OB_Track_LogRequest__c){
						component.set("v.confId",	logRequest.OB_OrderId__c);					
						helper.checkconfigtec(component, event, helper);
					}
					//END Simone Misani 03/07/2019  F2WAVE2-82
					var lookupsLogRequest = [];
					console.log('logRequest is: ' + logRequest);
					if(typeof(logRequest) != undefined ) {
						/*LOOKUP WITH ACCOUNT*/
						lookupsLogRequest.push(logRequest.OB_AccountId__c);
						console.log("@@@@ logRequest.OB_AccountId__c:  " + logRequest.OB_AccountId__c);
						/*LOOKUP WITH CONFIGURATION*/
						lookupsLogRequest.push(logRequest.OB_OrderId__c);
						console.log("logRequest.OB_OrderId__c is: " + logRequest.OB_OrderId__c);						
						/*LOOKUP WITH SERVICE POINT*/
						lookupsLogRequest.push(logRequest.OB_ServicePointId__c);
						console.log("logRequest.OB_ServicePointId__c is: " + logRequest.OB_ServicePointId__c);
						
						/*FUNCTION TO CHECK IF IN THE LOG REQUEST THERE'S ALL POPULATED LOOKUPS*/
						function checkPopulatedLookups(lookupsLogRequest) {
						  return ( typeof(lookupsLogRequest) !=undefined && lookupsLogRequest != null && lookupsLogRequest!= "");
						}
						var lookupsAreNotEmpty = lookupsLogRequest.every(checkPopulatedLookups);
						console.log("lookupsAreNotEmpty is: " + lookupsLogRequest.every(checkPopulatedLookups));
						//IF ALL LOOKUPS ARE POPULATED
						if(lookupsAreNotEmpty == true) {
						
							component.set("v.isError", false);
							component.set("v.confId",	contextLogRequest.OB_OrderId__c );
							console.log("### config ID is: " + component.get("v.confId"));
							var getConfiguration = component.get("c.getConfigurationServer");
							getConfiguration.setParams({ configurationId : component.get("v.confId") });
							getConfiguration.setCallback(this, function(response) {
								var state = response.getState();
								if (state === "SUCCESS") {
									/*RETRIEVE THE CONFIGURATION RELATED TO THE LOG REQ*/
									var configuration = response.getReturnValue();
									if(configuration != null) {
										if(configuration.OB_CTI_Code__c != null) {
											component.set('v.CTICode', configuration.OB_CTI_Code__c);
										}
										component.set("v.configuration" , configuration);
									}
									// console.log("## configuration is : " + JSON.stringify(configuration));
									//Salvatore Pianura start
									component.set("v.dataInstallazionePos"		,	contextLogRequest.OB_InstallationDate_POS__c 		);
									component.set("v.dataDisinstallazionePos"	,	contextLogRequest.OB_UninstallationDate_POS__c 	);
									component.set("v.codiceConvenzione"			,	contextLogRequest.OB_ConventionCode__c 			);
									component.set("v.companyCode"				,	contextLogRequest.OB_CompanyCode__c 				);
									component.set("v.hasPos"					,	contextLogRequest.OB_HasPos__c					);
									component.set("v.hasVas"					,	contextLogRequest.OB_HasVas__c					);
									console.log("has Vas is:  " + component.get("v.hasVas"));
									component.set("v.hasAcquiring"				,	contextLogRequest.OB_HasAcquiring__c				);
									component.set("v.status" 					,	contextLogRequest.OB_Status__c 					);
                                    console.log('@@@ contextLogRequest' + JSON.stringify(contextLogRequest));
										
									var hasPos 			= component.get("v.hasPos");
									var hasAcquiring 	= component.get("v.hasAcquiring");
									var hasVas 			= component.get("v.hasVas");
									var savedPos 		= component.get("v.savedPos");
									var savedAcq 		= component.get("v.savedAcq");
									var rejectedPos 	= component.get("v.rejectedPos");
									var rejectedAcq 	= component.get("v.rejectedAcq");
									var actionToCheckLogRequest = component.get("c.checkProfileOnLogRequestConsistenza");

								actionToCheckLogRequest.setCallback(this, function(response)
								{
									var state = response.getState();
									if (state === "SUCCESS") 
									{
										var isOperation = response.getReturnValue();
										console.log('IS NOT OPERATION IS : ' + component.get("v.isNotOperation"));
										if(logRequest.OB_Status__c == 'Bozza'){
											isOperation = false;
										}
										//24/06/19 francesca.ribezzi -->  !isOperation instead of isOperation - F2WAVE2-6
										component.set("v.isNotOperation", !isOperation);
										component.set("v.operationLogged", isOperation);//Simone Misani 17/12/2019 Perf-76

									} 
									else if (state === "INCOMPLETE")
									{
										//do something
									}
									else if (state === "ERROR") 
									{
										var errors = response.getError();
										if (errors) 
										{
											if (errors[0] && errors[0].message) 
											{
												console.log("OB_Maintenance_Consistenza_Log_RequestController.js : checkProfileOnLogRequestConsistenza : Error message: "
												 + errors[0].message);
											}
										}
										else 
										{
											console.log("OB_Maintenance_Consistenza_Log_RequestController.js : checkProfileOnLogRequestConsistenza : *UNKNOW ERROR*");
										}
									}
								});
								$A.enqueueAction(actionToCheckLogRequest);

							var getSortedConfigItems = component.get("c.getSortedConfigItemsServer2");
							var config = component.get("v.configuration");
							console.log('#@#@ dynamic configuration id is: ' + JSON.stringify(config.Id));
							/* SET AS PARAMETER THE CONFIGURATION ID*/
							getSortedConfigItems.setParams({ "configurationId" : config.Id });

							getSortedConfigItems.setCallback(this, function(response) {
								var state = response.getState();
								if (state === "SUCCESS") {

									var allConfigItems = response.getReturnValue();
									console.log("##### before : " + JSON.stringify( allConfigItems));
									allConfigItems = allConfigItems.replace('\"', '"');
									allConfigItems = JSON.parse(allConfigItems);

									var listPOStItem;
									var listAcquiringItem;
									var listVasItem;
									var listPagoBancomatItem;
									//START - elena.preteni descoping 28/06/2019
									var listIntegrazionetItem;
									var integrazionetItemAttribute;
									var listGatewaytItem;
									var filteredVasGateway;
									//END - elena.preteni descoping 28/06/2019

									console.log("##### after : " + JSON.stringify(allConfigItems));
									if(allConfigItems.isFirstPos == "true"){
										component.set("v.isFirstPos",true);
									}
									
									if(allConfigItems.listPOStItem!=null&& allConfigItems.listPOStItem!=undefined &&allConfigItems.listPOStItem.length>0 )
									{	
										listPOStItem = JSON.parse(allConfigItems.listPOStItem.replace('\"', '"'));
										component.set("v.configurationTerminalObject",listPOStItem);
										//06-03-2019--S.P.--SET HAS POS
										if(listPOStItem.length>0)
										{
											component.set("v.hasPos",true);											
										}
										if(allConfigItems.isNotIntegrated == 'true'){
											component.set("v.isNotIntegrated",true);
											

										}

									}
									if(allConfigItems.listAcquiringItem!=null&& allConfigItems.listAcquiringItem!=undefined &&allConfigItems.listAcquiringItem.length>0 )
									{
										listAcquiringItem = JSON.parse(allConfigItems.listAcquiringItem.replace('\"', '"'));
										component.set("v.configurationACQUIRINGItems",listAcquiringItem);
										//06-03-2019--S.P.--SET HAS ACQUIRING
										if(listAcquiringItem.length>0)
										{
											component.set("v.hasAcquiring",true);
										}
									}

									if(allConfigItems.listVasItem!=null&& allConfigItems.listVasItem!=undefined &&allConfigItems.listVasItem.length>0 )
									{	listVasItem = JSON.parse(allConfigItems.listVasItem.replace('\"', '"'));
										//elena.preteni 10/06/2019 descoping consistenza VAS ecommerce
										var filteredVAS = [];
										var filteredRecOneClick = [];
										var filteredVasGateway = [];
										for(var i = 0; i < (listVasItem).length; i++){
											var item = listVasItem[i];
											if((item.NE__Action__c !='None') && item.NE__OrderId__r.OB_Service_Point__r.OB_Typology__c=='Virtuale' 
												&& item.NE__Root_Order_Item__c == null &&  item.NE__ProdId__r.OB_Codice_sfdc__c != "RECURRING" &&  item.NE__ProdId__r.OB_Codice_sfdc__c != "ONECLICK" ){
												filteredVAS.push(item);
											}else if ((item.NE__Action__c !='None') && item.NE__OrderId__r.OB_Service_Point__r.OB_Typology__c=='Virtuale' 
											&& item.NE__Root_Order_Item__c == null &&  (item.NE__ProdId__r.OB_Codice_sfdc__c == "RECURRING" ||  item.NE__ProdId__r.OB_Codice_sfdc__c == "ONECLICK") ){
												filteredRecOneClick.push(item);
											}
											else if ((item.NE__Action__c !='None') && item.NE__OrderId__r.OB_Service_Point__r.OB_Typology__c=='Virtuale' 
											&&  (item.NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName == "Moto" ||  item.NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName == "eCommerce") &&
											item.NE__Root_Order_Item__r.NE__Action__c != 'Remove'){
												filteredVasGateway.push(item);
											}
										}
										if(filteredVAS.length>0){
											component.set("v.disconnectedVAS",filteredVAS);
											component.set("v.hasVas",true);
										}//francesca.ribezzi 02/10/19 - WN-552 - else deleted to avoid duplicate vas items
										if(filteredRecOneClick.length>0){
											component.set("v.listRecOneClickVasItem",filteredRecOneClick);//Simone Misani per-92 19/12/
											component.set("v.hasRecOneClickVas",true);
										}
										if(filteredVasGateway.length>0){
											component.set("v.listVasGatewayItem",filteredVasGateway);
											component.set("v.hasVasGateway",true);
										}
										//elena.preteni 10/06/2019 descoping consistenza VAS ecommerce
									}
									//START - elena.preteni 06/06/2019 descoping consistenza RT Integrazione
									if(allConfigItems.listIntegrazionetItem!=null&& allConfigItems.listIntegrazionetItem!=undefined &&allConfigItems.listIntegrazionetItem.length>0 )
									{
										listIntegrazionetItem = JSON.parse(allConfigItems.listIntegrazionetItem.replace('\"', '"'));
										
										if(listIntegrazionetItem.length>0)
										{
											component.set("v.listIntegrazionetItem",listIntegrazionetItem);
											component.set("v.hasIntegrazione",listIntegrazionetItem[0].NE__OrderId__r.OB_Service_Point__r.OB_Typology__c=='Virtuale'? true : false);
										}
									
									}
									//END - elena.preteni 06/06/2019 descoping consistenza RT Integrazione
									//START - elena.preteni 07/06/2019 descoping consistenza RT Gateway
									if(allConfigItems.listGatewaytItem!=null&& allConfigItems.listGatewaytItem!=undefined &&allConfigItems.listGatewaytItem.length>0 )
									{
										listGatewaytItem = JSON.parse(allConfigItems.listGatewaytItem.replace('\"', '"'));
										console.log('listGatewaytItem'+JSON.stringify(listGatewaytItem));
										
										if(listGatewaytItem.length>0)
										{
											component.set("v.listGatewaytItem",listGatewaytItem);
											component.set("v.hasGateway",listGatewaytItem[0].NE__OrderId__r.OB_Service_Point__r.OB_Typology__c=='Virtuale' 
												? true : false);
											//  && listGatewaytItem[0].NE__Action__c=='Change'
										}
									
									}
									//END - elena.preteni 07/06/2019 descoping consistenza RT Gateway
									component.set("v.mainDoInitDone", true);
									console.log('Main do Init DONE ? : ' + component.get("v.mainDoInitDone"));
									if(listPOStItem != null) {
										for(var i = 0; i < (listPOStItem).length; i++){
											if(listPOStItem[i].OB_CustomerCode__c != null) {
												component.set("v.OB_CustomerCode__c" ,listPOStItem[i].OB_CustomerCode__c);
												break;
											}
										} 
									}
									if(listPOStItem != null) {
										for(var i = 0; i < (listPOStItem).length; i++){
											if(listPOStItem[i].OB_CustomerCode__c != null && listPOStItem[i].OB_ShopCode__c) {
												component.set("v.OB_CustomerCode__c" ,listPOStItem[i].OB_CustomerCode__c);
												component.set("v.OB_ShopCode__c" ,listPOStItem[i].OB_ShopCode__c);
												break;
											}
										} 
									}
									//var attributes = allConfigItems.AllConfigurationItems.NE__Order_Item_Attributes__r;
									
									// console.log('attribute of response is: ' + JSON.stringify(component.get("v.configurationTerminalObject")));
									// if(allConfigItems.listPOStItem != null) {
									// 	for(var i = 0; i < (allConfigItems.listPOStItem).length; i++) {
									// 		console.log(JSON.stringify('singleConfig is: ' + allConfigItems.listPOStItem[i]));
									// 		if(allConfigItems.listPOStItem[i].OB_CustomerCode__c != null) {
									// 			component.set("v.configurationTerminalObject.OB_CustomerCode__c" ,allConfigItems.listPOStItem[i].OB_CustomerCode__c);
									// 			console.log('single configuration OB_Customer code is: ' + component.get("v.configurationTerminalObject.OB_CustomerCode__c"));
									// 			break;
									// 		}
									// 	}
									// }
									component.set("v.lookupEmpty", false);
									console.log('@@@@ DONE K');		
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
							$A.enqueueAction(getSortedConfigItems);
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
								//Salvatore Pianura end
								$A.enqueueAction(getConfiguration);
							} else if(lookupsAreNotEmpty == false) {
								component.set('v.isError', true);
							}
					}
					/*ANDERA END 25/01/2019*/
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
							console.log("OB_Maintenance_Consistenza_Log_RequestController.js : actionToRetrieveLogRequest : Error message: " + errors[0].message);
						}
					}
					else 
					{
						console.log("OB_Maintenance_Consistenza_Log_RequestController.js : actionToRetrieveLogRequest : *UNKNOW ERROR*");
					}
				}
			});
			$A.enqueueAction(actionToRetrieveLogRequest);
			
		}
		catch(err) {
			console.log('[EXCE] OB_Maintenance_Consistenza_Log_RequestController.js : doInit : ' + err.message);
		} 
			},

			/*
	@author shaghayegh tofighian <shaghayegh.tofighian@accenture.com> 
	@date 02/05/2019
	@description this method updates the list of orderitems
	*/ 
	
handleUpdateOrderItems: function (component, event, helper){
	var configurationTerminalObject	= component.get("v.configurationTerminalObject");
	console.log('configurationTerminalObject: ', configurationTerminalObject);
	var orderItems1 = [];
	for (var i = 0; i < configurationTerminalObject.length; i++) {
	var tempOrderItems1 = {'sobjectType':'NE__orderItem__c', 'Id': configurationTerminalObject[i].Id, 'OB_Replacement__c': configurationTerminalObject[i].OB_Replacement__c};
	orderItems1.push(tempOrderItems1);
	}
	var action = component.get("c.getSortedConfigItemsServer2UpdateList");
	helper.createSecondLog(component, event, helper);
	action.setParams({ orderItems : orderItems1 });
	action.setCallback(this, function(response){
		var state = response.getState();
		if (state === "SUCCESS") {
			console.log("From server: " + response.getReturnValue());
			component.set("v.ShowModal",false);
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
			mode: 'sticky',
			type:'success',
			message: 'la sua richiesta è stata presa in carico',
			});
			toastEvent.fire();
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
	@author shaghayegh tofighian <shaghayegh.tofighian@accenture.com> 
	@date 09/05/2019
	@description this method will shows the modal if the user click on CONFIRM button
// 	*/ 
showModal: function (component, event, helper){
	component.set("v.ShowModal",true);
},

//START - 2019/05/10 - salvatore.pianura - function Conferma SIA
confirmRequestSia : function(component,_event,helper)
{
	var logRequest = component.get("v.contextLogRequest");
	var action = component.get("c.updateRequestSia");
	action.setParams
	({
		"logRequest" : logRequest
	});
	action.setCallback(this, function(response){
		var state = response.getState();
		if (state === "SUCCESS") 
		{
			location.reload(); 
		} 
		else if (state === "INCOMPLETE")
		{
			//do something
		}
		else if (state === "ERROR") 
		{
			var errors = response.getError();
			if (errors) {
				if (errors[0] && errors[0].message) 
				{
					console.log("Error message: " + 
						errors[0].message);
				}
			} 
			else 
			{
				console.log("Unknown error");
			}
		}
	});
	$A.enqueueAction(action);
}
//END - 2019/05/10 - salvatore.pianura - function Conferma SIA

	
	

})