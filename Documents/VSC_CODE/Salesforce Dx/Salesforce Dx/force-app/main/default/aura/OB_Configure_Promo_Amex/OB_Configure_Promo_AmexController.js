({
	/*
		*   Author      :   Morittu Andrea
		*   Date        :   05-Sept-2019
        *   Task        :   BACKLOG-143 
        *   Description :   Do Init Function
	*/
    doInit : function(component, event, helper) {
       helper.toggleSpinner(component, event);
        helper.doInitHelper(component,event, helper)
    },
    
    /*
		*   Author      :   Morittu Andrea
		*   Date        :   05-Sept-2019
        *   Task        :   BACKLOG-143 
        *   Description :   Centralized Function for all buttons
	*/
    modalAction : function(component, event, helper) {
        helper.toggleSpinner(component, event);

        let wrapperOutcome = {};
        let whichButton = event.getSource().get("v.name");

        if($A.util.isUndefined(whichButton) && !$A.util.isUndefined(event.getParam('action')) ) {
            let action = event.getParam('action');
            whichButton = action.name;
        }
        switch (whichButton) {
            // NEW CONVENTION CODE
            case  $A.get("$Label.c.OB_New"):
                component.set('v.showModal' , true);
                component.set('v.modalOperation',  $A.get("$Label.c.OB_Create") );
                
                helper.toggleSpinner(component, event);
                break;
            // EDIT CONVENTION CODE
            case $A.get("$Label.c.OB_Edit"):
                component.set('v.showModal' , true);
                component.set('v.modalOperation',  $A.get("$Label.c.OB_Edit") );

                var row = event.getParam('row');
                component.set('v.currentRow', row);

                helper.populateInputModal(component, event, row, whichButton);

                helper.toggleSpinner(component, event);

                break;
            case $A.get("$Label.c.OB_Delete"):
                component.set('v.showModal' , true);
                component.set('v.modalOperation',  $A.get("$Label.c.OB_Delete") );

                var row = event.getParam('row');
                component.set('v.currentRow', row);

                helper.populateInputModal(component, event, row, whichButton );
                break;
            case $A.get("$Label.c.OB_Confirm") :
                let currentRow  = component.get('v.modalOperation') == $A.get("$Label.c.OB_Create") ? {} : component.get('v.currentRow');
                helper.checkData(component, event, currentRow, component.get('v.modalOperation') );
                break;
            // EXIT MODAL
            case $A.get("$Label.c.OB_Cancel"):
                component.set('v.showModal' , false);
                component.set('v.modalOperation',  '');

                helper.toggleSpinner(component, event);
        }
    },
})