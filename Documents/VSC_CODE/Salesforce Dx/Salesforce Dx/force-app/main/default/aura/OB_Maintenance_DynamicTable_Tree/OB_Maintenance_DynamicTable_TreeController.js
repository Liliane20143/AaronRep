({
		init : function(component, event, helper) {
     	console.log('dynamicTable init started');
     
     	
     	
     	
     	//element.classList.remove("mystyle");
     	
     	var test = component.get("v.recordparentid"); 
     	//console.log("itemsChange aaabbbbbccccc "+test);
     
 	 	var test = component.get("v.recordparentid"); 
     	//console.log("itemsChange aaabbbbbccccc "+test);
      var parentidretrived = component.get("v.recordparentid"); 
      if(parentidretrived){
      	helper.retrieveFieldsLabel(component, event, helper);
	  }

	  
		
    },
    
    handleRowAction:  function(component, event, helper) {
    	console.log('into handleRowAction');
    	var action = event.getParam('action');
	    var row = event.getParam('row');
	    //var selectedRows = event.getParam('selectedRows');
	    // console.log("selectedRows", selectedRows);
	    console.log("row: "+ JSON.stringify(row));
	    switch (action.name) {
	        case 'editRecord':
	            helper.editRecord(component,row);
	            break;
            case 'pricing':
	           // helper.handlePricing(component,row);
	            break;
	        case 'editOffer':
	          //  helper.editOffer(component,row);
	            break;
	        case 'attributeBtn':
	        	 helper.getAssetAttribute(component,row);
				break;
			// ANDREA MORITTU START 24-Sept-2019 - PRODOB_469
			case 'innerObjects':
				helper.grabInnerObject(component, row);
				break;
			// ANDREA MORITTU END 24-Sept-2019 - PRODOB_469
	   }
  
    },
    
    closeModal:  function(component, event, helper) {
    	component.set("v.showModal", false);
    },
    updateRowAttribute:  function(component, event, helper) {
    	//console.log("dataToShow after update: ", component.get("v.dataToShow"));
    	var dataToShow = component.get("v.dataToShow");
    	var row =  component.get("v.row");
    	//console.log("dataToShow[i]['Id']: ", dataToShow[0]['Id']);
    	
    },
    
    handleEditAsset:  function(component, event, helper) {
    	var input = event.target.id;
    	//console.log("id: " + input);
    	var value = event.target.value;
    	var fieldName = document.getElementById(event.target.id).name;
    	//console.log("fieldName: "+ fieldName);
    	var row = component.get("v.row");
    	row[fieldName] = value;
    	//console.log("updated row: "+ JSON.stringify(row));
    	component.set("v.row", row);
    }
    
 /*
    itemsChange :  function(component, event, helper) {
     	var test = component.get("v.recordparentid"); 
     	console.log("itemsChange aaabbbbbccccc "+test);
    	helper.retrieveFieldsLabel(component, event, helper);
    },
  
   handleRowAction : function(component, event, helper) {
		var action = event.getParam('action');
		var row = event.getParam('row');
		console.log('action is '+action);
		console.log('row is '+row);
		console.log('row.Id is '+row.Id);
		console.log('action.name is '+action.name);

      if(action.name == 'view_Enablements'){
        helper.updateEnablements(component, event, helper,row.Id );
        component.set("v.showEnablementsModal", true);
      }
    }, */

  /*  updateSelectedRow :  function(component, event, helper) {
    	var selectedRows = event.getParam('selectedRows');
       	var switchOnload = 	component.get('v.switchOnload');

       	    	var test = component.get("v.recordparentid"); 

		
		component.set('v.selectedRow',''+selectedRows[0].Id);

		if('OFFER' == component.get('v.queryType')) {
			component.set('v.switchOnload',!switchOnload);
		}

    } */

    	
})