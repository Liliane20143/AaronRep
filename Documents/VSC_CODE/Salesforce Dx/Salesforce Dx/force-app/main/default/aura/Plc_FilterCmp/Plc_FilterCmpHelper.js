({

    h_initComponent: function (component, event, helper) {
        console.log('FilterCmp- initHelper');
        this.h_getPicklistValues(component);
    },


    h_validityCheck: function (component, event, helper) {
        //formal inputs checks
        console.log('checking FiedsValidity');

        var inputSearch = component.find('inputSearch');
        var rangeSerialDA = component.find('rangeSerialDA');
        var rangeSerialA = component.find('rangeSerialA');
        var manufacturerFilter = component.find('manufacturerFilter');
        var serialStatusFilter = component.find('serialStatusFilter');
        var errors = false;
        var validity = inputSearch.get("v.validity");

        if (validity != null && validity !== '' && !validity !== undefined) {
            if (inputSearch != null && inputSearch !== '' && !inputSearch !== undefined) {
                inputSearch.showHelpMessageIfInvalid();
                if (!inputSearch.get("v.validity").valid) {
                    errors = true;
                }
            }

            if ((rangeSerialDA != null && rangeSerialDA !== '' && rangeSerialDA !== undefined)
                && (rangeSerialA != null && rangeSerialA !== '' && rangeSerialA !== undefined)) {

                if (rangeSerialDA.get('v.value') && !rangeSerialA.get('v.value')) {
                    rangeSerialA.setCustomValidity($A.get("$Label.c.Plc_RangeFilterRequiredError"));
                } else if (!rangeSerialDA.get('v.value') && rangeSerialA.get('v.value')) {

                    rangeSerialDA.setCustomValidity($A.get("$Label.c.Plc_RangeFilterRequiredError"));
                } else {
                    rangeSerialA.setCustomValidity('');
                    rangeSerialDA.setCustomValidity('');
                }
                rangeSerialA.reportValidity();
                rangeSerialDA.reportValidity();
            }


            if (rangeSerialDA != null && rangeSerialDA !== '' && rangeSerialDA !== undefined) {
                rangeSerialDA.showHelpMessageIfInvalid();
                if (!rangeSerialDA.get("v.validity").valid) {
                    errors = true;
                }
            }

            if (rangeSerialA != null && rangeSerialA !== '' && rangeSerialA !== undefined) {
                rangeSerialA.showHelpMessageIfInvalid();
                if (!rangeSerialA.get("v.validity").valid) {
                    errors = true;
                }
            }

            if (manufacturerFilter != null && manufacturerFilter !== '' && manufacturerFilter !== undefined) {
                manufacturerFilter.showHelpMessageIfInvalid();
                if (!manufacturerFilter.get("v.validity").valid) {
                    errors = true;
                }
            }

            if (serialStatusFilter != null && serialStatusFilter !== '' && serialStatusFilter !== undefined) {
                serialStatusFilter.showHelpMessageIfInvalid();
                if (!serialStatusFilter.get("v.validity").valid) {
                    errors = true;
                }
            }

            if (errors) {
                console.log('Invalid patterns pls check your input!');
                return 'error'
            } else {
                console.log('All inputs are valid!');
                return ''
            }
        } else {
            return ''
        }

    },

    h_applyFiltersCmp: function (component, event, helper) {
        //function that applyes the selected filters
        console.log('FilterCmp- applyFilters started!');

        if (this.h_validityCheck(component, event, helper) === 'error') {
            return;
        }
        component.set('v.showSpinner', true);
        //creating the object fotr the apex controller
        var inputFieldsObj = {
            inputString: component.get('v.inputSearch'),
            rangeMatricolaDa: component.get('v.rangeSerialDA'),
            rangeMatricolaA: component.get('v.rangeSerialA'),
            manufacturer: component.get('v.manufacturerFilter'),
            status: component.get('v.serialStatusFilter')
        };

        var inputFieldsToString = JSON.stringify(inputFieldsObj);
        console.log('FilterCmp - inputFieldsToString: ' + inputFieldsToString +
            '\n' + 'FilterCmp - inputFieldsObj: ', inputFieldsObj);


        var action = component.get('c.applyFilters');
        action.setParams({inputsFields: inputFieldsToString, configurationMap: component.get('v.configuationMap')});
        action.setCallback(this, function (res) {
            if (component.isValid() && res.getState() === "SUCCESS") {
                console.log("success callback applyFilters");
                var results = res.getReturnValue();

                var evt = $A.get("e.c:Plc_FilterEvt");
                evt.setParams({
                    "searchResultsEvt": results,
                    "actionType": 'applyFilters',
                    "inputSearchValue": component.get('v.inputSearch')
                });
                evt.fire();

                console.log('event results fired! ', results);
                component.set('v.showSpinner', false);

            } else if (component.isValid() && res.getState() === "INCOMPLETE") {
                console.log("Error in h_applyFiltersCmp: " + res.getError()[0].message);

            } else if (component.isValid() && res.getState() === "ERROR") {
                console.log("Unknown error in h_applyFiltersCmp: " + res.getError()[0].message);

            }
        });
        $A.enqueueAction(action);

    },

    h_removeFiltersCmp: function (component, event, helper) {
        //reset all filters and input erros
        console.log('FilterCmp - h_removeFiltersCmp start!');

        component.set('v.inputSearch', null);
        component.set('v.rangeSerial', null);
        component.set('v.rangeSerialA', '');
        component.set('v.rangeSerialDA', '');
        component.set('v.manufacturerFilter', '');
        component.set('v.serialStatusFilter', null);
        component.set('v.picklistValues', '');
        this.h_getPicklistValues(component);

        var evt = $A.get("e.c:Plc_FilterEvt");
        evt.setParams({"searchResultsEvt": []});
        evt.setParams({"actionType": "removeFilters"});
        evt.fire();

        var a = this.h_validityCheck(component, event, helper);

        console.log('Filters and errors removed succesfully!');
        console.log('FilterCmp - h_removeFiltersCmp end!');
        this.h_applyFiltersCmp(component, event, helper);
    },

    h_resetInputsAfterSearching: function (component, event, helper) {
        //reset all filters

        if (component.get('v.resetInputsAfterSearching')) {
            console.log('FilterCmp - resetInputsAfterSearching start!');
            component.set('v.inputSearch', null);
            component.set('v.rangeSerial', null);
            component.set('v.rangeSerialA', '');
            component.set('v.rangeSerialDA', '');
            component.set('v.manufacturerFilter', '');
            component.set('v.serialStatusFilter', null);

            console.log('Filters cleared succesfully!');
            console.log('FilterCmp - resetInputsAfterSearching end!');
        }
    },


    h_getPicklistValues: function (component, event, helper) {
        //function that gets the right picklist value for the user viewing the cmp
        console.log('FilterCmp- h_getPicklistValues started!');
        component.set('v.showSpinner', true);

        //setting the picklist field and object
        var fieldName = 'Bit2Shop__Status__c';
        var sObjectName_ = 'Bit2Shop__Stock_Serials2__c';


        var action = component.get('c.getPicklistOptions');
        action.setParams({fieldName: fieldName, sObjectName: sObjectName_});
        action.setCallback(this, function (res) {
            if (component.isValid() && res.getState() === "SUCCESS") {
                console.log("success callback h_getPicklistValues");
                var results = res.getReturnValue();
                component.set('v.picklistValues', results);
                console.log('Picklist field populated! ', component.get('v.picklistValues'), results);
                component.set('v.showSpinner', false);

            } else if (component.isValid() && res.getState() === "INCOMPLETE") {
                console.log("Error in h_getPicklistValues: " + res.getError()[0].message);

            } else if (component.isValid() && res.getState() === "ERROR") {
                console.log("Unknown error in h_getPicklistValues: " + res.getError()[0].message);

            }
        });
        $A.enqueueAction(action);

    },
})