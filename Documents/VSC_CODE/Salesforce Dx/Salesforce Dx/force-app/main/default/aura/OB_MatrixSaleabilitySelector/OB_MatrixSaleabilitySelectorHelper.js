({

    moveItems: function(component,startWith){
        var listCmp = component.find(startWith);
        listCmp.moveItems();
    },
    initializeList: function(component,event){
        var rightValues = component.get("v.rightValues");
        component.set("v.activeABI",rightValues);
    },
       
})