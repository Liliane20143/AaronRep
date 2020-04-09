({
    doInit : function(component, event, helper)
	{ 	
		// helper.getAbi(component, helper,event );
		console.log('recordId container: ' + component.get("v.recordId"));
		var action = component.get("c.getAccount");
		action.setParams
		({
			servicePointsId_value : component.get("v.recordId")
		});
		action.setCallback(this, function(response)
		{
			if (response.getState() === "SUCCESS")
			{
				console.log('Success in helper:getInfo_helper');
				
				var responseMap = response.getReturnValue();
				console.log('responseMap in helper.getInfo_helper: ' + JSON.stringify(responseMap));

				if (responseMap!=null && responseMap['contextAccount']!=null && responseMap['contextServicePoint']!=null)
				{
					var contextAccount = responseMap['contextAccount'][0];
					
                    component.set("v.AccountData",contextAccount);
                    component.set("v.proposerABI",contextAccount.OB_ABI__c);
					
					// var legalAddress =  contextAccount.OB_Legal_Address_Name__c+'\n'+
					// 					contextAccount.OB_Legal_Address_Street__c+', '+contextAccount.OB_Legal_Address_Street_Number__c+'\n'+
					// 					contextAccount.OB_Legal_Address_ZIP__c+'\n'+
					// 					contextAccount.OB_Legal_Address_City__c+' ('+contextAccount.OB_Legal_Address_State_Code__c+')';
					
					// //var addressName = typeof contextAccount.OB_Legal_Address_Name__c == 'undefined' ? '' : contextAccount.OB_Legal_Address_Name__c;
					// var addressStreet 		= typeof contextAccount.OB_Legal_Address_Street__c == 'undefined' ? '' : contextAccount.OB_Legal_Address_Street__c;
					// var addressStreetNum 	= typeof contextAccount.OB_Legal_Address_Street_Number__c == 'undefined' ? '' :contextAccount.OB_Legal_Address_Street_Number__c;
					// var addressZIP 			= typeof contextAccount.OB_Legal_Address_ZIP__c == 'undefined' ? '' : contextAccount.OB_Legal_Address_ZIP__c;
					// var addressCity 		= typeof contextAccount.OB_Legal_Address_City__c == 'undefined' ? '' : contextAccount.OB_Legal_Address_City__c;
					// var addressStatecode 	= typeof contextAccount.OB_Legal_Address_State_Code__c == 'undefined' ? '' : contextAccount.OB_Legal_Address_State_Code__c;

					// component.set("v.completeLegalAddress", /*addressName+'\n'+*/
					// 										addressStreet+', '+addressStreetNum+'\n'+
					// 										addressZIP+'\n'+
					// 										addressCity+' ('+addressStatecode+')');
	
					// component.set("v.servicePoint", responseMap['contextServicePoint'][0]);

					// component.set("v.contacts", responseMap['contacts']);

					// console.log('acquiring list in helper.getInfo_helper: ' + JSON.stringify(responseMap['acquiringList']));
					// console.log('vas in helper.getInfo_helper: ' + JSON.stringify(responseMap['vasList'])); 
					
					// component.set("v.acquirings", responseMap['acquiringList']);
					// component.set("v.vas", responseMap['vasList']);
					// component.set("v.terminali", responseMap['terminaliList']);
				}

			}
			else if (response.getState() === "INCOMPLETE")
			{
				System.debug('incomplete'); 
			}
			else if (response.getState() === "ERROR") 
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
		$A.enqueueAction(action);
	}
})