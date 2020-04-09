({
    /*
    *   Author      :   Morittu Andrea
    *   Date        :   02-Sep-2019
    *   Description :   Call FileNet Service
    */
    doInit : function(component, event, helper) {
        
        Promise.all([
							helper.getMerchantDocumentHelper(component, event, helper)
						]).then(function(response) {
            				var scroller = component.find("scrollable");
    						scroller.scrollTo("right");
							} 
						).catch(
							function(error) {
								component.set("v.status" ,error ) ; 
								console.log(error);
							}
						);
    },

    /*
    *   Author      :   Morittu Andrea
    *   Date        :   02-Sep-2019
    *   Description :   Open Specific Document
    */
    getDocument : function(component, event , helper){
        var docSpinner = component.find("docSpinner");
        var source = event.target.id;
        var documentID = source.split('_')[0];
        documentID = documentID.replace('{', '').replace('}', '');
        var salesPointId = source.split('_')[1];    
        var orderId = source.split('_')[2];
        var merchant = component.get("v.recordId");
			try{
                $A.util.removeClass(docSpinner, 'slds-hide');
                $A.util.addClass(docSpinner, 'slds-show');
				var action = component.get("c.getTokenJWE");
				action.setParams({"documentId" : documentID});
				action.setCallback(this, function(response){
					var state = response.getState();
					console.log('state getToken is: ' + state);
					console.log('response is: ' +JSON.stringify(response.getReturnValue()) );
					var response = response.getReturnValue();
					if (state === "SUCCESS") 
					{
						var token 	= response['jewToken'];
                        var url = response['FEurl'] + '/api/merchants/'+merchant+'/sales-points/'+salesPointId+'/orders/'+orderId+'/documents/'+documentID;
                        console.log('TOKEN: ' + token);
						console.log('FE URL: '+ url);
                        
                        window.open('/apex/OpenDocumentsPage?params='+token+'?'+url);
					}
                });
                $A.util.removeClass(docSpinner, 'slds-show');
                $A.util.addClass(docSpinner, 'slds-hide');
				$A.enqueueAction(action);
			}catch(err){
                console.log(err.message);
                $A.util.removeClass(docSpinner, 'slds-show');
                $A.util.addClass(docSpinner, 'slds-hide');
			}
    }, 
        
    /*
    *   Author      :   Morittu Andrea
    *   Date        :   02-Sep-2019
    *   Description :   Filter Function
    */
    startFiltering : function(component, event, helper) {
        /* SPINNER */
        var docSpinner = component.find("docSpinner");
        $A.util.removeClass(docSpinner, 'slds-hide');
        $A.util.addClass(docSpinner, 'slds-show');
        /* / SPINNER */

        helper.filter_Helper(component, event, helper);
    },

    /*
    *   Author      :   Morittu Andrea
    *   Date        :   02-Sep-2019
    *   Description :   Redirect to sObject 
    */
    redirectToObjectDetail : function(component, event, helper) {
        helper.redirectToObjectDetail_Helper(component, event, helper);
    },

    /*
    *   Author      :   Morittu Andrea
    *   Date        :   02-Sep-2019
    *   Description :   Clear research
    */
    resetResearch : function(component, event, helper) {
        helper.resetResearch_Helper(component, event, helper);
    }
})