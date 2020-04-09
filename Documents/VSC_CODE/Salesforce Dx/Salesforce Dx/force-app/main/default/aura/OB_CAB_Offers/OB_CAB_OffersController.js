({
	doInit : function(component, event, helper) {
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        console.log('userId' + userId);
        helper.getABIbyUser(component, event, userId);
    },

    selectRecord : function(component, event, helper){      
    	  console.log("into selectRecord ");
    	  var listOfSearchRecords = component.get("v.listOfSearchRecords");
    	  console.log("listOfSearchRecords: " + JSON.stringify(listOfSearchRecords));
    	  console.log("index: " + event.currentTarget.id);

    	  var selectedRecord = listOfSearchRecords[event.currentTarget.id];
    	  if(selectedRecord != null){
    	  console.log("selectedRecord: ", selectedRecord);
    	  //selectedRecord is the selected NE__Lov__c sObject:
    	 
	    	var forclose = component.find("lookup-pill");
	           $A.util.addClass(forclose, 'slds-show');
	           $A.util.removeClass(forclose, 'slds-hide');
	  
	        var forclose = component.find("searchRes");
	           $A.util.addClass(forclose, 'slds-is-close');
	           $A.util.removeClass(forclose, 'slds-is-open');
	        
	        var lookUpTarget = component.find("lookupField");
	            $A.util.addClass(lookUpTarget, 'slds-hide');
	            $A.util.removeClass(lookUpTarget, 'slds-show');  
	            
	        var searchIconId = component.find("searchIconId");
		        $A.util.addClass(searchIconId, 'slds-hide');
		       //  $A.util.removeClass(pillTarget, 'slds-show');
		       component.set("v.selectedRecord", selectedRecord);
		       component.set("v.goToNextComponent", true);  
		 }
    },
     onfocus : function(component,event,helper){
       $A.util.addClass(component.find("mySpinner"), "slds-show");
     /*   var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close'); */
        // Get Default 5 Records order by createdDate DESC  
         var getInputkeyWord = '';
        // helper.searchHelper(component,event,getInputkeyWord);
                var showNoMatchMessage= component.get("v.showNoMatchMessage");
  
    },
    onblur : function(component,event,helper){       
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
        var showNoMatchMessage = component.get("v.showNoMatchMessage");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');

        
    },
    keyPressController : function(component, event, helper) {
       // get the search Input keyword   
    	var getInputkeyWord = component.get("v.SearchKeyWord");
    	var showNoMatchMessage= component.get("v.showNoMatchMessage");
        var lookupInput = component.find("lookupInputId");
        var forOpen = component.find("searchRes");
        
        if(/[0-9]/g.test(getInputkeyWord))    // ex regex: /^(?:[0-9]{5})$/
	    { 
	    	component.set("v.showErrorMessage", false); 
	    	console.log("it's valid");
	    	$A.util.removeClass(lookupInput, 'lookupError');
	        $A.util.removeClass(lookupInput, 'lookupInputError');         
	       // check if getInputKeyWord size  more then 1 then open the lookup result List and 
	       // call the helper 
	       // else close the lookup result List part.   
	       if( getInputkeyWord.length > 1){
	    	   helper.searchHelper(component,event,getInputkeyWord);
	       }else{
	    	 $A.util.removeClass(lookupInput, 'lookupError');
	    	 component.set("v.showNoMatchMessage", false);
	    	 $A.util.removeClass(forOpen, 'slds-is-open');
	    	 $A.util.addClass(forOpen, 'slds-is-close');
	       }	
	    }
	    else //input is not valid!
	    {
	    	if(getInputkeyWord.length > 0){
		    	$A.util.addClass(lookupInput, 'lookupInputError');
		    	console.log("it's NOT valid");
		    	component.set("v.showErrorMessage", true); 
	    	}
	    	else{	 
		    	$A.util.removeClass(lookupInput, 'lookupError');
		    	component.set("v.showNoMatchMessage", false);
		    	$A.util.removeClass(forOpen, 'slds-is-open');
		    	$A.util.addClass(forOpen, 'slds-is-close');
	    	}
	    }
	},
    
  // function for clear the Record Selection 
    clear :function(component,event,helper){
         var pillTarget = component.find("lookup-pill");
         var lookUpTarget = component.find("lookupField"); 
         var searchIconId= component.find("searchIconId");
         $A.util.addClass(pillTarget, 'slds-hide');
         $A.util.removeClass(pillTarget, 'slds-show');
        
         $A.util.removeClass(lookUpTarget, 'slds-hide');
         $A.util.addClass(lookUpTarget, 'slds-show');
         
         $A.util.removeClass(searchIconId, 'slds-hide');
         $A.util.addClass(searchIconId, 'slds-show');
      
         component.set("v.SearchKeyWord",null);
         component.set("v.listOfSearchRecords", null );
         component.set("v.selectedRecord", {} );   
           component.set("v.bundleOffers", [] );  
       //  helper.retrieveBundleOffers(component);
    }

})