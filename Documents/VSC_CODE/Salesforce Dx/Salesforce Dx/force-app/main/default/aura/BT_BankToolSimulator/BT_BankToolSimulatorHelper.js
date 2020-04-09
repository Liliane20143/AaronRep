({
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

	populateFromConfig: function(cmp, hlp, configObject, callParams, mode, isReferral) {
		let record = cmp.get('v.record');

		record.BT_SimulazioneAvanzata__c = mode === 'advanced'

		let fieldMapToTransfer = {
			'BT_JCB__c': 'negjcb',
			'BT_MaestroCommercialEEA__c': 'negmaestrocommercialeea',
			'BT_MaestroCommercial__c': 'negmaestrocommercial',
			'BT_MaestroConsumerDebitEEA__c': 'negmaestroconsumerdebiteea',
			'BT_MaestroConsumerDebit__c': 'negmaestroconsumerdebit',
			'BT_MaestroConsumerPrepaidEEA__c': 'negmaestroconsumerprepaideea',
			'BT_MaestroConsumerPrepaid__c': 'negmaestroconsumerprepaid',
			'BT_MastercardCommercialEEA__c': 'negmastercardcommercialeea',
			'BT_MastercardCommercial__c': 'negmastercardcommercial',
			'BT_MastercardConsumerCreditEEA__c': 'negmastercardconsumercrediteea',
			'BT_MastercardConsumerCredit__c': 'negmastercardconsumercredit',
			'BT_MastercardConsumerDebitEEA__c': 'negmastercardconsumerdebiteea',
			'BT_MastercardConsumerDebit__c': 'negmastercardconsumerdebit',
			'BT_MastercardConsumerPrepaidEEA__c': 'negmastercardconsumerprepaideea',
			'BT_MastercardConsumerPrepaid__c': 'negmastercardconsumerprepaid',
			'BT_Pagobancomat__c': 'negpagobancomat',
			'BT_UPI__c': 'negupi',
			'BT_VPayConsumerDebitEEA__c': 'negvpayconsumerdebiteea',
			'BT_VPayConsumerDebit__c': 'negvpayconsumerdebit',
			'BT_VPayConsumerPrepaidEEA__c': 'negvpayconsumerprepaideea',
			'BT_VPayConsumerPrepaid__c': 'negvpayconsumerprepaid',
			'BT_VisaCommercialEEA__c': 'negvisacommercialeea',
			'BT_VisaCommercial__c': 'negvisacommercial',
			'BT_VisaConsumerCreditEEA__c': 'negvisaconsumercrediteea',
			'BT_VisaConsumerCredit__c': 'negvisaconsumercredit',
			'BT_VisaConsumerDebitEEA__c': 'negvisaconsumerdebiteea',
			'BT_VisaConsumerDebit__c': 'negvisaconsumerdebit',
			'BT_VisaConsumerPrepaidEEA__c': 'negvisaconsumerprepaideea',
			'BT_VisaConsumerPrepaid__c': 'negvisaconsumerprepaid',
		}

		if (!isReferral) {
			fieldMapToTransfer = Object.assign(fieldMapToTransfer, {
				'BT_CanMensMobilePosSmart__c': 'BT_Min_MobilePosSmart__c',
				'BT_CanMensPos3GPremium__c': 'BT_Min_PosPortatile3gPremium__c',
				'BT_CanMensPosCordlSmart__c': 'BT_Min_PosCordSmartPstnEth__c',
				'BT_CanMensPosPortGprsSmart__c': 'BT_Min_PosPortatileGprsSmart__c',
				'BT_CanMensPosTradPremium__c': 'BT_Min_PosTradizionalePremium__c',
				'BT_CanMensPosTradSmart__c': 'BT_Min_PosTradSmartPstnEth__c',
				'BT_CanMensPosWifiPremium__c': 'BT_Min_PosCordlessWifiPremium__c',
				'BT_CanMensSmartPosCassaPremium__c': 'BT_Min_SmartposCassaPremium__c',
				'BT_CanMensSmartPosCassa__c': 'BT_Min_SmartposCassa__c',
				'BT_CanMensSmartPosPremium__c': 'BT_Min_SmartposPremium__c',
				'BT_CanMensSmartPos__c': 'BT_Min_Smartpos__c',
			})

			if (mode === 'advanced') {
				fieldMapToTransfer = Object.assign(fieldMapToTransfer, {
					'BT_MaestroCommercialAcqEEA__c': ['mfeemaestrocommercialeea', 'mfeemaestrocommercial'],
					'BT_MaestroCommercialAcq__c': 'mfeemaestrocommercial',
					'BT_MaestroConsumerDebitAcqEEA__c': ['mfeemaestroconsumerdebiteea', 'mfeemaestroconsumerdebit'],
					'BT_MaestroConsumerDebitAcq__c': 'mfeemaestroconsumerdebit',
					'BT_MaestroConsumerPrepaidAcqEEA__c': ['mfeemaestroconsumerprepaideea', 'mfeemaestroconsumerprepaid'],
					'BT_MaestroConsumerPrepaidAcq__c': 'mfeemaestroconsumerprepaid',
					'BT_MastercardCommercialAcqEEA__c': ['mfeemastercardcommercialeea', 'mfeemastercardcommercial'],
					'BT_MastercardCommercialAcq__c': 'mfeemastercardcommercial',
					'BT_MastercardConsumerCreditAcqEEA__c': ['mfeemastercardconsumercrediteea', 'mfeemastercardconsumercredit'],
					'BT_MastercardConsumerCreditAcq__c': 'mfeemastercardconsumercredit',
					'BT_MastercardConsumerDebitAcqEEA__c': ['mfeemastercardconsumerdebiteea', 'mfeemastercardconsumerdebit'],
					'BT_MastercardConsumerDebitAcq__c': 'mfeemastercardconsumerdebit',
					'BT_MastercardConsumerPrepaidAcqEEA__c': ['mfeemastercardconsumerprepaideea', 'mfeemastercardconsumerprepaid'],
					'BT_MastercardConsumerPrepaidAcq__c': 'mfeemastercardconsumerprepaid',
					'BT_VPayConsumerDebitAcqEEA__c': ['mfeevpayconsumerdebiteea', 'mfeevpayconsumerdebit'],
					'BT_VPayConsumerDebitAcq__c': 'mfeevpayconsumerdebit',
					'BT_VPayConsumerPrepaidAcqEEA__c': ['mfeevpayconsumerprepaideea', 'mfeevpayconsumerprepaid'],
					'BT_VPayConsumerPrepaidAcq__c': 'mfeevpayconsumerprepaid',
					'BT_VisaCommercialAcqEEA__c': ['mfeevisacommercialeea', 'mfeevisacommercial'],
					'BT_VisaCommercialAcq__c': 'mfeevisacommercial',
					'BT_VisaConsumerCreditAcqEEA__c': ['mfeevisaconsumercrediteea', 'mfeevisaconsumercredit'],
					'BT_VisaConsumerCreditAcq__c': 'mfeevisaconsumercredit',
					'BT_VisaConsumerDebitAcqEEA__c': ['mfeevisaconsumerdebiteea', 'mfeevisaconsumerdebit'],
					'BT_VisaConsumerDebitAcq__c': 'mfeevisaconsumerdebit',
					'BT_VisaConsumerPrepaidAcqEEA__c': ['mfeevisaconsumerprepaideea', 'mfeevisaconsumerprepaid'],
					'BT_VisaConsumerPrepaidAcq__c': 'mfeevisaconsumerprepaid',
					'BT_JCBAcq__c': 'mfeejcb',
					'BT_UPIAcq__c': 'mfeeupi',
					'BT_PagobancomatAcq__c': 'mfeepagobancomat'
				})
			} else if (mode === 'basic') {
				fieldMapToTransfer = Object.assign(fieldMapToTransfer, {
					'BT_MaestroCommercialAcqEEA__c': 'mfeecommeea',
					'BT_MaestroCommercialAcq__c': 'mfeecomm',
					'BT_MaestroConsumerDebitAcqEEA__c': 'mfeecdpeea',
					'BT_MaestroConsumerDebitAcq__c': 'mfeecdp',
					'BT_MaestroConsumerPrepaidAcqEEA__c': 'mfeecdpeea',
					'BT_MaestroConsumerPrepaidAcq__c': 'mfeecdp',
					'BT_MastercardCommercialAcqEEA__c': 'mfeecommeea',
					'BT_MastercardCommercialAcq__c': 'mfeecomm',
					'BT_MastercardConsumerCreditAcqEEA__c': 'mfeecdpeea',
					'BT_MastercardConsumerCreditAcq__c': 'mfeecdp',
					'BT_MastercardConsumerDebitAcqEEA__c': 'mfeecdpeea',
					'BT_MastercardConsumerDebitAcq__c': 'mfeecdp',
					'BT_MastercardConsumerPrepaidAcqEEA__c': 'mfeecdpeea',
					'BT_MastercardConsumerPrepaidAcq__c': 'mfeecdp',
					'BT_VPayConsumerDebitAcqEEA__c': 'mfeecdpeea',
					'BT_VPayConsumerDebitAcq__c': 'mfeecdp',
					'BT_VPayConsumerPrepaidAcqEEA__c': 'mfeecdpeea',
					'BT_VPayConsumerPrepaidAcq__c': 'mfeecdp',
					'BT_VisaCommercialAcqEEA__c': 'mfeecommeea',
					'BT_VisaCommercialAcq__c': 'mfeecomm',
					'BT_VisaConsumerCreditAcqEEA__c': 'mfeecdpeea',
					'BT_VisaConsumerCreditAcq__c': 'mfeecdp',
					'BT_VisaConsumerDebitAcqEEA__c': 'mfeecdpeea',
					'BT_VisaConsumerDebitAcq__c': 'mfeecdp',
					'BT_VisaConsumerPrepaidAcqEEA__c': 'mfeecdpeea',
					'BT_VisaConsumerPrepaidAcq__c': 'mfeecdp',
					'BT_JCBAcq__c': 'mfeeasian',
					'BT_UPIAcq__c': 'mfeeasian',
					'BT_PagobancomatAcq__c': 'mfeepb'
				})
			}
		}


		Object.keys(fieldMapToTransfer).forEach(recordField => {
			if (Array.isArray(fieldMapToTransfer[recordField])) {
				record[recordField] = Math.max(0, configObject[fieldMapToTransfer[recordField][0]] - configObject[fieldMapToTransfer[recordField][1]])
			} else {
				record[recordField] = configObject[fieldMapToTransfer[recordField]]
			}
		})

		if (!$A.util.isEmpty(callParams['negoziato'])) {
			record.BT_FatturatoAnnuo__c = Number((record.BT_NegoziatoAnnuo__c / configObject.incrpercnegfatt).toFixed(2));
		} else if (!$A.util.isEmpty(callParams['fatturato'])) {
			record.BT_NegoziatoAnnuo__c = Number((record.BT_FatturatoAnnuo__c * configObject.incrpercnegfatt).toFixed(2));
		}

		console.log(JSON.stringify(record));

		cmp.set('v.record', record)
	},

	computeAvgMfee : function(cmp, evt, hlp, record, config, currentOffer, mode) {
		let negFields = ['BT_JCB__c', 'BT_MaestroCommercial__c', 'BT_MaestroCommercialEEA__c',
			'BT_MaestroConsumerDebit__c', 'BT_MaestroConsumerDebitEEA__c', 'BT_MaestroConsumerPrepaid__c',
			'BT_MaestroConsumerPrepaidEEA__c', 'BT_MastercardCommercial__c', 'BT_MastercardCommercialEEA__c',
			'BT_MastercardConsumerCredit__c', 'BT_MastercardConsumerCreditEEA__c', 'BT_MastercardConsumerDebit__c',
			'BT_MastercardConsumerDebitEEA__c', 'BT_MastercardConsumerPrepaid__c', 'BT_MastercardConsumerPrepaidEEA__c',
			'BT_Pagobancomat__c', 'BT_UPI__c', 'BT_VisaCommercial__c',
			'BT_VisaCommercialEEA__c', 'BT_VisaConsumerCredit__c', 'BT_VisaConsumerCreditEEA__c',
			'BT_VisaConsumerDebit__c', 'BT_VisaConsumerDebitEEA__c', 'BT_VisaConsumerPrepaid__c',
			'BT_VisaConsumerPrepaidEEA__c', 'BT_VPayConsumerDebit__c', 'BT_VPayConsumerDebitEEA__c',
			'BT_VPayConsumerPrepaid__c', 'BT_VPayConsumerPrepaidEEA__c']

		let acqFields = ['BT_JCBAcq__c', 'BT_MaestroCommercialAcq__c', 'BT_MaestroCommercialAcqEEA__c',
			'BT_MaestroConsumerDebitAcq__c', 'BT_MaestroConsumerDebitAcqEEA__c', 'BT_MaestroConsumerPrepaidAcq__c',
			'BT_MaestroConsumerPrepaidAcqEEA__c', 'BT_MastercardCommercialAcq__c', 'BT_MastercardCommercialAcqEEA__c',
			'BT_MastercardConsumerCreditAcq__c', 'BT_MastercardConsumerCreditAcqEEA__c', 'BT_MastercardConsumerDebitAcq__c',
			'BT_MastercardConsumerDebitAcqEEA__c', 'BT_MastercardConsumerPrepaidAcq__c', 'BT_MastercardConsumerPrepaidAcqEEA__c',
			'BT_PagobancomatAcq__c', 'BT_UPIAcq__c', 'BT_VisaCommercialAcq__c',
			'BT_VisaCommercialAcqEEA__c', 'BT_VisaConsumerCreditAcq__c', 'BT_VisaConsumerCreditAcqEEA__c',
			'BT_VisaConsumerDebitAcq__c', 'BT_VisaConsumerDebitAcqEEA__c', 'BT_VisaConsumerPrepaidAcq__c',
			'BT_VisaConsumerPrepaidAcqEEA__c', 'BT_VPayConsumerDebitAcq__c', 'BT_VPayConsumerDebitAcqEEA__c',
			'BT_VPayConsumerPrepaidAcq__c', 'BT_VPayConsumerPrepaidAcqEEA__c']

		let types = ['IF', 'Oneri', 'Costo']
		let configFeeFieldsToSubtract = types.map(t => {
			return ['BT_${this.type}_jcb__c', 'BT_${this.type}_maestrocommercial__c', 'BT_${this.type}_maestrocommercialEEA__c',
					'BT_${this.type}_maestroconsumerdebit__c', 'BT_${this.type}_maestroconsumerdebitEEA__c', 'BT_${this.type}_maestroconsumerprepaid__c',
					'BT_${this.type}_maestroconsumerprepaidEEA__c', 'BT_${this.type}_mastercardcommercial__c', 'BT_${this.type}_mastercardcommercialEEA__c',
					'BT_${this.type}_mastercardconsumercredit__c', 'BT_${this.type}_mastercardconsumercreditEEA__c', 'BT_${this.type}_mastercardconsumerdebit__c',
					'BT_${this.type}_mastercardconsumerdebitEEA__c', 'BT_${this.type}_mastercardconsumerprepaid__c', 'BT_${this.type}_mastercardconsumerprepaidEEA__c',
					'BT_${this.type}_pagobancomat__c', 'BT_${this.type}_upi__c', 'BT_${this.type}_visacommercial__c',
					'BT_${this.type}_visacommercialEEA__c', 'BT_${this.type}_visaconsumercredit__c', 'BT_${this.type}_visaconsumercreditEEA__c',
					'BT_${this.type}_visaconsumerdebit__c', 'BT_${this.type}_visaconsumerdebitEEA__c', 'BT_${this.type}_visaconsumerprepaid__c',
					'BT_${this.type}_visaconsumerprepaidEEA__c', 'BT_${this.type}_vpayconsumerdebit__c', 'BT_${this.type}_vpayconsumerdebitEEA__c',
					'BT_${this.type}_vpayconsumerprepaid__c', 'BT_${this.type}_vpayconsumerprepaidEEA__c'].map(fieldTemplate => {
						return new Function('return `' + fieldTemplate + '`;').call({type: t})})
		})

		let netFee = 0
		let fee = 0;
		let cfg = mode === 'packages' ? currentOffer : config
		console.log(mode)
		console.log(config)
		console.log(currentOffer)
		for(let i = 0; i < negFields.length; i++) {
			if (i >= acqFields.length) { break }
			
			let recordValue = record[acqFields[i]]
			console.log(acqFields[i] + ', ' + recordValue)

			if ((mode === 'advanced' || mode === 'packages') && acqFields[i].includes('EEA')) {
				recordValue += record[acqFields[i].replace('EEA', '')]
			}
			fee += record[negFields[i]] * recordValue

			for (let j = 0; j < types.length; j++) {
				console.log(configFeeFieldsToSubtract[j][i] + ', ' + cfg[configFeeFieldsToSubtract[j][i]])
				recordValue -= cfg[configFeeFieldsToSubtract[j][i]]
			}
			netFee += record[negFields[i]] * recordValue
			
		}
		console.log(Number((netFee * 100).toFixed(2)));
		record.BT_CommissioneMedia__c = Number((fee * 100).toFixed(2));
		record.BT_CommissioneMediaNetta__c = Number((netFee * 100).toFixed(2));
	},

	computeAvgMonthlyCost : function(cmp, evt, hlp, record) {
		record.BT_StimaCommissionaleMensile__c = Number(Number((record.BT_CommissioneMedia__c / 100.0) * (record.BT_NegoziatoAnnuo__c / 12.0)).toFixed(2))
	},

	scalePercentFields : function(cmp, evt, hlp, record) {
		let fields = [
			'BT_JCB__c', 'BT_MaestroCommercial__c', 'BT_MaestroCommercialEEA__c',
			'BT_MaestroConsumerDebit__c', 'BT_MaestroConsumerDebitEEA__c', 'BT_MaestroConsumerPrepaid__c',
			'BT_MaestroConsumerPrepaidEEA__c', 'BT_MastercardCommercial__c', 'BT_MastercardCommercialEEA__c',
			'BT_MastercardConsumerCredit__c', 'BT_MastercardConsumerCreditEEA__c', 'BT_MastercardConsumerDebit__c',
			'BT_MastercardConsumerDebitEEA__c', 'BT_MastercardConsumerPrepaid__c', 'BT_MastercardConsumerPrepaidEEA__c',
			'BT_Pagobancomat__c', 'BT_UPI__c', 'BT_VisaCommercial__c',
			'BT_VisaCommercialEEA__c', 'BT_VisaConsumerCredit__c', 'BT_VisaConsumerCreditEEA__c',
			'BT_VisaConsumerDebit__c', 'BT_VisaConsumerDebitEEA__c', 'BT_VisaConsumerPrepaid__c',
			'BT_VisaConsumerPrepaidEEA__c', 'BT_VPayConsumerDebit__c', 'BT_VPayConsumerDebitEEA__c', 'BT_VPayConsumerPrepaid__c', 'BT_VPayConsumerPrepaidEEA__c',
			'BT_JCBAcq__c', 'BT_MaestroCommercialAcq__c', 'BT_MaestroCommercialAcqEEA__c',
			'BT_MaestroConsumerDebitAcq__c', 'BT_MaestroConsumerDebitAcqEEA__c', 'BT_MaestroConsumerPrepaidAcq__c',
			'BT_MaestroConsumerPrepaidAcqEEA__c', 'BT_MastercardCommercialAcq__c', 'BT_MastercardCommercialAcqEEA__c',
			'BT_MastercardConsumerCreditAcq__c', 'BT_MastercardConsumerCreditAcqEEA__c', 'BT_MastercardConsumerDebitAcq__c',
			'BT_MastercardConsumerDebitAcqEEA__c', 'BT_MastercardConsumerPrepaidAcq__c', 'BT_MastercardConsumerPrepaidAcqEEA__c',
			'BT_PagobancomatAcq__c', 'BT_UPIAcq__c', 'BT_VisaCommercialAcq__c',
			'BT_VisaCommercialAcqEEA__c', 'BT_VisaConsumerCreditAcq__c', 'BT_VisaConsumerCreditAcqEEA__c',
			'BT_VisaConsumerDebitAcq__c', 'BT_VisaConsumerDebitAcqEEA__c', 'BT_VisaConsumerPrepaidAcq__c',
			'BT_VisaConsumerPrepaidAcqEEA__c', 'BT_VPayConsumerDebitAcq__c', 'BT_VPayConsumerDebitAcqEEA__c',
			'BT_VPayConsumerPrepaidAcq__c', 'BT_VPayConsumerPrepaidAcqEEA__c'
		]

		fields.forEach(field => {
			record[field] = Number((record[field] * 100).toFixed(2))
		})
	},

	toAbsoluteAcqEea : function(cmp, evt, hlp, record) {
		let acqFieldMap = {
			'BT_MaestroCommercialAcqEEA__c': 'BT_MaestroCommercialAcq__c',
			'BT_MaestroConsumerDebitAcqEEA__c': 'BT_MaestroConsumerDebitAcq__c', 
			'BT_MaestroConsumerPrepaidAcqEEA__c': 'BT_MaestroConsumerPrepaidAcq__c',
			'BT_MastercardCommercialAcqEEA__c': 'BT_MastercardCommercialAcq__c',
			'BT_MastercardConsumerCreditAcqEEA__c': 'BT_MastercardConsumerCreditAcq__c', 
			'BT_MastercardConsumerDebitAcqEEA__c': 'BT_MastercardConsumerDebitAcq__c', 
			'BT_MastercardConsumerPrepaidAcqEEA__c': 'BT_MastercardConsumerPrepaidAcq__c',
			'BT_VisaCommercialAcqEEA__c': 'BT_VisaCommercialAcq__c', 
			'BT_VisaConsumerCreditAcqEEA__c': 'BT_VisaConsumerCreditAcq__c',
			'BT_VisaConsumerDebitAcqEEA__c': 'BT_VisaConsumerDebitAcq__c', 
			'BT_VisaConsumerPrepaidAcqEEA__c': 'BT_VisaConsumerPrepaidAcq__c', 
			'BT_VPayConsumerDebitAcqEEA__c': 'BT_VPayConsumerDebitAcq__c',
			'BT_VPayConsumerPrepaidAcqEEA__c': 'BT_VPayConsumerPrepaidAcq__c'
		}

		Object.keys(acqFieldMap).forEach(fieldEea => record[fieldEea] += record[acqFieldMap[fieldEea]])
	},

	computeSemaphoreState : function(cmp, evt, hlp, record, config) {
		let mfeeOk = record.BT_CommissioneMediaNetta__c >= (config.BT_MarginalitaDesiderataTOTPreventivo__c * 100)

		let posOk = true

		let posFieldsToCheck = {
			'BT_Min_Smartpos__c': ['BT_CanMensSmartPos__c', 'BT_QtaSmartPos__c'],
			'BT_Min_SmartposCassa__c': ['BT_CanMensSmartPosCassa__c', 'BT_QtaSmartPosCassa__c'],
			'BT_Min_SmartposPremium__c': ['BT_CanMensSmartPosPremium__c', 'BT_QtaSmartPosPremium__c'],
			'BT_Min_SmartposCassaPremium__c': ['BT_CanMensSmartPosCassaPremium__c', 'BT_QtaSmartPosCassaPremium__c'],
			'BT_Min_MobilePosSmart__c': ['BT_CanMensMobilePosSmart__c', 'BT_QtaMobilePosSmart__c'],
			'BT_Min_PosPortatile3gPremium__c': ['BT_CanMensPos3GPremium__c', 'BT_QtaPos3GPremium__c'],
			'BT_Min_PosCordSmartPstnEth__c': ['BT_CanMensPosCordlSmart__c', 'BT_QtaPosCordlSmart__c'],
			'BT_Min_PosPortatileGprsSmart__c': ['BT_CanMensPosPortGprsSmart__c', 'BT_QtaPosPortGprsSmart__c'],
			'BT_Min_PosTradizionalePremium__c': ['BT_CanMensPosTradPremium__c', 'BT_QtaPosTradPremium__c'],
			'BT_Min_PosTradSmartPstnEth__c': ['BT_CanMensPosTradSmart__c', 'BT_QtaPosTradSmart__c'],
			'BT_Min_PosCordlessWifiPremium__c': ['BT_CanMensPosWifiPremium__c', 'BT_QtaPosWifiPremium__c']
		}

		console.log(posFieldsToCheck)
		Object.keys(posFieldsToCheck).filter(configField => {
			return !($A.util.isEmpty(record[posFieldsToCheck[configField][0]]) || $A.util.isEmpty(record[posFieldsToCheck[configField][1]]))
		}).map(configField => {
			console.log(configField + ', ' + posFieldsToCheck[configField] + ', ' + record[posFieldsToCheck[configField][0]] + ', ' + record[posFieldsToCheck[configField][1]] + ', ' + config[configField])
			posOk = posOk && record[posFieldsToCheck[configField][0]]*record[posFieldsToCheck[configField][1]] >= config[configField]*record[posFieldsToCheck[configField][1]]
		})

		record.BT_MargineOK__c = mfeeOk && posOk
		cmp.set('v.canPrint', (mfeeOk || config.BT_PermettiStampaMargNegCommissioni__c) && (posOk || config.BT_PermettiStampaMargNegPOS__c));
	},
	
})