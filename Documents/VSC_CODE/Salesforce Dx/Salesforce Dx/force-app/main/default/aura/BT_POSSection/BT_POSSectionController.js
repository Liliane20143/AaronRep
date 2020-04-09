({
	onPosTableChange: function(cmp, evt, hlp) {
		let record = cmp.get('v.record')
		let offer = cmp.get('v.config')
		let isReferral = cmp.get('v.isReferral')
		let qtyFieldsList = ['BT_QtaSmartPos__c', 'BT_QtaSmartPosCassa__c', 
							/*'BT_QtaSmartPosCassaPro__c',*/ 'BT_QtaSmartPosPremium__c', 
							'BT_QtaSmartPosCassaPremium__c', /*'BT_QtaSmartPosCassaProPremium__c',*/
							'BT_QtaPosTradSmart__c', 'BT_QtaPosCordlSmart__c', 
							'BT_QtaPosPortGprsSmart__c', 'BT_QtaMobilePosSmart__c',
							'BT_QtaPosTradPremium__c', 'BT_QtaPosWifiPremium__c',
							'BT_QtaPos3GPremium__c'/*, 'BT_QtaAltro__c'*/];
		let fieldsList = ['BT_CanMensSmartPos__c', 'BT_CanMensSmartPosCassa__c',
							/*'BT_CanMensSmartPosCassaPro__c',*/ 'BT_CanMensSmartPosPremium__c',
							'BT_CanMensSmartPosCassaPremium__c', /*'BT_CanMensSmartPosCassaProPremium__c'*/
							'BT_CanMensPosTradSmart__c', 'BT_CanMensPosCordlSmart__c',
							'BT_CanMensPosPortGprsSmart__c', 'BT_CanMensMobilePosSmart__c',
							'BT_CanMensPosTradPremium__c', 'BT_CanMensPosWifiPremium__c',
							'BT_CanMensPos3GPremium__c'/*, BT_CanMensAltro__c*/
		];

		record['BT_TotaleQPOS__c'] = hlp.computeAggregate(record, qtyFieldsList, false);
		record['BT_TotalePOS__c'] = hlp.computeAggregate(record, qtyFieldsList, false, (i, f, v) => {
			return Number(v) * record[fieldsList[i]];
		});

		if (isReferral) {
			let qtyToCodeField = {
				'BT_QtaSmartPos__c': 'BT_Codice_Smartpos__c',
				'BT_QtaSmartPosCassa__c': 'BT_Codice_SmartposCassa__c',
				'BT_QtaSmartPosPremium__c': 'BT_Codice_SmartposPremium__c',
				'BT_QtaSmartPosCassaPremium__c': 'BT_Codice_SmartposCassaPremium__c',
				'BT_QtaPosTradSmart__c': 'BT_Codice_PosTradSmartPstnEth__c',
				'BT_QtaPosCordlSmart__c': 'BT_Codice_PosCordSmartPstnEth__c', 
				'BT_QtaPosPortGprsSmart__c': 'BT_Codice_PosPortatileGprsSmart__c', 
				'BT_QtaMobilePosSmart__c': 'BT_Codice_MobilePosSmart__c',
				'BT_QtaPosTradPremium__c': 'BT_Codice_PosTradizionalePremium__c',
				'BT_QtaPosWifiPremium__c': 'BT_Codice_PosCordlessWifiPremium__c',
				'BT_QtaPos3GPremium__c': 'BT_Min_PosPortatile3gPremium__c'
			}

			let codesToShow = []
			Object.keys(qtyToCodeField).forEach(qtyField => {
				if (record[qtyField] > 0) {
					codesToShow.push(offer[qtyToCodeField[qtyField]]) 
				}
			})
			record['BT_CodiciPOS__c'] = codesToShow.join(', ')
		}

		cmp.set('v.record', record)
	},
})