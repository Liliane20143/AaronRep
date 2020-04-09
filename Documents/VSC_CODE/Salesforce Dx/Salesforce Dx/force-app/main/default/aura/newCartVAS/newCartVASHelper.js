({
	objectIsEmpty: function(obj) {
        return Object.keys(obj).length === 0;
    },
    updateCartList: function(component){
        
        var cartList = [];
        var items = [];
        var contextOutput = component.get('v.contextOutput');
        var cart = contextOutput.cart[0];
        var offerta = cart.fields.productname;
        var childItems = cart.childItems;
        console.log(JSON.stringify(childItems))
        //Aggiungi l'offerta
        items.push(offerta);
        cartList.push({
            categoryName: "OFFERTA",
            items: items
        });
        if(Object.keys(childItems).length != 0){
            for(var i=0;i<childItems.length;i++){
                items = [];
                var childItem = childItems[i];
                var categoryName = childItem.fields.categoryname;
                var productName = childItem.fields.productname;
                var result = cartList.filter(obj => {
                    return obj.categoryName === categoryName
                });
                if(result.length !=0){
                    if(result[0].items.length != undefined){
                        for(var j=0; j<result[0].items.length;j++){
                            items.push(result[0].items[j]);
                        }
                    }
                    else items.push(result[0].items);
                    
                    items.push(productName);
                    var index = cartList.findIndex(x => x.categoryName==categoryName);
                    cartList[index].items = items;
                }
                else{
                    items.push(productName);
                    cartList.push({
                        categoryName: categoryName,
                        items: items
                    });
                }
            }
        }
        
		component.set('v.cartList',cartList);       
        
    },
    //francesca.ribezzi
    showDetailsSelectedCheckbox: function(component, event, openDetailsBtnId) {
   //   var selectedElement = event.currentTarget;
    	var selectedElement = document.getElementById(openDetailsBtnId);
        var offertChildList = component.get('v.offertChildList');
        var contextOutput = component.get('v.contextOutput');
        var item;
        var itemId = selectedElement.getAttribute('data-item');
        console.log("showDetailsSelectedCheckbox itemId: " + itemId);
        var itemShowDetails = document.getElementById(itemId+'_showDetails');
        var itemHideDetails = document.getElementById(itemId+'_hideDetails');
        var itemInfo = document.getElementById(itemId+'_info');
        var listOfItems = component.get("v.listOfItems");
        //1) TEST editable price Items by ID
        //for(var i = 0; i<listOfItems.length; i++){
        //	console.log("showDetailsSelectedCheckbox itemPrice iD: " + itemId+'_itemPrice'+i);
        //	console.log("showDetailsSelectedCheckbox listOfItems.length: " + listOfItems.length);
        	/*	for(var j = 0; j<document.getElementsByClassName("f216").length; j++ ){
        		console.log("id by class name f216: " + document.getElementsByClassName("f216")[j].id);
        			if(document.getElementById(itemId+'_itemPrice'+j) == document.getElementsByClassName("f216")[j].id ){
        				document.getElementsByClassName("f216")[j].readOnly = false;

        			}
        		} */
        
        //END TEST
        
        //2) TEST editable price Items by CLASS
    /*    var inputs = document.getElementsByClassName("f217");
        var inputs2 = document.getElementsByClassName("f216");
        if(inputs.length > 0){
        	for(var i = 0; i< inputs.length; i++){
        	    inputs[i].className =  'f216';
            	inputs[i].classList.remove('f217');
        		inputs[i].readOnly = false;
         }
        }else{
        	for(var i = 0; i< inputs2.length; i++){  
        	    inputs2[i].className =  'f216';
            	inputs2[i].classList.remove('f217');
        		inputs2[i].readOnly = false;
         }
        } */
        //END TEST
        itemShowDetails.classList.add("hidden");
        itemHideDetails.classList.remove("hidden");
        itemInfo.classList.remove("hidden");
        component.set("v.isEditablePrice",true);
        /*prendi dati sul i figli di quel item */
        //console.log(JSON.stringify(offertChildList))
        for(var offertaChild in offertChildList){
            if(offertChildList[offertaChild].id == itemId){
                item = offertChildList[offertaChild];
                console.log("showDetailsSelectedCheckbox item: " + item);
            }
        }
        console.log('today'+item.fields.catalogid)
        console.log(item.fields.categoryid)
        console.log(item.fields.parent)
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
            console.log('showDetailsSelectedCheckbox here')
            configureAppEvent.fire();
        }
    },
    //francesca.ribezzi
    hideDetailsSelectedCheckbox: function(component, event, openDetailsBtnId) {
        var selectedElement = document.getElementById(openDetailsBtnId);
        var itemId = selectedElement.getAttribute('data-item');
        var itemShowDetails = document.getElementById(itemId+'_showDetails');
        var itemHideDetails = document.getElementById(itemId+'_hideDetails');
        var itemInfo = document.getElementById(itemId+'_info');
        itemShowDetails.classList.remove("hidden");
        itemHideDetails.classList.add("hidden");
        itemInfo.classList.add("hidden");
    },
    
     updateCartList: function(component){
        
        var cartList = [];
        var items = [];
        var contextOutput = component.get('v.contextOutput');
        var cart = contextOutput.cart[0];
        var offerta = cart.fields.productname;
        var childItems = cart.childItems;
        console.log(JSON.stringify(childItems))
        //Adding offer (mind that everytime we add something below you add it here with null value)
        //Marco.Ferri 
        items.push({
        	productName: offerta,
            qty: ''
        });
        cartList.push({
            categoryName: "OFFERTA",
            items: items,
        });
        
        //if there are no object in the cart for everyone of them i get their attributes
        if(Object.keys(childItems).length != 0){
            for(var i=0;i<childItems.length;i++){
                items = [];
                var childItem = childItems[i];
                var categoryName = childItem.fields.categoryname;
                var productName = childItem.fields.productname;
                var qty = childItem.fields.qty;
                var result = cartList.filter(obj => {
                    return obj.categoryName === categoryName
                });
                if(result.length !=0){
                    if(result[0].items.length != undefined){
                        for(var j=0; j<result[0].items.length;j++){
                            items.push(result[0].items[j]);
                        }
                    }
                    else items.push(result[0].items);
                    //add every attribute we need to the array items
                     items.push({
                        productName: productName,
                        qty: qty
                    });
                    //----------------------------------------------
                    var index = cartList.findIndex(x => x.categoryName==categoryName);
                    cartList[index].items = items;
                }
                else{
                	//add every attribute we need to the array items
                    items.push({
                        productName: productName,
                        qty: qty
                    });
                    //----------------------------------------------
                    cartList.push({
                        categoryName: categoryName,
                        items: items,
                    });
                }
            }
        }
        console.log("MarkCartJSON"+JSON.stringify(cartList));
		component.set('v.cartList',cartList);       
        
    }
})