({
	doInit : function(component,event,helper) 
	{
		helper.getUserInformation_Helper(component,helper,event);
	},

	/**
    * @author ?
    * @date ?
    * @description  Resume Flow
    * @history 07/05/2019 <joanna.mielczarek@accenture.com> calls method from helper to set order statuses
    **/
	resumeTheFlow : function(component,event,helper) 
	{
	    //05/03/19 francesca.ribezzi adding alreadyClicked to block user clicking on button twice
		var alreadyClicked = component.get("v.alreadyClicked");
		if(alreadyClicked)
		{
			return;
		}
		else
		{
			component.set("v.alreadyClicked", true);
		}
		console.log( "confId: " + event.getSource().get( "v.class" ) );
		var confId = event.getSource().get("v.class");
		var historicWizard = component.get( "v.historicWizard" );
		console.log( "historicWizard: " + JSON.stringify( historicWizard ) );

		// NEXI-20 joanna.mielczarek@accenture.com 29/04/2019 START
        helper.setOrderStatusToDraftIncompleteOrder( component, event );
        // NEXI-20 joanna.mielczarek@accenture.com 29/04/2019 STOP

		var historicWizardId = "";
		for ( var key in historicWizard )
		{
			if ( key == confId )
			{
				historicWizardId = historicWizard[ key ];
				break;
			}
		}

		var historicWizardId = historicWizard[ confId ];
		console.log( "historicWizardId: " + historicWizardId );
		component.set( "v.historicWizardId" , historicWizardId );

		$A.createComponent(
			"bit2flow:dynWizardMain",
			{
				"params": "objectType=bit2flow__Historic_Wizard_Data__c,wizardConfigurationId=,displayMenu=" + false +",sourceVF="+false+",showMainToast="+false,
				"recordId": historicWizardId
			},
			function(newCmp, status, errorMessage)
			{
				if ( status === "SUCCESS" && newCmp.isValid() )
				{
					var body = component.get( "v.body" );
					body.push( newCmp );
					console.log( 'body is: '  + body );
					component.set( "v.body" , body );
				}
				else if ( status === "INCOMPLETE" )
				{
					this.showMessage( "error",$A.get( "$Label.bit2flow.b2f_State_incomplete" ), false );
					// Show offline error
				} 
				else if ( status === "ERROR" )
				{
					this.showMessage( "error","Error: " + errorMessage, false );
					// Show error message
				}
			}.bind( this )
		);

		component.set( "v.showResumeFlow", true );

	},
	
	/**
    * @author marco.ferri
    * @date 07/01/2019
    * @description  Resume Flow Reject
    * @history 07/05/2019 <joanna.mielczarek@accenture.com> calls method from helper to set order statuses
    **/
	resumeTheFlowReject: function(component, event, helper)
	{
	    // NEXI-20 joanna.mielczarek@accenture.com 29/04/2019 START
        helper.setOrderStatusToDraft( component, event );
        // NEXI-20 joanna.mielczarek@accenture.com 29/04/2019 STOP

		//05/03/19 francesca.ribezzi adding alreadyClicked to block user clicking on button twice
		var alreadyClicked = component.get("v.alreadyClicked");
		if(!alreadyClicked){
			console.log("confId: "+ event.getSource().get("v.class"));
			var confId = event.getSource().get("v.class");
			//Change order & orderItem fullfillment status to draft
			component.set("v.alreadyClicked", true);
			helper.changeOrderStatus(component,event,confId);
		}
	},
	
	//	START 	micol.ferrari 24/12/2018
	openModalUploadDocs : function(component, event, helper)
	{
		var currentOrderHeader = event.getSource().get( "v.class" );
		var currentAccount = event.getSource().get( "v.name" );

		//	START 	micol.ferrari 19/02/2019	
		var currentConfigurationId = event.getSource().get( "v.value" );
		//	END 	micol.ferrari 19/02/2019

		component.set( "v.currentOrderHeaderId", currentOrderHeader );
		component.set( "v.currentAccountId", currentAccount );

		//	START 	micol.ferrari 19/02/2019	
		component.set( "v.currentConfigurationId", currentConfigurationId );
		//	END 	micol.ferrari 19/02/2019

		component.set( "v.showModalUploadDocs", true );
	},

	closeModalUploadDocs : function(component, event, helper)
	{
		//	START 	micol.ferrari 19/02/2019	
		helper.closeModalUploadDocs_Helper(component, event, helper);
		//	END 	micol.ferrari 19/02/2019
	},
	//	END 	micol.ferrari 24/12/2018

	// DG 05/02/2019
	denyPricingVariation : function(component, event, helper)
	{
		console.log( "In denyPricingVariation, confId: " + event.getSource().get( "v.class" ) );
		var confId = event.getSource().get( "v.class" );
		helper.callCancelButton(component, event, confId);
	},

	// DG 06/02/2019
	goToDocumentPage : function(component, event, helper){
		console.log( "##Into goToDocument: ");
		var orderId = event.getSource().get( "v.class" );
		console.log("##Into orderId: " + orderId );
		var urlString = window.location.href;
		console.log( "##Into url: " + urlString );
		var goToUrl = urlString.replace( 'ob-items-final-approve-status', 'ob-upload-documents' );
		console.log( "##Into goToUrld: " + goToUrl );
		goToUrl  += '?Id=' + orderId;
		console.log( "goToUrl with Id: " + goToUrl );
		//timeout 
		window.setTimeout(
			$A.getCallback(function() {
				window.location.replace(goToUrl);
		    }), 2500
		)
	},

	// DG 06/02/2019
	backToStep1MaintenanceFlow : function(component, event, helper){
		console.log( "In backToStep1MaintenanceFlow" );
		var confId = event.getSource().get( "v.class" );
		console.log( "In confId: " + confId );
		var object = "Object";
		console.log( "In Object: " + object );
		var wizardName = "OB_Maintenance_Catalogo_Nuovo_Contratto";
		console.log( "In wizardName: " + wizardName );
		var action = component.get( "c.launchMaintenanceWizard" );
		console.log( "In action: " + action );
		action.setParams({
			"wizardName": wizardName
		});
		console.log("After set Params");

		action.setCallback(this, function( response )
		{
            var state = response.getState();
            if ( state === "SUCCESS" )
            {
					var wizId = response.getReturnValue();

					$A.createComponent("bit2flow:dynWizardMain",
							{          
									"wizardConfigurationId": wizId,
									"sourceVF": true,
									"objectId": confId,
									"objectType": object,
									"displayMenu" : false,
									"params" : 'Id::'+confId,
									"showMainToast": false
							},

							function(newCmp, status, errorMessage){
								if ( status === "SUCCESS" && newCmp.isValid() ) {
									var body = component.get( "v.body" );
									//MAS && AAP 24/08/2018  avoid launching more than one wizard at the same time and window
									if ( $A.util.isUndefinedOrNull ( body ) || body.length > 0 ){
											body = [];
											component.set( "v.body", body );
									}
									//END MAS && AAP 24/08/2018 
									body.push( newCmp );
									component.set( "v.body", body );
								} else if (status === "INCOMPLETE") {
								} else if (status === "ERROR") {
								}
							}.bind( this )
					);
					component.set( "v.showResumeFlow", true );

            } 
            else if ( state === "ERROR" )
            {
            	_utils.debug( 'GET WIZARD ID FROM API NAME ERROR' );
            }
        });
		$A.enqueueAction( action );
	},

	// 	START	micol.ferrari 19/02/2019 - #1388 - RESUBMIT BIO
	resubmitBIO : function(component, event, helper)
	{
		var actionBIO = component.get( "c.callResubmitBIO" );
		actionBIO.setParams
		({
			confId 	: component.get( "v.currentConfigurationId" )
		});
		actionBIO.setCallback( this, function( response )
		{
			if ( response.getState() === "SUCCESS" )
			{
				console.log( "OB_ItemsToApprove.resubmitBIO - SUCCESS" );

				var BIOok = response.getReturnValue();
				console.log( "## BIOok " + BIOok );
				if ( BIOok )
				{
					helper.closeModalUploadDocs_Helper(component, event, helper);
					$A.get( 'e.force:refreshView' ).fire();
				}
			}
			else if ( response.getState() === "INCOMPLETE" )
			{
				console.log( "OB_ItemsToApprove.resubmitBIO - INCOMPLETE" );
			}
			else if ( response.getState() === "ERROR" )
			{
				var errors = response.getError();
				if ( errors )
				{ 
					if ( errors[0] && errors[0].message )
					{
						console.log( "OB_ItemsToApprove.resubmitBIO - Error message: " + errors[0].message );
					}
				}
				else 
				{
					console.log( "OB_ItemsToApprove.resubmitBIO - UNKNOWN ERROR" );
				}
			}
		});

		// <!-- Start AV 20/02/2019 1388 can resubmit if all docs was loaded  -->
		var canRes = component.get( "v.canResubmit" );
		console.log("@@canRes: "+canRes);
		if ( canRes == "true" )
		{
			$A.enqueueAction(actionBIO);
		}
		else
		{
			var toastEvent = $A.get( "e.force:showToast" );
			toastEvent.setParams({
				title: 'ERRORE',
				message: 'CARICARE TUTTI I DOCUMENTI',
				duration: '5000',
				type: 'error',
				mode: 'dismissible'
			});
			toastEvent.fire();
		}
	},

	// 	END		micol.ferrari 19/02/2019 - #1388 - RESUBMIT BIO
	//giovanni spinelli 21/02/2019 - open modal merchant detail
	openModalMerchantDetails: function(component,event,helper)
	{
		var ordId 		= event.target.id;
		console.log('ORD ID: ' + ordId);
		var configurations 	= component.get("v.configurations");
		console.log('configurations: '+ JSON.stringify(configurations));
		try{
			for (var configuration in configurations)
			{
				console.log(' work item: ' + configuration);
				console.log('MERCHANT ID: ' + JSON.stringify(configurations[configuration]));
				console.log('ORD ID: ' + ordId);
				console.log('ORD ID 2: ' + configurations[configuration].NE__AccountId__r.Id);
				if (configurations[configuration].NE__AccountId__r.Id == ordId){
					console.log('SUCCESS: '+ configurations[configuration].NE__AccountId__r.Id);
					//save merchant id selected
					console.log('tipe of id: ' +typeof configurations[configuration].NE__AccountId__r.Id);
					component.set('v.merchantId' , configurations[configuration].NE__AccountId__r.Id);
					component.set('v.actualABI' , configurations[configuration].OB_ABI__c);
					break;
				}

			}
			helper.getAccountInformation(component,event,helper);
		}
		catch(err){
			console.log('ERROR IN OPEN MODAL: '+ err.message);
		}
		
		console.log('configurations ID: '+ JSON.stringify(configurations));
		component.set("v.contextConfigurationId",event.target.id);
		
	},

	closeModalMerchantDetails: function(component,event,helper)
	{
		component.set("v.openModalmerchantDetails",false);
	},
	// 	END		micol.ferrari 19/02/2019 - #1388 - RESUBMIT BIO
	/*
		giovanni spinelli - start 
		date: 18/07/2019
		refresh page without filter
		*/
	refreshPage: function(component,event,helper){
		var url = window.location.href;
		window.location.href = url.split('?')[0];
		component.set('v.showRefreshButton' , false);
	},

	// Daniele Gandini <daniele.gandini@accenture.com> - 21/05/2019 - TerminalsReplacement - Redirect in case of pricing approval process in the tech details - START
	backToStep1MaintenanceFlowReplacement : function(component, event, helper){
		console.log( "In backToStep1MaintenanceFlowReplacement" );
		var confId = event.getSource().get( "v.class" );
		console.log( "In confId: " + confId );
		var object = "Object";
		console.log( "In Object: " + object );
		var wizardName = "OB_Maintenance_Sostituzione";
		console.log( "In wizardName: " + wizardName );
		var action = component.get( "c.launchMaintenanceWizard" );
		console.log( "In action: " + action );
		action.setParams({
			"wizardName": wizardName
		});
		console.log("After set Params");

		action.setCallback(this, function( response )
		{
            var state = response.getState();
            if ( state === "SUCCESS" )
            {
					var wizId = response.getReturnValue();

					$A.createComponent("bit2flow:dynWizardMain",
							{          
									"wizardConfigurationId": wizId,
									"sourceVF": true,
									"objectId": confId,
									"objectType": object,
									"displayMenu" : false,
									"params" : 'Id::'+confId,
									"showMainToast": false
							},

							function(newCmp, status, errorMessage){
								if ( status === "SUCCESS" && newCmp.isValid() ) {
									var body = component.get( "v.body" );
									//MAS && AAP 24/08/2018  avoid launching more than one wizard at the same time and window
									if ( $A.util.isUndefinedOrNull ( body ) || body.length > 0 ){
											body = [];
											component.set( "v.body", body );
									}
									//END MAS && AAP 24/08/2018 
									body.push( newCmp );
									component.set( "v.body", body );
								} else if (status === "INCOMPLETE") {
								} else if (status === "ERROR") {
								}
							}.bind( this )
					);
					component.set( "v.showResumeFlow", true );

            } 
            else if ( state === "ERROR" )
            {
            	_utils.debug( 'GET WIZARD ID FROM API NAME ERROR' );
            }
        });
		$A.enqueueAction( action );
	},
	// Daniele Gandini <daniele.gandini@accenture.com> - 21/05/2019 - TerminalsReplacement - Redirect in case of pricing approval process in the tech details - END
})