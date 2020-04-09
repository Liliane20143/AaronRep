({
	getABIbyUser: function(component, event, userId) {

      var action = component.get('c.getABIbyUserIdServer');
      action.setParams({
    	  userId: userId
      });
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === 'SUCCESS') {
        	var userInfo = response.getReturnValue();
           
           	if(userInfo.Profile.UserLicense.Name == 'Partner Community'){
		      	 component.set("v.warningMessage", '');
	      	}else{
	      		var warningMessage = 'There is no associate bank with this user!';
	      		component.set("v.warningMessage", warningMessage);
	      	}
	      	 component.set("v.currentUser", userInfo);
	      	 component.set("v.spinner", false);
	    } 
      });
      $A.enqueueAction(action);
      component.set("v.spinner", true);
    },

	searchHelper : function(component, event, getInputkeyWord) {
	  var abi = component.get("v.currentUser").Contact.Account.OB_ABI__c;
	 // var abi = '05696';
      var searchText = component.get('v.SearchKeyWord');
      var action = component.get('c.getCABListFromInput');
      action.setParams({
    	  abi: abi,
    	  cab: searchText
      });
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === 'SUCCESS') {
          var cabList = response.getReturnValue();
         //   component.set("v.spinner", false);
            console.log("cabList found: ", cabList);
            if(getInputkeyWord.length < 5){
            	 var lookupInput = component.find("lookupInputId");
            	 $A.util.removeClass(lookupInput, 'lookupError');
            	 component.set("v.showNoMatchMessage", false);
            	 var forOpen = component.find("searchRes");
            	 $A.util.addClass(forOpen, 'slds-is-open');
            	 $A.util.removeClass(forOpen, 'slds-is-close');
            }
            if(cabList.length == 0 && getInputkeyWord.length == 5){
            	component.set("v.Message", '');
            	component.set("v.showNoMatchMessage", true);
            	component.set("v.hideListResults", true);
            	var forclose = component.find("searchRes");
                $A.util.addClass(forclose, 'slds-is-close');
                $A.util.removeClass(forclose, 'slds-is-open');
            	var lookupInput = component.find("lookupInputId");
            	 $A.util.addClass(lookupInput, 'lookupError');
            	 //component.set("v.bundleOffers", []);
            }
            // if storeResponse size is equal 0 ,display No Result Found... message on screen.    
	        else if (cabList.length == 0) {
	        	console.log("else if!!!");
	            var message = $A.get("$Label.c.OB_NoResultMsg");
	            console.log("message is: " + message);
	            component.set("v.Message", message);
	            component.set("v.hideListResults", false);
	            var forOpen = component.find("searchRes");
	            console.log("forOpen: " + forOpen);
              $A.util.removeClass(forOpen, 'slds-is-close');
               $A.util.addClass(forOpen, 'slds-is-open');
               
	        } else {
	            component.set("v.Message", '');
	            component.set("v.hideListResults", true);
	        }
          component.set("v.listOfSearchRecords", cabList);
        }
      });
      $A.enqueueAction(action);
    //  component.set("v.spinner", true);
    },
    

})