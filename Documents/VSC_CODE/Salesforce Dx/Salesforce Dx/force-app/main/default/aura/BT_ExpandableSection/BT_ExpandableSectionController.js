({
	doInit: function(cmp, evt, hlp) {
		cmp.set('v.componentId', 'expando-' + Math.floor(Math.random() * 1000));
	},

	toggle: function(cmp, evt, hlp) {
		cmp.set('v.open', !cmp.get('v.open'));
	}
})