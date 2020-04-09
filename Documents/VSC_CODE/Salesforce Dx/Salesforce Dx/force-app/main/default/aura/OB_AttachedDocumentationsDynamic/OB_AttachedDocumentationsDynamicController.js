({
	doInit : function(component, event, helper){
		var license = component.get("v.license");
		var isAdmin =  component.get("v.isAdmin");
		var itemsToApprove = component.get("v.itemsToApprove")
		if(itemsToApprove || isAdmin || license !=  $A.get("$Label.c.OB_License_PartnerCommunity")){
			component.set("v.canRemove", false);
		}
		//Start antonio.vatrano r1f3-131 02/10/2019
		var listReason = ['Documentazione Assente', 'Documentazione Incompleta'];
		var listFields 	= component.get("v.listFields");
		var reason = listFields[5];
		if(listReason.includes(reason)){
			component.set("v.canRemove", true);
		}
		//End antonio.vatrano r1f3-131 02/10/2019
		// Start AV 18/02/2019 defect Id #00001548 Hide button REMOVE if logrequest's status is In attesa.
		helper.getStateLogRequest(component, event, helper);
		// End AV 18/02/2019 defect Id #00001548

	},



	delete : function(component, event, helper){
		console.log("delete OB_AutoCompleteLigthining")
		var listFields 	= component.get("v.listFields");
		var configurationId = listFields[0];
		var servicePointId = listFields[1];
		var merchantId = listFields[2];

		//	START	micol.ferrari 03/12/2018
		var logRequestId = '';
		if (listFields.length>6)
		{
			logRequestId = listFields[6];
			console.log("### logRequestId: "+logRequestId);
		}
		//	END		micol.ferrari 03/12/2018
		var multipleMapId= component.get("v.multipleMapId");
		// var id = component.get("v.Id");
		console.log("***delete multipleMapId: "+JSON.stringify(multipleMapId));
		component.set("v.multipleMapId",multipleMapId);
		var documentId = component.get("v.IdFilenet");
		var request = $A.get("e.c:OB_ContinuationRequest");

		//	START	micol.ferrari 03/12/2018
		if (typeof logRequestId !== 'undefined' && logRequestId!=null && logRequestId!='')
		{
			request.setParams({ 
				methodName: "filenetUpload",
				methodParams: [merchantId, servicePointId, logRequestId, '', '', "true", documentId, ''],
							
				callback: function(result) {
					console.log('RISULTATO: '+ result);
				}
			});
		}
		else
		{
			request.setParams({ 
				methodName: "filenetUpload",
				methodParams: [merchantId, servicePointId, configurationId, "", "", "true", documentId, ''],
				callback: function(result) {
					console.log('RISULTATO: '+ result);
				}
			});
		}
		//	END		micol.ferrari 03/12/2018

		request.fire();
		component.destroy();
	},

	callService : function(component, event , helper){
		
		var listFields 			= component.get("v.listFields");
		var configurationId 	= listFields[0];
		var servicePoint 		= listFields[1];
		var merchant 			= listFields[2];
		if(typeof (servicePoint)== "undefined" || servicePoint == null){
			servicePoint = "";
		}

		//	START	micol.ferrari 03/12/2018
		var logRequestId = '';
		if (listFields.length>6)
		{
			logRequestId = listFields[6];
			console.log("### logRequestId: "+logRequestId);
		}
		//	END		micol.ferrari 03/12/2018

		// var docIdsMap = component.get("v.IdMap");
		var docId = component.get("v.IdFilenet");
		var request = $A.get("e.c:OB_ContinuationRequest");

		//	START	micol.ferrari 03/12/2018
		if (typeof logRequestId !== 'undefined' && logRequestId!=null && logRequestId!='')
		{
			request.setParams({ 
				methodName: "visualizeDocLoadLogRequest",
				methodParams: [merchant, servicePoint, logRequestId, docId],
				callback: function(result) {
					console.log('RISULTATO: '+ result);
				}
			});
			request.fire();//giovanni spinelli
		}
		else
		{
			/* ANDREA MORITTU START 2019.08.21 - CALLING VISUALORCE PAGE TO DISPLAY DOCUMENTS */
			helper.getTokenJWE_Helper(component, event, helper, docId);
			/* ANDREA MORITTU END 2019.08.21 - CALLING VISUALORCE PAGE TO DISPLAY DOCUMENTS */			
		}
		//	END		micol.ferrari 03/12/2018
	}

})