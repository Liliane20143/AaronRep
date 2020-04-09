({
	retrieveBundleOffers : function(component) {
		var action = component.get('c.getBundleOffers');
	    // Set up the callback
	    action.setCallback(this, function(actionResult) {
	        var state = actionResult.getState();
	        if(state == 'SUCCESS') {
	            component.set("v.bundleOffers", actionResult.getReturnValue());
	            console.log('results: ', actionResult.getReturnValue());
	            component.set("v.spinner", false);
	        } else if(state == 'ERROR') {
	            console.error(actionResult.getError());
	        } else {
	            console.log("something went wrong!");
	        }
	    });
	    $A.enqueueAction(action);
	},
	
	searchHelper : function(component, event) {
      //davide.franzini - 01/07/2019 - F2WAVE2-15 - START
      var searchAbi = component.get('v.SearchKeyWord');
      var action = component.get('c.searchForOffer');
      action.setParams({searchAbi: searchAbi});
      //davide.franzini - 01/07/2019 - F2WAVE2-15 - END
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === 'SUCCESS') {
          var offers = response.getReturnValue();
            console.log("offers found: ", offers);
             // if storeResponse size is equal 0 ,display No Result Found... message on screen.    
	        if (offers.length == 0) {
	        	var message = $A.get("$Label.c.OB_NoResultMsg");
	            component.set("v.Message", message);
	        } else {
	            component.set("v.Message", '');
	            component.set("v.bundleOffers", offers);
	        }
          component.set("v.listOfSearchRecords", offers);
        }
      });
      $A.enqueueAction(action);
    },
    
    getOffersOrderBy: function(component, selectedValue) {
    	var bundleOffers = component.get('v.bundleOffers');
        var action = component.get("c.getBundleOffers");
        action.setParams({ selectedValue :selectedValue,
      					bundleOffers: bundleOffers });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            	component.set("v.spinner", false);
                console.log("From server: " , response.getReturnValue());
                component.set("v.bundleOffers", response.getReturnValue());
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
        component.set("v.spinner", true);
    },

    //13/05/19 START francesca.ribezzi adding function to retrive abi list from server:
    retrieveABIlist : function(component, event, inputABI) {

        var selectedOfferId = component.get("v.selectedOffer").Id; 
        var action = component.get("c.getAbiList");
        action.setParams({
            'offerId':selectedOfferId, 
            'inputABI': inputABI  
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.abiList", response.getReturnValue());
                var columns = [
                  {"label": 'ABI', "fieldName": 'Name', "type": 'text'},
                  {"label": 'Nome', "fieldName": 'NE__Value1__c', "type": 'text'}
                ];
                component.set("v.abiColumns", columns);
                if( response.getReturnValue().length == 0){
                    var message = $A.get("$Label.c.OB_NoResultMsg");
                    component.set("v.messageIsEmpty",message);
                }else{
                    component.set("v.messageIsEmpty",'');
                }
                component.set("v.showAbiModal", true);
                var selectedABI = component.get("v.selectedABI");
                if($A.util.isEmpty(selectedABI)){
                    component.set("v.disableOkBtn", true);
                }else{
                    component.set("v.disableOkBtn", false);
                }
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
     //13/05/19 END francesca.ribezzi


})