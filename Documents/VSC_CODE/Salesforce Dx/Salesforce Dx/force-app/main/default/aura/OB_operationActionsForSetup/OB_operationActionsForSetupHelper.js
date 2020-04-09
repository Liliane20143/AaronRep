({
	 /*
    * @author Elena Preteni <elena.preteni@accenture.com>
    * @date 22/07/2019
    * @description The method calls method from Apex : sets value of Nexi / Bank order status and timestamps
    * @history 22/07/2019 Created
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

   getHistoricWizards : function(component){
	let orderHeaderId = component.get( "v.recordId" );
	let action = component.get( "c.getHistoricWizards" );
	action.setParam( "orderHeaderId", orderHeaderId );
	action.setCallback( this, function( response ) {
		if ( response.getState( ) === "SUCCESS" )
		{
			component.set("v.historicWizard",response.getReturnValue());
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
   }
})