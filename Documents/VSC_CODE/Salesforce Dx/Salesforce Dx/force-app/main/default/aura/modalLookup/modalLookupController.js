({
    doInit : function(component, event, helper) {
        //mappa composta da FieldName e Label:
        var mapLabelColumns = component.get("v.mapLabelColumns");
        var columns = [];
        //ciclo for mappa
        for(var key in mapLabelColumns){
            columns.push({"label": mapLabelColumns[key],"fieldName": key, "type": "text"});
            console.log("nel ciclo for" + columns);
        }
        //end for
        /*
        component.set('v.mycolumns', [
            {label: 'Item Id', fieldName: 'Name', type: 'text'},
            {label: 'Item Name', fieldName: 'NE__Type__c', type: 'text'},
            {label: 'Prod Name', fieldName: 'Id', type: 'text'}
        ]);
        */
        component.set('v.mycolumns', columns);
        console.log("mycolumns" + JSON.stringify(component.get('v.mycolumns')));
        
    },
    getSelectedrow: function(component, event, helper) {
        var selectedRows = event.getParam('selectedRows');
        var mapOfSourceFieldTargetField = component.get("v.mapOfSourceFieldTargetField");
        var objectDataMap = component.get("v.objectDataMap");

        var objectString = component.get("v.objectString");
        console.log("objectString in getSelectedrow" + objectString);
        // Display that fieldName of the selected rows
        var lovs = component.get("v.lovs");
        for (var i = 0; i < selectedRows.length; i++){
            //  selectedRows[i].opportunityName;
            console.log("selectedRows[i]: " + JSON.stringify(selectedRows[i]));
            for(var key in mapOfSourceFieldTargetField){
                /*
                    var objMap = {};
                    objMap[key] = lovs[0][mapOfSourceFieldTargetField[key]];
                    console.log("objMap "+ JSON.stringify(objMap));
                    console.log("objectDataMap[objectStr]: " + JSON.stringify(objectDataMap[objectStr]));
                    */
                    objectDataMap[objectString][key] = selectedRows[i][mapOfSourceFieldTargetField[key]];
                    console.log("success");
                }
        } 
        component.set("v.objectDataMap", objectDataMap);
        component.set("v.input", '');
        var selectedRows = [];
        component.set("v.selectedRows", selectedRows);
        console.log("objectDataMap " + JSON.stringify(objectDataMap)); 
        console.log("sto per chiamare l'helper");
      	helper.fireShowModalEvent(component, event);
    },
	closeModal: function(component, event, helper) {
        helper.fireShowModalEvent(component, event);
    },
    searchLovs: function(component, event, helper) {
        helper.getLovs(component, event);
    },
    formPress: function(component, event, helper) {
        if (event.keyCode === 13){
            event.preventDefault();
            helper.getLovs(component, event);      
        }
    }


    
})