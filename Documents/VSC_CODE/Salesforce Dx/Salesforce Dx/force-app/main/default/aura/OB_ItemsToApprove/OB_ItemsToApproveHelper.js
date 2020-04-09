({
	getUserInformation_Helper : function(component, helper, event)
	{
		console.log( "OB_ItemsToApprove.getUserInformation_Helper - INSIDE" );
		var action = component.get( "c.getUserInformation" );
		action.setCallback( this, function( response )
		{
			if ( response.getState() === "SUCCESS" )
			{
				console.log( "OB_ItemsToApprove.getUserInformation_Helper - SUCCESS" );
				var contextuser = {};
				if ( response.getReturnValue() != null )
				{
					contextuser = response.getReturnValue();
					if ( contextuser != null && contextuser.Profile.UserLicense.Name == $A.get( "$Label.c.OB_License_PartnerCommunity" ) )
					{
						component.set( "v.contextABI", contextuser.Contact.Account.OB_ABI__c );
						component.set( "v.contextCABs", contextuser.OB_CAB__c ); // NEX-006 joanna.mielczarek@accenture.com, 20.03.2019

						this.retrieveItemsToApprove_Helper(component, helper, event);
					}
				}
			}
			else if ( response.getState() === "INCOMPLETE" )
			{
				console.log( "OB_ItemsToApprove.getUserInformation_Helper - INCOMPLETE" );
			}
			else if ( response.getState() === "ERROR" )
			{
				var errors = response.getError();
				if ( errors )
				{ 
					if ( errors[0] && errors[0].message )
					{
						console.log( "OB_ItemsToApprove.getUserInformation_Helper - Error message: " + errors[0].message );
					}
				}
				else 
				{
					console.log( "OB_ItemsToApprove.getUserInformation_Helper - UNKNOWN ERROR" );
				}
			}
		});
		$A.enqueueAction( action );
	},
	retrieveItemsToApprove_Helper : function(component, helper, event)
	{
		/*
		giovanni spinelli - start 
		date: 16/07/2019
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
		var action = component.get( "c.retrieveItemsToApprove" );
		action.setParams
		({
			contextABI : component.get( "v.contextABI" ),
			contextCAB : component.get( "v.contextCABs" ), // NEX-006 joanna.mielczarek@accenture.com, 20.03.2019
			filterValue: filterValue 					   // giovanni spinelli 17/07/2019 add value to filter query
		});
		action.setCallback( this, function( response )
		{
			if ( response.getState() === "SUCCESS" )
			{
				console.log( "OB_ItemsToApprove.retrieveItemsToApprove_Helper - SUCCESS" );
				var workitems = {};
				workitems = response.getReturnValue();
				console.log( "OB_ItemsToApprove.retrieveItemsToApprove_Helper - workitems: " + JSON.stringify( workitems ) );
				if (workitems!=null)
				{
					component.set("v.workitems",workitems);
				}
			}
			else if (response.getState() === "INCOMPLETE")
			{
				console.log("OB_ItemsToApprove.retrieveItemsToApprove_Helper - INCOMPLETE"); 
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
	},

	getAccountInformation : function(component,event,helper) {
		var action = component.get("c.getAccountInfo");
		var merchantId = component.get('v.merchantId');
		var contextABI = component.get("v.actualABI")
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
					console.log('responseData: ' , responseData);
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
	}
})