({ 
	doInit : function(component, event, helper)
	{
		console.log("@DO INIT OF CONTAINER");
		var objectDataMap 		= component.get("v.objectDataMap");
		//giovanni spinelli 15/02/2019 manage if the merchant hasn't FATECO field - start

		// NEXI-93 Marta Stempien <marta.stempien@accenture.com> 27/05/2019  - Start
		if(component.get('v.fromMaintenance')&&(!$A.util.isUndefinedOrNull(objectDataMap.acc))){
		    objectDataMap.merchant = objectDataMap.acc;
        }
        // NEXI-93 Marta Stempien <marta.stempien@accenture.com>   27/05/2019  - Stop
		try{
			console.log('OB_ATECO__c: '+ objectDataMap.merchant.OB_ATECO__c);
			if(objectDataMap.merchant.OB_ATECO__c){
				console.log('THERE IS ATECO');
				//show ateco field
				component.set("v.showATECO",true);
				component.set('v.objectDataMap.merchant.OB_FATECO__c' , 'S');

			}else{
				component.set('v.objectDataMap.merchant.OB_FATECO__c' , 'N');
			}
		}catch(err){
			console.log('ERROR FATECO: '+  err.message);
		}
		
		//giovanni spinelli 15/02/2019 manage if the merchant hasn't FATECO field - end
		var addressMapping 		= component.get("v.addressMapping");
		var addressMappingSAE 	= {};
		var addressMappingATECO = {};
		
		for (var key in addressMapping) 
		{
		    var newKey = key.split('_')[1];
		    if (addressMapping.hasOwnProperty(key) && key.startsWith('SAE_'))
		    {		    	
				addressMappingSAE[newKey] 	= addressMapping[key];
			}
			else if (addressMapping.hasOwnProperty(key) && key.startsWith('ATECO_'))
			{
				addressMappingATECO[newKey] = addressMapping[key];
			}
		}

		console.log('---- SAE -----');
		console.log(JSON.stringify(addressMappingSAE));
		console.log('---- ATECO -----');
		console.log(JSON.stringify(addressMappingATECO));

		//	CHECK IF WE HAVE TO PICK AN ATECO
		
		if (objectDataMap.merchant.OB_FATECO__c=='S')
		{
			component.set("v.showATECO",true);
		}
		
		component.set("v.backupFATECO",objectDataMap.merchant.OB_FATECO__c);
		console.log('FATECO: '+component.get("v.backupFATECO"));

		component.set("v.addressMappingSAE",addressMappingSAE);
		component.set("v.addressMappingATECO",addressMappingATECO);
		component.set("v.doneRenderParent",true);
	},

    /**
    * @author Marta Stempien <marta.stempien@accenture.com>
    * @date 19/07/2019
    * @task NEXI-231
    * @description Method sets red border on Sae and Ateco fields if needed
    */
	setRedBorderOnSaeAteco : function(component, event)
	{
	    let parameters = event.getParam("arguments");
        if (parameters)
        {
            if(parameters.isMissingSae)
            {
                 $A.util.addClass(component.find('saecomponent'), 'slds-has-error flow_required');
            }
            else
            {
                $A.util.removeClass(component.find('saecocomponent'), 'slds-has-error flow_required');
            }
             if(parameters.isMissingAteco)
            {
                $A.util.addClass(component.find('atecocomponent'), 'slds-has-error flow_required');
            }
            else
            {
                $A.util.removeClass(component.find('atecocomponent'), 'slds-has-error flow_required');
            }
        }
    },

	hideATECOcomponent : function(component, event, helper)
	{
		var objectDataMap = component.get("v.objectDataMap");
		// NEXI-93 Marta Stempien <marta.stempien@accenture.com> 03/06/2019  - Start
		if($A.util.isUndefinedOrNull(objectDataMap.merchant)&&(component.get('v.fromMaintenance'))
		&&(!$A.util.isUndefinedOrNull(objectDataMap.acc))){
		    objectDataMap.merchant = objectDataMap.acc;
		    component.set("v.objectDataMap.merchant", objectDataMap.acc);
            }
        // NEXI-93 Marta Stempien <marta.stempien@accenture.com>   03/06/2019  - Stop
		console.log('FATECO '+ component.get("v.backupFATECO") +' vs OBJ.FATECO '+ objectDataMap.merchant.OB_FATECO__c);
		if ((component.get("v.backupFATECO")!=objectDataMap.merchant.OB_FATECO__c)||(objectDataMap.merchant.OB_FATECO__c=='S')) // NEXI-194 Marta Stempien <marta.stempien@accenture.com> 12/07/2019
		{
			if (objectDataMap.merchant.OB_FATECO__c=='S')
			{
			    component.set("v.showATECO",false); // NEXI-194 Marta Stempien <marta.stempien@accenture.com> 12/07/2019
				component.set("v.showATECO",true);
			}
			else
			{
				component.set("v.showATECO",false);
			}
			component.set("v.backupFATECO",objectDataMap.merchant.OB_FATECO__c);
		}
	},
})