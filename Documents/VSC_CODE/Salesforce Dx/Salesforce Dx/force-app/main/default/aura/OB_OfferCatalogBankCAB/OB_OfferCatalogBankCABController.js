({
	doInit : function(component, event, helper) {
		var userId = $A.get("$SObjectType.CurrentUser.Id");
		console.log('userId' + userId);
	    helper.getUserABI(component, event, userId);
		//helper.getOffersByABI(component, event);
		//helper.retrieveBundleOffers(component, event);
	},
	selectRecord : function(component, event, helper){      
		  
		  console.log("selectedRecord value: " + event.target.value);
		  var listOfSearchRecords = component.get("v.listOfSearchRecords");
		  var selectedRecord = listOfSearchRecords[event.target.id];
		  console.log("selectedRecord: ", selectedRecord);
		  component.set("v.selectedRecord", selectedRecord);
		  //when i select an offer, i only show that offer:
		  component.set("v.bundleOffers", selectedRecord);
		var forclose = component.find("lookup-pill");
		   $A.util.addClass(forclose, 'slds-show');
		   $A.util.removeClass(forclose, 'slds-hide');
  
		var forclose = component.find("searchRes");
		   $A.util.addClass(forclose, 'slds-is-close');
		   $A.util.removeClass(forclose, 'slds-is-open');
		
		var lookUpTarget = component.find("lookupField");
			$A.util.addClass(lookUpTarget, 'slds-hide');
			$A.util.removeClass(lookUpTarget, 'slds-show');  
			
		 var searchIconId = component.find("searchIconId");
			 $A.util.addClass(searchIconId, 'slds-hide');
		   //  $A.util.removeClass(pillTarget, 'slds-show');
	},
	 onfocus : function(component,event,helper){
	   $A.util.addClass(component.find("mySpinner"), "slds-show");
	 /*   var forOpen = component.find("searchRes");
			$A.util.addClass(forOpen, 'slds-is-open');
			$A.util.removeClass(forOpen, 'slds-is-close'); */
		// Get Default 5 Records order by createdDate DESC  
		 var getInputkeyWord = '';
		// helper.searchHelper(component,event,getInputkeyWord);
	},
	onblur : function(component,event,helper){       
		component.set("v.listOfSearchRecords", null );
		var forclose = component.find("searchRes");
		$A.util.addClass(forclose, 'slds-is-close');
		$A.util.removeClass(forclose, 'slds-is-open');
		
	},
	keyPressController : function(component, event, helper) {
	   // get the search Input keyword   
		 var getInputkeyWord = component.get("v.SearchKeyWord");
	   // check if getInputKeyWord size id more then 0 then open the lookup result List and 
	   // call the helper 
	   // else close the lookup result List part.   
		if(getInputkeyWord.length > 1){
			 var forOpen = component.find("searchRes");
			   $A.util.addClass(forOpen, 'slds-is-open');
			   $A.util.removeClass(forOpen, 'slds-is-close');
			helper.searchHelper(component,event,getInputkeyWord);
		}
		else{  
			 component.set("v.listOfSearchRecords", null ); 
			 var forclose = component.find("searchRes");
			   $A.util.addClass(forclose, 'slds-is-close');
			   $A.util.removeClass(forclose, 'slds-is-open');
		  }
	},
	
  // function for clear the Record Selaction 
	clear :function(component,event,helper){
		 var pillTarget = component.find("lookup-pill");
		 var lookUpTarget = component.find("lookupField"); 
		 var searchIconId= component.find("searchIconId");
		 $A.util.addClass(pillTarget, 'slds-hide');
		 $A.util.removeClass(pillTarget, 'slds-show');
		
		 $A.util.removeClass(lookUpTarget, 'slds-hide');
		 $A.util.addClass(lookUpTarget, 'slds-show');
		 
		 $A.util.removeClass(searchIconId, 'slds-hide');
		 $A.util.addClass(searchIconId, 'slds-show');
	  
		 component.set("v.SearchKeyWord",null);
		 component.set("v.listOfSearchRecords", null );
		 component.set("v.selectedRecord", {} );   
		 helper.retrieveBundleOffers(component);
	},
	
	onChangePicklistOrderBy :function(component,event,helper){
		var selectedValue = event.target.value;
		console.log("selectedValue: " + selectedValue);
		helper.getOffersOrderBy(component,selectedValue);
	},
	openOffersModal:function(component,event,helper){
		component.set("v.showModal", true);
		
	},
	
	handleActivationBtn:function(component,event,helper){
		component.set("v.showActiveBtn", false);
		console.log("index: " + event.target.id);
		var idToString = JSON.stringify(event.target.id);
		var isActive = false;
		var btn = document.getElementById(event.target.id);
		var index = document.getElementById(event.target.id).name;  
		console.log("index?? " + index);
		var activeOffersMap = component.get("v.activeOffersMap");
		var allOffers = component.get("v.allOffers");
		var cardId = index + '_card';
		console.log("cardId" + cardId);
		var cardDiv = document.getElementById(cardId);
		var inactiveLabel = $A.get("$Label.c.OB_Inactive");
		var activeLabel = $A.get("$Label.c.OB_Active");
		console.log("offerta attiva: " + JSON.stringify(allOffers[parseInt(index)]));
		var selectedOffer = allOffers[parseInt(index)];
		

		console.log("btn value: "+btn.value);
		if(btn.value == "active"){
			btn.classList.add("overWriteInActiveBtn");
			btn.classList.remove("overWriteActiveBtn");
			btn.classList.remove("slds-button_neutral");
			btn.value = "inactive";
			btn.innerHTML  = inactiveLabel;
			cardDiv.classList.add("activeOfferBox");
			activeOffersMap[selectedOffer.Id] = true;
		}else if(btn.value == "inactive"){
			btn.classList.add("slds-button_neutral");
			btn.classList.add("overWriteActiveBtn");
			btn.classList.remove("overWriteInActiveBtn");
			btn.value = "active";
			btn.innerHTML  = activeLabel;
			cardDiv.classList.remove("activeOfferBox");
			activeOffersMap[selectedOffer.Id] = false;
		}
	
		component.set("v.activeOffersMap", activeOffersMap);
			console.log("activeOffersMap" + JSON.stringify(activeOffersMap));
	},
   /* handleInActiveBtn:function(component,event,helper){
		component.set("v.showActiveBtn", true);
	}*/
	closeModal:function(component,event,helper){
	
		component.set("v.showModal", false);
	},
	handleSaveRows:function(component,event,helper){
		var activeOffersMap = component.get("v.activeOffersMap");
		//var selectedABI = component.get("v.abiCabLov").NE__Value1__c;
		var selectedABI = component.get('v.currentUser').Contact.Account.OB_ABI__c;
		var selectedCAB = component.get("v.abiCabLov").Name;
		var rows = component.get("v.rows");
		var listToUpdate = [];
		var activeOffers = [];
		for(var i = 0; i<rows.length; i++){
			for(var key in activeOffersMap){
				if(rows[i].NE__Matrix_Parameter__r.OB_Offerta__c == key && activeOffersMap[key] == false){
					//remove Active from all parameters rows.
					rows[i].NE__Active__c = false;
					listToUpdate.push(rows[i]);
				}else if(rows[i].NE__Matrix_Parameter__r.OB_Offerta__c != key  && activeOffersMap[key] == true){
					if(activeOffers.length > 0){
						for(var j = 0; j<activeOffers.length; j++){
							if(activeOffers[j].Id == key){
								continue;
							}else{
								activeOffers.push({"Id" : key});
								break;
							}	
						}
					}else{
						activeOffers.push({"Id" : key});
					}	
				}						
			}
		}
		console.log("activeOffers: ", activeOffers);
		console.log("listToUpdate: ", listToUpdate);
		helper.saveNewRowsWithOffers(component,event, activeOffers, selectedABI,selectedCAB, listToUpdate);
	},
	
	
	callConfigure :function(component,event,helper){
		//	START 	micol.ferrari 18/11/2018
		var offertaIndex = event.currentTarget.name;
		var offerbund = component.get("v.bundleOffers")[offertaIndex];
		component.set("v.offer",offerbund);
		component.set("v.openOfferCatalogBankCABContainer",true);
		component.set("v.goToOffers",false);//Andrea Saracini 20/05/2019 Catalog ON-OFF
		//	END 	micol.ferrari 18/11/2018

		// var offertaIndex = event.currentTarget.name;
		// var offer = component.get("v.bundleOffers")[offertaIndex];

		// var abiCabLov = component.get("v.abiCabLov");

		// console.log("offer: "+JSON.stringify(offer));
		// console.log("abiCabLov: "+JSON.stringify(abiCabLov));

		// //	START 	micol.ferrari 18/11/2018
		// // var evt = $A.get("e.force:navigateToComponent");
		
		// // evt.setParams({
		// //     componentDef : "c:OB_ConfigurazioniTableBank", //Banca
		// //     componentAttributes: {
		// //         offerta : offer,
		// //         abiCabLov: abiCabLov
		// //     }
		// // });
		// // evt.fire();

		// var offerCatalogBankCABContainer = component.find("offerCatalogBankCABContainer");
		// offerCatalogBankCABContainer.innerHTML = "";
		// $A.createComponent(
		// 	"c:OB_ConfigurazioniTableBank",
		// 	{
		// 		"offerta" : offer,
		// 		"abiCabLov": abiCabLov
		// 	},
		//    function(newCmp, status, errorMessage)
		//    {
		// 	   if (status === "SUCCESS" && newCmp.isValid()) 
		// 	   {			   	
		// 		   var body = component.get("v.body");
		// 		   body.push(newCmp);
		// 		   component.set("v.body", body);

		// 	   }
		// 	   else if (status === "INCOMPLETE") 
		// 	   {
		// 		   console.log("No response from server or client is offline.")
		// 	   }
		// 	   else if (status === "ERROR") 
		// 	   {
		// 		   console.log("Error: " + errorMessage);
		// 	   }
		//    }.bind(this) 
	 //   );
		//	END 	micol.ferrari 18/11/2018
	},

	//	START 	micol.ferrari 18/11/2018
	/*closeModalOfferCatalogBankCABContainer : function(component,event,helper)
	{
		component.set("v.openOfferCatalogBankCABContainer",false);
	}*/
	//	END 	micol.ferrari 18/11/2018
	//START Andrea Saracini 20/05/2019 Catalog ON-OFF
	callSaleabilityForBank :function(component,event,helper){
		var offertaIndex = event.currentTarget.name;
		var offerbund = component.get("v.bundleOffers")[offertaIndex];
		console.log("offerbund: ", offerbund);
		component.set("v.offer",offerbund);
		component.set("v.goToSaleabilityForBank",true); 
		component.set("v.goToOffers",false);
	}
	//STOP Andrea Saracini 20/05/2019 Catalog ON-OFF
})