({
    /*
     *   antonio.vatrano, antonio.vatrano@accenture.com
     *   15/04/2019
     *   method to retrieve data of servicePoint from the context referent, and current user for OB_Maintenance_EditServicePoint
     */
    init : function(component, event, helper) {
        console.log("@@init");
        var recordId= component.get("v.recordId");
        console.log("@@init Id: "+recordId);
        try {
            var action = component.get('c.retrieveData');
            action.setParams({
                "contactId": recordId
            });
            action.setCallback(this, $A.getCallback(function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var valueReturns = response.getReturnValue();
                    if(valueReturns['profile'] == 'Operation'){
                        component.set("v.OperationUser",true);
                    }
					component.set("v.FlowData",valueReturns['result']);
                    component.set("v.servicePointId",valueReturns['servicePointId']);
                    var recordType = valueReturns['recordType'];
                    console.log('@@recordType: '+recordType);
                    var rightRecordType = ['Referente_Punto_Vendita', 'Referente_Tecnico','Responsabile_Amministrativo'];
                    if(rightRecordType.includes(recordType)){
                        component.set("v.rightRecordType",true);
                    }
                    component.set("v.retrieveDone",true);
                    
                }
            }));
            $A.enqueueAction(action);
        } catch (err) {
            console.log('SEARCH ERROR EXCEPTION:' + err);
        }
        

    },
    /*
     *   antonio.vatrano, antonio.vatrano@accenture.com
     *   15/04/2019
     *   method to open OB_Maintenance_EditServicePoint in modal
     */
    showModalModify : function(component, event, helper){
        console.log("@@Modal");
        component.set("v.showModal", true);
	},


})