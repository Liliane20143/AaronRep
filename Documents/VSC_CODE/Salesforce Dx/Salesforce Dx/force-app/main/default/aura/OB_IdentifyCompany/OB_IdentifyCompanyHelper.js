({
    setErrore: function (listaId, customLabel, errorId) {
        listaId.className = "slds-has-error flow_required";
        var myDiv = document.createElement('div');
        myDiv.setAttribute('id', errorId);
        myDiv.setAttribute('style', 'color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
        var errorCustomLabel = customLabel;
        var errorMessage = document.createTextNode(errorCustomLabel);
        myDiv.appendChild(errorMessage);
        listaId.after(myDiv);
    },

    getAnnualRevenue: function (component, helper, event) {
        var actionGetAnnualRevenueValues = component.get("c.getAnnualRevenueValues");
        var objectDataMap = component.get("v.objectDataMap");
        console.log("the vat not present into doInit is: " + objectDataMap.merchant.VAT_Not_Present__c);
        actionGetAnnualRevenueValues.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //CREATE NODES IN ATTRIBUTE TO ITERATION
                var tempMap = [];
                var responseMap = response.getReturnValue();
                for (var key in responseMap) {
                    tempMap.push({ value: responseMap[key], key: key });
                }
                component.set("v.annualRevenueList", tempMap);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                }
                else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(actionGetAnnualRevenueValues);
    },

    getAnnualnegotiated: function (component, helper, event) {
        var actionGetAnnualNegotiationValues = component.get("c.getAnnualNegotiationValues");
        actionGetAnnualNegotiationValues.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var tempMap = [];
                var responseMap = response.getReturnValue();
                for (var key in responseMap) {
                    tempMap.push({ value: responseMap[key], key: key });
                }
                console.log("temp map in annual negotiated: " + JSON.stringify(tempMap));
                component.set("v.annualNegotiatedList", tempMap);

            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                }
                else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(actionGetAnnualNegotiationValues);
    },

    getEmployeesNumber: function (component, helper, event) {
        var actionGetEmployeesNumber = component.get("c.getEmployeesNumber");
        actionGetEmployeesNumber.setCallback(this, function (response) {
            var state = response.getState();
            console.log(' employee state is: ' + state);
            if (state === "SUCCESS") {
                var tempMap = [];
                var responseMap = response.getReturnValue();
                for (var key in responseMap) {
                    tempMap.push({ value: responseMap[key], key: key });
                }
                component.set("v.employeesNumberList", tempMap);
                console.log('employees list is: ' + component.get("v.employeesNumberList"));
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                }
                else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(actionGetEmployeesNumber);
    },

    //creating modal for ABI search   
    createComponent: function (component, event) {

        $A.createComponent(
            "c:modalLookupWithPagination",
            {
                "aura:id": "modal",
                "objectString": component.get("v.objectString"),
                "type": component.get("v.type"),
                "subType": component.get("v.subType"),
                //merchant or bank????
                "input": component.get("v.objectDataMap.bank.OB_ABI__c"),
                "mapOfSourceFieldTargetField": component.get("v.mapOfSourceFieldTargetField"),
                "mapLabelColumns": component.get("v.mapLabelColumns"),
                "objectDataMap": component.get("v.objectDataMap"),
                "messageIsEmpty": component.get("v.messageIsEmpty"),
                "orderBy": component.get("v.orderBy"),
                "inputFieldForLike": "Name"
            },
            function (newModal, status, errorMessage) {
                if (status === "SUCCESS") {
                    var body = component.get("v.body");
                    body.push(newModal);
                    component.set("v.body", body);
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                }
                else if (status === "ERROR") {
                    console.log("Error: " + errorMessage);
                }
            }
        );
    },

    //creating modal for CAB search
    createComponent_2: function (component, event) {
        console.log("INTO HELPER METHOD OF MODAL 2");
        var subType = component.get("v.objectDataMap.bank.OB_ABI__c");
        console.log("subtype: " + JSON.stringify(subType));
        var subTypeField = '';
        subTypeField = 'NE__value1__c';
        component.set("v.subTypeField", subTypeField);
        $A.createComponent(
            "c:modalLookupWithPagination",
            {
                "aura:id": "modal",
                "objectString": component.get("v.objectString"),
                "type": component.get("v.type"),
                "subType": subType,
                "input": component.get("v.objectDataMap.user.OB_CAB__c"),
                "mapOfSourceFieldTargetField": component.get("v.mapOfSourceFieldTargetField"),
                "mapLabelColumns": component.get("v.mapLabelColumns"),
                "objectDataMap": component.get("v.objectDataMap"),
                "messageIsEmpty": component.get("v.messageIsEmpty"),
                "orderBy": component.get("v.orderBy"),
                "inputFieldForLike": component.get("v.inputFieldForLike"),
                "subTypeField": component.get("v.subTypeField")
            },
            function (newModal, status, errorMessage) {
                if (status === "SUCCESS") {
                    var body = component.get("v.body");
                    body.push(newModal);
                    component.set("v.body", body);
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                }
                else if (status === "ERROR") {
                    console.log("Error: " + errorMessage);
                }
            }
        );
    },

    setABI: function (component) {
        console.log("setABI");
        var ABIvalue = component.find('ABI').get("v.value");
        component.set("v.objectDataMap.bank.OB_ABI__c", ABIvalue);
        console.log("abi input: " + ABIvalue);
    },

    //Francesca: setting abi search attributes for modal lookup
    setModalAttributes: function (component, event) {
        var objectString = 'bank'; //oggetto target -- da definire
        var objectDataMap = component.get("v.objectDataMap");
        console.log("doinit objectDataMap: " + JSON.stringify(objectDataMap));

        var mappa =
        {
            "Name": $A.get("$Label.c.ABI"),
            "NE__Value1__c": $A.get("$Label.c.OB_Bank")
        };
        var orderBy = 'Name';
        console.log("mappa " + JSON.stringify(mappa));
        component.set("v.mapLabelColumns", mappa);
        var mapLabelColumns = component.get("v.mapLabelColumns");
        console.log("mapLabelColumns " + JSON.stringify(mapLabelColumns));
        var mappa2 = {};
        mappa2['OB_ABI__c'] = 'Name';
        component.set("v.mapOfSourceFieldTargetField", mappa2);
        console.log("mappa 2 : " + JSON.stringify(mappa2));
        var mapOfSourceFieldTargetField = component.get("v.mapOfSourceFieldTargetField");
        console.log("mapOfSourceFieldTargetField " + JSON.stringify(mapOfSourceFieldTargetField));
        var type = component.get("v.type");
        var subType = component.get("v.subType");
        type = 'ABI';
        subType = '';
        component.set("v.subType", subType);
        component.set("v.type", type);
        component.set("v.objectString", objectString);
        component.set("v.orderBy", orderBy);
        this.createComponent(component);
    },

    //Francesca: setting cab search attributes for modalLookupWithPagination.cmp
    setModalAttributesCAB: function (component) {
        var objectString = 'user'; //oggetto target -- da definire
        var objectDataMap = component.get("v.objectDataMap");
        var mappa = {
            "Name": $A.get("$Label.c.CAB"),
            "NE__Value2__c": $A.get("$Label.c.OB_Bank")
        };

        console.log("doinit objectDataMap: " + JSON.stringify(objectDataMap));
        console.log("mappa " + JSON.stringify(mappa));
        component.set("v.mapLabelColumns", mappa);
        var mapLabelColumns = component.get("v.mapLabelColumns");
        console.log("mapLabelColumns " + JSON.stringify(mapLabelColumns));
        var mappa2 = {};
        mappa2['OB_CAB__c'] = 'Name';
        mappa2['OB_ABI__c'] = 'NE__Value1__c';
        component.set("v.mapOfSourceFieldTargetField", mappa2);
        console.log("mappa 2 : " + JSON.stringify(mappa2));
        var mapOfSourceFieldTargetField = component.get("v.mapOfSourceFieldTargetField");
        console.log("mapOfSourceFieldTargetField " + JSON.stringify(mapOfSourceFieldTargetField));
        //SOSTITUIRE QUESTO VALORE SCHIANTATO CON IL VALORE DELL'INPUT ABI INSERITO MANUALMENTE
        component.set("v.type", 'CAB');
        component.set("v.objectString", objectString);
        component.set("v.orderBy", "Name");

        this.createComponent_2(component, event);
    },

    //Francesca: if abi and cab are selected, apex method gets the bankId.
    searchBankProfile: function (component) {
        // NEXI-277 Marta Stempien <marta.stempien@accenture.com> 28/08/2019 Deleted check for cab and all of the declarations of unused cab variables, Start
        var objectDataMap = component.get("v.objectDataMap");
        var correctABI = component.get("v.correctABI");
        console.log('correctABI ' + correctABI );
        if (correctABI) {
            console.log('bankprofile in search bank profilr: ' + JSON.stringify(objectDataMap.bankProfile));
            var abi = component.get("v.objectDataMap.bank.OB_ABI__c");
        // NEXI-277 Marta Stempien <marta.stempien@accenture.com> 28/08/2019 Deleted check for cab and all of the declarations of unused cab variables, Stop

            var action = component.get("c.getBankProfileByABI");
            action.setParams({ abi: abi });
            action.setCallback(this, function (response) {
                var state = response.getState();
                console.log('state searchBankProfile: ' + state);
                if (state === "SUCCESS") {
                    if (response.getReturnValue() != null) {
                        
                        //	micol.ferrari 26/10/2019 - PostProd - START
                        console.log('bp '+JSON.stringify(response.getReturnValue()));
                        //	micol.ferrari 26/10/2019 - PostProd - STOP
                        
                        component.set("v.bankId", response.getReturnValue()['bankOwner']); // NEXI-277 Marta Stempien <marta.stempien@accenture.com> 28/08/2019 Fix - upperCase to meet the returned values
                        console.log("bankId in helper : " + component.get("v.bankId"));
                    } else {
                        console.log("bankId not found!");
                    }
                    component.set("v.objectDataMap.bankOwner", component.get("v.bankId"));
                    component.set("v.objectDataMap.actualBank", response.getReturnValue()['actualBank']);//giovanni spinelli 28/10/2019 - fix next operational data
                    component.set("v.objectDataMap.GT", response.getReturnValue()['GT']);
                    console.log("response map from apex: " + response.getReturnValue());
                    component.set("v.objectDataMap.bankProfile.OB_Business_Model_POS__c", response.getReturnValue()['OB_Business_Model_POS__c']);
                    component.set("v.objectDataMap.bankProfile.OB_Business_Model_Acquiring__c", response.getReturnValue()['OB_Business_Model_Acquiring__c']);
                    component.set("v.objectDataMap.bankProfile.OB_Service_Type__c", response.getReturnValue()['OB_Service_Type__c']);
                    component.set("v.objectDataMap.bankProfile.OB_Apm_Circuit__c", response.getReturnValue()['OB_Apm_Circuit__c']);
                    component.set("v.objectDataMap.bankProfile.OB_Vas__c", response.getReturnValue()['OB_Vas__c']);
                    component.set("v.objectDataMap.bankProfile.OB_Circuit__c", response.getReturnValue()['OB_Circuit__c']);
                    component.set("v.objectDataMap.bankProfile.OB_Other_Acquirer__c", response.getReturnValue()['OB_Other_Acquirer__c']);
                    component.set("v.objectDataMap.bankProfile.OB_GT__c", response.getReturnValue()['GT']);
                    component.set("v.objectDataMap.bankProfile.OB_SettlementType__c", response.getReturnValue()['OB_SettlementType__c']);
                    //GIOVANNI SPINELLI 09/11/2018
                    component.set("v.objectDataMap.bankProfile.OB_AccountHolder__c", response.getReturnValue()['OB_AccountHolder__c']);
                    component.set("v.objectDataMap.bankProfile.OB_Applicant_RAC_Code_SIA__c", response.getReturnValue()['OB_Applicant_RAC_Code_SIA__c']);
                    //GIOVANNI SPINELLI 12/11/2018
                    component.set("v.objectDataMap.bankProfile.OB_Terminal_Id_Generator__c", response.getReturnValue()['OB_Terminal_Id_Generator__c']);
                    //GIOVANNI SPINELLI 07/01/2019
                    component.set("v.objectDataMap.bankProfile.OB_NeedBIO__c", response.getReturnValue()['OB_NeedBIO__c']);
                    //ANDREA MORITTU START 11/02/2019
                    component.set("v.objectDataMap.bankProfile.OB_NDG__c", response.getReturnValue()['OB_NDG__c']);
                    // if BP.NDG is true ..
                    if (component.get("v.objectDataMap.bankProfile.OB_NDG__c")) {
                        if (typeof (component.find("NDGOrderHeader")) != undefined && component.find("NDGOrderHeader") != null && component.find("NDFOrderHeader") != "") {
                            component.set("v.objectDataMap.OrderHeader.OB_NDG__c", component.find("NDGOrderHeader").get("v.value"));
                        }
                        else {
                            component.set("v.objectDataMap.OrderHeader.OB_NDG__c", null);
                        }
                    }
                    else {
                        component.set("v.objectDataMap.OrderHeader.OB_NDG__c", null);
                    }
                    console.log('v.objectDataMap.OrderHeader: ' + JSON.stringify(component.get("v.objectDataMap.OrderHeader")));
                    //ANDREA MORITTU END 11/02/2019
                    component.set("v.objectDataMap.bankProfile.OB_Terminal_Id_Gateway__c"  , response.getReturnValue()['OB_Terminal_Id_Gateway__c']);	//davide.franzini - F2WAVE2-4 - 17/07/2019
                    console.log('v.objectDataMap.bankProfile: ' + JSON.stringify(component.get("v.objectDataMap.bankProfile")));
                    console.log('v.objectDataMap.Configuration: ' + JSON.stringify(component.get("v.objectDataMap.Configuration")));
                }
                else if (state === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message searchBankProfile: " + errors[0].message);
                        }
                    }
                    else {
                        console.log("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },

    //checkABI added by Francesca
    checkABI: function (component, event, value) {
        console.log("checkABI");
        console.log("value input ABI: " + value);
        if(value!= undefined ){
            var action = component.get("c.searchABIbyInputValue");
            action.setParams({ value: value });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    if (response.getReturnValue() != null) {
                        console.log("ABI: correct!");
                        component.set("v.correctABI", true);//SHOW GREEN CHECK
                        component.set("v.objectDataMap.bank.OB_ABI__c", response.getReturnValue());
                        //component.set("v.objectDataMap.user.OB_CAB__c", ''); //davide.franzini - 29/07/2019 - WN-212
                        component.set("v.disabledABI", true);
                        //REMOVE ERROR MESSAGE AND RED BORDER
                        console.log("ABI AFTER CHECK--> " + value);
                        if (value != '' && value != null) {
                            if (document.getElementById('errorIdABI')) {
                                console.log("INTO CHECK ABI METHOD");
                                var errorMessage = document.getElementsByClassName('messageErrorABI').length;
                                try {
                                    $A.util.removeClass(component.find('ABI'), 'slds-has-error flow_required');
                                    //REMOVE ERROR MESSAGE MORE THAN ONCE BECAUSE THERE ARE 9 MESSAGE  OVERLAPPING
                                    for (var i = 0; i < errorMessage; i++) {
                                        document.getElementById('errorIdABI').remove();
                                    }
                                    console.log("success delete");
                                }
                                catch (err) {
                                    console.log('ABI err.message: ' + err.message);
                                }
                            }
                        }
                    }
                    else {
                        console.log("wrong ABI!");
                    }
                }
                else if (state === "INCOMPLETE") {
                    // do something
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                        }
                    }
                    else {
                        console.log("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },

    //checkCAB added by Francesca
    checkCAB: function (component, event, value) {
        console.log("checkCAB");
        console.log("value input CAB: " + value);
        var action = component.get("c.searchCABbyInputValue");
        action.setParams(
            {
                value: value,
                abi: component.get("v.objectDataMap.bank.OB_ABI__c")
            });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if (response.getReturnValue().length > 0) {
                    console.log("CAB: correct!");
                    component.set("v.correctCAB", true);   //set the green check if cab is correct
                    component.set("v.disabledCAB", true);//disable cab input if it is correct
                    for (var i = 0; i < response.getReturnValue().length; i++) {
                        component.set("v.objectDataMap.user.OB_CAB__c", response.getReturnValue()[i].Name);
                        component.set("v.objectDataMap.bank.OB_ABI__c", response.getReturnValue()[i].NE__Value1__c);
                        console.log("cab in check cab: " + component.get("v.objectDataMap.user.OB_CAB__c"));
                        component.set("v.correctABI", true);
                        component.set("v.disabledABI", true);//disable abi input if cab  is correct
                        if (value != '' && value != null) {

                            if (document.getElementById('errorIdCAB')) {
                                var errorMessage = document.getElementsByClassName('messageErrorCAB').length;
                                try {
                                    $A.util.removeClass(component.find('CAB'), 'slds-has-error flow_required');
                                    //REMOVE ERROR MESSAGE MORE THAN ONCE BECAUSE THERE ARE 9 MESSAGE  OVERLAPPING
                                    for (var i = 0; i < errorMessage; i++) {
                                        document.getElementById('errorIdCAB').remove();
                                    }
                                    console.log("success delete");
                                }
                                catch (err) {
                                    console.log('CAB err.message: ' + err.message);
                                }
                            }
                        }
                    }
                }
                else {
                    console.log("wrong CAB!");
                }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                }
                else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    removeRedBorder: function (component, event, helper) {
        try {
            //GET THE CURRENT ID FROM INPUT 
            var currentId = event.target.id;
            console.log("current id in remove red border is: " + currentId);
        }
        catch (err) {
            console.log('err.message: ' + err.message);
        }
        //RECREATE THE SAME ID OF ERROR MESSAGE
        var errorId = 'errorId' + currentId;
        //REMOVE RED BORDER
        //REMOVE ERROR MESSAGE
        if (document.getElementById(errorId) != null) {
            console.log("errorID . " + errorId);
            document.getElementById(errorId).remove();
        }
    },

    removeBorderFromVatAndFiscalCode: function (component, event, helper) {
        //*********************************************REMOVE RED BORDER AND MESSAGE OF FISCAL CODE AND VAT-START*********************************************//
        $A.util.removeClass(component.find('fiscalCode'), 'slds-has-error flow_required');
        $A.util.removeClass(component.find('vat'), 'slds-has-error flow_required');
        if (document.getElementById('errorIdfiscalCode') || document.getElementById('errorIdvat')) {
            console.log("into remove border after click");
            var errorMessage = document.getElementsByClassName('messageErrorfiscalCode').length;
            var errorMessage2 = document.getElementsByClassName('messageErrorvat').length;
            console.log("length of error message vat: " + errorMessage2);
            console.log("length of error message fiscal code: " + errorMessage);
            try {
                //REMOVE ERROR MESSAGE MORE THAN ONCE BECAUSE THERE ARE 9 MESSAGE  OVERLAPPING
                //remove fiscal code message
                for (var i = 0; i < errorMessage; i++) {
                    document.getElementById('errorIdfiscalCode').remove();
                }
                //remove vat message
                for (var k = 0; k < errorMessage2; k++) {
                    document.getElementById('errorIdvat').remove();
                }
                console.log("success delete");
            }
            catch (err) {
                console.log('handleClick err.message: ' + err.message);
            }
        }
        //*********************************************REMOVE RED BORDER AND MESSAGE OF FISCAL CODE AND VAT-END*********************************************//
    },

    removeBorderPicklist: function (component, event, helper) {
        //*********************************************REMOVE RED BORDER AND MESSAGE FROM ANNUAL REVENUE AND EMPLOYEES NUMBER-START*********************************************//
        var annualRevenue = component.find("annualRevenue");
        var annualNegotiated = component.find("annualNegotiated");
        var employeesNumber = component.find("employeesNumber");
        //MAP OF PICKLIST IN PAGE: KEYS ARE THE ID NAME AND VALUE THE COMPONENT
        var mapPicklist = { "employeesNumber": employeesNumber };
        for (var keys in mapPicklist) {
            console.log("PICKLIST values: " + JSON.stringify(mapPicklist[keys]) + "keys: " + keys);
            //ITERATION ON THE VALUE OF EACH COMPONENT
            //IF THE VALUE ISN'T NULL, REMOVE THE RED BORDER
            if (mapPicklist[keys].get("v.value") != '') {
                console.log("PICKLIST VALUE IS: " + mapPicklist[keys].get("v.value"));
                $A.util.removeClass(mapPicklist[keys], 'slds-has-error flow_required');
                //IF THERE IS AN ERROR MESSAGE, REMOVE IT
                if (document.getElementById('errorId' + keys)) {
                    console.log("REMOVE MESSAGE METHOD: " + document.getElementById('errorId' + keys));
                    try {
                        document.getElementById('errorId' + keys).remove();
                    }
                    catch (err) {
                        console.log('remove borderd from picklist err.message: ' + err.message);
                    }
                }
            }
        }
        //*********************************************REMOVE RED BORDER AND MESSAGE FROM ANNUAL REVENUE AND EMPLOYEES NUMBER-END*********************************************//
    },

    getMerchantFromSFDC: function (component) {
        console.log("merchant saved from MIP 2: " + JSON.stringify(component.get("v.responseMerchant")));
        var bankId = component.get("v.objectDataMap.bankOwner"); //davide.franzini - 29/07/2019 - WN-212
        var objectDataMap = component.get("v.objectDataMap");
        var FC = component.find('fiscalCode').get("v.value");
        var VAT = component.find('vat').get("v.value");
        var merchantFromMip = component.get("v.responseMerchant");
        //MANAGE IF SERCH WITH VAT AND MIP RETURN A MERCHANT

        (merchantFromMip.vatCode && !FC) ? VAT = merchantFromMip.vatCode : VAT = VAT;
        merchantFromMip.fiscalCode ? FC = merchantFromMip.fiscalCode : FC = FC;

        console.log("FISCALCODE: " + FC + " BANKID: " + bankId + " VAT: " + VAT);
        var aaction = component.get("c.listAcc");
        aaction.setParams({ fiscalCode: FC, vatId: VAT, bankId: bankId });
        aaction.setCallback(this, function (response) {
            var state = response.getState();
            console.log("the state of get merchant from slds is: " + state);
            console.log("RESPONSE merchant SFDC: " + JSON.stringify(response.getReturnValue()));
            if (state === "SUCCESS") {
                console.log("RESPONSE merchant SFDC" + JSON.stringify(response.getReturnValue()));
                var merchantFromSFDC = response.getReturnValue()[0];
                component.set("v.merchantFromSFDC", merchantFromSFDC);
                console.log("ID MERCHANT FROM SFDC : " + merchantFromSFDC.Id + '**MERCHANT** ' + JSON.stringify(merchantFromSFDC));
                //IN SLDS THERE ISN'T ANY MERCHANT WITH THE FC OR VAT
                if (merchantFromSFDC.Id == null || merchantFromSFDC.Id == undefined) {
                    component.set("v.disableName", false);
                    component.set("v.hideVat", false);

                    /* Doris D.   08/03/2019 ------------- Start*/
                    if (FC && FC.length == 11 || VAT) {
                        //BUTTON TO COPY THE VAT VALUE IN FISCAL CODE IS ATTIVED
                        component.set("v.setMerchantFC", false);
                    }
                    else
                        component.set("v.setMerchantFC", true);
                    /* Doris D.   08/03/2019 ------------- End*/

                    component.set('v.showShopSignInput', true);
                    /*
                        SET TRUE THE BOOLEAN FOR NEW MERCHANT AND FALSE BOOLEANS FOR NEW AND OLD SP
                        TO MANAGE THE READ ONLY FIELDS IN PREVIOS SCENARIO
                    */
                    component.set("v.objectDataMap.isNewMerchant", true);

                    /*------------ Doris D. --- 25/02/2019 ------------------------- Start*/
                    component.set("v.objectDataMap.isNewPV", true);
                    component.set("v.objectDataMap.unbind.isNewPV", 'true');

                    /*------------ Doris D. --- 25/02/2019 ------------------------- end*/

                    component.set("v.objectDataMap.isOldMerchantNewSp", false);
                    component.set("v.objectDataMap.isOldMerchantOldSp", false);
                    component.set("v.objectDataMap.pv.OB_MCC_Description__c", "ALL");
                    component.set("v.objectDataMap.pv.OB_MCC__c", "0001");
                    this.setMerchantList(component, event);
                }
                //IN SLDS THERE IS A MERCHANT WITH THE FC OR VAT
                else if (merchantFromSFDC.Id != '') {
                    component.set("v.objectDataMap.isNewMerchant", false);

                    /*------------ Doris D. --- 25/02/2019 ------------------------- Start*/
                    component.set("v.objectDataMap.isNewPV", false);
                    /*------------ Doris D. --- 25/02/2019 ------------------------- end*/

                    //COMPILE THE INPUT WITH THE VALUE FROM SLDS AND SET TO OBJECT DATA MAP
                    //ONLY IF THE MERCHANT IS ONLY ON SFDC

                    component.set("v.disableName", true);
                    component.set("v.hideVat", true);
                    //e.p. 
                    component.set("v.objectDataMap.pv.OB_MCC_Description__c", 'ALL');
                    component.set("v.objectDataMap.pv.OB_MCC__c", '0001');
                    console.log("merchant from sFdC after setting: " + JSON.stringify(objectDataMap.merchant));
                    this.setMerchantList(component, event);
                }
                console.log('is new merchant?: ' + component.get('v.objectDataMap.isNewMerchant')
                    + '** is new service point?: ' + component.get('v.objectDataMap.isOldMerchantNewSp')
                    + '** is old service point?: ' + component.get('v.objectDataMap.isOldMerchantOldSp'));
                /*
                START ANDREA MORITTU F2WAVE2_68_MissingServiePointLogicForNewMerchant
                */
                var offerAssetId = objectDataMap.offerAsset.Id;
                if(component.get('v.objectDataMap.isNewMerchant')) {
                    if(!$A.util.isUndefinedOrNull(offerAssetId)) { 
                        var oldWrapperInformation = component.get("v.oldWrapperInformation");
                        console.log('oldWrapperInformation is : '  + oldWrapperInformation);
                        var oldSPtypology = !$A.util.isEmpty(oldWrapperInformation.formalCheckOnServicePointType) ? oldWrapperInformation.formalCheckOnServicePointType : null;
                        if(!$A.util.isUndefinedOrNull(oldSPtypology)){
                            component.set('v.oldInformationSPtype' , oldSPtypology);
                        }
                   }
               }
               /*
               END ANDREA MORITTU F2WAVE2_68_MissingServiePointLogicForNewMerchant
               */
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                }
                else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(aaction);
    },


    //****METHOD TO OPEN THE MERCHANT MODAL AND PASS THE LIST****//
    //**** SEPTEMBER 06 2018#####THE MODAL IS DELETED--->WE USE THE FIRST MERCHANT FROM ARRAY****//
    /*****IF SOMETHING DOESN'T WORK, DELETE THE TRY CATCH IN OB_ContinuationProxyCompenentControlleer*****/
    setMerchantList: function (component, event, helper) {
        var isTimeOut = component.get('v.isTimeOut');
        var objectDataMap = component.get("v.objectDataMap"),
            merchantFromMip = component.get("v.responseMerchant"),
            merchantFromSFDC = component.get("v.merchantFromSFDC"),
            resultFromPromise = component.get('v.resultFromPromise');
        console.log('MERCHANT REJECTED: ' + JSON.stringify(objectDataMap.merchant));
        console.log('RESULT FROM PROMISE: ' + component.get('v.resultFromPromise'));

        console.log("MERCHANT FROM MIP: " + JSON.stringify(merchantFromMip));
        console.log("MERCHANT FROM SALESFORCE: " + JSON.stringify(merchantFromSFDC));
        component.set("v.searchMerchantButton", true);
        component.set("v.showMerchantData", true);
        component.find('vatInput').set('v.checked', false);
    
        if(merchantFromSFDC.Id && merchantFromMip.result==0) {
            objectDataMap.showButtons = true;

            //EP INIZIO FIX 27/12/2018
            objectDataMap.merchant = merchantFromSFDC;
            //bleach INPUT  IN THE FIRST STEP
            objectDataMap.merchant.NE__E_mail__c = '';
            objectDataMap.merchant.Phone = '';
            objectDataMap.merchant.OB_Employees_Number__c = '';
            objectDataMap.merchant.OB_Annual_Negotiated__c = '';
            objectDataMap.merchant.OB_Annual_Revenue__c = '';
            if (objectDataMap.merchant.OB_VAT_Not_Present__c != true) {
                objectDataMap.merchant.OB_DescriptionVATNotPresent__c = '';
            } else if (objectDataMap.merchant.OB_VAT_Not_Present__c == true) {
                component.set("v.showModal", true);
                component.set("v.disableDescriptionVat", true);
                objectDataMap.unbind.VAT_notPresent = 'true';
            }
            console.log('MERCHANT SET: ' + JSON.stringify(objectDataMap.merchant));
            // EP FINE FIX 28/12/2018

            component.set("v.hideFiscalCode", true);
            component.set("v.disableName", true);
            component.set("v.disabledVat", true);


            /* Doris D.   08/03/2019 ------------- Start*/
            //BUTTON TO COPY THE VAT VALUE IN FISCAL CODE IS ATTIVED
            component.set("v.setMerchantFC", true);
            /* Doris D.   08/03/2019 ------------- End*/

            // component.set( "v.toggleSpinner"        , false); //stop spinner
            component.set("v.showButtons", objectDataMap.showButtons);
            //GET ANNUAL REVENUE ID TO PASS IN SERVICE POINT COMPONENT
            var annualRevenueId = component.find("annualRevenue");
            component.set("v.idAnnualRevenure", annualRevenueId);

            console.log('booleanForNewMerchant after service: ' + component.get("v.booleanForNewMerchant"));
            component.set("v.objectDataMap", objectDataMap);
            this.getOrderHeader(component);
        }
        //giovanni spinelli - 14/02/2019 - add OR condition --> if MIP result is 2(error) but there is merchant in sfdc --> use merchant from sfdc
        else if ((merchantFromSFDC.Id && merchantFromMip.result == 1) || (merchantFromSFDC.Id && resultFromPromise == null) || (merchantFromSFDC.Id && resultFromPromise == 'Error')
            || (merchantFromSFDC.Id && isTimeOut == true) || (merchantFromSFDC.Id && merchantFromMip.result == 2)) {
            console.log('is time out: ' + component.get('v.isTimeOut'));
            objectDataMap.merchant = merchantFromSFDC;
            //bleach INPUT  IN THE FIRST STEP
            objectDataMap.merchant.NE__E_mail__c = '';
            objectDataMap.merchant.Phone = '';
            objectDataMap.merchant.OB_Employees_Number__c = '';
            objectDataMap.merchant.OB_Annual_Negotiated__c = '';
            objectDataMap.merchant.OB_Annual_Revenue__c = '';
            if (objectDataMap.merchant.OB_VAT_Not_Present__c != true) {
                objectDataMap.merchant.OB_DescriptionVATNotPresent__c = '';
            }
            else if (objectDataMap.merchant.OB_VAT_Not_Present__c == true) {
                component.set("v.showModal", true);
                component.set("v.disableDescriptionVat", true);
                objectDataMap.unbind.VAT_notPresent = 'true';
            }
            console.log('MERCHANT SETTED: ' + JSON.stringify(objectDataMap.merchant));

            objectDataMap.showButtons = true;
            component.set("v.hideFiscalCode", true);
            component.set("v.disableName", true);
            component.set("v.disabledVat", true);

            component.set("v.showButtons", objectDataMap.showButtons);
            //GET ANNUAL REVENUE ID TO PASS IN SERVICE POINT COMPONENT
            var annualRevenueId = component.find("annualRevenue");
            component.set("v.idAnnualRevenure", annualRevenueId);

            console.log('booleanForNewMerchant after service: ' + component.get("v.booleanForNewMerchant"));
            //17/12/2018 - SAVE EXTERNAL SOURCE IF THE MERCHANT IS IN SFDC
            this.getExternalSourceSFDC(component)
            component.set("v.objectDataMap", objectDataMap);
        }
        else {
            component.set("v.setUppercCaseMethod", false);//set the boolean to make disable the method into uppercasemethod
            component.set("v.disabledVat", false);
            component.set("v.showMerchantData", true);  //show input name, phone , email...
            //IF I HAVEN'T AN ID BUT I HAVE A MERCHANT FROM MIP
            if (merchantFromMip.result == 0 && objectDataMap.merchant.Id == '') {
                /* Doris D.   08/03/2019 ------------- Start*/
                //BUTTON TO COPY THE VAT VALUE IN FISCAL CODE IS DESATTIVED
                component.set("v.setMerchantFC", false);
                /* Doris D.   08/03/2019 ------------- End*/

                //alert('MERCHANT FROM MIP RESULT 0 AND NOT FROM SFDC');
                var legalFormMap = {};
                legalFormMap = component.get('v.legalFormMap');
                console.log('map attribute: ' + JSON.stringify(legalFormMap));
                objectDataMap.merchant.Name = merchantFromMip.name;
                objectDataMap.merchant.NE__VAT__c = merchantFromMip.vatCode;
                objectDataMap.merchant.NE__Fiscal_code__c = merchantFromMip.fiscalCode;
                objectDataMap.merchant.OB_Legal_Form_Code__c = merchantFromMip.legalForm;
                objectDataMap.merchant.OB_Legal_Form__c = legalFormMap[objectDataMap.merchant.OB_Legal_Form_Code__c];
                console.log('OB_Legal_Form__c: ' + objectDataMap.merchant.OB_Legal_Form__c);

                if (emailControl(merchantFromMip.PEC) != 'ERROR' && (merchantFromMip.PEC).length > 0) {//<-- giovanni spinelli 29/04/2019 change AND condition because name variable wasn't correct
                    objectDataMap.sede_legale.OB_PEC__c = merchantFromMip.PEC
                }
                else {
                    objectDataMap.sede_legale.OB_PEC__c = '';
                }
                console.log('PEC:  ' + objectDataMap.sede_legale.OB_PEC__c);

                objectDataMap.merchant.OB_Year_constitution_company__c = merchantFromMip.yearConstitutionCompany;
                objectDataMap.merchant.OB_CCIAA__c = merchantFromMip.companyRegistrationNumber;
                objectDataMap.merchant.OB_CCIAA_Province__c = merchantFromMip.provinceChamberOfCommerce;
                objectDataMap.merchant.OB_SAE_Code__c = merchantFromMip.commoditySectorCodeSAE;
                objectDataMap.merchant.OB_ATECO__c = merchantFromMip.atecoCode;

                this.merchantMapping(component, objectDataMap, merchantFromMip);
                console.log('MERCHANT SETTED: ' + JSON.stringify(objectDataMap.merchant));

                console.log('MERCHANT MAPPING: ' + JSON.stringify(objectDataMap.merchant));
                component.set("v.objectDataMap", objectDataMap);
                component.set("v.disableName", true);
                objectDataMap.showButtons = true;
                component.set("v.showButtons", objectDataMap.showButtons);
                this.getCODSOCFromMip(component);
            }
            else if (merchantFromMip.result == 2) {
                objectDataMap.showOtherInput = true;
                component.set("v.disableName", false);
                component.set("v.showOtherInput", objectDataMap.showOtherInput);  //show service point input
            }
            //IF I HAVEN'T AN ID AND I HAVEN'T A MERCHANT FROM MIP
            else {
                objectDataMap.showOtherInput = true;
                component.set("v.objectDataMap.showOtherInput", objectDataMap.showOtherInput);
                component.set("v.showOtherInput", objectDataMap.showOtherInput);  //show service point input
            }

            component.set("v.booleanForNewMerchant", true);//TO  UNDERSTAND THAT I HAVE A NEW MERCHANT
            component.set("v.objectDataMap", objectDataMap);
            component.set("v.hideFiscalCode", false);
            var fiscalCodeInput = component.find("fiscalCode").get("v.value");
            var vatInput = component.find("vat").get("v.value");

            fiscalCodeInput.length > 0 ? component.set("v.hideFiscalCode", true) : component.set("v.hideVat", true); //disable or able fiscal code if there is the fiscal code value

            if (vatInput.length > 0) {
                component.set("v.hideVat", true); //disable vat because there is the value
                component.set("v.disabledVat", true); //make disabled the vat not present checkbox
            }
            else {
                component.set("v.hideVat", false); //able vat because there isn't the value
                component.set("v.disabledVat", false); //make abled the vat not present checkbox
            }
        }
        //*********************************************REMOVE RED BORDER AND MESSAGE OF FISCAL CODE AND VAT-START*********************************************//
        this.removeBorderFromVatAndFiscalCode(component, event, helper);
        //*********************************************REMOVE RED BORDER AND MESSAGE OF FISCAL CODE AND VAT-END*********************************************//
        component.set("v.toggleSpinner", false); //stop spinner
    },

    //**ENRICO PURIFICATO-GIOVANNI SPINELLI - 11/10/2018- CALL THE MIP SERVICET   **//
    //USE THE PROMISE METHOD TO CHAIN FIRST THE SERVICE CALL AND AFTER THE SFDC CALL//
    retrieveMerchantPromise: function (component, event) {
        return new Promise($A.getCallback(function (resolve, reject) {
            var responseMerchant = component.get("v.responseMerchant");
            var objectDataMap = component.get("v.objectDataMap");
            var FCode = component.find('fiscalCode').get("v.value");
            var VATcode = component.find('vat').get("v.value");
            var merchantNull = component.get('v.merchantNull');
            console.log('@@@FC ' + FCode);
            console.log('@@@VAT ' + VATcode);
            var action = component.get("c.getretrieveMerchant");
            action.setParams({
                fiscalCode: FCode,
                vatCode: VATcode
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                console.log("the state is 2method : " + state);
                if (state === "SUCCESS") {
                    console.log("SUCCESS getretrieveMerchant");
                    var result = response.getReturnValue();
                    console.log("***Res getretrieveMerchant 2method: " + result);
                    //start antonio.vatrano manage getMerchant 06/06/2019
                    if(result.includes('<html>')){  
                        var e = document.createElement('div');
                        e.innerHTML = result;
                        var lastElementChild = e.lastElementChild.textContent;
                        if (lastElementChild == "500 Internal Server Error") {
                            console.log('Service Unaviable');
                            component.set('v.resultFromPromise', result);
                            component.set("v.merchantNull", true);
                            component.set("v.toggleSpinner", false);
                            component.set('v.showModalErrorParsing', true);
                        }
                    }
                    //End antonio.vatrano manage getMerchant 06/06/2019
                    else if (result == 'Error') {
                        console.log("merchant error: " + result);
                        component.set('v.resultFromPromise', result);
                        console.log('result promise: ' + component.get('v.resultFromPromise'));
                        reject(component);
                        component.set("v.toggleSpinner", false); //stop spinner
                        component.set("v.merchantNull", true);
                    }
                    //MIP RETURN null RESPONSE
                    else if (result == null) {
                        console.log("merchant null 2method: " + result);
                        component.set('v.resultFromPromise', result);
                        console.log('result promise: ' + component.get('v.resultFromPromise'));
                        reject(component);

                        component.set("v.toggleSpinner", false); //stop spinner
                        component.set("v.merchantNull", true);
                    }
                    //SUCCESS
                    else {
                        //use the method 'convertChart' only if there is a response
                        try {
                            //FUNCTION TO DECODE THE VALUE HTML
                            function htmlDecode(input) {
                                var e = document.createElement('div');
                                e.innerHTML = input;
                                // handle case of empty input
                                return e.childNodes.length === 0 ? "" : e.childNodes[0].nodeValue;
                            }
                            console.log('htmlDecode 2method: ' + htmlDecode(result));
                            var resultHtmlDecode = htmlDecode(result);
                            console.log("merchant converted from service----> " + JSON.stringify(JSON.parse(resultHtmlDecode)));
                            resultConverted = JSON.parse(resultHtmlDecode);
                            component.set("v.responseMerchant", resultConverted);
                            console.log("****responseMerchant 2method: " + component.get("v.responseMerchant"));
                            console.log('@@ FC 2 ' + FCode);
                            resolve(component);
                            reject(null);
                        }
                        catch (err) {
                            console.log('in parsing error');
                            console.log('*****error message: ' + err.message);
                            component.set('v.showModalErrorParsing', true);
                        }
                    }

                }
            });
            console.log("***action 2method: " + action);
            $A.enqueueAction(action);
            /***************************** END AV  17-12-18***************************************************change call service from continuation*/
        }));
    },


    //**GIOVANNI SPINELLI - 11/10/2018- METHOD TO KNOW IF THERE IS AN ORDER HEADER LINKED WITH MERCHANT**//
    getOrderHeader: function (component) {
        var action = component.get("c.getOrderHeaderByAccountId");
        var objectDataMap = component.get("v.objectDataMap");
        var merchantFromSFDC = component.get("v.merchantFromSFDC");
        var merchantFromMip = component.get("v.responseMerchant");
        var merchantId = objectDataMap.merchant.Id;
        console.log("merchant saved from salesforce: " + JSON.stringify(component.get("v.merchantFromSFDC")));
        console.log("merchant saved from MIP: " + JSON.stringify(component.get("v.responseMerchant")));
        console.log('merchantId: ' + merchantFromSFDC.Id);
        objectDataMap.merchant.Id = merchantFromSFDC.Id;
        action.setParams({ merchantId: merchantFromSFDC.Id });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('ORDER HEADER RESPONSE: ' + response.getReturnValue());
                var responseOrder = response.getReturnValue();
                //IF THE MERCHANT HAS AT LEAsT AN ORDER PENDING
                if (responseOrder == true) {
                    //SET THE OBJECTDATAMAP WITH VALUE FROM SFDC-->ANAGRAFICA NON AGGIORNATA-->CASO STRADIVARIUS
                    objectDataMap.merchant = merchantFromSFDC;
                    //bleach INPUT  IN THE FIRST STEP
                    objectDataMap.merchant.NE__E_mail__c = '';
                    objectDataMap.merchant.Phone = '';
                    objectDataMap.merchant.OB_Employees_Number__c = '';
                    objectDataMap.merchant.OB_Annual_Negotiated__c = '';
                    if (objectDataMap.merchant.OB_VAT_Not_Present__c != true) {
                        objectDataMap.merchant.OB_DescriptionVATNotPresent__c = '';
                    }
                    else if (objectDataMap.merchant.OB_VAT_Not_Present__c == true) {
                        component.set("v.showModal", true);
                    }
                    objectDataMap.merchant.OB_Annual_Revenue__c = '';
                    //FIRE RULES IN STEP 'DATI SOCIETA'
                    //IF LEGAL FORM IS NO PROFIT
                    if (objectDataMap.merchant.OB_Legal_Form_Code__c == 'ORG_NO_PROFIT') {
                        objectDataMap.unbind.OB_Legal_Form__c = 'NOPROFIT';
                        console.log('input:unbind:OB_Legal_Form__c: ' + document.getElementById('input:unbind:OB_Legal_Form__c'));
                        if (objectDataMap.merchant.OB_No_Profit_Recipient_Class__c == 'Altro') {
                            objectDataMap.unbind.OB_No_Profit_Recipient_Class__c = 'Altro';
                        }
                    }
                    component.set("v.objectDataMap", objectDataMap);
                    console.log("objectdatamap after setting sfdc: " + JSON.stringify(objectDataMap.merchant));
                    console.log("LEGAL FORM OBJDATAMAP: " + JSON.stringify(objectDataMap.merchant.OB_Legal_Form__c));
                    console.log("objectDataMap.unbind.OB_Legal_Form__c: " + objectDataMap.unbind.OB_Legal_Form__c);
                    console.log("objectDataMap.unbind.OB_No_Profit_Recipient_Class__c " + objectDataMap.unbind.OB_No_Profit_Recipient_Class__c);
                    this.getCODSOCFromMip(component);
                }
                //IF THE MERCHANT HASN'T AN ORDER PENDING
                else if (responseOrder == false) {
                    //SET THE OBJECTDATAMAP WITH VALUE FROM MIP-->ANAGRAFICA AGGIORNATA-->CASO BERSHKA
                    var legalFormMap = {};
                    legalFormMap = component.get('v.legalFormMap');
                    console.log('map attribute: ' + JSON.stringify(legalFormMap));
                    objectDataMap.merchant.Name = merchantFromMip.name;
                    objectDataMap.merchant.NE__VAT__c = merchantFromMip.vatCode;
                    objectDataMap.merchant.NE__Fiscal_code__c = merchantFromMip.fiscalCode;
                    objectDataMap.merchant.OB_Legal_Form_Code__c = merchantFromMip.legalForm;
                    objectDataMap.merchant.OB_Legal_Form__c = legalFormMap[objectDataMap.merchant.OB_Legal_Form_Code__c];
                    console.log('OB_Legal_Form__c: ' + objectDataMap.merchant.OB_Legal_Form__c);
                    if (emailControl(merchantFromMip.PEC) != 'ERROR' && (mmerchantFromMip.PEC).length > 0) {
                        objectDataMap.sede_legale.OB_PEC__c = merchantFromMip.PEC
                    } else {
                        objectDataMap.sede_legale.OB_PEC__c = '';
                    }
                    console.log('PEC:  ' + objectDataMap.sede_legale.OB_PEC__c);
                    objectDataMap.merchant.OB_Year_constitution_company__c = merchantFromMip.yearConstitutionCompany;
                    objectDataMap.merchant.OB_CCIAA__c = merchantFromMip.companyRegistrationNumber;
                    objectDataMap.merchant.OB_CCIAA_Province__c = merchantFromMip.provinceChamberOfCommerce;
                    objectDataMap.merchant.OB_SAE_Code__c = merchantFromMip.commoditySectorCodeSAE;
                    objectDataMap.merchant.OB_ATECO__c = merchantFromMip.atecoCode;

                    this.merchantMapping(component, objectDataMap, merchantFromMip);
                    console.log('MERCHANT MAPPING:  ' + JSON.stringify(objectDataMap.merchant));

                    component.set("v.objectDataMap", objectDataMap);
                    this.getCODSOCFromMip(component);
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                }
                else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    //VALUATE IF THERE ARE CODSOC IN MIP
    getCODSOCFromMip: function (component) {
        var objectDataMap = component.get("v.objectDataMap"),
            merchantFromMip = component.get("v.responseMerchant"),
            POS = merchantFromMip.POS,
            merchantFromSFDC = component.get("v.merchantFromSFDC"),
            merchantId,
            Acquiring = merchantFromMip.Acquiring,
            action = component.get("c.getSourceSystem");

        merchantFromSFDC ? merchantId = merchantFromSFDC.Id : merchantId = '';

        console.log("ACQUIRING cod" + JSON.stringify(Acquiring) + " POS cod" + JSON.stringify(POS));
        console.log("MERCHANT get soc " + JSON.stringify(merchantFromSFDC));
        console.log("lunghezza acquiring " + Acquiring.length + " lunghezza pos " + POS.length);
        console.log("merchantId: " + merchantId);
        action.setParams({ merchantId: merchantId });
        action.setCallback(this, function (response) {
            var state = response.getState(),
                sfdcSourceSystemMap = {},
                mipSourceSystemMap = {},
                SourceSystemArray = [],
                totalArrayFromMip = [],
                acquiringSocIdArray = [],
                posclientIdArray = [],
                totalArrayFromMip = [];

            response = response.getReturnValue();

            console.log("RESPONSE FROM EXTERNAL MAP: " + JSON.stringify(response));

            var sfdcOnlyArray = {};
            var MIPOnlyArray = {};
            var MIPAndSfdcArray = {};
            if (state === "SUCCESS") {
                //SAVE EXTERNAL SOURCE IN A DIFFERENT OBJECT THAN EXTERNAL ACCOUT(USING  FOR UPDATE MERCHANT METHOD)
                component.set('v.objectDataMap.externalAccountBackup', response);
                console.log('EXTERNAL ACCOUNT BACKUP: ' + JSON.stringify(component.get('v.objectDataMap.externalAccountBackup')));
                // 17/10/2018 - GIOVANNI SPINELLI - ENRICO PURIFICATO
                sfdcSourceSystemMap = this.generateSfdcSourceMap(response);
                mipSourceSystemMap = this.generateMIPSourceMap(merchantFromMip);
                console.log("ARRAY FROM HELPER: " + JSON.stringify(sfdcSourceSystemMap) + ' /// ' + JSON.stringify(mipSourceSystemMap));
                //ITERATION IN SFDC
                for (var key in sfdcSourceSystemMap) {
                    console.log('key sfdc: ' + key);
                    console.log('value sfdc: ' + JSON.stringify(sfdcSourceSystemMap[key]));
                    console.log('mip contains keys: ' + mipSourceSystemMap.hasOwnProperty(key));
                    if (mipSourceSystemMap.hasOwnProperty(key)) {
                        for (var code in sfdcSourceSystemMap[key]) {
                            console.log('code sfdc: ' + code);
                            //IF THERE ARE SAME SOURCE IN MIP AND SFDC
                            if (mipSourceSystemMap[key].hasOwnProperty(code)) {
                                console.log('mip contains code: ' + mipSourceSystemMap[key].hasOwnProperty(code));
                                //oggetto contenuto sia in sfdc che nel mip
                                //to do....cosa fare con questo array
                                MIPAndSfdcArray[key] = sfdcSourceSystemMap[key][code];
                            }
                            else {
                                //solo in sfdc e non nel mip
                                console.log('code sfdc 3: ' + code);
                                sfdcOnlyArray[key] = sfdcSourceSystemMap[key][code];
                                console.log('sfdcOnlyArray in else: ' + JSON.stringify(sfdcOnlyArray));
                            }
                        }
                    }
                    else {
                        //CI SONO SOURCE IN SFDC E NON NEL MIP manca il sistema 
                        //CONTROL WHEN THERE ARE SOME CODES IN MIP AND NOT IN SFDC??
                        //HOW POPULATE THE MAP??
                        sfdcOnlyArray[key] = sfdcSourceSystemMap[key];
                        console.log('key sfdc 2: ' + key);
                        console.log('sfdcOnlyArray[key] ' + JSON.stringify(mipSourceSystemMap[key]));
                        console.log('sfdcOnlyArray in else 2: ' + JSON.stringify(sfdcOnlyArray));
                    }
                }
                //ITERATION IN MIP
                for (var key in mipSourceSystemMap) {
                    console.log('key MIP: ' + key);
                    console.log('SFDC contains keys: ' + sfdcSourceSystemMap.hasOwnProperty(key));
                    if (!(sfdcSourceSystemMap.hasOwnProperty(key))) {
                        MIPOnlyArray[key] = mipSourceSystemMap[key];
                    }
                    else {
                        for (var code in mipSourceSystemMap[key]) {
                            console.log('CODE IN FOR: ' + code)
                            console.log('SFDC contains keys in for: ' + sfdcSourceSystemMap[key].hasOwnProperty(code));
                            if (!(sfdcSourceSystemMap[key].hasOwnProperty(code))) {
                                if (MIPOnlyArray[key] == undefined) {
                                    MIPOnlyArray[key] = {};
                                }
                                MIPOnlyArray[key][code] = mipSourceSystemMap[key][code];
                            }
                        }
                    }
                }
                console.log('MIPAndSfdcArray: ' + JSON.stringify(MIPAndSfdcArray));
                console.log('sfdcOnlyArray: ' + JSON.stringify(sfdcOnlyArray));
                console.log('MIPOnlyArray: ' + JSON.stringify(MIPOnlyArray));
                console.log("keyset of array: " + Object.keys(MIPOnlyArray));

                this.updateMerchantCodes(component, merchantId, MIPAndSfdcArray, sfdcOnlyArray, MIPOnlyArray);

                //***************NEXT STEP***************//
                //CONTROL IF THE CODE IN SFDC IS ALSO IN MIP OR NOT
                //FIRST FOR ITERATES THE VALUE IN SFDC
                for (var keSourceSystemys in SourceSystemArray) {
                    console.log("first for SFDC array: " + SourceSystemArray[keSourceSystemys]);
                    var hasOneElement = false;
                    //SECOND FOR ITERATES THE VALUE IN MIP
                    for (var cod in totalArrayFromMip) {
                        console.log("second for MIP array: " + totalArrayFromMip[cod]);
                        //THE FOLLOW CONTROLS START ONLY IF THERE IS A VALUE IN THE ARRAY
                        if (totalArrayFromMip[cod] != '') {
                            console.log("second for MIP array in if: " + totalArrayFromMip[cod]);
                            if (SourceSystemArray[keSourceSystemys] == totalArrayFromMip[cod]) {
                                hasOneElement = true;
                            }
                            //CONTROL IF THE COD IN SFDC AND NOT IN MIP HAVE AN ORDER PENDING
                            else {
                                var codeSFDCnotInMip = SourceSystemArray[keSourceSystemys];
                                component.set("v.listCodeSFDCnotInMIP", codeSFDCnotInMip);

                                console.log('the codeSFDCnotInMip list: ' + component.get("v.listCodeSFDCnotInMIP"));
                            }
                        }
                    }
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                }
                else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    //ENRICO PURIFICATO - gIOVANNI SPINELLI - 16/10/2018
    getPendingOrderFromCode: function (component, merchantId, operator, codeObject) {
        console.log('codeObject to pass to apex method: ' + codeObject);
        var objectDataMap = component.get("v.objectDataMap");
        var action = component.get("c.getPendingOrderFromCode");
        var arrayCodAnothetFC;
        var merchantToBeVerify = [];
        var codeToBeDeleted = [];
        action.setParams({ merchantId: merchantId, operator: operator, codeObject: codeObject });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('the state in getPendingOrderFromCode: ' + state);

            if (state === "SUCCESS") {
                //alert('getPendingOrderFromCode');
                var response = response.getReturnValue();
                console.log('the response in getPendingOrderFromCode: ' + JSON.stringify(response));
                return response;
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                }
                else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    checkOtherMerchantByCod: function (component, codeWithePending) {
        console.log('CONTROL IF THE CODE IN MIP AND NOT IN SFDC ARE LINKED TO ANOTHER MERCHANT : ' + codeWithePending);
        var action = component.get("c.checkOtherMerchantByCod");
        var arrayCodAnothetFC = [];
        action.setParams({ code: codeWithePending, merchantId: merchantId });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('the state in checkOtherMerchantByCod: ' + state);
            var response = response.getReturnValue();

            console.log('the response in checkOtherMerchantByCod: ' + JSON.stringify(response));
            console.log('the response length: ' + response.length);

            if (state === "SUCCESS") {
                //ITERATION FOR THE LENGTH OF THE LIST RETURNED FROM APEX
                for (var i = 0; i < response.length; i++) {
                    console.log("response[i].OB_Merchant_ID__c : " + response[i].OB_Merchant_ID__c);
                    //IF THE LIST FROM APEX IS EMPTY, CONTROL IF THERE ARE ORDER PENDING WITH THE CODE IN SFDC ONLY
                    //****MODIFY THIS IF CONDITION !!!!!
                    if (response[i].OB_Merchant_ID__c == '' || response[i].OB_Merchant_ID__c == undefined) {
                        console.log('lista vuota');
                    }
                    //IF THE LIST FROM APEX IS EMPTY CONTROL IF THERE ARE ORDER PENDING WITH THE CODE IN MIP ONLY
                    else {
                        console.log('not empty list');
                    }
                    arrayCodAnothetFC.push(response[i]);
                    console.log('arrayCodAnothetFC: ' + JSON.stringify(arrayCodAnothetFC));
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                }
                else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    //CREATE A MAP {SOURCE : {CODE , ID}} FROM SFDC
    generateSfdcSourceMap: function (sfdcResult) {
        console.log('sfdcResult: ' + JSON.stringify(sfdcResult));
        //CREATE A MAP AND A COUNTER
        var tmp = {};
        var count = 0;
        if (!sfdcResult) {
            return tmp;
        }
        for (var i = 0; i < sfdcResult.length; i++) {
            var source = (sfdcResult[i].OB_Source__c).toUpperCase();

            if (typeof tmp[source] != 'object') {
                console.log('tmp[source]: ' + i);
                tmp[source] = {};
            }
            var element = {};
            element[sfdcResult[i].OB_CustomerCodeClientCode__c] = sfdcResult[i];
            tmp[source][sfdcResult[i].OB_CustomerCodeClientCode__c] = element;
            count++;
        }
        console.log('tmp : ' + JSON.stringify(tmp));
        return tmp;
    },

    //CREATE A MAP {SOURCE : {CODE , CODE}} FROM MIP
    generateMIPSourceMap: function (MIPResult) {
        console.log('MIPResult: ' + JSON.stringify(MIPResult));
        var tmp = {};
        var count = 0;
        var acquiring = MIPResult.Acquiring;

        console.log('acquiring: ' + JSON.stringify(acquiring));
        for (var i = 0; i < acquiring.length; i++) {
            var processor = (acquiring[i].processor).toUpperCase();

            if (typeof tmp[processor] != 'object') {
                tmp[processor] = {};
            }
            var element = {};
            var externalSourceLike = {}
            externalSourceLike.OB_CustomerCodeClientCode__c = acquiring[i].socId;
            externalSourceLike.OB_Source__c = processor;
            externalSourceLike.OB_Start_Date__c = acquiring[i].activityStartDate;
            externalSourceLike.OB_Pricing__c = acquiring[i].pricingType;
            externalSourceLike.OB_ReportType__c = acquiring[i].typeOfAccountStatement;
            element[acquiring[i].socId] = externalSourceLike;
            tmp[processor][acquiring[i].socId] = element;
            count++;
        }
        var pos = MIPResult.POS;
        console.log('pos: ' + JSON.stringify(pos));

        for (var i = 0; i < pos.length; i++) {
            var gt = (pos[i].gt).toUpperCase();
            gt == 'NEXI' ? gt = 'MONETICA' : gt = gt;

            if (typeof tmp[gt] != 'object') {
                tmp[gt] = {};
            }
            var element = {};
            var externalSourceLike = {};
            externalSourceLike.OB_CustomerCodeClientCode__c = pos[i].clientId;
            externalSourceLike.OB_Source__c = gt;
            element[pos[i].clientId] = externalSourceLike;
            tmp[gt][pos[i].clientId] = element;
            count++;
        }
        console.log('tmp mip : ' + JSON.stringify(tmp));
        return tmp;
    },

    updateMerchantCodes: function (component, merchantId, MIPAndSfdcArray, sfdcOnlyArray, MIPOnlyArray) {
        console.log('MIPAndSfdcArray:****' + JSON.stringify(MIPAndSfdcArray) + '****sfdcOnlyArray:****' + JSON.stringify(sfdcOnlyArray) + '****MIPOnlyArray:****' + JSON.stringify(MIPOnlyArray));
        console.log('MIPAndSfdcArray:****' + typeof MIPAndSfdcArray + '****sfdcOnlyArray:****' + typeof sfdcOnlyArray + '****MIPOnlyArray:****' + typeof MIPOnlyArray);
        var action = component.get("c.updateMerchantCodes");
        var objectDataMap = component.get("v.objectDataMap");
        console.log('PARAMS UPDATE MERCAHANT (MERCHANT ID) : ' + typeof merchantId);
        action.setParams({ merchantId: merchantId, MIPAndSfdcArray: MIPAndSfdcArray, sfdcOnlyArray: sfdcOnlyArray, MIPOnlyArray: MIPOnlyArray });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('the state in updateMerchantCodes: ' + state);
            var returnValue = response.getReturnValue();

            console.log('the response in updateMerchantCodes: ' + JSON.stringify(returnValue));

            if (state === "SUCCESS") {
                //oggetti da inserire nell'objdatamap
                var ExternalAccount = [];
                for (var i = 0; i < returnValue.length; i++) {
                    var el = {};
                    el.OB_CustomerCodeClientCode__c = returnValue[i].OB_CustomerCodeClientCode__c;
                    el.OB_Source__c = returnValue[i].OB_Source__c;
                    el.OB_Start_Date__c = returnValue[i].OB_Start_Date__c;
                    el.OB_Pricing__c = returnValue[i].OB_Pricing__c;
                    el.OB_ReportType__c = returnValue[i].OB_ReportType__c;

                    ExternalAccount.push(el);
                }
                objectDataMap.ExternalAccount = ExternalAccount;
                component.set("v.objectDataMap", objectDataMap);
                console.log('objectDataMap in updateMerchantCodes: ' + JSON.stringify(objectDataMap.ExternalAccount));
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                }
                else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    merchantMapping: function (component, objectDataMap, merchantFromMip) {
        //MAPPING REGISTERED OFFICE ADDRESS
        var countryMap = {};
        countryMap = component.get('v.countryMap');

        if (merchantFromMip.RegisteredOfficeAddress) {
            objectDataMap.merchant.OB_Legal_Address_Street__c = merchantFromMip.RegisteredOfficeAddress.street;
            objectDataMap.merchant.OB_Legal_Address_Street_Number__c = merchantFromMip.RegisteredOfficeAddress.civicNumber;
            objectDataMap.merchant.OB_Legal_Address_Detail__c = merchantFromMip.RegisteredOfficeAddress.careOf;
            objectDataMap.merchant.OB_Legal_Address_ZIP__c = merchantFromMip.RegisteredOfficeAddress.postalCode;
            objectDataMap.merchant.OB_Legal_Address_City__c = merchantFromMip.RegisteredOfficeAddress.city;
            objectDataMap.merchant.OB_Legal_Address_State__c = merchantFromMip.RegisteredOfficeAddress.province;
            objectDataMap.merchant.OB_Legal_Address_State_Code__c = merchantFromMip.RegisteredOfficeAddress.province;
            objectDataMap.merchant.OB_Legal_Address_Country_Code__c = merchantFromMip.RegisteredOfficeAddress.country;
            objectDataMap.merchant.OB_Legal_Address_Country__c = countryMap[objectDataMap.merchant.OB_Legal_Address_Country_Code__c];
        }
        //MAPPING INVOICING ADDRESS
        if (merchantFromMip.InvoicingAddres) {
            objectDataMap.merchant.BillingStreet = merchantFromMip.InvoicingAddres.street + ', ' + merchantFromMip.InvoicingAddres.civicNumber;
            objectDataMap.merchant.BillingPostalCode = merchantFromMip.InvoicingAddres.postalCode;
            objectDataMap.merchant.BillingCity = merchantFromMip.InvoicingAddres.city;
            objectDataMap.merchant.BillingState = merchantFromMip.InvoicingAddres.province;
            objectDataMap.merchant.BillingCountry = countryMap[merchantFromMip.InvoicingAddres.country];
        }
        //MAPPING ADMINISTRATIVE ADDRESS
        if (merchantFromMip.AdmistrativeAddress) {
            objectDataMap.merchant.OB_Administrative_Office_Street__c = merchantFromMip.AdmistrativeAddress.street;
            objectDataMap.merchant.OB_Administrative_Office_Street_number__c = merchantFromMip.AdmistrativeAddress.civicNumber;
            objectDataMap.merchant.OB_Administrative_Office_Address_Details__c = merchantFromMip.AdmistrativeAddress.careOf;
            objectDataMap.merchant.OB_Administrative_Office_ZIP__c = merchantFromMip.AdmistrativeAddress.postalCode;
            objectDataMap.merchant.OB_Administrative_Office_City__c = merchantFromMip.AdmistrativeAddress.city;
            objectDataMap.merchant.OB_Administrative_Office_State__c = merchantFromMip.AdmistrativeAddress.province;
            objectDataMap.merchant.OB_Administrative_Office_State_Code__c = merchantFromMip.AdmistrativeAddress.province;
            objectDataMap.merchant.OB_Administrative_Office_Country_Code__c = merchantFromMip.AdmistrativeAddress.country;
            objectDataMap.merchant.OB_Administrative_Office_Country__c = countryMap[objectDataMap.merchant.OB_Administrative_Office_Country_Code__c];
        }
        component.set("v.objectDataMap", objectDataMap);
    },

    //17/12/2018 - SAVE EXTERNAL SOURCE IF THE MERCHANT IS GET FROMSFDC
    getExternalSourceSFDC: function (component) {
        var actionGetExternalSource = component.get("c.getSourceSystem");
        var merchantId = component.get('v.objectDataMap.merchant.Id');
        actionGetExternalSource.setParams({ merchantId: merchantId });
        actionGetExternalSource.setCallback(this, function (response) {
            var state = response.getState();
            console.log('STATE IN GET EXTERNAL: ' + state);
            responseGetExt = response.getReturnValue();
            if (state === "SUCCESS") {
                component.set('v.objectDataMap.externalAccountBackup', responseGetExt);
                console.log('EXTERNAL MERCHANT FROM SFDC: ' + JSON.stringify(component.get('v.objectDataMap.externalAccountBackup')));
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                }
                else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(actionGetExternalSource);
    },

    checkvalidityNDGHelper: function (component, event, helper) {
        // NEED TO REMOVE THE LABEL FROM FLOW CONTROL UTILITY
        try {
            if (document.getElementById("errorIdNDGOrderHeader") != null) {
                document.getElementById("errorIdNDGOrderHeader").remove();
            }
        }
        catch (err) {
            console.log('NDG err.message: ' + err.message);
        }

        var myDiv;
        var errorMessage;

        var NDGOrderHeader = component.find('NDGOrderHeader');
        var regExp = new RegExp("^[A-Za-z0-9]{1,16}$");
        if (typeof (NDGOrderHeader) != undefined && NDGOrderHeader != null && NDGOrderHeader != '') {

            var NDGOrderHeaderValue = component.find('NDGOrderHeader').get("v.value");
            console.log('NDGOrderHeaderValue is: ' + NDGOrderHeaderValue);
            // console.log('NDGOrderHeaderValue.match(regExp) is: ' + NDGOrderHeaderValue.match(regExp));
            if (typeof (NDGOrderHeaderValue) != undefined && NDGOrderHeaderValue != null) {
                //NOT ERROR:
                if (regExp.test(NDGOrderHeaderValue) == true && NDGOrderHeaderValue.length >= 1 && NDGOrderHeaderValue.length < 16) {
                    $A.util.removeClass(component.find('NDGOrderHeader'), 'slds-has-error flow_required');
                    // $A.util.removeClass(component.find('NDGOrderHeader'), 'error-input-message');
                    component.set("v.NDGError", false);
                    console.log("Correct NDG");
                    //ERROR: 
                } else if (!regExp.test(NDGOrderHeaderValue) || NDGOrderHeaderValue.length > 0 || NDGOrderHeaderValue.length > 16) {
                    myDiv = document.createElement('div');
                    $A.util.addClass(component.find('NDGOrderHeader'), 'slds-has-error flow_required');
                    errorMessage = $A.get("$Label.c.errorSpecialCharacter");
                    console.log("error message: " + JSON.stringify(errorMessage));
                    myDiv.setAttribute('style', 'color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
                    myDiv.setAttribute('id', 'customErrorIdName');
                    component.set("v.NDGError", true);
                    console.log("error ndg");
                }
                // IF EMPTY, SHOW NOTHING
                if (NDGOrderHeaderValue.length == 0 || NDGOrderHeaderValue == '') {
                    $A.util.removeClass(component.find('NDGOrderHeader'), 'slds-has-error flow_required');
                    component.set("v.NDGError", false);
                    console.log("ndg is empty");
                }
            }
        }
    },

    //START gianluigi.virga 15/07/2019 - BACKLOG-153
    checkvalidityCheckInDate: function (component, event , helper){
        if(document.getElementById("errorIdorderCheckInDate") != null) {
            document.getElementById("errorIdorderCheckInDate").remove();
        }
        var date = component.get("v.objectDataMap.Configuration.OB_Check_in_date__c");
        var target = component.find("orderCheckInDate");
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        if(date == null || date == undefined || date == ''){
            $A.util.removeClass(target, "slds-has-error");
        }else{
            $A.util.removeClass(target, "slds-has-error");
        }
        console.log("checkInDateError: " + component.get("v.checkInDateError"));
    },
    //END gianluigi.virga BACKLOG-153

    /*
        ---------------------------------------------------------------------
        @Author:    Andrea.Morittu
        @Date:      2019.05.02
        @Task:      ID_Stream_6_Subentro
        ---------------------------------------------------------------------
    */
    checkMerchantOnTakeoverProcess : function(component, event, helper, objectDataMap) {
        console.log('my ObjDtmp is: ' + JSON.stringify(objectDataMap));
        console.log('objectDataMap.offerAsset is : ' , objectDataMap.offerAsset);
        var offerAssetId = objectDataMap.offerAsset.Id ;
        var action = component.get("c.formalCheckOnSameMerchant");
        action.setParams({ orderAssetId : offerAssetId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var merchantAssetWrapper = response.getReturnValue();
                console.log('merchant takeover :' , merchantAssetWrapper);
                component.set("v.oldWrapperInformation" , merchantAssetWrapper);

            }
            else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    /*
        ---------------------------------------------------------------------
        @Author:    Andrea.Morittu
        @Date:      2019.05.02
        @Task:      ID_Stream_6_Subentro
        ---------------------------------------------------------------------
    */
    formalCheckOnOldMerchant : function(component, event, helper, fiscalCode, VAT, oldObjectsInfo) {
        var oldObjectsInfoStringified = JSON.stringify(oldObjectsInfo)
        try {
            return new Promise($A.getCallback(function(resolve, reject) {
                var action = component.get("c.formalCheckOnOldData");
                action.setParams({  fiscalCode  : fiscalCode,
                                    VAT         : VAT,
                                    oldObjectsInfoStringified : oldObjectsInfoStringified     
                                });

                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var takeoverProcessError = response.getReturnValue();
                        console.log('takeoverProcessError is : ' , takeoverProcessError);
                        resolve(takeoverProcessError);
                    } else if (state === "ERROR") {
                            var errors = response.getError();
                            if (errors) {
                                if (errors[0] && errors[0].message) {
                                    reject(Error("Error message: " + errors[0].message));
                                }
                            }
                    } else {
                        reject(Error("Unknown error"));
                    }
                });
                $A.enqueueAction(action);
            }))
        }catch(exc) {
            console.log('exc.message is :' + exc.message);
        }
    },

    /*
    -----------------------------------------------------------

        @Author : Andrea . Morittu
        @Date   : 2019.05.02
        @Task   : ID_Stream_6_Subentro

    -----------------------------------------------------------
    */
    showToast: function (component, event, helper,title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title"     : title,
            "message"   : message,
            "type"      : type,
            "duration"  : 5000
        });
        toastEvent.fire();
    },
    /*
    -----------------------------------------------------------
        @Author : Andrea . Morittu
                    END
    -----------------------------------------------------------
    */

    /*
    -----------------------------------------------------------

        @Author : Andrea . Morittu
        @Date   : 2019.05.02
        @Task   : ID_Stream_6_Subentro
        @Description    : Dragged all old handleClick logic into this new function

    -----------------------------------------------------------
    */

    /* Doris D.   07/03/2019 ------------- Start*/
    executeHandleClick : function(component, event , helper) {
        component.set('v.isTimeOut' , false);//possibile errore
        if((component.find("fiscalCode").get("v.value")).length== 11 && (component.find("vat").get("v.value")).length==0)
        {
        //BUTTON TO COPY THE VAT VALUE IN FISCAL CODE IS ATTIVED
            component.set("v.setMerchantFC",false);

        }

        if((component.find("fiscalCode").get("v.value")).length == 0 && (component.find("vat").get("v.value")).length == 11)
        {
        //BUTTON TO COPY THE VAT VALUE IN FISCAL CODE IS ATTIVED
            component.set("v.setMerchantFC",false);

        }

        if((component.find("fiscalCode").get("v.value")).length == 16 && (component.find("vat").get("v.value")).length == 0)
        {
        //BUTTON TO COPY THE VAT VALUE IN FISCAL CODE IS DESATTIVED
            component.set("v.setMerchantFC",true);

        }
        //giovanni spinelli - 27/09/2019 - re set attribute from maintenance to false
		component.set('v.isFromMaintenance' , false);
        /* Doris D.   07/03/2019 ------------- End*/
        //Promise.reject(new Error('fail')).then(resolved, rejected);
        //resolved = right function
        //rejected = to manage 'null' response from MIP
        //GET A TIMEOUT TO MANAGE IF THERE ARE SOME GENERIC ERRORS
        var actionTimeOut = component.get("c.getTimeOut");
        actionTimeOut.setCallback(this, function(response) 
        {
            var state = response.getState();
            if (state === "SUCCESS")
            {
                var P = helper.retrieveMerchantPromise(component, event).then($A.getCallback(function(component){helper.getMerchantFromSFDC(component)} ),  $A.getCallback(function(component){helper.getMerchantFromSFDC(component)})
                                                                                    );// , helper.setMerchantList(component) $A.getCallback(function(component){helper.setMerchantList(component)})
                const resultNull =  '{}' //DA CAMBIARE QUANDO AVREMO IL SERVIZIO
                var responseMerchant = component.get("v.responseMerchant");
                component.set( "v.toggleSpinner"        , true); //start spinner
                //FIRST CALL THE SERVICE AND AFTER THE SALESFORCE QUERY
                //START
                //CLOSE THE BANNER MESSAGE AND RED BORDER AT SEARCH BUTTON**START
                component.set( "v.hasMessage", false);
                var btnsearch = component.find('btnSearch').getElement();
                btnsearch.setAttribute('style','');
                //CLOSE THE BANNER MESSAGE AND RED BORDER AT SEARCH BUTTON**END

                //IF THE SPINNER RUM FOR MORE THAN 30 SEC, IT SHOW AN ERROR MESSAGE
                setTimeout(function()
                {
                    if(component.get("v.toggleSpinner" )==true)
                    {
                        // component.set( "v.toggleSpinner"        , false); //start spinner
                        // component.set('v.showModalErrorParsing' , true);
                        console.log('component in timeout: ' + JSON.stringify(component));
                        component.set('v.isTimeOut' , true);
                        //helper.getMerchantFromSFDC(component);
                    }
                }, response.getReturnValue()*1000);
            }
            else if (state === "ERROR")
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
        $A.enqueueAction(actionTimeOut);
        component.set("v.ErrorBooleanFiscalCode " , false);
    },
    /*
    -----------------------------------------------------------
        @Author : Andrea . Morittu
                    END
    -----------------------------------------------------------
    */
    /**
     * @author Grzegorz Banach <grzegorz.banach@accenture.com>
     * @date 07/05/2019
     * @description The method sets attribute for opening Document Info Modal
     * @task: NEXI-30
    **/
    handleDocumentInfoEvent : function( component, event )
    {
        let cancelBtnClicked = event.getParam( "isCancelButtonClicked" );
        if ( $A.util.isUndefinedOrNull( cancelBtnClicked ) || typeof cancelBtnClicked != 'boolean' )
        {
           return;
        }

        component.set( "v.isDocumentInfoModalVisible", false );
        if ( cancelBtnClicked )
        {
            return;
        }
        component.set( "v.disableName", false );
        component.set("v.objectDataMap.unbind.isCompanyDataModified", true);//NEXI-32 Customer DS-4 & FG-4 grzegorz.banach@accenture.com 15/05/2019
    },
     /**
    *@author Giovanni Spinelli <spinelli.giovanni@accenture.com>
    *@date 27/09/2018
    *@description   Method to get sp from id from
                    maintenance and pass this sp in child component 
                    in pvNode attribute with aura:method
    *@params -
    *@return Account
    */
    retrieveAutomaticSp : function (component,automaticId){
        var action = component.get("c.retrieveAutomaticSp");
        action.setParams({ servicePointId : automaticId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.showOtherInput', true);
                component.set('v.pvNode', response.getReturnValue());
                var pvNode = component.get('v.pvNode');
                var fireSp = component.find("servicePointIdentifyCompany");
                fireSp.automaticSp(pvNode);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });

        $A.enqueueAction(action);
    }

})