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
        console.log('childIT::',childItems)
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
        
    }
})