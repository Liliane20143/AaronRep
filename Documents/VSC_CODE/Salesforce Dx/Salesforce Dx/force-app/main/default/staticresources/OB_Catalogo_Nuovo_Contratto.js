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
		methodArguments['stepToGo'] = 9;
		emit("goToStep",methodArguments);
	}
}


rule ShowNoProfitRecipient {
	agenda-group:'Dati_societa_5';
	when{
		f1 : FieldProps f1.objectsData.merchant.OB_Legal_Form_Code__c =='ORG_NO_PROFIT';
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_No_Profit_Recipient_Class__c",property:"hidden",value:false});
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_No_Profit_Recipient_Class__c",property:"required",value:true});
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_No_Profit_Recipient_Class__c",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_No_Profit_Class__c",property:"hidden",value:false});
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_No_Profit_Class__c",property:"required",value:true});
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_No_Profit_Class__c",property:"disabled",value:false});
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
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_No_Profit_Recipient_Other__c",property:"required",value:true});
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_No_Profit_Recipient_Other__c",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
	}
}

rule HideNoProfitRecipient {
	agenda-group:'Dati_societa_5';
	when{
		f1 : FieldProps f1.objectsData.merchant.OB_Legal_Form_Code__c !='ORG_NO_PROFIT';
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_No_Profit_Recipient_Class__c",property:"hidden",value:true});
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_No_Profit_Recipient_Class__c",property:"required",value:false});
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_No_Profit_Recipient_Class__c",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_No_Profit_Recipient_Other__c",property:"hidden",value:true});
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_No_Profit_Recipient_Other__c",property:"required",value:false});
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_No_Profit_Recipient_Other__c",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_No_Profit_Class__c",property:"hidden",value:true});
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_No_Profit_Class__c",property:"required",value:false});
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_No_Profit_Class__c",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var dataToUpdate=[];
		dataToUpdate.push({path:"merchant.OB_No_Profit_Recipient_Class__c",newValue:""});
		dataToUpdate.push({path:"merchant.OB_No_Profit_Class__c",newValue:""});
		dataToUpdate.push({path:"merchant.OB_No_Profit_Recipient_Other__c",newValue:""});
		emit("updateData",dataToUpdate);
	}
}

