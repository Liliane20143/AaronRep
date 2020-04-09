/**
 * Created by adrian.dlugolecki on 09.07.2019.
 */
({
    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 06/03/2019
    * @task NEXI-178
    * @description Method make init
    */
    makeInit : function(component,event,helper)
    {
        console.log('OB_LCP008_ChangeCompanyData init'); //NEXI-292 Kinga Fornal <kinga.fornal@accenture.com> 02/09/2019
        let initComponentAction = component.get("c.retrieveDataForEditAccount");
        initComponentAction.setParams({
            inAccountId : component.get("v.recordId")
        });
        initComponentAction.setCallback(this, $A.getCallback(function (response)
        {
            let state = response.getState();
            if (state === "SUCCESS")
            {
                let result = response.getReturnValue();
                if(result.isError)
                {
                    helper.showToast( $A.get("$Label.c.OB_MAINTENANCE_ERROR"), $A.get("$Label.c.OB_ServerLogicFailed"), 'error');
                    console.log('OB_LCP008_ChangeCompanyData error CODE:001 '+result.errorMessage);
                    return;
                }
                component.set("v.flowData",result.resultJSON);
                component.set("v.showButton",result.showButton);
                component.set("v.isInitDone",true);
            }
            else
            {
                helper.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR"), $A.get("$Label.c.OB_ServerLogicFailed"), 'error');
                console.log('OB_LCP008_ChangeCompanyData error CODE:002');
            }
        }));
        $A.enqueueAction(initComponentAction);
    },

    showModalHandler : function(component,event,helper)
    {
        component.set("v.showModal",true);
    }
})