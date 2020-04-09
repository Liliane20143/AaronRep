({
	//getting a list of Matrix Parameter Rows based on the NE__Matrix_Parameter__c lookupfield:
	doInit : function(component, event, helper)
	{
		helper.retrieveMatrixParameterRows(component);
	},

	handleEditableExistingRow: function(component, event, helper)
	{
		console.log("into handleEditableExistingRow");
		component.set("v.spinner", true);
		console.log("index: " + event.currentTarget.id);
		var parentChildrenRows = component.get("v.parentChildrenRows");
		var idString = '';
		idString = event.currentTarget.id;
		var readOnly =  idString.split('-').pop();
		console.log("isReadOnly? " + readOnly);
		var parentIndex = idString.substr(0, idString.indexOf('_'));
		var childIndex = idString.substr(idString.indexOf('_')+1, idString.indexOf('-')-2);//index+'_'+index2+'-true'
		console.log("parentIndex? " + parentIndex);
		console.log("childIndex? " + childIndex);
		var selectedRow = parentChildrenRows[parseInt(parentIndex)].children[parseInt(childIndex)];
		console.log("selectedRow??" + JSON.stringify(selectedRow));
		if(readOnly == 'false')
		{
			selectedRow.OB_ReadOnly__c = true;
			selectedRow.OB_Read_Only_banca__c = true;
			console.log("selectedRow.OB_ReadOnly__c : " + selectedRow.OB_ReadOnly__c );
		}else if(readOnly == 'true')
		{
			selectedRow.OB_ReadOnly__c = false;
			selectedRow.OB_Read_Only_banca__c = false;
		}
		component.set("v.parentChildrenRows", parentChildrenRows);
		component.set("v.spinner", false);
	},
	
	//getting the matrix parameter row to clone by event.currentTarget.id
	createNewRow: function(component, event, helper)
	{
		component.set("v.spinner", true);
		console.log("into createNewRow index: " + event.currentTarget.id);
		var targetId = event.currentTarget.id;
		var index =  targetId.substr(0, targetId.indexOf('_'));
		
		console.log("index: " + index);
		var parentChildrenRows = component.get("v.parentChildrenRows");
		var rowToClone = parentChildrenRows[parseInt(index)];
		helper.cloneRow(component,rowToClone, index, event);
	},

	//updating changes on matrix parameter rows:
	handleSaveChangedRows: function(component, event, helper)
	{
		component.set("v.spinner", true);
		helper.saveRows(component, event);
	},

	//refreshing rows list by clicking cancel button:
	reloadRowsList: function(component, event, helper)
	{
		component.set("v.spinner", true);
	    component.set("v.SearchKeyWord", '');
	    component.set("v.Message", '');
		component.set("v.listOfSearchRecords", []);
		helper.retrieveMatrixParameterRows(component, event);
	},
	
	goBackToConfigurazioniTable: function(component, event, helper)
	{
		component.set("v.goBackToConfigurazioniTableNexi", true);
	},

    //updating attribute's value and checking its input validity:
    onChangeValueOldRow: function(component, event, helper)
    {
		console.log("into onChangeValueOldRow");		
		var parentChildrenRows = component.get("v.parentChildrenRows");
		var targetId = event.getSource().get("v.id");
		var field;
		var value = parseFloat(event.getSource().get("v.value"));
		console.log("value: " + value);
        if(!$A.util.isEmpty(targetId))
        {
			var parentIndex = targetId.substr(0,targetId.indexOf('_'));
			var childIndex = targetId.substr(targetId.indexOf('_')+1, targetId.indexOf('-')-2);//index+'_'+index2+'
			console.log("parentIndex? " + parentIndex);
			console.log("childIndex? " + childIndex);
			var selectedRow = parentChildrenRows[parseInt(parentIndex)].children[parseInt(childIndex)];
			field = event.getSource().get("v.name");
			console.log("field: " + field);
			//console.log("selectedRow: " + JSON.stringify(selectedRow));
			var sogliaMin = selectedRow.OB_Soglia_Min_Approvazione__c;
			var sogliaMax = selectedRow.OB_Soglia_Max_Approvazione__c;
			var maxValue = selectedRow.OB_Massimo__c;
			var minValue = selectedRow.OB_Minimo__c;
			var maxPrice = selectedRow.OB_Massimale__c;
			var defaultValue = selectedRow.OB_Valore_Default__c;
			//Nex-005 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 21/03/2019 Start
			let minThresholdL3 = selectedRow.OB_MinThresholdL3__c;
			let minThresholdL2 = selectedRow.OB_MinThresholdL2__c;
			let maxThresholdL2 = selectedRow.OB_MaxThresholdL2__c;
			let maxThresholdL3 = selectedRow.OB_MaxThresholdL3__c;
            //Nex-005 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 21/03/2019 Stop
			let validity = event.getSource().get("v.validity");
			var isApproved = true;
			var numInputError = component.get("v.numInputError");
			if(validity.valid && value != null && !isNaN(value))
			{
				console.log("input is valid");
				/*Nex-005 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 21/03/2019 Start add 4 fields into switch case,
				    reorganize switch caseordering cases from smalest to bigest and
				    reorganize condition in cases adding 4 new fields */
                //NEXI-8 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 11/04/2019 Start
//				condition to met:
//				OB_Minimo__c <= OB_MinThresholdL3__c <= OB_MinThresholdL2__c <= OB_Soglia_Min_Approvazione__c
//				    <= OB_Valore_Default__c <= OB_Soglia_Max_Approvazione__c <= OB_MaxThresholdL2__c <= OB_MaxThresholdL3__c
//				    <= OB_Massimo__c <= OB_Massimale__c

                switch (field)
                {
                    case 'OB_Minimo__c':
                        if
                        (
                            ($A.util.isEmpty(minThresholdL3) || value <= minThresholdL3) &&
                            ($A.util.isEmpty(minThresholdL2) || value <= minThresholdL2) &&
                            ($A.util.isEmpty(sogliaMin) || value <= sogliaMin) &&
                            ($A.util.isEmpty(defaultValue) || value <= defaultValue) &&
                            ($A.util.isEmpty(sogliaMax) || value <= sogliaMax) &&
                            ($A.util.isEmpty(maxThresholdL2) || value <= maxThresholdL2) &&
                            ($A.util.isEmpty(maxThresholdL3) || value <= maxThresholdL3) &&
                            ($A.util.isEmpty(maxValue) || value <= maxValue) &&
                            ($A.util.isEmpty(maxPrice) || value <= maxPrice)
                        )
                        {
                            console.log(' min is ok!!');
                            selectedRow[field] = value;
                            parentChildrenRows[parseInt(parentIndex)].children[parseInt(childIndex)][field] = value;
                            var span = document.getElementById(targetId).nextElementSibling.innerHTML= '';
                            if(document.getElementById(targetId).classList.contains("borderErrorConf"))
                            {
                                numInputError--;
                            }
                            document.getElementById(targetId).classList.remove("borderErrorConf");
                            isApproved = true;
                        }
                        else
                        {
                            console.log(' min  is NOT ok!!');
                            var errorMessage = "min value is not valid!";
                            var span = document.getElementById(targetId).nextElementSibling.innerHTML= errorMessage;
                            if(!document.getElementById(targetId).classList.contains("borderErrorConf"))
                            {
                                numInputError++;
                            }
                            document.getElementById(targetId).classList.add("borderErrorConf");
                            isApproved = false;
                        }
                        break;
                    case 'OB_MinThresholdL3__c':
                        if
                        (
                            ($A.util.isEmpty(minValue) ||  value >= minValue) &&
                            ($A.util.isEmpty(minThresholdL2) || value <= minThresholdL2) &&
                            ($A.util.isEmpty(sogliaMin) || value <= sogliaMin) &&
                            ($A.util.isEmpty(defaultValue) || value <= defaultValue) &&
                            ($A.util.isEmpty(sogliaMax) || value <= sogliaMax) &&
                            ($A.util.isEmpty(maxThresholdL2) || value <= maxThresholdL2) &&
                            ($A.util.isEmpty(maxThresholdL3) || value <= maxThresholdL3) &&
                            ($A.util.isEmpty(maxValue) || value <= maxValue) &&
                            ($A.util.isEmpty(maxPrice) || value <= maxPrice)
                        )
                        {
                            console.log(' min L3 is ok!!');
                            selectedRow[field] = value;
                            parentChildrenRows[parseInt(parentIndex)].children[parseInt(childIndex)][field] = value;
                            var span = document.getElementById(targetId).nextElementSibling.innerHTML= '';
                            if(document.getElementById(targetId).classList.contains("borderErrorConf"))
                            {
                                numInputError--;
                            }
                            document.getElementById(targetId).classList.remove("borderErrorConf");
                            isApproved = true;
                        }
                        else
                        {
                            console.log(' min L3 is NOT ok!!');
                            let errorMessage = $A.get("$Label.c.OB_L3_Min_Error");//R1F2_RP_010 Adrian Dlugolecki<adrian.dlugolecki@accenture.com> 08/04/2019 change into label
                            var span = document.getElementById(targetId).nextElementSibling.innerHTML= errorMessage;
                            if(!document.getElementById(targetId).classList.contains("borderErrorConf"))
                            {
                                numInputError++;
                            }
                            document.getElementById(targetId).classList.add("borderErrorConf");
                            isApproved = false;
                        }
                        break;
                    case 'OB_MinThresholdL2__c':
                        if
                        (
                            ($A.util.isEmpty(minValue) ||  value >= minValue) &&
                            ($A.util.isEmpty(minThresholdL3) || value >= minThresholdL3) &&
                            ($A.util.isEmpty(sogliaMin) || value <= sogliaMin) &&
                            ($A.util.isEmpty(defaultValue) || value <= defaultValue) &&
                            ($A.util.isEmpty(sogliaMax) || value <= sogliaMax) &&
                            ($A.util.isEmpty(maxThresholdL2) || value <= maxThresholdL2) &&
                            ($A.util.isEmpty(maxThresholdL3) || value <= maxThresholdL3) &&
                            ($A.util.isEmpty(maxValue) || value <= maxValue) &&
                            ($A.util.isEmpty(maxPrice) || value <= maxPrice)
                        )
                        {
                            console.log(' min L2 is ok!!');
                            selectedRow[field] = value;
                            parentChildrenRows[parseInt(parentIndex)].children[parseInt(childIndex)][field] = value;
                            var span = document.getElementById(targetId).nextElementSibling.innerHTML= '';
                            if(document.getElementById(targetId).classList.contains("borderErrorConf"))
                            {
                                numInputError--;
                            }
                            document.getElementById(targetId).classList.remove("borderErrorConf");
                            isApproved = true;
                        }
                        else
                        {
                            console.log(' min L2 is NOT ok!!');
                            let errorMessage = $A.get("$Label.c.OB_L2_Min_Error");//R1F2_RP_010 Adrian Dlugolecki<adrian.dlugolecki@accenture.com> 08/04/2019 change into label
                            var span = document.getElementById(targetId).nextElementSibling.innerHTML= errorMessage;
                            if(!document.getElementById(targetId).classList.contains("borderErrorConf"))
                            {
                                numInputError++;
                            }
                            document.getElementById(targetId).classList.add("borderErrorConf");
                            isApproved = false;
                        }
                        break;
                    case 'OB_Soglia_Min_Approvazione__c':
                        if
                        (
                            ($A.util.isEmpty(minValue) ||  value >= minValue) &&
                            ($A.util.isEmpty(minThresholdL3) || value >= minThresholdL3) &&
                            ($A.util.isEmpty(minThresholdL2) || value >= minThresholdL2) &&
                            ($A.util.isEmpty(defaultValue) || value <= defaultValue) &&
                            ($A.util.isEmpty(sogliaMax) || value <= sogliaMax) &&
                            ($A.util.isEmpty(maxThresholdL2) || value <= maxThresholdL2) &&
                            ($A.util.isEmpty(maxThresholdL3) || value <= maxThresholdL3) &&
                            ($A.util.isEmpty(maxValue) || value <= maxValue) &&
                            ($A.util.isEmpty(maxPrice) || value <= maxPrice)
                        )
                        {
                            console.log('soglia min is ok!!');
                            selectedRow[field] = value;
                            parentChildrenRows[parseInt(parentIndex)].children[parseInt(childIndex)][field] = value;
                            var span = document.getElementById(targetId).nextElementSibling.innerHTML= '';
                            if(document.getElementById(targetId).classList.contains("borderErrorConf"))
                            {
                                numInputError--;
                            }
                            document.getElementById(targetId).classList.remove("borderErrorConf");
                            isApproved = true;
                        }
                        else
                        {
                            console.log('soglia min  is NOT ok!!');
                            var errorMessage = $A.get("$Label.c.OB_L1_Min_Error");//R1F2_RP_010 Adrian Dlugolecki<adrian.dlugolecki@accenture.com> 08/04/2019 change into label
                            var span = document.getElementById(targetId).nextElementSibling.innerHTML= errorMessage;
                            if(!document.getElementById(targetId).classList.contains("borderErrorConf"))
                            {
                                numInputError++;
                            }
                            document.getElementById(targetId).classList.add("borderErrorConf");
                            isApproved = false;
                        }
                        break;
                    case 'OB_Valore_Default__c':
                        if
                        (
                            ($A.util.isEmpty(minValue) ||  value >= minValue) &&
                            ($A.util.isEmpty(minThresholdL3) || value >= minThresholdL3) &&
                            ($A.util.isEmpty(minThresholdL2) || value >= minThresholdL2) &&
                            ($A.util.isEmpty(sogliaMin) || value >= sogliaMin) &&
                            ($A.util.isEmpty(sogliaMax) || value <= sogliaMax) &&
                            ($A.util.isEmpty(maxThresholdL2) || value <= maxThresholdL2) &&
                            ($A.util.isEmpty(maxThresholdL3) || value <= maxThresholdL3) &&
                            ($A.util.isEmpty(maxValue) || value <= maxValue) &&
                            ($A.util.isEmpty(maxPrice) || value <= maxPrice)
                        )
                        {
                            console.log('default value is ok!!');
                            selectedRow[field] = value;
                            parentChildrenRows[parseInt(parentIndex)].children[parseInt(childIndex)][field] = value;
                            var span = document.getElementById(targetId).nextElementSibling.innerHTML= '';
                            if(document.getElementById(targetId).classList.contains("borderErrorConf"))
                            {
                                numInputError--;
                            }
                            document.getElementById(targetId).classList.remove("borderErrorConf");
                            isApproved = true;
                            document.getElementById('saveChangesBtn').disabled = !isApproved;
                        }
                        else
                        {
                            var errorMessage = "default value is not valid!";
                            var span = document.getElementById(targetId).nextElementSibling.innerHTML= errorMessage;
                            if(!document.getElementById(targetId).classList.contains("borderErrorConf"))
                            {
                                numInputError++;
                            }
                            document.getElementById(targetId).classList.add("borderErrorConf");
                            isApproved = false;
                        }
                        break;
                    case 'OB_Soglia_Max_Approvazione__c':
                        if
                        (
                            ($A.util.isEmpty(minValue) ||  value >= minValue) &&
                            ($A.util.isEmpty(minThresholdL3) || value >= minThresholdL3) &&
                            ($A.util.isEmpty(minThresholdL2) || value >= minThresholdL2) &&
                            ($A.util.isEmpty(sogliaMin) || value >= sogliaMin) &&
                            ($A.util.isEmpty(defaultValue) || value >= defaultValue) &&
                            ($A.util.isEmpty(maxThresholdL2) || value <= maxThresholdL2) &&
                            ($A.util.isEmpty(maxThresholdL3) || value <= maxThresholdL3) &&
                            ($A.util.isEmpty(maxValue) || value <= maxValue) &&
                            ($A.util.isEmpty(maxPrice) || value <= maxPrice)
                        )
                        {
                            console.log('soglia max value is ok!!');
                            selectedRow[field] = value;
                            parentChildrenRows[parseInt(parentIndex)].children[parseInt(childIndex)][field] = value;
                            var span = document.getElementById(targetId).nextElementSibling.innerHTML= '';
                            if(document.getElementById(targetId).classList.contains("borderErrorConf"))
                            {
                                numInputError--;
                            }
                            document.getElementById(targetId).classList.remove("borderErrorConf");
                            isApproved = true;
                        }
                        else
                        {
                            console.log('soglia max  is NOT ok!!');
                            var errorMessage = $A.get("$Label.c.OB_L1_Max_Error");//R1F2_RP_010 Adrian Dlugolecki<adrian.dlugolecki@accenture.com> 08/04/2019 change into label
                            var span = document.getElementById(targetId).nextElementSibling.innerHTML= errorMessage;
                            if(!document.getElementById(targetId).classList.contains("borderErrorConf"))
                            {
                                numInputError++;
                            }
                            document.getElementById(targetId).classList.add("borderErrorConf");
                            isApproved = false;
                        }
                        break;
                    case 'OB_MaxThresholdL2__c':
                        if
                        (
                            ($A.util.isEmpty(minValue) ||  value >= minValue) &&
                            ($A.util.isEmpty(minThresholdL3) || value >= minThresholdL3) &&
                            ($A.util.isEmpty(minThresholdL2) || value >= minThresholdL2) &&
                            ($A.util.isEmpty(sogliaMin) || value >= sogliaMin) &&
                            ($A.util.isEmpty(defaultValue) || value >= defaultValue) &&
                            ($A.util.isEmpty(sogliaMax) || value >= sogliaMax) &&
                            ($A.util.isEmpty(maxThresholdL3) || value <= maxThresholdL3) &&
                            ($A.util.isEmpty(maxValue) || value <= maxValue) &&
                            ($A.util.isEmpty(maxPrice) || value <= maxPrice)
                        )
                        {
                            console.log('max L2 value is ok!!');
                            selectedRow[field] = value;
                            parentChildrenRows[parseInt(parentIndex)].children[parseInt(childIndex)][field] = value;
                            var span = document.getElementById(targetId).nextElementSibling.innerHTML= '';
                            if(document.getElementById(targetId).classList.contains("borderErrorConf"))
                            {
                                numInputError--;
                            }
                            document.getElementById(targetId).classList.remove("borderErrorConf");
                            isApproved = true;
                        }
                        else
                        {
                            console.log('max L2 is NOT ok!!');
                            let errorMessage = $A.get("$Label.c.OB_L2_Max_Error");//R1F2_RP_010 Adrian Dlugolecki<adrian.dlugolecki@accenture.com> 08/04/2019 change into label
                            var span = document.getElementById(targetId).nextElementSibling.innerHTML= errorMessage;
                            if(!document.getElementById(targetId).classList.contains("borderErrorConf"))
                            {
                                numInputError++;
                            }
                            document.getElementById(targetId).classList.add("borderErrorConf");
                            isApproved = false;
                        }
                        break;
                    case 'OB_MaxThresholdL3__c':
                        if
                        (
                            ($A.util.isEmpty(minValue) ||  value >= minValue) &&
                            ($A.util.isEmpty(minThresholdL3) || value >= minThresholdL3) &&
                            ($A.util.isEmpty(minThresholdL2) || value >= minThresholdL2) &&
                            ($A.util.isEmpty(sogliaMin) || value >= sogliaMin) &&
                            ($A.util.isEmpty(defaultValue) || value >= defaultValue) &&
                            ($A.util.isEmpty(sogliaMax) || value >= sogliaMax) &&
                            ($A.util.isEmpty(maxThresholdL2) || value >= maxThresholdL2) &&
                            ($A.util.isEmpty(maxValue) || value <= maxValue) &&
                            ($A.util.isEmpty(maxPrice) || value <= maxPrice)
                        )
                        {
                            console.log('max L3 value is ok!!');
                            selectedRow[field] = value;
                            parentChildrenRows[parseInt(parentIndex)].children[parseInt(childIndex)][field] = value;
                            var span = document.getElementById(targetId).nextElementSibling.innerHTML= '';
                            if(document.getElementById(targetId).classList.contains("borderErrorConf"))
                            {
                                numInputError--;
                            }
                            document.getElementById(targetId).classList.remove("borderErrorConf");
                            isApproved = true;
                        }
                        else
                        {
                            console.log('max L3 is NOT ok!!');
                            let errorMessage = $A.get("$Label.c.OB_L3_Max_Error");//R1F2_RP_010 Adrian Dlugolecki<adrian.dlugolecki@accenture.com> 08/04/2019 change into label
                            var span = document.getElementById(targetId).nextElementSibling.innerHTML= errorMessage;
                            if(!document.getElementById(targetId).classList.contains("borderErrorConf"))
                            {
                                numInputError++;
                            }
                            document.getElementById(targetId).classList.add("borderErrorConf");
                            isApproved = false;
                        }
                        break;
                    case 'OB_Massimo__c':
                        if
                        (
                            ($A.util.isEmpty(minValue) ||  value >= minValue) &&
                            ($A.util.isEmpty(minThresholdL3) || value >=minThresholdL3) &&
                            ($A.util.isEmpty(minThresholdL2) || value >= minThresholdL2) &&
                            ($A.util.isEmpty(sogliaMin) || value >= sogliaMin) &&
                            ($A.util.isEmpty(defaultValue) || value >= defaultValue) &&
                            ($A.util.isEmpty(sogliaMax) || value >= sogliaMax) &&
                            ($A.util.isEmpty(maxThresholdL2) || value >= maxThresholdL2) &&
                            ($A.util.isEmpty(maxThresholdL3) || value >= maxThresholdL3) &&
                            ($A.util.isEmpty(maxPrice) || value <= maxPrice)
                        )
                        {
                            console.log('OB_Massimo__c is ok!!');
                            selectedRow[field] = value;
                            parentChildrenRows[parseInt(parentIndex)].children[parseInt(childIndex)][field] = value;
                            var span = document.getElementById(targetId).nextElementSibling.innerHTML= '';
                            if(document.getElementById(targetId).classList.contains("borderErrorConf"))
                            {
                                numInputError--;
                            }
                            document.getElementById(targetId).classList.remove("borderErrorConf");
                            isApproved = true;
                        }
                        else
                        {
                            console.log('max value is NOT ok!!');
                            var errorMessage = "max value is not valid!";
                            var span = document.getElementById(targetId).nextElementSibling.innerHTML= errorMessage;
                            if(!document.getElementById(targetId).classList.contains("borderErrorConf")){
                                numInputError++;
                            }
                            document.getElementById(targetId).classList.add("borderErrorConf");
                            isApproved = false;
                        }
                        break;
                    case 'OB_Massimale__c':
                        if
                        (
                            ($A.util.isEmpty(minValue) ||  value >= minValue) &&
                            ($A.util.isEmpty(minThresholdL3) || value >= minThresholdL3) &&
                            ($A.util.isEmpty(minThresholdL2) || value >= minThresholdL2) &&
                            ($A.util.isEmpty(sogliaMin) || value >= sogliaMin) &&
                            ($A.util.isEmpty(defaultValue) || value >= defaultValue) &&
                            ($A.util.isEmpty(sogliaMax) || value >= sogliaMax) &&
                            ($A.util.isEmpty(maxThresholdL2) || value >= maxThresholdL2) &&
                            ($A.util.isEmpty(maxThresholdL3) || value >= maxThresholdL3) &&
                            ($A.util.isEmpty(maxValue) || value >= maxValue)
                        )
                        {
                            console.log('max price is ok!!');
                            selectedRow[field] = value;
                            parentChildrenRows[parseInt(parentIndex)].children[parseInt(childIndex)][field] = value;
                            var span = document.getElementById(targetId).nextElementSibling.innerHTML= '';
                            if(document.getElementById(targetId).classList.contains("borderErrorConf"))
                            {
                                numInputError--;
                            }
                            document.getElementById(targetId).classList.remove("borderErrorConf");
                            isApproved = true;
                        }
                        else
                        {
                            console.log(' max price  is NOT ok!!');
                            var errorMessage = "max price is not valid!";
                            var span = document.getElementById(targetId).nextElementSibling.innerHTML= errorMessage;
                            if(!document.getElementById(targetId).classList.contains("borderErrorConf"))
                            {
                                numInputError++;
                            }
                            document.getElementById(targetId).classList.add("borderErrorConf");
                            isApproved = false;
                        }
			    }
			    //NEXI-8 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 11/04/2019 End
//			    Nex-005 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 21/03/2019 End
                if(isApproved)
                {
                    component.set("v.parentChildrenRows", parentChildrenRows);
                }
			
            }
            else if(!validity.valid && value != null && !isNaN(value))
            {
                console.log("value != null and not valid!!");
                if(!document.getElementById(targetId).classList.contains("borderErrorConf"))
                {
                    numInputError++;
                }
                document.getElementById(targetId).classList.add("borderErrorConf");
                document.getElementById(targetId).nextElementSibling.innerHTML = 'Enter a valid value.';
            }
            else
            {
                console.log("else!!!!!");
                if(document.getElementById(targetId).classList.contains("borderErrorConf"))
                {
                    numInputError--;
                }
                document.getElementById(targetId).classList.remove("borderErrorConf");
                document.getElementById(targetId).nextElementSibling.innerHTML = '';
            }
            console.log("numInputError: " + numInputError);
            if(numInputError == 0)
            {
                document.getElementById('saveChangesBtn').disabled = false;
            }
            else
            {
                document.getElementById('saveChangesBtn').disabled = true;
            }
            component.set("v.numInputError", numInputError);
        }
    },

	//updating OB_Sequence__c field and checking its input validity:
	handleRightSequence: function(component, event, helper)
	{
		component.set("v.spinner", true);
		var parentChildrenRows = component.get("v.parentChildrenRows");
		var idString =  event.target.id;
		var index = idString.substr(0, idString.indexOf('_'));
		console.log("index? " + index);

	    if(/[0-9]/g.test(event.target.value))
	    { 
	    	console.log("input is valid");
	    	document.getElementById(event.target.id).classList.remove('borderErrorConf');
	    	document.getElementById(index+'_SequenceError').classList.remove('slds-show');
	    	document.getElementById(index+'_SequenceError').classList.add('slds-hide');
			parentChildrenRows[parseInt(index)].parent.OB_Sequence__c = event.target.value;
			for(var i = 0; i<parentChildrenRows[parseInt(index)].children.length; i++)
			{
				parentChildrenRows[parseInt(index)].children[i].OB_Sequence__c = event.target.value;
			}
		}
		else
		{
			document.getElementById(event.target.id).classList.add('borderErrorConf');
			document.getElementById(index+'_SequenceError').classList.add('slds-show');
	    	document.getElementById(index+'_SequenceError').classList.remove('slds-hide');
			console.log("input is NOT valid");
		}
		component.set("v.spinner", false);
		component.set("v.parentChildrenRows", parentChildrenRows);
	},

	handleOnchangeStartDateOldRow: function(component, event, helper)
	{
		component.set("v.spinner", true);
		var dateValue = new Date();
		dateValue = event.getSource().get("v.value");
		var parentChildrenRows = component.get("v.parentChildrenRows");
		var rowToCloneList = component.get("v.rowToCloneList");
		console.log("dateValue: "+ dateValue);
		console.log("id?? " + event.getSource().get("v.id"));
		var idString = event.getSource().get("v.id");
		var index = idString.substr(0, idString.indexOf('_'));
		//if the new start date value is valid, 
		var selectedRow;
		var validity = event.getSource().get("v.validity");
		if(validity.valid)
		{
			if(parentChildrenRows[parseInt(index)].cloneId != '')
			{
				console.log("it is a clone!"); //if it's a clone
				for(var i = 0; i<parentChildrenRows.length; i++)
				{
				    //this checks if it is a cloned row and gets the row this one comes from:
                    if(parentChildrenRows[parseInt(index)].cloneId == parentChildrenRows[i].parent.Id && parentChildrenRows[i].cloneId == '')
                    {
                        console.log("it is a match!");
                        if($A.util.isEmpty(parentChildrenRows[i].parent.NE__End_Date__c ))
                        {
                            console.log("end date it's not empty!");
                            selectedRow = parentChildrenRows[i];
                            var action = component.get("c.calculateDate");
                            action.setParams({
                                startDate: dateValue
                            });
                            action.setCallback(this, function(response)
                            {
                                var state = response.getState();
                                if (state === "SUCCESS")
                                {
                                    console.log("date From server: ", response.getReturnValue());
                                    selectedRow.parent.NE__End_Date__c = response.getReturnValue();
                                    console.log("selectedRow.parent.NE__End_Date__c: " + selectedRow.parent.NE__End_Date__c);
                                    component.set("v.parentChildrenRows", parentChildrenRows);
                                    component.set("v.spinner", false);
                                } else if (state === "INCOMPLETE")
                                {
                                    // do something
                                } else if (state === "ERROR")
                                {
                                    var errors = response.getError();
                                    if (errors)
                                    {
                                        if (errors[0] && errors[0].message)
                                        {
                                            console.log("Error message: " + errors[0].message);
                                        }
                                    }
                                    else
                                    {
                                        console.log("Unknown error");
                                    }
                                }
                            });
                        }
                    }
                    else
                    {
                        component.set("v.spinner", false);
                    }
				}	  
            }
            else
            {
                component.set("v.spinner", false);
            }
		}else
		{
			component.set("v.spinner", false);
		}
        component.set("v.parentChildrenRows", parentChildrenRows);
	},
	
	handleOnchangeEndDateOldRow: function(component, event, helper)
	{
        var parentChildrenRows = component.get("v.parentChildrenRows");
		var dateValue = event.getSource().get("v.value");
		component.set("v.parentChildrenRows", parentChildrenRows);
	},

    //updating NE__Active__c field for both parent and children rows based on checkbox value:
    handleActivationRows:function(component,event,helper)
    {
    	var idString = '';
		idString = event.getSource().get("v.id");

		console.log("checked? " + event.getSource().get("v.checked"));
		var checked = false;
		checked = event.getSource().get("v.checked");
		var index = idString.substr(0, idString.indexOf('_'));
		console.log("index? " + index);
		var parentChildrenRows = component.get("v.parentChildrenRows");
		parentChildrenRows[parseInt(index)].parent.NE__Active__c = !checked;
		for(var i = 0; i<parentChildrenRows[parseInt(index)].children.length; i++)
		{
			parentChildrenRows[parseInt(index)].children[i].NE__Active__c = !checked;
		}
		console.log("activation??: ", parentChildrenRows);
		component.set("v.parentChildrenRows", parentChildrenRows);
    },
    
    deleteRow:function(component,event,helper)
    {
        //setting modal attributes value and row to delete:
    	component.set("v.modalButton", 'Delete');
    	var deleteHeader = $A.get("$Label.c.OB_DeleteHeader");
    	var deleteMsg = $A.get("$Label.c.OB_DeleteMsg"); 
    	component.set("v.modalHeader",deleteHeader);
    	var idString = event.getSource().get("v.name");
    	var index = idString.substr(0, idString.indexOf('_'));
    	var parentChildrenRows = component.get("v.parentChildrenRows");
    	var selectedRow = parentChildrenRows[parseInt(index)];
    	component.set("v.modalDesc",deleteMsg+' "'+selectedRow.parent.OB_Product__r.Name+'" ?');
    	component.set("v.selectedRow", selectedRow);
    	component.set("v.Confirm", true);
    	component.set("v.indexRowToDelete", index);
    },
    
    handleModalCancel:function(component,event,helper)
    {
		//easy closing the modal
		component.set("v.Confirm",false);
	},

	handleModalButton:function(component,event,helper)
	{
		component.set("v.spinner", true);
		var parentChildrenRows = component.get("v.parentChildrenRows");
		var selectedRow = component.get("v.selectedRow");
		var buttonMode = component.get("v.modalButton");
		
		if(buttonMode == 'Delete')
		{
			helper.deleteRowServer(component, event, selectedRow);	
			component.set("v.Confirm",false);
		}
    },
    //davide.franzini - 26/08/2019 - Manage single property activation - START
    handleActivationChildRows:function(component,event,helper)
    {
        console.log('##in handleActivationChildRows');
        
    	var idString = '';
		idString = event.getSource().get("v.id");
		console.log("checked? " + event.getSource().get("v.checked"));
		var checked = false;
        checked = event.getSource().get("v.checked");
        var tmp = idString.split("-");
        var parent = tmp[1];
		var index = idString.substr(0, idString.indexOf('_'));
        console.log("index? " + index);
		var parentChildrenRows = component.get("v.parentChildrenRows");
		for(var i = 0; i<parentChildrenRows[parseInt(parent)].children.length; i++)
		{
			parentChildrenRows[parseInt(parent)].children[index].NE__Active__c = !checked;
		}
		console.log("activation??: ", parentChildrenRows);
        component.set("v.parentChildrenRows", parentChildrenRows);
    },
    //davide.franzini - 26/08/2019 - Manage single property activation - END
})