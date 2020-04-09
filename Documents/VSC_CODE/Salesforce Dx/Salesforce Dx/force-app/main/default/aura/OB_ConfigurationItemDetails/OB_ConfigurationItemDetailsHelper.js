({
    /**
	*@author Giovanni Spinelli <spinelli.giovanni@accenture.com>
	*@date 09/09/2019
	*@description fire toast
	*@params type - message
	*@return 
    */
   showToast : function( type , message ){
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
        "type" : type,
        "message": message
    });
    toastEvent.fire();
   }
})