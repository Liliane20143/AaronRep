/**
 * Created by ripagano on 19/04/2018.
 */
({
  doInit : function(component, event, helper){
      helper.initPickOpts(component, event, 'v.pickOpts');
      // Listen for all clicks on the document
      document.addEventListener('click', function (event) {

          // If the click happened inside the the container, bail
          if(event.target != null){
            if (!event.target.closest('.slds-combobox')) {
            $A.util.removeClass(component.find("rCombo"), "slds-is-open");
            }
          }
      }, false);
  },

  updatePicklistValues : function(component, event, helper){
    let newControlledBy = event.getParam("value");
    helper.initPickOpts(component, event, 'v.pickOpts')
    .then($A.getCallback(res => {
        console.log('qui')
        let rCombo = component.find("rCombo");
        let dataArray;
        if (!$A.util.isEmpty(rCombo) && !$A.util.isEmpty(rCombo.getElement())) {
            dataArray = rCombo.getElement().getElementsByClassName("searchOption");
        }
        if ($A.util.isEmpty(newControlledBy)) {
            component.set("v.selectedValue", null);
            component.set("v.selectedLabel", null);
            if (!$A.util.isEmpty(dataArray) && dataArray.length > 0) {
                dataArray[0].style.display = 'block';
            } 
        } else {
            if (!$A.util.isEmpty(dataArray) && dataArray.length > 1) {
                dataArray[0].style.display = 'none';
            } 
        }
    }))
    
  },

//  COMBOBOX CONTROLLER

    validateInput : function(component, event, helper) {
        if(component.get("v.hideOptions") != false){
            $A.util.removeClass(component.find("rCombo"), "slds-is-open");
            var value = event.target.value;
            helper.validate(component, helper, value);
        }
        component.set("v.hideOptions", true);
    },

    disableHideOptions  : function(component, event, helper) {
        component.set("v.hideOptions", false);
    },
    showOptions  : function(component, event, helper) {
        $A.util.addClass(component.find("rCombo"), "slds-is-open");
    },

    hideOptions  : function(component, event, helper) {
        $A.util.removeClass(component.find("rCombo"), "slds-is-open");
    },

    setFiledFocus  : function(component, event, helper) {
         component.find("Field").getElement().focus();
    },

    selectOption  : function(component, event, helper) {
        var selectedItem = event.currentTarget;
        component.set("v.selectedValue", selectedItem.dataset.value);
        component.set("v.selectedLabel", selectedItem.dataset.label);
        $A.util.removeClass(component.find("rCombo"), "slds-is-open");
        event.stopPropagation();
    },

    search : function(component, event, helper) {
        let rCombo = component.find("rCombo");
        $A.util.addClass(rCombo, "slds-is-open");
        var searchTerm = event.target.value;
        var dataArray = rCombo.getElement().getElementsByClassName("searchOption");
        var hideCount = 1;
        if (dataArray.length > 1) {
            dataArray[0].style.display = 'none';
        }
        if(searchTerm != '' && searchTerm != null) {
            for(var i=1; i<dataArray.length; i++) {
                if(dataArray[i].getAttribute("data-label").toLowerCase().includes(searchTerm.toLowerCase())) {
                    dataArray[i].style.display = 'block';
                }else {
                    dataArray[i].style.display = 'none';
                    hideCount++;
                }
            }
            if(hideCount == dataArray.length){
                //Nessun risultato
                dataArray[0].style.display = 'block';
            }
        }else {
            for(var i=1; i<dataArray.length; i++) {
                dataArray[i].style.display = 'block';
            }
            $A.util.removeClass(component.find("InputElement"), "slds-has-error");
            $A.util.addClass(component.find("InputError"), "slds-hide");
        }
        component.set("v.selectedLabel", searchTerm);
    },

    clearText : function(component, event, helper) {
        component.set("v.selectedValue", null);
        component.set("v.selectedLabel", null);
    }

})