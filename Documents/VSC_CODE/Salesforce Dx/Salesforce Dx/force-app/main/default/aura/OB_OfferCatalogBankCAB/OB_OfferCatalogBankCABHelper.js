({
    
    getUserABI : function(component, event, userId) {
		  var action = component.get('c.getUserCABandABIServer');
		  action.setParams({
              userId: userId
          });
		  action.setCallback(this, function(response) {
		    var state = response.getState();
		    if (state === 'SUCCESS') {
		      	var userInfo = response.getReturnValue();
		      	if(userInfo.Profile.UserLicense.Name == 'Partner Community'){
		      		 this.getOffersByABI(component, event, userInfo);
                       component.set("v.warningMessage", '');
                       var urlImg = component.get("v.urlImages");
                       var urlImgCommunity = '..' + urlImg;
                       component.set("v.urlImages", urlImgCommunity);
		      	}else{
		      		var warningMessage = 'There is no associate bank with this user!';
		      		component.set("v.warningMessage", warningMessage);
		      	}
		        console.log("userInfo: ", userInfo);
				component.set("v.spinner", false);
				component.set("v.currentUser", userInfo);
		    }
		  });
		  $A.enqueueAction(action);
		  component.set("v.spinner", true);
	
	},
    
	getOffersByABI : function(component, event, userInfo) {
		 var abi = userInfo.Contact.Account.OB_ABI__c;
       //  console.log("ABI from contact's user:" + abi);
		 // var abi = component.get('v.abiCabLov').NE__Value1__c;
		  var action = component.get('c.getOffersByABIServer');
		  var offerName = '';
		  var newOffers = [];
		  action.setParams({
              abi: abi
          });
		  action.setCallback(this, function(response) {
		    var state = response.getState();
		    if (state === 'SUCCESS') {
		        var offers = response.getReturnValue();
		        console.log("offers found: ", offers);
		        component.set("v.bundleOffers", offers);
		        component.set("v.spinner", false);
		    }
		  });
		  $A.enqueueAction(action);
		  component.set("v.spinner", true);
	},
	
	searchHelper : function(component, event) {
		
      var searchText = component.get('v.SearchKeyWord');
      var selectedABI = component.get('v.currentUser').Contact.Account.OB_ABI__c;
     // var selectedCAB = component.get('v.abiCabLov').Name; 
      var offerName = '';
	  var newOffers = [];
	  
	  var action = component.get('c.searchForOffer');
      action.setParams({
    	  searchText: searchText,
    	  selectedABI: selectedABI
      });
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === 'SUCCESS') {
          var offers = response.getReturnValue();
         //   component.set("v.spinner", false);
            console.log("offers found: ", offers);
             // if storeResponse size is equal 0 ,display No Result Found... message on screen.    
	        if (offers.length == 0) {
	            var message = $A.get("$Label.c.OB_NoResultMsg");
	            component.set("v.Message", message);
	        }else {
	        	for(var i = 0; i<offers.length; i++ ){
		        	if(offerName != offers[i].NE__Matrix_Parameter__r.OB_Offerta__r.Name){
		        		newOffers.push(offers[i]);
		        		offerName = offers[i].NE__Matrix_Parameter__r.OB_Offerta__r.Name;
		        	}
		        }
	            component.set("v.Message", '');
	            component.set("v.bundleOffers", newOffers);
	        }
          component.set("v.listOfSearchRecords", newOffers);
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
		var action = component.get('c.getBundleOffers');
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
	},
	
	saveNewRowsWithOffers: function(component,event, activeOffers, selectedABI, selectedCAB, listToUpdate) {
		var action = component.get("c.cloneParametersAndRows");
		action.setParams({ 
			activeOffers: activeOffers,
      		selectedABI: selectedABI,
            selectedCAB: selectedCAB,
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