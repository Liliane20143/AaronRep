({
    doInit : function(component, event, helper) {
        //START francesca.ribezzi 09/10/19 WN-551 setting isConventionCodeOk to false if the bundle offer is one of those two:
        try{
            var isConventionCodeOk = component.get("v.isConventionCodeOk");
            var offer = component.get("v.offer"); 
            console.log('@@@ offer: ' + JSON.stringify(offer));
            debugger;
            var offerCodeXpay = "XPAY_FULL_SOLO_GT";  //xPay Full - attivazione gateway
            var offerCodeEcomm = "ECOMM_ACQ_EST"; //Offerta Acquiring Ecommerce con GT Terzi - Estensione Acquiring
            var conventionCodeRequired = (offer.fields.OBCodiceSfd == offerCodeXpay || offer.fields.OBCodiceSfd == offerCodeXpay );
            if(conventionCodeRequired){
                component.set("v.isConventionCodeOk", false); //this checks if convention code field must be required or not
            }
        }catch(err){
            console.log('ERROR in doInit OB_ConventionCodeSearchController: ' + err.message);
        }
        //END francesca.ribezzi 09/10/19 WN-551
    },
    closeModal: function(component, event, helper) {
        component.set("v.isModalOpen", false);
        component.set("v.assetSelected", undefined);
    },
    doSearch: function(component, event, helper) {       
        helper.myServicePointCode(component, event, helper);
    },
    saveCode: function(component, event, helper) { 
        var selectedRow = component.get("v.assetSelected");
        if(selectedRow){
            /*davide.franzini 08/05/2019 - START*/
            component.set("v.Spinner", true);
            component.set("v.isModalOpen", false);
            /*davide.franzini 08/05/2019 - END*/
            helper.updateServicePointCode(component, event, helper);
        }
        else{
            component.set("v.noCodeSelected", true);
        }
    },
    clonePricing: function(component, event, helper) {       
    },
    getSelectedRecord: function(component, event, helper) {
        var selectedRow = event.getParam('selectedRows');
        if(selectedRow){
            component.set("v.bundleAssetId", selectedRow[0].NE__Bundle_Configuration__c);             
            selectedRow = JSON.stringify(selectedRow);
            component.set("v.assetSelected", selectedRow);
            component.set("v.noCodeSelected", false);

        }
    },
    showAssetPricing: function(component, event, helper) {
        var selectedRow = component.get("v.assetSelected");
        console.log('[assetSelected, showAssetPricing] - bundleAssetId: '+component.get("v.bundleAssetId"));
        if(selectedRow){
            component.set("v.showAssetPricing", true);
        }
        else{
            component.set("v.noCodeSelected", true);
        }       
    },

    /*
    *@author francesca.ribezzi
    *@date 09/10/2019
    *@task callHandleRedBorderErrors - setting red border to empty required fields - WN-551
    *@history  09/10/2019 Method created
    */
   callHandleRedBorderErrors: function(component, event, helper){
    helper.handleRedBorderErrors(component,event);
},
})