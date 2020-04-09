({
    doInit : function(component, event, helper) {
        helper.getMatrixParameterByBundle(component,event);
       console.log('ABIlist: ' , component.get("v.ABIlist"));
       console.log('activeABIObj: ' , component.get("v.activeABIObj"));     
    },

    cloneMatrixParameterJS : function(component, event, helper) {
        //17/06/19 francesca.ribezzi calling 
        helper.checkForInProgressApexJobs(component, event);
        //helper.callCloneMatrixHelper(component, event);
    },
    //START Andrea Saracini 20/05/2019 Catalog ON-OFF
    goBackToOffertaTable : function(component, event, helper) {
        component.set("{!v.goToOffers}",true);
        component.set("{!v.goToSaleabilityForBank}",false);
    },
    //STOP Andrea Saracini 20/05/2019 Catalog ON-OFF
    //START Andrea Saracini 27/05/2019 Catalog ON-OFF
    cloneMatrixParameterRowsJS : function(component, event, helper) {   
        //START francesca.ribezzi 10/06/19 commenting callCloneMatrixRowsHelper method and use a new one:
        //helper.callCloneMatrixRowsHelper(component, event);    
        helper.callUpdateActiveBankMatrixRowsHelper(component, event);
        //END francesca.ribezzi 10/06/19
    },
    //STOP Andrea Saracini 27/05/2019 Catalog ON-OFF
    //davide.franzini - 11/07/2019 - F2WAVE2-117 - START
    rejectConfiguration : function(component, event, helper) {
        helper.rejectConfigurationHelper(component, event);
    },
    //davide.franzini - 11/07/2019 - F2WAVE2-117 - END
    /*
     *@author francesca.ribezzi
     *@date  03/07/19
     *@task F2WAVE2-16
     *@description Method checks all components' checkboxes
     *@history 03/07/19 Method created
     */
    handleSetCheckBoxToAllComponents : function(component, event, helper) {
        var setAllCheckboxMatrixTable = component.get("v.setAllCheckboxMatrixTable");
        var active = event.currentTarget.checked;
        component.set("v.setAllCheckboxMatrixTable", active);
    },


})