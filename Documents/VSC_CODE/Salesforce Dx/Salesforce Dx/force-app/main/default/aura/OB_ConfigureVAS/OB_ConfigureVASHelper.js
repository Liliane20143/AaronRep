({
    objectIsEmpty: function(obj) {
        return Object.keys(obj).length === 0;
    },
    updateCartList: function(component){
        //_utils.debug('into updateCartList'); 
        var cartList = [];
        var items = [];
        var contextOutput = component.get("v.contextOutput");
        //_utils.debug('updateCartList contextOutput: ' + JSON.stringify(contextOutput));
        
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
        
        //FROM OB_newCartBancomat get attributes for the single attribute
        var itemToConfigure = component.get("v.itemToConfigure");
        
        var listOfItems = [];
        var listOfAttributes = [];
        var listOfFamilies = [];
        var attributesParentList = [];
        var qtymax = component.get("v.qtyMax");
        
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
		var numOfCol = 0;
        var commissionColSize = 1;
        
		//28/11/18 francesca.ribezzi - calling a new method to create the right grid and cols to display for childItems and attributes:
		//start
		// go ahead wit this block of code only if the user selects a vas:
		if(itemToConfigure != null || itemToConfigure != undefined){ //if it's true, then it needs to call enrichAttribute function:
			for(var j=0; j<contextOutput.cart.length; j++)
			{    
				if(contextOutput.cart[j].fields.id == itemToConfigure.fields.id)
				{
					var listToSort = [];
					listToSort.push(contextOutput.cart[j]);
					listToSort = this.createAttribute(listToSort,  component.get("v.vasCategories"));
					//setting numOfCol and commissionColSize values:
				    numOfCol = listToSort[0].numOfCol;
				    commissionColSize = listToSort[0].commissionColSize;	
				    component.set("v.commissionColSize", commissionColSize);
					//_utils.debug("numOfCol: " + numOfCol);
					component.set("v.numOfCol", numOfCol);
					numOfCol =  parseInt(numOfCol)+2;
					component.set("v.maxCol", numOfCol);
					//setting labels:
					
					var uniqueLabels  = [];
					var labelLen = 0;
					for(var i = 0; i<listToSort.length; i++){
						for(var k = 0; k<listToSort[i].childItems.length; k++){
							var childItem = listToSort[i].childItems[k];   
							if(childItem.uniqueLabels != undefined){
								
								labelLen = childItem.uniqueLabels.length;
								
								if(childItem.uniqueLabels.indexOf("Gratuità") != -1){
									var index = childItem.uniqueLabels.indexOf("Gratuità");
									 childItem.uniqueLabels.splice(index, 1);
									 var label = "Condizioni particolari/Mesi";
									 //childItem.uniqueLabels.push(label);
									 childItem.uniqueLabels.splice(index, 0, label);
								}
								
								if(labelLen > uniqueLabels.length){
									uniqueLabels = childItem.uniqueLabels;
								}
								else if(labelLen == uniqueLabels.length){
									//check fakes
									//_utils.debug("TEST childItem: "+ childItem.uniqueLabels.indexOf(" "));
									//_utils.debug("TEST uniqueLabels: "+ uniqueLabels.indexOf(" "));
									if(childItem.uniqueLabels.indexOf(" ") == -1 && uniqueLabels.indexOf(" ") != -1 ){
										uniqueLabels = childItem.uniqueLabels;
									}
								}
								//_utils.debug("uniqueLabels attribute: ", childItem.uniqueLabels);
								//break;
							}
						}	
					}
					component.set("v.uniqueLabels", uniqueLabels);
					listToSort[0] = contextOutput.cart[j];
					break;
				}
			}
		}
		/*************************************************************************************************************************/
		//end    
           
              
        if( (itemToConfigure != null || itemToConfigure != undefined) ){
        	//_utils.debug("actual cart ", contextOutput.cart);
            for(var j=0; j<contextOutput.cart.length; j++)
            {    
            	if(contextOutput.cart[j].fields.id==itemToConfigure.fields.id)
                { 
            		var qty = contextOutput.cart[j].fields.qty;
            		
                    for(var i = 0; i <contextOutput.cart[j].childItems.length; i++){
                        
                       
					   if(contextOutput.cart[j].childItems[i].fields.visible==true || contextOutput.cart[j].childItems[i].fields.visible=='true')
					   {
							for(var k= 0; k<contextOutput.cart[j].childItems[i].listOfFamilies.length; k++)
							{
								if((contextOutput.cart[j].childItems[i].listOfFamilies[k].fields.hidden!='true' && contextOutput.cart[j].childItems[i].listOfFamilies[k].fields.hidden!=true))
								{
									listOfFamilies.push({
										attribute: contextOutput.cart[j].childItems[i].listOfFamilies[k]
									});
								}
						   
							}
							for(var z= 0; z<contextOutput.cart[j].childItems[i].listOfAttributes.length; z++)
						    {
									var attr =  contextOutput.cart[j].childItems[i].listOfAttributes[z];
 								
 									
									listOfAttributes.push({
									   attribute: attr //contextOutput.cart[j].childItems[i].listOfAttributes[z]
									})		
								//}
								//else{
									//_utils.debug("z Attribute hidden");
								//}	
							}
							//end FOR attribute	  
						   
                    	   	var description;
							var price;
							//START francesca.ribezzi 06/12/19 - perf-27 - setting readonly if the action is none
							if(!$A.util.isEmpty(contextOutput.cart[j].childItems[i].fields.action)){ 
								var action = contextOutput.cart[j].childItems[i].fields.action;
								contextOutput.cart[j].childItems[i].readOnly = action == 'None' ? true : false; 
							}
                    	  	//END francesca.ribezzi 06/12/19 - perf-27  
	                        if( !($A.util.isEmpty(contextOutput.cart[j].childItems[i].fields.cartDescription)) ){
	                            //_utils.debug("cartDescription is not empty");
	                            //push cartDescription field instead of description
	                            description = contextOutput.cart[j].childItems[i].fields.cartDescription;
	                            
	                        }else{
	                            description = contextOutput.cart[j].childItems[i].fields.description;	
	                        }
	                        //end
	                        
	                        //price if/else
	                        if(contextOutput.cart[j].childItems[i].fields.baserecurringcharge > 0){
	                           
	                            //push baserecurringcharge field instead of baseonetimefee
	                            price = contextOutput.cart[j].childItems[i].fields.baserecurringcharge;
	                            
	                        }else{
	                            price = contextOutput.cart[j].childItems[i].fields.baseonetimefee;	
	                        }
	                        //end
	                        
	                        //make the push in the list and then empty the arrays for the next iteration
	                         listOfItems.push({
	                                productname: contextOutput.cart[j].childItems[i].fields.productname,
	                                description: description,
	                                listOfAttributes: listOfAttributes,
	                                listOfFamilies:listOfFamilies,
	                                price: price,
	                                qty:qty,
	                                item: contextOutput.cart[j].childItems[i] 
	                        });
	                        listOfAttributes = [];
	                        listOfFamilies =[];
	                        
                        }else{
                        	//if the item is not visible dont push it in the list that will be in the view
                        	//_utils.debug("ITEM NOT VISIBLE FOR SOME ERROR OR SOMETHING");
                        }
                    }
                }   
        	} 
            
            //sort by sequence first....
			listOfItems.sort(function(a, b){
				return a.item.fields.OB_Sequence__c == b.item.fields.OB_Sequence__c ? 0 : +(a.item.fields.OB_Sequence__c > b.item.fields.OB_Sequence__c) || -1;
			});
			
        	component.set("v.listOfAttributes", listOfAttributes);
        	//_utils.debug("listOfItems: " + JSON.stringify(listOfItems));
        	component.set("v.listOfItems", listOfItems);
        }//END

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
                             
                //check if an offert is already into cart
                if(productName == offerta){
                	continue;
                }
                
                //check if a fake quantity was added to the item 
                if(qty >= qtymax){
                	continue;
                }
                
                //update total based on current qty
                cartListTotal += (1*qty);
                
                //refresh Map from scratch
				var key = contextOutput.cart[i].id+'_'+contextOutput.cart[i].fields.vid;
				var bundleElementKey = contextOutput.cart[i].fields.bundleElement;
				
				if( !($A.util.isEmpty(key)) &&  $A.util.isEmpty(listOfCart[key]) )
				{	 
					var tmpObj = {};
					tmpObj.cartItem = contextOutput.cart[i];
					tmpObj.qty = qty;
					tmpObj.status = contextOutput.cart[i].fields.status;
					tmpObj.bundleElement = bundleElementKey;
						
					listOfCart[key] = tmpObj;
					
					var oldNum = listOfCart[bundleElementKey];
					listOfCart[bundleElementKey] = parseInt(oldNum)+1;
				}
                
                               
                //check the right category from the cart
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
                    
                    //the item goes on list view only if the qty is > 0        
                    if(items.hiddenInCart != true){ 
	                    cartList.push({
	                        categoryName: categoryName,
	                        items: items,
	                    });
                     }
                }
            }
        }
        //_utils.debug("MarkCartJSON"+JSON.stringify(cartList)); 
        // component.set('v.spinner',false);  
        component.set('v.listOfCartTotal',listOfCart);
        
        //check changes in min max qty
        this.checkMinMaxQtyBundleStep(component,event,contextOutput);
              
        component.set('v.cartListTotal',cartListTotal); 
		component.set('v.cartList',cartList);       
        
    },
    //francesca.ribezzi
    showDetailsSelectedCheckbox: function(component, event, openDetailsBtnId) {
   //   var selectedElement = event.currentTarget;
    	var selectedElement = document.getElementById(openDetailsBtnId);
    	//_utils.debug("selectedElement: " + selectedElement);
        //var offertChildList = component.get('v.offertChildList');
        //var contextOutput = component.get('v.contextOutput');
        var item;
        var itemId = selectedElement.getAttribute('data-item');
        //_utils.debug("showDetailsSelectedCheckbox itemId: " + itemId);
        var itemShowDetails = document.getElementById(itemId+'_showDetails');
        var itemHideDetails = document.getElementById(itemId+'_hideDetails');
        var itemInfo = document.getElementById(itemId+'_info');
        //var listOfItems = component.get("v.listOfItems");

        itemShowDetails.classList.add("hidden");
        itemHideDetails.classList.remove("hidden");
        itemInfo.classList.remove("hidden");
        component.set("v.isEditablePrice",true);
        /*prendi dati sul i figli di quel item */
       //find the currentItem on the full list (this is TAO logic, may be flawed 
       /*
       for(var offertaChild in offertChildList){
       
            if(offertChildList[offertaChild].id == itemId){
                item = offertChildList[offertaChild];
                //_utils.debug("showDetailsSelectedCheckbox item: " + JSON.stringify(item));
            }
        }
        */
    },
    //francesca.ribezzi
    hideDetailsSelectedCheckbox: function(component, event, openDetailsBtnId) {
        var selectedElement = document.getElementById(openDetailsBtnId);
        //_utils.debug("selectedElement "+selectedElement);
        if(selectedElement != null){
	        var itemId = selectedElement.getAttribute('data-item');
	        //_utils.debug("hideDetailsSelectedCheckbox itemId: " + itemId);
	        var itemShowDetails = document.getElementById(itemId+'_showDetails');
	        //_utils.debug("hideDetailsSelectedCheckbox itemShowDetails: " + itemShowDetails);
	        var itemHideDetails = document.getElementById(itemId+'_hideDetails');
	        itemShowDetails.classList.remove("hidden");
	        itemHideDetails.classList.add("hidden");
	        
	         var itemInfo = document.getElementById(itemId+'_info');
       
	         itemInfo.classList.add("hidden");
        }
        else{
        	
        }
    },
   
    showBundleElement	: function(component,coreOutput){ 		//component,coreOut
        	//_utils.debug('__showBundleElement');
			var productCategories = [];
			var qtyMax = component.get("v.qtyMax");
			//var enableNextButton = false;
			
			
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
							var qty = 0;
							for(var k in coreOutput.cart){
							//	_utils.debug(coreOutput.listOfItems[j].fields.itemCode+"____"+coreOutput.cart[k].fields.itemCode);
								if(coreOutput.cart[k].fields.catalogitemid == coreOutput.listOfItems[j].fields.catalogitemid){
									qty = coreOutput.cart[k].fields.qty;
									if(qty != qtyMax){
										checked = true;
										component.set("v.isFirstAdd",false); //NEW
									}				
								}	
							}
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

		
	    component.set('v.productCategories',productCategories);
		this.updateCartList(component);
    },
        
    //this function checks if the products catalog is in need to be refreshed. 
    checkCatalogChanges: function(component, coreOutput){ 	
    	//_utils.debug("inside checkCatalogChanges");
    	component.set("v.spinner", true);
    	//var contextOutput = component.get("v.contextOutput");
    	//_utils.debug("contextOutput before checking length: ", coreOutput);
    	//_utils.debug("ATTRIBUTE contextOutput : " , component.get("v.contextOutput"));
    	var contextListOfItems = [];
    	var productCategories = component.get("v.productCategories");
    	var categoryListOfItems = [];
    	for(var i = 0; i< productCategories.length; i++){
    		for(var j = 0; j<productCategories[i].items.length; j++){
    			categoryListOfItems.push(productCategories[i].items[j]);
    		}
    	}
		for(var i in coreOutput.listOfCategories){
			if(i!= 0 && (coreOutput.listOfCategories[i].categoryFields.hidden == 'true' || coreOutput.listOfCategories[i].categoryFields.hidden == true ) ){
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
    	_utils.debug("contextListOfItems: ", contextListOfItems);*/
    	//_utils.debug("contextListOfItems: "+ contextListOfItems.length);
    	
    	this.handleRefreshCatalog(component,coreOutput);
    }, 
    		
    handleRefreshCatalog: function(component, coreOutput){ 	
		//_utils.debug("handleRefreshCatalog is starting...");
		var productCategories = [];
		var qtyMax = component.get("v.qtyMax");
		//_utils.debug("contextOutput.cart in handleRefreshCatalog: ", coreOutput.cart);
		//_utils.debug("contextListOfItems: ", contextListOfItems);
		 //CREATING PRODUCTCATEGORIES ATTRIBUTE:
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
						var qty = 0;
						for(var k in coreOutput.cart){
						//	_utils.debug(coreOutput.listOfItems[j].fields.itemCode+"____"+coreOutput.cart[k].fields.itemCode);
						//	_utils.debug('listofitem id: '+coreOutput.listOfItems[j].fields.productcatalogitem+"_______ cart id: "+coreOutput.cart[k].fields.id);
							if(coreOutput.cart[k].id == coreOutput.listOfItems[j].fields.productcatalogitem){
								qty = coreOutput.cart[k].fields.qty;
								if(qty != parseInt(qtyMax)){
									checked = true;
								}
								else{
									qty = 0;
								}		
							}	
						}
					//	_utils.debug("checked in refresh???: " + checked);
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
	
		}// END CREATING
		 
		//here we sort by sequence the array of objects, Good luck understanding any of this :)
		productCategories.sort(function(a, b){
			return a.categorySequence == b.categorySequence ? 0 : +(a.categorySequence > b.categorySequence) || -1;
		});
		 
		 component.set('v.productCategories',productCategories);
		 //_utils.debug("productCategories after refreshing catalog: ", productCategories);
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
    	//_utils.debug("listToSort",listToSort);
    	var listOfItems = [];
    	for(var i = 0; i<listToSort.length; i++){
    		listToSort[i].listOfChildItems = [];						
    		listToSort[0].numOfCol = 3;
    		listToSort[0].commissionColSize = 1;
			for(var j = 0; j<listToSort[i].childItems.length; j++){
				for(var k = 0; k<listToSort[i].childItems[j].listOfAttributes.length; k++){
					var att = listToSort[i].childItems[j].listOfAttributes[k];
					if(att.fields.name == "fake"){
						continue;
					}	
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
    	//_utils.debug("categoriesMap: ", categoriesMap);
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
			//_utils.debug("listToSort[0].commissionColSize: " + listToSort[0].commissionColSize);
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
		var attributeLabelsList = [];
    	var needGrid = true; 
    	for(var i = 0; i< childItem.listOfAttributes.length; i++){
    	    //francesca.ribezzi - creating a list of all attributes' labels:
			attributeLabelsList.push(childItem.listOfAttributes[i].fields.name);
			
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
		  var uniqueLabels = attributeLabelsList.filter(function(elem, index, self) {
		        return index == self.indexOf(elem);
		    });
			
		   childItem.uniqueLabels = [];
		   for(var i = 0; i < uniqueLabels.length; i++){
			 if(uniqueLabels[i].indexOf("fake") != -1){
				 childItem.uniqueLabels.push(" ");
			}else{
				childItem.uniqueLabels.push(uniqueLabels[i]);	
			}
    	  }
		//_utils.debug("uniqueLabels: ", uniqueLabels);
		return childItem;
    },
    checkMinMaxQtyBundleStep: function(component,event,coreOutput){
    	
    	_utils.debug("into checkMinMaxQtyBundleStep");
    
    	var listOfCart = component.get("v.listOfCartTotal");
		
    	var selectedBundle = component.get("v.selectedBundle"); //coreOutput.listOfBundles[i]--> i
    	var step = component.get("v.bundleStep");
    	var bundleMaxQty = component.get("v.bundleMaxQty");
    	var bundleMinQty = component.get("v.bundleMinQty");
    	var bundleElementKey = coreOutput.listOfBundles[selectedBundle].bundleElements[step].id;
    	_utils.debug("listOfCart", listOfCart);
    	_utils.debug("bundleElementKey " + bundleElementKey); 
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
    	
    	_utils.debug("numOfCheckedItems" + numOfCheckedItems);
    	_utils.debug("bundleMinQty" + component.get("v.bundleMinQty"));
    	_utils.debug("bundleMaxQty" + component.get("v.bundleMaxQty"));
    	
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
})