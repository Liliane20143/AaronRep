({
	getUserInformation_Helper : function(component,helper,event) 
	{
		console.log("OB_ItemsToApprove.getUserInformation_Helper - INSIDE"); 
		var action = component.get("c.getUserInformation");
		action.setCallback(this, function(response)
		{
			if (response.getState() === "SUCCESS")
			{
				console.log("OB_ItemsToApprove.getUserInformation_Helper - SUCCESS"); 

				var contextuser = {};
				contextuser 	= response.getReturnValue();
				console.log("OB_ItemsToApprove.getUserInformation_Helper - contextuser: "+JSON.stringify(contextuser)); 
				if (contextuser!=null && contextuser.Profile.UserLicense.Name == $A.get("$Label.c.OB_License_PartnerCommunity"))
				{
					component.set("v.contextABI",contextuser.Contact.Account.OB_ABI__c);
					component.set("v.contextCAB",contextuser.OB_CAB__c);
					this.retrieveConfigurationApproval_Helper(component,helper,event);
				}
			}
			else if (response.getState() === "INCOMPLETE")
			{
				console.log("OB_ItemsToApprove.getUserInformation_Helper - INCOMPLETE"); 
			}
			else if (response.getState() === "ERROR") 
			{
				var errors = response.getError();
				if (errors) 
				{ 
					if (errors[0] && errors[0].message) 
					{
						console.log("OB_ItemsToApprove.getUserInformation_Helper - Error message: " + errors[0].message);
					}
				}
				else 
				{
					console.log("OB_ItemsToApprove.getUserInformation_Helper - UNKNOWN ERROR"); 
				}
			}
		});
		$A.enqueueAction(action);
	},

	retrieveConfigurationApproval_Helper : function(component,helper,event) 
	{
		/*
		giovanni spinelli - start 
		date: 15/07/2019
		get filter from url if 'gestisci pratiche' tab is opened from home page button
		pass this filter to query
		*/
		try {
			var url = window.location.href;
			console.log('url: ' + url);
			var urlSplit = url.split('filter=')[1];
			console.log('urlSplit: ' + urlSplit);
			var filterValue='';
			if (urlSplit) {
				filterValue = urlSplit.replace(/\+/g, ' ');
				component.set('v.showRefreshButton' , true);
				console.log('filterValue: ' + filterValue);
				
			}
		} catch (err) {
			console.log('ERROR: ' + err.message);
		}
		var action = component.get("c.retrieveConfigurationApproval");
		action.setParams
		({
			contextABI 	: component.get("v.contextABI"),
			contextCAB 	: component.get("v.contextCAB"),
			filterValue	: filterValue
		});
		action.setCallback(this, function(response)
		{
			if (response.getState() === "SUCCESS")
			{
				console.log("OB_ItemsApprovalStatus.retrieveConfigurationApproval_Helper - SUCCESS"); 				
			
				var configurationList 	 		= response.getReturnValue();

				console.log("OB_ItemsApprovalStatus.retrieveConfigurationApproval_Helper - configurations: " +
				            JSON.stringify( configurationList ));

				if (configurationList!=null)
				{
					console.log("OB_ItemsApprovalStatus.retrieveConfigurationApproval_Helper  INSIDE");
					component.set("v.configurations",configurationList); 
					this.retrieveHistoricWizardData_Helper(component,helper,event);
					//giovanni spinelli
					this.retrieveOrdersComments(component);
					//giovanni spinelli
				}
			}
			else if (response.getState() === "INCOMPLETE")
			{
				console.log("OB_ItemsApprovalStatus.retrieveConfigurationApproval_Helper - INCOMPLETE"); 
			}
			else if (response.getState() === "ERROR") 
			{
				var errors = response.getError();
				if (errors) 
				{ 
					if (errors[0] && errors[0].message) 
					{
						console.log( "OB_ItemsApprovalStatus.retrieveConfigurationApproval_Helper - Error message: " +
						             errors[0].message );
					}
				}
				else 
				{
					console.log("OB_ItemsApprovalStatus.retrieveConfigurationApproval_Helper - UNKNOWN ERROR"); 
				}
			}
		});
		$A.enqueueAction(action);
	},
	retrieveHistoricWizardData_Helper : function(component,helper,event)
	{
		console.log('## retrieveHistoricWizardData_Helper');
		var actionwiz = component.get("c.retrieveHistoricWizardData");
		actionwiz.setParams
		({
			configurations : component.get("v.configurations")
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
				component.set("v.historicWizard",historicWizard);	

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
	
	//START	marco.ferri 07/01/2019
	changeOrderStatus: function(component,event,confId)
	{
		//@author Francesca Ribezzi <francesca.ribezzi@accenture.com>
		//@date 16/04/19
		//@task R1F2-28
		//@description getting user to update order's owner id with it 
		//and adding currentUserId parameter to action
		var currentUserId = $A.get("$SObjectType.CurrentUser.Id");
		var action = component.get("c.changeOrderStatusServer");
		action.setParams
		({
			currentUserId: currentUserId,
			orderId : confId
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
	            	this.manageHistoricWizard(component,event,confId);
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
	
	manageHistoricWizard: function(component,event,confId){
	
		var historicWizard 	= component.get("v.historicWizard");
		console.log("historicWizard: "+JSON.stringify(historicWizard));

		var historicWizardId = "";
		for (var key in historicWizard)
		{
			if (key == confId)
			{
				historicWizardId = historicWizard[key];
				break;
			}
		}
		var historicWizardIdString = historicWizard[confId];
		console.log("historicWizardId: "+historicWizardIdString);
		component.set("v.historicWizardId",historicWizardIdString);
		
		//TODO Apex: change changeJumpToStepHistoricAttachment
		this.changeJumpToStepHistoricAttachment(component,event,historicWizardIdString);
		
	},
	
	changeJumpToStepHistoricAttachment: function(component,event,historicWizardIdString)
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
					this.showMessage("error",$A.get("$Label.bit2flow.b2f_State_incomplete"),false);
					// Show offline error
				} 
				else if (status === "ERROR") 
				{
					this.showMessage("error","Error: " + errorMessage,false);
					// Show error message
				}
			}.bind(this)     
    	);
    	component.set("v.showResumeFlow",true);          	
	},
	//END marco.ferri 07/01/2019
	
	// DG - 05/02/2019
	callCancelButton : function(component,event,confId)
	{
		console.log("##callCancelButton: "+confId);

		var action = component.get("c.cancelPricingOperation");
		action.setParams
		({
			orderId : confId
		});
		action.setCallback(this, function(response)
		{
			if (response.getState() === "SUCCESS")
			{	
				console.log("callCancelButtom response: ", response.getReturnValue());
				
	            var res =  response.getReturnValue();
	            if(res)
	            {	
					//	CALL CANCEL ORDER AND CHILDREN
					console.log("##cancelOrderAndChildren: "+confId);
					var actioncancel = component.get("c.cancelOrderAndChildren");
					actioncancel.setParams
					({
						orderId : confId
					});
					actioncancel.setCallback(this, function(response)
					{
						if (response.getState() === "SUCCESS")
						{	
							console.log('ok cancelOrderAndChildren');
						}
						else if (response.getState() === "INCOMPLETE")
						{
							console.log("callCancelButtom - INCOMPLETE"); 
						}
						else if (response.getState() === "ERROR") 
						{
							var errors = response.getError();
							if (errors) 
							{ 
								if (errors[0] && errors[0].message) 
								{
									console.log("callCancelButtom - Error message: " + errors[0].message);
								}
							}
							else 
							{
								console.log("callCancelButtom - UNKNOWN ERROR"); 
							}
						}
					});
					$A.enqueueAction(actioncancel);
				}
				else
				{
					console.log('ko callCancelButton');
				}
				
			}
			else if (response.getState() === "INCOMPLETE")
			{
				console.log("callCancelButtom - INCOMPLETE"); 
			}
			else if (response.getState() === "ERROR") 
			{
				var errors = response.getError();
				if (errors) 
				{ 
					if (errors[0] && errors[0].message) 
					{
						console.log("callCancelButtom - Error message: " + errors[0].message);
					}
				}
				else 
				{
					console.log("callCancelButtom - UNKNOWN ERROR"); 
				}
			}
		});
		$A.enqueueAction(action);
		$A.get('e.force:refreshView').fire();
	}, 

	//	START 	micol.ferrari 19/02/2019	
	closeModalUploadDocs_Helper : function(component,event,helper) 
	{
		component.set("v.showModalUploadDocs",false);
		component.set("v.currentOrderHeaderId",null);
		component.set("v.currentAccountId",null);

		//	START 	micol.ferrari 19/02/2019	
		component.set("v.currentConfigurationId",null);
		//	END 	micol.ferrari 19/02/2019
	}, 
	//	END 	micol.ferrari 19/02/2019
	getAccountInformation : function(component,event,helper) {
		var action = component.get("c.getAccountInfo");
		var merchantId = component.get('v.merchantId');
		var contextABI = component.get("v.actualABI");
		try{
			action.setParams
			({
				merchantId : merchantId , contextABI : contextABI
			});
			action.setCallback(this, function(response)
			{
				console.log('STATE IN GET MERCHANT IS: '+ response.getState());
				if (response.getState() === "SUCCESS")
				{
					var responseData = response.getReturnValue();
					component.set('v.objectDataModal' , responseData);
					component.set("v.openModalmerchantDetails",true);
					console.log('responseData: ' + JSON.stringify(responseData));
				}
				else if (response.getState() === "INCOMPLETE")
				{
					
				}
				else if (response.getState() === "ERROR") 
				{
					var errors = response.getError();
					if (errors) 
					{ 
						if (errors[0] && errors[0].message) 
						{
							console.log("OB_ItemsToApprove.retrieveItemsToApprove_Helper - Error message: " + errors[0].message);
						}
					}
					else 
					{
						console.log("OB_ItemsToApprove.retrieveItemsToApprove_Helper - UNKNOWN ERROR"); 
					}
				}
			});
			$A.enqueueAction(action);
		}catch(err){
			console.log('ERROR IN OPEN MODAL HELPER: '+ err.message);
		}
		
	},
	//	END 	micol.ferrari 19/02/2019

    /**
    * @author Joanna Mielczarek <joanna.mielczarek@accenture.com>
    * @date 29/04/2019
    * @description The method calls method from Apex : sets value of Nexi / Bank order status and timestamps
    * @history NEXI-20 29/04/2019 Created
    **/
    setOrderStatusToDraftIncompleteOrder: function ( component, event )
    {
        let action = component.get( "c.setOrderStatusDraftIncompleteOrder" );
        let orderToUpdate = event.getSource( ).get( "v.class" );
        action.setParam( "orderToUpdate", orderToUpdate );
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

    /**
    * @author Joanna Mielczarek <joanna.mielczarek@accenture.com>
    * @date 29/04/2019
    * @description The method calls method from Apex : sets value of Nexi / Bank order status and timestamps
    * @history NEXI-20 29/04/2019 Created
    **/
    setOrderStatusToDraft: function ( component, event )
    {
        let action = component.get( "c.setOrderStatusDraft" );
        let orderToUpdate = event.getSource( ).get( "v.class" );
        action.setParam( "orderToUpdate", orderToUpdate );
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
	/**
    * @author Giovanni spinelli <spinelli.giovannik@accenture.com>
    * @date 30/07/2019
    * @description create a new field in order list with last comment of approver
    * @history 30/07/2019
    **/
	retrieveOrdersComments : function(component){
		try{
			
			var orderList = component.get('v.configurations'),
			idOrderList = [];
			/*
			create a list of order id to pass to apex method
			*/
			for(var order in orderList){
				console.log('ID: ' + orderList[order]['Id']);
				idOrderList.push(orderList[order]['Id']);
			}
			console.log('idOrderList: ' , idOrderList);
			var action = component.get( "c.retrieveComments" );
			action.setParams( { idOrderList : idOrderList } );
			action.setCallback( this, function( response ) {
				if ( response.getState( ) === "SUCCESS" )
				{
					var responseData = response.getReturnValue();
					console.log('response: ' , responseData);
					/*
					loop to match if orders in table have a step comment
					if yes create a new field 'comment' on which store the comment string
					*/
					for(var order in orderList){
						var orderId = orderList[order]['Id'];
						for(var orderIdStep in responseData){
							console.log('orderIdStep comment: ' + responseData[orderIdStep]);
							var comment = responseData[orderIdStep];
							if( orderId == orderIdStep  ){
								orderList[order]['comment']  = comment;
								console.log('SINGLE OBJECT: ' , orderList[order]);
							}
						}
					}
					component.set('v.configurations' , orderList);
				}
				else
				{
					let errors = response.getError();
					if ( errors && errors[0].message )
					{
						console.log( "Exception during retrieve comments: " + errors[0].message );
					}
				}
			});
			$A.enqueueAction( action );
	}catch(err){
		console.log("Exception during retrieve comments: " + err.message);
	}
	}

})