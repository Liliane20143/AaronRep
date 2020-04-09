({
    getEmployeesNumberPicklistValues: function (component , helper , event ){
        var actionGetEmployeesNumber = component.get("c.getEmployeesNumber");
        actionGetEmployeesNumber.setCallback(this, function(response)  {
            var state = response.getState();
            console.log(' employee state is: ' + state);
            if (state === "SUCCESS") {
                
                var  tempMap =[];
                var  responseMap= response.getReturnValue();
            for(var key in responseMap) {
                tempMap.push({value:responseMap[key], key:key});
            }
                component.set( "v.employeesNumberList",  tempMap);
                console.log( 'employees list is: ' + component.get("v.employeesNumberList"));
            }
            else if (state === "INCOMPLETE")  {
                // do something
            }
                else if (state === "ERROR")  {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message)  {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(actionGetEmployeesNumber);
    }, 

    removeBorderPicklist: function (component, event, helper){
        //*********************************************REMOVE RED BORDER AND MESSAGE FROM ANNUAL REVENUE AND EMPLOYEES NUMBER-START*********************************************//
        var annualRevenue    = component.find("annualRevenue");
        var annualNegotiated = component.find("annualNegotiated");
        var employeesNumber  = component.find("employeesNumber");
        //MAP OF PICKLIST IN PAGE: KEYS ARE THE ID NAME AND VALUE THE COMPONENT
        var mapPicklist = { "employeesNumber": employeesNumber};
        try {
            for(var keys in mapPicklist) {
                console.log("PICKLIST values: " + JSON.stringify(mapPicklist[keys]) + "keys: "+ keys);
                //ITERATION ON THE VALUE OF EACH COMPONENT
                //IF THE VALUE ISN'T NULL, REMOVE THE RED BORDER
                if(mapPicklist[keys].get("v.value")!='') {
                    console.log("PICKLIST VALUE IS: "+ mapPicklist[keys].get("v.value"));
                    $A.util.removeClass(mapPicklist[keys]          , 'slds-has-error flow_required');
                    //IF THERE IS AN ERROR MESSAGE, REMOVE IT
                    if(document.getElementById('errorId'+keys)) {
                        console.log("REMOVE MESSAGE METHOD: " + document.getElementById('errorId'+keys) );
                        try {
                            document.getElementById('errorId'+keys).remove();
                        }
                        catch(err) {
                            console.log('remove borderd from picklist err.message: ' + err.message);
                        }

                    }
                        
                }
            }
        }catch(err){
            console.log('err.message: ' + err.message);
           }
    },

    removeRedBorder: function (component, event , helper){
       
        try{
               //GET THE CURRENT ID FROM INPUT 
               var currentId = event.target.id; 
               console.log("current id in remove red border is: " + currentId);
           }catch(err){
            console.log('err.message: ' + err.message);
           }
            //RECREATE THE SAME ID OF ERROR MESSAGE
            var errorId = 'errorId'+ currentId;
            //var changeClass = component.find(errorId);
            //REMOVE RED BORDER
            //REMOVE ERROR MESSAGE
           if(!$A.util.isEmpty(document.getElementById(errorId))){ //francesca.ribezzi 15/11/19 - PROD-107 - using util.isEmpty  
            console.log("errorID . " + errorId);
                document.getElementById(errorId).remove();
            }
        }
})