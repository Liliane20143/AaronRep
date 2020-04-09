({
	handleClick: function(component, event , helper)
    {   
		var idAcc = component.get("v.recordId");
		console.log('Account id: '+idAcc);
		 
		helper.getAcc(component, idAcc);
		
	},

	responseServicePointChange : function(component, event, helper){
		console.log("response Service Point has changed: " + component.get("v.responseServicePoint"));
		helper.updateServicePoint(component, component.get("v.recordId"));
		$A.get('e.force:refreshView').fire(); 
		
		var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				title: "Merchant Update From Service",
				message: "The merchant is updated!",
				type: "success"
			}).fire();
		
		$A.get("e.force:closeQuickAction").fire(); 
	}

})