({
    doInit : function(component, event, helper) {
        var searchLovs = component.get("v.searchLovs");
        if(searchLovs){
            helper.getLovs(component, event);
        }else{
            helper.getCabForApproverLevel(component, event);
        }
    },
    getSelectedrow: function(component, event, helper) {

        var selectedRows = event.getParam('selectedRows');
        var mapOfSourceFieldTargetField = component.get("v.mapOfSourceFieldTargetField");
        var objectDataMap = component.get("v.objectDataMap");
        var objectString = component.get("v.objectString");
        var level = component.get('v.level');
        console.log("objectString in getSelectedrow" + JSON.stringify(objectString));
        console.log("objectDataMap in getSelectedrow" + JSON.stringify(objectDataMap));
        console.log("mapOfSourceFieldTargetField in getSelectedrow" + JSON.stringify(mapOfSourceFieldTargetField));
        console.log('level in selected rpw: ' + component.get('v.level'));
        // Display that fieldName of the selected rows
        var lovs = component.get("v.lovs");
        for (var i = 0; i < selectedRows.length; i++){
            console.log("selectedRows[i]: " + JSON.stringify(selectedRows[i]));

            component.set("v.objectDataMap" , objectDataMap);
            console.log('idSelected: ' + component.get('v.objectDataMap.lookupLov'));
            for(var key in mapOfSourceFieldTargetField){
                objectDataMap[objectString][key] = selectedRows[i][mapOfSourceFieldTargetField[key]];
                console.log("GET SELECTED ROW mapOfSourceFieldTargetField: " + key);
                console.log("selectedRows[i][mapOfSourceFieldTargetField[key]: " + selectedRows[i][mapOfSourceFieldTargetField[key]]);
                console.log("objectDataMap[objectString][key]: " + objectDataMap[objectString][key]);
            }

        }
        component.set("v.input", '');
        console.log("objectDataMap FINALLLLL" + JSON.stringify(objectDataMap));
        var selectedRows = [];
        component.set("v.selectedRows", selectedRows);
        console.log("SelectedRow Value: " , selectedRows);
      	helper.fireShowModalEvent(component, event);
    },
	closeModal: function(component, event, helper) {
        helper.fireShowModalEvent(component, event);
    },
    searchLovs: function(component, event, helper) {
        var searchLovs = component.get("v.searchLovs");
        if(searchLovs){
            helper.getLovs(component, event);
        }else{
            helper.getCabForApproverLevel(component, event);
        }
    },
    formPress: function(component, event, helper) {
        if (event.keyCode === 13){
            event.preventDefault();
            helper.getCabForApproverLevel(component, event); //antonio.vatrano 03/05/2019 R1F2-72     
        }
    },
    navigate : function(component, event, helper) {
        var mappa = component.get("v.mappa");
        var currentPage = component.get("v.currentPage");
        var direction = event.getSource().get("v.alternativeText");
        var currentList = component.get("v.currentList");
        if(direction === "previous"){
            currentPage = currentPage - 1;
            component.set("v.currentList",mappa[currentPage]);
            component.set("v.currentPage" ,currentPage);
        }else{
            currentPage = currentPage + 1;
            component.set("v.currentList",mappa[currentPage]);
            component.set("v.currentPage" ,currentPage);
        }
        
    },
    updateColumnSorting: function (component, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        helper.sortData(component, fieldName, sortDirection);
    },

})