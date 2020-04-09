rule check_acquiring {
	agenda-group:'Servizio_4';
	when{
		f1 : FieldProps f1.objectsData.unbind.ACQUIRING ==true;
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Servizio_4.unbind_POS",property:"hidden",value:false});
		metadataToUpdate.push({path:"Servizio_4.unbind_POS",property:"required",value:false});
		metadataToUpdate.push({path:"Servizio_4.unbind_POS",property:"disabled",value:true});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Servizio_4.unbind_ACQUIRINGPOS",property:"hidden",value:false});
		metadataToUpdate.push({path:"Servizio_4.unbind_ACQUIRINGPOS",property:"required",value:false});
		metadataToUpdate.push({path:"Servizio_4.unbind_ACQUIRINGPOS",property:"disabled",value:true});
		emit("updateInptCmpsMetadata",metadataToUpdate);
	}
}

rule Check_Pos {
	agenda-group:'Servizio_4';
	when{
		f1 : FieldProps f1.objectsData.unbind.POS ==true;
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Servizio_4.unbind_ACQUIRING",property:"hidden",value:false});
		metadataToUpdate.push({path:"Servizio_4.unbind_ACQUIRING",property:"required",value:false});
		metadataToUpdate.push({path:"Servizio_4.unbind_ACQUIRING",property:"disabled",value:true});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Servizio_4.unbind_ACQUIRINGPOS",property:"hidden",value:false});
		metadataToUpdate.push({path:"Servizio_4.unbind_ACQUIRINGPOS",property:"required",value:false});
		metadataToUpdate.push({path:"Servizio_4.unbind_ACQUIRINGPOS",property:"disabled",value:true});
		emit("updateInptCmpsMetadata",metadataToUpdate);
	}
}

rule Check_ac_pos {
	agenda-group:'Servizio_4';
	when{
		f1 : FieldProps f1.objectsData.unbind.ACQUIRINGPOS ==true;
	}
	then{
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Servizio_4.unbind_ACQUIRING",property:"hidden",value:false});
		metadataToUpdate.push({path:"Servizio_4.unbind_ACQUIRING",property:"required",value:false});
		metadataToUpdate.push({path:"Servizio_4.unbind_ACQUIRING",property:"disabled",value:true});
		emit("updateInptCmpsMetadata",metadataToUpdate);
		var metadataToUpdate=[];
		metadataToUpdate.push({path:"Servizio_4.unbind_POS",property:"hidden",value:false});
		metadataToUpdate.push({path:"Servizio_4.unbind_POS",property:"required",value:false});
		metadataToUpdate.push({path:"Servizio_4.unbind_POS",property:"disabled",value:true});
		emit("updateInptCmpsMetadata",metadataToUpdate);
	}
}


rule Check_Acquiring {
	agenda-group:'Servizio_4';
	when{
		f1 : FieldProps f1.objectsData.unbind.ACQUIRING ==true;
	}
	then{
		var dataToUpdate=[];
		dataToUpdate.push({path:"merchant.OB_Services_Choice__c",newValue:"ACQUIRING"});
		emit("updateData",dataToUpdate);
	}
}

rule Check_Pos_Value {
	agenda-group:'Servizio_4';
	when{
		f1 : FieldProps f1.objectsData.unbind.POS ==true;
	}
	then{
		var dataToUpdate=[];
		dataToUpdate.push({path:"merchant.OB_Services_Choice__c",newValue:"POS"});
		emit("updateData",dataToUpdate);
	}
}

rule check_value_Ac_pos {
	agenda-group:'Servizio_4';
	when{
		f1 : FieldProps f1.objectsData.unbind.ACQUIRINGPOS ==true;
	}
	then{
		var dataToUpdate=[];
		dataToUpdate.push({path:"merchant.OB_Services_Choice__c",newValue:"ACQUIRING + POS"});
		emit("updateData",dataToUpdate);
	}
}







