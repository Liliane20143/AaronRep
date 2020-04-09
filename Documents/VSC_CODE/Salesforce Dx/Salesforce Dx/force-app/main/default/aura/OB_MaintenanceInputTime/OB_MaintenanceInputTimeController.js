({
	doInit : function(component, event, helper) {
		helper.launchDoInit(component, event, helper);
	},
	
	valorizationInputTime : function(component, event, helper){
		var	openingTime			= 	 component.find("openingTime");
		var	closingTime			=    component.find("closingTime");
		var	breakStartTime		=    component.find("breakStartTime");
		var	breakEndTime		=    component.find("breakEndTime");
		try {
			if( (	typeof(openingTime)		!= undefined && 
					typeof(closingTime)		!= undefined && 
					typeof(breakStartTime)	!= undefined && 
					typeof(breakEndTime)	!= undefined ) 
					&&
				(	openingTime 			!= null && 
					closingTime 			!= null && 
					breakStartTime 			!= null && 
					breakEndTime 			!= null 	)
					&&
				(	openingTime 			!= "" &&
					closingTime 			!= "" &&
					breakStartTime 			!= "" &&
					breakEndTime 			!= "") 	)	{
					
					openingTime					=	component.find("openingTime").get("v.value");
					closingTime 				=	component.find("closingTime").get("v.value");
					breakStartTime 				=	component.find("breakStartTime").get("v.value");
					breakEndTime 				=	component.find("breakEndTime").get("v.value");
		
					console.log('open ' + openingTime);
					console.log('closingTime ' + closingTime);
					console.log('breakStartTime ' + breakStartTime);
					console.log('breakEndTime ' + breakEndTime);
						
					helper.checkCoherencyDateHelper(component, event, helper, openingTime, closingTime, breakStartTime, breakEndTime);
			}
		}  catch(err) {
    		console.log('Catch message is : ' + err.message);
		}
	}
		
})