({ 
	 doInit : function(component, event, helper) {
    
    	console.log("__init");
    	console.log("abiCablov: ", component.get("v.abiCabLov"));
    	helper.loadConfigurazioni(component);	
    
	},
	onPagePrevious: function(component, event, helper) {
		var page = component.get("v.page") || 1;
        page = page - 1;
        
        //check if a search is been made
		var name = component.get("v.name");
		var listino = component.get("v.listino");
		var schemaPrezzi = component.get("v.schemaPrezzi");
		var modello = component.get("v.modello");
		
		var from = document.getElementById("dateFromBANK").value;
		var to = document.getElementById("dateTo").value;
		if(!$A.util.isEmpty(name)|| !$A.util.isEmpty(from) || !$A.util.isEmpty(to) || !$A.util.isEmpty(listino) || !$A.util.isEmpty(schemaPrezzi)  || !$A.util.isEmpty(modello)  ){
			helper.searchconfigurazioni(component,page);
		}
		else{
			helper.loadConfigurazioni(component,page);
		}		
    },
    onPageNext: function(component, event, helper) {
    	var page = component.get("v.page") || 1;
        page = page + 1;
        
        //check if a search is been made
        var name = component.get("v.name");
    	var listino = component.get("v.listino");
    	var schemaPrezzi = component.get("v.schemaPrezzi");
    	var modello = component.get("v.modello");
    	
    	var from = document.getElementById("dateFromBANK").value;
    	var to = document.getElementById("dateTo").value;
        if(!$A.util.isEmpty(name)|| !$A.util.isEmpty(from) || !$A.util.isEmpty(to) || !$A.util.isEmpty(listino) || !$A.util.isEmpty(schemaPrezzi)  || !$A.util.isEmpty(modello)  ){
    		helper.searchconfigurazioni(component,page);
    	}
        else{
        	helper.loadConfigurazioni(component,page);
        }		
    },
    onPageSelected: function (component,event,helper){
    	
    	var page = event.currentTarget.id;
    	
    	//check if a search is been made
		var name = component.get("v.name");
		var listino = component.get("v.listino");
		var schemaPrezzi = component.get("v.schemaPrezzi");
		var modello = component.get("v.modello");
		
		var from = document.getElementById("dateFromBANK").value;
		var to = document.getElementById("dateTo").value;
		if(!$A.util.isEmpty(name)|| !$A.util.isEmpty(from) || !$A.util.isEmpty(to) || !$A.util.isEmpty(listino) || !$A.util.isEmpty(schemaPrezzi)  || !$A.util.isEmpty(modello)  ){
			helper.searchconfigurazioni(component,page);
		}
		else{
			helper.loadConfigurazioni(component,page);
		}		
    },  
    editConfigurazione :function(component, event, helper) {
    	var configurazioneIndex = event.currentTarget.name;
    	var configurazioniList = component.get("v.configurazioniList");
    	var selectedMatrix = configurazioniList[configurazioneIndex];
    	component.set("v.selectedMatrix",selectedMatrix);
    	component.set("v.goToConfigurationDetailsCAB", true);
    	component.set("v.goBackToOfferCatalogCAB", false);
    	component.set("v.showConfigTableCAB", false);
    /*	var configurazioneIndex = event.currentTarget.name;
    	var configurazioniList = component.get("v.configurazioniList");
    	var abiCabLov = component.get("v.abiCabLov");
    	var offerta = component.get("v.offerta");
    	//console.log("sto editando listino all'indice ",listinoList[listinoIndex]);
    	
    	var evt = $A.get("e.force:navigateToComponent");
    	
	    evt.setParams({
	        componentDef : "c:OB_ConfigurationDetailsCAB", //CAB
	        componentAttributes: {
	            offer: offerta,
	            matrixParameter : configurazioniList[configurazioneIndex],
	            abiCabLov : abiCabLov 
	        }
	    });
	    evt.fire();*/
    },
    deleteConfigurazione :function(component, event, helper) {
    	console.log("init Delete"); 
    	var configurazioneIndex = event.currentTarget.name;
    	var configurazioniList = component.get("v.configurazioniList");
    	component.set("v.configurazioneToDelete",configurazioniList[configurazioneIndex]);
    	
    	console.log("configurazioneToDelete",configurazioniList[configurazioneIndex]);
    	//set modal attributes
    	
    	var deleteLabel = $A.get("$Label.c.OB_Delete");
    	var deleteMsg = $A.get("$Label.c.OB_DeleteMsg");
    	var deleteHeader = $A.get("$Label.c.OB_DeleteHeader");
    	
    	component.set("v.modalButton",deleteLabel);
    	component.set("v.modalDesc",deleteMsg+' "'+configurazioniList[configurazioneIndex].OB_Componente__r.NE__Product_Name__c+'" ?');
    	component.set("v.modalHeader",deleteHeader);
    	
    	component.set("v.Confirm",true);
    	
    },
    searchConfigurazioni :function(component, event, helper) {
    	
    	//var name = document.getElementById("Componente").value;
    	var name = component.get("v.name");
    	var listino = component.get("v.listino");
    	var schemaPrezzi = component.get("v.schemaPrezzi");
    	var modello = component.get("v.modello");
    	
    	var from = document.getElementById("dateFromBANK").value;
    	var to = document.getElementById("dateTo").value;
    	
    	console.log("parameters are: "+name+","+from+","+to+","+listino+","+schemaPrezzi+","+modello);
    	
    	component.set("v.name",name);
    	component.set("v.from",from);
    	component.set("v.to",to);
    	
    	//reset ALL error msgs
    	var lookupInput = component.find("lookupCatalogInputId");
	    $A.util.removeClass(lookupInput, 'lookupError');
    	//document.getElementsByName("Listino")[0].classList.remove("borderError"); //TODO
    	//document.getElementsByName("SchemaPrezzi")[0].classList.remove("borderError");
    	//document.getElementsByName("ModelloDiBusiness")[0].classList.remove("borderError"); 
    	document.getElementById("dateFromBANK").getElementsByTagName("input")[0].classList.remove("borderError");
    	//document.getElementById("dateTo").getElementsByTagName("input")[0].classList.remove("borderError");
    	var errorMsgs = [];
    	component.set("v.errorMsg",errorMsgs);
    	

    	if(!$A.util.isEmpty(name)|| !$A.util.isEmpty(from) || !$A.util.isEmpty(to) || !$A.util.isEmpty(listino) || !$A.util.isEmpty(schemaPrezzi)  || !$A.util.isEmpty(modello)  ){
    		var page = 1; //make it so the user will always start from first page
    		helper.searchconfigurazioni(component,page);
    	}
    },
    newConfigurazione:function(component, event, helper) {
    	console.log("__init newConf");

        var name = component.get("v.name");
        var lookupInput = component.find("lookupCatalogInputId");
        
        var listino = component.get("v.listino");
    	var schemaPrezzi = component.get("v.schemaPrezzi");
    	var modello = component.get("v.modello");
        
    	var from = document.getElementById("dateFromBANK").value;
    	var to = document.getElementById("dateTo").value;
    	
    	console.log("parameters are: "+name+","+from+","+to+","+listino+","+schemaPrezzi+","+modello);
    	
    	//component.set("v.name",name);
    	component.set("v.from",from);
    	//component.set("v.to",to);
    	
    	//&& listino != '' dont check listini for now, logic is unclear
        if(name != '' && from != ''  ){ //&& to != '' && schemaPrezzi != '' && modello != ''
        	
        	//reset ALL error msgs	    	
	    	$A.util.removeClass(lookupInput, 'lookupError');
	    	//document.getElementsByName("Listino")[0].classList.remove("borderError"); //TODO
	    	//document.getElementsByName("SchemaPrezzi")[0].classList.remove("borderError");
	    	//document.getElementsByName("ModelloDiBusiness")[0].classList.remove("borderError"); 
        	document.getElementById("dateFromBANK").getElementsByTagName("input")[0].classList.remove("borderError");
        	//document.getElementById("dateTo").getElementsByTagName("input")[0].classList.remove("borderError");
        	var errorMsgs = [];
        	component.set("v.errorMsg",errorMsgs);
        	
    		var page = 1; //make it so the user will always start from first page
    		helper.createconfigurazione(component,page);
    		
    		//cleaning forms after insert
    		var pillTarget = component.find("lookup-pill"); //Catalog
		    var lookUpTarget = component.find("lookupField"); //Catalog
		    var searchIconId= component.find("searchIconId"); //Catalog
		    $A.util.addClass(pillTarget, 'slds-hide');
		    $A.util.removeClass(pillTarget, 'slds-show');
		    
		    $A.util.removeClass(lookUpTarget, 'slds-hide');
		    $A.util.addClass(lookUpTarget, 'slds-show');
		     
		    $A.util.removeClass(searchIconId, 'slds-hide');
		    $A.util.addClass(searchIconId, 'slds-show');
		  
		    component.set("v.SearchKeyWord",null);
		    component.set("v.listOfSearchRecords", null );
		    component.set("v.selectedRecord", {} );
			component.set("v.name",'');
			
			var pillTarget2 = component.find("lookup-pill2"); 
		    var lookUpTarget2 = component.find("lookupField2"); 
		    var searchIconId2= component.find("searchIconId2"); 
		    $A.util.addClass(pillTarget2, 'slds-hide');
		    $A.util.removeClass(pillTarget2, 'slds-show');
		    
		    $A.util.removeClass(lookUpTarget2, 'slds-hide');
		    $A.util.addClass(lookUpTarget2, 'slds-show');
		     
		    $A.util.removeClass(searchIconId2, 'slds-hide');
		    $A.util.addClass(searchIconId2, 'slds-show');
		  
		    component.set("v.SearchKeyWord2",null);
		    component.set("v.listOfSearchRecords2", null );
		    component.set("v.selectedRecord2", {} );
			component.set("v.listino",'');
			
			//component.find("SchemaPrezzi").set("v.value",'');
			component.set("v.schemaPrezzi",[]);
			//component.find("ModelloDiBusiness").set("v.value",'');
			component.set("v.modello",[]);
			
	    	document.getElementById("dateFromBANK").value= '';
	    	document.getElementById("dateTo").value = '';
	    	
	    	if(component.get("v.resetForm") == true){
	    		component.set("v.resetForm",false);
			}
    		 
    	}
    	else{
    		console.log("ERROR with input");
    		var errorMsgs = [];
    		
    		//get custom labels
    		var SelectError = $A.get("$Label.c.OB_SelectError");
    		var FromValError = $A.get("$Label.c.OB_ValidityFROMError");
    		var ToValError = $A.get("$Label.c.OB_ValidityTOError");
    		
    		
    		//error messages on every null element
    		/* COMPONENT */
    		if($A.util.isEmpty(name))
    		{
    			//document.getElementsByName("Componente")[0].classList.add("borderError");
    			$A.util.addClass(lookupInput, 'lookupError');
    			//add error msg
    			errorMsgs.push({
    				parameter: "Nome",
    				message: SelectError
    			});    			
    		}
    		else{
    			//reset errMsg
    			//document.getElementsByName("Componente")[0].classList.remove("borderError");
    			$A.util.removeClass(lookupInput, 'lookupError');
    		}
    		/* LISTINO */
    		/*
    		if($A.util.isEmpty(listino))
    		{
    			document.getElementsByName("Listino")[0].classList.add("borderError");
    			//add error msg
    			errorMsgs.push({
    				parameter: "Listino",
    				message: SelectError
    			});    			
    		}
    		else{
    			//reset errMsg
    			document.getElementsByName("Listino")[0].classList.remove("borderError");
    		}
			*/
    		/* SCHEMA PREZZI */
    		/*
    		if($A.util.isEmpty(schemaPrezzi))
    		{
    			document.getElementsByName("SchemaPrezzi")[0].classList.add("borderError");
    			//add error msg
    			errorMsgs.push({
    				parameter: "SchemaPrezzi",
    				message: SelectError
    			});    			
    		}
    		else{
    			//reset errMsg
    			document.getElementsByName("SchemaPrezzi")[0].classList.remove("borderError");
    		}
			*/
    		/* MODELLO ACQ */
    		/*
    		if($A.util.isEmpty(modello))
    		{
    			document.getElementsByName("ModelloDiBusiness")[0].classList.add("borderError");
    			//add error msg
    			errorMsgs.push({
    				parameter: "ModelloDiBusiness",
    				message: SelectError
    			});    			
    		}
    		else{
    			//reset errMsg
    			document.getElementsByName("ModelloDiBusiness")[0].classList.remove("borderError");
    		}
			*/
    		/* DATA VALIDITA FROM */
    		if(from == '')
    		{
    			document.getElementById("dateFromBANK").getElementsByTagName("input")[0].classList.add("borderError");
    			//add error msg
    			errorMsgs.push({
    				parameter: "dateFrom",
    				message: FromValError
    			});
    					
    		}
    		else{
    			//reset errMsg
    			document.getElementById("dateFromBANK").getElementsByTagName("input")[0].classList.remove("borderError");
    			errorMsgs.push({
    				parameter: "dateFrom",
    				message: ''
    			});
    		}
    		/* DATA VALIDITA TO */
    		/*
    		if(to == '')
    		{
    			document.getElementById("dateTo").getElementsByTagName("input")[0].classList.add("borderError");
    			
    			//add error msg
    			errorMsgs.push({
    				parameter: "dateTo",
    				message: ToValError
    			});
	
    		}
    		else{
    			//reset errMsg
    			document.getElementById("dateTo").getElementsByTagName("input")[0].classList.remove("borderError");
    			
    		}
			*/
    		component.set("v.errorMsg",errorMsgs);
    		//console.log("v.errorMsg",errorMsgs);
    	}   
	},
	handleModalCancel:function(component,event,helper){
		//easy closing the modal
		component.set("v.Confirm",false);
	
	},
	handleModalButton:function(component,event,helper){
		var page = 1;
		var buttonMode = component.get("v.modalButton");
		if(buttonMode == 'Delete'){
			var configurazioneToDelete  = component.get("v.configurazioneToDelete");
			helper.deleteconfigurazione(component,page,configurazioneToDelete);
			component.set("v.Confirm",false);
		}
		else{
			console.log("Error!");
			component.set("v.Confirm",false);
		}
	},
	cleanForms:function(component,event,helper){
		
		//make option selected a fake option of 0
		//component.find("Componente").set("v.value",''); //TODO change
		
		var pillTarget = component.find("lookup-pill"); //Catalog
	    var lookUpTarget = component.find("lookupField"); //Catalog
	    var searchIconId= component.find("searchIconId"); //Catalog
	    $A.util.addClass(pillTarget, 'slds-hide');
	    $A.util.removeClass(pillTarget, 'slds-show');
	    
	    $A.util.removeClass(lookUpTarget, 'slds-hide');
	    $A.util.addClass(lookUpTarget, 'slds-show');
	     
	    $A.util.removeClass(searchIconId, 'slds-hide');
	    $A.util.addClass(searchIconId, 'slds-show');
	  
	    component.set("v.SearchKeyWord",null);
	    component.set("v.listOfSearchRecords", null );
	    component.set("v.selectedRecord", {} );
		component.set("v.name",'');
		
		var pillTarget2 = component.find("lookup-pill2"); 
	    var lookUpTarget2 = component.find("lookupField2"); 
	    var searchIconId2= component.find("searchIconId2"); 
	    $A.util.addClass(pillTarget2, 'slds-hide');
	    $A.util.removeClass(pillTarget2, 'slds-show');
	    
	    $A.util.removeClass(lookUpTarget2, 'slds-hide');
	    $A.util.addClass(lookUpTarget2, 'slds-show');
	     
	    $A.util.removeClass(searchIconId2, 'slds-hide');
	    $A.util.addClass(searchIconId2, 'slds-show');
	  
	    component.set("v.SearchKeyWord2",null);
	    component.set("v.listOfSearchRecords2", null );
	    component.set("v.selectedRecord2", {} );
		component.set("v.listino",'');
		
		//component.find("SchemaPrezzi").set("v.value",'');
		component.set("v.schemaPrezzi",[]);
		//component.find("ModelloDiBusiness").set("v.value",'');
		component.set("v.modello",[]);
		
    	document.getElementById("dateFromBANK").value= '';
    	document.getElementById("dateTo").value = '';
    	
    	if(component.get("v.resetForm") == true){
    		component.set("v.resetForm",false);
		}
	},
	goBackToOffertaTable: function(component, event, helper) { 
		component.set("v.goBackToOfferCatalogCAB", true);
		 	component.set("v.showConfigTableCAB", false);
		 	 //	component.set("v.showConfigTableCAB", false);
	/*	var abiCabLov = component.get("v.abiCabLov");
		var event = $A.get("e.force:navigateToComponent");
	    event.setParams({
	        componentDef : "c:OB_CAB_Offers", //CAB
	        componentAttributes: {
	            selectedRecord: abiCabLov,
	            goToNextComponent: true
	        }
	    });
	    event.fire(); */
	},
	
changeComponente: function(component, event, helper) { 
		
		//var selectedValue= event.getSource().get("v.value");
		//var selectedValueType = event.getSource().get("v.name");
		
		var selectedElement = event.currentTarget.id;
		var selectedValueType = event.currentTarget.name;
		console.log("selectedElement "+ selectedElement);
		
		if(selectedValueType == 'Componente'){ 
			component.set("v.name",selectedElement);//NO
		}
		else if(selectedValueType == 'Listino'){
			component.set("v.listino",selectedElement); //NO
		}
		else if(selectedValueType == 'SchemaPrezzi'){
			var found = false;
			var index;
			var prezziAsIs = component.get("v.schemaPrezzi");
			for(var i = 0; i < prezziAsIs.length; i++){
				if(prezziAsIs[i] == selectedElement){
					var found = true;
					index = i;
				}
			}
			if(!found){
				prezziAsIs.push(selectedElement);
			}
			else{
				prezziAsIs.splice(index,1);
			}
			component.set("v.schemaPrezzi",prezziAsIs);
		}
		else if(selectedValueType == 'ModelloDiBusiness'){
			//component.set("v.modello",selectedElement);
			var found = false;
			var index;
			var modelliAsIs = component.get("v.modello");
			for(var i = 0; i < modelliAsIs.length; i++){
				if(modelliAsIs[i] == selectedElement){
					var found = true;
					index = i;
				}
			}
			if(!found){
				modelliAsIs.push(selectedElement);
			}
			else{
				modelliAsIs.splice(index,1);
			}
			component.set("v.modello",modelliAsIs);
		}
	},
	//setting the clicked product as the chosen one for the new row:
	selectRecord : function(component, event, helper){      
    	  
    	  console.log("selectedRecord value: " + event.target.value);
    	  var listOfSearchRecords = component.get("v.listOfSearchRecords");
    	   
    	  var selectedRecord = listOfSearchRecords[event.target.id];
    	  //console.log("selectedRecord: ", selectedRecord);
    	  if(selectedRecord != null){
    	  
    	  component.set("v.selectedRecord", selectedRecord);
    	  
    	   //reset message Error
	    	 var indexErr;
	    	 var errMsg = component.get("v.errorMsg");
	    	 
	    	 for (var i = 0; i< errMsg.length; i++){	 
	    		 if(errMsg[i].parameter == 'Nome'){
	    			 indexErr = i;
	    			 break;
	    		 }
	    	 }
	    	 errMsg.splice(indexErr,1);
	    	 component.set("v.errorMsg",errMsg);
    	 
    	  var productId = selectedRecord.Id;
    	  component.set("v.name",selectedRecord.Id);
    	  console.log("productId: " + productId);
			
    	var forshow = component.find("lookup-pill");
           $A.util.addClass(forshow, 'slds-show');
           $A.util.removeClass(forshow, 'slds-hide');
  
        var forclose = component.find("searchRes");
           $A.util.addClass(forclose, 'slds-is-close');
           $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
            $A.util.addClass(lookUpTarget, 'slds-hide');
            $A.util.removeClass(lookUpTarget, 'slds-show');  
            
         var searchIconId = component.find("searchIconId");
	         $A.util.addClass(searchIconId, 'slds-hide');
	       //  $A.util.removeClass(pillTarget, 'slds-show');
	   }
    },
    onfocus : function(component,event,helper){
       $A.util.addClass(component.find("mySpinner"), "slds-show");
       var getInputkeyWord = '';
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
         component.set("v.name",'');    
           
    },
    //setting the clicked product as the chosen one for the new row:
	selectRecord2 : function(component, event, helper){      
    	  
    	  console.log("selectedRecord value: " + event.target.id);
    	  var listOfSearchRecords = component.get("v.listOfSearchRecords2");
    	  var selectedRecord = listOfSearchRecords[event.target.id];
    	  
    	  if(selectedRecord != null){
	    	  //console.log("selectedRecord: ", selectedRecord);
	    	  component.set("v.selectedRecord2", selectedRecord);
	    	 
	    	  var productId = selectedRecord.Id;
	    	  component.set("v.listino",selectedRecord.Id);
	    	  console.log("productId: " + productId);
				
	    	var forshow = component.find("lookup-pill2");
	           $A.util.addClass(forshow, 'slds-show');
	           $A.util.removeClass(forshow, 'slds-hide');
	  
	        var forclose = component.find("searchRes2");
	           $A.util.addClass(forclose, 'slds-is-close');
	           $A.util.removeClass(forclose, 'slds-is-open');
	        
	        var lookUpTarget = component.find("lookupField2");
	            $A.util.addClass(lookUpTarget, 'slds-hide');
	            $A.util.removeClass(lookUpTarget, 'slds-show');  
	            
	         var searchIconId = component.find("searchIconId2");
		         $A.util.addClass(searchIconId, 'slds-hide');
		       //  $A.util.removeClass(pillTarget, 'slds-show');
    	  }
    },
    onfocus2 : function(component,event,helper){
       $A.util.addClass(component.find("mySpinner2"), "slds-show");
       var getInputkeyWord = '';
    },
    onblur2 : function(component,event,helper){       
        component.set("v.listOfSearchRecords2", null );
        var forclose = component.find("searchRes2");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
    },
    keyPressController2 : function(component, event, helper) {
       // get the search Input keyword   
         var getInputkeyWord = component.get("v.SearchKeyWord2");
       // check if getInputKeyWord size id more then 0 then open the lookup result List and 
       // call the helper 
       // else close the lookup result List part.   
        if( getInputkeyWord.length > 1 ){
             var forOpen = component.find("searchRes2");
               $A.util.addClass(forOpen, 'slds-is-open');
               $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper2(component,event,getInputkeyWord);
        }
        else{  
           component.set("v.listOfSearchRecords2", null ); 
           var forclose = component.find("searchRes2");
           $A.util.addClass(forclose, 'slds-is-close');
           $A.util.removeClass(forclose, 'slds-is-open');
          }
	},
    
    // function for clear the Record Selection 
    clear2 :function(component,event,helper){
         var pillTarget = component.find("lookup-pill2");
         var lookUpTarget = component.find("lookupField2"); 
         var searchIconId= component.find("searchIconId2");
         $A.util.addClass(pillTarget, 'slds-hide');
         $A.util.removeClass(pillTarget, 'slds-show');
        
         $A.util.removeClass(lookUpTarget, 'slds-hide');
         $A.util.addClass(lookUpTarget, 'slds-show');
         
         $A.util.removeClass(searchIconId, 'slds-hide');
         $A.util.addClass(searchIconId, 'slds-show');
      
         component.set("v.SearchKeyWord2",null);
         component.set("v.listOfSearchRecords2", null );
         component.set("v.selectedRecord2", {} );
         component.set("v.listino",'');    
           
    },
     //open generic picklist
    togglePicklist :function(component,event,helper){
    	
    	var pickToToggle = event.currentTarget.id;    	
    	var idPick = 'arrowId_'+pickToToggle;
    	var arrowIcon = component.find(idPick);
    	
    	var pickElement = document.getElementById(pickToToggle); 	
    	
    		
    	if(pickElement.classList.contains("slds-is-open")){		
    			pickElement.classList.remove("slds-is-open");
    			if( !($A.util.isUndefined(arrowIcon)) )
    			{
    				arrowIcon.set("v.iconName",'utility:down');
    			}
    	}
    	else
    	{	
    			pickElement.classList.add("slds-is-open");
    			if( !($A.util.isUndefined(arrowIcon)) )
    			{
    				arrowIcon.set("v.iconName",'utility:up');
    			}
    	}
    
    },
})