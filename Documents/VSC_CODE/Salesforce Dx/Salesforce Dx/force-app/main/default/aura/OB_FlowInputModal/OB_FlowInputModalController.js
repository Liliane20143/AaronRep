({
	doInit : function(component, event, helper) {
		console.log('@INSIDE DO INIT');

		if($A.util.isUndefinedOrNull(component.get("v.objectDataMap"))){
            console.log('objectDataMap mancante');
            return null;
        }

        /*	START 	micol.ferrari 26/09/2018 - GET LABEL FROM ADDRESSMAPPING */
        var labelDynamic 	= component.get("v.addressMapping.fieldInputLabel");
       	var labelReference 	= $A.getReference("$Label.c." + labelDynamic);
		component.set("v.fieldInputLabel", labelReference);
        /*	END 	micol.ferrari 26/09/2018 - GET LABEL FROM ADDRESSMAPPING */

		 // NEXI-351 Marta Stempien <marta.stempien@accenture.com> 30/09/2019 Start
		let objectDataMap = component.get("v.objectDataMap");
		if(!$A.util.isEmpty(objectDataMap.merchant)){	// antonio.vatrano r1f3-123 01/10/2019
			if(!$A.util.isEmpty(objectDataMap.merchant.OB_ATECO__c))
			{
				component.set("v.previousAteco", objectDataMap.merchant.OB_ATECO__c);
			}
		}// antonio.vatrano r1f3-123 01/10/2019
		 // NEXI-351 Marta Stempien <marta.stempien@accenture.com> 30/09/2019 Stop
		var addressMapping = component.get("v.addressMapping");
		
		var objectDataNode = addressMapping.objectDataNode;
		var objectDataField = addressMapping.objectDataField;
		var lovType = addressMapping.lovType;
		var lovOrderBy = addressMapping.lovOrderBy;
		var mapLabelColumns = addressMapping.mapLabelColumns;
		var lovSourceField = addressMapping.lovSourceField;
		component.set("v.fieldIdDiv",addressMapping.inputFieldId + "div");
		
		if(objectDataField == 'OB_Citizenship__c'){
			var countryinput = objectDataMap[objectDataNode][objectDataField]; 
		    if(countryinput == undefined || countryinput == null || countryinput == ''){
			   component.set("v.objectDataMap."+ objectDataNode + "." + objectDataField ,  'ITALIA' );
			}
		}
		
		var subType =  addressMapping.subType || '';
		var subTypeField =  addressMapping.subTypeField || '';
		var fatecoField = addressMapping.fatecoField || '';
		var fatecoFieldFlag = addressMapping.fatecoFieldFlag || '';


		if ((subType == null || subType == '') && subTypeField!= ''){
			subType = objectDataMap[objectDataNode][subTypeField];
		}

		if(fatecoFieldFlag !='' && subTypeField!= '')
		{
			var fatecoFieldFlagVal = objectDataMap[objectDataNode][fatecoField];
			console.log("fatecoFieldFlagVal :    " + fatecoFieldFlagVal);
			if(fatecoFieldFlagVal != undefined && fatecoFieldFlagVal.toUpperCase() =='S')
			{
				subType = objectDataMap[objectDataNode][fatecoField];
			}
		}

		/* ANDREA MORITTU START 18-Jun-19 Fix_ClickableSAEbutton*/
		if(objectDataField == 'OB_SAE_Code__c') {
			component.set('v.isDisableModify', false);
		}
		/* ANDREA MORITTU END 18-Jun-19 Fix_ClickableSAEbutton*/

		console.log('@@@ objectDataNode: '+objectDataNode);
		console.log('@@@ objectDataField: '+objectDataField);
		console.log('@@@ fatecoField: '+fatecoField);
		console.log('@@@ subType: '+subType);
		console.log('@@@ subTypeField: '+subTypeField);
		
		component.set("v.subType", subType);
		component.set("v.subTypeField", subTypeField);

		//	SET OBJECTSTRING
		
		component.set("v.objectString", objectDataNode);
		console.log('objectDataMap[objectDataNode] '+JSON.stringify(objectDataMap[objectDataNode]));
		let inputValue = objectDataMap[objectDataNode][objectDataField];
		console.log('objectDataMap[objectDataNode][objectDataField] '+JSON.stringify(inputValue));
		//Set input Field
		console.log("Set input field: " + inputValue);
        // NEXI-351 Marta Stempien <marta.stempien@accenture.com> 30/09/2019 Start
        if( !$A.util.isEmpty(objectDataField ) && objectDataField == 'OB_ATECO__c' )
        {
            component.set("v.inputField", component.get("v.previousAteco"));
        }
        else
        {
		    component.set("v.inputField", inputValue);
        }
        // NEXI-351 Marta Stempien <marta.stempien@accenture.com> 30/09/2019 Stop
		//NEXI-159 grzegorz.banach@accenture.com 03.07.2019 START
		if ( $A.util.isEmpty( inputValue ) )
		{
            component.set( "v.isDisableModify", false );
        }
        //NEXI-159 grzegorz.banach@accenture.com 03.07.2019 END
		//Set Type
		component.set("v.type", lovType);
		//Set lov Source Field 
		console.log('@@@ lovSourceField: '+lovSourceField);
		var resultMapTargetSource = lovSourceField.split(',');
		console.log(resultMapTargetSource);
		var objTarget = {};
		for (var i=0;i<resultMapTargetSource.length;i++)
		{
			var resultTarget = resultMapTargetSource[i].split('||');
			for (var j=0;j<resultTarget.length;j++)
			{
				objTarget[resultTarget[0]] = resultTarget[1];
			}
		}
		console.log('Stringify of objTarget:  ' + JSON.stringify(objTarget));	
		component.set("v.mapOfSourceFieldTargetField",objTarget);
		//Set Order By on Modal
		component.set("v.orderBy", lovOrderBy);
		//Set Map Label Colums
		var resultMapLabelCol = mapLabelColumns.split(',');
		console.log(resultMapLabelCol);
		var objColumns = {};
		for (var i=0;i<resultMapLabelCol.length;i++)
		{
			var resultCol = resultMapLabelCol[i].split('||');
			for (var j=0;j<resultCol.length;j++)
			{
				objColumns[resultCol[0]] = resultCol[1];
			}
		}
		console.log(JSON.stringify(objColumns));
		
		component.set("v.mapLabelColumns",objColumns);
	},
	openModal: function(component, event, helper) {
		component.set("v.spinner", true); 
		helper.initHelper(component,event);
		//START francesca.ribezzi 16/09/19 -  F2Wave2-188 - checking if the fiscal code is the alphanumeric one and the lov type is legal form 
		var fiscalCode = component.get("v.objectDataMap.merchant.NE__Fiscal_code__c");
		if(fiscalCode.length == 16 && component.get("v.type") == 'LegalForm'){
			//this subtype limits the lov search to just a few records which are marked with 'CF' in OB_Value4 field
			component.set("v.subType", 'CF'); 
			component.set("v.subTypeField", 'OB_Value4__c');
		}
		//END francesca.ribezzi 16/09/19 -  F2Wave2-188 

		helper.createComponentModal(component, event);
       
	},
	handleShowModalEvent : function(component, event, helper) {
		console.log("INTO HANDLE SHOW EVENT");

		//---------
		var oldObjectDataMap = component.get("v.objectDataMap"); //obj della componente
		//---------

		var objectDataMap = event.getParam("objectDataMap");
		var addressMapping = component.get("v.addressMapping");
		var objectDataNode = addressMapping.objectDataNode;
		var objectDataField = addressMapping.objectDataField;

		console.log("handleShowModalEvent event.getParam: " + JSON.stringify(objectDataMap));
		component.set("v.objectDataMap", objectDataMap);
		console.log("Objectdatamap merchant: ");
		console.log(component.get("v.objectDataMap.merchant"));
        component.set("v.inputField", objectDataMap[objectDataNode][objectDataField]);
        console.log('Test inputField: '+ component.get("v.inputField"));
       	var inputFieldId = component.get("v.addressMapping.inputFieldId");
    	console.log('inputFieldId '+inputFieldId);
    	// ---09/10/2018--Test to clean ATECO when update SAE  Salvatote P. START---
        if(inputFieldId == 'SAE')
        {
			var objSae = oldObjectDataMap.merchant.OB_SAE_Code__c;
			var objAteco = oldObjectDataMap.merchant.OB_ATECO__c;
			if(objSae != undefined && objSae != null && objAteco != undefined && objAteco != null )
			{
				console.log('objectDataMap.merchant.OB_SAE_Code__c '+objectDataMap.merchant.OB_SAE_Code__c );
				console.log('oldObjectDataMap.merchant.OB_SAE_Code__c '+oldObjectDataMap.merchant.OB_SAE_Code__c );
				if(objectDataMap.merchant.OB_SAE_Code__c != oldObjectDataMap.merchant.OB_SAE_Code__c)
				{
				    // NEXI-351 Marta Stempien <marta.stempien@accenture.com> 30/09/2019 Start
					if( $A.util.isEmpty(objectDataMap.merchant.OB_FATECO__c)|| objectDataMap.merchant.OB_FATECO__c == 'N' )
					{
					    component.set("v.objectDataMap.merchant.OB_ATECO__c",'');
                    }
                    else
                    {
                        component.set("v.objectDataMap.merchant.OB_ATECO__c",component.get("v.previousAteco"));
                    }

					if(document.getElementById('ATECO'))
					{
						document.getElementById('ATECO').value = component.get("v.objectDataMap.merchant.OB_ATECO__c");
					}
                    // NEXI-351 Marta Stempien <marta.stempien@accenture.com> 30/09/2019 Stop
				}
			}
		}
		// ---09/10/2018--Test to clean ATECO when update SAE  Salvatote P. END-----
        //RECREATE THE SAME ID OF ERROR MESSAGE
        var errorId = 'errorId'+ inputFieldId;
        //REMOVE ERROR MESSAGE
        var x =  document.getElementById(errorId);
        console.log('inputfieldid::: '+document.getElementById(inputFieldId));
        $A.util.removeClass(document.getElementById(inputFieldId), 'slds-has-error');
        console.log('var x'+x);
        if(x)
        {
        	x.remove();                                    
        }
	},
    
    /* lea.emalieu START 14/09/2018   */
	objectDataMapChanges : function(component, event, helper){
	    // NEXI-97 Marta Stempien <marta.stempien@accenture.com> 05/06/2019 - Start
	    var objectDataMap = component.get("v.objectDataMap");
	    var addressMapping = component.get("v.addressMapping");
        var objectDataNode = addressMapping.objectDataNode;
        var objectDataField = addressMapping.objectDataField;
		component.set("v.inputField", objectDataMap[objectDataNode][objectDataField]);
		// NEXI-97 Marta Stempien <marta.stempien@accenture.com> 05/06/2019 - Stop
	}

	/*lea.emalieu END 14/09/2918  */
		
})