({
	getProductDocuments : function(component, event, helper) {
		var orderHeaderId = component.get("v.orderHeaderId");
		var commercialProducts = component.get("v.commercialProducts");
		var action1 = component.get("c.getProductDocumentsServer");
		// console.log('******printing Action1: '+ JSON.stringify(action1));
		action1.setParams({orderHeaderId : orderHeaderId});
		// console.log('******printing Action1: '+ JSON.stringify(action1));
		action1.setCallback(this, function(response)
		{
			var state = response.getState();
			if (state === "SUCCESS")
			{
				var response = response.getReturnValue();
				var myList;
				var listFields;
				for(var key in response)
				{
					myList = response[key];
					listFields = key.split('||');
					component.set("v.listFields",listFields);
				}
				component.set("v.response", myList);

				var listDocs=[];
				for (var k in myList)
				{
					listDocs.push(k);
				}
				var mapProductsList= new Map();
				var loadDoc= false;
				for(var i=0; i<listDocs.length;i++)
				{
					mapProductsList[listDocs[i]] = loadDoc;
				}
				component.set("v.myMap", mapProductsList);
				console.log("condition: "+ (listDocs.length==0));
				component.set("v.documentsList", listDocs);
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
		$A.enqueueAction(action1);


	},

	getDocId: function(component){

		var orderHeaderId = component.get("v.orderHeaderId");
		var action4 = component.get("c.serverGetDocumentListId");

		action4.setParams({ 
			orderHeaderId : orderHeaderId
		});
		action4.setCallback(this, function(response)
		{
			var state = response.getState();
			//giovanni spinelli 10/07/2019 - manage error from server - start
			// antonio.vatrano 26/09/2019 r1f3-97
            if(response=='ERROR')
            {
                this.fireToast(component,event);
            }
            else
            {
				if (state === "SUCCESS")
				{
					var response = response.getReturnValue();
					console.log('@@@RES: '+ response); // antonio.vatrano 26/09/2019 r1f3-97
					var jsonRes = JSON.parse(response);
					var mapDocIdType={};
					var mapContractId = {};
					var mapRiskEvaluation = {};
					for(var key in jsonRes)
					{
						var myList = jsonRes[key];
						for(var k in myList)
						{
							var docId = myList[k].documentId;
							var type;
							var status;
							var contract;
							var nameFile; //antonio.vatrano r1f3-97 28/09/2019	
							for(var i in myList[k].metadata)
							{
								if(myList[k].metadata[i].metadataLabel == 'documentType'){
									type = myList[k].metadata[i].values[0];
								}
								if (myList[k].metadata[i].metadataLabel == 'documentStatus'){
									status =  myList[k].metadata[i].values[0];
								}
								if(myList[k].metadata[i].metadataLabel == 'documentTemplateName'){
									contract = myList[k].metadata[i].values[0];
								}
								// start antonio.vatrano r1f3-97 28/09/2019	
								if(myList[k].metadata[i].metadataLabel == 'documentFilename'){
									nameFile = myList[k].metadata[i].values[0];
								}
								// end antonio.vatrano r1f3-97 28/09/2019	
							}
                            if(status['string'] != 'DEPRECATED')
                            {
                                mapDocIdType[docId] = type['string'];
                                if(type['string'] == 'CONTRATTO')
                                {
                                    mapContractId[docId] = contract['string'];
								}
								//Start antonio.vatrano 24/09/2019 R1F3-97 
                                if(type['string'] == 'VALUTAZIONE RISCHIO')
                                {
									component.set("v.idDocRisk", docId); // antonio.vatrano 26/09/2019 r1f3-97
									component.set("v.nameDocRisk", nameFile['string']); // antonio.vatrano r1f3-97 28/09/2019
								}
								//End antonio.vatrano 24/09/2019 R1F3-97 
							}
							
                        }
					    var retrieveContract = component.get("c.retrieveContracts");
						retrieveContract.setCallback(this, function(response)
						{
							var state = response.getState();
							if (state === "SUCCESS")
							{
								var listcontract = [];
								var res = response.getReturnValue();
								for(var k in mapContractId)
								{

									var item = res[mapContractId[k]]+'||'+k.substring(1,k.length-1);
									listcontract.push(item);

								}
								component.set('v.contractList',listcontract);
							}
						});
						$A.enqueueAction(retrieveContract);
					}
					component.set("v.mapFileNet",mapDocIdType);
					// antonio.vatrano 26/09/2019 r1f3-97
				}
				else if (state === "INCOMPLETE") {
					// do something
				}
				else if (state === "ERROR") {

				}
			}
			//giovanni spinelli 10/07/2019 - manage error from server - end
		});
		$A.enqueueAction(action4);
	},

	// Start AV 21/02/2019 dont show buttons CARICA and RIMUOVI if ADMIN  [Schema STEFANO MONTORI]
	getProfile: function(component, event)
	{        
		var actiongetprofile = component.get("c.retrieveUserProfile");
		actiongetprofile.setCallback(this, function(response)
		{
			var state = response.getState();
			if (state === "SUCCESS") 
			{
				var profilename = response.getReturnValue();

  			if(profilename == 'Nexi Partner Admin'){
            		component.set('v.isAdmin', true);
       			 }
				 else
				 {
					component.set('v.isAdmin', false);
				 }
                
			}
			else
			{
				console.log("NO USER");
			}
		});
		$A.enqueueAction(actiongetprofile);
	},
	// End AV 21/02/2019 dont show buttons CARICA and RIMUOVI if ADMIN  [Schema STEFANO MONTORI]

	//giovanni spinelli 10/07/2019 - method to fire toast
	fireToast: function(component, event){
		var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "Error",
            "mode": "dismissible",
            "message":  $A.get("$Label.c.OB_ServerErrorMessage")
        });
        toastEvent.fire();
    }

})