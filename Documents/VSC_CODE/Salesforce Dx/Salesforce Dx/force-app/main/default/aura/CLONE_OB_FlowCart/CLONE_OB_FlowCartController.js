({
	doInit:  function(component,event,helper)
	{
		console.log("into doInit FlowCart");
		var wizardWrapper = component.get("v.wizardWrapper");
		component.set("v.wizardWrapper",wizardWrapper);
		var objectDataMap = component.get("v.objectDataMap");
		//console.log("WW " + JSON.stringify(wizardWrapper) );
		var isCommunity = objectDataMap.isCommunityUser;
		
		if(isCommunity == undefined){
			isCommunity= false;
		}
		
		var urlImages = component.get("v.urlImages");
		
		if(isCommunity){
			urlImages = '..'+urlImages;
		}
		component.set("v.urlImages",urlImages);
	}, 
	
    nextStep: function(component,event,helper)
	{
        console.log('ENTER BUNDLE');	
		var objectDataMap = component.get("v.objectDataMap");
		var offertaId = objectDataMap.unbind.offertaId;
        console.log('offertaId: ' +offertaId);
        
        //get order ID -- TO MERGE
        var orderId = component.get("v.orderId");
        if($A.util.isEmpty(orderId)){
        	orderId = objectDataMap.Configuration.Id;
        	component.set("v.orderId",orderId);
        }
        //TO MERGE                        
        var step = parseInt(component.get('v.step')) +1;
        var contextOutput = component.get("v.contextOutput");
        var cartLength = 0;
        var backToOfferSelection = component.get("v.backToOfferSelection");
        if(contextOutput == undefined || contextOutput == null){
        	cartLength = 0;
        }else{
        	cartLength = contextOutput.cart.length;
        }

        component.set('v.step',step);
        if(step == 1 && cartLength > 0 && backToOfferSelection){
        
        	//boolean to check for same offer selected
        	var isSameOfferta = false; //useless now
	        	
            if(offertaId == contextOutput.cart[0].fields.bundleId){
            	console.log("you have selected the same offer!");
            	isSameOfferta = true;
            	//break; 
            }
	        //}
	        
	        if(isSameOfferta){
	        	var updateContext =	$A.get("e.NE:Bit2win_Event_RetrieveContext");
		            updateContext.setParams({
		                'componentRequest'		:	'catalog',
		                'page'					:	1
		            });
		            updateContext.fire();
		    }
	        else{
	               //if I'm in offer selection component, this checks if cart is not empty then firing clear event when the offer is changed:  
		    	   var clearCartEvent = $A.get("e.NE:Bit2win_Event_ApplyPenalty");  
		    	   clearCartEvent.setParams({
		                "action": "clearCart" 
		           });
		           clearCartEvent.fire();
		           console.log('FIRING EVENT __Bit2Win_Event_ CLEAR CART');
		          
		    	   component.set("v.clearCart", true);
	        }	
        }
        else if(step == 1){
            var offertaComponent = component.find('offertaComponent');
            $A.util.addClass(offertaComponent, 'hidden');
            
            var updateContext =	$A.get("e.NE:Bit2win_Event_RetrieveContext");
            updateContext.setParams({
                'componentRequest'		:	'catalog',
                'page'					:	1
            });
            updateContext.fire();
        } 
            //change button of offers selection in button for bundle progression
            var button1 = component.find('buttondiv');
            var button2 = component.find('navigateStepBundle');
            var previousButtonDiv = component.find('previousButtonDiv'); 
            $A.util.addClass(button1, 'hidden');
            $A.util.removeClass(button2, 'hidden');
            $A.util.removeClass(previousButtonDiv, 'hidden');
            
            document.getElementById("nextBtnId").disabled = true;
            //check if is not an usual step
	        helper.isUnusualStep(component,event,'next');
    },
    
    //Marco Ferri 06/09/2018 -- structured component bundle steps
    nextStepBundle: function(component,event,helper)
    {
    	
    	var checkAttributeRules = component.get("v.checkAttributeRules");
    	if(checkAttributeRules === "error"){
    		var errorMessage = "You must enter valid approval values before going to next step.";
    		//helper.showErrorToast(component, errorMessage);
    		
    	}
    	else{
	    	var objectDataMap = component.get("v.objectDataMap");	
	        var endBundle = false;
	        var step = component.get('v.bundleStep');
	        var outerstep = component.get('v.step');
	        var afterSummary=component.get('v.afterSummary');
	        var bundId	= objectDataMap.unbind.offertaId;
	        var	coreOutput	= component.get("v.contextOutput");
	        var bundleSelected;
	 		var selectedBundle='';
	 		var activeBundleStep;
	 		
	            for(var i in coreOutput.listOfBundles)
	            {
	                if(bundId == coreOutput.listOfBundles[i].id)
	                {
	                	var bundleLength = coreOutput.listOfBundles[i].bundleElements.length;
	                    if((bundleLength-1)> step)
	                    {
	                    	selectedBundle=  coreOutput.listOfBundles[i].bundleElements[step];
	                    	bundleSelected =  coreOutput.listOfBundles[i];
	                        break;
	                    }
	                    endBundle= true;
	                    
	                    	outerstep++;
	                    
	                }
	             }
	
	        if(!endBundle)
	        {       
	        	//close current configuration after next
	        	/*
	        	var closeConfEvent 	= 	$A.get("e.NE:Bit2Win_Event_ResetSaveConfiguration");
	            closeConfEvent.setParams({
	
				    "CartService_Output": coreOutput,
				    "type": "save"
	            });
	
	            closeConfEvent.fire();   	
	        	//
				*/
	        	
	            var configureBundle 	= 	$A.get("e.NE:Bit2win_Event_BundleElements");   
	            configureBundle.setParams({
	                'BundleElement'	: 	selectedBundle
	            });
	            console.log('FIRE EVENT __Bit2win_Event_BundleElements');
	            configureBundle.fire(); 
	        	
	            step++;
	            
	            var direction = 'next';
	            activeBundleStep = bundleSelected.bundleElements[step].fields.active;
	                    	
	            if(activeBundleStep == 'false' || activeBundleStep == false){ 
	            	component.set('v.bundleElementName',bundleSelected.bundleElements[step+1].fields.name);
	            	step++;
	            	direction = 'nextJump';
	            }
	            else{
	            	component.set('v.bundleElementName',bundleSelected.bundleElements[step].fields.name);
	            }
	            
	            //check minQty for bundElement Step
	            if(bundleSelected.bundleElements[step].fields.minqty >= 1){
	            	document.getElementById("nextBtnId").disabled = true;
	            	component.set("v.isCheckNextRequired",true);
	            	
	            }
	            else{
	            	document.getElementById("nextBtnId").disabled = false;
	            	component.set("v.isCheckNextRequired",false);
	            }
	            component.set("v.bundleMinQty",bundleSelected.bundleElements[step].fields.minqty);
	            
	            //send this info to every child
	            component.set("v.selectedBundle",bundleSelected.bundleElements[step]);
	            
	            //check maxqty for bundElement Step
	            var bundleMaxQty = bundleSelected.bundleElements[step].fields.maxqty;
	            //console.log("bundleMaxQty"+ bundleMaxQty);
	            component.set("v.bundleMaxQty",bundleMaxQty);
	            
	            
	            //check if is not an usual step
	            helper.isUnusualStep(component,event,direction);
	        }
	        else
	        {
	        	//close current configuration after next
	        	var closeConfEvent 	= 	$A.get("e.NE:Bit2Win_Event_ResetSaveConfiguration");
	            closeConfEvent.setParams({
	
				    "CartService_Output": coreOutput,
				    "type": "save"
	            });
	
	            closeConfEvent.fire();   	
	        	//  
	        
	        	if(outerstep > 2 ){
	        		component.set("v.afterSummary",true);
	        		//set spinner ON!
	        		component.set("v.spinner",true); 
	        	}

	        	
	            var configureBundle 	= 	$A.get("e.NE:Bit2Win_Event_ResetSaveConfiguration");   
	            configureBundle.setParams({
	                'type'	: 	'saveBundle'
	            });
	            console.log('FIRE EVENT __Bit2Win_Event_ResetSaveConfiguration');
	            
	            component.set('v.requestCheckout',true);
	            configureBundle.fire();
	        }
	
	        	component.set('v.step',outerstep);
	        	component.set('v.bundleStep',step);
	        	
	        	console.log('next bundle  with step: '+outerstep+' and bundleStep: '+step);
	    }//end else error approval rule
    }, 
    onUpdateContextChildren : function(component,event)
	{
       var contextOutput = component.get("v.contextOutput");
       console.log("context attr: ", context);
       var disabledNextBtn = event.getParam("disabledNextBtn");
       var context = event.getParam("contesto");
       var cartLength = event.getParam("cartLength");
       var outerStep = component.get("v.step");

       
       if(context == undefined || context == null){
    	   //console.log("context is empty!");
	        disabledNextBtn = event.getParam("disabledNextBtn");
	        console.log("disabledNextBtn: " + disabledNextBtn);
	       if(disabledNextBtn){
	    	   document.getElementById("nextBtnId").disabled = true;
	       }
	       else{
	    	   document.getElementById("nextBtnId").disabled = false;
	    	   document.getElementById("nextBtnOffertaId").disabled = false;
	       }
       }
       else{
    	   component.set("v.contextOutput",context);
       }
    	
    }, 
    
    onUpdateContext : function(component,event, helper){
    	
    	console.log('Inside onUpdateContext for flowCart');
	
        var doCheckout=component.get('v.requestCheckout');
    	var afterSummary=component.get('v.afterSummary');
    	var goToNextStep =component.get('v.goToNextStep');
    	var clearCart =component.get('v.clearCart');
    	var checkAttributeRules = component.get('v.checkAttributeRules');
    	
    	console.log("contextOutput inside onUpdateContext: " , component.get("v.contextOutput"));
    	
    	if(doCheckout && afterSummary)
        {
    		if(checkAttributeRules == "warning"){
    			//custom label declaring
    			var warningCustomLabel = $A.get("$Label.c.OB_Warning")+"!";
    			var warningCustomLabelBody = $A.get("$Label.c.OB_WarningMessageApprovalOffer");
    			
    			//flag to open modal
    			var modalHeader = warningCustomLabel; //Custom Label +"!"
    			var modalDesc = warningCustomLabelBody;
    			//custom Label
    			component.set("v.modalHeader", modalHeader);
    			component.set("v.modalDesc", modalDesc);
    			component.set("v.showWarningModal", true);
    			
    		}
			else{
				//AFTER LAST STEP OF BUNDLE CHECKOUT SITUATION -- Marco.Ferri
				console.log('__CHECKOUT__');
	
				var checkPenalty = 	$A.get("e.NE:Bit2win_Event_ApplyPenalty");
	            checkPenalty.setParams({
	                'action' 	: 	'checkout'
	            });
				console.log('FIRE EVENT __Bit2win_Event_ApplyPenalty');
	            checkPenalty.fire();
	            
	           // component.set("v.requestCheckout",false);  
	            component.set("v.spinner",true);  
	           // component.set("v.goToNextStep", true);
	       }
	       component.set("v.requestCheckout",false); 
	       
        }else if(clearCart){
         //retriving context after clearing cart event: 
    	   console.log("retriving context after clearing cart event");
		    var updateContext =	$A.get("e.NE:Bit2win_Event_RetrieveContext");
	        updateContext.setParams({
	            'componentRequest'		:	'catalog',
	            'page'					:	1,
	            "retrieveContext"		:	"bundle"
	        });
	        updateContext.fire();
		    console.log("FIRING _RetrieveContext after clearing cart event");
		    
		    //reset maps of error,warning
		    component.set("v.MapAttributeItemsError",{});
		    component.set("v.MapAttributeItemsWarning",{});
   
		    component.set("v.clearCart", false);
        }

    },
    
    handleAfterCheckOut : function(component,event, helper){
    	console.log("into handleAfterCheckOut");
    	
    	var checkAttributeRules = component.get("v.checkAttributeRules");
    	var bitwinMap = {};
    	bitwinMap = event.getParam("bitwinMap");
    	console.log("bitwinMap: " + JSON.stringify(bitwinMap));
    	console.log("bitwinMap.checkOutResponse: " + JSON.stringify(bitwinMap.checkOutResponse));
    	
    	console.log("checkAttributeRules " +checkAttributeRules);
    	if(checkAttributeRules == 'warning'){
    		//TODO save and exit bundle with approve flag set to true.
    		//i expect another helper with another action 
	    	helper.setConfigurationToApprove(component,event,bitwinMap);
    	}
    	else{
    		//splitting of order items POS by quantity -- apex call
    		helper.splitOrderItemPOS(component,event,bitwinMap);
    	}
    },
    
	previousStepBundle: function(component,event, helper){
    	console.log("into previousStepBundle");
    	var objectDataMap = component.get("v.objectDataMap");	
        var firstBundle = false;
        var step = component.get('v.bundleStep');
        var outerstep = component.get('v.step');
        
        //console.log('MARKbundleStep = '+step);
        //console.log('MARKOuterStep = '+outerstep);
        var bundId	= objectDataMap.unbind.offertaId;
        var	coreOutput	= component.get("v.contextOutput");
 		var selectedBundle='';
 		var bundleSelected;
 		var previousBtn;
 		var isSelectOffer = false;
 		
 		var activeBundleStep;
 		//console.log("coreOutput: ", coreOutput);
 		//if I'm in the first bundle step, this let's you going back to the offer selection component:
 		if(outerstep == 1 && step == 0){
	    	console.log("OB_SelectOffer STEP is COMING NEXT!");
	    	isSelectOffer = true;
	    	outerstep--;
	    	var nextButtonOffer = component.find('buttondiv'); 
            var nextButtonBundle = component.find('navigateStepBundle'); 
            var previousButtonDiv = component.find('previousButtonDiv');
            $A.util.addClass(nextButtonBundle, 'hidden');
            $A.util.addClass(previousButtonDiv, 'hidden');
            $A.util.removeClass(nextButtonOffer, 'hidden');
            document.getElementById("nextBtnOffertaId").disabled = true;
            component.set("v.backToOfferSelection", true);
        }
        else{
        	component.set("v.backToOfferSelection", false);
	        for(var i in coreOutput.listOfBundles)
	        {
	            if(bundId == coreOutput.listOfBundles[i].id)
	            {
	            	if(step > 0)
	                {
	                	selectedBundle=  coreOutput.listOfBundles[i].bundleElements[step];
	                	bundleSelected =  coreOutput.listOfBundles[i];           	
	                    break;
	                }
	                firstBundle= true;
	                outerstep = 1;
	            }
	         }
	    }
        if(!firstBundle && !isSelectOffer)
        {       
        	//close current configuration after next
        	/*
        	var closeConfEvent 	= 	$A.get("e.NE:Bit2Win_Event_ResetSaveConfiguration");
            closeConfEvent.setParams({

			    "CartService_Output": coreOutput,
			    "type": "save"
            });

            closeConfEvent.fire(); 
  			*/
        	//   
            var configureBundle 	= 	$A.get("e.NE:Bit2win_Event_BundleElements");   
            configureBundle.setParams({
                'BundleElement'	: 	selectedBundle //bundleSelected.bundleElements[step--];
            });
            console.log('FIRE EVENT __Bit2win_Event_BundleElements');
            configureBundle.fire(); 
            //if we are in the price summary component, by clicking previous we go back to offer selection component:         
            if(outerstep == 2 || (outerstep > 2 && component.get("v.checkAttributeRules") == 'warning')){
            	outerstep= 0;
            	step= 0;
            	isSelectOffer = true;
		        var objectDataMap = component.get("v.objectDataMap");
		        var offertaId = objectDataMap.unbind.offertaId;
		        console.log("offertaId: " + offertaId);
		        component.set("v.offertaId", offertaId);
		        
		    	var nextButtonOffer = component.find('buttondiv'); 
		        var nextButtonBundle = component.find('navigateStepBundle'); 
		        var previousButtonDiv = component.find('previousButtonDiv');
		        $A.util.addClass(nextButtonBundle, 'hidden');
		        $A.util.addClass(previousButtonDiv, 'hidden');
		        $A.util.removeClass(nextButtonOffer, 'hidden');
		        document.getElementById("nextBtnOffertaId").disabled = true;
		        component.set("v.backToOfferSelection", true);
		                
            }
            else{
            	step--;
            	
            	activeBundleStep = bundleSelected.bundleElements[step].fields.active;
            }
            
            if( (activeBundleStep == 'false' || activeBundleStep == false) && activeBundleStep != null){ 
            	component.set('v.bundleElementName',bundleSelected.bundleElements[step-1].fields.name);
            	step--;
            	console.log("bundleElementName after clicking previous: " + bundleSelected.bundleElements[step].fields.name);
            }
            else{
            	component.set('v.bundleElementName',bundleSelected.bundleElements[step].fields.name);
            	console.log("bundleElementName after clicking previous: " + bundleSelected.bundleElements[step].fields.name);
            }
            //check if is not an usual step
            var direction = 'previous';
            if(step == 0){
            	component.set("v.isUnusualStep",false);
            }
            else{
            	helper.isUnusualStep(component,event,direction);
            }
            
        }
        if(isSelectOffer) //firstBundle && isSelectOffer
        {        	
    	   //close current configuration after next
        	var closeConfEvent 	= 	$A.get("e.NE:Bit2Win_Event_ResetSaveConfiguration");
            closeConfEvent.setParams({

			    "CartService_Output": coreOutput,
			    "type": "save"
            });

            closeConfEvent.fire();   	
        	//   
        
           var configureBundle 	= 	$A.get("e.NE:Bit2Win_Event_ResetSaveConfiguration");   //Do I need this event??
            configureBundle.setParams({
                'type'	: 	'saveBundle'
            });
            console.log('FIRE EVENT __Bit2Win_Event_ResetSaveConfiguration');
            configureBundle.fire();
        }
        	component.set('v.step',outerstep);
        	component.set('v.bundleStep',step);
        	
        	console.log('previous bundle  with step: '+outerstep+' and bundleStep: '+step);
    },
    
    //NEW
    onUpdateApprovalOrderRules: function(component,event, helper){
    	
    	var checkAttributeRules = event.getParam("checkAttributeRules");
    	
    	var idChild = event.getParam("IdChildItem");
    	var itemToUpdate = event.getParam("ChildItem");
    	var itemToUpdateAttribute = event.getParam("ChildItemAttribute");
    	var status = 'ok';
    	//console.log("itemToUpdate "+ JSON.stringify(itemToUpdate));
    	var fatherId = itemToUpdate.fields.productcatalogitem;
    	
    	var MapAttributeItemsError = component.get("v.MapAttributeItemsError");
    	var MapAttributeItemsWarning = component.get("v.MapAttributeItemsWarning");
    	
    	//fill MAP of id - status
    	if(checkAttributeRules == 'error')
    	{
	    	if($A.util.isEmpty(MapAttributeItemsError)){
	    		MapAttributeItemsError = {};
	    	}
	    	
	    	if($A.util.isEmpty(MapAttributeItemsError[fatherId])){
	    		MapAttributeItemsError[fatherId] = {};
	    	}
	    	if($A.util.isEmpty(MapAttributeItemsError[fatherId][idChild])){
	    		MapAttributeItemsError[fatherId][idChild] = {};
	    	}
	    	MapAttributeItemsError[fatherId][idChild].childItemAttribute = itemToUpdateAttribute;
	    	MapAttributeItemsError[fatherId][idChild].status = checkAttributeRules;
		
    		component.set("v.MapAttributeItemsError",MapAttributeItemsError);
    		
    		//clear the key from the warning map if present on the same key
    		if( !($A.util.isEmpty(MapAttributeItemsWarning)) &&  !($A.util.isEmpty(MapAttributeItemsWarning[fatherId])) && !($A.util.isEmpty(MapAttributeItemsWarning[fatherId][idChild])) )
    		{	
    			delete MapAttributeItemsWarning[fatherId][idChild];
    			//is last?
				if(Object.values(MapAttributeItemsWarning[fatherId]) == ''){
					delete MapAttributeItemsWarning[fatherId];
				}
    			component.set("v.MapAttributeItemsWarning",MapAttributeItemsWarning);
    		}
    			
    	}
    	else if(checkAttributeRules == 'warning')
    	{	
    		
	    	if($A.util.isEmpty(MapAttributeItemsWarning)){
	    		MapAttributeItemsWarning = {};
	    	}
	    	
	    	if($A.util.isEmpty(MapAttributeItemsWarning[fatherId])){
	    		MapAttributeItemsWarning[fatherId] = {};
	    	}
	    	if($A.util.isEmpty(MapAttributeItemsWarning[fatherId][idChild])){
	    		MapAttributeItemsWarning[fatherId][idChild] = {};
	    	}
	    	
	    	MapAttributeItemsWarning[fatherId][idChild].childItemAttribute = itemToUpdateAttribute;
	    	MapAttributeItemsWarning[fatherId][idChild].status = checkAttributeRules;
    		
    	
    		//clear the key from the error map if present on the same key
    		if( !($A.util.isEmpty(MapAttributeItemsError)) &&  !($A.util.isEmpty(MapAttributeItemsError[fatherId])) && !($A.util.isEmpty(MapAttributeItemsError[fatherId][idChild])) )
    		{	
    			delete MapAttributeItemsError[fatherId][idChild];
    			//is last?
				if(Object.values(MapAttributeItemsError[fatherId]) == ''){
					delete MapAttributeItemsError[fatherId];
				}
    			component.set("v.MapAttributeItemsError",MapAttributeItemsError);
    		}
    		
    		component.set("v.MapAttributeItemsWarning",MapAttributeItemsWarning);	
    	}
    	else{
    		//delete entry from map is status is ok
    		
    		/* WARNING */
    		if( $A.util.isEmpty(MapAttributeItemsWarning) || $A.util.isEmpty(MapAttributeItemsWarning[fatherId]))
    		{
    		}
    		else
    		{		
    			if($A.util.isEmpty(MapAttributeItemsWarning[fatherId])){
    				delete MapAttributeItemsWarning[fatherId];
    			}
    			else{
    				delete MapAttributeItemsWarning[fatherId][idChild];
    				//is last?
    				if(Object.values(MapAttributeItemsWarning[fatherId]) == ''){
    					delete MapAttributeItemsWarning[fatherId];
    				}
    			}	
				
				component.set("v.MapAttributeItemsWarning",MapAttributeItemsWarning);	
			}
			
			/* ERROR */
			if($A.util.isEmpty(MapAttributeItemsError) || $A.util.isEmpty(MapAttributeItemsError[fatherId]))
    		{
    			//do nothing
    		}
    		else
    		{		
    			if($A.util.isEmpty(MapAttributeItemsError[fatherId])){
    				delete MapAttributeItemsError[fatherId];
    			}
    			else{
    				delete MapAttributeItemsError[fatherId][idChild];
    				//is last?
    				if(Object.values(MapAttributeItemsError[fatherId]) == ''){
    					delete MapAttributeItemsError[fatherId];
    				}
    				
    			}	
				component.set("v.MapAttributeItemsError",MapAttributeItemsError);
				
			}				
    	}
    	if( ($A.util.isEmpty(MapAttributeItemsError)) && ($A.util.isEmpty(MapAttributeItemsWarning)) ){
    		//do nothing
	    }
	    else if( !($A.util.isEmpty(MapAttributeItemsError)) ){
	    	status = 'error';
	    }
	    else if( ($A.util.isEmpty(MapAttributeItemsError)) && !($A.util.isEmpty(MapAttributeItemsWarning)) ){
	    	status = 'warning';
	    }
    	component.set("v.checkAttributeRules", status);
    	console.log("MapAttributeItemsError", JSON.stringify(MapAttributeItemsError));
    	console.log("MapAttributeItemsWarning", JSON.stringify(MapAttributeItemsWarning));
    	console.log("checkAttributeRules "+ component.get("v.checkAttributeRules") );
    },
    
    /*NEWWWW */
    onUpdateParentMapAttribute: function(component,event, helper){
    	
    	var fatherId = event.getParam("IdItem");
    	var status = 'ok';
    	
    	var MapAttributeItemsError = component.get("v.MapAttributeItemsError");
    	var MapAttributeItemsWarning = component.get("v.MapAttributeItemsWarning");
    	
    	/* WARNING */
		if( $A.util.isEmpty(MapAttributeItemsWarning) || $A.util.isEmpty(MapAttributeItemsWarning[fatherId]))
		{
		}
		else
		{		
			delete MapAttributeItemsWarning[fatherId];	
			component.set("v.MapAttributeItemsWarning",MapAttributeItemsWarning);	
		}
			
		/* ERROR */
		if($A.util.isEmpty(MapAttributeItemsError) || $A.util.isEmpty(MapAttributeItemsError[fatherId]))
		{
			//do nothing
		}
		else
		{		
			delete MapAttributeItemsError[fatherId];
			component.set("v.MapAttributeItemsError",MapAttributeItemsError);
		}
				
    	if( ($A.util.isEmpty(MapAttributeItemsError)) && ($A.util.isEmpty(MapAttributeItemsWarning)) ){
    		//do nothing
	    }
	    else if( !($A.util.isEmpty(MapAttributeItemsError)) ){
	    	status = 'error';
	    }
	    else if( ($A.util.isEmpty(MapAttributeItemsError)) && !($A.util.isEmpty(MapAttributeItemsWarning)) ){
	    	status = 'warning';
	    }
	    
    	component.set("v.checkAttributeRules", status);
    	console.log("MapAttributeItemsError", JSON.stringify(MapAttributeItemsError));
    	console.log("MapAttributeItemsWarning", JSON.stringify(MapAttributeItemsWarning));
    	console.log("checkAttributeRules "+ component.get("v.checkAttributeRules") );
    
    },
    
    handleModalButton: function(component,event, helper){
    	//by clicking ok btn -> firing checkout
    	
		console.log('__CHECKOUT__');

		var checkPenalty = 	$A.get("e.NE:Bit2win_Event_ApplyPenalty");
        checkPenalty.setParams({
            'action' 	: 	'checkout'
        });
		console.log('FIRE EVENT __Bit2win_Event_ApplyPenalty');
        checkPenalty.fire();
        
        component.set("v.showWarningModal", false);
        component.set("v.spinner",true);  
    },
    
    //closing modal:
    handleModalCancel: function(component,event, helper){
    	//reset more 
    	component.set("v.step",2);
    	component.set("v.spinner",false);    	
    	component.set("v.showWarningModal", false);
    	
    },
    
})