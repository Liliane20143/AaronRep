({
	computeStartSimulationState : function(cmp, evt, hlp) {
		let annualParam = cmp.get('v.annualParam');
		let geoParam = cmp.get('v.geoParam');
		let record = cmp.get('v.record');

		let disabled = (annualParam === $A.get('$Label.c.BT_NegoziatoAnnuo') && ($A.util.isEmpty(record.BT_NegoziatoAnnuo__c) || record.BT_NegoziatoAnnuo__c == 0)) || 
			(annualParam === $A.get('$Label.c.BT_FatturatoAnnuo') && ($A.util.isEmpty(record.BT_FatturatoAnnuo__c) || record.BT_FatturatoAnnuo__c == 0)) ||
			($A.util.isEmpty(record.BT_MacroCatMerceologica__c) || record.BT_MacroCatMerceologica__c === '0') ||
			($A.util.isEmpty(record.BT_CatMerceologica__c) || record.BT_CatMerceologica__c === '0') ||
			(geoParam === $A.get('$Label.c.BT_CAP') && ($A.util.isEmpty(record.BT_CAP__c) || record.BT_CAP__c == '00000' || $A.util.isEmpty(record.BT_CAP__c.match(/^[0-9]{5}$/)))) ||
			(geoParam === $A.get('$Label.c.BT_Provincia') && ($A.util.isEmpty(record.BT_Provincia__c) || record.BT_Provincia__c === '0'));

		cmp.set('v.startSimulationDisabled', disabled);

	}
})