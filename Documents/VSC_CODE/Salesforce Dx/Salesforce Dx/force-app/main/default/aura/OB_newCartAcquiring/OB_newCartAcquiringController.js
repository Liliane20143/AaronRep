({
doInit  : function(component, event, helper)
{
	// ANDREA MORITTU START - EVO BACKLOG_245 - Logic on set empty list if the attrbiute does not exist
	try {
		if(!$A.util.isUndefinedOrNull(component.get('v.oldVMAttributes') )) {
			if(!$A.util.isUndefinedOrNull(component.get('v.oldVMAttributes')[0]['Commissione Unica'] ) && !$A.util.isEmpty(component.get('v.oldVMAttributes')[0]['Commissione Unica'] ) ) {
				
			} else {
				component.set('v.oldVMAttributes', []);
			}
		}
	} catch(e) {
		console.log('An error has occured inside doInit of OB_newCartAcq : ' + e.message);
	}
	// ANDREA MORITTU END - EVO BACKLOG_245 - Logic on set empty list if the attrbiute does not exist
},

	//LUBRANO 16/01/2019 Libreria Log
	logInit: function(component){
		_utils.logInit(component.getName());
	},

	onUpdateContext : function(component, event, helper)
	{
        _utils.debug('Inside onUpdateContext for newCartAcquiring');
   
      //  _utils.debug('into newCartAcquiring bundleStep: ' + component.get("v.bundleStep"));
        var doCheckout=component.get('v.requestCheckout');
        //var visibleCategories = component.get('v.visibleCategories');
        var objectDataMap = component.get("v.objectDataMap");
        var itemAddedToCart = component.get('v.itemAddedToCart');
        var itemRemovedFromCart = component.get('v.itemRemovedFromCart');
        var category,bundle,listOfCategories,listOfBundles;
        var offertaId = objectDataMap.unbind.offertaId;
        component.set('v.offertaId',offertaId);
        var coreOutput = event.getParam("CartService_Output");
        var step =  component.get("v.bundleStep");
       // _utils.debug("step into acquiring: " + step);
        var itemToUpdate =  component.get("v.itemToUpdate");
        //_utils.debug("itemToUpdate: " + JSON.stringify(itemToUpdate));
        var isItemFakeToRemove = component.get("v.isItemFakeToRemove");
        
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
			//START 27/03/19 francesca.ribezzi: 
			var alert = coreOutput.sessionParameters.alert;
			if(alert){
				//showing alert message:
				var type = 'error';
				var mode = 'sticky';
				var infoMessage =$A.get("$Label.c.OB_CancelOfferMessage");
				helper.showInfoToast(component, event, infoMessage, type, mode);
			}
			//END francesca.ribezzi
             
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
			
			helper.showBundleElement(component,coreOutput);
			//component.set('v.spinner',false); 
		}
		/* NO checkout HERE 
		else if(doCheckout)
        {
			// set contextOutput
			component.set('v.contextOutput',coreOutput);
			//francesca.ribezzi firing updateContextEvent event to parent OB_FlowCart
			//START EVENT 
			var updateContextEvent = $A.get("e.c:OB_CustomUpdateContextEvent");
			updateContextEvent.setParams({ contesto: coreOutput,
											});
        	updateContextEvent.fire();
        	//END event 
			_utils.debug('__CHECKOUT__');
			var checkPenalty 							= 	$A.get("e.NE:Bit2win_Event_ApplyPenalty");
            checkPenalty.setParams({
                'action' 	: 	'checkout'
            });
			_utils.debug('FIRE EVENT __Bit2Win_Event_ResetSaveConfiguration');
            checkPenalty.fire();
            
        }*/
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
	        	helper.updateCartList(component,coreOutput);
	        	component.set('v.spinner',false);
            	
	    }
        else if(itemAddedToCart || itemRemovedFromCart || itemEditedFromCart){
        	
        	// set contextOutput
			component.set('v.contextOutput',coreOutput);
			//francesca.ribezzi firing updateContextEvent event to parent OB_FlowCart
			//START EVENT 
			var updateContextEvent = $A.get("e.c:OB_CustomUpdateContextEvent");
			updateContextEvent.setParams({ contesto: coreOutput});
        	updateContextEvent.fire();
        	//END event 			
        				
			//helper.updateCartList(component);
        	/*********** START NEW PART: CONFIGURE ITEMS  **********/			
        	var needConfig = component.get("v.needConfiguration");
        	var itemToConfigure = component.get("v.itemToConfigure");
        	var isFirstAdd = component.get('v.isFirstAdd');
        	var itemId = component.get("v.newItemId");
        	var isCloseConf = component.get("v.isCloseConf");
        	var openDetailsBtnId;
        	
        	
        	
        	//check changes in min max qty
        	//helper.checkMinMaxQtyBundleStep(component,event,coreOutput);
        	
        	//setting agenda group
        	//Options for the ADD event (is the same parameter for all the events)
            var requestOptions =      {};
             
            //Add an array called "agendaGroups" to the requestOptions object
            var agendaGroups   =      [];
            agendaGroups.push("agAcquiring");
            requestOptions.agendaGroups = agendaGroups;
        	        	 	      	
        	//only copy this {if/else} if you manage the quantity
        	if(isCloseConf){
        			
        			//potentially dead step on the chain...
        			
        			//hide previous element details
        			component.set("v.isCloseConf",false);
		        	//_utils.debug("hello!");
		        	helper.updateCartList(component);
        			//after the old one is closed set the old on the current one
        			//component.set("v.oldItemId",itemId); //useless
        			// make spinner go off here as normal routine for every item after 1st add
        			component.set('v.spinner',false);			
        	}
        	else{
		        if(!needConfig){ //already called configure event on the item 
		        	if(itemAddedToCart){
		        			
		        			
		        	
		        			if(isFirstAdd){		        			
		        				//component.set("v.isFirstAdd",false);
		        				helper.updateCartList(component);				
		        				component.set('v.spinner',false);    				
		        			}
		        			else{
		        			//_utils.debug("MARK STO IN CONFIG 2nd ELEMENT");
		        			helper.checkCatalogChanges(component, coreOutput);
			        		 
			        		 /*
			        		 var addRemoveFromCart = $A.get("e.NE:Bit2win_Event_AddRemoveFromCart");  
			        		 //before launching addRemoveFromCart to configure the item
			        		 	addRemoveFromCart.setParams({
					            	"item": itemToConfigure,
					                //"mapOfItems": +{...},
					                "catalogId":  itemToConfigure.fields.catalogid,
					                "action": "modify",
					                "categoryId": itemToConfigure.fields.categoryid,
					                "typeOfAdd": "multiAdd" 
				            	});
			        		addRemoveFromCart.fire();
 							*/
			        			
			        		component.set("v.isCloseConf",true);
			        		
			        		helper.updateCartList(component);
		        			//after the old one is closed set the old on the current one
		        			//component.set("v.oldItemId",itemId); //useless
		        			// make spinner go off here as normal routine for every item after 1st add
		        			component.set('v.spinner',false);
  					
		        			}
			        		
		        	}
		        	else if(itemRemovedFromCart){
		        	
		        		
		        		//update parent of childToRemove
				         var updateParentAttributeMap = $A.get("e.c:OB_UpdateParentMapAttribute");
								updateParentAttributeMap.setParams({
									'IdItem': itemToConfigure.id,
								});										
						updateParentAttributeMap.fire();
						//END 			   
		        	 		
		        		//after removing an item, calling helper to refresh catalog
		        		helper.checkCatalogChanges(component, coreOutput);
		        		helper.updateCartList(component); 
		        		component.set('v.spinner',false);
		        		//_utils.debug("itemToConfigure VAR in remove after conf: ", itemToConfigure);	
						//_utils.debug("itemToConfigure ATTR in remove after conf: ", component.get("v.itemToConfigure"));
						/* ANDREA MORITTU START 19-Sept-2019 - EVO_PRODOB_452  */
						let isEditCommissionModel = component.get('v.isEditCommissionModel');
						let actualCommissionalItem = component.get('v.cartCommission');
						if(isEditCommissionModel && (!$A.util.isUndefined(actualCommissionalItem) && !$A.util.isEmpty(actualCommissionalItem) ) ) {
							helper.updateCommissionModel(component, event, isEditCommissionModel, actualCommissionalItem);
						}
						/* ANDREA MORITTU END 19-Sept-2019 - EVO_PRODOB_452  */
		        		  
		        	} 	
		        }else{//need config is false
		           
		        	if(itemAddedToCart){
		        	
		        		if(isFirstAdd){
		        			helper.checkCatalogChanges(component, coreOutput);
		        			
		        			//in case there is no event calling on first add
		        			helper.updateCartList(component);
		        					
		        			component.set('v.spinner',false);
		        			
		        			/*
		        			var addRemoveFromCart = $A.get("e.NE:Bit2win_Event_AddRemoveFromCart");  
		        			//before launching addRemoveFromCart to configure the item
		        		 	addRemoveFromCart.setParams({
				            	"item": itemToConfigure,
				                //"mapOfItems": +{...},
				                "catalogId":  itemToConfigure.fields.catalogid,
				                "action": "modify",
				                "categoryId": itemToConfigure.fields.categoryid,
				                "typeOfAdd": "multiAdd" 
			            	});
		        		 	addRemoveFromCart.fire();
		        		 	
		        		 	*/
		        		 	//component.set("v.oldItemId",itemToConfigure.id);
		        		}
		        		else{
		        		  //try to get the item from the correct offertChildList
		        		  //need to get the list again after the conf. closed in this step so it
		        		  //gets refreshed
  
		                  var item;
        
		                  component.set("v.offertChildList", coreOutput.listOfItems);
		                  var offertChildList = component.get("v.offertChildList");
		                  
		        		  for(var i=0;i<offertChildList.length;i++){
			                item = offertChildList[i];
			                
				                if(item.id == itemId){
				                	component.set("v.itemToConfigure",item);
				                	break;
							     }  
			            	}   
			            	//item.fields.qty = itemQty;
		        		  var updateChildEvent 	= 	$A.get("e.NE:Bit2win_Event_AddRemoveFromCart");
				            updateChildEvent.setParams({
				                "item": item,
							    //"mapOfItems": ,
							    //"catalogId": item.fields.catalogid,
							    "action": "add",
							    //"categoryId":  item.fields.categoryid,
							    "typeOfAdd": "singleAdd",
								//"options" : requestOptions
				           });
				           updateChildEvent.fire();
				         }
		        	}
		        	else if(itemRemovedFromCart){
		        		var configureAppEvent 	= 	$A.get("e.NE:Bit2win_Event_AddRemoveFromCart");
			            configureAppEvent.setParams({
				                'item'	: 	itemToConfigure,
				                'action' : 	'remove',
				                //'options' : requestOptions
				            });
			            configureAppEvent.fire();
		        	}
		             component.set("v.needConfiguration", false);
		          }               
	        }// END ELSE IF
        }
        }else{
        	//_utils.debug("itemToUpdate has been changed!");
        	//_utils.debug("coreOutput item updated? " + JSON.stringify(coreOutput));
        	
        	component.set("v.itemToUpdate", null);
			component.set("v.contextOutput", coreOutput);
			/**
			 * giovanni spinelli 19/09/2019 start
			 * call again method to reset value if there are more than one value to reset
			 */
			var isToreset = component.get('v.isToreset');
			if(isToreset == true){
				component.set('v.spinner',true);
				var index = component.get('v.indexReset');
				index = index +1;
				helper.resetValueEvent(component, event, index);
			}
			//giovanni spinelli 19709/2019 end
			/* ANDREA MORITTU  - START 04-Oct-2019 - EVO_BACKLOG_245 */
			var isToreset_VM = component.get('v.isVIsaToReset');
			if(isToreset_VM == true){
				component.set('v.spinner',true);
				var index_VM = component.get('v.index_VM');
				index_VM = index_VM +1;
				helper.updateListAttributeEvent(component, event, index_VM);
			}
			/* ANDREA MORITTU  - END 04-Oct-2019 - EVO_BACKLOG_245 */

			
        	//update childItems here from coreOutput
        	//francesca.ribezzi - adding 2 vars for displaying columns:
			var categoryCirc = component.get("v.categoryCircuit")
			var numOfCol = categoryCirc.length;
	        var acquiringRecordType = "Acquiring";
	        acquiringRecordType = acquiringRecordType.toLowerCase();
	        var listToSort = [];
			//28/11/18 francesca.ribezzi - calling a new method to create the right grid and cols to display for childItems and attributes:
			//start
			// go ahead wit this block of code only if the user selects a pos:
			for(var j=0; j<coreOutput.cart.length; j++)
			{    
					if(coreOutput.cart[j].fields.RecordTypeName.toLowerCase() == acquiringRecordType)
					{
						listToSort.push(coreOutput.cart[j]);
						
					  /*  numOfCol = listToSort[0].numOfCol;
						_utils.debug("numOfCol: " + numOfCol);
						component.set("v.numOfCol", numOfCol);
						numOfCol =  parseInt(numOfCol)+2;
						component.set("v.maxCol", numOfCol);*/
						//listToSort[0] = contextOutput.cart[j];
					}
					
				}
				//_utils.debug("listToSort before calling createAttribute2: ", listToSort);
				
				if(listToSort.length > 0){
					listToSort = helper.createAttribute(listToSort,  component.get("v.categoryCircuit"));
				}
				if(listToSort.length > 0){
					if(listToSort[0].childItems.length> 0){
					   if(numOfCol <= listToSort[0].childItems[0].listOfAttributes.length){
			        	  numOfCol = listToSort[0].childItems[0].listOfAttributes.length;
				    }
					}
				}
			   	component.set("v.numOfCol", numOfCol);
				numOfCol =  parseInt(numOfCol)+2;
				component.set("v.maxCol", numOfCol);	
				helper.createRowAcquiringSummaryTable(component);
        	//*********************************************************************************
        	
		   //Set focus on the last id
	       var idToFocus = component.get("v.childItemToFocus");
	      
	       if( !($A.util.isEmpty(idToFocus)) )
	       {
	    	    window.setTimeout(
			    $A.getCallback(function() {
			    		if(document.getElementById(idToFocus) != undefined)
			    		{
			    			document.getElementById(idToFocus).focus();
			    		}
			    }), 250
			    )
	    	  
	       } 
        	
			component.set("v.spinner", false);
			var isToreset = component.get('v.isToreset');
			if(isToreset == true){
				component.set("v.spinner", true);
			}
        }
    },
    
    onCheck: function(component,event,helper){
        component.set("v.spinner", true);
        var itemId = event.getSource().get("v.id");
        var chkBoxVal = event.getSource().get("v.checked");
        var item;
        var contextOutput = component.get('v.contextOutput');
        var offertChildList = contextOutput.listOfItems;
        var isFirstAdd = component.get('v.isFirstAdd');
        //var numOfCheckedItems = component.get('v.numOfCheckedItems');
        for(var i=0;i<offertChildList.length;i++){
            item = offertChildList[i];
            if(item.id == itemId) break;
        }
        
        //setting agenda group
    	//Options for the ADD event (is the same parameter for all the events)
        var requestOptions =      {};
         
        //Add an array called "agendaGroups" to the requestOptions object
        var agendaGroups   =      [];
        agendaGroups.push("agAcquiring");
        requestOptions.agendaGroups = agendaGroups;
        
        if(chkBoxVal){
        	//numOfCheckedItems++;
        	//_utils.debug("numOfCheckedItems +1: " + numOfCheckedItems);
            component.set('v.itemAddedToCart',true);
        /*    var itemQty = parseInt(document.getElementById(itemId+'_qty').value);
            if(itemQty == 0){
                document.getElementById(itemId+'_qty').value = 1;
            }*/
            if(isFirstAdd){
				
            	//getting specific item props by cycling the whole bundleItem list and setting the quantity
            	//only on first add, get the item after the update context on the 2nd add!
            	for(var i=0;i<offertChildList.length;i++){
                item = offertChildList[i];
	                if(item.id == itemId){
	                	break;
	                }  
            	}   
            	//item.fields.qty = itemQty;
	           //if this is the first element we add it immediatly 
	            var updateChildEvent 	= 	$A.get("e.NE:Bit2win_Event_AddRemoveFromCart");
	            updateChildEvent.setParams({
	                "item": item,
				    //"mapOfItems": ,
				    //"catalogId": item.fields.catalogid,
				    "action": "add",
				    //"categoryId": item.fields.categoryid,
				    "typeOfAdd": "singleAdd",
					//"options" : requestOptions
				
	            });
	
	            updateChildEvent.fire();
	            component.set("v.itemToConfigure",item);
            }
            /*
            else{
            	//if not we need to close the previous configuration THEN add
            	var closeConfEvent 	= 	$A.get("e.NE:Bit2Win_Event_ResetSaveConfiguration");
	            closeConfEvent.setParams({
				    "CartService_Output": contextOutput,
				    "type": "save"
	            });
	            closeConfEvent.fire();
	            	
	            //need to save the attribute of the id to have as a reference for the later cycle
	            component.set("v.newItemId",itemId);
	           
            }
			*/
			component.set("v.newItemId",itemId);
			
            component.set("v.needConfiguration",true); 
            //reset flags
            component.set('v.itemAddedToCart',true);
            component.set('v.itemRemovedFromCart',false);
            //******************      
            /* ==== random view selection css stuff ->IGNORE<- ==== */
           // var productRow = document.getElementById(itemId+'_prdRow');
           // var itemInfo = document.getElementById(itemId+'_infoColor');
           // productRow.classList.add("product_row_color");
            //itemInfo.classList.add("product_row_color");
            /* =====================================================*/
        
            /* start acquiring table */
            //change background color of row            
            var productRow = document.getElementById(itemId+'_prdRow');
            productRow.classList.add("product_row_color");
            
            
            //ToDo Add only if the category is "Circuiti Internazionali"?
            //if(item.fields.categoryName == "Circuiti Internazionali"){
            // add table acquiring 
            /*var circuitiList = component.get("v.circuitiList"); 
            // get all category names on first iteration 
            var categoryName = component.get("v.categoryCircuit");
           	if(circuitiList.length == 0 &&  categoryName.length == 0){
           		for(var i = 0; i < item.listOfAttributes.length; i++){
           			var catName  =  item.listOfAttributes[i].fields.name;
           			// coreOutput.cart[cartIndex].fields.categoryname,
					//items: 	coreOutput.cart[cartIndex].fields.productname
           			//
            		categoryName.push(catName);
            	}
            component.set("v.categoryCircuit",categoryName);
            }
            var categoryValues = [];           
            for(var i = 0; i < item.listOfAttributes.length; i++){ 	
            	var catValueWithPercent =  item.listOfAttributes[i].fields.value;
            	var catValue = catValueWithPercent.substring(0, catValueWithPercent.length-1);
            	categoryValues.push(catValue); 	
            }
            //_utils.debug("MarkvaluesPostFOR "+categoryValues);          
            //push with more parameters
            circuitiList.push({ 	
            		 "productName" : item.fields.productname, //product name (es. Visa/Mastercard)
            		 "value" : categoryValues
            	 });
            component.set("v.circuitiList",circuitiList);
            component.set("v.categoryCircuitValues",categoryValues); 
        }*/
        
        }
        else{
          //numOfCheckedItems--;
          //_utils.debug("numOfCheckedItems -1: " + numOfCheckedItems);
          var cartChildItems = contextOutput.cart;
          var item;
            for(var i=0; i<contextOutput.cart.length;i++){
                item = cartChildItems[i];
                if(item.id == itemId) break;
            }
            
            var recordTypeCommissione = 'Commissione';
            recordTypeCommissione = recordTypeCommissione.toLowerCase();
            
            if(item.fields.RecordTypeName.toLowerCase() == recordTypeCommissione){
            	
            	var acquiringList = component.get("v.circuitiList");
            	
            	for(var i = 0; i <acquiringList.length; i++){
            		
            		var IdItemToSend = acquiringList[i].fields.id;
            		
            		var updateParentAttributeMap = $A.get("e.c:OB_UpdateParentMapAttribute");
						updateParentAttributeMap.setParams({
							'IdItem': IdItemToSend
						});										
					updateParentAttributeMap.fire();
            	}
            }
            else{
	            //update parent of childToRemove
			    var updateParentAttributeMap = $A.get("e.c:OB_UpdateParentMapAttribute");
					updateParentAttributeMap.setParams({
						'IdItem': item.id
					});										
				updateParentAttributeMap.fire();
				//END 	
			}
					   
            
            //if not we need to close the previous configuration THEN remove 
            
            /*
            var closeConfEvent 	= 	$A.get("e.NE:Bit2Win_Event_ResetSaveConfiguration");
	            closeConfEvent.setParams({
	
				    "CartService_Output": contextOutput,
				    "type": "save"
	            });

	        closeConfEvent.fire();    
	   		
                        
            //setting the item in the attribute for future reference to remove
            component.set("v.itemToConfigure",item);
			component.set("v.needConfiguration",true);
			
			*/
			
			component.set("v.itemToConfigure",item);
			var configureAppEvent 	= 	$A.get("e.NE:Bit2win_Event_AddRemoveFromCart");
			configureAppEvent.setParams({
				                'item'	: 	item,
				                'action' : 	'remove'
				                //'options' : requestOptions
				            });
			            configureAppEvent.fire();
		    
		    component.set("v.needConfiguration", false);


            //set flags
            component.set('v.itemAddedToCart',false);
            component.set('v.itemRemovedFromCart',true);
            //****************
            /*change background color of row */
            
            var productRow = document.getElementById(itemId+'_prdRow');
            productRow.classList.remove("product_row_color");
            
            /* remove  table acquiring */
            
          /*  var circuitiList = component.get("v.circuitiList");
            var index = 0;
            for(var i = 0; i < circuitiList.length; i++){
            	//_utils.debug("MARK$: "+circuitiList[i].productName+ " == "+item.fields.productname);
            	if(circuitiList[i].productName == item.fields.productname){
            		index = i;
            		break;
            	}
            	else continue;	
            }
            circuitiList.splice(index,1);
           
            component.set("v.circuitiList",circuitiList); */
            
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
	        //	_utils.debug("firing event to OB_FlowCart cmp to disable next button..");
	        	//END event 
	        }else if(numOfCheckedItems >= component.get("v.bundleMinQty")){
				//START EVENT 
				var updateContextEvent = $A.get("e.c:OB_CustomUpdateContextEvent");
				updateContextEvent.setParams({ "disabledNextBtn": false});
	        	updateContextEvent.fire();
	        //	_utils.debug("firing event to OB_FlowCart cmp to enable next button..");
	        	//END event 
	        }
	    }    
        component.set("v.numOfCheckedItems", numOfCheckedItems);
		*/
        
    },
     //this is called when an attribute value is changed. it fires an event that calls onUpdateContext function:
    onChangeAttributeValue: function(component, event, helper){
    	
        var attributeIndex = JSON.stringify(event.target.id); 
    
        //attributeIndex = parseInt(attributeIndex.split('_').pop());
        var listOfItems = component.get("v.acquiringChildItems");
        var parentIndex = document.getElementById(event.target.id).name;

        //get the index of the error span
        var errorIndex = document.getElementById(event.target.id+'_errorACQ'); 
        
        //lil check 
        var pos1 = attributeIndex.indexOf("_")+1; 
        attributeIndex = attributeIndex.substr(parseInt(pos1),1);      
        
        var itemToUpdate;
        for(var i = 0; i<listOfItems.length; i++){
        	if(listOfItems[i].id == parentIndex){
        	//_utils.debug("listOfItems[i].id: " + listOfItems[i].id);
        		itemToUpdate = listOfItems[i];
        		break;
        	}
        }

        if(itemToUpdate != null){
	        //attributes to pass to  checkItemValueApprovalRules helper function:
	        var input = document.getElementById(event.target.id); 
		    var valueToCheck = event.target.value;
		    var attributeFields = itemToUpdate.listOfAttributes[attributeIndex].fields;
		    
		    //match the regex
	        if(/^[0-9]*([,][0-9]{1,3}|)$/.test(event.target.value)){ 
	        	//_utils.debug("VALUE IS OK");
	        	//reset err msg
	        	if(errorIndex != null)
	        	{
	        		errorIndex.classList.add("hidden");
				}
				
				var isAuraId = false;
				
				//CHECK RULES
			    helper.checkItemValueApprovalRules(component,event,attributeFields,valueToCheck,input,errorIndex,isAuraId);
			    //-------  
			    
		        var contextOutput = component.get("v.contextOutput"); 
		        itemToUpdate.listOfAttributes[attributeIndex].fields.value =  event.target.value;
		        component.set("v.itemToUpdate", itemToUpdate);
		       
			    var changeAttributeEvent = 	$A.get("e.NE:Bit2win_Event_AttributeChanged");
					changeAttributeEvent.setParams({
						'itemChanged': itemToUpdate,
						'Context_Output':contextOutput
					});										
			   changeAttributeEvent.fire(); 
			   component.set("v.spinner", true);
			   component.set("v.itemToUpdate", itemToUpdate); 									
	
		    }
		    else{//regex failed show error
		    	//_utils.debug("VALUE IS NOT OK");
		    	
		    	
		    	if(errorIndex != null){
				   errorIndex.classList.remove("hidden");
				   input.classList.remove("borderWarning");
				   input.classList.add("borderError");
			   }   
			   event.target.value = '';
			   //event.target.value = itemToUpdate.listOfAttributes[attributeIndex].fields.value; 
			   
			   component.set('v.checkAttributeRules','error');

			   //firing approvalOrderRulesEvent event to parent OB_FlowCart
			   var checkAttributeRulesToSend = component.get("v.checkAttributeRules");
			   //START EVENT 
				
				var approvalOrderRulesEvent = $A.get("e.c:OB_ApprovalOrderRulesEvent");
				approvalOrderRulesEvent.setParams({ 
					"checkAttributeRules": checkAttributeRulesToSend
				});
		    	approvalOrderRulesEvent.fire();
		    	//END event 
		    }  
	    }
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
    	var idChild = event.getParam("IdChildItem"); //set in an attribute to set focus!
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
		   
		   component.set("v.childItemToFocus",idChild);
		   component.set("v.itemToUpdate", itemToUpdate);
		   component.set("v.spinner", true);
	},
	/**
	*@author Giovanni Spinelli <spinelli.giovanni@accenture.com>
	*@date 20/09/2018
	*@description reset value on acquiring
	*@params -
	*@return 
	*/
	resetValue      : function(component,event, helper){
		
    	var acqlist = component.get('v.acquiringChildItems');
		var listItemToreset = [];
		var indexReset =0;
		for(var i =0; i<acqlist.length; i++){
			
			var listAtt = acqlist[i].listOfAttributes;
			for(var j=0; j<listAtt.length; j++){
				console.log('ACTION attributes: ' + JSON.stringify(listAtt[j]));
				var fields = listAtt[j].fields;
				//davide.franzini 07/01/2020 PERF-93 Old Value changed to previousvalue
				if( fields.previousvalue != fields.value){

					fields.value = fields.previousvalue;
					listItemToreset.push( acqlist[i] );
					
				}
			}
		}
		console.log('listItemToreset ' , listItemToreset);
		console.log('indexReset ' , listItemToreset.length);
		component.set('v.acquiringChildItems' , acqlist);
		component.set( 'v.listItemToreset' , listItemToreset);
		
		// component.set( 'v.indexReset' , listItemToreset.length);
		helper.resetValueEvent(component , event , 0 );
	},

	/*
	*	Author		:	Morittu Andrea
	*	Date		:	03-Oct-2019
	*	Task		:	EVO_BACKLOG_245
	*	Description	:	Handler on change of listVISAtoReset attribute
	*/
	onchange_listVISAtoReset : function(component, event, helper) {
		
		console.log('Do Init onchange_listVISAtoReset ');

		var acqlist = component.get('v.listVISAtoReset');
		var listItemToreset = [];
		var indexReset =0;
		for(var i =0; i<acqlist.length; i++){
			
			var listAtt = acqlist[i].listOfAttributes;
			for(var j=0; j<listAtt.length; j++){
				var fields = acqlist[i].fields;
					fields.value = fields.Old_Value__c;
					listItemToreset.push( acqlist[i] );	
			}
		}
		component.set( 'v.listItemToreset' , listItemToreset);
		helper.updateListAttributeEvent(component, event,  0 );
	},

	/*
	*	Author		:	Morittu Andrea
	*	Date		:	02-10-2019
	*	Task		:	BACKLOG_245
	*	Description	:	On click of VISA_MASTERCARD button and modal
	*/
	actionModal_VM : function(component, event, helper) {
		let currentClickedButton = event.getSource().get("v.name");		
		try {
			switch (currentClickedButton) {
				// CONFIRM BUTTON AFTER SHOW MODAL
				case $A.get("$Label.c.OB_Confirm"):
					component.set('v.showProgressBar' , true);
					component.set('v.show_VM_Modal', false);

					helper.overturnOldVISAMASTERCARDvalues_Helper(component, event, helper);
				break;
				// EXIT MODAL
				case $A.get("$Label.c.OB_Cancel"):
					component.set('v.show_VM_Modal', false);
				break;
				// SET VALUE BUTTON CLICKED
				case  $A.get("$Label.c.OB_Import_VISA_Values"):
					component.set('v.show_VM_Modal', true);
				break;
			}
		} catch(e) {
			console.log(e.message);
		}
	}
})