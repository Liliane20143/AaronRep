({
      /*
        *@author antonio.vatrano antonio.vatrano@accenture.com
        *@date 18/04/2019
        *@search function: retrive all data of account from fiscal code or vat code, and build FlowData for OB_Maintenance_EditAccount
    */
    searchHelper: function (component, fiscalCode, vatCode) {
        var AccountName = fiscalCode;
        var VatNumber = vatCode;
		var ServicePoint     = '';
		var SIACode          = '';
		var SiaEstablishment = '';
		var TerminalId       = '';
		var MoneticaCustomerCode= '';
		var MoneticaEstablishmentCode = '';
		var ABI='';
		var wrapper = {AccountName:AccountName, VatNumber:VatNumber, ServicePoint:ServicePoint,SIACode : SIACode, SiaEstablishment: SiaEstablishment,TerminalId: TerminalId,MoneticaCustomerCode : MoneticaCustomerCode, MoneticaEstablishmentCode : MoneticaEstablishmentCode, ABI : ABI };
        var JSONwrap =  JSON.stringify(wrapper);
        try {
            var action = component.get('c.searchAcc');
            action.setParams({
                "jsonWrap": JSONwrap
            });
            action.setCallback(this, $A.getCallback(function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var valueReturns = response.getReturnValue();
                    component.set("v.FlowData",valueReturns);
                    component.set("v.retrieveDone",true);
                    
                }
            }));
            $A.enqueueAction(action);
        } catch (err) {
            console.log('SEARCH ERROR EXCEPTION:' + err);
        }

    }
})