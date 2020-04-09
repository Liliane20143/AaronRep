({
	openActionWindow_helper : function(component, event, helper)
	{
		component.set("v.showConfigurationDetails", false);
	},

    // Start AV 21/02/2019 retrieve field of configuration OB_ShowAttachedDocumentations__c to show or not to show Documents
	showDocuments : function(component, event, helper)
	{
		var action = component.get("c.showCmpDocs");
        action.setParams({
            "orderHeaderId" : component.get("v.recordId")}
        );
        action.setCallback(this, function(response)
        {
            if (response.getState() === "SUCCESS")
            {
				var show = response.getReturnValue();
				console.log("@@@@show: "+show);
				if (show == 'true'){
					component.set("v.showComponentDocuments", true);
					console.log("##SHOW DOCUMENTS");
				}
				else{
					component.set("v.showComponentDocuments", false);
					console.log("##HIDE DOCUMENTS");
				}
            }
            else if (response.getState() === "INCOMPLETE")
            {
                console.log('incomplete'); 
            }
            else if (response.getState() === "ERROR") 
            {
				console.log('error')
            }
        });
        $A.enqueueAction(action);
	},
	// END AV 21/02/2019 retrieve field of configuration OB_ShowAttachedDocumentations__c to show or not to show Documents
	
	// Start AV 21/02/2019  show buttons CARICA and RIMUOVI if DOCUEMNTAZIONE ASSENTE/INCOMPLEATA [Schema STEFANO MONTORI]
	checkRejectReasons: function(component, event)
	{   
		var orderHeaderId = component.get("v.recordId");
		var action = component.get("c.checkRejectReason");
		action.setParams({"orderHeaderId" : orderHeaderId});    
		action.setCallback(this, function(response)
		{
			var state = response.getState();
			if (state === "SUCCESS") 
			{
				var checkReason = response.getReturnValue();
				console.log('@@checkReason: '+checkReason);
                
  			if(checkReason == 'true'){
				  component.set('v.rejectReasonBool', true);
				}
				 else
				 {
					component.set('v.rejectReasonBool', false);
				 }
                
			}
			else
			{
				console.log("NO USER");
			}
		});
		$A.enqueueAction(action);
	},
	// END AV 21/02/2019  show buttons CARICA and RIMUOVI if DOCUEMNTAZIONE ASSENTE/INCOMPLEATA [Schema STEFANO MONTORI]

	//START 	andrea.saracini 25/02/2019 - Cancell Order
    cancelOrder : function(component, event, helper)
	{
		var action = component.get("c.callCancelOrder");
		//Start antonio.vatrano r1f2-160 06/06/2019
		var confId;
		var confFromAsset = component.get("v.asset.NE__Order_Config__c");
		if( $A.util.isEmpty(confFromAsset) ){
			var configuration = component.get("v.configurations")[0];
			confId = configuration.Id;
		}else{
			confId = confFromAsset;
		}
        action.setParams({ 
			"orderId" : confId
		});
        action.setCallback(this, function(response) {
			var state = response.getState();
			console.log("###state: " + state);
            if (state === "SUCCESS") {
				var cancelled = response.getReturnValue();
				component.set("v.spinner", false);
				component.set("v.canBecancelled", false);
				component.set("v.showButtonFlow", false);
		//End antonio.vatrano r1f2-160 06/06/2019
				if(!cancelled){
					var infoMessage = $A.get("$Label.c.OB_NoCancel");
					this.showInfoMessage(component, event, infoMessage);
				}
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
				component.set("v.spinner", false);
			}
		});
        $A.enqueueAction(action);
    },
    //END 	andrea.saracini 25/02/2019 - Cancell Order

    /*
    * @author Joanna Mielczarek <joanna.mielczarek@accenture.com>
    * @date 07/05/2019
    * @description The method calls method from Apex : sets value of Nexi / Bank order status and timestamps
    * @history NEXI-20 07/05/2019 Created
    */
    setOrderStatusToDraftIncompleteOrder: function ( component )
    {
        let orderHeaderId = component.get( "v.recordId" );
        let action = component.get( "c.setOrderStatusDraftIncompleteOrder" );
        action.setParam( "orderHeaderId", orderHeaderId );
        action.setCallback( this, function( response ) {
            if ( response.getState( ) === "SUCCESS" )
            {
                console.log( "Nexi/Bank Order Status was updated." );
            }
            else
            {
                let errors = response.getError();
                let message = 'Unknown error';
                if (errors && Array.isArray(errors) && errors.length > 0)
                {
                    message = errors[0].message;
                }
                console.log( "Exception during update Nexi/Bank Order Status: " +  message );
            }
        });
        $A.enqueueAction( action );
	},
	/*
    * @author Giovanni Spinelli <spinelli.giovanni@accenture.com>
    * @date 23/08/2019
    * @description move in helper the same method from controller js
    * @history 
    */
   changeOwnerHelper : function ( component ){
	   //START-----Simone misani  change owner 19/06/2019
	   var orderHeaderId = component.get('v.recordId');
	   var action = component.get("c.changeOwnerForApprovalProcess");
	   action.setParams({ "orderHeaderId": orderHeaderId });
	   action.setCallback(this, function (response) {
		   if (response.getState() === "SUCCESS") {
			   console.log("Owner Order was updated.");
			   //END-----Simone misani  change owner 19/06/2019
			   var historicWizard = component.get("v.historicWizard");
			   console.log("historicWizard: " + JSON.stringify(historicWizard));
			   var historicWizardId = historicWizard['historicWizardData'][0].Id;
			   console.log("historicWizardId: " + historicWizardId);
			   component.set("v.historicWizardId", historicWizardId);

			   // NEXI-20 joanna.mielczarek@accenture.com 07/05/2019 START
			   // this.setOrderStatusToDraftIncompleteOrder(component); //gianluigi.virga 27/08/2019 - The order status must not change when a user selects "Riprendi Convenzionamento"
			   // NEXI-20 joanna.mielczarek@accenture.com 07/05/2019 STOP

			   $A.createComponent(
				   "bit2flow:dynWizardMain",
				   {
					   "params": "objectType=bit2flow__Historic_Wizard_Data__c,wizardConfigurationId=,displayMenu=" + false + ",sourceVF=" + false + ",showMainToast=" + false,
					   "recordId": historicWizardId
				   },
				   function (newCmp, status, errorMessage) {
					   console.log("status: " + status);
					   if (status === "SUCCESS" && newCmp.isValid()) {
						   console.log()
						   var body = component.get("v.body");
						   body.push(newCmp);
						   console.log('body is: ' + body);
						   component.set("v.body", body);
					   }
					   else if (status === "INCOMPLETE") {
						   this.showMessage("error", $A.get("$Label.bit2flow.b2f_State_incomplete"), false);
					   }
					   else if (status === "ERROR") {
						   this.showMessage("error", "Error: " + errorMessage, false);
					   }
				   }.bind(this)
			   );

			   component.set("v.showResumeFlow", true);
		   }  //START-----Simone misani  change owner 19/06/2019
		});
	    $A.enqueueAction(action);
		//END-----Simone misani  change owner 19/06/2019
   },
   fireToast: function(component , message){
	var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
		"type": "warning",
        "message": $A.get("$Label.c.OB_WarningResumeFlow") + ' '+message
    });
    toastEvent.fire();
   },
   //START gianluigi.virga 17/09/2019 - UX Print quote
   setOrderStatusToDraft: function ( component, event )
    {
		console.log('IN setOrderStatusToDraft');
        let action = component.get( "c.setOrderStatusDraft" );
		let orderToUpdate = component.get("v.configurations[0].Id");
		console.log('Order to update: '+orderToUpdate);
		action.setParams({
            "orderToUpdate" : orderToUpdate}
        );
        action.setCallback( this, function( response ) {
            if ( response.getState( ) === "SUCCESS" )
            {
                console.log( "Nexi/Bank Order Status was updated." );
            }
            else
            {
                let errors = response.getError();
                if ( errors && errors[0].message )
                {
                    console.log( "Exception during update Nexi/Bank Order Status: " + errors[0].message );
                }
            }
        });
        $A.enqueueAction( action );
	},
	changeOrderStatus: function(component,event, helper)
	{
		var currentUserId = $A.get("$SObjectType.CurrentUser.Id");
		var action = component.get("c.changeOrderStatusServer");
		var confId = component.get("v.configurations[0].Id");
		action.setParams({
			"currentUserId": currentUserId,
			"orderId" : confId
		});
		action.setCallback(this, function(response)
		{
			if (response.getState() === "SUCCESS")
			{	
				console.log("response: ", response.getReturnValue());
				
	            var res =  response.getReturnValue();
	            if(res)
	            {	
					//change JumpToStep
	            	this.manageHistoricWizard(component,event,helper);
				}
				else
				{
					//TODO set eventual spinner off and error toast.
				}
				
			}
			else if (response.getState() === "INCOMPLETE")
			{
				console.log("OB_ItemsApprovalStatus.changeOrderStatuses - INCOMPLETE"); 
			}
			else if (response.getState() === "ERROR") 
			{
				var errors = response.getError();
				if (errors) 
				{ 
					if (errors[0] && errors[0].message) 
					{
						console.log("OB_ItemsApprovalStatus.changeOrderStatuses - Error message: " + errors[0].message);
					}
				}
				else 
				{
					console.log("OB_ItemsApprovalStatus.changeOrderStatuses - UNKNOWN ERROR"); 
				}
			}
		});
		$A.enqueueAction(action);
	},
	manageHistoricWizard: function(component,event,helper){
	
		var historicWizard 	= component.get("v.historicWizardQuote");
		console.log("historicWizardQuote: "+JSON.stringify(historicWizard));

		var historicWizardId = "";
		var confId = component.get("v.configurations[0].Id");
		for (var key in historicWizard)
		{
			if (key == confId)
			{
				historicWizardId = historicWizard[key];
				break;
			}
		}
		var historicWizardIdString = historicWizard[confId];
		console.log("historicwizardidQuote: "+historicWizardIdString);
		component.set("v.historicwizardidQuote",historicWizardIdString);
		
		this.changeJumpToStepHistoricAttachment(component, event, helper, historicWizardIdString);
		
	},
	
	changeJumpToStepHistoricAttachment: function(component, event, helper, historicWizardIdString)
	{
		var action = component.get("c.changeJumpToStepHistoricAttachment");
		action.setParams
		({
			historicWizardId : historicWizardIdString
		});
		action.setCallback(this, function(response)
		{
			if (response.getState() === "SUCCESS")
			{	
				console.log("response: ", response.getReturnValue());
				
	            var resId =  response.getReturnValue();
	            if(resId != null)
	            {	
	            	//dynamically create component bit2flow!
	            	this.dynamicallyCreateBit2flow(component,event,resId);
				}
				else
				{
					//TODO set eventual spinner off and error toast.
				}
				
			}
			else if (response.getState() === "INCOMPLETE")
			{
				console.log("OB_ItemsApprovalStatus.changeJumpToStepHistoricAttachment - INCOMPLETE"); 
			}
			else if (response.getState() === "ERROR") 
			{
				var errors = response.getError();
				if (errors) 
				{ 
					if (errors[0] && errors[0].message) 
					{
						console.log( "OB_ItemsApprovalStatus.changeJumpToStepHistoricAttachment - Error message: " +
						             errors[0].message);
					}
				}
				else 
				{
					console.log("OB_ItemsApprovalStatus.changeJumpToStepHistoricAttachment - UNKNOWN ERROR"); 
				}
			}
		});
		$A.enqueueAction(action);
	},
	dynamicallyCreateBit2flow: function(component,event,resId)
	{
		console.log("into dynamicallyCreateBit2flow with resId "+resId);
		$A.createComponent(
		"bit2flow:dynWizardMain",
		{
			"params": "objectType=bit2flow__Historic_Wizard_Data__c,wizardConfigurationId=,displayMenu="+false+",sourceVF="+false+",showMainToast="+false,
			"recordId": resId
		},
			function(newCmp, status, errorMessage)
			{
				if (status === "SUCCESS" && newCmp.isValid()) 
				{
					var body = component.get("v.body");
					body.push(newCmp);
					component.set("v.body", body);
				}
				else if (status === "INCOMPLETE")
				{
					// this.showMessage("error",$A.get("$Label.bit2flow.b2f_State_incomplete"),false);
					// Show offline error
					console.log("Error: ", $A.get("$Label.bit2flow.b2f_State_incomplete"));
				} 
				else if (status === "ERROR") 
				{
					// this.showMessage("error","Error: " + errorMessage,false);
					// Show error message
					console.log("Error: " + errorMessage);
				}
			}.bind(this)     
    	);
    	component.set("v.showResumeFlow",true);          	
	},
	retrieveHistoricWizardData_Helper : function(component,helper,event)
	{
		console.log('## retrieveHistoricWizardData_Helper');
		var actionwiz = component.get("c.retrieveHistoricWizardData");
		actionwiz.setParams
		({
			"configurations" : component.get("v.configurations")
		});
		actionwiz.setCallback(this, function(response)
		{
			if (response.getState() === "SUCCESS")
			{
				console.log("OB_ItemsApprovalStatus.retrieveHistoricWizardData_Helper - SUCCESS"); 

				var historicWizard 	= {};
				historicWizard 		= response.getReturnValue();
				console.log( "OB_ItemsApprovalStatus.retrieveConfigurationApproval_Helper - historicWizard: " +
				             JSON.stringify( historicWizard ) );
				component.set("v.historicWizardQuote",historicWizard);	

			}
			else if (response.getState() === "INCOMPLETE")
			{
				console.log("OB_ItemsApprovalStatus.retrieveHistoricWizardData_Helper - INCOMPLETE"); 
			}
			else if (response.getState() === "ERROR") 
			{
				var errors = response.getError();
				if (errors) 
				{ 
					if (errors[0] && errors[0].message) 
					{
						console.log( "OB_ItemsApprovalStatus.retrieveHistoricWizardData_Helper - Error message: " +
						             errors[0].message );
					}
				}
				else 
				{
					console.log("OB_ItemsApprovalStatus.retrieveHistoricWizardData_Helper - UNKNOWN ERROR"); 
				}
			}
		});
		$A.enqueueAction(actionwiz);
	},
	//END gianluigi.virga

	/*
    *   Author  :   Morittu Andrea
    *   Date    :   11-Oct-2019
    *   Task    :   EVO_PRODOB_450
    *   Descrip :   Function of 'Detail location' button
    */
	servicePointModalAction_Helper : function(component, event) {
		try {
			// TO CHECK NAME OF BUTTON
			const locationDetails =  $A.get("$Label.c.OB_Details") + ' ' +  $A.get("$Label.c.OB_LocationLabel");

			let whichButton = event.getSource().get('v.name');
			switch(whichButton) {
				case locationDetails:
					component.set('v.showServicePointModal', true);
				break;
				case $A.get("$Label.c.OB_Cancel"):
					component.set('v.showServicePointModal', false);
				break;
			}
		}catch(e) {
			console.log('An error has occured inside openServicePointDetails_Helper : ' + e.message);
		}
	},
  
  /*
    *   Author  :   Morittu Andrea
    *   Date    :   11-Oct-2019
    *   Task    :   EVO_PRODOB_450
    *   Descrip :   Function of 'Detail location' button
  */
	servicePointModalAction_Helper : function(component, event) {
		try {
			// TO CHECK NAME OF BUTTON
			const locationDetails =  $A.get("$Label.c.OB_Details") + ' ' +  $A.get("$Label.c.OB_LocationLabel");

			let whichButton = event.getSource().get('v.name');
			switch(whichButton) {
				case locationDetails:
					component.set('v.showServicePointModal', true);
				break;
				case $A.get("$Label.c.OB_Cancel"):
					component.set('v.showServicePointModal', false);
				break;
			}
		}catch(e) {
			console.log('An error has occured inside openServicePointDetails_Helper : ' + e.message);
		}
	},

})