({
    getInfoServicePointFromSalesforce : function(component, recordId) 
    {
        var action = component.get("c.getInfoServicePointFromSalesforce");
        action.setParams({"servicePointId" : recordId});
        action.setCallback(this, function(response) 
        {
            var state = response.getState();
			if(state === "SUCCESS") 
            {
                console.log("SUCCESS");
                component.set("v.ServicePointFromSalesforce", response.getReturnValue());
                component.set("v.FiscalCode", response.getReturnValue().NE__Account__r.NE__Fiscal_code__c);
                component.set("v.MCC", response.getReturnValue().OB_MCC_Description__c);
                component.set("v.ZipCode", response.getReturnValue().NE__Zip_Code__c);
                //component.set("v.Processor", response.getReturnValue().NE__Processor__c);
                console.log('v.ServicePointFromSalesforce' + component.get("v.ServicePointFromSalesforce"));
                console.log('v.FiscalCode: ' + component.get("v.FiscalCode"));
                console.log('v.MCC: ' + component.get("v.MCC"));
                console.log('v.ZipCode: ' + component.get("v.ZipCode"));
                //console.log('v.Processor: ' + component.get("v.Processor"));
                 $A.get('e.force:refreshView').fire();

            } 
            else
            {
                var errors = response.getError();
                if (errors) 
                {
                    if (errors[0] && errors[0].message) 
                    {
                        console.log("Error message: " + errors[0].message);
                    }
                }
                else 
                {
                    console.log("Unknown error");
                }
            }
        });
		$A.enqueueAction(action);
    },

    serviceCaller : function(component)
    {
        console.log('sono nel serviceCaller');
        var fiscalCode = component.get("v.FiscalCode");
        var MCC = component.get("v.MCC");
        var zipCode = component.get("v.ZipCode");
        var processor = '';
        var request = $A.get("e.c:OB_ContinuationRequest");
        console.log('Request prima: ' + JSON.stringify(request));
        request.setParams
        ({ 
            methodName: "retriveServicePoint",
            methodParams: [fiscalCode, MCC, zipCode, processor],
            callback: function(result) 
            {
                console.log('Result: '+ result);
                component.set("v.responseServiceServicePoint", result);
                console.log('v.responseServiceServicePoint: ' + component.get("v.responseServiceServicePoint"));
            }
        });
        console.log('Request dopo: ' + JSON.stringify(request));

        request.fire();
    },

    updateServicePoint : function(component)
    {
        var servicePointFromSalesforce = component.get("v.ServicePointFromSalesforce");
        var servicePointFromService = component.get("v.ServicePointFromService");
        
        var action = component.get("c.updateServicePoint");
        action.setCallback(this, function(response) 
        {
            var state = response.getState();
            if(state === "SUCCESS") 
            {
                console.log("SUCCESS");
            } 
            else
            {
                var errors = response.getError();
                if (errors) 
                {
                    if (errors[0] && errors[0].message) 
                    {
                        console.log("Error message: " + errors[0].message);
                    }
                }
                else 
                {
                    console.log("Unknown error");
                }
            }
        })
    }
})

    /*
    	getServicePointFromService : function(component, codiceUnivoco){
	    
            //console.log('MCC ' + JSON.stringify(MCC));
            var action = component.get("c.invokeCaller");
            action.setParams({"methodName" : 'retrieveServicePoint' , "params" : [codiceUnivoco]});
            action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('prima mcc: ' + component.get("v.MCC"));

            //console.log("state: " + JSON.stringify(state));
            if(state === "SUCCESS") {
                console.log('successo in getServicePointFromService');
                component.set("v.MCC", response.getReturnValue());
                console.log('dopo mcc: ' + component.get("v.MCC"));
            } 
             
                console.log('Errore in getServicePointFromService nell helper');
            
            }
            
        });
        $A.enqueueAction(action);
        /*var request = $A.get("e.c:OB_ContinuationRequest");
        console.log('siamo nel callService, stampo la request: '+ JSON.stringify(request));
		request.setParams({ 
            methodName: "retriveServicePoint",
            methodParams: [MCC],
            callback: function(result) {
                if(result == '{}'){
                    console.log('peccato');
                   
                }
                else{
                    resultConverted = JSON.parse(result);
                    console.log('resultConverted' + JSON.stringify(resultConverted));
					component.set( "v.responseServicePoint" , resultConverted);
					console.log("the first SP from array is: " + JSON.stringify(resultConverted[0]));
                }
                //console.log(" response SP attribute: " + JSON.stringify(component.get("v.responseServicePoint")));
                //console.log("the first SP from array is: " + JSON.stringify(resultConverted[0]));
                
            }
        });
		request.fire();
		
	}*/