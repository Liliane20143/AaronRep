({
	onRecordChange: function(cmp, evt, hlp) {
		let recordChangedEvent = cmp.getEvent('recordChangedEvent');
		recordChangedEvent.fire();
	},

	onSliderChange: function(cmp, evt, hlp) {
		let record = cmp.get('v.record');
		let sliderToFieldsMap = {
			'cdp_eu':    ['BT_VisaConsumerCreditAcq__c', 'BT_VisaConsumerPrepaidAcq__c', 
					      'BT_VisaConsumerDebitAcq__c', 'BT_VPayConsumerDebitAcq__c', 
					      'BT_VPayConsumerPrepaidAcq__c', 'BT_MastercardConsumerCreditAcq__c',
					      'BT_MastercardConsumerDebitAcq__c', 'BT_MastercardConsumerPrepaidAcq__c',
					      'BT_MaestroConsumerDebitAcq__c', 'BT_MaestroConsumerPrepaidAcq__c'],
			'comm_eu':   ['BT_VisaCommercialAcq__c', 'BT_MaestroCommercialAcq__c', 'BT_MastercardCommercialAcq__c'],
			'cdp_noeu':  ['BT_VisaConsumerCreditAcqEEA__c', 'BT_VisaConsumerPrepaidAcqEEA__c',
						  'BT_VisaConsumerDebitAcqEEA__c', 'BT_VPayConsumerDebitAcqEEA__c',
						  'BT_VPayConsumerPrepaidAcqEEA__c', 'BT_MastercardConsumerCreditAcqEEA__c',
						  'BT_MastercardConsumerDebitAcqEEA__c', 'BT_MastercardConsumerPrepaidAcqEEA__c',
						  'BT_MaestroConsumerDebitAcqEEA__c', 'BT_MaestroConsumerPrepaidAcqEEA__c'],
			'comm_noeu': ['BT_VisaCommercialAcqEEA__c', 'BT_MaestroCommercialAcqEEA__c', 'BT_MastercardCommercialAcqEEA__c'],
			'pb': 	   	 ['BT_PagobancomatAcq__c'],
			'asian': 	 ['BT_JCBAcq__c', 'BT_UPIAcq__c']
		};

		let fields = sliderToFieldsMap[evt.getParam("name")];
		if (!$A.util.isEmpty(fields)) {
			for (let fieldIdx in fields) {
				record[fields[fieldIdx]] = Number(evt.getParam("value")).toFixed(4);
			}
			cmp.set('v.record', record);
		}
	}
})