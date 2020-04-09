({
	//getting a list of Matrix Parameter Rows based on the NE__Matrix_Parameter__c lookupfield:
	doInit : function(component, event, helper)
	{
		component.set("v.onlyDoInit", true);
		helper.retrieveMatrixParameterRows(component);
	},

	handleEditableExistingRow: function(component, event, helper)
	{
		//LUBRANO 2019-02-27 - read-only blocked until all values are correct
		var idString = '';
		idString = event.currentTarget.id;
		var errorMessage = $A.get("$Label.c.OB_valueRangeInvalid");
		var hasError= component.get("v.valuesError");
		if(!hasError)
		{
			document.getElementById(idString).nextElementSibling.innerHTML= "";
			console.log("into handleEditableExistingRow");
			component.set("v.spinner", true);
			console.log("index: " + event.currentTarget.id);
			var parentChildrenRows = component.get("v.parentChildrenRows");
			
			var readOnly =  idString.split('-').pop();
			console.log("isReadOnly? " + readOnly);
			var parentIndex = idString.substr(0, idString.indexOf('_'));
			var childIndex = idString.substr(idString.indexOf('_')+1, idString.indexOf('-')-2);//index+'_'+index2+'-true'
			console.log("parentIndex? " + parentIndex);
			console.log("childIndex? " + childIndex);
			var selectedRow = parentChildrenRows[parseInt(parentIndex)].children[parseInt(childIndex)][0];
			if(selectedRow.blocked == false)
			{
				console.log("selectedRow??" + JSON.stringify(selectedRow));
				if(readOnly == 'false')
				{
					selectedRow.child.OB_ReadOnly__c = true;
					selectedRow.child.OB_Read_Only_CAB__c = true;
					console.log("selectedRow.child.OB_ReadOnly__c : " + selectedRow.child.OB_ReadOnly__c );
				}
				else if(readOnly == 'true')
				{
					selectedRow.child.OB_ReadOnly__c = false;
					selectedRow.child.OB_Read_Only_CAB__c = false;
				}
				component.set("v.parentChildrenRows", parentChildrenRows);
			}
			component.set("v.spinner", false);
		}else
		{
			document.getElementById(idString).nextElementSibling.innerHTML= errorMessage;
		}
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
		component.set("v.showEmptyCard", false);
	    component.set("v.SearchKeyWord", '');
	    component.set("v.Message", '');
		component.set("v.listOfSearchRecords", []);
		helper.retrieveMatrixParameterRows(component, event);
	},
	
	goBackToConfigurazioniTableBank: function(component, event, helper)
	{
	    component.set("v.goBackToConfigurazioniTableBank", true);
	},

//    Nex-005 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 21/03/2019 Start Copylogic from previous components
//                        add 4 fields into switch case,
//                        reorganize switch caseordering cases from smalest to bigest and
//                        reorganize condition in cases adding 4 new fields
//    updating attribute's value and checking its input validity:
    onChangeValueOldRow: function(component, event, helper)
    {
        console.log("into onChangeValueOldRow");
        var parentChildrenRows = component.get("v.parentChildrenRows");
        var targetId = event.getSource().get("v.id");
        var field;
        //elena.preteni 29/05/2019 R1F2-65 virgola da accettare
        var value; 
        if(event.getSource().get("v.value").includes(',')){
            value = parseFloat(event.getSource().get("v.value").replace(',','.'));
        }else{
            value = parseFloat(event.getSource().get("v.value"));
        }
        //elena.preteni 29/05/2019 R1F2-65 virgola da accettare
        console.log("value: " + value);
        console.log("targetId: " + targetId);
        if(!$A.util.isEmpty(targetId))
        {
            var parentIndex = targetId.substr(0,targetId.indexOf('_'));
            var childIndex = targetId.substr(targetId.indexOf('_')+1, targetId.indexOf('-')-2);//index+'_'+index2+'
            console.log("parentIndex? " + parentIndex);
            console.log("childIndex? " + childIndex);
			//START 17/04/19 francesca.ribezzi - PRODOB-53 - removing last char of string if it is - char
			if(childIndex.indexOf('-') != -1){
				console.log('childIndex  '+ childIndex.substr(0,childIndex.length - 1));
				childIndex = childIndex.substr(0,childIndex.length - 1);
				console.log('final childIndex '  +  childIndex);
			}
			//END  17/04/19 francesca.ribezzi 
            var selectedRow = parentChildrenRows[parseInt(parentIndex)].children[parseInt(childIndex)][0];
            field = event.getSource().get("v.name");
            console.log("field: " + field);
            console.log("selectedRow: " + JSON.stringify(selectedRow));
            var sogliaMin = selectedRow.child.OB_Soglia_Min_Approvazione__c;
            var sogliaMax = selectedRow.child.OB_Soglia_Max_Approvazione__c;
            var maxValue = selectedRow.child.OB_Massimo__c;
            var minValue = selectedRow.child.OB_Minimo__c;
            var maxPrice = selectedRow.child.OB_Massimale__c;
            var defaultValue = selectedRow.child.OB_Valore_Default__c;
            //Nex-005 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 26/03/2019 Start
            let minThresholdL3 = selectedRow.child.OB_MinThresholdL3__c;
            let minThresholdL2 = selectedRow.child.OB_MinThresholdL2__c;
            let maxThresholdL2 = selectedRow.child.OB_MaxThresholdL2__c;
            let maxThresholdL3 = selectedRow.child.OB_MaxThresholdL3__c;
            //Nex-005 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 26/03/2019 Stop
            let validity = event.getSource().get("v.validity");
            var isApproved = true;
            var numInputError = component.get("v.numInputError");
            if(validity.valid && value != null && !isNaN(value))
            {
                console.log("input is valid");
//                NEXI-8 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 11/04/2019 Start
//                condition to met:
//                OB_Minimo__c <= OB_MinThresholdL3__c <= OB_MinThresholdL2__c <= OB_Soglia_Min_Approvazione__c
//                    <= OB_Valore_Default__c <= OB_Soglia_Max_Approvazione__c <= OB_MaxThresholdL2__c <= OB_MaxThresholdL3__c
//                    <= OB_Massimo__c <= OB_Massimale__c
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
                            selectedRow.child[field] = value;
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
                            selectedRow.child[field] = value;
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
                            selectedRow.child[field] = value;
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
                            selectedRow.child[field] = value;
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
                            selectedRow.child[field] = value;
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
                            selectedRow.child[field] = value;
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
                            selectedRow.child[field] = value;
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
                            selectedRow.child[field] = value;
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
                            ($A.util.isEmpty(minThresholdL3) || value >= minThresholdL3) &&
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
                            selectedRow.child[field] = value;
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
                            selectedRow.child[field] = value;
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
//    Nex-005 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 26/03/2019 End

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
			if(parentChildrenRows[parseInt(index)].cloneId != '')//selected row
			{
				console.log("it is a clone!"); //if it's a clone
				for(var i = 0; i<parentChildrenRows.length; i++)
				{
				    //this checks if it is a cloned row and gets the row this one comes from:
                    if(parentChildrenRows[parseInt(index)].cloneId == parentChildrenRows[i].parent.Id && parentChildrenRows[i].cloneId == '')// finding its parent
                    {
                        console.log("it is a match!");
                        if($A.util.isEmpty(parentChildrenRows[i].parent.NE__End_Date__c ))
                        {
                            console.log("end date it's not empty!");
                            selectedRow = parentChildrenRows[i];
                            var action = component.get("c.calculateDate");
                            action.setParams
                            ({
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
                                }
                                else
                                {
                                    var errors = response.getError();
                                    if (errors)
                                    {
                                        if (errors[0] && errors[0].message)
                                        {
                                            console.log("Error message: " +errors[0].message);
                                        }
                                    }
                                    else
                                    {
                                        console.log("Unknown error");
                                    }
                                }
                            });
                            $A.enqueueAction(action);
                        }
                        else
                        {
                            component.set("v.spinner", false);
                        }
					 }
				}	  
			 }
			 else
			 {
				 component.set("v.spinner", false);
			 }
		}
		else
		{
			component.set("v.spinner", false);
		}
		component.set("v.parentChildrenRows", parentChildrenRows);
	},

    handleModalCancel:function(component,event,helper)
    {
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

	checkValidityDates : function(component,event,helper)
	{
		var index = event.getSource().get("v.id").split("_")[0];
		var parentStartDate = document.getElementById(index + "_parentStartDate").value;
		var parentEndDate = document.getElementById(index + "_parentEndDate").value
		//LUBRANO 2019-02-27 - Disable Pulsante Maintenance
		var dateError = component.get("v.dateError");

		if( (!$A.util.isEmpty(parentStartDate) && !$A.util.isEmpty(parentEndDate) ) && (new Date(parentStartDate) >= new Date(parentEndDate)))
		{
			//LUBRANO 2019-02-27 - Disable Pulsante Maintenance
			component.set("v.dateError",true);
			helper.checkDisabledButton(component,event);
			document.getElementById(index + "_parentStartDate").classList.add("borderErrorDates");
			document.getElementById(index + "_parentEndDate").classList.add("borderErrorDates");
			document.getElementById(index + "_parentStartDateError").innerHTML = $A.get("$Label.c.OB_InvalidEndLegitimacyDate");
			document.getElementById(index + "_parentEndDateError").innerHTML = $A.get("$Label.c.OB_InvalidEndLegitimacyDate");
		}
		else if($A.util.isEmpty(parentStartDate))
		{
			//LUBRANO 2019-02-27 - Disable Pulsante Maintenance
			component.set("v.dateError",true);
			helper.checkDisabledButton(component,event);
			document.getElementById(index + "_parentStartDate").classList.add("borderErrorDates");
			document.getElementById(index + "_parentEndDate").classList.add("borderErrorDates");
			document.getElementById(index + "_parentStartDateError").innerHTML = $A.get("$Label.c.OB_InvalidEndLegitimacyDate");
			document.getElementById(index + "_parentEndDateError").innerHTML = $A.get("$Label.c.OB_InvalidEndLegitimacyDate");
		}
		else
		{
			//LUBRANO 2019-02-27 - Disable Pulsante Maintenance
			component.set("v.dateError",false);
			helper.checkDisabledButton(component,event);
			document.getElementById(index + "_parentStartDate").classList.remove("borderErrorDates");
			document.getElementById(index + "_parentEndDate").classList.remove("borderErrorDates");
			document.getElementById(index + "_parentStartDateError").innerHTML = "";
			document.getElementById(index + "_parentEndDateError").innerHTML = "";
		}
	},

	showTooltip: function(component,event,helper)
	{
		var targetId = event.getSource().get("v.id");
		var tooltip = document.getElementById(targetId+ '_tooltip');
		tooltip.classList.remove("slds-hide");
		tooltip.classList.add("slds-show");
	},

	hideTooltip: function(component,event,helper)
	{
		var targetId = event.getSource().get("v.id"); 
		var tooltip = document.getElementById(targetId + '_tooltip');
		tooltip.classList.remove("slds-show");
		tooltip.classList.add("slds-hide");
	},


	/* Doris D.   28/03/2019 ------------- START*/
	openTooltip : function (component,event,helper){

		var selectedElement = event.currentTarget;
		var index = selectedElement.getAttribute('id');
		var parentChildrenRows = component.get("v.parentChildrenRows");
		var row = parentChildrenRows[index];
		row.showMessage = true;
		component.set("v.parentChildrenRows",parentChildrenRows);

	},
	closeTooltip : function (component,event,helper){
	
		var selectedElement = event.currentTarget;
		var index = selectedElement.getAttribute('id');		
		var parentChildrenRows = component.get("v.parentChildrenRows");
		var row = parentChildrenRows[index];
		row.showMessage = false;
		component.set("v.parentChildrenRows",parentChildrenRows);
	},

	/* Doris D.   28/03/2019 ------------- START*/

})