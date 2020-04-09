({  
    doInit : function(component, event, helper)
    {
        component.set("v.showSpinner","true");
        helper.getField_helper(component, event, helper);
    },
 
    exportClick : function(component, event, helper)
    { 
        helper.exportDataTable(component); 
    },

    exportAPIClick : function(component, event, helper)// DD --- Start
    { 
        helper.exportAPIdataTable(component); 
    },                                                 // DD --- End

    searchClick : function(component, event, helper)
    {
        component.set("v.currentPageNumber",1); 
        helper.setFilters(component);
        helper.setDataTable(component);
        
    }, 

    setDataTable : function(component, event, helper){
        helper.setDataTable(component);
    },   

    onNext : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber+1);
        helper.buildData(component, helper);
    },
    
    onPrev : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber-1);
        helper.buildData(component, helper);
    },
    
    processMe : function(component, event, helper) {
        component.set("v.currentPageNumber", parseInt(event.target.name));
        helper.buildData(component, helper);
    },
    
    onFirst : function(component, event, helper) {        
        component.set("v.currentPageNumber", 1);
        helper.buildData(component, helper);
    },
    
    onLast : function(component, event, helper) {        
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.buildData(component, helper);
    },

    changeData : function(component, event, helper){
        helper.buildData(component, helper);
    },

    onControllerFieldChange: function(component, event, helper) 
    {   
        var listFilters = component.get("v.listFilters");
        var filters = component.get("v.filters");
        var value =  event.getSource().get("v.value");
        var name = event.getSource().get("v.name");
        var find = false;

        for(var filter in filters.reportFilters){            
            if(filters.reportFilters[filter].column == name){
                find = true;
                filters.reportFilters[filter].value = value; 
            }
        }
        
        for(var filter in listFilters){
            
            if(listFilters[filter].column == name ){
                
                listFilters[filter].value = value;
                
                if(find==false){
                    console.log('##find false');
                    if(!$A.util.isEmpty(filters.reportFilters))
                    {
                        var len = filters.reportFilters.length;
                        filters.reportFilters[len]={
                        "column": name,
                        "isRunPageEditable": true,
                        "operator": "equals",
                        "value": value,
                        "label" : listFilters[filter].label,
                        "type" : listFilters[filter].type,
                        "filterValues" : listFilters[filter].filterValues 
                        };
                    }
                }
            }
        }
        
        component.set("v.listFilters",listFilters);
        component.set("v.currentPageNumber", 1);
    },

    updateColumnSorting: function (component, event, helper) {
        
        var fieldName = event.getParam('fieldName');
        console.log('masoud'+fieldName);
        var sortDirection = event.getParam('sortDirection');
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        helper.sortData(component,helper, fieldName, sortDirection);
    },

    filterName : function(component, event, helper ) {

        component.set("v.showSpinner","true");
        helper.filterDataTable(component, event, helper);
        
    }

})