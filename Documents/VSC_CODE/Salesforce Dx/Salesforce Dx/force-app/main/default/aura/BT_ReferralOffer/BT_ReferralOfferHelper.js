({
	populateFromOffer: function(cmp, hlp, offer, record, mode) {
		let fieldMapToTransfer = {
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
			'BT_JCBAcq__c': 'BT_Min_asian__c',
			'BT_CodOfferta__c': 'BT_CodiceOfferta__c',
			'BT_NomeOfferta__c': 'BT_NomeOfferta__c',
			'BT_DescrizioneOfferta__c': 'BT_DescrizioneOfferta__c',
			'BT_DescrizioneProfiloPremium__c': 'BT_DescrizioneProfiloPremium__c',
			'BT_DescrizioneProfiloSmart__c': 'BT_DescrizioneProfiloSmart__c',
			'BT_Eccezioni__c': 'BT_Eccezioni__c',
			'BT_PromozioniCommissioni__c': 'BT_PromozioniCommissioni__c',
			'BT_PromozioniPOS__c': 'BT_PromozioniPOS__c',
			'BT_Note__c': 'BT_Note__c',
			'BT_UPIAcq__c': 'BT_Min_asian__c',
			'BT_PagobancomatAcq__c': 'BT_Min_pb__c',
			'BT_MaestroCommercialAcqEEA__c': 'BT_Min_commEEA__c',
			'BT_MaestroCommercialAcq__c': 'BT_Min_comm__c',
			'BT_MaestroConsumerDebitAcqEEA__c': 'BT_Min_cdpEEA__c',
			'BT_MaestroConsumerDebitAcq__c': 'BT_Min_cdp__c',
			'BT_MaestroConsumerPrepaidAcqEEA__c': 'BT_Min_cdpEEA__c',
			'BT_MaestroConsumerPrepaidAcq__c': 'BT_Min_cdp__c',
			'BT_MastercardCommercialAcqEEA__c': 'BT_Min_commEEA__c',
			'BT_MastercardCommercialAcq__c': 'BT_Min_comm__c',
			'BT_MastercardConsumerCreditAcqEEA__c': 'BT_Min_cdpEEA__c',
			'BT_MastercardConsumerCreditAcq__c': 'BT_Min_cdp__c',
			'BT_MastercardConsumerDebitAcqEEA__c': 'BT_Min_cdpEEA__c',
			'BT_MastercardConsumerDebitAcq__c': 'BT_Min_cdp__c',
			'BT_MastercardConsumerPrepaidAcqEEA__c': 'BT_Min_cdpEEA__c',
			'BT_MastercardConsumerPrepaidAcq__c': 'BT_Min_cdp__c',
			'BT_VPayConsumerDebitAcqEEA__c': 'BT_Min_cdpEEA__c',
			'BT_VPayConsumerDebitAcq__c': 'BT_Min_cdp__c',
			'BT_VPayConsumerPrepaidAcqEEA__c': 'BT_Min_cdpEEA__c',
			'BT_VPayConsumerPrepaidAcq__c': 'BT_Min_cdp__c',
			'BT_VisaCommercialAcqEEA__c': 'BT_Min_commEEA__c',
			'BT_VisaCommercialAcq__c': 'BT_Min_comm__c',
			'BT_VisaConsumerCreditAcqEEA__c': 'BT_Min_cdpEEA__c',
			'BT_VisaConsumerCreditAcq__c': 'BT_Min_cdp__c',
			'BT_VisaConsumerDebitAcqEEA__c': 'BT_Min_cdpEEA__c',
			'BT_VisaConsumerDebitAcq__c': 'BT_Min_cdp__c',
			'BT_VisaConsumerPrepaidAcqEEA__c': 'BT_Min_cdpEEA__c',
			'BT_VisaConsumerPrepaidAcq__c': 'BT_Min_cdp__c'
		}


		Object.keys(fieldMapToTransfer).forEach(recordField => {
			record[recordField] = offer[fieldMapToTransfer[recordField]]
		})
	},

	resetFields: function(cmp, hlp, record) {
		let fieldsToReset = {
			BT_QtaSmartPos__c: null,
			BT_QtaSmartPosCassa__c: null,
			BT_QtaSmartPosPremium__c: null,
			BT_QtaSmartPosCassaPremium__c: null,
			BT_QtaPosTradSmart__c: null,
			BT_QtaPosCordlSmart__c: null,
			BT_QtaPosPortGprsSmart__c: null,
			BT_QtaMobilePosSmart__c: null,
			BT_QtaPosTradPremium__c: null,
			BT_QtaPosWifiPremium__c: null,
			BT_QtaPos3GPremium__c: null,
			BT_TotalePOS__c: null,
			BT_TotaleQPOS__c: null,
			BT_CodiciPOS__c: ' '
		}

		Object.keys(fieldsToReset).forEach(field => {
			record[field] = fieldsToReset[field]
		})
	}
})