({
    doInit : function(component, event, helper) {
        var integrazionetItemAttribute = component.get("v.integrazionetItem").NE__Order_Item_Attributes__r;
        if(integrazionetItemAttribute!= undefined && integrazionetItemAttribute!= null && integrazionetItemAttribute.records.length>0){
        	component.set("v.integrazionetItemAttribute",integrazionetItemAttribute.records);
        }
        var itemId = component.get("v.integrazionetItem.Id");
        component.set("v.itemId",itemId);
        var actionRetrieve = component.get("c.retrieveStatus");
        actionRetrieve.setParams({
            itemId : itemId
        });
        actionRetrieve.setCallback(this, function(response)
        {
            var state = response.getState();
            if (state === "SUCCESS") 
            {
              
                var res = response.getReturnValue();
                //Start antonio.vatrano wave2-153 02/08/2019
                if(res!=null && res.NE__Status__c=='Completed'){
                    component.set("v.isNotOperation",false);
                    component.set("v.itemHasBeenUpdated",true);
                //End antonio.vatrano wave2-153 02/08/2019
                    component.find("startDateInt").set("v.value",res.NE__StartDate__c);
                    component.find("endDateInt").set("v.value",res.NE__EndDate__c);
                }

            } 
            else if (state === "INCOMPLETE")
            {
                //do something
            }
            else if (state === "ERROR") 
            {
                var errors = response.getError();
                if (errors) 
                {
                    if (errors[0] && errors[0].message) 
                    {
                        console.log("OB_Maintenance_Consistenza_Log_RequestController.js : checkProfileOnLogRequestConsistenza : Error message: "
                            + errors[0].message);
                    }
                }
                else 
                {
                    console.log("OB_Maintenance_Consistenza_Log_RequestController.js : checkProfileOnLogRequestConsistenza : *UNKNOW ERROR*");
                }
            }
        });
        $A.enqueueAction(actionRetrieve);
    },

    save : function(component, event, helper){
        var startDate = component.find("startDateInt").get("v.value");
        var endDate = component.find("endDateInt").get("v.value");
        var action = component.find("actionInt").get("v.value");
        var itemId = event.getSource().get("v.name");
        console.log('startDate',typeof startDate);
        console.log('endDate',typeof endDate);
        console.log('action',typeof action);
        console.log('id',typeof itemId);
        /* TOAST VARIABLE ANDREA MORITTU END 18-Jul-19 - F2WAVE2 - 154*/
        var type;
        var title;
        var message;
        /* TOAST VARIABLE ANDREA MORITTU END 18-Jul-19 - F2WAVE2 - 154*/
        var actionSave = component.get("c.saveOrderItemIntegrazione");
        actionSave.setParams({
            action : action,
            startDate : startDate == undefined ? null : startDate,
            endDate : endDate == undefined ? null : endDate,
            itemId : itemId
        });
        actionSave.setCallback(this, function(response)
        {
            var state = response.getState();
            if (state === "SUCCESS") 
            {
               console.log(state);
               component.set("v.isNotOperation",false);
               
                /* ANDREA MORITTU START 18-Jul-19 F2WAVE2 - 154 - Added Success Message*/
               
                var updateIsDone = response.getReturnValue();
                if(updateIsDone) {
                    type     = 'Success'
                    title    = $A.get("$Label.c.OB_MAINTENANCE_TOAST_OPERATIONSUCCESSFULL");
                    message  = ' ';

                    // IF item has been updated successfully, disable save button
                    component.set('v.itemHasBeenUpdated', true);

                    helper.launchToast(component , event , helper , type , title , message);
                } else {
                    type     = 'Error'
                    title    = 'Servizio Momentaneamente non disponibile';
                    message  = ' ';
                    helper.launchToast(component , event , helper , type , title , message);
                }
                /* ANDREA MORITTU END 18-Jul-19 F2WAVE2 - 154 - Added Success Message*/
            } 
            else if (state === "INCOMPLETE")
            {
                //do something
            }
            else if (state === "ERROR") 
            {
                var errors = response.getError();
                if (errors) 
                {
                    if (errors[0] && errors[0].message) 
                    {
                        console.log("OB_Maintenance_Consistenza_Log_RequestController.js : checkProfileOnLogRequestConsistenza : Error message: "
                            + errors[0].message);
                            /* ANDREA MORITTU START 18-Jul-19 F2WAVE2 - 154 - Added Error Message*/
                            type     = 'Error'
                            title    = 'Servizio Momentaneamente non disponibile';
                            message  = ' ';
                            helper.launchToast(component , event , helper , type , title , message);
                            /* ANDREA MORITTU END 18-Jul-19 F2WAVE2 - 154 - Added Error Message*/
                    }
                }
                else 
                {
                    console.log("OB_Maintenance_Consistenza_Log_RequestController.js : checkProfileOnLogRequestConsistenza : *UNKNOW ERROR*");
                }
            }
        });
        //start antonio.vatrano 03/09/2019 WN 320
        if(action =='Remove' && typeof(endDate)=='undefined'){
            type     = 'Error'
            title    = 'Operazione non riuscita';
            message  = 'Attenzione, inserire la data di fine validità';
            helper.launchToast(component , event , helper , type , title , message);
        }else{
            $A.enqueueAction(actionSave);
        }
        //END antonio.vatrano 03/09/2019 WN 320
    }
})