({
	loadConfigurazioni : function(component,page) {
		
		var pageSize = component.get("v.pageSize");
		var offerta = component.get("v.offerta").Name;
		var abi = component.get("v.abiCabLov").NE__Value1__c;
		var cab = component.get("v.abiCabLov").Name;
		
        var action = component.get("c.getConfigurazioni");
        action.setParams({ 
        	"pageSize": pageSize,
          	"pageNumber": page || 1,
          	"offerta": offerta,
          	"abi" : abi,
          	"cab": cab
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            var pageList = [];
            
            if (state === "SUCCESS") {
                //manage the resp 
                console.log("response: ",response.getReturnValue());
                var result = response.getReturnValue();
                component.set("v.configurazioniList", result.configurazioniList);
                
                var configurazioniListTotal = result.configurazioniListTotal;

               //manage filling of multiselect TODO
                component.set("v.configurazioniSchemaNoDuplicate",result.pickListPrezzi);
                component.set("v.configurazioniModelliNoDuplicate",result.pickListModelli);
                
                
	            // Added code to set the values for the page, 
	            // total and pages attributes
	            component.set("v.page", result.page);
	            component.set("v.total", result.total);
	            component.set("v.pages", Math.ceil(result.total/pageSize));
	            for(var i = 1; i <=Math.ceil(result.total/pageSize); i++){
	            	pageList.push(i);
	            }
	            component.set("v.pagesList",pageList);
	            
	            this.changeSizePageContainer(component,result);
	            
				component.set("v.Spinner", false);
            }
            else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
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
        component.set("v.Spinner", true);
	},
	searchconfigurazioni: function(component,page) {
		
		var pageSize = component.get("v.pageSize");
		var name = component.get("v.name");
		var listino = component.get("v.listino");
    	var schemaPrezzi = component.get("v.schemaPrezzi");
    	var modello = component.get("v.modello");
		
		var fromDate = component.get("v.from");
		var toDate = component.get("v.to");
		
		var offerta = component.get("v.offerta").Name;
		var abi = component.get("v.abiCabLov").NE__Value1__c;
		var cab = component.get("v.abiCabLov").Name;
		//var abi will become:
		//var abi = component.get("v.currentUser").OB_Abi__c;
		
        var action = component.get("c.searchConfigurazioniServer");
        action.setParams({ 
        	"pageSize": pageSize,
          	"pageNumber": page || 1,
          	"name":name,
          	"fromDate":fromDate.toString(),
          	"toDate":toDate.toString(),
          	"offerta": offerta,
          	"listino":listino,
          	"schemaPrezzi":schemaPrezzi,
          	"modello":modello,
          	"abi" : abi,
          	"cab" : cab
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            var pageList = [];
            
            if (state === "SUCCESS") {
                //manage the resp 
                console.log("response: ",response.getReturnValue());
                var result = response.getReturnValue();
                if(result == null){
                	//some error msg
                	component.set("v.configurazioniList", null);
                	console.log("ERRORE APEX NULL");
                }
                else{
                	component.set("v.configurazioniList", result.configurazioniList);
                
		            // Added code to set the values for the page, 
		            // total and pages attributes
		            component.set("v.page", result.page);
		            component.set("v.total", result.total);
		            component.set("v.pages", Math.ceil(result.total/pageSize));
		            for(var i = 1; i <=Math.ceil(result.total/pageSize); i++){
		            	pageList.push(i);
		            }
		            component.set("v.pagesList",pageList);
		            
		            this.changeSizePageContainer(component,result);
		            
		            if( !($A.util.isEmpty(name)) || !($A.util.isEmpty(fromDate)) || !($A.util.isEmpty(toDate)) || !($A.util.isEmpty(listino)) || !($A.util.isEmpty(schemaPrezzi)) || !($A.util.isEmpty(modello)) )
		            {
		            	component.set("v.resetForm",true);
		            }
	            }
				component.set("v.Spinner", false);
            }
            else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
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
        component.set("v.Spinner", true);
		
	},
	createconfigurazione: function(component,page) {
		
		var pageSize = component.get("v.pageSize");
		
		var name = component.get("v.name");
		var listino = component.get("v.listino");
    	var schemaPrezzi = component.get("v.schemaPrezzi");
    	var modello = component.get("v.modello");
		
		var from = component.get("v.from");
		var to = component.get("v.to");
		
		var offertaId = component.get("v.offerta").Id;
		var offertaName = component.get("v.offerta").Name;
		

		if(name == null){
			console.log("Name cannot be null");
			//border red
			return false;
		}
		
        var action = component.get("c.creaConfigurazioneServer");
        action.setParams({ 
        	"pageSize": pageSize,
          	"pageNumber": page || 1,
          	"name":name,
          	"fromDate":from,
          	"toDate":to,
          	"offerta": offertaId,
          	"listino":listino,
          	"schemaPrezzi":schemaPrezzi,
          	"modello":modello
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            var pageList = [];
            
            if (state === "SUCCESS") {
                //manage the resp 
                console.log("response: ",response.getReturnValue());
                var result = response.getReturnValue();
                component.set("v.configurazioniList", result.configurazioniList);
	            // Added code to set the values for the page, 
	            // total and pages attributes
	            component.set("v.page", result.page);
	            
	            var oldTotal = component.get("v.total");
	            
	            if(oldTotal == result.total){
	            	//DUPLICATE notification
					this.showWarningDuplicateToast(component,event,result.configurazione.OB_Componente__r.NE__Product_Name__c,offertaName);
					//end notification
	            }
	            else{
	            
		            component.set("v.total", result.total);
		            component.set("v.pages", Math.ceil(result.total/pageSize));
		            for(var i = 1; i <=Math.ceil(result.total/pageSize); i++){
		            	pageList.push(i);
		            }
		            component.set("v.pagesList",pageList);
		            
		            this.changeSizePageContainer(component,result);

					//toast notification
					this.showSuccessToast(component, event,result.configurazione.OB_Componente__r.NE__Product_Name__c,offertaName);
					//end notification
				}

				component.set("v.Spinner", false);
            }
            else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
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
        component.set("v.Spinner", true);
		
	},
	deleteconfigurazione: function(component,page,configurazione) {
		
		var pageSize = component.get("v.pageSize");
		
		var offerta = component.get("v.offerta").Name;
		
        var action = component.get("c.deleteconfigurazioneServer");
        action.setParams({ 
        	"pageSize": pageSize,
          	"pageNumber": page || 1,
          	"configurazioneToDelete":configurazione,
          	"offerta": offerta
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            var pageList = [];
            
            if (state === "SUCCESS") {
                //manage the resp 
                console.log("response: ",response.getReturnValue());
                var result = response.getReturnValue();
                component.set("v.configurazioniList", result.configurazioniList);
	            // Added code to set the values for the page, 
	            // total and pages attributes
	            component.set("v.page", result.page);
	            component.set("v.total", result.total);
	            component.set("v.pages", Math.ceil(result.total/pageSize));
	            for(var i = 1; i <=Math.ceil(result.total/pageSize); i++){
	            	pageList.push(i);
	            }
	            component.set("v.pagesList",pageList);
	            
	            this.changeSizePageContainer(component,result);
	            
				component.set("v.Spinner", false);
				
				//toast notification
				this.showSuccessDeleteToast(component,event,configurazione.OB_Componente__r.NE__Product_Name__c,offerta);
				//end notification
            }
            else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
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
        component.set("v.Spinner", true);
		
	},

	changeSizePageContainer: function(component,result){
	
	//marco.ferri start alghoritm to dynamically set the col size
	    var pageText = component.find('totListini');
	    var pageTextBottom = component.find('totListini2');
	    var oldnumber = component.get("v.oldNumber");
	    var pageSize = component.get("v.pageSize");
	    
	    if(oldnumber != null){ 
	    	oldsizeClass = 'slds-size_'+oldnumber+'-of-6 slds-medium-size_'+oldnumber+'-of-6 slds-small-size_'+oldnumber+'-of-6'
	    	$A.util.removeClass(pageText, oldsizeClass);
	    	$A.util.removeClass(pageTextBottom, oldsizeClass);
	    	
	    }
	    var pages = Math.ceil(result.total/pageSize); 
	    console.log("pages "+ pages);
	    //failing at alghoritms....
	    if(pages <= 6){
	    	number = 5;
	    }
	    else if(pages > 6 && pages < 10){
	    	number = 4;
	    }
	    else if(pages > 10 && pages < 20){
	    	number = 3;
	    }
	    else if(pages > 20 && pages < 30){
	    	number = 2;
	    }
	    else if(pages >30){
	    	number = 1;
	    }
	    //END
	    console.log("number "+number);
	    var sizeClass = 'slds-size_'+number+'-of-6 slds-medium-size_'+number+'-of-6 slds-small-size_'+number+'-of-6';
	    $A.util.addClass(pageText, sizeClass);
	    $A.util.addClass(pageTextBottom, sizeClass);   
	    component.set("v.oldNumber",number);
	    //end
	},
	
	showSuccessToast : function(component, event,name,listino) {
		
		var successLabelmsg = $A.get("$Label.c.OB_SuccessToastLabel");
		var successLabelhead = $A.get("$Label.c.OB_SuccessToastHead");
		
		 
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : successLabelhead,
            message: 'test message',
            messageTemplate: '{0} in {1} {2}',
            messageTemplateData: [name,listino,successLabelmsg],
            duration:'5000',
            key: 'info_alt',
            type: 'success',
            mode: 'dismissible'
        });
        toastEvent.fire();
	},
	showSuccessDeleteToast : function(component, event,name,listino) {
	
		var deleteLabelmsg = $A.get("$Label.c.OB_DeleteToastLabel");
		var deleteLabelhead = $A.get("$Label.c.OB_DeleteToastHead");
		 
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : deleteLabelhead,
            message: 'test message',
            messageTemplate: '{0} in {1} {2}',
            messageTemplateData: [name,listino,deleteLabelmsg],
            duration:'5000',
            key: 'info_alt',
            type: 'success',
            mode: 'dismissible'
        });
        toastEvent.fire();
	},
	
	showWarningDuplicateToast : function(component, event,name,listino) {
		
		var duplicateLabelmsg = $A.get("$Label.c.OB_DuplicateToastLabel");
		var duplicateLabelhead = $A.get("$Label.c.OB_DuplicateToastHead");
			 
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : duplicateLabelhead,
            message: 'test message',
            messageTemplate: '{0} in {1} {2}',
            messageTemplateData: [name,listino,duplicateLabelmsg],
            duration:'5000',
            key: 'info_alt',
            type: 'warning',
            mode: 'dismissible'
        });
        toastEvent.fire();
	},
	searchHelper : function(component, event) {
		
      var searchText = component.get('v.SearchKeyWord');
      
      var action = component.get('c.searchForProducts');
      action.setParams({searchText: searchText});
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === 'SUCCESS') {
          var products = response.getReturnValue();
            console.log("products found: ", products);
             // if storeResponse size is equal 0 ,display No Result Found... message on screen.    
	        if (products.length == 0) {
	        	var message = $A.get("$Label.c.OB_NoResultMsg");
	            component.set("v.Message", message);
	        } else {
	            component.set("v.Message", '');
	            //component.set("v.catalogItems", products);
	        }
          component.set("v.listOfSearchRecords", products);
        }
      });
      $A.enqueueAction(action);
    },
    searchHelper2 : function(component, event) {
		
      var searchText = component.get('v.SearchKeyWord2');
      
      var action = component.get('c.searchForCatalogs');
      action.setParams({searchText: searchText});
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === 'SUCCESS') {
          var catalogs = response.getReturnValue();
            console.log("catalogs found: ", catalogs);
             // if storeResponse size is equal 0 ,display No Result Found... message on screen.    
	        if (catalogs.length == 0) {
	        	var message = $A.get("$Label.c.OB_NoResultMsg");
	            component.set("v.Message2", message);
	        } else {
	            component.set("v.Message2", '');
	            //component.set("v.catalogItems", products);
	        }
          component.set("v.listOfSearchRecords2", catalogs);
        }
      });
      $A.enqueueAction(action);
    },				
})