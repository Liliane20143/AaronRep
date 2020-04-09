({
	/* Handler for initialization */
	handleInit: function(component, event, helper) {
		helper.retrieveTranslationsMap(component, helper);
        helper.retrievePropertiesMap(component, helper);
	},
	/* Handler for opening the url */
	handleOpenUrl: function(component, event, helper) {
		var positions = event.currentTarget.dataset.record.split(',');
		//Getting action from items list
		var url = component.get('v.itemsList')[positions[0]].url;
		window.open(url, '_blank');
	}
})