rule ShowPvDetails {
	agenda-group:'Punto_Vendita_4';
	when{
		f1 : FieldProps f1.objectsData.accoID.UNBIND1 !='';
	}
	then{
		var sectionsToUpdate=[];
		sectionsToUpdate.push({step:"Punto_Vendita_4",sectionName:"DATI_PV",sectionIndex:"1",property:"hidden",value:false});
		emit("updateSections",sectionsToUpdate);
	}
}
rule showPvDetailPanel {
       agenda-group:'Punto_Vendita_4';
       when{
              f1 : FieldProps f1.objectsData.accoID.UNBIND1 !='';
       }
       then{
              var sectionsToUpdate=[];
       sectionsToUpdate.push({step:"Punto_Vendita_4",sectionName:"DETTAGLI_PV",sectionIndex:"2",property:"hidden",value:false});
              emit("updateSections",sectionsToUpdate);
       }
}
rule checkRoleEsecutore {
	agenda-group:'Esecutore_2';
	when{
		f1 : FieldProps f1.objectsData.legale_rappresentante.Role__c !='Esecutore';
	}
	then{
		var methodArguments= {};
		methodArguments["messageType"] = "error";
		methodArguments["messageText"] = "Errore: ruolo non consentito";
		emit("showMessage",methodArguments);
	}
}
rule checkRoleTitEff {
	agenda-group:'Titolare_Effettivo_3';
	when{
		f1 : FieldProps f1.objectsData.titolare_effettivo1.Role__c !='Titolare Effettivo';
	}
	then{
		var methodArguments= {};
		methodArguments["messageType"] = "error";
		methodArguments["messageText"] = "Errore: ruolo non consentito";
		emit("showMessage",methodArguments);
	}
}


