({
	getProductDocuments: function(component, logRequestId) //NEXI-298 Marta Stempien <marta.stempien@accenture.com> 11/09/2019 changed params
	{
	    //NEXI-298 Marta Stempien <marta.stempien@accenture.com> 11/09/2019 Start
	    let listOfDocumentationForCurrentLogRequest = [];
	    let documentsByLogRequestId = component.get("v.documentsByLogRequestId");
	    let listDocs = component.get("v.documentsList");
	    //NEXI-298 Marta Stempien <marta.stempien@accenture.com> 11/09/2019 Stop
		var actionProductDocumentsServer = component.get("c.getProductDocumentsServer");
		actionProductDocumentsServer.setParams(
		{
			logRequestId : logRequestId, //NEXI-298 Marta Stempien <marta.stempien@accenture.com> 11/09/2019
			isSaeAtecoChanged : component.get("v.saeAtecoHasChanged"), // NEXI-97 Marta Stempien <marta.stempien@accenture.com> 10/06/2019
			isTEEdit : component.get("v.isTEEdit") // NEXI-60 Adrian Dlugolecki <adrian.dlugolecki@accenture.com> 19/06/2019
		});
		actionProductDocumentsServer.setCallback(this, function(response)
		{
			var state = response.getState();
			if (state === "SUCCESS") 
			{
				console.log("SUCCESS getProductDocuments");
				var response = response.getReturnValue();
				component.set("v.response", response);
                 /*
                 ******Start AV 19_12_2018********
                 */
                //NEXI-298 Marta Stempien <marta.stempien@accenture.com> 11/09/2019 Start
				for ( let doc in response )
				{
				    listOfDocumentationForCurrentLogRequest.push(doc);
				    if(!listDocs.includes(doc))
				    {
                        listDocs.push(doc);
                    }
				}
				//NEXI-298 Marta Stempien <marta.stempien@accenture.com> 11/09/2019 Stop
				if(listDocs!=null && listDocs.length>0)
				{
					var mapAllLoad = new Map();
					var loadDoc= false;
					for(var i=0; i<listDocs.length;i++)
					{
						mapAllLoad[listDocs[i]] = loadDoc;
					}	
					component.set("v.mapAllLoad", mapAllLoad);	
					component.set("v.documentsList", listDocs);
				}
				else
				{
					component.set("v.listIsEmpty",true);
					component.set("v.documentsList", listDocs);
					
					$A.util.removeClass(component.find('messageError1'), 'slds-hide');
					console.log("##################LISTA VUOTA");
				}
				//NEXI-298 Marta Stempien <marta.stempien@accenture.com> 11/09/2019 Start
				documentsByLogRequestId[logRequestId] = listOfDocumentationForCurrentLogRequest;
				component.set("v.documentsByLogRequestId", documentsByLogRequestId);

				component.set("v.listOfDocumentationForCurrentLogRequest", listOfDocumentationForCurrentLogRequest);
			}
			//NEXI-298 Marta Stempien <marta.stempien@accenture.com> 11/09/2019 Stop

			//NEXI-298 Marta Stempien <marta.stempien@accenture.com> Deleted unnecessary code
			else if (state === "ERROR")
			{
				var toastEvent = $A.get("e.force:showToast");
    	    	toastEvent.setParams({
	    	        "type": "Error",
	    	        "mode": "dismissible",
	    	        "message":  $A.get("$Label.c.OB_ServerErrorMessage")
    	    	});
    	    	toastEvent.fire();
				console.log("Unknown error");
			}
		});
		$A.enqueueAction(actionProductDocumentsServer);

	},

    /**
    * @author Marta Stempien <marta.stempien@accenture.com>
    * @date 11/09/2019
    * @task NEXI-298
    * @params component
    * @description: Calls getProductDocuments for each log request that requires documents
    */
	getRequiredDocuments : function( component )
	{
	   let logRequests = component.get("v.logRequests");
	   if($A.util.isEmpty(logRequests))
       {
           this.getProductDocuments(component, component.get("v.logrequestid") );
       }
       else
       {
          for( let loopLogRequest of logRequests )
          {
              this.getProductDocuments(component, loopLogRequest );
          }
       }
    },

	getDocId : function(component, event, helper)
	{
		var actionGetDocId = component.get("c.serverGetDocumentListId");
		actionGetDocId.setParams(
		{ 
			logRequestId : component.get("v.logrequestid")
		});
		actionGetDocId.setCallback(this, function(response)
		{
			//giovanni spinelli 10/07/2019 - manage exception from server - start
			var state = response.getState();
			var response 		= response.getReturnValue();
			console.log('*****RESPONSE: ' , response);
			if (response == 'ERROR') {
				this.fireToast(component, event);
			}
			else {
				if (state === "SUCCESS") 
				{
					
					var jsonRes 		= JSON.parse(response);
					var mapDocIdType 	= {};
					for(var key in jsonRes)
					{
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
							}
						}
					}
					component.set("v.mapFileNet",mapDocIdType);
				}
				else if (state === "INCOMPLETE") 
				{
					// do something
				}
				else if (state === "ERROR") 
				{
					this.fireToast(component,event);
				}
			}
			//giovanni spinelli 10/07/2019 - manage exception from server - end
		});
		$A.enqueueAction(actionGetDocId);
	},
	// Start AV 22/02/2019 get profile if is ADMIN
	getProfile: function(component, event)
	{        
		var actiongetprofile = component.get("c.retrieveUserProfile");
		actiongetprofile.setCallback(this, function(response)
		{
			var state = response.getState();
			if (state === "SUCCESS") 
			{
				var profilename = response.getReturnValue();
				console.log('@@Retrieved Profile: '+profilename);
                
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
	//giovanni spinelli - 10/07/2019 - fire toast method
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