({

	onUpdateContext : function(component, event, helper)
	{
        _utils.debug('Inside onUpdateContext for newCartBancomat');
   
        // _utils.debug('into newCartBancomat bundleStep: ' + component.get("v.bundleStep"));
        var doCheckout=component.get('v.requestCheckout');
        //var visibleCategories = component.get('v.visibleCategories');
        var objectDataMap = component.get("v.objectDataMap");
        var itemAddedToCart = component.get('v.itemAddedToCart');
        var itemRemovedFromCart = component.get('v.itemRemovedFromCart');
        var validItems=[], validBundles=[], productCategories = [], stepOneCategories = [];
        var category,bundle,listOfCategories,listOfBundles;
        var offertaId = objectDataMap.unbind.offertaId;
        component.set('v.offertaId',offertaId);
        var coreOutput = event.getParam("CartService_Output");
        
        var step =  component.get("v.bundleStep");
        //_utils.debug("step into newCartBancomat: " + step);
        var itemToUpdate =  component.get("v.itemToUpdate");
        //_utils.debug("itemToUpdate: " + JSON.stringify(itemToUpdate));
        
        var isItemFakeToRemove = component.get("v.isItemFakeToRemove");
        var itemIsIntoCart = component.get("v.itemIsIntoCart");
        
        if(itemToUpdate == null){
        
	        if(component.get('v.offertaAddedToCart')== true && component.get('v.configureBundle')==false)
			{
				// set contextOutput
				component.set('v.contextOutput',coreOutput);		
				//francesca.ribezzi firing updateContextEvent event to parent OB_FlowCart
				//START EVENT 
				var updateContextEvent = $A.get("e.c:OB_CustomUpdateContextEvent");
				updateContextEvent.setParams({ contesto: coreOutput});
	        	updateContextEvent.fire();
	        	//END event 
				//_utils.debug('updataContex after add bundle');
	            var bundId	= component.get('v.offertaId');		
				//_utils.debug(JSON.stringify(coreOutput));
	
	            var selectedBundleId='';
	            for(var i in coreOutput.listOfBundles)
	            {
	                if(bundId == coreOutput.listOfBundles[i].id)
	                {
	                	//_utils.debug('list of bundle after add to cart of first bundle element has same id');
	                    selectedBundleId=  coreOutput.listOfBundles[i].bundleElements[parseInt(step)]; 
	                    //_utils.debug("bundleElements pagobancomat: " + JSON.stringify(coreOutput.listOfBundles[i].bundleElements[parseInt(step)]));
	                    component.set('v.bundleElementName',coreOutput.listOfBundles[i].bundleElements[parseInt(step)].fields.name);
	                    //NEW --get the selectedBundleElement so we can refresh min qty and max qty
	                    component.set("v.selectedBundle",i);
	                    break;
	                }
	             }
	             
	             //check minQty for bundElement Step -- change this control!
		         if(component.get("v.bundleMinQty") >= 1){
		        	 document.getElementById("nextBtnId").disabled = true;
		        	 component.set("v.isCheckNextRequired",true);
		         }
		         else{
		        	 document.getElementById("nextBtnId").disabled = false;
		        	 component.set("v.isCheckNextRequired",false);
		         }
	             
					//_utils.debug('___ selected id  '+selectedBundleId);
	                var configureBundle 	= 	$A.get("e.NE:Bit2win_Event_BundleElements");   
	                    
					configureBundle.setParams({
					'BundleElement'	: 	selectedBundleId
					});
	            	//_utils.debug('FIRE EVENT __Bit2win_Event_BundleElements');
	              	configureBundle.fire(); 
	            component.set('v.configureBundle',true);
	           
			}     
			else if(component.get('v.offertaAddedToCart')== true && component.get('v.configureBundle')==true && !doCheckout && !(itemAddedToCart || itemRemovedFromCart || isItemFakeToRemove))
			{
				// set contextOutput
				component.set('v.contextOutput',coreOutput);
				//francesca.ribezzi firing updateContextEvent event to parent OB_FlowCart
				//START EVENT 
				var updateContextEvent = $A.get("e.c:OB_CustomUpdateContextEvent");
				updateContextEvent.setParams({ contesto: coreOutput});
	        	updateContextEvent.fire();
	        	//END event 			
				//component.set('v.spinner',false);
				helper.showBundleElement(component,coreOutput);
			}
			/* Never do a checkout in this step
			else if(doCheckout)
	        {
				// set contextOutput
				component.set('v.contextOutput',coreOutput);
				//francesca.ribezzi firing updateContextEvent event to parent OB_FlowCart
				//START EVENT 
				var updateContextEvent = $A.get("e.c:OB_CustomUpdateContextEvent");
				updateContextEvent.setParams({ contesto: coreOutput});
	        	updateContextEvent.fire();
	        	//END event 
				_utils.debug('__CHECKOUT__');
				var checkPenalty 							= 	$A.get("e.NE:Bit2win_Event_ApplyPenalty");
	            checkPenalty.setParams({
	                'action' 	: 	'checkout'
	            });
				_utils.debug('FIRE EVENT __Bit2Win_Event_ResetSaveConfiguration');
	            checkPenalty.fire();
	            
	        }
			*/
	         else if(itemAddedToCart || itemRemovedFromCart || itemIsIntoCart){
	        	
	        	/* POTENTIALLY DEAD LINK */
	        	
	        	//_utils.debug("into else if itemIsIntoCart");
	        	 //component.set('v.spinner',false);
	        	// set contextOutput
				component.set('v.contextOutput',coreOutput);
				//francesca.ribezzi firing updateContextEvent event to parent OB_FlowCart
				//START EVENT 
				var updateContextEvent = $A.get("e.c:OB_CustomUpdateContextEvent");
				updateContextEvent.setParams({ contesto: coreOutput});
	        	updateContextEvent.fire();
	        	//END event
	        	helper.addBancomatToCart(component);
        		
        		component.set('v.spinner',false);
        		component.set('v.endLoading',true);			
			
	        }
	        else if(isItemFakeToRemove){
	        	//_utils.debug("into isItemFakeToRemove in updateContext");
	        	component.set('v.contextOutput',coreOutput);
	        	
	        	//START EVENT 
				var updateContextEvent = $A.get("e.c:OB_CustomUpdateContextEvent");
				updateContextEvent.setParams({ contesto: coreOutput});
	        	updateContextEvent.fire();
	        	//END event
	        	
	        	//destroy flags and item 
	        	component.set("v.itemFakeToRemove",null);
	        	component.set("v.isItemFakeToRemove",false);
	        	//****
	        	helper.addBancomatToCart(component);
            	//helper.updateCartList(component);
	        }
	    //Updating a price only    
        }else{
        	//_utils.debug("itemToUpdate has been changed!");
        	//_utils.debug("coreOutput item updated? " + JSON.stringify(coreOutput));
        	
        	/* Marco.Ferri --> Closing conf can be skipped    
			var closeConfEvent 	= 	$A.get("e.NE:Bit2Win_Event_ResetSaveConfiguration");
	        closeConfEvent.setParams({
			    "CartService_Output": coreOutput,
			    "type": "save"
	        });
	        closeConfEvent.fire(); 
	        _utils.debug("after firing save configure event..."); 
	        _utils.debug("coreOutput after firing save configure event " + JSON.stringify(coreOutput)); 
        	*/
        	component.set("v.itemToUpdate", null);
			component.set("v.contextOutput", coreOutput);
			/**
			 * giovanni spinelli 19/09/2019 start
			 * if isToReset is true call again the reset method
			 * than check again on this attribute to stop spinner
			 */
			var isToreset = component.get('v.isToreset');
			if(isToreset == true){
				component.set('v.spinner',true);
				var index = component.get('v.indexReset');
				index = index +1;
				helper.resetValueEvent(component, event, index);
			}
			component.set("v.spinner", false);
			var isToreset = component.get('v.isToreset');
			if(isToreset == true){
				component.set("v.spinner", true);
			}
			//giovanni spinelli 19/09/2019 end
        }
    },

    //LUBRANO 16/01/2019 Libreria Log
	logInit: function(component){
		_utils.logInit(component.getName());
	},

    //NEW OPEN CART FUNCTION
    openCart: function(component, event, helper){
    
    	//_utils.debug("into open cart function");
    	var cartCont = component.find("cartContainer");
    	var cartContUL = component.find("cartContainerUL");
    	if( $A.util.hasClass(cartContUL, "animationSlideShow") ){
    		//$A.util.removeClass(cartCont,"slds-show");
    		//$A.util.addClass(cartCont,"slds-hide");
    		
    		//animations
    		$A.util.removeClass(cartContUL,"animationSlideShow");
    		$A.util.removeClass(cartContUL,"animationSlideShowOpacity");
    		$A.util.addClass(cartContUL,"animationSlideHide");
    		
    		
    		//timeout
    		window.setTimeout(
		    $A.getCallback(function() {
		        $A.util.addClass(cartContUL,"animationSlideHideOpacity");
		    }), 150
		    )
    		
    	}
    	else{
    		//$A.util.removeClass(cartCont,"slds-hide");
    		//$A.util.addClass(cartCont,"slds-show");
    		
    		//animations
    		$A.util.addClass(cartContUL,"animationSlideShow");
    		$A.util.removeClass(cartContUL,"animationSlideHide");
    		$A.util.removeClass(cartContUL,"animationSlideHideOpacity");
    		
    		//timeout
    		window.setTimeout(
		    $A.getCallback(function() {
		        $A.util.addClass(cartContUL,"animationSlideShowOpacity");
		    }), 250
		    )
    	}
    
    },
    
     onUpdateApprovalOrderRules: function(component,event, helper){
    	
    	var checkAttributeRules = event.getParam("checkAttributeRules");
    	var idChild = event.getParam("IdChildItem");
    	var itemToUpdate = event.getParam("ChildItem");
    	var itemToUpdateAttribute = event.getParam("ChildItemAttribute");
    	var status = 'ok';
    	var contextOutput = component.get("v.contextOutput");
    	
    	var oldCheckAttributeRules = component.get("v.checkAttributeRules");
    	
    	
    		 var changeAttributeEvent = 	$A.get("e.NE:Bit2win_Event_AttributeChanged");
					changeAttributeEvent.setParams({
						'itemChanged': itemToUpdate,
						'Context_Output':contextOutput
					});										
			   changeAttributeEvent.fire(); 			   

			   component.set("v.itemToUpdate", itemToUpdate);
			   component.set("v.spinner", true);
	},
	
    

	/**
	*@author giovanni spinelli <spinelli.giovanni@accenture.com>
	*@date 19/09/2019
	*@description Method to reset default value on child item
	*@params -
	*@return -
	*/
	resetValue: function(component,event, helper){
		var pagobancomatList = component.get('v.listOfItems');
		var listItemToreset = [];
		for(var i =0; i<pagobancomatList.length; i++){
			var listAtt = pagobancomatList[i].listOfAttributes;
			for(var j=0; j<listAtt.length; j++){
				var fields = listAtt[j].attribute.fields;
				if( fields.Old_Value__c != fields.value){

					fields.value = fields.Old_Value__c;
					listItemToreset.push( pagobancomatList[i].item );
				}
			}
		}
		component.set('v.listOfItems' , pagobancomatList);
		component.set( 'v.listItemToreset' , listItemToreset);
		helper.resetValueEvent(component , event , 0 );
	}
})