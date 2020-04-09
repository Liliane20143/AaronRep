({
	doInit : function(component, event, helper) {
		helper.getAcqChanges(component, event);

	},
	handleExit : function(component, event, helper){
		helper.createLogRequest(component, event);
	},

	// showDocuments : function(component, event, helper){
	// 	var isDocumentListEmpty = event.getParam("isDocumentListEmpty");
	// 	component.set("v.isDocumentListEmpty",isDocumentListEmpty);
	// 	component.set("v.documentsLoaded",true);
	// }

})