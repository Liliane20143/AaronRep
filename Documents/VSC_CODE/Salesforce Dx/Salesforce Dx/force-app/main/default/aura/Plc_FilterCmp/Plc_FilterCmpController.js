({
    initComponent: function (component, event, helper) {
        console.log('FilterCmp- init');
        helper.h_initComponent(component);
        if(component.get("v.searchOnLoad")){
            helper.h_applyFiltersCmp(component);
        }

        setTimeout(function(){
            component.find("inputSearch").focus();
        }, 300);
    },

    applyFiltersCmp: function (component, event, helper) {
        console.log('FilterCmp- applyFiltersCmp');
        helper.h_applyFiltersCmp(component);
    },

    removeFiltersCmp: function (component, event, helper) {
        console.log('FilterCmp- removeFiltersCmp');
        helper.h_removeFiltersCmp(component);

    },
    
    resetInputsAfterSearching: function (component, event, helper) {
        console.log('FilterCmp- resetInputsAfterSearching');
        helper.h_resetInputsAfterSearching(component);

    },

    keyCheck: function (component, event, helper) {
        console.log('FilterCmp- keyCheck');
        //seatch on keyPress (13 = enter key)
        if (event.which === 13) {
            if (!$A.util.isEmpty(component.get('v.inputSearch'))) {
                var inputSearchValue = component.get('v.inputSearch');
                component.set('v.inputSearch',inputSearchValue.replace(/[^0-9a-z]/gi, ''));
                //return console.log('Please insert a value before searching');
            }
            console.log('Enter key pressed, starting search function ', event.which);
            helper.h_applyFiltersCmp(component, event, helper);
        }

    },

    validityCheck :function(component,event,helper){
        console.log('FilterCmp- validityCheck');
        helper.h_validityCheck(component);
    },

    handleShowModal: function (component, event, helper) {
        var actionType = event.getParam("actionType");
        //set showModal true on button press
        if (!actionType) {
            console.log('FilterCmp- ShowModal = true');
            component.set("v.showModal", true);
        }

        //catches the event fired from child component Plc_UploadCsvCmp.cmp
        // (fired when close botton is pressed on the modal)
        if (event.getParam("actionType") === 'hideModal' || event.getParam("actionType") === 'sendCsvResults') {
            component.set("v.showModal", false);
            console.log('handleShowModalEvt lunched!');
            console.log('actionType: '+actionType +' showModal = false');
        }
    },

    handleChangeSearchOnLoad: function (component, event, helper){
        console.log('handleChangeSearchOnLoad: '+ component.get("v.searchOnLoad"));
        if(component.get("v.searchOnLoad")){
            helper.h_applyFiltersCmp(component);
        }
    },

});