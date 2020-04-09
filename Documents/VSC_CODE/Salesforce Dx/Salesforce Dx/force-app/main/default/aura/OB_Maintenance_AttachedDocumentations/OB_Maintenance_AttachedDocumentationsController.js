({
	doInit : function(component, event, helper) 
	{
		var recordIdLog = component.get("v.recordId");
		if (recordIdLog)
		{
			component.set("v.logrequestid",recordIdLog);
		}
		console.log("°°°readonly: "+component.get("v.isReadOnly"));
		var actiongetinfos = component.get("c.retrieveInfos");
		actiongetinfos.setParams(
		{
			logRequestId : component.get("v.logrequestid")
		});
		actiongetinfos.setCallback(this, function(response)
		{
			var state = response.getState();
			if (state === "SUCCESS") 
			{ 
				var mapreturned = {};
				mapreturned		= response.getReturnValue();
				// AV if admin hide button 
				//NEXI-131 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 27/06/2019 Start
				component.set("v.isTEEdit",mapreturned["isTEEDIT"]);
				component.set("v.hideComponent",mapreturned["showComponent"] == "false");
				if(!$A.util.isEmpty(mapreturned["isSaeAtecoChanged"]))
                {
                    component.set("v.saeAtecoHasChanged",true);
                }
				//NEXI-131 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 27/06/2019 Stop
				if(mapreturned['PROFILE'] == 'Nexi Partner Admin'){
					component.set('v.isAdmin', true);
				}
				//	HIDE DOCUMENTS COMPONENT IF WE CHANGED THE SERVICE POINT
				if (mapreturned["EDITSERVICEPOINT"]=="true")
				{
				    console.log(mapreturned["EDITSERVICEPOINT"])
					component.set("v.hideComponent",false);
				}
				if(mapreturned["STATUS"] == $A.get("$Label.c.OB_MAINTENANCE_LOGREQUEST_STATUS_DRAFT")){
					component.set("v.isDraft",true);
				}
				if(mapreturned["REJECTREASON"] == 'Documentazione Incompleta' || mapreturned["REJECTREASON"] == 'Documentazione Assente' ){
					component.set("v.rejectReasonBool",true);
				}
				//start antonio.vatrano 07/05/2019 rif2-82
				if(mapreturned['OWNER'] == 'Operation'){
					component.set('v.isOperation', true);
				}
				//NEXI-259 Marta Stempien <marta.stempien@accenture.com> 08/08/2019 Start
				if(mapreturned['SAVEASDRAFT'] == 'true')
				{
				    component.set('v.isSaveAsDraft', true);
                }
                else
                {
                    component.set('v.isSaveAsDraft', false);
                }
                //NEXI-259 Marta Stempien <marta.stempien@accenture.com> 08/08/2019 Stop

				console.log('mapreturned[OWNER]: '+mapreturned['OWNER']);
				console.log('isOperation: '+component.get('v.isOperation'));
				//end antonio.vatrano 07/05/2019 rif2-82
				component.set("v.license", mapreturned["LICENSE"]);
				var listoffieldsconcatenated = [];
				listoffieldsconcatenated.push(null);	//	CONFIGURATION ID
				listoffieldsconcatenated.push(mapreturned["SERVICEPOINT"]);
				listoffieldsconcatenated.push(mapreturned["MERCHANT"]);
				listoffieldsconcatenated.push(null);	//	START APPROVAL PROCESS
				listoffieldsconcatenated.push(null);	//	IN APPROVAZIONE
				listoffieldsconcatenated.push(null);	//	REJECTION REASON
				listoffieldsconcatenated.push(component.get("v.logrequestid"));
				component.set("v.listFields", listoffieldsconcatenated);
				//NEXI-298 Marta Stempien <marta.stempien@accenture.com> 11/09/2019 Start
                component.set("v.documentsByLogRequestId", {});
                component.set("v.documentsList", []);
				helper.getRequiredDocuments(component);
				//NEXI-298 Marta Stempien <marta.stempien@accenture.com> 11/09/2019 Stop
				helper.getDocId(component, event, helper);
			}
            //NEXI-298 Marta Stempien <marta.stempien@accenture.com> 11/09/2019 Deleted unnecessary else
		});
		$A.enqueueAction(actiongetinfos);
	},

// ***********************************************************START Antonio Vatrano 11/12/2018*****************************************************
	compareDocFilenetSalesForce: function(component)
	{
		let documentsInFilenet = component.get("v.mapFileNet");
		let documentInSales = component.get("v.response");
		let compareMap = new Map();
        //NEXI-259 Marta Stempien <marta.stempien@accenture.com> 08/08/2019, Start
		let uploadedDocuments = [];
		let documentsInFilenetNames = [];
		for(let k in documentInSales)
		{
			let listId = [];
			compareMap[k] = ''; 
			let typeDoc = documentInSales[k].split(':')[0];
			for (let key in documentsInFilenet)
			{
				if(typeDoc == documentsInFilenet[key])
				{
					listId.push(key.substring(1, key.length-1));
                    uploadedDocuments.push(k);
				}
			}
			compareMap[k] = listId;
		}
		component.set("v.compareMap", compareMap);
		component.set('v.uploadedDocuments', uploadedDocuments);
		//NEXI-259 Marta Stempien <marta.stempien@accenture.com> 08/08/2019, Stop
	},

// ***********************************************************END Antonio Vatrano 11/12/2018*****************************************************

		/*
 ******Start AV 19_12_2018********
 */
	checkAllTrue : function(component, event){
		var changedMap=event.getParam("value");
		var allTrue = false;
		var listChecked = [];
		for(var key in changedMap){
			listChecked.push(changedMap[key]);
		}
		if(listChecked.includes(false)){
			// component.set("v.objectDataMap.allCheckedLoad",'false');
			console.log("*******all Docs aren't load************");
		}
		else {
			console.log("*******all Docs are load************");
			component.set("v.showSaveButton", true);
		}
	}

})