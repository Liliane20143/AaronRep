({
	doInit : function(cmp, evt, hlp) {
		const api = hlp.buildApi(cmp);

		api('loadRecord', {})
			.then(returnObject => {
				hlp.scalePercentFields(returnObject, false);
				console.log(JSON.stringify(returnObject));
				cmp.set('v.record', returnObject);
				cmp.set('v.showSpinner', false);
			})
			.catch(error => {
				console.log(error);
				hlp.notifyError(error);
				cmp.set('v.showSpinner', false);
			})
	},

	doSave : function(cmp, evt, hlp) {
		let fieldsToStrip = [
			'BT_Enable_MobilePosSmart__c',
			'BT_Enable_PosCordSmartPstnEth__c',
			'BT_Enable_PosCordlessWifiPremium__c',
			'BT_Enable_PosPortatile3gPremium__c',
			'BT_Enable_PosPortatileGprsSmart__c',
			'BT_Enable_PosTradSmartPstnEth__c',
			'BT_Enable_PosTradizionalePremium__c',
			'BT_Enable_SmartposCassaPremium__c',
			'BT_Enable_SmartposCassa__c',
			'BT_Enable_SmartposPremium__c',
			'BT_Enable_Smartpos__c'
		]

		const api = hlp.buildApi(cmp);
		
		let recordToSave = Object.assign({}, cmp.get('v.record'))
		fieldsToStrip.forEach(field => delete recordToSave[field])

		hlp.scalePercentFields(recordToSave, true);
		cmp.set('v.showSpinner', true);
		api('saveRecord', {'record': recordToSave})
			.then(() => {
				hlp.notifySuccess($A.get('$Label.c.BT_SalvataggioRiuscito'));
				cmp.set('v.showSpinner', false);
			})
			.catch(error => {
				console.log(error);
				hlp.notifyError(error);
				cmp.set('v.showSpinner', false);
			})
	},

	onRecordChange : function(cmp, evt, hlp) {
		let record = cmp.get('v.record');
		let hasError = $A.util.isEmpty(record.BT_MarginalitaDesiderataTOTPreventivo__c) || record.BT_MarginalitaDesiderataTOTPreventivo__c > 0.2 || record.BT_MarginalitaDesiderataTOTPreventivo__c < 0;
		let oldRecord = evt.getParam('oldValue');
		/*if ((oldRecord.BT_PermettiStampaMargNegCommissioni__c !== record.BT_PermettiStampaMargNegCommissioni__c) || 
			(oldRecord.BT_PermettiStampaMargNegPOS__c !== record.BT_PermettiStampaMargNegPOS__c)) {
			
			cmp.set('v.record', record)
		}*/
		cmp.set('v.hasMarginalitaError', hasError)
		cmp.set('v.saveButtonDisabled',  hasError);
	},

	onPermettiMargNegChange: function(cmp, evt, hlp) {
		let record = cmp.get('v.record')
		record.BT_PermettiInvioMailDeroga__c = !(record.BT_PermettiStampaMargNegCommissioni__c || record.BT_PermettiStampaMargNegPOS__c)
		cmp.set('v.record', record)
	}
})