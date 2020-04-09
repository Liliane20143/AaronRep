rule showPvPanel {
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

rule Saving_Service_choice {
	agenda-group:'Summary';
	when{
		f1 : FieldProps f1.objectsData.unbind.ACQUIRING ==true;
	}
	then{
		var dataToUpdate=[];
		dataToUpdate.push({path:"merchant.OB_Services_Choice__c",newValue:unbind.ACQUIRING});
		emit("updateData",dataToUpdate);
	}
}

