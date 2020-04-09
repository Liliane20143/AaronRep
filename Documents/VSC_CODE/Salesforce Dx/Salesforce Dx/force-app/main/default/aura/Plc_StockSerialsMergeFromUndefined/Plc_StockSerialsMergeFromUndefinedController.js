/*
 * Created by dilorenzo on 17/01/2019.
 */

({
    doInit : function (component, event, helper) {

        helper.retrieveTranslationsMap(component, helper);
        
        let pageRef = component.get('v.pageReference');
        if (pageRef && pageRef.state && pageRef.state.c__objectId) {
            component.set('v.recordId', pageRef.state.c__objectId);
        }

     //   event.setParam("updateField", true);
        helper.retrieveRecords(component, helper);

        //var inputElm = component.find("serialCodeInput").getElements();
        //component.setAttribute('aria-describedby', component.get('v.serialCodeInput'))
        //inputElm.getElementsById('serialCodeInput')[0].setAttribute('aria-describedby', 'serialCodeInput');


        $A.util.addClass(component.find('searchResultArea1'), 'slds-hide');
        $A.util.addClass(component.find('searchWithLookup'), 'slds-hide');

        $A.util.addClass(component.find("saveButtonArea"), 'slds-hide');
    },
    showResultsSearch : function (component, event, helper) {

        //Abilito la sezione per la ricerca
        helper.searchModelIndefiniti(component,helper,event);
    },
    handleCloseModal : function (component){
         component.set('v.showErrorModal', false);
    },
    isRadioButtonSelected : function (component, helper){
        //propertiesMap selected
        component.set('v.radioToAbleIndef', false);
        component.set('v.flagRadioButton', true);

    },
    isRadioButtonSelectedIndef : function (component, helper){
        //{!v.StockSerialIndefiniti.Plc_Model__c} selected
        component.set('v.radioToAble', false);
        component.set('v.flagRadioButton', true);

        var action101 = component.get('c.updateIndispSS2');
    },
    saveRadio : function(component, event, helper){
         helper.saveRadio(component, helper);
    },
    backSS2Page : function(component, event, helper){
        $A.get("e.force:refreshView").fire();
        window.location.href = '/'+ component.get('v.recordId');
    }
})