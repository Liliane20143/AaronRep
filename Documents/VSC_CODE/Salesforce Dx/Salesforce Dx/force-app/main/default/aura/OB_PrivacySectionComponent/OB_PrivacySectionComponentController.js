({
	/*
		*	Author			:	Morittu	Andrea
		*	Date			:	23-Aug-2019
		*	Description		:	DoInit of the main controller
	*/
	doInit : function(component, event, helper) {
		console.log('Do init has been fired');

		// ACTION SECTION 
		var objectDataMap 				= 	component.get('v.objectDataMap');		
		var pagoBancomatArePresentJS	=	component.get('c.pagoBancomatArePresent');
		var retrievePrivacyFieldNameJS 	= 	component.get("c.retrievePrivacyFieldName");
		pagoBancomatArePresentJS.setParams( { orderId : objectDataMap.Configuration.Id});
		
		

        Promise.all([
			helper.pre_SetPrivacyInputValues(component, objectDataMap),
            helper.doInit_Helper(component,pagoBancomatArePresentJS),
			helper.retrievePrivacyFieldName_Helper(component,retrievePrivacyFieldNameJS)
        ]).then(function(response) {
				console.log('responseArray is : ' + response);
                component.set("v.status" ,"Success" ) ; 
				component.set("v.statusArray" ,response[1] ) ; 
				
				//START gianluigi.virga 20/09/2019 - if is a quote always show buttons
				if(component.get("v.objectDataMap.isPreventivo")){
					component.set('v.showPrivacyRadioGroup', true);
					helper.setPrivacyValue(component, event, helper);
				}else{
					/* true or false to display privacy input */
					component.set('v.showPrivacyRadioGroup', response[1]);
				}
				//END gianluigi.virga 20/09/2019
				if(response[1]) {
					component.set('v.objectDataMap.activateMandatoryChecksPrivacyInput', true);
				} else {
					component.set('v.objectDataMap.activateMandatoryChecksPrivacyInput', false);
				}

				/* label field construction */
				var labelPrivacyList = [];
				var apiNames = [];
				for(var key in response[2]) {
					labelPrivacyList.push(response[2][key]);
					apiNames.push(key);
				}
				component.set('v.privacyC3', labelPrivacyList[0]);
				component.set('v.privacyC4', labelPrivacyList[1]);
				component.set('v.privacyC5', labelPrivacyList[2]);

				component.set('v.privacyC3API', apiNames[0]);
				component.set('v.privacyC4API', apiNames[1]);
				component.set('v.privacyC5API', apiNames[2]);
            } 
        ).catch(
            function(error) {
                component.set("v.status" ,error ) ; 
                console.log(error);
            }
        );
	},
	
	/*
		*	Author			:	Morittu	Andrea
		*	Date			:	23-Aug-2019
		*	Description		:	OnChange of privacy's input
	*/
	privacySelection : function(component, event, helper) {
		helper.setPrivacyRadioGroup_Helper(component, event, helper);
	},

	/*
		*	Author		:	Morittu	Andrea
		*	Date		:	23-Aug-2019
		*	Description	:	Set	redBorder in privacy's input
	*/
	setRedBorder : function (component, event, helper) {
		helper.setRedBorder_Helper(component, event, helper);
	}
})