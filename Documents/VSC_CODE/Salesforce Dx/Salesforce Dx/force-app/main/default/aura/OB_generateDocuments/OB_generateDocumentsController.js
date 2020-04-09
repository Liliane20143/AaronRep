({
  	doInit : function(component, event, helper) {
		var action = component.get("c.getContractList");
        
        //var arrayListNotEmpty= [];
        action.setCallback(this, function(response) {
            
            console.log("RESPONSE " + JSON.stringify(response.getReturnValue()));
            /*for (var i =0; response.getReturnValue().length; i++){
              if(response.getReturnValue().OB_Description_contract__c != ''){
                   arrayListNotEmpty.add(response.getReturnValue().[i]);
              }
            }*/
            component.set("v.documentsList", response.getReturnValue());   
            console.log("RESPONSE documentsList ******" + JSON.stringify(component.get("v.documentsList")));
            //console.log("arrayListNotEmpty ******" + JSON.stringify(arrayListNotEmpty));
                                   
        });
        $A.enqueueAction(action);
     
 	}
})