({
	getMissingInformation : function(component) {
		var objectDataMap 	= component.get('v.objectDataMap'),
			merchantId		= objectDataMap.merchant.Id,
			servicePointId	= objectDataMap.pv.Id,
			configurationId   = objectDataMap.Configuration.Id;//antonio.vatrano 23/05/2019 add configurationId
		try{
			console.log('OBJ LAST STEP: '+ JSON.stringify(objectDataMap));
			console.log('PARAMS: ' +merchantId + ' , ' +  servicePointId + ' , ' + configurationId);
			var action = component.get("c.checkMissingField");
			action.setParams({ 	'merchantId' : merchantId , 
								'servicePointId' : servicePointId,
								'configurationId' : configurationId }); //antonio.vatrano 23/05/2019 add configurationId
			action.setCallback(this, function(response) {
				var state = response.getState();
				console.log('STATE LAST STEP: ' + state);
				if (state === "SUCCESS") {
					
					var missingFieldsBoolean = response.getReturnValue();
					component.set('v.objectDataMap.missingFieldsBoolean' , missingFieldsBoolean);
					component.set('v.objectDataMap' , objectDataMap);
					console.log('IF CONDITION ' + (missingFieldsBoolean==true || missingFieldsBoolean=='true'));
					if(missingFieldsBoolean==true || missingFieldsBoolean=='true'){
						// warning alert because there are missing fields
						console.log('into if method toast');
						var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams({
							title: $A.get("$Label.c.OB_MissingFieldTitle"),
							type 		: 'warning',
							duration: '7000',
							message	: $A.get("$Label.c.OB_MissingFieldMessage")
						});
						toastEvent.fire();
						console.log('VALUE IN OBJ IS: ' + component.get('v.objectDataMap.missingFieldsBoolean'));
					}
				}
				else if (state === "ERROR") {
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							console.log("Error message: " + 
									errors[0].message);
						}
					} else {
						console.log("Unknown error");
					}
				}
			});

			$A.enqueueAction(action);
		}catch(err){
			alert(err.message);
		}
		
	},
	
})