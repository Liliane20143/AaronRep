({
    doInit : function(component, event, helper) {
        try
        {
			var isFlow = component.get("v.isFlow");
			var objectDataMap = component.get("v.objectDataMap");
            helper.doInitMethodApex(component,event,helper); //both setup and maintenance  

			//END francesca.ribezzi 16/07/19 
			if(isFlow){  
				//START francesca.ribezzi 16/07/19 adding addressMapping to set isMaintenance value - performance merge:
				var addressMapping = JSON.stringify(component.get("v.addressMapping"));
				var addressMappingObj = JSON.parse(addressMapping);
				if(!$A.util.isEmpty(addressMappingObj.isMaintenance)){
					var isTrueSet = (addressMappingObj.isMaintenance == 'true');
					component.set('v.isMaintenance',isTrueSet);
				}
				console.log("addressMapping: " +JSON.stringify(component.get("v.addressMapping")));
				// START - 2019/05/14 - salvatore.pianura - Sostituzione Terminale
				var listOfId = component.get("v.objectDataMap.TerminalIdsChanged");
				component.set("v.listOfTerminalIdAvaiable",listOfId);
				// END - 2019/05/14 - salvatore.pianura - Sostituzione Terminale
				// Daniele Gandini <daniele.gandini@accenture.com> - 22/05/2019 - TerminalsReplacement - START
				var isReplacement = component.get("v.objectDataMap.isReplacement");
				component.set("v.isReplacement", isReplacement);
				console.log("isreplacement tech details? " + isReplacement);
				// Daniele Gandini <daniele.gandini@accenture.com> - 22/05/2019 - TerminalsReplacement - END
				/*SIMONE MISANI 08/03/2019*/
				/*var yearConstitutionCompanyNull = $A.util.isEmpty(objectDataMap.merchant.OB_Year_constitution_company__c);
				if(yearConstitutionCompanyNull) {
					component.set("v.objectDataMap.merchant.OB_Year_constitution_company__c", null);
				}*/
				// Daniele Gandini <daniele.gandini@accenture.com> - 19/06/2019 - Logic for maintenance remove case - START													  										
				helper.checkProfileLoggedUser_helper(component, event, helper);
				helper.offerModify_Helper(component, event, helper);
				// Daniele Gandini <daniele.gandini@accenture.com> - 19/06/2019 - Logic for maintenance remove case - END	 
			}
			var isMaintenance = component.get("v.isMaintenance");  
			console.log("isMaintenance: " + isMaintenance);
			
		//27/07/19 francesca.ribezzi removinf block code from here -> going into doInitMethodApex
        
            // Daniele Gandini <daniele.gandini@accenture.com> - 17/05/2019 - TerminalsReplacement - START
            if(isReplacement){
                objectDataMap.confirmOperationalData=true;
                component.set("v.objectDataMap",objectDataMap);
                var listOfId = component.get("v.objectDataMap.TerminalIdsChanged");
                component.set("v.listOfTerminalIdAvaiable",listOfId);
                helper.checkProfileLoggedUser_helper(component, event, helper);
                helper.populateMapForTerminalId_Helper(component, event, helper);
                helper.retrieveSiaCodes_Helper(component, event, helper);
                var operationalDataToHide = component.find("confirmOperationaDataId");
                $A.util.addClass(operationalDataToHide, 'slds-hide');
                console.log('isFlow: ' + isFlow + 'isMaintenance: ' + isMaintenance);
                console.log("objectDataMap.itemsInRemove:" + JSON.stringify(component.get("v.objectDataMap.itemsInRemove")));
			}
            // Daniele Gandini <daniele.gandini@accenture.com> - 17/05/2019 - TerminalsReplacement - END
            //START francesca.ribezzi 09/07/19  call createFakeContextOutput everytime
            var orderId = component.get("v.orderId"); 
            if($A.util.isEmpty(orderId)){
                orderId = objectDataMap.Configuration.Id;
            }
			component.set("v.orderId",orderId);
            if(isMaintenance){
				//start antonio.vatrano 12/06/2019 r1f2-247
				var businessModel = (component.get('v.objectDataMap.bankProfile.OB_Business_Model_Acquiring__c') == 'Bancario')? true : false;
				var gt = (component.get('v.objectDataMap.bankProfile.OB_GT__c') == 'Nexi') ? true : false;
				var applicantNEXI = (component.get('v.objectDataMap.bankProfile.OB_Applicant_RAC_Code_SIA__c') == 'Nexi') ? true : false;
				var applicantBANCA = (component.get('v.objectDataMap.bankProfile.OB_Applicant_RAC_Code_SIA__c') != 'Nexi') ? true : false;
				var conditionBanca =  businessModel && gt && applicantBANCA ;
				var conditionNexi = applicantNEXI;
				component.set('v.conditionBanca',conditionBanca);
				component.set('v.conditionNexi',conditionNexi);
				//End antonio.vatrano 12/06/2019 r1f2-247
				helper.currentUse(component, event, helper);// simone misani R1F2-115 15/05/2019
				//D.F. _ Manage Rac Sia v4 _ START
				component.set('v.isMaintenanceRac',true);
				//francesca.ribezzi 26/07/19 deleting checkterminals
				//D.F. _ END
			}
			//26/07/19 francesca.ribezzi moving this helper here
			helper.getReportType(component,helper ,event ); //both setup and maintenance

		//	helper.splitOrderItemPOS(component,event);
            //START francesca.ribezzi 11/07/19 call getOrderData and then createFakeContextOutput here instead of splitOrderItemPOS
			helper.getOrderData(component,event,orderId);
		
           } catch(err){
               console.log('GENERIC_ERROR_DOINIT:  ' + err.message );                                      
        }
    },

    	//LUBRANO 16/01/2019 Libreria Log
	logInit: function(component){
		_utils.logInit(component.getName());
	},
	/*
    *@author francesca.ribezzi
    *@date 31/07/2019
    *@task checkRedBorder - setting red border to empty required fields - WN-211
    *@history 31/07/2019 Method created
    */
    checkRedBorder: function(component, event, helper){
		var input = event.target;
		helper.handleRedBorderErrors(component,event, input);
	},
	//this is called when an attribute value is changed. it fires an event that calls onUpdateContext function:
    onChangeAttributeValuePOS: function(component, event, helper){
    	//_utils.debug("into onChangeAttributeValuePOS");
    	var attributeIndex = JSON.stringify(event.target.id); 
        var listOfItems = component.get("v.posList");
        var parentIndex = document.getElementById(event.target.id).name;
        var pos1 = attributeIndex.indexOf("_")+1;
        var length1 = attributeIndex.indexOf("_",pos1)-1;
		var tempStr = attributeIndex.substr(length1);
		//19/07/19 francesca.ribezzi - performance 
		var isMaintenance = component.get("v.isMaintenance");
        attributeIndex = tempStr.substr(0,tempStr.indexOf('_'));//firstIndex+'_'+index+'_POS'

        //RESET Error Message if updating terminal ID
        var attName = document.getElementById(attributeIndex+'_attName').textContent;
        var itemToUpdate = listOfItems[parentIndex];
         var errMsg= document.getElementById(event.target.id+'_Error');
        var contextOutput = component.get("v.contextOutput");
		itemToUpdate.listOfAttributes[attributeIndex].fields.value =  event.target.value;
		//START francesca.ribezzi 18/07/19 chaning action - performance
		var newValue = 	itemToUpdate.listOfAttributes[attributeIndex].fields.value;
		var oldValue = itemToUpdate.listOfAttributes[attributeIndex].fields.Old_Value__c;
		//francesca.ribezzi 04/09/19 - wn-349 - adding check on action:
		var enAction = itemToUpdate.childItems[attributeIndex].fields.action;  
		if(isMaintenance){
			if(newValue != oldValue && enAction == 'None'){
				itemToUpdate.listOfAttributes[attributeIndex].fields.NE__Action__c = 'Change';
				itemToUpdate.listOfAttributes[attributeIndex].fields.action = 'Change';
				//START francesca.ribezzi 03/09/19- WN-3128 - changing childItem's action as well
				itemToUpdate.fields.NE__Action__c = 'Change';
				itemToUpdate.fields.action = 'Change';   
				//END francesca.ribezzi  03/09/19 - WN-3128
			}
			if($A.util.isEmpty(oldValue)){
				oldValue = newValue;
			}
		}
		//END francesca.ribezzi 18/07/19 
		//START francesca.ribezzi 31/07/19 - WN-211 
		var name = 	itemToUpdate.listOfAttributes[attributeIndex].fields.name;
		var setRequiredToAll = 'Yes';
		if(name == 'APP' || name == 'URL' || name == 'Paymail'){
			if(!$A.util.isEmpty(newValue)){
				setRequiredToAll = 'No'; 
			}
		}
		for(var i = 0; i < itemToUpdate.listOfAttributes.length;i++){
			var name = itemToUpdate.listOfAttributes[i].fields.name;
			if(name == 'APP' || name == 'URL' || name == 'Paymail'){
				//obj[name] = value;
				itemToUpdate.listOfAttributes[i].fields.required = setRequiredToAll;
			}
		}
		//END francesca.ribezzi 31/07/19 - WN-211 
        //francesca.ribezzi - removing error class from input:
		component.set("v.itemToUpdate", itemToUpdate);
		//francesca.ribezzi 08/07/19 setting posList as not calling onUpdateContext anymore
		component.set("v.posList", listOfItems);
		errMsg.innerHTML = '';
		// francesca.ribezzi 01/08/19 setting red border to empty required fields - WN-211
	//	helper.handleRedBorderErrors(component,event); 

    },
     onChangeAttributeValuePOSPickList: function(component, event, helper){
        //_utils.debug("into onChangeAttributeValuePOSPicklist")   
		var listOfItems = component.get("v.posList");
		//LUBRANO -- 2019/02/23 gestione attribute/parent index index 
		var attributeIndex = event.getSource().get("v.name"); //11/07/19 francesca.ribezzi getting attribute with event.getSource - api version 
		attributeIndex = attributeIndex.replace(/"\""/g, ""); 
        //var attributeIndex = JSON.stringify(event.target.name); 
		//_utils.debug("attributeIndex: " + attributeIndex);
		var indexArray = attributeIndex.split('_');
		var parentIndex = indexArray[0]; 
		attributeIndex = indexArray[1];
        var itemToUpdate = listOfItems[parseInt(parentIndex)];
		var contextOutput = component.get("v.contextOutput");
		//19/07/19 francesca.ribezzi - performance 
		var isMaintenance = component.get("v.isMaintenance");
        itemToUpdate.listOfAttributes[attributeIndex].fields.value =  event.getSource().get("v.value"); //11/07/19 francesca.ribezzi getting value with event.getSource - api version 
        ////_utils.debug("attribute changed: " +itemToUpdate.listOfAttributes[attributeIndex] );
	  	//START francesca.ribezzi 18/07/19 chaning action - performance
		var newValue = 	itemToUpdate.listOfAttributes[attributeIndex].fields.value;
		var oldValue = itemToUpdate.listOfAttributes[attributeIndex].fields.Old_Value__c;
		//francesca.ribezzi 04/09/19 - wn-349 - adding check on action: 
		var enAction = itemToUpdate.listOfAttributes[attributeIndex].fields.action; 
		if(isMaintenance){
			if(newValue != oldValue && enAction == 'None'){
				itemToUpdate.listOfAttributes[attributeIndex].fields.NE__Action__c = 'Change';
				itemToUpdate.listOfAttributes[attributeIndex].fields.action = 'Change';
				//START francesca.ribezzi 03/09/19- WN-3128 - changing childItem's action as well
				itemToUpdate.fields.NE__Action__c = 'Change';
				itemToUpdate.fields.action = 'Change';   
				//END francesca.ribezzi  03/09/19 - WN-3128
			}
			if($A.util.isEmpty(oldValue)){
				oldValue = newValue;
			}
		}
		//END francesca.ribezzi 18/07/19 
		if(itemToUpdate.listOfAttributes[attributeIndex].fields.name == 'SimCard'){
			//francesca.ribezzi 04/09/19 - WN-349 - adding this node in order to insert simcard order item
			itemToUpdate.listOfAttributes[attributeIndex].fields.rootOrderItem = itemToUpdate.fields.id;
			itemToUpdate.listOfAttributes[attributeIndex].fields.Old_Value__c = newValue; //gianluigi.virga 04/11/2019 - PRODOB-526
		}
		//START francesca.ribezzi 31/07/19 - WN-211 
		var name = 	itemToUpdate.listOfAttributes[attributeIndex].fields.name;
		var setRequiredToAll = 'Yes';
		if(name == 'APP' || name == 'URL' || name == 'Paymail'){
			if(!$A.util.isEmpty(newValue)){
				setRequiredToAll = 'No';
			}
		}
		for(var i = 0; i < itemToUpdate.listOfAttributes.length;i++){
			var name = itemToUpdate.listOfAttributes[i].fields.name;
			if(name == 'APP' || name == 'URL' || name == 'Paymail'){
				//obj[name] = value;
				itemToUpdate.listOfAttributes[i].fields.required = setRequiredToAll;
			}
		}
		//END francesca.ribezzi 31/07/19 - WN-211 
		component.set("v.itemToUpdate", itemToUpdate);
    	component.set("v.isEnd",false);
        //itemToUpdate.childItems[attributeIndex].fields.OB_enablement__c = status; 
		//francesca.ribezzi 08/07/19 setting listOfItems as not calling onUpdateContext anymore
		component.set("v.posList", listOfItems);	 
		 component.set("v.configurePicklist",true);
		 component.set("v.needConfig",true);
		// francesca.ribezzi 01/08/19 setting red border to empty required fields - WN-211
	//helper.handleRedBorderErrors(component,event);
		//START gianluigi.virga 25/07/2019 - PRODOB-161
		 if(itemToUpdate.listOfAttributes[attributeIndex].fields.name == $A.get("$Label.c.OB_SimCard")){
			if((itemToUpdate.listOfAttributes[attributeIndex].fields.action != $A.get("$Label.c.OB_ActionNone") && itemToUpdate.listOfAttributes[attributeIndex].fields.value != null && itemToUpdate.listOfAttributes[attributeIndex].fields.value != undefined && itemToUpdate.listOfAttributes[attributeIndex].fields.value != '')
					|| (itemToUpdate.listOfAttributes[attributeIndex].fields.action == $A.get("$Label.c.OB_ActionNone"))){
				itemToUpdate.listOfAttributes[attributeIndex].fields.simCardIsValid = true;
			}else{
				itemToUpdate.listOfAttributes[attributeIndex].fields.simCardIsValid = false;
			}
		}
		if(itemToUpdate.listOfAttributes[attributeIndex].fields.name == $A.get("$Label.c.OB_Property")){
			if((itemToUpdate.listOfAttributes[attributeIndex].fields.action != $A.get("$Label.c.OB_ActionNone") && itemToUpdate.listOfAttributes[attributeIndex].fields.value != null && itemToUpdate.listOfAttributes[attributeIndex].fields.value != undefined && itemToUpdate.listOfAttributes[attributeIndex].fields.value != '')
					|| (itemToUpdate.listOfAttributes[attributeIndex].fields.action == $A.get("$Label.c.OB_ActionNone"))){
				itemToUpdate.listOfAttributes[attributeIndex].fields.thirdPartyPropertyIsValid = true;
			}else{
				itemToUpdate.listOfAttributes[attributeIndex].fields.thirdPartyPropertyIsValid = false;
			}
		}
		//END gianluigi.virga 25/07/2019 - PRODOB-161

    },
    onChangeItemValuePOS: function(component, event, helper){
    	//_utils.debug("into onChangeItemValuePOS");
    	var attributeIndex = event.target.id; 
        var listOfItems = component.get("v.posList");
        var itemToUpdate = listOfItems[parseInt(attributeIndex)];
        var contextOutput = component.get("v.contextOutput");
		itemToUpdate.fields.OB_Description__c = event.srcElement.value;
        component.set("v.itemToUpdate", itemToUpdate);
        ////_utils.debug("itemToUpdate: ",itemToUpdate);  
    	//francesca.ribezzi 08/07/19 setting listOfItems as not calling onUpdateContext anymore
		component.set("v.posList", listOfItems);	 
	},  
	
	onCheck: function(component, event, helper){
    	//_utils.debug("into onCheck");
    	//
    	component.set("v.isEnd",false);
    	//09/07/19 francesca.ribezzi using event.getSource().get("v.id") instead of event.target.id -> not working here
    	var attributeIndex = JSON.stringify(event.getSource().get("v.id")); 
        var listOfItems = component.get("v.posList");
       // var parentIndex = document.getElementById(event.target.id).name;
        //var parentIndex = event.currentTarget.getAttribute('data-item');
        var parentIndex = attributeIndex.substr(1, attributeIndex.indexOf('_')-1);
        //_utils.debug("parentIndex: " + parentIndex);
        
        var acq1 = attributeIndex.indexOf("_")+1;
        var length1 = attributeIndex.indexOf("_",acq1)-1;
        var tempStr = attributeIndex.substr(length1);
        attributeIndex = tempStr.substr(0,tempStr.indexOf('_'));	
       // attributeIndex = parseInt(attributeIndex.split('_').pop());
        //_utils.debug("attributeIndex "+attributeIndex);
        var itemToUpdate = listOfItems[parseInt(parentIndex)];
        var contextOutput = component.get("v.contextOutput");
        //_utils.debug("itemToUpdate ",itemToUpdate);
		var status;
		//09/07/19 francesca.ribezzi using event.getSource().get("v.checked") : event.target.checked not working here
        if(event.getSource().get("v.checked")){
        	status = "Y";
        }
        else{
        	status = "N";
		}
		//francesca.ribezzi 10/07/19 setting enablement on childItem:
		itemToUpdate.childItems[attributeIndex].fields.OB_enablement__c = status;
		//START 19/07/19 francesca.ribezzi - performance 
		var isMaintenance = component.get("v.isMaintenance");
		var oldEnablement = itemToUpdate.childItems[attributeIndex].fields.OB_Old_Enablement__c;
		var newEnablement = itemToUpdate.childItems[attributeIndex].fields.OB_enablement__c;
		//END 19/07/19 francesca.ribezzi 
		//START francesca.ribezzi 31/07/19 - WN-228
		var enAction = itemToUpdate.childItems[attributeIndex].fields.action;
			if(oldEnablement != newEnablement && enAction == 'None'){
				itemToUpdate.childItems[attributeIndex].fields.NE__Action__c = 'Change';
				itemToUpdate.childItems[attributeIndex].fields.action = 'Change';
			}//26/08/19 francesca.ribezzi - WN-284 - if action is add, do not change it 
			if($A.util.isEmpty(oldEnablement)){
				oldEnablement = newEnablement;
			}
		//END francesca.ribezzi 31/07/19 - WN-228 
        component.set("v.itemChildCheck",status);
        component.set("v.itemChildToUpdate",itemToUpdate.childItems[attributeIndex]);
		component.set("v.itemToUpdate", itemToUpdate);
		
        ////_utils.debug("itemToUpdate: ",itemToUpdate);  
		//francesca.ribezzi 08/07/19 setting listOfItems as not calling onUpdateContext anymore
		component.set("v.posList", listOfItems);	
		 component.set("v.needConfig",true);
    
    },   
    //this is called when an attribute value is changed. it fires an event that calls onUpdateContext function:
    onChangeAttributeValueBancomat: function(component, event, helper){
    	//_utils.debug("into onChangeAttributeValueBancomat");
        var attributeIndex = JSON.stringify(event.target.id); 
        var listOfItems = component.get("v.bancomatList");
        var parentIndex = document.getElementById(event.target.id).name;
        var Bancomat1 = attributeIndex.indexOf("_")+1;
        var length1 = attributeIndex.indexOf("_",Bancomat1)-1;
        var tempStr = attributeIndex.substr(length1);
        attributeIndex = tempStr.substr(0,tempStr.indexOf('_'));//firstIndex+'_'+index+'_Bancomat'
        var errMsg = document.getElementById(event.target.id+'Error');
        //19/07/19 francesca.ribezzi - performance 
		var isMaintenance = component.get("v.isMaintenance");
        var itemToUpdate = listOfItems[parentIndex];
        var inputNumNameMap = {};
        //francesca.ribezzi - creating map to check the correct input value length for each field:
        inputNumNameMap['Codice SIA'] = 7;
        inputNumNameMap['Codice Stabilimento SIA'] = 5;
        inputNumNameMap['Progressivo SIA'] = 3;
         
        if(itemToUpdate != null){
	        var contextOutput = component.get("v.contextOutput");
	        itemToUpdate.listOfAttributes[attributeIndex].fields.value =  event.target.value;
	        ////_utils.debug("attribute changed: " +itemToUpdate.listOfAttributes[attributeIndex] );
	        var inputValue = event.target.value;
	         //match the regex  /^[0-9]+$/
	        if(/^[0-9]+$/.test(event.target.value)){   	
	        	var nameToCheck = itemToUpdate.listOfAttributes[attributeIndex].fields.name;
				 if(inputValue.length == inputNumNameMap[nameToCheck]){
		        	document.getElementById(event.target.id).classList.remove("borderError");
					itemToUpdate.listOfAttributes[attributeIndex].fields.value =  event.target.value;
					//START francesca.ribezzi 18/07/19 chaning action - performance
					var newValue = 	itemToUpdate.listOfAttributes[attributeIndex].fields.value;
					var oldValue = itemToUpdate.listOfAttributes[attributeIndex].fields.Old_Value__c;
					//francesca.ribezzi 04/09/19 - wn-349 - adding check on action:
					var enAction = itemToUpdate.listOfAttributes[attributeIndex].fields.action; 
					if(isMaintenance){
						if(newValue != oldValue && enAction == 'None'){
							itemToUpdate.listOfAttributes[attributeIndex].fields.NE__Action__c = 'Change';
							itemToUpdate.listOfAttributes[attributeIndex].fields.action = 'Change';
							//START francesca.ribezzi 03/09/19- WN-3128 - changing childItem's action as well
							itemToUpdate.fields.NE__Action__c = 'Change';
							itemToUpdate.fields.action = 'Change';   
							//END francesca.ribezzi  03/09/19 - WN-3128
						}
						if($A.util.isEmpty(oldValue)){
							oldValue = newValue;
						}
					}
					//END francesca.ribezzi 18/07/19 
			        component.set("v.itemToUpdate", itemToUpdate);
			        //_utils.debug("itemToUpdate: ",itemToUpdate);  
				   errMsg.innerHTML = '';
			     }else{
			    	 if(inputValue.length == 0){
			    		 errMsg.innerHTML = '';
				    	 document.getElementById(event.target.id).classList.remove("borderError");
			    	 }else{
				    	 errMsg.innerHTML = $A.get("$Label.c.OB_invalidValue");
				    	 document.getElementById(event.target.id).classList.add("borderError");
				    }
			     }
			     
			}
			else{
				//show error message!!!
				 errMsg.innerHTML = $A.get("$Label.c.OB_invalidValue");
				event.target.value = '';
				document.getElementById(event.target.id).classList.add("borderError");
			}
			//francesca.ribezzi 08/07/19 setting contextOutput as not calling onUpdateContext anymore
			component.set("v.bancomatList", listOfItems);	
		}

	 								
    },
    onChangeAttributeValueBancomatPickList: function(component, event, helper){
        //_utils.debug("into onChangeAttributeValueBancomatPicklist")
        
        var listOfItems = component.get("v.bancomatList");
        
        var attributeIndex = JSON.stringify(event.target.name); 
        //_utils.debug("attributeIndex: " + attributeIndex);
        var parentIndex = attributeIndex.substring(1, attributeIndex.indexOf('_')); 
        var bancomat1 = attributeIndex.indexOf("_")+1;
        var length1 = attributeIndex.indexOf("_", bancomat1)-1;
        var tempStr = attributeIndex.substr(length1);
        attributeIndex = tempStr.substr(0,tempStr.indexOf('_'));
        //attributeIndex = parseInt(attributeIndex.split('_').pop());
        //19/07/19 francesca.ribezzi - performance 
		var isMaintenance = component.get("v.isMaintenance");
        var itemToUpdate = listOfItems[parseInt(parentIndex)];
        var contextOutput = component.get("v.contextOutput");
        itemToUpdate.listOfAttributes[attributeIndex].fields.value =  event.target.value;
        ////_utils.debug("attribute changed: " +itemToUpdate.listOfAttributes[attributeIndex] );
        	//START francesca.ribezzi 18/07/19 chaning action - performance
		var newValue = 	itemToUpdate.listOfAttributes[attributeIndex].fields.value;
		var oldValue = itemToUpdate.listOfAttributes[attributeIndex].fields.Old_Value__c;
		//francesca.ribezzi 04/09/19 - wn-349 - adding check on action:
		var enAction = itemToUpdate.listOfAttributes[attributeIndex].fields.action; 
		if(isMaintenance){
			if(newValue != oldValue && enAction == 'None'){
				itemToUpdate.listOfAttributes[attributeIndex].fields.NE__Action__c = 'Change';
				itemToUpdate.listOfAttributes[attributeIndex].fields.action = 'Change';
				//START francesca.ribezzi 03/09/19- WN-3128 - changing childItem's action as well
				itemToUpdate.fields.NE__Action__c = 'Change';
				itemToUpdate.fields.action = 'Change';   
				//END francesca.ribezzi  03/09/19 - WN-3128
			}
			if($A.util.isEmpty(oldValue)){
				oldValue = newValue;
			}
		}
		//END francesca.ribezzi 18/07/19 
        component.set("v.itemToUpdate", itemToUpdate);
       // //_utils.debug("itemToUpdate: ",itemToUpdate);  
		//francesca.ribezzi 08/07/19 setting bancomatList as not calling onUpdateContext anymore
		component.set("v.bancomatList", listOfItems);	
    },      
    //this is called when an attribute value is changed. it fires an event that calls onUpdateContext function:
    onChangeAttributeValueACQ: function(component, event, helper){
        //_utils.debug("into onChangeAttributeValueACQ")
        var attributeIndex = JSON.stringify(event.target.id); 
          //_utils.debug("attributeIndex: " + attributeIndex);
        var listOfItems = component.get("v.acquiringList");
        var parentIndex = document.getElementById(event.target.id).name;
        var acq1 = attributeIndex.indexOf("_")+1;
        var length1 = attributeIndex.indexOf("_",acq1)-1;
        var tempStr = attributeIndex.substr(length1);
        attributeIndex = tempStr.substr(0,tempStr.indexOf('_'));
        var itemToUpdate = listOfItems[parentIndex];
        var errMsg= document.getElementById(event.target.id+'_Error');
        
        if(itemToUpdate != null){
	        var contextOutput = component.get("v.contextOutput");
	        itemToUpdate.listOfAttributes[attributeIndex].fields.value =  event.target.value;
	        var attName = itemToUpdate.listOfAttributes[attributeIndex].fields.name;
	         //match the regex
	        if(/^[0-9]*([,][0-9]{1,3}|)$/.test(event.target.value)){
	        	if(attName == 'Codice Convenzione'){
	        		if(event.target.value.length != 10 && event.target.value.length != 0){
	        			document.getElementById(event.target.id).classList.add("borderError");
	        			errMsg.innerHTML = $A.get("$Label.c.OB_TenCharsError");
	        		}else{
	        			errMsg.innerHTML = '';
	        			document.getElementById(event.target.id).classList.remove("borderError");
	        			
	        			component.set("v.itemToUpdate", itemToUpdate);
				        //_utils.debug("itemToUpdate: ",itemToUpdate);  
	        		}
	        	}else{
	        		document.getElementById(event.target.id).classList.remove("borderError");
	        		errMsg.innerHTML = '';
			        component.set("v.itemToUpdate", itemToUpdate);
			        //_utils.debug("itemToUpdate: ",itemToUpdate);  
				}
		   }
		   else{
			   event.target.value = '';
			   errMsg.innerHTML = $A.get("$Label.c.OB_invalidValue");
			   	document.getElementById(event.target.id).classList.add("borderError");
		   }
		   	//francesca.ribezzi 08/07/19 setting acquiringList as not calling onUpdateContext anymore
			component.set("v.acquiringList", listOfItems);
		}
	
    },
     onChangeAttributeValueVAS: function(component, event, helper){
    	//_utils.debug("into onChangeAttributeValueVAS");
    	var attributeIndex = JSON.stringify(event.target.id); 
         var listOfItems = component.get("v.vasList");
        var parentIndex = document.getElementById(event.target.id).name;
        var vas1 = attributeIndex.indexOf("_")+1;
        var length1 = attributeIndex.indexOf("_",vas1)-1;
        var tempStr = attributeIndex.substr(length1);
        attributeIndex = tempStr.substr(0,tempStr.indexOf('_'));//firstIndex+'_'+index+'_VAS'
        var errMsg = document.getElementById(event.target.id+'Error');
		var itemToUpdate = listOfItems[parentIndex];
		//19/07/19 francesca.ribezzi - performance 
		var isMaintenance = component.get("v.isMaintenance");
        if(itemToUpdate != null){
	        var contextOutput = component.get("v.contextOutput");
	        itemToUpdate.listOfAttributes[attributeIndex].fields.value =  event.target.value;
	        ////_utils.debug("attribute changed: " +itemToUpdate.listOfAttributes[attributeIndex] );
	         if(/^[0-9]*([,][0-9]{1,3}|)$/.test(event.target.value)){ 
				//START francesca.ribezzi 18/07/19 chaning action - performance
				var newValue = 	itemToUpdate.listOfAttributes[attributeIndex].fields.value;
				var oldValue = itemToUpdate.listOfAttributes[attributeIndex].fields.Old_Value__c;
				//francesca.ribezzi 04/09/19 - wn-349 - adding check on action:
				var enAction = itemToUpdate.listOfAttributes[attributeIndex].fields.action; 
				if(isMaintenance){
					if(newValue != oldValue && enAction == 'None'){
						itemToUpdate.listOfAttributes[attributeIndex].fields.NE__Action__c = 'Change';
						itemToUpdate.listOfAttributes[attributeIndex].fields.NE__Action__c = 'Change';
						//START francesca.ribezzi 03/09/19- WN-3128 - changing childItem's action as well
						itemToUpdate.fields.NE__Action__c = 'Change';
						itemToUpdate.fields.action = 'Change';   
						//END francesca.ribezzi  03/09/19 - WN-3128
					}
					if($A.util.isEmpty(oldValue)){
						oldValue = newValue;
					}
				}
				//END francesca.ribezzi 18/07/19 
		        //francesca.ribezzi - removing error class from input:
		        errMsg.innerHTML = '';
		        var inputValue = event.target.value;
		        if(inputValue.length > 0){
		        	document.getElementById(event.target.id).classList.remove("borderError");
				}
				//START francesca.ribezzi 18/07/19 chaning action - performance
				var newValue = 	itemToUpdate.listOfAttributes[attributeIndex].fields.value;
				var oldValue = itemToUpdate.listOfAttributes[attributeIndex].fields.Old_Value__c;
				//francesca.ribezzi 04/09/19 - wn-349 - adding check on action:
				var enAction = itemToUpdate.listOfAttributes[attributeIndex].fields.action; 
				if(isMaintenance){
					if(newValue != oldValue && enAction == 'None'){
						itemToUpdate.listOfAttributes[attributeIndex].fields.NE__Action__c = 'Change';
						itemToUpdate.listOfAttributes[attributeIndex].fields.NE__Action__c = 'Change';
						//START francesca.ribezzi 03/09/19- WN-3128 - changing childItem's action as well
						itemToUpdate.fields.NE__Action__c = 'Change';
						itemToUpdate.fields.action = 'Change';   
						//END francesca.ribezzi  03/09/19 - WN-3128
					}
					if($A.util.isEmpty(oldValue)){
						oldValue = newValue;
					}
				}
				//END francesca.ribezzi 18/07/19 
		        component.set("v.itemToUpdate", itemToUpdate);
		        //_utils.debug("itemToUpdate: ",itemToUpdate);  
			 }
	         else{
	        	 errMsg.innerHTML = 'Enter a valid value.';
	        	 event.target.value = '';
	        	 document.getElementById(event.target.id).classList.add("borderError");
			 }
			//francesca.ribezzi 08/07/19 setting vasList as not calling onUpdateContext anymore
			component.set("v.vasList", listOfItems);
	    }
	   //component.set("v.itemToUpdate", itemToUpdate);  
    },
 
    onChangeAttributeValueVASPickList: function(component, event, helper){
        //_utils.debug("into onChangeAttributeValueVASPicklist")
        
        var listOfItems = component.get("v.vasList");
        
        var attributeIndex = JSON.stringify(event.target.name); 
        //_utils.debug("attributeIndex: " + attributeIndex);
        var parentIndex = attributeIndex.substring(1, attributeIndex.indexOf('_')); 
        
        var vas1 = attributeIndex.indexOf("_")+1;
        var length1 = attributeIndex.indexOf("_", vas1)-1;
        var tempStr = attributeIndex.substr(length1);
        attributeIndex = tempStr.substr(0,tempStr.indexOf('_'));
        //attributeIndex = parseInt(attributeIndex.split('_').pop());
        
        var itemToUpdate = listOfItems[parseInt(parentIndex)];
		var contextOutput = component.get("v.contextOutput");
		//19/07/19 francesca.ribezzi - performance 
		var isMaintenance = component.get("v.isMaintenance");
		itemToUpdate.listOfAttributes[attributeIndex].fields.value =  event.target.value;
		//START francesca.ribezzi 18/07/19 chaning action - performance
		var newValue = 	itemToUpdate.listOfAttributes[attributeIndex].fields.value;
		var oldValue = itemToUpdate.listOfAttributes[attributeIndex].fields.Old_Value__c;
		//francesca.ribezzi 04/09/19 - wn-349 - adding check on action:
		var enAction = itemToUpdate.listOfAttributes[attributeIndex].fields.action; 
		if(isMaintenance){
			if(newValue != oldValue && enAction == 'None'){
				itemToUpdate.listOfAttributes[attributeIndex].fields.NE__Action__c = 'Change';
				itemToUpdate.listOfAttributes[attributeIndex].fields.action = 'Change';
				//START francesca.ribezzi 03/09/19- WN-3128 - changing childItem's action as well
				itemToUpdate.fields.NE__Action__c = 'Change';
				itemToUpdate.fields.action = 'Change';   
				//END francesca.ribezzi  03/09/19 - WN-3128
			}
			if($A.util.isEmpty(oldValue)){
				oldValue = newValue;
			}
		}
		//END francesca.ribezzi 18/07/19 
        ////_utils.debug("attribute changed: " +itemToUpdate.listOfAttributes[attributeIndex] );
        
        component.set("v.itemToUpdate", itemToUpdate);
       // //_utils.debug("itemToUpdate: ",itemToUpdate);  
    	
		//francesca.ribezzi 08/07/19 setting contextOutput as not calling onUpdateContext anymore
		component.set("v.vasList", listOfItems);
    },

   
    doInitAfter: function(component, event, helper) {
		console.log('INIT AFTER');
		//console.log('call init:' + component.get('v.callInit'));
		console.log("t0 doInitAfter: " + performance.now());
		var t0 = performance.now();
		var objectDataMap = component.get('v.objectDataMap');
		// Daniele Gandini <daniele.gandini@accenture.com> - 19/06/2019 - Logic for maintenance remove case - START
		helper.removeCase_Helper(component, event, helper);
		// Daniele Gandini <daniele.gandini@accenture.com> - 19/06/2019 - Logic for maintenance remove case - END
		console.log('@@@@ ObjectDatamap doinitafter: ' + JSON.stringify(objectDataMap));
		var isNewVisaMastercard = component.get('v.isNewVisaMastercard');
		try 
		{		
			//g.s. 14/02/2019 - if there is the OB_HeaderInternational__c , set it with merchant name - end
			console.log('@@@@ Nel try del doInitAfter'); 
			// DG - 14/02/2019 - 1341 - START
			// Vars to have row time from timestamp
			var opening = objectDataMap.pv.OB_Opening_Time__c/1000/3600;
			var closing = objectDataMap.pv.OB_Ending_Time__c/1000/3600;
			var breakStart = objectDataMap.pv.OB_Break_Start_Time__c/1000/3600;
			var breakEnd = objectDataMap.pv.OB_Break_End_Time__c/1000/3600;					   
			// Vars to have right time values
			// OPENING 
			var openingHours =  Math.floor(opening);
			var openingMinutes =  ((opening - (Math.floor(opening)))*60/100);
			var openingTime = (openingHours + openingMinutes).toFixed(2);
			// CLOSURE
			var closingHours =  Math.floor(closing);
			var closingMinutes = ((closing - (Math.floor(closing)))*60/100);
			var closingTime = (closingHours + closingMinutes).toFixed(2);
			// BREAK START
			var breakStartHours =  Math.floor(breakStart);
			var breakStartMinutes = ((breakStart - (Math.floor(breakStart)))*60/100);
			var breakStartTime = (breakStartHours + breakStartMinutes).toFixed(2);
			// BREAK END
			var breakEndHours =  Math.floor(breakEnd);
			var breakEndMinutes = ((breakEnd - (Math.floor(breakEnd)))*60/100);
			var breakEndTime = (breakEndHours + breakEndMinutes).toFixed(2);

			if(objectDataMap.pv.OB_Opening_Time__c){
				objectDataMap.pv.OB_Opening_Time__c       = openingTime;
			}
			if(objectDataMap.pv.OB_Ending_Time__c){
				objectDataMap.pv.OB_Ending_Time__c        = closingTime;
			}
			if(objectDataMap.pv.OB_Break_Start_Time__c){
				objectDataMap.pv.OB_Break_Start_Time__c   = breakStartTime;
			}
			if(objectDataMap.pv.OB_Break_End_Time__c){
				objectDataMap.pv.OB_Break_End_Time__c     = breakEndTime;
			}
			// DG - 14/02/2019 - 1341 - END

			/*console.log('objectDataMap.merchant.OB_Year_constitution_company__c BEFORE'+objectDataMap.merchant.OB_Year_constitution_company__c);
			//SET YEAR OF CONSTITUTION 
		/*	if( objectDataMap.merchant.OB_Year_constitution_company__c == undefined || 
				objectDataMap.merchant.OB_Year_constitution_company__c == '' || 
				objectDataMap.merchant.OB_Year_constitution_company__c == 0 ) {
				console.log('sono nell if');
				objectDataMap.merchant.OB_Year_constitution_company__c = null;
				// component.set('v.objectDataMap.unbind.yearOfConstitutionCompany' ,'test');
			}
			// else{
			// 	component.set('v.objectDataMap.unbind.yearOfConstitutionCompany' , objectDataMap.merchant.OB_Year_constitution_company__c);
			// }
			component.set('v.objectDataMap.unbind.yearOfConstitutionCompany' , objectDataMap.merchant.OB_Year_constitution_company__c);*/
			//set value for rule at next step -->show/hide description vat not present
			if(objectDataMap.merchant.OB_VAT_Not_Present__c==true){
				//console.log('iNTO IF TRUE');
				component.set( 'v.objectDataMap.unbind.VAT_notPresent_Main', 'true');
				
			}else if(objectDataMap.merchant.OB_VAT_Not_Present__c==false){
				//console.log('iNTO IF FALSE');
				component.set( 'v.objectDataMap.unbind.VAT_notPresent_Main', 'false');
				
			}
			//set value for rule at next step-->manage no profit field
			//IF LEGAL FORM IS NO PROFIT
			if(objectDataMap.merchant.OB_Legal_Form_Code__c == 'ORG_NO_PROFIT')
			{
				component.set('v.objectDataMap.unbind.OB_Legal_Form_Main' , 'NOPROFIT');
				if(objectDataMap.merchant.OB_No_Profit_Recipient_Class__c=='Altro'){
					component.set('v.objectDataMap.unbind.OB_No_Profit_Recipient_Class__c','Altro');
				}
			}
		//	//console.log('OBJECT_DATA_MAP_DOINIT_UNBIND' + JSON.stringify(component.get('v.objectDataMap.unbind') ));
			//********************IBAN SECTION - START ********************//
	    	//valuate if there is a new visa/mastercard and JCB/UPI
	    	var isNewPOS	,	isNewVisaMastercard		,	isNewJCB	,	isNewUPI	, isPOSAtt_unatt;
	    	for(var key in objectDataMap.orderItem)
	    	{
	    	//	//console.log('KEy: ' + key);
	    	//	//console.log('NODE_IN_MAP: ' + JSON.stringify(objectDataMap.orderItem[key]));
	
    			for(var i=0; i<(objectDataMap.orderItem[key]).length; i++)
    			{
    				if(key == 'ACQUIRING' && objectDataMap.orderItem[key][i].NE__ProdId__r.OB_Codice_sfdc__c == 'VISAMASTERCARD' && objectDataMap.orderItem[key][i].NE__Action__c == 'Add') //davide.franzini - 14/06/2019 - R1F2-283
		    		{
						isNewVisaMastercard=true;
						component.set('v.isNewVisaMastercard' , true);
		    		}
		    		if(key == 'ACQUIRING' && objectDataMap.orderItem[key][i].NE__ProdId__r.OB_Codice_sfdc__c == 'UPI' && objectDataMap.orderItem[key][i].NE__Action__c == 'Add') //davide.franzini - 14/06/2019 - R1F2-283
		    		{
		    			isNewUPI=true;
		    		}
		    		if(key == 'ACQUIRING' && objectDataMap.orderItem[key][i].NE__ProdId__r.OB_Codice_sfdc__c == 'JCB' && objectDataMap.orderItem[key][i].NE__Action__c == 'Add') //davide.franzini - 14/06/2019 - R1F2-283
		    		{
		    			isNewJCB=true;
					}
					if(key == 'POS' && objectDataMap.orderItem[key][i].NE__Action__c == 'Add')	//davide.franzini - 14/06/2019 - R1F2-283
					{
						isNewPOS = true;
					}
		    		if(key == 'POS' && (objectDataMap.orderItem[key][i].NE__ProdId__r.OB_Codice_sfdc__c=='POS_TERZI_ATTENDED'|| objectDataMap.orderItem[key][i].NE__ProdId__r.OB_Codice_sfdc__c=='POS_TERZI_UNATTENDED'))
		    		{
		    			isPOSAtt_unatt=true;
		    		}
    			}
    		}
			var bankABI           = $A.util.isUndefinedOrNull(component.get("v.objectDataMap.user.OB_ABI__c")) ? component.get("v.objectDataMap.bank.OB_ABI__c") :component.get("v.objectDataMap.user.OB_ABI__c"), ////START - elena.preteni 18/07/2019 F3 ABI CAB Selection missing nodes OB_ABI__c in user
				CAB               = component.get("v.objectDataMap.user.OB_CAB__c");
			//16/07/19 francesca.ribezzi setting bankABI attribute to generate terminal id:
			component.set('v.bankABI', bankABI);
	    	//if there is an new POS, a new visa/mastercard and there isn't JCB or UPI show IBAN  
	    	if((isNewPOS==true || isNewVisaMastercard==true)/*&&(isNewUPI!=true || isNewJCB!=true )*/)
	    	{
	    		//console.log('SHOW_IBAN');
	    		component.set('v.showIBANSection' , true);
	    		component.find('headerInternational').set('v.disabled' , false);
	    	}
	    	//if there is a new POS attended or anattended show the preliminary verification code
	    	if(isPOSAtt_unatt==true)
	    	{
	    		component.set('v.objectDataMap.prelimVerifCodeRO' , false);//DEFAULT IS TRUE
	    	}

	    	
			var showIBANSection =  component.get('v.showIBANSection');
			//console.log('BANK PROFILE BEFORE IBAN: ' + JSON.stringify(objectDataMap.bankProfile));
			//if i have IBAN section, replace same logic of setup flow - start
			//START - elena.preteni 28/08/2019 CAB editabile added condition (component.get("v.objectDataMap.isOperation") && component.get("v.objectDataMap.isSetup")) to if
			if(showIBANSection==true || (component.get("v.objectDataMap.isOperation") && component.get("v.objectDataMap.isSetup")) )
			{
			//END  - elena.preteni 28/08/2019 CAB editabile added condition (component.get("v.objectDataMap.isOperation") && component.get("v.objectDataMap.isSetup"))  to if
				//g.s. 14/02/2019 - if there is the OB_HeaderInternational__c , set it with merchant name - start
				component.set('v.objectDataMap.BillingProfilePOS.OB_HeaderInternational__c' , objectDataMap.merchant.Name);
				//START - elena.preteni 18/07/2019 F3 ABI CAB Selection CAB editabile
				if(component.get("v.objectDataMap.isOperation") && component.get("v.objectDataMap.isSetup")){
					component.set("v.objectDataMap.BillingProfilePOS.OB_CABCode__c", ''   );
					component.set("v.disabledCab",false);
					//START - elena.preteni 28/08/2019 R1F3-11 make field disabed
					component.set("v.ibanDisabled",false);
					//END - elena.preteni 28/08/2019 R1F3-11 make field disabed
					component.set("v.objectDataMap.BillingProfilePOS.OB_ABICode__c", bankABI   );
					component.set("v.disabledAbi",true);
				}else{
					if(objectDataMap.bankProfile.OB_AccountHolder__c==true){
						//console.log('ACCOUNT_HOLDER_TRUE');
						
						component.set("v.objectDataMap.BillingProfilePOS.OB_CABCode__c", CAB   );
						component.set("v.disabledCab",true);
						component.set("v.objectDataMap.BillingProfilePOS.OB_ABICode__c", bankABI   );
						component.set("v.disabledAbi",true);
					}else{
						//console.log('ACCOUNT_HOLDER_FALSE');
						if(isNewPOS && isNewVisaMastercard){ //11/10/19 francesca.ribezzi WN-604 - disable iban if there are a new pos and a new vm
							component.set("v.ibanDisabled",true);
						}else{
							component.set("v.disabledCab",false);
							component.set("v.disabledAbi",false);
							component.set("v.objectDataMap.BillingProfilePOS.OB_CABCode__c"					, '');
							component.set("v.objectDataMap.BillingProfilePOS.OB_ABICode__c"					, '');
							//START francesca.ribezzi 17/07/19 moving this code below inside else and not outside - performance merge
							component.set('v.objectDataMap.BillingProfilePOS.OB_EuroControlCode__c'			, '');
							component.set('v.objectDataMap.BillingProfilePOS.OB_CINCode__c'					, '');
							component.set('v.objectDataMap.BillingProfilePOS.OB_Bank_Account_Number__c'		, '');
							//END francesca.ribezzi 17/07/19
						}

					}
				}
				//END - elena.preteni 18/07/2019 F3 ABI CAB Selection CAB editabile
			}
			//if i have IBAN section, replace same logic of setup flow - end
			//if i have IBAN section, replace same logic of setup flow
		//	//console.log('SHOW_IBAN: ' + component.get('v.showIBANSection'));
	    	
			//********************      IBAN SECTION - END    ********************//

			//********************REPORT TYPE SECTION - START ********************//
			//only if there is a new visa/mastercard show picklist
			 // check && isNewPOS!=true && isNewUPI!=true && isNewJCB!=true
			//START francesca.ribezzi 11/09/19 - R1F3-48 - if it is setup, setting reportTypeRO in doInitMethod server-side method
			 if(component.get("v.isMaintenance")){
				if(isNewVisaMastercard==true){
					component.set('v.objectDataMap.reportTypeRO' , false);
				}else{
					component.set('v.objectDataMap.reportTypeRO' , true);
				}
			}
			//END francesca.ribezzi 11/09/19 - R1F3-48 
			//********************REPORT TYPE SECTION - END   ********************//
			//********************PRELIMINARY VERIFICATION CODE & SETT TYPE - START   ********************//
	    	for(var key in objectDataMap.orderItem)
	    	{
	    		//console.log('KEy: ' + key);
	    	//	//console.log('NODE_IN_MAP: ' + JSON.stringify(objectDataMap.orderItem[key]));
    			for(var i=0; i<(objectDataMap.orderItem[key]).length; i++)
    			{
    	//			//console.log('NODE_INNER_MAP: ' + JSON.stringify(objectDataMap.orderItem[key][i].NE__ProdId__r.OB_Codice_sfdc__c));

    				if(key == 'POS' && (objectDataMap.orderItem[key][i].NE__ProdId__r.OB_Codice_sfdc__c=='POS_TERZI_ATTENDED'|| objectDataMap.orderItem[key][i].NE__ProdId__r.OB_Codice_sfdc__c=='POS_TERZI_UNATTENDED'))
		    		{
		    //			//console.log('POS_ATTENDED');
		    			component.set('v.objectDataMap.prelimVerifCodeRO' , false);//DEFAULT IS TRUE
		    		}
		    		if(key == 'ACQUIRING' && objectDataMap.orderItem[key][i].NE__ProdId__r.OB_Acquirer__c == 'NEXI' )
		    		{
		    	//		//console.log('ACQUIRING LIST: ' + JSON.stringify(objectDataMap.orderItem[key]));
		    			component.set('v.objectDataMap.isNEXI' ,  true);
		    			// NEXI-256 Marta Stempien <marta.stempien@accenture.com> 05/08/2019, Deleted setting v.settlementType - deleted attribute
					}
				}
			}
			//********************PRELIMINARY VERIFICATION CODE & SETT TYPE - START   ********************//
			var keyToUse= !$A.util.isEmpty(objectDataMap.keyToUse)? JSON.parse(objectDataMap.keyToUse) : null; //francesca.ribezzi 18/10/19 - parsing keyToUse node bacause it is a String!
			for(var key in objectDataMap.orderItem)
				{
					//elena.preteni - start - 30/01/2019
					for(var i=0; i<(objectDataMap.orderItem[key]).length; i++)
					{
						if(isNewVisaMastercard && objectDataMap.orderItem[key][i].NE__ProdId__r.OB_Acquirer__c == 'NEXI'){
					//		//console.log('OBJDATAMAP_KEYTOUSE: ' + objectDataMap.keyToUse);
							if(keyToUse.servicePointCode != null && keyToUse.Processor == 'EQUENS')
							{ 
					//			//console.log('PROCESSOR_EQUENS');
								if( keyToUse.OBInternationalSettlementMethod != null )
								{
					//				//console.log('INT_SETT_METHOD_NOTNULL');
									if(objectDataMap.bankProfile.OB_Circuit__c == 'Pagobancomat bancario')
									{
					//					//console.log('BANKPROFILE_PAGOBANCOMAT_BANCARIO');
										component.set('v.objectDataMap.interSettMethRO',true);
										objectDataMap.Configuration.OB_PBSettlementMethod__c  = keyToUse.OBPBSettlementMethod;
										objectDataMap.Configuration.OB_InternationalSettlementMethod__c =keyToUse.OBInternationalSettlementMethod;
									}
									if(objectDataMap.bankProfile.OB_Circuit__c == 'Pagobancomat sub-licenza')
									{
					//					//console.log('BANKPROFILE_PAGOBANCOMAT_SUBLICENZA');
										if(objectDataMap.orderItem[key][i].NE__Root_Order_Item__c == null && objectDataMap.orderItem[key][i].NE__ProdId__r.RecordType.DeveloperName == 'Pagobancomat')
										{
											if(objectDataMap.Configuration.OB_PBSettlementMethod__c != undefined && objectDataMap.Configuration.OB_PBSettlementMethod__c !=null)
											{
					//							//console.log('SETT_MET_NOTNULL');
												objectDataMap.viewSettMeth = true;
												objectDataMap.settMethRO = false;
											
											}
											else if(objectDataMap.orderItem[key][i].RecordType.DeveloperName=='Pagobancomat') 
											{
					//							//console.log('DEVNAME==PAGOBANCOMAT');
												component.set('v.objectDataMap.interSettMethRO',true);
												objectDataMap.Configuration.OB_PBSettlementMethod__c  = keyToUse.OBPBSettlementMethod;
												objectDataMap.Configuration.OB_InternationalSettlementMethod__c =keyToUse.OBInternationalSettlementMethod;
											}
											else
											{
					//							//console.log('DEVNAME!=PAGOBANCOMAT');
												component.set('v.objectDataMap.interSettMethRO',true);
												objectDataMap.Configuration.OB_PBSettlementMethod__c  = keyToUse.OBPBSettlementMethod;
												objectDataMap.Configuration.OB_InternationalSettlementMethod__c = keyToUse.OBInternationalSettlementMethod;
											}
		
										}
									
									}
								}
							}
							//var valueNetto = 'BANCA (ACCREDITATO AL NETTO DELLE COMMISSIONI)';
							//var valueLordo = 'BANCA (ACCREDITATO AL LORDO DELLE COMMISSIONI)';
							var valueNetto = 'ACCREDITO AL NETTO DELLE COMMISSIONI';
							var valueLordo = 'ACCREDITO AL LORDO DELLE COMMISSIONI';
							if(keyToUse.servicePointCode != null && keyToUse.Processor == 'SIA')
							{
					//			//console.log('EQUENS_SIA');
								if( keyToUse.OBInternationalSettlementMethod != null )
								{

									component.set('v.objectDataMap.interSettMethRO',true);
									objectDataMap.Configuration.OB_PBSettlementMethod__c  = keyToUse.OBInternationalSettlementMethod;
									objectDataMap.Configuration.OB_InternationalSettlementMethod__c =keyToUse.OBInternationalSettlementMethod;
								} 
								else
								{
									
									if( objectDataMap.bankProfile.OB_SettlementType__c == 'Prepagato')
									{
					//					//console.log('SETT_PREPAGATO');
										component.set('v.objectDataMap.interSettMethRO',true);
										keyToUse.OBInternationalSettlementMethod=valueNetto;
										objectDataMap.Configuration.OB_PBSettlementMethod__c  = valueNetto;
										objectDataMap.Configuration.OB_InternationalSettlementMethod__c =valueNetto;
									}
									if( objectDataMap.bankProfile.OB_SettlementType__c == 'Postpagato')
									{
					//					//console.log('SETT_POSTPAGATO');
										component.set('v.objectDataMap.showPicklistPostpagato',true);
										component.get('v.postPagatoPickList').push(valueNetto);
										component.get('v.postPagatoPickList').push(valueLordo);
										objectDataMap.Configuration.OB_PBSettlementMethod__c  = component.get('v.settMethodPostPagatoValue');
										objectDataMap.Configuration.OB_InternationalSettlementMethod__c =component.get('v.settMethodPostPagatoValue');;
									}
									
								}

							}
							if(typeof keyToUse.servicePointCode === undefined || keyToUse.servicePointCode == null)
							{
					//			//console.log('SERVICEPOINTCODE_NULL');
								if( objectDataMap.bankProfile.OB_SettlementType__c == 'Prepagato')
								{
					//				//console.log('SETT_PREPAGATO');
									component.set('v.objectDataMap.interSettMethRO',true);
									keyToUse.OBInternationalSettlementMethod =valueLordo;
									objectDataMap.Configuration.OB_PBSettlementMethod__c  = valueLordo;
									objectDataMap.Configuration.OB_InternationalSettlementMethod__c =valueLordo;
								}
								if( objectDataMap.bankProfile.OB_SettlementType__c == 'Postpagato')
								{
					//				//console.log('SETT_POSTPAGATO');
									component.set('v.objectDataMap.showPicklistPostpagato',true);
									component.get('v.postPagatoPickList').push(valueNetto);
									component.get('v.postPagatoPickList').push(valueLordo);
									objectDataMap.Configuration.OB_PBSettlementMethod__c  = component.get('v.settMethodPostPagatoValue');
									objectDataMap.Configuration.OB_InternationalSettlementMethod__c =component.get('v.settMethodPostPagatoValue');;
								}
							}
						}
					}
					//elena.preteni - end - 30/01/201
				
				} 
				//component.set("v.Spinner", false);
				console.log('showIBANSection before calling confirm btn funct: ' + component.get('v.showIBANSection'));
				//16/07/19  francesca.ribezzi adding else condition - performance merge
				component.set("v.loadComponent", true);
				//26/07/19 francesca.ribezzi calling checkTerminalsIBAN before confirmCreationBillingProfilesHelper
				component.set('v.objectDataMap',objectDataMap ); // antonio.vatrano 05/09/2019 WN-290
				if(isNewVisaMastercard && !isNewPOS){ //francesca.ribezzi 18/10/19 
					component.set("v.ibanDisabled", false);
				}else{
					helper.checkTerminalsIBAN(component,event);
				}
				
	
		}catch(err){
			component.set("v.Spinner", false);
			console.log('DOINTI_AFTER_ERROR: ' + err.message);
		}
		var t1 = performance.now();
		console.log("Call doInitAfter took " + (t1 - t0) + " milliseconds.");
	},
	    
    /* NEW STUFF */
    fieldCheck : function(component, event, helper) // onchange
	{
		// 25-09-2018-Salvatore P.-Check if fields are of max length and focus on next input
		var inputId 		= event.getSource().getLocalId();
		var inputValue 		= component.find(inputId).get("v.value");
		var maxLengthInput 	= component.find(inputId).get("v.maxlength");
		//francesca.ribezzi 28/08/19 - R1F3-7 - declaring variables:
		var nextInput;
		var nextInput2;

		try
		{
			inputValue=inputValue.toUpperCase();
		}
		catch(err)
		{
			//_utils.debug('err.message: ' + err.message);
		}

		if(inputId == 'euroControlCode')
		{
			component.set("v.objectDataMap.BillingProfilePOS.OB_EuroControlCode__c",inputValue);
			//francesca.ribezzi 28/08/19 - R1F3-7 - chaning document.getElementById to component.find
			nextInput=component.find('cin');
			if(maxLengthInput==inputValue.length)
			{
				nextInput.focus();
			}

		}
		else if(inputId == 'cin')
		{
			component.set("v.objectDataMap.BillingProfilePOS.OB_CINCode__c",inputValue);
			//francesca.ribezzi 28/08/19 - R1F3-7 - chaning document.getElementById to component.find
			nextInput=component.find('abi');
			nextInput2=component.find('cab');
			if(maxLengthInput==inputValue.length)
			{
				var disabledAbi = component.get("v.disabledAbi");
				if(disabledAbi == false)
				{	
					nextInput.focus();
				}
				else
				{
					nextInput2.focus();
				}
			}
		}
		else if(inputId == 'abi')
		{
			component.set("v.objectDataMap.BillingProfilePOS.OB_ABICode__c",inputValue);
			//francesca.ribezzi 28/08/19 - R1F3-7 - chaning document.getElementById to component.find
			nextInput=component.find('cab');
			if(maxLengthInput==inputValue.length)
			{
				nextInput.focus();
			}
		}
		else if(inputId == 'cab')
		{
			component.set("v.objectDataMap.BillingProfilePOS.OB_CABCode__c",inputValue);
			//francesca.ribezzi 28/08/19 - R1F3-7 - chaning document.getElementById to component.find
			nextInput=component.find('bankAccountNumber');
			if(maxLengthInput==inputValue.length)
			{
				nextInput.focus();
			}
		}
		else if(inputId == 'bankAccountNumber')
		{
			component.set("v.objectDataMap.BillingProfilePOS.OB_Bank_Account_Number__c",inputValue);
			//francesca.ribezzi 28/08/19 - R1F3-7 - chaning document.getElementById to component.find
			nextInput=component.find('headerInternational');
			if(maxLengthInput==inputValue.length)
			{
				// nextInput.focus();
			}
		}
	},

	completeIban : function(component,event,helper) //onblur
	{
		// 25-09-2018-Salvatore P.-Check mandatory fields and validations 
		var inputId 				= event.getSource().getLocalId();
		//26/0/19 francesca.ribezzi get input:
		var input 					= component.find(inputId);
		//_utils.debug("INPUD ID: "+inputId);
		var inputValue 				= component.find(inputId).get("v.value");
		var errorId 				= 'errorId' + inputId;
		var errorIdValidation 		= 'errorId' + inputId;
		var errorCustomLabel 		= '';
		var myDiv;
		var arrayIban 				= [];
		var arrayConverted 			= [];
		var countryCodeValue 		=	component.get("v.objectDataMap.BillingProfilePOS.OB_CountryCode__c");
		var euroControlCodeValue 	=	component.get("v.objectDataMap.BillingProfilePOS.OB_EuroControlCode__c");
		var cinCodeValue 			=	component.get("v.objectDataMap.BillingProfilePOS.OB_CINCode__c");
		var abiCodeValue 			=	component.get("v.objectDataMap.BillingProfilePOS.OB_ABICode__c");
		var cabCodeValue 			=	component.get("v.objectDataMap.BillingProfilePOS.OB_CABCode__c");
		var bankAccountNumberValue 	= 	component.get("v.objectDataMap.BillingProfilePOS.OB_Bank_Account_Number__c");
		var ibanComplete 			=	countryCodeValue + euroControlCodeValue + cinCodeValue + abiCodeValue + cabCodeValue + bankAccountNumberValue;

		var ibanLength = ibanComplete.length;
		//francesca.ribezzi 28/08/19 - R1F3-7 - setting error message to blank:
		input.setCustomValidity(''); 

		if(inputId == 'euroControlCode')
		{	
			var countryCode = component.find("countryCode").get("v.value");
			if(countryCode=="IT")
			{
				component.set("v.objectDataMap.BillingProfilePOS.OB_CountryCode__c","IT");
			}
			var typeInputValue = isNaN(inputValue);
			component.set("v.objectDataMap.BillingProfilePOS.OB_EuroControlCode__c", '');
			if(!inputValue)
			{				
				if(document.getElementById(errorIdValidation))
				{
					//francesca.ribezzi 28/08/19 -R1F3-7 removing error message if any
					input.setCustomValidity("");
					document.getElementById(errorIdValidation).remove();
				}
				//_utils.debug("control if fields value is null (onblur)");
				$A.util.addClass(input , 'slds-has-error'); //francesca.ribezzi 26/0719 changing comp
				errorCustomLabel = $A.get("$Label.c.MandatoryField");
				//francesca.ribezzi 28/08/19 setting standard custom validation error for lightning input
				//instead of using custom javascript!
				input.setCustomValidity(errorCustomLabel); 
				/*myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorId);
				myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
				var errorMessage = document.createTextNode(errorCustomLabel);
				myDiv.appendChild(errorMessage);
				var divAfter = component.find(inputId).getElement();
				divAfter.after(myDiv);*/

			}
			else if(inputValue.length > 0 && inputValue.length != 2 || typeInputValue==true)
			{
				if(document.getElementById(errorId))
				{
					//francesca.ribezzi 28/08/19 -R1F3-7 removing error message if any
					input.setCustomValidity("");
					document.getElementById(errorId).remove();
				}
				$A.util.addClass(input, 'slds-has-error');  //francesca.ribezzi 26/0719 changing comp
				errorCustomLabel = $A.get("$Label.c.TwoDigitLength");
				//francesca.ribezzi 28/08/19 setting standard custom validation error for lightning input
				//instead of using custom javascript!
				input.setCustomValidity(errorCustomLabel);
				/*myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorIdValidation);
				myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
				var errorMessage = document.createTextNode(errorCustomLabel);
				myDiv.appendChild(errorMessage);
				var divAfter = component.find(inputId).getElement();
				divAfter.after(myDiv);*/
			}
			else
			{
				if(document.getElementById(errorId))
				{
					//francesca.ribezzi 28/08/19 -R1F3-7 removing error message if any
					input.setCustomValidity("");
					document.getElementById(errorId).remove();
				}
				component.set("v.objectDataMap.BillingProfilePOS.OB_EuroControlCode__c", inputValue);
				//_utils.debug("euroControlCode value in object data map:  ",component.get("v.objectDataMap.BillingProfilePOS.OB_EuroControlCode__c"));
				if(ibanLength == 27)
				{
					helper.validateIban(component,event,helper,inputId);
				}
			}
		}
		else if(inputId == "cin")
		{
			var typeInputValue = isNaN(inputValue);
			component.set("v.objectDataMap.BillingProfilePOS.OB_CINCode__c", '');
			if(!inputValue)
			{				
				if(document.getElementById(errorIdValidation))
				{
					//francesca.ribezzi 28/08/19 -R1F3-7 removing error message if any
					input.setCustomValidity("");
					document.getElementById(errorIdValidation).remove();
				
				}
				//_utils.debug("control if fields value is null (onblur)");
				$A.util.addClass(input , 'slds-has-error');  //francesca.ribezzi 26/0719 changing comp
				errorCustomLabel = $A.get("$Label.c.MandatoryField");
				//_utils.debug("ERROR CUSTOM Label: "+errorCustomLabel);
				//francesca.ribezzi 28/08/19 -R1F3-7 - setting standard custom validation error for lightning input
				//instead of using custom javascript!
				input.setCustomValidity(errorCustomLabel);
				/*myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorId);
				myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
				var errorMessage = document.createTextNode(errorCustomLabel);
				myDiv.appendChild(errorMessage);
				var divAfter = component.find(inputId).getElement();
				divAfter.after(myDiv);*/

			}
			else if(inputValue.length > 0 && inputValue.length != 1 || typeInputValue==false)
			{
				if(document.getElementById(errorId))
				{
					//francesca.ribezzi 28/08/19 -R1F3-7 removing error message if any
					input.setCustomValidity("");
					document.getElementById(errorId).remove();
				}
				$A.util.addClass(input , 'slds-has-error'); //francesca.ribezzi 26/0719 changing comp
				errorCustomLabel = $A.get("$Label.c.OneCharLength");
				//francesca.ribezzi 28/08/19 setting - R1-F3-7 -  standard custom validation error for lightning input
				//instead of using custom javascript!
				input.setCustomValidity(errorCustomLabel);
				/*myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorIdValidation);
				myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
				var errorMessage = document.createTextNode(errorCustomLabel);
				myDiv.appendChild(errorMessage);
				var divAfter = component.find(inputId).getElement();
				divAfter.after(myDiv);*/
			}
			else
			{
				if(document.getElementById(errorId))
				{
					//francesca.ribezzi 28/08/19 -R1F3-7 removing error message if any
					input.setCustomValidity("");
					document.getElementById(errorId).remove();
				}
				component.set("v.objectDataMap.BillingProfilePOS.OB_CINCode__c", inputValue);
				//_utils.debug("cin value in object data map:  ",component.get("v.objectDataMap.BillingProfilePOS.OB_CINCode__c"));
				if(ibanLength == 27)
				{
					helper.validateIban(component,event,helper,inputId);
				}
			}
		}
		else if(inputId == "abi")
		{
			var typeInputValue = isNaN(inputValue);
			component.set("v.objectDataMap.BillingProfilePOS.OB_ABICode__c", '');
			if(!inputValue)
			{				
				if(document.getElementById(errorIdValidation))
				{
					//francesca.ribezzi 28/08/19 -R1F3-7 removing error message if any
					input.setCustomValidity("");
					document.getElementById(errorIdValidation).remove();
				}
				//_utils.debug("control if fields value is null (onblur)");
				$A.util.addClass(input , 'slds-has-error'); //francesca.ribezzi 26/0719 changing comp
				errorCustomLabel = $A.get("$Label.c.MandatoryField");
				//_utils.debug("ERROR CUSTOM Label: "+errorCustomLabel);
				//francesca.ribezzi 28/08/19 setting - R1-F3-7 -  standard custom validation error for lightning input
				//instead of using custom javascript!
				input.setCustomValidity(errorCustomLabel);
				/*myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorId);
				myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
				var errorMessage = document.createTextNode(errorCustomLabel);
				myDiv.appendChild(errorMessage);
				var divAfter = component.find(inputId).getElement();
				divAfter.after(myDiv);*/

			}
			else if(inputValue.length > 0 && inputValue.length != 5 || typeInputValue==true)
			{
				if(document.getElementById(errorId))
				{
					//francesca.ribezzi 28/08/19 -R1F3-7 removing error message if any
					input.setCustomValidity("");
					document.getElementById(errorId).remove();
				}
				$A.util.addClass(input , 'slds-has-error'); //francesca.ribezzi 26/0719 changing comp
				errorCustomLabel = $A.get("$Label.c.FiveDigitLength");
				//francesca.ribezzi 28/08/19 setting - R1-F3-7 -  standard custom validation error for lightning input
				//instead of using custom javascript!
				input.setCustomValidity(errorCustomLabel);
				/*myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorIdValidation);
				myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
				var errorMessage = document.createTextNode(errorCustomLabel);
				myDiv.appendChild(errorMessage);
				var divAfter = component.find(inputId).getElement();
				divAfter.after(myDiv);*/
			}
			else
			{
				if(document.getElementById(errorId))
				{
					//francesca.ribezzi 28/08/19 -R1F3-7 removing error message if any
					input.setCustomValidity("");
					document.getElementById(errorId).remove();
				}
				component.set("v.objectDataMap.BillingProfilePOS.OB_ABICode__c", inputValue);
				//_utils.debug("abi value in object data map:  ",component.get("v.objectDataMap.BillingProfilePOS.OB_ABICode__c"));
				if(ibanLength == 27 && component.get("v.disabledAbi")==false)
				{
					helper.validateIban(component,event,helper,inputId);
				}
			}
		}
		else if(inputId == "cab")
		{
			var typeInputValue = isNaN(inputValue);
			component.set("v.objectDataMap.BillingProfilePOS.OB_CABCode__c", '');
			if(!inputValue)
			{				
				if(document.getElementById(errorIdValidation))
				{
					//francesca.ribezzi 28/08/19 -R1F3-7 removing error message if any
					input.setCustomValidity("");
					document.getElementById(errorIdValidation).remove();
				}
				//_utils.debug("control if fields value is null (onblur)");
				$A.util.addClass(input, 'slds-has-error');  //francesca.ribezzi 26/0719 changing comp
				errorCustomLabel = $A.get("$Label.c.MandatoryField");
				//_utils.debug("ERROR CUSTOM Label: "+errorCustomLabel);
				//francesca.ribezzi 28/08/19 setting - R1-F3-7 -  standard custom validation error for lightning input
				//instead of using custom javascript!
				input.setCustomValidity(errorCustomLabel);
				/*myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorId);
				myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
				var errorMessage = document.createTextNode(errorCustomLabel);
				myDiv.appendChild(errorMessage);
				var divAfter = component.find(inputId).getElement();
				divAfter.after(myDiv);*/

			}
			else if(inputValue.length > 0 && inputValue.length != 5 || typeInputValue==true)
			{
				if(document.getElementById(errorId))
				{
					//francesca.ribezzi 28/08/19 -R1F3-7 removing error message if any
					input.setCustomValidity("");
					document.getElementById(errorId).remove();
				}
				$A.util.addClass(input, 'slds-has-error');  //francesca.ribezzi 26/0719 changing comp
				errorCustomLabel = $A.get("$Label.c.FiveDigitLength");
				//francesca.ribezzi 28/08/19 setting - R1-F3-7 -  standard custom validation error for lightning input
				//instead of using custom javascript!
				input.setCustomValidity(errorCustomLabel);
				/*myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorIdValidation);
				myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
				var errorMessage = document.createTextNode(errorCustomLabel);
				myDiv.appendChild(errorMessage);
				var divAfter = component.find(inputId).getElement();
				divAfter.after(myDiv);*/
			}
			else
			{
				if(document.getElementById(errorId))
				{
					//francesca.ribezzi 28/08/19 -R1F3-7 removing error message if any
					input.setCustomValidity("");
					document.getElementById(errorId).remove();
				}
				component.set("v.objectDataMap.BillingProfilePOS.OB_CABCode__c", inputValue);
				//_utils.debug("cab value in object data map:  ",component.get("v.objectDataMap.BillingProfilePOS.OB_CABCode__c"));
				if(ibanLength == 27)
				{
					helper.validateIban(component,event,helper,inputId);
				}
			}
		}
		else if(inputId == "bankAccountNumber")
		{
			component.set("v.objectDataMap.BillingProfilePOS.OB_Bank_Account_Number__c", inputValue);
			var typeInputValue = false;
			if( /[^a-zA-Z0-9]/.test(inputValue))
			{
				typeInputValue = true;
			}
			if(!inputValue)
			{				
				if(document.getElementById(errorIdValidation))
				{
					//francesca.ribezzi 28/08/19 -R1F3-7 removing error message if any
					input.setCustomValidity("");
					document.getElementById(errorIdValidation).remove();
				}
				//_utils.debug("control if fields value is null (onblur)");
				$A.util.addClass(input , 'slds-has-error');  //francesca.ribezzi 26/0719 changing comp
				errorCustomLabel = $A.get("$Label.c.MandatoryField");
				//_utils.debug("ERROR CUSTOM Label: "+errorCustomLabel);
				//francesca.ribezzi 28/08/19 setting - R1-F3-7 -  standard custom validation error for lightning input
				//instead of using custom javascript!
				input.setCustomValidity(errorCustomLabel);
				/*myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorId);
				myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
				var errorMessage = document.createTextNode(errorCustomLabel);
				myDiv.appendChild(errorMessage);
				var divAfter = component.find(inputId).getElement();
				divAfter.after(myDiv);*/

			}
			else if(inputValue.length > 0 && inputValue.length != 12 || typeInputValue==true)
			{
				if(document.getElementById(errorId))
				{
					//francesca.ribezzi 28/08/19 -R1F3-7 removing error message if any
					input.setCustomValidity("");
					document.getElementById(errorId).remove();
				}
				$A.util.addClass(input, 'slds-has-error');  //francesca.ribezzi 26/0719 changing comp
				errorCustomLabel = $A.get("$Label.c.TwelveDigitLength");
				//francesca.ribezzi 28/08/19 setting - R1-F3-7 -  standard custom validation error for lightning input
				//instead of using custom javascript!
				input.setCustomValidity(errorCustomLabel);
				/*myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorIdValidation);
				myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
				var errorMessage = document.createTextNode(errorCustomLabel);
				myDiv.appendChild(errorMessage);
				//var divAfter = component.find(inputId).getElement(); //26/07/19 francesca.ribezzi - commenting cause of api version
				//divAfter.after(myDiv);*/
			}
			else if(document.getElementById(errorId))
			{
				//francesca.ribezzi 28/08/19 -R1F3-7 removing error message if any
				input.setCustomValidity("");
				document.getElementById(errorId).remove();
			}
			component.set("v.objectDataMap.BillingProfilePOS.OB_Bank_Account_Number__c", inputValue);
			//_utils.debug("bankAccountNumber value in object data map:  ",component.get("v.objectDataMap.BillingProfilePOS.OB_Bank_Account_Number__c"));
			if(ibanLength == 27)
			{
				helper.validateIban(component,event,helper,inputId);
			}
		}
		else if(inputId == 'headerInternational')
		{
																				   
																					
																					 


			component.set("v.objectDataMap.BillingProfilePOS.OB_HeaderInternational__c", inputValue);
			var typeInputValue = false;
			if(/^[a-zA-Z0-9()""?!&% $£=^ °\/\\.'']+$/.test(inputValue))
			{
				typeInputValue = true;
			}
			if(!inputValue)
			{				
				if(document.getElementById(errorIdValidation))
				{
					//francesca.ribezzi 28/08/19 -R1F3-7 removing error message if any
					input.setCustomValidity("");											
					document.getElementById(errorIdValidation).remove();
				}
															  
			$A.util.addClass(component.find(input) , 'slds-has-error');  //francesca.ribezzi 26/0719 changing comp
			errorCustomLabel = $A.get("$Label.c.MandatoryField");
			//francesca.ribezzi 28/08/19 setting - R1-F3-7 -  standard custom validation error for lightning input
			//instead of using custom javascript!
			input.setCustomValidity(errorCustomLabel);											   
			/*myDiv = document.createElement('div');
			myDiv.setAttribute('id',errorId);
			myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
			var errorMessage = document.createTextNode(errorCustomLabel);
			myDiv.appendChild(errorMessage);
			var divAfter = component.find(inputId).getElement();
			divAfter.after(myDiv);*/
			}
			else if(typeInputValue==false)
			{
				if(document.getElementById(errorId))
				{
					//francesca.ribezzi 28/08/19 -R1F3-7 removing error message if any
					input.setCustomValidity("");			
					document.getElementById(errorId).remove();
				}
				$A.util.addClass(component.find(input) , 'slds-has-error');  //francesca.ribezzi 26/0719 changing comp
				errorCustomLabel = $A.get("$Label.c.errorSpecialCharacter");
				//francesca.ribezzi 28/08/19 setting - R1-F3-7 -  standard custom validation error for lightning input
				//instead of using custom javascript!
				input.setCustomValidity(errorCustomLabel);
				/*myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorIdValidation);
				myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
				var errorMessage = document.createTextNode(errorCustomLabel);
				myDiv.appendChild(errorMessage);
				var divAfter = component.find(inputId).getElement();
				divAfter.after(myDiv);*/
			}
			else
			{
				if(document.getElementById(errorId))
				{
					//francesca.ribezzi 28/08/19 -R1F3-7 removing error message if any
					input.setCustomValidity("");						
					document.getElementById(errorId).remove();
				}
				component.set("v.objectDataMap.BillingProfilePOS.OB_HeaderInternational__c", inputValue);
																																				   
			}
		}
    },						
    // ID 155, Doris Dongmo <doris.tatiana.dongmo@accenture.com>, 08/04/2019 Start
	controlIsSpecialCharacter:function(component,event,helper){

		var inputIdVar          = component.find('prelimVerifCode');
		var inputValue 	        = inputIdVar.get("v.value");
		var errorIdValidation 	= 'errorId' + inputIdVar;
		var typeInputValue      = false;	
						
		// ID 155, Doris Dongmo <doris.tatiana.dongmo@accenture.com>, 03/05/2019, update regex
		if(/^[a-zA-Z0-9()?@_:\-!&% $+ \/°.'',]+$/.test(inputValue) ) 
		{
			typeInputValue = true;
						
		}
		if(!inputValue)
		{				
			// BOOLEAN TO SHOW ERROR MESSAGE - BOOLEAN TO HIDE  SPECIAL CHARACTER ERROR MESSAGE - ADD CLASS				
			helper.controlIsSpecialCharacterHelper(component, true,false,inputIdVar);
			
		}

		else if(typeInputValue==false)
		{
			// BOOLEAN TO HIDE ERROR MESSAGE - BOOLEAN TO SHOW  SPECIAL CHARACTER ERROR MESSAGE - ADD CLASS
			helper.controlIsSpecialCharacterHelper(component, false,true,inputIdVar);
			component.set("v.objectDataMap.errorDateMap."+errorIdValidation, true);
		}
		else
		{
			// BOOLEAN TO HIDE ERROR MESSAGE -  BOOLEAN TO HIDE  SPECIAL CHARACTER ERROR MESSAGE - REMOVE CLASS
			helper.controlIsSpecialCharacterHelper(component, false, false,inputIdVar);
			component.set("v.objectDataMap.errorDateMap."+errorIdValidation, false);
		}
	},
		//ID 155, Doris Dongmo <doris.tatiana.dongmo@accenture.com>,  08/04/2019 .....END
																					   
        setPickListValue : function(component,event,helper)
        {	var currentId = event.getSource().getLocalId();
                                                  
            // 25-09-2018-Salvatore P.-Set of picklist value
            component.set("v.objectDataMap.Configuration.OB_Report_Type__c", component.get("v.objectDataMap.OrderHeader.OB_Report_Type__c"));
                                                                                                                                 
            $A.util.removeClass(component.find(currentId) , 'slds-has-error');
            //RECREATE THE SAME ID OF ERROR MESSAGE
            var errorId = 'errorId'+ currentId;
            if(document.getElementById(errorId)!=null){
                                                       
                document.getElementById(errorId).remove();
			}
			//START francesca.ribezzi 18/07/19 deleting confirmOperationData button
	//		helper.confirmCreationBillingProfilesHelper(component,event);
        },
    
        setRedBorderoperationalData: function(component, event, helper) 
        {
             helper.setRedBorderHelper(component,event);
        },
        
                                                                                                                     
        /* START 	micol.ferrari 01/10/2018 - CREATION OF BILLING PROFILES */
        confirmCreationBillingProfiles: function(component, event, helper) 
        {
            try{
                helper.confirmCreationBillingProfilesHelper(component,event);
            }catch(err){
                console.log('ERROR_MESSAGE_CALL_HELPER: ' + 	err.message);
            }
            
        },
    /* END	 	micol.ferrari 01/10/2018 - CREATION OF BILLING PROFILES */
	
	picklistPrepagatoChange: function(component, event, helper) {
		var currentId = event.getSource().getLocalId();
		var postPagatoValue = component.get("v.settMethodPostPagatoValue");
		component.set("v.objectDataMap.Configuration.OB_PBSettlementMethod__c", postPagatoValue);
		component.set("v.objectDataMap.Configuration.OB_InternationalSettlementMethod__c", postPagatoValue);
		$A.util.removeClass(component.find(currentId) , 'slds-has-error');
        //RECREATE THE SAME ID OF ERROR MESSAGE
        var errorId = 'errorId'+ currentId;
        if(document.getElementById(errorId)!=null){
            //_utils.debug("errorID . " + errorId);
            document.getElementById(errorId).remove();
		}
		//START francesca.ribezzi 18/07/19 deleting confirmOperationData button
	//	helper.confirmCreationBillingProfilesHelper(component,event);
	},
	removeRedBorder: function (component, event , helper){
       
        helper.removeRedBorder(component, event , helper);
    },
    
    notBlank: function (component, event , helper){
    	var dateValue = event.getSource().get("v.value");
    	var currentId = event.getSource().getLocalId();
    	//_utils.debug('dateValue:: '+dateValue);
    	if(!dateValue){
    		component.find(currentId).set("v.value", component.get("v.orderCreatedDate"));
    	} else {
			 helper.removeRedBorderDate(component, event , helper);
			 //START francesca.ribezzi 18/07/19 deleting confirmOperationData button
		//	 helper.confirmCreationBillingProfilesHelper(component,event);
    	}
    },
    
    //francesca.ribezzi -  checking if the value is a terminal id and if it is correct:
  /*  checkInputValue: function(component, event, helper) {
    	//_utils.debug("into checkInputValue");
    	var value = event.target.value;//event.getSource().get("v.value");
    	var attributeIndex = JSON.stringify(event.target.id); 
        var listOfItems = component.get("v.posList");
        var parentIndex = document.getElementById(event.target.id).name;
        //_utils.debug("parentIndex: " + parentIndex);
        var pos1 = attributeIndex.indexOf("_")+1;
        var length1 = attributeIndex.indexOf("_",pos1)-1;
        var tempStr = attributeIndex.substr(length1);
        attributeIndex = tempStr.substr(0,tempStr.indexOf('_'));
        var attName = document.getElementById(attributeIndex+'_attName').textContent;
        var itemToUpdate = listOfItems[parentIndex];
        var errMsg= document.getElementById(event.target.id+'_ErrorTerminalId');
        //checking if this is the terminal id: 
	 //   if(value.length > 2){
	    	if(value.length != 8){
	    		errMsg.innerHTML= 'Terminal ID must be 8 characters long.';
	    	}
	  //  }
		
    },*/
    onChangeAttributeValueTerminalId: function(component, event, helper){
		try{ //francesca.ribezzi 26/09/19 - WN-500 - adding try catch   
			//francesca.ribezzi - new list composed by vas and pos with terminal ids:
			var terminaIdItemsMap = component.get("v.terminaIdItemsMap");
			var itemId = document.getElementById(event.target.id).name; 
			var mapItemIdSuccessTerminalCall = component.get("v.mapItemIdSuccessTerminalCall");
			//RESET Error Message if updating terminal ID
			var itemToUpdate = terminaIdItemsMap[itemId];
			var errMsg= document.getElementById(event.target.id+'_ErrorTerminalId');
			//checking if this is the terminal id: 
			//francesca.ribezzi - removing error class from input:
			var inputValue = event.target.value;
				if(/^[0-9]*([,][0-9]{1,3}|)$/.test(event.target.value)){ 
					if(inputValue.length == 8){
						document.getElementById(event.target.id).classList.remove("borderError");
						//START francesca.ribezzi 26/09/19 - WN-500 - removing attributeIndex and setting the term id value:
						for(var i = 0; i<itemToUpdate.listOfAttributes.length; i++ ){
							if(itemToUpdate.listOfAttributes[i].fields.name == 'Terminal Id'){
								itemToUpdate.listOfAttributes[i].fields.value =  event.target.value; 
								break;
							}
						}	
						//END francesca.ribezzi 26/09/19 - WN-500
						component.set("v.itemToUpdate", itemToUpdate);
						//francesca.ribezzi 30/09/19 update terminaIdItemsMap:
						component.set("v.terminaIdItemsMap", terminaIdItemsMap);
						errMsg.innerHTML = '';
					}else{
						if(inputValue.length == 0){
							errMsg.innerHTML = '';
							document.getElementById(event.target.id).classList.remove("borderError");
						}else{
							errMsg.innerHTML = $A.get("$Label.c.OB_EightCharError");
							document.getElementById(event.target.id).classList.add("borderError");
						}
					}
					

				}
				else{
					var errorMessage = $A.get("$Label.c.OB_invalidValue");
					errMsg.innerHTML = errorMessage;
					//event.target.value = '';
					document.getElementById(event.target.id).classList.add("borderError");
				}
				
			mapItemIdSuccessTerminalCall[itemToUpdate.fields.id] = false;
			component.set("v.mapItemIdSuccessTerminalCall", mapItemIdSuccessTerminalCall);
		}catch(err){
			console.log('ERROR - onChangeAttributeValueTerminalId:  ' + err.message );                                      
	 	}
	},
	// Daniele Gandini <daniele.gandini@accenture.com> - 20/05/2019 - TerminalsReplacement - Logic for getting termId from selectList and set into attribute field - START
	setTermId : function(component,event,helper){
		//francesca.ribezzi 15/07/19 changing event.target.value into event.getSource cause of API version.
		var attributeIndex = event.getSource().get("v.name"); // POS index
		var termIdValue = event.getSource().get("v.value"); // termId
		console.log("term id = " + termIdValue);
		var contextOutput = component.get("v.contextOutput");
		var mapItemIdSuccessTerminalCall = component.get("v.mapItemIdSuccessTerminalCall");
		var listOfItems = [];
		listOfItems = component.get("v.posList");
		console.log("posList: " + JSON.stringify(listOfItems));
		attributeIndex = JSON.stringify(event.getSource().get("v.name"));
        attributeIndex = attributeIndex.substr(0,attributeIndex.indexOf('-'));
        var itemName = attributeIndex.split("_").pop(); //VAS or POS
		attributeIndex = attributeIndex.substr(1,attributeIndex.indexOf('_')-1);
		var termIdMap = component.get("v.termIdMap");
		// create a list with term id values already used in a POS to check them
		var termIdUsed = [];

		console.log("termIdUsed" + JSON.stringify(termIdUsed));
		var itemToUpdate = listOfItems[parseInt(attributeIndex)];
		
		for(var j = 0; j < itemToUpdate.listOfAttributes.length; j++){
			if(itemToUpdate.listOfAttributes[j].fields.name == 'Terminal Id'){
				itemToUpdate.listOfAttributes[j].fields.value = termIdValue; //22/07/19 francesca.ribezzi changing event.target.value into event.getSource cause of API version.
				// component.set("v.Spinner",false);
				break;
			}
		}
		termIdMap[attributeIndex] = termIdValue;
		component.set("v.termIdMap", termIdMap);
		console.log("updated term id map: " + JSON.stringify(component.get("v.termIdMap")));
		component.set("v.posList",listOfItems);
		var siaCodesFromTerminals = component.get("v.siaCodesFromTerminals");
		for( var key in siaCodesFromTerminals){
			for(var j = 0; j < itemToUpdate.listOfAttributes.length; j++){
				if(key == itemToUpdate.listOfAttributes[j].fields.value){
					for(var k in siaCodesFromTerminals[key]){
						for(var i = 0; i < itemToUpdate.listOfAttributes.length; i++){
							if(itemToUpdate.listOfAttributes[i].fields.name == k){
								itemToUpdate.listOfAttributes[i].fields.value = siaCodesFromTerminals[key][k];
								console.log('itemToUpdate.listOfAttributes[j].fields.value'+itemToUpdate.listOfAttributes[i].fields.value);
							}
						}
					}
					console.log('mappa sia'+ JSON.stringify(siaCodesFromTerminals[key]));
				}
			}
		}
		// component.set("v.isEnd", true);        
		mapItemIdSuccessTerminalCall[itemToUpdate.fields.id] = true;   
		component.set("v.itemToUpdate", itemToUpdate);

		//francesca.ribezzi 10/07/19 deleting this event - not needed anymore
		/*var changeAttributeEvent = 	$A.get("e.NE:Bit2win_Event_AttributeChanged");
		changeAttributeEvent.setParams({
			'itemChanged': itemToUpdate,
			'Context_Output':contextOutput
		});
		changeAttributeEvent.fire();*/
	// Daniele Gandini <daniele.gandini@accenture.com> - 20/05/2019 - TerminalsReplacement - Logic for getting termId from selectList and set into attribute field - START
    },
	// Doris D.  ...25/03/2019... ::::::: Start//
	open : function (component,event,helper){
           
		component.set("v.showMessage", true);
	
	},
	
	close : function (component,event,helper){
		component.set("v.showMessage", false);
	
	},
	//D.F. _ 26-03-2019 ManageRacSia v4 _ START
	showIbanSelModal: function(component, event, helper) {
    	component.set("v.showIbanSelModal", true);							
																																									   
    },										  
	closeIbanSelModal: function(component, event, helper) {
		   
		component.set("v.showIbanSelModal",false);		
 
	},
	getSelectedIBAN: function(component, event, helper) {
        helper.getSelectedOption(component, event);
	},
	//D.F. _ END	
	/*
    *@author francesca.ribezzi
	*@date 31/07/2019
	*@defect WN-211
    *@description 	passing goNext attribute to ManageRacSIA component to set red border on invalid inputs once next button is clicked: 
    *@history 31/07/2019 Method created
    */
    goNextStep	: function(component, event, helper) {
		component.set("v.goNext", true);
	},
	/*
    *@author francesca.ribezzi
	*@date 26/09/2019
	*@defect WN-368
    *@description 	method used to check if the inserted preliminary verification code is a correct value
    *@history 26/09/2019 Method created
    */
	onChangePrelimVerifCode	: function(component, event, helper) {
		var input = component.find('prelimVerifCode');
		var value = component.find("prelimVerifCode").get("v.value");
		if (value.length == 7 && !isNaN(value)){ //if it's numeric and its length is 7 --> OK!
			input.setCustomValidity(""); 
			component.set("v.objectDataMap.OrderHeader.OB_PreliminaryVerificationCode__c", value); 
			$A.util.removeClass(input, 'slds-has-error');  
			component.set("v.isOkPrelimVerifCode", true);
        }else{
			var errorLabel = $A.get("$Label.c.OB_enterSevenChar");   
			input.setCustomValidity(errorLabel);  
			$A.util.addClass(input, 'slds-has-error');  
			component.set("v.isOkPrelimVerifCode", false);
        }
	},

	/*
	*	Author 		: 	Morittu Andrea
	*	Date		:	07-Nov-2019
	*	Task		:	EVO_Backlog 143
	*	Description	:	On change function Promo amex lightning select
	*/
	onChangePromoloyaltyOffer : function(component, event, helper) {
		var currentOptionSelection = component.find('PromoLoyaltyOffer').get('v.value');
		if(!$A.util.isEmpty(currentOptionSelection)) {
			helper.promoLoyaltySelection_Helper(component, event, helper, currentOptionSelection);
		}
	},
})