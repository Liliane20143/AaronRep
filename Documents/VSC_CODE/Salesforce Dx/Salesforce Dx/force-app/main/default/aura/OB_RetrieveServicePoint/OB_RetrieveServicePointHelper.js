({
	updateServicePoint : function(component, idServicePoint) {
				
		var action = component.get("c.updateServicePoint"); 
		var responseServicePoint = component.get("v.responseServicePoint");
		console.log('response Service Point into updateServicePoint: '+responseServicePoint);
		var strResponse = JSON.stringify(responseServicePoint)
		console.log("Id SP: "+idServicePoint);
		console.log("String response: "+strResponse);
		action.setParams({idServicePoint : idServicePoint, spService : strResponse});
		action.setCallback(this, function(response) 
				{
					var state = response.getState();
					console.log("the state is: " + state);
					console.log("RESPONSE " + JSON.stringify(response.getReturnValue())); 
					
					if (state === "SUCCESS") {
						console.log("INTO SUCCESS STATE OF CLICK");
						console.log("RESPONSE " + JSON.stringify(response.getReturnValue()));    
						
					}
					else
					{
						console.log('Error state!!');
						$A.get("e.force:closeQuickAction").fire(); 
					}
						
			});
		$A.enqueueAction(action);
		
	},

	getServicePointFromService : function(component, fiscalCode, processore, MCCDescription, cap, vat){
		const resultNull =  '{}'
		var searchPVParam  = null;
	
		console.log('Merchant Search : fiscalCode encodeURI: ' + fiscalCode + ' vat encodeURI: ' + vat);
		if(fiscalCode){
			console.log('Fidcal code not null');
			searchPVParam = fiscalCode;
		}else if(vat){
			console.log('vat not null');
			searchPVParam = vat;
		}
 
		console.log('searchPVParam:' + searchPVParam );
         
		var request = $A.get("e.c:OB_ContinuationRequest");
		console.log('siamo nel completeProvincia, stampo la request: '+JSON.stringify(request));
		request.setParams({ 
			methodName: "retriveServicePoint",
			methodParams: [searchPVParam,processore,MCCDescription,cap],
			callback: function(result) {
				console.log('RISULTATO: '+ result);
				 
				//control if the response is null or not
				if(result == resultNull || result =='[]' || result == null){
					console.log('service point not exist on service' );
					$A.get("e.force:closeQuickAction").fire(); 
                }else{ 
                    //use the method 'convertChart' only if there is a response
					var result = result.replace(/\\n/g, "\\n").replace(/\\'/g, "\\'").replace(/\\"/g, '\\"').replace(/\\&/g, "\\&").replace(/\\r/g, "\\r").replace(/\\t/g, "\\t").replace(/\\b/g, "\\b").replace(/\\f/g, "\\f").replace(/&quot;/g, '"');
					console.log('merchant result by call service: '+ result);
					var resultConverted = JSON.parse(result);
					
					//For mock, hold salePoints for real service
					var spLen = resultConverted.salePoint == undefined ? resultConverted.length : resultConverted.salePoint.length;
					
					console.log('Lunghezza array SP: '+spLen);
					if(spLen == 1){
						console.log("the service point from array is: " + JSON.stringify(resultConverted));
						component.set( "v.responseServicePoint" , resultConverted.salePoints[0]);
					}
					else{
						console.log("the 1 service point from array is: " + JSON.stringify(resultConverted[0]));
						console.log("the 2 service point from array is: " + JSON.stringify(resultConverted[1]));
						console.log("the service point from array is: " + JSON.stringify(resultConverted));
						console.log('shopName: '+resultConverted.salePoints[0].shopName);
						console.log('CAP: '+resultConverted.salePoints[0].address.postalCode);
						console.log(resultConverted);
						
						var i = 1;

						resultConverted.salePoints.forEach(function(entry) {
							entry.id = i;
							i++;
						});
						
						console.log('servicePoints: '+JSON.stringify(resultConverted.salePoints));
						component.set("v.dataTableList", resultConverted.salePoints);
						component.set("v.toggleSpinner", true);
						}
						
					}
                console.log(" response service point attribute: " + JSON.stringify(component.get("v.responseServicePoint")));

			 	
			}
		});
		
		request.fire();
		
	}, 

	getAcc : function(component, servicePointId) {
		console.log('Id service point into call: '+servicePointId);		
		var action = component.get("c.getServicePoint"); 
		action.setParams({idServicePoint : servicePointId});
		action.setCallback(this, function(response) 
				{
					var state = response.getState();
					console.log("the state of getAcc is: " + state);
										
					if (state === "SUCCESS") {
						console.log("INTO SUCCESS STATE OF CLICK");
						console.log("RESPONSE of getAcc" + JSON.stringify(response.getReturnValue()));    
						console.log('FC account: '+response.getReturnValue().NE__Account__r.NE__Fiscal_code__c);
						console.log('processore non presente');
						console.log('MCC description: '+response.getReturnValue().OB_MCC_Description__c);
						console.log('ZIP code: '+response.getReturnValue().NE__Zip_Code__c);
						console.log('VAT account: '+response.getReturnValue().NE__Account__r.NE__VAT__c);
						component.set("v.CF", response.getReturnValue().NE__Fiscal_code__c);
						component.set("v.VAT", response.getReturnValue().NE__VAT__c);
						this.getServicePointFromService(component, response.getReturnValue().NE__Account__r.NE__Fiscal_code__c, "", response.getReturnValue().OB_MCC_Description__c, response.getReturnValue().NE__Zip_Code__c, response.getReturnValue().NE__VAT__c);												
					}
					else
					{
						console.log('Error state!!');
						$A.get("e.force:closeQuickAction").fire();
					}
						
			});
		$A.enqueueAction(action);
		
	}
})