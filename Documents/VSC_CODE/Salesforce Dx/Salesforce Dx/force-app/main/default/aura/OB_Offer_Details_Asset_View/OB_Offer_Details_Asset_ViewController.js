({
    openPricingModal : function(component, event, helper) {
        component.set("v.showPricing", true);
        
        // component.set("v.showOffer", false);
    },
    closeModal :function(component, event, helper){
        component.set("v.showOffer", false);
    },
    closeModalPricing:function(component, event, helper) {
        component.set("v.showPricing", false);
        // component.set("v.showOffer", true);
    }
})