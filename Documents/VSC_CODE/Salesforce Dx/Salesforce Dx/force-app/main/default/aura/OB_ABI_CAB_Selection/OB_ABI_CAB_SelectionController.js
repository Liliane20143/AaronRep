({
    doInit : function(component, event, helper) {
		helper.doInitHelper(component, event, helper);
    },
    
    openABIModal : function(component, event, helper)
	{
		console.log("INTO OPEN MODAL");
		component.set("v.searchABI", true);
		component.set("v.spinner", true);  
		helper.setABIAttributesForModal(component, event);
    },

    //Francesca: checking ABI or CAB value while user is typing.
	checkInputValue: function(component, event, helper) {
		var id = event.getSource().get("v.id");			//davide.franzini - 29/07/2019 - WN-212
		var value = '';
		if(id == "ABI") 
		{
			value = event.getSource().get("v.value");	//davide.franzini - 29/07/2019 - WN-212
			if(value.length == 5)
			{
				helper.checkABI(component, event, value);
			}else
			{
				component.set("v.correctABI", false);
			}
		}else if(id == "CAB")
		{
			value = event.getSource().get("v.value");	//davide.franzini - 29/07/2019 - WN-212
			if(value.length == 5)
			{
				helper.checkCAB(component, event, value);
			}else
			{
				component.set("v.correctCAB", false);
			}	
		}
	},
	
	  // OPEN MODAL FOR CAB FIELD
	openCABModal: function(component, event, helper) {
		  helper.setModalAttributesCAB(component, event);  
	},
    
    handleShowModalEventABICABSelection : function(component, event, helper)
	{
		console.log("INTO HANDLE SHOW EVENT");
        var objectDataMap = event.getParam("objectDataMap");
        
		//enrico purificato - skip error when i open all modal
		
		if(objectDataMap.isCommunityUser){ 
			//return;
		}
		component.set("v.objectDataMap", objectDataMap);
		component.set("v.objectDataMap.cabSelected", "true");
		var objDataMapAfterEvent  = component.get("v.objectDataMap");
		var searchABI = component.get("v.searchABI");
		console.log("objectDataMap.bank.OB_ABI__c : " + objDataMapAfterEvent.bank.OB_ABI__c );
		console.log("objDataMapAfterEvent.user.OB_CAB__c : " + objDataMapAfterEvent.user.OB_CAB__c );
		if(searchABI)
		{
			objDataMapAfterEvent.user.OB_CAB__c = '';
			helper.checkABI(component, event, objDataMapAfterEvent.bank.OB_ABI__c);
		}
		else
		{
			objDataMapAfterEvent.bank.OB_ABI__c = objDataMapAfterEvent.user.OB_ABI__c;
			helper.checkABI(component, event, objDataMapAfterEvent.bank.OB_ABI__c);
			var testABI = objDataMapAfterEvent.bank.OB_ABI__c;
			console.log("test abi is: "+ testABI);
			helper.checkCAB(component, event, objDataMapAfterEvent.user.OB_CAB__c);
		}
		
		component.set("v.objectDataMap", objDataMapAfterEvent);
		console.log("objdatamap after setting CAB and ABI: " + JSON.stringify(component.get("v.objectDataMap")));
		console.log("MCC DESCRIPTION :" + objectDataMap.merchant.OB_DescriptionVATNotPresent__c);
	},
	
    handleShowModal : function() {
        var modalBody;
        var modalFooter;
        $A.createComponents([
            ["c:modalContent",{}],
            ["c:modalFooter",{}]
        ],
                            function(components, status){
                                if (status === "SUCCESS") {
                                    modalBody = components[0];
                                    modalFooter = components[1];
                                    component.find('overlayLib').showCustomModal({
                                        header: "Paginaniton In Lightning",
                                        body: modalBody, 
                                        footer: modalFooter,
                                        showCloseButton: true,
                                        cssClass: "my-modal,my-custom-class,my-other-class",
                                        closeCallback: function() {
                                            
                                        }
                                    });
                                }
                            }
                           );
	},

	showError : function(component,event,helper)
	{
        helper.showError(component);
	},

	//elena.preteni F3 17/07/2019 show error toast, abi not selected F3
	showErrorABI :function(component,event,helper){
		if(component.get("v.objectDataMap.abiError")=='true'){
			let toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				"message"   : $A.get("$Label.c.OB_AbiNotSelectedOperation"), //NEXI-275 Marta Stempien <marta.stempien@accenture.com> 27/08/2019
				"type"      : 'error',
				"duration"  : 5000
			});
			toastEvent.fire();
		}
	}
})