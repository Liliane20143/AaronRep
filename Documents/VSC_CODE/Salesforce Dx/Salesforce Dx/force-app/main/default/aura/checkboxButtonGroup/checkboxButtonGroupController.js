({
	onCheckboxChange : function(cmp, evt, hlp) {
		let idx = evt.currentTarget.getAttribute('aria-idx');
		let value = evt.currentTarget.getAttribute('value');
		let values = cmp.get('v.value');
		values[idx] = evt.currentTarget.checked ? value : null;
		cmp.set('v.value', values);
	}
})