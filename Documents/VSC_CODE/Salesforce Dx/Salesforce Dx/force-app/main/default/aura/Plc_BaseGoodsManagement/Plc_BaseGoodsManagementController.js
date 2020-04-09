({
	handleInitialize : function (component, event, helper) {
        var myPageRef = component.get("v.pageReference");
        var objectId = myPageRef.state.c__objectId;
        component.set("v.objectId", objectId);
        console.log('objectId >> ' + objectId);
	},

	handleSaveInternal : function (component, event, helper) {
	    //invoco la logica del componente figlio al clic sul salva
        component.getConcreteComponent().handleSave();
    },

    handleBackInternal : function (component, event, helper) {
        //invoco la logica del componente figlio al clic su indietro
        component.getConcreteComponent().handleBack();
    },

    handleNextInternal : function (component, event, helper) {
        //invoco la logica del componente figlio al clic su avanti
        component.getConcreteComponent().handleNext();
    },

    handleAnnulla : function (component, event, helper){
        //se la funzionalità dell'annulla è per tutti uguali la implemento qui
        console.log("Annulla clicked");
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
          "recordId": component.get("v.objectId"),
          "slideDevName": "related"
        });
        navEvt.fire();
    },

    handleFilterComponentInternal : function(component, event, helper){
        //recupero la lista di record restituita dal componente filtro

        /*event.stopPropagation();
        var searchResult = event.getParam("searchResultsEvt");
        var actionType = event.getParam("actionType");
        component.set("v.filterResult", searchResult);
        component.set("v.actionType", actionType);
        //invoco la logica del componente figlio all'evento lanciato dal componente filtro
        component.getConcreteComponent().handleFilterComponent();*/
    },

    handleOpenCancelModal : function(component, event, helper) {
        console.log('[START] C - handleOpenCancelModal');

        component.set('v.showCancelModal', true);

        console.log('[END] C - handleOpenCancelModal');
    },

    handleCloseCancelModal : function(component, event, helper) {
        console.log('[START] C - handleOpenCancelModal');

        component.set('v.showCancelModal', false);

        console.log('[END] C - handleOpenCancelModal');
    }
})