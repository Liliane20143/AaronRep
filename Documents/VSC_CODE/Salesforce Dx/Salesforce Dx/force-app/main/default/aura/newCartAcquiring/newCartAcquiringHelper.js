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
        
        var currentStep = 0;
        //console.log("MARK TEST "+ JSON.stringify(component.get("v.listOfCategories")));
        //Adding offer (mind that everytime we add something below you add it here with null value)
        //Marco.Ferri 
        items.push({
        	productName: offerta,
            qty: '',
        });
        cartList.push({
            categoryName: "OFFERTA",
            items: items,
            step: 0 // we can hardcode this anyway, since its always the zero step Nd MarcoFerri
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
                        step: currentStep
                    });
                }
            }
        }
        //console.log("MarkCartJSON"+JSON.stringify(cartList));
		component.set('v.cartList',cartList);      
        
    }
})