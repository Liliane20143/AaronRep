({
    doInit : function(component, event, helper) {
        var item = component.get("v.item");
        var itemSplit = item.split("||");
        component.set("v.contractName",itemSplit[0]);
		component.set("v.docId",itemSplit[1]);
		//giovanni spinelli 02/04/2019
		helper.getBase64SingleContract(component);
    },

    viewDocument : function(component, event , helper){
		var listFields 			= component.get("v.listFields");
		var configurationId 	= listFields[0];
		var servicePoint 		= listFields[1];
        var merchant			= listFields[2];
        var docId =  component.get("v.docId");
		var logRequestId = '';
		if (listFields.length>6)
		{
			logRequestId = listFields[6];
			console.log("### logRequestId: "+logRequestId);
		}
		console.log("merchant: "+merchant+"  servicePoint: "+servicePoint+"  configurationId: "+configurationId+"  ID: "+docId);
		var request = $A.get("e.c:OB_ContinuationRequest");
		if (typeof logRequestId !== 'undefined' && logRequestId!=null && logRequestId!='')
		{
			if(servicePoint == 'undefined' || servicePoint=='' || servicePoint==null )
			{
				servicePoint= '';
			}
			console.log("INSIDE visualizeDocLoadLogRequest");
			// console.log('Params: '+merchant+' || '+ servicePoint+' || '+ logRequestId+' || '+ docId );
			request.setParams(
			{ 
				methodName: "visualizeDocLoadLogRequest",
				methodParams: [merchant, servicePoint, logRequestId, docId],
				callback: function(result)
				{
					console.log('****RISULTATO: '+ JSON.stringify(result));
				}
			});
		}
		else
		{
			console.log("INSIDE visualizeDocLoad");
			request.setParams(
			{ 
				methodName: "visualizeDocLoad",
				methodParams: [merchant, servicePoint, configurationId, docId],
				callback: function(result)
				{
					console.log('****RISULTATO: '+ result);
				}
			});
		}
		request.fire();
	}

})