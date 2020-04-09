rule MostraDatiPV {
	agenda-group:'Ricerca_Merchant_1';
	when{
		f1 : FieldProps f1.objectsData.pv.Id !='';
	}
	then{
		var sectionsToUpdate=[];
		sectionsToUpdate.push({step:"Ricerca_Merchant_1",sectionName:"DATI_PUNTO_VENDITA",sectionIndex:"1",property:"hidden",value:false});
		emit("updateSections",sectionsToUpdate);
		var sectionsToUpdate=[];
		sectionsToUpdate.push({step:"Ricerca_Merchant_1",sectionName:"Referente_Tecnico",sectionIndex:"2",property:"hidden",value:false});
		emit("updateSections",sectionsToUpdate);
		var sectionsToUpdate=[];
		sectionsToUpdate.push({step:"Ricerca_Merchant_1",sectionName:"APERTURE",sectionIndex:"3",property:"hidden",value:false});
		emit("updateSections",sectionsToUpdate);
	}
}
