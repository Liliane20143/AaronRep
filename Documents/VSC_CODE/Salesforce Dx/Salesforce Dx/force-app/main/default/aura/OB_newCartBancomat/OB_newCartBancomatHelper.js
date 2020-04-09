({
   showBundleElement: function(component,coreOutput){ 	

			var productCategories = [];    
			for(var i in coreOutput.listOfCategories)
			{
				if(i!= 0 && (coreOutput.listOfCategories[i].categoryFields.hidden == 'true' || coreOutput.listOfCategories[i].categoryFields.hidden == true) )				
				// toAdd || root --> depth =0 , coreOutput.listOfCategories[0]
				{
					continue;	
				}
				var listOfitems=[];
				for(var j in coreOutput.listOfItems)
				{
					//coreOutput.listOfItems[j].fields				
					if(coreOutput.listOfItems[j].fields.visible == true || coreOutput.listOfItems[j].fields.visible == 'true' )
					{
						if(coreOutput.listOfItems[j].fields.categoryid	==	coreOutput.listOfCategories[i].id)
						{	
							listOfitems.push(coreOutput.listOfItems[j]);
						}
					}
				}

            if(listOfitems.length >0)
            {
                    productCategories.push({
                            categoryName	:	coreOutput.listOfCategories[i].categoryFields.name,
                            categorySequence:   coreOutput.listOfCategories[i].categoryFields.sequence,
                            items			:	listOfitems
                        
                    });
                }
			}
			
			//here we sort by sequence the array of objects, Good luck understanding any of this :)
			productCategories.sort(function(a, b){
				return a.categorySequence == b.categorySequence ? 0 : +(a.categorySequence > b.categorySequence) || -1;
			});
			
            component.set('v.productCategories',productCategories);
            //here we need a check...
            var cartChildItems = coreOutput.cart;
			var item;
			var qtyMax = component.get("v.qtyMax");
			for(var i=0; i<coreOutput.cart.length;i++){
				item = cartChildItems[i];
				if(item.fields.qty == qtyMax){
					component.set("v.itemFakeToRemove",item);
					break;
				}
			}	
            var itemFakeToRemove = component.get("v.itemFakeToRemove");
            
            //Marco.Ferri 24/09/2018: --> CTRFI <-- :Time to decrypt! Every letter is the starting one for the word<--
            //Normal route -- IF ONLY! 
            if(itemFakeToRemove != null || itemFakeToRemove != undefined){   	
            	this.removeFakeItem(component);	
        	}
        	//shame on you!
        	else{
        		this.addBancomatToCart(component);
            	//this.updateCartList(component); 		
        	}
        },
        
    updateCartList: function(component){
        _utils.debug('into updateCartList'); 
        var cartList = [];
        var items = [];
        var contextOutput = component.get("v.contextOutput");
        var itemToConfigure =  component.get("v.itemToConfigure");
       
        var listOfItems = [];
        var listOfAttributes = [];
        var listOfFamilies = [];
        var attributesParentList = [];
        var offertaId = component.get("v.offertaId");
        var offerta;
		if(contextOutput.cart.length == 1)
		{
			offerta = contextOutput.cart[0].fields.productname;
		}
		else{
			for(var i=0;i<contextOutput.cart.length;i++){
				if(contextOutput.cart[i].fields.RecordTypeName == 'Tariff_Plan')
				{
					offerta = contextOutput.cart[i].fields.productname;
					break;
				}
			}
		}
        var cartListTotal = 0;
      /*************************************************************************************************************************/
		//adding logic to display child items and attributes correctly in markup!!!
		//francesca.ribezzi - adding 2 vars for displaying columns:
		var numOfCol = 0;
        var commissionColSize = 1;
        
       
        
		//28/11/18 francesca.ribezzi - calling a new method to create the right grid and cols to display for childItems and attributes:
		//start
		// go ahead wit this block of code only if the user selects a pos:
		if(itemToConfigure != null || itemToConfigure != undefined){ //if it's true, then it needs to call enrichAttribute function:
			/*
			giovanni spinelli 30/08/2019 - start
			create array to store label
			*/
			var uniqueLabels  = [];
			var tmpUniqueLabel = [];
			//giovanni spinelli 30/08/2019 - end
			
			
			for(var j=0; j<contextOutput.cart.length; j++)
			{
				//check to get teh correct id to check if we are in a post checkout or not
		        var cartId;
				var ItemIdToAdd; 
				
				if(itemToConfigure.id != undefined && itemToConfigure.id != null && itemToConfigure.id != ''){
					cartId = contextOutput.cart[j].id;
					ItemIdToAdd = itemToConfigure.id
				}
				else{
					cartId = contextOutput.cart[j].fields.id;
					ItemIdToAdd = itemToConfigure.fields.id;
				}
				//END
			
				if(cartId == ItemIdToAdd && contextOutput.cart[j].fields.type == "Product")
				{
					var listToSort = [];
					listToSort.push(contextOutput.cart[j]);
					listToSort = this.createAttribute(listToSort,  component.get("v.posCategories"));
					//setting numOfCol and commissionColSize values:
				    numOfCol = listToSort[0].numOfCol;
				    commissionColSize = listToSort[0].commissionColSize;	
				    component.set("v.commissionColSize", commissionColSize);
					_utils.debug("numOfCol: " + numOfCol);
					component.set("v.numOfCol", numOfCol);
					numOfCol =  parseInt(numOfCol)+2;
					component.set("v.maxCol", numOfCol);
					
					//setting labels:
					/*
					giovanni spinelli - START - 28/08/201
					loop on the unique label on child items
					push on tmp array
					sort by blank space
					and switch on uniqueLabels[] array
					*/
					for(var i = 0; i<listToSort.length; i++)
					{
						for(var k = 0; k<listToSort[i].childItems.length; k++)
						{
							var childItem = listToSort[i].childItems[k];   
							var childItem = listToSort[i].childItems[k];
							console.log('childItem.uniqueLabels: ', childItem.uniqueLabels);
							console.log('childItem.uniqueLabels.length: ', childItem.uniqueLabels.length);
							tmpUniqueLabel.push(JSON.parse(JSON.stringify(childItem.uniqueLabels)));
						}
						listToSort[0] = contextOutput.cart[j];
						break;	
					}
					tmpUniqueLabel.sort(function (a, b) {
						var tmpA = a.filter(
							function (value) {
								if (value != ' ') {
									return true;
								}
							});
						var tmpB = b.filter(
							function (value) {
								if (value != ' ') {
									return true;
								}
							});
		
						return tmpB.length - tmpA.length;
					});
					for (var i = 0; i < tmpUniqueLabel.length; i++) {
						var currentLabel = tmpUniqueLabel[i];
						for (var j = 0; j < currentLabel.length; j++) {
							if (uniqueLabels[j] == ' ' || !uniqueLabels[j]) {
								uniqueLabels[j] = currentLabel[j];
							} else {
								if (JSON.stringify(uniqueLabels).indexOf(currentLabel[j]) == -1) {
									uniqueLabels[j] = uniqueLabels[j] + '/ ' + currentLabel[j];
								}
							}
						}
					}
					console.log('LABEL ARRAY: ', uniqueLabels);
					component.set("v.uniqueLabels", uniqueLabels);
					//giovanni spinelli - END - 28/08/201
					break; //08/10/19 francesca.ribezzi avoid never-ending loop 
			
				}
			}			
		}
		/*************************************************************************************************************************/
		//end 
        //START francesca.ribezzi 11/09/2018 get child items from cart after configuring item
        if(itemToConfigure != null || itemToConfigure != undefined){
              
            for(var j=0; j<contextOutput.cart.length; j++)
            {   
            
            	//check to get teh correct id to check if we are in a post checkout or not
		        var cartId;
				var ItemIdToAdd; 
				
				if(itemToConfigure.id != undefined && itemToConfigure.id != null && itemToConfigure.id != ''){
					cartId = contextOutput.cart[j].id;
					ItemIdToAdd = itemToConfigure.id
				}
				else{
					cartId = contextOutput.cart[j].fields.id;
					ItemIdToAdd = itemToConfigure.fields.id;
				}
				//END
             
            	if(cartId==ItemIdToAdd && contextOutput.cart[j].fields.type == "Product")
                {  
                    for(var i = 0; i <contextOutput.cart[j].childItems.length; i++)
                    {
                       
                       if(contextOutput.cart[j].childItems[i].fields.visible==true || contextOutput.cart[j].childItems[i].fields.visible=='true')
                       {
                          //listOfFamilies = contextOutput.cart[j].childItems[i].listOfFamilies;
                          	for(var k= 0; k<contextOutput.cart[j].childItems[i].listOfFamilies.length; k++)
							{
								if((contextOutput.cart[j].childItems[i].listOfFamilies[k].fields.hidden!='true' && contextOutput.cart[j].childItems[i].listOfFamilies[k].fields.hidden!=true))
								{
									listOfFamilies.push(contextOutput.cart[j].childItems[i].listOfFamilies[k]);
									
								}					   
							}
                        	for(var z= 0; z<contextOutput.cart[j].childItems[i].listOfAttributes.length; z++){

									var attr =  contextOutput.cart[j].childItems[i].listOfAttributes[z];
									if(attr.fields.hidden!='true' && attr.fields.hidden!=true)
									{
										listOfAttributes.push({
										   attribute: attr //contextOutput.cart[j].childItems[i].listOfAttributes[z]
										});
									}		
								//}
								//else{
									//_utils.debug("z Attribute hidden");
								//}
                            }
                                               
                         if(contextOutput.cart[j].childItems[i].fields.cartDescription != '' && contextOutput.cart[j].childItems[i].fields.cartDescription != null){
                            //_utils.debug("cartDescription is not empty");
                            //push cartDescription field instead of description
                            listOfItems.push({
                                productname: contextOutput.cart[j].childItems[i].fields.productname,
                                description: contextOutput.cart[j].childItems[i].fields.cartDescription,
                                listOfAttributes: listOfAttributes,
                                listOfFamilies:listOfFamilies,
                                item:contextOutput.cart[j].childItems[i]
                            });
                             
                            listOfAttributes = [];
                            listOfFamilies =[];
                            
                         }
                         else{
                            listOfItems.push({
                                productname: contextOutput.cart[j].childItems[i].fields.productname,
                                description: contextOutput.cart[j].childItems[i].fields.description,
                                listOfAttributes: listOfAttributes,
                                listOfFamilies:listOfFamilies,
                                item:contextOutput.cart[j].childItems[i]
                                });
        					listOfAttributes = [];
                            listOfFamilies =[];
                         }
                    }
                    else{
                    	//_utils.debug("there are some childItems that are not visible!");
                    }
                    }
                }   
        	}
        	 
        	//OB_Sequence__c
        	//sort by sequence first....
			listOfItems.sort(function(a, b){
				return a.item.fields.OB_Sequence__c == b.item.fields.OB_Sequence__c ? 0 : +(a.item.fields.OB_Sequence__c > b.item.fields.OB_Sequence__c) || -1;
			});
        	
        	_utils.debug("listOfItems",listOfItems);
        	 
        	component.set("v.listOfItems", listOfItems);
        }       
        // firing updateContextEvent event to parent OB_FlowCart that enables next button:
		//START EVENT 
		var updateContextEvent = $A.get("e.c:OB_CustomUpdateContextEvent");
		updateContextEvent.setParams({ "disabledNextBtn": false});
		updateContextEvent.fire();
		//_utils.debug("FIRING OB_CustomUpdateContextEvent to enable next button");
		//END event 
	        /*
	        else{
	        	 listOfItems.push({
                                productname: 'Nessun attributo disponibile per questo prodotto',
                                description: '',
                                listOfAttributes: '',
                                listOfFamilies:'',
                                item:''
                                });
                 component.set("v.listOfItems", listOfItems);                             
	        	 component.set('v.spinner',false);
	        }
			*/
        //END
        
        //_utils.debug('updateCartList cart: ' + JSON.stringify(contextOutput.cart));

        //Adding offer (mind that everytime we add a new attribute below, you add it here with null value)
        //Marco.Ferri 
        items.push({
        	productName: offerta,
            qty: ''
        });
        //get custom label
		var offerLabel = $A.get("$Label.c.OB_Offerta");
		
		cartList.push({
			categoryName: offerLabel,
			items: items,
		});
        
        //var childItems = cart.childItems;
        //_utils.debug('updateCartList childItems: ' + JSON.stringify(childItems));
   
        //if there are no object in the cart for everyone of them i get their attributes
        if(contextOutput.cart.length > 1){
        
            for(var i=0;i<contextOutput.cart.length;i++){
                items = [];
                var categoryName = contextOutput.cart[i].fields.categoryname;
                var productName = contextOutput.cart[i].fields.productname;
                var qty = contextOutput.cart[i].fields.qty;
                var recordTypeName = contextOutput.cart[i].fields.RecordTypeName;
                var status = contextOutput.cart[i].fields.status;
                
                //check if an offer is already into cart
                if(productName == offerta){
                	continue;
                }
                
                //update total based on current qty
                cartListTotal += (1*qty);
                
                var result = cartList.filter(obj => {
                    return obj.categoryName === categoryName
                });
                if(result.length !=0){
                    if(result[0].items.length != undefined){
                        for(var j=0; j<result[0].items.length;j++){
                            items.push({
                            	productName: result[0].items[j].productName,
                            	qty: result[0].items[j].qty,
                            	recordTypeName : result[0].items[j].recordTypeName,
                            	status : result[0].items[j].status,
                            });
                        }
                    }
                    else items.push(result[0].items);
                    //add every attribute we need to the array items
                     items.push({
                        productName: productName,
                        qty: qty,
                        recordTypeName : recordTypeName,
                        status: status,
                    });
                    //----------------------------------------------
                    var index = cartList.findIndex(x => x.categoryName==categoryName);
                    cartList[index].items = items;
                }
                else{
                	//add every attribute we need to the array items
                    items.push({
                        productName: productName,
                        qty: qty,
                        recordTypeName : recordTypeName,
                        status: status,
                    });
                    //----------------------------------------------
                    cartList.push({
                        categoryName: categoryName,
                        items: items,
                    });
                }
            }
        }
        
       // _utils.debug("MarkCartJSON"+JSON.stringify(cartList));
       component.set('v.cartListTotal',cartListTotal);  
       component.set('v.cartList',cartList);             
    },
 
    addBancomatToCart: function(component){
       //_utils.debug("into addBancomatToCart");
       var item;
	   var coreOutput = component.get("v.contextOutput");
       var offertChildList = coreOutput.listOfItems;
       //_utils.debug(" coreOutput.listOfItems",  coreOutput.listOfItems);
       var cart = coreOutput.cart;
        //_utils.debug(" cart",  cart);
        /* Francesca.Ribezzi --> getting all bancomat items*/
        for(var i=0;i<offertChildList.length;i++){
        	item = offertChildList[i];
        	for(var j= 0; j < cart.length; j++){
        		if(cart[j].fields.catalogitemid == item.fields.catalogitemid){
        			//_utils.debug("pagobancomat is already in cart!");
        			component.set("v.itemToConfigure", cart[j]);
			        //component.set("v.configuredItem", true);
			        //var itemToConfigure = component.get("v.itemToConfigure");
			        
			        /*
			        var addRemoveFromCart = 	$A.get("e.NE:Bit2win_Event_AddRemoveFromCart");  
	                //before launching addRemoveFromCart to configure the item
	               // _utils.debug("before launching addRemoveFromCart to configure the item");
	        		addRemoveFromCart.setParams({
	        			 "item": itemToConfigure,
	   					//"mapOfItems": +{...},
	    				//"catalogId":  itemToConfigure.fields.catalogid,
	    				"action": "modify",
	    				//"categoryId": itemToConfigure.fields.categoryid,
	    				"typeOfAdd": "multiAdd" 
	        		});
	        		addRemoveFromCart.fire();
					*/
	        		//component.set('v.itemAddedToCart',true); 
			        //component.set("v.configuredItem", false); 
			        
			        component.set('v.contextOutput',coreOutput);
					//francesca.ribezzi firing updateContextEvent event to parent OB_FlowCart
					//START EVENT 
					var updateContextEvent = $A.get("e.c:OB_CustomUpdateContextEvent");
					updateContextEvent.setParams({ contesto: coreOutput});
		        	updateContextEvent.fire();
		        	//END event
		        	
		        	//check changes in min max qty
		        	this.checkMinMaxQtyBundleStep(component,event,coreOutput);
		        	 	
		        	//var configuredItem = component.get("v.configuredItem");		
	
	        		//var itemToConfigure = component.get("v.itemToConfigure");
	        		
	        	
	                //after firing addRemoveFromCart to configure the item
	                //_utils.debug("after firing addRemoveFromCart to configure the item");
	        		//component.set("v.configuredItem", false);
	        		// component.set('v.spinner',false);
	        		
	        		this.updateCartList(component);
	        		
	        		component.set('v.spinner',false);
	        		component.set('v.endLoading',true);	
			         
        			break;
        		
        		}

        	}
        	
        }

    },
    
    removeFakeItem : function(component){
    	
    	_utils.debug("into removeFakeItem");
    	var itemToRemove = component.get("v.itemFakeToRemove");
    	if(itemToRemove != null){
	    	//call event
	    	var configureAppEvent 	= 	$A.get("e.NE:Bit2win_Event_AddRemoveFromCart");
		        configureAppEvent.setParams({
		                'item'	: 	itemToRemove,
		                'action' : 	'remove',
		            });
		    configureAppEvent.fire();
	    	
	    	//wonderful updateContext happenz, will need boolean to understand where to go next...
	    	component.set("v.isItemFakeToRemove", true);
    	}
    },    

    /*   
	checkItemValueApprovalRules : function(component,event,attributeFields,valueToCheck,input,errorIndex,isAuraId){    
	    
	    //_utils.debug("into checkItemValueApprovalRules"); 
		//_utils.debug("attributeFields",attributeFields); 
	    
		var minAbsolute = parseFloat( (''+attributeFields.OB_MIn_Absolute__c).replace(',','.')); //DO NOT CORRECT it is REALLY like that 
		var maxAbsolute =  parseFloat((''+attributeFields.OB_Max_Absolute__c).replace(',','.'));
		var minThreshold =  parseFloat((''+attributeFields.OB_Min_Threshold__c).replace(',','.'));
		var maxThreshold =  parseFloat((''+attributeFields.OB_Max_Threshold__c).replace(',','.'));

		var maxPrice =  parseFloat((''+attributeFields.OB_Massimale__c).replace(',','.'));
		var status;
		
		valueToCheck = parseFloat( (''+valueToCheck).replace(',','.') );
		
		//_utils.debug("valueToCheck"+ valueToCheck);
		
		var numInputError = component.get("v.numInputError");
		var numInputWarning = component.get("v.numInputWarning");  
		var checkAttributeRulesToSendOLD = component.get("v.checkAttributeRules");
		
		var classCheckError;
		var classCheckWarning; 
		
		//START checking rules	
		if( !isNaN(minAbsolute) && valueToCheck < minAbsolute){
			//red error
			status = 'error';
			if(isAuraId){
				classCheckError = $A.util.hasClass(input,'borderError');
				classCheckWarning = $A.util.hasClass(input,'borderWarning');
			}
			else{
				classCheckError = input.classList.contains("borderError");
				classCheckWarning = input.classList.contains("borderWarning");
			}
			
			numInputError++;
			
			if(classCheckError){
				numInputError--;
			}

			if(numInputWarning != 0 && classCheckWarning){
				numInputWarning--;
			}
			component.set('v.checkAttributeRules',status);
		}
		else if( !isNaN(maxAbsolute) && valueToCheck > maxAbsolute){
			//red error
			status = 'error';
			if(isAuraId){
				classCheckError = $A.util.hasClass(input,'borderError');
				classCheckWarning = $A.util.hasClass(input,'borderWarning');
			}
			else{
				classCheckError = input.classList.contains("borderError");
				classCheckWarning = input.classList.contains("borderWarning");
			}
			
			numInputError++;
			
			if(classCheckError){
				numInputError--;
			}

			if(numInputWarning != 0 && classCheckWarning){
				numInputWarning--;
			}
			component.set('v.checkAttributeRules',status);
		}
		else if( !isNaN(maxPrice) && valueToCheck > maxPrice){
			//red error
			status = 'error';
			if(isAuraId){
				classCheckError = $A.util.hasClass(input,'borderError');
				classCheckWarning = $A.util.hasClass(input,'borderWarning');
			}
			else{
				classCheckError = input.classList.contains("borderError");
				classCheckWarning = input.classList.contains("borderWarning");
			}
			
			numInputError++;
			
			if(classCheckError){
				numInputError--;
			}

			if(numInputWarning != 0 && classCheckWarning){
				numInputWarning--;
			}
			component.set('v.checkAttributeRules',status);
		}
		else if( !isNaN(minThreshold) && valueToCheck < minThreshold){
			//yellow error
			status = 'warning';
			//_utils.debug("borderError? "+input.classList.contains("borderError"));
			if(isAuraId){
				classCheckError = $A.util.hasClass(input,'borderError');
				classCheckWarning = $A.util.hasClass(input,'borderWarning');
			}
			else{
				classCheckError = input.classList.contains("borderError");
				classCheckWarning = input.classList.contains("borderWarning");
				
			}
			if(numInputError != 0 && classCheckError){
				numInputError--;
			}
			
			numInputWarning++;
			
			if(numInputError != 0 && classCheckWarning){
				numInputWarning--;
			}
			if(checkAttributeRulesToSendOLD == 'error' && numInputError == 0){
				component.set('v.checkAttributeRules',status);
			}
		}
		else if( !isNaN(maxThreshold) && valueToCheck > maxThreshold){
			//yellow error
			status = 'warning';
			if(isAuraId){
				classCheckError = $A.util.hasClass(input,'borderError');
				classCheckWarning = $A.util.hasClass(input,'borderWarning');
			}
			else{
				classCheckError = input.classList.contains("borderError");
				classCheckWarning = input.classList.contains("borderWarning");
				
			}
			if(numInputError != 0 && classCheckError){
				numInputError--;
			}

			numInputWarning++;
			
			if(numInputError != 0 && classCheckWarning){
				numInputWarning--;
			}
			if(checkAttributeRulesToSendOLD == 'error' && numInputError == 0){
				component.set('v.checkAttributeRules',status);
			}
		}
		else{
			status = 'ok';
			if(isAuraId){
				classCheckError = $A.util.hasClass(input,'borderError');
				classCheckWarning = $A.util.hasClass(input,'borderWarning');
			}
			else{
				classCheckError = input.classList.contains("borderError");
				classCheckWarning = input.classList.contains("borderWarning");
			}
			if(numInputError != 0 && classCheckError){
				numInputError--;
			}
			if(numInputWarning != 0 && classCheckWarning){
				numInputWarning--;
			}
			if(numInputWarning == 0 && numInputError == 0 ){
				component.set('v.checkAttributeRules',status);
			}
		}
		
		//set graphic rules and warning colors
		this.setGraphicBorders(component,event,input,errorIndex,status,isAuraId);
		
		//_utils.debug("checkAttributeRulesToSendOLD "+ checkAttributeRulesToSendOLD);
		//_utils.debug("numInputError "+ numInputError);
		//_utils.debug("checkAttributeRulesToSend "+ checkAttributeRulesToSend);
		
		//firing approvalOrderRulesEvent event to parent OB_FlowCart
		var checkAttributeRulesToSend = component.get("v.checkAttributeRules");
		
		//Rules to send the frigging event
	 	if(numInputError > 0){
	 		
	 		status = 'error'; 
	 		//START EVENT 
			var approvalOrderRulesEvent = $A.get("e.c:OB_ApprovalOrderRulesEvent");
			approvalOrderRulesEvent.setParams({ 
				"checkAttributeRules": status
			});
	    	approvalOrderRulesEvent.fire();
	    	//END event 
	    	
	    	component.set('v.checkAttributeRules',status);
	 	}
	 	else if(numInputError == 0 && numInputWarning >0 ){
	 		
	 		status = 'warning';
	 		
	 		//START EVENT 
			var approvalOrderRulesEvent = $A.get("e.c:OB_ApprovalOrderRulesEvent");
			approvalOrderRulesEvent.setParams({ 
				"checkAttributeRules": status
			});
	    	approvalOrderRulesEvent.fire();
	    	//END event 
	    	component.set('v.checkAttributeRules',status);
	 	}
	 	else if(numInputError == 0 && numInputWarning == 0 ){
	 		
	 		status = 'ok';
	 		
	 		//START EVENT 
			var approvalOrderRulesEvent = $A.get("e.c:OB_ApprovalOrderRulesEvent");
			approvalOrderRulesEvent.setParams({ 
				"checkAttributeRules": status
			});
	    	approvalOrderRulesEvent.fire();
	    	//END event 
	 		component.set('v.checkAttributeRules',status);
	 	}

	 	component.set("v.numInputError",numInputError);
	 	component.set("v.numInputWarning",numInputWarning);  
	 },
	 
	 setGraphicBorders: function(component,event,input,errorIndex,status,isAuraId){ 
		 
		 //_utils.debug("isAuraId Graphic" +isAuraId);
		 //_utils.debug("status" +status);
		  
		 if(status == 'error'){
   			 if(isAuraId){
   				  if($A.util.hasClass(input,'borderError')){
   					  $A.util.remove(input,"borderError");
   				  }
   				  if($A.util.hasClass(input,'borderWarning')){
   					  $A.util.remove(input,"borderWarning");
   				  }
   				  
   				  $A.util.addClass(input, 'borderError');
   			 }else{
   				 
   				 input.classList.remove("borderError");
   				 input.classList.remove("borderWarning");
   				 input.classList.add("borderError");
   			 }
   		 }
   		 else if(status == 'warning'){
   		     if(isAuraId){
   				  if($A.util.hasClass(input,'borderError')){
   					  $A.util.remove(input,"borderError");
   				  }
   				  if($A.util.hasClass(input,'borderWarning')){
   					  $A.util.remove(input,"borderWarning");
   				  }
   				$A.util.addClass(input,'borderWarning');
   			 }else{
   				input.classList.remove("borderError");
   				input.classList.remove("borderWarning");
   				input.classList.add("borderWarning");
   			 }	
   		 }
   		 else{
   			//OK! clear all errors
   			 if(isAuraId){
				  if($A.util.hasClass(input,'borderError')){
					  $A.util.remove(input,"borderError");
				  }
				  if($A.util.hasClass(input,'borderWarning')){
					  $A.util.remove(input,"borderWarning");
				  }
			 }
			 else{
   				input.classList.remove("borderError");
   				input.classList.remove("borderWarning");
   			 }		  
   		 }
	 },
	 
	 getInputsToCheck : function(component,event, listToCheck, auraIdName){
	   	//_utils.debug("into getWarningInputs");
        //var pos = component.get("v.posList");
        //auraIdName == VAS||POS||ACQ||Bancomat 
        var input;
        var valueToCheck;
        var attributeFields; 
        var errorIndex;
        var item;
        
        //_utils.debug("listToCheck",listToCheck);
        
        //_utils.debug("auraIdList length: " + auraIdList.length);
    	var index = 0;
    	   for(var i = 0; i<listToCheck.length; i++){    		   		
    		   for(var x=0; x<listToCheck[i].item.listOfAttributes.length; x++){
			    		if( (listToCheck[i].item.listOfAttributes[x].fields.readonly != true || listToCheck[i].item.listOfAttributes[x].fields.readonly != 'true') && listToCheck[i].item.listOfAttributes[x].fields.value != ''){
				    		var auraIdList = component.find(auraIdName+'AuraId');

				    		item = listToCheck[i].item.listOfAttributes[x];
				    	
				    		input = auraIdList[index];
				    		index++;
				    		//_utils.debug(" input!!!!!!!!! ", input);
				    		valueToCheck = item.fields.value;
				    		attributeFields = item.fields;  //!index+'_'+index2+'_POS'
				    		//errorIndex = document.getElementById(j+'_'+x+'_'+auraIdName+'_'+i+'_error'+auraIdName);
				    		//_utils.debug(" FR# composed ID:  " + j+'_'+x+'_POS_'+i+'_errorPOS');
				    		//_utils.debug(" FR# errorIndex pos: " , errorIndex);
				    		var isAuraId = true;
				    		if(input != null && input != undefined && input != '' && valueToCheck != '' && valueToCheck != null  ){
				    			this.checkItemValueApprovalRules(component,event,attributeFields,valueToCheck,input,errorIndex,isAuraId);
				    		}
				    	}
			    	}   
		   }
    },
	*/

	 //28-11-18 - francesca.ribezzi 
	 createAttribute: function(listToCheck, category){

    	_utils.debug("into createAttribute");
    	//_utils.debug("listToCheck.length: " + listToCheck.length);
    	//_utils.debug("category: ",category);
    	//creating a map categoryName, index (index of displaying sequence):
    	var categoriesMap = {}; 
    	for(var key in category){
    		categoriesMap[category[key]] = key;
    	}
    	if($A.util.isEmpty(categoriesMap)){
    		return listToCheck;
    	}
    	else{
	    	if(listToCheck.length > 0){
	    		//_utils.debug("before calling enrichAttribute..");
	    		 return this.enrichAttribute(listToCheck, categoriesMap);
	    	}
	    }
	    
    },

    //28-11-18 - francesca.ribezzi 	 	 
	 enrichAttribute : function(listToSort, categoriesMap){
    	_utils.debug("into enrichAttribute...");
    	var listOfItems = [];
    	for(var i = 0; i<listToSort.length; i++){
    		listToSort[i].listOfChildItems = [];						
    		listToSort[0].numOfCol = 3;
    		listToSort[0].commissionColSize = 1;
    		var pagobancomatRecordType = "Pagobancomat";
			for(var j = 0; j<listToSort[i].childItems.length; j++){
				for(var k = 0; k<listToSort[i].childItems[j].listOfAttributes.length; k++){
					var att = listToSort[i].childItems[j].listOfAttributes[k];
						
					//TODO: change attributeCode to OB_attribute_code:
					var attributeCode = att.fields.attributeCode.toLowerCase();
					
					/*
					giovanni spinelli - START - 28/08/2019
					add  'importo' value as a commission
					*/
					att.commission = (attributeCode.indexOf('importo 2') != -1) ||(attributeCode.indexOf('importo 1') != -1) || (attributeCode.indexOf('scaglione') != -1) || (attributeCode.indexOf('indifferenziata') != -1) ;
					//giovanni spinelli - END - 28/08/2019
					//_utils.debug("before if attributeCode: " + attributeCode);
					//_utils.debug("att.commission: " + att.commission);
					if(att.commission){
						listToSort[i].childItems[j].commission = true;
						att.displaySequence = categoriesMap['COMMISSIONE'];
						var index = att.fields.attributeCode.indexOf(':');
						//_utils.debug("attributeCode: " + att.fields.attributeCode);
						var commissionSequence = att.fields.attributeCode.substring(index-1, index);
						
						//_utils.debug("@@@index: " + index);
						if(isNaN(commissionSequence)){
							commissionSequence = 4;
						}
						//_utils.debug("@@@commissionSequence: " + commissionSequence);
						//_utils.debug('att.displaySequence' + att.displaySequence);
						switch(att.fields.name){
							case 'Commissione':
								att.displaySequence= parseInt(att.displaySequence) + parseFloat(0.01+parseInt(commissionSequence)/10);
							//	att.fields.value = '10';
								break;
							/*
							giovanni spinelli - START - 28/08/2019
							add case to manage the 'importo' value in frontend
							*/
							case 'Importo':
								att.displaySequence= parseInt(att.displaySequence) + parseFloat(0.01+parseInt(commissionSequence)/10);
								break
							//giovanni spinelli - END - 28/08/2019
							case 'da': 
								att.displaySequence=parseInt(att.displaySequence) + parseFloat(0.02+parseInt(commissionSequence)/10);
								//att.fields.value = '10';
								if(!$A.util.isEmpty(att.fields.value)){
									listToSort[0].commissionColSize = 3;
									listToSort[0].numOfCol = 5;
								}
								break;
							case 'a':
								att.displaySequence= parseInt(att.displaySequence) +parseFloat(0.03+parseInt(commissionSequence)/10);
								//att.fields.value = '10';
								break;
								
						}
						att.rowSequence = commissionSequence;
						//_utils.debug("@@@att.displaySequence: " + att.displaySequence);
					}else{
						att.displaySequence = categoriesMap[att.fields.OB_Attribute_Code__c];
					}
				}
			}
		}
    //	_utils.debug("categoriesMap: ", categoriesMap);
    	for(var i = 0; i<listToSort.length; i++){
			for(var j = 0; j<listToSort[i].childItems.length; j++){
				var localMap = JSON.parse(JSON.stringify(categoriesMap));
				
				for(var k = 0; k<listToSort[i].childItems[j].listOfAttributes.length; k++){
					var att = listToSort[i].childItems[j].listOfAttributes[k];
					//creating list of attributes		
					var attKey = att.fields.idfamily+'_'+att.fields.propid;
					
					
					if(localMap[att.fields.OB_Attribute_Code__c] != undefined){		
						delete localMap[att.fields.OB_Attribute_Code__c];
					}else if(att.commission && localMap['COMMISSIONE'] != undefined && att.fields.OB_Attribute_Code__c != ''){
						delete localMap['COMMISSIONE'];
					}
				}
			//	_utils.debug("listToSort[0].commissionColSize: " + listToSort[0].commissionColSize);
				for(var key in localMap){
					var tmpAttr = {};
					tmpAttr.displaySequence = localMap[key];
					tmpAttr.virtualAttribute = true;
					if(key == 'COMMISSIONE'){
						tmpAttr.commission = true;
					}
					tmpAttr.fields = {"value" : null, "name" : "fake"};
					/*
					giovanni spinelli - START - 28/08/2019
					add if condition to manage the addition of new columns
					when they are empty columns
					*/
					if(tmpAttr.commission){
						for(var z = 0; z < parseInt(listToSort[0].commissionColSize); z++){
						listToSort[i].childItems[j].listOfAttributes.push(tmpAttr);
						}
					}else{
						listToSort[i].childItems[j].listOfAttributes.push(tmpAttr);
					}
					//giovanni spinelli - END - 28/08/2019	
				}
			//	_utils.debug("before filteredAttributes");
				var filteredAttributes = listToSort[i].childItems[j].listOfAttributes.filter(function(element){
					return (!$A.util.isEmpty(element.fields.value) || element.fields.name == 'fake'); //        || element.displaySequence == undefined
				}).sort(function(a, b){
					return a.displaySequence == b.displaySequence ? 0 : +(a.displaySequence > b.displaySequence) || -1;
				});
				listToSort[i].childItems[j].listOfAttributes = filteredAttributes;

			//	_utils.debug("after filteredAttributes");

				var childItem = this.createListOfItems(listToSort[i].childItems[j]);
				listToSort[i].listOfChildItems.push(childItem);
		
			}
		}

    	_utils.debug("@@@listToSort: ", listToSort);

    	return listToSort;
    },
	
	createListOfItems : function(childItem, component){
    	
    //	var emptyObj = {};
    //	emptyObj.productname = childItem.fields.productname;
    //	emptyObj.listOfAttributes = [];
    //	emptyObj.listOfFamilies = [];
		var attributeLabelsList = [];
    	
    	var needGrid = true; 
    	for(var i = 0; i< childItem.listOfAttributes.length; i++){
    		//francesca.ribezzi - creating a list of all attributes' labels:
			//attributeLabelsList.push(childItem.listOfAttributes[i].fields.name);
			
    		if(childItem.listOfAttributes[i].commission && childItem.listOfAttributes[i].fields.value != null && needGrid){
    			childItem.listOfAttributes[i].openGrid = true;
    			needGrid = false;
    		}else{
    			childItem.listOfAttributes[i].openGrid = false;
    		}
    		if(!childItem.listOfAttributes[i].commission && !needGrid && childItem.listOfAttributes[i].fields.value != null){
    			childItem.listOfAttributes[i].closeGrid = true;
    		}else{
    			childItem.listOfAttributes[i].closeGrid = false;
    		}
    		/*emptyObj.listOfAttributes.push({
    			"attribute": childItem.listOfAttributes[i]
    		});*/
    	}
    	//_utils.debug("attributeLabelsList: ", attributeLabelsList);
		childItem.uniqueLabels = [];
		//giovanni spinelli - START - 28/08/2019
		childItem.uniqueLabels = this.findLabels(childItem.listOfAttributes);    
		//giovanni spinelli - END   - 28/08/2019

	
		return childItem;

	},
	/**
	*@author Giovanni Spinelli <spinelli.giovanni@accenture.com>
	*@date 28/08/2019
	*@description Method create list of unique label sorted by decimal value 
	*@params listOfAttributes
	*@return array with sorted unique label to show when select a pos
	*/
	findLabels:function(listOfAttributes) {
		if(!listOfAttributes){
			return [];
		}
		var beforeDecimal =[];
		var insideDecimal =[];
		var afterDecimal =[];
		var currentArray = beforeDecimal;
		var maxDecimal = 999.99;
		for(var  i =0; i<listOfAttributes.length; i++){
			var displaySequence = listOfAttributes[i].displaySequence;
			if(displaySequence % 1 != 0){
				
				currentArray = insideDecimal;
				maxDecimal = displaySequence;
				var temp = displaySequence.toString();
				var lastNum = parseInt(temp[temp.length - 1]);
				displaySequence = parseInt(lastNum , 10 ) - 1;
				
			}else if(displaySequence < maxDecimal ){
				currentArray = beforeDecimal;
			}else if(displaySequence > maxDecimal){
				currentArray = afterDecimal;
				displaySequence = displaySequence - Math.ceil( maxDecimal );
			}
			var attributeName = listOfAttributes[i].fields.name;
			if(attributeName == 'fake'){
				attributeName = ' ';
			}else if(attributeName == 'Gratuità') {
				attributeName = 'Condizioni particolari/Mesi';
			}
			currentArray[displaySequence] = attributeName;
		}
		console.log('RETURN LABELS: ' , beforeDecimal.concat( insideDecimal ).concat( afterDecimal ));
		
		return beforeDecimal.concat( insideDecimal ).concat( afterDecimal );
		
	},
   checkMinMaxQtyBundleStep: function(component,event,coreOutput){
    	 	
    	var numOfCheckedItems = component.get("v.numOfCheckedItems");
    	var selectedBundle = component.get("v.selectedBundle"); //coreOutput.listOfBundles[i]--> i
    	var step = component.get("v.bundleStep");
    	var bundleMaxQty = component.get("v.bundleMaxQty");
    	var bundleMinQty = component.get("v.bundleMinQty");
    	var bundleMaxQtyToCheck = coreOutput.listOfBundles[selectedBundle].bundleElements[step].fields.maxqty;
    	var bundleMinQtyToCheck = coreOutput.listOfBundles[selectedBundle].bundleElements[step].fields.minqty;
    	
    	//_utils.debug("bundleMinQtyToCheck" + bundleMinQtyToCheck);
    	//_utils.debug("bundleMaxQtyToCheck" + bundleMaxQtyToCheck);
    	
    	if(bundleMaxQty != bundleMaxQtyToCheck){
    		component.set("v.bundleMaxQty",bundleMaxQtyToCheck);
    	}
    	if(bundleMinQty != bundleMinQtyToCheck){
    		component.set("v.bundleMinQty",bundleMinQtyToCheck);
    	}
    	
    	//_utils.debug("numOfCheckedItems" + numOfCheckedItems);
    	//_utils.debug("bundleMinQty" + component.get("v.bundleMinQty"));
    	//_utils.debug("bundleMaxQty" + component.get("v.bundleMaxQty"));
    	
    	if(numOfCheckedItems < component.get("v.bundleMinQty")){
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
	},
	/**
	*@author giovanni spinelli <spinelli.giovanni@accenture.com>
	*@date 19/09/2019
	*@description 	Method to reset default value on child item --> call the update context
					that calls again this method until the index is equal to list length
	*@params index: pass to update context
	*@return -
	*/
	resetValueEvent: function (component, event, index) {
		try{
			component.set('v.indexReset', index);
			component.set('v.spinner', true);
			var contextOutput = component.get("v.contextOutput");
			var listItemToreset = component.get('v.listItemToreset');
			var listLength = listItemToreset.length - 1;
			if (index <= listLength) {
				component.set('v.isToreset', true);
				component.set("v.itemToUpdate", listItemToreset[index]);
				var changeAttributeEvent = $A.get("e.NE:Bit2win_Event_AttributeChanged");
				changeAttributeEvent.setParams({
					'itemChanged': listItemToreset[index],
					'Context_Output': contextOutput
				});
				changeAttributeEvent.fire();
			} else {
				component.set('v.isToreset', false);
				component.set('v.spinner', false);
			}
		}catch(err){
			console.log(err.message);
		}
	}
})