rule Hide1 {
	agenda-group:'Titolare_effettivo_9';
	when{
		f1 : FieldProps f1.objectsData.unbind.clean1 =='hide';
	}
	then{
		var sectionsToUpdate=[];
		sectionsToUpdate.push({step:"Titolare_effettivo_9",sectionName:"Titolare_1_-_Dati_Anagrafici",sectionIndex:"1",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
		var sectionsToUpdate=[];
		sectionsToUpdate.push({step:"Titolare_effettivo_9",sectionName:"Titolare_1_-_Indirizzo_di_residenza",sectionIndex:"2",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
	}
}

rule Hide2 {
	agenda-group:'Titolare_effettivo_9';
	when{
		f1 : FieldProps f1.objectsData.unbind.clean2 =='hide';
	}
	then{
		var sectionsToUpdate=[];
		sectionsToUpdate.push({step:"Titolare_effettivo_9",sectionName:"Titolare_2_-_Dati_Anagrafici",sectionIndex:"3",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
		var sectionsToUpdate=[];
		sectionsToUpdate.push({step:"Titolare_effettivo_9",sectionName:"Titolare_2_-_Indirizzo_di_residenza",sectionIndex:"4",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
	}
}

rule Hide3 {
	agenda-group:'Titolare_effettivo_9';
	when{
		f1 : FieldProps f1.objectsData.unbind.clean3 =='hide';
	}
	then{
		var sectionsToUpdate=[];
		sectionsToUpdate.push({step:"Titolare_effettivo_9",sectionName:"Titolare_3_-_Dati_Anagrafici",sectionIndex:"5",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
		var sectionsToUpdate=[];
		sectionsToUpdate.push({step:"Titolare_effettivo_9",sectionName:"Titolare_3_-_Indirizzo_di_residenza",sectionIndex:"6",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
	}
}

rule Hide4 {
	agenda-group:'Titolare_effettivo_9';
	when{
		f1 : FieldProps f1.objectsData.unbind.clean4 =='hide';
	}
	then{
		var sectionsToUpdate=[];
		sectionsToUpdate.push({step:"Titolare_effettivo_9",sectionName:"Titolare_4_-_Dati_Anagrafici",sectionIndex:"7",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
		var sectionsToUpdate=[];
		sectionsToUpdate.push({step:"Titolare_effettivo_9",sectionName:"Titolare_4_-_Indirizzo_di_residenza",sectionIndex:"8",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
	}
}

rule Hide5 {
	agenda-group:'Titolare_effettivo_9';
	when{
		f1 : FieldProps f1.objectsData.unbind.clean5 =='hide';
	}
	then{
		var sectionsToUpdate=[];
		sectionsToUpdate.push({step:"Titolare_effettivo_9",sectionName:"Titolare_5_-_Dati_Anagrafici",sectionIndex:"9",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
		var sectionsToUpdate=[];
		sectionsToUpdate.push({step:"Titolare_effettivo_9",sectionName:"Titolare_5_-_Indirizzo_di_residenza",sectionIndex:"10",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
	}
}

rule Hide6 {
	agenda-group:'Titolare_effettivo_9';
	when{
		f1 : FieldProps f1.objectsData.unbind.clean6 =='hide';
	}
	then{
		var sectionsToUpdate=[];
		sectionsToUpdate.push({step:"Titolare_effettivo_9",sectionName:"Titolare_6_-_Dati_Anagrafici",sectionIndex:"11",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
		var sectionsToUpdate=[];
		sectionsToUpdate.push({step:"Titolare_effettivo_9",sectionName:"Titolare_6_-_Indirizzo_di_residenza",sectionIndex:"12",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
	}
}





rule Show1 {
	agenda-group:'Titolare_effettivo_9';
	when{
		f1 : FieldProps f1.objectsData.unbind.clean1 =='show';
	}
	then{
		var sectionsToUpdate=[];
		sectionsToUpdate.push({step:"Titolare_effettivo_9",sectionName:"Titolare_1_-_Dati_Anagrafici",sectionIndex:"1",property:"hidden",value:false});
		emit("updateSections",sectionsToUpdate);
		var sectionsToUpdate=[];
		sectionsToUpdate.push({step:"Titolare_effettivo_9",sectionName:"Titolare_1_-_Indirizzo_di_residenza",sectionIndex:"2",property:"hidden",value:false});
		emit("updateSections",sectionsToUpdate);
	}
}

rule Show2 {
	agenda-group:'Titolare_effettivo_9';
	when{
		f1 : FieldProps f1.objectsData.unbind.clean2 =='show';
	}
	then{
		var sectionsToUpdate=[];
		sectionsToUpdate.push({step:"Titolare_effettivo_9",sectionName:"Titolare_2_-_Dati_Anagrafici",sectionIndex:"3",property:"hidden",value:false});
		emit("updateSections",sectionsToUpdate);
		var sectionsToUpdate=[];
		sectionsToUpdate.push({step:"Titolare_effettivo_9",sectionName:"Titolare_2_-_Indirizzo_di_residenza",sectionIndex:"4",property:"hidden",value:false});
		emit("updateSections",sectionsToUpdate);
	}
}

rule Show3 {
	agenda-group:'Titolare_effettivo_9';
	when{
		f1 : FieldProps f1.objectsData.unbind.clean3 =='show';
	}
	then{
		var sectionsToUpdate=[];
		sectionsToUpdate.push({step:"Titolare_effettivo_9",sectionName:"Titolare_3_-_Dati_Anagrafici",sectionIndex:"5",property:"hidden",value:false});
		emit("updateSections",sectionsToUpdate);
		var sectionsToUpdate=[];
		sectionsToUpdate.push({step:"Titolare_effettivo_9",sectionName:"Titolare_3_-_Indirizzo_di_residenza",sectionIndex:"6",property:"hidden",value:false});
		emit("updateSections",sectionsToUpdate);
	}
}

rule Show4 {
	agenda-group:'Titolare_effettivo_9';
	when{
		f1 : FieldProps f1.objectsData.unbind.clean4 =='show';
	}
	then{
		var sectionsToUpdate=[];
		sectionsToUpdate.push({step:"Titolare_effettivo_9",sectionName:"Titolare_4_-_Dati_Anagrafici",sectionIndex:"7",property:"hidden",value:false});
		emit("updateSections",sectionsToUpdate);
		var sectionsToUpdate=[];
		sectionsToUpdate.push({step:"Titolare_effettivo_9",sectionName:"Titolare_4_-_Indirizzo_di_residenza",sectionIndex:"8",property:"hidden",value:false});
		emit("updateSections",sectionsToUpdate);
	}
}


rule Show5 {
	agenda-group:'Titolare_effettivo_9';
	when{
		f1 : FieldProps f1.objectsData.unbind.clean5 =='show';
	}
	then{
		var sectionsToUpdate=[];
		sectionsToUpdate.push({step:"Titolare_effettivo_9",sectionName:"Titolare_5_-_Dati_Anagrafici",sectionIndex:"9",property:"hidden",value:false});
		emit("updateSections",sectionsToUpdate);
		var sectionsToUpdate=[];
		sectionsToUpdate.push({step:"Titolare_effettivo_9",sectionName:"Titolare_5_-_Indirizzo_di_residenza",sectionIndex:"10",property:"hidden",value:false});
		emit("updateSections",sectionsToUpdate);
	}
}

rule Show6 {
	agenda-group:'Titolare_effettivo_9';
	when{
		f1 : FieldProps f1.objectsData.unbind.clean6 =='show';
	}
	then{
		var sectionsToUpdate=[];
		sectionsToUpdate.push({step:"Titolare_effettivo_9",sectionName:"Titolare_6_-_Dati_Anagrafici",sectionIndex:"11",property:"hidden",value:false});
		emit("updateSections",sectionsToUpdate);
		var sectionsToUpdate=[];
		sectionsToUpdate.push({step:"Titolare_effettivo_9",sectionName:"Titolare_6_-_Indirizzo_di_residenza",sectionIndex:"12",property:"hidden",value:false});
		emit("updateSections",sectionsToUpdate);
	}
}

rule makeYearCompanyReadOnly {
	agenda-group:'Identifica_societa_1';
	when{
		f1 : FieldProps f1.objectsData.merchant.OB_Year_constitution_company__c >0;

	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Dati_societa_5.unbind_yearOfConstitutionCompany",property:"hidden",value:false});
		metadataToUpdate.push({path:"Dati_societa_5.unbind_yearOfConstitutionCompany",property:"required",value:false});
		metadataToUpdate.push({path:"Dati_societa_5.unbind_yearOfConstitutionCompany",property:"disabled",value:true});
		emit("updateInptCmpsMetadata",metadataToUpdate);
	}
}

rule ShowereferenteTecnicoPv {
	agenda-group:'Punto_Vendita_9';
	when{
		f1 : FieldProps f1.objectsData.unbind.DisableInputReferenteTecnico !='DisableInputReferenteTecnico';
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Punto_Vendita_9.Referente_TecnicoPV_FirstName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Referente_TecnicoPV_FirstName",property:"required",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Referente_TecnicoPV_FirstName",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Punto_Vendita_9.Referente_TecnicoPV_MobilePhone",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Referente_TecnicoPV_MobilePhone",property:"required",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Referente_TecnicoPV_MobilePhone",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Punto_Vendita_9.Referente_TecnicoPV_Email",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Referente_TecnicoPV_Email",property:"required",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Referente_TecnicoPV_Email",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Punto_Vendita_9.Referente_TecnicoPV_LastName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Referente_TecnicoPV_LastName",property:"required",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Referente_TecnicoPV_LastName",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
	}

}

rule ResponsabilePuntoVendita {
	agenda-group:'Punto_Vendita_9';
	when{
		f1 : FieldProps f1.objectsData.unbind.DisableInputResponsabilePuntoVendita2!='TEST';
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_PV_FirstName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_PV_FirstName",property:"required",value:true});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_PV_FirstName",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_PV_MobilePhone",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_PV_MobilePhone",property:"required",value:true});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_PV_MobilePhone",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_PV_Email",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_PV_Email",property:"required",value:true});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_PV_Email",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_PV_LastName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_PV_LastName",property:"required",value:true});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_PV_LastName",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
	}
	
}

rule required2 {
	agenda-group:'Titolare_effettivo_9';
	when{
		f1 : FieldProps f1.objectsData.unbind.required2 =='required';
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact2_FirstName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact2_FirstName",property:"required",value:true});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact2_FirstName",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact2_LastName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact2_LastName",property:"required",value:true});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact2_LastName",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);

		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact2_OB_Sex__c",property:"hidden",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact2_OB_Sex__c",property:"required",value:true});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact2_OB_Sex__c",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
	}
}


rule required3 {
	agenda-group:'Titolare_effettivo_9';
	when{
		f1 : FieldProps f1.objectsData.unbind.required3 =='required';
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact3_FirstName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact3_FirstName",property:"required",value:true});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact3_FirstName",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact3_LastName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact3_LastName",property:"required",value:true});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact3_LastName",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);

		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact3_OB_Sex__c",property:"hidden",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact3_OB_Sex__c",property:"required",value:true});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact3_OB_Sex__c",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
	}
}

rule required4 {
	agenda-group:'Titolare_effettivo_9';
	when{
		f1 : FieldProps f1.objectsData.unbind.required4 =='required';
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact4_FirstName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact4_FirstName",property:"required",value:true});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact4_FirstName",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact4_LastName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact4_LastName",property:"required",value:true});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact4_LastName",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);

		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact4_OB_Sex__c",property:"hidden",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact4_OB_Sex__c",property:"required",value:true});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact4_OB_Sex__c",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
	}
}

rule required5 {
	agenda-group:'Titolare_effettivo_9';
	when{
		f1 : FieldProps f1.objectsData.unbind.required5 =='required';
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact5_FirstName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact5_FirstName",property:"required",value:true});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact5_FirstName",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact5_LastName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact5_LastName",property:"required",value:true});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact5_LastName",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);

		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact5_OB_Sex__c",property:"hidden",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact5_OB_Sex__c",property:"required",value:true});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact5_OB_Sex__c",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
	}
}

rule required6 {
	agenda-group:'Titolare_effettivo_9';
	when{
		f1 : FieldProps f1.objectsData.unbind.required6 =='required';
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact6_FirstName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact6_FirstName",property:"required",value:true});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact6_FirstName",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact6_LastName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact6_LastName",property:"required",value:true});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact6_LastName",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);

		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact6_OB_Sex__c",property:"hidden",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact6_OB_Sex__c",property:"required",value:true});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact6_OB_Sex__c",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
	}
}

rule notrequired2 {
	agenda-group:'Titolare_effettivo_9';
	when{
		f1 : FieldProps f1.objectsData.unbind.required2 =='not_required';
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact2_FirstName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact2_FirstName",property:"required",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact2_FirstName",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact2_LastName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact2_LastName",property:"required",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact2_LastName",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);

		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact2_OB_Sex__c",property:"hidden",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact2_OB_Sex__c",property:"required",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact2_OB_Sex__c",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
	}
}


rule notrequired3 {
	agenda-group:'Titolare_effettivo_9';
	when{
		f1 : FieldProps f1.objectsData.unbind.required3 =='not_required';
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact3_FirstName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact3_FirstName",property:"required",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact3_FirstName",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact3_LastName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact3_LastName",property:"required",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact3_LastName",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);

		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact3_OB_Sex__c",property:"hidden",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact3_OB_Sex__c",property:"required",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact3_OB_Sex__c",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
	}
}

rule notrequired4 {
	agenda-group:'Titolare_effettivo_9';
	when{
		f1 : FieldProps f1.objectsData.unbind.required4 =='not_required';
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact4_FirstName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact4_FirstName",property:"required",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact4_FirstName",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact4_LastName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact4_LastName",property:"required",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact4_LastName",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);

		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact4_OB_Sex__c",property:"hidden",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact4_OB_Sex__c",property:"required",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact4_OB_Sex__c",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
	}
}

rule notrequired5 {
	agenda-group:'Titolare_effettivo_9';
	when{
		f1 : FieldProps f1.objectsData.unbind.required5 =='not_required';
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact5_FirstName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact5_FirstName",property:"required",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact5_FirstName",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact5_LastName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact5_LastName",property:"required",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact5_LastName",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);

		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact5_OB_Sex__c",property:"hidden",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact5_OB_Sex__c",property:"required",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact5_OB_Sex__c",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
	}
}

rule notrequired6 {
	agenda-group:'Titolare_effettivo_9';
	when{
		f1 : FieldProps f1.objectsData.unbind.required6 =='not_required';
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact6_FirstName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact6_FirstName",property:"required",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact6_FirstName",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact6_LastName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact6_LastName",property:"required",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact6_LastName",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact6_OB_Sex__c",property:"hidden",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact6_OB_Sex__c",property:"required",value:false});
		metadataToUpdate.push({path:"Titolare_effettivo_9.contact6_OB_Sex__c",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);		
	}
}

rule automaticShowLegalForm {
	agenda-group:'Identifica_societa_1';
	when{
		f1 : FieldProps f1.objectsData.unbind.OB_Legal_Form__c =='NOPROFIT';
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_No_Profit_Recipient_Class__c",property:"hidden",value:false});
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_No_Profit_Recipient_Class__c",property:"required",value:false});
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_No_Profit_Recipient_Class__c",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_No_Profit_Class__c",property:"hidden",value:false});
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_No_Profit_Class__c",property:"required",value:false});
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_No_Profit_Class__c",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
	}
}


