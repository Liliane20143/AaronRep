({
	/*
		antonio.vatrano, antonio.vatrano@accenture.com
		11/04/2019
		method retrieve active asset from recordId and enablements;
	*/
    doInit : function(component, event, helper) {
        console.log(component.get("v.recordId"));
        var action = component.get("c.getAcquiringFromAsset");
        action.setParams({
            "assetId": component.get("v.recordId")
            
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
				var res = response.getReturnValue();
				var responseParsed= JSON.parse(res);
				var listEnab = responseParsed.enablememntsList;
				var enab = listEnab[0];
				var listPos = responseParsed.wpList;
				var pos = listPos[0];
				/*
					antonio.vatrano, antonio.vatrano@accenture.com
					11/04/2019
					component is visible only for Operation;
				*/
				if(responseParsed.profileName =='Operation'){
					component.set("v.isOperation", true);
				}
				component.set("v.posList",listPos);
				component.set("v.enablementsList",listEnab);
				if(component.get("v.posList").length>0 && enab.prodRecordType == 'Acquiring'){
					component.set("v.orderParameter", 'lightningFromVF=false;ordId='+pos.orderId); 
					component.set("v.proposerABI",pos.abi);
					component.set("v.offerid",pos.bundleId);
					component.set("v.servicePointId",pos.servicePointId);
					component.set("v.isToShow",true);
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
                    console.log("****Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
	},
	
    showDetails : function(component, event, helper){
        if(component.get("v.openTab")=='open'){
            component.set("v.openTab",'close');
		}
		else
		{
            component.set("v.openTab",'open');
        }
		$A.createComponent("c:OB_Enablements", 
		{   
			"enablementsListToView" :  component.get("v.enablementsList"),
			"isColumnToAdd":false
		}, 
		function (cmp)
		{
			var body = component.get("v.body");
			body.push(cmp);
			if(component.get("v.openTab")=='open')
			{
				component.set("v.body", body);
			}
			else
			{
				component.set("v.body",'');
			}
		});
	},
	showOfferClick: function(component, event, helper){
		/*
			antonio.vatrano, antonio.vatrano@accenture.com
			11/04/2019
			method to start search and biuld FlowData
		*/
		helper.showOffer(component, event, helper); 
	},
	showAttribute: function(component, event, helper){
		component.set("v.attributeColumns", [
			{label: 'Nome', fieldName: 'Name',type: 'text'},
			{label: 'Valore', fieldName: 'NE__Value__c',type: 'text'}
			]);
		var action = component.get("c.getAttributesAsset");
		action.setParams({
			"assetId": component.get("v.recordId")
		});
		action.setCallback(this, function(response){
			var state = response.getState();
			if (state === "SUCCESS") {
				var res = response.getReturnValue();
				component.set("v.attributesList",res);
				component.set("v.isToShowAttribute",true);
				if(res.length==0)
				{
					component.set("v.showDatatable",false);
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
					console.log("****Unknown error");
				}
			}
		});
		
		$A.enqueueAction(action);
		
	},
	closeModal : function(component, event, helper) {
        component.set("v.isToShowAttribute", false);
	},


   

})