rule stepToGo {
	agenda-group:'Esecutore_2';
	when{
		f1 : FieldProps f1.objectsData.stepToGo.UNBIND2 =='step1';
	}
	then{
		var methodArguments= {};
		methodArguments['stepToGo'] = 4;
		emit("goToStep",methodArguments);
	}
}



