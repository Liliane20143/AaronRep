({
    /*------------------------------------------------------------
    Author:        Daniele Gandini
    Company:       Accenture Tecnology
    Description:   doInit Method: did a replacement/not replacement logic in the init method because of the component shoul be used in different stream
    Date:          09/05/2019
   ------------------------------------------------------------*/
    initHelper : function(component, event, helper) {
        console.log("in doinit method");
        var isReplacement = component.get("v.objectDataMap.isReplacement");
        var isOperationLogged = component.get("v.isOperationLogged");
        var itemsInRemove = component.get("v.itemsInRemove");
        var isModificaOfferta = component.get("v.isModificaOfferta");
        // if(isReplacement){
        if(isReplacement && isOperationLogged){
            var dateNow = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
            component.set("v.objectDataMap.Configuration.OB_RequestDate__c", dateNow);
            this.loadPetitionerOptions(component, event, helper);
        }
        if(!isReplacement){
            this.loadUnistallationProcedure(component, event, helper);
        }
        if(isModificaOfferta && itemsInRemove){
            var dateNow = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
            component.set("v.objectDataMap.Configuration.OB_RequestDate__c", dateNow);
            this.loadPetitionerOptions(component, event, helper);
            this.loadUnistallationProcedure(component, event, helper);
        }
    },

    loadPetitionerOptions: function (component, event, helper) {
        console.log("in pettitioners load methos");
        var action = component.get("c.getFieldValuesForPetitioner");
        action.setCallback(this, function(response)
        {
            var state = response.getState();
            if (state === "SUCCESS")
            {
                var  tempMap =[];
                var  responseMap= response.getReturnValue();
                for(var key in responseMap)
                {
                    tempMap.push({value:responseMap[key], key:key});
                }
                component.set( "v.petitioners",  tempMap);
                component.set( "v.objectDataMap.Configuration.OB_Petitioner__c",  tempMap[0].key);
                console.log("Value of picklist selectedPetitioner: "+component.get("v.objectDataMap.Configuration.OB_Petitioner__c"));
            }
            else if (state === "INCOMPLETE")
            {
				_utils.debug("INCOMPLETE");
            }
            else if (state === "ERROR")
            {
                    var errors = response.getError();
                    if (errors)
                    {
                        if (errors[0] && errors[0].message)
                        {
                            _utils.debug("Error message: " + errors[0].message);
                        }
                    } else {
                        _utils.debug("Unknown error");
                    }
            }
        });
        $A.enqueueAction(action);
    },

    loadUnistallationProcedure: function (component, event, helper) {
        var action = component.get("c.getFieldValuesForUnistallationProcedure");
        action.setCallback(this, function(response)
        {
            var state = response.getState();
            if (state === "SUCCESS")
            {
                var  tempMap =[];
                var  responseMap= response.getReturnValue();
                for(var key in responseMap)
                {
                    tempMap.push({value:responseMap[key], key:key});
                }
                component.set( "v.unistallationList",  tempMap);
                component.set( "v.objectDataMap.Configuration.OB_Unistallation_Procedure__c",  tempMap[0].key);
                console.log("Value of picklist unistallation values: "+component.get("v.objectDataMap.Configuration.OB_Unistallation_Procedure__c"));
            }
            else if (state === "INCOMPLETE")
            {
				_utils.debug("INCOMPLETE");
            }
            else if (state === "ERROR")
            {
                    var errors = response.getError();
                    if (errors)
                    {
                        if (errors[0] && errors[0].message)
                        {
                            _utils.debug("Error message: " + errors[0].message);
                        }
                    } else {
                        _utils.debug("Unknown error");
                    }
            }
        });
        $A.enqueueAction(action);
    },

    checkDate_helper : function (component, event, helper) {
        var date = component.get("v.objectDataMap.Configuration.OB_RequestDate__c");
        var target = component.find("dateId");
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        if(date == null || date == undefined || date < today){
            $A.util.addClass(target, "slds-has-error");
            component.set("v.dateError", true);
        }else{
            $A.util.removeClass(target, "slds-has-error");
            component.set("v.dateError", false);
        }
        console.log("dateerror: " + component.get("v.dateError"));
    },

        // Daniele Gandini <daniele.gandini@accenture.com> - 19/06/2019 - method for checking combination between unistalation method and note fields - START
    checkNoteIfOK_helper : function (component, event, helper) {
        var unistallationValue = component.get("v.objectDataMap.Configuration.OB_Unistallation_Procedure__c");
        var noteField = component.find("noteId");
        var noteValue = noteField.get("v.value");
        if(unistallationValue == "Altro luogo"){
            if(noteValue == null || noteValue == '' || noteValue == undefined){
                component.set("v.isNoteOK", false);
                $A.util.addClass(noteField, "slds-has-error");
            }else{
                component.set("v.isNoteOK", true);
                $A.util.removeClass(noteField, "slds-has-error");
            }
        }else{
            component.set("v.isNoteOK", true);
            $A.util.removeClass(noteField, "slds-has-error");
        }
    },
    // Daniele Gandini <daniele.gandini@accenture.com> - 19/06/2019 - method for checking combination between unistalation method and note fields - END
})