({
	updateCartPriceList : function(component,event) {
		
		_utils.debug("into updateCartPriceList");
		var itemToConfigure = component.get("v.itemPricing");
        var listOfCartPOSActive = component.get("v.listOfCartPOSActive");
        //_utils.debug("itemToConfigure ",itemToConfigure);
		/*************************************************************************************************************************/
		//adding logic to display child items and attributes correctly in markup!!!
		//francesca.ribezzi - adding 2 vars for displaying columns:
		var numOfCol = 0;
        var commissionColSize = 1;
       
		//28/11/18 francesca.ribezzi - calling a new method to create the right grid and cols to display for childItems and attributes:
		//start
		// go ahead wit this block of code only if the user selects a pos:
		if(itemToConfigure != null || itemToConfigure != undefined)
		{ 
			for(var j=0; j<listOfCartPOSActive.length; j++)
			{
				if(listOfCartPOSActive[j].cartItem.fields.itemCode == itemToConfigure.fields.itemCode)//Simone Misani 06/12/2019 perf-21
				{
					var listToSort = [];
					listToSort.push(listOfCartPOSActive[j].cartItem);
					listToSort = this.createAttribute(listToSort,component.get("v.posCategories"));
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
					listToSort[0] = listOfCartPOSActive[j].cartItem;
					
					
					var listOfItems = [];
					var listOfAttributes = [];
					var listOfFamilies = [];
					var qty = listOfCartPOSActive[j].cartItem.fields.qty;
					
					for(var i = 0; i <listOfCartPOSActive[j].cartItem.childItems.length; i++){
						
					   
					   if(listOfCartPOSActive[j].cartItem.childItems[i].fields.visible==true || listOfCartPOSActive[j].cartItem.childItems[i].fields.visible=='true')
					   {
							for(var k= 0; k<listOfCartPOSActive[j].cartItem.childItems[i].listOfFamilies.length; k++)
							{
								if((listOfCartPOSActive[j].cartItem.childItems[i].listOfFamilies[k].fields.hidden!='true' && listOfCartPOSActive[j].cartItem.childItems[i].listOfFamilies[k].fields.hidden!=true))
								{
									listOfFamilies.push({
										attribute: listOfCartPOSActive[j].cartItem.childItems[i].listOfFamilies[k]
									});
								}  
							}
							for(var z= 0; z<listOfCartPOSActive[j].cartItem.childItems[i].listOfAttributes.length; z++)
							{
									var attr =  listOfCartPOSActive[j].cartItem.childItems[i].listOfAttributes[z];
								
									listOfAttributes.push({
									   attribute: attr 
									})		
								//}
								//else{
									//_utils.debug("z Attribute hidden");
								//}	
							}
							//end FOR attribute	   
							var description;
							var price;
								  
							if( !($A.util.isEmpty(listOfCartPOSActive[j].cartItem.childItems[i].fields.cartDescription)) ){
								//_utils.debug("cartDescription is not empty");
								//push cartDescription field instead of description
								description = listOfCartPOSActive[j].cartItem.childItems[i].fields.cartDescription;
								
							}else{
								description = listOfCartPOSActive[j].cartItem.childItems[i].fields.description;	
							}
							//end
							
							//price if/else
							if(listOfCartPOSActive[j].cartItem.childItems[i].fields.baserecurringcharge > 0){
								//push baserecurringcharge field instead of baseonetimefee
								price = listOfCartPOSActive[j].cartItem.childItems[i].fields.baserecurringcharge;
								
							}else{
								price = listOfCartPOSActive[j].cartItem.childItems[i].fields.baseonetimefee;	
							}
							//end
							
							//make the push in the list and then empty the arrays for the next iteration
							
							listOfItems.push({
									productname: listOfCartPOSActive[j].cartItem.childItems[i].fields.productname,
									description: description,
									listOfAttributes: listOfAttributes,
									listOfFamilies:listOfFamilies,
									price: price,
									qty:qty,
									item: listOfCartPOSActive[j].cartItem.childItems[i] 
							});
							
							listOfAttributes = [];
							listOfFamilies =[];
							
						}
						else{
							//if the item is not visible dont push it in the list that will be in the view
							//_utils.debug("ITEM NOT VISIBLE FOR SOME ERROR OR SOMETHING");
						}
					}
					break;
				}//END FIRST IF	checking correct cart to item clicked   
			}//END FIRST FOR of cartPoSActive
		
		
		//sort by sequence first....
		listOfItems.sort(function(a, b){
			return a.item.fields.OB_Sequence__c == b.item.fields.OB_Sequence__c ? 0 : +(a.item.fields.OB_Sequence__c > b.item.fields.OB_Sequence__c) || -1;
		});
 
		//component.set("v.listOfAttributes", listOfAttributes);
		_utils.debug("listOfItems: " ,listOfItems);
		component.set("v.showPrices", true);
		component.set("v.listOfItemsCart", listOfItems);
		
		/*************************************************************************************************************************/

		}//END IF ITEMTOCONFIGURE CHECK IF NULL
		
		else{
		
			//error message, something is very wrong here...
		}
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
			    
		 /* OLD
		  if(uniqueLabels.indexOf("fake") == -1){
			//uniqueLabels.splice(uniqueLabels.indexOf("fake"), 1);
			//_utils.debug("uniqueLabels: ", uniqueLabels);
			childItem.uniqueLabels = [];
			for(var i = 0; i< uniqueLabels.length; i++){
				childItem.uniqueLabels.push(uniqueLabels[i]);	
			}
    	  } 
		
		return childItem;
		*/
		childItem.uniqueLabels = [];
		for(var i = 0; i < uniqueLabels.length; i++)
		{
			if(uniqueLabels[i].indexOf("fake") != -1){
				childItem.uniqueLabels.push(" ");
			}
			else{
				childItem.uniqueLabels.push(uniqueLabels[i]);	
			}
		}
		//_utils.debug("uniqueLabels: ", uniqueLabels);
		return childItem;
		
	},

	// <daniele.gandini@accenture.com> - 27/06/2019 - methods removed - F2WAVE2-32-36

    //START Andrea Saracini 14/05/2019 Maintenance Terminal Removed
	backToMerchantHelper : function(component, event, helper){ // <daniele.gandini@accenture.com> - 27/06/2019 - methods signature changed - F2WAVE2-32-36
		component.set("v.showModalLastTerminal", false);
		//START francesca.ribezzi 21/06/19
		component.set("v.spinner", true);
		var orderId = component.get("v.objectDataMap.Configuration.Id");
		//END francesca.ribezzi 21/06/19
		var action = component.get("c.cancelOrderOperation");
		action.setParams({ 
			orderId : orderId //francesca.ribezzi 21/06/19 changing parameters
		}); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
				//START francesca.ribezzi 21/06/19 
				var confActivePosEvent = $A.get("e.c:OB_ConfigureActivePOSevent");  
				confActivePosEvent.setParams({
					 "fiscalCode": component.get("v.objectDataMap.merchant.NE__Fiscal_code__c")
				});
				confActivePosEvent.fire();
				//END francesca.ribezzi 21/06/19 
			}
			else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						console.log("Error message: " + errors[0].message);
					}
				} else {
					console.log("Unknown error");
				}
			}
        });
		$A.enqueueAction(action);
	},
    //STOP Andrea Saracini 14/05/2019 Maintenance Terminal Removed
})