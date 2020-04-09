({  
    doInit : function(component, event, helper)
    {
        helper.getField_helper(component, event, helper);
    },
 
    exportClick : function(component, event, helper)
    { 
        helper.exportDataTable(component); 
    },

    searchClick : function(component, event, helper)
    {
        helper.setFilters(component);
         
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
        //console.log('Filter:'+JSON.stringify(component.get("v.filters").reportMetadata.reportFilters)); 
        //console.log('List Filter:'+JSON.stringify(component.get("v.listFilters")));
        
        var listFilters = component.get("v.listFilters");
        var filters = component.get("v.filters");
        var value =  event.getSource().get("v.value");
        var name = event.getSource().get("v.name");
        
        var find = false;

        for(var filter in filters.reportMetadata.reportFilters){            
            if(filters.reportMetadata.reportFilters[filter].column == name){
                find = true;
                filters.reportMetadata.reportFilters[filter].value = value; 
            }
        }
        
        for(var filter in listFilters){
            
            if(listFilters[filter].column == name ){
                
                listFilters[filter].value = value;
                
                if(find==false){
                    var len = filters.reportMetadata.reportFilters.length;
                    filters.reportMetadata.reportFilters[len]={
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
        
        
        
        //console.log('Filtri picklist:'+JSON.stringify(filters.reportMetadata.reportFilters));
        //console.log('Filtri List picklist:'+JSON.stringify(listFilters));
        component.set("v.filters",filters);
        component.set("v.listFilters",listFilters);
        
        
        component.set("v.currentPageNumber", 1);
    }

    //  START   micol.ferrari 29/11/2018
    // updateColumnSorting: function (cmp, event, helper) 
    // {
    //     cmp.set('v.isLoading', true);
    //     // We use the setTimeout method here to simulate the async
    //     // process of the sorting data, so that user will see the
    //     // spinner loading when the data is being sorted.
    //     setTimeout(function() {
    //         var fieldName = event.getParam('fieldName');
    //         var sortDirection = event.getParam('sortDirection');
    //         cmp.set("v.sortedBy", fieldName);
    //         cmp.set("v.sortedDirection", sortDirection);
    //         helper.sortData(cmp, fieldName, sortDirection);
    //         cmp.set('v.isLoading', false);
    //     }, 0);
    // }
    //  END   micol.ferrari 29/11/2018

})