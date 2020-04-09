({
	doInit: function(cmp, evt, hlp) {
		if(!$A.util.isEmpty(cmp.get('v.body'))) {
			cmp.get('v.body')[0].set('v.state', 'active');
		}
	},

	progressChanged: function(cmp, evt, hlp) {
		if(!$A.util.isEmpty(cmp.get('v.body'))) {
			let curProgress = evt.getParam('value');
			let steps = cmp.get('v.body').length;
			let progressStep = (100 / (steps - 1));
			let childIdx = Math.trunc(curProgress / progressStep);
			let i = 0;
			while (i < childIdx) {
				cmp.get('v.body')[i++].set('v.state', 'completed');
			}
			if (i < steps) {
				cmp.get('v.body')[i++].set('v.state', 'active');
			}
			while (i < steps) {
				cmp.get('v.body')[i++].set('v.state', '');
			}
		}
	}
})