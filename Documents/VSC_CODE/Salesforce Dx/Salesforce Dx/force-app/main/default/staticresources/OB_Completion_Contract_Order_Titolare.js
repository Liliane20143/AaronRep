rule InsertNumberTitolare {
	agenda-group:'Numero_Titolari_Effetivi_3';
	when{
		f1 : FieldProps f1.objectsData.Numeri_Titolari.UNBIND2 <='2';
	}
	then{
		var sectionsToUpdate=[];
		sectionsToUpdate.push({step:"Titolare_Effettivo_3",sectionName:"Titolare_Effettivo_2_",sectionIndex:"3",property:"hidden",value:false});
		emit("updateSections",sectionsToUpdate);
	}
}

