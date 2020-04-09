({
    showInfoToast: function(component, event, infoMessage, type)
	{
	    // _utils.debug("into showInfoToast");
    	var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: '',
            message: infoMessage,
            duration: '5000',
            key: 'info_alt',
            type: type,
            mode: 'pester'
        });
        toastEvent.fire();
    },
   
})