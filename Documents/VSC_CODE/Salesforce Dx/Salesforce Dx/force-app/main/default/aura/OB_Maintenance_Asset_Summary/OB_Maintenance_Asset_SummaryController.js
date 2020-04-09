({
	doInit : function(component, event, helper) {
		console.log("doInit Maitenance_Asset_Summary...");
		console.log("UserWrapper summary: " + JSON.stringify(component.get("v.currentUser")));

		// ANDREA MORITTU START 27-Sept-2019 - PRODOB_469
		helper.getLOVnameByMCC(component, event)
		.then(function(MCClov) {
			
			console.log('MCClov are :' , MCClov);
		})
		.catch(function(error) {
			component.set("v.status" ,error ) ; 
			console.log(error);
        });
		// ANDREA MORITTU END 27-Sept-2019 - PRODOB_469
		//console.log('PROPOSER ABI Asset Summary--> '+component.get("v.proposerABI"));
		if($A.util.isEmpty(component.get("v.proposerABI"))){
			var ServicePointSelectedRow = component.get("v.recordId");
			console.log("recordId: " + ServicePointSelectedRow);
			component.set("v.ServicePointSelectedRow", ServicePointSelectedRow);
		}
		//setting a fake objDataMap
		var objectDataMap = {};
		var Configuration = {};
		
		var accId = component.get("v.AccountData").Id;
		//console.log("accId: " + accId);
		var merchant = {};
		merchant.Id = accId;
		//Configuration.NE__Parameters__c = 'lightningFromVF='+isCommunity+';ordId='+order.Id;
		objectDataMap['merchant'] = merchant;
		//objectDataMap['Configuration'] = Configuration;
		component.set("v.objectDataMap", objectDataMap);
		
	},
	/*------------------------------------------------------------
    Author:         Andrea Saracini
    Company:        Accenture Tecnology
    Description:    handle tipologies Picklist Selection
    Inputs:         component, event, helper
    History:
    <Date>          <Authors Name>      <Brief Description of Change>
    2019-04-01      Andrea Saracini     Creator
    ------------------------------------------------------------*/
    handleTipologiesOnChange : function(component, event, helper) {
			//START gianluigi.virga 27/11/2019
			if(component.get("v.callRetrieveItemsAndItemAttributes") == false){
				helper.retrieveLineItemsAndLineItemAttributes(component, event);
			} 			
			//END gianluigi.virga 27/11/2019
			var val = event.getSource().get("v.value");
			console.log('val is : ' + val);
				if(val!=""){		
				component.set("v.executeBtnDisabled", false);
				component.set("v.typologiesValue", val);
				}
			else{
				component.set("v.executeBtnDisabled", true);
			}
    },

	itemsChange : function(component, event, helper) {
		component.set("v.callRetrieveItemsAndItemAttributes", false); // enrico.purificato - 20/12/2019 	
		console.log("cambiato....................");
		var switchOnload =  component.get('v.switchOnload');
		component.set('v.switchOnload',!switchOnload);
	},
	
	handleShowLabel : function(component, event, helper) {
	   var showLabel = event.getParam("showLabel");
	   var offerAssetId = event.getParam("offerAssetId");
	   var offerAsset = event.getParam("offerAsset");
	   console.log('offerAsset ' + JSON.stringify(offerAsset));
	   //var offerAssetMap = component.get("v.offerAssetMap");
	   if(offerAsset != undefined && offerAsset != null){
		//offerAssetMap[offerAssetId] = offerAsset;
		component.set("v.offerAssetSelected",offerAsset);
	   }

	   
		// var pricingBtn = component.get("v.pricingbtnDisabled");
		// var editOfferBtn = component.find("v.offerBtnDisabled");
		// var editCommissionBtn = component.find("v.commissionbtnDisabled");
		component.set('v.pricingbtnDisabled',false);
		component.set('v.offerBtnDisabled', false);
		component.set('v.commissionbtnDisabled',false);
		component.set('v.terminateDisabled',false);
		//START [01-04-2019 No Card Present] Andrea Saracini
		// if(offerAsset.Name != 'Offerta Personalizzata' && offerAsset.Name != 'Offerta Start'){
        if( !$A.util.isEmpty(offerAsset)){
            if(offerAsset.Name != $A.get("$Label.c.OB_CustomOffer") && offerAsset.Name != $A.get("$Label.c.OB_StartOffer")){
                component.set('v.isEcommerce',true);
            }
    	}
		// Initialize input select options		
		var typologiesMap = [];
		/* ANDREA MORITTU START 2019 - Commented removed picklist value   */
		// if(!component.get("v.commissionbtnDisabled")){
		// 	typologiesMap.push({key: "editCommissionBtn", value: $A.get("$Label.c.OB_EditCommissionModel")});
		// }
		// if(!component.get("v.pricingbtnDisabled")){		
			// typologiesMap.push({key: "pricingBtn", value: $A.get("$Label.c.OB_EditPricing")});
		// }
		/* ANDREA MORITTU END 2019 - Commented removed picklist value   */
		if(component.get("v.isEcommerce")){
			typologiesMap.push({key: "editIntBtn", value: $A.get("$Label.c.OB_ChangeIntegrationMode")});
		}		
		if(!component.get("v.offerBtnDisabled")){
			typologiesMap.push({key: "editOfferBtn", value: $A.get("$Label.c.OB_EditOffer")});
		}
		if(!component.get("v.terminateDisabled")){
			typologiesMap.push({key: "terminateOfferBtn", value: $A.get("$Label.c.OB_TerminateOffer")});
		}
		/* ANDREA MORITTU START 2019.04.02 --> ADDING COBA OPTION IN THE PICKLIST (LIGHTNING SELECT)*/
		typologiesMap.push({key: "showCoBa", value:$A.get('$Label.c.OB_showCoBaPricingLabel')});
		/* ANDREA MORITTU END*/
		/* andrea.morittu - START 29.04.2019 - ID_Task_6 - Subentro */
		typologiesMap.push({key: "changeCompanyName", value:$A.get('$Label.c.OB_ChangeCompanyNameLabel')});
		/* andrea.morittu - END 29.04.2019 - ID_Task_6 - Subentro */ 	

		// start antonio.vatrano 17/04/2019 ri-3
		typologiesMap.push({key: "showPricing", value:$A.get('$Label.c.OB_checkPricing')}); 
		// end antonio.vatrano 17/04/2019 ri-3

		//	Daniele Gandini <daniele.gandini@accenture.com>	- 29/04/2019 - TerminalsReplacement - Add Replacement value to the action picklist in the Asset Summary page - START
		typologiesMap.push({key: "replacementAction", value: $A.get("$Label.c.OB_Replacement")});
		//	Daniele Gandini <daniele.gandini@accenture.com>	- 29/04/2019 - TerminalsReplacement - Add Replacement value to the action picklist in the Asset Summary page - END
		
		component.set("v.typologiesMap", typologiesMap);
		//STOP [01-04-2019 No Card Present] Andrea Saracini

	   console.log("@@@offerAsset?? "+  JSON.stringify(offerAsset));
	   var isCommunity = event.getParam("isCommunity");
	   //var currentUser = event.getParam("currentUser");
	  
        // set the handler attributes based on event data
		component.set("v.showLabel", showLabel);
		if(!$A.util.isEmpty(offerAsset)){
			//LUBRANO 2019-02-07 CHECK order moved to goToMaintenance()
			// if(offerAsset.NE__Status__c == 'In Progress'){
			// 	var pricingBtn = component.find("pricingBtn");
			// 	var editOfferBtn = component.find("editOfferBtn");
			// 	var editCommissionBtn = component.find("editCommissionBtn");
			// 	pricingBtn.set('v.disabled',true);
			// 	editOfferBtn.set('v.disabled', true);
			// 	//  editCommission button handled in helper.getcommission() below
			// 	//editCommissionBtn.set('v.disabled',true);
				
			// 	component.set("v.offerAsset", offerAsset);
			// 	var infoMessage = $A.get("$Label.c.OB_pendingOrder");
			// 	helper.showInfoMessage(component, event, infoMessage);
			// }
			//START Andrea Saracini 12/06/2019 R1F2-164
			if('Disconnected' != offerAsset.NE__Status__c){
				component.set("v.isDisconnectOffer", false);
			}
			else{
				component.set("v.isDisconnectOffer", true);
			}
			//STOP Andrea Saracini 12/06/2019 R1F2-164
        }
        if(!$A.util.isEmpty(offerAssetId)){
			component.set("v.offerAssetId", offerAssetId);
        }
         if(!$A.util.isEmpty(isCommunity)){
        	component.set("v.isCommunity", isCommunity);
			console.log("calling flow cart for pre load...");
			component.set("v.showFlowCartForPreload", true);
        }
        //  if(!$A.util.isEmpty(currentUser)){
         
        // 	 component.set("v.currentUser", currentUser);
        //     console.log("current user: "+ JSON.stringify(currentUser));
        // }
        if(!$A.util.isEmpty(offerAsset)){
        	 component.set("v.offerAsset", offerAsset);
        	 console.log("offerAsset: "+ JSON.stringify(offerAsset));
        	 helper.getCommission(component, event, offerAsset); 
        }
	},
	//START andrea.saracini 25/02/2018 - obsolete
	/*
	cancelRequest: function(component, event, helper) {
		var offerAssetSelected = component.get("v.offerAssetSelected");
		if( !$A.util.isEmpty(offerAssetSelected) && offerAssetSelected.NE__Status__c != 'In Progress' ){
			var infoMessage = $A.get("$Label.c.OB_NOpendingOrder");
			helper.showInfoMessage(component, event, infoMessage);
		} else{			
			helper.callCancelOrder(component, event);
			//todo refresh table
			var switchOnload = component.get("v.switchOnload");
			component.set("v.switchOnload",!switchOnload);
			var offertable = component.find("offertable");
			offertable.refresh();
		}
		
	},
	*/
	//END andrea.saracini 25/02/2018 - obsolete

	goToMaintenance: function(component, event, helper) {
	
		var offerAssetSelected = component.get("v.offerAssetSelected");
	//Start antonio.vatrano 17/04/2019 bugfix RI-3
      
      	/* ANDREA MORITTU START 07-Jan-2019 - PROD-367 - Adding missing code */
      	var currentUser = component.get("v.currentUser");
      	if($A.util.isEmpty(currentUser)){ //francesca.ribezzi 11/11/19 - PROD-42 - calling handleCurrentUser for operation to set abi and cab
			helper.handleCurrentUser(component, event, offerAssetSelected.NE__Order_Config__c);
		}
      	/* ANDREA MORITTU END 07-Jan-2019 - PROD-367 - Adding missing code */
      
      
		var clickedBtn = component.get("v.typologiesValue");
		if(clickedBtn == 'showPricing'){
			component.set("v.showAssetPricing", true);
			console.log('showPricing: perf31');
		}
		// var offerassetid = component.get("v.offerAssetId");
		/*
		if(offerAssetMap.keys().includes(offerassetid)){
			
			for(var key in offerAssetMap){
				// var offerAsset = offerAssetList[i];
				// console.log(' offerasset ' + JSON.stringify(offerAsset));
				//|| $A.util.isEmpty(offerAsset.OB_MCCL2__c)
				
				var offerAsset =  offerAssetMap[offerassetid];*/
				/*andrea.morittu start 2019.04.29 -- added control on clicked button inside if condition*/
		else if( !$A.util.isEmpty(offerAssetSelected) 
				 && offerAssetSelected.NE__Status__c == 'In Progress' &&
				 clickedBtn != 'showCoBa' && clickedBtn != 'changeCompanyName' ){
		//End antonio.vatrano 17/04/2019 bugfix RI-3 add else if
			// var pricingBtn = component.find("pricingBtn");
			// var editOfferBtn = component.find("editOfferBtn");
			// var editCommissionBtn = component.find("editCommissionBtn");
			// pricingBtn.set('v.disabled',true);
			// editOfferBtn.set('v.disabled', true);
			// editCommissionBtn.set('v.disabled',true);

			// component.set('v.pricingbtnDisabled',true);
			// component.set('v.offerBtnDisabled', true);
			// component.set('v.commissionbtnDisabled',true);
			// component.set('v.terminateDisabled',true);
			
			// component.set("v.offerAsset", offerAsset);
			console.log('primo else if: perf31');
			var infoMessage = $A.get("$Label.c.OB_pendingOrder");
			helper.showInfoMessage(component, event, infoMessage);
		}else if($A.util.isEmpty(offerAssetSelected.OB_MCCL2__c)){
			// component.set('v.pricingbtnDisabled',true);
			// component.set('v.offerBtnDisabled', true);
			// component.set('v.commissionbtnDisabled',true);
			// component.set('v.terminateDisabled',true);
			
			// component.set("v.offerAsset", offerAsset);
			console.log('secondo else if: perf31');
			var infoMessage = $A.get("$Label.c.OB_MCCL2empty");
			helper.showInfoMessage(component, event, infoMessage);
			/*andrea.morittu start 29.04.2019 - ID_Task_6-Subentro*/
		} else if(clickedBtn == 'changeCompanyName') {
			
			/* ANDREA MORITTU START 2019.05.09 - ID_Stream_6_Subentro */
			console.log('terzo  else if changeCompanyName: perf31');
			helper.updateAssetABIandCAB(component, event, helper );
			/* ANDREA MORITTU END 2019.05.09 - ID_Stream_6_Subentro */

			helper.showCompanyFunction(component, event, helper);
		} 
		/*ANDREA MORITTU START 2019.04.02*/
		else if(clickedBtn == 'showCoBa') {
		/*Simone.misani START 2019.05.06 - fix R1F2-100*/
		console.log('quarto   else if showCoBa: perf31');
			component.set('v.showCoBaModal', true);
		/*Simone.misani END 2019.05.06 - fix R1F2-100*/
		/*ANDREA MORITTU END 2019.04.02*/
		} 
		// ANDREA MORITTU START 05-Jun-2019 F2WAVE2-75
		else if(clickedBtn == 'terminateOfferBtn') {
			console.log('quinto   else if terminateOfferBtn: perf31');
			component.set('v.showTerminalOfferModal', true);
		} 
		// ANDREA MORITTU START 05-Jun-2019 F2WAVE2-75
		else {
			console.log('## current user is :Perf31 ' +  JSON.stringify(component.get("v.currentUser")));
			helper.callAssetToOrder(component, event);
		}
				/*} break;			
			}
		}else{
			helper.callAssetToOrder(component, event);
		
		}*/
		
	
	},
	
	handleFlowCartEvent: function(component, event, helper) {
		var goBackToMaintenanceDetails = event.getParam("goBackToMaintenanceDetails");
		//destroy the cmp created or memory leak!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
		//marco.ferri 
		component.find("flowCartCmp").destroy();
		//end
		component.set("v.showPriceSummary", false);
	},
	
	destroyFlowCart: function (component, event, helper){
		console.log("@@@ inside destryFlowCart");
		var flowcart = component.find("flowCartCmp");
		flowcart.destroy();
	},

	/*
	*	Author		:	Morittu Andrea
	*	Date		:	18-Sept-2019
	*	Task		:	EVO_PRODOB_452
	*	Description	:	Grabbing event that takes values of 'edit pricing' or 'edit commissional model'
	*/
	catchEventNewCartPriceSummary : function(component, event, helper) {
		var whichButtonClicked = event.getParam("whichAction"); 
		if(!$A.util.isUndefined(whichButtonClicked) && !$A.util.isEmpty(whichButtonClicked)) {
			component.set('v.buttonChosenInNewCartPriceSummary', whichButtonClicked);
			component.set('v.showAssetPricing', false);
			component.set('v.spinner', true);
			helper.callAssetToOrder(component, event);
		}
		// ANDREA MORITTU START 02-Oct-2019 - EVO_BACKLOG_245 - START
		let oldVISAMASTERCARDitemAttributes = event.getParam("oldVisaMastercard"); 
		component.set('v.oldVMAttributes',oldVISAMASTERCARDitemAttributes );
		// ANDREA MORITTU END 02-Oct-2019 - EVO_BACKLOG_245 - START
	},
	
	showInfoMessage_JS : function(component, event, helper, infoMessage) {
		helper.showInfoMessage(component, event, infoMessage);
	},
	
	/*	
		@Author	:	Morittu Andrea
		@Date	:	05-Jun-19
		@Task	:	Fix F2WAVE2-75
	*/
	chooseTerminateOfferAction : function(component, event, helper) {
		var currentSelection = event.getSource().get('v.name');
		var yesLabel = $A.get("$Label.c.OB_Yes");
		console.log('currentSelection is :' + currentSelection);
		if(currentSelection == yesLabel ) {
			helper.terminateOffer(component, event, helper);
		} else {
			helper.closeTerminateOfferModal(component, event, helper);
		}
	},
	/*
		@Author	:	Morittu Andrea
		@Date	:	05-Jun-19
		@Task	:	Fix F2WAVE2-75
	*/
	closeTerminalOfferModal : function(component, event, helper) {
		helper.closeTerminateOfferModal(component, event, helper);
	},
})