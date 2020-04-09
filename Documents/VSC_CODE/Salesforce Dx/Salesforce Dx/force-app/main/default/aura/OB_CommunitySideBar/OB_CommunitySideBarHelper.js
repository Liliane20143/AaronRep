({
	getSidebarLinks : function (component, event, helper) {
		console.log('entrd in classApexConstructor');  
		var action = component.get("c.retrieveCommunityLovs");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
	            console.log('My State is: ' + state); 
	            console.log('Return value IS : ' + JSON.stringify(response.getReturnValue()));
	            component.set("v.objectLov" , response.getReturnValue());
	            var objectLov = [];
	            objectLov = component.get("v.objectLov");
 
            } else if (state === "INCOMPLETE") {
                // do something
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                    console.log('ERRORE!');
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
          $A.enqueueAction(action);
        
        //	GET BANK ACCOUNT INFO
	            var actionBank = component.get("c.getBankInfo");
	            actionBank.setCallback(this, function(response) {
	            	var state = response.getState();
	            	if (state === "SUCCESS") {
	            		console.log('state of getBank is: ' + state);
	            		var currentUser = {};
	            		currentUser = response.getReturnValue();
	            		if (currentUser!=null && currentUser.Profile.UserLicense.Name == $A.get("$Label.c.OB_License_PartnerCommunity")) {
		            		component.set("v.phoneBank", currentUser.Contact.Account.Phone);
		            		component.set("v.faxBank", currentUser.Contact.Account.Fax);
		            		var firstName = currentUser.Contact.FirstName;
		            		var lastName = currentUser.Contact.LastName;
		            		console.log('firstName ' + firstName);
		            		console.log('lastName ' + lastName);

		            		//	START 	micol.ferrari 23/11/2018
		            		var concatenatedNameAndLastName = '';
		            		if (!(typeof(firstName) == 'undefined' || firstName==null || firstName=='' ))
		            		{
		            			concatenatedNameAndLastName += firstName+' ';
		            		}
		            		concatenatedNameAndLastName +=  lastName;
		            		//	END 	micol.ferrari 23/11/2018

		            		component.set("v.currentUserName", concatenatedNameAndLastName);
                            console.log("concatened username is: " + concatenatedNameAndLastName);
		            		//component.set("v.currentUserFirstName", currentUser.Contact.Account.FirstName);
		            		//component.set("v.currentUserLastName", currentUser.Contact.Account.LastName);
		            		
		            		console.log('faxNumber is : ' + component.get("v.faxBank"));
		            		console.log('phone numb is: '+ component.get("v.phoneBank"));
		            		//console.log('phone numb is: '+ component.get("v.currentUserFirstName"));
		            		//console.log('phone numb is: '+ component.get("v.currentUserLastName"));
		            		console.log('response is: ' + JSON.stringify(bankinfo) );
		            	}
	            	} else if(state === "INCOMPLETE") {
	            		console.log('state of getBank is: ' + state);
	            	} else if (state === "ERROR") {
	            	console.log('state of getBank is: ' + state);	
		                var errors = response.getError();
		                if (errors) {
		                    if (errors[0] && errors[0].message) {
		                    console.log('ERRORE!');
		                        console.log("Error message: " + 
		                                 errors[0].message);
		                    }
		                } else {
		                    console.log("Unknown error");
		                }
	            	}
	            });
	            $A.enqueueAction(actionBank);
        
	},
	
})