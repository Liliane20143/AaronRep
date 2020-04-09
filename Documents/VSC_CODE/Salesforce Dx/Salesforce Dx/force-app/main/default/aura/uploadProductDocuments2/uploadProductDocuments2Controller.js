({
	doInit : function(component, event, helper) {
		// gs start
		//START gianluigi.virga 25/09/2019 - Always retrieve documents from firenet and moved 'second time' logic on helper
		// var docsIdSavedList = component.get('v.objectDataMap.documentSaved');
		// console.log('DOCS SAVED: ' + JSON.stringify(docsIdSavedList));
		// if(docsIdSavedList){
			// console.log('second time');
			// component.set('v.secondTime' , true);
			helper.retrieveDocsSaved(component, event, helper).then(
				helper.getProductDocuments(component, event, helper)
			);
		// }else{
		// 	console.log('first time'); 
		// 	helper.getProductDocuments(component);
		// }	
		//gs end
		////END gianluigi.virga 25/09/2019
	},

	showBanner : function (component, event, helper)
	{
		var control = component.get ("v.objectDataMap.missingDocs");
		if (control == true)
		{
			component.set("v.hasMessage", true);
		}
		else
		{
			component.set("v.hasMessage", false);
		}
	},

	hideError : function (component, event, helper)
	{
			component.set("v.hasMessage", false);
	},

	checkAllTrue : function(component, event)
	{
		var changedMap=event.getParam("value");
		var allTrue = false;
		var listChecked = [];
		var listOfDocs = []; //antonio.vatrano 27/08/2019 f2wave2-180
		for(var key in changedMap)
		{
			listChecked.push(changedMap[key]);
			listOfDocs.push(key); //antonio.vatrano 27/08/2019 f2wave2-180
		}
		if(listChecked.includes(false))
		{
			component.set("v.objectDataMap.allCheckedLoad",'false');
		}
		else
		{
			component.set("v.objectDataMap.allCheckedLoad",'true');
		}
		var onlySignedContract = (listOfDocs.length == 1 && listOfDocs[0] == 'Contratto firmato') ? true : false; //antonio.vatrano 27/08/2019 f2wave2-180
		var orderHeaderId =component.get("v.objectDataMap.OrderHeader.Id");
		var isToUp = component.get("v.isToUpdate");
		var presentTrue = listChecked.includes(true);
		//START - elena.preteni 19/07/2019 no BIO triggered F3 abi cab selection
		//Start antonio.vatrano 27/08/2019 f2wave2-180
		if( (!$A.util.isEmpty( component.get("v.objectDataMap.isOperation") ) &&
		    !$A.util.isEmpty( component.get("v.objectDataMap.isSetup") ) && // NEXI-261 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 16/08/2019 added null checks
		    component.get("v.objectDataMap.isOperation") &&
		    component.get("v.objectDataMap.isSetup")) || onlySignedContract
		   )
		//End antonio.vatrano 27/08/2019 f2wave2-180
        {
			presentTrue = false;
		}
		//END - elena.preteni 19/07/2019 no BIO triggered F3 abi cab selection
		if(isToUp && listChecked.includes(true))
		{
			var action = component.get("c.updateDocReqTrue");
			action.setParams({ 
				orderHeaderId : orderHeaderId,
				isToTriggered : presentTrue // elena.preteni 19/07/2019 no BIO triggered F3 abi cab selection
			});
			action.setCallback(this, function(response)
			{
				var state = response.getState();
				if (state === "SUCCESS") {
					component.set("v.isToUpdate", false);
				}
			});
			$A.enqueueAction(action);
		}
	}
})