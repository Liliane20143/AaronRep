({
    doInit: function(component, event, helper){
        component.set('v.mycolumns', [
            {label: 'Item Id', fieldName: 'Name', type: 'text'},
            {label: 'Item Name', fieldName: 'Id', type: 'text'},
            {label: 'Prod Name', fieldName: 'NE__ProdName__c', type: 'text'}
        ]);
        var orderItems = component.get("v.orderItems");
        var order = component.get("v.order");
        
        var objMap = component.get("v.objectDataMap");
        
         console.log("objMap: " + JSON.stringify(objMap));
     //    var orderId = objMap.orderId.orderId;
     
     var orderId = objMap.unbind.orderId;
            console.log("valore Unbind prima del set: " + orderId);
        component.set("v.order", orderId);
        
        var order = component.get("v.order");
        console.log("valore Unbind dopo il set: " + order);
        helper.searchOrder(component, event);
        
    },
    
    

})