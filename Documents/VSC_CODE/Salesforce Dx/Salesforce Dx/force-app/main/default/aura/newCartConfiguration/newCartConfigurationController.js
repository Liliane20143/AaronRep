({
    /*doInit : function(component, event, helper) {
        var updateContext				=	$A.get("e.NE:Bit2win_Event_RetrieveContext");
        updateContext.setParams({
            'componentRequest'		:	'catalog',
            'page'					:	1
        });
        updateContext.fire();
        
    },*/
    
    onUpdateContext : function(component, event, helper) {
        console.log('Inside onUpdateContext for newCartConfiguration');
        
        //var visibleCategories = component.get('v.visibleCategories');
        var objectDataMap = component.get("v.objectDataMap");
        var itemAddedToCart = component.get('v.itemAddedToCart');
        var itemRemovedFromCart = component.get('v.itemRemovedFromCart');
        var validItems=[], validBundles=[], productCategories = [], stepOneCategories = [];
        var category,bundle,listOfCategories,listOfBundles;
        var offertaId = objectDataMap.unbind.offertaId;
        
        var getCartServiceParam = event.getParam("CartService_Output");
        component.set('v.contextOutput',getCartServiceParam);
        
        if(offertaId != undefined && offertaId != '' && !itemAddedToCart && !itemRemovedFromCart){
            component.set("v.spinner", true);
            var configureItem = component.get('v.configureItem');
            var configureItemChild = component.get('v.configureItemChild');
            var offertaAddedToCart = component.get('v.offertaAddedToCart');
            
            var cart = getCartServiceParam.cart;
            var listOfItems = getCartServiceParam.listOfItems;
            console.log("onUpdateContext listOfItems: " + JSON.stringify(listOfItems));
            component.set("v.listOfItems", listOfItems); 
            var listOfCategories = getCartServiceParam.listOfCategories;
            console.log('List of Categories: '+JSON.stringify(listOfCategories))
            console.log('getCartServiceParam.cart: '+JSON.stringify(getCartServiceParam.cart))
            
            //check listOfCategories for step=1 and parentCategory=POS
            if(!helper.objectIsEmpty(listOfCategories)){
                var categoriesLength = listOfCategories.length;
                var category;
                for(var i=0;i< categoriesLength;i++){
                    category = listOfCategories[i];
                    console.log("parentCategory: " +category.categoryFields.step );
                    if(category.categoryFields.parentCategory == 'POS' && category.categoryFields.step == '1'){
                        stepOneCategories.push(category);
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
            
            //search listOfitems for items with category included in stepOnecategories 
            if(!helper.objectIsEmpty(validItems)){
                var itemsLength = validItems.length;
                var item,itemVisible,categoryName,result;
                
                for(var i=0;i< itemsLength;i++){
                    var items = [];
                    item = validItems[i];
                    categoryName = item.fields.categoryname;
                    
                    //search in stepOnecategories
                    result = stepOneCategories.filter(obj => {
                        return obj.categoryFields.categoryname === categoryName
                    });
                    
                    if(result.length !=0){
                        if(!helper.objectIsEmpty(productCategories)){
                            result = productCategories.filter(obj => {
                                return obj.categoryName === categoryName
                            }); 
                            if(result.length !=0){
                                if(result[0].items.length != undefined){
                                    for(var j=0; j<result[0].items.length;j++){
                                        items.push(result[0].items[j]);
                                    }
                                }
                                else items.push(result[0].items);
                                
                                items.push(item);
                                var index = productCategories.findIndex(x => x.categoryName==categoryName);
                                productCategories[index].items = items;
                            }
                            else{
                                productCategories.push({
                                    categoryName: categoryName,
                                    items: item
                                });
                            }
                        }
                        else{
                            productCategories.push({
                                categoryName: categoryName,
                                items: item
                            });
                        }
                    }
                    
                }
            }
            
            if(!offertaAddedToCart){
                var configureAppEvent 	= 	$A.get("e.NE:Bit2win_Event_AddRemoveFromCart");
                var mapOfItems = [];
                var vid,qty;
                //var offertaId = component.get('v.selectedOfferta');
                //var validItems = component.get('v.validItems');
                var item;
                console.log('taocheck' +offertaId)
                for(var i=0;i<validItems.length;i++){
                    item = validItems[i];
                    if(item.id == offertaId) break;
                }
                vid = item.fields.vid;
                item.fields.qty = parseInt(item.fields.qty) + 1;
                qty = item.fields.qty;
                mapOfItems.push({[vid]: qty});
                configureAppEvent.setParams({
                    'item'	: 	item,
                    'mapOfItems': mapOfItems[0], 
                    'action' : 	'add',
                    'catalogId'	: item.fields.catalogid,
                    'categoryId'	: item.fields.categoryid,
                    'typeOfAdd' : 'multiAdd'
                });
                component.set('v.offertaAddedToCart',true);
                configureAppEvent.fire();
            }
            else if(!configureItem){
                helper.updateCartList(component);
                var configureAppEvent 	= 	$A.get("e.NE:Bit2win_Event_AddRemoveFromCart");
                var mapOfItems = [];
                var vid,qty;
                //var offertaId = component.get('v.selectedOfferta');
                //var validItems = component.get('v.validItems');
                if(!helper.objectIsEmpty(cart)){
                    var item = cart[0];
                    vid = item.fields.vid;
                    item.fields.qty = parseInt(item.fields.qty) + 1;
                    qty = item.fields.qty;
                    mapOfItems.push({[vid]: qty});
                    configureAppEvent.setParams({
                        'item'	: 	item,
                        'mapOfItems': mapOfItems[0], 
                        'action' : 	'modify',
                        'catalogId'	: item.fields.catalogid,
                        'categoryId'	: item.fields.categoryid,
                        'typeOfAdd' : 'multiAdd'
                    });
                    component.set('v.configureItem',true);
                    configureAppEvent.fire();
                }
            }
            
                else{
                    if(configureItemChild){
                        component.set('offertChildSubList',validItems);
                        component.set('v.configureItemChild',false);
                        component.set("v.spinner", false);
                        console.log('offertChildSubList'+JSON.stringify(offertChildSubList))
                    }
                    else{
                        component.set('v.offertChildList',validItems);
                        component.set('v.productCategories',productCategories);
                        component.set("v.spinner", false);
                    }
                    //component.set('v.validItems',validItems);
                }
        }else if(itemAddedToCart || itemRemovedFromCart){
            helper.updateCartList(component);
        	component.set("v.spinner", false);
        }
        
        
    },
    onCheck: function(component,event,helper){
        component.set("v.spinner", true);
        var itemId = event.getSource().get("v.id");
        var itemQty = parseInt(document.getElementById(itemId+'_qty').value);
        var chkBoxVal = event.getSource().get("v.checked");
        var item;
        var contextOutput = component.get('v.contextOutput');
        var offertChildList = component.get('v.offertChildList');
        var openDetailsBtnId = itemId + '_showDetails' ;
     
        if(chkBoxVal){
        	//francesca.ribezzi 29/08/2018 showing details
            helper.showDetailsSelectedCheckbox(component, event, openDetailsBtnId);
            for(var i=0;i<offertChildList.length;i++){
                item = offertChildList[i];
                if(item.id == itemId) break;
              }   
 
            item.fields.qty = itemQty;
            var itemQty = parseInt(document.getElementById(itemId+'_qty').value);
            if(itemQty == 0){
                document.getElementById(itemId+'_qty').value = 1;
            }
            component.set('v.itemAddedToCart',true);
            console.log("ITEM AGGIUNTO"+ JSON.stringify(item)); //DEBUG LOG TO TRANSLATE BIt2WIN Language -.-
            var updateChildEvent 	= 	$A.get("e.NE:Bit2win_Event_UpdateChildItem");
            updateChildEvent.setParams({
                "itemChanged": 	item,
                "Context_Output":  contextOutput 
            });
            updateChildEvent.fire();
            
            /*cambia il colore del background*/
            var productRow = document.getElementById(itemId+'_prdRow');
          //  var itemInfo = document.getElementById(itemId+'_info');
            var itemInfo = document.getElementById(itemId+'_infoColor');
            productRow.classList.add("product_row_color");
            itemInfo.classList.add("product_row_color");
        }
        else{
        //francesca.ribezzi 29/08/2018 inputs not editable:
      /*  	for(var i = 0; i<10; i++){
        		console.log("itemPrice iD: " + itemId+'_itemPrice'+i);
        		if(document.getElementById(itemId+'_itemPrice'+i) != null ){
        			var inputToEdit = document.getElementById(itemId+'_itemPrice'+i).readOnly = true;
        			console.log("showDetailsSelectedCheckbox inputToEdit " + inputToEdit);

        		}
        } */
        //2) TEST editable price Items by CLASS -> readOnly
        
     /*   var inputs = document.getElementsByClassName("f216");
        var inputs2 = document.getElementsByClassName("f217");
        if(inputs.length > 0){
            	for(var i = 0; i< inputs.length; i++){
            	inputs[i].className =  'f217';
            	inputs[i].classList.remove('f216');
            		inputs[i].readOnly = true;
            	}
        }else{
            	for(var i = 0; i< inputs2.length; i++){
            		inputs2[i].className =  'f217';
            		inputs2[i].classList.remove('f216');
            		inputs2[i].readOnly = true;
            	}
        } */
        //END TEST   
        //francesca.ribezzi 29/08/2018 hiding details:
        	helper.hideDetailsSelectedCheckbox(component, event, openDetailsBtnId);

            var itemQty = parseInt(document.getElementById(itemId+'_qty').value);
            document.getElementById(itemId+'_qty').value = 0;
            var cartChildItems = contextOutput.cart[0].childItems;
            for(var i=0; i<cartChildItems.length;i++){
                item = cartChildItems[i];
                if(item.id == itemId) break;
            }
            var configureAppEvent 	= 	$A.get("e.NE:Bit2win_Event_AddRemoveFromCart");
            configureAppEvent.setParams({
                'item'	: 	item,
                'action' : 	'remove',
            });
            component.set('v.itemRemovedFromCart',true);
            configureAppEvent.fire();

            /*cambia il colore del background*/
            
            var productRow = document.getElementById(itemId+'_prdRow');
           // var itemInfo = document.getElementById(itemId+'_info');
            var itemInfo = document.getElementById(itemId+'_infoColor');
            productRow.classList.remove("product_row_color");
            itemInfo.classList.remove("product_row_color");
        }
        //console.log('taocheck'+JSON.stringify(item.fields))
    },
    showDetails: function(component,event,helper){
        var selectedElement = event.currentTarget;
        var offertChildList = component.get('v.offertChildList');
        var contextOutput = component.get('v.contextOutput');
        var item;
        var itemId = selectedElement.getAttribute('data-item');
        console.log("showDetails itemId: " + itemId);
        var itemShowDetails = document.getElementById(itemId+'_showDetails');
        var itemHideDetails = document.getElementById(itemId+'_hideDetails');
        var itemInfo = document.getElementById(itemId+'_info');
        itemShowDetails.classList.add("hidden");
        itemHideDetails.classList.remove("hidden");
        itemInfo.classList.remove("hidden");
        component.set("v.isEditablePrice",true);
        /*prendi dati sul i figli di quel item */
        //console.log(JSON.stringify(offertChildList))
        for(var offertaChild in offertChildList){
            if(offertChildList[offertaChild].id == itemId){
                item = offertChildList[offertaChild];
            }
        }
       // console.log('today'+item.fields.catalogid)
       // console.log(item.fields.categoryid)
       // console.log(item.fields.parent)
        if(item != null){
            component.set('v.configureItemChild',true);
            var configureAppEvent 	= 	$A.get("e.NE:Bit2win_Event_ConfigureItem");
            var mapOfItems = {};
            
            configureAppEvent.setParams({
                'item'	: 	item,
                'configure': true, 
                'Context_Output' : 	contextOutput,
                'EngineType'  : 'Bit2Gin' 
                
            });
            component.set('v.configureItem',true);
            console.log('here')
            configureAppEvent.fire();
        }        
    },
    hideDetails: function(component,event,helper){
        var selectedElement = event.currentTarget;
        var itemId = selectedElement.getAttribute('data-item');
        var itemShowDetails = document.getElementById(itemId+'_showDetails');
        var itemHideDetails = document.getElementById(itemId+'_hideDetails');
        var itemInfo = document.getElementById(itemId+'_info');
        itemShowDetails.classList.remove("hidden");
        itemHideDetails.classList.add("hidden");
        itemInfo.classList.add("hidden");
    },
    increaseQty : function(component,event,helper){
        var selectedElement = event.currentTarget;
        var itemId = selectedElement.getAttribute('data-item');
        var itemQty = parseInt(document.getElementById(itemId+'_qty').value);
        var contextOutput = component.get('v.contextOutput');
        var item;
        var itemIncart = false;
        
        //add this logic only if the item is in the cart
        
	        //find the item in the cart
	        var cartChildItems = contextOutput.cart[0].childItems;
	            for(var i=0; i<cartChildItems.length;i++){
	                item = cartChildItems[i];
	                console.log("MATCH? : "+ item.id+ " == "+ itemId);
	                if(item.id == itemId){
	                	item.fields.qty = itemQty;               	
	                	itemIncart = true;
	                	break;
	                }	
	            }
	                 
	        //add logic for bit2win engine
	        if(itemIncart){
		        component.set("v.spinner", true);
		        console.log("OGGETTO? "+JSON.stringify(item));
		        var updateChildEvent 	= 	$A.get("e.NE:Bit2win_Event_ApplyPenalty");
		            updateChildEvent.setParams({
		                "item": 	item,
		                "action" 	: 	'changeQty'
		            });
		         updateChildEvent.fire();

	         }   
	        //----------------------------       
        
        document.getElementById(itemId+'_qty').value = itemQty+1;
    },
    decreaseQty: function(component,event,helper){
        var selectedElement = event.currentTarget;
        var itemId = selectedElement.getAttribute('data-item');
        var itemQty = parseInt(document.getElementById(itemId+'_qty').value);
        var contextOutput = component.get('v.contextOutput');       
        var item;

        var itemIncart = false;
        
         
        //add this logic only if the item is in the cart
        
	        //find the item in the cart
	        var cartChildItems = contextOutput.cart[0].childItems;
	            for(var i=0; i<cartChildItems.length;i++){
	                item = cartChildItems[i];
	                console.log("MATCH? : "+ item.id+ " == "+ itemId);
	                if(item.id == itemId){
	                	item.fields.qty = itemQty; //check for 0             	
	                	itemIncart = true;
	                	break;
	                }	
	            }
	                 
	        //add logic for bit2win engine
	        if(itemIncart){
	        console.log("OGGETTO? "+JSON.stringify(item));
		        var updateChildEvent 	= 	$A.get("e.NE:Bit2win_Event_ApplyPenalty");
		            updateChildEvent.setParams({
		                "item": 	item,
		                "action" 	: 	'changeQty' 
		            });
		         updateChildEvent.fire();
		         
	         }   
	        //----------------------------       
               
        if(itemQty <= 0){
            document.getElementById(itemId+'_qty').value = 0;
        }
        else{
            document.getElementById(itemId+'_qty').value = itemQty-1;
        }
    },
   //francesca.ribezzi 28/08/2018 
    onLoadingSpinner: function(component,event,helper){
    	console.log('Inside onLoadingSpinner for newCartConfiguration');
    	var listOfCategories = component.get("v.listOfCategories");
    	console.log("listOfCategories length in onLoadingSpinner: " + listOfCategories.length);
    	if(listOfCategories.length > 0){
    		component.set("v.spinner", false);
    	}else{
    		component.set("v.spinner", true);
    	}
    }
    
})