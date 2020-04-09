({
          doInit: function(component, event, helper) {
                // Fetch the account list from the Apex controller
          console.log("*** do init ***" );
        var action = component.get("c.getCommercialProductId");
        // Set up the callback
       
        action.setCallback(this, function(response) {
            
            console.log("RESPONSE " + JSON.stringify(response.getReturnValue()));
            component.set("v.orderItemList", response.getReturnValue());   
            console.log("RESPONSE orderItemList ******" + JSON.stringify(component.get("v.orderItemList")));
                                   
        });
        $A.enqueueAction(action);
     
      },
    
    
    
    
        deleteAccount: function(component, event, helper) {
            // Prevent the form from getting submitted
            event.preventDefault();
            // Get the value from the field that's in the form
            var accountName = event.target.getElementsByClassName('account-name')[0].value;
            confirm('Generate the ' + accountName + ' account? (don’t worry, this won’t actually work!)');
      },
    
    
	      doSearch : function(component, event, helper) {
       
                
        var objectDataMap = component.get("v.objectDataMap");
        var orderInputId = component.get("v.inputProduct");
        console.log("RESPONSE orderInputId ----->>>>" + orderInputId);
        
         
        var action = component.get("c.getTemplateId");
        
        
        action.setParams({ orderInputId : orderInputId});
        
        action.setCallback(this, function(response) 
                           {
                               var state = response.getState();
                               console.log("the state is  "+ state);
                               if (state === "SUCCESS") {
                                   console.log("RESPONSE " + JSON.stringify(response.getReturnValue()));
                                
                                   component.set("v.templateList", response.getReturnValue());   
                                   console.log("RESPONSE templateList ******" + JSON.stringify(component.get("v.templateList")));
                                   
                                   /*component.set('v.columns', [
                                       {label:"Template ID",fieldName: 'OB_TemplateId__c',   type: 'text'},
                                       {label: "Start Date",fieldName: 'OB_Start_Date__c', type: 'date'},
                                       {label: "End Date",fieldName: 'OB_End_Date__c', type: 'date'},
                                       {label: "Commercial Product Name",fieldName: 'OB_Commercial_Product__c', type: 'text'}
                                   ]);*/
                                   
                               }
                               else if (state === "INCOMPLETE") 
                               {
                                   // do something
                                   console.log("INCOMPLETE state ^.^ " );
                               }
                                   else if (state === "ERROR") 
                                   {
                                       // alert('You have to insert the new service point');
                                       var errors = response.getError();
                                       if (errors) {
                                           if (errors[0] && errors[0].message) 
                                           {
                                               console.log("Error message: " + 
                                                           errors[0].message);
                                           }
                                       } else 
                                       {
                                           console.log("Unknown error");
                                       }
                                   }
                           });
        $A.enqueueAction(action);
        
        
        
        
		
	}
})