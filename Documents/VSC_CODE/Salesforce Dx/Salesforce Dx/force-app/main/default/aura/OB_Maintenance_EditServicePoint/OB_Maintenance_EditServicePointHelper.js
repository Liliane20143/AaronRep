({
    initFunction: function(component, event, helper)
    {
        component.set("v.isSpinner",true); //NEXI-195 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 11/07/2019 Delete field disabling
        console.log('sono nel init');
        this.setAddressMapping(component,event,helper);
        this.getTypologyValues(component,event,helper);
        this.retrieveFieldsLabel(component,event,helper);
        this.retrieveServicePointData(component,event,helper);
        this.retrievePuntiVenditaData(component,event,helper);

        console.log("oldInfo : "+JSON.stringify(component.get("v.oldInfo")));
        console.log("FlowStep : "+component.get("v.FlowStep"));
        //giovanni spinelli-get lov l2 and l3
        var ListOfPuntiVendita = component.get('v.ListOfServicePoint');
        //NEXI-180 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 12/07/2019 START
        if(component.get("v.fromShortCutSP"))
        {
            component.set('v.ServicePointColumns', [
                {label: 'Insegna', fieldName: 'OB_ShopSign__c', type: 'text'},
                {label: 'Insegna Scontrino', fieldName: 'OB_ReceiptHeader__c', type: 'text'},                        //changeLabel
                {label: 'Località Scontrino', fieldName: 'OB_ReceiptCity__c', type: 'text'},
                {label: 'Codice Punto Vendita', fieldName: 'OB_ServicePointCodeShopCode__c', type: 'text'},
                //NEXI-183, Wojciech Szuba, <wojciech.szuba@accenture.com>, 09/07/2019, START
                {label: 'Modalità di liquidazione', fieldName: 'OB_InternationalSettlementMethod__c', type: 'text'}
                //NEXI-183, Wojciech Szuba, <wojciech.szuba@accenture.com>, 09/07/2019, STOP
            ]);
        }
        else
        {
            component.set('v.ServicePointColumns',
            [
                {label: 'Insegna', fieldName: 'OB_ShopSign__c', type: 'text'},
                {label: 'Insegna Scontrino', fieldName: 'OB_ReceiptHeader__c', type: 'text'},                        //changeLabel
                {label: 'Località Scontrino', fieldName: 'OB_ReceiptCity__c', type: 'text'},
                {label: 'Codice Punto Vendita', fieldName: 'OB_ServicePointCodeShopCode__c', type: 'text'}
            ]);
        }
        //NEXI-180 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 12/07/2019 STOP

        //ANDREA START 28/12/2018
        /* ON CLICK OF CANCEL BUTTON REMOVE RED BORDER UPON THE ERROR CLASS */

        //Array containing every currentId
        var listOfCurrentId = ["OB_Email__c", "OB_TechnicalReferentEmail", "OB_ServicePointResponsibleEmail", "OB_Mobile_Phone_Number__c", "MobilePhone", "OB_ServicePointAdminResponsibleMobile", "OB_ServicePointResponsibleMobile", "OB_TechnicalReferentMobile", "Name", "OB_ShopSign", "OB_ReceiptHeader__c", "OB_ReceiptCity__c", "FirstName", "LastName", "OB_ServicePointAdminResponsibleFirstName", "OB_ServicePointAdminResponsibleLastName", "OB_ServicePointResponsibleFirstName", "OB_ServicePointResponsibleLastName", "OB_TechnicalReferentFirstName", "OB_TechnicalReferentLastName"];
        for(var index = 0; index < listOfCurrentId.length; index ++)
        {
            console.log(listOfCurrentId[index]);
            if (typeof component.find(listOfCurrentId[index]) !== "undefined")
            {
                $A.util.removeClass(component.find(listOfCurrentId[index]), 'slds-has-error flow_required');
            }
        }
        //ANDREA END 28/12/2018
    },

    getL2 : function(component , valueReturns)
    {
        console.log('PUNTI VENDITA: ' + JSON.stringify(valueReturns));
        let action = component.get('c.retrieveLovMccL2');
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS")
            {
                let listOfLovL2 = response.getReturnValue();
                // NEXI-212 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 16/07/2019 START back to old version with loop
                component.set( "v.mccL2", listOfLovL2 ); // NEXI-81 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 03/06/2019
                for( let sp in valueReturns )
                {
                    for( let key in listOfLovL2 )
                    {
                        // NEXI-161 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 03/07/2019 START
                        let mccL2 = valueReturns[sp]['OB_MCCL2__c'];
                        if( !$A.util.isEmpty( mccL2 ) && // NEXI-261 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 14/08/2019 null check
                            ( mccL2 == listOfLovL2[key]['OB_Value4__c'] || mccL2 == listOfLovL2[key]['NE__Value2__c'] ) )
                        {
                            valueReturns[sp]['OB_MCCL2__c'] = mccL2 + ' - ' + listOfLovL2[key]['Name'];
                            break;
                        }
                       // NEXI-161 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 03/07/2019 STOP
                    }
                }
                // NEXI-212 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 16/07/2019 STOP
                //ADD A COLUMN
                let cols = component.get('v.ServicePointColumns');
                cols.push({label: $A.get("$Label.c.OB_MCC_DescriptionL2"), fieldName: 'OB_MCCL2__c', type: 'text'});
                component.set('v.ServicePointColumns' , cols);
            }
            else if (state === "ERROR")
            {
                let errors = response.getError();
                console.log(errors);
            }
        });
        $A.enqueueAction(action);
    },

    getL3 : function(component , valueReturns)
    {
        let action = component.get('c.retrieveLovMccL3');
        action.setCallback(this, function (response)
        {
            let state = response.getState();
            if (state === "SUCCESS")
            {
                let listOfLovL3 = response.getReturnValue();
                // NEXI-212 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 16/07/2019 START back to old version with loop
                component.set( "v.mccL3", listOfLovL3 ); // NEXI-81 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 03/06/2019
                for( let sp in valueReturns )
                {
                    for( let key in listOfLovL3 )
                    {
                        if( !$A.util.isEmpty( valueReturns[sp]['OB_MCC__c'] ) && // NEXI-261 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 14/08/2019 null check
                            valueReturns[sp]['OB_MCC__c'] == listOfLovL3[key]['NE__Value2__c'] )
                        {
                            valueReturns[sp]['OB_MCC__c'] = valueReturns[sp]['OB_MCC__c'] + ' - ' + listOfLovL3[key]['Name'];
                            break;
                        }
                    }
                }
                // NEXI-212 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 16/07/2019 STOP
                let cols = component.get('v.ServicePointColumns');
                cols.push({label: $A.get("$Label.c.OB_MCC_DescriptionL3"), fieldName: 'OB_MCC__c', type: 'text'});
                component.set('v.ServicePointColumns' , cols);
            }
            else if (state === "ERROR")
            {
                let errors = response.getError();
                console.log(errors);
            }
        });
        $A.enqueueAction(action);
    },

    disableFields : function(component, event, helper) {
        var dis= component.get("v.disabled");
        var myInputs = component.find("MainDiv").find({instancesOf : "lightning:input"});
        for(var i = 0; i < myInputs.length; i++){
            console.log(myInputs[i]);
            myInputs[i].set('v.disabled',dis);
        }
        var disabledFields = component.get('v.DisabledFields');
        if(disabledFields)
        {
            for(var i in disabledFields)
            {
                component.find(disabledFields[i]).set('v.disabled',true);
            }
        }
    },

    retrieveServicePointData: function(component, event, helper)
    {
        var action = component.get('c.retrieveServicePointData');
        var servicePointId = component.get('v.modifyServicePointId');
        console.log('servicePointId --> '+servicePointId);
        action.setParams({
            servicePointId : servicePointId
        });
        action.setCallback(this, function (response)
        {
            var state = response.getState();
            console.log('state --> '+(state === "SUCCESS"));
            if (state === "SUCCESS")
            {
                console.log('valueReturns --> '+JSON.stringify(response.getReturnValue()));
                var valueReturns = response.getReturnValue();
                var odm = component.get('v.objectDataMap');
                console.log('JSON.stringify(valueReturns.pv.OB_Opening_Time__c)'+JSON.stringify(JSON.parse(valueReturns).pv));
                //ANDREA START 17/01/19
                if(JSON.stringify(JSON.parse(valueReturns).pv.OB_Opening_Time__c) != undefined)
                {
                    var openTime = JSON.stringify(JSON.parse(valueReturns).pv.OB_Opening_Time__c);
                    console.log('openTime is : ' + openTime );
                    console.log('CHARAT')
                    var lastChar = openTime.substr(openTime.length - 2);
                    console.log('lastChar is: ' + lastChar );
                    openTime = openTime.slice(0, openTime.length-2);
                    //START g.v. 01/04/2019 - changed substring to HH:mm
                    openTime = openTime.substr(1,5);
                    //END g.v.
                    console.log('Final open time is : ' + openTime);
                    component.set('v.finalOpenTime', openTime);
                }
                if(JSON.stringify(JSON.parse(valueReturns).pv.OB_Ending_Time__c) != undefined)
                {
                    var closeTime = JSON.stringify(JSON.parse(valueReturns).pv.OB_Ending_Time__c);
                    console.log('closeTime is : ' + closeTime );
                    console.log('CHARAT')
                    var lastChar = closeTime.substr(closeTime.length - 2);
                    console.log('lastChar is: ' + lastChar );
                    closeTime = closeTime.slice(0, closeTime.length-2);
                    //START g.v. 01/04/2019 - changed substring to HH:mm
                    closeTime = closeTime.substr(1,5);
                    //END g.v.
                    console.log('Final closeTime  is : ' + closeTime);
                    component.set('v.finalClosingTime', closeTime);
                }
                if(JSON.stringify(JSON.parse(valueReturns).pv.OB_Break_Start_Time__c) != undefined)
                {
                    var bStartTime = JSON.stringify(JSON.parse(valueReturns).pv.OB_Break_Start_Time__c);
                    console.log('bStartTime is : ' + bStartTime );
                    console.log('CHARAT')
                    var lastChar = bStartTime.substr(bStartTime.length - 2);
                    console.log('lastChar is: ' + lastChar );
                    bStartTime = bStartTime.slice(0, bStartTime.length-2);
                    //START g.v. 01/04/2019 - changed substring to HH:mm
                    bStartTime = bStartTime.substr(1,5);
                    //END g.v.
                    console.log('Final closeTime  is : ' + bStartTime);
                    component.set('v.finalBreakStartTime', bStartTime);
                }
                if(JSON.stringify(JSON.parse(valueReturns).pv.OB_Break_End_Time__c) != undefined)
                {
                    var bEndTime = JSON.stringify(JSON.parse(valueReturns).pv.OB_Break_End_Time__c);
                    console.log('bEndTime is : ' + bEndTime );
                    console.log('CHARAT')
                    var lastChar = bEndTime.substr(bEndTime.length - 2);
                    console.log('lastChar is: ' + lastChar );
                    bEndTime = bEndTime.slice(0, bEndTime.length-2);
                    //START g.v. 01/04/2019 - changed substring to HH:mm
                    bEndTime = bEndTime.substr(1,5);
                    //END g.v.
                    console.log('Final bEndTime  is : ' + bEndTime);
                    component.set('v.finalBreakEndTime', bEndTime);
                }
                //ANDREA END 17/01/19
                component.set('v.objectDataMap',JSON.parse(valueReturns));
                component.set("v.oldInfo",JSON.parse(valueReturns));
                component.set("v.oldInfo",JSON.parse(valueReturns));
                console.log('component.set(v.objectDataMap)'+JSON.stringify(component.get('v.objectDataMap')));
                console.log('pv: '+ JSON.stringify(component.get('v.objectDataMap').pv)); //NEXI-105 06/06/2019 z.urban@accenture.com Change logic for lookup
                // Start antonio.vatrano 04/04/2019 skip referents if from shortcut
                var fromShortCutSP = component.get("v.fromShortCutSP");
                // Start antonio.vatrano 16/04/2019 show only the context contact and hide the other contacts if exist
                var fromShortCutReferents = component.get("v.fromShortCutReferents");
                var contactId = component.get("v.shortcutContactId");
                if(!fromShortCutSP)
                {
                    if(!fromShortCutReferents)
                    {
                        if(component.get('v.objectDataMap').servicePointResponsible != undefined && component.get('v.objectDataMap').servicePointResponsible.LastName != undefined) //NEXI-76 Zuzanna Urban <z.urban@accenture.com> 14/06/2019, change logic
                        {
                            component.set("v.servPointResp",true);
                            //NEXI-195 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 11/07/2019 Delete field disabling
                        }
                        if(component.get('v.objectDataMap').administrativeResponsible != undefined && component.get('v.objectDataMap').administrativeResponsible.LastName != undefined) //NEXI-76 Zuzanna Urban <z.urban@accenture.com> 14/06/2019, change logic
                        {
                            component.set("v.adminResp",true);
                            //NEXI-195 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 11/07/2019 Delete field disabling
                        }
                        if(component.get('v.objectDataMap').technicalReferent != undefined && component.get('v.objectDataMap').technicalReferent.LastName != undefined) //NEXI-76 Zuzanna Urban <z.urban@accenture.com> 14/06/2019, change logic
                        {
                            component.set("v.techRef",true);
                            //NEXI-195 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 11/07/2019 Delete field disabling
                        }
                    }
                    else
                    {
                        //START NEXI-105 06/06/2019 z.urban@accenture.com Change logic for lookup
                        var servicePointResponsible = component.get('v.objectDataMap').servicePointResponsible;
                        var servicePointAdminResponsible = component.get('v.objectDataMap').administrativeResponsible;
                        var technicalReferent =  component.get('v.objectDataMap').technicalReferent;
                        //STOP NEXI-105 06/06/2019 z.urban@accenture.com Change logic for lookup
                        if(component.get('v.objectDataMap').servicePointResponsible != undefined && contactId == servicePointResponsible && component.get('v.objectDataMap').servicePointResponsible.LastName != undefined) ///NEXI-76 Zuzanna Urban <z.urban@accenture.com> 14/06/2019, change logic
                        {
                            component.set("v.servPointResp",true);
                            //NEXI-195 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 11/07/2019 Delete field disabling
                        }
                        if(component.get('v.objectDataMap').administrativeResponsible != undefined && contactId == servicePointAdminResponsible && component.get('v.objectDataMap').administrativeResponsible.LastName != undefined) //NEXI-76 Zuzanna Urban <z.urban@accenture.com> 14/06/2019, change logic
                        {
                            component.set("v.adminResp",true);
                            //NEXI-195 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 11/07/2019 Delete field disabling
                        }
                        if(component.get('v.objectDataMap').technicalReferent != undefined && contactId == technicalReferent && component.get('v.objectDataMap').technicalReferent.LastName != undefined) //NEXI-76 Zuzanna Urban <z.urban@accenture.com> 14/06/2019, change logic
                        {
                            component.set("v.techRef",true);
                            //NEXI-195 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 11/07/2019 Delete field disabling
                        }
                        //giovanni spinelli 13/06/2019 - end - enabled fields
                    }
                }
                // End antonio.vatrano 04/04/2019 skip referents if from shortcut
                // NEXI-261 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 14/08/2019 START
                let tempListOfESM = JSON.parse(JSON.stringify(component.get("v.objectDataMap").listOfSourceMapping));
                if ( !$A.util.isEmpty( tempListOfESM ) )
                {
                    for ( let i = 0; i < tempListOfESM.length; i++ )
                    {
                        if (  $A.util.isEmpty( tempListOfESM[i]['OB_MCC__c'] ) )
                        {
                            tempListOfESM[i]['OB_MCC__c'] = '';
                        }
                        if (  $A.util.isEmpty( tempListOfESM[i]['OB_MCCL2__c'] ) )
                        {
                            tempListOfESM[i]['OB_MCCL2__c'] = '';
                        }
                    }
                    component.set( "v.objectDataMap.listOfSourceMapping", tempListOfESM );
                }
                // NEXI-261 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 14/08/2019 STOP
                // Start antonio.vatrano 16/04/2019 show only the context contact and hide the other contacts if exist
                component.set('v.isLoaded',true);
                //NEXI-195 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 11/07/2019 Start
                this.modify(component);
                component.set("v.isSpinner",false);
                //NEXI-195 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 11/07/2019 Stop
            }
            else if (state === "ERROR")
            {
                var errors = response.getError();
                console.log(errors);
            }
        });
        $A.enqueueAction(action);
    },

    retrieveFieldsLabel : function(component, event, helper)
    {
        var action = component.get('c.retriveSchemaInformation');
        var listOfSobject = ["NE__Service_Point__c", "Contact"];
        action.setParams({
            SObjectToRetrive : listOfSobject
        });
        action.setCallback(this, function (response) {

            var state = response.getState();
            console.log('state retrieveFieldsLabel -->'+state);
            if (state === "SUCCESS") {
                console.log('success retrieveFieldsLabel');
                var valueReturns = response.getReturnValue();
                var myMap = new Map();
                var result = JSON.parse( valueReturns );
                try
                {
                    var servicePoint = result.mapSObjectfields['NE__Service_Point__c'];
                    var contactFiels = result.mapSObjectfields['Contact'];
                    component.set("v.ServicePointFieldsLabel",servicePoint);
                    component.set("v.ContactFieldsLabel",contactFiels);
                }
                catch(err){
                    console.log(err);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        });
        $A.enqueueAction(action);
    },

    getTypologyValues: function(component,event,helper)
    {
        var actionTypologyValues = component.get("c.retrieveValueTypology");
        actionTypologyValues.setCallback(this, function (response) {
            var state = response.getState();
            console.log("state typology --> "+state);
            if (state === "SUCCESS") {
                console.log("getTypologyValues response --> "+ response.getReturnValue());
                component.set("v.typologyValuedPicklist",response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.log(errors);
            }
        });
        $A.enqueueAction(actionTypologyValues);
    } ,

    setAddressMapping : function(component,event,helper)
    {
        console.log('sono in setAddressMapping');
        var postelcomponentparams = {};
        postelcomponentparams.sectionaddress         = 'generaladdress';

        postelcomponentparams.provincedisabled       = 'false';
        postelcomponentparams.provinceinputobject    = 'pv';
        postelcomponentparams.provinceinputfield     = 'NE__Province__c';

        postelcomponentparams.citydisabled           = 'true';
        postelcomponentparams.cityinputobject        = 'pv';
        postelcomponentparams.cityinputfield         = 'NE__City__c';

        postelcomponentparams.districtdisabled       = 'true';
        postelcomponentparams.districtinputobject    = 'pv';
        postelcomponentparams.districtinputfield     = 'OB_District__c';

        postelcomponentparams.streetdisabled         = 'true';
        postelcomponentparams.streetinputobject      = 'pv';
        postelcomponentparams.streetinputfield       = 'NE__Street__c';

        postelcomponentparams.streetnumberdisabled   = 'false';
        postelcomponentparams.streetnumberinputobject= 'pv';
        postelcomponentparams.streetnumberinputfield = 'OB_Street_Number__c';

        postelcomponentparams.zipcodedisabled        = 'false';
        postelcomponentparams.zipcodeinputobject     = 'pv';
        postelcomponentparams.zipcodeinputfield      = 'NE__Postal_Code__c';

        postelcomponentparams.countrydisabled        = 'false';
        postelcomponentparams.countryinputobject     = 'pv';
        postelcomponentparams.countryinputfield      = 'NE__Country__c';

        postelcomponentparams.countrycodeinputobject = 'pv';
        postelcomponentparams.countrycodeinputfield  = 'NE__Country_Code__c';
        postelcomponentparams.withCountry            = 'true';
        postelcomponentparams.provincecodeinputobject= 'pv';
        postelcomponentparams.provincecodeinputfield = 'OB_Province_Code__c';
        postelcomponentparams.isComplete             = 'true';
        postelcomponentparams.withDetail             = 'true';
        postelcomponentparams.pressoinputfield       = 'OB_Address_Detail__c';
        postelcomponentparams.pressoinputobject      = 'pv';

        postelcomponentparams.isPV                    = 'true';
        console.log("*****before set");
        component.set('v.postelcomponentparams',postelcomponentparams);
        console.log("**** "+JSON.stringify(component.get('v.postelcomponentparams')));
        console.log("*****after set");
    },

    retrievePuntiVenditaData :function(component,event,helper)
    {
        var action = component.get('c.retrievePuntiVenditaData');
        var servicePointId = component.get('v.modifyServicePointId');
        console.log('servicePointId retrievePuntiVenditaData --> '+servicePointId);
        action.setParams({
            servicePointId : servicePointId
        });
        action.setCallback(this,function (response) {
            var state = response.getState();
            if (state === "SUCCESS")
            {
                console.log('valueReturns retrievePuntiVenditaData --> '+JSON.stringify(response.getReturnValue()));
                var valueReturns = response.getReturnValue();
                component.set('v.ListOfServicePoint',valueReturns);
                this.getL2(component , valueReturns);
                this.getL3(component , valueReturns);
                console.log('valueReturns.size -->'+valueReturns.length);
                component.set("v.ListOfServicePointSize",valueReturns.length);
           }
           else if (state === "ERROR")
           {
                var errors = response.getError();
                console.log(errors);
           }
        });
        $A.enqueueAction(action);
    },

    //Start antonio.vatrano 19/07/2019 create 2 logrequests
    saveDataHelper: function (component, event, oldObject, newObject, objectDataMap)
    {
        //NEXI-298 Marta Stempien <marta.stempien@accenture.com> 11/09/2019 Start
        let logRequestsRequiringDocumentation = [];
        let isApprovalProcessRequired = false;
        //NEXI-298 Marta Stempien <marta.stempien@accenture.com> 11/09/2019 Stop
        let action = component.get('c.getRequests');
        action.setParams
            ({
                "oldData": oldObject,
                "newData": newObject,
                "objectDataMap": objectDataMap
            });
        action.setCallback(this, $A.getCallback(function (response) {
            let state = response.getState();
            if (state === "SUCCESS")
            {
                let result = response.getReturnValue();
                //NEXI-298 Marta Stempien <marta.stempien@accenture.com> 11/09/2019 Start
                for (let returnedValue of result)
                {
                    if($A.util.isEmpty(returnedValue.errorMessage ) && !$A.util.isEmpty(returnedValue.logrequestId))
                    {
                        if( returnedValue.documentRequired )
                        {
                            if( $A.util.isEmpty(returnedValue.conditionMCC) || returnedValue.conditionMCC )
                        {
                            logRequestsRequiringDocumentation.push(returnedValue.logrequestId);
                            isApprovalProcessRequired = returnedValue.approvalProcessRequired;
                        }
                            else if (!returnedValue.conditionMCC)
                    {
                                this.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR"), $A.get("$Label.c.OB_MAINTENANCE_IT_IS_NOT_POSSIBLE_TO_SELECT_THE_FALLOWING_MCC"), 'error');
                        this.removeLogRequest(component, event);
                        this.setOldMCCValue(component, component.get("v.ListOfServicePoint"));
                        break;
                    }
                        }
                        component.set("v.saveLogRequest", returnedValue.logrequestId);
                        }
                    else
                    {
                        this.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR"), returnedValue.errorMessage, 'error');
                        console.log(returnedValue.errorMessage); //NEXI-298 Marta Stempien <marta.stempien@accenture.com> 13/09/2019 Changed message for errorMessage
                        break;
                    }
                }
                component.set("v.isApprovalProcessRequired", isApprovalProcessRequired);
                if(!$A.util.isEmpty(logRequestsRequiringDocumentation))
                {
                     component.set("v.logRequestsRequiringDocumentation", logRequestsRequiringDocumentation);
                     component.set('v.isDocumentUploadOpen', true);
                }
                if(!$A.util.isEmpty(component.get("v.saveLogRequest"))&&!component.get('v.isDocumentUploadOpen'))
                {
                    let navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": component.get("v.saveLogRequest"),
                        "isredirect": true
                    });
                    navEvt.fire();
                }
                component.find("save").set("v.disabled",true); //francesca.ribezzi 11/11/19 - PROD-66 - disable/enable btn to avoid duplicates
                 //NEXI-298 Marta Stempien <marta.stempien@accenture.com> 11/09/2019 Stop
                 
            }
            else if (state === "ERROR")
            {
                let errors = response.getError();
                console.log('EditServicePoint.savecustomHelper:Code000 : ' + errors);
                component.find("save").set("v.disabled",false);  //francesca.ribezzi 11/11/19 - PROD-66 - disable/enable btn to avoid duplicates
                this.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR"), errors, 'error');
            }
        }));
        $A.enqueueAction(action);
    },
    //End antonio.vatrano 19/07/2019 create 2 logrequests

    /**
    * @author ?
    * @task ?
    * @date ?
    * @description Method saves changed data
    * @history 08/07/2019 Joanna Mielczarek <joanna.mielczarek@accenture.com> modified - NEXI-173 - refactored code, align logic to apex method
    **/
    savecustomHelper : function(component, event, oldObject, newObject, flowData)
    {
        let action = component.get('c.saveRequest');
        action.setParams({
            "oldData" : oldObject,
            "newData" : newObject,
            "flowData" : flowData
        });
        action.setCallback(this, function (response)
        {
            let state = response.getState();
            if ( state === "SUCCESS" )
            {
                let result = response.getReturnValue();
                let errorMex = result.errorMessage;

                //  START   micol.ferrari 27/12/2018
                if ( errorMex == $A.get( "$Label.c.OB_NoChangesMessage" ) )
                {
                    this.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_NOERROR"), $A.get("$Label.c.OB_MAINTENANCE_ERROR_NODATACHANGE"), 'error');
                }
                //  END   micol.ferrari 27/12/2018
                else
                {
                    let recordId = result.logrequestId;
                    if( !$A.util.isEmpty( recordId ) && recordId != 'null' )
                    {
                        component.set( 'v.saveLogRequest', recordId );
                        if ( !result.documentRequired ) //NEXI-65 Wojciech Kucharek <wojciech.kucharek@accenture.com> 11/06/2019 START
                        {
                            let navEvt = $A.get("e.force:navigateToSObject");
                            navEvt.setParams({
                                "recordId":recordId,
                                "isredirect": true //NEXI-76 10/06/2019 z.urban@accenture.com Fix redirect
                            });
                            navEvt.fire();
                            $A.get('e.force:refreshView').fire();
                        }
                        else
                        {
                            // NEXI-173 Joanna Mielczarek <joanna.mielczarek@accenture.com> 08/07/2019 START changed value of toast
                            if ( !result.conditionMCC )
                            {
                                this.showToast( component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR"), $A.get("$Label.c.OB_MAINTENANCE_IT_IS_NOT_POSSIBLE_TO_SELECT_THE_FALLOWING_MCC"), 'error');
                                this.removeLogRequest( component, event );
                                this.setOldMCCValue( component, component.get( "v.ListOfServicePoint" ) ); // NEXI-212 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 16/07/2019 setting old value
                            }
                            else
                            {
                                component.set( 'v.isDocumentUploadOpen', result.documentRequired );
                                component.set( 'v.isApprovalProcessRequired', result.approvalProcessRequired );//NEXI-146 grzegorz.banach@accenture.com 08/07/2019
                            }
                            // NEXI-173 Joanna Mielczarek <joanna.mielczarek@accenture.com> 08/07/2019 STOP
                        }
                    }
                    else
                    {
                        console.log('recordID == null');
                        this.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR"),errorMex,'error');
                    }
                }
            }
            else if (state === "ERROR")
            {
                let errors = response.getError();
                console.log( 'EditServicePoint.savecustomHelper:Code000 : ' + errors );
                this.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR"), errors, 'error');
            }
        });
        $A.enqueueAction(action);
    },

    /**
    * @author Wojciech Kucharek
    * @task NEXI-65
    * @date 13/06/2019
    * @description Method fires event - redirect to log request detail page
    * @history 13/06/2019 <wojciech.kucharek@accenture.com> created
    * @history 08/07/2019 grzegorz.banach@accenture.com NEXI-146 - added logic for starting approval process
    **/
    whenDocumentsUploaded: function(component, event)
    {
        var recordId = component.get('v.saveLogRequest');
        let isApprovalProcessRequired = component.get('v.isApprovalProcessRequired');
        if ( isApprovalProcessRequired )
        {
            let action = component.get( 'c.startApprovalProcess' );
            action.setParams({ "logRequestId" : recordId });
            action.setCallback(this, function (response) {
                let state = response.getState();
                let approvalProcessStarted = response.getReturnValue( );
                if ( state === "SUCCESS" && approvalProcessStarted )
                {
                    this.redirectToSObject( component, event, recordId );
                }
                else
                {
                    this.showToast( component, event, $A.get("$Label.c.OB_ServerLogicFailed"), '', 'error' );
                }
            });
            $A.enqueueAction( action );
            return;
        }
        else
        {
        //NEXI-259 Marta Stempien <marta.stempien@accenture.com> 08/08/2019 Start
            let action = component.get( 'c.confirmUploadedDocumentsSetInAttesaStatus' );
            action.setParams({ "inLogRequestId" : recordId });
            action.setCallback(this, function (response) {
                let state = response.getState();
                let isUpdated = response.getReturnValue( );
                if ( state === "SUCCESS" && isUpdated )
                {
                    this.redirectToSObject( component, event, recordId );
                }
                else
                {
                    this.showToast( component, event, $A.get("$Label.c.OB_ServerLogicFailed"), '', 'error' );
                }
            });
            $A.enqueueAction( action );
            return;
        //NEXI-259 Marta Stempien <marta.stempien@accenture.com> 08/08/2019 Stop
        }
    },

    /**
    * @author Grzegorz Banach
    * @task NEXI-146
    * @date 09/07/2019
    * @description Method redirects to SObject using given "recordId"
    * @history 09/07/2018 <grzegorz.banach@accenture.com> created - extracted logic from "whenDocumentsUploaded" method
    **/
    redirectToSObject: function(component, event, recordId)
    {
        let navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId" : recordId,
            "isredirect": true
        });
        navEvt.fire();
    },

    /**
    * @author Wojciech Kucharek
    * @task NEXI-65
    * @date 13/06/2019
    * @description Method calls apex method - removing log request
    * @history 13/06/2019 <wojciech.kucharek@accenture.com> created
               05/07/2019 <joanna.mielczarek@accenture.com> added error handling
    **/
    removeLogRequest: function(component, event)
    {
        var recordId = component.get('v.saveLogRequest');
        var action = component.get('c.deleteLogRequest');
        action.setParams({
            "logRequestId" : recordId
        });
        action.setCallback(this, function ( response)
        {
            var state = response.getState();
            if(state === "SUCCESS")
            {
                // NEXI-143 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 05/07/2019 START
                if ( !$A.util.isEmpty( response.getReturnValue( ) ) )
                {
                    console.log( 'EditServicePoint.removeLogRequest exception: ' + response.getReturnValue( ) );
                    this.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR"), $A.get("$Label.c.OB_ServerLogicFailed"), 'error');
                }
                else
                {
                    component.set('v.saveLogRequest', '');
                    component.set('v.isDocumentUploadOpen', false);
                    component.set('v.showConfirmButton', false);
                    console.log('Removed log request : ' + recordId);
                }
            // NEXI-143 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 05/07/2019 STOP
            }
            else if (state === "ERROR")
            {
                let errors = response.getError();
                console.error( errors );
                // NEXI-143 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 05/07/2019 START
                this.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR"), $A.get("$Label.c.OB_ServerLogicFailed"), 'error');
                // NEXI-143 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 05/07/2019 STOP
            }
        });
        $A.enqueueAction(action);
    },

    showToast: function (component, event,title, message, type)
    {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },

    //NEXI-110 24.06.2019 damian.krzyzaniak@accenture.com START - creation of non-existing function checking for special characters
    specialCharacter : function(component, validationValue)
    {
        let regExp = /[~`!@#$%^&()_={}[\]:;,.<>+\/?-]/;
        if(regExp.test(validationValue))
        {
            component.set("v.isDisabled", true);
            return 'ERROR';
        }
        else
        {
            component.set("v.isDisabled", false);
            return ''; //NEXI-110 25.06.2019 damian.krzyzaniak@accenture.com
        }

    },
    //NEXI-110 24.06.2019 damian.krzyzaniak@accenture.com STOP

    formalCheck : function(component, event, helper)
    {
        console.log('formalCheck method');
        try
        {
            var currentId =event.getSource().getLocalId();
            console.log('currentId : ' + currentId);
            console.log('component.find(currentId) : ' + component.find(currentId));
            var validationValue = component.find(currentId).get("v.value");
            console.log('validationValue : ' + validationValue);
            var emailControl  = helper.emailControl(validationValue);
            var numberControl = helper.onlyNumberPhone(validationValue);
            var nameControl = helper.specialCharacter(component, validationValue); //NEXI-110 24.06.2019 damian.krzyzaniak@accenture.com
            console.log('nameControl : ' + nameControl);

            //************************************************START___Dettagli Location*****************************************
            if(currentId == 'OB_Email__c')
            {
                if((emailControl)=='ERROR' )
                {
                    $A.util.addClass( component.find(currentId) , 'slds-has-error flow_required');
                    if( validationValue.length>0){
                        component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageEmailPV" , $A.get("$Label.c.EmailNotValid"))  ;
                    }else{
                        component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageEmailPV" , $A.get("$Label.c.MandatoryField")) ;
                    }
                    component.set("v.objectDataMap.errorFamily.errorEmailPv", true);
                    component.find("save").set("v.disabled",true);
                }
                else
                {
                    $A.util.removeClass(component.find(currentId) , 'slds-has-error flow_required');
                    component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageEmailPV" , '')  ;
                    component.set("v.objectDataMap.errorFamily.errorEmailPv", false);
                    component.find("save").set("v.disabled",false);
                }
            }
            else if(currentId=='Name')
            {
                if((nameControl)=='ERROR'  )
                {
                    $A.util.addClass( component.find(currentId) , 'slds-has-error flow_required');
                    if(validationValue.length>0)
                    {
                        component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageNamePV" ,  $A.get("$Label.c.OB_PresenceOfAnInvalidCharacter"))  ;
                    } else{
                        component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageNamePV" , $A.get("$Label.c.MandatoryField"))  ;
                    }
                    component.set("v.objectDataMap.errorFamily.ErrorNamePv", true);
                    component.find("save").set("v.disabled",true);
                }
                else
                {
                    $A.util.removeClass(component.find(currentId) , 'slds-has-error flow_required');
                    component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageNamePV" , '')  ;
                    component.set("v.objectDataMap.errorFamily.ErrorNamePv", false);
                    component.find("save").set("v.disabled",false);
                }
            }
            else if(currentId=='OB_Mobile_Phone_Number__c')
            {
                if((numberControl)=='ERROR')
                {
                    $A.util.addClass( component.find(currentId) , 'slds-has-error flow_required');
                    if( validationValue.length>0){

                        component.set("v.objectDataMap.errorFamilyMessage.ErrorMessagePhonePV" ,  $A.get("$Label.c.MinFiveMaxTenDigitLength"))  ;
                    }else{
                        component.set("v.objectDataMap.errorFamilyMessage.ErrorMessagePhonePV" , $A.get("$Label.c.MandatoryField"))  ;
                    }

                    component.set("v.objectDataMap.errorFamily.errorPhonePv", true);
                    component.find("save").set("v.disabled",true);
                }
                else
                {
                    $A.util.removeClass(component.find(currentId) , 'slds-has-error flow_required');
                    component.set("v.objectDataMap.errorFamilyMessage.ErrorMessagePhonePV" , '')  ;
                    component.set("v.objectDataMap.errorFamily.errorPhonePv", false);
                    component.find("save").set("v.disabled",false);
                }
            }
            //************************************************END___Dettagli Location*****************************************

            //************************************************START___OB_TechnicalReferent*****************************************
            else if(currentId=='OB_TechnicalReferentFirstName')
            {
                if((nameControl)=='ERROR')
                {
                    $A.util.addClass( component.find(currentId) , 'slds-has-error flow_required');
                    if(validationValue.length>0)
                    {

                        component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageNameTechRef" ,  $A.get("$Label.c.OB_PresenceOfAnInvalidCharacter"))  ;
                    }
                    else
                    {
                        component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageNameTechRef" , $A.get("$Label.c.MandatoryField"))  ;
                    }
                    component.set("v.objectDataMap.errorFamily.ErrorNameTechRefName", true);
                    component.find("save").set("v.disabled",true);
                }
                else
                {
                    $A.util.removeClass(component.find(currentId) , 'slds-has-error flow_required');
                    component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageNameTechRef" , '')  ;
                    component.set("v.objectDataMap.errorFamily.ErrorNameTechRefName", false);
                    component.find("save").set("v.disabled",false);
                }
            }
            else if(currentId=='OB_TechnicalReferentLastName')
            {
                if((nameControl)=='ERROR')
                {
                    $A.util.addClass( component.find(currentId) , 'slds-has-error flow_required');
                    if(validationValue.length>0)
                    {
                        component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageLastNameTechRef" ,  $A.get("$Label.c.OB_PresenceOfAnInvalidCharacter"))  ;
                    }
                    else
                    {
                        component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageLastNameTechRef" , $A.get("$Label.c.MandatoryField"))  ;
                    }
                    component.set("v.objectDataMap.errorFamily.ErrorNameTechRefLast", true);
                    component.find("save").set("v.disabled",true);
                }
                else
                {
                    $A.util.removeClass(component.find(currentId) , 'slds-has-error flow_required');
                    component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageLastNameTechRef" , '')  ;
                    component.set("v.objectDataMap.errorFamily.ErrorNameTechRefLast", false);
                    component.find("save").set("v.disabled",false);
                }
            }
            else if(currentId=='OB_TechnicalReferentEmail')
            {
                if((emailControl)=='ERROR')
                {
                    $A.util.addClass( component.find(currentId) , 'slds-has-error flow_required');
                    if( validationValue.length>0)
                    {
                        component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageEmailTechRef" , $A.get("$Label.c.EmailNotValid"))  ;
                    }
                    else
                    {
                        component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageEmailTechRef" , $A.get("$Label.c.MandatoryField"))  ;
                    }
                    component.set("v.objectDataMap.errorFamily.errorEmailTechRef", true);
                    component.find("save").set("v.disabled",true);
                }
                else
                {
                    $A.util.removeClass(component.find(currentId) , 'slds-has-error flow_required');
                    component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageEmailTechRef" , '')  ;
                    component.set("v.objectDataMap.errorFamily.errorEmailTechRef", false);
                    component.find("save").set("v.disabled",false);
                }
            }
            else if(currentId=='OB_TechnicalReferentMobile')
            {
                if((numberControl)=='ERROR')
                {
                    $A.util.addClass( component.find(currentId) , 'slds-has-error flow_required');
                    if( validationValue.length>0)
                    {
                        component.set("v.objectDataMap.errorFamilyMessage.ErrorMessagePhoneTechRef" ,  $A.get("$Label.c.MinFiveMaxTenDigitLength"))  ;
                    }
                    else
                    {
                        component.set("v.objectDataMap.errorFamilyMessage.ErrorMessagePhoneTechRef" , $A.get("$Label.c.MandatoryField"))  ;
                    }
                    component.set("v.objectDataMap.errorFamily.errorPhoneTechRef", true);
                    component.find("save").set("v.disabled",true);
                }
                else
                {
                    $A.util.removeClass(component.find(currentId) , 'slds-has-error flow_required');
                    component.set("v.objectDataMap.errorFamilyMessage.ErrorMessagePhoneTechRef" , '')  ;
                    component.set("v.objectDataMap.errorFamily.errorPhoneTechRef", false);
                    component.find("save").set("v.disabled",false);
                }
            }
            //************************************************END___OB_TechnicalReferent*****************************************

            //************************************************START___OB_ServicePointResponsable*****************************************
            else if(currentId=='OB_ServicePointResponsibleFirstName')
            {
                if((nameControl)=='ERROR')
                {
                    $A.util.addClass( component.find(currentId) , 'slds-has-error flow_required');
                    if( validationValue.length>0)
                    {
                        component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageNameResp" , $A.get("$Label.c.OB_PresenceOfAnInvalidCharacter"));
                    }else
                    {
                        component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageNameResp" , $A.get("$Label.c.MandatoryField"))  ;
                    }
                    component.set("v.objectDataMap.errorFamily.ErrorNameRespPv", true);
                    component.find("save").set("v.disabled",true);
                }
                else
                {
                    $A.util.removeClass(component.find(currentId) , 'slds-has-error flow_required');
                    component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageNameResp" , '')  ;
                    component.set("v.objectDataMap.errorFamily.ErrorNameRespPv", false);
                    component.find("save").set("v.disabled",false);
                }
            }
            else if(currentId=='OB_ServicePointResponsibleLastName')
            {
                if((nameControl)=='ERROR')
                {
                    $A.util.addClass( component.find(currentId) , 'slds-has-error flow_required');
                    if( validationValue.length>0)
                    {
                        component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageLastNameResp" , $A.get("$Label.c.OB_PresenceOfAnInvalidCharacter"));
                    }
                    else
                    {
                        component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageLastNameResp" , $A.get("$Label.c.MandatoryField"))  ;
                    }
                    component.set("v.objectDataMap.errorFamily.ErrorLastNameRespPv", true);
                    component.find("save").set("v.disabled",true);
                }
                else
                {
                    $A.util.removeClass(component.find(currentId) , 'slds-has-error flow_required');
                    component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageLastNameResp" , '')  ;
                    component.set("v.objectDataMap.errorFamily.ErrorLastNameRespPv", false);
                    component.find("save").set("v.disabled",false);
                }
            }
            else if(currentId=='OB_ServicePointResponsibleEmail')
            {
                if((emailControl)=='ERROR')
                {
                    $A.util.addClass( component.find(currentId) , 'slds-has-error flow_required');
                    if( validationValue.length>0)
                    {
                        component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageEmailResp" , $A.get("$Label.c.EmailNotValid"))  ;
                    }
                    else
                    {
                        component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageEmailResp" , $A.get("$Label.c.MandatoryField"))  ;
                    }

                    component.set("v.objectDataMap.errorFamily.errorEmailRespPv", true);
                    component.find("save").set("v.disabled",true);
                }
                else
                {
                    $A.util.removeClass(component.find(currentId) , 'slds-has-error flow_required');
                    component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageEmailResp" , '')  ;
                    component.set("v.objectDataMap.errorFamily.errorEmailRespPv", false);
                    component.find("save").set("v.disabled",false);
                }
            }
            else if(currentId=='OB_ServicePointResponsibleMobile')
            {
                if((numberControl)=='ERROR' )
                {
                    $A.util.addClass( component.find(currentId) , 'slds-has-error flow_required');
                    if( validationValue.length>0)
                    {
                        component.set("v.objectDataMap.errorFamilyMessage.ErrorMessagePhoneResp" ,  $A.get("$Label.c.MinFiveMaxTenDigitLength"))  ;
                    }
                    else
                    {
                        component.set("v.objectDataMap.errorFamilyMessage.ErrorMessagePhoneResp" , $A.get("$Label.c.MandatoryField"))  ;
                    }
                    component.set("v.objectDataMap.errorFamily.errorPhoneRespPv", true);
                    component.find("save").set("v.disabled",true);
                }
                else
                {
                    $A.util.removeClass(component.find(currentId) , 'slds-has-error flow_required');
                    component.set("v.objectDataMap.errorFamilyMessage.ErrorMessagePhoneResp" , '')  ;
                    component.set("v.objectDataMap.errorFamily.errorPhoneRespPv", false);
                    component.find("save").set("v.disabled",false);
                }
            }
            //************************************************END___OB_ServicePointResponsable*****************************************

            //************************************************START___OB_ServicePointAdminResponsible*****************************************
            else if(currentId=='OB_ServicePointAdminResponsibleFirstName')
            {
                if((nameControl)=='ERROR' )
                {
                    $A.util.addClass( component.find(currentId) , 'slds-has-error flow_required');
                    if(validationValue.length>0)
                    {
                        component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageNameAdminResp" ,  $A.get("$Label.c.OB_PresenceOfAnInvalidCharacter"))  ;
                    }
                    else
                    {
                        component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageNameAdminResp" , $A.get("$Label.c.MandatoryField"))  ;
                    }
                    component.set("v.objectDataMap.errorFamily.ErrorNameRespAmmName", true);
                    component.find("save").set("v.disabled",true);
                }
                else
                {
                    $A.util.removeClass(component.find(currentId) , 'slds-has-error flow_required');
                    component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageNameAdminResp" , '')  ;
                    component.set("v.objectDataMap.errorFamily.ErrorNameRespAmmName", false);
                    component.find("save").set("v.disabled",false);
                }
            }
            else if(currentId=='OB_ServicePointAdminResponsibleLastName')
            {
                if((nameControl)=='ERROR' )
                {
                    $A.util.addClass( component.find(currentId) , 'slds-has-error flow_required');
                    if(validationValue.length>0)
                    {
                        component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageLastNameAdminResp" ,  $A.get("$Label.c.OB_PresenceOfAnInvalidCharacter"))  ;
                    }
                    else
                    {
                        component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageLastNameAdminResp" , $A.get("$Label.c.MandatoryField"))  ;
                    }
                    component.set("v.objectDataMap.errorFamily.ErrorNameRespAmmLast", true);
                    component.find("save").set("v.disabled",true);
                }
                else
                {
                    $A.util.removeClass(component.find(currentId) , 'slds-has-error flow_required');
                    component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageLastNameAdminResp" , '')  ;
                    component.set("v.objectDataMap.errorFamily.ErrorNameRespAmmLast", false);
                    component.find("save").set("v.disabled",false);
                }
            }
            else if(currentId=='OB_ServicePointAdminResponsibleEmail')
            {
                if((emailControl)=='ERROR' )
                {
                    $A.util.addClass( component.find(currentId) , 'slds-has-error flow_required');
                    if( validationValue.length>0)
                    {
                        component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageEmailAdminResp" , $A.get("$Label.c.EmailNotValid"))  ;
                    }
                    else
                    {
                        component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageEmailAdminResp" , $A.get("$Label.c.MandatoryField"))  ;
                    }
                    component.set("v.objectDataMap.errorFamily.errorEmailRespAmm", true);
                    component.find("save").set("v.disabled",true);
                }
                else
                {
                    $A.util.removeClass(component.find(currentId) , 'slds-has-error flow_required');
                    component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageEmailAdminResp" , '')  ;
                    component.set("v.objectDataMap.errorFamily.errorEmailRespAmm", false);
                    component.find("save").set("v.disabled",false);
                }
            }
            else if(currentId=='OB_ServicePointAdminResponsibleMobile')
            {
                if((numberControl)=='ERROR')
                {
                    $A.util.addClass( component.find(currentId) , 'slds-has-error flow_required');
                    if( validationValue.length>0)
                    {
                        component.set("v.objectDataMap.errorFamilyMessage.ErrorMessagePhoneAdminResp" ,  $A.get("$Label.c.MinFiveMaxTenDigitLength"))  ;
                    }
                    else
                    {
                        component.set("v.objectDataMap.errorFamilyMessage.ErrorMessagePhoneAdminResp" , $A.get("$Label.c.MandatoryField"))  ;
                    }
                    component.set("v.objectDataMap.errorFamily.errorPhoneRespAmm", true);
                    component.find("save").set("v.disabled",true);
                }
                else
                {
                    $A.util.removeClass(component.find(currentId) , 'slds-has-error flow_required');
                    component.set("v.objectDataMap.errorFamilyMessage.ErrorMessagePhoneAdminResp" , '')  ;
                    component.set("v.objectDataMap.errorFamily.errorPhoneRespAmm", false);
                    component.find("save").set("v.disabled",false);
                }
            }
            //************************************************END___OB_ServicePointAdminResponsible*****************************************

            /**************Start AV 03/01/2019***********FormalCheck on OB_ShopSign - OB_ReceiptHeader__c - OB_ReceiptCity__c ***********************/
            else if(currentId=='OB_ShopSign')
            {
                if((nameControl)=='ERROR' || validationValue == undefined || validationValue == '' || validationValue == null)
                {
                     $A.util.addClass( component.find(currentId) , 'slds-has-error flow_required');
                    if(validationValue!=undefined && validationValue.length>0)
                    {
                        component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageName" ,  $A.get("$Label.c.OB_PresenceOfAnInvalidCharacter"))  ;
                    }
                    else
                    {
                        component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageName" , $A.get("$Label.c.MandatoryField"))  ;
                    }
                    component.set("v.objectDataMap.errorFamily.ErrorNameSign", true);
                    component.find("save").set("v.disabled",true);
                    component.find("closeModalConfirm").set("v.disabled",true);
                }
                else
                {
                    $A.util.removeClass(component.find(currentId) , 'slds-has-error flow_required');
                    component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageName" , '')  ;
                    component.set("v.objectDataMap.errorFamily.ErrorNameSign", false);
                    component.find("save").set("v.disabled",false);
                    component.find("closeModalConfirm").set("v.disabled",false);
                }
            }
            else if(currentId=='OB_ReceiptHeader__c')
            {
                if((nameControl)=='ERROR'  || validationValue == undefined || validationValue == '' || validationValue == null)
                {
                    $A.util.addClass( component.find(currentId) , 'slds-has-error flow_required');
                    if(validationValue!=undefined && validationValue.length>0)
                    {
                        component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageName" ,  $A.get("$Label.c.OB_PresenceOfAnInvalidCharacter"))  ;
                    }
                    else
                    {
                        component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageName" , $A.get("$Label.c.MandatoryField"))  ;
                    }
                    component.set("v.objectDataMap.errorFamily.ErrorNameHeaderReceipt", true);
                    component.find("save").set("v.disabled",true);
                    component.find("closeModalConfirm").set("v.disabled",true);
                }
                else
                {
                    $A.util.removeClass(component.find(currentId) , 'slds-has-error flow_required');
                    component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageName" , '')  ;
                    component.set("v.objectDataMap.errorFamily.ErrorNameHeaderReceipt", false);
                    component.find("save").set("v.disabled",false);
                    component.find("closeModalConfirm").set("v.disabled",false);
                }
            }
            else if(currentId=='OB_ReceiptCity__c')
            {
                if(((nameControl)=='ERROR' ) || validationValue == undefined || validationValue == '' || validationValue == null)
                {
                    $A.util.addClass( component.find(currentId) , 'slds-has-error flow_required');
                    if(validationValue!=undefined && validationValue.length>0)
                    {
                        component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageName" ,  $A.get("$Label.c.OB_PresenceOfAnInvalidCharacter"))  ;
                    }
                    else
                    {
                        component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageName" , $A.get("$Label.c.MandatoryField"))  ;
                    }
                    component.set("v.objectDataMap.errorFamily.ErrorNameCityReceipt", true);
                    component.find("save").set("v.disabled",true);
                    component.find("closeModalConfirm").set("v.disabled",true);
                }
                else
                {
                    $A.util.removeClass(component.find(currentId) , 'slds-has-error flow_required');
                    component.set("v.objectDataMap.errorFamilyMessage.ErrorMessageName" , '')  ;
                    component.set("v.objectDataMap.errorFamily.ErrorNameCityReceipt", false);
                    component.find("save").set("v.disabled",false);
                    component.find("closeModalConfirm").set("v.disabled",false);
                }
            }
        }
        catch(err)
        {
            console.log('err.message e mail: ' + err.message);
        }
    },

        // PRODOB-177 - Doris Dongmo <doris.tatiana.dongmo@accenture.com>, moved modify function to helper, 03/06/2019 - Start

    modify : function(component)
    {
        console.log('modifica');
        var allAreNotEmpty;
        try
        {
            //start 15/04/2019 antonio.vatrano antonio.vatrano@accenture.com shortCut maintenance for referents: add if(!fromShortCutReferents)
            var fromShortCutReferents = component.get("v.fromShortCutReferents");
            if(!fromShortCutReferents)
            {
                var  mobilePhone = component.find("OB_Mobile_Phone_Number__c");
                var  email = component.find("OB_Email__c");
                var  name = component.find("Name");
                var addRespPuntoVend = component.find("addRespPuntoVend"); //NEXI-76 Zuzanna Urban <z.urban@accenture.com> 14/06/2019, add resposible punto vendita
                var  addrespAmm = component.find("addRespAmm");
                var  addRefTech = component.find("addRefTech");
                var  refresh = component.find("refresh");
            }

            component.set("v.status","EDIT");
            //start 15/04/2019 antonio.vatrano antonio.vatrano@accenture.com shortCut maintenance for referents: add if(!fromShortCutReferents)
            let isDisabledRespPuntoVendButton = true; //NEXI-76 Zuzanna Urban <z.urban@accenture.com> 14/06/2019, check Referente button
            let isDisabledRespAmmButton = true; //NEXI-76 Zuzanna Urban <z.urban@accenture.com> 14/06/2019, check Referente button
            let isDisabledRefTechButton = true; //NEXI-76 Zuzanna Urban <z.urban@accenture.com> 14/06/2019, check Referente button
            if(!fromShortCutReferents)
            {
                component.find("OB_Mobile_Phone_Number__c").set("v.disabled", false);
                component.find("OB_Email__c").set("v.disabled", false);
                component.find("Name").set("v.disabled", false);
                //	START 	micol.ferrari 27/12/2018 - IF WE DON'T HAVE THE BUTTON, WE CAN'T SET IT TO DISABLED
                if (typeof component.find("addRespPuntoVend") !== "undefined")
                {
                    component.find("addRespPuntoVend").set("v.disabled",false);
                    isDisabledRespPuntoVendButton = false; //NEXI-76 Zuzanna Urban <z.urban@accenture.com> 14/06/2019, check Referente button
                }
                if (typeof component.find("addRespAmm") !== "undefined")
                {
                    component.find("addRespAmm").set("v.disabled",false);
                    isDisabledRespAmmButton = false; //NEXI-76 Zuzanna Urban <z.urban@accenture.com> 14/06/2019, check Referente button
                }
                if (typeof component.find("addRefTech") !== "undefined")
                {
                    component.find("addRefTech").set("v.disabled",false);
                    isDisabledRefTechButton = false; //NEXI-76 Zuzanna Urban <z.urban@accenture.com> 14/06/2019, check Referente button
                }
                //	END 	micol.ferrari 27/12/2018
            }
            //end 15/04/2019 antonio.vatrano antonio.vatrano@accenture.com shortCut maintenance for referents
            component.set("v.isToSave",true);
            // Start antonio.vatrano 04/04/2019 skip referents if from shortcut
            // Start antonio.vatrano 16/04/2019 enable input only of context contact
            //NEXI-195 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 11/07/2019 Delete field disabling
        }
        catch(err)
        {
            console.log('CATCH ERROR MODIFY: ' + err.message);
        }
    },

    // PRODOB-177 - Doris Dongmo <doris.tatiana.dongmo@accenture.com>, moved modify function to helper, 03/06/2019 - End
    /**
    * @author Zuzanna Urban
    * @task NEXI-75
    * @date 30/05/2019
    * @description Set RespPv fields empty
    * @history 30/05/2019 <z.urban@accenture.com> created
    **/
    emptyRespPv : function( component )
    {
		component.find( "OB_ServicePointResponsibleFirstName" ).set( "v.value", '' );
        component.set( "v.objectDataMap.errorFamilyMessage.ErrorMessageNameResp", '' );
		component.find( "OB_ServicePointResponsibleLastName").set( "v.value", '' );
        component.set( "v.objectDataMap.errorFamilyMessage.ErrorMessageLastNameResp" , '' );
		component.find( "OB_ServicePointResponsibleEmail").set( "v.value",'');
        component.set( "v.objectDataMap.errorFamilyMessage.ErrorMessageEmailResp", '' );
		component.find( "OB_ServicePointResponsibleMobile").set( "v.value", '' );
        component.set( "v.objectDataMap.errorFamilyMessage.ErrorMessagePhoneResp" , '' );
    },

    /**
    * @author Zuzanna Urban
    * @task NEXI-75
    * @date 30/05/2019
    * @description Set RefTech fields empty
    * @history 30/05/2019 <z.urban@accenture.com> created
    **/
     emptyRefTech : function( component )
     {
		component.find( "OB_TechnicalReferentFirstName" ).set( "v.value", '' );
        component.set( "v.objectDataMap.errorFamilyMessage.ErrorMessageNameTechRef" , '' );
		component.find( "OB_TechnicalReferentLastName" ).set( "v.value", '' );
        component.set( "v.objectDataMap.errorFamilyMessage.ErrorMessageLastNameTechRef" , '' );
		component.find( "OB_TechnicalReferentEmail" ).set( "v.value",'' );
        component.set( "v.objectDataMap.errorFamilyMessage.ErrorMessageEmailTechRef" , '' );
		component.find( "OB_TechnicalReferentMobile" ).set("v.value",'' );
        component.set( "v.objectDataMap.errorFamilyMessage.ErrorMessagePhoneTechRef" , '') ;
     },
    /**
    * @author Zuzanna Urban
    * @task NEXI-75
    * @date 30/05/2019
    * @description Set RespAmm fields empty
    * @history 30/05/2019 <z.urban@accenture.com> created
    **/
     emptyRespAmm : function( component )
     {
		component.find( "OB_ServicePointAdminResponsibleFirstName" ).set( "v.value",'' );
        component.set( "v.objectDataMap.errorFamilyMessage.ErrorMessageNameAdminResp" , '' );
		component.find( "OB_ServicePointAdminResponsibleLastName" ).set( "v.value",'' );
        component.set( "v.objectDataMap.errorFamilyMessage.ErrorMessageLastNameAdminRes" , '' );
		component.find( "OB_ServicePointAdminResponsibleEmail" ).set( "v.value",'');
        component.set( "v.objectDataMap.errorFamilyMessage.ErrorMessageEmailAdminResp" , '' );
		component.find( "OB_ServicePointAdminResponsibleMobile" ).set( "v.value",' ');
     },

     /**
     * @author Joanna Mielczarek
     * @task NEXI-81
     * @date 07/06/2019
     * @params component, wasAnnulled
     * @description Method clear all attributes related to mcc modal
     * @history 07/06/2019 <joanna.mielczarek@accenture.com> created
     **/
    clearMCCModal: function ( component, wasAnnulled )
    {
        component.set( "v.selectedMCCL2", "" );
        component.set( "v.selectedMCCL3", "" );
        component.set( "v.level", "" );
        component.set( "v.isChecked", false );
        component.set( "v.isDisabled", true );
        if ( wasAnnulled )
        {
            this.setOldMCCValue( component, component.get( "v.ListOfServicePoint" ) ); // NEXI-212 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 16/07/2019 setting old value
        }
    },

    /**
    * @author Joanna Mielczarek
    * @task NEXI-81
    * @date 10/06/2019
    * @params mccCode, mccDescription
    * @return String
    * @description Method concats the mcc value to display proper value in table
    * @history 10/06/2019 <joanna.mielczarek@accenture.com> created
    **/
    setMCCvalue : function ( mccCode, mccDescription )
    {
        return !$A.util.isEmpty( mccCode ) ? mccCode + ' - ' + mccDescription : mccDescription;
    },

    /**
    * @author Joanna Mielczarek
    * @task NEXI-81
    * @date 12/06/2019
    * @params component, selectedRows
    * @description Method sets value of old MCC codes to MCCL2input / MCCL3input
    * @history 12/06/2019 <joanna.mielczarek@accenture.com> created
               10/07/2019 Joanna Mielczarek <joanna.mielczarek@accenture.com> modified - NEXI-176 - update logic
               16/07/2019 Joanna Mielczarek <joanna.mielczarek@accenture.com> modified - NEXI-212 - update logic
    **/
    setOldMCCValue : function ( component, selectedRows )
    {
        for ( let loopRow of selectedRows )
        {
            let mccL2 = loopRow.OB_MCCL2__c;
            let mccL3 = loopRow.OB_MCC__c;

            let splittedMCCL2 = '';
            if ( mccL2.includes( "-" ) )
            {
                splittedMCCL2 = mccL2.split( "- " )[1];
            }
            else
            {
                this.setMCCDescription( loopRow, component.get( "v.mccL2" ), 'OB_MCCL2__c' );
                splittedMCCL2 = loopRow.OB_MCCL2__c.split( "- " )[1];
            }

            let splittedMCCL3 = '';
            if ( mccL3.includes( "-" ) )
            {
                splittedMCCL3 = mccL3.split( "- " )[1];
            }
            else
            {
                this.setMCCDescription( loopRow, component.get( "v.mccL3" ), 'OB_MCC__c' );
                splittedMCCL3 =  loopRow.OB_MCC__c.split( "- " )[1];
            }

            component.set( "v.MCCL2input", !$A.util.isEmpty( splittedMCCL2 ) ? splittedMCCL2 : "" );
            component.set( "v.MCCL2oldValue", !$A.util.isEmpty( splittedMCCL2 ) ? splittedMCCL2 : "" );

            component.set( "v.MCCL3input", !$A.util.isEmpty( splittedMCCL3 ) ? splittedMCCL3 : "" );
            component.set( "v.MCCL3oldValue", !$A.util.isEmpty( splittedMCCL3 ) ? splittedMCCL3 : "" );
        }
    },

    /**
    * @author Joanna Mielczarek
    * @task NEXI-176
    * @date 10/07/2019
    * @params servicePoints, lovs, field
    * @description Method sets value and description for MCC
    * @history 10/07/2019 <joanna.mielczarek@accenture.com> created
    *          16/07/2019 Joanna Mielczarek <joanna.mielczarek@accenture.com> modified - NEXI-212 - update logic
    **/
    setMCCDescription : function ( servicePoint, lovs, field )
    {
        for( let loopLov of lovs )
        {
            let mccL2 = '';
            let mccL3 = '';
            if ( field == 'OB_MCCL2__c' )
            {
                mccL2 = servicePoint.OB_MCCL2__c;
                if ( mccL2 == loopLov[ 'OB_Value4__c' ] ||  mccL2 == loopLov[ 'NE__Value2__c' ] )
                {
                    servicePoint.OB_MCCL2__c = mccL2 + ' - ' + loopLov['Name'];
                    return;
                }
            }

            if ( field == 'OB_MCC__c' )
            {
                mccL3 = servicePoint.OB_MCC__c;
                if ( mccL3 == loopLov[ 'NE__Value2__c' ]  )
                {
                    servicePoint.OB_MCC__c = mccL3 + ' - ' + loopLov['Name'];
                    return;
                }
            }
        }
    },

    //NEXI-110 24.06.2019 damian.krzyzaniak@accenture.com START - copied logic from controller and added modification to reset fields after dechecking checkboxes
    writableShopSign: function(component, event, helper)
    {
        console.log(component.find("ShopSignCheck").get("v.checked"));

        if(component.find("ShopSignCheck").get("v.checked"))
        {
            component.find("OB_ShopSign").set("v.disabled", false );
            component.set('v.objectDataMap.errorFamily.ErrorNameSign',false);
            component.set('v.objectDataMap.esm.OB_ShopSign__c','');
            $A.util.removeClass(component.find("OB_ShopSign") , 'slds-has-error flow_required');
        }
        else
        {
            component.find("OB_ShopSign").set("v.disabled", true );
            component.set('v.objectDataMap.esm.OB_ShopSign__c','');
        }
    },

    writableShopSignHeader: function(component, event, helper){
        if(component.find("ShopSignHeaderCheck").get("v.checked"))
        {
            component.find("OB_ReceiptHeader__c").set("v.disabled", false);
            component.set('v.objectDataMap.errorFamily.ErrorNameHeaderReceipt',false);
            component.set('v.objectDataMap.esm.OB_ReceiptHeader__c','');
            $A.util.removeClass(component.find("OB_ReceiptHeader__c") , 'slds-has-error flow_required');
        }
        else
        {
            component.find("OB_ReceiptHeader__c").set("v.disabled", true);
            component.set('v.objectDataMap.esm.OB_ReceiptHeader__c','');
        }
    },

    writableShopSignCity : function(component, event, helper)
    {
        if(component.find("ShopSignCityCheck").get("v.checked"))
        {
            component.find("OB_ReceiptCity__c").set("v.disabled", false);
            component.set('v.objectDataMap.esm.OB_ReceiptCity__c','');
            component.set('v.objectDataMap.errorFamily.ErrorNameCityReceipt',false);
            $A.util.removeClass(component.find("OB_ReceiptCity__c") , 'slds-has-error flow_required');
        }
        else
        {
            component.find("OB_ReceiptCity__c").set("v.disabled", true);
            component.set('v.objectDataMap.esm.OB_ReceiptCity__c','');
        }
    },
    //NEXI-110 24.06.2019 damian.krzyzaniak@accenture.com STOP

    /**
    * @author Wojciech Szuba
    * @task NEXI-180
    * @date 10/07/2019
    * @description Method allows user to change value of Settlement Method
    **/
    writableSettlementMethod: function(component, event, helper){
        if(component.find("InternationalSettlementMethodCheck").get("v.checked"))
        {
            component.find("OB_InternationalSettlementMethod__c").set("v.disabled", false );
            component.set('v.objectDataMap.errorFamily.ErrorNameSign',false);
            component.set('v.objectDataMap.esm.OB_InternationalSettlementMethod__c','');
            $A.util.removeClass(component.find("OB_InternationalSettlementMethod__c") , 'slds-has-error flow_required');
        }
        else
        {
            component.find("OB_InternationalSettlementMethod__c").set("v.disabled", true );
            component.set('v.objectDataMap.esm.OB_InternationalSettlementMethod__c','');
        }
    }
})