({
    getAbiList : function(component, event) {
        var act = component.get("c.getAvailableABI");
		var availableABI = [];
		var activeABI = [];
		var activeABIobj = [];
        act.setParams({ 
			offerId: component.get("v.offer.Id")
		});
		act.setCallback(this, function(response){
			var state = response.getState();		 					
			if (state === "SUCCESS")
			{
				var resp = response.getReturnValue();
				console.log('### resp: ', resp);
				if(!$A.util.isEmpty(resp)){
					for(var key in resp.availableAbi){
						var abi = {value: key, label: resp.availableAbi[key]};
						availableABI.push(abi);
					}
					for(var key in resp.activeAbi){
						var abi = {value: key, label: resp.activeAbi[key]};
						availableABI.push(abi);
						activeABI.push(abi.value);
						activeABIobj.push(abi);
					}
					component.set("v.availableABIList",availableABI);
					component.set("v.activeABIList",activeABI);
					component.set("v.activeABIObj",activeABIobj);
				}else{
					console.log('### No Abi found');
				}
			}
			else if (state === "ERROR") 
			{
				var errors = response.getError();
				console.log("errors: "+errors);
			}
		});
		$A.enqueueAction(act);
    }

})