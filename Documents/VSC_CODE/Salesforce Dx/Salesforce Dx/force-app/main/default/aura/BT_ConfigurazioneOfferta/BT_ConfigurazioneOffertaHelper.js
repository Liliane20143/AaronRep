({
	setActiveOffer: function(cmp, currentPackage, packages) {
		for (let i = 0; i < packages.length; i++) {
			if (packages[i].BT_CodiceOfferta__c === currentPackage) {
				cmp.set('v.currentOffer', packages[i])
				break
			}
		}
	},
	
	buildApi : function(c) {
	return function(method, params) {
		return new Promise((resolve, reject) => {
		$A.getCallback(function () {
			console.log('docall called');
			let action = c.get('c.' + method);
			if(params) action.setParams(params);
			action.setCallback(c, function (res) {
			if (c.isValid() && res.getState() === 'SUCCESS') {
				resolve(res.getReturnValue())
			} else if (c.isValid() && res.getState() === 'ERROR') {
				let error = 'Si è verificato un errore'
				if (res.getError() && res.getError()[0] && res.getError()[0].pageErrors && res.getError()[0].pageErrors[0]) {
				error = res.getError()[0].pageErrors[0].message
				} else if (res.getError()[0]) {
				error = res.getError()[0].message
				}
				reject(error)
			} else {
				reject(res)
			}
			});
		$A.enqueueAction(action)
		})()
		})
	}
	},

	notifyError: function (message) {
	const toastEvent = $A.get('e.force:showToast');
	toastEvent.setParams({
		'title': 'Errore',
		'message': message,
		'type': 'error'
	});
	toastEvent.fire();
	},

	notifySuccess: function (message) {
	const toastEvent = $A.get('e.force:showToast')
	toastEvent.setParams({
		'title': 'Operazione completata',
		'message': message,
		'type': 'success'
	});
	toastEvent.fire()
	},

	doSendEmail: function(cmp, evt, hlp) {
		let params = evt.getParam('arguments')
		let shouldUseSimplified = !($A.util.isEmpty(params) || $A.util.isEmpty(params.shouldUseSimplified)) ? params.shouldUseSimplified : false
		let api = hlp.buildApi(cmp)
		let isReferral = cmp.get('v.isReferral')
		let mode = cmp.get('v.mode')

		api('sendOfferVariationEmail', { simulationId: cmp.get('v.simulationId'), addCurrentUserCC: true, contactIdOverride: null, includeAttachment: !isReferral || mode === 'packages', referralSimplified: shouldUseSimplified })
		.then($A.getCallback(outcome => {
			if (outcome.success) {
				hlp.notifySuccess(outcome.message)
				cmp.set('v.emailButtonDisabled', true)
			} else {
				hlp.notifyError(outcome.message)
			}
		}))
		.catch($A.getCallback(error => {
			hlp.notifyError(error)
		}))
	},

	doPrint: function(cmp, evt, hlp) {
		window.open('../apex/BT_SimulationDocument?id=' + cmp.get('v.simulationId'))
	}
})