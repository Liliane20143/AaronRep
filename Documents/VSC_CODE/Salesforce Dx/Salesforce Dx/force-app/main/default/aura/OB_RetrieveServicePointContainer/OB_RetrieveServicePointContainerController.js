({
	handleClick: function(component, event , helper)
    {   
		var idAcc = component.get("v.recordId");
		console.log('Account id: '+idAcc);
		helper.getAcc(component, idAcc);
	},

	responseServicePointChange : function(component, event, helper){
		console.log("response Service Point has changed: " + component.get("v.reponseMerchant"));
		helper.updateServicePoint(component, component.get("v.recordId"));
		$A.get('e.force:refreshView').fire(); 
		$A.get("e.force:closeQuickAction").fire(); 
	}

})