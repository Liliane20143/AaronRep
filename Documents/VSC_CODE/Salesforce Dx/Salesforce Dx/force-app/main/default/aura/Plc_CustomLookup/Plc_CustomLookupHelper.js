/**
 * Created by dilorenzo on 22/01/2019.
 */
({
    /* Gets the list of records given by search filters */
    searchHelper: function(component, event, helper, getInputKeyWord) {
        var action = component.get("c.fetchLookUpValues");
        /* Query filters */
        action.setParams({
            'searchKeyWord': getInputKeyWord,
            'objectName': component.get("v.objectAPIName"),
            'additionalFieldsToQuery': component.get("v.additionalFieldsToQuery"),
            'whereCondition': component.get("v.whereCondition"),
            'limitSize' : component.get("v.resultsLimit"),
            'searchWithSosl' : component.get("v.searchWithSosl")
        });

        action.setCallback(this, function(response) {

            $A.util.removeClass(component.find("loadingSpinner"), "slds-show");
            $A.util.addClass(component.find("loadingSpinner"), "slds-hide");
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var result = response.getReturnValue();
                if (result.error) {
                    helper.showToast('ERROR', result.errorMsg, 'error');
                    return;
                }
                var searchResultList = result.returnList;
                if (searchResultList.length == 0) {
                     component.set("v.noResultMessage", $A.get('$Label.c.Plc_AllAllNoResultMessage'));
                } else {
                    component.set("v.noResultMessage", null);
                }
                component.set("v.listOfSearchRecords", result.returnList);
            }
        });

        $A.enqueueAction(action);
    },

    /* Gets the selected record described by initID  */
    initFunction: function(component, event, helper) {

        //If selected record is set then show result
        if(component.get("v.selectedRecord.Id")){
            helper.showResult(component, event, helper);
        }
        //SECOND CHECK initID
        var initID = component.get("v.initID");
        /* If the initID attribute id not set the function doesn't continue. */
        if(!initID){
            return;
        }

        //Since just an Id is given, we must get the object
        var action = component.get("c.getRecordById");

        action.setParams({

            'recordId': initID,
            'objectName': component.get("v.objectAPIName"),
            'additionalFieldsToQuery': component.get("v.additionalFieldsToQuery")
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var result = response.getReturnValue();
                if (result.error) {
                    helper.showToast('ERROR', result.errorMsg, 'error');
                    return;
                }
                var searchResultList = result.returnList;
                if (searchResultList.length == 1) {
                   helper.setResult(component, event, helper, result.returnList[0]);
                } else{
                    component.set("v.noResultMessage", null);
                }
            }
        });
        $A.enqueueAction(action);

    },
    /* Set CSS attributes in order to hide result */
    clear: function(component, event, helper) {

        var pillTarget = component.find("lookup-pill");
        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        /* Show search icon */
        component.set('v.showSearchIcon', true);
        // var searchIcon = component.find("searchIcon");
        // $A.util.removeClass(searchIcon, 'slds-hide');
        // $A.util.addClass(searchIcon, 'slds-show');
        component.set("v.searchKeyWord", '');
        component.set("v.listOfSearchRecords", null);
    },
    /* Set CSS attributes in order to show result and the label of the selected object */
    showResult: function(component, event, helper) {

        var sObjectFieldToDisplayList = component.get("v.sObjectFieldToDisplayList");
        component.set("v.showedTextSelectedRecord",  component.get('v.selectedRecord.' + sObjectFieldToDisplayList[0]));
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        /* Hide search icon */
        component.set('v.showSearchIcon', false);
        // var searchIcon = component.find("searchIcon");
        // $A.util.addClass(searchIcon, 'slds-hide');
        // $A.util.removeClass(searchIcon, 'slds-show');
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show');

    },
    /* Shows a custom message defined by parameters */
    showToast: function(title, message, type) {
        // show toast message
        var toastEvent = $A.get('e.force:showToast');
        toastEvent.setParams({
            'title': title,
            'message': message,
            'type': type,
            'mode': 'dismissible'
        });
        toastEvent.fire();
    },
    /* Utility function that sets the selected record and the label to show */
    setResult: function(component, event, helper, result){
        component.set("v.selectedRecord", result);
    }
})