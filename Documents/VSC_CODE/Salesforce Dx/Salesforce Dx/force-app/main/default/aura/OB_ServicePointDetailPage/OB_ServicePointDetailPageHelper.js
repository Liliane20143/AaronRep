({
	 // START Elena Preteni MAIN_62_R1F1
    getAbi : function(component, helper,event){
    	var actionAbi = component.get('c.getAbi');
	    actionAbi.setCallback(this, function (response) {
	        var state = response.getState();
	        console.log('STATE L2: ' + state);
	        if (state === "SUCCESS") 
	        {	
	            component.set('v.proposerABI',response.getReturnValue());
	            console.log('PROPOSER ABI --> '+component.get("v.proposerABI"));
	            component.set("v.isLoadedAbi",true);
	        }
	        else if (state === "ERROR") 
	        {
	                var errors = response.getError();
	                console.log(errors);
	        }
	    });
        $A.enqueueAction(actionAbi);
   	}
	// END Elena Preteni MAIN_62_R1F1
})