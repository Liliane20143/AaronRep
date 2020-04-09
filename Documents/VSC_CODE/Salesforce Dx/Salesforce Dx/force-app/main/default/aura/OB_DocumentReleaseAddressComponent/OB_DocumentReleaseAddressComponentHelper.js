({
	getDocTypes : function (component , helper , event )
	{
		var actionGetReportTypeValues = component.get("c.getDocTypeValues");
		var objectDataMap = component.get("v.objectDataMap");
		actionGetReportTypeValues.setCallback(this, function(response)
		{
			 var state = response.getState();
			 if (state === "SUCCESS") 
			 {
				 var  tempMap =[];
				 var  responseMap= response.getReturnValue();
				 for(var key in responseMap)
				 {
					tempMap.push({value:responseMap[key], key:key});
				 }
				 component.set( "v.docTypeList",  tempMap);
				 console.log("Value of picklist report type: "+tempMap);
			 } 
			 else if (state === "INCOMPLETE") 
			 {
				 // do something
			 }
			 else if (state === "ERROR") 
			 {
				var errors = response.getError();
				if (errors) 
				{
					if (errors[0] && errors[0].message) 
					{
						console.log("Error message: " + errors[0].message);
					}
				}
				else 
				{
					console.log("Unknown error");
				}
			 }
		 });
		$A.enqueueAction(actionGetReportTypeValues); 
	},
	getDocAuth : function (component , helper , event )
	{
		var actionGetReportTypeValues = component.get("c.getDocAuthValues");
		var objectDataMap = component.get("v.objectDataMap");
		actionGetReportTypeValues.setCallback(this, function(response)
		{
			 var state = response.getState();
			 if (state === "SUCCESS") 
			 {
				 var  tempMap =[];
				 var  responseMap= response.getReturnValue();
				 for(var key in responseMap)
				 {
					tempMap.push({value:responseMap[key], key:key});
				 }
				 component.set( "v.docAuthList",  tempMap);
				 console.log("Value of picklist report type: "+tempMap);
			 } 
			 else if (state === "INCOMPLETE") 
			 {
				 // do something
			 }
			 else if (state === "ERROR") 
			 {
				var errors = response.getError();
				if (errors) 
				{
					if (errors[0] && errors[0].message) 
					{
						console.log("Error message: " + errors[0].message);
					}
				}
				else 
				{
					console.log("Unknown error");
				}
			 }
		 });
		$A.enqueueAction(actionGetReportTypeValues); 
	},
	removeRedBorder: function (component, event , helper){
       
        //GET THE CURRENT ID FROM INPUT 
        var currentId = event.target.id; 
        console.log("current id is: " + currentId);
        $A.util.removeClass(document.getElementById(currentId) , 'slds-has-error');
        //RECREATE THE SAME ID OF ERROR MESSAGE
        var errorId = 'errorId'+ currentId;
        if(document.getElementById(errorId)!=null){
            console.log("errorID . " + errorId);
            document.getElementById(errorId).remove();
        }
    }, 
    removeRedBorderDocPick: function (component, event , helper){
    	var names = [component.get('v.docTypeId'), component.get('v.docAuthId')];
        for(var i=0; i<names.length; i++){ 
	        //GET THE CURRENT ID FROM INPUT 
	        var currentId = names[i];
	        console.log("current id is: " + currentId);
	        $A.util.removeClass(document.getElementsByName(currentId)[0] , 'slds-has-error');
	        //RECREATE THE SAME ID OF ERROR MESSAGE
	        var errorId = 'errorId'+ currentId;
	        if(document.getElementById(errorId)!=null){
	            console.log("errorID . " + errorId);
	            document.getElementById(errorId).remove();
	        }
	    }
    }, 
    removeRedBorderDate: function (component, event , helper){
       var ids = [component.get('v.birthDateId'), component.get('v.docRelDateId'), component.get('v.docExpDateId')];
      for(var i=0; i<ids.length; i++){ 
	        //GET THE CURRENT ID FROM INPUT 
	        var currentId = ids[i];
	        console.log("current id is: " + currentId);
	        var idSet = document.getElementsByClassName(currentId)[0];
	        
	        idSet.style.border = "";
			idSet.style.borderColor = "";
	        //RECREATE THE SAME ID OF ERROR MESSAGE
	        var errorId = 'errorId'+ currentId;
	        if(document.getElementById(errorId)!=null){
	            console.log("errorID . " + errorId);
	            document.getElementById(errorId).remove();
	        }
	    }
	},


	/*
		*	Author		:	Morittu Andrea
		*	Date		:	17-Sept-2019
		*	Task		:	BACKLOG-10
		*	Description	:	Check If Pagobancomat are present inside the offer
	*/
	checkIfBagopancomatArePresent : function(component, event, helper) {

        return new Promise(function(resolve, reject) {
			let orderId = component.get('v.objectDataMap.Configuration.Id');
			if(!$A.util.isUndefined(orderId) && !$A.util.isEmpty(orderId)) {
				var action = component.get("c.pagoBancomatArePresent");
				action.setParams({ orderId : orderId });
	
			    action.setCallback(this, function(response) {
					var state = response.getState();
					if (state === "SUCCESS") {
						pagoBancomatArePresent = response.getReturnValue();
						resolve(pagoBancomatArePresent);
					} else if (state === "INCOMPLETE") {
						
					} else if (state === "ERROR") {
						var error = new Error(response.getError());
						reject(error);
						var errors = response.getError();
					} else {
						console.log("Unknown error");
					}
				});
				$A.enqueueAction(action);
			}
		});
	},

})