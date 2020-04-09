({
	/**

LUBRANO 2019-04-09  SETUP-251- setting single document variable removing sfdc code
@method doInit
@return void
*/
	doInit : function(component, event , helper){
		
		var documentParameters = component.get("v.documentParameters");
		var singleDocument = documentParameters.split("__")[0];
		component.set("v.singleDocument", singleDocument);
	},

	callService : function(component, event , helper){
		component.set("v.showError", false);
		component.set("v.showMessage", false);
		component.set("v.showFlag", false);
		component.set("v.showSpinner", true);	
		component.set('v.disableGenerateButton' , true);// giovanni spinelli 14/05/2019 disable button during calling service
		var docIdsMap = component.get("v.mapDocumentId");
		var merchant = component.get("v.objectDataMap.merchant.Id");
		var servicePoint = component.get("v.objectDataMap.pv.Id");
		var configurationItem = component.get("v.objectDataMap.Configuration.Id");
		var orderHeader = component.get("v.objectDataMap.OrderHeader.Id");
		

		var recordMap = component.get("v.mapRecordId");
		//LUBRANO - 2019-04-09 -- CHANGING RECORDID
		var recordId = recordMap[component.get("v.documentParameters")];
		console.log('docIdsMap[component.get("v.singleDocument")]: ' + docIdsMap[component.get("v.singleDocument")]);
		var docId = docIdsMap[component.get("v.singleDocument")]==undefined?'':docIdsMap[component.get("v.singleDocument")];
		
		
		var request = $A.get("e.c:OB_ContinuationRequest");
		var isToRegenerate = docId==''?'false':'true';
		request.setParams({ 
			methodName: "getBase64DocID",
			//LUBRANO - 2019-04-09 -- CHANGING singleDocument to documentParameters
			methodParams: [merchant ,	servicePoint, orderHeader, configurationItem, recordId , isToRegenerate, docId,component.get("v.documentParameters")],
			callback: function(result) {
				console.log('RISULTATO: '+ JSON.stringify(result));
				component.set("v.response" , result);
				var docIdsMap = component.get("v.mapDocumentId");
				if(result!=null){
					if(result['status code']!='KO'){
						for(var k in result){
							docIdsMap[component.get("v.singleDocument")]=k;	
							//START gianluigi.virga 24/09/2019              
							// //giovanni spinelli - start - store id in object data map 06/05/2019
							// try{
							// 	var name = component.get("v.singleDocument");
							// 	component.set('v.objectDataMap.contractsIdGenerated.'+name.replace(/\s/g , "_") , k);     
							// 	console.log('contractIdGenerated in objectdatamap: ' , component.get('v.objectDataMap.contractsIdGenerated')); 
							// }catch(err){
							// 	console.log(err.message);
							// }
							// //giovanni spinelli - end - store id in object data map 06/05/2019
							//END gianluigi.virga 24/09/2019 
						}
						component.set("v.mapDocumentId",docIdsMap);
						component.set("v.showFlag", true);
					}else{		
						component.set("v.showMessage", true);
						component.set("v.showError", true);
					}
				}else{		
					component.set("v.showMessage", true);
					component.set("v.showError", true);
				}
				
			}
		});
		request.fire();
		var mappa=component.get("v.myMap");
		mappa[component.get("v.singleDocument")]=true;
		component.set("v.myMap", mappa);
	},


	changeResponse : function(component,event, helper){
		component.set("v.showSpinner", false);
		component.set('v.disableGenerateButton' , false);//giovanni spinelli 14/05/2019 enable button after calling service
	}

	
})