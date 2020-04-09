({

    /*------------------------------------------------------------
    Author:        Daniele Gandini
    Company:       Accenture Tecnology
    Description:   doInit Method
    Date:          09/05/2019
   ------------------------------------------------------------*/
    doInit : function (component, event, helper) {
        // if(component.get("v.isOperationLogged")){
            helper.initHelper(component, event, helper);
        // }
    },

    checkDate : function (component, event, helper) {
        helper.checkDate_helper(component, event, helper);
    },

    // Daniele Gandini <daniele.gandini@accenture.com> - 19/06/2019 - method check required field in remove case flow - START
    checkNoteIfOK : function (component, event, helper) {
        helper.checkNoteIfOK_helper(component, event, helper);
    },
    // Daniele Gandini <daniele.gandini@accenture.com> - 19/06/2019 - onchange check required field in remove case flow - END
})