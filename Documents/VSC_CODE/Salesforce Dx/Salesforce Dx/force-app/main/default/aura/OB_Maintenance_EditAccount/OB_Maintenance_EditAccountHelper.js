({
	disableFields : function(component, event, helper) {
		var dis= component.get("v.disabled");
		var myInputs = component.find("MainDiv").find({instancesOf : "lightning:input"});
        for(var i = 0; i < myInputs.length; i++){
        	console.log(myInputs[i]);
        	myInputs[i].set('v.disabled',dis);
        }
        var disabledFields = component.get('v.DisabledFields');
        for(var i in disabledFields){
        	component.find(disabledFields[i]).set('v.disabled',true);
        }
	},

	retrieveFieldsLabel : function(component, event, helper) {
        var action = component.get('c.retriveSchemaInformation');
        var listOfSobject = ["Account", "Contact"];
        action.setParams({ 
            "SObjectToRetrive" : listOfSobject
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var valueReturns = response.getReturnValue();
                var myMap = new Map(); 
                var result = JSON.parse( valueReturns );
                try{
                var accountFields = result.mapSObjectfields['Account'];
       			var contactFiels = result.mapSObjectfields['Contact'];
                component.set("v.AccountFieldsLabel",accountFields);
                component.set("v.ContactFieldsLabel",contactFiels);

                }
                catch(err){
                	console.log(err);
                }
 
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);    
	},

    /**
    * @author Marta Stempien <marta.stempien@accenture.com>
    * @date 03/07/2019
    * @task NEXI-144
    * @description Method calls apex method to create log requests
    * @history NEXI-298 Marta Stempien <marta.stempien@accenture.com> 07/09/2019 - Modified
    */
	saveDataHelper :  function(component, event, oldObject, newObject)
	{
	    let action = component.get('c.getRequests');
	    let objectDataMap = {};
	    let logRequestsRequiringDocumentation = []; // NEXI-298 Marta Stempien <marta.stempien@accenture.com> 09/09/2019 Added variable
	    try
	    {
	        objectDataMap = JSON.stringify(component.get('v.objectDataMap'));
            action.setParams
            ({
                "oldData" : oldObject,
                "newData" : newObject,
                "objectDataMap" : objectDataMap
            });
            action.setCallback(this, $A.getCallback(function (response)
            {
                let state = response.getState();
                if (state === "SUCCESS")
                {
                    component.find("SaveButton").set("v.disabled", true); //francesca.ribezzi 11/11/19 - PROD-66 - disable/enable btn to avoid duplicates
                    let returnedValues = response.getReturnValue();
                    for (let returnedValue of returnedValues)
                    {
                        // NEXI-298 Marta Stempien <marta.stempien@accenture.com> 09/09/2019 Start
                        if(returnedValue.message =='Success' && !$A.util.isEmpty(returnedValue.logRequestId))
                        {
                            if(returnedValue.documentRequired)
                            {
                                logRequestsRequiringDocumentation.push(returnedValue.logRequestId);
                            }
                            component.set("v.logRequestId", returnedValue.logRequestId);
                            if(returnedValue.isNotIntegrated == 'false' || returnedValue.isNotIntegrated == false){
                                component.set("v.logRequestIdForMip", returnedValue.logRequestId);
                                
                            }
                        }
                         else
                        {
                            component.find("SaveButton").set("v.disabled", false); //francesca.ribezzi 11/11/19 - PROD-66 - disable/enable btn to avoid duplicates
                            this.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR"), returnedValue.message, 'error');
                            console.log(returnedValue.message);
                            break;
                        }
                    }
                    if(!$A.util.isEmpty(logRequestsRequiringDocumentation))
                    {
                         component.set("v.documentationRequired", true);
                         component.set("v.logRequestsRequiringDocumentation", logRequestsRequiringDocumentation);
                    }
                    // NEXI-298 Marta Stempien <marta.stempien@accenture.com> 09/09/2019 Stop
                    if(!$A.util.isEmpty(component.get("v.logRequestId"))&&(!component.get("v.documentationRequired")))
                    {
                        //NEXI-329 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 17/09/2019 Start
                        // <daniele.gandini@accenture.com> - 18/07/2019 - WN-144 - start
                        let promisedActions = [];
                        for (let returnedValue of returnedValues)
                        {
                            if(returnedValue.isNotIntegrated == 'false' || returnedValue.isNotIntegrated == false)
                            {
                                promisedActions.push(this.startSerializeAnagrafica(component));
                            }
                            else
                            {
                                promisedActions.push(this.startAcquiringApprovalProcessForNotIntegrated(component,returnedValue.logRequestId))
                            }
                        }
                        Promise.all(promisedActions)
                        .then($A.getCallback(result=>
                        {
                            console.log('Promises Results ',result);
                            let objectToRedirect;
                            for(let singleResult of result)
                            {
                                if(singleResult.isIntegrated == false)
                                {
                                    objectToRedirect = singleResult.logRequestId;
                                    break;
                                }
                                else
                                {
                                    if($A.util.isUndefinedOrNull(objectToRedirect))
                                    {
                                        objectToRedirect = singleResult.logRequestId
                                    }
                                }
                            }
                            let navEvt = $A.get("e.force:navigateToSObject");
                            navEvt.setParams(
                            {
                                "recordId": objectToRedirect,
                                "slideDevName": "related"
                            });
                            navEvt.fire();
                        }))
                        .catch(result=>
                        {
                            console.log('Promise error ',result);
                            component.find("SaveButton").set("v.disabled", false); //francesca.ribezzi 11/11/19 - PROD-66 - disable/enable btn to avoid duplicates
                            this.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR"), $A.get("$Label.c.OB_ServerLogicFailed"), 'error');
                        });
                        // <daniele.gandini@accenture.com> - 18/07/2019 - WN-144 - stop
                        //NEXI-329 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 17/09/2019 Stop
                    }
                }
                else if (state === "ERROR")
                {
                    let errors = response.getError();
                    console.error(errors);
                    this.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR"), $A.get("$Label.c.OB_ServerLogicFailed"), 'error');
                }
            }));
            $A.enqueueAction(action);
        }
        catch(error)
        {
            this.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR"), $A.get("$Label.c.OB_ServerLogicFailed"), 'error');
            console.log(error.message);
        }
	},

    /**
     *@author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
     *@date 17/09/2019
     *@task NEXI-329
     *@description Method return promise of startApprovalProcessForSaeAteco
     *@param component, inLogRequestId
     *@return Promise
     *@history 17/09/2019 Method created
     */
	startAcquiringApprovalProcessForNotIntegrated : function( component, inLogRequestId )
    {
        return new Promise((resolve,reject) =>
        {
            let action = component.get("c.startApprovalProcessForSaeAteco");
            action.setParam("inLogRequestId", inLogRequestId );
            action.setCallback(this, function (response)
            {
                let state = response.getState();
                if( state !== 'SUCCESS' )
                {
                    this.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR"), $A.get("$Label.c.OB_ServerLogicFailed"), 'error');
                    console.log('CODE:001');
                    reject( null );
                }
                let responseWrapper = {};
                responseWrapper.isIntegrated = false;
                responseWrapper.logRequestId = response.getReturnValue();
                resolve( responseWrapper );
            });
            $A.enqueueAction( action );
        });
    },

    /**
     *@author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
     *@date 17/09/2019
     *@task NEXI-329
     *@param component
     *@return Promise
     *@description Method return promise of callSerializeAnagrafica
     *@history 17/09/2019 Method created
     */
    startSerializeAnagrafica : function( component )
    {
        return new Promise((resolve,reject) =>
        {
            let logRequestId = component.get("v.logRequestIdForMip");  /* Simone Misani  canghe logrequest id becouse in case   - WN-78 - REMOVED ALERT  *///NEXI-298 Marta Stempien <marta.stempien@accenture.com> 12/09/2019 Deleted temporary fix
            let submitAction = component.get("c.callSerializeAnagrafica");

            submitAction.setParams
            ({
                "logRequestId": logRequestId
            });
            submitAction.setCallback(this, function(response)
            {
                let stateSubmit = response.getState();
                if( stateSubmit === "SUCCESS" )
                {
                    let responseWrapper = {};
                    responseWrapper.isIntegrated = true;
                    responseWrapper.logRequestId = response.getReturnValue();
                    resolve(responseWrapper);
                }
                else if(stateSubmit === "ERROR")
                {
                    this.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR"), $A.get("$Label.c.OB_ServerLogicFailed"), 'error');

                    let errorsSubmit = response.getError();
                    if (errorsSubmit)
                    {
                        if (errorsSubmit[0] && errorsSubmit[0].message)
                        {
                            console.log("Error message: " + errorsSubmit[0].message);
                        }
                    }
                    else
                    {
                        console.log("Unknown error");
                    }
                     reject( null );
                }
            });
            $A.enqueueAction(submitAction);
        });
    },

	/**
    * @author Marta Stempien <marta.stempien@accenture.com>
    * @date 11/07/2019
    * @task NEXI-179
    * @params component
    * @description Prepares data for Change Data Company Section, excluding SAE/ATECO part of Section
    * @history NEXI-298 Marta Stempien <marta.stempien@accenture.com> 07/09/2019 - Modified
    */
    generateDataForChangeCompanyDataSection : function( component )
    {
        let newObject = {};
        let oldObject = {}; //NEXI-298 Marta Stempien <marta.stempien@accenture.com 09/09/2019 Added variable
    	let companyMissingFields = component.get("v.companyMissingFields");
    	let objectDataMap = component.get('v.objectDataMap');
        let nameValue  = component.find('Name').get("v.value");
        let legalForm = objectDataMap.acc.OB_Legal_Form__c;
        let newAccountData = {};
        let oldAccountData = {}; //NEXI-298 Marta Stempien <marta.stempien@accenture.com 09/09/2019 Added variable

        try
        {
            oldAccountData = JSON.parse(component.get("v.FlowData")).acc;
            newAccountData = JSON.parse(JSON.stringify(objectDataMap.acc));
        }
        catch(error)
        {
            this.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR"), $A.get("$Label.c.OB_ServerLogicFailed"), 'error');
            console.log(error.message);
        }
        if($A.util.isEmpty(nameValue) )
        {
            $A.util.addClass( component.find('Name') , 'slds-has-error flow_required');
            companyMissingFields.push( $A.get("$Label.c.Merchant_Name"));
        }
        if($A.util.isEmpty(legalForm))
        {
            $A.util.addClass( component.find('OB_Legal_Form__c'), 'slds-has-error flow_required');
            companyMissingFields.push(component.get("v.AccountFieldsLabel.OB_Legal_Form__c"));
        }
        else if(!component.get('v.legalFormAllowSave') )
        {
            $A.util.addClass( component.find('OB_Legal_Form__c'), 'slds-has-error flow_required');
            this.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR"), $A.get("$Label.c.OB_MAINTENANCE_FISCALCODENOTCOMPATIBLEWITHLEGALFORM"), 'error');
        }
        else if(companyMissingFields.length>0)
        {
            component.set('v.companyMissingFields', companyMissingFields);
        }
        else
        {
            component.set("v.saeAtecoHasChanged", false);
            if(!$A.util.isEmpty(newAccountData))
            {
                if($A.util.isUndefined(oldAccountData.OB_SAE_Code__c))
                {
                    oldAccountData.OB_SAE_Code__c = '';
                }
                newAccountData.OB_SAE_Code__c = oldAccountData.OB_SAE_Code__c;
                newAccountData.OB_SAE_Description__c = oldAccountData.OB_SAE_Description__c;
                newAccountData.OB_FATECO__c = oldAccountData.OB_FATECO__c;

                if(!($A.util.isUndefined(newAccountData.OB_ATECO__c)))
                {
                    newAccountData.OB_ATECO__c = oldAccountData.OB_ATECO__c;
                    newAccountData.OB_ATECO_Description__c = oldAccountData.OB_ATECO_Description__c;
                }
            }
        }
        newObject['Account'] = newAccountData;
        oldObject['Account'] = oldAccountData; //NEXI-298 Marta Stempien <marta.stempien@accenture.com 09/09/2019 Added variable
        component.set("v.newObject", newObject);
        component.set("v.oldObject", oldObject); //NEXI-298 Marta Stempien <marta.stempien@accenture.com 09/09/2019 Set attribute
    },

    /**
    * @author Marta Stempien <marta.stempien@accenture.com>
    * @date 11/07/2019
    * @task NEXI-179
    * @params component
    * @description Method prepares data filled in sections Sede Legale, Sede Administrativo
    * @history NEXI-298 Marta Stempien <marta.stempien@accenture.com> 07/09/2019 - Modified
    */
    generateDataForAddressSections : function(component)
    {
        let legalMissingFields = [];
        let adminOfficeMissingFields = [];
        component.set("v.legalMissingFields",legalMissingFields);
        component.set("v.adminOfficeMissingFields", adminOfficeMissingFields);
        let objectDataMap = component.get("v.objectDataMap");
        let newObject = component.get("v.newObject");
        let newAccountData = {};
        let newContactData = {};
        try
        {
             newAccountData = JSON.parse(JSON.stringify(newObject['Account']));
        }
        catch(error)
        {
             this.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR"), $A.get("$Label.c.OB_ServerLogicFailed"), 'error');
             console.log(error.message);
        }
        //START gianluigi.virga 10/09/2019 - UX55
        //let isLegalEqualAdministrative = component.get('v.objectDataMap.isLegalEqualAdm');
        let isLegalEqualAdministrative = component.get("v.isEqualsAddress");
		//END gianluigi.virga 10/09/2019 - UX55
        if(isLegalEqualAdministrative)
        {
            newAccountData.OB_Administrative_Office_Hamlet__c = newAccountData.OB_Legal_Address_Hamlet__c;
            newAccountData.OB_Administrative_Office_Address_Details__c = newAccountData.OB_Legal_Address_Detail__c;
            newAccountData.OB_Administrative_Office_City__c = newAccountData.OB_Legal_Address_City__c;
            newAccountData.OB_Administrative_Office_Country__c = newAccountData.OB_Legal_Address_Country__c;
            newAccountData.OB_Administrative_Office_Country_Code__c = newAccountData.OB_Legal_Address_Country_Code__c;
            newAccountData.OB_Administrative_Office_State__c = newAccountData.OB_Legal_Address_State__c;
            newAccountData.OB_Administrative_Office_State_Code__c = newAccountData.OB_Legal_Address_State_Code__c;
            newAccountData.OB_Administrative_Office_Street__c = newAccountData.OB_Legal_Address_Street__c;
            newAccountData.OB_Administrative_Office_Street_number__c = newAccountData.OB_Legal_Address_Street_Number__c;
            newAccountData.OB_Administrative_Office_ZIP__c = newAccountData.OB_Legal_Address_ZIP__c;
        }

        let phoneValue, emailValue;
        if(component.get('v.showLegalOffice')==true){
            phoneValue = component.find('Phone').get("v.value");
            emailValue = component.find('Email').get("v.value");
        }

        if(component.get('v.showLegalOffice') == true && !$A.util.isEmpty(newContactData))
        {
            if($A.util.isEmpty(phoneValue))
            {
                $A.util.addClass( component.find('Phone') , 'slds-has-error flow_required');
                legalMissingFields.push( component.get("v.ContactFieldsLabel.Phone"));

            }
            if($A.util.isEmpty(emailValue))
            {
                $A.util.addClass( component.find('Email') , 'slds-has-error flow_required');
                legalMissingFields.push(component.get("v.ContactFieldsLabel.Email"));
            }
        }
        if(!$A.util.isEmpty(newAccountData))
        {
            if($A.util.isEmpty(newAccountData.OB_Legal_Address_State__c))
            {
                legalMissingFields.push(component.get("v.AccountFieldsLabel.OB_Legal_Address_State__c"));
                $A.util.addClass( component.find('OB_Legal_Address_State__c'), 'slds-has-error flow_required');
            }
            if($A.util.isEmpty(newAccountData.OB_Legal_Address_City__c))
            {
                legalMissingFields.push(component.get("v.AccountFieldsLabel.OB_Legal_Address_City__c"));
                $A.util.addClass( component.find('OB_Legal_Address_City__c'), 'slds-has-error flow_required');
            }
            if($A.util.isEmpty(newAccountData.OB_Legal_Address_Street__c))
            {
                legalMissingFields.push(component.get("v.AccountFieldsLabel.OB_Legal_Address_Street__c"));
                $A.util.addClass( component.find('OB_Legal_Address_Street__c'), 'slds-has-error flow_required');

            }
            if($A.util.isEmpty(newAccountData.OB_Legal_Address_Street_Number__c))
            {
                legalMissingFields.push(component.get("v.AccountFieldsLabel.OB_Legal_Address_Street_Number__c"));
                $A.util.addClass( component.find('OB_Legal_Address_Street_Number__c'), 'slds-has-error flow_required');
            }
            if($A.util.isEmpty(newAccountData.OB_Legal_Address_ZIP__c))
            {
                legalMissingFields.push(component.get("v.AccountFieldsLabel.OB_Legal_Address_ZIP__c"));
                $A.util.addClass( component.find('OB_Legal_Address_ZIP__c'), 'slds-has-error flow_required');
            }
            if(legalMissingFields.length)
            {
                component.set("v.legalMissingFields", legalMissingFields);
            }
            if(!isLegalEqualAdministrative)
            {
                if($A.util.isEmpty(newAccountData.OB_Administrative_Office_State__c))
                {
                   adminOfficeMissingFields.push(component.get("v.AccountFieldsLabel.OB_Administrative_Office_State__c"));
                   $A.util.addClass( component.find('OB_Administrative_Office_State__c'), 'slds-has-error flow_required');

                }
                if($A.util.isEmpty(newAccountData.OB_Administrative_Office_City__c))
                {
                    adminOfficeMissingFields.push(component.get("v.AccountFieldsLabel.OB_Administrative_Office_City__c"));
                    $A.util.addClass( component.find('OB_Administrative_Office_City__c'), 'slds-has-error flow_required');
                }
                if($A.util.isEmpty(newAccountData.OB_Administrative_Office_Street__c))
                {
                    adminOfficeMissingFields.push(component.get("v.AccountFieldsLabel.OB_Administrative_Office_Street__c"));
                    $A.util.addClass( component.find('OB_Administrative_Office_Street__c'), 'slds-has-error flow_required');

                }
                if($A.util.isEmpty(newAccountData.OB_Administrative_Office_Street_number__c))
                {
                    adminOfficeMissingFields.push(component.get("v.AccountFieldsLabel.OB_Administrative_Office_Street_number__c"));
                    $A.util.addClass( component.find('OB_Administrative_Office_Street_number__c'), 'slds-has-error flow_required');
                }
                if($A.util.isEmpty(newAccountData.OB_Administrative_Office_ZIP__c))
                {
                    adminOfficeMissingFields.push(component.get("v.AccountFieldsLabel.OB_Administrative_Office_ZIP__c"));
                    $A.util.addClass( component.find('OB_Administrative_Office_ZIP__c'), 'slds-has-error flow_required');
                }
                if (adminOfficeMissingFields.length > 0)
                {
                    component.set("v.adminOfficeMissingFields", adminOfficeMissingFields);
                }
            }
                newObject['Account'] = newAccountData;
                component.set("v.newObject", newObject);
            }
    },


    /**
    * @author Marta Stempien <marta.stempien@accenture.com>
    * @date 11/07/2019
    * @task NEXI-179
    * @params component
    * @description Method prepares data for SAE/ATECO part from Change Company Data Section
    * @history NEXI-298 Marta Stempien <marta.stempien@accenture.com> 07/09/2019 - Modified
    */
    getSaeAtecoChanges : function( component )
    {
        let companyMissingFields = component.get("v.companyMissingFields");
        let objectDataMap = component.get("v.objectDataMap");
        let newObjectNotIntegrated = {};
        let oldObjectNotIntegrated = {};
        let newAccountData = {};
        let newAccountDataSAE = {};
        let oldAccountData = {};
        try
        {
            newAccountData = JSON.parse(JSON.stringify(objectDataMap.merchant));
            oldAccountData = JSON.parse(component.get("v.FlowData")).acc;
        }
        catch(error)
        {
            this.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR"), $A.get("$Label.c.OB_ServerLogicFailed"), 'error');
            console.log(error.message);
        }
        if($A.util.isEmpty(newAccountData.OB_SAE_Code__c))
        {
            component.set("v.missingSae", true);
            companyMissingFields.push( $A.get("$Label.c.OB_SAE"));
        }
        else
        {
             component.set("v.missingSae", false);
        }
        if(component.get("v.showAteco") && $A.util.isEmpty(newAccountData.OB_ATECO__c))
        {
            component.set("v.missingAteco", true);
            companyMissingFields.push( $A.get("$Label.c.OB_ATECO"));
        }
        else
        {
            component.set("v.missingAteco", false);
        }

        if(companyMissingFields.length>0)
        {
            component.set("v.companyMissingFields", companyMissingFields);
        }
        else if((newAccountData.OB_SAE_Code__c != oldAccountData.OB_SAE_Code__c) || (newAccountData.OB_ATECO__c != oldAccountData.OB_ATECO__c))
        {
            oldAccountData = JSON.parse(JSON.stringify(component.get("v.newObject"))).Account;
            oldAccountData.OB_BypassValidation__c = true;
            component.set("v.oldAccountSae", oldAccountData);
            newAccountData = JSON.parse(JSON.stringify(oldAccountData));
            newAccountData.OB_SAE_Code__c = objectDataMap.merchant.OB_SAE_Code__c;
            newAccountData.OB_SAE_Description__c = objectDataMap.merchant.OB_SAE_Description__c;
            newAccountData.OB_FATECO__c = objectDataMap.merchant.OB_FATECO__c;  // NEXI-194 Marta Stempien <marta.stempien@accenture.com> 09/07/2019
            if(newAccountData.OB_FATECO__c == 'N')
            {
                newAccountData.OB_ATECO__c = '';
                newAccountData.OB_ATECO_Description__c = '';
            }
            else if(!($A.util.isUndefined(objectDataMap.merchant.OB_ATECO__c)))
            {
                newAccountData.OB_ATECO__c = objectDataMap.merchant.OB_ATECO__c;
                newAccountData.OB_ATECO_Description__c = objectDataMap.merchant.OB_ATECO_Description__c;
            }
            component.set("v.saeAtecoHasChanged", true);
            objectDataMap.documentRequired = true;
            newObjectNotIntegrated['Account'] = newAccountData;
            oldObjectNotIntegrated['Account'] = oldAccountData;
            component.set("v.objectDataMap", objectDataMap);
        }
        // NEXI-298 Marta Stempien <marta.stempien@accenturec.com> 09/09/2019 Start
        else
        {
            oldObjectNotIntegrated['Account'] = JSON.parse(JSON.stringify(component.get("v.newObject"))).Account;
            newObjectNotIntegrated['Account'] = oldObjectNotIntegrated['Account'];
        }
        component.set("v.newObjectNotIntegrated", newObjectNotIntegrated);
        component.set("v.oldObjectNotIntegrated", oldObjectNotIntegrated);
        // NEXI-298 Marta Stempien <marta.stempien@accenturec.com> 09/09/2019 Stop

    },


	// NEXI-144 Marta Stempien <marta.stempien@accenture.com> 03/07/2019 - savecustomHelper method deleted

    /**
    * @author Marta Stempien <marta.stempien@accenture.com>
    * @date 11/07/2019
    * @task NEXI-179
    * @params component
    * @description Method prepares data for Societa section for Operational user
    * @history NEXI-298 Marta Stempien <marta.stempien@accenture.com> 07/09/2019 - Modified
    */
     generateDataForSocietaSectionOperational : function( component )
     {
     	let newObjectNotIntegrated = component.get("v.newObjectNotIntegrated");
     	let oldObjectNotIntegrated = component.get("v.oldObjectNotIntegrated");
     	let newExternalSourceMappings = [];
     	let oldExternalSourceMappings = [];
     	try
     	{
     	    newExternalSourceMappings = JSON.parse(JSON.stringify(component.get("v.listOfExternalSourceMapping")));
     	    oldExternalSourceMappings= JSON.parse(JSON.stringify(component.get("v.oldExternalSourceMapping")));
            oldObjectNotIntegrated['externalSourceMappings'] = oldExternalSourceMappings; //NEXI-348 Marta Stempien <marta.stempien@accenture.com> 24/09/2019 Deleted wrong condition

        }
        catch(error)
        {
             this.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR"), $A.get("$Label.c.OB_ServerLogicFailed"), 'error');
             console.log(error.message);
        }
        newObjectNotIntegrated['externalSourceMappings'] = newExternalSourceMappings;
     	component.set("v.newObjectNotIntegrated", newObjectNotIntegrated);
     	component.set("v.oldObjectNotIntegrated", oldObjectNotIntegrated);
     },





	showToast: function (component, event,title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },

	setAddressMappingLegalAddress : function(component, event) {
		var postelcomponentparamslegaladdress = {};
		postelcomponentparamslegaladdress.sectionaddress          = 'sedelegale';
		postelcomponentparamslegaladdress.sectionName          	  = 'SedeLegale';

		postelcomponentparamslegaladdress.provincedisabled        = 'false';
		postelcomponentparamslegaladdress.provinceinputobject     = 'acc';
		postelcomponentparamslegaladdress.provinceinputfield      = 'OB_Legal_Address_State__c';

		postelcomponentparamslegaladdress.citydisabled            = 'true';
		postelcomponentparamslegaladdress.cityinputobject         = 'acc';
		postelcomponentparamslegaladdress.cityinputfield          = 'OB_Legal_Address_City__c';

		postelcomponentparamslegaladdress.districtdisabled        = 'true';
		postelcomponentparamslegaladdress.districtinputobject     = 'acc';
		postelcomponentparamslegaladdress.districtinputfield      = 'OB_Legal_Address_Hamlet__c';

		postelcomponentparamslegaladdress.streetdisabled          = 'true';
		postelcomponentparamslegaladdress.streetinputobject       = 'acc';
		postelcomponentparamslegaladdress.streetinputfield        = 'OB_Legal_Address_Street__c';
		
		postelcomponentparamslegaladdress.streetnumberdisabled    = 'false'; //gianluigi.virga 10/09/2019 - UX-55
		postelcomponentparamslegaladdress.streetnumberinputobject = 'acc';
		postelcomponentparamslegaladdress.streetnumberinputfield  = 'OB_Legal_Address_Street_Number__c';

		postelcomponentparamslegaladdress.zipcodedisabled         = 'false';
		postelcomponentparamslegaladdress.zipcodeinputobject      = 'acc';
		postelcomponentparamslegaladdress.zipcodeinputfield       = 'OB_Legal_Address_ZIP__c';

		postelcomponentparamslegaladdress.countrydisabled         = 'false';
		postelcomponentparamslegaladdress.countryinputobject      = 'acc';
		postelcomponentparamslegaladdress.countryinputfield       = 'OB_Legal_Address_Country__c';

		postelcomponentparamslegaladdress.countrycodeinputobject  = 'acc';
		postelcomponentparamslegaladdress.countrycodeinputfield   = 'OB_Legal_Address_Country_Code__c';

		postelcomponentparamslegaladdress.provincecodeinputobject = 'acc';
		postelcomponentparamslegaladdress.provincecodeinputfield  = 'OB_Legal_Address_State_Code__c';
		postelcomponentparamslegaladdress.isComplete              = 'true';

		postelcomponentparamslegaladdress.withCountry             = 'false';
		postelcomponentparamslegaladdress.withDetail              = 'true';
		postelcomponentparamslegaladdress.pressoinputfield        = 'OB_Legal_Address_Detail__c';
		postelcomponentparamslegaladdress.pressoinputobject       = 'acc';

		component.set("v.postelcomponentparamslegaladdress", postelcomponentparamslegaladdress);
		console.log('postelcomponentparamslegaladdress');
		console.log(JSON.stringify(postelcomponentparamslegaladdress));
	},
	setAddressMappingAdministrativeOffice : function(component, event) {
		var postelcomponentparamsadmoffice = {};
		postelcomponentparamsadmoffice.sectionaddress          = 'sedeamministrativa';
		postelcomponentparamsadmoffice.sectionName             = 'sedeAmministrativa';

		postelcomponentparamsadmoffice.provincedisabled        = 'false';
		postelcomponentparamsadmoffice.provinceinputobject     = 'acc';
		postelcomponentparamsadmoffice.provinceinputfield      = 'OB_Administrative_Office_State__c';

		postelcomponentparamsadmoffice.citydisabled            = 'true';
		postelcomponentparamsadmoffice.cityinputobject         = 'acc';
		postelcomponentparamsadmoffice.cityinputfield          = 'OB_Administrative_Office_City__c';

		postelcomponentparamsadmoffice.districtdisabled        = 'true';
		postelcomponentparamsadmoffice.districtinputobject     = 'acc';
		postelcomponentparamsadmoffice.districtinputfield      = 'OB_Administrative_Office_Hamlet__c';

		postelcomponentparamsadmoffice.streetdisabled          = 'true';
		postelcomponentparamsadmoffice.streetinputobject       = 'acc';
		postelcomponentparamsadmoffice.streetinputfield        = 'OB_Administrative_Office_Street__c';
		
		postelcomponentparamsadmoffice.streetnumberdisabled    = 'false'; //gianluigi.virga 10/09/2019 - UX-55
		postelcomponentparamsadmoffice.streetnumberinputobject = 'acc';
		postelcomponentparamsadmoffice.streetnumberinputfield  = 'OB_Administrative_Office_Street_number__c';

		postelcomponentparamsadmoffice.zipcodedisabled         = 'false';
		postelcomponentparamsadmoffice.zipcodeinputobject      = 'acc';
		postelcomponentparamsadmoffice.zipcodeinputfield       = 'OB_Administrative_Office_ZIP__c';

		postelcomponentparamsadmoffice.countrydisabled         = 'false';
		postelcomponentparamsadmoffice.countryinputobject      = 'acc';
		postelcomponentparamsadmoffice.countryinputfield       = 'OB_Administrative_Office_Country__c';

		postelcomponentparamsadmoffice.countrycodeinputobject  = 'acc';
		postelcomponentparamsadmoffice.countrycodeinputfield   = 'OB_Administrative_Office_Country_Code__c';

		postelcomponentparamsadmoffice.provincecodeinputobject = 'acc';
		postelcomponentparamsadmoffice.provincecodeinputfield  = 'OB_Administrative_Office_State_Code__c';
		postelcomponentparamsadmoffice.isComplete              = 'true';

		postelcomponentparamsadmoffice.withCountry             = 'false';
		postelcomponentparamsadmoffice.withDetail              = 'true';
		postelcomponentparamsadmoffice.pressoinputfield        = 'OB_Administrative_Office_Address_Details__c';
		postelcomponentparamsadmoffice.pressoinputobject       = 'acc';

		component.set("v.postelcomponentparamsadmoffice", postelcomponentparamsadmoffice);
		console.log('postelcomponentparamsadmoffice');
		console.log(JSON.stringify(postelcomponentparamsadmoffice));
	},
	setAddressMappingCCIAA : function(component, event) {
		var postelcomponentparamsCCIAA = {};
		postelcomponentparamsCCIAA.sectionaddress          = 'CCIAA';
		postelcomponentparamsCCIAA.sectionName             = 'CCIAA';

		postelcomponentparamsCCIAA.provincedisabled        = 'false';
		postelcomponentparamsCCIAA.provinceinputobject     = 'acc';
		postelcomponentparamsCCIAA.provinceinputfield      = 'OB_CCIAA_Province__c';

		postelcomponentparamsCCIAA.provincecodeinputobject = 'acc';
		postelcomponentparamsCCIAA.provincecodeinputfield  = 'OB_CCIAA_Province_Code__c';
		postelcomponentparamsCCIAA.isComplete              = 'false';
		postelcomponentparamsCCIAA.withCity                = 'false';

		component.set("v.postelcomponentparamsCCIAA", postelcomponentparamsCCIAA);
		console.log('postelcomponentparamsCCIAA');
		console.log(JSON.stringify(postelcomponentparamsCCIAA));
	},
	setAddressMappingLegalForm : function(component, event) {
		var postelcomponentparamsLegalForm = {};
		postelcomponentparamsLegalForm.objectDataNode          = 'acc';
		postelcomponentparamsLegalForm.objectDataField         = 'OB_Legal_Form__c';
		postelcomponentparamsLegalForm.lovType			       = 'LegalForm';
		postelcomponentparamsLegalForm.lovOrderBy     		   = 'Name';
		postelcomponentparamsLegalForm.lovSourceField          = 'OB_Legal_Form__c||Name,OB_Legal_Form_Code__c||NE__Value1__c';
		postelcomponentparamsLegalForm.inputFieldId 		   = 'FormaGiuridica';
		postelcomponentparamsLegalForm.fieldInputLabel  	   = 'OB_LegalForm';
		postelcomponentparamsLegalForm.mapLabelColumns         = 'Name||Forma Giuridica';

		component.set("v.postelcomponentparamsLegalForm", postelcomponentparamsLegalForm);
		console.log('postelcomponentparamsLegalForm');
		console.log(JSON.stringify(postelcomponentparamsLegalForm));
	},

	/**
    * @author salvatore.pianura
    * @date 2019/05/10
    * @task ?
    * @description Maitnenance Anagrafica Integration
    * @history NEXI-301 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 04/09/2019 new param, navigate to record, error handling
    */
	serializeAnagrafica : function( component, event, navigateToRecordPage )
	{
        /* ANDREA MORITTU - START 11-Jul-19  - WN-78 - REMOVED ALERT  */
		let logRequestId = component.get("v.logRequestIdForMip");  /* Simone Misani  canghe logrequest id becouse in case   - WN-78 - REMOVED ALERT  *///NEXI-298 Marta Stempien <marta.stempien@accenture.com> 12/09/2019 Deleted temporary fix  //NEXI-329 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 17/09/2019
		let submitAction = component.get("c.callSerializeAnagrafica");

		submitAction.setParams
		({
			"logRequestId": logRequestId
		});
		submitAction.setCallback(this, function(response)
		{
			let stateSubmit = response.getState();
			if( stateSubmit === "SUCCESS" )
			{
				this.showToast(component, event, $A.get(" "), $A.get("$Label.c.OB_MAINTENANCE_SUCCESSOPERATION"), 'success');
				if ( navigateToRecordPage )
				{
                    let navigateAction = $A.get("e.force:navigateToSObject");
                    navigateAction.setParams
                    ({
                        "recordId": component.get("v.logRequestId"),//NEXI-329 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 17/09/2019
                        "slideDevName": "detail"
                    });
                    navigateAction.fire();
                }
			}
			else if(stateSubmit === "ERROR")
			{
				this.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR"), $A.get("$Label.c.OB_ServerLogicFailed"), 'error');

				let errorsSubmit = response.getError();
				if (errorsSubmit)
				{
					if (errorsSubmit[0] && errorsSubmit[0].message)
					{
						console.log("Error message: " + errorsSubmit[0].message);
					}
				}
				else
				{
					console.log("Unknown error");
				}
			}
		});
		$A.enqueueAction(submitAction);
	},
	//END - 2019/05/10 - salvatore.pianura- Maitnenance Anagrafica Integration

	/**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 03/06/2019
    * @task NEXI-58
    * @description Method open modal for new Titolari Effectivi contact
    */
	openTEmodal : function(component)
	{
	    component.set("v.showTEmodal",true);
    },

    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 30/05/2019
    * @task NEXI-58
    * @description Cancel all changes from owner section
    * @history 18/06/2019 Joanna Mielczarek <joanna.mielczarek@accenture.com> removed apex call, clearing tableData
    */
    cancelOwnerChanges : function(component)
    {
        component.set( "v.tableData", [] );
        component.set( "v.areChangesOnOwnerSection", false );
        component.set( "v.refreshOwnersTable", false );
        component.set( "v.refreshOwnersTable", true );
        component.set( "v.refreshOwnersTable", true );
        component.set( "v.newOwnerContacts", '[]' );
    },

    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 03/06/2019
    * @task NEXI-58
    * @description Method confirm all changes from owner section
    */
    confirmOwnerChanges : function (component,event,helper)
    {
        let inOldContacts = [];
        let inNewContacts = [];
        let isEdit = false;
        let isInsert =false;
        let isPep = false; //NEXI-289 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 04/09/2019
        for(let rowWrapper of component.get("v.tableData"))
        {
            //Simone Misani&& ANtonio Vatrano 17/10/2019 R1F3-149 START 
            var oldC = JSON.stringify(rowWrapper.oldContact);
            var newC = JSON.stringify(rowWrapper.newContact);
            if(oldC != newC){
                inOldContacts.push(rowWrapper.oldContact);
                inNewContacts.push(rowWrapper.newContact);
            }
            //Simone Misani&& ANtonio Vatrano 17/10/2019 R1F3-149 END 
            if(!isInsert && rowWrapper.actionType === 'Inserito')
            {
                isInsert = true;
            }
            if(!isEdit && rowWrapper.actionType === 'Modificato')
            {
                isEdit=true;
            }
            //NEXI-289 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 04/09/2019 Start
            if(!isPep && (rowWrapper.actionType === 'Inserito' || rowWrapper.actionType === 'Modificato') && String(rowWrapper.newContact.OB_PEP__c) === 'true')
            {
                isPep = true;
            }
            //NEXI-289 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 04/09/2019 Stop
        }
        let action = component.get('c.createLogRequest');
        action.setParams
        (
            {
                "inOldContacts" : inOldContacts,
                "inNewContacts" : inNewContacts,
                "inAccountId" : component.get("v.objectDataMap.acc.Id"),
                "inIsEditOrUpdate" : (isInsert || isEdit),
                "inIsPep" : isPep //NEXI-289 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 04/09/2019
            }
        );
        action.setCallback(this, $A.getCallback(function (response)
        {
            let state = response.getState();
            if (state !== "SUCCESS"  )
            {
                this.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR"), $A.get("$Label.c.OB_ServerLogicFailed"), 'error');
                return;
            }
            let result = response.getReturnValue();
            if(result.isError)
            {
                this.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR"), $A.get("$Label.c.OB_ServerLogicFailed"), 'error');
                console.log(' Error in confirmOwnerChanges '+result.errorMessage);
                return;
            }
            let logRequestId = result.logRequestId;
            component.set("v.isTEEdit",isEdit);
            if(isInsert || isEdit)
            {
                component.set("v.isTEConfirmed",true);
                component.set("v.logRequestId",logRequestId);
                component.set("v.documentationRequired",true);
            }
            else
            {
                let navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams
                ({
                    "recordId": logRequestId,
                    "slideDevName": "detail"
                });
                navEvt.fire();
            }
        }));
        $A.enqueueAction(action);
    },

    /**
    * @author Grzegorz Banach <grzegorz.banach@accenture.com>
    * @date 11/06/2019
    * @description Method close modal
    */
    handleModal: function(component, event) {
        event.stopPropagation();
        let cancelBtnClicked = event.getParam( "isCancelButtonClicked" );
        if ( $A.util.isUndefinedOrNull( cancelBtnClicked ) || typeof cancelBtnClicked != 'boolean' )
        {
           return;
        }
        component.set( "v.showTEmodal", false );
    },

    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 11/06/2019
    * @description Method handle request for insert of new TE
    */
    handleContactEvent : function(component, event)
    {
        let tableData = component.get("v.tableData");
        let logRequestType = event.getParam("logRequestType");
        if(logRequestType === 'Inserito')
        {
            let inContact = JSON.parse(event.getParam("inContactJson"));
            var oldContact =JSON.parse(event.getParam("inContactJson"));
            let tableWrapper = {};
            tableWrapper.accountId = component.get("v.objectDataMap.acc.Id");
            tableWrapper.newContact = inContact;
            tableWrapper.oldContact = this.toBlankContact(oldContact); //Simone Misani&& ANtonio Vatrano 17/10/2019 R1F3-149 
            tableWrapper.actionType = logRequestType;
            tableData.push(tableWrapper);
            component.set("v.tableData", tableData);
            if(this.checkTableContent(component)>=6)
            {
                component.set("v.isTEInsertPossible",false);
            }
            else
            {
                component.set("v.isTEInsertPossible",true);
            }
            component.set( "v.isTEDeletePossible", true ); // NEXI-169 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 05/07/2019
            component.set("v.refreshOwnersTable",false);
            component.set("v.refreshOwnersTable",true);
            component.set("v.showTEmodal",false);
        }
        component.set("v.areChangesOnOwnerSection",true);
    },

    /**
    * @author Joanna Mielczarek <joanna.mielczarek@accenture.com>
    * @date 20/06/2019
    * @description Method creates new, empty Contact with Titolari Effettivo RecordTypeId
    */
    createEmptyContact : function ( component )
    {
        let action = component.get( "c.getInitDataWrapper" );
        action.setParam( "inAccountId", component.get( "v.objectDataMap.acc.Id" ) );
        action.setCallback( this, $A.getCallback( function ( response )
        {
            let state = response.getState();
            if( state === "SUCCESS" && response.getReturnValue( ) != null )
            {
                let result = response.getReturnValue();
                let emptyContact = {};
                emptyContact.LastName ='';
                emptyContact.FirstName ='';
                emptyContact.OB_PEP__c =false;
                emptyContact.OB_Sex__c ='F';
                emptyContact.OB_SkipCadastralCodeCheck__c =false;
                emptyContact.OB_Fiscal_Code__c='';
                emptyContact.OB_Citizenship__c='';
                emptyContact.OB_Birth_State__c='';
                emptyContact.OB_Birth_City__c='';
                emptyContact.OB_Country_Birth__c='';
                emptyContact.OB_Country_Birth_Code__c='';
                emptyContact.OB_Birth_State_Code__c='';
                emptyContact.OB_Address_State__c='';
                emptyContact.OB_Address_City__c='';
                emptyContact.OB_Address_Hamlet__c='';
                emptyContact.OB_Address_Street__c='';
                emptyContact.OB_Address_Street_Number__c='';
                emptyContact.OB_Address_PostalCode__c='';
                emptyContact.OB_Address_Country__c='';
                emptyContact.OB_Address_Country_Code__c='';
                emptyContact.OB_Address_State_Code__c='';
                emptyContact.RecordTypeId = result.contactRecordTypeId;
                emptyContact.AccountId  = component.get( "v.objectDataMap.acc.Id" );
                emptyContact.OB_Bank__c = !$A.util.isEmpty( result.bankId ) ? result.bankId : ''; // NEXI-127 Joanna Mielczarek <joanna.mielczarek@accenture.com> 26/06/2019
                component.set( 'v.newContactEmptyObject', emptyContact );
                component.set( "v.hasLogRequest", result.hasLogRequest );
            }
            else
            {
                this.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR"), $A.get("$Label.c.OB_ServerLogicFailed"), 'error');
                console.log( "Error in createEmptyContact" );
            }
        }));
        $A.enqueueAction( action );
    },

    // NEXI-110 Wojciech Szuba <wojciech.szuba@accenture.com> 19/06/2019 - Logic that was moved from controller function modify - START
    modifyData : function(component, event) {
        component.set("v.disabled",false);
        component.set("v.status","EDIT");
    },
    // NEXI-110 Wojciech Szuba <wojciech.szuba@accenture.com> 19/06/2019 STOP

   /*
   * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
   * @date 24/06/2019
   * @description Method check how many not deleted rows are in table
   * @history 26/06/2019 NEXI-127 Joanna Mielczarek <joanna.mielczarek@accenture.com> added condition to if statement with OB_EndDate__c
   */
   checkTableContent : function(component)
   {
       let tableData = component.get("v.tableData");
       let notEliminatoElements = 0;
       for (let i = 0; i < tableData.length; i++)
       {
           if ( tableData[i].actionType == "Eliminato" || !$A.util.isEmpty( tableData[i].newContact.OB_EndDate__c ) )
           {
               continue;
           }
           notEliminatoElements++;
       }
       return notEliminatoElements;
   },

   /*
   * @author Marlena Lukomska-Rogala <m.lukomska-rogala@accenture.com>
   * @date 02/07/2019
   * @description: Method checks correctness of NE__Fiscal_code__c length and format
   * @task: NEXI-124
   */
   isFiscalCodeValid:function(component)
   {
       let fiscalCode = component.get("v.objectDataMap.acc.NE__Fiscal_code__c");
       if ($A.util.isEmpty(fiscalCode))
       {
           return false;
       }
       else
       {
           let regex = new RegExp("[a-zA-Z0-9_+-]+");
           let isFiscalCodeSchemaCorrect = regex.test(fiscalCode);
           return (fiscalCode.length == 16 && isFiscalCodeSchemaCorrect) ? true : false;
       }
   },

   /*
   * @author Marlena Lukomska-Rogala <m.lukomska-rogala@accenture.com>
   * @created 03/07/2019
   * @description Method checks correctness of NE__Fiscal_code__c after change on NE_Legal_Form__c
   * @history: 10/07/2019 NEXI-189 Marlena Lukomska-Rogala <m.lukomska-rogala@accenture.com> red border on Forma Giuridica field in the case of disabled save
   * @task: NEXI-124
   */
   checkFiscalCodeCorrectnessAfterLegalFormChange : function(component, event, helper){

        let oldLegalForm = component.get('v.oldLegalForm');
        let newLegalForm = event.getParam('value').acc.OB_Legal_Form__c;
        let legalFormsToValidate = [
            "Ditta Individuale",
            "Libero professionista",
            "Lavoratore autonomo" ,
            "Imprenditore individuale agricolo",
            "Imprenditore individuale non agricolo"
        ];
       // NEXI-179 Marta Stempien <marta.stempien@accenture.com> 11/07/2019 Fix for NEXI-124 - deleted unnecessary toast
       if($A.util.isEmpty(oldLegalForm) || $A.util.isEmpty(newLegalForm)){
           return;
       }
       else if(legalFormsToValidate.includes(newLegalForm) && !legalFormsToValidate.includes(oldLegalForm) && !this.isFiscalCodeValid(component)){
           component.set('v.showCheckFCModal', true);
           component.set('v.legalFormAllowSave', false);
           $A.util.addClass(component.find('FlowInputModal'), 'slds-has-error flow_required');
       } else if(!legalFormsToValidate.includes(newLegalForm) && legalFormsToValidate.includes(oldLegalForm)){
           this.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR"), $A.get("$Label.c.OB_MAINTENANCE_FISCALCODENOTCOMPATIBLEWITHLEGALFORM"), 'error');
           component.set('v.legalFormAllowSave', false);
           $A.util.addClass(component.find('FlowInputModal'), 'slds-has-error flow_required');
       } else {
           component.set('v.legalFormAllowSave', true);
           $A.util.removeClass(component.find('FlowInputModal'), 'slds-has-error flow_required');
       }
   },

    //Start Antonio.vatrano hide btndoc 17/07/2019
    hideBtnDocs : function(component, logId){
        var  hideBtnUpload = component.get('c.confirmDocs');
        hideBtnUpload.setParams({"logId" : logId }); // fix bug antonio.vatrano 18/07/2019
        hideBtnUpload.setCallback(this, $A.getCallback(function (response) // fix bug antonio.vatrano 18/07/2019
        {
            var status = response.getState();
            if (status !== "SUCCESS"  )
            {
                console.log('@@ change flag btn Documents')
            }
        }));
        $A.enqueueAction(hideBtnUpload);
    },
    //end  Antonio.vatrano hide btndoc 17/07/2019

   /*
   * @author Zuzanna Urban <z.urban@accenture.com>
   * @created 15/07/2019
   * @description Method to set listOfExternalSourceMapping, oldExternalSourceMapping and typeOptions
   * @task: NEXI-186
   */
    retrieveExternalSourceMapping : function( component )
    {
        let action = component.get('c.retrieveExternalSourceMapping');
        action.setParams({
            merchantId : component.get("v.objectDataMap.acc.Id")
        });
        action.setCallback(this,function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let valueReturns = response.getReturnValue();
                component.set('v.listOfExternalSourceMapping',valueReturns.listESM);
                component.set('v.oldExternalSourceMapping',valueReturns.listESM);
                component.set('v.typeOptions',valueReturns.picklistValues);
                if ( $A.util.isEmpty(valueReturns.listESM) )
                {
                    component.set( 'v.isNotEmptyTable', false );
                }
            }
            else if (state === "ERROR")
            {
                var errors = response.getError();
                console.log('EditAccountretrieveExternalSourceMapping:Code000 : ' + errors);
                this.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR"), errors, 'error');
            }
        });
        $A.enqueueAction(action);
    },

    /*
    *   Author  :   Morittu Andrea
    *   Date    :   25-Jul-2019
    *   Task    :   New Logic employees Number MAINTENANCE ANAGRAFICA
    */
    retrieveEmployeesNumber : function(component,action)
    {
        return new Promise(function(resolve, reject)
        {
            action.setCallback(this,function(response)
            {
                var state = response.getState();
                if (state === "SUCCESS")
                {
                    var employeesMap = response.getReturnValue();
                    resolve(employeesMap);
                }
                else
                {
                    reject(new Error(response.getError()));
                }
            });
            $A.enqueueAction(action);
        });
    },

    /**
     *@author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
     *@date 18/09/2019
     *@task NEXI-339
     *@param oldObject, newObject
     *@description Method check if there was some undefined for sae. it change it to ''
     *@history 18/09/2019 Method created
     */
    protectSaeAtecoFromUndefined : function(oldObject, newObject)
    {
        if( $A.util.isUndefined(oldObject['Account'].OB_SAE_Code__c ))
        {
            oldObject['Account'].OB_SAE_Code__c = '';
        }
        if( $A.util.isUndefined(oldObject['Account'].OB_SAE_Description__c ))
        {
            oldObject['Account'].OB_SAE_Description__c = '';
        }
        if( $A.util.isUndefined(oldObject['Account'].OB_FATECO__c ))
        {
            oldObject['Account'].OB_FATECO__c = '';
        }
        if( $A.util.isUndefined(oldObject['Account'].OB_ATECO__c ))
        {
            oldObject['Account'].OB_ATECO__c = '';
        }
        if( $A.util.isUndefined(oldObject['Account'].OB_ATECO_Description__c ))
        {
            oldObject['Account'].OB_ATECO_Description__c = '';
        }
        //NEW
        if( $A.util.isUndefined(newObject['Account'].OB_SAE_Code__c ))
        {
            newObject['Account'].OB_SAE_Code__c = '';
        }
        if( $A.util.isUndefined(newObject['Account'].OB_SAE_Description__c ))
        {
            newObject['Account'].OB_SAE_Description__c = '';
        }
        if( $A.util.isUndefined(newObject['Account'].OB_FATECO__c ))
        {
            newObject['Account'].OB_FATECO__c = '';
        }
        if( $A.util.isUndefined(newObject['Account'].OB_ATECO__c ))
        {
            newObject['Account'].OB_ATECO__c = '';
        }
        if( $A.util.isUndefined(newObject['Account'].OB_ATECO_Description__c ))
        {
            newObject['Account'].OB_ATECO_Description__c = '';
        }
    },

     //Simone Misani&& ANtonio Vatrano 17/10/2019 R1F3-149 START 
    toBlankContact : function(inContact)
    {
        var toReturn = {};
        toReturn =inContact
        for (var k in toReturn){
            if(toReturn[k]!== false && toReturn[k]!== true ){
               toReturn[k] = null;
           }
           if(toReturn[k] == "1"){
            toReturn[k] = null;
           }
         }
         console.log('@@@ contact Blank'+JSON.stringify(toReturn));

         return toReturn;
    }
     //Simone Misani&& ANtonio Vatrano 17/10/2019 R1F3-149 END 
})