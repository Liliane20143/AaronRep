({
	doInit : function(component, event, helper) {
		helper.retrieveBundleOffers(component);
	},
	
      selectRecord : function(component, event, helper){      
    	  
    	  console.log("selectedRecord value: " + event.target.value);
    	  var listOfSearchRecords = component.get("v.listOfSearchRecords");
    	  var selectedRecord = listOfSearchRecords[event.target.id];
    	  console.log("selectedRecord: ", selectedRecord);
    	  component.set("v.selectedRecord", selectedRecord);
    	  //when i select an offer, i only show that offer:
    	  component.set("v.bundleOffers", selectedRecord);
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
    },
     onfocus : function(component,event,helper){
       $A.util.addClass(component.find("mySpinner"), "slds-show");
     /*   var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close'); */
        // Get Default 5 Records order by createdDate DESC  
         var getInputkeyWord = '';
        // helper.searchHelper(component,event,getInputkeyWord);
    },
    onblur : function(component,event,helper){       
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
    },
    keyPressController : function(component, event, helper) {
       // get the search Input keyword   
         var getInputkeyWord = component.get("v.SearchKeyWord");
       // check if getInputKeyWord size id more then 0 then open the lookup result List and 
       // call the helper 
       // else close the lookup result List part.   
        if( getInputkeyWord.length > 1 ){
             var forOpen = component.find("searchRes");
               $A.util.addClass(forOpen, 'slds-is-open');
               $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
             component.set("v.listOfSearchRecords", null ); 
             var forclose = component.find("searchRes");
               $A.util.addClass(forclose, 'slds-is-close');
               $A.util.removeClass(forclose, 'slds-is-open');
          }
	},
    
  // function for clear the Record Selaction 
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
         helper.retrieveBundleOffers(component);
    },
    
    onChangePicklistOrderBy :function(component,event,helper){
    	var selectedValue = event.target.value;
    	console.log("selectedValue: " + selectedValue);
    	helper.getOffersOrderBy(component,selectedValue);
    },
    //marco.ferri
    callConfigure :function(component,event,helper){
    	var offertaIndex = event.currentTarget.name;
    	var offerteList = component.get("v.bundleOffers");
    	component.set("v.selectedOffer", offerteList[offertaIndex]);
    	component.set("v.goToConfigurazioniTable", true);
    	/*var offertaIndex = event.currentTarget.name;
    	var offerteList = component.get("v.bundleOffers");
    	
    	var evt = $A.get("e.force:navigateToComponent");
    	
	    evt.setParams({
	        componentDef : "c:OB_ConfigurazioniTable",
	        componentAttributes: {
	            offerta : offerteList[offertaIndex]
	        }
	    });
	    evt.fire();*/
    },
    //13/05/19 START francesca.ribezzi adding function to show ABI list Modal:
    callAbiModal:function(component,event,helper){
    	var offertaIndex = event.currentTarget.name; 
      var offerteList = component.get("v.bundleOffers");
      console.log('selectedOffer, ', offerteList[offertaIndex]);
    	component.set("v.selectedOffer", offerteList[offertaIndex]);
      helper.retrieveABIlist(component, event);
   
    },
    //13/05/19 END francesca.ribezzi

    //13/05/19 START francesca.ribezzi adding function to get the clicked bank:
    getSelectedAbi: function(component, event, helper) {
      var selectedRows = event.getParam('selectedRows');
      var selectedABI = {};
       
      for (var i = 0; i < selectedRows.length; i++){
          selectedABI = selectedRows[i];
      }

      component.set("v.selectedRows", selectedRows);
      console.log("selectedRows: ", selectedRows);
      console.log("selectedABI: ", selectedABI);
      component.set("v.selectedABI", selectedABI);
 
      component.set("v.disableOkBtn", false);


    },
    //13/05/19 END francesca.ribezzi

    goToListini : function(component, event, helper) {
      component.set("v.goToConfigurazioniTable", true);
    },
    //13/05/19 START francesca.ribezzi :
    cancelClickedABI: function(component, event, helper) {
      component.set("v.input", ''); 
      component.set("v.showAbiModal", false);
      component.set("v.selectedABI", {});
      component.set("v.selectedRows", []);
      component.set("v.abiList", []);
     // component.set("v.selectedOffer", null);*/

    },
    //14/05/19 START francesca.ribezzi search for abi by input received:
    searchForABI: function(component, event, helper) {
     // var abiList = component.get("v.abiList"); 
      var inputABI =  component.get("v.input"); 
    /*  for(var key in abiList){
          if(abiList[key].Name == inputABI){ 
            component.set("v.abiList", abiList[key]);
            component.set("v.input", '');
          }
      }*/ 
      helper.retrieveABIlist(component, event, inputABI);
      //helper.getABI(component, event);
    },
    //14/05/19 END francesca.ribezzi 

   //15/05/19 START francesca.ribezzi search for abi by input received:
    configureSeleability: function(component, event, helper) {
      var offertaIndex = event.currentTarget.name;
    	var offerteList = component.get("v.bundleOffers");
      component.set("v.selectedOffer", offerteList[offertaIndex]);
      console.log('selectedOffer?? ' ,component.get("v.selectedOffer"));
      component.set("v.configureSelling", true);
      var offerCatalogNexiContainer = component.find('offerCatalogNexiContainer');
      offerCatalogNexiContainer.destroy();

    },
    //15/05/19 END francesca.ribezzi 
})