rule automaticShowOtherNoProfit {
	agenda-group:'Identifica_societa_1';
	when{
		f1 : FieldProps f1.objectsData.unbind.OB_No_Profit_Recipient_Class__c =='Altro';
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_No_Profit_Recipient_Other__c",property:"hidden",value:false});
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_No_Profit_Recipient_Other__c",property:"required",value:false});
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_No_Profit_Recipient_Other__c",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
	}
}

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

rule Show_VATNotPresent {
	agenda-group:'Identifica_societa_1';
	when{
		f1 : FieldProps f1.objectsData.unbind.VAT_notPresent =='true';
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_DescriptionVATNotPresent__c",property:"hidden",value:false});
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_DescriptionVATNotPresent__c",property:"required",value:false});
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_DescriptionVATNotPresent__c",property:"disabled",value:true});
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

rule HideRecipientDescription {
	agenda-group:'Dati_societa_5';
	when{
		f1 : FieldProps f1.objectsData.merchant.OB_No_Profit_Recipient_Class__c !='Altro';
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_No_Profit_Recipient_Other__c",property:"hidden",value:true});
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_No_Profit_Recipient_Other__c",property:"required",value:false});
		metadataToUpdate.push({path:"Dati_societa_5.merchant_OB_No_Profit_Recipient_Other__c",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var dataToUpdate=[];
		dataToUpdate.push({path:"merchant.OB_No_Profit_Recipient_Other__c",newValue:""});
		emit("updateData",dataToUpdate);
	}
}

rule ruleStepOffertaNext {
	agenda-group:'Offerta_3';
	when{
		f1 : FieldProps f1.objectsData.unbind.goToNextStepCatalog =='goToNextStepCatalog';
	}
	then{
		var methodArguments= {};
		methodArguments['stepToGo'] = 4;
		emit("goToStep",methodArguments);
	}
}

rule RulegoToNextStepSocieta {
	agenda-group:'Dati_operativi_4';
	when{
		f1 : FieldProps f1.objectsData.unbind.goToNextStepSocieta =='true';
	}
	then{
		var methodArguments= {};
		methodArguments['stepToGo'] = 5;
		emit("goToStep",methodArguments);
	}
}

rule ResponsabileAmministrativo {
	agenda-group:'Punto_Vendita_9';
	when{
		f1 : FieldProps f1.objectsData.unbind.DisableInputResponsabileAmministrativo!='TEST';
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_Amm_PV_FirstName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_Amm_PV_FirstName",property:"required",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_Amm_PV_FirstName",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_Amm_PV_MobilePhone",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_Amm_PV_MobilePhone",property:"required",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_Amm_PV_MobilePhone",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_Amm_PV_Email",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_Amm_PV_Email",property:"required",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_Amm_PV_Email",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_Amm_PV_LastName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_Amm_PV_LastName",property:"required",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_Amm_PV_LastName",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
	}
	
}


rule HiddenOpeningWeeklyInSetup {
	agenda-group:'Punto_Vendita_9';
	when{
		f1 : FieldsData f1.objectsData.pv.OB_Typology__c =='Virtuale';
	}
	then{
		var sectionsToUpdate=[];
		sectionsToUpdate.push({step:"Punto_Vendita_9",sectionName:"Aperture_Settimanali",sectionIndex:"3",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
	}
}

rule CoherencyStartSeasonal {
	agenda-group:'Punto_Vendita_9';
	when{
		f1 : FieldProps f1.objectsData.pv.OB_Start_Seasonal__c =='' &&  f1.objectsData.pv.OB_End_Seasonal__c !='';
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Punto_Vendita_9.pv_OB_Start_Seasonal__c",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.pv_OB_Start_Seasonal__c",property:"required",value:true});
		metadataToUpdate.push({path:"Punto_Vendita_9.pv_OB_Start_Seasonal__c",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
	}
}

rule CoherencyEndSeasonal {
	agenda-group:'Punto_Vendita_9';
	when{
		f1 : FieldProps f1.objectsData.pv.OB_Start_Seasonal__c !='' &&  f1.objectsData.pv.OB_End_Seasonal__c =='';
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Punto_Vendita_9.OB_End_Seasonal__c",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.OB_End_Seasonal__c",property:"required",value:true});
		metadataToUpdate.push({path:"Punto_Vendita_9.OB_End_Seasonal__c",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
	}
}
rule enableFieldsPVCatalog {
	agenda-group:'Identifica_societa_1';
	when{
		f1 : FieldProps f1.objectsData.unbind.isNewPV =='true';
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_PV_LastName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_PV_LastName",property:"required",value:true});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_PV_LastName",property:"disabled",value:false});
        
        
        metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_PV_FirstName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_PV_FirstName",property:"required",value:true});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_PV_FirstName",property:"disabled",value:false});
        
        metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_PV_Email",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_PV_Email",property:"required",value:true});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_PV_Email",property:"disabled",value:false});
        
        metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_PV_MobilePhone",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_PV_MobilePhone",property:"required",value:true});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_PV_MobilePhone",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
	}
}

