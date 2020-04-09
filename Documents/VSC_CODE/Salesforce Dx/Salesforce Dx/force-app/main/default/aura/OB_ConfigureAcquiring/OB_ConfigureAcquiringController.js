({
    onUpdateContext : function(component, event, helper) {
        console.log('Inside onUpdateContext for newCartAcquiring');
      
        var objectDataMap = component.get("v.objectDataMap");
        var itemAddedToCart = component.get('v.itemAddedToCart');
        var itemRemovedFromCart = component.get('v.itemRemovedFromCart');
        var validItems=[], validBundles=[], productCategories = [], stepTwoCategories = [];
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
            var listOfCategories = getCartServiceParam.listOfCategories;
            
        
            //check listOfCategories for step=2 and parentCategory=Acquiring
            if(!helper.objectIsEmpty(listOfCategories)){
                var categoriesLength = listOfCategories.length;
                var category;
                for(var i=0;i< categoriesLength;i++){
                    category = listOfCategories[i];
                    if(category.categoryFields.parentCategory == 'Acquiring' && category.categoryFields.step == '2'){
                        stepTwoCategories.push(category);
                    }
                }
            }
            
            //search listOfitems for items with category included in stepOnecategories 
            if(!helper.objectIsEmpty(listOfItems)){
                var itemsLength = listOfItems.length;
                var item,itemVisible,categoryName,result;
                
                
                for(var i=0;i< itemsLength;i++){
                    var items = [];
                    item = listOfItems[i];
                    itemVisible = item.fields.visible;
                    categoryName = item.fields.categoryname;
                    
                    console.log("MarkTest: "+ item.listOfAttributes);
		            
                    
                    //search in stepTwocategories
                    result = stepTwoCategories.filter(obj => {
                        return obj.categoryFields.categoryname === categoryName
                    });
                    
                    if(result.length !=0){
                        //controlla se il item è visibile(se si lo aggiungi nella lista di prodotti da mostrare)
                        if(itemVisible){
                            validItems.push(item);
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
            }
            
            if(!offertaAddedToCart){
                var configureAppEvent 	= 	$A.get("e.NE:Bit2win_Event_AddRemoveFromCart");
                var mapOfItems = [];
                var vid,qty;
                var item;
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
                component.set('v.offertaList',validItems);
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
                        component.set('v.listOfCategories',listOfCategories);
                        component.set("v.spinner", false);
                    }
                }
            
        }else if(itemAddedToCart || itemRemovedFromCart){
            helper.updateCartList(component);
        	component.set("v.spinner", false);
        }
        
    },
    onCheck: function(component,event,helper){
        component.set("v.spinner", true);
        var itemId = event.getSource().get("v.id");
        var chkBoxVal = event.getSource().get("v.checked");
        var item;
        console.log('taoitemId'+itemId);
        var contextOutput = component.get('v.contextOutput');
        var offertChildList = component.get('v.offertChildList');
        
        for(var i=0;i<offertChildList.length;i++){
            item = offertChildList[i];
            if(item.id == itemId) break;
        }
        
        if(chkBoxVal){
            component.set('v.itemAddedToCart',true);
            var updateChildEvent 	= 	$A.get("e.NE:Bit2win_Event_UpdateChildItem");
            updateChildEvent.setParams({
                "itemChanged": 	item,
                "Context_Output":  contextOutput 
            });
            updateChildEvent.fire();
            
            /*cambia il colore del background*/
            
            var productRow = document.getElementById(itemId+'_prdRow');
            productRow.classList.add("product_row_color");
            
            /* add table acquiring */
            var circuitiList = component.get("v.circuitiList");
            //push with more parameters
            //console.log("Mark More Fields"+ JSON.stringify(item.listOfAttributes[0].fields.value));
            for(var i = 0; i < item.listOfAttributes.length; i++){
            	var catName  =  item.listOfAttributes[i].fields.name;
            	var catValue =  item.listOfAttributes[i].fields.value;
            	console.log("NomeCategoria: "+catName+" ValoreCategoria: "+catValue);
            }
            
            circuitiList.push(item.fields.productname); //product name (es. Visa/Mastercard)
            //console.log("Mark circuiti: "+JSON.stringify(circuitiList));
            component.set("v.circuitiList",circuitiList);
        }
        else{
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
            productRow.classList.remove("product_row_color");
            
            /* remove  table acquiring */
            
            var circuitiList = component.get("v.circuitiList");
            var index = circuitiList.indexOf(item.fields.productname); //ToDo fare una ricerca migliore
            circuitiList.splice(index,1);
           
            component.set("v.circuitiList",circuitiList);
            
        }
    },
    //francesca.ribezzi 28/08/2018 
    onLoadingSpinner: function(component,event,helper){
    	console.log('Inside onLoadingSpinner for newCartAcquiring');
    	var listOfCategories = component.get("v.listOfCategories");
    	console.log("listOfCategories length in onLoadingSpinner: " + listOfCategories.length);
    	if(listOfCategories.length > 0){
    		component.set("v.spinner", false);
    	}else{
    		component.set("v.spinner", true);
    	}
    }
})