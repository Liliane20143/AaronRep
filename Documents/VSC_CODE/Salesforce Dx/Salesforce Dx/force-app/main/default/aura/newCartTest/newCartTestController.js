({
    doInit : function(component, event, helper) {
        $A.createComponent("c:newCartLook", {
            
        }, function(newCmp) {
            if (component.isValid()) {
                component.set("v.body", newCmp);
            }
        });
    },
    
    NavigateComponent : function(component, event, helper) {
            $A.createComponent(event.getParam("componentName"), {
                //"CartServiceOutput": event.getParam("CartServiceOutput"),
                "offertaSelected": event.getParam("offertaSelected"),
                "offertaId": event.getParam("offertaId"),
                "listOfCategories": event.getParam("listOfCategories")
            }, function(newCmp) {
                if (component.isValid()) {
                    component.set("v.body", newCmp);
                }
            });

    }
    
})