rule enableFieldsPV_ResponsabileAmministrativo {
	agenda-group:'Identifica_societa_1';
	when{
		f1 : FieldProps f1.objectsData.unbind.isNewPV =='true';
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_Amm_PV_LastName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_Amm_PV_LastName",property:"required",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_Amm_PV_LastName",property:"disabled",value:false});
        
        metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_Amm_PV_FirstName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_Amm_PV_FirstName",property:"required",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_Amm_PV_FirstName",property:"disabled",value:false});
        
        metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_Amm_PV_Email",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_Amm_PV_Email",property:"required",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_Amm_PV_Email",property:"disabled",value:false});
        
        metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_Amm_PV_MobilePhone",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_Amm_PV_MobilePhone",property:"required",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Responsabile_Amm_PV_MobilePhone",property:"disabled",value:false});        
        
		emit("updateInptCmpsMetadata",metadataToUpdate);
	}
}


rule enableFieldsPV_Referente_Tecnico_Punto_Vendita {
	agenda-group:'Identifica_societa_1';
	when{
		f1 : FieldProps f1.objectsData.unbind.isNewPV =='true';
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Punto_Vendita_9.Referente_TecnicoPV_LastName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Referente_TecnicoPV_LastName",property:"required",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Referente_TecnicoPV_LastName",property:"disabled",value:false});
        
        metadataToUpdate.push({path:"Punto_Vendita_9.Referente_TecnicoPV_FirstName",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Referente_TecnicoPV_FirstName",property:"required",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Referente_TecnicoPV_FirstName",property:"disabled",value:false});
        
        
        metadataToUpdate.push({path:"Punto_Vendita_9.Referente_TecnicoPV_Email",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Referente_TecnicoPV_Email",property:"required",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Referente_TecnicoPV_Email",property:"disabled",value:false});
        
        metadataToUpdate.push({path:"Punto_Vendita_9.Referente_TecnicoPV_MobilePhone",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Referente_TecnicoPV_MobilePhone",property:"required",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.Referente_TecnicoPV_MobilePhone",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
	}
}

