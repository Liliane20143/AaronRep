({
	doInit : function (component, event, helper) {
        
    var stepDiv = document.getElementsByClassName('.slds-tabs_path.slds-is-current');
	console.log('@@@@@ my class is: ' + JSON.stringify(stepDiv));
    stepDiv.style.backgroundColor= "rgb(21, 137, 238)";
        

    }
})