({
	/* Method invoked when the user land on the component page. This method prepare the information about the 
	 * Address__c custom object. */
    doInit: function (component, event, helper) {
        helper.getObjectInfo(component, event, helper, false);
        let typy = {};
        typy.AddressType__c = [];
        typy.AddressType__c.push({Label: 'topo',value:'topo'});
        component.set("v.objJunctionPicklist",typy);

        let schemacik = {};
        schemacik.Toponymy__c={updateable:true,nillable:true,label:'Toponymy__c'};
        schemacik.StreetName__c={updateable:true,nillable:true,label:'StreetName__c'};
        schemacik.StreetNumber__c={updateable:true,nillable:true,label:'StreetNumber__c'};
        schemacik.StreetNumber__c={updateable:true,nillable:true,label:'StreetNumber__c'};
        schemacik.Building__c={updateable:true,nillable:true,label:'Building__c'};
        schemacik.Stair__c={updateable:true,nillable:true,label:'Stair__c'};
        schemacik.ApartmentFloor__c={updateable:true,nillable:true,label:'ApartmentFloor__c'};
        schemacik.ApartmentNumber__c={updateable:true,nillable:true,label:'ApartmentNumber__c'};
        schemacik.ZipCode__c={updateable:true,nillable:true,label:'ZipCode__c'};
        schemacik.City__c={updateable:true,nillable:true,label:'City__c'};
        schemacik.IsNormalized__c={updateable:true,nillable:true,label:'IsNormalized__c'};
        schemacik.Province__c={updateable:true,nillable:true,label:'Province__c'};
        schemacik.Country__c={updateable:true,nillable:true,label:'Country__c'};
        schemacik.Notes__c={updateable:true,nillable:true,label:'Notes__c'};
        component.set("v.objAddressSchema",schemacik);
        //helper.getObjectJunctionInfo(component, event, helper);
        //helper.getObjectPicklistValues(component, event, helper);
    },

    /* Method invoked by choosing a new type inserting a new Address Object*/
    handleChooseAddressType: function (component, event, helper) {
        var menuItem = event.detail.menuItem.get("v.value");
        component.set('v.showForm', true);
        if (component.get('v.cmpParams.AddressId') != null) {
            component.set('v.cmpParams.AddressEC__c', null);
            component.set('v.cmpParams.AddressId', null);
            helper.resetItemAddress(component, event, helper);
        }
        component.set('v.objJunction.AddressType__c', menuItem);
        component.set('v.objAddress.Type__c', menuItem); //TODO: DELETE

        if (component.get('v.cmpParams.normalizer') != null && component.get('v.cmpParams.normalizer') != '') {
            if (component.get('v.cmpParams.normalizer') == 'OFF') {
                // Normalizer OFF

                // Hide forced and normalized CheckBox
                var isForced = component.find('adrForced');
                $A.util.addClass(isForced, "slds-hide");
                var isNormalized = component.find('adrNormalized');
                $A.util.addClass(isNormalized, "slds-hide"); 

                // Hide verify button
                var verifyButton = component.find("btnVerify");
                $A.util.addClass(verifyButton, "slds-hide");

                // Forced=true, normalized=false
                component.set('v.objAddress.isForced__c', true);
                component.set('v.objAddress.IsNormalized__c', false);
            } else {
                // Normalizer ON
                if (component.get("v.isEmbedded") === false)
                    component.find("submit").set("v.disabled", true);
            }
        }
    },

    /* Contains logic about the forced checkbox change */
    onForcedChange: function (component, event, helper) {
        if (component.find("adrIsForced").get("v.value") === true) {
            if (component.get("v.isEmbedded") === false)
                component.find("submit").set("v.disabled", false);
            component.find("verify").set("v.disabled", true);
        } else {
            if (component.get("v.isEmbedded") === false)
                component.find("submit").set("v.disabled", true);
            component.find("verify").set("v.disabled", false);
        }
    },

    /* The validate method will show a toast message when a required field contains a null value. */
    validateObjAddress: function (component, event, helper) {
        return helper.validateUI(component, event, helper);
    },

    /* Submit the address form */
    submit: function (component, event, helper) {
        helper.spinnerShow(component);
        component.get('v.objAddress')['AccountEC__c'] = component.get('v.cmpParams.AccountEC__c');
        component.get('v.objJunction')['AccountEC__c'] = component.get('v.cmpParams.AccountEC__c');
        component.get('v.objJunction')['AddressEC__c'] = component.get('v.objAddress.ExternalCode__c');
        var dataToSend = {
            'parameters': {
                'Address__c': component.get('v.objAddress')
            }
        }
        if (helper.validateUI(component, event, helper)) {
            helper.saveComponentData(component, dataToSend).then(
                $A.getCallback(function resolve(value) {
                    helper.showToast("bbSuccessMsgTitleSuccess", "bbSuccessMsgOperationSave", 'success');
                    helper.refreshView(component);
                }),
                $A.getCallback(function reject(error) {
                    helper.showToast("bbErrorMsgTitleError", "bbErrorMsgOperationSave", 'error');
                })
            );
            helper.spinnerHide(component);
        }
    },

    /* Method invocked clicking on Edit button on row inside datatable. 
     * It will load object infromation and show data in the form for edit the object. */
    onRowSelection: function (component, event, helper) {
        var record = JSON.parse(event.getParam('record'));
        var action = event.getParam('action');
        component.set('v.cmpParams.AddressId', record.Id);
        event.stopPropagation();
        if (action === 'Edit') {
            helper.getObjectInfo(component, event, helper, true);
            component.set('v.showForm', true);
        }
    },

    /* Select the desired object when the Address component is embedded. */
    onRowSelectionRadio: function (component, event, helper) {
        var rows = JSON.parse(event.getParam('selectedRows'));
        component.set('v.cmpParams.AddressId', rows[0].Id);
        event.stopPropagation();
        var objToRetrieve = {
            'objType': 'Address__c',
            'Id': component.get('v.cmpParams.AddressId'),
            'externalCode': component.get('v.cmpParams.AddressEC__c'),
            'mode': component.get('v.cmpParams.AddressId') != undefined || component.get('v.cmpParams.AddressEC__c') != undefined ? 'EDIT' : 'INSERT'
        };
        helper.extractInfoOnObject(component, objToRetrieve).then(
            $A.getCallback(function resolve(result) {
                var jsonResult = JSON.parse(result);
                component.set('v.objAddress', JSON.parse(jsonResult.objValue));
                component.set('v.objAddressSchema', JSON.parse(jsonResult.objSchema));
                if (component.get('v.addressType') != '') {
                    component.set('v.objAddress.Type__c', component.get('v.addressType'));
                }
                component.set('v.objAddress.Id', null);
                component.set('v.objAddress.ExternalCode__c', helper.generateNewGuid());
                component.set('v.cmpParams.AddressId', null);
                component.set('v.selectedTabId', 'addressNewTab');
            }),
            $A.getCallback(function reject(error) {
                helper.showToast("bbErrorMsgTitleError", "bbErrorMsgFatalInitOp", 'error');
            })
        );
    },

    /* The normalize method will normalize the address starting from City value */
    normalize: function (component, event, helper) {
        if (component.find("adrCity").get('v.value') === null || component.find("adrCity").get('v.value') === '') {
            var toastEvent = $A.get("e.force:showToast");
            var errorLabelMessage = "bbErrorMsgCityRequired";
            var errorLabelTitle = "bbErrorMsgTitleCityRequired";
            toastEvent.setParams({
                "type": "error",
                "title": errorLabelTitle,
                "message": errorLabelMessage
            });
            toastEvent.fire();
        } else {  
            helper.retrieveDataFromCity(component, component.find("adrCity").get('v.value'));
            component.set('v.objAddress.IsNormalized__c', true);
        }
    },

	/* Address autocomplete using Google Map's API */
    autocompleteAddress: function (component, event, helper) {
		helper.autocompleteAddressFunction(component, event, helper)
	},
	
    /* Fill in the correct field on the address form, after Google Map's API call. */
	selectOption: function (component, event, helper) {
		helper.selectOptionFunction(component, event, helper)
	}

})