({
    searchOrder : function(component, event) {
        var orderId = component.get("v.order");
        console.log('taocheck'+orderId)
        var action = component.get("c.retrieveOrder");
        console.log("Param: " + orderId);
        action.setParams({
            "orderId": orderId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("success!");
                var orderItemList = response.getReturnValue();
                //console.log("Json item  " + JsonItem);
                var parent;
                for (var i=0;i<orderItemList.length; i++){
                    if((orderItemList[i].NE__Bundle_Element__c == undefined) && (orderItemList[i].NE__Root_Order_Item__c==undefined) && (orderItemList[i].NE__Parent_Order_Item__c==undefined)){
                        parent = orderItemList[i]; 
                    }
                }
                var listFirstLevel = [] ; 
                if(orderItemList.length >1){
                    for (var i=0;i<orderItemList.length; i++){
                        if((orderItemList[i].NE__Bundle_Element__c != undefined) && (orderItemList[i].NE__Bundle__c==parent.NE__Bundle__c)){
                            listFirstLevel.push(orderItemList[i]); 
                        }
                    }
                }
                
                var listSecondLevel = [] ; 
                
                    for(var i=0;i<listFirstLevel.length;i++){
                        console.log('Name firstLevel ' + listFirstLevel[i].NE__ProdName__c );
                        for (var j=0;j<orderItemList.length; j++){
                            if((orderItemList[j].NE__Root_Order_Item__c != undefined) && (listFirstLevel[i].Id == orderItemList[j].NE__Root_Order_Item__c)){
                                console.log('Name lista ' + orderItemList[j].NE__ProdName__c );
                                console.log('Id ' + listFirstLevel[i].Id + ' Root_Id ' + orderItemList[j].NE__Root_Order_Item__c);
                                listSecondLevel.push(orderItemList[j]);
                            }
                        }
                        
                    }
                
                
                var fullChildList = [];
                
                fullChildList.push(parent);
                for(var i=0;i<listFirstLevel.length;i++){
                    fullChildList.push(listFirstLevel[i]);
                    
                }
                for(var i=0;i<listSecondLevel.length;i++){
                    fullChildList.push(listSecondLevel[i]);
                    
                }
                
                console.log("Parent " + JSON.stringify(parent));
                console.log("FirstLevel list:"+JSON.stringify(listFirstLevel));
                console.log("SecondLevel  list:"+JSON.stringify(listSecondLevel));
                console.log("FullLevel list:"+JSON.stringify(fullChildList));
                
                component.set("v.orderItems", fullChildList);
                
                
                
                //component.set("v.orderItems", response.getReturnValue());   
                // var orderItems = component.get("v.orderItems");
                //console.log("order Items: " + JSON.stringify(orderItems));
                //console.log("order Items: " + orderItems.length);
                
            }
            
        });
        $A.enqueueAction(action);
    },
})