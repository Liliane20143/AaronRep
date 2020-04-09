({
	doInit : function(component, event, helper) {
		 
		//_utils.debug("into doInit ChildItemACQ");
		var MapAttributeItems = {};
		var userLicense = component.get("v.userLicense");	// antonio.vatrano 09/05/2019 r1f2-106
		var childItem = component.get("v.childItem");
		var approvalTypePricing = component.get("v.approvalTypePricing");
		var approvalStatus = component.get("v.approvalStatus");
		var approvalStatusIsPricing = (approvalStatus == 'In Approvazione Pricing' || approvalStatus == 'Rigettato Pricing');
		var showStartDate = component.get("v.showStartDate");
		var approvalLevelMap = {}; //francesca.ribezzi 26/11/19 - performance - adding approvalLevelMap

		//_utils.debug("childItem.listOfAttributes", childItem.listOfAttributes);
		for(var i = 0; i < childItem.listOfAttributes.length; i++ ){

			var att = childItem.listOfAttributes[i];

			var minAbsolute  = parseFloat( (''+att.fields.OB_MIn_Absolute__c).replace(',','.')); //DO NOT CORRECT it is REALLY like that 
			var maxAbsolute =  parseFloat((''+att.fields.OB_Max_Absolute__c).replace(',','.'));
			var isEditCommissionModel = component.get("v.isEditCommissionModel");
			var maxPrice =  parseFloat((''+att.fields.OB_Massimale__c).replace(',','.'));
			var minThresholdMap = {};  //francesca.ribezzi 26/11/19 - performance - adding max and min thresholds map + approval level.
			var maxThresholdMap = {};
			var status;

     	//START hotfix/Pricing approval helper 18.04.2019 Zuzanna Urban <z.urban@accenture.com> Select thresholds 
     	var minThresholdOne =  parseFloat((''+att.fields.OB_Min_Threshold__c).replace(',','.'));
     	var maxThresholdOne =  parseFloat((''+att.fields.OB_Max_Threshold__c).replace(',','.'));
     	var minThresholdTwo =  parseFloat((''+att.fields.OB_MinThresholdL2__c).replace(',','.'));
     	var maxThresholdTwo =  parseFloat((''+att.fields.OB_MaxThresholdL2__c).replace(',','.'));
     	var minThresholdThree =  parseFloat((''+att.fields.OB_MinThresholdL3__c).replace(',','.'));
     	var maxThresholdThree =  parseFloat((''+att.fields.OB_MaxThresholdL3__c).replace(',','.'));
        //giovanni spinelli - start - 16/09/2019 - store default value
		var defaultValue = parseFloat((''+att.fields.previousvalue).replace(',','.'));
		 
		//giovanni spinelli - end - 16/09/2019 - store default value	
		var minThreshold = null;
     	var maxThreshold = null;
     
     	var minThresholdList = new Array( );
        var maxThresholdList = new Array( );
		 //START hotfix/Pricing-approval3  18.04.2019 francesca.ribezzi checking if these values are numbers:
		 //francesca.ribezzi 26/11/19 - performance - adding values to minThresholdMap and maxThresholdMap
     	if (!isNaN(minThresholdOne))
        {
			minThresholdList.push( minThresholdOne );
			minThresholdMap['1'] = minThresholdOne; // stands for L1

        }
     	if ( !isNaN(minThresholdTwo))
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
		
			valueToCheck = parseFloat( (''+att.fields.value).replace(',','.') );
			
			//EP 30/01/2019 set readonly for active items
			if(!$A.util.isEmpty(childItem.fields.status) && childItem.fields.status =='Active' && isEditCommissionModel ){
				att.fields.readonly= "true";
			}
		try{	
			//04/01/19 francesca.ribezzi - checking status only if the action is Add or undefined or the old value is not equal to the new one:		
		if(childItem.fields.action == 'Add' ||att.fields.Old_Value__c != att.fields.value || childItem.fields.action == undefined){ 	
		//	if(att.fields.Old_Value__c != att.fields.value ){ 
				if( !isNaN(minAbsolute) && valueToCheck < minAbsolute){
					//red error
					status = 'error';
				}
				else if( !isNaN(maxAbsolute) && valueToCheck > maxAbsolute){
					//red error
					status = 'error';
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
				else if(valueToCheck != defaultValue && defaultValue != undefined && !isNaN(defaultValue )){
					status = 'ok_change';
				}
				//giovanni spinelli - end - 16/09/2019  - set new status when change value but it is okay
				else{
					status = 'ok';
				}
			}else{
				status = 'ok';
			}
		}catch(err){
			console.log(err.message);
		}
			
			//push additional node
			//start antonio.vatrano 09/05/2019 r1f2-106
			if(userLicense != 'Salesforce'){ 
				att.fields.status = status; //francesca.ribezzi 26/11/19 - performance - calling checkThresholds
				var approvalLevel = ''; 
				if(status == 'warning'){   //francesca.ribezzi 06/12/19 - Perf-24 - calling checkThresholds only if the status is warning
					approvalLevel = helper.checkThresholds(component,event,minThresholdMap, maxThresholdMap, valueToCheck);   
				}
				var key = childItem.fields.itemCode+'_'+att.fields.idfamily+'_'+att.fields.propid;
				approvalLevelMap[key] = approvalLevel;	
			}else{
				att.fields.status = 'ok';
			}
			//End antonio.vatrano 09/05/2019 r1f2-106
			//att.fields.status = 'ok';
			att.isWarningApproval = (att.fields.status == 'warning' && approvalTypePricing);
			if(!approvalStatusIsPricing){
				att.isWarningApproval = false;
			}
			MapAttributeItems[childItem.fields.itemCode+'_'+att.fields.idfamily+'_'+att.fields.propid] = i;		
		}
		//_utils.debug("MapAttributeItems ",MapAttributeItems);
		//francesca.ribezzi START 21/03/19 
		if(showStartDate && !$A.util.isEmpty(childItem.fields.NE__StartDate__c)){
			var date = childItem.fields.NE__StartDate__c;
			var year = date.substring(0, 4);
			//console.log("year: " + year);
			var month = date.substring(5, 7);
			//console.log("month: " + month);
			var day = date.substring(8, 10);
			//console.log("day: " + day);
			var newDateFormat = day +'-'+ month+'-' + year; 
			childItem.fields.newStartDateFormat = newDateFormat;
		}
		//END
		component.set("v.childItem",childItem);
		component.set("v.childApprovalLevelMap", approvalLevelMap); //francesca.ribezzi 26/11/19 - performance - setting approvalLevelMap
		component.set("v.MapAttributeItems", MapAttributeItems);

	},

	//LUBRANO 16/01/2019 Libreria Log
	logInit: function(component){
		_utils.logInit(component.getName());
	},
	
	onChangeAttributeValue: function(component, event, helper){
    	
    	_utils.debug("into onChangeAttributeValue");
    	
    	var MapAttributeItems = component.get("v.MapAttributeItems");
    	
    	//_utils.debug("MapAttributeItems ",MapAttributeItems);
    	var userLicense = component.get("v.userLicense");		// antonio.vatrano 09/05/2019 r1f2-106
        var attributeIndex = event.target.id;
        var mapIndex =  MapAttributeItems[attributeIndex];        
        var childItem = component.get("v.childItem");
         
        var itemToUpdate = childItem;  
        
        if(itemToUpdate != null){
        	
        	var errorIndex = document.getElementById(attributeIndex+'_errorACQ');
		    
		    var input = document.getElementById(event.target.id); 
		    var valueToCheck = event.target.value;
		    
		    //error	
		    var attributeFields = itemToUpdate.listOfAttributes[mapIndex].fields;
			var newValue = parseFloat( (''+valueToCheck).replace(',','.') ); //francesca.ribezzi 25/11/19 - performance - adding new and old value to pass these to FlowCart 
			var oldValue = parseFloat((''+attributeFields.Old_Value__c).replace(',','.')); 
		    
	    	//match the regex	
	    	if(/^[0-9]*([,][0-9]{1,3}|)$/.test(event.target.value) ){ //&& !$A.util.isEmpty(event.target.value)
	    		//_utils.debug("VALUE IS VALID");	
	    	   if($A.util.isEmpty(event.target.value)){
	    			//_utils.debug("value is empty!!");
	    			event.target.value = 0; 
	    		//	component.set('v.checkAttributeRules','error');
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
		    	
		    	//error	
		        itemToUpdate.listOfAttributes[mapIndex].fields.value =  event.target.value;
		        //
		        
		        component.set("v.itemToUpdate", itemToUpdate);
		        var checkAttributeRulesToSend = component.get('v.checkAttributeRules');    
			    
			    //START EVENT 
				var approvalOrderRulesEvent = $A.get("e.c:OB_ApprovalOrderRulesEvent");
				approvalOrderRulesEvent.setParams({ 
					"checkAttributeRules": checkAttributeRulesToSend,
					"IdChildItem" : itemToUpdate.fields.itemCode+'_'+itemToUpdate.listOfAttributes[mapIndex].fields.idfamily+'_'+itemToUpdate.listOfAttributes[mapIndex].fields.propid,
					"ChildItem": itemToUpdate,
					"ChildItemAttribute": itemToUpdate.listOfAttributes[mapIndex],
					"newValue" : newValue, //francesca.ribezzi 25/11/19 - performance - adding new and old value to pass these to FlowCart 
					"oldValue" : oldValue
				});
		    	approvalOrderRulesEvent.fire();
				//END event   
				
				//22/02/19 francesca.ribezzi adding check for isMaintenancePricing - percentuale and maggiorazione:
				var attrCode = itemToUpdate.listOfAttributes[mapIndex].fields.OB_Attribute_Code__c;
				if(component.get("v.isMaintenancePricing") && (attrCode  == 'MAGGIORAZIONE' || attrCode  == 'PERCENTUALE')){
					var attrId = itemToUpdate.listOfAttributes[mapIndex].fields.itemCode;
					var attrOldValue = itemToUpdate.listOfAttributes[mapIndex].fields.Old_Value__c;
					//=  itemToUpdate.listOfAttributes[mapIndex];
			    		helper.checkMaggiorazionePercentuale(component, event,attrId,attrCode, valueToCheck, attrOldValue);	
					//-------
				}
		   }
		   //regex check was false
		   else{ 			  
			  // _utils.debug("VALUE IS NOT VALID");
			   if(errorIndex != null){
				   errorIndex.classList.remove("hidden");
				   input.classList.remove("borderWarning");
				   input.classList.add("borderError");
			   }   
			   event.target.value = 0;
			  // event.target.value = itemToUpdate.listOfAttributes[mapIndex].fields.value; 
			   
			   component.set('v.checkAttributeRules','ok');

			   //firing approvalOrderRulesEvent event to parent OB_FlowCart
			   var checkAttributeRulesToSend = component.get("v.checkAttributeRules");
			   //START EVENT 
				var approvalOrderRulesEvent = $A.get("e.c:OB_ApprovalOrderRulesEvent");
				approvalOrderRulesEvent.setParams({ 
					"checkAttributeRules": checkAttributeRulesToSend,
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