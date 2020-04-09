({
    afterRender: function (component, helper) {
    	this.superAfterRender();
		console.log('After render Container by rederer');
		if(component.get("v.isContainerRendered") == false)
			component.set("v.isContainerRendered", true);
	}
})