({
	/* ANDREA MORITTU START 2019.05.07 - ID_Stream_6_Subentro */
	doInitHelper : function(component, even, helper) {
		helper.getOldAsset(component, event, helper);
	},
	/* ANDREA MORITTU END 2019.05.07 - ID_Stream_6_Subentro */

	objectIsEmpty: function(obj) {
		return Object.keys(obj).length === 0;
	},
   updateCartList: function(component){
		_utils.debug('into updateCartList'); 
		var cartList = [];
		var items = [];
		var contextOutput = component.get("v.contextOutput");
		
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
		
		
		var oldItem = component.get("v.oldItemId");
		
		var qtyMax = component.get("v.qtyMax");
		//FROM OB_newCartBancomat get attributes for the single attribute
		var itemToConfigure = component.get("v.itemToConfigure");
		
		var listOfItems = [];
		var listOfAttributes = [];
		var listOfFamilies = [];
		var listOfFamiliestemp = [];
		var attributesParentList = [];
		var offertaId = component.get("v.offertaId");
	    
	    var listOfCart = {};
	    var listOfCartPosActive = [];
	    
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
				
				if(contextOutput.cart[j].fields.id == itemToConfigure.fields.id)
				{
					var listToSort = [];
					listToSort.push(contextOutput.cart[j]);
					listToSort = this.createAttribute(listToSort,  component.get("v.posCategories"));
					//setting numOfCol and commissionColSize values:
				    numOfCol = listToSort[0].numOfCol;
				    commissionColSize = listToSort[0].commissionColSize;	
				    component.set("v.commissionColSize", commissionColSize);
					//_utils.debug("numOfCol: " + numOfCol);
					component.set("v.numOfCol", numOfCol);
					numOfCol =  parseInt(numOfCol)+2;
					component.set("v.maxCol", numOfCol);
					/**
					 * giovanni spinelli START - 03/09/2019
					 * sort list of childItems on OB_Sequence__c becasuse if 
					 * we have first array like [importo , commissione, da , a, ] and
					 * second array like [importo , importo, da , a, ], we are not able to create
					 * label "IMPORTO/COMMISSIONE"
					 */
					listToSort[0].childItems.sort(function (a, b) {
						var intA = parseInt(a.fields.OB_Sequence__c);
						var intB = parseInt(b.fields.OB_Sequence__c);
						var sec = (intA > intB) ? 1 : -1;
						return sec;
					});
					// giovanni spinelli END - 03/09/2019
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
					}
					listToSort[0] = contextOutput.cart[j];
					break;
				}
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
			//_utils.debug("listOfItems: " ,listOfItems);
			component.set("v.listOfItems", listOfItems);			
			
		}//END
		//Adding offer (mind that everytime we add a new attribute below, you CAN add it here with null value)
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
		
		//cartListTotal++;
		
		//if there are no object in the cart for everyone of them i get their attributes
		if(contextOutput.cart.length > 1){
			//START Andrea Saracini 13/05/2019 Maintenance Terminal Removed
			var offer = '';
			var posCount = 0;	
			//STOP Andrea Saracini 13/05/2019 Maintenance Terminal Removed
			for(var i=0;i<contextOutput.cart.length;i++){
				items = [];
				var categoryName = contextOutput.cart[i].fields.categoryname;
				var productName = contextOutput.cart[i].fields.productname;
				var qty = contextOutput.cart[i].fields.qty;
				var recordTypeName = contextOutput.cart[i].fields.RecordTypeName;
				var status = contextOutput.cart[i].fields.status;
                //START Andrea Saracini 10/05/2019 Maintenance Terminal Removed
				if(contextOutput.cart[i].fields.OBCodiceSfd == 'START' && recordTypeName == 'Tariff_Plan'){
					offer = contextOutput.cart[i].fields.OBCodiceSfd;
				}
				//STOP Andrea Saracini 10/05/2019 Maintenance Terminal Removed
				//check if a fake quantity was added to the item
				if(qty >= parseInt(qtyMax)){
					continue;
				}
				
				if(productName == offerta){
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
                    tmpObj.startdate = contextOutput.cart[i].fields.startdate;//Andrea Saracini 10/05/2019 Maintenance Terminal Removed
					tmpObj.bundleElement = bundleElementKey;
					listOfCart[key] = tmpObj;					
                    
					
					//_utils.debug("bundleElementKey" + bundleElementKey);
					//_utils.debug("selectedBundle", );
					//insert in listOfCartPosActive if status != undefined
					//START Andrea Saracini 10/05/2019 Maintenance Terminal Removed (tmpObj.status != undefined)
                    if(tmpObj.status == $A.get("$Label.c.OB_Active_String") && bundleElementKey == contextOutput.listOfBundles[component.get("v.selectedBundle")].bundleElements[component.get("v.bundleStep")].fields.id){						
						if(component.get("v.isReplacement")){
							console.log("contextOutput.cart[i]"+JSON.stringify(contextOutput));
							console.log("contextOutput.cart[i]"+JSON.stringify(contextOutput.cart[i]));
							// listOfCartPosActive.push({
							// 	cartItem : contextOutput.cart[i],
							// 	qty: qty,
							// 	status: contextOutput.cart[i].fields.status
							// });
						}
						posCount++;						
						listOfCartPosActive.push({
							cartItem : contextOutput.cart[i],
							qty: qty,
							status: contextOutput.cart[i].fields.status,
							startdate: tmpObj.startdate,
							offer: offer,
                            poscount: posCount
						});
					}
					//STOP Andrea Saracini 10/05/2019 Maintenance Terminal Removed
					
					if($A.util.isEmpty(listOfCart[bundleElementKey])){
						listOfCart[bundleElementKey] = 1;										
					}
					else{
						var oldNum = listOfCart[bundleElementKey];
						listOfCart[bundleElementKey] = parseInt(oldNum)+1;
					}
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
									//hiddenInCart : result[0].items[j].hiddenInCart,
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
							recordTypeName: recordTypeName,
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
							recordTypeName: recordTypeName,
							status: status,              
						}); 
					//----------------------------------------------
					
					//the item goes on list view only if the qty is a reasonable number
					 cartList.push({
							categoryName: categoryName,
							items: items,
						});  
				}
			}
		}
		//_utils.debug("MarkCart ",cartList);
		//component.set('v.spinner',false);
		component.set('v.listOfCartTotal',listOfCart);
		_utils.debug("listOfCartPOSActive",listOfCartPosActive);
		
		listOfCartPosActive.sort(function(a, b){
				return a.cartItem.fields.sequence == b.cartItem.fields.sequence ? 0 : +(a.cartItem.fields.sequence > b.cartItem.fields.sequence) || -1;
		});
		
		var oldListToCheck = component.get("v.listOfCartPOSActive");
		// Daniele Gandini <daniele.gandini@accenture.com> - 21/05/2019 - TerminalsReplacement - START
		if ( component.get( "v.isReplacement" ) )
        {
            for ( let i = 0; i < listOfCartPosActive.length; i++ )
            {
                // NEXI-265 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 08/08/2019 START changed conditions to remove from list
                let active = listOfCartPosActive[i].cartItem.fields.active;
                if ( $A.util.isEmpty( active ) || active == 'false' || active == false ||
                     $A.util.isEmpty( listOfCartPosActive[i].cartItem.fields.itemCode ) )//Simone Misani 06/12/2019 Perf-21
                // NEXI-265 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 08/08/2019 STOP
                {
                    listOfCartPosActive.splice(i, 1);
                }
            }
            console.log('listOfCartPosActiveAfterRemove'+listOfCartPosActive);
        }

		if( oldListToCheck.length == 0)
		{
			component.set('v.listOfCartPOSActive',listOfCartPosActive); 
		}
		
		//check changes in min max qty
		this.checkMinMaxQtyBundleStep(component,event,contextOutput);
				
		component.set('v.cartListTotal',cartListTotal); 
		component.set('v.cartList',cartList);       
		// }
	},
	//francesca.ribezzi
	showDetailsSelectedCheckbox: function(component, event, openDetailsBtnId) {
   //   var selectedElement = event.currentTarget;
		var selectedElement = document.getElementById(openDetailsBtnId);
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
		
	
	},
	//francesca.ribezzi
	hideDetailsSelectedCheckbox: function(component, event, openDetailsBtnId) {
		
		var selectedElement = document.getElementById(openDetailsBtnId);
		_utils.debug("selectedElement To Hide "+selectedElement);
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
   
	showBundleElement	: function(component,coreOutput){ 		
		_utils.debug('__showBundleElement');

		var productCategories = [];
		var qtyMax = component.get("v.qtyMax");
		//var enableNextButton = false;
		var numOfCheckedItems = 0;
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
			//var listOfItemsMap = {};
				
			var listOfitems=[];
			
			for(var j in coreOutput.listOfItems){	
				
				//NEW
				//listOfItemsMap[coreOutput.listOfItems[j].fields.id] = coreOutput.listOfItems[j];
				//NEW
				
				if(coreOutput.listOfItems[j].fields.visible == 'true' || coreOutput.listOfItems[j].fields.visible == true ){
					if(coreOutput.listOfItems[j].fields.categoryid	==	coreOutput.listOfCategories[i].id){	
						var checked = false;
						var qty = 0;
						var numberOfItems = 0;
						for(var k in coreOutput.cart){
							//_utils.debug('listofitem id: '+coreOutput.listOfItems[j].fields.catalogitemid+"_______ cart id: "+coreOutput.cart[k].fields.catalogitemid);
							if(coreOutput.cart[k].fields.catalogitemid == coreOutput.listOfItems[j].fields.catalogitemid){
								if(coreOutput.cart[k].fields.status == undefined){
									qty = coreOutput.cart[k].fields.qty;
								}
								if(qty != parseInt(qtyMax)){ 
									if(coreOutput.cart[k].fields.status == undefined){
										checked = true;
										component.set("v.isFirstAdd",false);
									}
									
								}		
							}						
						}
						listOfitems.push({
							"item": coreOutput.listOfItems[j],
							"checked": checked,
							"qty":qty								
						});
					}
				}
			}
			
			//component.set("v.listOfItemMap",listOfItemsMap);
			
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
	
		}//END OF FATHER OF ALL FOR
		
		//here we sort by sequence the array of objects, Good luck understanding any of this :)
		productCategories.sort(function(a, b){
			return a.categorySequence == b.categorySequence ? 0 : +(a.categorySequence > b.categorySequence) || -1;
		});
		
		//_utils.debug("productCategories ",productCategories);
		//_utils.debug("enableNextButton: " + enableNextButton);
		
		component.set('v.productCategories',productCategories);
		//CALL DEDICATED HELPER FUNCTION -- Marco.Ferri
		this.updateCartList(component);

		},
		  //this function checks if the products catalog is in need to be refreshed. 
	checkCatalogChanges: function(component, coreOutput){ 	
		_utils.debug("inside checkCatalogChanges");
		//component.set("v.spinner", true);

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
			if(i!= 0 && (coreOutput.listOfCategories[i].categoryFields.hidden == 'true' || coreOutput.listOfCategories[i].categoryFields.hidden == true)){
				continue;	
			}
			for(var j in coreOutput.listOfItems)
			{		
				if(coreOutput.listOfItems[j].fields.visible == true || coreOutput.listOfItems[j].fields.visible == 'true')
				{
					if(coreOutput.listOfItems[j].fields.categoryid	==	coreOutput.listOfCategories[i].id)
					{	
						contextListOfItems.push(coreOutput.listOfItems[j]);
					}
				}
			}
		}
		
		this.handleRefreshCatalog(component,coreOutput);
	}, 
			
	handleRefreshCatalog: function(component, coreOutput){ 	
		_utils.debug("handleRefreshCatalog is starting...");
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
				if(coreOutput.listOfItems[j].fields.visible == true || coreOutput.listOfItems[j].fields.visible == 'true' ){
					if(coreOutput.listOfItems[j].fields.categoryid	==	coreOutput.listOfCategories[i].id){	
						var checked = false;
						var qty = 0;
						for(var k in coreOutput.cart){
							//_utils.debug('listofitem id: '+coreOutput.listOfItems[j].fields.productcatalogitem+"_______ cart id: "+coreOutput.cart[k].fields.id);
							if((coreOutput.cart[k].id || coreOutput.cart[k].fields.id)  == coreOutput.listOfItems[j].fields.productcatalogitem){
								if(coreOutput.cart[k].fields.status == undefined){
									qty = coreOutput.cart[k].fields.qty;
								}
								if(qty != parseInt(qtyMax)){							
									if(coreOutput.cart[k].fields.status == undefined){
										checked = true;
									}
								}
								else{
									qty = 0;
								}		
							}	
						}
						listOfitems.push({
							"item": coreOutput.listOfItems[j],
							"checked": checked,
							"qty":qty								
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
		
		//_utils.debug("productCategories ",productCategories);
		//component.set("v.spinner", false);
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
					/*
					giovanni spinelli - START - 28/08/2019
					add  'importo' value as a commission
					*/
					//giovanni spinelli 08/10/2019 - add new value in commission - start
					att.commission = (attributeCode.indexOf('importo 5') != -1) || (attributeCode.indexOf('importo 4') != -1) || (attributeCode.indexOf('importo 3') != -1) || (attributeCode.indexOf('importo 2') != -1) ||(attributeCode.indexOf('importo 1') != -1) || (attributeCode.indexOf('scaglione') != -1) || (attributeCode.indexOf('indifferenziata') != -1) ;
					//giovanni spinelli 08/10/2019 - add new value in commission - start
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
								//att.fields.value = '10';
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
    	//_utils.debug("categoriesMap: ", categoriesMap);
    	for(var i = 0; i<listToSort.length; i++){
			for(var j = 0; j<listToSort[i].childItems.length; j++){
				var localMap = JSON.parse(JSON.stringify(categoriesMap));
				
				for(var k = 0; k<listToSort[i].childItems[j].listOfAttributes.length; k++){
					var att = listToSort[i].childItems[j].listOfAttributes[k];
					//creating list of attributes		
					var attKey = att.fields.idfamily+'_'+att.fields.propid;
					
					//giovanni spinelli 30/08/2019 add if condition
					if(localMap[att.fields.OB_Attribute_Code__c] != undefined && !att.commission){		
						delete localMap[att.fields.OB_Attribute_Code__c];
					}else if(att.commission && localMap['COMMISSIONE'] != undefined && att.fields.OB_Attribute_Code__c != '' ){
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
				console.log('**childItem',childItem);
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
				//Start antonio.vatrano wn_422 19/08/2019
				var temp = "";
				if(displaySequence){
					temp = displaySequence.toString();
				}
				//End antonio.vatrano wn_422 19/08/2019
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
	
	//francesca.ribezzi 08/02/19 TEST ON CHECK BY INCREASING QUANTITY:
    onCheckByIncreaseQty: function(component,event,itemId, itemQty){
    
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
	     //   var itemId = event.getSource().get("v.id");
	      //  var itemQty = parseInt(document.getElementById(itemId+'_qty').value);
	        var chkBoxVal = true;//event.getSource().get("v.checked");
			//var nameTest = event.getSource().get("v.name");
	        var item;
	        //var itemNameToCompare;
	
	        var offertChildList = component.get('v.offertChildList');
	        
	        //var openDetailsBtnId = itemId + '_showDetails' ;
	        
	        if(chkBoxVal){
	            //numOfCheckedItems++;      	
	           /* var itemQty = parseInt(document.getElementById(itemId+'_qty').value);
	            if(itemQty == 0){
	            	//add class
	            	document.getElementById(itemId+'_qty').classList.add("black");
	                document.getElementById(itemId+'_qty').value = 1;
	            }*/
	            
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
		                if(itemToCheck.id == itemId && itemToCheck.fields.status == undefined){
		                	component.set("v.itemToConfigure",itemToCheck);
				            found = true;
				            break;
			            }
			         }     
					
					 if(itemToCheck.fields.qty == maxQty && itemToCheck != null){
		        					
						var userQty = document.getElementById(itemToCheck.id+'_qty').value;
						
						if(userQty == 0){
	    					itemToCheck.fields.qty = 1;
							itemToCheck.fields.qtyToManage = 1;
							//04/03/19 giovanni spinelli setting checkbox to true:
							document.getElementById(itemId).checked = true;
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
		}//end if checkAttributeRules != error
	},
	//04/03/19 giovanni spinelli adding method to remove item:
	onCheckByDecreaseQty : function(component,event,itemId, itemQty){
    
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
	     //   var itemId = event.getSource().get("v.id");
	      //  var itemQty = parseInt(document.getElementById(itemId+'_qty').value);
	        var chkBoxVal = false;//event.getSource().get("v.checked");
			//var nameTest = event.getSource().get("v.name");
	        var item;
	        //var itemNameToCompare;
	
	        var offertChildList = component.get('v.offertChildList');
	        
	        //var openDetailsBtnId = itemId + '_showDetails' ;
	        
	        if(!chkBoxVal){
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
				                'action' : 	'remove'
				            });
			            configureAppEvent.fire();	                          
	            //setting the item in the attribute for future reference to remove
	            component.set("v.itemToConfigure",item);
	            component.set("v.needConfiguration", false);
	            //set flags
	            component.set('v.itemAddedToCart',false);
	            component.set('v.itemRemovedFromCart',true);
	            

	
	            var productRow = document.getElementById(itemId+'_prdRow');           
	            var itemInfo = document.getElementById(itemId+'_infoColor');
	            productRow.classList.remove("product_row_color");
	            itemInfo.classList.remove("product_row_color");
	            //remove class
	            document.getElementById(itemId+'_qty').classList.remove("black");

			}
		}
	},
	/**
	*@author giovanni spinelli <spinelli.giovanni@accenture.com>
	*@date 19/09/2019
	*@description Method to remove selected POS
	*@params itemId , coreOutput
	*@return -
	*/
	removeItemReset : function( component , event , itemId , coreOutput){
		
		var item;
		var itemToRemove;
		var cartChildItems = coreOutput.cart;
		var oldItemId = component.get("v.oldItemId");
		for (var i = 0; i < coreOutput.cart.length; i++) {
			item = cartChildItems[i];
			console.log('item in remove: ' , item.id);
			if( itemId == item.id){
				itemToRemove = item;
				component.set('v.itemRemovedFromCart',true);
				component.set('v.itemAddedToCart',false);
				component.set("v.needConfiguration" , false);
				break;
			}
		}
		var configureAppEvent = $A.get("e.NE:Bit2win_Event_AddRemoveFromCart");
		configureAppEvent.setParams({
			'item': itemToRemove,
			'action': 'remove',
		});
		configureAppEvent.fire();
		component.set('v.isReset' , true);

	

	},
	/**
	*@author giovanni spinelli <spinelli.giovanni@accenture.com>
	*@date 19/09/2019
	*@description Method to add  selected POS just after its removal
	*@params itemId , coreOutput
	*@return -
	*/
	addItemReset : function( component ){
		var coreOutput = component.get('v.contextOutput');
		
		var itemId = component.get('v.currentTermId');
		component.set("v.offertChildList", coreOutput.listOfItems);
		var offertChildList = component.get('v.offertChildList');
		var itemToAdd;
		for(var i=0;i<offertChildList.length;i++){
			itemToAdd = offertChildList[i];
				if(itemToAdd.id == itemId){
					
					component.set('v.itemRemovedFromCart',false);
					component.set('v.itemAddedToCart',true);
					component.set("v.needConfiguration" , true);
					component.set('v.spinner',true);
					
					break;
				}  
			} 
		var updateChildEvent 	= 	$A.get("e.NE:Bit2win_Event_AddRemoveFromCart");
		updateChildEvent.setParams({
			"item":itemToAdd,		    
		    "action": "add",		    
		    "typeOfAdd": "singleAdd"
		});

		updateChildEvent.fire();
		component.set('v.isReset' , false);
	},

	/* 
		@Author		: Morittu Andrea
		@Date		: 2019.05.10
		@Task		: ID_Streanm_6_Subentro
	*/

	getOldAsset : function(component, event, helper) {
		var objectDataMap = component.get("v.objectDataMap");
		try {
			if(!$A.util.isUndefined(objectDataMap.offerAsset)) {
				var action = component.get("c.getOldAssetServer");
				action.setParams({ offerAssetId : objectDataMap.offerAsset.Id });

				action.setCallback(this, function(response) {
					var state = response.getState();
					if (state === "SUCCESS") {
						console.log('getOldAsset is SUCCESS' );
						var oldAssets = response.getReturnValue();
						console.log('oldAssets are: ' , oldAssets);
						var fields = {};

						var oldPos = [];

						for(var i = 0; i<oldAssets.length; i++){
							var cartItem = {};
							var fields = {};
							debugger
							/*
								* History	:	02-Aug-2019
								  Morittu Andrea. Change field target 
								  'cause logic changed. FROM Order_Item TO ASSET
								*
							*/
							fields.productname = oldAssets[i].Name;
							fields.name = 'Terminal Id';
							// VALUE --> TERMINAL ID - NULL --> N/A
							fields.value = !$A.util.isUndefinedOrNull(oldAssets[i].OB_TermId__c) ? oldAssets[i].OB_TermId__c : 'N/A' ;
							cartItem.fields = fields;
							var listOfAttributes = [];
							listOfAttributes.push({'fields':fields});
							cartItem.listOfAttributes = listOfAttributes;
							oldAssets[i].cartItem = cartItem;
							oldPos.push(oldAssets[i]);
						}

						console.log('oldPos: ' ,oldPos);
						if(!$A.util.isEmpty(oldPos)) {
							component.set("v.oldTerminalArePresent", true);
							component.set("v.listOfCartPOSActive" , oldPos);
						}
					}
					else if (state === "INCOMPLETE") {
					}
					else if (state === "ERROR") {
						var errors = response.getError();
						if (errors) {
							if (errors[0] && errors[0].message) {
								console.log("Error message: " + 
										errors[0].message);
							}
						} else {
							console.log("Unknown error");
						}
					}
				});
			$A.enqueueAction(action);
			}
		} catch(exc) {
			console.log('an exception has occured : ' + exc.message );
		}
	}
	/* 
		-------------------
			END
	*/
    
})