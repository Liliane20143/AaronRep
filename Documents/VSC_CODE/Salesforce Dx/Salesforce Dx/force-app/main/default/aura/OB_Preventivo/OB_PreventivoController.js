({
    doInit : function(component, event, helper) {
		console.log('In preventivo - doInit');
		component.set("v.objectDataMap.isPreventivo", false);
		var templateName = 'Contratto Trilaterale POS'; //Waiting for the name template
		component.set("v.templateName", templateName);
		var action = component.get("c.retrieveQuoteTemplate");
        action.setParams({
            "templateName" : templateName
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var res = response.getReturnValue();
                if(!($A.util.isEmpty(res)) )
                {
					component.set("v.templateId", res);
					console.log('Id template: '+component.get("v.templateId"));
                }
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        _utils.debug("Error message: " +
                        errors[0].message);
                    }
                }else {
                    _utils.debug("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    callService : function(component, event , helper){
        var merchant = component.get("v.objectDataMap.merchant.Id");
        console.log('merchant: '+merchant);
        var servicePoint = component.get("v.objectDataMap.pv.Id");
        console.log('servicePoint: '+servicePoint);
        var configuration = component.get("v.objectDataMap.Configuration.Id");
        console.log('configuration: '+configuration);
        var orderHeader = component.get("v.objectDataMap.OrderHeader.Id");
        console.log('orderHeader: '+orderHeader);
		var recordId = component.get("v.templateId");
		console.log('recordId: ' + recordId);
		var nameDoc = component.get("v.templateName");
		console.log('nameDoc: ' + nameDoc);
		
		var request = $A.get("e.c:OB_ContinuationRequest");
		var isToRegenerate = 'false';
		request.setParams({ 
			methodName: "getBase64DocID",
			methodParams: [merchant, servicePoint, orderHeader, configuration, recordId , isToRegenerate, "false", nameDoc],
			callback: function(result) {
				console.log('RISULTATO: '+ JSON.stringify(result));
			}
		});
		request.fire();
	},
	nextStepBundle: function(component,event,helper){	
		var borderErrors = [];
		borderErrors = document.getElementsByClassName('borderError');
		var mapChildIdName = component.get("v.mapChildIdName");
		var childItemList = [];
        if(borderErrors.length == 0)
        {
            if(component.get("v.checkAgreedChanges") == false)
            {
                for(var key in mapChildIdName)
                {
                    if(mapChildIdName[key].warning)
                    {
                        childItemList.push(mapChildIdName[key].name);
                    }
                }
                if(childItemList.length > 0)
                {
                    var message =  $A.get("$Label.c.OB_decreaseCommission");
                    message+= ' ';
                    for(var i = 0; i<childItemList.length; i++)
                    {
                        message+= childItemList[i] + ', ';
                    }
                    var type = 'info';
                    var newMessage = message.substring(0, message.length - 2);
                    helper.showInfoToast(component, event, newMessage, type);
                    return;
                }
            }
        }
		var isMaintenancePricing = component.get("v.isMaintenancePricing");
		var requestCheckout = false;
		if( borderErrors.length > 0 )
		{
			var type = 'error';
			var infoMessage =  $A.get("$Label.c.OB_RemoveErrorsToProceed");
			helper.showInfoToast(component, event, infoMessage, type);
		}
		else
		{
			component.set("v.objectDataMap.isPreventivo", true);	
			var objectDataMap = component.get("v.objectDataMap");
			var endBundle = false;
			var step = component.get('v.bundleStep');
			var outerstep = component.get('v.step');
			var bundId	= objectDataMap.unbind.offertaId;
			var	coreOutput	= component.get("v.contextOutput");
            for(var i in coreOutput.listOfBundles){
                if(bundId == coreOutput.listOfBundles[i].id){
                    var bundleLength = coreOutput.listOfBundles[i].bundleElements.length;
                    if((bundleLength-1)> step && isMaintenancePricing != true){
                        selectedBundle=  coreOutput.listOfBundles[i].bundleElements[step];
                        bundleSelected =  coreOutput.listOfBundles[i];
                        break;
                    }
                    endBundle= true;
                    outerstep++;
                }
			}
			component.set("v.afterSummary",true);
			outerstep = 2;
			var warningCustomLabel = $A.get("$Label.c.OB_GenerateQuote");
			var warningCustomLabelBody = $A.get("$Label.c.OB_AgreePrivacy");
			var modalHeader = warningCustomLabel; 
			var modalDesc = warningCustomLabelBody;
			component.set("v.modalHeader", modalHeader);
			component.set("v.modalDesc", modalDesc);
			component.set("v.showWarningModal", true);
			requestCheckout = false;
			component.set('v.requestCheckout',requestCheckout);
			component.set('v.step',outerstep);
			component.set('v.bundleStep',step);
		}
    }, 

})