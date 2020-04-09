/**
 * Created by dilorenzo on 22/01/2019.
 */
({
     doInit: function(component, event, helper) {
        helper.initFunction(component, event, helper);
    },
    //function used to show search icon after init
    //it is used because somehow in the init method the search icon is not visible yet
    //i need to show/hide it because the record could be initialized with initID or prefillWithRecord
    afterRender: function (component, event, helper) {

        component.superAfterRender();
        //Selected record could be set by outside therefore first of all shoe if it exists otherwise show search icon
        if (component.get("v.selectedRecord.Id") == undefined) {
             /* Show search icon because default search icon visibility is hide */
             component.set('v.showSearchIcon', true);
            // var lookUpTarget = component.find("searchIcon");
            // $A.util.removeClass(lookUpTarget, 'slds-hide');
            // $A.util.addClass(lookUpTarget, 'slds-show')
        }
    },
    /* function called when user clicks inside lookup field */
    onfocus: function(component, event, helper) {

        $A.util.addClass(component.find("mySpinner"), "slds-show");
        $A.util.removeClass(component.find("mySpinner"), "slds-hide");
        component.set("v.errors", []);
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        var getInputkeyWord = component.get("v.searchKeyWord");
        helper.searchHelper(component, event, helper, getInputkeyWord);
    },
    /* When user clicks outside of lookup field this function cleans result data */
    onblur: function(component, event, helper) {

        component.set("v.listOfSearchRecords", null);
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    /* handler called when a key is pressed in the lookup field*/
    keyPressController: function(component, event, helper) {

        $A.util.addClass(component.find("mySpinner"), "slds-show");
        $A.util.removeClass(component.find("mySpinner"), "slds-hide");

        var getInputkeyWord = component.get("v.searchKeyWord");

        if (getInputkeyWord.length > 0) {
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component, event, helper, getInputkeyWord);

        } else {
            component.set("v.listOfSearchRecords", null);
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    /* Function used to clean the selected record */
    clear: function(component, event, helper) {

        var compEvent = component.getEvent("oDeselectedRecordEvent");
        // set record attribute within event
        component.set("v.selectedRecord", {});
        compEvent.setParams({"recordByEvent" : component.get("v.selectedRecord")});
        // fire event
        compEvent.fire();
        // helper.clear(component, event, helper);
    },
    /* This function is called whether the selected record Id is changed */
    clearbox: function(component, event, helper) {

        if (component.get("v.selectedRecord.Id") == undefined) {
            var pillTarget = component.find("lookup-pill");
            var lookUpTarget = component.find("lookupField");
            $A.util.addClass(pillTarget, 'slds-hide');
            $A.util.removeClass(pillTarget, 'slds-show');
            $A.util.addClass(lookUpTarget, 'slds-show');
            $A.util.removeClass(lookUpTarget, 'slds-hide');
            /* Show search icon */
            component.set('v.showSearchIcon', true);
            // var lookUpTarget = component.find("searchIcon");
            // $A.util.addClass(lookUpTarget, 'slds-show');
            // $A.util.removeClass(lookUpTarget, 'slds-hide');
        }
    },
    /* Function called when an item is selected from the list of results */
    handleComponentEvent: function(component, event, helper) {
        /* Takes the selected record from the triggered event */
        var selectedRecordGetFromEvent = event.getParam("recordByEvent");
        // show result
        helper.setResult(component, event, helper, selectedRecordGetFromEvent);
    },
    handleClearEvent: function(component, event, helper) {
        /* When the field is cleared througout the custom clean event, if the initId is defined
         * do not clear the box. Instead of this just calculate new value to put in it
         */
        if(!component.get("v.initID")){
          component.set("v.selectedRecord", {});
          helper.clear(component, event, helper);
        }
        /* In any case the initFunction is called */
        helper.initFunction(component, event, helper);
    },
    /* Handler called when a record is selected */
    handleSelectedRecordChange: function(component, event, helper) {
        var selectedRecord = component.get('v.selectedRecord');
        if (selectedRecord != undefined && selectedRecord.Id){
            helper.showResult(component, event, helper);
        } else {
            helper.clear(component, event, helper);
        }
    },
    /* Function used to check if the text field input is valid or not */
    checkValidity: function(component, event, helper) {

        if(!component.get("v.required") || Boolean(component.get("v.selectedRecord.Id"))){
            component.set("v.errors", []);
            return true;
        } else{
            component.set("v.errors", [{message: $A.get('$Label.c.Plc_AllAllRequiredFieldErrorMessage')}]);
            return false;
        }
    }
})