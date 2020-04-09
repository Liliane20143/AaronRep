rule MostraDati {
	agenda-group:'Ricerca_societa_1';
	when{
		f1 : FieldProps f1.objectsData.merchant.Id !='';
	}
	then{
		var sectionsToUpdate=[];
		sectionsToUpdate.push({step:"Ricerca_societa_1",sectionName:"DATI_SOCIETA",sectionIndex:"1",property:"hidden",value:false});
		emit("updateSections",sectionsToUpdate);
	}
}

