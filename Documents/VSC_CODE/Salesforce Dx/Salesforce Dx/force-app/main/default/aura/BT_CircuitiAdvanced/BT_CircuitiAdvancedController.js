({
	doInit : function(cmp, evt, hlp) {
		let config = cmp.get('v.config')
		cmp.set('v.record.BT_TipologiaCommissione__c', 'COMMISSIONE DIFFERENZIATA')
		cmp.set('v.commVisaMC', config.mfeevisamc)
	},

	propagateVisaMC : function(cmp, evt, hlp) {
		let record = cmp.get('v.record')
		hlp.propVisaMC(cmp, record, evt.getSource().get("v.value"), hlp)
	},

	onTipologiaCommissioneChange: function(cmp, evt, hlp) {
		let record = cmp.get('v.record')
		if (record.BT_TipologiaCommissione__c === 'COMMISSIONE UNICA') {
			hlp.propVisaMC(cmp, record, cmp.get('v.commVisaMC'), hlp)
			let extraEEAFields = ['BT_VisaConsumerCreditAcqEEA__c', 'BT_VisaConsumerPrepaidAcqEEA__c', 
							'BT_VisaConsumerDebitAcqEEA__c', 'BT_VPayConsumerDebitAcqEEA__c', 
							'BT_VPayConsumerPrepaidAcqEEA__c', 'BT_MastercardConsumerCreditAcqEEA__c',
							'BT_MastercardConsumerDebitAcqEEA__c', 'BT_MastercardConsumerPrepaidAcqEEA__c',
							'BT_MaestroConsumerDebitAcqEEA__c', 'BT_MaestroConsumerPrepaidAcqEEA__c',
							'BT_VisaCommercialAcqEEA__c', 'BT_MaestroCommercialAcqEEA__c', 'BT_MastercardCommercialAcqEEA__c']

			hlp.propagateToFields(record, extraEEAFields, 0)		
			cmp.set('v.record', record)
		} 
	},

	onPosQtyChange: function(cmp, evt, hlp) {
		let record = cmp.get('v.record')
		let fieldsList = ['BT_QtaSmartPos__c', 'BT_QtaSmartPosCassa__c', 
						  'BT_QtaSmartPosCassaPro__c', 'BT_QtaSmartPosPremium__c', 
						  'BT_QtaSmartPosCassaPremium__c', 'BT_QtaSmartPosCassaProPremium__c',
						  'BT_QtaPosTradSmart__c', 'BT_QtaPosCordlSmart__c', 
						  'BT_QtaPosPortGprsSmart__c', 'BT_QtaMobilePosSmart__c',
						  'BT_QtaPosTradPremium__c', 'BT_QtaPosWifiPremium__c',
						  'BT_QtaPos3GPremium__c', 'BT_QtaAltro__c']
		cmp.set('v.totQty', hlp.computeAggregate(record, fieldsList, false))
	},

	onInputCDPChange: function(cmp, evt, hlp) {
		let record = cmp.get('v.record')
		let cdpExtraEUFields = ['BT_VisaConsumerCreditEEA__c', 'BT_VisaConsumerPrepaidEEA__c', 
								'BT_VisaConsumerDebitEEA__c', 'BT_VPayConsumerDebitEEA__c', 
								'BT_VPayConsumerPrepaidEEA__c', 'BT_MastercardConsumerCreditEEA__c',
								'BT_MastercardConsumerDebitEEA__c', 'BT_MastercardConsumerPrepaidEEA__c',
								'BT_MaestroConsumerDebitEEA__c', 'BT_MaestroConsumerPrepaidEEA__c']
		let fieldsList = ['BT_VisaConsumerCredit__c', 
						  'BT_VisaConsumerPrepaid__c', 
						  'BT_VisaConsumerDebit__c', 
						  'BT_VPayConsumerDebit__c', , 
						  'BT_VPayConsumerPrepaid__c',  
						  'BT_MastercardConsumerCredit__c',  
						  'BT_MastercardConsumerDebit__c', 
						  'BT_MastercardConsumerPrepaid__c', 
						  'BT_MaestroConsumerDebit__c', 
						  'BT_MaestroConsumerPrepaid__c' ]
		cmp.set('v.sumPercentCDP', hlp.computeAggregate(record, fieldsList, true))
		cmp.set('v.sumPercentCDPExtraUE', hlp.computeAggregate(record, cdpExtraEUFields, true))
		hlp.computeTotalExtraEA(cmp, evt, hlp)
		hlp.checkIfCanCompute(cmp, evt, hlp)

	},

	onInputCommChange: function(cmp, evt, hlp) {
		let record = cmp.get('v.record')
		let commExtraEUFields = ['BT_VisaCommercialEEA__c', 'BT_MaestroCommercialEEA__c', 'BT_MastercardCommercialEEA__c']
		let fieldsList = ['BT_VisaCommercial__c',
						  'BT_MaestroCommercial__c',  
						  'BT_MastercardCommercial__c']
		cmp.set('v.sumPercentComm', hlp.computeAggregate(record, fieldsList, true))
		cmp.set('v.sumPercentCommExtraUE', hlp.computeAggregate(record, commExtraEUFields, true))
		hlp.computeTotalExtraEA(cmp, evt, hlp)
		hlp.checkIfCanCompute(cmp, evt, hlp)

	},

	onInputBancomatChange: function(cmp, evt, hlp) {
		let record = cmp.get('v.record')
		cmp.set('v.sumPercentBancomat', hlp.computeAggregate(record, ['BT_Pagobancomat__c'], true))
		hlp.checkIfCanCompute(cmp, evt, hlp)

	},

	onInputAsianChange: function(cmp, evt, hlp) {
		let record = cmp.get('v.record')
		let fieldsList = ['BT_JCB__c', 'BT_UPI__c']
		cmp.set('v.sumPercentAsian', hlp.computeAggregate(record, fieldsList, true))
		hlp.checkIfCanCompute(cmp, evt, hlp)
	},

	onRecordChange: function(cmp, evt, hlp) {
		let recordChangedEvent = cmp.getEvent('recordChangedEvent')
		recordChangedEvent.fire()
	}
})