/**
 * Created by ripagano on 19/04/2018.
 */
({
  initPickOpts : function(component, event, destAttribute){
    return new Promise($A.getCallback((resolve, reject) => {
      var placeholder          = component.get("v.placeholder");
      var sObjectType          = component.get("v.sObjectType");
      var fieldName            = component.get("v.fieldName");
      var multiple             = component.get("v.multiple");
      var value                = component.get("v.selectedValue");
      var recordType           = component.get("v.recordTypeDevName");
      var controlledBy         = component.get("v.controlledBy");
      var controlledByApiName  = component.get("v.controlledByApiName");
      var searchBox            = component.get("v.searchBox");
      var filter               = component.get("v.filter");

      var optionList=[];

      if (!searchBox) {
        optionList.push( {"class": "optionClass", "label": placeholder, "value": "0"} );
      }
      var action = component.get("c.getPickOpts");
      action.setParams({sObjectType : sObjectType, field: fieldName, recordTypeDevName: recordType, controlledBy: controlledBy, controlledByApiName: controlledByApiName, multipleValue: multiple, selectedValue: value});
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {
            var result = JSON.parse(response.getReturnValue()).filter(res => { return !filter.includes(res.value); });
            for(var i=0; i < result.length; i++){
                optionList.push( {"class": "optionClass", "label": result[i].label, "value": result[i].value, "selected": result[i].selected} );
            }
            component.set(destAttribute, [].concat(optionList));
            resolve(true)
        }
        else {
          reject(state)
        }
      });
      $A.enqueueAction(action);
    })
  )},
  
  updatePickOpts : function(component, event, destAttribute){
    this.initPickOpts(component, event, destAttribute);
  },

//  COMBOBOX HELPER

  validate  : function(component, helper, value) {
     var dataArray = component.get("v.pickOpts");
     if(value != '' && value != null) {
       var presente = false;
       for(var i=1; i<dataArray.length; i++){
          if(dataArray[i].label == label){
            presente = true;
          }
       }
       if(presente){
         $A.util.removeClass(component.find("InputElement"), "slds-has-error");
         $A.util.addClass(component.find("InputError"), "slds-hide");
         return true;
       } else{
         $A.util.addClass(component.find("InputElement"), "slds-has-error");
         $A.util.removeClass(component.find("InputError"), "slds-hide");
         return false;
       }
     }
  }
})