rule RulegoToNextStepSocieta {
	agenda-group:'Dati_Operativi_3';
	when{
		f1 : FieldProps f1.objectsData.unbind.goToNextStepSocieta =='true';
	}
	then{
		var methodArguments= {};
		methodArguments['stepToGo'] = 3;
		emit("goToStep",methodArguments);
	}
}
