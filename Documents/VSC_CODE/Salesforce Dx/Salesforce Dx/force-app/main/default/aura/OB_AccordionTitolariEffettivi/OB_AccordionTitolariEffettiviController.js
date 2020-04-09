({
	doInit : function(component, event, helper) 
	{
		console.log('I am in OB_AccordionTitolariEffettivi:doInit');
		var iterationStep = component.get("v.iterationStep");
		iterationStep = iterationStep + 1;
		component.set("v.iterationStep", iterationStep);
	}
})