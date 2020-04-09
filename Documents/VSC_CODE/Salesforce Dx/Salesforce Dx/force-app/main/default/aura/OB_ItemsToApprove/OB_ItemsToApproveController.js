({
	doInit : function(component, event, helper)
	{
		helper.getUserInformation_Helper(component, helper, event);
	},

	openModalConfigurationDetails : function(component, event, helper)
	{
		var ordId = event.target.id;
		
		//	START	micol.ferrari 14/02/2019 - #1386
		var workitems 	= component.get( "v.workitems" );
		for ( var workitem in workitems )
		{
			console.log( "inside if " + workitems[workitem].configurationId );
			console.log( "ordid " + ordId );
			if ( workitems[workitem].configurationId == ordId && workitems[workitem].orderApprovalType == 'BIO' )
			{				
				component.set( "v.contextOrderHeaderId", workitems[workitem].orderHeaderId );
				component.set( "v.contextAccountId", workitems[workitem].accountId );
				component.set( "v.contextApprovalType", workitems[workitem].orderApprovalType );
				console.log( component.get( "v.contextOrderHeaderId" ) );
				console.log( component.get( "v.contextAccountId" ) );
				console.log( component.get( "v.contextApprovalType" ) );
				break;
			}
		}
		//	END		micol.ferrari 14/02/2019 - #1386
		component.set( "v.contextConfigurationId", event.target.id );
		component.set( "v.openModalConfDetails", true );
	},

	closeModalConfigurationDetails : function(component, event, helper)
	{
		component.set( "v.openModalConfDetails", false );
		component.set( "v.contextConfigurationId", "" );

		//	START	micol.ferrari 14/02/2019 - #1386
		component.set( "v.contextOrderHeaderId", "" );
		component.set( "v.contextAccountId", "" );
		component.set( "v.contextApprovalType", "" );
		//	END		micol.ferrari 14/02/2019 - #1386
	},

	//giovanni spinelli 21/02/2019 - open modal merchant detail
	openModalMerchantDetails: function(component,event,helper)
	{
		var ordId 		= event.target.id;
		console.log('ORD ID: ' + ordId);
		var workitems 	= component.get("v.workitems");
		console.log('workitems: '+ JSON.stringify(workitems));
		try{
			for (var workitem in workitems)
			{
				console.log(' work item: ' + workitem);
				console.log('MERCHANT ID: ' + JSON.stringify(workitems[workitem]));
				if (workitems[workitem].accountId == ordId){
					console.log('SUCCESS: '+ workitems[workitem].accountId);
					//save merchant id selected
					console.log('tipe of id: ' +typeof workitems[workitem].accountId);
					component.set('v.merchantId' , workitems[workitem].accountId);
					component.set('v.actualABI' , workitems[workitem].contextABI);
					break;
				}

			}
			helper.getAccountInformation(component,event,helper);
		}
		catch(err){
			console.log('ERROR IN OPEN MODAL: '+ err.message);
		}

		console.log('workitems ID: '+ JSON.stringify(workitems));
		component.set("v.contextConfigurationId",event.target.id);

	},
	closeModalMerchantDetails: function(component,event,helper)
	{
		component.set("v.openModalmerchantDetails",false);
	},

		
	/* Doris D.   28/03/2019 ------------- START*/
	openTooltip : function (component,event,helper){		
		component.set("v.showMessage", true);
	},

	closeTooltip: function (component,event,helper){
		component.set("v.showMessage", false);
	},

	openTooltipCAB : function (component,event,helper){		
		component.set("v.showMessageCAB", true);
	},

	closeTooltipCAB: function (component,event,helper){
		component.set("v.showMessageCAB", false);
	},

	openTooltipData: function (component,event,helper){		
		component.set("v.showMessageData", true);
	},

	closeTooltipData: function (component,event,helper){
		component.set("v.showMessageData", false);
	},
	
	/* Doris D.   28/03/2019 ------------- END*/
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
})