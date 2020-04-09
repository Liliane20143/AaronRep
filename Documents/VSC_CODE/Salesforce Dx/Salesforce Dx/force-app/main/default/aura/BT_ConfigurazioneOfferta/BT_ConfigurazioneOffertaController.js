({
	doInit : function(cmp, evt, hlp) {
		let config = cmp.get('v.config')
		let record = cmp.get('v.record')
		let isReferral = cmp.get('v.isReferral')
		if (!$A.util.isEmpty(config)) {
			if (isReferral) {
				if (!$A.util.isEmpty(config.offers)) {
					if (config.offers.length > 1) {
						cmp.set('v.packagesOptions', config.offers.map(offer => {
							return {
								'label': offer.BT_NomeOfferta__c, value: offer.BT_CodiceOfferta__c
							}
						}))
						let defPkg = undefined
						for (let i = 0; i < config.offers.length; i++) {
							if (record.BT_TipologiaCliente__c === config.offers[i].BT_CriterioDefault__c || 
								(record.BT_NuovoPuntoVenditaPIVA__c && config.offers[i].BT_CriterioDefault__c === 'Nuovo punto vendita / partita IVA' )) {
								defPkg = config.offers[i].BT_CodiceOfferta__c
								break;
							}
						}
						if ($A.util.isEmpty(defPkg)) {
							for (let i = 0; i < config.offers.length; i++) {
								if ($A.util.isEmpty(config.offers[i].BT_CriterioDefault__c)) {
									defPkg = config.offers[i].BT_CodiceOfferta__c
									break;
								}
							}
						}
						cmp.set('v.currentPackage', defPkg)
						hlp.setActiveOffer(cmp, defPkg, config.offers)
					} else if (config.offers.length === 1) {
						cmp.set('v.currentOffer', config.offers[0])
					}
				}
			}
			//cmp.set('v.config', config)
			cmp.set('v.sumPercentCDP', (config.negcdp * 100).toFixed(2))
			cmp.set('v.sumPercentCDPExtraUE', (config.negcdpeea * 100).toFixed(2))
			cmp.set('v.sumPercentComm', (config.negcomm * 100).toFixed(2))
			cmp.set('v.sumPercentCommExtraUE', (config.negcommeea * 100).toFixed(2))
			cmp.set('v.sumPercentBancomat', (config.negpb * 100).toFixed(2))
			cmp.set('v.sumPercentAsian', (config.negasian * 100).toFixed(2))
			cmp.set('v.sumPercentEEA', config.negcdpeea + config.negcommeea)
		}
	},
	
	onPrintClick : function(cmp, evt, hlp) {
		let simulationOK = cmp.get('v.showSimulationResult')
		let isReferral = cmp.get('v.isReferral')
		if (isReferral && !simulationOK) {
			let simulationSaveEvent = cmp.getEvent('simulationSaveEvent')
			simulationSaveEvent.setParams({sender: cmp, senderCallback: 'doPrint'})
			simulationSaveEvent.fire();
		} else if (simulationOK) {
			hlp.doPrint(cmp, evt, hlp)
		}
		//cmp.set('v.showSimulationResult', false);
	},
	
	doRefresh: function(cmp, evt, hlp) {
		window.scroll({
			top: 0,
			left: 0,
			behavior: 'smooth' 
		});
		$A.get('e.force:refreshView').fire();
	},

	onConfigLoaded: function(cmp, evt, hlp) {
		let config = evt.getParam('arguments').config
		console.log(config)
	},

	onSendEmailClick: function(cmp, evt, hlp) {
		let simulationOK = cmp.get('v.showSimulationResult')
		let isReferral = cmp.get('v.isReferral')
		let mode = evt.getSource().get('v.name')
		
		if (isReferral && !simulationOK) {
			cmp.set('v.record.BT_RichiestaDeroga__c', mode === $A.get('$Label.c.BT_Semplificata'))
			cmp.set('v.record.BT_RichiestaDerogaFull__c', mode === $A.get('$Label.c.BT_Full'))
			let simulationSaveEvent = cmp.getEvent('simulationSaveEvent')
			simulationSaveEvent.setParams({sender: cmp, senderCallback: 'doSendEmail', callbackParams: [mode === $A.get('$Label.c.BT_Semplificata')]})
			simulationSaveEvent.fire();
		} else if (simulationOK) {
			hlp.doSendEmail(cmp, evt, hlp)
		}
	},

	doPrint: function(cmp, evt, hlp) {
		hlp.doPrint(cmp, evt, hlp)
	},

	doSendEmail: function(cmp, evt, hlp) {
		hlp.doSendEmail(cmp, evt, hlp)
	},

	onCurrentPackageChange: function(cmp, evt, hlp) {
		let config = cmp.get('v.config')
		cmp.set('v.showSpinner', true)
		window.setTimeout($A.getCallback(() => {
			hlp.setActiveOffer(cmp, evt.getParam('value'), config.offers)
			cmp.set('v.showSpinner', false)
		}), 500)
	}
})