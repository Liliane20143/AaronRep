({
	loadConfigurazioni : function(component,page) {
		
		var pageSize = component.get("v.pageSize");
		var offerta = component.get("v.offerta").Name;
		var orderName = component.get('v.orderName');
		var sortDirection = component.get('v.sortDirection');
		//alert(orderName);
        var action = component.get("c.getConfigurazioni");
        action.setParams({ 
        	"pageSize"		: pageSize,
          	"pageNumber"	: page || 1,
			"offerta"		: offerta,
			"orderName" 	: orderName, //<--add by giovanni spinelli
			"sortDirection"	: sortDirection//<--add by giovanni spinelli
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            var pageList = [];
            
            if (state === "SUCCESS") {
                //manage the resp 
                console.log("response: ",response.getReturnValue());
				var result = response.getReturnValue();
				
				var configurazioniList 	= 	component.get("v.configurazioniList"),
					hasFilter			=	component.get('v.hasFilter'),
					selectedName		=	component.get('v.selectedRecord2.Name');	
				
				/*
				  giovanni spinelli 25/03/2019 - start
				  when i open at first time the page i have 
				  length =0 so I set the list from apex method - 
				  when i go back after open detail page I use previous list
				*/ 
				//giovanni spinelli 25/03/2019 - start
				if(hasFilter==false)
				{
					// alert(orderName);
					/*
						skip the update of list if order name is schema prezzi--> the sort is on javascript
						because it is a picklist and soql order by method doesn't work with picklist
					*/
					if(orderName!='OB_SchemaPrezzi__c'){
						component.set("v.configurazioniList", (result.configurazioniList).slice(0,20));// <-- list with 20 configurations
						component.set("v.configurazioniListTotal", result.configurazioniList);// <-- list with all configurations
					}else{
						var list = component.get('v.configurazioniList');
						var listTotal=component.get('v.configurazioniListTotal');
						//alert(listTotal.length);
						if(page==1){
							component.set("v.configurazioniList", listTotal.slice(0,20));
						}else if(page==2){
							component.set("v.configurazioniList", listTotal.slice(20,40));
						}else if(page==3){
							component.set("v.configurazioniList", listTotal.slice(40,60));
						}
					}
					
					component.set("v.total", result.total);
					// Added code to set the values for the page, 
					// total and pages attributes
					component.set("v.page", result.page);
					component.set("v.pages", Math.ceil(result.total/pageSize));
					for(var i = 1; i <=Math.ceil(result.total/pageSize); i++){
						pageList.push(i);
					}
					component.set("v.pagesList",pageList);
				}
				/*show lightning pill only if in previous step I have filter by 'price list'*/
				if(selectedName){
					var forshow = component.find("lookup-pill2");
					$A.util.addClass(forshow, 'slds-show');
					$A.util.removeClass(forshow, 'slds-hide');
			
					var forclose = component.find("searchRes2");
					$A.util.addClass(forclose, 'slds-is-close');
					$A.util.removeClass(forclose, 'slds-is-open');
					
					var lookUpTarget = component.find("lookupField2");
					$A.util.addClass(lookUpTarget, 'slds-hide');
					$A.util.removeClass(lookUpTarget, 'slds-show');  
						
					var searchIconId = component.find("searchIconId2");
					$A.util.addClass(searchIconId, 'slds-hide');
				}
				//giovanni spinelli 25/03/2019 - end
				
				// console.log("configurazioniList length : ", result.configurazioniList.length);
				// console.log("configurazioniList  : ", JSON.stringify(result.configurazioniList));
                //manage filling of multiselect TODO
                component.set("v.configurazioniSchemaNoDuplicate",result.pickListPrezzi);
                component.set("v.configurazioniModelliNoDuplicate",result.pickListModelli);
                
              
                
	            
	            
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
		


		//Doris D....16/03/2019...Start		
		var action = component.get('c.listProducts');
		
		action.setCallback(this, function(response) {
		  var state = response.getState();
		  if (state === 'SUCCESS') {
			var products = response.getReturnValue();
			console.log("products list : ",products);
			  console.log("products list : ", JSON.stringify(products));
			  	  //24/07/19 francesca.ribezzi setting catalogItems;
			  component.set("v.catalogItems", products);

			var listComponent = [];	
			
			  for (var indice in products) {				
				console.log('configurazioniNameNoDuplicate --->' +products[indice]);
				listComponent.push(products[indice].NE__Product_Name__c);
			  }
			  component.set("v.configurazioniNameNoDuplicate",listComponent);
			  console.log('configurazioniNameNo ççç  --->' + component.get("v.configurazioniNameNoDuplicate"));
				 
			  if (products.length == 0) {
				  var message = $A.get("$Label.c.OB_NoResultMsg");
				  component.set("v.Message", message);
			  } else {

				  component.set("v.Message", '');
				 
				}
		}else{
			alert('error');
		}
		});
		$A.enqueueAction(action);
	  //Doris D....16/03/2019.......Fin
	},

	
	searchconfigurazioni: function(component,page) {
		
		var pageSize = component.get("v.pageSize");
		var name = component.get("v.nameProduct");// component.get("v.name"); DD. 18/03/2019
		var listino = component.get("v.listino");
    	var schemaPrezzi = component.get("v.schemaPrezzi");
    	var modello = component.get("v.modello");
		
		var fromDate = component.get("v.from");
		var toDate = component.get("v.to");
		
		var offerta = component.get("v.offerta").Name;
		//alert('SCHEMA PREZZI-->');
		if(component.get('v.orderName')=='OB_SchemaPrezzi__c' ){
			component.set('v.orderName' 	, '');// <--SET NULL ORDER VALUE to reset when i do a search with filter
		}
		
		var orderName = component.get('v.orderName');
		var sortDirection = component.get('v.sortDirection');
		var action = component.get("c.searchConfigurazioniServer");
		var hasFilter = component.get('v.hasFilter');
		
        action.setParams({ 
        	"pageSize": pageSize,
          	"pageNumber": page || 1,
          	"nameProduct":name, //	"name":name, DD. 18/03/2019
          	"fromDate":fromDate.toString(),
          	"toDate":toDate.toString(),
          	"offerta": offerta,
          	"listino":listino,
          	"schemaPrezzi":schemaPrezzi,
			"modello":modello,
			"orderName" 	: orderName, //<--add by giovanni spinelli
			"sortDirection"	: sortDirection//<--add by giovanni spinelli
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            var pageList = [];
            
            if (state === "SUCCESS") {
                //manage the resp 
                console.log("response searchconfigurazioni : ",response.getReturnValue());
                var result = response.getReturnValue();
                if(result == null){
                	//some error msg
                	component.set("v.configurazioniList", null);
                	console.log("ERRORE APEX NULL");
                }
                else{
					// alert('into else');
                	/*
						skip the update of list if order name is schema prezzi--> the sort is on javascript
						because it is a picklist and soql order by method doesn't work with picklist
					*/
					if(orderName!='OB_SchemaPrezzi__c' ){
						component.set("v.configurazioniList", (result.configurazioniList).slice(0,20));// <-- list with 20 configurations
						component.set("v.configurazioniListTotal", result.configurazioniList);// <-- list with all configurations
					}else{
						var list = component.get('v.configurazioniList');
						var listTotal=component.get('v.configurazioniListTotal');
						//alert(listTotal.length);
						if(page==1){
							component.set("v.configurazioniList", listTotal.slice(0,20));
						}else if(page==2){
							component.set("v.configurazioniList", listTotal.slice(20,40));
						}else if(page==3){
							component.set("v.configurazioniList", listTotal.slice(40,60));
						}
					}
					//giovanni spinelli 26/03/2019 - start
					component.set('v.hasFilter' , true);
					//giovanni spinelli 26/03/2019 - end
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
					//START francesca.ribezzi 25/07/19 checking if OB_Componente__c is null
					var componente = '';
					if(!$A.util.isEmpty(result.configurazione.OB_Componente__c)){
						componente = result.configurazione.OB_Componente__r.NE__Product_Name__c;
					}
	            	//DUPLICATE notification
					this.showWarningDuplicateToast(component,event,componente,offertaName);
					//END francesca.ribezzi 25/07/19
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
	            //francesca.ribezzi - redirect to OB_ConfigurationDetails after creating a new Price List:
	            var offerta = component.get("v.offerta");
	            var event = $A.get("e.force:navigateToComponent");
			    event.setParams({
			        componentDef : "c:OB_ConfigurationDetails",
			        componentAttributes : {
	      	            offer: offerta,
	      	            matrixParameter : result.configurazione
			        }	
			    });
			    event.fire(); 
	            
	            
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