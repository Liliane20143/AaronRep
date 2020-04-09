({
	doInit : function(component, event, helper) {

		var userLicense = component.get("v.userLicense");	// antonio.vatrano 09/05/2019 r1f2-106 
		var MapAttributeItems = {};
		var childItem = component.get("v.childItem");
		var approvalTypePricing = component.get("v.approvalTypePricing");
		var approvalStatus = component.get("v.approvalStatus");
		var approvalStatusIsPricing = (approvalStatus == 'In Approvazione Pricing' || approvalStatus == 'Rigettato Pricing');
		var showStartDate = component.get("v.showStartDate");
		var approvalLevelMap = {}; //francesca.ribezzi 26/11/19 - performance - adding approvalLevelMap

		for(var i = 0; i < childItem.listOfAttributes.length; i++ ){
			var att = childItem.listOfAttributes[i];
			
			var minAbsolute = parseFloat((''+att.attribute.fields.OB_MIn_Absolute__c).replace(',','.')); //DO NOT CORRECT it is REALLY like that 
			var maxAbsolute =  parseFloat((''+att.attribute.fields.OB_Max_Absolute__c).replace(',','.'));
			var maxPrice =  parseFloat((''+att.attribute.fields.OB_Massimale__c).replace(',','.'));
			//giovanni spinelli - start - 16/09/2019 - store default value
			var minThresholdMap = {};  //francesca.ribezzi 26/11/19 - performance - adding max and min thresholds map + approval level.
			var maxThresholdMap = {};
/* 
			* GIOVANNI SPINELLI - START - 20/11/2019 - PROD-127
			* change how to create defaultValue because if there is a number
			* like 12.000 it becomes 12 and the approval check doesn't work
			*/
			try{
				var tmpValueDefault = null;
				var attributeFieldValue = att.attribute.fields.previousvalue;
				
				var defaultValue = helper.createValueToCheck( component , attributeFieldValue , tmpValueDefault , defaultValue);
				
			}catch(err){
				console.log('error in init'+err.message);
			}	
						//GIOVANNI SPINELLI - END - 20/11/2019 - CHANGHE VALUETOCHECK WHEN VALUE IS LIKE 1.000

			//giovanni spinelli - end - 16/09/2019 - store default value
			var status;
            
        //START hotfix/Pricing approval helper 18.04.2019 Zuzanna Urban <z.urban@accenture.com> Select thresholds 
     	var minThresholdOne =  parseFloat((''+att.attribute.fields.OB_Min_Threshold__c).replace(',','.'));
     	var maxThresholdOne =  parseFloat((''+att.attribute.fields.OB_Max_Threshold__c).replace(',','.'));
     	var minThresholdTwo =  parseFloat((''+att.attribute.fields.OB_MinThresholdL2__c).replace(',','.'));
     	var maxThresholdTwo =  parseFloat((''+att.attribute.fields.OB_MaxThresholdL2__c).replace(',','.'));
     	var minThresholdThree =  parseFloat((''+att.attribute.fields.OB_MinThresholdL3__c).replace(',','.'));
     	var maxThresholdThree =  parseFloat((''+att.attribute.fields.OB_MaxThresholdL3__c).replace(',','.'));
        	
		var minThreshold = null;
     	var maxThreshold = null;
     
     	var minThresholdList = new Array( );
        var maxThresholdList = new Array( );
		 //START hotfix/Pricing-approval3  18.04.2019 francesca.ribezzi checking if these values are numbers:
		 //francesca.ribezzi 26/11/19 - performance - adding values to minThresholdMap and maxThresholdMap
     	if ( !isNaN(minThresholdOne ))
        {
			minThresholdList.push( minThresholdOne );
			minThresholdMap['1'] = minThresholdOne; // stands for L1
        }
     	if ( !isNaN(minThresholdTwo ))
        {
			minThresholdList.push( minThresholdTwo );
			minThresholdMap['2'] = minThresholdTwo; // stands for L2

        }
     	if ( !isNaN(minThresholdThree))
        {
			minThresholdList.push( minThresholdThree );
			minThresholdMap['3'] = minThresholdThree; // stands for L3

        }
        if ( !isNaN(maxThresholdOne))
        {
			maxThresholdList.push( maxThresholdOne );
			maxThresholdMap['1'] = maxThresholdOne; // stands for L1

        }
     	if ( !isNaN(maxThresholdTwo))
        {
			maxThresholdList.push( maxThresholdTwo );
			maxThresholdMap['2'] = maxThresholdTwo; // stands for L2

        }
     	if ( !isNaN(maxThresholdThree))
        {
			maxThresholdList.push( maxThresholdThree );
			maxThresholdMap['3'] = maxThresholdThree; // stands for L3

        } 
     
        if( minThresholdList != undefined || minThresholdList.length != 0 )
        {
            minThreshold = Math.max(...minThresholdList);
        }
        if( maxThresholdList != undefined || maxThresholdList.length != 0 )
        {
            maxThreshold = Math.min(...maxThresholdList);
		}     
		//END hotfix/Pricing-approval3  18.04.2019 francesca.ribezzi
        //STOP hotfix/Pricing approval helper 18.04.2019 Zuzanna Urban <z.urban@accenture.com>
		/* 
		 * GIOVANNI SPINELLI - START - 20/11/2019 - PROD-127
		 * change how to create valueToCheck because if there is a number
		 * like 12.000 it becomes 12 and the approval check doesn't work
		 */
		try{
			var tmpValue = null;
			var attributeFieldValue = att.attribute.fields.value
			
			var valueToCheck = helper.createValueToCheck( component , attributeFieldValue , tmpValue , valueToCheck);
			
		}catch(err){
			console.log('error in init'+err.message);
		}	
			
				//GIOVANNI SPINELLI - END - 20/11/2019 - CHANGHE VALUETOCHECK WHEN VALUE IS LIKE 1.000

			//04/01/19 francesca.ribezzi - checking status only if the action is Add or undefined or the old value is not equal to the new one:
		if(childItem.item.fields.action == 'Add' ||att.attribute.fields.Old_Value__c != att.attribute.fields.value ||childItem.item.fields.action == undefined){ 
	//	if(att.attribute.fields.Old_Value__c != att.attribute.fields.value){ 		
				if( !isNaN(minAbsolute) && valueToCheck < minAbsolute){
				//red error
				status = 'error';
			//	errorList.push(status);
				}
				else if( !isNaN(maxAbsolute) && valueToCheck > maxAbsolute){
					//red error
					status = 'error';
				//	errorList.push(status);
				}
				//START francesca.ribezzi 06/12/19 - PERF-24 - adding maxPrice check
				else if( !isNaN(maxPrice) && valueToCheck > maxPrice){ 
					//red error
					status = 'error';
				}
				//END francesca.ribezzi 06/12/19 - PERF-24
				else if( !isNaN(minThreshold) && valueToCheck < minThreshold){
					//yellow error
					status = 'warning';
				}
				else if( !isNaN(maxThreshold) && valueToCheck > maxThreshold){
					//yellow error
					status = 'warning';
				}
				//giovanni spinelli - start - 16/09/2019  - set new status when change value but it is okay
				else if(valueToCheck != defaultValue && defaultValue != undefined && !isNaN(defaultValue ) ){
					status = 'ok_change';
				}
				//giovanni spinelli - end - 16/09/2019  - set new status when change value but it is okay
				else{
					status = 'ok';
				}
			
			}else{
				status = 'ok';
			}	
			//console.log('@@@status: ' + status);	//davide.franzini 20/11/2019
			//push additional node
			//start antonio.vatrano 09/05/2019 r1f2-106
			if(userLicense != 'Salesforce'){
				att.attribute.fields.status = status; //francesca.ribezzi 26/11/19 - performance - calling checkThresholds
				var approvalLevel = '';
				if(status == 'warning'){   //francesca.ribezzi 06/12/19 - Perf-24 - calling checkThresholds only if the status is warning
					approvalLevel = helper.checkThresholds(component,event,minThresholdMap, maxThresholdMap, valueToCheck);   
					//	Start antonio.vatrano 30/12/2019 R1P-357
					var approvalOrderRulesEvent = $A.get("e.c:OB_ApprovalOrderRulesEvent");
					approvalOrderRulesEvent.setParams({ 
						"checkAttributeRules": status, 
						"IdChildItem" : childItem.item.fields.itemCode
					});
					approvalOrderRulesEvent.fire();
				}
				if(status == 'error'){   
					var approvalOrderRulesEvent = $A.get("e.c:OB_ApprovalOrderRulesEvent");
					approvalOrderRulesEvent.setParams({ 
						"checkAttributeRules": status, 
						"IdChildItem" : childItem.item.fields.itemCode
					});
					approvalOrderRulesEvent.fire();   
				}
				//	End antonio.vatrano 30/12/2019 R1P-357
				var key = childItem.item.fields.itemCode+'_'+att.attribute.fields.idfamily+'_'+att.attribute.fields.propid;
				approvalLevelMap[key] = approvalLevel;	
			}else{
				att.attribute.fields.status = 'ok';
			}
			//End antonio.vatrano 09/05/2019 r1f2-106 

			att.attribute.isWarningApproval = (att.attribute.fields.status == 'warning' && approvalTypePricing);
			//console.log('approvalStatusIsPricing is : ' + approvalStatusIsPricing); //davide.franzini 20/11/2019
			if(!approvalStatusIsPricing){
				att.attribute.isWarningApproval = false;
			}
			//francesca.ribezzi 30/10/19 childItemId changed to childItem.ItemCode 
			MapAttributeItems[childItem.item.fields.itemCode+'_'+att.attribute.fields.idfamily+'_'+att.attribute.fields.propid] = i; 	 	
		}
		//francesca.ribezzi START 21/03/19 
		if(showStartDate && !$A.util.isEmpty(childItem.item.fields.NE__StartDate__c)){
			var date = childItem.item.fields.NE__StartDate__c;
			var year = date.substring(0, 4);
			//console.log("year: " + year);
			var month = date.substring(5, 7);
			//console.log("month: " + month);
			var day = date.substring(8, 10); 
			//console.log("day: " + day);
			var newDateFormat = day +'-'+ month+'-' + year;
			//_utils.debug("newDateFormat: " + newDateFormat);//davide.franzini 20/11/2019
			childItem.item.fields.newStartDateFormat = newDateFormat;
		}
		//END
		component.set("v.childItem",childItem);
		component.set("v.childApprovalLevelMap", approvalLevelMap);   //francesca.ribezzi 26/11/19 - performance - setting approvalLevelMap

		component.set("v.MapAttributeItems", MapAttributeItems);

		//creating lists:
		var childItem = component.get("v.childItem");
		var firstList = [];
		var secondList = [];
		var thirdList = [];
		var beforeGrid = true;
		var inGrid = false;
		var afterGrid = false;
		for(var i = 0; i < childItem.listOfAttributes.length; i++ ){
			var att = childItem.listOfAttributes[i];
			if(!att.attribute.openGrid && beforeGrid){
				firstList.push(att);
			}
			if(att.attribute.openGrid){
				beforeGrid = false;
				inGrid = true;
			}
			if(!att.attribute.closeGrid && inGrid){
				secondList.push(att);
			}
			if(att.attribute.closeGrid){
				inGrid = false;
				afterGrid = true;
			}
			if(afterGrid){
				thirdList.push(att);
			}
		}
		
		component.set("v.firstList", firstList);
		component.set("v.secondList", secondList);
		component.set("v.thirdList", thirdList);

	},

	//LUBRANO 16/01/2019 Libreria Log
	logInit: function(component){
		_utils.logInit(component.getName());
	},

	
	onChangeAttributeValue: function(component, event, helper){
    	    	
    	var MapAttributeItems = component.get("v.MapAttributeItems");
    	
		var userLicense = component.get("v.userLicense");		// antonio.vatrano 09/05/2019 r1f2-106
    	
        var attributeIndex = event.target.id;
        var mapIndex =  MapAttributeItems[attributeIndex];        
        var childItem = component.get("v.childItem");
         
        var itemToUpdate = childItem.item;
        if(itemToUpdate != null){
        	
        	var errorIndex = document.getElementById(attributeIndex+'_errorPOS');
		    
		    var input = document.getElementById(event.target.id); 
		    var valueToCheck = event.target.value;
		    var attributeCodeOnlyInt = 'gratuita';
		    //error	
		    var attributeFields = itemToUpdate.listOfAttributes[mapIndex].fields;
			var newValue = parseFloat( (''+valueToCheck).replace(',','.') ); //francesca.ribezzi 25/11/19 - performance - adding new and old value to pass these to FlowCart 
			var oldValue = parseFloat((''+attributeFields.Old_Value__c).replace(',','.')); 
		    
		    //check the attribute codice_Sfd if == gratuita.ToLowerCase() then new regex
		    if(itemToUpdate.listOfAttributes[mapIndex].fields.OB_Attribute_Code__c.toLowerCase() == attributeCodeOnlyInt)
		    {
		    	//match the regex	
		    	//if(/^[1-9]+[0-9]*$|\s+/.test(event.target.value)){
				if(/^[0-9]*([,][0-9]{1,3}|)$/.test(event.target.value) ){
					if($A.util.isEmpty(event.target.value)){
						//_utils.debug("value is empty!!");//davide.franzini 20/11/2019
						event.target.value = 0; 
					}
		    		//reset msg setting border in helper method
			    	if(errorIndex != null){
					   errorIndex.classList.add("hidden");
				    }
				    
				    //check here to know if the input value should be integer or float..
				    
				    var isAuraId = false;   
			    	
			    	//error	
			        itemToUpdate.listOfAttributes[mapIndex].fields.value =  event.target.value;
			        //
			        
			        component.set("v.itemToUpdate", itemToUpdate);
			        var checkAttributeRulesToSend = component.get('v.checkAttributeRules');    
				    

					   //START EVENT 
					var approvalOrderRulesEvent = $A.get("e.c:OB_ApprovalOrderRulesEvent");
					approvalOrderRulesEvent.setParams({ 
						"checkAttributeRules": checkAttributeRulesToSend, //francesca.ribezzi 30/10/19 childItemId changed to childItem.ItemCode
						"IdChildItem" : itemToUpdate.fields.itemCode+'_'+itemToUpdate.listOfAttributes[mapIndex].fields.idfamily+'_'+itemToUpdate.listOfAttributes[mapIndex].fields.propid,
						"ChildItem": itemToUpdate,
						"ChildItemAttribute": itemToUpdate.listOfAttributes[mapIndex], 
						"newValue" : newValue, //francesca.ribezzi 25/11/19 - performance - adding new and old value to pass these to FlowCart 
						"oldValue" : oldValue
					});
				    approvalOrderRulesEvent.fire();
				    //END event
			    	
		    	}
		    	//regex check was false
		    	else{
		    		if(errorIndex != null){
					   errorIndex.classList.remove("hidden");
					   input.classList.remove("borderWarning");
					   input.classList.add("borderError");
				   }   
				  /* if($A.util.isEmpty(event.target.value)){
					_utils.debug("value is empty!!");*/
					//06/02/19
					event.target.value = 0; 
				//   } 
					//component.set('v.checkAttributeRules','error');
				   //event.target.value = itemToUpdate.listOfAttributes[attributeIndex].fields.value; 
				   
				   component.set('v.checkAttributeRules','ok');
	 
				   //firing approvalOrderRulesEvent event to parent OB_FlowCart
				   var checkAttributeRulesToSend = component.get("v.checkAttributeRules");
				   //START EVENT 
					var approvalOrderRulesEvent = $A.get("e.c:OB_ApprovalOrderRulesEvent");
					approvalOrderRulesEvent.setParams({ 
						"checkAttributeRules": checkAttributeRulesToSend,//francesca.ribezzi 30/10/19 childItemId changed to itemToUpdate.ItemCode
						"IdChildItem" : itemToUpdate.fields.itemCode+'_'+itemToUpdate.listOfAttributes[mapIndex].fields.idfamily+'_'+itemToUpdate.listOfAttributes[mapIndex].fields.propid,
						"ChildItem": itemToUpdate,
						"ChildItemAttribute": itemToUpdate.listOfAttributes[mapIndex],
						"newValue" : newValue, //francesca.ribezzi 25/11/19 - performance - adding new and old value to pass these to FlowCart 
						"oldValue" : oldValue
					});
			    	approvalOrderRulesEvent.fire();
			    	//END event
		    	} 
		    }
		    else{
		    	//_utils.debug("into first if else##");
		    	//match the regex	
		    //	if(/^[0-9]*([,][0-9]{1,3}|)$|\s+/.test(event.target.value)){ 	    
				if(/^[0-9]*([,][0-9]{1,3}|)$/.test(event.target.value) ){ 		
					if($A.util.isEmpty(event.target.value)){
						//_utils.debug("value is empty!!");//davide.franzini 20/11/2019
						event.target.value = 0; 
					}
		    		//reset msg setting border in helper method
			    	if(errorIndex != null){
					   errorIndex.classList.add("hidden");
				    }
				    
				    //check here to know if the input value should be integer or float..
				    
				    var isAuraId = false;   
			    	//CHECK RULES
			    	//start antonio.vatrano 09/05/2019 r1f2-106
					if(userLicense=='Salesforce'){
						component.set('v.checkAttributeRules', 'ok');  
					}
					//End antonio.vatrano 09/05/2019 r1f2-106
			    	//-------
			    	
			    	//error	
			        itemToUpdate.listOfAttributes[mapIndex].fields.value =  event.target.value;
			        //
			        
			        component.set("v.itemToUpdate", itemToUpdate);
			        var checkAttributeRulesToSend = component.get('v.checkAttributeRules');    
				    
					//START EVENT 
					var approvalOrderRulesEvent = $A.get("e.c:OB_ApprovalOrderRulesEvent");
					approvalOrderRulesEvent.setParams({ 
						"checkAttributeRules": checkAttributeRulesToSend,//francesca.ribezzi 30/10/19 childItemId changed to itemToUpdate.ItemCode
						"IdChildItem" : itemToUpdate.fields.itemCode+'_'+itemToUpdate.listOfAttributes[mapIndex].fields.idfamily+'_'+itemToUpdate.listOfAttributes[mapIndex].fields.propid,
						"ChildItem": itemToUpdate,
						"ChildItemAttribute": itemToUpdate.listOfAttributes[mapIndex],
						"newValue" : newValue, //francesca.ribezzi 25/11/19 - performance - adding new and old value to pass these to FlowCart 
						"oldValue" : oldValue
					});
				    approvalOrderRulesEvent.fire();
				    //END event   
			    	
			   }
			   //regex check was false
			   else{ 			  
				if(errorIndex != null){
					errorIndex.classList.remove("hidden");
					input.classList.remove("borderWarning");
					input.classList.add("borderError");
				}   
				event.target.value = 0;
			   // event.target.value = itemToUpdate.listOfAttributes[mapIndex].fields.value; 
				
				component.set('v.checkAttributeRules','ok');
				   //event.target.value = itemToUpdate.listOfAttributes[attributeIndex].fields.value; 
				   
				 
	
				   //firing approvalOrderRulesEvent event to parent OB_FlowCart
				   var checkAttributeRulesToSend = component.get("v.checkAttributeRules");
				   //START EVENT 
					var approvalOrderRulesEvent = $A.get("e.c:OB_ApprovalOrderRulesEvent");
					approvalOrderRulesEvent.setParams({ 
						"checkAttributeRules": checkAttributeRulesToSend,//francesca.ribezzi 30/10/19 childItemId changed to itemToUpdate.ItemCode
						"IdChildItem" : itemToUpdate.fields.itemCode+'_'+itemToUpdate.listOfAttributes[mapIndex].fields.idfamily+'_'+itemToUpdate.listOfAttributes[mapIndex].fields.propid,
						"ChildItem": itemToUpdate,
						"ChildItemAttribute": itemToUpdate.listOfAttributes[mapIndex],
						"newValue" : newValue, //francesca.ribezzi 25/11/19 - performance - adding new and old value to pass these to FlowCart  
						"oldValue" : oldValue
						//"regexField" : "INVALID"
					});
			    	approvalOrderRulesEvent.fire();
			    	//END event
			   }
		   } 	
        }//END ItemToUpdate != null  	
    },
    disableEnterOnPress: function(component,event, helper){
    	
    	var key;      
	    if(window.event)
	    {
	    	key = window.event.keyCode; //IE
	    }
	    else{
	    	key = e.which; //firefox      
	    }
	    if(key == 13){
	    	 event.preventDefault();
	    	 return false;
	    }
    },
})