rule SettingFiscalCode {
	agenda-group:'Merchant_2';
	when{
		f1 : FieldProps f1.objectsData.unbind.UNBIND5 !='';
	}
	then{
		var methodArguments= {};
		methodArguments['stepToGo'] = 3;
		emit("goToStep",methodArguments);
	}
}
