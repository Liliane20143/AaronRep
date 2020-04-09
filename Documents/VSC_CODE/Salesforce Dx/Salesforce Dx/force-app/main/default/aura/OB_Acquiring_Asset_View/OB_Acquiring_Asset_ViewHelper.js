({
        /*
			antonio.vatrano, antonio.vatrano@accenture.com
			11/04/2019
			method call an action from controller apex; the action value return is flowdata to OB_Maintenance_Summary 
		*/
    performSearchOnServer : function(component, event, helper,wrapper ){
         try{
            var action = component.get('c.search');
            action.setParams({ 
                "jsonWrap" : wrapper
            });
            action.setCallback(this, $A.getCallback(function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var valueReturns = response.getReturnValue();
                    var result = JSON.parse( valueReturns );
                    if(result.outcome == $A.get("$Label.c.OB_MAINTENANCE_NOERROR")){
                        component.set("v.FlowData",valueReturns);
                        component.set("v.FlowStep", $A.get("$Label.c.OB_MAINTENANCE_STEP_SUMMARY"));
                        component.set("v.showOffer", true);
                    }
                    else{
                        console.log('error on outcome'); 
                        this.showToast(component, event, helper,$A.get("$Label.c.OB_MAINTENANCE_TOASTERROR"), result.errorMessage, "error");
                    }
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    console.error(errors);
                }
            }));
            $A.enqueueAction(action);   
            }catch(err) {
                    console.log ('SEARCH ERROR EXCEPTION:'+ err);
            } 
        },

        /*
			antonio.vatrano, antonio.vatrano@accenture.com
			11/04/2019
			method to to build a String lake a filter for search
		*/
        showOffer: function(component, event, helper){
            var posList = component.get("v.posList");
            var pos = posList[0];
            var AccountName      =  pos.accountFC;
            var VatNumber        =  '';
            var ServicePoint     =  pos.ServicePoint;
            var SIACode          =  '';
            var SiaEstablishment =  '';
            var TerminalId       =  '';
            var url =  '';
            var app =  '';
            var InternalUser = true;  
            var MoneticaCustomerCode = '';
            var MoneticaEstablishmentCode = '';
            var ABI = pos.abi;
            var wrapper = {AccountName:AccountName, VatNumber:VatNumber, ServicePoint:ServicePoint,SIACode : SIACode, SiaEstablishment: SiaEstablishment,TerminalId: TerminalId, url: url, app: app, MoneticaCustomerCode : MoneticaCustomerCode, MoneticaEstablishmentCode : MoneticaEstablishmentCode, ABI : ABI };
            var JSONwrap =  JSON.stringify(wrapper);
            component.set("v.proposerABI",ABI);
            component.set("v.bundleConfiguration",pos.bundleId);
            component.set("v.servicePointId",pos.servicePointId); // antonio.vatrano ri107 25/06/2019
           
            this.performSearchOnServer(component, event, helper,JSONwrap);
        },

        /*
			antonio.vatrano, antonio.vatrano@accenture.com
			11/04/2019
			method to show a toast with parameters title, message, type
		*/
        showToast: function (component, event, helper,title, message, type) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": title,
                "message": message,
                "type": type
            });
            toastEvent.fire();
        },
})