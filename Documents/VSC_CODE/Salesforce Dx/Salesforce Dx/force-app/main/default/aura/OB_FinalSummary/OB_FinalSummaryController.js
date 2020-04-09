({
	doInit: function(component, event, helper) {
           //var frame=document.getElementsByClassName('slds-grid slds-wrap sectionColsContainer')[0];
        //giovanni spinelli start 11/04/2019
        console.log('BEFORE HELPER');
        helper.getMissingInformation(component); 
        //giovanni spinelli end 11/04/2019
    }    
})