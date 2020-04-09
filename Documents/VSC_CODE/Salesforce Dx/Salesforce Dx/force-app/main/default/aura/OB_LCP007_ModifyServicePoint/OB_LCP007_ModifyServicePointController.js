/*
 * Created by damian.krzyzaniak on 15.07.2019
*/
({
    /**
    * @author Damian Krzyzaniak <damian.krzyzaniak@accenture.com>
    * @date 15/07/2019
    * @task NEXI-184
    * @description Method make init
    */
    init : function(component, event, helper) {
            let action = component.get('c.retrieveDataForServicePoint');
            action.setParams({
                "inServicePointId": component.get("v.recordId")
            });
            action.setCallback(this, $A.getCallback(function (response) {
            let state = response.getState();
            if (state === "SUCCESS")
                {
                    let returnValue = response.getReturnValue();
                    if(returnValue['errorMessage'])
                    {
                        helper.showToast( $A.get("$Label.c.OB_MAINTENANCE_ERROR"), $A.get("$Label.c.OB_ServerLogicFailed"), 'error');
                        console.log('OB_LCP007_ModifyServicePoint error in controller OB_LCC007_ModifyServicePoint: ' + returnValue['errorMessage']);
                    }else
                    {
                        component.set("v.flowData",returnValue['result']);
                    }
                }
                else
                {
                    helper.showToast( $A.get("$Label.c.OB_MAINTENANCE_ERROR"), $A.get("$Label.c.OB_ServerLogicFailed"), 'error');
                    console.log('OB_LCP007_ModifyServicePoint error');
                }}));
            $A.enqueueAction(action);
    },
})