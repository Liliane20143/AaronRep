({
	doInit: function(cmp, evt, hlp) {
		let isReferral = cmp.get('v.isReferral')
		if (isReferral) {
			cmp.set('v.modeOptions', [
				{ label: $A.get('$Label.c.BT_PacchettiPredefiniti'), value: 'packages' },
				{ label: $A.get('$Label.c.BT_CondizioniPersonalizzate'), value: 'custom' },
				{ label: $A.get('$Label.c.BT_CommissioneUnica'), value: 'unique', }
			])
			cmp.set('v.mode', 'packages')
		} else {
			cmp.set('v.modeOptions', [
				{ label: $A.get('$Label.c.BT_Base'), value: 'basic' },
				{ label: $A.get('$Label.c.BT_Avanzata'), value: 'advanced' }
			])
			cmp.set('v.mode', 'basic')
		}
		hlp.computeStartSimulationState(cmp, evt, hlp);
	},

	onAnnualParamsChange: function(cmp, evt, hlp) {
		var selected = evt.getSource().get('v.label');
		cmp.set('v.annualParam', selected);
		hlp.computeStartSimulationState(cmp, evt, hlp);
	},

	onGeoParamsChange: function(cmp, evt, hlp) {
		var selected = evt.getSource().get('v.label');
		cmp.set('v.geoParam', selected);
		hlp.computeStartSimulationState(cmp, evt, hlp);
	},

	onRecordChange: function(cmp, evt, hlp) {
		let record = cmp.get('v.record')
		cmp.set('v.isNegGtThreshold', record.BT_NegoziatoAnnuo__c > cmp.get('v.negThreshold'))
		hlp.computeStartSimulationState(cmp, evt, hlp);
		let recordChangedEvent = cmp.getEvent('recordChangedEvent');
		recordChangedEvent.fire();
	},

	onStartSimulationClick: function(cmp, evt, hlp) {
		let simStartEvt = cmp.getEvent('simulationStartedEvent');
		simStartEvt.setParams({ annualParam: cmp.get('v.annualParam'), geoParam: cmp.get('v.geoParam'), mode: cmp.get('v.mode') });
		simStartEvt.fire();
	},

	onNegoziatoChange: function(cmp, evt, hlp) {
		let record = cmp.get('v.record')
		record.BT_FatturatoAnnuo__c = ''
		cmp.set('v.record', record)
	},

	onFatturatoChange: function(cmp, evt, hlp) {
		let record = cmp.get('v.record')
		record.BT_NegoziatoAnnuo__c = ''
		cmp.set('v.record', record)
	}
})