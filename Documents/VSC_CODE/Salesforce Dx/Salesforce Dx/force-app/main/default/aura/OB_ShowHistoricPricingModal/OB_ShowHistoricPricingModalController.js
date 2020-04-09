({
   

    init : function(component, event, helper) {
        console.log('productId: '+component.get("v.productId"));
        console.log('offerAssetId: '+component.get("v.offerAssetId"));
        helper.setColumns(component, event, helper);   /* Masoud zaribaf 13/05/2019 Call the helper function*/

        var action = component.get('c.retriveInfo');
        action.setParams({ 
            prodId : component.get("v.productId"),
            offerId : component.get("v.offerAssetId")//simone.misani@accenture.com add params for query. 06/05/2019 R1F2-91
      
        });
        action.setCallback(this, $A.getCallback(function (response) {
            console.log("SUCCESS:");
            var state = response.getState();
            console.log("state: "+state);
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                console.log("response: "+JSON.stringify(resp)); // masoud zaribaf 13/05/2019 
                component.set("v.listOrder",resp);
                

                
        

                
            }


        }));
        $A.enqueueAction(action);
        
    },



    redirectConf : function(component, event, helper) {
        var action = component.get('c.getBaseURl');
        action.setCallback(this, $A.getCallback(function (response) {
            console.log("SUCCESS:");
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp= response.getReturnValue();
                console.log("resp: "+resp);
                var confId = event.target.id;
                window.location.href = resp+'/'+confId; //masoud.zaribaf@accenture.com RI-32 add / to the URL 19/04/2019

            }
        }));
        $A.enqueueAction(action);
    }


    

})