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
                    window.location.href = '/Bit2winCart.app?accId='+cmp.get('v.recordId'); 
                }
               

            }
            else
            {

            }
        });
        $A.enqueueAction(redirectTo);


	}
})