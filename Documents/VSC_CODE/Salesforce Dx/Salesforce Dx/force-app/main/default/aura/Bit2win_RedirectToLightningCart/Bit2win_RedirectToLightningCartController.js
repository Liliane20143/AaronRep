({
    doInit : function(cmp,evt)
	{
        console.log('v.recordId: '+cmp.get('v.recordId'));
        console.log('RecordName: '+cmp.get('v.sObjectName'));

        var redirectTo = cmp.get('c.redirectObject');

        redirectTo.setParams(
		{
			'IdObject' 	: 	cmp.get('v.recordId')
		});


        redirectTo.setCallback(this, function(responce)
		{
			if(cmp.isValid() && responce.getState() == 'SUCCESS')
			{
                if(responce.getReturnValue() == 'Account')
                {
//                    window.location.href = '/c/Bit2win_LightningCart.app?accId='+cmp.get('v.recordId');
                	 window.location.href = '/apex/OB_Bit2winCart?accId='+cmp.get('v.recordId')+'&lightningFromVF=true';
                		
                }
                else if(responce.getReturnValue() == 'Opportunity')
                {
                    window.location.href = '/c/Bit2win_LightningCart.app?oppId='+cmp.get('v.recordId');
                }
                else if(responce.getReturnValue() == 'Quote__c' || responce.getReturnValue() == 'NE__Quote__c')
                {
                    window.location.href = '/c/Bit2win_LightningCart.app?quoteId='+cmp.get('v.recordId');
                }
                else if(responce.getReturnValue().startsWith('orderId'))
                {
                    window.location.href = '/c/Bit2win_LightningCart.app?'+responce.getReturnValue();
                }

            }
            else
            {

            }
        });
        $A.enqueueAction(redirectTo);


	}
})