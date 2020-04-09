({
    performSearchOnServer : function(component, event, helper,wrapper ){
        console.log('performSearchOnServer start');
         console.log('performSearchOnServer wrapper is '+wrapper);
         try{
            var action = component.get('c.search');
            action.setParams({ 
                "jsonWrap" : wrapper
            });
            action.setCallback(this, $A.getCallback(function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var valueReturns = response.getReturnValue();
                    console.log('performSearchOnServer --> '+valueReturns);
                    var result = JSON.parse( valueReturns );
                    if(result.outcome == $A.get("$Label.c.OB_MAINTENANCE_NOERROR")){
                        console.log('no error on outcome');
                        component.set("v.FlowData",valueReturns);
                        component.set("v.FlowStep", $A.get("$Label.c.OB_MAINTENANCE_STEP_SUMMARY"));
                        component.set("v.showOffer", true);
                    }
                    else{
                        console.log('error on outcome'); 
                        this.showToast(component, event, helper,$A.get("$Label.c.OB_MAINTENANCE_TOASTERROR"), result.errorMessage, "error");
                        //this.toggleSpinner(component);//START Andrea Saracini 18/03/2019 Card No Present
                    }
                    //component.set('v.InternalUser', response.getReturnValue());
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    console.error(errors);
                }
            }));
            $A.enqueueAction(action);   
            }catch(err) {
                    console.log ('SEARCH ERROR EXCEPTION:'+ err);
            } 
        },
        showToast: function (component, event, helper,title, message, type) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": title,
                "message": message,
                "type": type
            });
            toastEvent.fire();
        }
})