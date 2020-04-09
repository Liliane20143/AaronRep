({
    
    onUpdateContext : function(component, event, helper) {
        console.log('Inside onUpdateContext for newCartLook');

        var visibleCategories = component.get('v.visibleCategories');
        var fireNextPageEvent = component.get('v.fireNextPageEvent');
        var validItems=[];
        var validBundles=[];
        var category,bundle,listOfCategories,listOfBundles;
        //var currentCategoryId = component.get('v.currentCategoryId');
        var getCartServiceParam = event.getParam("CartService_Output");
        // se esiste event.getParam("categoryId") significa che l'evento e categoryCahnged
        var listOfItems = getCartServiceParam.listOfItems;
        listOfBundles = getCartServiceParam.listOfBundles;
        console.log('listOfBundles'+listOfBundles.length);
        if(typeof listOfBundles!='undefined'){
            if(!helper.objectIsEmpty(listOfBundles)){
                //cicla sulla lista di bundles per cercare quelli active
                for(var j=0;j< listOfBundles.length;j++){
                    bundle = listOfBundles[j];
                      console.log('bundle'+bundle.fields.active);
                    var bundleActive = bundle.fields.active;
                    if(bundleActive){
                        validBundles.push(bundle);
                    }
                }
            }
        }
       
       if(!helper.objectIsEmpty(listOfItems)){
            var itemsLength = listOfItems.length;
            console.log(itemsLength)
            var item,itemVisible;
            for(var i=0;i< itemsLength;i++){
                item = listOfItems[i];
                itemVisible = item.fields.visible;
                //controlla se il item è visibile(se si lo aggiungi nella lista di prodotti da mostrare)
                if(itemVisible == 'true'){
                    validItems.push(item);
                }
            }
       }  
            
            component.set('v.validItems',validItems);
            component.set('v.validBundles',validBundles);
            //visibleCategories = component.get('v.visibleCategories');
            //console.log('visible categories' +visibleCategories);
            //helper.searchAllCategories(component,event);
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
            component.set("v.Spinner", false);
 
        
        
    },
    
    onCategoryChanged: function(component,event,helper){
        var categoryId = event.getParam('categoryId');
        var updateContext				=	$A.get("e.c:Bit2win_Event_UpdateContext");
        updateContext.setParams({
            'CategoryName'				:	categoryId
        }).fire();
        //console.log('taocheck on CategoryChanged');
    },
    
    offertaSelected : function(component,event,helper){
        
        var objectDataMap = component.get("v.objectDataMap");
        
        var oldSelectedOfferta = component.get('v.offertaId');
        
        var selectedElement = event.currentTarget;
        console.log('selectedElement'+selectedElement);
        var newSelectedOffertaId = selectedElement.id;
       // var elementImage = document.getElementById(newSelectedOffertaId+'_img');
        var nascondiTxt = document.getElementById(newSelectedOffertaId+'_nsc');
        var mostraTxt = document.getElementById(newSelectedOffertaId+'_shw');
        var dettaglio = document.getElementById('dettaglio');
        helper.getOffertaDetails(component,newSelectedOffertaId);
        
        if(oldSelectedOfferta != undefined && oldSelectedOfferta != newSelectedOffertaId){
        	helper.hidePreviousOffertaCss(component,oldSelectedOfferta);
        }	
        
        if(oldSelectedOfferta != newSelectedOffertaId){
	        $A.util.removeClass(selectedElement, 'u44');
	        $A.util.addClass(selectedElement, 'u59');
	        
	        //test
	        $A.util.addClass(selectedElement, 'right');
	        //test
	        
	        //elementImage.classList.remove("hidden");
	        //elementImage.classList.add("arrow_image");
	        nascondiTxt.classList.remove("hidden");
	        nascondiTxt.classList.add("u46");
	        mostraTxt.classList.add("u46");
	        dettaglio.classList.remove("hidden");
	        
	        component.set('v.offertaId',newSelectedOffertaId);
	        objectDataMap.unbind.offertaId = newSelectedOffertaId;
	        console.log('taotao'+objectDataMap.unbind.offertaId);
        }
    },
    hideDettaglio: function(component,event,helper){
    	
    	
        var dettaglio = document.getElementById('dettaglio');       
        var selectedElement = event.currentTarget;
        var newSelectedOffertaId = selectedElement.id;
        newSelectedOffertaId = newSelectedOffertaId.substring( 0, newSelectedOffertaId.indexOf( "_" ));
        var element = document.getElementById(newSelectedOffertaId);
        //var elementImage = document.getElementById(newSelectedOffertaId+'_img');
        //console.log(elementImage)
        var nascondiTxt = document.getElementById(newSelectedOffertaId+'_nsc');
        var mostraTxt = document.getElementById(newSelectedOffertaId+'_shw');
        //element.classList.add("u44");
        //element.classList.remove("u59");
        //element.classList.remove("right");
        //elementImage.classList.add("hidden");
        //elementImage.classList.remove("arrow_image");
        nascondiTxt.classList.add("hidden");
        mostraTxt.classList.remove("hidden");
        dettaglio.classList.add("hidden");
       
    	   	 
    },
    
     showDettaglio: function(component,event,helper){
    	
    	
        var dettaglio = document.getElementById('dettaglio');       
        var selectedElement = event.currentTarget;
        var newSelectedOffertaId = selectedElement.id;
        newSelectedOffertaId = newSelectedOffertaId.substring( 0, newSelectedOffertaId.indexOf( "_" ));
        var element = document.getElementById(newSelectedOffertaId);
        //var elementImage = document.getElementById(newSelectedOffertaId+'_img');
        //console.log(elementImage)
        var nascondiTxt = document.getElementById(newSelectedOffertaId+'_nsc');
        var mostraTxt = document.getElementById(newSelectedOffertaId+'_shw');
        //element.classList.add("u44");
        //element.classList.remove("u59");
        //element.classList.remove("right");
        //elementImage.classList.add("hidden");
        //elementImage.classList.remove("arrow_image");
        nascondiTxt.classList.remove("hidden");
        mostraTxt.classList.add("hidden");
        dettaglio.classList.remove("hidden");  
    	   	 
    },
    
    nextStep: function(component,event,helper){
        
        /* var configureAppEvent 	= 	$A.get("e.NE:Bit2win_Event_AddRemoveFromCart");
        var mapOfItems = {};
        var offertaId = component.get('v.selectedOfferta');
        var validItems = component.get('v.validItems');
        var item;
        for(var i=0;i<validItems.length;i++){
            item = validItems[i];
            if(item.id == offertaId) break;
        }
        
        configureAppEvent.setParams({
            'item'	: 	item,
            'mapOfItems': mapOfItems, 
            'action' : 	'modify',
            'catalogId'	: item.fields.catalogid,
            'categoryId'	: item.fields.categoryid,
            'typeOfAdd' : 'multiAdd'
        });
        configureAppEvent.fire();
        component.set('v.fireNextPageEvent',true);*/
        var offertaSelected = component.get('v.offertaHeader');
        var offertaId = component.get('v.offertaId');
        var event = $A.get("e.c:navigateToComponent");
        event.setParams({
            componentName : "c:newCartConfiguration",
            offertaSelected : offertaSelected,
            offertaId : offertaId
        });
        event.fire();
        
        
    },
    showSpinner: function(component, event, helper) {
        component.set("v.Spinner", true); 
    },
    hideSpinner : function(component,event,helper){
        component.set("v.Spinner", false);
    },
    //TODO documentation
    updateNextButton: function(component,event,helper){
      //fire dell'evento
      
            var cmpEvent = component.getEvent("newCartOverrideNextEvent");
        		cmpEvent.setParams({
            	"step" : 1
			});
        	cmpEvent.fire();
     }   
})