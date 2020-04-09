({
	getOffersForCAB : function(component, event) {
		console.log('into getOffersForCAB..');
		  var abi = component.get('v.abiCabRecord').NE__Value1__c;
		    var cab = component.get('v.abiCabRecord').Name;
		  console.log("abi" + abi);
		   console.log("cab" + cab);
		  var action = component.get('c.getOffersByABIServer');
		  var offerName = '';
		  var newOffers = [];
		  action.setParams({
			  abi: abi,
			  cab: cab
		  });
		  action.setCallback(this, function(response) {
		    var state = response.getState();
		    if (state === 'SUCCESS') {
		      var offers = response.getReturnValue();	   
		        console.log("CABOffers found: ", offers);
		        component.set("v.bundleOffers", offers);
		        var message = '';
		        if(offers.length >0){
		        	component.set("v.offerMessage", message);
		        }else{
		        	console.log('There are no active offers! setting offer Message value..');
		        	message = 'There are no active offers for this bank.';
		        	component.set("v.offerMessage", message);
		        }
		        this.getAllOffersToEnable(component, event);
		        component.set("v.spinner", false);
		    }
		  });
		  $A.enqueueAction(action);
		  component.set("v.spinner", true);
	
	},
	
	getAllOffersToEnable: function(component, event) {
	
		console.log('into getAllOffersToEnable..');
		var cabOffers = component.get("v.bundleOffers");
		var cab = component.get("v.abiCabRecord").Name;
		var abi = component.get("v.abiCabRecord").NE__Value1__c;
		var action = component.get('c.getAllOffersToEnableServer');
		action.setParams({
			cabOffers: cabOffers,
			cab: cab,
			abi: abi
		});
		  action.setCallback(this, function(response) {
		    var state = response.getState();
		    if (state === 'SUCCESS') {
		      var offers = response.getReturnValue();	   
		        console.log("offersToEnable found: ", offers);
		        component.set("v.offersToEnable", offers);
		    }
		  });
		  $A.enqueueAction(action);
	},
	
	
	searchHelper : function(component, event) {
		
      var searchText = component.get('v.SearchKeyWord');
      var selectedCAB = component.get('v.abiCabRecord').Name;
      var bankOffers = component.get("v.bundleOffers");
      var offerName = '';
	  var newOffers = [];
	  console.log("calling searchForOffersToEnable method..");
	  var action = component.get('c.searchForOffersToEnable');
      action.setParams({
    	  bankOffers: bankOffers,
    	  searchText: searchText
      });
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === 'SUCCESS') {
          var offers = response.getReturnValue();
         //   component.set("v.spinner", false);
            console.log("offers To enable: ", offers);
             // if storeResponse size is equal 0 ,display No Result Found... message on screen.    
	        if (offers.length == 0) {
	            var message = $A.get("$Label.c.OB_NoResultMsg");
	            component.set("v.Message", message);
	        }else {   
	            component.set("v.Message", '');
	            //component.set("v.bundleOffers", newOffers);
	        }
          component.set("v.listOfSearchRecords", offers);
        }
      });
      $A.enqueueAction(action);
     // component.set("v.spinner", true);
    },
    
    getOffersOrderBy: function(component, selectedValue) {
    	var bundleOffers = component.get('v.bundleOffers');
        var action = component.get("c.getBundleOffersOrderBy");
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
    
    retrieveBundleOffers : function(component) {
    	console.log('into retrieveBundleOffers');
		/*var action = component.get('c.getBundleOffers');
	    // Set up the callback
	    action.setCallback(this, function(actionResult) {
	        var state = actionResult.getState();
	        if(state == 'SUCCESS') {
	        	var allOffers = actionResult.getReturnValue();
	            component.set("v.allOffers", actionResult.getReturnValue());
	            console.log('results: ', actionResult.getReturnValue());
	            component.set("v.spinner", false);
	        } else if(state == 'ERROR') {
	            console.error(actionResult.getError());
	        } else {
	            console.log("something went wrong!");
	        }
	    });
	    $A.enqueueAction(action);
	},*/
    	var abi = component.get("v.abiCabRecord").NE__Value1__c;
    	console.log("abi: "+ abi);
        var action = component.get("c.getBundleOffers");
        action.setParams({ 
        	abi : abi
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            	component.set("v.spinner", false);
                console.log("From server: " , response.getReturnValue());
                component.set("v.allOffers", response.getReturnValue());
                component.set("v.spinner", false);
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
	
	/*saveNewRowsWithOffers: function(component,event, activeOffers, selectedABI, listToUpdate) {
		var action = component.get("c.cloneParametersAndRows");
		action.setParams({ 
			activeOffers: activeOffers,
      		selectedABI: selectedABI,
      		listToUpdate: listToUpdate
      	});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            	//component.set("v.spinner", false);
                console.log("From server - testing massive upsert of rows: " , response.getReturnValue());
              //  component.set("v.bundleOffers", response.getReturnValue());
                this.showSuccessToast(component, event);
                this.getOffersByABI(component, event);
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
                this.showErrorToast(component, event);
            }
        });

        $A.enqueueAction(action);
        component.set("v.spinner", true);	
	},*/
	saveNewRowsWithOffers: function(component,event) {
	 	var activeOffersMap = component.get("v.activeOffersMap");
	 	var activeOffers = [];
	 	for(var key in activeOffersMap){
	 		//activeOffers.push({"Id" : key});
	 		activeOffers.push(key);
	 	}
	 	console.log("offers to activate: " + JSON.stringify(activeOffers));
    	var cab = component.get("v.abiCabRecord").Name;
    	var abi = component.get("v.abiCabRecord").NE__Value1__c;
    	console.log("abi: " + abi);
    	console.log("cab: " + cab);
		var action = component.get("c.cloneParametersAndRows");
		action.setParams({ 
			activeOffers: activeOffers,
      		abi: abi,
      		cab: cab
      	});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            	//component.set("v.spinner", false);
                console.log("From server - SUCCESS");
              //  component.set("v.bundleOffers", response.getReturnValue());
                component.set("v.spinner", false);	
                component.set("v.showModal", false);
                this.showSuccessToast(component, event);
                this.getOffersForCAB(component, event);
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
                this.showErrorToast(component, event);
            }
        });

        $A.enqueueAction(action);
        component.set("v.spinner", true);	
	},
	
	   
	
	showSuccessToast : function(component, event) {	 
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : '',
            message: 'Records updated successfully',
            //messageTemplateData: [name],
            duration:'5000',
            key: 'info_alt',
            type: 'success',
            mode: 'dismissible'
        });
        toastEvent.fire();
	},
	
	showErrorToast : function(component, event) {	 
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : '',
            message: 'A server error occurred. Please, try again later. ',
            //messageTemplateData: [name],
            duration:'5000',
            key: 'info_alt',
            type: 'error',
            mode: 'dismissible'
        });
        toastEvent.fire();
	},
})