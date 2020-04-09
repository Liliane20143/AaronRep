({
	updateServicePoint : function(component, idAcc) {
				
		var action = component.get("c.updateServicePoint"); 
		var responseMerchant = component.get("v.responseServicePoint");
		console.log('response Service Point into gAcc: '+responseMerchant);
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
						/*
						console.log(response.getReturnValue().NE__Fiscal_code__c);
						console.log(response.getReturnValue().NE__VAT__c);
						component.set("v.FC", response.getReturnValue().NE__Fiscal_code__c);
						component.set("v.VAT", response.getReturnValue().NE__VAT__c);
						FC = response.getReturnValue().NE__Fiscal_code__c;
						VAT = response.getReturnValue().NE__VAT__c;
						*/
						
					}
					else
					{
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
		var request = $A.get("e.c:OB_ContinuationRequest");
		//var request = component.get("v.requestMerchant");
		console.log('siamo nel callService, stampo la request: '+ JSON.stringify(request));
		request.setParams({ 
            methodName: "retriveMerchant",
            methodParams: [FC, VAT],
            callback: function(result) {
                
                //control if the response is null or not
				if(result == resultNull || result=='[]' ||result == null){
					console.log('merchant not exist on service' );
					component.set( "v.responseMerchant" , "");
                }else{
                    //use the method 'convertChart' only if there is a response
					var result = result.replace(/\\n/g, "\\n").replace(/\\'/g, "\\'").replace(/\\"/g, '\\"').replace(/\\&/g, "\\&").replace(/\\r/g, "\\r").replace(/\\t/g, "\\t").replace(/\\b/g, "\\b").replace(/\\f/g, "\\f").replace(/&quot;/g, '"');
					console.log('merchant result by call service: '+ result);
					var resultConverted = JSON.parse(result);
					component.set( "v.responseMerchant" , resultConverted);
					if(resultConverted != null){
						console.log("the first merchant from array is: " + JSON.stringify(resultConverted));
					}
                }
                console.log(" response merchant attribute: " + JSON.stringify(component.get("v.responseMerchant")));
                
            } 
        });
		request.fire();
	},



	/*	getMerchantFromService : function(component, FC, VAT){
			const resultNull =  '{}' 
			//DA CAMBIARE QUANDO AVREMO IL SERVIZIO
	        //FIRST CALL THE SERVICE AND AFTER THE SALESFORCE QUERY
	        //START
			// create a one-time use instance of the serverEcho action
			// in the server-side controller
			console.log("Prima updateMerchant");
				
			//var request = $A.get("e.c:OB_ContinuationRequest");
			console.log('FC Merchant Service: '+FC);
			console.log('VAT Merchant Service: '+VAT);
			var action = component.get("c.getretrieveMerchant");
	        action.setParams({
		        fiscalCode : FC, 
		        vatCode : VAT
	        });
		    action.setCallback(this, function(response)
		    {
		        var state = response.getState();
		        console.log("the state is 2method : "+state);
		        if (state === "SUCCESS") 
		        {
		            console.log("SUCCESS getretrieveMerchant");
		            var result = response.getReturnValue();
		            console.log("***Res getretrieveMerchant 2method: "+result);
		        	//control if the response is null or not
					if(result == resultNull || result=='[]' ||result == null)
					{
						console.log('merchant not exist on service' );
						component.set( "v.responseMerchant" , "");
			        }
			        else
			        {
			            //use the method 'convertChart' only if there is a response
						var result = result.replace(/\\n/g, "\\n").replace(/\\'/g, "\\'").replace(/\\"/g, '\\"').replace(/\\&/g, "\\&").replace(/\\r/g, "\\r").replace(/\\t/g, "\\t").replace(/\\b/g, "\\b").replace(/\\f/g, "\\f").replace(/&quot;/g, '"');
						console.log('merchant result by call service: '+ result);
						var resultConverted = JSON.parse(result);
						component.set( "v.responseMerchant" , resultConverted);
						if(resultConverted != null)
						{
							console.log("the first merchant from array is: " + JSON.stringify(resultConverted));
						}
			        }
			        console.log(" response merchant attribute: " + JSON.stringify(component.get("v.responseMerchant")));
			    }
		        
		    });
		    $A.enqueueAction(action); 
    
	},*/











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
						component.set("v.CF", response.getReturnValue().NE__Fiscal_code__c);
						component.set("v.VAT", response.getReturnValue().NE__VAT__c);
						this.getMerchantFromService(component, response.getReturnValue().NE__Fiscal_code__c, response.getReturnValue().NE__VAT__c);												
					}
					else
					{
						console.log('Error state!!');
						component.set('v.account', "");;
					}
						
			});
		$A.enqueueAction(action);
		
	},
})