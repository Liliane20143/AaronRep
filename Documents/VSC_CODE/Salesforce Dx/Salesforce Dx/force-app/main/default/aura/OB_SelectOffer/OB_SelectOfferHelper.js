({
    objectIsEmpty: function(obj) {
        return Object.keys(obj).length === 0;
    },
    
    getSelectedOffer: function(component, event){
    
    	var objectDataMap = component.get("v.objectDataMap");
        var oldSelectedOfferta = component.get('v.offertaId');
        var options = component.get("v.options");
        component.set("v.offerIsSelected", true);
        //_utils.debug("options: ", options);
       // var selectedElement = event.currentTarget;
       // var newSelectedOffertaId = selectedElement.id;
       var selectedElement;
       var newSelectedOffertaId;
       
       
       if(event.currentTarget == undefined){
        	for(var i = 0; i<options.length; i++){
        		if(options[i].value == oldSelectedOfferta){
        				newSelectedOffertaId = options[i].value;
        				oldSelectedOfferta = undefined;
        				break;
        		}		
        	}     	
        }
        else{
        	selectedElement = event.currentTarget;
        	newSelectedOffertaId = event.currentTarget.id; //!option.value 
        }
         
        //_utils.debug('newSelectedOffertaId '+newSelectedOffertaId);
        //_utils.debug('selectedElement '+selectedElement);
    
       // var elementImage = document.getElementById(newSelectedOffertaId+'_img');
        var nascondiTxt = document.getElementById(newSelectedOffertaId+'_nsc');
        var mostraTxt = document.getElementById(newSelectedOffertaId+'_shw');
        //_utils.debug("nascondiTxt: ", nascondiTxt);
        //_utils.debug("mostraTxt: " , mostraTxt);
        var dettaglio = document.getElementById('dettaglio');
        var contextOutput = component.get("v.contextOutput");
        var cartLength = 0;
        if(contextOutput == undefined || contextOutput == null){
        	cartLength = 0;
        }else{
        	cartLength = contextOutput.cart.length;
        }  
        //_utils.debug("cartLength in selectoffer: " , cartLength);
	    	// firing updateContextEvent event to parent OB_FlowCart to enable next button:
			//START EVENT 
			var updateContextEvent = $A.get("e.c:OB_CustomUpdateContextEvent");
			updateContextEvent.setParams({ "disabledNextBtn": false
											});
	    	updateContextEvent.fire();
	    	_utils.debug("firing event to OB_FlowCart cmp to enable next button..");
	    	//END event 

        this.getOffertaDetails(component,newSelectedOffertaId);
        
        if(oldSelectedOfferta != undefined && oldSelectedOfferta != newSelectedOffertaId){
        	//_utils.debug("oldSelectedOfferta "+oldSelectedOfferta);
        	//_utils.debug("newSelectedOffertaId "+newSelectedOffertaId);
        	
        	this.hidePreviousOffertaCss(component,oldSelectedOfferta);
        }	
        
        if(oldSelectedOfferta != newSelectedOffertaId){
	        $A.util.removeClass(selectedElement, 'u44');
	        $A.util.addClass(selectedElement, 'u59');
	        
	        //add arrow like div
	        $A.util.addClass(selectedElement, 'right');


	        nascondiTxt.classList.remove("hidden");
	        nascondiTxt.classList.add("u46");
	        mostraTxt.classList.add("u46");
	        dettaglio.classList.remove("hidden");
	        
	        component.set('v.offertaId',newSelectedOffertaId);
	        objectDataMap.unbind.offertaId = newSelectedOffertaId;
	        //_utils.debug('offerta id: '+objectDataMap.unbind.offertaId);
	        component.set("v.objectDataMap",objectDataMap);
	    }
    },
    
    
    searchAllCategories: function(component,event){
        
        var validItems = component.get('v.validItems');
        var validBundles = component.get('v.validBundles');
        var bundleName,bundleId,item,itemId,itemName,bundle;
        var products = [];
        
        for(var i=0;i<validBundles.length;i++){
            bundle = validBundles[i];
            bundleName = bundle.fields.bundlename;
            bundleId = bundle.fields.id;
            products.push({
                'label': bundleName, 
                'value': bundleId
            });
        }
        
        for(var i=0;i<validItems.length;i++){
            item = validItems[i];
            
            itemName = item.fields.productname;
            itemId = item.id;
            products.push({
                'label': itemName, 
                'value': itemId
            });
        }
        
        component.set('v.options',products);
    },
    
    hidePreviousOffertaCss: function(component,selectedOfferta){
        var element = document.getElementById(selectedOfferta);

        var nascondiTxt = document.getElementById(selectedOfferta+'_nsc');
        var mostraTxt = document.getElementById(selectedOfferta+'_shw');
        element.classList.remove(selectedOfferta, 'u59');
        element.classList.remove(selectedOfferta, 'right');
        element.classList.add(selectedOfferta, 'u44');

        /* hide misc text */
        nascondiTxt.classList.remove("u46");
        nascondiTxt.classList.add("hidden");
        
        mostraTxt.classList.remove("u46");
        mostraTxt.classList.add("hidden");
        
    },
    
    getOffertaDetails: function(component,selectedOfferta){
        var validItems = component.get('v.validItems');
        var validBundles = component.get('v.validBundles');

        var item,description, bundle;
        for(var i=0;i<validItems.length;i++){
            item = validItems[i];
            if(item.id == selectedOfferta){
                description = item.fields.description;
                component.set('v.offertaHeader',item.fields.productname);
                component.set('v.offertaDescription',description);
                component.set('v.offertaImage',item.fields.image);
            }
            else continue;
            
        }
        
        for(var i=0;i<validBundles.length;i++){
            bundle = validBundles[i];
            if(bundle.id == selectedOfferta){
                description = bundle.fields.description;
                component.set('v.offertaHeader',bundle.fields.bundlename);
                component.set('v.offertaDescription',description);
                component.set('v.offertaImage',(bundle.fields.image).replace('"',''));
            }
            else continue;
            
        }
    }
})