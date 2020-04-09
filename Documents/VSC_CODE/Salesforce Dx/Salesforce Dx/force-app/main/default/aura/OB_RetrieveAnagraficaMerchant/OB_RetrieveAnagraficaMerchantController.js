({
	handleClick: function(component, event , helper)
    {   
		var idAcc = component.get("v.recordId");
		setTimeout(function () { $A.get("e.force:closeQuickAction").fire() }, 5000);
		console.log('Account id: '+idAcc);
		helper.getAcc(component, idAcc);

	},

	responseMerchantChange : function(component, event, helper){
		console.log("response Merchant has changed: " + component.get("v.responseMerchant"));
		helper.updateMerchant(component, component.get("v.recordId"));
		$A.get('e.force:refreshView').fire(); 
		
		var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						title: "Merchant Update From Service",
						message: "The merchant is updated!",
						type: "success"
					});
		toastEvent.fire();

		$A.get("e.force:closeQuickAction").fire(); 
	}

})