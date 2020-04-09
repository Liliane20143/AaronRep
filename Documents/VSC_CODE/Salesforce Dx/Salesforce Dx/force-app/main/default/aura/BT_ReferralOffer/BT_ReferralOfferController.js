({
	onOfferChange : function(cmp, evt, hlp) {
		let record = cmp.get('v.record')
		let offer = cmp.get('v.offer')
		let mode = cmp.get('v.mode')

		hlp.populateFromOffer(cmp, hlp, offer, record, mode)
		hlp.resetFields(cmp, hlp, record)

		cmp.set('v.record', record)
	}
})