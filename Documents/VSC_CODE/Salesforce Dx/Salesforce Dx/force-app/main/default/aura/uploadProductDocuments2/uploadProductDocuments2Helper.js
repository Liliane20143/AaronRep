({
	getProductDocuments : function(component)
	{
		//LUBRANO 2019/02/23 -- send info if document list is empty
		var mcc =component.get("v.objectDataMap.order.OB_MCC__c");
		var ateco = component.get("v.objectDataMap.merchant.OB_ATECO__c");
		var legalForm = component.get("v.objectDataMap.merchant.OB_Legal_Form__c");
		var orderId = component.get("v.objectDataMap.Configuration.Id");
		var orderHeaderId = component.get("v.objectDataMap.OrderHeader.Id");
		var merchantId = component.get("v.objectDataMap.merchant.Id");
		var abi = component.get("v.objectDataMap.bank.OB_ABI__c"); // // <daniele.gandini@accenture.com> - 12/07/2019 - F2WAVE2-128 - semi colon added
		// <daniele.gandini@accenture.com> - 12/07/2019 - F2WAVE2-128 - start - condition for avoiding undefined/null iscompanyDataModified. If others cases ned it change condition
		var ordeHeaerSubProcess = component.get("v.objectDataMap.OrderHeader.OB_Sub_Process__c");
		var economicVariation = $A.get( "$Label.c.OB_economic_variation");
		let isCompanyDataModified; // <daniele.gandini@accenture.com> - 12/07/2019 - F2WAVE2-128 - moved out of if condition
		if(ordeHeaerSubProcess != economicVariation){
		// <daniele.gandini@accenture.com> - 12/07/2019 - F2WAVE2-128 - stop
			//NEXI-32 Customer DS-4 & FG-4 grzegorz.banach@accenture.com 13/05/2019 START
        	isCompanyDataModified = component.get("v.objectDataMap.unbind.isCompanyDataModified");
			if ( $A.util.isUndefinedOrNull( isCompanyDataModified ) )
			{
				//francesca.ribezzi 05/11/19 - PROD-22 - server-logic failed toast deleted
				isCompanyDataModified = false;
			}
		// <daniele.gandini@accenture.com> - 12/07/2019 - F2WAVE2-128 - start
		}
		else
		{
			isCompanyDataModified = false;
		}
		// <daniele.gandini@accenture.com> - 12/07/2019 - F2WAVE2-128 - stop
        //NEXI-32 Customer DS-4 & FG-4 grzegorz.banach@accenture.com 13/05/2019 END
		var isSetupFromOp = component.get("v.objectDataMap.isOperation") && component.get("v.objectDataMap.isSetup");
		var action = component.get("c.getProductDocumentsServer");
		action.setParams({ 
			orderId : orderId,
			orderHeaderId : orderHeaderId,
			mcc : mcc , 
			ateco : ateco,
			legalForm: legalForm,
			merchantId : merchantId,
			abi : abi,
			isCompanyDataModified : isCompanyDataModified, //NEXI-32 Customer DS-4 & FG-4 grzegorz.banach@accenture.com 13/05/2019
			isSetupFromOp : isSetupFromOp
		});

		action.setCallback(this, function(response){
			var state = response.getState();
			if (state === "SUCCESS")
			{
				 var myResponse = response.getReturnValue();
                component.set("v.response", myResponse);
                var listDocs = [];
                for (var k in myResponse)
                {
                        listDocs.push(k);
                }
                if(listDocs.length !=0)
                {
                    component.set("v.documentsList", listDocs);
                    var documentsList = component.get("v.documentsList");
                    if(documentsList.includes("Non sono presenti") )
                    {
                        var btnUp=component.find("upLoad");
                        $A.util.addClass(btnUp,'slds-hide');
                    }
                    var mapProductsList= new Map();
                    var loadDoc= false;
                    for(var i=0; i<documentsList.length;i++)
                    {
                        mapProductsList[documentsList[i]] = loadDoc;
                    }
                    component.set("v.myMap", mapProductsList);
                    //giovanni spinelli
                    var secondTime = component.get('v.secondTime');
                    if(secondTime==true)
                    {
                        this.compareFileNetAndSfdc(component);
                    }
                }
                else
                {
                    console.log('messageError');
                    var messageLoad=component.find("messageError");
                    $A.util.removeClass(messageLoad,'slds-hide');
                }
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
				} else
				{
					console.log("Unknown error");
				}
			}
		});
		$A.enqueueAction(action);
	},

	getCommercialProducts : function(component)
	{
        // Load expenses from Salesforce
		// COMPONENT.GET = SI RIFERISCE AL METOFDO LATO CONTROLLER HE STO CHIAMANDO
		var action = component.get("c.getCommercialProductsServer");
		// Add callback behavior for when response is received
		action.setCallback(this, function(response)
		{
			var state = response.getState();
			if (state === "SUCCESS")
			{
				component.set("v.commercialProducts", response.getReturnValue());
				this.getProductDocuments(component);
			}
			else
			{
				console.log("Failed with state: " + state);
			}
		});
		// Send action off to be executed
		$A.enqueueAction(action);
	},

	//giovanni spinelli
	retrieveDocsSaved : function(component, event, helper) { //g.v. add event and helper parameters
		//return new Promise( $A.getCallback(function(resolve, reject) {}));
		return new Promise(function(resolve, reject) { 
			console.log('INTO HELPER RETRIEVE DOCS');
			var merchantId 		=	component.get('v.objectDataMap.merchant.Id'),
				servicePointId	=	component.get('v.objectDataMap.pv.Id'),
				orderId 		=	component.get('v.objectDataMap.Configuration.Id');
			var contractsToDeprecate = []; //g.v. 30/09/2019
			var action = component.get("c.retrieveSavedDocs");
			action.setParams({
				merchantId 		: merchantId,
				servicePointId	:	servicePointId,
				orderId 		: orderId
			});
			// Add callback behavior for when response is received
			action.setCallback(this, function(response) {
				var state = response.getState();
				console.log('STATE IN RETRIEVE DOCS SAVED IS: ' + state);
				if (state === "SUCCESS") {
						var response 		= response.getReturnValue();
						var jsonRes 		= JSON.parse(response);
						var mapDocIdType 	= {};
						console.log("*****RES is " + response);
						//manage response to have a better map
						for(var key in jsonRes)
						{
							console.log("*****key " + key);
							var myList = jsonRes[key];
							for(var k in myList)
							{
								var docId 	= myList[k].documentId;
								var type;
								var status;
								for(var i in myList[k].metadata){
									if(myList[k].metadata[i].metadataLabel == 'documentType'){
										type = myList[k].metadata[i].values[0];
									}
									if (myList[k].metadata[i].metadataLabel == 'documentStatus'){
										status =  myList[k].metadata[i].values[0];
									}
									
								}
								console.log("key: "+docId+'   Status:'+status['string']+'     type: '+type['string'] );
								if(status['string'] != 'DEPRECATED'){
									mapDocIdType[docId] = type['string'];
									//START gianluigi.virga 30/09/2019 - create a list of all contracts to deprecate
									if(type['string']==$A.get("$Label.c.OB_ContractType")){
										contractsToDeprecate.push(docId.substring(1, docId.length-1));
									}
									//END gianluigi.virga 30/09/2019
								}
							}
						}
						console.log("*****mapDocIdType" + JSON.stringify(mapDocIdType));
						component.set('v.mapFileNet' , mapDocIdType);
						//START gianluigi.virga 26/09/2019 - do logic only if there are documents stored
						if(!$A.util.isEmpty(mapDocIdType)){
							component.set('v.secondTime', true);
						}
						component.set("v.contractsToDeprecate", contractsToDeprecate);
						console.log("contractsToDeprecate: "+contractsToDeprecate);
						if(!$A.util.isEmpty(contractsToDeprecate)){
							helper.deprecateAllContracts(component, event, helper);
						}
						//END gianluigi.virga 26/09/2019
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
			// Send action off to be executed
			$A.enqueueAction(action);
		});
	},

	compareFileNetAndSfdc : function(component)
	{
		var mapProductsList = component.get("v.response"),
		mapFileNet = component.get('v.mapFileNet');
		var compareMap = new Map();
		for(var k in mapProductsList)
		{
			var listId = [];
			compareMap[k] = '';
			var typeDoc = mapProductsList[k].split(':')[0];
			for (var key in mapFileNet)
			{
				if(typeDoc == mapFileNet[key])
				{
					listId.push(key.substring(1, key.length-1));
				}
			}
			compareMap[k] = listId;
		}
		component.set("v.compareMap", compareMap);
	},
	 /*
	* Author : Gianluigi Virga
	* Date : 01/10/2019 
	* Description : call apex future method to deprecate all contrat generated.
	*/
	deprecateAllContracts : function(component, event, helper) {
		var contractsIdList = component.get("v.contractsToDeprecate");
        console.log('*****id list: ' +contractsIdList);
        var merchantId      = component.get('v.objectDataMap.merchant.Id'),
            servicePointId  = component.get('v.objectDataMap.pv.Id'),
            orderId         = component.get('v.objectDataMap.Configuration.Id');
        console.log('params: ' + merchantId + ' '+servicePointId+'  '+orderId);
        var action = component.get("c.deprecateContracts");
        action.setParams({   merchantId     :   merchantId,
                            servicePointId  :   servicePointId,
                            orderId         :   orderId,
                            contractsIdList :   contractsIdList
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('STATE IN DEPRECATE ALL CONTRACTS IS: '+ state);
            if(state === "SUCCESS"){
                var message = $A.get("$Label.c.OB_RegenerateContracts");
                var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
				    message:message,
					duration: '7000',
					type: 'info',
					mode: 'dismissible'
				});
				toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    

    },
})