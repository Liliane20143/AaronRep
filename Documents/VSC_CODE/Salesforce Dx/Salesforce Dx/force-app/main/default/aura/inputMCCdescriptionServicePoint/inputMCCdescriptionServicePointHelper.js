({
    createComponent : function(component, event) {
      
           $A.createComponent(
           "c:modalLookupWithPagination",
       {
           "aura:id": "modal",
           "objectString":component.get("v.objectString"),
           "type":component.get("v.type"),
           "subType":component.get("v.subType"),
           // "input":component.get("v.objectDataMap.pv.OB_MCC_Description__c"),
           "input": '',
           "mapOfSourceFieldTargetField":component.get("v.mapOfSourceFieldTargetField"),
           "mapLabelColumns":component.get("v.mapLabelColumns"),
           "objectDataMap":component.get("v.objectDataMap"),
           "messageIsEmpty":component.get("v.messageIsEmpty"),
           "orderBy":component.get("v.orderBy"),
           "level" : component.get("v.level"),
           "lookupLov" : component.get("v.lookupLov")
       },
           function(newModal, status, errorMessage){
               if (status === "SUCCESS") {
                   var body = component.get("v.body");
                   body.push(newModal);
                   component.set("v.body", body);
                   component.set("v.avoidDoubleClick", false);

               }
               else if (status === "INCOMPLETE") {
                   console.log("No response from server or client is offline.")
               }
               else if (status === "ERROR") {
                   console.log("Error: " + errorMessage);
               }
           }
       );
       console.log('level in helper: '+ component.get('v.level')); 
    },

    // START shaghayegh.tofighian 23/05/2019 R1F2-170 (get the coherent OB_MCC_Description__c by choosing OB_MCC__c WHEN OB_MCC__c & OB_MCC_Description__c are already filled and you want to rechoose OB_MCC__c.  )
    retrievLovMcc : function(component,objectDataMap){
        try{
            var action = component.get("c.getMccLovL2");
            //pass lookup of l3 that identify the parent l2
            action.setParams({lookupID : objectDataMap.order2.NE__Lov__c});
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log("RESPONSE " + JSON.stringify(response.getReturnValue()));
                    var responseMCCL2 = response.getReturnValue();
                    
                    console.log('RESPONSE mcc: ' + JSON.stringify( responseMCCL2));
                    objectDataMap.order.OB_MCC_Description__c   = responseMCCL2.Name;
                    /*
                    when i select a l3 mcc save on order node (l2 node) the mcc code
                    It can be on value4 or value2 
                    */
                   if(responseMCCL2.NE__Value2__c){
                       objectDataMap.order.OB_MCC__c               = responseMCCL2.NE__Value2__c;
                       
                    }else{
                        objectDataMap.order.OB_MCC__c               = responseMCCL2.OB_Value4__c;
                    }
                    
                    objectDataMap.order.hasLeve3                = responseMCCL2.NE__Value1__c;
                    objectDataMap.order.OB_tmp_MCC__c           = responseMCCL2.OB_Value4__c;
                    objectDataMap.order.MCC_level               = responseMCCL2.NE__Value3__c;
                    component.set("v.objectDataMap", objectDataMap);
                }
                else if (state === "INCOMPLETE") {
                 console.log('State INCOMPLETE');  //shaghayegh.tofighian 28/05/2019  R1F2-170 add consolelog
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                            errors[0].message);
                            var errorMex = errors[0].message;
                            this.showToast(component,event,helper,errorMex,'Errore'); //shaghayegh.tofighian 28/05/2019  R1F2-170 add toast
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        }
        catch(err){
            this.showToast(component,event,helper,'Si prega di riprovare','Errore');  //shaghayegh.tofighian 28/05/2019  R1F2-170 add toast
        }
    },
     showToast :function(component,event,helper,errorLabelMessage,errorLabelTitle){
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
        "type": "error",
        "title": errorLabelTitle,
        "message": errorLabelMessage
    });
    toastEvent.fire();
}
    // END shaghayegh.tofighian 23/05/2019  R1F2-170 (get the coherent OB_MCC_Description__c by choosing OB_MCC__c WHEN OB_MCC__c & OB_MCC_Description__c are already filled and you want to rechoose OB_MCC__c.  )
})