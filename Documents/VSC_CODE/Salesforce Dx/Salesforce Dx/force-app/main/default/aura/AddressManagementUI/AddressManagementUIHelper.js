({
    
    /* Prepare the information about the Address__c custom object. */
    getObjectInfo: function (component, event, helper,isEditMode) {
        var objToRetrieve = {
            'objType': 'Address__c',
            'Id': component.get('v.cmpParams.AddressId'),
            'externalCode': component.get('v.cmpParams.AddressEC__c'),
            'mode': component.get('v.cmpParams.AddressId') != undefined || component.get('v.cmpParams.AddressEC__c') != undefined ? 'EDIT' : 'INSERT'
        };
        
//        helper.extractInfoOnObject(component, objToRetrieve).then(
//            $A.getCallback(function resolve(result) {
//                var jsonResult = JSON.parse(result);
//                component.set('v.objAddress', JSON.parse(jsonResult.objValue));
//                component.set('v.objAddressSchema', JSON.parse(jsonResult.objSchema));
//                component.set('v.objAddress.AccountEC__c', component.get('v.cmpParams.AccountEC__c'));
//                if(component.get('v.addressType') != ''){
//                    component.set('v.objAddress.Type__c', component.get('v.addressType'));
//                    component.set('v.objJunction.Type__c', component.get('v.addressType'));
//                }
//                if(component.get('v.objAddress.isForced') === true || component.get('v.objAddress.isNormalized') === true){
//                    component.find("submit").set("v.disabled", false);
//                }
//            }),
//            $A.getCallback(function reject(error) {
//                helper.showToast("bbErrorMsgTitleError", "bbErrorMsgFatalInitOp", 'error');
//            })
//        );
    },
    
    /* Prepare the information about the AddressJunction__c custom object. */
    getObjectJunctionInfo: function (component, event, helper) {
        var objToRetrieve = {
            'objType': 'AddressJunction__c',
            'Id': '',
            'externalCode': '',
            'mode': 'INSERT'
        };
        
//        helper.extractInfoOnObject(component, objToRetrieve).then(
//            $A.getCallback(function resolve(result) {
//                var jsonResult = JSON.parse(result);
//                component.set('v.objJunction', JSON.parse(jsonResult.objValue));
//                component.set('v.objJunctionSchema', JSON.parse(jsonResult.objSchema));
//                if(component.get('v.addressType') != ''){
//                    component.set('v.objJunction.Type__c', component.get('v.addressType'));
//                }
//            }),
//            $A.getCallback(function reject(error) {
//                helper.showToast("bbErrorMsgTitleError", "bbErrorMsgFatalInitOp", 'error');
//            })
//        );
    },
    
    /* This method prepare the information about the Address__c picklist. */
    getObjectPicklistValues: function (component, event, helper) {
        var dataToSend = {
            'objApiName': 'AddressJunction__c',
            'fieldsApiName': 'AddressType__c'
        };
        helper.extractPicklistForFieldsOnObject(component, dataToSend).then(
            $A.getCallback(function resolve(result) {
                component.set('v.objJunctionPicklist', JSON.parse(result));
            }),
            $A.getCallback(function reject(error) {
                helper.showToast("bbErrorMsgTitleError","bbErrorMsgFatalInitOp", 'error');
            })
        );
    },
    
    /* This method call the noralization method backend for obtain information about the city in input. */
    retrieveDataFromCity: function (component, city) {
        var action = component.get("c.retrieveCityRegistry");
        action.setParams({
            adrCity: city
        })
        action.setCallback(this, function (response) {
            var state = response.getState();
            var a = JSON.stringify(response);
            if (state === "SUCCESS") {
                var responseFromApex = response.getReturnValue();
                var data = JSON.parse(responseFromApex);
                if (responseFromApex != null) {
                    component.find("adrCity").set("v.value", data.CityName__c);
                    component.find("adrProvince").set("v.value", data.ProvinceName__c);
                    component.find("adrZone").set("v.value", data.ZoneName__c);
                    component.find("adrRegion").set("v.value", data.RegionName__c);
                    component.find("adrCountry").set("v.value", data.Country__c);
                }
                if(component.get("v.isEmbedded") === false)
                    component.find("submit").set("v.disabled", false);
            } else {
                var toastEvent = $A.get("e.force:showToast");
                var errorLabelMessage = "bbErrorMsgCityNotFound"; // Please provide an existing city!
                var errorLabelTitle = "bbErrorMsgTitleCityNotFound"; // City not found
                toastEvent.setParams({
                    "type": "error",
                    "title": errorLabelTitle,
                    "message": errorLabelMessage
                });
                toastEvent.fire();
                if(component.get("v.isEmbedded") === false)
                    component.find("submit").set("v.disabled", true);
            }
        });
        $A.enqueueAction(action);
    },
    
    /* Just reset the form. */
    resetItemAddress: function(component, event,helper){ 
        var notRequireFilds = ['type','AccountEC__c'];
        for (var key in component.get('v.objAddress')){
            if(notRequireFilds.indexOf(key) <= -1){
                component.set('v.objAddress.'+key, null);
            }
        }
        component.set('v.objAddress.ExternalCode__c ', helper.generateNewGuid());
    },
    
    /* Validate the required field in the form. */
    validateUI: function (component, event, helper) {
        var result = true;
        var notRequiredFields = ['Toponymy__c','Id', 'SystemModstamp', 'LastModifiedById', 'LastModifiedDate', 'CreatedById', 'CreatedDate', 'Name', 'IsDeleted', 'OwnerId'];	
        var errors = "These fields are required: ";
        var lista = [];
        for (var key in component.get('v.objAddressSchema')) {
            for (var key2 in component.get('v.objAddressSchema')[key]) {
                if (key2 == 'nillable') {
                    if (component.get('v.objAddressSchema')[key][key2] === false) {
                        if (notRequiredFields.indexOf(key) <= -1) {
                            lista.push(key);
                        }
                    }
                }
            }
        }
        for (var item in lista) {
            for (var key in component.get('v.objAddress')) {
                if (lista[item] == key) {
                    if (component.get('v.objAddress')[key] == null) {
                        errors += key + ', ';
                        result = false;
                    }
                }
            }
        }
        if (!result) {
            helper.showToast("bbErrorMsgTitleError", errors, 'error');
        }
        helper.spinnerHide(component);
        return result;
    },
    
    /* Address autocomplete using Google Map's API */
    autocompleteAddressFunction: function (component, event, helper) {
        $A.util.removeClass(component.find("addressSuggestion"), "slds-hide");
        var action = component.get("c.getAddressAutoComplete");
        action.setParams({
            "input": component.find('adrStreetName').get('v.value'),
            "types": '(regions)'
        });
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var options = JSON.parse(response.getReturnValue());
                var predictions = options.predictions;
                var addresses = [];
                if (predictions.length > 0) {
                    for (var i = 0; i < predictions.length; i++) {
                        addresses.push(
                            {
                                value: predictions[i].place_id,
                                label: predictions[i].description
                            });
                    }
                    component.set("v.filteredOptions", addresses);
                    
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    /* Fill in the correct field on the address form, after Google Map's API call. */
    selectOptionFunction: function(component, event, helper) {
        var selectedItem = event.currentTarget; // Get the target object
        var index = selectedItem.dataset.record; // Get its value i.e. the index
        var selectedStore = component.get("v.filteredOptions")[index]; // Use it retrieve the store record
                
        $A.util.addClass(component.find("addressSuggestion"), "slds-hide");
        
        var action = component.get("c.getPlaceDetail");
        action.setParams({
            "input": selectedStore.value
        });
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var options = JSON.parse(response.getReturnValue());
                var streetname = '';
                var address = options.result.address_components;
                if (address.length > 0) {
                    for (var i = 0; i < address.length; i++) {
                        if(address[i].types.length>0){
                            for (var j = 0; j < address[i].types.length; j++) {
                                if(address[i].types[j]=="route"){
                                    component.find("adrStreetName").set("v.value", address[i].long_name);
                                }
                                if(address[i].types[j]=="administrative_area_level_3"){
                                    component.find("adrCity").set("v.value",address[i].short_name);
                                }
                                if(address[i].types[j]=="country"){
                                    component.find("adrCountry").set("v.value",address[i].long_name);
                                }
                                
                                if(address[i].types[j]=="postal_code"){
                                    component.find("adrZipCode").set("v.value",address[i].long_name);
                                }
                                
                                if(address[i].types[j]=="administrative_area_level_2"){
                                    component.find("adrProvince").set("v.value", address[i].short_name);
                                }
                                if(address[i].types[j]=="street_number"){
                                    component.find("adrStreetNumber").set("v.value", address[i].short_name);
                                }       
                            }
                        }                        
                    }
                }   
            }
        });
        $A.enqueueAction(action);
    }
    
})