rule checkValidity_StartSeasonal {
	agenda-group:'Punto_Vendita_9';
	when{
		f1 : FieldProps f1.objectsData.pv.OB_End_Seasonal__c !='' && f1.objectsData.pv.OB_Start_Seasonal__c =='';
	}
	then{
		var metadataToUpdate=[];
		console.log('checkValidity_StartSeasonal has been fired! ');
		metadataToUpdate.push({path:"Punto_Vendita_9.OB_Start_Seasonal__c",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.OB_Start_Seasonal__c",property:"required",value:true});
		metadataToUpdate.push({path:"Punto_Vendita_9.OB_Start_Seasonal__c",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
	}
}

rule checkValidity_EndSeasonal {
	agenda-group:'Punto_Vendita_9';
	when{
		f1 : FieldProps f1.objectsData.pv.OB_Start_Seasonal__c !='' && f1.objectsData.pv.OB_End_Seasonal__c =='';
	}
	then{
		var metadataToUpdate=[];
		console.log('checkValidity_EndSeasonal has been fired! ');
		metadataToUpdate.push({path:"Punto_Vendita_9.pv_OB_End_Seasonal__c",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.pv_OB_End_Seasonal__c",property:"required",value:true});
		metadataToUpdate.push({path:"Punto_Vendita_9.pv_OB_End_Seasonal__c",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
	}
}

rule removeMandatorySeasonalInput {
	agenda-group:'Punto_Vendita_9';
	when{
		f1 : FieldProps f1.objectsData.pv.OB_Start_Seasonal__c =='' && f1.objectsData.pv.OB_End_Seasonal__c =='';
	}
	then{
		var metadataToUpdate=[];
		console.log('removeMandatorySeasonalInput has been fired! ');
		metadataToUpdate.push({path:"Punto_Vendita_9.pv_OB_Start_Seasonal__c",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.pv_OB_Start_Seasonal__c",property:"required",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.pv_OB_Start_Seasonal__c",property:"disabled",value:false});
		
		metadataToUpdate.push({path:"Punto_Vendita_9.pv_OB_End_Seasonal__c",property:"hidden",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.pv_OB_End_Seasonal__c",property:"required",value:false});
		metadataToUpdate.push({path:"Punto_Vendita_9.pv_OB_End_Seasonal__c",property:"disabled",value:false});
		emit("updateInptCmpsMetadata",metadataToUpdate);
	}
}