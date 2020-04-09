({
    fireShowModalEvent : function(component, event) {
        console.log("sono nell'helper fireShowModalEvent");
        component.set("v.spinner", true);
        var objectDataMap = component.get("v.objectDataMap");
        console.log("objectDataMap after getSelectedrow" + JSON.stringify(objectDataMap));
        var lovs = component.get("v.lovs");
        if(lovs != null){
               component.set("v.lovs", []);
        }
      //   component.set("v.showModal", false);
     //   var showModal = component.get("v.showModal");
        var showModalEvent = component.getEvent("showModalEvent");
     //   console.log("fireShowModalEvent, showModal: " + showModal);
        showModalEvent.setParams({ showModal: false });
        showModalEvent.fire();
        //  $A.util.addClass(modal, 'hideModal'); 
    },
    getLovs : function(component, event) {
        component.set("v.spinner", true);
        var lovs = component.get("v.lovs");
        if(lovs != null){
            component.set("v.lovs", []);
        }
        var type = component.get("v.type");
        var input = component.get("v.input");
        //EP 06/10/18 SAE ATECO
        var subType = component.get("v.subType");
        var subTypeField = component.get("v.subTypeField");

        var mapOfSourceFieldTargetField = component.get("v.mapOfSourceFieldTargetField");
        var mapLabelColumns = component.get("v.mapLabelColumns");
        var action = component.get("c.getLovsByType");
        action.setParams({ type : type,
                           input : input,
                           subType : subType,
                           subTypeField : subTypeField,
                          mapOfSourceFieldTargetField : mapOfSourceFieldTargetField,
                          mapLabelColumns : mapLabelColumns});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                //console.log("RESPONSE " + JSON.stringify(response.getReturnValue()));
                if(response.getReturnValue().length > 0){
                    component.set("v.lovs", response.getReturnValue()); 
                    component.set("v.messageIsEmpty", "");
                }else{
                    component.set("v.messageIsEmpty", "nessun record trovato.");
                    component.set("v.lovs", response.getReturnValue()); 
                }
                component.set("v.spinner", false);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
        
    }
})