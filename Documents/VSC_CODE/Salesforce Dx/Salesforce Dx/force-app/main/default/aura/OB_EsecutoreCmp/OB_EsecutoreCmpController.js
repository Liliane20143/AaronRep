({
	doInit : function(component, event, helper) {
        console.log('sono nel TEST Esecutore component');
        var appEvent = $A.get("e.c:OB_EventNextButton");
        var stepName = component.find("stepId").get("v.value");
        console.log('name of step in princing test: ' + stepName);
        appEvent.setParams({"idStep" : stepName  });
        appEvent.fire();
		
	},

	beforeNext: function(component, event, helper) {
		console.log('sono nel before next per inserimento di esecutore');
        var objectDataMap = component.get("v.objectDataMap");

            var step=1; 
            var data = {};
            var key='Object';
            data[key] = component.get("v.objectDataMap");
            console.log("the data key in esecutore is: " + JSON.stringify(data['Object']) + " AND THE OBJ IS: " + JSON.stringify(component.get("v.objectDataMap")));
            var targetObjectKey = component.get("v.objectKey");
            var method = 'createEsecutore'; 
            var stepsDefinition= null;
            var dynamicWizardWrapper = null;
            //chiamo helper
           // helper.saveServicePointData( component , step , data , key , targetObjectKey , method ,  stepsDefinition , dynamicWizardWrapper);
            var action = component.get("c.insertDataEsecutore");
            console.log("HO CHIAMATO IL METODO PER ESECUTORE");
            action.setParams({"step" : step , "data" : data , "targetObjectKey" : targetObjectKey ,"method" : method , "stepsDefinition":stepsDefinition , "dynamicWizardWrapper" : dynamicWizardWrapper });
            action.setCallback(this, function(response) 
                               {
                                   var state = response.getState();
                                   if (state === "SUCCESS")
                                   {
                                       console.log("RESPONSE BEFORE NEXT Esecutore " + JSON.stringify(response.getReturnValue()));
                                       component.set("v.objectDataMap",response.getReturnValue());
                                      
                               }
                               
                               else if (state === "INCOMPLETE") 
                               {
                                   // do something
                                   component.set( "v.toggleSpinner" , false);
                               }
                                   else if (state === "ERROR") 
                                   {
                                       console.log('ERROR IN CONTATORE ZERO');
                                       var errors = response.getError();
                                       if (errors) {
                                           if (errors[0] && errors[0].message) 
                                           {
                                               console.log("Error message: " + 
                                                           errors[0].message);
                                           }
                                       } 
                                       else 
                                       {
                                           console.log("Unknown error");
                                       }
                                   }
                           });
            
            $A.enqueueAction(action);
            component.set("v.objectDataMap.unbind.NextStepEsecutore", 'Next');
            document.getElementById('input:unbind:NextStepEsecutore').value= 'Next'; 
            if(document.getElementById('input:unbind:NextStepEsecutore').value != null){
                document.getElementById('input:unbind:NextStepEsecutore').dispatchEvent(new Event('blur'));
            }
            
        }

    


    
})