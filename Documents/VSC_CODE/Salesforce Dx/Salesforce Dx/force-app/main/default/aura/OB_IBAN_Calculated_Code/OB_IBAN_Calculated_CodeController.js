({  


	doInit : function(component, event, helper) {
        var objectString = 'pv'; //oggetto target -- da definire
        //objectDataMapTest: variabile mock per testare il componente se non si utilizza il wizard.
        //  var objectDataMapTest = {"merchant":{"sobjectType":"account","RecordTypeId":"","Id":"","Name":"", "OB_Legal_Address_State__c": "","Name": "","OB_Legal_Form__c": ""}};
        var objectDataMap = component.get("v.objectDataMap");
        //   component.set("v.objectDataMap", objectDataMapTest);
        //mappa = { apiName LOV : Label} -- in input

    },    


	openModal : function(component, event, helper) {
        component.set("openModalMccCap", true); 
       
    },

    closeModel: function(component, event, helper) {
		// for Hide/Close Model,set the "isOpen" attribute to "False"  
		component.set("v.modalMCCisOpen", false);
	},
})