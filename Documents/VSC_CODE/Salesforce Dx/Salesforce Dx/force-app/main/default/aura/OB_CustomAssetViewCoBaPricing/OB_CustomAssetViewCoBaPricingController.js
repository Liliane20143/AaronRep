({
    doInit : function(component, event, helper) {
        console.log('DO INIT OB_CUSTOMASSETVIEWCoBaPricing FIRED');
        helper.doInitHelper(component, event, helper);
    },
    
    openModal : function(component, event, helper) {
        // WE CAN MANAGE THIS ATTRIBUTE AND PASS IT FROM THE MAIN COMPONENT
        component.set("v.showCoBaModal", true);
    },
 
    closeModal : function(component,event, helper) { 
        component.set("v.showCoBaModal", false); 
    }
})