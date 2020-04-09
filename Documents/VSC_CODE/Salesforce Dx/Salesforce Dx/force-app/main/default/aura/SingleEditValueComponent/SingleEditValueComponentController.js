({
    enableEdit : function(component, event, helper) {
        component.set("v.enableEdit",true);
        window.setTimeout(
            $A.getCallback(function () {
                component.find("input").focus();
            }), 1
        );
    },
    disableEdit : function(component, event, helper) {
        component.set("v.enableEdit",false);
    }, 
    formPress: function(component, event, helper) {
        
        if (event.keyCode === 13){
            component.set("v.enableEdit",false);         
        }
    },
})