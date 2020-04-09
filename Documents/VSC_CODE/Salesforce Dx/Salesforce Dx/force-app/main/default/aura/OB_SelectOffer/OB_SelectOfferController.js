({
 
	doInit : function(component, event, helper)
	{
		//_utils.debug("__doInit__ OB_SelectOffer");
		
	},	

	//LUBRANO 16/01/2019 Libreria Log
	logInit: function(component){
		_utils.logInit(component.getName());
	},
	
	onUpdateContext : function(component, event, helper)
	{
		_utils.debug("into onUpdateContext OB_SelectOffer");
		//console.log("into onUpdateContext OB_SelectOffer");
		var visibleCategories = component.get('v.visibleCategories');
		var fireNextPageEvent = component.get('v.fireNextPageEvent');
		var validItems=[];
		var validBundles=[];
		var category,bundle,listOfCategories,listOfBundles;
		var getCartServiceParam = event.getParam("CartService_Output");
		
		/* check for previous */
		var offerIsSelected = false;
		var objectDataMap = component.get("v.objectDataMap");
		var offertaId = objectDataMap.unbind.offertaId;
		if(offertaId != '' && offertaId != undefined){
			component.set("v.offertaId", offertaId);
			offerIsSelected = true;
		}
		/* ================= */
		
		//_utils.debug("contextOutput OB_SelectOffer", getCartServiceParam);
		
		var listOfItems = getCartServiceParam.listOfItems;
		listOfBundles = getCartServiceParam.listOfBundles;
        
		if(typeof listOfBundles!='undefined'){
			if(!helper.objectIsEmpty(listOfBundles)){
				for(var j=0;j< listOfBundles.length;j++){
					bundle = listOfBundles[j];
					  //_utils.debug('bundle'+bundle.fields.active);
					var bundleActive = bundle.fields.active;
					if(bundleActive){
						validBundles.push(bundle);
					}
				}
			}
		}
       
		if(!helper.objectIsEmpty(listOfItems)){
			var itemsLength = listOfItems.length;
			//_utils.debug(itemsLength)
			var item,itemVisible;
			for(var i=0;i< itemsLength;i++){
				item = listOfItems[i];
				itemVisible = item.fields.visible;
				if(itemVisible == 'true'){
					validItems.push(item);
				}
			}
		}  
            
		component.set('v.validItems',validItems);
		component.set('v.validBundles',validBundles);
           
		var bundleName,bundleId,item,itemId,itemName,bundle;
		var products = [];
		
		//check if there are any validbundles and add them to the list
        if(validBundles.length > 0){    
			for(var i=0;i<validBundles.length;i++){
				bundle = validBundles[i];
				bundleName = bundle.fields.bundlename;
				bundleId = bundle.fields.id;
				products.push({
					'label': bundleName, 
					'value': bundleId
				});
			}
			
			//order offers
			products.sort(function(a, b){
			    var nameA=a.label.toLowerCase(), nameB=b.label.toLowerCase();
			    if (nameA < nameB ) 
			        return -1 
			    if (nameA > nameB )
			        return 1
			    return 0 //default return value (no sorting)
			});
		}
		//same stuff with items -- OLD S**T WE DONT NEED
        /*
        if(validItems.length > 0){   
			for(var i=0;i<validItems.length;i++){
				item = validItems[i];
				
				itemName = item.fields.productname;
				itemId = item.id;
				products.push({
					'label': itemName, 
					'value': itemId
				});
			}
        
		} */
		
		component.set('v.options',products);		
		component.set('v.spinner', false);   
		component.set('v.contextOutput',getCartServiceParam);	
		
		if(offerIsSelected){
			helper.getSelectedOffer(component, event);
		}
    },  
    offertaSelected : function(component,event,helper)
	{
    	helper.getSelectedOffer(component,event);
       
    },
    hideDettaglio: function(component,event,helper)
	{
        var dettaglio = document.getElementById('dettaglio');
        if(event!=null && event!='undefined')
        {   
	        var selectedElement = event.currentTarget;
	        var newSelectedOffertaId = selectedElement.id;
	        newSelectedOffertaId = newSelectedOffertaId.substring( 0, newSelectedOffertaId.indexOf( "_" ));
	        var element = document.getElementById(newSelectedOffertaId);

	        var nascondiTxt = document.getElementById(newSelectedOffertaId+'_nsc');
	        var mostraTxt = document.getElementById(newSelectedOffertaId+'_shw');

	        nascondiTxt.classList.add("hidden");
	        mostraTxt.classList.remove("hidden");
	        dettaglio.classList.add("hidden");
        }    
    },
    
    showDettaglio: function(component,event,helper){
    	
    	_utils.debug("into showDettaglio");
        var dettaglio = document.getElementById('dettaglio');       
       // var selectedElement = event.currentTarget;
       // var newSelectedOffertaId = selectedElement.id;
       // newSelectedOffertaId = newSelectedOffertaId.substring( 0, newSelectedOffertaId.indexOf( "_" ));
        var selectedElement;
        var newSelectedOffertaId;
        if(event.currentTarget == undefined){
        	for(var i = 0; i<options.length; i++){
        		if(options[i].value == oldSelectedOfferta){
        			newSelectedOffertaId = oldSelectedOfferta;
        			selectedElement = options[i];
        		}
        	}
        }else{
        	selectedElement = event.currentTarget;
        	newSelectedOffertaId = selectedElement.id;
            newSelectedOffertaId = newSelectedOffertaId.substring( 0, newSelectedOffertaId.indexOf( "_" ));
        } 
        //_utils.debug('newSelectedOffertaId'+newSelectedOffertaId);
        
        var element = document.getElementById(newSelectedOffertaId);

        var nascondiTxt = document.getElementById(newSelectedOffertaId+'_nsc');
        var mostraTxt = document.getElementById(newSelectedOffertaId+'_shw');

        nascondiTxt.classList.remove("hidden");
        mostraTxt.classList.add("hidden");
        dettaglio.classList.remove("hidden");  
    	   	 
    },
    nextStep: function(component,event,helper)
	{
        
        var offertaSelected = component.get('v.offertaHeader');
        var offertaId = component.get('v.offertaId');
        var event = $A.get("e.c:navigateToComponent");
        event.setParams({
            componentName : "c:OB_ConfigurePOS",
            offertaSelected : offertaSelected,
            offertaId : offertaId
        });
        event.fire();    
    },
})