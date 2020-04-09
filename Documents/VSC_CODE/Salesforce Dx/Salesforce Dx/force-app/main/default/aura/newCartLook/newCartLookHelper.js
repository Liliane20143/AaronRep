({
    objectIsEmpty: function(obj) {
        return Object.keys(obj).length === 0;
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
        //var elementImage = document.getElementById(selectedOfferta+'_img');
        var nascondiTxt = document.getElementById(selectedOfferta+'_nsc');
        var mostraTxt = document.getElementById(selectedOfferta+'_shw');
        element.classList.remove(selectedOfferta, 'u59');
        element.classList.remove(selectedOfferta, 'right');
        element.classList.add(selectedOfferta, 'u44');
        //elementImage.classList.remove("arrow_image");
        //elementImage.classList.add("hidden");
        /* hide misc text */
        nascondiTxt.classList.remove("u46");
        nascondiTxt.classList.add("hidden");
        
        mostraTxt.classList.remove("u46");
        mostraTxt.classList.add("hidden");
        
    },
    
    getOffertaDetails: function(component,selectedOfferta){
        var validItems = component.get('v.validItems');
        var validBundles = component.get('v.validBundles');
        //console.log('pippo'+JSON.stringify(validBundles));
        var item,description, bundle;
        for(var i=0;i<validItems.length;i++){
            item = validItems[i];
            if(item.id == selectedOfferta){
                description = item.fields.description;
                component.set('v.offertaHeader',item.fields.productname);
                component.set('v.offertaDescription',description);
                component.set('v.offertaImage',item.fields.thumbnailimage);
            }
            else continue;
            
        }
        
        for(var i=0;i<validBundles.length;i++){
            bundle = validBundles[i];
            if(bundle.id == selectedOfferta){
                description = bundle.fields.description;
                component.set('v.offertaHeader',bundle.fields.bundlename);
                component.set('v.offertaDescription',description);
                component.set('v.offertaImage',bundle.fields.thumbnailimage);
            }
            else continue;
            
        }
    }
})