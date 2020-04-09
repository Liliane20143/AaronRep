({
	doInit : function(cmp, evt, hlp) {
		const api = hlp.buildApi(cmp)

		api('isReferral', { })
			.then($A.getCallback(result => {
				cmp.set('v.showSpinner', false)
				cmp.set('v.isReferral', result)
				/*cmp.set('v.record', {
					sObjectType: 'BT_Simulation__c',
					BT_QtaSmartPos__c: 0,
					BT_QtaSmartPosCassa__c: 0,
					BT_QtaSmartPosPremium__c: 0,
					BT_QtaSmartPosCassaPremium__c: 0,
					BT_QtaPosTradSmart__c: 0,
					BT_QtaPosCordlSmart__c: 0,
					BT_QtaPosPortGprsSmart__c: 0,
					BT_QtaMobilePosSmart__c: 0,
					BT_QtaPosTradPremium__c: 0,
					BT_QtaPosWifiPremium__c: 0,
					BT_QtaPos3GPremium__c: 0,
					BT_TotalePOS__c: 0,
					BT_TotaleQPOS__c: 0
				})*/
			}))
	},

	handleStartSimulation: function(cmp, evt, hlp) {
		const api = hlp.buildApi(cmp)
		let annualParam = evt.getParam('annualParam')
		let geoParam = evt.getParam('geoParam')
		let mode = evt.getParam('mode')

		let record = cmp.get('v.record')
		let isReferral = cmp.get('v.isReferral')
		

		let params = {
			'mcc': record.BT_CatMerceologica__c,
			//'macrocatmerceologica': record.BT_MacroCatMerceologica__c
		}

		console.log(annualParam)
		console.log(geoParam)


		if (annualParam === $A.get('$Label.c.BT_NegoziatoAnnuo')) {
			params['negoziato'] = record.BT_NegoziatoAnnuo__c
		} else {
			params['fatturato'] = record.BT_FatturatoAnnuo__c
		}

		if (geoParam === $A.get('$Label.c.BT_CAP')) {
			params['cap'] = record.BT_CAP__c
		} else {
			params['provincia'] = record.BT_Provincia__c
		}

		cmp.set('v.showLoadSpinner', true)
		console.log(params)

		api(isReferral ? 'loadReferralConfigurations' : 'loadConfiguration', {'jsonParams': JSON.stringify(params), 'simulationMode': mode})
			.then(returnObject => {
				console.log(returnObject)
				cmp.set('v.config', returnObject)
				cmp.set('v.mode', mode)
				hlp.populateFromConfig(cmp, hlp, returnObject, params, mode, isReferral)
				cmp.set('v.showLoadSpinner', false)
			})
			.catch(error => {
				cmp.set('v.showLoadSpinner', false)
				console.log(error)
				hlp.notifyError(error)
			})
	},

	doSimulation : function(cmp, evt, hlp) {
		const api = hlp.buildApi(cmp)
		let recordToSave;
		let record = cmp.get('v.record')
		let config = cmp.get('v.config')
		let currentOffer = cmp.get('v.currentOffer')
		let mode = cmp.get('v.mode')
		let isReferral = cmp.get('v.isReferral')

		console.log('PRIMA: ' + JSON.stringify(record))

		cmp.set('v.showSaveSpinner', true)

		if (!isReferral || mode === 'packages') {
			hlp.computeAvgMfee(cmp, evt, hlp, record, config, currentOffer, mode)
			hlp.computeSemaphoreState(cmp, evt, hlp, record, config)
			hlp.computeAvgMonthlyCost(cmp, evt, hlp, record)
		}

		recordToSave = Object.assign({}, record)

		if (cmp.get('v.mode') === 'advanced') {
			hlp.toAbsoluteAcqEea(cmp, evt, hlp, recordToSave)
		}

		hlp.scalePercentFields(cmp, evt, hlp, recordToSave)

		console.log('DOPO: ' + JSON.stringify(recordToSave))

		api('saveSimulation', { 'record': recordToSave })
			.then(simId => {
				cmp.set('v.simulationId', simId)
				cmp.set('v.showSaveSpinner', false)
				cmp.set('v.simulationOK', true)
				let sender = evt.getParam('sender')
				let senderCallback = evt.getParam('senderCallback')
				if (!($A.util.isEmpty(sender) || $A.util.isEmpty(senderCallback) || $A.util.isEmpty(sender[senderCallback]))) {
					sender[senderCallback].apply(sender, evt.getParam('callbackParams'));
				}
			})
			.catch(error => {
				cmp.set('v.showSaveSpinner', false)
				console.log(error)
				hlp.notifyError(error)
			})

	}
})