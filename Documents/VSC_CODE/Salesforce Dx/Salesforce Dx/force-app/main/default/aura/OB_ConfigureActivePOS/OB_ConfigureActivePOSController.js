({
	doInit : function(component, event, helper) {
	
		_utils.debug("into OB_ConfigureActivePOS INIT");
		//var numberToShow = 0;
		var subsetNumber = component.get("v.subsetNumber");
		var listOfCartPOSActive = component.get("v.listOfCartPOSActive");
		var listOfCartPOSToShow = component.get("v.listOfCartPOSToShow");
		var listOfCartPOSToShowSmall = component.get("v.listOfCartPOSToShowSmall");
		//_utils.debug("listOfCartPosActive",listOfCartPosActive);
		// <daniele.gandini@accenture.com> - 11/07/2019 - F2WAVE2-124 - start
		console.log('****contextOutput' + JSON.stringify(component.get("v.contextOutput")));
		var cartList = component.get("v.contextOutput.cart");
		component.set("v.newCartList", cartList);
		// <daniele.gandini@accenture.com> - 11/07/2019 - F2WAVE2-124 - end
		if(listOfCartPOSActive.length <= subsetNumber){
			
			component.set("v.listOfCartPOSToShow",listOfCartPOSActive);
			component.set("v.moreToShow",false);
			//_utils.debug("listOfCartPOSToShow ",component.get("v.listOfCartPOSToShow");
		}
		else{
			//set in listOfCartPOSToShow a subset of the first 5
			for(var i = 0; i < subsetNumber-1;i++)
			{
				var item = listOfCartPOSActive[i];
				listOfCartPOSToShowSmall.push(item);
			}
			component.set("v.listOfCartPOSToShow",listOfCartPOSToShowSmall);
			component.set("v.moreToShow",true);
		}
		/*
			ANDREA MORITTU - REMOVED ADDITIONAL CODE IN SUBENTRO STREAM
		*/
	},

	//LUBRANO 16/01/2019 Libreria Log
	logInit: function(component){
		_utils.logInit(component.getName());
	},
	
	showLess: function(component, event, helper) {
		//set the smaller list to listOfCartPOSToShow
		var listOfCartPOSToShowSmall = component.get("v.listOfCartPOSToShowSmall");
		component.set("v.listOfCartPOSToShow",listOfCartPOSToShowSmall);
		component.set("v.showAll",true);
		//_utils.debug("showAll? "+component.get("v.showAll"));
	},
	
	showAll: function(component, event, helper) {
		//set all the active POS in the list
		var listOfCartPOSActive = component.get("v.listOfCartPOSActive");
		component.set("v.listOfCartPOSToShow",listOfCartPOSActive);
		component.set("v.showAll",false);
		//_utils.debug("showAll? "+component.get("v.showAll"));
	},
	
	togglePrices: function(component, event, helper) {
		var clickedId = event.currentTarget.id;
		var listOfCartPOSActive = component.get("v.listOfCartPOSActive");
		var currentActivePrice = component.get("v.itemPricing");
		var itemClicked = document.getElementById(clickedId);
		var lastItemClicked;
		
		_utils.debug("currentActivePrice", currentActivePrice);
		if( currentActivePrice != null ){
			lastItemClicked = document.getElementById(currentActivePrice.itemCode);//Simone Misani 06/12/2019 perf-21
		}
		
		//close
		if( currentActivePrice != null && clickedId == currentActivePrice.itemCode){//Simone Misani 06/12/2019 perf-21
			if(itemClicked.classList.contains("active")){
				//itemClicked.classList.remove("active");
				//component.set("v.showPrices", false);
			}
			else{
				//itemClicked.classList.add("active");
				component.set("v.showPrices", true);
			}
		}
		//open
		else{
			//close old
			if(lastItemClicked != null){
				//lastItemClicked.classList.remove("active");
			}
			
			//itemClicked.classList.add("active");
			
			for(var i = 0; i < listOfCartPOSActive.length;i++)
			{
				var item = listOfCartPOSActive[i];
				//_utils.debug(item.cartItem.id+" == "+clickedId);
				if(item.cartItem.fields.itemCode == clickedId){	//Simone Misani 06/12/2019 perf-21
					component.set("v.itemPricing",item.cartItem);
					break;
				}
			}
			
			helper.updateCartPriceList(component,event);
		}	
	},
	
	hidePrices: function(component, event, helper) {
		_utils.debug("into hidePrices");
		event.stopPropagation(); //stop the onclick on the parent
		component.set("v.showPrices", false);
	
	},
	
	deleteActiveItem: function(component, event, helper) {
		// Daniele Gandini <daniele.gandini@accenture.com> - 03/05/2019 - TerminalsReplacement-Task3 - Close modal if open - START -->
		component.set("v.showModal", false);
		// Daniele Gandini <daniele.gandini@accenture.com> - 03/05/2019 - TerminalsReplacement-Task3 - Close modal if open - END -->

		event.stopPropagation();
		// <daniele.gandini@accenture.com> - 27/06/2019 - variable assignment changed - F2WAVE2-32-36
		var clickedId = component.get("v.selectedIdPos");
		// Daniele Gandini <daniele.gandini@accenture.com> - 09/05/2019 - TerminalsReplacement-Task3 - Close modal if open - START -->
		var isReplacement = component.get("v.isReplacement");
		// <daniele.gandini@accenture.com> - 27/06/2019 - duplicated methods removed - F2WAVE2-32-36
		// Daniele Gandini <daniele.gandini@accenture.com> - 09/05/2019 - TerminalsReplacement-Task3 - Close modal if open - END -->
		var listOfCartPOSActive = component.get("v.listOfCartPOSActive");
		var listOfCartPOSToShow = component.get("v.listOfCartPOSToShow");
		var listOfCartPOSToShowSmall = component.get("v.listOfCartPOSToShowSmall");
		var subsetNumber = component.get("v.subsetNumber");
		var subsetNumberMinusOne = subsetNumber-1;
		var item;
			
		for(var i = 0; i < component.get("v.listOfCartPOSActive").length;i++)
		{
			var index = i;
			item = listOfCartPOSActive[index];	
			//_utils.debug(item.cartItem.id+" == "+clickedId);
			//14/03/19 francesca.ribezzi using fields.id instead of cartItem.id:
			if(item.cartItem.fields.itemCode == clickedId){//Simone Misani 06/12/2019 perf-21
			//if(item.cartItem.id == clickedId){
				
				//START: Delete from List and refill the short one <-- move it after confirm?
				listOfCartPOSActive.splice(index,1);
				
				if(listOfCartPOSActive.length <= subsetNumberMinusOne){
					component.set("v.moreToShow",false);
				}
				component.set("v.listOfCartPOSActive",listOfCartPOSActive);
				
				if(component.get("v.showAll") == false || component.get("v.moreToShow") == false){
					//listOfCartPOSToShow.splice(index,1);
					component.set("v.listOfCartPOSToShow",listOfCartPOSActive);
				}
				else{
					listOfCartPOSToShowSmall.splice(index,1);
					
					if(listOfCartPOSToShowSmall.length < subsetNumberMinusOne && listOfCartPOSActive.length >= subsetNumberMinusOne)
					{		
						//refill from main list			
						for(var j=0; j < listOfCartPOSActive.length; j++){
							var found = false;
							for(var k=0; k < listOfCartPOSToShowSmall.length; k++){
								if(listOfCartPOSActive[j].cartItem.fields.itemCode == listOfCartPOSToShowSmall[k].cartItem.fields.itemCode){//Simone Misani 06/12/2019 perf-21
									found = true;
									break;
								}
							}
							if(!found){
								listOfCartPOSToShowSmall.push(listOfCartPOSActive[j]);
								break;
							}
						}
						//END refill
					}
					component.set("v.listOfCartPOSToShowSmall",listOfCartPOSToShowSmall);
					component.set("v.listOfCartPOSToShow",listOfCartPOSToShowSmall);
				}
					
				break;
			}
		}
		
		//call event to container for delete
		var deleteActiveCartItem = 	$A.get("e.c:OB_ConfigureActivePOSEventRemove");
		deleteActiveCartItem.setParams({
			'cartItem': item.cartItem,
		});										
		deleteActiveCartItem.fire(); 	
	    component.set("v.showModalRemoveTerminal", false); //Andrea Saracini 14/05/2019 Maintenance Terminal Removed
	},
	//START Andrea Saracini 13/05/2019 Maintenance Terminal Removed
	checkDeleteActiveItem : function(component){
		var listOfPos = component.get("v.listOfCartPOSToShow");
		//START francesca.ribezzi 21/06/19 :
		var startOffer =  $A.get("$Label.c.OB_StartOffer");
		var isStartOffer = false;
		// var cartList= component.get("v.cartList");
		// for(var i in cartList){ 
		// 	for(var j in cartList[i].items){
		// 		if(cartList[i].items[j].productName == startOffer){
		// 			isStartOffer = true; 
		// 			break;
		// 		}
		// 	}
		// }
		//END francesca.ribezzi 21/06/19  

		// <daniele.gandini@accenture.com> - 11/07/2019 - F2WAVE2-124 - start
		var newCartList = component.get("v.newCartList");
		for(var i in newCartList){ 
			if(newCartList[i].fields.productname == startOffer){
				isStartOffer = true; 
				break;
			}
		}
		// <daniele.gandini@accenture.com> - 11/07/2019 - F2WAVE2-124 - stop

		//21/06/19 francesca.ribezzi changing if condition:
		if(listOfPos.length == 1 && isStartOffer){
			component.set("v.showModalLastTerminal", true);
		}
		else{
			component.set("v.showModalRemoveTerminal", true);
 			component.set("v.selectedIdPos",event.currentTarget.name); 
		}
	},
	backToTerminalsList : function(component, event, helper) { 
		component.set("v.showModalRemoveTerminal", false);
	},
	backToMerchant : function(component, event, helper) {
		helper.backToMerchantHelper(component, event, helper);
	},
	//STOP Andrea Saracini 13/05/2019 Maintenance Terminal Removed

	// <daniele.gandini@accenture.com> - 27/06/2019 - duplicated methods removed - F2WAVE2-32-36

	// Daniele Gandini <daniele.gandini@accenture.com> - 30/04/2019 - TerminalsReplacement - Modal for Replacement action Info - START -->
	openModal : function(component, event, helper) {
		// event.stopPropagation();
		component.set("v.showPrices", false);
		component.set("v.showModal", true);
		// <daniele.gandini@accenture.com> - 27/06/2019 - parameter added - F2WAVE2-32-36
		component.set("v.selectedIdPos",event.currentTarget.name);
	},
	// Daniele Gandini <daniele.gandini@accenture.com> - 30/04/2019 - TerminalsReplacement - Modal for Replacement action Info - END -->

	// Daniele Gandini <daniele.gandini@accenture.com> - 03/05/2019 - TerminalsReplacement-Task3 - Modal for Replacement action Info - START -->
	backToTerminals : function(component, event, helper) {
		// event.stopPropagation();
		component.set("v.showPrices", false);
		component.set("v.showModal", false);
	},
	// Daniele Gandini <daniele.gandini@accenture.com> - 03/05/2019 - TerminalsReplacement-Task3 - Modal for Replacement action Info - END -->	
})