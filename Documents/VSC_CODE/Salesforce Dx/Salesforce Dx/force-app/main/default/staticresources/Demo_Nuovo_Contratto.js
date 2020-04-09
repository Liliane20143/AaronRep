rule Section_Referente_PV {
	agenda-group:'Punto_Vendita_9';
	when{
		f1 : FieldProps f1.objectsData.unbind.Referente_PV !='';
	}
	then{
		var sectionsToUpdate=[];
		sectionsToUpdate.push({step:"Punto_Vendita_9",sectionName:"REFERENTE_TECNICO_PUNTO_VENDITA",sectionIndex:"4",property:"hidden",value:false});
		emit("updateSections",sectionsToUpdate);
	}
}




rule PV_Show_ReferenteTecnicoSection {
	agenda-group:'Punto_Vendita_9';
	when{
		f1 : FieldProps f1.objectsData.unbind.PV_Contacts =='Referente_Tecnico';
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Punto_Vendita_9.Referente_TecnicoPV_FirstName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Referente_TecnicoPV_FirstName",property:"required",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Referente_TecnicoPV_FirstName",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Punto_Vendita_9.Referente_TecnicoPV_LastName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Referente_TecnicoPV_LastName",property:"required",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Referente_TecnicoPV_LastName",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Punto_Vendita_9.Referente_TecnicoPV_Email",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Referente_TecnicoPV_Email",property:"required",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Referente_TecnicoPV_Email",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Punto_Vendita_9.Referente_TecnicoPV_MobilePhone",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Referente_TecnicoPV_MobilePhone",property:"required",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Referente_TecnicoPV_MobilePhone",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
	}
}

rule PV_Show_ResponsabileAmministrativoSection {
	agenda-group:'Punto_Vendita_9';
	when{
		f1 : FieldProps f1.objectsData.unbind.PV_Contacts =='Responsabile_Amministrativo';
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_Amm_PV_FirstName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_Amm_PV_FirstName",property:"required",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_Amm_PV_FirstName",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_Amm_PV_LastName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_Amm_PV_LastName",property:"required",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_Amm_PV_LastName",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_Amm_PV_Email",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_Amm_PV_Email",property:"required",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_Amm_PV_Email",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_Amm_PV_MobilePhone",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_Amm_PV_MobilePhone",property:"required",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_Amm_PV_MobilePhone",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
	}
}

rule PV_Show_ResponsabilePVSection {
	agenda-group:'Punto_Vendita_9';
	when{
		f1 : FieldProps f1.objectsData.unbind.PV_Contacts =='Referente_Punto_Vendita';
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_PV_FirstName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_PV_FirstName",property:"required",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_PV_FirstName",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_PV_LastName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_PV_LastName",property:"required",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_PV_LastName",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_PV_Email",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_PV_Email",property:"required",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_PV_Email",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_PV_MobilePhone",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_PV_MobilePhone",property:"required",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_PV_MobilePhone",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
	}
}

rule Show_VATNotPresent {
	agenda-group:'Identifica_societa_1';
	when{
		f1 : FieldProps f1.objectsData.unbind.VAT_notPresent =='true';
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_DescriptionVATNotPresent__c",property:"hidden",value:false});
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_DescriptionVATNotPresent__c",property:"required",value:false});
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_DescriptionVATNotPresent__c",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Dati_societa_5.merchant_NE__VAT__c",property:"hidden",value:true});
		metadataToUpdate.push({path:"Dati_societa_5.merchant_NE__VAT__c",property:"required",value:false});
		metadataToUpdate.push({path:"Dati_societa_5.merchant_NE__VAT__c",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
	}
}

rule Show_VATNotPresent {
	agenda-group:'Identifica_societa_1';
	when{
		f1 : FieldProps f1.objectsData.unbind.VAT_notPresent =='false';
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_DescriptionVATNotPresent__c",property:"hidden",value:true});
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_DescriptionVATNotPresent__c",property:"required",value:false});
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_DescriptionVATNotPresent__c",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Dati_societa_5.merchant_NE__VAT__c",property:"hidden",value:false});
		metadataToUpdate.push({path:"Dati_societa_5.merchant_NE__VAT__c",property:"required",value:false});
		metadataToUpdate.push({path:"Dati_societa_5.merchant_NE__VAT__c",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
	}
}

rule NewOrderSi {
	agenda-group:'Carica_documenti_11';
	when{
		f1 : FieldProps f1.objectsData.unbind.NewOrderSelected =='Si';
	}
	then{
		var dataToUpdate=[];
		dataToUpdate.push({path:"unbind.NewOrderSelected",newValue:""});
		emit("updateData",dataToUpdate);
		var methodArguments= {};
		methodArguments['stepToGo'] = 1;
		emit("goToStep",methodArguments);
	}
}

rule NewOrderNo {
	agenda-group:'Carica_documenti_11';
	when{
		f1 : FieldProps f1.objectsData.unbind.NewOrderSelected =='No';
	}
	then{
		var dataToUpdate=[];
		dataToUpdate.push({path:"unbind.NewOrderSelected",newValue:""});
		emit("updateData",dataToUpdate);
		var methodArguments= {};
		methodArguments['stepToGo'] = 10;
		emit("goToStep",methodArguments);
	}
}

rule ReasonNonTitolariEffettiviShow {
	agenda-group:'Dati_societa_5';
	when{
		f1 : FieldProps f1.objectsData.merchant.OB_Beneficial_Owner_Existence__c ==false;
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_Reason_Absence_Owner__c",property:"hidden",value:false});
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_Reason_Absence_Owner__c",property:"required",value:false});
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_Reason_Absence_Owner__c",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
	}
}

rule ReasonNonTitolariEffettiviHide {
	agenda-group:'Dati_societa_5';
	when{
		f1 : FieldProps f1.objectsData.merchant.OB_Beneficial_Owner_Existence__c ==true;
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_Reason_Absence_Owner__c",property:"hidden",value:true});
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_Reason_Absence_Owner__c",property:"required",value:false});
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_Reason_Absence_Owner__c",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
	}
}

rule ShowNoProfitRecipient {
	agenda-group:'Dati_societa_5';
	when{
		f1 : FieldProps f1.objectsData.merchant.OB_Legal_Form_Code__c =='55';
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_No_Profit_Recipient_Class__c",property:"hidden",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
	}
}
rule HideNoProfitRecipient {
	agenda-group:'Dati_societa_5';
	when{
		f1 : FieldProps f1.objectsData.merchant.OB_Legal_Form_Code__c !='55';
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_No_Profit_Recipient_Class__c",property:"hidden",value:true});
		emit("updateInptCmpsMetadata",metadataToUpdate);
	}
}

rule ShowRecipientDescription {
	agenda-group:'Dati_societa_5';
	when{
		f1 : FieldProps f1.objectsData.merchant.OB_No_Profit_Recipient_Class__c =='Altro';
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_No_Profit_Recipient_Other__c",property:"hidden",value:false});
		
		emit("updateInptCmpsMetadata",metadataToUpdate);
	}
}
rule HideRecipientDescription{
	agenda-group:'Dati_societa_5';
	when{
		f1 : FieldProps f1.objectsData.merchant.OB_No_Profit_Recipient_Class__c !='Altro';
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_No_Profit_Recipient_Other__c",property:"hidden",value:true});

		emit("updateInptCmpsMetadata",metadataToUpdate);
	}
}
