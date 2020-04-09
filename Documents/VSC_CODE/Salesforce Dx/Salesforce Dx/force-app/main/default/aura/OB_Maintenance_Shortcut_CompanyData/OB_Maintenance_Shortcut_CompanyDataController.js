({
    /*
        *@author antonio.vatrano antonio.vatrano@accenture.com
        *@date 18/04/2019
        *@init function: retrive account's fiscal code, vat code, recordType and the current User
    */
    init : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        console.log("@@@@record Id: "+recordId);
        var retrieveInformations = component.get("c.retrieveInfos");
        retrieveInformations.setParams({ 
            accountId : recordId
        });
        retrieveInformations.setCallback(this, $A.getCallback(function (response) {
			var state = response.getState();
            if (state === "SUCCESS") 
            {
				var valueReturns = response.getReturnValue();
                console.log('retrieveInformations --> '+JSON.stringify(valueReturns));
                var fiscalCode = '';
                var vatCode = '';
                var user = '';
                var devName = '';
                if(typeof(valueReturns['fiscalCode'])!= 'undefined'){
                    fiscalCode = valueReturns['fiscalCode'];
                }
                if(typeof(valueReturns['VatCode'])!= 'undefined'){
                    vatCode = valueReturns['VatCode'];
                }
                if(typeof(valueReturns['User'])!= 'undefined'){
                    user = valueReturns['User'];
                    var operation = (user == 'Operation')? true : false;
                    component.set("v.OperationUser",operation);
                }
                if(typeof(valueReturns['Developername'])!= 'undefined'){
                    devName = valueReturns['Developername'];
                    var merchant = (devName == 'Merchant')? true: false;
                    component.set("v.isMerchant",merchant);

                }

                helper.searchHelper(component,fiscalCode, vatCode);


            }
				
		}));
		$A.enqueueAction(retrieveInformations);   


    },
      /*
        *@author antonio.vatrano antonio.vatrano@accenture.com
        *@date 18/04/2019
        *@function: open modal
    */
    showModalModify : function(component, event, helper){
        component.set("v.showModal", true);
    }

})