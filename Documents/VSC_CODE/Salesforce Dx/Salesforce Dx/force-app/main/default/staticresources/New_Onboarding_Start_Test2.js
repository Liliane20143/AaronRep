rule ValidationSearch {
	agenda-group:'Start_1';
	when{
		f1 : FieldProps f1.objectsData.merchant.Id !='';
	}
	then{
		var methodArguments= {};
		methodArguments['stepToGo'] = 3;
		emit("goToStep",methodArguments);
	}
}