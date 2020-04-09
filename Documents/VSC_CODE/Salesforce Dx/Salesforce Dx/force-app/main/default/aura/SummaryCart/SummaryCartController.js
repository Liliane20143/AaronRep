({
    doInit: function(component, event, helper){
        component.set('v.mycolumns', [
            {label: 'Name ', fieldName: 'NE__ProdName__c', type: 'text'},
            {label: 'Quantity', fieldName: 'NE__Qty__c', type: 'number'},
            {label: 'OneTimeFeeOv', fieldName: 'NE__OneTimeFeeOv__c', type: 'currency'},
            {label: 'RecurringChargeOv', fieldName: 'NE__RecurringChargeOv__c', type: 'currency'},
            {label: 'Action', fieldName: 'NE__Action__c', type: 'text'},
            {label: 'Status', fieldName: 'NE__Status__c', type: 'text'},
            {label: 'Root_Order_Item', fieldName: 'NE__Root_Order_Item__c', type: 'text'}
            
        ]); 
        var orderItems = component.get("v.orderItems");
        var order = component.get("v.order");
        
        var objMap = component.get("v.objectDataMap");
        
        console.log("objMap nel Summary cart : " + JSON.stringify(objMap));
        //    var orderId = objMap.orderId.orderId;
        
       var orderId = objMap.Configuration.Id;

       console.log('order id dopo carello : ' + orderId);
        //var orderId = document.getElementById("input:orderId:UNBIND1");
        //var orderId='a0y9E000002gozFQAQ';

        //console.log("valore Unbind prima del set: " + orderId);
        component.set("v.order", orderId);
        
        var order = component.get("v.order");
        console.log("valore Unbind dopo il set: " + order);
        helper.searchOrder(component, event);
        
    },
    
    minimize_window : function(component,event){
        console.log("sono nel close window");
        //var cmpTarget = document.getElementById("ChildList");
        //$A.util.addClass(cmpTarget, 'slds-hide');
        //console.log('Componet show value ' + component.get("v.buttonChoice"));
        component.set("v.buttonChoice",false);
        component.set("v.showChilds",false);
        
    },
    
    add_window : function(component,event){
        component.set("v.buttonChoice",true);
        component.set("v.showChilds",true);
    }
    
    
    
})