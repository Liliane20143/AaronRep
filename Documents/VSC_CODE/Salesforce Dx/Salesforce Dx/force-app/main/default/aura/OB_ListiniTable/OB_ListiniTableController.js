({
	 doInit : function(component, event, helper) {
    
    	console.log("__init");
    	helper.loadListini(component);	
    
	},
	onPagePrevious: function(component, event, helper) {
		var page = component.get("v.page") || 1;
        page = page - 1;
        
        //check if a search is been made
		var name = component.get("v.name");
		var from = document.getElementById("dateFrom").value;
		var to = document.getElementById("dateTo").value;
		
		if(!$A.util.isEmpty(name)|| !$A.util.isEmpty(from) || !$A.util.isEmpty(to)){
			helper.searchlistini(component,page);
		}
		else{
			helper.loadListini(component,page);
		}		
        	
    },
    onPageNext: function(component, event, helper) {
    	var page = component.get("v.page") || 1;
        page = page + 1;
        //check if a search is been made
		var name = component.get("v.name");
		var from = document.getElementById("dateFrom").value;
		var to = document.getElementById("dateTo").value;
		
		if(!$A.util.isEmpty(name)|| !$A.util.isEmpty(from) || !$A.util.isEmpty(to)){
			helper.searchlistini(component,page);
		}
		else{
			helper.loadListini(component,page);
		}		
    },
    onPageSelected: function (component,event,helper){
    	var page = event.currentTarget.id;
    	//check if a search is been made
		var name = component.get("v.name");
		var from = document.getElementById("dateFrom").value;
		var to = document.getElementById("dateTo").value;
		
		if(!$A.util.isEmpty(name)|| !$A.util.isEmpty(from) || !$A.util.isEmpty(to)){
			helper.searchlistini(component,page);
		}
		else{
			helper.loadListini(component,page);
		}		
    },  
    editListino :function(component, event, helper) {
    	
    	var listinoIndex = event.currentTarget.name;
    	var listinoList = component.get("v.listiniList");
    	component.set("v.selectedMatrix", listinoList[listinoIndex]);
    	component.set("v.goToCatalogDetails", true);
    	//console.log("sto editando listino all'indice ",listinoList[listinoIndex]);
    	
    	/*var evt = $A.get("e.force:navigateToComponent");
    	
	    evt.setParams({
	        componentDef : "c:CLONE_OB_CatalogDetails", //used to be OB_CatalogDetails
	        componentAttributes: {
	            matrixParameter : listinoList[listinoIndex]
	        }
	    });
	    evt.fire();*/
    },
    deleteListino :function(component, event, helper) {
    	console.log("init Delete"); 
    	var listinoIndex = event.currentTarget.name;
    	var listinoList = component.get("v.listiniList");
    	component.set("v.listinoToDelete",listinoList[listinoIndex]);
    	
    	console.log("listinoToDelete",listinoList[listinoIndex]);
    	//set modal attributes
    	var deleteLabel = $A.get("$Label.c.OB_Delete");
    	var deleteMsg = $A.get("$Label.c.OB_DeleteMsg");
    	var deleteHeader = $A.get("$Label.c.OB_DeleteHeader");
    	
    	component.set("v.modalButton",deleteLabel);
    	component.set("v.modalDesc",deleteMsg+' "'+listinoList[listinoIndex].Name+'" ?');
    	component.set("v.modalHeader",deleteHeader);
    	
    	component.set("v.Confirm",true);
    	
    },
    searchListini :function(component, event, helper) {
    	var name = document.getElementById("Nome").value;
    	var from = document.getElementById("dateFrom").value;
    	var to = document.getElementById("dateTo").value;
    	console.log("parameters are: "+name+","+from+","+to);
    	
    	component.set("v.name",name);
    	component.set("v.from",from);
    	component.set("v.to",to);
    	
    	//reset ALL error msgs
    	document.getElementById("Nome").classList.remove("borderError");
    	document.getElementById("dateFrom").getElementsByTagName("input")[0].classList.remove("borderError");
    	document.getElementById("dateTo").getElementsByTagName("input")[0].classList.remove("borderError");
    	var errorMsgs = [];
    	component.set("v.errorMsg",errorMsgs);
    	
    	
    	
    	if(!$A.util.isEmpty(name)|| !$A.util.isEmpty(from) || !$A.util.isEmpty(to)){
    		var page = 1; //make it so the user will always start from first page
    		helper.searchlistini(component,page);
    	}
    },
    newListino:function(component, event, helper) {
    	console.log("__init newListino1");
        //var createRecordEvent = $A.get("event.force:createRecord");
        var name = document.getElementById("Nome").value;
    	var from = document.getElementById("dateFrom").value;
    	var to = document.getElementById("dateTo").value;
    	
    	console.log("parameters are: "+name+","+from+","+to);
    	
    	component.set("v.name",name);
    	component.set("v.from",from);
    	component.set("v.to",to);
    	
        if(name != '' && from != ''  ){ //&& to != ''
        	//reset ALL error msgs
        	document.getElementById("Nome").classList.remove("borderError");
        	document.getElementById("dateFrom").getElementsByTagName("input")[0].classList.remove("borderError");
        	document.getElementById("dateTo").getElementsByTagName("input")[0].classList.remove("borderError");
        	var errorMsgs = [];
        	component.set("v.errorMsg",errorMsgs);
        	
    		var page = 1; //make it so the user will always start from first page
    		helper.createlistini(component,page);
    		
    		//reset form
    		document.getElementById("Nome").value = '';
    		document.getElementById("dateFrom").value = '';
    		document.getElementById("dateTo").value ='';
    	}
    	else{
    		console.log("ERROR with input");
    		var errorMsgs = [];
    		
    		//get custom labels
    		var NameError = $A.get("$Label.c.OB_NameFieldError");
    		var FromValError = $A.get("$Label.c.OB_ValidityFROMError");
    		var ToValError = $A.get("$Label.c.OB_ValidityTOError");
    		
    		//error messages on every null element
    		if(name == '')
    		{
    			document.getElementById("Nome").classList.add("borderError");
    			//add error msg
    			errorMsgs.push({
    				parameter: "Nome",
    				message: NameError
    			});    			
    		}
    		else{
    			//reset errMsg
    			document.getElementById("Nome").classList.remove("borderError");
    		}
    		if(from == '')
    		{
    			document.getElementById("dateFrom").getElementsByTagName("input")[0].classList.add("borderError");
    			//add error msg
    			errorMsgs.push({
    				parameter: "dateFrom",
    				message: FromValError
    			});
    					
    		}
    		else{
    			//reset errMsg
    			document.getElementById("dateFrom").getElementsByTagName("input")[0].classList.remove("borderError");
    			errorMsgs.push({
    				parameter: "dateFrom",
    				message: ''
    			});
    		}
    		/*
    		if(to == '')
    		{
    			document.getElementById("dateTo").getElementsByTagName("input")[0].classList.add("borderError");
    			
    			//add error msg
    			errorMsgs.push({
    				parameter: "dateTo",
    				message: ToValError
    			});
	
    		}
    		else{
    			//reset errMsg
    			document.getElementById("dateTo").getElementsByTagName("input")[0].classList.remove("borderError");

    			
    		}
    		*/
    		component.set("v.errorMsg",errorMsgs);
    		//console.log("v.errorMsg",errorMsgs);
    	}   
	},
	handleModalCancel:function(component,event,helper){
		//easy closing the modal
		component.set("v.Confirm",false);
	
	},
	handleModalButton:function(component,event,helper){
		var page = 1;
		var buttonMode = component.get("v.modalButton");
		if(buttonMode == 'Delete'){
			var listinoToDelete  = component.get("v.listinoToDelete");
			helper.deletelistino(component,page,listinoToDelete);
			component.set("v.Confirm",false);
		}
		else{
			console.log("Error!");
			component.set("v.Confirm",false);
		}
	},
	cleanForms:function(component,event,helper){
		
		document.getElementById("Nome").value = '';
    	document.getElementById("dateFrom").value= '';
    	document.getElementById("dateTo").value = '';
		component.set("v.resetForm",false);
	}
})