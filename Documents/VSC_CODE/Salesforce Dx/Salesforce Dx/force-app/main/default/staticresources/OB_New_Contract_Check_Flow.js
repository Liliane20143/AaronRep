rule CheckServizio {
	agenda-group:'Servizio_4';
	when{
		f1 : FieldProps f1.objectsData.ValueService.UNBIND6 !='';
	}
	then{
		var methodArguments= {};
		methodArguments["validationClass"] = "CustomMerchantSave";
		methodArguments["method"] = "executeMethod";
		emit("executeMethod",methodArguments);
	}
}
