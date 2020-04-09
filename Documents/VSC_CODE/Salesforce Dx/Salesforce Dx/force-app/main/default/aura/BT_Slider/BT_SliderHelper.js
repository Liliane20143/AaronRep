({
	updateTrackColor : function(cmp, value) {
		let divContainer = cmp.find('slider_div');
		if (value < cmp.get('v.yellowThreshold')) {
			cmp.set('v.trackColor', 'red');
		} else if (value >= cmp.get('v.yellowThreshold') && value < cmp.get('v.greenThreshold')) {
			cmp.set('v.trackColor', 'yellow');
		} else {
			cmp.set('v.trackColor', 'green');
		}
	},

	fireValueChange : function(cmp, value) {
		let sliderValueChange = cmp.getEvent("sliderValueChange");
		sliderValueChange.setParams({
			"name": cmp.get("v.name"),
			"value": value
		});
		sliderValueChange.fire();
	}
})