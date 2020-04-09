({
	getAcc : function(component, idAcc) {
				
		var action = component.get("c.updateMerchant"); 
		var FC;
		var VAT;
		action.setParams({idAcc : idAcc});
		action.setCallback(this, function(response) 
				{
					var state = response.getState();
					console.log("the state is: " + state);
					console.log("RESPONSE " + JSON.stringify(response.getReturnValue())); 
					
					if (state === "SUCCESS") {
						console.log("INTO SUCCESS STATE OF CLICK");
						console.log("RESPONSE " + JSON.stringify(response.getReturnValue()));    
						console.log(response.getReturnValue().NE__Fiscal_code__c);
						console.log(response.getReturnValue().NE__VAT__c);
						component.set("v.FC", response.getReturnValue().NE__Fiscal_code__c);
						component.set("v.VAT", response.getReturnValue().NE__VAT__c);
						FC = response.getReturnValue().NE__Fiscal_code__c;
						VAT = response.getReturnValue().NE__VAT__c;
						
					}
					else
					{
						console.log('Error state!!');
						
					}
						
			});
		$A.enqueueAction(action);
		
	},

/*	getMerchantFromService : function(component, FC, VAT){
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
        console.log('siamo nel callService, stampo la request: '+ JSON.stringify(request));
		request.setParams({ 
            methodName: "retriveMerchant",
            methodParams: [FC, VAT],
            callback: function(result) {
                console.log('merchant result by call service: '+ result);
                //control if the response is null or not
                if(result == resultNull){
                    conosole.log('merchant non trovato');
                }else{
                    //use the method 'convertChart' only if there is a response
                    resultConverted = JSON.parse(result);
					component.set( "v.responseMerchant" , resultConverted);
					console.log("the first merchant from array is: " + JSON.stringify(resultConverted[0]));
                }
                console.log(" response merchant attribute: " + JSON.stringify(component.get("v.responseMerchant")));
                console.log("the first merchant from array is: " + JSON.stringify(resultConverted[0]));
                
            }
        });
		request.fire();
		
	}*/

/********************************** START Antonio Vatrano  18-12-18 **********************/
	getMerchantFromService : function(component, FC, VAT){
		const resultNull =  '{}' //DA CAMBIARE QUANDO AVREMO IL SERVIZIO
        //FIRST CALL THE SERVICE AND AFTER THE SALESFORCE QUERY
        //START
		 // create a one-time use instance of the serverEcho action
		// in the server-side controller
		console.log("Prima updateMerchant");
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
				console.log('merchant result by call service: '+ result);
                //control if the response is null or not
                if(result == resultNull){
                    conosole.log('merchant non trovato');
                }else{
                    //use the method 'convertChart' only if there is a response
                    resultConverted = JSON.parse(result);
					component.set( "v.responseMerchant" , resultConverted);
					console.log("the first merchant from array is: " + JSON.stringify(resultConverted[0]));
                }
                console.log(" response merchant attribute: " + JSON.stringify(component.get("v.responseMerchant")));
                console.log("the first merchant from array is: " + JSON.stringify(resultConverted[0]));
			}
		});
		$A.enqueueAction(action);	
	}
/********************************** END Antonio Vatrano  18-12-18 **********************/


})