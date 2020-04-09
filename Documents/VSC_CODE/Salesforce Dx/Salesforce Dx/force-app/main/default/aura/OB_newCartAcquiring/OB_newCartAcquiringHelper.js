({
	showBundleElement	: function(component,coreOutput){ 		//component,coreOut
    	_utils.debug('__showBundleElement ACQ');
		var productCategories = [];
		var enableNextButton = false;
		var numOfCheckedItems = 0;//component.get('v.numOfCheckedItems');
		
        // create main block       
		for(var i in coreOutput.listOfCategories)
		{
			if(i!= 0 && (coreOutput.listOfCategories[i].categoryFields.hidden == 'true' || coreOutput.listOfCategories[i].categoryFields.hidden == true))		
			// toAdd || root --> depth =0 , coreOutput.listOfCategories[0]
			{
				continue;	 
			}
			//_utils.debug(coreOutput.listOfCategories[i].categoryFields.name);
            //_utils.debug(coreOutput.listOfCategories[i].categoryFields.hidden);
            
			
			var listOfitems=[];
			for(var j in coreOutput.listOfItems){	
				if(coreOutput.listOfItems[j].fields.visible == 'true' || coreOutput.listOfItems[j].fields.visible == true ){
					if(coreOutput.listOfItems[j].fields.categoryid	==	coreOutput.listOfCategories[i].id){
						var checked = false;
						var qty = 0;
						for(var k in coreOutput.cart){
						//	_utils.debug(coreOutput.listOfItems[j].fields.itemCode+"____"+coreOutput.cart[k].fields.itemCode);	
							if(coreOutput.cart[k].fields.catalogitemid == coreOutput.listOfItems[j].fields.catalogitemid)
							{
								qty = coreOutput.cart[k].fields.qty;
								checked = true;
								component.set("v.itemToConfigure",coreOutput.cart[k]);
								//31/01/19 item checked as landing on page
								component.set("v.originItem", coreOutput.cart[k]);
								this.createRowAcquiringSummaryTable(component);
								//component.set("v.isFirstAdd",false); //NEW
							}	
						}
						//_utils.debug("checked????"+ checked);
						listOfitems.push({
							item: coreOutput.listOfItems[j],
							checked: checked								
						});
					}
				}
			}
            if(listOfitems.length >0)
            {
            	//sort by sequence first....
            	listOfitems.sort(function(a, b){
					return a.item.fields.sequence == b.item.fields.sequence ? 0 : +(a.item.fields.sequence > b.item.fields.sequence) || -1;
				});
            	
            	//...then sort by alphabet asc if same sequence number
            	listOfitems.sort(function(a, b){
				    var nameA=a.item.fields.productname.toLowerCase(), nameB=b.item.fields.productname.toLowerCase();
				    if (nameA < nameB && a.item.fields.sequence == b.item.fields.sequence) 
				        return -1 
				    if (nameA > nameB && a.item.fields.sequence == b.item.fields.sequence)
				        return 1
				    return 0 //default return value (no sorting)
				});
              
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
		
		/*
		if(component.get("v.isCheckNextRequired") == true){
			if(!enableNextButton){
	        	// firing updateContextEvent event to parent OB_FlowCart. 
	        	//if there are no items checked, disable next button. Otherwise, enable it.
				//START EVENT 
				var updateContextEvent = $A.get("e.c:OB_CustomUpdateContextEvent");
				updateContextEvent.setParams({ "disabledNextBtn": true});
	        	updateContextEvent.fire();
	        	//_utils.debug("firing event to OB_FlowCart cmp to disable next button..");
	        	//END event 
	        }else{
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
        if(itemFakeToRemove != null || itemFakeToRemove != undefined){   	
        	this.removeFakeItem(component);	
    	}
    	else{
			//CALL DEDICATED HELPER FUNCTION -- Marco.Ferri
			this.updateCartList(component,coreOutput);
			component.set('v.spinner',false);
		}
    },   
    
     updateCartList: function(component){
        _utils.debug('into updateCartList'); 
        var cartList = [];
        var items = [];
        var contextOutput = component.get("v.contextOutput");
       // _utils.debug('updateCartList contextOutput: ' + JSON.stringify(contextOutput));
        //FROM OB_newCartBancomat get attributes for the single attribute
		var itemToConfigure = component.get("v.itemToConfigure");
		var originItem = component.get("v.originItem");
        //_utils.debug("itemToConfigure in updateCartList: ", itemToConfigure);	
        
        var listOfItems = [];
        var listOfAttributes = [];
        var listOfFamilies = [];
        var attributesParentList = [];
        var itemAddedToCart = component.get("v.itemAddedToCart");
        var itemRemovedFromCart = component.get("v.itemRemovedFromCart");
        
        var listOfCart = {};
        
         //fill it with all the bundleElements with length 0
        var selectedBundle = component.get("v.selectedBundle");
    	var bundleElementsLength = contextOutput.listOfBundles[selectedBundle].bundleElements.length;
    	for(var count = 0; count < bundleElementsLength; count++){
    		var keyToInsert = contextOutput.listOfBundles[selectedBundle].bundleElements[count].id;
    		listOfCart[keyToInsert] = 0;
    	}
        
        var cartListTotal = 0;
        
        /*************************************************************************************************************************/
		//adding logic to display child items and attributes correctly in markup!!!
		//francesca.ribezzi - adding 2 vars for displaying columns:
		var categoryCirc = component.get("v.categoryCircuit")
		var numOfCol = categoryCirc.length;
        var acquiringRecordType = "Acquiring";
        acquiringRecordType = acquiringRecordType.toLowerCase();
        var listToSort = [];
        
		//28/11/18 francesca.ribezzi - calling a new method to create the right grid and cols to display for childItems and attributes:
		//start
		// go ahead wit this block of code only if the user selects a pos:
			for(var j=0; j<contextOutput.cart.length; j++)
			{    
				if(contextOutput.cart[j].fields.RecordTypeName.toLowerCase() == acquiringRecordType)
				{
					listToSort.push(contextOutput.cart[j]);
					
				  /*  numOfCol = listToSort[0].numOfCol;
					_utils.debug("numOfCol: " + numOfCol);
					component.set("v.numOfCol", numOfCol);
					numOfCol =  parseInt(numOfCol)+2;
					component.set("v.maxCol", numOfCol);*/
					//listToSort[0] = contextOutput.cart[j];
				}
				
			}
			//_utils.debug("listToSort before calling createAttribute: ", listToSort);
			if(listToSort.length> 0){
				listToSort = this.createAttribute(listToSort,  component.get("v.categoryCircuit"));
			}
			if(listToSort.length> 0){
				if(listToSort[0].childItems.length> 0){
				    if(numOfCol < listToSort[0].childItems[0].listOfAttributes.length){
			        	  numOfCol = listToSort[0].childItems[0].listOfAttributes.length;
				    }
				}
			}
		   	component.set("v.numOfCol", numOfCol);
			numOfCol =  parseInt(numOfCol)+2;
			component.set("v.maxCol", numOfCol);	
			this.createRowAcquiringSummaryTable(component);
		/*************************************************************************************************************************/
		//end 
        
        if(itemToConfigure != null || itemToConfigure != undefined || itemRemovedFromCart){ //ToDo: check if itemRemovedFromCart
            
            
            //START TEST: parte commentata
           /* for(var j=0; j<contextOutput.cart.length; j++)
            {    
            	if(contextOutput.cart[j].fields.id==itemToConfigure.fields.id)
                { 
            		var qty = contextOutput.cart[j].fields.qty;
            		if(contextOutput.cart[j].childItems.length > 0){
                    for(var i = 0; i <contextOutput.cart[j].childItems.length; i++){
                        listOfFamilies = contextOutput.cart[j].childItems[i].listOfFamilies;
                        if(contextOutput.cart[j].childItems[i].listOfAttributes.length > 0){
                        	for(var z= 0; z<contextOutput.cart[j].childItems[i].listOfAttributes.length; z++){
                               listOfAttributes.push({
                            	   attribute: contextOutput.cart[j].childItems[i].listOfAttributes[z]
                               });
                            }
                        }
                       if(contextOutput.cart[j].childItems[i].fields.visible){	 
                    	   	var description;                	    
                    	    //description if/else
	                        if(contextOutput.cart[j].childItems[i].fields.cartDescription != ''){
	                            _utils.debug("cartDescription is not empty");
	                            //push cartDescription field instead of description
	                            description = contextOutput.cart[j].childItems[i].fields.cartDescription;  
	                        }else{
	                            description = contextOutput.cart[j].childItems[i].fields.description;	
	                        }
	                        //end
	                        //make the push in the list and then empty the arrays for the next iteration
	                         listOfItems.push({
	                                productname: contextOutput.cart[j].childItems[i].fields.productname,
	                                description: description,
	                                listOfAttributes: listOfAttributes,
	                                listOfFamilies:listOfFamilies,
	                                qty:qty
	                        });
	                        
	                        listOfAttributes = [];
	                        listOfFamilies =[];
	                        
                        }else{
                        	//if the item is not visible dont push it in the list that will be in the view
                        }
                    }
                    }
                }   
        	} 
        	component.set("v.listOfAttributes", listOfAttributes);
        	_utils.debug("acquiring listOfItems: ", listOfItems);
        	component.set("v.listOfItems", listOfItems);
        */
        //END
        }
        
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
                
                //refresh Map from scratch
				var key = contextOutput.cart[i].fields.id+'_'+contextOutput.cart[i].fields.vid;
				var bundleElementKey = contextOutput.cart[i].fields.bundleElement;
				
				if( !($A.util.isEmpty(key)) &&  $A.util.isEmpty(listOfCart[key]) )
				{	 
					var tmpObj = {};
					tmpObj.cartItem = contextOutput.cart[i];
					tmpObj.qty = qty;
					tmpObj.status = contextOutput.cart[i].fields.status;
					tmpObj.bundleElement = bundleElementKey;
						
					listOfCart[key] = tmpObj;
					
					if($A.util.isEmpty(listOfCart[bundleElementKey])){
						listOfCart[bundleElementKey] = 1;										
					}
					else{
						var oldNum = listOfCart[bundleElementKey];
						listOfCart[bundleElementKey] = parseInt(oldNum)+1;
					}
				}

                
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
                    
                    //the item goes on list view only if the qty is > 0
                    if(items.qty != 0){ 
	                    cartList.push({
	                        categoryName: categoryName,
	                        items: items,
	                    });
                     }
                }
            }
        }
        //_utils.debug("MarkCartJSON"+JSON.stringify(cartList));
        
       /* if(itemAddedToCart){
        	this.createRowAcquiringSummaryTable(component);
        }*/
        else if(itemRemovedFromCart){
        	this.removeRowAcquiringSummaryTable(component);
        }
        component.set('v.listOfCartTotal',listOfCart);
        
        //check changes in min max qty
        this.checkMinMaxQtyBundleStep(component,event,contextOutput);
	  
		
        //component.set('v.spinner',false);      
        component.set('v.cartListTotal',cartListTotal); 
		component.set('v.cartList',cartList);       
		// ANDREA MORITTU START 19-Sept-2019 - EVO_PRODOB_452
		let isEditCommissionModel = component.get('v.isEditCommissionModel');
		let catalogItemCommission = component.get('v.catalogItemCommission');
		let stopAutomationCheckInputMethod = component.get('v.stopAutomationCheckInput');
		if(isEditCommissionModel && $A.util.isUndefinedOrNull(catalogItemCommission) && !stopAutomationCheckInputMethod ) {
			component.set('v.stopAutomationCheckInput' , true);
			this.automationCheckInput(component, event, contextOutput.cart, contextOutput.listOfItems);
		}
		// ANDREA MORITTU START 19-Sept-2019 - EVO_PRODOB_452
    },
    
    createRowAcquiringSummaryTable : function(component){ 	
            //add table acquiring 
            _utils.debug("into createRowAcquiringSummaryTable");
            var index = 0;
            var itemToConfigure = component.get("v.itemToConfigure");
            //_utils.debug("itemToConfigure in createRowAcquiringSummaryTable: " + JSON.stringify(itemToConfigure));
            
            //var acquiringCart = component.get("v.circuitiList"); 
            var acquiringCart = [];
            
            var categoryName = component.get("v.categoryCircuit");
            var contextOutput = component.get("v.contextOutput");
            var acquiringChildItems = [];
           
            //_utils.debug("contextOutput.cart", contextOutput.cart);
                        
            if(itemToConfigure != null){
	            for(var i = 0; i < contextOutput.cart.length; i++){
	            	//if(contextOutput.cart[i].id == itemToConfigure.id ){  
	            	if(contextOutput.cart[i].fields.RecordTypeName == 'Acquiring'){
	            		acquiringCart.push(contextOutput.cart[i]);
	            	//	break;
	            	}
	            }
	            //_utils.debug("acquiringCart",acquiringCart); 
	            component.set("v.circuitiList", acquiringCart);
            }  
         
            for(var i = 0; i < acquiringCart.length; i++){
            	if(acquiringCart[i].childItems.length > 0){
	            	for(var j= 0; j < acquiringCart[i].childItems.length; j++){
						//francesca.ribezzi 28/08/19 - hiddenincart condition deleted because this attribute is not used anymore 
	            		if(acquiringCart[i].childItems[j].fields.visible == "true" || acquiringCart[i].childItems[j].fields.visible == true){
							//START francesca.ribezzi 06/12/19 - perf-27 - setting readonly if the action is none
							if(!$A.util.isEmpty(acquiringCart[i].childItems[j].fields.action)){ 
								var action = acquiringCart[i].childItems[j].fields.action;
								acquiringCart[i].childItems[j].readOnly = action == 'None' ? true : false; 
							}
							//END francesca.ribezzi 06/12/19 - perf-27 
							acquiringChildItems.push(acquiringCart[i].childItems[j]);
	            		}
	            	}
	            }	
            }
            
            //_utils.debug("acquiringCart ",acquiringCart);
            //_utils.debug("acquiringChildItems ",acquiringChildItems);
            var maxIndex = 0;
            //if an attribute is hidden, it removes it from acquiringChildItems list.
            if(acquiringChildItems.length > 0){
            
            	acquiringChildItems.sort(function(a, b){
				return a.fields.OB_Sequence__c == b.fields.OB_Sequence__c ? 0 : +(a.fields.OB_Sequence__c > b.fields.OB_Sequence__c) || -1;
            	});                
            	
            	//_utils.debug("acquiringChildItems after visible check:", acquiringChildItems);
	            for(var i = 0; i< acquiringChildItems.length; i++){
	            	
	            	if(acquiringChildItems[i].listOfAttributes.length > 0){
			            for(var j = acquiringChildItems[i].listOfAttributes.length; j--;){  	
			            	if(acquiringChildItems[i].listOfAttributes[j].fields.hidden =="true" || acquiringChildItems[i].listOfAttributes[j].fields.hidden ==true)
			            	{
			            		acquiringChildItems[i].listOfAttributes.splice(j,1);
			            	}	
			            }    
				        var current = acquiringChildItems[i].listOfAttributes.length;
		            	if(acquiringChildItems[maxIndex].listOfAttributes.length < current){
		            		maxIndex = i;
		            	}
			        }
	           }
	           if(maxIndex != 0){ 
	        	   component.set("v.maxCategoriesIndex",maxIndex);
	           }
	           
	           component.set("v.acquiringChildItems", acquiringChildItems);
	          
	       }
	       component.set("v.acquiringChildItems", acquiringChildItems);
	       
	          
          
    },
    
    removeRowAcquiringSummaryTable : function(component){
           //_utils.debug("into removeRowAcquiringSummaryTable");
            //get item to configure
    		var item = component.get("v.itemToConfigure");
    		//_utils.debug("itemToConfigure: ", item);
    	    //_utils.debug("itemToConfigure id: " + item.id);
    		
    		var recordTypeCommissione = 'commissione';
    		
    		var recordTypeItem = item.fields.RecordTypeName.toLowerCase();
    		
    		if(recordTypeItem == recordTypeCommissione){
    			this.createRowAcquiringSummaryTable(component);	
    		}
    		else{    		
  
	            /* remove  table acquiring */
	            var circuitiList = component.get("v.circuitiList");
	            var acquiringChildItems = component.get("v.acquiringChildItems"); 
	            var index = 0;
	            
	            //if(acquiringChildItems.length > 0 || !($A.util.isEmpty(acquiringChildItems)) ){
	            for(var i = acquiringChildItems.length; i--;){
	            	 if(acquiringChildItems[i].fields.productcatalogitem == item.id){  
	            		 acquiringChildItems.splice(i,1); 
	            	 }
	            }
	            //} 
	            
	            acquiringChildItems.sort(function(a, b){
					return a.fields.OB_Sequence__c == b.fields.OB_Sequence__c ? 0 : +(a.fields.OB_Sequence__c > b.fields.OB_Sequence__c) || -1;
				});
	            
	            component.set("v.acquiringChildItems",acquiringChildItems);
	                
	            //28-11-18 francesca.ribezzi:  categoryCircuit is now set by attribute's default!!!    
	            //Recalculate categories for a remove of an item only if the number of attributes is the current max  
	       /*     if(acquiringChildItems.length > 0 || !($A.util.isEmpty(acquiringChildItems)) ){
	            	
	            	var currentMax = component.get("v.maxCategoriesIndex"); 
		            for(var j= 0; j < item.childItems.length; j++)
		            {
			            if( acquiringChildItems[currentMax].listOfAttributes.length < item.childItems[j].listOfAttributes.length)
			            {	
			            		var categoryName = [];
								for(var i = 0; i < acquiringChildItems[currentMax].listOfAttributes.length; i++)
								{ 
					    			var catName  =  acquiringChildItems[currentMax].listOfAttributes[i].fields.name;
									categoryName.push(catName);
						    	}
						    	component.set("v.categoryCircuit",categoryName);
						    	break;
			            }
			        }   
	            }*/
	            
	            if(circuitiList.length > 0){  
		            for(var i = 0; i < circuitiList.length; i++){
		            	//_utils.debug("MARK$: "+circuitiList[i].productName+ " == "+item.fields.productname);
		            	if(circuitiList[i].fields.productname == item.fields.productname){
		            		index = i;
		            		break;
		            	}
		            	else continue;	
		            }
		            circuitiList.splice(index,1);
		            component.set("v.circuitiList",circuitiList);
	            }
             }           
    },
    
    //calculating the number of columns to use in summary acquiring table by getting the maximum number of attributes an item could have.
  /*  createDynamicColumns : function(component,acquiringChildItems){
    	_utils.debug("into createDynamicColumns");
    	//var totalNumOfCol = component.get("v.numOfCol");
    	var totalNumOfCol = 0;
    	var rowNumOfCol = 0;
    	
    	//_utils.debug("acquiringChildItems.length "+acquiringChildItems.length);
    	//_utils.debug("acquiringChildItems createDynamicColumns: " , acquiringChildItems);
    	//acquiringChildItems[i].listOfAttributes[j].fields.name;
    	for(var i = 0; i<acquiringChildItems.length; i++){
    		//_utils.debug("list of Attributes length per childItem: " + JSON.stringify(acquiringChildItems[i].listOfAttributes.length));
			rowNumOfCol = parseInt(acquiringChildItems[i].listOfAttributes.length);
    		//_utils.debug(totalNumOfCol +" ==== "+ JSON.stringify(rowNumOfCol));
    		if(parseInt(totalNumOfCol) < rowNumOfCol){
    					totalNumOfCol = JSON.stringify(rowNumOfCol);
    		}
    		rowNumOfCol = 0;
    	}
    	//_utils.debug("totalNumOfCol is: " + totalNumOfCol);
    	//add 1 to totalNumOfCol-> space for productnames' column (es. Visa/Mastercard)
    	totalNumOfCol = JSON.stringify(parseInt(totalNumOfCol) + 1);
    	//_utils.debug("totalNumOfCol plus one: " + totalNumOfCol);
    	component.set("v.numOfCol", totalNumOfCol);
    },*/
    
    //this function checks if the products catalog is in need to be refreshed. 
    checkCatalogChanges: function(component, coreOutput){ 	
    	//_utils.debug("inside checkCatalogChanges");
    	component.set("v.spinner", true);
    	//var contextOutput = component.get("v.contextOutput");
    	//_utils.debug("contextOutput before checking length: ", coreOutput);
    	var contextListOfItems = [];
    	var productCategories = component.get("v.productCategories");
    	var categoryListOfItems = [];
    	for(var i = 0; i< productCategories.length; i++){
    		for(var j = 0; j<productCategories[i].items.length; j++){
    			categoryListOfItems.push(productCategories[i].items[j]);
    		}
    	}
		for(var i in coreOutput.listOfCategories){
			if(i!= 0 && (coreOutput.listOfCategories[i].categoryFields.hidden == 'true' || coreOutput.listOfCategories[i].categoryFields.hidden == true) )
			{
				continue;	
			}
			for(var j in coreOutput.listOfItems)
			{		
				if(coreOutput.listOfItems[j].fields.visible == true || coreOutput.listOfItems[j].fields.visible == 'true' )
				{
					if(coreOutput.listOfItems[j].fields.categoryid	==	coreOutput.listOfCategories[i].id)
					{	
						contextListOfItems.push(coreOutput.listOfItems[j]);
					}
				}
			}
		}
    	/*_utils.debug("categoryListOfItems: ", categoryListOfItems);
    	_utils.debug("categoryListOfItems: "+ categoryListOfItems.length);
    	_utils.debug("contextListOfItems: ", contextListOfItems);
    	_utils.debug("contextListOfItems: "+ contextListOfItems.length);*/
    	
    	this.handleRefreshCatalog(component,coreOutput);
    }, 
    		
    handleRefreshCatalog: function(component, coreOutput){ 	
		_utils.debug("handleRefreshCatalog is starting...");
		var productCategories = [];
		//_utils.debug("contextOutput.cart in handleRefreshCatalog: ", coreOutput.cart);
		//_utils.debug("contextListOfItems: ", contextListOfItems);
		 //CREATING PRODUCTCATEGORIES ATTRIBUTE:
		  
		//empty current list for recreation
        //component.set("v.acquiringChildItems",[]);
        //component.set("v.circuitiList",[]);
            
		for(var i in coreOutput.listOfCategories)
		{
			if(i!= 0 && (coreOutput.listOfCategories[i].categoryFields.hidden == 'true' || coreOutput.listOfCategories[i].categoryFields.hidden == true) )		
			// toAdd || root --> depth =0 , coreOutput.listOfCategories[0]
			{
				continue;	 
			}
			//_utils.debug(coreOutput.listOfCategories[i].categoryFields.name);
            //_utils.debug(coreOutput.listOfCategories[i].categoryFields.hidden);
                 
			var listOfitems=[];
			for(var j in coreOutput.listOfItems){	
				if(coreOutput.listOfItems[j].fields.visible == true || coreOutput.listOfItems[j].fields.visible == 'true'){
					if(coreOutput.listOfItems[j].fields.categoryid	==	coreOutput.listOfCategories[i].id){	
						var checked = false;
						for(var k in coreOutput.cart){
						//	_utils.debug(coreOutput.listOfItems[j].fields.itemCode+"____"+coreOutput.cart[k].fields.itemCode);
						//	_utils.debug('listofitem id: '+coreOutput.listOfItems[j].fields.productcatalogitem+"_______ cart id: "+coreOutput.cart[k].fields.id);
					//	console.log("cart item?: " + coreOutput.cart[k].fields.productname);
							if((coreOutput.cart[k].id ||coreOutput.cart[k].fields.id)  == coreOutput.listOfItems[j].fields.productcatalogitem){
								_utils.debug("product name?: " + coreOutput.cart[k].fields.productname);
								checked = true;
								
							}
						}
						//_utils.debug("checked in refresh???: " + checked);
						listOfitems.push({
							"item": coreOutput.listOfItems[j],
							"checked": checked								
						});
					}
				}
			}
            if(listOfitems.length >0)
            {
            
            	//sort by sequence first....
            	listOfitems.sort(function(a, b){
					return a.item.fields.sequence == b.item.fields.sequence ? 0 : +(a.item.fields.sequence > b.item.fields.sequence) || -1;
				});
            	
            	//...then sort by alphabet asc if same sequence number
            	listOfitems.sort(function(a, b){
				    var nameA=a.item.fields.productname.toLowerCase(), nameB=b.item.fields.productname.toLowerCase();
				    if (nameA < nameB && a.item.fields.sequence == b.item.fields.sequence) 
				        return -1 
				    if (nameA > nameB && a.item.fields.sequence == b.item.fields.sequence)
				        return 1
				    return 0 //default return value (no sorting)
				});
            
                productCategories.push({
                        categoryName	:	coreOutput.listOfCategories[i].categoryFields.name,
                        categorySequence:   coreOutput.listOfCategories[i].categoryFields.sequence,
                        items			:	listOfitems
                    
                });
            }	
		 }
		 // END CREATING
		 
		//here we sort by sequence the array of objects, Good luck understanding any of this :)
		productCategories.sort(function(a, b){
			return a.categorySequence == b.categorySequence ? 0 : +(a.categorySequence > b.categorySequence) || -1;
		});
		 
		component.set('v.productCategories',productCategories);
		// _utils.debug("productCategories after refreshing catalog: ", productCategories);
   	 },

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
			for(var j = 0; j<listToSort[i].childItems.length; j++){
				for(var k = 0; k<listToSort[i].childItems[j].listOfAttributes.length; k++){
					var att = listToSort[i].childItems[j].listOfAttributes[k];
						
					//TODO: change attributeCode to OB_attribute_code:
					var attributeCode = att.fields.attributeCode.toLowerCase();
					
					att.commission = (attributeCode.indexOf('scaglione') != -1) || (attributeCode.indexOf('indifferenziata') != -1) ;
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
								//att.fields.value = '10';
								break;
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
					for(var z = 0; z < parseInt(listToSort[0].commissionColSize); z++){
						listToSort[i].childItems[j].listOfAttributes.push(tmpAttr);
					}	
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
	
	createListOfItems : function(childItem){
    	
    //	var emptyObj = {};
    //	emptyObj.productname = childItem.fields.productname;
    //	emptyObj.listOfAttributes = [];
    //	emptyObj.listOfFamilies = [];

    	var needGrid = true; 
    	for(var i = 0; i< childItem.listOfAttributes.length; i++){
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
    	/*for(var i = 0; i< childItem.listOfFamilies.length; i++){
    		emptyObj.listOfFamilies.push({
    			"attribute": childItem.listOfFamilies[i]
    		});
    	}
		var description;
		var price;	  
		if(!$A.util.isEmpty(childItem.fields.cartDescription)){
			description = childItem.fields.cartDescription;
		}else{
			description = childItem.fields.description;	
		}
		if(childItem.fields.baserecurringcharge > 0){
			price = childItem.fields.baserecurringcharge;
		}else{
			price = childItem.fields.baseonetimefee;	
		}
		
		emptyObj.description = description;
		emptyObj.price = price;
		emptyObj.qty = childItem.fields.qty;
		emptyObj.item = childItem;*/
		
		return childItem;

    },
    
    checkMinMaxQtyBundleStep: function(component,event,coreOutput){
    	
    	_utils.debug("into checkMinMaxQtyBundleStep");
		//28/03/19 francesca.ribezzi adding alert var:
		var alert = coreOutput.sessionParameters.alert;
    	var listOfCart = component.get("v.listOfCartTotal");
		
    	var selectedBundle = component.get("v.selectedBundle"); //coreOutput.listOfBundles[i]--> i
    	var step = component.get("v.bundleStep");
    	var bundleMaxQty = component.get("v.bundleMaxQty");
    	var bundleMinQty = component.get("v.bundleMinQty");

    	var bundleElementKey = coreOutput.listOfBundles[selectedBundle].bundleElements[step].id;
    	//_utils.debug("listOfCart", listOfCart);
    	//_utils.debug("bundleElementKey " + bundleElementKey); 
    	var numOfCheckedItems = listOfCart[bundleElementKey];

		component.set('v.numOfCheckedItems',numOfCheckedItems); 
    	
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
		//28/03/19 francesca.ribezzi adding alert condition
    	if((numOfCheckedItems < component.get("v.bundleMinQty")) || alert){
	        	// firing updateContextEvent event to parent OB_FlowCart. 
	        	//if there are no items checked, disable next button. Otherwise, enable it.
				//START EVENT 
				var updateContextEvent = $A.get("e.c:OB_CustomUpdateContextEvent");
				updateContextEvent.setParams({ "disabledNextBtn": true});
	        	updateContextEvent.fire();
	        //	_utils.debug("firing event to OB_FlowCart cmp to disable next button..");
	        	//END event 
	        }else if(numOfCheckedItems >= component.get("v.bundleMinQty")){
				//TODO: if isEditCommissionModel and originItem == itemToConfigure -> disabled = true
				var disabled = false;
			//	var originItem = component.get("v.originItem");
				var itemToConfigure = component.get("v.itemToConfigure");
				
			/*	if(component.get("v.isEditCommissionModel") && (itemToConfigure.id == originItem.id)){
					disabled = true;
				}*/
				//START EVENT 
				var updateContextEvent = $A.get("e.c:OB_CustomUpdateContextEvent");
				updateContextEvent.setParams({ "disabledNextBtn": disabled});
	        	updateContextEvent.fire();
	        //	_utils.debug("firing event to OB_FlowCart cmp to enable next button..");
	        	//END event 
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
	//27/03/19 francesca.ribezzi adding showInfoToast function:
	showInfoToast: function(component, event, infoMessage, type, mode){
	    _utils.debug("into showInfoToast");
    	var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: '',
            message: infoMessage,
            //messageTemplateData: [name],
            duration: '5000',
            key: 'info_alt',
            type: type,
            mode: mode
        });
        toastEvent.fire();
	},

	/*
	*	Author		:	Morittu Andrea
	*	Date		:	19-Sept-2019
	*	Task		:	EVO_PRODOB_452
	*	Description	:	preset the model commission checkbox
	*/
	automationCheckInput : function(component, event, cartList, listOfItems) {
		debugger;
		console.log('cartList is : ' +  JSON.stringify(cartList));
		console.log('listOfItems is : ' +  JSON.stringify(listOfItems));

		let listOfModelCommission = [];

		try {
			if( !$A.util.isUndefined(listOfItems) && !$A.util.isEmpty(listOfItems) ) {
				for (let singleItem of listOfItems) {
					if(singleItem.fields.categoryname == 'MODELLI COMMISSIONALI') {
						listOfModelCommission.push(singleItem);
					}
				}
			}
	
			if(!$A.util.isUndefined(cartList) && !$A.util.isEmpty(cartList) ) {
				for(let singleItem of cartList) {
					if(singleItem.fields.categoryname == 'MODELLI COMMISSIONALI') {
						debugger;
						component.set('v.cartCommission', singleItem);
						break;
					}
				}
			}
	
			if(!$A.util.isUndefined(cartList) && !$A.util.isEmpty(cartList) && !$A.util.isUndefined(listOfModelCommission) && !$A.util.isEmpty(listOfModelCommission)) {
				let actualCommissionalItem = component.get('v.cartCommission');
				for(let commissionalModel of listOfModelCommission) {
					if(actualCommissionalItem.fields.catalogitemid != commissionalModel.fields.id ) {
						component.set('v.catalogItemCommission', commissionalModel);
					}
				}

				let configureAppEvent 	= 	$A.get("e.NE:Bit2win_Event_AddRemoveFromCart");
				configureAppEvent.setParams({
				'item'  :actualCommissionalItem,
				'action' :'remove',
				//'options' : requestOptions
											});
				configureAppEvent.fire();
				component.set('v.itemRemovedFromCart', true);


				
			}
		} catch(exc) {
			console.log('An Error has occured inside automationCheckInput : ' + exc.message );
		}
	},

	/*
	*	Author		:	Morittu Andrea
	*	Date		:	19-Sept-2019
	*	Task		:	EVO_PRODOB_452
	*	Description	:	preset the model commission checkbox
	*/

	updateCommissionModel : function(component, event, isEditCommissionModel, actualCommissionalItem) {
		debugger;
		let catalogItemCommission = component.get('v.catalogItemCommission');
		component.set('v.itemAddedToCart', true);
		component.set('v.itemRemovedFromCart', false);
		component.set('v.itemToConfigure', catalogItemCommission);
		
		this.onCheckByIncreaseQty(component,event,catalogItemCommission.fields.id, null);

	},

	/*
	*	Author		:	Morittu Andrea
	*	Date		:	19-Sept-2019
	*	Task		:	EVO_PRODOB_452
	*	Description	:	preset the model commission checkbox
	*/
	onCheckByIncreaseQty: function(component,event,itemId, itemQty){
		let catalogItemCommission = component.get('v.catalogItemCommission');
		if(!$A.util.isUndefined(catalogItemCommission) && !$A.util.isEmpty(catalogItemCommission)) {
			itemId = catalogItemCommission.fields.id;
		} 
    	var checkAttributeRules = component.get('v.checkAttributeRules');
    	var contextOutput = component.get('v.contextOutput');
        var selectedBundleId='';
        var isFirstAdd = component.get('v.isFirstAdd');
        var maxQty = component.get("v.qtyMax");

        if(checkAttributeRules != 'error'){
	        component.set("v.offertChildList", contextOutput.listOfItems);
	        
	        component.set("v.qtyEdit",false);
	        component.set("v.isCloseConf",false);
	        
	        component.set("v.qtyEditAfterFakeAdd",false);
	           
	        component.set("v.spinner", true);
	        var chkBoxVal = true;//event.getSource().get("v.checked");
	        var item;
	
	        var offertChildList = component.get('v.offertChildList');
	        
	        if(chkBoxVal){
	            //numOfCheckedItems++;      	
	            
	            for(var i=0;i<offertChildList.length;i++)
	            {
	                item = offertChildList[i];
		            if(item.id == itemId)
		            {
		            	break;
		            }  
	            }   
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
			}   
		}
	},
	/**
	*@author Giovanni Spinelli <spinelli.giovanni@accenture.com>
	*@date 20/09/2018
	*@description reset value on acquiring
	*@params -
	*@return 
	*/
	resetValueEvent : function(component, event, index){
		component.set( 'v.indexReset' , index);
		component.set('v.spinner',true);
		var contextOutput = component.get("v.contextOutput");
		var  listItemToreset = component.get('v.listItemToreset');
		var listLength = listItemToreset.length - 1;
		if ( index <= listLength  ) {
			component.set( 'v.isToreset' , true);
			component.set("v.itemToUpdate", listItemToreset[index]);
			var changeAttributeEvent = $A.get("e.NE:Bit2win_Event_AttributeChanged");
			changeAttributeEvent.setParams({
				'itemChanged': listItemToreset[index],
				'Context_Output': contextOutput
			});
			changeAttributeEvent.fire();
		}else{
			component.set( 'v.isToreset' , false);
			component.set('v.spinner',false);
		}
	
		
	},

		/*
	*	Author			:	Morittu Andrea
	*	Date			:	04-Oct-2019
	*	Task			:	EVO_BACKLOG_245
	* 	Description		:	overturn old values into new visa mastercard	
	*/
	overturnOldVISAMASTERCARDvalues_Helper : function(component, event, helper) {
		let cart = [];
		let tempMap = new Map();

		let tempObj = {};
		tempObj.itemAttributes = {};
		tempObj.itemAttributes = component.get('v.oldVMAttributes')[0]['Commissione Unica'];
		for(let [key, value] of Object.entries(tempObj.itemAttributes) ) {
			for(let [innerKey, innerValue] of Object.entries(value) ) { 
				switch (innerKey) {
					case ('Name'):
						tempMap[innerValue] = value.NE__Value__c;
					break;
				}
			}
		}
	
		if(tempMap) {
			tempObj.isError = false;
			
			
			let contextOutput = component.get('v.contextOutput');
			let VM_Attributes = [];
			cart = component.get('v.acquiringChildItems');
			
			console.log(JSON.stringify(component.get('v.contextOutput.cart')));
			//.fields[i].listOfAttributes[y].value && OB_Hidden__c OB_ReadOnly__c && readonly
			//OBCodiceSfd
			for(let i in cart) {
				for(let y in cart[i].listOfAttributes) {
					let mapValueByKey = tempMap[cart[i].listOfAttributes[y].fields.name];
					if(cart[i].listOfAttributes[y].fields.name != mapValueByKey && !$A.util.isUndefined(mapValueByKey)) {
						cart[i].listOfAttributes[y].fields.value = tempMap[cart[i].listOfAttributes[y].fields.name];
					}
				}
			}
			component.set('v.listVISAtoReset', cart);
		}
	},

	/*
	*	Author			:	Morittu Andrea
	*	Date			:	04-Oct-2019
	*	Task			:	EVO_BACKLOG_245
	*	Description		:	event change attribute	
	*/
	updateListAttributeEvent : function(component, event, index){
		try {
			
			component.set('v.spinner',true);
			var contextOutput = component.get("v.contextOutput"); 
			var  listItemToreset = component.get('v.listVISAtoReset');
			
			var listLength = listItemToreset.length - 1;
			if ( index <= listLength  ) {
				component.set( 'v.index_VM' , index);
				component.set( 'v.isVIsaToReset' , true);
				component.set("v.itemToUpdate", listItemToreset[index]);
				var changeAttributeEvent = $A.get("e.NE:Bit2win_Event_AttributeChanged");
				changeAttributeEvent.setParams({
					'itemChanged': listItemToreset[index],
					'Context_Output': contextOutput
				});
				changeAttributeEvent.fire();
				this.calculateProportion(component, event, index, listLength);
			}else{
				component.set( 'v.isVIsaToReset' , false);
				component.set('v.spinner',false);
				if(!$A.util.isUndefined(component.find('importVasValues'))) {
					component.find('importVasValues').set('v.disabled', true);
				}
				// SINCE THERE IS NO WAY TO GET THE CHILD ATTRIBUTE, I HAVE TO GET DOCUMENT.GET_ELEMENTBYCLASSNAME 
				let progressBar = document.getElementsByClassName('slds-progress-bar__value')

				if(!$A.util.isUndefinedOrNull(progressBar)) {
					document.getElementsByClassName('slds-progress-bar__value')[0].style.background = 'rgb(33, 152, 32)';
				}
			}
		} catch(exc) {
			console.log('An error has occured in updateListAttributeEvent : ' + exc.message);
		}
	},

	/*
	*	Author			:	Morittu Andrea
	*	Date			:	04-Oct-2019
	*	Task			:	EVO_BACKLOG_245
	*	Description		:	function to fill the progrss bar (It calculates the proportion between the lenght of the list and the index position)	
	*/
	calculateProportion : function(component, event, index, listLength) {
		try {
			let result;
			let index = component.get( 'v.index_VM');

			function percentCalculation(partialValue, totalValue ) {
				return (100 * partialValue) / totalValue;
			};

			result = percentCalculation(index, listLength );
			if(result >= 100) {
				component.find('importVasValues').set('v.disabled', true);

				let progressBar = component.find('progressBar');
				if(!$A.util.isUndefinedOrNull(progressBar)) {
					$A.util.addClass(progressBar, 'completed')
				}
			}
			component.set('v.progress' , parseFloat(result).toFixed(2));
		} catch (e) {
			console.log(e.message);
		}
	},	

})