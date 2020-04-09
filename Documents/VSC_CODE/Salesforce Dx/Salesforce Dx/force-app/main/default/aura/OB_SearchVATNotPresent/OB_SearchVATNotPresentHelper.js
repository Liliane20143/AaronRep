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
})