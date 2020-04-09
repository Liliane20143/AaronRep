({
	savePosInputs : function(component,event,helper)
	{
		var logRequestId 			= component.get("v.recordId");
		var dataInstallazionePos 	= component.find("dataInstallazionePos").get("v.value");
		var dataDisinstallazionePos = component.find("dataDisinstallazionePos").get("v.value");
		var acqIsSaved 				= component.get("v.savedAcq");
		var acqIsRejected 			= component.get("v.rejectedAcq");
		console.log("OB_Maintenance_Consistenza_LogRequestHelper.js : Log Request Id : " + logRequestId);
		console.log("OB_Maintenance_Consistenza_LogRequestHelper.js : Installation Date POS Value : " + dataInstallazionePos);
		console.log("OB_Maintenance_Consistenza_LogRequestHelper.js : Unistallation Date POS Value : " + dataDisinstallazionePos);
		console.log("OB_Maintenance_Consistenza_LogRequestHelper.js : Acquiring is saved : " + acqIsSaved);
		console.log("OB_Maintenance_Consistenza_LogRequestHelper.js : Acquiring is rejected : " + acqIsRejected);

		try
		{
			var savePosInputs = component.get("c.savePosInputs");
			savePosInputs.setParams
			({
				"logRequestId" 				: logRequestId				,
				"dataInstallazionePos" 		: dataInstallazionePos 		,
				"dataDisinstallazionePos" 	: dataDisinstallazionePos 	,
				"acqIsSaved" 				: acqIsSaved 				,
				"acqIsRejected" 			: acqIsRejected
			});
			savePosInputs.setCallback(this,function(response)
			{
				var state = response.getState();
				if (state === "SUCCESS") 
				{
					component.set("v.savedPos",true);
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams
					({
						type	: 	"Success",
						title 	: 	$A.get("$Label.c.OB_MAINTENANCE_TOAST_OPERATIONSUCCESSFULL"),
						message	: 	"     ",
						mode	: 	"dismissible"
					});
					toastEvent.fire();
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
							console.log("OB_Maintenance_Consistenza_Log_RequestController.js : savePosInputs : Error message: " + errors[0].message);
						}
					}
					else 
					{
						console.log("OB_Maintenance_Consistenza_Log_RequestController.js : savePosInputs : *UNKNOW ERROR*");
					}
				}
			});
			$A.enqueueAction(savePosInputs);
		}
		catch(err) 
		{
			console.log('[EXCE] OB_Maintenance_Consistenza_Log_RequestHelper.js : savePosInputs : ' + err.message);
		}
	},

	saveAcqInputs : function(component,event,helper)
	{
		var logRequestId 		= component.get("v.recordId");
		var codiceConvenzione 	= component.find("codiceConvenzione").get("v.value");
		var companyCode 		= component.find("companyCode").get("v.value");
		var posIsSaved 			= component.get("v.savedPos");
		var posIsRejected 		= component.get("v.rejectedPos");
		console.log("OB_Maintenance_Consistenza_LogRequestHelper.js : Log Request Id : " + logRequestId);
		console.log("OB_Maintenance_Consistenza_LogRequestHelper.js : Convention Code Value : " + codiceConvenzione);
		console.log("OB_Maintenance_Consistenza_LogRequestHelper.js : Company Code Value : " + companyCode);
		console.log("OB_Maintenance_Consistenza_LogRequestHelper.js : POS is saved : " + posIsSaved);
		console.log("OB_Maintenance_Consistenza_LogRequestHelper.js : POS is rejected : " + posIsRejected);

		try
		{
			var saveAcqInputs = component.get("c.saveAcqInputs");
			saveAcqInputs.setParams
			({
				"logRequestId" 		: logRequestId		,
				"codiceConvenzione" : codiceConvenzione ,
				"companyCode" 		: companyCode 		,
				"posIsSaved" 		: posIsSaved 		,
				"posIsRejected" 	: posIsRejected
			});
			saveAcqInputs.setCallback(this,function(response)
			{
				var state = response.getState();
				if (state === "SUCCESS") 
				{
					component.set("v.savedAcq",true);
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams
					({
						type	: 	"Success",
						title 	: 	$A.get("$Label.c.OB_MAINTENANCE_TOAST_OPERATIONSUCCESSFULL"),
						message	: 	"     ",
						mode	: 	"dismissible"
					});
					toastEvent.fire();
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
							console.log("OB_Maintenance_Consistenza_Log_RequestController.js : saveAcqInputs : Error message: " + errors[0].message);
						}
					}
					else 
					{
						console.log("OB_Maintenance_Consistenza_Log_RequestController.js : saveAcqInputs : *UNKNOW ERROR*");
					}
				}
			});
			$A.enqueueAction(saveAcqInputs);
		}
		catch(err) 
		{
			console.log('[EXCE] OB_Maintenance_Consistenza_Log_RequestHelper.js : saveAcqInputs : ' + err.message);
		}
	},

	rejectPosInputs : function(component,event,helper)
	{
		var logRequestId 			= component.get("v.recordId");
		var dataInstallazionePos 	= component.find("dataInstallazionePos").get("v.value");
		var dataDisinstallazionePos = component.find("dataDisinstallazionePos").get("v.value");
		var acqIsSaved 				= component.get("v.savedAcq");
		var acqIsRejected 			= component.get("v.rejectedAcq");
		console.log("OB_Maintenance_Consistenza_LogRequestHelper.js : Log Request Id : " + logRequestId);
		console.log("OB_Maintenance_Consistenza_LogRequestHelper.js : Installation Date POS Value : " + dataInstallazionePos);
		console.log("OB_Maintenance_Consistenza_LogRequestHelper.js : Unistallation Date POS Value : " + dataDisinstallazionePos);
		console.log("OB_Maintenance_Consistenza_LogRequestHelper.js : Acquiring is saved : " + acqIsSaved);
		console.log("OB_Maintenance_Consistenza_LogRequestHelper.js : Acquiring is rejected : " + acqIsRejected);

		try
		{
			var rejectPosInputs = component.get("c.rejectPosInputs");
			rejectPosInputs.setParams
			({
				"logRequestId" 				: logRequestId				,
				"dataInstallazionePos" 		: dataInstallazionePos 		,
				"dataDisinstallazionePos" 	: dataDisinstallazionePos 	,
				"acqIsSaved" 				: acqIsSaved 				,
				"acqIsRejected" 			: acqIsRejected
			});
			rejectPosInputs.setCallback(this,function(response)
			{
				var state = response.getState();
				if (state === "SUCCESS") 
				{
					component.set("v.rejectedPos",true);
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams
					({
						type	: 	"Success",
						title 	: 	$A.get("$Label.c.OB_MAINTENANCE_TOAST_OPERATIONSUCCESSFULL"),
						message	: 	"     ",
						mode	: 	"dismissible"
					});
					toastEvent.fire();
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
							console.log("OB_Maintenance_Consistenza_Log_RequestController.js : rejectPosInputs : Error message: " + errors[0].message);
						}
					}
					else 
					{
						console.log("OB_Maintenance_Consistenza_Log_RequestController.js : rejectPosInputs : *UNKNOW ERROR*");
					}
				}
			});
			$A.enqueueAction(rejectPosInputs);
		}
		catch(err) 
		{
			console.log('[EXCE] OB_Maintenance_Consistenza_Log_RequestHelper.js : rejectPosInputs : ' + err.message);
		}
	},

	rejectAcqInputs : function(component,event,helper)
	{
		var logRequestId 		= component.get("v.recordId");
		var codiceConvenzione 	= component.find("codiceConvenzione").get("v.value");
		var companyCode 		= component.find("companyCode").get("v.value");
		var posIsSaved 			= component.get("v.savedPos");
		var posIsRejected 		= component.get("v.rejectedPos");
		console.log("OB_Maintenance_Consistenza_LogRequestHelper.js : Log Request Id : " + logRequestId);
		console.log("OB_Maintenance_Consistenza_LogRequestHelper.js : Convention Code Value : " + codiceConvenzione);
		console.log("OB_Maintenance_Consistenza_LogRequestHelper.js : Company Code Value : " + companyCode);
		console.log("OB_Maintenance_Consistenza_LogRequestHelper.js : POS is saved : " + posIsSaved);
		console.log("OB_Maintenance_Consistenza_LogRequestHelper.js : POS is rejected : " + posIsRejected);

		try
		{
			var rejectAcqInputs = component.get("c.rejectAcqInputs");
			rejectAcqInputs.setParams
			({
				"logRequestId" 		: logRequestId		,
				"codiceConvenzione" : codiceConvenzione ,
				"companyCode" 		: companyCode 		,
				"posIsSaved" 		: posIsSaved 		,
				"posIsRejected" 	: posIsRejected
			});
			rejectAcqInputs.setCallback(this,function(response)
			{
				var state = response.getState();
				if (state === "SUCCESS") 
				{
					component.set("v.savedAcq",true);
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams
					({
						type	: 	"Success",
						title 	: 	$A.get("$Label.c.OB_MAINTENANCE_TOAST_OPERATIONSUCCESSFULL"),
						message	: 	"     ",
						mode	: 	"dismissible"
					});
					toastEvent.fire();
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
							console.log("OB_Maintenance_Consistenza_Log_RequestController.js : rejectAcqInputs : Error message: " + errors[0].message);
						}
					}
					else 
					{
						console.log("OB_Maintenance_Consistenza_Log_RequestController.js : rejectAcqInputs : *UNKNOW ERROR*");
					}
				}
			});
			$A.enqueueAction(rejectAcqInputs);
		}
		catch(err) 
		{
			console.log('[EXCE] OB_Maintenance_Consistenza_Log_RequestHelper.js : rejectAcqInputs : ' + err.message);
		}
	},

		/*
	@author Simone Misani 
	@date 03/07/2019
	@description this method  checks whether the situation is technical Configuration
	*/ 	
	
	checkconfigtec : function(component, event, helper){
		var configTec = component.get("c.compatibilityTechnicalConfigurator");
		configTec.setParams			({
				"configurationId": component.get("v.confId")
			});
			console.log('component.get("v.confId"): '+component.get("v.confId"));
			configTec.setCallback(this,function(response)
			{
				var state = response.getState();
				if (state === "SUCCESS") 
				{
					var technicalConf = response.getReturnValue();
					console.log('technicalConf: '+technicalConf);
					component.set("v.istechnicalconfigurator",technicalConf);
				}
			 	if (state === "ERROR") 
				{
					var errors = response.getError();
					if (errors) 
					{
						if (errors[0] && errors[0].message) 
						{
							console.log("OB_Maintenance_Consistenza_Log_RequestController.js : checkconfigtec : Error message: " + errors[0].message);
						}
					}
					else 
					{
						console.log("OB_Maintenance_Consistenza_Log_RequestController.js : checkconfigtec : *UNKNOW ERROR*");
					}
				}
			});
			$A.enqueueAction(configTec);
		},

			/*
	@author Simone Misani 
	@date 03/07/2019
	@description this method  create second log request
	*/ 	

	createSecondLog : function(component, event, helper){

		var actionSecondLog = component.get("c.createSecondLogrequestTechnicalConfigurator");
		actionSecondLog.setParams
			({
				"logRequestId": component.get("v.recordId")
			});
			actionSecondLog.setCallback(this,function(response)
			{
				var state = response.getState();
				if (state === "SUCCESS") 
				{
					var urlNewLog = response.getReturnValue();
					component.set("v.istechnicalconfigurator", false);
					window.location.href = urlNewLog;	
				}
			 	if (state === "ERROR") 
				{
					var errors = response.getError();
					if (errors) 
					{
						if (errors[0] && errors[0].message) 
						{
							console.log("OB_Maintenance_Consistenza_Log_RequestController.js : checkconfigtec : Error message: " + errors[0].message);
						}
					}
					else 
					{
						console.log("OB_Maintenance_Consistenza_Log_RequestController.js : checkconfigtec : *UNKNOW ERROR*");
					}
				}
			});
			$A.enqueueAction(actionSecondLog);

	}

})