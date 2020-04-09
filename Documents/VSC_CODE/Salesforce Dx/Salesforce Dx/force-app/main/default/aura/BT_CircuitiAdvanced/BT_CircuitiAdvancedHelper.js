({
	computeAggregate : function(record, fieldsList, isPercent) {
		let sum = 0;
		for (let fieldIdx in fieldsList) {
			let field = fieldsList[fieldIdx];
			sum += Number(record[field]);
		}
		return isPercent ? (sum * 100).toFixed(2) : sum;
	},

	propagateToFields : function(record, fieldsList, value) {
		for (let fieldIdx in fieldsList) {
			record[fieldsList[fieldIdx]] = value;
		}
	},

	computeTotalExtraEA : function(cmp, evt, hlp) {
		let record = cmp.get('v.record');
		let extraEEAFieldsList = ['BT_VisaConsumerCreditEEA__c', 'BT_VisaConsumerPrepaidEEA__c', 
								  'BT_VisaConsumerDebitEEA__c', 'BT_VPayConsumerDebitEEA__c', 
								  'BT_VPayConsumerPrepaidEEA__c', 'BT_MastercardConsumerCreditEEA__c', 
								  'BT_MastercardConsumerDebitEEA__c', 'BT_MastercardConsumerPrepaidEEA__c',
								  'BT_MaestroConsumerDebitEEA__c', 'BT_MaestroConsumerPrepaidEEA__c',
								  'BT_VisaCommercialEEA__c', 'BT_MaestroCommercialEEA__c', 'BT_MastercardCommercialEEA__c'];
		cmp.set('v.sumPercentEEA', hlp.computeAggregate(record, extraEEAFieldsList, false));
	},

	checkIfCanCompute: function(cmp, evt, hlp) {
		let total = Number(cmp.get('v.sumPercentBancomat')) + Number(cmp.get('v.sumPercentAsian')) + Number(cmp.get('v.sumPercentCommExtraUE')) + Number(cmp.get('v.sumPercentComm')) + Number(cmp.get('v.sumPercentCDPExtraUE')) + Number(cmp.get('v.sumPercentCDP'))
		console.log(total);
		cmp.set('v.canCompute', total === 100)
	},

	propVisaMC: function(cmp, record, value, hlp) {
		let fieldsList = ['BT_VisaConsumerCreditAcq__c', 'BT_VisaConsumerPrepaidAcq__c', 'BT_VisaConsumerDebitAcq__c', 'BT_VisaCommercialAcq__c', 'BT_VPayConsumerDebitAcq__c', 'BT_VPayConsumerPrepaidAcq__c', 
							'BT_MastercardConsumerCreditAcq__c', 'BT_MastercardConsumerPrepaidAcq__c', 'BT_MastercardConsumerDebitAcq__c', 'BT_MastercardCommercialAcq__c', 'BT_MaestroConsumerDebitAcq__c', 'BT_MaestroConsumerPrepaidAcq__c', 'BT_MaestroCommercialAcq__c']

		hlp.propagateToFields(record, fieldsList, value)
	}
})