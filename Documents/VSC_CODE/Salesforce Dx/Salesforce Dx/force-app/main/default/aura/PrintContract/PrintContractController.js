({
	loadOptions: function (component, event, helper) {
var opts = [
{ value: "VISA", label: "VISA Contract" },
{ value: "BANCOMAT", label: "BANCOMAT Contract" },
{ value: "AMEX", label: "AMEX Contract" }
];
        component.set("v.options", opts);}

})