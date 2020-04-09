({
    /*  @Author :   Morittu Andrea
        @Date_  :   18-Jul-19
        @Task   :   F2WAVE2-154 - Fix
    */
   launchToast : function(component, event, helper, type,  title, message) {
    var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams ({
            type: type,
            title: title,
            message: message,
            mode: "dismissible" });
        toastEvent.fire();
        if(type == 'Success') {
            component.set('v.isNotOperation', false);
        }                        
}
})