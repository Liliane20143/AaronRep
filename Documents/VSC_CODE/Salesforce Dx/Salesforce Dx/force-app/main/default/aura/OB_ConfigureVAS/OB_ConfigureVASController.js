({
    doInit : function(component, event, helper)
    {
    	//_utils.debug('init configure VAS');  
    },
    
	//LUBRANO 16/01/2019 Libreria Log
	logInit: function(component){
		_utils.logInit(component.getName());
	},
    
    onUpdateContext : function(component, event, helper)
	{
        _utils.debug('Inside onUpdateContext for ConfigureVAS');
        var doCheckout=component.get('v.requestCheckout');
        //var visibleCategories = component.get('v.visibleCategories');
        var objectDataMap = component.get("v.objectDataMap");
        var itemAddedToCart = component.get('v.itemAddedToCart');
        var itemRemovedFromCart = component.get('v.itemRemovedFromCart');
        var itemEditedFromCart = component.get("v.itemEditedFromCart");
        var validItems=[], validBundles=[], productCategories = [], stepOneCategories = [];
        var category,bundle,listOfCategories,listOfBundles;
        var offertaId = objectDataMap.unbind.offertaId;
        component.set('v.offertaId',offertaId);
        var coreOutput = event.getParam("CartService_Output");
        var step =  component.get("v.bundleStep");
        //_utils.debug("step into configureVAS: " + step);

		if(component.get('v.offertaAddedToCart')== true && component.get('v.configureBundle')==false )
		{
			//Bit2Win Magic? -- Marco.Ferri
			
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
                    //_utils.debug("bundleElements vas: " + JSON.stringify(coreOutput.listOfBundles[i].bundleElements[parseInt(step)]));
                    component.set('v.bundleElementName',coreOutput.listOfBundles[i].bundleElements[parseInt(step)].fields.name)
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
            //component.set('v.bundleStep',1);
		}
		else if(component.get('v.offertaAddedToCart')== true && component.get('v.configureBundle')==true && !doCheckout && !(itemAddedToCart || itemRemovedFromCart))
		{
			//STARTING ALL PRODUCTS AND REFRESHING CART FROM PREVIOUS STEPS
			
			// set contextOutput
			component.set('v.contextOutput',coreOutput);
			//francesca.ribezzi firing updateContextEvent event to parent OB_FlowCart
			//START EVENT 
			var updateContextEvent = $A.get("e.c:OB_CustomUpdateContextEvent");
			updateContextEvent.setParams({ contesto: coreOutput});
        	updateContextEvent.fire();
        	//END event 			
			//_utils.debug('__after configure bundle element__');
			
			//_utils.debug(JSON.stringify(event.getParam("CartService_Output")));
		
			component.set('v.spinner',false);
						
			helper.showBundleElement(component,coreOutput);
			/*		
			component.set('v.productCategories',coreOutput.listOfCategories);
			component.set('v.productCategories',coreOutput.listOfCategories);
			 */
			//listOfCategories.id
			
			//listOfItems.fields.categoryidcategoryid 

		}
		/*
		else if(doCheckout)
        {
			//AFTER LAST STEP OF BUNDLE CHECKOUT SITUATION -- Marco.Ferri
        
			// set contextOutput
			component.set('v.contextOutput',coreOutput);
			//francesca.ribezzi firing updateContextEvent event to parent OB_FlowCart
			//START EVENT 
			var updateContextEvent = $A.get("e.c:OB_CustomUpdateContextEvent");
			updateContextEvent.setParams({ contesto: coreOutput});
        	updateContextEvent.fire();
        	//END event 
			_utils.debug('__CHECKOUT__');

			var checkPenalt = 	$A.get("e.NE:Bit2win_Event_ApplyPenalty");
            checkPenalty.setParams({
                'action' 	: 	'checkout'
            });
			_utils.debug('FIRE EVENT __Bit2Win_Event_ResetSaveConfiguration');
            checkPenalty.fire();
             
        }
		 */
        else if(itemAddedToCart || itemRemovedFromCart || itemEditedFromCart ){
        	
        	// set contextOutput
			component.set('v.contextOutput',coreOutput);
			//francesca.ribezzi firing updateContextEvent event to parent OB_FlowCart
			//START EVENT 
			var updateContextEvent = $A.get("e.c:OB_CustomUpdateContextEvent");
			updateContextEvent.setParams({ contesto: coreOutput});
        	updateContextEvent.fire();
        	//END event 			
        	
        	var needConfig = component.get("v.needConfiguration");
        	var itemToConfigure = component.get("v.itemToConfigure");
        	var isFirstAdd = component.get('v.isFirstAdd');
        	var itemId = component.get("v.newItemId");
        	var isCloseConf = component.get("v.isCloseConf");
        	var fakeAdd = component.get("v.fakeAdd");
        	var qtyEdit = component.get("v.qtyEdit");
        	var qtyEditAfterFakeAdd = component.get("v.qtyEditAfterFakeAdd");
        	var noUpdateCart = component.get("v.noUpdateCartAfterRemoveFake");
        	var openDetailsBtnId;
        	
        	var maxQty = component.get("v.qtyMax");
        	var fakeToTrue = false;
        	
        	//var listOfCart = component.get("v.listOfCartTotal");
        	
        	//check changes in min max qty
        	//helper.checkMinMaxQtyBundleStep(component,event,coreOutput);
        	
        	//fra variables
        	var itemToUpdate =  component.get("v.itemToUpdate");
        	 
        	//_utils.debug("itemEditedFromCart "+itemEditedFromCart);
        	//_utils.debug("MARK VAR: "+"needConfig" +needConfig+",itemToConfigure "+itemToConfigure+", itemid "+itemId+", isCloseConf "+isCloseConf);
        	        	
        	//recalculate the itemToConfigureID, in some cases it needs to be refreshed
        	if(itemToConfigure != null){
        		openDetailsBtnId = itemToConfigure.id + '_showDetails';
        	}
        	     	
        	//only copy this {if/else} if you manage the quantity
        	if(itemEditedFromCart && !qtyEdit){
        	
        		if(!noUpdateCart){
        			helper.updateCartList(component);
        			component.set("v.noUpdateCartAfterRemoveFake",false);
        		}
        		component.set('v.spinner',false);
        		component.set("v.itemEditedFromCart",false);
        	}
        	else if(itemEditedFromCart && qtyEdit){
        		
        		component.set("v.qtyEdit",false);
        		
        	}
        	//i wont tell you what this do, find out! don't you like an adventure?
        	else if(itemEditedFromCart && itemToUpdate != null ){
        		
	        	//_utils.debug("itemToUpdate has been changed!");
				//_utils.debug("coreOutput item updated? " + JSON.stringify(coreOutput));
				component.set("v.itemToUpdate", null);
				component.set("v.itemEditedFromCart",false); 
				component.set("v.contextOutput", coreOutput);
				component.set("v.spinner", false);
        	}
        	else{
		        if(!needConfig){ //already called configure event on the item 
		        	
		        	if(itemAddedToCart){
		        				        		
		        	}
		        	else if(itemRemovedFromCart){
		        		
		        		
		        		
		        		//update parent of childToRemove
				         var updateParentAttributeMap = $A.get("e.c:OB_UpdateParentMapAttribute");
								updateParentAttributeMap.setParams({
									'IdItem': itemToConfigure.id,
								});										
						updateParentAttributeMap.fire();
						//END 			   
		        	
		        	
		        	
		        		helper.checkCatalogChanges(component, coreOutput);
		        		helper.updateCartList(component); //i believe this is needed
		        		window.setTimeout(
					    $A.getCallback(function() {
					       helper.hideDetailsSelectedCheckbox(component, event, openDetailsBtnId);
					    }), 350
					    )
		        		component.set('v.spinner',false);
		        	}
		        	
		        }else{//else needConfig is true
		           
		        	if(itemAddedToCart){
		        	
		        		
		        	
		        		if(isFirstAdd){
		        			//refresh
		        			if(!fakeAdd){
		        				helper.checkCatalogChanges(component, coreOutput);
		        			}
		        			component.set("v.oldItemId",itemToConfigure.id);

		        		 	//merge of the upper section
		        			helper.updateCartList(component); //** NEW
		        			//end of everything for a first add
		        			
		        			//if first add
		        			//timeout
				    		window.setTimeout(
						    $A.getCallback(function() {
						       helper.showDetailsSelectedCheckbox(component, event, openDetailsBtnId);
						    }), 350
						    )
		        			//------------
		        			component.set("v.fakeAdd",false);
		        			component.set("v.isFirstAdd",false);
		        			component.set('v.spinner',false);		
		        		}
		        		else{
		        		   //if its show detail called before this we search the cart before adding  
			              var cartChildItems = coreOutput.cart;
			              var item;
			              for(var i=0; i<coreOutput.cart.length;i++){
			                item = cartChildItems[i];
			                if(item.id == itemId){
			                	
				                component.set("v.itemToConfigure",item);
				                found = true;
				                //need to call an event to get out
				                itemToConfigure = component.get("v.itemToConfigure");
				                
				                //refresh
			        			if(!fakeAdd){
			        				helper.checkCatalogChanges(component, coreOutput);
			        				component.set("v.oldItemId",itemToConfigure.id);
			        			}
			        			
				                break;
			                }
			              }          		  
		        		  //try to get the item from the correct offertChildList
		        		  //need to get the list again after the conf. closed in this step so it
		        		  //gets refreshed
		        		  if(!found){
			                  var item;
	        
			                  component.set("v.offertChildList", coreOutput.listOfItems);
			                  var offertChildList = component.get("v.offertChildList");
			                  
			        		  for(var i=0;i<offertChildList.length;i++){
				                item = offertChildList[i];
				                //itemNameToCompare = offertChildList[i].fields.productname;
					                if(item.id == itemId){
					                	component.set("v.itemToConfigure",item);
					                	break;
								     }  
				            	}   
				            	if(fakeAdd){
				            		item.fields.qty = maxQty;
				            	}
				            	else{
				            		item.fields.qty = 1;
				            	}
				            	//item.fields.hiddenincart = 'false'; 
					         }
					         //_utils.debug(component.get("v.oldItemId")+' == '+itemId);
					         if(component.get("v.oldItemId") != itemId)
					         {
					         
			        			//refresh
			        			if(!fakeAdd)
			        			{
			        				helper.checkCatalogChanges(component, coreOutput);
			        			}
					         }
					         else{
					        	 if(itemToConfigure.fields.qty == maxQty && !fakeAdd){
		        					
		        					var userQty = 1;
	
	        						itemToConfigure.fields.qty = userQty;
		        					itemToConfigure.fields.qtyToManage = userQty;
		        					
				        			var updateChildEvent = $A.get("e.NE:Bit2win_Event_ApplyPenalty");
						            updateChildEvent.setParams({
						                "item": 	itemToConfigure,
						                "action" 	: 	'changeQty'
						            });
						            updateChildEvent.fire();
						            fakeToTrue = true;
						            
						            component.set("v.itemEditedFromCart",true);
						            component.set("v.qtyEdit",true);           
					        	}
			        		}
			        				
			        		if(qtyEditAfterFakeAdd){
			        			//_utils.debug("SPINNER OFF");
			        			component.set('v.spinner',false);
			        		}  		

					        //--------	
				        	if(!fakeAdd){
				        		window.setTimeout(
							    $A.getCallback(function() {
							       helper.showDetailsSelectedCheckbox(component, event, openDetailsBtnId);
							    }), 350
				        		)
				        	}
		        			//--------
		        			
		        			//hide previous element details
		        			
		        			openDetailsBtnId = component.get("v.oldItemId");
		        			openDetailsBtnId = openDetailsBtnId+"_showDetails";
		        			//check if newItem and oldItem are the same if they are DONT hide
		        			
		        			if(component.get("v.oldItemId") != itemId){
		        			 
		        				if( !($A.util.isEmpty(component.get("v.oldItemId")))){
		        					//_utils.debug("oldItemId "+component.get("v.oldItemId"));
								    helper.hideDetailsSelectedCheckbox(component, event, openDetailsBtnId);
		        					
			        				//HERE! we need to remove and hope in Bit2Win GODS nothing dies
			        				var item;
			        				var cartChildItems = coreOutput.cart;
			        				var oldItemId = component.get("v.oldItemId");
			        				for(var i=0; i<coreOutput.cart.length;i++){
						               item = cartChildItems[i];
						               //_utils.debug("item.id "+item.id +" oldItemId "+ oldItemId);
						                if(item.id == oldItemId && item.fields.qty == maxQty){
						                			        				
					        				var configureAppEvent 	= 	$A.get("e.NE:Bit2win_Event_AddRemoveFromCart");
								            configureAppEvent.setParams({
									                'item'	: 	item,
									                'action' : 	'remove',
									            });
								            configureAppEvent.fire();
								            if(qtyEdit){
								            	component.set("v.noUpdateCartAfterRemoveFake",true);
								            	if(component.get('v.spinner') == false){
								            		component.set('v.spinner') = true;
								            	}
								            }	
								            component.set("v.itemEditedFromCart",true);
								            
								            break;
						                  }
						                  else{
						                	  //same item but not a fake add? 
						                  }					 
						             }
			        				//END of Prayers
			        			}	
		        			}
		        			if(!qtyEdit){
		        				helper.updateCartList(component); //NEW***
		        				component.set('v.spinner',false);
		        			}
		        			else
		        			{
		        				component.set("v.qtyEditAfterFakeAdd",true);
		        			}
		        			//after the old one is closed set the oldItemId on the current one
		        			component.set("v.oldItemId",itemId);
		        			
		        			//end of everything 
				        	component.set("v.fakeAdd",false);
				        	
				        	        	  	
				        }
		        	}
		        	else if(itemRemovedFromCart){ 
		        			component.set("v.needConfiguration", false);
		          }               
		        }
        	}
       }// END ELSE IF
    },
    
    onCheck: function(component,event,helper){
    
    	var checkAttributeRules = component.get('v.checkAttributeRules');
    	var contextOutput = component.get('v.contextOutput');
        var selectedBundleId='';
        var isFirstAdd = component.get('v.isFirstAdd');
        //var numOfCheckedItems = component.get('v.numOfCheckedItems');
        var maxQty = component.get("v.qtyMax");
        //'error' blocks every action for this function
        if(checkAttributeRules != 'error'){
	        //_utils.debug("contextOutput.listOfItems: " + JSON.stringify(contextOutput.listOfItems));
	        //francesca.ribezzi 06/09/2018 setting  offertChildList as listOfItems.
	        component.set("v.offertChildList", contextOutput.listOfItems);
	        
	        component.set("v.qtyEdit",false);
	        component.set("v.isCloseConf",false);
	        component.set("v.qtyEditAfterFakeAdd",false);
	           
	        component.set("v.spinner", true);
	        var itemId = event.getSource().get("v.id");
	        var itemQty = 1;
	        var chkBoxVal = event.getSource().get("v.checked");
	        //var nameTest = event.getSource().get("v.name");
	        var item;
	        //var itemNameToCompare;
	
	        var offertChildList = component.get('v.offertChildList');
	        
	        //var openDetailsBtnId = itemId + '_showDetails' ;
	        
	        if(chkBoxVal){
	            //numOfCheckedItems++;      	
	            var itemQty = 1;
	            
	            for(var i=0;i<offertChildList.length;i++)
	            {
	                item = offertChildList[i];
		            if(item.id == itemId)
		            {
		            	break;
		            }  
	            }   
	            item.fields.qty = itemQty;
	            
	          
					 var cartChildItems = contextOutput.cart;
		             var itemToCheck;
		             for(var i=0; i<contextOutput.cart.length;i++){
		                itemToCheck = cartChildItems[i];
		                if(itemToCheck.id == itemId){
		                	component.set("v.itemToConfigure",itemToCheck);
				            found = true;
				            break;
			            }
			         }     
					 //NEXI-258 Grzegorz Banach <grzegorz.banach@accenture.com> 05/08/2019 START
					 if(itemToCheck.fields.qty == maxQty && itemToCheck != null && itemToCheck.fields.id == itemId){
                        //NEXI-258 Grzegorz Banach <grzegorz.banach@accenture.com> 05/08/2019 STOP
						var userQty = 1;
		
						itemToCheck.fields.qty = userQty;
    					itemToCheck.fields.qtyToManage = userQty;
						
	        			var updateChildEvent = $A.get("e.NE:Bit2win_Event_ApplyPenalty");
			            updateChildEvent.setParams({
			                "item": 	itemToCheck,
			                "action" 	: 	'changeQty'
			            });
			            updateChildEvent.fire();
			            
			            component.set("v.itemEditedFromCart",true);
			            component.set("v.qtyEdit",true);           
					}
					else{
					
					
					var updateChildEvent 	= 	$A.get("e.NE:Bit2win_Event_AddRemoveFromCart");
		            updateChildEvent.setParams({
		                "item": item,
					    //"mapOfItems": ,
					    //"catalogId": "a0K0Y000005YtIVUA0",
					    "action": "add",
					    //"categoryId": "a0G0Y000002I4l7UAC",
					    "typeOfAdd": "singleAdd"
		            });
		
		            updateChildEvent.fire();
		                 
		            //need to save the attribute of the id to have as a reference for the later cycle
		            component.set("v.itemToConfigure",item);
		            component.set("v.newItemId",itemId);
		            //we are in POS cmp so we always make the item added set to be configured
		            component.set("v.fakeAdd",false);	 
		            component.set("v.needConfiguration",true);
		            
		            //reset flags
		            component.set('v.itemAddedToCart',true);
		            component.set('v.itemRemovedFromCart',false);
		            //******************
		            }	            
	           // }
	                      
	            /* ==== random view selection css stuff ->IGNORE<- ==== */
	            var productRow = document.getElementById(itemId+'_prdRow');
	            var itemInfo = document.getElementById(itemId+'_infoColor');
	            productRow.classList.add("product_row_color");
	            itemInfo.classList.add("product_row_color");
	            //add class
	            //document.getElementById(itemId+'_qty').classList.add("black");
	            /* =====================================================*/
	        }
	        else{  //chkBoxVal is false a.k.a. i'm removing
	        	//numOfCheckedItems--;
	        	//check quantity to remove any quantity left on the object
	        	//var itemQty = parseInt(document.getElementById(itemId+'_qty').value);
	            //document.getElementById(itemId+'_qty').value = 0;
	            
	            //getting specific item props by cycling the cart  
	            var cartChildItems = contextOutput.cart;
	            for(var i=0; i<contextOutput.cart.length;i++){
	                item = cartChildItems[i];
	                if(item.id == itemId) break;
	            }

	             //update parent of childToRemove
		         var updateParentAttributeMap = $A.get("e.c:OB_UpdateParentMapAttribute");
						updateParentAttributeMap.setParams({
							'IdItem': item.id,
						});										
				updateParentAttributeMap.fire();
				//END 			   
	            
	            
	            //if not we need to close the previous configuration THEN remove
	            /* 
	            var closeConfEvent 	= 	$A.get("e.NE:Bit2Win_Event_ResetSaveConfiguration");
		            closeConfEvent.setParams({
		
					    "CartService_Output": contextOutput,
					    "type": "save"
		            });
	
		        closeConfEvent.fire();
				*/
				var configureAppEvent 	= 	$A.get("e.NE:Bit2win_Event_AddRemoveFromCart");
			            configureAppEvent.setParams({
				                'item'	: 	item,
				                'action' : 	'remove',
				            });
			            configureAppEvent.fire();	             
		       
		                   
	            //setting the item in the attribute for future reference to remove
	            component.set("v.itemToConfigure",item);
	            component.set("v.needConfiguration", false);
	            //set flags
	            component.set('v.itemAddedToCart',false);
	            component.set('v.itemRemovedFromCart',true);
	            //****************
	
	            /* ==== random view selection css stuff ->IGNORE<- ==== */ 
	            var productRow = document.getElementById(itemId+'_prdRow');           
	            var itemInfo = document.getElementById(itemId+'_infoColor');
	            productRow.classList.remove("product_row_color");
	            itemInfo.classList.remove("product_row_color");
	            //remove class
	            //document.getElementById(itemId+'_qty').classList.remove("black");
	            /* =====================================================*/
	        }
	        
	        /*
	        if(component.get("v.isCheckNextRequired") == true){
		        if(numOfCheckedItems == 0 || numOfCheckedItems < component.get("v.bundleMinQty")){
		        	// firing updateContextEvent event to parent OB_FlowCart. 
		        	//if there are no items checked, disable next button. Otherwise, enable it.
					//START EVENT 
					var updateContextEvent = $A.get("e.c:OB_CustomUpdateContextEvent");
					updateContextEvent.setParams({ "disabledNextBtn": true});
		        	updateContextEvent.fire();
		        	//_utils.debug("firing event to OB_FlowCart cmp to disable next button..");
		        	//END event 
		        }else if(numOfCheckedItems >= component.get("v.bundleMinQty")){
		             // firing updateContextEvent event to parent OB_FlowCart. 
					//START EVENT 
					var updateContextEvent = $A.get("e.c:OB_CustomUpdateContextEvent");
					updateContextEvent.setParams({ "disabledNextBtn": false});
		        	updateContextEvent.fire();
		        	//_utils.debug("firing event to OB_FlowCart cmp to enable next button..");
		        	//END event 
		        }    
		    }   
		    component.set('v.numOfCheckedItems',numOfCheckedItems);
			*/
		}//end if checkAttributeRules != error
    },
    
    showDetails: function(component,event,helper){
        var selectedElement = event.currentTarget;
        var isFirstAdd = component.get('v.isFirstAdd');
        var contextOutput = component.get('v.contextOutput');
        var checkAttributeRules = component.get("v.checkAttributeRules");
        //'error' blocks every action for this function
	    if(checkAttributeRules != 'error'){
	        //francesca.ribezzi 06/09/2018 setting offertChildList as listOfItems.
	        //wonder if i had to set it everytime??? Nd marco.ferri
	        component.set("v.offertChildList", contextOutput.listOfItems);
	        
	        var offertChildList = component.get('v.offertChildList');
	        
	        component.set("v.qtyEdit",false);
	        component.set("v.isCloseConf",false);
	        component.set("v.qtyEditAfterFakeAdd",false);   
	        component.set("v.spinner", true);
	        
	        /* GRAPHIC STUFF -- do later? */
	        var item;
	        var itemId = selectedElement.getAttribute('data-item');
	        //_utils.debug("showDetails itemId: " + itemId);
	        var itemShowDetails = document.getElementById(itemId+'_showDetails');
	        var itemHideDetails = document.getElementById(itemId+'_hideDetails');
	        var itemInfo = document.getElementById(itemId+'_info');
	        itemShowDetails.classList.add("hidden");
	        itemHideDetails.classList.remove("hidden");
	        itemInfo.classList.remove("hidden");
	        /* ========================== */
	       
	        //searching cart first
	        if(!isFirstAdd){
	        	
	        	var found = false;
	        	var oldItemId = component.get("v.oldItemId");
	        	
	        	
		        for(var j=0; j<contextOutput.cart.length; j++)
		        {    
		        	if(contextOutput.cart[j].id==itemId)
	                { 	
		        		found = true;
		        		
		        		if(itemId == oldItemId && oldItemId != undefined){
		        			
		        			var openDetailsBtnId = oldItemId+"_showDetails";
				            helper.showDetailsSelectedCheckbox(component, event, openDetailsBtnId);
				            component.set("v.itemToConfigure",contextOutput.cart[j]);
						    component.set("v.spinner", false);
							
		        		}
		        		else{
		        			component.set("v.itemToConfigure",contextOutput.cart[j]);
		        			helper.updateCartList(component);
							//end --load the items
								
							var openDetailsBtnId = oldItemId+"_showDetails";
				            helper.hideDetailsSelectedCheckbox(component, event, openDetailsBtnId);
				            
				            component.set("v.oldItemId",itemId);
						    component.set("v.spinner", false);
		        		
			            /*
			            component.set("v.needConfiguration",false);   
			            component.set("v.itemAddedToCart",true);
			            component.set("v.itemRemovedToCart",false); 
						*/
			            //*****
			            
			           break;
			        }    
		        }
		        }//END FOR
		        //if its not first add and not found in the cart repeat same as not first add and not in the cart
		        if(!found){
		        	
		        	for(var i=0;i<offertChildList.length;i++){
	                item = offertChildList[i];
		                if(item.id == itemId){
		                	break;
		                }  
	            	}   
	            	//set a fake quantity to understand the fake add
	            	item.fields.qty = component.get("v.qtyMax");
		        		
		        		/*
		        		var closeConfEvent 	= 	$A.get("e.NE:Bit2Win_Event_ResetSaveConfiguration");
			            closeConfEvent.setParams({
						    "CartService_Output": contextOutput,
						    "type": "save"
			            });
			            closeConfEvent.fire();
						*/
						 var updateChildEvent 	= 	$A.get("e.NE:Bit2win_Event_AddRemoveFromCart");
			            updateChildEvent.setParams({
			                "item": item,
						    //"mapOfItems": ,
						    //"catalogId": "a0K0Y000005YtIVUA0",
						    "action": "add",
						    //"categoryId": "a0G0Y000002I4l7UAC",
						    "typeOfAdd": "singleAdd"
			            });
			
			            updateChildEvent.fire();
			            		            
			             //need to save the attribute of the id to have as a reference for the later cycle
			            //Nd Marco.Ferri
			            component.set("v.newItemId",itemId);	           
		              
			            //we are in VAS cmp so we always make the item added set to be configured            
			            component.set("v.needConfiguration",true);
		            
			            //reset flags
			            component.set('v.itemAddedToCart',true);
			            component.set('v.itemRemovedFromCart',false);
			            //******************
		            
			            //we set the fake add cause the item is not in the cart already
			            component.set("v.fakeAdd",true);
		        }
		    }
		    //item is not in the cart so we need to add it in a fake way
		    // can be first add
		    else{
		    
	    		for(var i=0;i<offertChildList.length;i++){
	                item = offertChildList[i];
		                if(item.id == itemId){
		                	break;
		                }  
	            	}   
	            	//set a fake quantity to understand the fake add
	            	item.fields.qty = component.get("v.qtyMax");
		        
		        if(isFirstAdd){
		            
		            	//getting specific item props by cycling the whole bundleItem list and setting the quantity
		            	//only on first add, get the item after the update context on the 2nd add!
		            		
			           //if this is the first element we add it immediatly 
			            var updateChildEvent 	= 	$A.get("e.NE:Bit2win_Event_AddRemoveFromCart");
			            updateChildEvent.setParams({
			                "item": item,
						    //"mapOfItems": ,
						    //"catalogId": "a0K0Y000005YtIVUA0",
						    "action": "add",
						    //"categoryId": "a0G0Y000002I4l7UAC",
						    "typeOfAdd": "singleAdd"
			            });
			
			            updateChildEvent.fire();
			            //can configure the item immediatly 
			            component.set("v.itemToConfigure",item);
			           
		            }
		            else{
		            	//if not we need to close the previous configuration THEN add
		            	
		             var updateChildEvent 	= 	$A.get("e.NE:Bit2win_Event_AddRemoveFromCart");
			            updateChildEvent.setParams({
			                "item": item,
						    //"mapOfItems": ,
						    //"catalogId": "a0K0Y000005YtIVUA0",
						    "action": "add",
						    //"categoryId": "a0G0Y000002I4l7UAC",
						    "typeOfAdd": "singleAdd"
			            });
			            updateChildEvent.fire();
			            
			            component.set("v.itemToConfigure",item);
			             	
			            //need to save the attribute of the id to have as a reference for the later cycle
			            //Nd Marco.Ferri
			            component.set("v.newItemId",itemId);	           
		            }
		              
		            //we are in POS cmp so we always make the item added set to be configured            
		            component.set("v.needConfiguration",true);
		            
		            //reset flags
		            component.set('v.itemAddedToCart',true);
		            component.set('v.itemRemovedFromCart',false);
		            //******************
		            
		            //we set the fake add cause the item is not in the cart already
		            component.set("v.fakeAdd",true);
	        }
	    }//end if checkAttributeRules != error
     },    
     
     hideDetails: function(component,event,helper){
      	var contextOutput = component.get('v.contextOutput');
    	var isFirstAdd = component.get('v.isFirstAdd');
    	 	
        var selectedElement = event.currentTarget;
        var itemId = selectedElement.getAttribute('data-item');
        var itemShowDetails = document.getElementById(itemId+'_showDetails');
        var itemHideDetails = document.getElementById(itemId+'_hideDetails');
        var itemInfo = document.getElementById(itemId+'_info');
        var checkAttributeRules = component.get('v.checkAttributeRules');
        var maxQty = component.get("v.qtyMax");
        
        //'error' blocks every action in this function:   	
        if(checkAttributeRules != 'error'){   	
	        component.set("v.qtyEdit",false);	        
	        component.set("v.spinner", true);
	        
	        /* GRAPHIC STUFF */
	        itemShowDetails.classList.remove("hidden");
	        itemHideDetails.classList.add("hidden");
	        itemInfo.classList.add("hidden");
	        /* ============ */
	        
	        
	        
	        //same logic of remove 
	        
	        //check if item is in cart already 
	        if(!isFirstAdd){ 
		        for(var j=0; j<contextOutput.cart.length; j++)
		        {
		        	//found the item in the cart so i remove
		        	if(contextOutput.cart[j].id==itemId)
	                { 	
		            	//set some flags
			            if(contextOutput.cart[j].fields.qty == maxQty){ 
				            var configureAppEvent 	= 	$A.get("e.NE:Bit2win_Event_AddRemoveFromCart");
				            configureAppEvent.setParams({
					                'item'	: 	contextOutput.cart[j],
					                'action' : 	'remove',
					            });
				            configureAppEvent.fire();	  
				            
				            //setting the item in the attribute for future reference to remove
				            component.set("v.itemToConfigure",contextOutput.cart[j]);
				            component.set("v.needConfiguration",false);
				            //set flags
				            component.set('v.itemAddedToCart',false);
				            component.set('v.itemRemovedFromCart',true);
				            //****************
			            }
				        else{
				        	component.set("v.oldItemId",itemId);
				        	component.set("v.spinner", false);	 
				        }
				        break;
			        }
			    }//END FOR in the cart
			    
	        }//END NOT FIRST ADD
	        else{            
	            //document.getElementById(itemId+'_qty').value = 0;
	            
	            //getting specific item props by cycling the cart
	            var item;  
	            var cartChildItems = contextOutput.cart;
	            for(var i=0; i<contextOutput.cart.length;i++){
	                item = cartChildItems[i];
	                if(item.id == itemId){
	                	//set item to old
	                	component.set("v.oldItemId",itemId);
	                	component.set("v.spinner", false);
	                	break;
	                } 
		        }//END for  
		        
		           
	            if(item != null){
	            	 if(item.fields.qty == maxQty){
	            	 
		            	var configureAppEvent = $A.get("e.NE:Bit2win_Event_AddRemoveFromCart");
			            configureAppEvent.setParams({
				                'item'	: 	item,
				                'action' : 	'remove',
				        });
			            configureAppEvent.fire();	  
	            	 
			            //setting the item in the attribute for future reference to remove
			            component.set("v.itemToConfigure",item);
			            component.set("v.needConfiguration",false);
			            //set flags
			            component.set('v.itemAddedToCart',false);
			            component.set('v.itemRemovedFromCart',true);
			            //****************
		            }              
	            }
	           
	        }
	    }//end if checkAttributeRules 
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
			   
			   component.set("v.itemEditedFromCart",true);
			   component.set("v.itemToUpdate", itemToUpdate);
			   component.set("v.spinner", true);
    },
})