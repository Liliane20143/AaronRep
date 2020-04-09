({
	init : function(component, event, helper){
		var pos = component.get("v.pos");
		console.log("vediamo: "+pos.stato);
		var state = pos.color;		
		var rim = component.find("cer");		
		if($A.util.isEmpty(pos.orderId)){
			component.set("v.orderId",false);
		}else{
			component.set("v.orderId",true);
		}
		if(state == "red"){
			
			$A.util.addClass(rim,"rimRed");
			component.set("v.showLink",false);
		}else if(state == "green"){
			
			$A.util.addClass(rim,"rimGreen");
			component.set("v.showLink",false);
		}else{
			
			$A.util.addClass(rim,"rimYellow");
			component.set("v.showLink",true);
			
		}
	},
    showDetails : function(component, event, helper){
        var eventId = event.getSource().get("v.value");
        if(component.get("v.openTab")=='open'){
            component.set("v.openTab",'close');
        }else{
            component.set("v.openTab",'open');
        }
		console.log('eventId',eventId);
		var listToView=[];
		var action = component.get("c.getEnablements");
        action.setParams({
            "assetId": eventId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {				
				var res = response.getReturnValue();                
                var responseParsed= JSON.parse(res);
                console.log(JSON.stringify(responseParsed));				
				component.set("v.enablementsListToView",res);			
				$A.createComponent("c:OB_Enablements", 
				{   
					"enablementsListToView" :  responseParsed.enablememntsList,
					"isColumnToAdd":true
				}, 
				function (cmp)
				{
					var body = component.get("v.body");
					body.push(cmp);
					if(component.get("v.openTab")=='open'){
					component.set("v.body", body);
					}else{
						component.set("v.body",'');
					}
				});	
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
	showOffer: function(component, event, helper){
		var eventId = event.getSource().get("v.value");
		var AccountName      =  component.get("v.accountName");
		var VatNumber        =  '';
		var ServicePoint     =  '';
		var SIACode          =  '';
		var SiaEstablishment =  '';
		var TerminalId       =  '';
		var url =  '';
		var app =  '';
		var InternalUser = true;  
		var MoneticaCustomerCode = '';
		var MoneticaEstablishmentCode = '';
		var ABI = JSON.parse(JSON.stringify(component.get("v.mapAbi")[eventId]));
		var wrapper = {AccountName:AccountName, VatNumber:VatNumber, ServicePoint:ServicePoint,SIACode : SIACode, SiaEstablishment: SiaEstablishment,TerminalId: TerminalId, url: url, app: app, MoneticaCustomerCode : MoneticaCustomerCode, MoneticaEstablishmentCode : MoneticaEstablishmentCode, ABI : ABI };
		var JSONwrap =  JSON.stringify(wrapper);
		
		component.set("v.proposerABI",ABI);
		var configId=JSON.parse(JSON.stringify(component.get("v.mapAssetConfig")[eventId]));		
		for(var key in component.get("v.mapAssetBundleConfig")){
			if(key ==eventId ){
				component.set("v.bundleConfiguration",component.get("v.mapAssetBundleConfig")[key]);
			}	
		}		
		helper.performSearchOnServer(component, event, helper,JSONwrap);
		
	},
	showAttribute: function(component, event, helper){
		component.set("v.attributeColumns", [
			{label: 'Nome', fieldName: 'Name',type: 'text'},
			{label: 'Valore', fieldName: 'Value',type: 'text'}		// antonio.vatrano 17/04/2019 bugfix RI-5 
			]);
		console.log('showDetails');
		var eventId = event.getSource().get("v.value");
		var methodValue = component.get("v.mapItem")[eventId] == 'Asset'?'getAttributes':'getAttributesItem';
		var action = component.get("c."+methodValue);
	
		action.setParams({
			"orderItemId": eventId
			
		});
		action.setCallback(this, function(response){
			var state = response.getState();
			if (state === "SUCCESS") {
				var res = response.getReturnValue();
				res = JSON.parse(res);		// antonio.vatrano 17/04/2019 bugfix RI-5 
				component.set("v.attributesList",res);
				component.set("v.isToShowAttribute",true);
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
	/* Simone  Misani mail: simone.misani@accenture.com   
	redirect url  for the page-configuartion
	start date: 11/04/2019
	*/
	showTerminal: function(component, event, helper){
		var pos = component.get("v.pos");
        var getBaseURL    = component.get("c.getBaseURl");
		getBaseURL.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var myBaseURL = response.getReturnValue();
				component.set("v.myBaseURL",myBaseURL);				
				window.location.href = myBaseURL + pos.orderId;				
			}  
			else if (state === "ERROR"){
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message){
						console.log("Error message: " + 
								errors[0].message);
					}
				}
				else{
					console.log("Unknown error");
				}
			}
		});
		
		$A.enqueueAction(getBaseURL); 
	}

    

})