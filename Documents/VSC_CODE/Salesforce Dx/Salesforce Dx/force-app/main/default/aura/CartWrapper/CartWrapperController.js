({
    doInit : function(cmp,evt)
    {
        console.log("Application started");
        var input = document.getElementById("2103:0");
        console.log(input);
        //sessionStorage.clear();
    },
    
    showSpinner : function(cmp)
    {
        var spinner 			=	cmp.find('spinner');
        var container 			=	cmp.find('container');
        $A.util.removeClass(spinner,'slds-hide');
    },
    
    hideSpinner : function(cmp){
        var cartSize 	= cmp.get('v.cartSize');
        var openCart 	= cmp.find('openCart');
        var what 		= cmp.get('v.whatShow');
        if( cartSize != null && cartSize > 0 && what == 'catalog' )
        {
            $A.util.removeClass(openCart,'slds-hide');
        }
        else
        {
            $A.util.addClass(openCart,'slds-hide');
        }
        
        var spinner 	=	cmp.find('spinner');
        var container 	=	cmp.find('container');
        $A.util.addClass(spinner,'slds-hide');    	
    },
    
    hideCartCatalogButtons : function(cmp,evt)
    {
        var what 		=	evt.getParam('whatShow');
        if(what == 'configurator')
        {
            var openCart 		=	cmp.find('openCart');
            var openCatalog 	=	cmp.find('openCatalog');
            $A.util.addClass(openCatalog,'slds-hide');
            $A.util.addClass(openCart,'slds-hide');
        }
    },
    
    updateCartQty : function (cmp,evt)
    {
        
    },
    
    changeCatalogView : function(cmp,evt)
    {
        var itemView 	= evt.getParam('view');
        var container 	= cmp.find('totalAppContainer');
        if(itemView == 'singleAdd')
        {
            $A.util.removeClass(container, 'max-width-app-horizontal');
            $A.util.addClass(container, 'max-width-app-vertical');
        }
        else if(itemView == 'multiAdd')
        {
            $A.util.addClass(container, 'max-width-app-horizontal');
            $A.util.removeClass(container, 'max-width-app-vertical');
        }
    },
    afterCheckout : function(cmp,event){
        console.log("Sto gestendo l'evento dopo il checkout");
        var isCheckout = event.getParam("bitwinMap")["checkOutResponse"];
        var accID = isCheckout.configuration.NE__AccountId__c;
        var ordID = isCheckout.configuration.Id;
        console.log("ACCOUNTID:"+isCheckout.configuration.NE__AccountId__c);
        console.log("CONFIGURATIONID:"+isCheckout.configuration.Id);
        
        //window.location.replace("https://nexi-payments--dev1--c.cs88.visual.force.com/apex/testStartWizard?core.apexpages.request.devconsole=1&accId="+accID+"&ordID="+ordID);
        
        //Quello attuale che funziona è questo v
        //									   v			
        window.location.replace("https://nexi-payments--dev1--c.cs88.visual.force.com/apex/LineItemPage?id="+ordID+"&accID="+accID);
        
        if (typeof isCheckout !== 'undefined')
        {
            console.log("isCheckout: ",JSON.stringify(isCheckout));
        }
    }
})