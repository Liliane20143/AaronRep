({
    /*
    *	Author		:	Morittu Andrea
    *	Date		:	20-11-2019
    *	Task		:	EVO_PRODOB_480
    *	Description :   DoInit Component 
    */
    doInit : function(component, event, helper) {
        helper.doInit_Helper(component, event);
    },

    /*
    *	Author		:	Morittu Andrea
    *	Date		:	20-11-2019
    *	Task		:	EVO_PRODOB_480
    *	Description	:   Grab value from checkboxes and store them into objectDataMap
    */
    onChangeCheckboxes : function(component, event, helper) {
        try {
            helper.onChangeCheckboxes_Helper(component, event);
        } catch(e) {
            console.log('An error has occured : ' + e.message);
        }
    }
})