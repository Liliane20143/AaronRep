({
    doInit : function(component, event, helper) {
        helper.doInit(component);
    },
    //davide.franzini - START
    handleSearch : function(component,event, helper){
        helper.handleSearch(component,event);
    },
    sendSelectedABI : function(component,event,helper){
        helper.sendSelectedABI(component);
    },
    //davide.franzini - END
    deleteFromList : function(component,event, helper){
        helper.deleteFromList(component,event);
    },
    moveItems : function(component,event, helper){
        helper.moveItems(component);
    },
    handleDataChangeAppEvent : function(component, event, helper) {
        helper.handleDataChangeAppEvent (component, event);
    },
    handleListClick : function(component, event, helper) {
        helper.handleListClick(component,event,"v.items","v.highlightedItems","v.highlightedItem");
    },
    handleAddItems : function(component,event, helper){
        helper.handleAddItems(component,event,"v.items","v.highlightedItems","v.highlightedItem");
    },
    //davide.franzini - START
    // handleReorderItemUp : function(component,event, helper){
    //     helper.reorderItem(component,'up');
    // },
    // handleReorderItemDown : function(component,event, helper){
    //     helper.reorderItem(component,'down');
    // },
    //davide.franzini - END
})