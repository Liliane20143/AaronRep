({
    onUpdateContext : function(component, event, helper) {
        console.log('Inside onUpdateContext for newCartAcquiring');
      
        //var visibleCategories = component.get('v.visibleCategories');
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
            //console.log('taocatego'+JSON.stringify(listOfCategories))
            
        
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
            
            //search listOfitems for items with category included in stepTwocategories 
            if(!helper.objectIsEmpty(listOfItems)){
                var itemsLength = listOfItems.length;
                var item,itemVisible,categoryName,result;
                
                
                for(var i=0;i< itemsLength;i++){
                    var items = [];
                    item = listOfItems[i];
                    itemVisible = item.fields.visible;
                    categoryName = item.fields.categoryname;
                    
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
                                        //test -- to update cart list on first iteration
                                        helper.updateCartList(component);
                                        //test
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
                //var offertaId = component.get('v.selectedOfferta');
                //var validItems = component.get('v.validItems');
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
            
            /*change background color of row */           
            var productRow = document.getElementById(itemId+'_prdRow');
            productRow.classList.add("product_row_color");
            
            //ToDo Add only if the category is "Circuiti Internazionali"?
            //if(item.fields.categoryName == "Circuiti Internazionali"){
            
            /* add table acquiring */
            var circuitiList = component.get("v.circuitiList"); 
            /* get all category names on first iteration */
            var categoryName = component.get("v.categoryCircuit");
            
           	if(circuitiList.length == 0 &&  categoryName.length == 0){
           		for(var i = 0; i < item.listOfAttributes.length; i++){
           			var catName  =  item.listOfAttributes[i].fields.name;
           			
            		categoryName.push(catName);
            	}
            
            component.set("v.categoryCircuit",categoryName);
            }
            /* ===========================================*/
            
            var categoryValues = [];          
           
            for(var i = 0; i < item.listOfAttributes.length; i++){
            	
            	var catValueWithPercent =  item.listOfAttributes[i].fields.value;
            	var catValue = catValueWithPercent.substring(0, catValueWithPercent.length-1);
            	categoryValues.push(catValue); 	
            }
            //console.log("MarkvaluesPostFOR "+categoryValues);
            
            //push with more parameters
            circuitiList.push({ 	
            		 "productName" : item.fields.productname, //product name (es. Visa/Mastercard)
            		 "value" : categoryValues
            	 });
            
            
            component.set("v.circuitiList",circuitiList);
            component.set("v.categoryCircuitValues",categoryValues);
            
           
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
            
            /*change background color of row */
            
            var productRow = document.getElementById(itemId+'_prdRow');
            productRow.classList.remove("product_row_color");
            
            /* remove  table acquiring */
            
            var circuitiList = component.get("v.circuitiList");
            var index = 0;
            for(var i = 0; i < circuitiList.length; i++){
            	//console.log("MARK$: "+circuitiList[i].productName+ " == "+item.fields.productname);
            	if(circuitiList[i].productName == item.fields.productname){
            		index = i;
            		break;
            	}
            	else continue;	
            }
            circuitiList.splice(index,1);
           
            component.set("v.circuitiList",circuitiList);
            
        }
        //console.log('taocheck'+JSON.stringify(item.fields))
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