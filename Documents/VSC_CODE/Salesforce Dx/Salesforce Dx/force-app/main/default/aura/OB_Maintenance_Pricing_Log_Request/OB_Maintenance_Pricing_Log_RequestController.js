({
	init : function(component, event, helper) {
		var action = component.get('c.retrieveLogRequest');
        var recordid = component.get("v.recordId");
        action.setParams({ 
            "logRequestId" : recordid
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var response = response.getReturnValue();
                var responseParsed = JSON.parse(response);
                console.log('@#@# response'+JSON.stringify(responseParsed));
				component.set("v.responseLogRequest",responseParsed);
				console.log('responseParsed.isButtonsPushed '+responseParsed.isButtonsPushed);
				// if(responseParsed.isButtonsPushed != null){
				// 	if(component.get("v.hasPos") && component.find("startDatePos")!= undefined && responseParsed.isButtonsPushed['POS']){
				// 		component.find("startDatePos").set("v.disabled",'true');
				// 	}
				// 	if(component.get("v.hasAcquiring") && component.find("startDateAcquiring") != undefined && responseParsed.isButtonsPushed['Acquiring']){
				// 		component.find("startDateAcquiring").set("v.disabled",'true');
				// 	}
				// }
                if(responseParsed.listOfRow != null && responseParsed.listOfRow.length>0){
	                	component.set("v.orderId",responseParsed.listOfRow[0].OB_OrderId__c)
	                	console.log('responseParsed.isApprovingProfile'+responseParsed.isApprovingProfile);
	               		component.set("v.isApprovingProfilePos",responseParsed.isApprovingProfile);
	               		component.set("v.isApprovingProfileAcquiring",responseParsed.isApprovingProfile);

		                component.set("v.startDatePos",responseParsed.listOfRow[0].OB_Start_Date_POS__c);
		                component.set("v.startDateAcquiring",responseParsed.listOfRow[0].OB_Start_Date_Acquiring__c);

		                component.set("v.hasPos",responseParsed.listOfRow[0].OB_HasPos__c);
		                component.set("v.hasAcquiring",responseParsed.listOfRow[0].OB_HasAcquiring__c);
		                console.log('@# component.find("startDatePos")'+JSON.stringify(component.find("startDatePos")));

		                if(component.get("v.hasPos") && (component.find("startDatePos").get("v.value") !== undefined  ||
		                		responseParsed.listOfRow[0].OB_Status__c != 'In attesa') ) {
		                	component.set("v.isApprovingProfilePos",false);
							component.find("startDatePos").set("v.disabled",'true');
		                }
		                if(  component.get("v.hasAcquiring") && (component.find("startDateAcquiring").get("v.value") !== undefined  ||
		                	responseParsed.listOfRow[0].OB_Status__c != 'In attesa') ){
		                	component.set("v.isApprovingProfileAcquiring",false);
							component.find("startDateAcquiring").set("v.disabled",'true');
		                }
	            }else{
	           		responseParsed.errorMessage;
	            }
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);    
	},
	// Start antonio.vatrano 13/05/2019 RI-61 method to retrieve information of required fields of LOGREQUEST and current User
	saveButtonPos:function(component, event, helper){
		var action = component.get('c.retrieveRequiredFields');
		var logrequestId = component.get("v.recordId");
        action.setParams({ "logRequestId" : logrequestId });
        action.setCallback(this, $A.getCallback(function (response) {
        	console.log("SUCCESS");
            var state = response.getState();
            if (state === "SUCCESS") {
				var res = response.getReturnValue();
				var startDatePOS = component.find("startDatePos").get("v.value");
				var validStartDate = typeof(startDatePOS)!= 'undefined' && startDatePOS!=null && startDatePOS!='';
				if(res=='' && validStartDate ){
					component.set("v.isApprovingProfilePos",false);
					component.find("startDatePos").set("v.disabled",true);
					helper.saveDatePOS_Helper(component, event, helper);
				}else{
					helper.showErrorMessage(component, event, res, validStartDate);
				}
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
	},

	saveButtonAcquiring:function(component, event, helper){
		var action = component.get('c.retrieveRequiredFields');
		var logrequestId = component.get("v.recordId");
        action.setParams({ "logRequestId" : logrequestId });
        action.setCallback(this, $A.getCallback(function (response) {
        	console.log("SUCCESS");
            var state = response.getState();
            if (state === "SUCCESS") {
				var res = response.getReturnValue();
				var startDateACQ = component.find("startDateAcquiring").get("v.value");
				var validStartDate = typeof(startDateACQ)!= 'undefined' && startDateACQ!=null && startDateACQ!='';
				if(res=='' && validStartDate ){
					component.set("v.isApprovingProfileAcquiring",false);
					component.find("startDateAcquiring").set("v.disabled",true);
					helper.saveDateAcquiring_Helper(component, event, helper);
				}else{
					helper.showErrorMessage(component, event, res, validStartDate);
				}
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
	},
	// End antonio.vatrano 13/05/2019 RI-61 method to retrieve information of required fields of LOGREQUEST and current User
	rejectPos:function(component, event, helper){
		component.set("v.isApprovingProfilePos",false);
		component.find("startDatePos").set("v.disabled",true);
		helper.rejectRequestPOS_Helper(component, event, helper);	
	},
	rejectAcquiring:function(component, event, helper){
		component.set("v.isApprovingProfileAcquiring",false);
		component.find("startDateAcquiring").set("v.disabled",true);
		helper.rejectRequestAcquiring_Helper(component, event, helper);
			
	}
})