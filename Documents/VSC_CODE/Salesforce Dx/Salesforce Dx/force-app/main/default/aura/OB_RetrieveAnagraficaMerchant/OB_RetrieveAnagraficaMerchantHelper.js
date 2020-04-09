({
	updateMerchant : function(component, idAcc) {		
		var action = component.get("c.updateMerchant"); 
		var responseMerchant = component.get("v.responseMerchant");
		console.log('response Merchant into getAcc: '+responseMerchant);
		var strResponse = JSON.stringify(responseMerchant)
		console.log("String resposne: "+strResponse);
		action.setParams({idAcc : idAcc, accService : strResponse});
		action.setCallback(this, function(response) 
				{
					var state = response.getState();
					console.log("the state is: " + state);
					console.log("RESPONSE " + JSON.stringify(response.getReturnValue())); 
					
					if (state === "SUCCESS") {
						console.log("INTO SUCCESS STATE OF CLICK");
						console.log("RESPONSE " + JSON.stringify(response.getReturnValue()));   
						$A.get('e.force:refreshView').fire(); 
						var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams({
							title: "Merchant Update From Service",
							message: "The merchant is updated!",
							type: "success"
						});
						toastEvent.fire(); 
					}
					else
					{
						var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams({
							title : 'Error Message',
							message:'Merchant not retrieved on service',
							duration:' 2000',
							key: 'info_alt',
							type: 'error',
							mode: 'pester'
						});
						toastEvent.fire();
						console.log('Error state!!');
						
					}
						
			});
		$A.enqueueAction(action);
		
	},

	getMerchantFromService : function(component, FC, VAT){
		const resultNull =  '{}' //DA CAMBIARE QUANDO AVREMO IL SERVIZIO
        //FIRST CALL THE SERVICE AND AFTER THE SALESFORCE QUERY
        //START
		// create a one-time use instance of the serverEcho action
		// in the server-side controller
		console.log("Prima updateMerchant");
			
		//var request = $A.get("e.c:OB_ContinuationRequest");
		console.log('FC Merchant Service: '+FC);
		console.log('VAT Merchant Service: '+VAT);


/***************************** START AV  17-12-18***************************************************change call service from continuation*/

		// var request = $A.get("e.c:OB_ContinuationRequest");
		// var request = component.get("v.requestMerchant");
		// console.log('siamo nel callService, stampo la request: '+ JSON.stringify(request));

		var action = component.get("c.retrieveMerchantNew");
		action.setParams({
			fiscalCode : FC, 
			vatCode : VAT
		});
		action.setCallback(this, function(response)
		{
			var state = response.getState();
			console.log("the state is: "+state);
			if (state === "SUCCESS") 
			{
				console.log("SUCCESS retrieveMerchantNew");
				var result = response.getReturnValue();


		// request.setParams({ 
  //           methodName: "retriveMerchant",
  //           methodParams: [FC, VAT],
  //           callback: function(result) {
                
                //control if the response is null or not
				if(result == resultNull || result=='[]' ||result == null){
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						title : 'Error Message',
						message:'Merchant not retrieved on service',
						duration:' 2000',
						key: 'info_alt',
						type: 'error',
						mode: 'pester'
					});
					toastEvent.fire();
					$A.get("e.force:closeQuickAction").fire(); 
                }else{
                    //use the method 'convertChart' only if there is a response
					var result = result.replace(/\\n/g, "\\n").replace(/\\'/g, "\\'").replace(/\\"/g, '\\"').replace(/\\&/g, "\\&").replace(/\\r/g, "\\r").replace(/\\t/g, "\\t").replace(/\\b/g, "\\b").replace(/\\f/g, "\\f").replace(/&quot;/g, '"').replace(/&amp;/g, '&');			
					var resultConverted;
					try {
						resultConverted = JSON.parse(result);
						console.log('merchant result by call service: '+ resultConverted); 
						component.set( "v.responseMerchant" , resultConverted);
					} catch (e) {
						var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams({
							title : 'Error Message',
							message:'Merchant not retrieved on service',
							duration:' 2000',
							key: 'info_alt',
							type: 'error',
							mode: 'pester'
						});
						toastEvent.fire();
						$A.get("e.force:closeQuickAction").fire();
					}
                }
                console.log(" response merchant attribute: " + JSON.stringify(component.get("v.responseMerchant")));
                
            } 
        });
		// request.fire();
		$A.enqueueAction(action);

/***************************** END AV  17-12-18***************************************************+*/
	},

	getAcc : function(component, idAcc) {
		console.log('Id account into call: '+idAcc);		
		var action = component.get("c.getAccountById"); 
		action.setParams({idAcc : idAcc});
		action.setCallback(this, function(response) 
				{
					var state = response.getState();
					console.log("the state of getAcc is: " + state);
										
					if (state === "SUCCESS") {
						console.log("INTO SUCCESS STATE OF CLICK");
						console.log("RESPONSE of getAcc" + JSON.stringify(response.getReturnValue()));    
						console.log('FC account: '+response.getReturnValue().NE__Fiscal_code__c);
						console.log('VAT account: '+response.getReturnValue().NE__VAT__c);
						var FC = '';
						var VAT = '';
						var vatNotPresent = response.getReturnValue().OB_VAT_Not_Present__c;
						 
						if (vatNotPresent){
							FC = response.getReturnValue().NE__Fiscal_code__c
						}
						else{
							VAT = response.getReturnValue().NE__VAT__c;
						}
						
						component.set("v.CF", FC);
						component.set("v.VAT", VAT);

						this.getMerchantFromService(component, FC, VAT);												
					}
					else
					{
						console.log('Error state!!');
						var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams({
							title : 'Error Message',
							message:'Merchant not retrieved on service',
							duration:' 2000',
							key: 'info_alt',
							type: 'error',
							mode: 'pester'
						});
						toastEvent.fire();
						$A.get("e.force:closeQuickAction").fire(); 
					}
						
			});
		$A.enqueueAction(action);
		
	}
})