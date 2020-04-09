({
	doInit : function(component, event, helper) 
	{
		console.log("OB_Empty_User_Profile DO INIT");
//call apex method
		var action = component.get("c.retrieveStaticImg");
//set result of apex method
		action.setCallback(this, function(response)
        {
//check the response state
        	var state = response.getState();
        	if(state=="SUCCESS")
        	{
//get the response and assigned at a variable
        		 var  imgUrlReturned = response.getReturnValue();
        		 console.log("OB_Empty_User_Profile imgUrlReturned: "+imgUrlReturned);
//set response value in a components aura attribute
        		 component.set("v.imgUrl",imgUrlReturned);
        	}
        	else
        	{
//if the response haven't success show the error
        		console.log("error of method OB_Empty_User_Profile_CC.retrieveStaticImg");
        	}
        });
//set method in queue
	$A.enqueueAction(action);
	

	var getVFBaseURL = component.get("c.getVFBaseURLServer");

        getVFBaseURL.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
		var URL = response.getReturnValue();
		var URLSplitted = URL.split('/');
		console.log('URLSplitted is: ' + URLSplitted);
		for(var i = 0; i < URLSplitted.length; i++) {
			if(URLSplitted.length > 3) {
				var environment = '/' +  URLSplitted[3];
				component.set("v.environment", environment);
				console.log('environment is : ' + environment);
			} else if(URLSplitted.length <= 3) {
				var environment = '';
				component.set("v.environment", environment);
				console.log('environment is : ' + environment);
			}
		}


		// var URLSplitted2 = URLSplitted.split('.');
		// console.log('URLSplitted2 is: ' + URLSplitted2);
		// var lastIndex = URLSplitted2[URLSplitted2.length - 1];
		// console.log('lastIndex is: ' + lastIndex);
		// // if(lastIndex) {

		// }

            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
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
        $A.enqueueAction(getVFBaseURL);



     }
})