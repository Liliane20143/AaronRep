({
    doInit : function(component, event, helper) {
        var objectString = 'puntoVendita'; //oggetto target -- da definire
        //objectDataMapTest: variabile mock per testare il componente se non si utilizza il wizard.
        //  var objectDataMapTest = {"merchant":{"sobjectType":"account","RecordTypeId":"","Id":"","Name":"", "OB_Legal_Address_State__c": "","Name": "","OB_Legal_Form__c": ""}};
        var objectDataMap = component.get("v.objectDataMap");
        //   component.set("v.objectDataMap", objectDataMapTest);
        //mappa = { apiName LOV : Label} -- in input
        var mappa = {
            "Name": "MCC Description"
        };
        console.log("doinit objectDataMap: " + JSON.stringify(objectDataMap));
        console.log("mappa " + JSON.stringify(mappa));
        component.set("v.mapLabelColumns", mappa);
        var mapLabelColumns = component.get("v.mapLabelColumns");
        console.log("mapLabelColumns " + JSON.stringify(mapLabelColumns));
        var mappa2 = {}; 
        mappa2['OB_MCC_Description__c'] = 'Name';
        mappa2['OB_MCC__c'] = 'NE__Value2__c';
        component.set("v.mapOfSourceFieldTargetField", mappa2);
        var mapOfSourceFieldTargetField = component.get("v.mapOfSourceFieldTargetField");
        console.log("mapOfSourceFieldTargetField " + JSON.stringify(mapOfSourceFieldTargetField));
        var type = component.get("v.type");
        type = 'MCC';
        component.set("v.type", type);
        component.set("v.objectString", objectString);
        component.set("v.orderBy", "Name");
    },
    openModal : function(component, event, helper) {
        component.set("v.spinner", true); 
        //component.set("v.showModal", true); 
        //  helper.getLovs(component, event);    
        helper.createComponent(component, event);
    },
    
    handleShowModalEvent : function(component, event, helper) {
        var objectDataMap = event.getParam("objectDataMap");
        console.log("handleShowModalEvent event.getParam: " + objectDataMap);
        component.set("v.objectDataMap", objectDataMap);
    },
    formPress: function(component, event, helper) {
        if (event.keyCode === 13){
            // helper.getLovs(component, event);
            component.set("v.spinner", true);
             helper.createComponent(component, event);
           // component.set("v.showModal", true);        
        }
    },
})