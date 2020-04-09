({
    doInit : function(component,event,helper){
        console.log('## rightValues: ',component.get("v.activeABI"));
        helper.initializeList(component,event);
        console.log('## active ABI: ',component.get("v.activeABI"));
    },
    moveLeftToRight : function(component,event, helper){
        helper.moveItems(component,'left');
    },
    moveRightToLeft : function(component,event, helper){
        helper.moveItems(component,'right');
    },
    handleSearch : function(component,event,helper){
        var searchText = component.get('v.searchText');
        var items = component.get("v.activeABI");
        var matchedItems = [];
        items.forEach( function(item){
            if(item.value.includes(searchText) || item.label.includes(searchText.toLowerCase())){ 
                matchedItems.push(item);
            }
        });
        console.log('## matchedItems: ',matchedItems);
        //component.set("v.rightValues",matchedItems);
    },
})