({
	// changeFlowStep : function(component, event, helper) 
	// {
	// 	console.log("FlowStep: "+component.get("v.FlowStep"));	
	// 	console.log("modifyServicePointId: "+component.get("v.modifyServicePointId"));	
	// }
	/*
		@Author	:	francesca.ribezzi
		@methodName: handleRefresh
		@Date	:	21/06/19
		@Task	:	descoping-consistenza
	*/
	handleRefresh : function(component, event, helper){
		console.log("into handleRefresh");	
		var fiscalCode = event.getParam('fiscalCode');
		console.log("fiscalCode: " + fiscalCode);	
		component.set("v.FlowStep", true);
		component.set("v.searchStep", true);
		component.set("v.fiscalCode", fiscalCode);
	
	}
})