({
	init : function(component, event, helper) {
	    // NEXI-93 Marta Stempien <marta.stempien@accenture.com> 27/05/2019 - Start //
		var flowdata = component.get("v.FlowData");
		let saeAtecoMapping = {};
		saeAtecoMapping.SAE_objectDataNode = 'merchant';
		saeAtecoMapping.SAE_lovOrderBy = 'Name';
		saeAtecoMapping.SAE_fieldInputLabel = 'OB_SAE';
        saeAtecoMapping.SAE_mapLabelColumns = 'Name||Cod. SAE,NE__Value1__c||Descrizione SAE';
        saeAtecoMapping.SAE_objectDataField = 'OB_SAE_Code__c';
        saeAtecoMapping.SAE_lovType ='SAE';
        saeAtecoMapping.SAE_inputFieldId = 'SAE';
        saeAtecoMapping.SAE_lovSourceField ='OB_SAE_Code__c||Name,OB_SAE_Description__c||NE__Value1__c,OB_FATECO__c||NE__Value2__c';
        saeAtecoMapping.ATECO_objectDataNode = 'merchant';
        saeAtecoMapping.ATECO_objectDataField = 'OB_ATECO__c';
        saeAtecoMapping.ATECO_fieldInputLabel = 'OB_ATECO';
        saeAtecoMapping.ATECO_lovType = 'ATECO';
        saeAtecoMapping.ATECO_lovOrderBy = 'Name';
        saeAtecoMapping.ATECO_lovSourceField = 'OB_ATECO__c||Name,OB_ATECO_Description__c||NE__Value1__c';
        saeAtecoMapping.ATECO_inputFieldId = 'ATECO';
        saeAtecoMapping.ATECO_fatecoField = 'OB_SAE_Code__c';
        saeAtecoMapping.ATECO_subTypeField = 'NE__Value2__c';
        saeAtecoMapping.ATECO_fatecoFieldFlag = 'OB_FATECO__c';
        saeAtecoMapping.ATECO_mapLabelColumns = 'Name||Cod. Ateco,NE__Value1__c||Descrizione ATECO';

        // NEXI-298 Marta Stempien <marta.stempien@accenture.com> 06/09/2019 Start
        component.set("v.newObject", {});
        component.set("v.oldObject", {});
        component.set("v.newObjectNotIntegrated", {});
        component.set("v.oldObjectNotIntegrated", {});
        // NEXI-298 Marta Stempien <marta.stempien@accenture.com> 06/09/2019 Stop

        component.set('v.saeAtecoMapping', saeAtecoMapping );
        // NEXI-94 Marta Stempien <marta.stempien@accenture.com> 21/06/2019 - Start
        component.set('v.isFromEditAccount', true);
        // NEXI-94 Marta Stempien <marta.stempien@accenture.com> 21/06/2019 - Stop
        // NEXI-93 Marta Stempien <marta.stempien@accenture.com> 27/05/2019 - Stop
       	helper.disableFields(component,event,helper);
		helper.retrieveFieldsLabel(component,event,helper);
		helper.setAddressMappingLegalAddress(component, event);
		helper.setAddressMappingAdministrativeOffice(component, event);
		helper.setAddressMappingCCIAA(component, event);
		helper.setAddressMappingLegalForm(component, event);
		// NEXI-110 Wojciech Szuba <wojciech.szuba@accenture.com> 19/06/2019 START
		helper.modifyData(component, event);
		// NEXI-179 Marta Stempien <marta.stempien@accenture.com> 16/07/2019 Deleted call helper.disableFields
		// NEXI-110 Wojciech Szuba <wojciech.szuba@accenture.com> 19/06/2019 STOP
		component.set('v.objectDataMap',JSON.parse(flowdata));
		console.log('@do init objdata  '+JSON.stringify(component.get('v.objectDataMap')['legalOffice']));
		//GIOVANNI SPINELLI - 11/01/2019  - HIDE LEGAL FORM FIELD IF THERE ISN T A LEGAL FORM
		if(!component.get('v.objectDataMap')['legalOffice']){
			component.set('v.showLegalOffice' , false);
		}
		component.set('v.isLoaded',true);
		helper.createEmptyContact( component ); // NEXI-60 Joanna Mielczarek <joanna.mielczarek@accenture.com> 20/06/2019

        component.set('v.oldLegalForm', component.get('v.objectDataMap.acc.OB_Legal_Form__c')); //NEXI-124 Marlena Łukomska-Rogala <m.lukomska-rogala@accenture.com> 04.07.2019
        //NEXI-186 Zuzanna Urban <z.urban@accenture.com> 09/07/2019 Start, add table to new section
        component.set('v.externalSourceMappingColumns', [
            {label: $A.get("$Label.c.OB_Source"), fieldName: 'OB_Source__c', type: 'text'},
            {label: $A.get("$Label.c.OB_MAINTENANCE_COMPANYCODE"), fieldName: 'OB_CustomerCodeClientCode__c', type: 'text'}, //NEXI-321 Marta Stempien <marta.stempien@accenture.com> 10/09/2019 Changed for OB_CustomerCodeClientCode__c field
            {label: $A.get("$Label.c.OB_ReportType"), fieldName: 'OB_ReportType__c', type: 'text'}
             ]);
        helper.retrieveExternalSourceMapping( component );
         //NEXI-186 Zuzanna Urban <z.urban@accenture.com> 09/07/2019 Stop, add table to new section

        /*
        *  Author   :   Morittu Andrea
        *  Date     :   25-Jul-2019
        *  Task     :   (Untracked)NewLogicOnEmployeesNumberAnagrafica
        */
        var action = component.get("c.getEmployeesNumber");
        helper.retrieveEmployeesNumber(component,action).then(
            function(employeesMap) {
                var tempMap = [];
                for (var key in employeesMap) {
                    tempMap.push({ value: employeesMap[key], key: key });
                }
                component.set("v.employeesNumberList", tempMap);
            }
        ).catch(
            function(error) {
                component.set("v.status" ,error ) ;
                console.log(error);
            }
        );
        /*Morittu Andrea END */
    },

   // NEXI-124 Marlena Lukomska-Rogala <m.lukomska-rogala@accenture.com> 03.07.2019 START
    onLegalFormChange:function(component, event, helper){
        helper.checkFiscalCodeCorrectnessAfterLegalFormChange(component, event, helper)
    },
    // NEXI-124 Marlena Lukomska-Rogala <m.lukomska-rogala@accenture.com> 03.07.2019 STOP

	modify : function(component, event, helper) {
			helper.modifyData(component, event); // NEXI-110 Wojciech Szuba <wojciech.szuba@accenture.com> 19/06/2019 - Moved most of the logic to helper
			// NEXI-194 Marta Stempien <marta.stempien@accenture.com> Calling helper.disableFields deleted - 09/07/2019
	},
    // NEXI-110 Wojciech Szuba <wojciech.szuba@accenture.com> 19/06/2019 - Edited assignments so fields are still editable after clicking specific button - START
	revertModify : function(component, event, helper) {
			// NEXI-194 Marta Stempien <marta.stempien@accenture.com> Setting v.disabled to false deleted - 09/07/2019
			// reset all modified data
			var flowdata = component.get("v.FlowData");
            component.set('v.objectDataMap',JSON.parse(flowdata));
            //START gianluigi.virga 10/09/2019 - UX-55
			component.set("v.isEqualsAddress", true);
			//END gianluigi.virga 10/09/2019 - UX-55
			component.set("v.status","EDIT");
			// NEXI-194 Marta Stempien <marta.stempien@accenture.com> Calling helper.disableFields deleted - 09/07/2019

	},
	// NEXI-110 Wojciech Szuba <wojciech.szuba@accenture.com> 19/06/2019 STOP

	closeModalNoDocs : function(component, event, helper) {
		component.set("v.documentationRequired",false);
	},

	closeModal : function(component, event, helper) {
		var save = component.get("v.showSaveButton");
       	console.log("*******Save Button: "+save);
		var requestID =  component.get("v.logRequestId");
		console.log('REQUEST ID IN CLOSE MODAL: ' + requestID);
		// NEXI-301 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 04/09/2019 navigating to record page moved to helper.serializeAnagrafica

		if(save)
		{
		    //NEXI-287 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 02/09/2019 START move hideBtnDocs and add one parameter inIsInsert
		    //NEXI-60 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 18/06/2019 START
		    if(component.get("v.isTEConfirmed"))
		    {
		        let isInsert =false;
                for(let rowWrapper of component.get("v.tableData"))
                {
                    if( rowWrapper.actionType === 'Inserito')
                    {
                        isInsert = true;
                        break;
                    }
                }
		        let action = component.get('c.startApprovalProcess');
                action.setParam("inLogRequestId" , requestID );
                action.setParam("inIsInsert" , isInsert );
                action.setCallback(this, $A.getCallback(function (response)
                {
                    let state = response.getState();
                    if (state !== "SUCCESS"  )
                    {
                        helper.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR"), $A.get("$Label.c.OB_ServerLogicFailed"), 'error');
                        // NEXI-179 Marta Stempien <marta.stempien@accenture.com> 16/07/2019
                        return;
                    }
                    component.set('v.hideBroker', true);
                    //navEvt.fire();     //    Antonio.vatrano 09/09/2019 wn 385
                }));
                $A.enqueueAction(action);
                //return;          //   Antonio.vatrano 09/09/2019 wn 385
            }
            // NEXI-298 Marta Stempien <marta.stempien@accenture.com>, 07/09/2019 START Update status for in Attesa if all docs are uploaded for SaeAteco
            else if(component.get("v.saeAtecoHasChanged"))
            {
                let action = component.get('c.updateChangedSaeAtecoLogRequestStatusToInAttesa');
                action.setParam("inLogRequestId" , requestID );
                action.setCallback(this, $A.getCallback(function (response)
                {
                    let state = response.getState();
                    if (state !== "SUCCESS"  )
                    {
                        helper.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR"), $A.get("$Label.c.OB_ServerLogicFailed"), 'error');
                        return;
                    }
                }));
                $A.enqueueAction(action);
            }
            // NEXI-298 Marta Stempien <marta.stempien@accenture.com>, 07/09/2019 STOP

             helper.hideBtnDocs(component,requestID); // Antonio.vatrano hide btndoc 17/07/2019
            //NEXI-60 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 18/06/2019 Stop
            //NEXI-287 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 02/09/2019 Stop
			// start antonio.vatrano 04/04/2019 hide continuationBrokercomponent
			component.set('v.hideBroker', true);
			// end antonio.vatrano 04/04/2019 hide continuationBrokercomponent
			// NEXI-301 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 04/09/2019 START new param, navigating to record from helper method, error handling
			helper.serializeAnagrafica( component, event, true ); //2019/05/10 - salvatore.pianura
		}
		else
		{
		    helper.showToast( component, event, $A.get("$Label.c.OB_MAINTENANCE_OPERATION_FAILED"), $A.get("$Label.c.OB_MAINTENANCE_ERRORMESSAGE_DOCUMENTS") , 'error' );
			// NEXI-301 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 04/09/2019 STOP
		}
	},

	cancel : function(component, event, helper) {

		component.set("v.FlowStep", $A.get("$Label.c.OB_MAINTENANCE_STEP_SUMMARY"));
	},

    /**
    * @author ?
    * @date ?
    * @task ?
    * @description Method called after clicking 'Salva' button tries to create log requests
    * @history NEXI-179 Marta Stempien <marta.stempien@accenture.com> 14/07/2019 - Modified
    * @history NEXI-298 Marta Stempien <marta.stempien@accenture.com> 07/09/2019 - Modified
    */
	savecustom : function(component, event, helper)
	{
        component.find("SaveButton").set("v.disabled", true); //francesca.ribezzi 11/11/19 - PROD-66 - disable/enable btn to avoid duplicates
        // NEXI-144 Marta Stempien <marta.stempien@accenture.com> 03/07/2019 - Start
		let newData = [];
        let oldData = [];
        let oldObject = {};
        let companyMissingFields = [];
        component.set("v.companyMissingFields",companyMissingFields);
        // NEXI-144 Marta Stempien <marta.stempien@accenture.com> 03/07/2019 - Stop
        helper.generateDataForChangeCompanyDataSection(component);
        helper.generateDataForAddressSections( component);
        helper.getSaeAtecoChanges( component );
        let newObject = component.get("v.newObject");
        oldObject['Account'] = JSON.parse(component.get("v.FlowData")).acc;
        // NEXI-298 Marta Stempien <marta.stempien@accenture> 09/09/2019 Deleted oldObject['Contact']
        if(component.get("v.isFromOperation"))
        {
            helper.generateDataForSocietaSectionOperational(component);

        }
        let newAccountData = newObject['Account'];
        // NEXI-298 Marta Stempien <marta.stempien@accenture.com> 09/09/2019 Deleted variable for newContact
        let newAccountSAE = component.get('v.newAccount');
        let missingFields = [];
        companyMissingFields = component.get("v.companyMissingFields");
        let legalMissingFields = component.get("v.legalMissingFields");
        let adminOfficeMissingFields = component.get("v.adminOfficeMissingFields");

        // NEXI-261 Marta Stempien <marta.stempien@accenture.com> 14/08/2019 Start
        // ANDREA MORITTU START 25-Jul-2019 - Adding Employees Company mandatory logic
        let employeesNumberValue = component.find('employeesNumber').get('v.value');
        if($A.util.isEmpty(employeesNumberValue)) {
            companyMissingFields.push(component.find('employeesNumber').get('v.title'));
            $A.util.addClass( component.find('employeesNumber') , 'slds-has-error flow_required');
            component.set('v.objectDataMap.errorFamily.ErrorName', true);
            component.set('v.objectDataMap.errorFamilyMessage.ErrorMessageEmployees' , $A.get("$Label.c.MandatoryField"));
        } else {
            $A.util.removeClass( component.find('employeesNumber') , 'slds-has-error flow_required');
            component.set('v.objectDataMap.errorFamily.ErrorName', false);
            component.set('v.objectDataMap.errorFamilyMessage.ErrorMessageEmployees' , '');
        }
        // NEXI-261 Marta Stempien <marta.stempien@accenture.com> 14/08/2019 Stop
        // ANDREA MORITTU END 25-Jul-2019 - Adding Employees Company mandatory logic

        if(!$A.util.isEmpty(companyMissingFields))
        {
            missingFields.push($A.get('$Label.c.OB_MAINTENANCE_ACCOUNTEDIT_SECTION1')+": " + companyMissingFields);
        }
        if(!$A.util.isEmpty(legalMissingFields))
        {
            missingFields.push($A.get('$Label.c.OB_MAINTENANCE_ACCOUNTEDIT_SECTION2')+": " + legalMissingFields);
        }
        if(!$A.util.isEmpty(adminOfficeMissingFields))
        {
            missingFields.push($A.get('$Label.c.OB_MAINTENANCE_ACCOUNTEDIT_SECTION3')+": " + adminOfficeMissingFields);
        }

        if(missingFields.length>0)
        {
            let missingFieldsError = $A.get("$Label.c.OB_MAINTENANCEMISSINGFIELDS")+" " + missingFields;
            component.find("SaveButton").set("v.disabled", false); //francesca.ribezzi 11/11/19 - PROD-66 - disable/enable btn to avoid duplicates
            helper.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR"), missingFieldsError, 'error');
        }
        else
        {
            if(!$A.util.isEmpty(JSON.parse(JSON.stringify(newAccountData))))
            {
                newAccountData.OB_BypassValidation__c  = true;
                oldObject['Account'].OB_BypassValidation__c = true;
                //Start antonio.vatrano WN-526 28/09/2019
                var isLegalEqualAdministrative = component.get("v.isEqualsAddress");
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
                    newObject['Account'] = newAccountData;
                    
                    component.set('v.objectDataMap.acc.OB_Administrative_Office_Hamlet__c',component.get( 'v.objectDataMap.acc.OB_Legal_Address_Hamlet__c'));
                    component.set('v.objectDataMap.acc.OB_Administrative_Office_Address_Details__c',component.get( 'v.objectDataMap.acc.OB_Legal_Address_Detail__c'));
                    component.set('v.objectDataMap.acc.OB_Administrative_Office_City__c',component.get( 'v.objectDataMap.acc.OB_Legal_Address_City__c'));
                    component.set('v.objectDataMap.acc.OB_Administrative_Office_Country__c',component.get( 'v.objectDataMap.acc.OB_Legal_Address_Country__c'));
                    component.set('v.objectDataMap.acc.OB_Administrative_Office_Country_Code__c',component.get( 'v.objectDataMap.acc.OB_Legal_Address_Country_Code__c'));
                    component.set('v.objectDataMap.acc.OB_Administrative_Office_State__c',component.get( 'v.objectDataMap.acc.OB_Legal_Address_State__c'));
                    component.set('v.objectDataMap.acc.OB_Administrative_Office_State_Code__c',component.get( 'v.objectDataMap.acc.OB_Legal_Address_State_Code__c'));
                    component.set('v.objectDataMap.acc.OB_Administrative_Office_Street__c',component.get( 'v.objectDataMap.acc.OB_Legal_Address_Street__c'));
                    component.set('v.objectDataMap.acc.OB_Administrative_Office_Street_number__c',component.get( 'v.objectDataMap.acc.OB_Legal_Address_Street_Number__c'));
                    component.set('v.objectDataMap.acc.OB_Administrative_Office_ZIP__c',component.get( 'v.objectDataMap.acc.OB_Legal_Address_ZIP__c'));
                }
                //End antonio.vatrano WN-526 28/09/2019
            }
            // NEXI-298 Marta Stempien <marta.stempien@accenture.com> 09/09/2019 Deleted part for Contact
            helper.protectSaeAtecoFromUndefined(oldObject,newObject);//NEXI-339 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 18/09/2019

            let oldObjectStringified = JSON.stringify(oldObject);
            let newObjectStringified = JSON.stringify(newObject);
            if((oldObjectStringified != newObjectStringified) &&(!$A.util.isEmpty(component.get('v.newObject'))))
            {
                // NEXI-298 Marta Stempien <marta.stempien@accenture.com> 09/09/2019 Start
                oldData.push(oldObjectStringified);
                newData.push(newObjectStringified);
            }
            let oldObjectNotIntegratedStringified = JSON.stringify(component.get("v.oldObjectNotIntegrated"));
            let newObjectNotIntegratedStringified = JSON.stringify(component.get("v.newObjectNotIntegrated"));
            if((oldObjectNotIntegratedStringified != newObjectNotIntegratedStringified) &&(!$A.util.isEmpty(component.get("v.newObjectNotIntegrated"))))
            {
                oldData.push(oldObjectNotIntegratedStringified);
                newData.push(newObjectNotIntegratedStringified);
                 // NEXI-298 Marta Stempien <marta.stempien@accenture.com> 09/09/2019 Stop
            }

            if((!$A.util.isEmpty(oldData))&&(!$A.util.isEmpty(newData)))
            {
                try
                {
                    helper.saveDataHelper(component, event, oldData, newData);
                }
                catch(error)
                {
                    component.find("SaveButton").set("v.disabled", false); //francesca.ribezzi 11/11/19 - PROD-66 - disable/enable btn to avoid duplicates
                    helper.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR"), $A.get("$Label.c.OB_ServerLogicFailed"), 'error');
                }
            }
            else
            {
                component.find("SaveButton").set("v.disabled", false); //francesca.ribezzi 11/11/19 - PROD-66 - disable/enable btn to avoid duplicates
                helper.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR"), $A.get("$Label.c.OB_MAINTENANCE_ERROR_NODATACHANGE"), 'error');
            }
        }
	},

	formalCheck : function(component, event, helper)
	{
		console.log('formalCheck method');
		try
		{
            var currentId =event.getSource().getLocalId();
            console.log('currentId : ' + currentId);
            var validationValue = component.find(currentId).get("v.value");
            console.log('validationValue : ' + validationValue);
            var emailControl  = helper.emailControl(validationValue);
            var numberControl = helper.onlyNumberPhone(validationValue);
            var nameControl   = helper.specialCharacter(validationValue);
            var cciaaControl   = helper.controlCCIA(validationValue);			//new AV 21.12.18 control CCIAA
            console.log('nameControl : ' + nameControl);
            if(currentId == 'Email'){
                if((emailControl)=='ERROR' && validationValue.length>0)
                {
                    $A.util.addClass( component.find(currentId) , 'slds-has-error flow_required');
                    component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageEmail" , $A.get("$Label.c.EmailNotValid"))  ;
                    component.set("v.objectDataMap.errorFamily.errorEmail", true);
                }
                else
                {
                    $A.util.removeClass(component.find(currentId) , 'slds-has-error flow_required');
                    component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageEmail" , '')  ;
                    component.set("v.objectDataMap.errorFamily.errorEmail", false);
                }
            }

            //new AV 21.12.18 control CCIAA
            else if(currentId=='OB_CCIAA__c')
            {
                if((cciaaControl)=='ERROR' && validationValue.length>0)
                {
                    $A.util.addClass( component.find(currentId) , 'slds-has-error flow_required');
                     component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageCCIAA" , $A.get("$Label.c.OB_PresenceOfAnInvalidCharacter"))  ; //changeLabel
                     component.set("v.objectDataMap.errorFamily.errorCCIAA", true);
                }
                else
                {
                    $A.util.removeClass(component.find(currentId) , 'slds-has-error flow_required');
                     component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageCCIAA" , '')  ;
                     component.set("v.objectDataMap.errorFamily.errorCCIAA", false);
                }
            }
            //end AV 21.12.18 control CCIAA

            else if(currentId=='OB_PEC__c')
            {
                if((emailControl)=='ERROR' && validationValue.length>0)
                {
                    $A.util.addClass( component.find(currentId) , 'slds-has-error flow_required');
                    component.set("v.objectDataMap.errorFamilyMessage.ErrorMessagePEC" , $A.get("$Label.c.EmailNotValid"))  ;
                    component.set("v.objectDataMap.errorFamily.errorPEC", true);
                }
                else
                {
                    $A.util.removeClass(component.find(currentId) , 'slds-has-error flow_required');
                    component.set("v.objectDataMap.errorFamilyMessage.ErrorMessagePEC" , '')  ;
                    component.set("v.objectDataMap.errorFamily.errorPEC", false);
                }
            }
            else if(currentId=='Phone')
            {
                if((numberControl)=='ERROR' && validationValue.length>0)
                {
                    $A.util.addClass( component.find(currentId) , 'slds-has-error flow_required');
                    component.set("v.objectDataMap.errorFamilyMessage.ErrorMessagePhone" ,  $A.get("$Label.c.MinFiveMaxTenDigitLength"))  ;
                    component.set("v.objectDataMap.errorFamily.errorPhone", true);
                }
                else
                {
                    $A.util.removeClass(component.find(currentId) , 'slds-has-error flow_required');
                    component.set("v.objectDataMap.errorFamilyMessage.ErrorMessagePhone" , '')  ;
                    component.set("v.objectDataMap.errorFamily.errorPhone", false);
                }
            }
            else if(currentId=='Name')
            {
                if((nameControl)=='ERROR' && validationValue.length>0)
                {
                    $A.util.addClass( component.find(currentId) , 'slds-has-error flow_required');
                    component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageName" ,  $A.get("$Label.c.OB_PresenceOfAnInvalidCharacter"))  ;
                    component.set("v.objectDataMap.errorFamily.ErrorName", true);
                }
                else
                {
                    $A.util.removeClass(component.find(currentId) , 'slds-has-error flow_required');
                    component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageName" , '')  ;
                    component.set("v.objectDataMap.errorFamily.ErrorName", false);
                }
            }
        }
	    catch(err)
	    {
	        console.log('err.message e mail: ' + err.message);
        }
     },

    saveAsDraft : function(component, event, helper)
    {
    	var logId = component.get("v.logRequestId");
    	console.log("logrequestid: "+ logId);
    	try
    	{
    		var action = component.get ("c.saveDraft");
    		action.setParams({ "logId" : logId});
    		action.setCallback(this, $A.getCallback(function (response) {
    			var state = response.getState();
    			if (state === "SUCCESS") {
    				try{
    					var navEvt = $A.get("e.force:navigateToSObject");
    					navEvt.setParams({"recordId": logId,"slideDevName": "detail"});
    					console.log("OB_Maintenance_EditNewExecutor_intermediateController.js : navEvt : " + navEvt);
    					navEvt.fire();
    				}
    				catch(err){
    					console.log('err.message navEvt : ' + err.message);
    				}
    				console.log("@@@@@LOG REQUEST UPDATE");
    			}
    			else if (state === "ERROR") {
    				var errors = response.getError();
    				console.error(errors);
    			}
    		}));
    		$A.enqueueAction(action);
    	}
    	catch(err2){
    		console.log("@@@@@LOG REQUEST not UPDATE");
    	}
    },

    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 30/05/2019
    * @task NEXI-58
    * @description Method enable buttons in owner section
    * @history 11/06/2019 NEXI-60 joanna.mielczarek@accenture.com end method if action is 'Eliminato'
    */
    changeInOwnerSection : function(component,event,helper)
    {
        let recordId = event.getParam( "recordId" );
        component.set("v.areChangesOnOwnerSection",true);
        // NEXI-60 grzegorz.banach@accenture.com 11/06/2019 START
        component.set("v.contactTableRecordId", recordId);
        if ( event.getParam( "actionType" ) == 'Eliminato' )
        {
            let notEliminatoElements = helper.checkTableContent(component);
            if(notEliminatoElements>1)
            {
                component.set("v.isTEDeletePossible", true);
                if(notEliminatoElements>=6)
                {
                    component.set("v.isTEInsertPossible",false);
                }
                else
                {
                    component.set("v.isTEInsertPossible",true);
                }
            }
            else
            {
                component.set("v.isTEDeletePossible", false);
            }
            return;
        }
        component.set("v.showTEmodal", true);
        // NEXI-60 grzegorz.banach@accenture.com 11/06/2019 STOP
    },

    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 30/05/2019
    * @task NEXI-58
    * @description Method open modal for new owner contact
    */
    openOwnerSectionModal : function(component,event,helper)
    {
        helper.openTEmodal(component);
    },

    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 30/05/2019
    * @task NEXI-58
    * @description Method revert all changes in owner section
    */
    cancelOwnerChanges : function(component,event,helper)
    {
        helper.cancelOwnerChanges(component);
    },

    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 30/05/2019
    * @task NEXI-58
    * @description Method confirm all changes from owner section
    */
    confirmOwnerChanges : function(component,event,helper)
    {
        helper.confirmOwnerChanges(component);
    },

    handleModal : function(component, event, helper)
    {
        helper.handleModal(component, event);
    },

    handleContactEvent : function(component, event, helper)
    {
        helper.handleContactEvent(component, event);
    },

   /*
   * @author Zuzanna Urban <z.urban@accenture.com>
   * @created 10/07/2019
   * @description Method checks selected rows
   * @task: NEXI-186
   */
	updateSelectedRows :function( component, event ){
		let selectedRows = event.getParam('selectedRows');
        component.set("v.selectedESM", selectedRows);
		if(selectedRows.length > 0)
		{
            component.set("v.isMaintenanceUpdate",false);
		}
		else
		{
            component.set("v.isMaintenanceUpdate",true);
		}
	},

	/*
   * @author Zuzanna Urban <z.urban@accenture.com>
   * @created 10/07/2019
   * @description Method shows the modal with tipologia di rendicontazione to modify
   * @task: NEXI-186
   */
	showTheModal : function( component )
    {
		component.set("v.showMerchantModal",true);
	},

   /*
   * @author Zuzanna Urban <z.urban@accenture.com>
   * @created 10/07/2019
   * @description Method close the modal with tipologia di rendicontazione to modyfy
   * @task: NEXI-186
   */
	closeTheModal : function( component )
    {
		component.set("v.showMerchantModal",false);
	},

   /*
   * @author Zuzanna Urban <z.urban@accenture.com>
   * @created 10/07/2019
   * @description Method close the modal with tipologia di rendicontazione to modyfy
   * @task: NEXI-186
   */
	confirmChanges : function( component, event, helper )
    {
        let changesESM = component.find("selectedESMValue").get("v.value");
        let objectsESMPossible = component.get("v.selectedESM");
        let listOfallESM = component.get("v.listOfExternalSourceMapping");
        let action = component.get('c.getNewESMList');
        action.setParams({
            newReportTypeValue : changesESM,
            oldESMList : listOfallESM,
            changedESMlist : objectsESMPossible
        });
        action.setCallback(this,function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let valueReturns = response.getReturnValue();
                if (! $A.util.isEmpty(valueReturns) )
                {
                    component.set('v.listOfExternalSourceMapping',valueReturns);
                }
                else
                {
                    helper.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR"),$A.get("$Label.c.OB_TheSameRecordTypeError"),'error');
                }
           } else if (state === "ERROR") {
                var errors = response.getError();
                console.log('EditAccount.confirmChanges:Code000 : ' + errors);
                helper.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR"), errors, 'error');
            }
        });
        $A.enqueueAction(action);
		component.set("v.showMerchantModal",false);
	},

	/**
    * @author Marta Stempien <marta.stempien@accenture.com>
    * @date 19/07/2019
    * @task NEXI-231
    * @description Method calls method from child component : OB_SAEATECOContainer
    */
    callSettingRedBorderSaeAtecoContainer : function(component, event)
    {
        let saeAtecoContainer;
        if(component.get("v.isFromOperation"))
        {
            saeAtecoContainer = component.find("saeAtecoComponentFromOperational");
        }
        else
        {
            saeAtecoContainer = component.find("saeAtecoComponent");
        }
        saeAtecoContainer.setRedBorderOnSaeAteco(component.get("v.missingSae"), component.get("v.missingAteco"));
    },

    /*
    *   Author  :   Morittu Andrea
    *   Date    :   25-Jul-2019
    *   Task    :   EmployeesNumberInMainteannceANAGRAFICA
    *   Branch  :   (Untracked)NewLogicOnEmployeesNumberAnagrafica
    */
    removeRedBorder : function(component, event, helper) {
        var currentInput = event.getSource().get("v.name");

        switch(currentInput) {
            case 'EmployeesNumber':
                $A.util.removeClass( component.find('employeesNumber') , 'slds-has-error flow_required');
                component.set('v.objectDataMap.errorFamily.ErrorName', false);
                component.set('v.objectDataMap.errorFamilyMessage.ErrorMessageEmployees' , '');
        }
    }
})