({
    doInit : function(component, event, helper) {
        helper.initializeZeros();
        helper.setLightningFromParam(component);
        var nextButton = document.getElementsByClassName('slds-button slds-button--brand');
        console.log('nextButton:'+JSON.stringify(nextButton));
        var configurationId = component.get("v.orderId");
        var paramsUrl = component.get("v.lightningFromParam");
        paramsUrl += ";ordId=" + configurationId; 
        console.log("params url : " + paramsUrl);
        component.set("v.lightningFromParam",paramsUrl);
        
        for (var i = 0; i < nextButton.length; i++) {
            console.log('ID'+JSON.stringify(nextButton[i])); //second console output
            nextButton[i].className='slds-hide';
        }
        //nextButton.addClass("slds-hide");
        
        
        //console.log("nextButtone:"+JSON.stringify(nextButtone[0]));
        
        
        //next.set("v.style","slds-hide");
      
        var wizardWrapper = component.get("v.wizardWrapper");
        var objectDataMap = component.get("v.objectDataMap");
        var objectKey = component.get("v.objectKey");
        var identifier = component.get("v.identifier");
        var field = component.get("v.field"); 
        console.log("WizardWrapper:"+JSON.stringify(wizardWrapper));
        console.log("objectDataMap:"+JSON.stringify(objectDataMap));
        console.log("objectKey:"+JSON.stringify(objectKey));
        console.log("identifier:"+JSON.stringify(identifier));
        console.log("field:"+JSON.stringify(field));
        console.log("Application started");
        var input = document.getElementById("2103:0");
        console.log(input);
        
        if(component.get("v.orderId") != null){
             var id = component.get("v.orderId");
        }else{
           var id = component.get("v.accId");
        }
        
        console.log("Provo a creare i componenti con questo ID :"+id);
        
        
    },
    showSpinner : function(cmp){
        var spinner  =	cmp.find('spinner');
        var container =	cmp.find('container');
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
    
    updateCartQty : function (cmp,evt){
        
    },
    
    changeCatalogView : function(cmp,evt){
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
        if(isCheckout!=null)
        {    
            var accID = isCheckout.configuration.NE__AccountId__c;
            var ordID = isCheckout.configuration.Id;
            console.log("ACCOUNTID:"+isCheckout.configuration.NE__AccountId__c);
            console.log("CONFIGURATIONID:"+isCheckout.configuration.Id);
            var objectDataMap = cmp.get("v.objectDataMap");
            //objectDataMap.unbind.orderId = ordID;
            cmp.set("v.objectDataMap",objectDataMap);
            
            //window.location.replace("https://nexi-payments--dev1--c.cs88.visual.force.com/apex/testStartWizard?core.apexpages.request.devconsole=1&accId="+accID+"&ordID="+ordID);
            
            //Quello attuale che funziona è questo v
            //									   v			
            //window.location.replace("https://nexi-payments--dev1--c.cs88.visual.force.com/apex/LineItemPage?id="+ordID+"&accID="+accID);
            /*var objectDataMap = cmp.get("v.objectDataMap");
        objectDataMap.unbind.nextCheckout = 'true';
        console.log("GESTICO CHECKOUT");
        console.log("MAPPA PRIMA DELL'UPDATE");
        console.log("objectDataMap:"+JSON.stringify(objectDataMap));
        cmp.set("v.objectDataMap",objectDataMap);
        //cmp.set("v.objectDataMpa.unbind.nextCheckout","true");
       	console.log("MAPPA DOPO DELL'UPDATE");
        console.log("objectDataMap:"+JSON.stringify(objectDataMap));
        var focusDiv = cmp.find("focusDiv").focus();
        */
            
            document.getElementById('input:unbind:nextCheck').value='NEXT';
            
            console.log("VALORE INPUTFLOW:"+document.getElementById('input:unbind:nextCheck').value);
            document.getElementById('input:unbind:nextCheck').dispatchEvent(new Event('blur'));
            document.getElementById('input:unbind:nextCheck').value='';
            
        }
        
        
        
        /*
        var inputText = cmp.find("nextIn");
        inputText.set("v.value","NEXT");
        */
        
        /*
        if (typeof isCheckout !== 'undefined')
        {
            console.log("isCheckout: ",JSON.stringify(isCheckout));
        }
        */
    }
})