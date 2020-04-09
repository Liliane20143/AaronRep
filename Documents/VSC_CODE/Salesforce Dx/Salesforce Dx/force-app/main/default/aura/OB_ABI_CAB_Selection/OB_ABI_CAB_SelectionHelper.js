({
    doInitHelper : function(component, event, helper) {
        console.log('-- Inside DoInit of OB_ABI_CAB_Selection --');
        //davide.franzini - WN-406 - 13/09/2019 - START
        if(component.get("v.objectDataMap.isOperation")){
            component.set("v.objectDataMap.bank", {});
        }
        //davide.franzini - WN-406 - 13/09/2019 - END 
        component.set("v.objectDataMap.isCommunityUser", false);
        component.set("v.objectDataMap.abiError",'false');//elena.preteni 17/07/2019 show error when abi not selected F3 abi cab selection
        
        var action = component.get("c.getUserInformation");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                try {
                    /*
                IF:
                    1. OPERATION                        --> SELECT ABI AND SELECT CAB 
                    2. APPROVER L1 OR Nexi Partner User   --> SELECT ONE CAB
                    3. APPROVER L2                       --> SELECT ONE CAB FROM LIST[FROM USER.OB_CAB__c] --> OB_CAB__c = '12345;23456;56780;'
                    4. APPROVER L3                       --> SELECT ABI AND SELECT CAB [FROM LOV]
                */

                    var userInformation = response.getReturnValue();


                    console.log('## userInformation is : ' + JSON.stringify(userInformation));
                    
                    // ANDREA MORITTU START 2019.05.09 ID_Stream_6_Subentro
                    var takeoverProcess = false;
                    var oldWrapperInformation = component.get("v.oldWrapperInformation");
                    console.log('  : ' + JSON.stringify(oldWrapperInformation));
                    if(!$A.util.isUndefinedOrNull(oldWrapperInformation) && !$A.util.isEmpty(oldWrapperInformation.draggedAsset.OB_Takeover_CAB__c)) {
                        takeoverProcess = true;
                    }
                    // ANDREA MORITTU END 2019.05.09    ID_Stream_6_Subentro 
                            component.set("v.objectDataMap.isOperation", userInformation.isOperation);//RP_015 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 05/04/2019
                            if(userInformation.isOperation)  {
                                console.log('## I\'M OPERATION_USER: ' );
                                component.set("v.hideFields", false);

                                component.set("v.objectDataMap.isCommunityUser", false);
                                component.set("v.CABnature", 'LOV');//RP_015 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 05/04/2019
                                //START - elena.preteni 11/07/2019 Fase 3 Setup from operation hide cabb default value 99999
                                component.set("v.showCAB", false);

                                //END - elena.preteni 11/07/2019 Fase 3 Setup from operation hide cabb default value 99999
                            }
                            if(userInformation.isPartner)  {
                                console.log('## ## I\'M PARTNER_USER: ' );
                                if(!$A.util.isUndefined(userInformation.CABnature)) {
                                    //IF PROFILE IS L1
                                    if(userInformation.CABnature == 'singleCAB') {
                                        component.set("v.showABI", false);
                                        component.set("v.CABnature", userInformation.CABnature);
                                    }
                                    //IF PROFILE IS L2 (MULTI CAB)
                                    else if(userInformation.CABnature == 'multiCAB')  {
                                        component.set("v.showABI", false);
                                        component.set("v.CABnature", userInformation.CABnature);
                                        console.log('## multicab is: ' + userInformation.CAB);
                                        if(userInformation.CAB.length > 1) {
                                            console.log('## THE OB_CAB__c is a list: ' + userInformation.CAB );
                                            component.set("v.hideFields", false);
                                            component.set("v.disabledABI", true);
                                            component.set("v.CABList", userInformation.CAB);
                                            console.log('v.CABLis is : ' + component.get("v.CABList"));
                                            component.set("v.ABIValue", userInformation.ABI);
                                            console.log('##ABI VALUE DO IIT IS: ' +  component.get("v.ABIValue"));
                                            
                                        /*
                                        IF IIN THE LIST THERE'S ONLY ONE CAB, SET IT INTO OBJECT DATA MAP
                                        */
                                        } else if(userInformation.CAB.length == 1) {
                                            component.set("v.showFiscalCodeSection", true);
                                            component.set("v.CABList", userInformation.CAB);
                                            component.set("v.objectDataMap.bank.OB_CAB__c", userInformation.CAB[0]);
                                            console.log('v.CABLis is : ' + component.get("v.CABList"));
                                            component.set("v.hideFields", false);
                                            component.set("v.disabledABI", true);
                                            component.set("v.ABIValue", userInformation.ABI);
                                            component.set("v.objectDataMap.user.OB_CAB__c", userInformation.CAB[0]);
                                            component.set("v.objectDataMap.bank.OB_CAB__c", userInformation.CAB[0]);
                                            component.set("v.disabledCAB", true);
                                            component.set("v.correctABI", true);
                                            component.set("v.correctCAB", true);
                                            component.set("v.showFiscalCodeSection", true);
                                            //(v.correctABI, v.correctCAB)
                                            component.set("v.showCAB", false);
                                            
                                        }
                                    //IF PROFILE IS L3 (NO CAB) 
                                    } else if(userInformation.CABnature == 'LOV') {
                                        component.set("v.CABnature", userInformation.CABnature);
                                        component.set("v.hideFields", false);
                                    
                                        console.log('userInformation is : ', userInformation );

                                        component.set("v.disabledABI", true);
                                        component.set("v.ABIValue", userInformation.ABI);

                                        component.set("v.showFiscalCodeSection", true);
                                        //(v.correctABI, v.correctCAB)
                                        component.set("v.showCAB", true);
                                        component.set("v.showABI", false);
                                        

                                    }
                                }
                                
                                component.set("v.isCommunityUser", true);
                                component.set("v.objectDataMap.isCommunityUser", true);
                                component.set("v.objectDataMap.user.OB_ABI__c", userInformation.ABI);
                                component.set("v.objectDataMap.bank.OB_ABI__c", userInformation.ABI);
                                
                                component.set("v.objectDataMap.bankOwner" , userInformation.bankProfile.bankOwner);
                                component.set("v.objectDataMap.actualBank", userInformation.bankProfile.actualBank);    //davide.franzini - 29/07/2019 - WN-212
                                component.set("v.objectDataMap.GT"        , userInformation.bankProfile.GT); 

                                component.set("v.bankId", userInformation.bankProfile.bankOwner );

                                if(userInformation.CAB.length > 1) {
                                    console.log('## userInformation.OB_CAB__c.length is major than 1: ' );
                                    component.set("v.hideFields", false);
                                    component.set("v.disabledABI", true);
                                }
                                //antonio.vatrano 29/04/2019 r1f2-49 99999 is new cab for L3, add condition in if
                                if(userInformation.CAB.length == 1 &&  userInformation.CABnature != 'LOV') {
                                    component.set("v.showFiscalCodeSection", true);
                                    component.set("v.objectDataMap.bank.OB_CAB__c", userInformation.CAB[0]);
                                    component.set("v.objectDataMap.user.OB_CAB__c", userInformation.CAB[0]);//RP_015 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 03.04.2019
                                    component.set("v.objectDataMap.correctCAB", true);//RP_015 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 03.04.2019
                                }
                                component.set("v.objectDataMap.bankProfile", userInformation.bankProfileObject );
                                var objectDataMap = !$A.util.isEmpty(component.get("v.objectDataMap") ) ? component.get("v.objectDataMap") : null ;
                                console.log('OBJECT DATA MAP INSIDE OB_ABI_CAB_Selection : ' +  JSON.stringify(objectDataMap));

                                var isCommEvent =  component.getEvent('OB_isCommunityAttributeEvent');
                                isCommEvent.setParams({
                                    "isCommunityUserEvt" :  component.get("v.objectDataMap.isCommunityUser")});
                                isCommEvent.fire();

                                if((takeoverProcess)) {
                                    component.set("v.showFiscalCodeSection", true);
                                    component.set("v.objectDataMap.user.OB_CAB__c", oldWrapperInformation.draggedAsset.OB_Takeover_CAB__c);
                                    component.set("v.objectDataMap.bank.OB_CAB__c", oldWrapperInformation.draggedAsset.OB_Takeover_CAB__c);
                                    component.set("v.disabledCAB", true);
                                    component.set("v.correctABI", true);
                                    component.set("v.correctCAB", true);
                                    component.set("v.showCAB", false);
                                }
                            }
                
                } catch(exc) {
                    console.log('ERROR ON ABI_CAB_Selection; Error is : ' + exc.message)
                }
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

    setABIAttributesForModal: function(component, event)
    {
        
        var objectDataMap = component.get("v.objectDataMap");

        var mapLabelColumns =
        {
            "Name":  $A.get("$Label.c.ABI"),
            "NE__Value1__c" : $A.get("$Label.c.OB_Bank")
        };
        var objectString = 'bank'; //oggetto target -- da definire
        var type = 'ABI';
        var subType = '';
        var input = component.get("v.objectDataMap.bank.OB_ABI__c");
        var mapOfSourceFieldTargetField  = {};
        mapOfSourceFieldTargetField.OB_ABI__c = 'Name';
        var messageIsEmpty = '';
        var orderBy= 'Name';
        this.createModalforABI(component, objectString, type, subType, input, mapOfSourceFieldTargetField, mapLabelColumns, messageIsEmpty, orderBy  );    
    },

    createModalforABI : function(component, objectString, type, subType, input, mapOfSourceFieldTargetField, mapLabelColumns, messageIsEmpty, orderBy)
    {
        console.log('## INSIDE OB_ABI_CABSELECTIONCREATECOMPONENT');
        $A.createComponent(
            "c:modalLookupWithPagination",
            {
                "aura:id":      "modal",
                "objectString": objectString,
                "type":         type,
                "subType":      subType,
                //merchant or bank????
                "input":        input,
                "mapOfSourceFieldTargetField":mapOfSourceFieldTargetField,
                "mapLabelColumns":mapLabelColumns,
                "objectDataMap":component.get("v.objectDataMap"),
                "messageIsEmpty":messageIsEmpty,
                "orderBy":orderBy,
                "inputFieldForLike": "Name"
            },
            function(newModal, status, errorMessage)
            {
                if (status === "SUCCESS")
                {
                    console.log('### SETTING INTO BODY');
                    var body = component.get("v.body");
                    body.push(newModal);
                    component.set("v.body", body);
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
    },
    
    checkABI: function (component, event, value)
    {
        console.log("checkABI");
        console.log("value input ABI: " + value);
        var action = component.get("c.searchABIbyInputValue");
        action.setParams({ value : value });
        action.setCallback(this, function(response)
        {
            var state = response.getState();
            if (state === "SUCCESS")
            {
                if(response.getReturnValue() != null)
                {
                    console.log("ABI: correct!");
                    component.set("v.correctABI", true);//SHOW GREEN CHECK
                    component.set("v.objectDataMap.bank.OB_ABI__c", response.getReturnValue());
                    component.set("v.disabledABI", true);
                    // START - elena.preteni 11/07/2019 Fase 3 Setup from operation hide cab default value 99999
                    if( component.get("v.objectDataMap.isOperation")){
                        component.set("v.objectDataMap.user.OB_CAB__c", '99999');
                        component.set("v.objectDataMap.user.OB_ABI__c", response.getReturnValue());
                        component.set("v.showFiscalCodeSection", true);
                        component.set("v.correctCAB", true);
                    }
                    // END - elena.preteni 11/07/2019 Fase 3 Setup from operation hide cab default value 99999
                    //REMOVE ERROR MESSAGE AND RED BORDER
                    console.log("ABI AFTER CHECK--> " + value);
                    if(value != '' && value!=null)
                    {
                        if(document.getElementById('errorIdABI'))
                        {
                            console.log("INTO CHECK ABI METHOD");
                            var errorMessage = document.getElementsByClassName('messageErrorABI').length;
                            try
                            {
                                $A.util.removeClass(componenABIValuet.find('ABI') , 'slds-has-error flow_required');
                                //REMOVE ERROR MESSAGE MORE THAN ONCE BECAUSE THERE ARE 9 MESSAGE  OVERLAPPING
                                for(var i=0 ; i<errorMessage ; i++)
                                {
                                    document.getElementById('errorIdABI').remove();
                                }
                                console.log("success delete");
                            }
                            catch(err)
                            {
                                console.log('ABI err.message: ' + err.message);
                            }
                        }
                    }
                }
                else
                {
                    console.log("wrong ABI!");
                }
            }
            else if (state === "INCOMPLETE")
            {
                // do something
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
        $A.enqueueAction(action);
    },

    checkCAB: function (component, event, value)
    {
        console.log("checkCAB");
        console.log("value input CAB: " + value);
        var action = component.get("c.searchCABbyInputValue");
        action.setParams(
        {
            value : value,
            abi : component.get("v.objectDataMap.bank.OB_ABI__c")
        });
        action.setCallback(this, function(response)
        {
            var state = response.getState();
            if (state === "SUCCESS")
            {
                var res = response.getReturnValue();                    //davide.franzini - 29/07/2019 - WN-212
                if(res.CAB.length > 0)
                {
                    console.log("CAB: correct!");
                    component.set("v.correctCAB", true);   //set the green check if cab is correct
                    component.set("v.disabledCAB" , true);//disable cab input if it is correct
                    //davide.franzini - 29/07/2019 - WN-212 - START
                    for(var i= 0; i<res.CAB.length; i++)
                    {
                        component.set("v.objectDataMap.user.OB_CAB__c", res.CAB[i]);
                        component.set("v.objectDataMap.user.OB_ABI__c", res.ABI);
                        component.set("v.objectDataMap.bank.OB_ABI__c", res.ABI);
                        component.set("v.objectDataMap.bank.OB_CAB__c", res.CAB[i]);
                        component.set("v.objectDataMap.bankProfile", res.bankProfileObject);
                        component.set("v.objectDataMap.bankOwner", res.bankProfile.bankOwner);
                        component.set("v.objectDataMap.actualBank", res.bankProfile.actualBank);
                        component.set("v.objectDataMap.GT", res.bankProfile.GT);
                        component.set("v.objectDataMap.OrderHeader.OB_NDG__c", null);
                        console.log("## ObjectDataMap after set: ", JSON.stringify(component.get("v.objectDataMap")));
                    //davide.franzini - 29/07/2019 - WN-212 - END
                        component.set("v.correctABI" , true);
                        component.set("v.disabledABI", true);//disable abi input if cab  is correct
                        if(value != '' && value!=null)
                        {
                        
                            if(document.getElementById('errorIdCAB'))
                            {
                                var errorMessage = document.getElementsByClassName('messageErrorCAB').length;
                                try
                                {
                                    $A.util.removeClass(component.find('CAB') , 'slds-has-error flow_required');
                                    //REMOVE ERROR MESSAGE MORE THAN ONCE BECAUSE THERE ARE 9 MESSAGE  OVERLAPPING
                                    for(var i=0 ; i<errorMessage ; i++)
                                    {
                                        document.getElementById('errorIdCAB').remove();
                                    }
                                    console.log("success delete");
                                }
                                catch(err)
                                {
                                    console.log('CAB err.message: ' + err.message);
                                }
                            }
                        }
                    }
                }
                else
                {
                    console.log("wrong CAB!");
                }
            }
            else if (state === "INCOMPLETE")
            {
                // do something
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
        $A.enqueueAction(action);
    },

    //Francesca: setting cab search attributes for modalLookupWithPagination.cmp
    setModalAttributesCAB: function(component)
    {
        var cabNature = component.get("v.CABnature");
        console.log('## cabNature is : ' + cabNature);
            /*
            ---------------------------------------------------
            IF IT'S SINGLE CAB, FIRE THE APEX MODAL FOR L1 PROFILE
            ---------------------------------------------------
            */
          
           if(!$A.util.isUndefined(cabNature)) {
                /*
                ---------------------------------------------------
                FINAL ATTRIBUTES USED TO CREATE MODAL
                ---------------------------------------------------
                */
               var type = 'CAB';
               var mapOfSourceFieldTargetField  = {};
               mapOfSourceFieldTargetField.OB_CAB__c = 'Name';
               mapOfSourceFieldTargetField.OB_ABI__c = 'NE__Value1__c';
            if(cabNature == 'singleCAB') {
                console.log("INTO OPEN MODAL CAB");
                component.set("v.searchABI", false);
                component.set("v.spinner", true); 
                var objectDataMap = component.get("v.objectDataMap");

                var mapLabelColumns =
                {
                    "Name":  $A.get("$Label.c.CAB")
                };
                //RP_015 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 14.01.2019 Remove "NE__Value2__c" : $A.get("$Label.c.OB_Bank") from column definition
                var objectString = 'user'; //oggetto target -- da definire
               ;
                var subType = '';
                var input = component.get("v.objectDataMap.user.OB_CAB__c");
               
                var messageIsEmpty = '';
                var orderBy= 'Name';
                this.createModalCAB(component, objectString, type, subType, input, mapOfSourceFieldTargetField, mapLabelColumns, messageIsEmpty, orderBy);
            } 
            
            else if(cabNature == 'multiCAB') {
                /*
            ---------------------------------------------------
            IF IT'S MULTI CAB, FIRE THE CAB MODAL FROM USER CAB FIELD () MODAL FOR L2 PROFILE)
            ---------------------------------------------------
            
            */
                var cabListToStringify = component.get("v.CABList");
                console.log(cabListToStringify);
                var finalCABString = '';
                if(!$A.util.isEmpty(cabListToStringify)) {
                    if(cabListToStringify.length > 1) {
                        for( var singleCAB in cabListToStringify ) {
                            finalCABString +=  cabListToStringify[singleCAB]+';';
                        }
                    } else if(cabListToStringify.length == 0) {
                        finalCABString += cabListToStringify[0]+';';
                    }
                }
                console.log('finalCABString is: ' + finalCABString);
                
                console.log("INTO OPEN MODAL CAB");
                component.set("v.searchABI", false);
                component.set("v.spinner", true); 
                var objectDataMap = component.get("v.objectDataMap");

                var mapLabelColumns =
                {
                    "Name":  $A.get("$Label.c.CAB")
                };
                //RP_015 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 14.01.2019 Remove "NE__Value2__c" : $A.get("$Label.c.OB_Bank") from column definition
                var objectString = 'user'; //oggetto target -- da definire
                var type = 'CAB';
                var subType = 'Tipologiche';
                var ABIValue = component.get("v.ABIValue");
                console.log('ABIValue is . ' + ABIValue);
                var cabStringValues = finalCABString;
                var searchLovs = false;
                var input =component.find('CAB').get('v.value'); // antonio.vatrano 03/05/2019  R1F2-85
                //component.get("v.CABList");
                var mapOfSourceFieldTargetField  = {};
                mapOfSourceFieldTargetField.OB_CAB__c = 'Name';
                mapOfSourceFieldTargetField.OB_ABI__c = 'NE__Value1__c';
                var messageIsEmpty = '';
                var orderBy= 'Name';
                this.createModalCAB(component, objectString, type, subType, input, mapOfSourceFieldTargetField, mapLabelColumns, messageIsEmpty, orderBy, ABIValue, searchLovs, cabStringValues);
            }
                /*
            ---------------------------------------------------
            IF IT'S MULTI CAB, FIRE THE CAB MODAL FROM LOV () MODAL FOR L3 PROFILE)
            ---------------------------------------------------
            */
            else if(cabNature == 'LOV') {
                var cabListToStringify = component.get("v.CABList");
                console.log(cabListToStringify);
                var finalCABString = '';
                console.log('finalCABString is: ' + finalCABString);
                
                console.log("INTO OPEN MODAL CAB");
                component.set("v.searchABI", false);
                component.set("v.spinner", true); 
                var objectDataMap = component.get("v.objectDataMap");

                var mapLabelColumns =
                {
                    "Name":  $A.get("$Label.c.CAB")
                };
                //RP_015 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 14.01.2019 Remove "NE__Value2__c" : $A.get("$Label.c.OB_Bank") from column definition
                var objectString = 'user'; //oggetto target -- da definire
                var type = 'CAB';
                var subType = 'Tipologiche';
                var ABIValue = component.get("v.ABIValue");
                //RP_015 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 05/04/2019 Start
                if(String(objectDataMap.isOperation) == 'true')
                {
                    ABIValue = objectDataMap.bank.OB_ABI__c;
                }
                //RP_015 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 05/04/2019 Stop
                var cabStringValues = '';
                var searchLovs = false;
                var input =component.find('CAB').get('v.value'); // antonio.vatrano 03/05/2019  R1F2-85
                //component.get("v.CABList");
                var mapOfSourceFieldTargetField  = {};
                mapOfSourceFieldTargetField.OB_CAB__c = 'Name';
                mapOfSourceFieldTargetField.OB_ABI__c = 'NE__Value1__c';
                var messageIsEmpty = '';
                var orderBy= 'Name';
                this.createModalCAB(component, objectString, type, subType, input, mapOfSourceFieldTargetField, mapLabelColumns, messageIsEmpty, orderBy, ABIValue, searchLovs, cabStringValues);
            }
        }        
    },

    createModalCAB : function(component, objectString, type, subType, input, mapOfSourceFieldTargetField, mapLabelColumns, messageIsEmpty, orderBy, ABIValue, searchLovs, cabStringValues)
    {
        console.log("INTO HELPER METHOD OF MODAL 2");
        console.log('###ABI VALUE INSIDE CREATE MODAL IS : ' + ABIValue);
        var subType = subType;
        console.log("subtype: " + JSON.stringify(subType));
        var subTypeField = '';
        subTypeField ='NE__value1__c';
        component.set("v.subTypeField", subTypeField);
        $A.createComponent(
            "c:modalLookupWithPagination",
            {
                "aura:id": "modal",
                "objectString":objectString,
                "type":type,
                "subType":subType,
                "input":input,
                "mapOfSourceFieldTargetField":mapOfSourceFieldTargetField,
                "mapLabelColumns":mapLabelColumns,
                "objectDataMap":component.get("v.objectDataMap"),
                "messageIsEmpty":messageIsEmpty,
                "orderBy":orderBy,
                "inputFieldForLike": component.get("v.inputFieldForLike"),
                "subTypeField":component.get("v.subTypeField"),
                "ABIvalue" :         ABIValue,
                "searchLovs" :       searchLovs,
                "cabStringValues" :   cabStringValues      
            },
            function(newModal, status, errorMessage){
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

    /**
    -----------------------------------------------------------------------------
    GET CAB VALUES FROM CAB MODAL SELECTION 
    */
    getCABelectionValueHelper : function(component, event, helper) {
        var currentCheckValue = event.getSource().get("v.value");
        var objectDataMap = component.get("v.objectDataMap");
        var listToUpdate =  component.get("v.CABList");

        var isChecked = event.getSource().get("v.checked");
        console.log('## isChecked  is : ' + isChecked);
        
        var filterInputCAB = !$A.util.isUndefined(component.find("CABFilter"))?component.find("CABFilter").get("v.value") : null;
        if($A.util.isEmpty(filterInputCAB)) {
            console.log('##filterInputCAB isNOT EMPTY ');
            for(var singleModalValue in listToUpdate) {
                
                if(filterInputCAB.contains(listToUpdate[singleModalValue]) ) {
                    console.log('##filterInputCAB is : ' +  filterInputCAB);
                }
            }
        }

        if(isChecked) {
            if(!$A.util.isUndefined(currentCheckValue)) {
                console.log('## currentCheckValue is : ' + currentCheckValue);
                component.set("v.objectDataMap.user.OB_CAB__c", currentCheckValue);
                if(!$A.util.isEmpty(objectDataMap.user.OB_CAB__c)) {
                    component.set("v.showModalFromCabFieldUser", false);
                }
            }
        }
    },

    /**
     *@author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
     *@date 03/04/2019
     *@task RP_015
     *@description Method show error when validation on next return false
     *@history 03/04/2019 Method created
     */
    showError : function(component)
    {
        let isCabEmpty = component.get("v.objectDataMap.cabError");
        if(String(isCabEmpty) == 'true')
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams
            ({
                "title": '',
                "message": component.get("v.objectDataMap.cabErrorMessage"),
                "type": 'error'
            });
            toastEvent.fire();
            component.set("v.objectDataMap.cabError",false);
        }
    }

})