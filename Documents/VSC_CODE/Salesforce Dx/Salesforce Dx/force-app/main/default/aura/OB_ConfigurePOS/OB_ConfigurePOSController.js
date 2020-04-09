({
    doInit : function(component, event, helper)
    {
		/* ANDREA MORITTU START 2019.05.07 - ID_Stream_6_Subentro */
		helper.doInitHelper(component, event, helper);
		/* ANDREA MORITTU END 2019.05.07 - ID_Stream_6_Subentro */
    	//_utils.debug('init configure pos');  
    },

    //LUBRANO 16/01/2019 Libreria Log
	logInit: function(component){
		_utils.logInit(component.getName());
	},
		
    onUpdateContext : function(component, event, helper)
		{
        _utils.debug('Inside onUpdateContext for newCartConfiguration');
        var doCheckout=component.get('v.requestCheckout');
        var objectDataMap = component.get("v.objectDataMap");
        var itemAddedToCart = component.get('v.itemAddedToCart');
        var itemRemovedFromCart = component.get('v.itemRemovedFromCart');
        var itemEditedFromCart = component.get("v.itemEditedFromCart");
        var validItems=[], validBundles=[], productCategories = [], stepOneCategories = [];
        var category,bundle,listOfCategories,listOfBundles;
        var offertaId = objectDataMap.unbind.offertaId;

        var coreOutput = event.getParam("CartService_Output");

		if(component.get('v.offertaAddedToCart')== false &&!(offertaId== '' || offertaId == null || offertaId ==undefined))
        {
			//INITIAL CONFIGURATION SETTING THE OFFER ID TO THE ENGINE TO PROCESS -- Marco.Ferri
        
			// set contextOutput
			component.set('v.contextOutput',coreOutput);
			//francesca.ribezzi firing updateContextEvent event to parent OB_FlowCart
			//START EVENT 
			var updateContextEvent = $A.get("e.c:OB_CustomUpdateContextEvent");
			updateContextEvent.setParams({ contesto: coreOutput});
        	updateContextEvent.fire();
        	//END event 
			var item;
			//only in this case -- CHECK FOR DISABLED NEXT
			var bundleStepForRule = component.get("v.bundleStep");
			var bundleSelectedRule;
			for(var i in coreOutput.listOfBundles)
				{
					if(coreOutput.listOfBundles[i].id==offertaId){
						bundleSelectedRule = coreOutput.listOfBundles[i];
					break;
				}
			}
			//check minQty for bundElement Step -- change this control!
            if(bundleSelectedRule.bundleElements[bundleStepForRule].fields.minqty >= 1){
            	document.getElementById("nextBtnId").disabled = true;
            	component.set("v.isCheckNextRequired",true);
            }
            else{
            	document.getElementById("nextBtnId").disabled = false;
            	component.set("v.isCheckNextRequired",false);
		}
		
            component.set("v.bundleMinQty",bundleSelectedRule.bundleElements[bundleStepForRule].fields.minqty);
            //--END
		
            //check maxqty for bundElement Step
            var bundleMaxQty = bundleSelectedRule.bundleElements[bundleStepForRule].fields.maxqty;
            //_utils.debug("bundleMaxQty"+ bundleMaxQty);
            component.set("v.bundleMaxQty",bundleMaxQty);
		
			//check if offerta already in the cart
			if(coreOutput.cart.length > 0 ){                
				for(var i in coreOutput.cart)
				{
					if(coreOutput.cart[i].fields.categoryname == 'bundleItem'){
						_utils.debug("offer already in the cart??: " + offertaId);
						_utils.debug("offer in cart " + coreOutput.cart[i]);
						component.set('v.offertaId',offertaId);
						component.set('v.offertaAddedToCart',true);
						item = coreOutput.cart[i];
					break;
				}
			}
		}
			if(component.get("v.offertaAddedToCart") == false){
				var mapOfItems = [];
				var vid,qty;
					
						
				for(var i in coreOutput.listOfBundles)
					   {
					if(coreOutput.listOfBundles[i].id==offertaId){
						item = coreOutput.listOfBundles[i];
						break;
					}	
								}  
							}
				// to do, add check if objecttype == bundle or item                
				var configureAppEvent 	= 	$A.get("e.NE:Bit2win_Event_ConfigureBundle");
				configureAppEvent.setParams({
					'bundleItem'	: 	item     
				});
								
				component.set('v.offertaAddedToCart',true); 
				//_utils.debug('FIRE EVENT __Bit2win_Event_ConfigureBundle');
	            configureAppEvent.fire();
	            component.set('v.offertaId',offertaId);
								//}
	        //i'm in an order with an offer already in the cart
								//else{
	        	var bundId	= component.get('v.offertaId');		
								  
	            var selectedBundleId='';
	            for(var i in coreOutput.listOfBundles)
	            {
	            	//_utils.debug(bundId+" == "+coreOutput.listOfBundles[i].id );
	                if(bundId == coreOutput.listOfBundles[i].id)
	                {
	                	//_utils.debug('list of bundle after add to cart of first bundle element has same id');
	                    selectedBundleId=  coreOutput.listOfBundles[i].bundleElements[0]; 
	                    component.set('v.bundleElementName',coreOutput.listOfBundles[i].bundleElements[0].fields.name);
	                    //NEW --get the selectedBundleElement so we can refresh min qty and max qty
	                    component.set("v.selectedBundle",i);
	                    break;
							}
							}
					//_utils.debug('___ selected id  ', selectedBundleId); 
					//01/03/19 francesca.ribezzi calling configure bundle here instead of bundleElements event:
	              /*   var configureBundle 	= 	$A.get("e.NE:Bit2win_Event_BundleElements");   
							
					configureBundle.setParams({
					'BundleElement'	: 	selectedBundleId
							});
	            	//_utils.debug('FIRE EVENT __Bit2win_Event_BundleElements');
	              	configureBundle.fire();
							
	            component.set('v.configureBundle',true);*/
							
	      //  }
	        component.set('v.contextOutput',coreOutput);   
			} 

		else if(component.get('v.offertaAddedToCart')== true && component.get('v.configureBundle')==false )
		{
			//Bit2Win Magic? open configuration of bundle -- Marco.Ferri
			 
			// set contextOutput
			component.set('v.contextOutput',coreOutput);		
			//francesca.ribezzi firing updateContextEvent event to parent OB_FlowCart
			//START EVENT 
			var updateContextEvent = $A.get("e.c:OB_CustomUpdateContextEvent");
			updateContextEvent.setParams({ contesto: coreOutput});
        	updateContextEvent.fire();
        	//END event 
			
        	//check if for some reason we didnt had the bundle in the cart yet
        	if(coreOutput.cart.length <= 0){
        	var configureAppEvent 	= 	$A.get("e.NE:Bit2win_Event_ConfigureBundle");
		
				var mapOfItems = [];
				var vid,qty;
				var item;
				//01/03/19 francesca.ribezzi commentato:
				for(var i in coreOutput.listOfBundles)
				{
					if(coreOutput.listOfBundles[i].id==offertaId){
						item = coreOutput.listOfBundles[i];
						break;
					}	
				}
				configureAppEvent.setParams({
					'bundleItem'	: 	item     
		});
		
				/*configureAppEvent.setParams({
					'bundleItem'	: 	context.     
				});*/
			
				
				
				//component.set('v.offertaAddedToCart',true);
				//_utils.debug('FIRE EVENT __Bit2win_Event_ConfigureBundle');
	            configureAppEvent.fire();
	            component.set('v.offertaId',offertaId);
				}
	        //-------------------------------------------------------    
				
			//_utils.debug('updateContext after add bundle');
            var bundId	= component.get('v.offertaId');		 
			//_utils.debug(JSON.stringify(coreOutput));
				
            var selectedBundleId='';
            for(var i in coreOutput.listOfBundles)
            {
                if(bundId == coreOutput.listOfBundles[i].id)
				{	 
                	//_utils.debug('list of bundle after add to cart of first bundle element has same id');
                    selectedBundleId=  coreOutput.listOfBundles[i].bundleElements[0]; 
                    component.set('v.bundleElementName',coreOutput.listOfBundles[i].bundleElements[0].fields.name);
                    //NEW --get the selectedBundleElement so we can refresh min qty and max qty
	                component.set("v.selectedBundle",i);
                    break;
					}
				}
			//_utils.debug('___ selected id  ',selectedBundleId);
             var configureBundle 	= 	$A.get("e.NE:Bit2win_Event_BundleElements");   
				
			configureBundle.setParams({
			'BundleElement'	: 	selectedBundleId
				});
        	//_utils.debug('FIRE EVENT __Bit2win_Event_BundleElements');
          	configureBundle.fire(); 
            component.set('v.configureBundle',true);
            //component.set('v.bundleStep',1);
		}
		else if(component.get('v.offertaAddedToCart')== true && component.get('v.configureBundle')==true && !doCheckout && !(itemAddedToCart || itemRemovedFromCart || itemEditedFromCart))
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
			helper.showBundleElement(component,coreOutput);
				
			component.set('v.spinner',false);
				
				}
					
        else if(itemAddedToCart || itemRemovedFromCart || itemEditedFromCart ){
		
        	//set contextOutput
			component.set('v.contextOutput',coreOutput);
		
			//START EVENT  francesca.ribezzi firing updateContextEvent event to parent OB_FlowCart
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
				
		
		
        	//_utils.debug("newItemId" +itemId);
        	//_utils.debug("oldItemId "+component.get("v.oldItemId"));
	
        	var itemToUpdate =  component.get("v.itemToUpdate");
		
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
        		//_utils.debug("SPINNER OFF");
        		component.set('v.spinner',false);
        		component.set("v.itemEditedFromCart",false); 			
		}
        	else if(itemEditedFromCart && qtyEdit){
   
        		component.set("v.qtyEdit",false);

        	}
        	else if(itemEditedFromCart && itemToUpdate != null ){
				
	        	_utils.debug("itemToUpdate has been changed!");
				//_utils.debug("coreOutput item updated? " + JSON.stringify(coreOutput));
				component.set("v.itemToUpdate", null);
				component.set("v.itemEditedFromCart",false); 
				component.set("v.contextOutput", coreOutput);
				component.set("v.spinner", false);
			}
        	//manage this when its 2nd conf active
        	else{
		        if(!needConfig){ //already called configure event on the item 
				
		        	if(itemAddedToCart){
			
		        	}	
		        	else if(itemRemovedFromCart){
				
		        		//_utils.debug("listOfCartTotal", listOfCart);
				
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
						/**
						 * giovanni spinelli 19/09/2019
						 * if is reset is true, add the pos deleted just before
						 */
						var isreset = component.get('v.isReset');
		        		if(isreset==true){
		        			helper.addItemReset(component);
						}
						//giovanni spinelli 19/09/2019
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
		
		        		  var found = false;  
		        		  //if its show detail called before this we search the cart before adding  
			              var cartChildItems = coreOutput.cart;
			              var item;
			              for(var i=0; i<coreOutput.cart.length;i++){
			                item = cartChildItems[i];
			                if(item.id == itemId && item.fields.status == undefined){
		
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
				            		item.fields.qty = parseInt(document.getElementById(itemId+'_qty').value);
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
				
		        					var userQty = document.getElementById(itemToConfigure.id+'_qty').value;
				
		        					if(userQty == 0){
			        					itemToConfigure.fields.qty = 1;
			        					itemToConfigure.fields.qtyToManage = 1;
			}
		        					else{
		        						itemToConfigure.fields.qty = userQty;
			        					itemToConfigure.fields.qtyToManage = userQty;
		}
		
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
						                if(item.id == oldItemId && item.fields.qty == maxQty && item.fields.status == undefined){
					
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
		
				        }//end not first add
			    
    	  } 
		        	else if(itemRemovedFromCart){
		
		        		component.set("v.needConfiguration", false);
			}
			}
	        }// END ELSE IF
		}
    },
    
    
		
    //Marco.Ferri MASSIVE rework of the whole logic + add of comments 12.09.2018
    //p.s: this code is a mess!!!! 
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
			_utils.debug("itemId"+itemId);
			_utils.debug("itemId_qty ",document.getElementById(itemId+'_qty'));
			_utils.debug("itemId_qty value "+document.getElementById(itemId+'_qty').value);
	        var itemQty = parseInt(document.getElementById(itemId+'_qty').value);
	        var chkBoxVal = event.getSource().get("v.checked");
			//var nameTest = event.getSource().get("v.name");
	        var item;
	        //var itemNameToCompare;
	
	        var offertChildList = component.get('v.offertChildList');
	        
	        //var openDetailsBtnId = itemId + '_showDetails' ;
	        
	        if(chkBoxVal){
	            //numOfCheckedItems++;      	
	            var itemQty = parseInt(document.getElementById(itemId+'_qty').value);
	            if(itemQty == 0){
	            	//add class
	            	document.getElementById(itemId+'_qty').classList.add("black");
	                document.getElementById(itemId+'_qty').value = 1;
	            }
	            
	            for(var i=0;i<offertChildList.length;i++)
	            {
	                item = offertChildList[i];
		            if(item.id == itemId)
		            {
		            	break;
		            }  
	            }   
	            item.fields.qty = itemQty;
	            
	            /*
	            if(isFirstAdd){
	            
	            	//getting specific item props by cycling the whole bundleItem list and setting the quantity
	            	//only on first add, get the item after the update context on the 2nd add!
	            	
	            	//item.fields.hiddenincart = 'false';
	            
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
		            component.set("v.itemToConfigure",item);
	            }
				*/
	           // else{
	             
	            	//if not we need to close the previous configuration THEN add
	            	/*
	            	var closeConfEvent 	= 	$A.get("e.NE:Bit2Win_Event_ResetSaveConfiguration");
		            closeConfEvent.setParams({
		
					    "CartService_Output": contextOutput,
					    "type": "save"
		            });
	
		            closeConfEvent.fire();
					*/
					 var cartChildItems = contextOutput.cart;
		             var itemToCheck;
		             for(var i=0; i<contextOutput.cart.length;i++){
		                itemToCheck = cartChildItems[i];
		                if(itemToCheck.id == itemId && itemToCheck.fields.status == undefined){
		                	component.set("v.itemToConfigure",itemToCheck);
				            found = true;
				            break;
			            }
			         }     
                     //NEXI-258 Grzegorz Banach <grzegorz.banach@accenture.com> 06/08/2019 START
					 if(itemToCheck.fields.qty == maxQty && itemToCheck != null && itemToCheck.fields.id == itemId){
                        //NEXI-258 Grzegorz Banach <grzegorz.banach@accenture.com> 05/08/2019 STOP
						var userQty = document.getElementById(itemToCheck.id+'_qty').value;
						
						if(userQty == 0){
	    					itemToCheck.fields.qty = 1;
							itemToCheck.fields.qtyToManage = 1;
						}
						else{
							itemToCheck.fields.qty = userQty;
	    					itemToCheck.fields.qtyToManage = userQty;
						}
						
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
	            document.getElementById(itemId+'_qty').classList.add("black");
	            /* =====================================================*/
			}   
	        else{  //chkBoxVal is false a.k.a. i'm removing
	        	//numOfCheckedItems--;
				//check quantity to remove any quantity left on the object

	        	var itemQty = parseInt(document.getElementById(itemId+'_qty').value);
	            document.getElementById(itemId+'_qty').value = 0;
	            
	            //getting specific item props by cycling the cart  
	            var cartChildItems = contextOutput.cart;
	            for(var i=0; i<contextOutput.cart.length;i++){
	                item = cartChildItems[i];
	                if(item.id == itemId && item.fields.status == undefined) break;
	            }
	            
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
	            document.getElementById(itemId+'_qty').classList.remove("black");
	            /* =====================================================*/
	        }
	        
		}//end if checkAttributeRules != error
	},
    
   
    showDetails: function(component,event,helper){
        var selectedElement = event.currentTarget;
        var isFirstAdd = component.get('v.isFirstAdd');
    	var contextOutput = component.get('v.contextOutput');
		var checkAttributeRules = component.get("v.checkAttributeRules");
		// Doris D. 11/03/2019 ..... Start
		// BOOLEAN TO STOP THE MOUSEOVER WHEN DETAILS IS SHOWED 
		component.set('v.isShowDetail',false);
		// Doris D. 11/03/2019 ..... End 

		//'error' blocks every action for this function	
        if(checkAttributeRules != 'error'){
	        //francesca.ribezzi 06/09/2018 setting  offertChildList as listOfItems.
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
		        	//_utils.debug("contextOutput.cart",contextOutput.cart );
		        	//_utils.debug(contextOutput.cart[j].id+" == "+itemId);
		        	if(contextOutput.cart[j].id==itemId && contextOutput.cart[j].fields.status == undefined)
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
		              
			            //we are in POS cmp so we always make the item added set to be configured            
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
		// Doris D. 11/03/2019 ..... Start
		// BOOLEAN TO ACTIVE THE MOUSEOVER WHEN DETAILS IS HIDDEN 
		component.set('v.isShowDetail',true);
		// Doris D. 11/03/2019 ..... End 
        //'error' blocks every action in this function:   	
        if(checkAttributeRules != 'error'){   	
	        component.set("v.qtyEdit",false);	        
	        component.set("v.spinner", true);
	        
	        /* GRAPHIC STUFF */
	        itemShowDetails.classList.remove("hidden");
	        itemHideDetails.classList.add("hidden");
	        itemInfo.classList.add("hidden");
	        /* ============ */
	        
	        //check quantity on the view
	        	var itemQty = parseInt(document.getElementById(itemId+'_qty').value);
	        
	        //same logic of remove 
	        
	        //check if item is in cart already 
	        if(!isFirstAdd){ 
		        for(var j=0; j<contextOutput.cart.length; j++)
		        {
		        	//found the item in the cart - remove it
		        	if(contextOutput.cart[j].id==itemId && contextOutput.cart[j].fields.status == undefined)
	                { 	
		            	//set some flags
			            if(itemQty == 0){ 
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
	                if(item.id == itemId && item.fields.status == undefined){
	                	//set item to old
	                	component.set("v.oldItemId",itemId);
	                	component.set("v.spinner", false);
	                	break;
	            }
		        }//END for  
		        
		           
	            if(item != null){
	            	 if(itemQty == 0){
	            
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
		            }              
	            }
	           
	        }
	    }//end if checkAttributeRules 
    },
    //marco.ferri 07/09/2018 rewrite for bundles  
    increaseQty : function(component,event,helper){
        var selectedElement = event.currentTarget;
        var itemId = selectedElement.getAttribute('data-item');
        var itemQty = parseInt(document.getElementById(itemId+'_qty').value);
        var contextOutput = component.get('v.contextOutput');
        var item;
        var itemIncart = false;
        var readonly = false;
        var qtymax = component.get('v.qtyMax');   
        component.set("v.qtyEdit",true);
        //add this logic only if the item is in the cart
        
	        //find the item in the cart
	        var cartChildItems = contextOutput.cart;
	            for(var i=1; i<cartChildItems.length;i++){
	                item = cartChildItems[i];
	                //_utils.debug("MATCH?++ : "+ item.id+ " == "+ itemId);
	                if(item.id == itemId && item.fields.status == undefined){
	                	
	                	//cant edit the qty
	                	if(item.fields.qty == qtymax){
							//readonly = true; //19/03/2019 comment this!!!
							//04/03/19 francesca ribezzi editing itemQty:
							//itemQty+=1;
							document.getElementById(itemId+'_qty').value = 0;
						//document.getElementById(itemId+'_qty').value = itemQty;
	                		break;	
	                	}
	                	//add attribute qtyToManage
	                	item.fields.qty = itemQty+1; //maybe schiant
						//_utils.debug("QUANTITY EDITED "+itemQty+1);
		
	                	item.fields.qtyToManage = itemQty+1;               	
	                	itemIncart = true;
	                	break;
	                }	
	            }
	                 
	        //add logic for bit2win engine
	        if(itemIncart){
		        component.set("v.spinner", true);
		        
		        
		        //_utils.debug("OGGETTO? "+JSON.stringify(item));
		        var updateChildEvent 	= 	$A.get("e.NE:Bit2win_Event_ApplyPenalty");
		            updateChildEvent.setParams({
		                "item": 	item,
		                "action" 	: 	'changeQty'
		            });
		         updateChildEvent.fire();
		         component.set("v.itemEditedFromCart",true);
		         
			 }
			 //08/02/19 if item is not in cart, adding it thanks to new logic!!
			 else{
				helper.onCheckByIncreaseQty(component, event, itemId, itemQty);

			 }   
	        //----------------------------       
        
        //qty font color logic here 
        if(itemQty+1 > 0){
        	//add class
            document.getElementById(itemId+'_qty').classList.add("black");
        }
        else if(itemQty == 0){
        	//remove class
            document.getElementById(itemId+'_qty').classList.remove("black");
        }
        else{}
        //**************************
        document.getElementById(itemId+'_qty').value = itemQty+1;
    },
    //marco.ferri 07/09/2018 rewrite for bundles 
    decreaseQty: function(component,event,helper){
        var selectedElement = event.currentTarget;
        var itemId = selectedElement.getAttribute('data-item');
        var itemQty = parseInt(document.getElementById(itemId+'_qty').value);
        var contextOutput = component.get('v.contextOutput');       
        var item;
        var IsDecreasable = true;
        var itemIncart = false;
        var readonly = false;
        var qtymax = component.get('v.qtyMax');   
           
        component.set("v.qtyEdit",true);
           
        //add this logic only if the item is in the cart
        
	       //find the item in the cart
	        var cartChildItems = contextOutput.cart;
	            for(var i=1; i<cartChildItems.length;i++){
	                item = cartChildItems[i];
	                //_utils.debug("MATCH?-- : "+ item.id+ " == "+ itemId);
	                if(item.id == itemId && item.fields.status == undefined){
	                	
	                	//cant edit the qty
	                	if(item.fields.qty == qtymax){
	                		readonly = true;
	                		document.getElementById(itemId+'_qty').value = 0;
	                		break;	
	                	}
	                	//add attribute qtyToManage
	                	if( (itemQty-1) >= 0 ){ //before was >=1 giovanni spinelli 04/03/2019
	                		item.fields.qty = itemQty-1; //maybe schiant
	                		item.fields.qtyToManage = itemQty-1;               	
	                		itemIncart = true;
	                		break;
	                	}
	                	else{	
	                		//item in cart but less or equal to 1 in qty
	                		//_utils.debug("MARK Quantity is already at min [1]");
	                		IsDecreasable = false;
	                		itemIncart = true;
	                		break;
	                	}	
	                }	
	            }                 
	        //add logic for bit2win engine
	        if(itemIncart){	        
	        	component.set("v.spinner", true);	
	        		        	
		        if(IsDecreasable){
		        	
		        	//  //reset error counter
				    //  component.set("v.numInputError",0);
				    //  component.set("v.numInputWarning",0);  
				    //  //end   
		        	        
			        // var updateChildEvent 	= 	$A.get("e.NE:Bit2win_Event_ApplyPenalty");
			        //     updateChildEvent.setParams({
			        //         "item": 	item,
			        //         "action" 	: 	'changeQty' 
			        //     });
			        //  updateChildEvent.fire();
					//  component.set("v.itemEditedFromCart",true);  
					//giovanni spinelli 04/03/2019
					//reset error counter
					component.set("v.numInputError",0);
					component.set("v.numInputWarning",0);  
					//end   
					//04/03/19 francesca.ribezzi if qty = 0, remove item from cart: 
				   if(item.fields.qty == 0){
					   helper.onCheckByDecreaseQty(component, event, itemId, itemQty);
				   }else{
					   var updateChildEvent 	= 	$A.get("e.NE:Bit2win_Event_ApplyPenalty");
					   updateChildEvent.setParams({
						   "item": 	item,
						   "action" 	: 	'changeQty' 
					   });
					updateChildEvent.fire();
					component.set("v.itemEditedFromCart",true);   
				   } 
		         }
		         else{
		        	 component.set("v.spinner", false);	
		         }   
		        //---------------------------- 
		        
		        /* COLOR STUFF */
		        if(itemQty-1 >= 0){
	        	//add class
		            document.getElementById(itemId+'_qty').classList.add("black");
		        }
		        else if(itemQty-1 < 0){
		        	//remove class
		            document.getElementById(itemId+'_qty').classList.remove("black");
		        }
		        else{}        
		        /* ========= */
		        
		        //conditional for the view of the quantity applied if the item is in cart
		        //_utils.debug("MARK check: "+ (itemQty-1));
		        if((itemQty-1) <= 1){
		            document.getElementById(itemId+'_qty').value = 1;
		        }
		        else{
		            document.getElementById(itemId+'_qty').value = itemQty-1;
		        }      
            }
            else{
            	/* COLOR STUFF */
		        if(itemQty-1 > 0){
	        	//add class
		            document.getElementById(itemId+'_qty').classList.add("black");
		        }
		        else if(itemQty-1 == 0){
		        	//remove class
		            document.getElementById(itemId+'_qty').classList.remove("black");
		        }
		        else{}        
		        /* ========= */
            
            	//conditional for the view of the quantity applied if the item is NOT in cart      
		        if(itemQty <= 0){
		            document.getElementById(itemId+'_qty').value = 0;
		        }
		        else{
		            document.getElementById(itemId+'_qty').value = itemQty-1;
		        }
            }  
    },
    //marco.ferri 18/09/2018 rewrite for bundles  
    changeQty : function(component,event,helper){
        var selectedElement = event.currentTarget;
        var itemId = selectedElement.getAttribute('data-item');
        var itemQty = parseInt(document.getElementById(itemId+'_qty').value);
        var contextOutput = component.get('v.contextOutput');
        var item;
        var itemIncart = false;
        var readonly = false;
        var invalidQty = false;
        var qtymax = component.get('v.qtyMax');
        
		component.set("v.qtyEdit",true);
		//04/03/19 giovanni spinelli if qty = 0, removing item from cart:
		if(itemQty == 0){
			helper.onCheckByDecreaseQty(component, event, itemId, itemQty);
			return;
		}

        //add this logic only if the item is in the cart
        
	        //find the item in the cart
	        var cartChildItems = contextOutput.cart;
	            for(var i=1; i<cartChildItems.length;i++){
	                item = cartChildItems[i];
	                //_utils.debug("MATCH? : "+ item.id+ " == "+ itemId);
	                if(item.id == itemId && item.fields.status == undefined){
	                	//add attribute qtyToManage
	                	if(itemQty == 0){
							//04/03/19 giovanni spinelli- commentato:
	                		//itemQty++;
	                	//	document.getElementById(itemId+'_qty').value = itemQty;
	                		//some error msg? nd Marco.Ferri
	                	}
	                	//cant edit the qty
	                	else if(item.fields.qty == qtymax){

							readonly = true;
							//04/03/19 giovanni spinelli - commentato:
	                		/*itemQty = 0;
							document.getElementById(itemId+'_qty').value = 0;*/
							//adding:
							itemQty = parseInt(document.getElementById(itemId+'_qty').value);
	                		document.getElementById(itemId).checked = true;
	                		break;	
	                	}
	                	if(!isNaN(itemQty)){
	                		item.fields.qty = itemQty;
	                		item.fields.qtyToManage = itemQty;    
	                	}	           	
	                	itemIncart = true;
	                	break;
	                }	
	            }
	         //_utils.debug("itemQty "+ itemQty);
	         if(isNaN(itemQty)){
	        	if(itemIncart){
	        		document.getElementById(itemId+'_qty').value = item.fields.qty;
	        	}
	        	else{
	        		document.getElementById(itemId+'_qty').value = 0;
	        	}
	        	invalidQty = true;
	        }            
	        //add logic for bit2win engine
	        if(itemIncart && !readonly && !invalidQty){
		        component.set("v.spinner", true);
	            
		        //_utils.debug("OGGETTO? "+JSON.stringify(item));
		        var updateChildEvent 	= 	$A.get("e.NE:Bit2win_Event_ApplyPenalty");
		            updateChildEvent.setParams({
		                "item": 	item,
		                "action" 	: 'changeQty'
		         });
		         updateChildEvent.fire();
		         component.set("v.itemEditedFromCart",true);

			 } 	
			//08/02/19 if item is not in cart, adding it thanks to new logic!!
			 else{
				helper.onCheckByIncreaseQty(component, event, itemId, itemQty);
	
			 }    
	        //----------------------------   
	        
        
        //qty font color logic here 
        if(itemQty > 0){
        	//add class
            document.getElementById(itemId+'_qty').classList.add("black");
        }
        else if(itemQty == 0){
	            //remove class
	            document.getElementById(itemId+'_qty').classList.remove("black");
        }
        else{}
        //**************************
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
    
    onDeleteActivePOS: function(component,event, helper){
    
    	_utils.debug("into onDeleteActivePOS");
    	var cartItemToDelete = event.getParam("cartItem");
    	
    	_utils.debug("cartItemToDelete",cartItemToDelete);
    	//set spinner on -> call delete -> set flags
    	component.set("v.spinner",true);
    	
    	var configureAppEvent 	= 	$A.get("e.NE:Bit2win_Event_AddRemoveFromCart");
        configureAppEvent.setParams({
                'item'	: 	cartItemToDelete,
                'action' : 	'remove',
            });
        configureAppEvent.fire();	             
		       
		                   
        //setting the item in the attribute for future reference to remove
        component.set("v.itemToConfigure",cartItemToDelete);
        component.set("v.oldItemId",undefined);
        component.set("v.needConfiguration", false);
        //set flags
        component.set('v.itemAddedToCart',false);
        component.set('v.itemRemovedFromCart',true);
        //****************
    	
    },
    disableEnterOnPress: function(component,event, helper){
    	
    	var key;      
	    if(window.event)
	    {
	    	key = window.event.keyCode; //IE
	    }
	    else{
	    	key = e.which; //firefox      
	    }
	    if(key == 13){
	    	 event.preventDefault();
	    	 return false;
	    }
	},


	// Doris D. ----01/03/2019 .....START
	openPop : function(component, event, helper) { 
		//var currId = event.getSource().get("v.id");
		var selectedElement = event.currentTarget;
        var currId = selectedElement.getAttribute('data-item');
		console.log("Current id is ---> "+ currId);
		component.set("v.currentItemId",currId);
		//alert("Test mouse over " + currId);
		component.set('v.showMessage',true);
	
	},

	closePop : function(component, event, helper) { 
			
		component.set("v.currentItemId","");
		component.set('v.showMessage',false);
		// alert("Close");
	},

	// Doris D. ----01/03/2019 .....END
	/**
	*@author giovanni spinelli <spinelli.giovanni@accenture.com>
	*@date 19/09/2019
	*@description Method to reset default value on child item
	*@params -
	*@return -
	*/
	resetValue: function (component, event, helper) {
		var coreOutput = component.get('v.contextOutput');
		
		var itemId = event.currentTarget.name;
		component.set('v.currentTermId' , itemId);
        helper.removeItemReset(component , event , itemId , coreOutput);
	}
})