/**
 * Created by dilorenzo on 22/01/2019.
 */
({
    doInit: function(component, event, helper) {
        var additionalFieldsToShow = component.get("v.additionalFieldsToShow");
        var fieldsValues = [];
        //First item is always the main label to show
        component.set('v.mainFieldToShow', component.get('v.oRecord.' + additionalFieldsToShow[0]) );
        for(var i = 1; i< additionalFieldsToShow.length; i++){
            var item = component.get('v.oRecord.' + additionalFieldsToShow[i]);
            fieldsValues.push(item);
        }
        component.set("v.fieldsValues", fieldsValues.join(' • '));
    },
    selectRecord : function(component, event, helper){
        // Takes record from list
        var getSelectRecord = component.get("v.oRecord");
        // call event
        var compEvent = component.getEvent("oSelectedRecordEvent");
        // set record attribute within event
        compEvent.setParams({"recordByEvent" : getSelectRecord });
        // fire event
        compEvent.fire();
    }
})