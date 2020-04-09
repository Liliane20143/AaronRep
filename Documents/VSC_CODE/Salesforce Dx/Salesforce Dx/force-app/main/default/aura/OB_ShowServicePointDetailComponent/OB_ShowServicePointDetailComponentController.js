({
	/*
	*	Author	:	Morittu Andrea
	*	Date	:	11-Oct-2019
	*	Task	:	EVO_PRODOB_450
	*	Descr	:	Component initialization
	*/
	doInit : function(component, event, helper) {
		helper.doInit_helper(component, event);
		helper.showOrHideSpinner(component, event );
	},
	/*
	*	Author	:	Morittu Andrea
	*	Date	:	11-Oct-2019
	*	Task	:	EVO_PRODOB_450
	*	Descr	:	Close modal function
	*/
	servicePointModalAction : function(component, event, helper) {
		helper.servicePointModalAction_helper(component, event);
	},
})