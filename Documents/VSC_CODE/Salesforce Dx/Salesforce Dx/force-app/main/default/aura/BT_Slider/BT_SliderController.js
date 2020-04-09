({
	doInit : function(cmp, evt, hlp) {
		let maximumFractionDigits = cmp.get('v.maximumFractionDigits');
		cmp.set('v.yellowThreshold', Number(cmp.get('v.value')*cmp.get('v.yellowThresholdPercentage')).toFixed(maximumFractionDigits+2));
		cmp.set('v.greenThreshold', Number(cmp.get('v.value')).toFixed(maximumFractionDigits+2));
		hlp.updateTrackColor(cmp, cmp.get('v.value'));
	},

	onInput : function(cmp, evt, hlp) {
		cmp.set('v.value', evt.currentTarget.value);
	},

	onSliderChange : function(cmp, evt, hlp) {
		let value = evt.currentTarget.value;
		console.log(value);
		hlp.fireValueChange(cmp, value);
	},

	onInputNumberChange : function(cmp, evt, hlp) {
		let value = evt.getSource().get('v.value');
		console.log(value);
		hlp.fireValueChange(cmp, value);
	},

	onValueChange : function(cmp, evt, hlp) {
		let value = evt.getParam("value");
		cmp.set('v.hasDirectInputError', value < cmp.get('v.min') || value > cmp.get('v.max'));

		hlp.updateTrackColor(cmp, value);
	}
})