rule ExecuteMethod {
	agenda-group:'Servizio_4';
	when{
		f1 : FieldProps f1.objectsData.unbind.UNBIND7 !='';
	}
	then{
		var methodArguments= {};
		methodArguments["validationClass"] = "CustomMerchantSave";
		methodArguments["method"] = "executeMethod";
		emit("executeMethod",methodArguments);
	}
}

rule NEXTRULE {
	agenda-group:'Cart_5';
	when{
		f1 : FieldProps f1.objectsData.unbind.nextCheck !='';
	}
	then{
		var methodArguments= {};
		methodArguments['stepToGo'] = 6;
		emit("goToStep",methodArguments);
	}
}


