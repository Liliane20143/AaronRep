({
    /*
        *@author antonio.vatrano antonio.vatrano@accenture.com
        *@date 18/04/2019
        *@init function: retrive all data of current servicePoint, user, and build flowdata for OB_Maintenance_EditServicePoint
    */

    init : function(component, event, helper) {
        console.log("@@init");
        var recordId= component.get("v.recordId");
        console.log("@@init Id: "+recordId);
        try {
            var action = component.get('c.retrieveSP');
            action.setParams({
                "servicePointId": recordId
            });
            action.setCallback(this, $A.getCallback(function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var valueReturns = response.getReturnValue();
                    console.log('@@@result' + JSON.stringify(valueReturns['result']));
                    console.log('@@@profile' + JSON.stringify(valueReturns['profile']));
                    if(valueReturns['profile'] == 'Operation'){
                        component.set("v.OperationUser",true);
                    }
                    component.set("v.FlowData",valueReturns['result']);
                    component.set("v.retrieveDone",true);
                    
                }
            }));
            $A.enqueueAction(action);
        } catch (err) {
            console.log('SEARCH ERROR EXCEPTION:' + err);
        }
        

    },

     /*
        *@author antonio.vatrano antonio.vatrano@accenture.com
        *@date 18/04/2019
        *@function: open modal
    */
    showModalModify : function(component, event, helper){
        console.log("@@Modal");
        component.set("v.showModal", true);
    },


})