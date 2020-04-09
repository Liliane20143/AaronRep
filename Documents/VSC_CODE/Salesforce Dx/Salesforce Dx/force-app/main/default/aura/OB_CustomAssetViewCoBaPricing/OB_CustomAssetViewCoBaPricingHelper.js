({
    //andrea.morittu start 2019.04.15        
    doInitHelper : function(component, event, helper) {
        var action          = component.get("c.getAssetInfoServer");
        var objectDataMap   = !$A.util.isUndefined(component.get("v.objectDataMap"))? component.get("v.objectDataMap") : null;
        var isCommunity     = !$A.util.isUndefined(component.get("v.isCommunity"))? component.get("v.isCommunity") : null;
        // @ andrea.morittu --> passing the service point id to the apex class
        var servicePointId  = !$A.util.isUndefined(component.get("v.ServicePointSelectedRow"))? component.get("v.ServicePointSelectedRow") : null;
        var offerAssetid  = !$A.util.isUndefined(component.get("v.offerAssetid"))? component.get("v.offerAssetid") : null;//simone.misani@accenture.com R1F2-92 07/05/2019
        action.setParams({  
                                servicePointId         :   servicePointId,
                                offerId                : offerAssetid //simone.misani@accenture.com R1F2-92 07/05/2019
                        });

        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (state === "SUCCESS") {
                try {
                    var retrievedItem =  response.getReturnValue();
                    console.log('retrievedItems are the following: ' +  JSON.stringify(retrievedItem));
                    if(!$A.util.isUndefined(retrievedItem)) {
                        component.set("v.retrievedItem", retrievedItem);
                        //START----simone.misani@accenture.com R1F2-92 07/05/2019
                        var res = JSON.parse(retrievedItem);
                        console.log('resp: '+JSON.stringify(res));
                        component.set("v.listCoba",res);
                    }
                    this.setColumns(component, event, helper);
                    //END---simone.misani@accenture.com R1F2-92 07/05/2019
                } catch(exc) {
                    console.log('an error has occured: ' + exc.getMessage);
                }
            }
            else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    //andrea.morittu end 2019.04.15
/*simone misani create columns for data-table.
R1F2-92 07/05/2019*/
/*Start Masoud zaribaf 10/05/2019 defect RI-113 add initialwidth to IBAN column*/

    setColumns : function(component, event, helper){
            console.log('in set columns');
            
        component.set("v.columnsCoba", [
            {label: $A.get('$Label.c.OB_Pos'), fieldName: 'pvCode',type: 'text'},	
            {label: $A.get('$Label.c.OB_TerminalIdLabel') , fieldName: 'terminalId',type: 'text'},
            {label: $A.get('$Label.c.OB_pvCode') , fieldName: 'codeServicepoint',type: 'text'},
            
            {label: $A.get('$Label.c.IBAN') , fieldName: 'IBAN',type: 'text', initialWidth:400},
            {label: $A.get('$Label.c.OB_AccountHolderLabel') , fieldName: 'accountHolder',type: 'text'}	
            ]);
            /*End Masoud zaribaf 10/05/2019 defect RI-113 add initialwidth to IBAN column*/


            console.log(component.get("v.columnsCoba"));

    }
})