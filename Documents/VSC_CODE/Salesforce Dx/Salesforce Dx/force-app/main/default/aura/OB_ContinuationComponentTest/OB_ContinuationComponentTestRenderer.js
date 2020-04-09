({
    afterRender : function(component, event, helper){
        
        this.superAfterRender();
        console.log('Rendering Continuation Component finish...');
        component.set("v.isRedereredIframeChild", true);    
        
    }
})