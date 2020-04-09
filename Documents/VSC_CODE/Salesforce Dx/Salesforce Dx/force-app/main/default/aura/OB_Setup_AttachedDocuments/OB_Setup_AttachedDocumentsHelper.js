({
    helperMethod : function() {

    },
    getProductDocuments : function(component) {
		// var mcc =component.get("v.objectDataMap.order.OB_MCC__c");
		// console.log('MCC_UPLOAD_DOCUMENT: ' + mcc);
		// var ateco = component.get("v.objectDataMap.merchant.OB_ATECO__c");
		// console.log('get ateco --> '+ateco);
		// var legalForm = component.get("v.objectDataMap.merchant.OB_Legal_Form__c");
		// console.log('get legalForm --> '+legalForm);
		// var orderId = component.get("v.objectDataMap.Configuration.Id");
		// console.log('get orderId --> '+orderId);
		// var orderHeaderId = component.get("v.objectDataMap.OrderHeader.Id");
		// console.log('get orderHeaderId --> '+orderHeaderId);
		// var merchantId = component.get("v.objectDataMap.merchant.Id");
		// console.log('get merchantId --> '+merchantId);
		// var abi = component.get("v.objectDataMap.bank.OB_ABI__c")
		// console.log('get abi --> '+abi);

        
        var mcc= '5631';
        var ateco = '101100';
        var orderHeaderId = 'a0w9E0000038xcKQAQ';
        var orderId = 'a0y9E000004Nr75QAC';
        var legalForm='Organizzazione non profit/strutture analoghe';
        var merchantId = '0019E00000pZPVBQA4';
        var abi = '05116';

		var action = component.get("c.getProductDocumentsServer");
		action.setParams({ 
			orderId : orderId,
			orderHeaderId : orderHeaderId,
			mcc : mcc , 
			ateco : ateco,
			legalForm: legalForm,
			merchantId : merchantId,
			abi : abi
		});
		action.setCallback(this, function(response){
			var state = response.getState();
			if (state === "SUCCESS") {
				var map_Merchant_SP = response.getReturnValue();
				console.log("SUCCESS getProductDocuments: "+ JSON.stringify(map_Merchant_SP));
                component.set("v.response", map_Merchant_SP);
                var mapMerchant = map_Merchant_SP['MERCHANT'];
                console.log('@@'+JSON.stringify(mapMerchant));
                var mapServicePoint = map_Merchant_SP['SERVICEPOINT'];
                console.log('@@'+JSON.stringify(mapServicePoint));
				var listMerchant = [];
				var listSP = [];
				var listDocs = [];
                for(var k in mapMerchant){
					listMerchant.push(k); 
					listDocs.push(k); 
                }
                for(var k in mapServicePoint){
					listSP.push(k);  
					listDocs.push(k); 
                }
                component.set("v.documentsListMerchant",listMerchant);
				component.set("v.documentsListServicePoint",listSP);
				component.set("v.documentsList",listDocs);
				component.set("v.showSpinner", false);
				
                
                    
      
			}
			else if (state === "INCOMPLETE") {

				// do something
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

	},
})