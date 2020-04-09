rule CheckNext {
	agenda-group:'Ricerca_Merchant_1';
	when{
		f1 : FieldProps f1.objectsData.unbind.UNBIND3 !='';
	}
	then{
		var methodArguments= {};
		methodArguments['stepToGo'] = 2;
		emit("goToStep",methodArguments);
	}
}
