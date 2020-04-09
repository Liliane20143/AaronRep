({
	/*
		*	Author			:	Morittu	Andrea
		*	Date			:	23-Aug-2019
		*	Description		:	if objectDataMap is already populated it flags automatically the input
	*/
	pre_SetPrivacyInputValues : function(component, objectDataMap){
		
		var parseBoolean = function(incomingBoolean) {
			if(incomingBoolean == 'true' ||  incomingBoolean == true ) {
				return 'true';
			} else if(incomingBoolean == 'false' || incomingBoolean == false) {
				return 'false';
			}
		}

		var finalValue;
		if(!$A.util.isUndefined(objectDataMap.pv)) {
			/* ANDREA MORITTU  START 28-Aug-2019 - FIX_ON_UX.xxx */
			if(	objectDataMap.pv.OB_Privacy_C3__c == true || objectDataMap.pv.OB_Privacy_C3__c == 'true' ||
				objectDataMap.pv.OB_Privacy_C3__c == false || objectDataMap.pv.OB_Privacy_C3__c == 'false') {
				finalValue = parseBoolean(objectDataMap.pv.OB_Privacy_C3__c);
				component.find('OB_Privacy_C3__c').set('v.value', finalValue);
			}
			if(objectDataMap.pv.OB_Privacy_C4__c == true || objectDataMap.pv.OB_Privacy_C4__c == false ||
				objectDataMap.pv.OB_Privacy_C4__c == 'true' || objectDataMap.pv.OB_Privacy_C4__c == 'false') {
				finalValue = parseBoolean(objectDataMap.pv.OB_Privacy_C4__c);
				component.find('OB_Privacy_C4__c').set('v.value', finalValue);
			}
			if(objectDataMap.pv.OB_Privacy_C5__c == true || objectDataMap.pv.OB_Privacy_C5__c == false ||
				objectDataMap.pv.OB_Privacy_C5__c == 'true' || objectDataMap.pv.OB_Privacy_C5__c == 'false') {
				finalValue = parseBoolean(objectDataMap.pv.OB_Privacy_C5__c);
				component.find('OB_Privacy_C5__c').set('v.value', finalValue);
			}
			/* ANDREA MORITTU END 28-Aug-2019 - FIX_ON_UX.xxx */
		}
	},

	/*
		*	Author			:	Morittu	Andrea
		*	Date			:	23-Aug-2019
		*	Description		:	doInit Method - it return true if there is at least one pagobancomat
	*/
	doInit_Helper : function(component,pagoBancomatArePresentJS) {
        return new Promise(function(resolve, reject) { 
            pagoBancomatArePresentJS.setCallback(this, function(response) {
				var state = response.getState();
				if (state === "SUCCESS") {
					var showPrivacyRadioGroup = response.getReturnValue();
					resolve(showPrivacyRadioGroup);
				} else {
					var error = new Error(response.getError());
					reject(error);
				}
			}); 
            $A.enqueueAction(pagoBancomatArePresentJS);
        });
	},

	/*
		*	Author			:	Morittu	Andrea
		*	Date			:	23-Aug-2019
		*	Description		:	this method retrieve dynamically the field label and it put it inside attributes 
								(These for not creating a custom label and for retrieving as the user local)
	*/
	retrievePrivacyFieldName_Helper : function(component,retrievePrivacyFieldNameJS) {
        return new Promise(function(resolve, reject) { 
            retrievePrivacyFieldNameJS.setCallback(this, function(response) {
				var state = response.getState();
				if (state === "SUCCESS") {
					var fidlLabels = response.getReturnValue();
					resolve(fidlLabels);
				} else {
					var error = new Error(response.getError());
					reject(error);
				}
			}); 
            $A.enqueueAction(retrievePrivacyFieldNameJS);
        });
	},

	/*
		*	Author			:	Morittu	Andrea
		*	Date			:	23-Aug-2019
		*	Description		:	Function to valorize the input dynamically
	*/
	setPrivacyRadioGroup_Helper : function (component, event, helper){
		var wichOne = event.getSource().get('v.name');
		var radioValue = event.getParam('value');

		$A.util.removeClass(component.find(wichOne), "slds-has-error flow_required");
		component.set('v.errorOn_' + wichOne, false );
		

		var parseBoolean = function(stringedBoolean){ 
			if(stringedBoolean == 'true' || stringedBoolean == true ){
				return true;
			} else if(stringedBoolean == 'false' || stringedBoolean == false ){
				return false;
			}
		};

		var booleanValue = parseBoolean(radioValue);
		var objectDataMap = component.get('v.objectDataMap');
		console.log('## objectDataMap.pv is ' , JSON.stringify(objectDataMap.pv));
		component.set('v.objectDataMap.pv.' + wichOne, booleanValue );

		//START gianluigi.virga 20/09/2019
		if(component.get("v.objectDataMap.isPreventivo")){
			var privacy3 = component.get("v.objectDataMap.pv.OB_Privacy_C3__c");
			var privacy4 = component.get("v.objectDataMap.pv.OB_Privacy_C4__c");
			var privacy5 = component.get("v.objectDataMap.pv.OB_Privacy_C5__c");

			if((privacy3 == true || privacy3 =='true') && (privacy4 == true || privacy4 =='true') && (privacy5 == true || privacy5 =='true')){
				component.set("v.objectDataMap.isPrivacyOk", true);
				component.set("v.isPrivacyOk", true);
			}else{
				component.set("v.objectDataMap.isPrivacyOk", false);
				component.set("v.isPrivacyOk", false);
			}
		}
		//END gianluigi.virga 20/09/2019
	},
	/*
		*	Author			:	Morittu	Andrea
		*	Date			:	23-Aug-2019
		*	Description		:	Method to set dynamically red border
	*/

	setRedBorder_Helper : function(component, event, helper) {
		
		console.log('setRedBorder has been fired!');
		let objectDataMap = component.get('v.objectDataMap');
		if(!$A.util.isEmpty(objectDataMap.checkMapValuesServicePointStepValidation)) {
			var mapFromNext = {};
			mapFromNext = objectDataMap.checkMapValuesServicePointStepValidation;

			console.log("mandatory field from map: " + JSON.stringify(mapFromNext));
			try {
				for(var key in mapFromNext) {
					component.set('v.errorOn_' + key, true);
					// $A.util.addClass(component.find('errorOn_'+key), "slds-has-error flow_required");
					var errorMessage = mapFromNext[key];
					component.set('v.errorMessage', errorMessage);
				}
			}catch(exc) {
				console.log('## An error has occured : ' + exc.message);
			}
		}
	},
	//START gianluigi.virga 20/09/2019 - retrieve privacy value from service point
	setPrivacyValue : function(component, event, helper) {
		var action = component.get("c.retrievePrivacyServicePoint");
        var servicePointId = component.get("v.objectDataMap.pv.Id");
        console.log('servicePointId: '+servicePointId);
        action.setParams({
            "servicePointId": servicePointId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
				var privacyMap = {};
				privacyMap = response.getReturnValue();
				var parseBoolean = function(incomingBoolean) {
					if(incomingBoolean == 'true' ||  incomingBoolean == true ) {
						return 'true';
					} else if(incomingBoolean == 'false' || incomingBoolean == false) {
						return 'false';
					}
				}
				var finalValue3 = parseBoolean(privacyMap['OB_Privacy_C3__c']);
				var finalValue4 = parseBoolean(privacyMap['OB_Privacy_C4__c']);
				var finalValue5 = parseBoolean(privacyMap['OB_Privacy_C5__c']);
				
				component.set('v.valueC3', finalValue3);
				component.set('v.objectDataMap.pv.OB_Privacy_C3__c', finalValue3);
				console.log('val3 '+component.get("v.valueC3"));
				component.set('v.valueC4', finalValue4);
				component.set('v.objectDataMap.pv.OB_Privacy_C4__c', finalValue4 );
				console.log('val4 '+component.get("v.valueC4"));
				component.set('v.valueC5', finalValue5);
				component.set('v.objectDataMap.pv.OB_Privacy_C5__c', finalValue5 );
				console.log('val5 '+component.get("v.valueC5"));

				var privacy3 = component.get('v.valueC3');
				var privacy4 = component.get('v.valueC4');
				var privacy5 = component.get('v.valueC5');
				if((privacy3 == true || privacy3 =='true') && (privacy4 == true || privacy4 =='true') && (privacy5 == true || privacy5 =='true')){
					component.set("v.objectDataMap.isPrivacyOk", true);
					component.set("v.isPrivacyOk", true);
				}else{
					component.set("v.objectDataMap.isPrivacyOk", false);
					component.set("v.isPrivacyOk", false);
				}
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        _utils.debug("Error message: " +
                        errors[0].message);
                    }
                }
            }
        });
        $A.enqueueAction(action);
    }
	//END gianluigi.virga 20/09/2019
})