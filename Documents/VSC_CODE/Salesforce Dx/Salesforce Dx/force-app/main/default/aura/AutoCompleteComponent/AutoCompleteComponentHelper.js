({  
    initHandlers: function(component,jQuery) {
        console.log('sono nel helper');
        var citySet =['Milano','Roma','Pavia'];
    	var ready = component.get("v.ready");

        if (ready === false) {
           	return;
        }
        
        var ctx = component.getElement();
        console.log('ctx element ' + ctx);
        
        jQuery(".autocomplete", ctx).autocomplete({
            minLength: 2,
            delay: 500,
            source : citySet,
            autoFocus: true
                })
            }
})