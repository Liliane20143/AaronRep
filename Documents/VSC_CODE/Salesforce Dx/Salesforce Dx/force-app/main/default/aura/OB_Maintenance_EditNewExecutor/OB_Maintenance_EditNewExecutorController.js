({ 
	init : function(component, event, helper) {
		//SALVATORE P. -- SET ACCORDION SECTION "SECTION 1" EXPENSEVE--START
		if(component.get("v.status") == "EDIT")
		{
			component.set("v.showAccordionEditExecutor","Section1");
			console.log("OB_Maintenance_EditNewExecutorController.js : showAccordionEditExecutor : " + component.get("v.showAccordionEditExecutor"));
		}
		//SALVATORE P. -- SET ACCORDION SECTION "SECTION 1" EXPENSEVE--END
		var flowdata = component.get("v.FlowData");  
		var showmodal =  component.get("v.showModal");
		helper.retrieveFieldsLabel(component,event,helper);
		
		var generateNewContact =  component.get("v.newExecutor");
		console.log('generateNewContact: ' + JSON.stringify(generateNewContact));
		var objectDataMap = {};
		
		if(generateNewContact){
			objectDataMap = JSON.parse(flowdata);
			var AccountId = objectDataMap.acc.Id;
			objectDataMap.executor = JSON.parse('{"attributes":{"type":"Contact"} , "AccountId":"'+AccountId+'"}');
			component.set('v.objectDataMap',objectDataMap);
		}else{
			component.set('v.objectDataMap',JSON.parse(flowdata));
		}

		var status = component.get("v.status");
		// NEXI-94 Marta Stempien <marta.stempien@accenture.com> 18/06/2019 - Start
            if(!$A.util.isEmpty(component.get("v.objectDataMap.executor.Id"))){
        	    component.set("v.isTrueShowExecutorInputs", true);
            }
        // NEXI-94 Marta Stempien <marta.stempien@accenture.com> 18/06/2019 - Stop

		console.log('do init objdata '+JSON.stringify(component.get('v.objectDataMap')['executor']));
		if(status=='EDIT'){
			helper.setAddressMappingcontactAddress(component, event);
			helper.setAddressMappingdocreleaseAddress(component, event);
			helper.setAddressMappingbirthAddress(component, event);
			helper.setAddressMappingCitizenship(component, event);
			helper.setAddressMappingFiscalCode(component, event);
			helper.getCompanyLinkTypes(component, event);
			helper.getGenders(component, event);

			try{
				component.set('v.isLoaded',true);

				
			}
			catch(err){
				console.log('err is '+err);}
			}  
			else{
				helper.disableFields(component,event,helper);
			}
	},
	test : function(component, event, helper) {
       		var switchOnload= component.get("v.switchOnload");
       		component.set('v.switchOnload',!switchOnload);
       		component.set("v.showModal", false);
       	},
       	modify : function(component, event, helper) {
       		var oldFlowdata = component.get("v.FlowData"); 
       		var JSONDeserialized = JSON.parse(oldFlowdata);
       		console.log('ACC ID: ' + typeof JSONDeserialized.acc.Id);
       		var AccountId =  JSONDeserialized.acc.Id;
			   helper.existLog(component, event, AccountId ,false);
			   component.set("v.showMerchantDetails", false);
		},
		modifyNewExecutor : function(component, event, helper) {
		var oldFlowdata = component.get("v.FlowData"); 
		var JSONDeserialized = JSON.parse(oldFlowdata);
		var AccountId =  JSONDeserialized.acc.Id;
		helper.existLog(component, event, AccountId , true);
		component.set("v.showMerchantDetails", false);
       },

       cancel : function(component, event, helper) {

       	component.set("v.FlowStep", $A.get("$Label.c.OB_MAINTENANCE_STEP_SUMMARY"));
       },

       savecustom : function(component, event, helper) { 
       	var oldFlowdata = component.get("v.FlowData"); 
       	var JSONDeserialized = JSON.parse(oldFlowdata);
       	var objectDataMap = component.get('v.objectDataMap');
        //28/12/18 -- SALVATORE P. -- SET PEP VALUE IN OBJECT DATA MAP--START
        var pepValue = component.find('OB_PEP__c');
        console.log("@pep value : " + pepValue);
        
        if(typeof(pepValue) !== undefined)
        {	
        	if(component.find('OB_PEP__c').get("v.checked")){
        		objectDataMap.executor.OB_PEP__c = true;
        	}else{
        		objectDataMap.executor.OB_PEP__c = false;
        	}
        }
        console.log('objectDataMap.executor.OB_PEP__c'+objectDataMap.executor.OB_PEP__c);
		//28/12/18 -- SALVATORE P. -- SET PEP VALUE IN OBJECT DATA MAP--END
		var newFlowdataCon = objectDataMap.executor;
       	console.log('objectDataMap: '+JSON.stringify(objectDataMap));
       	console.log('oldFlowdata: '+ JSONDeserialized.executor);
        var oldObject = {};
        var newObject = {};
        oldObject['Contact'] = JSONDeserialized.executor;
        
        newObject['Contact'] = newFlowdataCon;
        console.log('oldObject: '+ JSON.stringify(oldObject));
        console.log('newObject: '+ JSON.stringify(newObject));


        var oldJSON = JSON.stringify(oldObject);
        var newJSON = JSON.stringify(newObject);
        
        if(oldJSON == newJSON)
        {
        	//err
        	console.log('in error save');
        	helper.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR") , $A.get("$Label.c.OB_MAINTENANCE_ERROR_NODATACHANGE"), 'error');
        }
        else{
        	console.log('in success');
			var generateNewContact =  component.get("v.newExecutor");
        	helper.savecustomHelper(component,event, JSON.stringify(oldObject), JSON.stringify(newObject),generateNewContact);
        }
    },
    //giovanni spinelli 18/01/2019 - remover error message with onblur event
    removeErrorMessage :  function(component, event, helper){

    	try{
    		
       		var currentId = event.getSource().getLocalId();
       		console.log('current id; ' + currentId);
    		var errorMessage  = helper.removeMandatoryMessage('errorId'+currentId);
    	}catch(err){
			console.log('err.message removeErrorMessage: ' + err.message);
		}
    	
    }

   

})