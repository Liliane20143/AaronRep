window._wizardController = (function() {

    return {
        notifyClick: function(component, event, helper) {
			var auraId = event.getSource().getLocalId();
			
			if(window._wizardHandler.hasOwnProperty(auraId))
				if (typeof window._wizardHandler[auraId].onClick === "function")
						window._wizardHandler[auraId].onClick(component, event, helper);
				
            
        },
        notifyBlur: function(component, event, helper) {
			var auraId = event.getSource().getLocalId();
		
			if(window._wizardHandler.hasOwnProperty(auraId))
				if (typeof window._wizardHandler[auraId].onBlur === "function")
						window._wizardHandler[auraId].onBlur(component, event, helper);
				
            
        },
        notifyOnChange: function(component, event, helper) {
			var auraId = event.getSource().getLocalId();
		
			if(window._wizardHandler.hasOwnProperty(auraId))
				if (typeof window._wizardHandler[auraId].onChange === "function")
						window._wizardHandler[auraId].onChange(component, event, helper);
				
            
        },
        notifyInit: function(component,auraId) {
			
			if(window._wizardHandler.hasOwnProperty(auraId))
				if (typeof window._wizardHandler[auraId].doInit === "function")
						window._wizardHandler[auraId].doInit(component,auraId);
				
            
        },
        notifyValidate: function(component,auraId, helper) {		
				if(window._wizardHandler.hasOwnProperty(auraId)){
					if (typeof window._wizardHandler[auraId].doValidate === "function")
							return window._wizardHandler[auraId].doValidate(component, auraId, helper);
				}
				return true;
		}	
    };
}());