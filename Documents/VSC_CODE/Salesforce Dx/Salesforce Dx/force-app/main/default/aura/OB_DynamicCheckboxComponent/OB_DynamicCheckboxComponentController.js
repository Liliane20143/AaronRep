({
    /*
    *	Author		:   Morittu Andrea
    *	Date		:   26/Nov/2019
    *	Task		:   Untracked -> creating dynamic checkbox to insert in flows (Dependency : Bit2Flow)
    *	Description	:	DoInit
    */
	doInit : function(component, event, helper) {
        helper.doInit_Helper(component, event);
	},
    
    /*
    *	Author		:   Morittu Andrea
    *	Date		:   26/Nov/2019
    *	Task		:   Untracked -> creating dynamic checkbox to insert in flows (Dependency : Bit2Flow)
    *	Description	:	Method to store true or false values
    */
    onChangeCheckboxes : function(component, event, helper) {
        helper.onChangeCheckboxes_Helper(component, event); 
    }
})