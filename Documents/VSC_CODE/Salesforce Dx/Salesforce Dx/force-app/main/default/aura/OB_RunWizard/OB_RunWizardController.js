({
	doInit : function(cmp, event, helper) {
		var wizardId 	= cmp.get("v.wizardId");
		var wizardName 	= cmp.get("v.wizardName");
		var objectType 	= cmp.get("v.objectType");
		var recordId 	= cmp.get("v.recordID");
		var displayMenu = cmp.get("v.displayMenu");
		console.log("Wizard to show:"+wizardName);
		console.log("objectType:"+objectType);
		console.log("recordId:"+recordId);
		var action = cmp.get("c.getWizardIdFromAPIName");
		action.setParams({
			"wizardName": wizardName
		});
		action.setCallback(this, function(response)
		{
            var state = response.getState();
            if (state === "SUCCESS")
            {
            	var wizId = response.getReturnValue();
            	console.log('wizId: '+wizId);
            	$A.createComponent(
					// "bit2flow:dynWizardMain",
					// {
					// 	"wizardConfigurationId": wizId,
					// 	"sourceVF": true,
					// 	"objectId": recordId,
					// 	"objectType":objectType
					// },

					//	micol.ferrari 31/01/2019 - ADDED showMainToast" : false
					"bit2flow:dynWizardMain",
					{
						"wizardConfigurationId": wizId,
						"sourceVF": true,
						"objectId": recordId,
						"objectType": objectType,
						"displayMenu" : displayMenu,
						"showMainToast" : false
					},
					
					function(newCmp, status, errorMessage)
					{
						if (status === "SUCCESS") 
						{
							var body = cmp.get("v.body");
							body.push(newCmp);
							cmp.set("v.body", body);
						}
						else if (status === "INCOMPLETE") 
						{
							console.log("No response from server or client is offline.")
						}
						else if (status === "ERROR") 
						{
							console.log("Error: " + errorMessage);
						}
					}
				);
            }
            else if (state === "ERROR")
            {
            	console.log('GET WIZARD ID FROM API NAME ERROR');
            }
        });
		$A.enqueueAction(action);
	}
})