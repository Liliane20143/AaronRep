({
    createComponent : function(component, event) {
           $A.createComponent(
           "c:modalLookupWithPagination",
       {
           "aura:id": "modal",
           "objectString":component.get("v.objectString"),
           "type":component.get("v.type"),
           "subType":component.get("v.subType"),
           "input":component.get("v.objectDataMap.merchant.OB_DescriptionVATNotPresent__c"),
           "mapOfSourceFieldTargetField":component.get("v.mapOfSourceFieldTargetField"),
           "mapLabelColumns":component.get("v.mapLabelColumns"),
           "objectDataMap":component.get("v.objectDataMap"),
           "messageIsEmpty":component.get("v.messageIsEmpty"),
           "orderBy":component.get("v.orderBy")
       },
           function(newModal, status, errorMessage){
               if (status === "SUCCESS") {
                   var body = component.get("v.body");
                   body.push(newModal);
                   component.set("v.body", body);
               }
               else if (status === "INCOMPLETE") {
                   console.log("No response from server or client is offline.")
               }
               else if (status === "ERROR") {
                   console.log("Error: " + errorMessage);
               }
           }
       ); 
           
        
    }
      //DA CANCELLARE
        /*
    getLovs : function(component, event) {
      
        component.set("v.showModal", true); 

        var type = component.get("v.type");
        var input = component.get("v.input");
        var mapOfSourceFieldTargetField = component.get("v.mapOfSourceFieldTargetField");
        var mapLabelColumns = component.get("v.mapLabelColumns");
        var action = component.get("c.getLovsByType");
        action.setParams({ type : type,
                           input : input,
                          mapOfSourceFieldTargetField : mapOfSourceFieldTargetField,
                          mapLabelColumns : mapLabelColumns});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
           
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
     */

})