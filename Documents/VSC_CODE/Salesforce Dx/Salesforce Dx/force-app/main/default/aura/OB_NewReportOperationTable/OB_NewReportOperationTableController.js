({  
    doInit : function(component, event, helper){
        component.set("v.showSpinner","true");       
        helper.getField_helper(component, event, helper);       
    },
 
    exportClick : function(component, event, helper){    
        helper.exportDataTable(component); 
    },

    exportAPIClick : function(component, event, helper){// DD --- Start    
        helper.exportAPIdataTable(component); 
    },                                              // DD --- End

    
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

    onControllerFieldChange: function(component, event, helper) {     
        var listFilters = component.get("v.listFilters");
        var filters     = component.get("v.filters");
        var value       = event.getSource().get("v.value");
        var name        = event.getSource().get("v.name");
        var find        = false;
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
                    if(!$A.util.isEmpty(filters.reportFilters)){                    
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
        var sortDirection = event.getParam('sortDirection');
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        helper.sortData(component,helper, fieldName, sortDirection);
    },

    filterName : function(component, event, helper ) {
        component.set("v.error",false);
        component.set("v.showSpinner","true");
        //giovanni spinelli 15/07/2019 - start- pass var in helper
        var field = component.find("valueFilter").get("v.value");
        helper.filterDataTable(component, event, helper , field);   
        //giovanni spinelli 15/07/2019 - end- pass var in helper     
    },

    clearTable : function(component, event, helper){
        component.set("v.error",false);
        component.set("v.clear","");
		helper.tableClear(component, helper);
    },
    /**
	*@author Giovanni Spinelli <spinelli.giovanni@accenture.com>
	*@date 10/10/2018
	*@description Method to filter table when user clicks "enter key"
	*/
    searchEnterKey: function (component, event, helper) {
        if (event.keyCode === 13) {
            var actionFilterName = component.get("c.filterName");
            $A.enqueueAction(actionFilterName);
        }

    },

})