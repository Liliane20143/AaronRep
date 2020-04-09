({
    /*
	* Author : Giovanni Spinelli
	* Date : 06/05/2019 
	* Description : call apex future method to deprecate all contrat generated.
	*/
    deprecateAllContracts : function(component, contractsIdList) {
        console.log('*****id list: ' +contractsIdList);
        var merchantId      = component.get('v.objectDataMap.merchant.Id'),
            servicePointId  = component.get('v.objectDataMap.pv.Id'),
            orderId         = component.get('v.objectDataMap.Configuration.Id');
        console.log('params: ' + merchantId + ' '+servicePointId+'  '+orderId);
        var action = component.get("c.deprecateContracts");
        action.setParams({   merchantId     :   merchantId,
                            servicePointId  :   servicePointId,
                            orderId         :   orderId,
                            contractsIdList :   contractsIdList
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('STATE IN DEPRECATE ALL CONTRACTS IS: '+ state);
            if(state === "SUCCESS"){
                var message = $A.get("$Label.c.OB_RegenerateContracts");
                var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
				    message:message,
					duration: '7000',
					type: 'info',
					mode: 'dismissible'
				});
				toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
})