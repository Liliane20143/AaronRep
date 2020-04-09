({
	//getting a list of Matrix Parameter Rows based on the NE__Matrix_Parameter__c lookupfield:
	doInit : function(component, event, helper) { 
		helper.retrieveMatrixParameterRows(component);
	},
	
	handleEditableRow : function(component, event, helper) {
		console.log("into handleEditableRow");
		component.set("v.attributeSpinner", true);
		console.log("index: " + event.target.id);
		var newRows = component.get("v.newRows");
		var idString = '';
		idString = event.target.id;
		var readOnly =  idString.split('_').pop();
		//var isReadOnly = readOnly.substring(0, readOnly.length() - 1);
		console.log("isReadOnly? " + readOnly);
		var index = idString.substr(0, idString.indexOf('_'));
		console.log("index? " + index);
		var selectedRow = newRows[parseInt(index)];
		var attributesAndNewRows = component.get("v.attributesAndNewRows");
		if(readOnly == 'false'){
			attributesAndNewRows[parseInt(index)].newRow.OB_ReadOnly__c = true;
			console.log("attributesAndNewRows[parseInt(index)].newRow.OB_ReadOnly__c : " + attributesAndNewRows[parseInt(index)].newRow.OB_ReadOnly__c );
			selectedRow.OB_ReadOnly__c = true;
			attributesAndNewRows[parseInt(index)].readOnly = 'true';
		}else if(readOnly == 'true'){
			attributesAndNewRows[parseInt(index)].newRow.OB_ReadOnly__c = false;
			//console.log("attributesAndNewRows[parseInt(index)].newRow[0].OB_ReadOnly__c : " + attributesAndNewRows[parseInt(index)].newRow[0].OB_ReadOnly__c );
			selectedRow.OB_ReadOnly__c = false;
				attributesAndNewRows[parseInt(index)].readOnly = 'false';
		}

		component.set("v.attributesAndNewRows", attributesAndNewRows);
		component.set("v.newRows", newRows);
		component.set("v.attributeSpinner", false);
	},
	
	handleEditableExistingRow: function(component, event, helper) {
		console.log("into handleEditableExistingRow");
		component.set("v.spinner", true);
		console.log("index: " + event.target.id);
		var parentChildrenRows = component.get("v.parentChildrenRows");
		var idString = '';
		idString = event.target.id;
		var readOnly =  idString.split('-').pop();
		console.log("isReadOnly? " + readOnly);
		var parentIndex = idString.substr(0, idString.indexOf('_'));
		var childIndex = idString.substr(idString.indexOf('_')+1, idString.indexOf('-')-2);//index+'_'+index2+'-true'
		console.log("parentIndex? " + parentIndex);
		console.log("childIndex? " + childIndex);
		var selectedRow = parentChildrenRows[parseInt(parentIndex)].children[parseInt(childIndex)];
		console.log("selectedRow??" + JSON.stringify(selectedRow));
		if(readOnly == 'false'){
			selectedRow.OB_ReadOnly__c = true;
			console.log("selectedRow.OB_ReadOnly__c : " + selectedRow.OB_ReadOnly__c );
		}else if(readOnly == 'true'){
			selectedRow.OB_ReadOnly__c = false;
		}
		component.set("v.parentChildrenRows", parentChildrenRows);
		component.set("v.spinner", false);
	},
	
	//this function makes editable only the attributes related to a matrix parameter row:
	/*handleEditAttributesRow: function(component, event, helper) { 
		console.log("into handleEditAttributesRow");
		var rows = component.get("v.rows");
		var attributes = component.get("v.attributes");
		var selectedRow = rows[event.target.id];
		console.log("selectedRow name: " +selectedRow.Name);
		for(var i = 0; i<attributes.length; i++){
			if(attributes[i].itemId == selectedRow.Id){
				attributes[i].readonly = false;
			}
		}
		component.set("v.attributes", attributes);
	},*/
	
	//getting the matrix parameter row to clone by event.currentTarget.id
	createNewRow: function(component, event, helper) {
		component.set("v.spinner", true);
		//component.set("v.disableNewCardBtn", true);
		//disabled new matrix parameter row btn:
		//document.getElementById("createNewRowBtn").disabled = true;
		//document.getElementById("createNewRowBtn").classList.add('disabledBtn');
		console.log("into createNewRow index: " + event.currentTarget.id);
		var targetId = event.currentTarget.id;
		var index =  targetId.substr(0, targetId.indexOf('_'));
		
		console.log("index: " + index);
		var parentChildrenRows = component.get("v.parentChildrenRows");
		var rowToClone = parentChildrenRows[parseInt(index)];
		/*component.set("v.tempParentChildrenRows", parentChildrenRows);
		var tempParentChildrenRows = component.get("v.tempParentChildrenRows");
		var rowToClone = tempParentChildrenRows[parseInt(index)];*/
				 //$A.util.addClass(cardToSelect, 'selectedCard');
		helper.cloneRow(component,rowToClone, index, event);
	},
	//updating changes on matrix parameter rows:
	handleSaveChangedRows: function(component, event, helper) { 
		component.set("v.spinner", true);
		helper.saveRows(component, event);
	},
	
	/*handleChangeRowValues: function(component, event, helper) { 
		console.log("into handleChangeRowValues");
		var rows = component.get("v.rows");
		var attributes = component.get("v.attributes");
		var value= event.target.value;
		var idString =  JSON.stringify(event.target.id);
		var targetId= idString.substr(1, idString.indexOf('_')); 
	//	console.log("id: " + targetId);
		// var attributeIndex = parseInt(idString.split('_').pop());
		// console.log("attributeIndex: " + attributeIndex);
		// console.log("value changed to " + value);
		// var fieldValueToChange = attributes[parseInt(targetId)][document.getElementById(event.target.id).name];
		 attributes[parseInt(targetId)][document.getElementById(event.target.id).name] = value;
		// console.log("fieldValueToChange: ", fieldValueToChange);
		//getting the correct element within the attributes list thanks to the clicked index:
		var selectedAttribute = attributes[parseInt(targetId)];
		//console.log("selectedAttribute: ", selectedAttribute);
		component.set("v.attributes", attributes);
		//updating the element in the rows list with the one contained in the attributes one:
		for(var i = 0; i< rows.length; i++){
			if(rows[i].Id == selectedAttribute.itemId){
				//console.log("testttttt: " +	rows[i][document.getElementById(event.target.id).name]);
				rows[i][document.getElementById(event.target.id).name] = attributes[parseInt(targetId)][document.getElementById(event.target.id).name];
			}
		}
		component.set("v.rows", rows);
		//helper.handleRowsAttributes(component, event);
	},*/
	
	//refreshing rows list by clicking cancel button:
	reloadRowsList: function(component, event, helper) { 
		component.set("v.spinner", true);
		helper.retrieveMatrixParameterRows(component, event);
	},
	
	//showing a card in order to create a new matrix parameter row:
	createNewMatrixRow: function(component, event, helper) { 
		console.log("into createNewMatrixRow");
		//helper.getCatalogItemsByProductId(component, event);
		//helper.getCatalogItems(component, event);
		component.set("v.showEmptyCard", true);
		component.set("v.showAttributesCard", false);
		component.set("v.SearchKeyWord", '');
		component.set("v.showEmptyCard", true);
		//component.set("v.newRow.NE__Start_Date__c", '');
		//component.set("v.newRow.NE__End_Date__c", '');
		//setting newRow as default attribute value:
		var newRow = {'sobjectType':'NE__Matrix_Parameter_Row__c', 'OB_Massimale__c':'0', 'OB_Massimo__c':'0','OB_Minimo__c':'0', 'OB_Soglia_Max_Approvazione__c':'0','OB_Soglia_Min_Approvazione__c' : '0','OB_Valore_Default__c' :'0', 'OB_SelfLookup__c' : '', 'OB_Product__c' : ''};
		component.set("v.newRow", newRow);
	},
	
	goBackToListiniTable: function(component, event, helper) { 
	
		var event = $A.get("e.force:navigateToComponent");
	    event.setParams({
	        componentDef : "c:OB_ListiniTable"
	    });
	    event.fire(); 
	},
	
	/*onChangeCatalogItem: function(component, event, helper) { 
		//var value = event.target.value;
		console.log("into onChangeCatalogItem");
		var productId= event.getSource().get("v.value");
		//var field= event.getSource().get("v.name");
		console.log("productId: " + productId);
		var newRow = component.get("v.newRow");
		newRow.OB_Product__c = productId;
		component.set("v.newRow", newRow);
		component.set("v.attributeSpinner", true);
		helper.getFamilies(component, event, productId);	
	},*/
	//inserting new rows...
	confirmSave: function(component, event, helper) {
		component.set("v.spinner", true);
		//console.log("newRow: " , component.get("v.newRow"));
		helper.insertNewRows(component, event);

	},
	//updating attribute's value and checking its input validity:
	onChangeValueNewRow: function(component, event, helper) {
		var attributesAndNewRows = component.get("v.attributesAndNewRows");
		var newRows = component.get("v.newRows");
		//var targetId = event.currentTarget.i);
		var targetId =  event.getSource().get("v.id");
		console.log("targetId: " + targetId);
		var index = targetId.substr(0,targetId.indexOf('_'));
		console.log("index: " + index);
		var newRow = newRows[parseInt(index)];
		console.log("newRow: " +  newRow);
		//var field = document.getElementById(event.target.id).name;
		var field = event.getSource().get("v.name");
		console.log("field: " + field);
		//event.target.value;
		console.log("newRow in onChangeValuewNewRow: " + JSON.stringify(newRow));
		console.log("newRows: ", newRows);
		component.set("v.newRows", newRows);
		//event.target.value;
		 var validity = event.getSource().get("v.validity");
		if(validity.valid){
			console.log(validity.valid); 
			console.log("input is valid");
			attributesAndNewRows[parseInt(index)].newRow[field] =   event.getSource().get("v.value"); 
			newRow[field] = event.getSource().get("v.value")
		}else{
			attributesAndNewRows[parseInt(index)].newRow[field] =  0,0;
		}
		component.set("v.attributesAndNewRows", attributesAndNewRows);
	},
	//updating attribute's value and checking its input validity:
	onChangeValueOldRow: function(component, event, helper) {
		console.log("into onChangeValueOldRow");		
		var parentChildrenRows = component.get("v.parentChildrenRows");
		var targetId = event.getSource().get("v.id");
		console.log("targetId: " + targetId);
		if(!$A.util.isEmpty(targetId)){
			var parentIndex = targetId.substr(0,targetId.indexOf('_'));
			var childIndex = targetId.substr(targetId.indexOf('_')+1, targetId.indexOf('-')-2);//index+'_'+index2+'
			console.log("parentIndex? " + parentIndex);
			console.log("childIndex? " + childIndex);
			var selectedRow = parentChildrenRows[parseInt(parentIndex)].children[parseInt(childIndex)];
			var field = event.getSource().get("v.name");
			console.log("field: " + field);
			console.log("selectedRow: " + JSON.stringify(selectedRow));	
			var validity = event.getSource().get("v.validity");
			if(validity.valid){
				console.log(validity.valid); 
				console.log("input is valid");
				selectedRow[field] = event.getSource().get("v.value");
				parentChildrenRows[parseInt(parentIndex)].children[parseInt(childIndex)][field] = event.getSource().get("v.value");
			}else{
				parentChildrenRows[parseInt(parentIndex)].children[parseInt(childIndex)][field] =  0,0;
				
			}
		}
		component.set("v.parentChildrenRows", parentChildrenRows);
	},
	//updating OB_Sequence__c field and checking its input validity:
	handleRightSequence: function(component, event, helper) {
		component.set("v.spinner", true);
		var parentChildrenRows = component.get("v.parentChildrenRows");
		var idString = event.target.id;
		console.log("idString: " + idString);
		var index = idString.substr(0, idString.indexOf('_'));
		console.log("index? " + index);
		
	    if(/[0-9]/g.test(event.target.value))
	    { 
	    	console.log("input is valid");
	
	    	document.getElementById(event.target.id).classList.remove('borderError');
	    	document.getElementById(index+'_SequenceError').classList.remove('slds-show');
	    	document.getElementById(index+'_SequenceError').classList.add('slds-hide');
			parentChildrenRows[parseInt(index)].parent.OB_Sequence__c = event.target.value;
			for(var i = 0; i<parentChildrenRows[parseInt(index)].children.length; i++){
				parentChildrenRows[parseInt(index)].children[i].OB_Sequence__c = event.target.value;
			}
		}else{
			document.getElementById(event.target.id).classList.add('borderError');
			document.getElementById(index+'_SequenceError').classList.add('slds-show');
	    	document.getElementById(index+'_SequenceError').classList.remove('slds-hide');
			console.log("input is NOT valid");
		}
		component.set("v.spinner", false);
		component.set("v.parentChildrenRows", parentChildrenRows);
	},
	//updating date field and checking its input validity:
	onChangeDateNewRow: function(component, event, helper) {
		var validity = event.getSource().get("v.validity");
		if(validity.valid){
			document.getElementById("saveButtonId").disabled = false;
		}else{
			document.getElementById("saveButtonId").disabled = true;
		}
		var newRow = component.get("v.newRow");
		console.log("newRow in onChangeDateNewRow: " + JSON.stringify(newRow));
		component.set("v.newRow", newRow);
	},
	//updating date field and checking its input validity:
	onChangeValueNewRowDate: function(component, event, helper) {
		var dateValue = event.getSource().get("v.value");
		console.log("dateValue: "+ dateValue);
		console.log("id?? " + event.getSource().get("v.id"));
		//var attributesAndNewRows = component.get("v.attributesAndNewRows");
		//component.set("v.attributesAndNewRows", attributesAndNewRows);
		
	},
	
/*	onChangeValueOldRowDate: function(component, event, helper) {
		var dateValue = event.getSource().get("v.value");
		console.log("dateValue: "+ dateValue);
		console.log("id?? " + event.getSource().get("v.id"));
		//var attributesAndNewRows = component.get("v.attributesAndNewRows");
		//component.set("v.attributesAndNewRows", attributesAndNewRows);
	},*/

	handleOnchangeStartDateOldRow: function(component, event, helper) {
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
		if(validity.valid){
			if(parentChildrenRows[parseInt(index)].cloneId != ''){ //selected row
				console.log("it is a clone!"); //if it's a clone
				for(var i = 0; i<parentChildrenRows.length; i++){
				//this checks if it is a cloned row and gets the row this one comes from:
					 if(parentChildrenRows[parseInt(index)].cloneId == parentChildrenRows[i].parent.Id && parentChildrenRows[i].cloneId == ''){ // finding its parent
					  console.log("it is a match!");
						if($A.util.isEmpty(parentChildrenRows[i].parent.NE__End_Date__c )){ 
						console.log("end date it's not empty!");
							//var newEndDate = new Date();
							//d.setDate(d.getDate() - 1);
							//setting the 'root' row's end date as the clone row's start date minus one:
							/*newEndDate = newEndDate.setDate(dateValue - 1);
							parentChildrenRows[i].parent.NE__End_Date__c = newEndDate;
							console.log("newEndDate" + newEndDate);*/
							selectedRow = parentChildrenRows[i];
							var action = component.get("c.calculateDate");
					        action.setParams({
					            startDate: dateValue
					        });
					        action.setCallback(this, function(response) {
					            var state = response.getState();
					            if (state === "SUCCESS") {
					               console.log("date From server: ", response.getReturnValue());
					               selectedRow.parent.NE__End_Date__c = response.getReturnValue();
					               console.log("selectedRow.parent.NE__End_Date__c: " + selectedRow.parent.NE__End_Date__c);
					                component.set("v.parentChildrenRows", parentChildrenRows);
					            } else if (state === "INCOMPLETE") {
					                // do something
					            } else if (state === "ERROR") {
					                var errors = response.getError();
					                if (errors) {
					                    if (errors[0] && errors[0].message) {
					                        console.log("Error message: " +
					                            errors[0].message);
					                    }
					                } else {
					                    console.log("Unknown error");
					                }
					            }
					        });
					
					        $A.enqueueAction(action);
					
						}
					 }
				}	  
			 }
		}
		 component.set("v.parentChildrenRows", parentChildrenRows);

	},
	//setting the clicked product as the chosen one for the new row:
	 selectRecord : function(component, event, helper){      
    	  
    	  console.log("selectedRecord value: " + event.target.value);
    	  var listOfSearchRecords = component.get("v.listOfSearchRecords");  
    	  var selectedRecord = listOfSearchRecords[event.target.id];
    	  
    	  if(selectedRecord != null){
	    	  console.log("selectedRecord: ", selectedRecord);
	    	  component.set("v.selectedRecord", selectedRecord);
	    	  var productId = selectedRecord.Id;
	    	  console.log("productId: " + productId);
				var newRow = component.get("v.newRow");
				
				console.log("newRow after setting productId: " + JSON.stringify(newRow));
				newRow.OB_Product__c = productId;
				component.set("v.newRow", newRow);
				component.set("v.attributeSpinner", true);
				
	    	var forclose = component.find("lookup-pill");
	           $A.util.addClass(forclose, 'slds-show');
	           $A.util.removeClass(forclose, 'slds-hide');
	  
	        var forclose = component.find("searchRes");
	           $A.util.addClass(forclose, 'slds-is-close');
	           $A.util.removeClass(forclose, 'slds-is-open');
	        
	        var lookUpTarget = component.find("lookupField");
	            $A.util.addClass(lookUpTarget, 'slds-hide');
	            $A.util.removeClass(lookUpTarget, 'slds-show');  
	            
	         var searchIconId = component.find("searchIconId");
		         $A.util.addClass(searchIconId, 'slds-hide');
		       //  $A.util.removeClass(pillTarget, 'slds-show');
		       helper.getFamilies(component, event, productId);
		 }
    },
     onfocus : function(component,event,helper){
       $A.util.addClass(component.find("mySpinner"), "slds-show");
     /*   var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close'); */
        // Get Default 5 Records order by createdDate DESC  
         var getInputkeyWord = '';
        // helper.searchHelper(component,event,getInputkeyWord);
    },
    onblur : function(component,event,helper){       
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
    },
    keyPressController : function(component, event, helper) {
       // get the search Input keyword   
         var getInputkeyWord = component.get("v.SearchKeyWord");
       // check if getInputKeyWord size id more then 0 then open the lookup result List and 
       // call the helper 
       // else close the lookup result List part.   
        if( getInputkeyWord.length > 1 ){
             var forOpen = component.find("searchRes");
               $A.util.addClass(forOpen, 'slds-is-open');
               $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
             component.set("v.listOfSearchRecords", null ); 
             var forclose = component.find("searchRes");
               $A.util.addClass(forclose, 'slds-is-close');
               $A.util.removeClass(forclose, 'slds-is-open');
          }
	},
    
  // function for clear the Record Selection 
    clear :function(component,event,helper){
         var pillTarget = component.find("lookup-pill");
         var lookUpTarget = component.find("lookupField"); 
         var searchIconId= component.find("searchIconId");
         $A.util.addClass(pillTarget, 'slds-hide');
         $A.util.removeClass(pillTarget, 'slds-show');
        
         $A.util.removeClass(lookUpTarget, 'slds-hide');
         $A.util.addClass(lookUpTarget, 'slds-show');
         
         $A.util.removeClass(searchIconId, 'slds-hide');
         $A.util.addClass(searchIconId, 'slds-show');
      
         component.set("v.SearchKeyWord",null);
         component.set("v.listOfSearchRecords", null );
         component.set("v.selectedRecord", {} );    
         component.set("v.showAttributesCard", false);   
    },
    //updating NE__Active__c field for both parent and children rows based on checkbox value:
    handleActivationRows:function(component,event,helper){
    	var idString = '';
		idString = event.getSource().get("v.id");

		console.log("checked? " + event.getSource().get("v.checked"));
		var checked = false;
		checked = event.getSource().get("v.checked");
		//console.log("checked? " +document.getElementById(event.target.id).checked);
		var index = idString.substr(0, idString.indexOf('_'));
		console.log("index? " + index);
		var parentChildrenRows = component.get("v.parentChildrenRows");
		parentChildrenRows[parseInt(index)].parent.NE__Active__c = !checked;
		for(var i = 0; i<parentChildrenRows[parseInt(index)].children.length; i++){
			parentChildrenRows[parseInt(index)].children[i].NE__Active__c = !checked;
		}
		console.log("activation??: ", parentChildrenRows);
		component.set("v.parentChildrenRows", parentChildrenRows);
    },
    
    deleteRow:function(component,event,helper){
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
    
    handleModalCancel:function(component,event,helper){
		//easy closing the modal
		component.set("v.Confirm",false);
	
	},
	handleModalButton:function(component,event,helper){
		component.set("v.spinner", true);
		var parentChildrenRows = component.get("v.parentChildrenRows");
		var selectedRow = component.get("v.selectedRow");
		var buttonMode = component.get("v.modalButton");
		
		if(buttonMode == 'Delete'){
			//checking if it is a clone row; if so, this method just removes it from list.
	    	//otherwise, it calls helper to also remove it from db.
		    /*	if(selectedRow.cloneId == ''){ 
		    		helper.deleteRowServer(component, event, selectedRow);	
		    	
		    	}else{
		    		component.set("v.spinner", false);
		    	}
		    }*/
			/*for(var i = parentChildrenRows.length-1; i--;){
				if(parentChildrenRows[i].cloneId == ''){ 
					parentChildrenRows.splice(i, 1);
				}
			}*/
			helper.deleteRowServer(component, event, selectedRow);	
			component.set("v.Confirm",false);
			//parentChildrenRows.splice(parseInt(index), 1);
			//component.set("v.parentChildrenRows", parentChildrenRows);
		}
	},
    
})