({
	
	searchHelper : function(component, event, getInputkeyWord) {
		
      var searchText = component.get('v.SearchKeyWord');
      var action = component.get('c.getABIListFromInput');
      action.setParams({abi: searchText});
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === 'SUCCESS') {
          var abiList = response.getReturnValue();
         //   component.set("v.spinner", false);
            console.log("abiList found: ", abiList);
            if(getInputkeyWord.length < 5){
            	 var lookupInput = component.find("lookupInputId");
            	 $A.util.removeClass(lookupInput, 'lookupError');
            	 component.set("v.showNoMatchMessage", false);
            	 var forOpen = component.find("searchRes");
            	 $A.util.addClass(forOpen, 'slds-is-open');
            	 $A.util.removeClass(forOpen, 'slds-is-close');
            }
            if(abiList.length == 0 && getInputkeyWord.length == 5){
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
	        else if (abiList.length == 0) {
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
	          //  component.set("v.abiList", abiList);
	        }
          component.set("v.listOfSearchRecords", abiList);
        }
      });
      $A.enqueueAction(action);
    //  component.set("v.spinner", true);
    },
    

})