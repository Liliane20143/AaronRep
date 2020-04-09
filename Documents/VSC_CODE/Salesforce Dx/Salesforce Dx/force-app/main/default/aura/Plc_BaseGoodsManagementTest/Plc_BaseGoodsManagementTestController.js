({
	init : function(component, event, helper) {
	    //passo il titolo dell'header al base wizard
        component.set("v.title", "Titolo da init");

        //nascondo i pulsanti che non voglio vedere
        //component.set("v.isBackVisible", false);
        //component.set("v.isNextVisible", false);
        //component.set("v.isAnnullaVisible", false);
        //component.set("v.isSaveVisible", false);

        //disabilito i pulsanti che sono visibili ma non devono essere attivi
        //component.set("v.isNextEnabled", false);
        //component.set("v.isBackEnabled", false);
        //component.set("v.isAnnullaEnabled", false);
        //component.set("v.isSaveEnabled", false);

        //nascondo, se necessario, il componente dei filtri
        //component.set("v.isFilterVisible", false);

        //inizializzo i campi del componente filtro altrimenti per default tutti visibili: quelli che non voglio vedere gli passo qualcosa di diverso da show, ma non campo vuoto.
        var filterToShow = component.get("v.filterToShow");
        filterToShow['rangeSerial']='show';
        filterToShow['serialFilterType']='winput';
        //filterToShow['serialFilterType']='noinput';
        filterToShow['costructorsFilter']='show';
        //filterToShow['costructorsFilter']='ee';
        filterToShow['serialStatusFilter']='show';
        filterToShow['uploadCsv']='show';
        component.set("v.filterToShow", filterToShow);

        //se diverso da quello di default seto l'object sul quale deve querare il componente filtro
        //component.set("v.objectToSearch", "apinameoggetto__c");
		
	},
    handleSave : function(component, event, helper){
        var titolo = component.get("v.title");
        console.log("Save clicked, titolo: "+titolo);
    },
    handleBack : function(component, event, helper){
        var titolo = component.get("v.title");
        console.log("Back clicked, titolo: "+titolo);
    },
    handleNext : function(component, event, helper){
        var titolo = component.get("v.title");
        console.log("Next clicked, titolo: "+titolo);
    }
})