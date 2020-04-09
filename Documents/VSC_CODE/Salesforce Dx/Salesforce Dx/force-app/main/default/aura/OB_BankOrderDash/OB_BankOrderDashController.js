({	
	doInit : function(component, event, helper) 
	{
		console.log('INSIDE DO INIT OB BANK ORDER DASH');
		var getFinalUrl = component.get("c.getFinalUrl");
		getFinalUrl.setCallback(this, function(response)
		{
    	   var state = response.getState();
    	   console.log('state getFinalUrl: '+state);
    	   if(state === 'SUCCESS') 
    	   {
	    	   component.set("v.lcBaseURL", response.getReturnValue());
	    	   
	    	   var initialURL = component.get("v.lcBaseURL");
	    	   console.log('lcBaseURL '+initialURL);
	    	   var reportname = component.get("v.reportName");
	    	   console.log('reportname '+reportname);

	    	   // FinalHomeCommunityReport_Vlh

		       var url = initialURL + "/apex/OB_BankOrderDashboard?reportName="+reportname+"&ABIField=Account.OB_ABI__c&CABField=NE__Order_Header__c.OB_CAB__c";
		       var encodedUrl = encodeURI(url);
		       component.set("v.url", encodedUrl);
            } 
            else if (state === "ERROR") 
            {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }            
        });  
        $A.enqueueAction(getFinalUrl);      
	}
})