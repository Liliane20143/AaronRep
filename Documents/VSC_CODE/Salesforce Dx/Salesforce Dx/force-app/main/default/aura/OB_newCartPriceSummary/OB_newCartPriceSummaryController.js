({

doInit: function(component,event,helper){

	//  R1F2 Micol Ferrari <micol.ferrari@accenture.com>, 14/06/2019 - START
	//elena.preteni if condition added START
	if(component.get("v.objectDataMap")!= undefined){
		component.set("v.objectDataMap.unbind.goToNextStepSocieta", "false"); 
	}
	//elena.preteni if condition added START
	//  R1F2 Micol Ferrari <micol.ferrari@accenture.com>, 14/06/2019 - STOP

	// 11/04/2019 andrea.morittu@accenture.com start 
	var action = component.get("c.getUserInformation");
	action.setCallback(this, function(response) {
		var state = response.getState();
		if (state === "SUCCESS") {
			try {
				var currentUser = response.getReturnValue();
				console.log('currentUser is: ', currentUser);
				if(!$A.util.isUndefined(currentUser)) {
					component.set("v.currentUser", currentUser);
					//Start antonio.vatrano 28/08/2019 R1F3-10
					if(currentUser.isOperation){
						component.set('v.userLicense', 'Salesforce');
					}
					//End antonio.vatrano 28/08/2019 R1F3-10
				}
			} catch(e) {
					console.log('An error has occured: ' + e.message + ' at line : ' + e.line);
				}
		}
		else if (state === "INCOMPLETE") {
			// do something
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
	// 11/04/2019 andrea.morittu@accenture.com end 

	//26/03/19 francesca.ribezzi adding window scroll
	window.scrollTo(0, 0); 
	var isFlow = component.get("v.isFlow");
	var offerAssetId = component.get("v.offerAssetId");
	//18/07/19 francesca.ribezzi - - F2WAVE2-160 
	var orderId = component.get("v.orderId");

	if(!isFlow && !$A.util.isEmpty(orderId))
	{   	
		//_utils.debug('orderParameterDoInit: '+orderId);

		//28/02/19 francesca.ribezzi adding method to get configuration's approval status:
		helper.getConfigurationApprovalStatus(component, event, orderId);
	}else if(!isFlow && !$A.util.isEmpty(offerAssetId)){
		//20/03/19 francesca.ribezzi - Maintenance Variazione Anagrafica creating assets pricing:
		helper.createFakeContextOutput(component, event, offerAssetId);
	}

},

	//LUBRANO 16/01/2019 Libreria Log
	logInit: function(component){
		_utils.logInit(component.getName());
	},
	
 onUpdateContext : function(component, event, helper){
	try{
        _utils.debug('Inside onUpdateContext for newCartPriceSummary');
        var objectDataMap = component.get("v.objectDataMap");
        var coreOutput = event.getParam("CartService_Output");
        if(coreOutput == undefined){
        	//_utils.debug("coreOutput is undefined! return!")
        	return;
        }
        

    	//francesca.ribezzi firing updateContextEvent event to parent OB_FlowCart
		//START EVENT 
		var updateContextEvent = $A.get("e.c:OB_CustomUpdateContextEvent");
		updateContextEvent.setParams({ contesto: coreOutput});
    	updateContextEvent.fire();
    	//END event 
		var itemToUpdate =  component.get("v.itemToUpdate");
		var isMaintenanceOffer = component.get("v.isMaintenanceOffer");
		var isMaintenancePricing = component.get("v.isMaintenancePricing");
		var isEditCommissionModel = component.get("v.isEditCommissionModel");
		var isPricingProcess = (isEditCommissionModel || isMaintenancePricing); //francesca.ribezzi - perf-17 - 06/12/19 adding isPricingProcess
        var qtyMax = component.get("v.qtyMax");
        //_utils.debug("coreOutput into PriceSUmmary: " ,coreOutput);
        component.set("v.cartList", coreOutput.cart);
        var cart = component.get("v.cartList");
        
        var pos = [];
        var bancomat = [];
        var vas = [];
        var acquiring = [];
        var categoryName = [];
        var acquiringChildItems = [];
        var posChildItems = [];
        var bancomatChildItems = [];
        var vasChildItems = [];
        var pciChildItems = [];
        var pciList = [];
        var numOfCol = 0;
        var commissionColSize = 1;
        var numOfColACQ = 0;
        
        var commissionColSizeBancomat = 1;
        var numOfColBancomat = 0;
        
        var commissionColSizeVas = 1;
        var numOfColVas = 0;
        
        //label vars:
        //var uniqueLabelsAcq = [];
        var uniqueLabelsPos = [];
        var uniqueLabelsBancomat = [];
        var uniqueLabelsVas = [];
        
        var terminaliRecordType = "Terminali";
		var terminaliRecordTypeGateway = "Gateway_Virtuale";
		var terminaliRecordTypeEcommerce = "eCommerce";
		var terminaliRecordTypeMoto = "Moto";
		var pagobancomatRecordType = "Pagobancomat";
		var acquiringRecordType = "Acquiring";
		var acquiringRecordType2 = "PCI";
		var vasRecordType = "Vas";
		var pricingRecordType = 'Pricing';
				
		terminaliRecordType 			= terminaliRecordType.toLowerCase();
		terminaliRecordTypeGateway 		= terminaliRecordTypeGateway.toLowerCase();
		terminaliRecordTypeEcommerce 	= terminaliRecordTypeEcommerce.toLowerCase();
		terminaliRecordTypeMoto 		= terminaliRecordTypeMoto.toLowerCase();
		pagobancomatRecordType 			= pagobancomatRecordType.toLowerCase(); 
		acquiringRecordType 			= acquiringRecordType.toLowerCase();
		acquiringRecordType2 			= acquiringRecordType2.toLowerCase();
		vasRecordType 					= vasRecordType.toLowerCase();
        	
		var itemFakeToRemove;
     
		//if ob_main_process is setup -> all inputs in OB_childItem components must be readonly:
		var configuration = coreOutput.configuration;
		//setting new attributes for maintenance check:
		var mainProcess = configuration.ob_main_process;
		var subProcess = configuration.ob_sub_process;
		var isReadOnly = false;  //francesca.ribezzi - perf-17 - 06/12/19 isReadonly
		if((configuration.ob_main_process == "Setup" && component.get("v.isFlow") == true) || subProcess == 'variazione economica'){
			isReadOnly = false;
		}
		if(configuration.ob_main_process == "Maintenance"){
			var updateContextEvent = $A.get("e.c:OB_CustomUpdateContextEvent");
			updateContextEvent.setParams({ "disabledNextBtn": false});
        	updateContextEvent.fire();
		}
		
		   //getting cart lists for each sections (pos, pagobancomat, acquiring and vas):
    		for(var i = 0; i< cart.length; i++){
    			if(cart[i] != null){
    				//_utils.debug("into cart");
    				if(cart[i].fields.qty == qtyMax){
    					//_utils.debug("into remove");
						component.set("v.itemFakeToRemove",cart[i]);
						itemFakeToRemove = cart[i];
						continue;
						
    				}
    				//new checks for maintenance part:
    				/*if(configuration.ob_main_process == "Maintenance"){
    					//'Active' and 'variazione economica' are only used to test - waiting for real values!!
    					if(cart[i].status == 'Active'){ 
    						if(configuration.ob_sub_process == 'variazione economica'){
    							//adding a new node to the cartItem
    							cart[i].readOnly = false; //in ob_childItem = fatherItem.readOnly -> do this logic in ob_childItem doInit
    						}else{
    							cart[i].readOnly = true;
    						}
    					}
    				}*/
    				//************
    				
    				var recordTypeToMatch = cart[i].fields.RecordTypeName.toLowerCase();
    					var element = cart[i];
    					// ON HOLD: || recordTypeToMatch == terminaliRecordTypeEcommerce || recordTypeToMatch == terminaliRecordTypeMoto
    					if(recordTypeToMatch == terminaliRecordType || recordTypeToMatch == terminaliRecordTypeGateway || recordTypeToMatch == terminaliRecordTypeEcommerce || recordTypeToMatch == terminaliRecordTypeMoto  ) // ANDREA MORITTU 19-Jul-19 - F2WAVE2-147  - ADDED IF CONDITION	//davide.franzini - WN-209 - 29/07/2019 - added check for Moto
    					{	
    						if(cart[i].childItems.length != 0){ //francesca.ribezzi 06/12/19 - PERF-27 - calling setReadOnlyOnAttributes is isReadonly is false
								element.readOnly = isReadOnly? true : helper.setReadOnlyOnAttributes(component, isPricingProcess,element.fields.action);
    							pos.push(element);
    						}
    					}
    					//else if(coreOutput.listOfBundles[j].bundleElements[x].fields.name =="Gestione Pagobancomat" ){
    					else if(recordTypeToMatch == pagobancomatRecordType ){	
    						if(cart[i].childItems.length != 0){ //francesca.ribezzi 06/12/19 - PERF-27 - calling setReadOnlyOnAttributes is isReadonly is false
								element.readOnly = isReadOnly? true : helper.setReadOnlyOnAttributes(component, isPricingProcess,element.fields.action);
    							bancomat.push(element);
    						}
    					}
    					//else if(coreOutput.listOfBundles[j].bundleElements[x].fields.name =="Selezione Acquiring" ){
    					else if(recordTypeToMatch == acquiringRecordType){	
    						if(cart[i].childItems.length != 0){ //francesca.ribezzi 06/12/19 - PERF-27 - calling setReadOnlyOnAttributes is isReadonly is false
								element.readOnly = isReadOnly? true : helper.setReadOnlyOnAttributes(component, isPricingProcess,element.fields.action);
								acquiring.push(element);
    						}
    					}
    					else if(recordTypeToMatch == acquiringRecordType2){
    						if(cart[i].childItems.length != 0){ //francesca.ribezzi 06/12/19 - PERF-27 - calling setReadOnlyOnAttributes is isReadonly is false
								element.readOnly = isReadOnly? true : helper.setReadOnlyOnAttributes(component, isPricingProcess,element.fields.action);
    							pciList.push(element);
    						}
    					}
    					//else if(coreOutput.listOfBundles[j].bundleElements[x].fields.name =="Selezione VAS" ){
    					else if(recordTypeToMatch == vasRecordType ){	
    						if(cart[i].childItems.length != 0){	 //francesca.ribezzi 06/12/19 - PERF-27 - calling setReadOnlyOnAttributes is isReadonly is false
								element.readOnly = isReadOnly? true : helper.setReadOnlyOnAttributes(component, isPricingProcess,element.fields.action);
    							vas.push(element);
    						}
    					}	
    			}
    		}
	        //_utils.debug("after for ");
	        if(itemFakeToRemove != null || itemFakeToRemove != undefined){   
	        	//_utils.debug("before calling removeFakeItem");
	            	helper.removeFakeItem(component);	
	        }
   
		   if(pos != undefined && pos.length>0){
			   //_utils.debug("pos is not undefined!!");
			   pos.sort(function(a, b){
				return a.fields.sequence == b.fields.sequence ? 0 : +(a.fields.sequence > b.fields.sequence) || -1;
			});
		        
		   //check attributes in pos
		  //_utils.debug("posList before map: ", pos);
		  //francesca.ribezzi 07/10/19 - WN-566 - filtering for recordType pricing first. then sorting:
		  for(var i = 0; i < pos.length; i++){
			var filteredItems = pos[i].childItems.filter(function(value){		
				//START GIOVANNI SPINELLI - PROD-21 - FIX MIGRATION POS WITH NO SEQUENCE IN CAN_LOC IN MODIFICA PREZZI - 08/11/2019
				if( ( value.fields.RecordTypeName == pricingRecordType && value.fields.OB_Sequence__c != null ) ||
					( value.fields.RecordTypeName == pricingRecordType && value.fields.OBCodiceSfd == 'CAN_LOC' && configuration.ob_sub_process== "variazione economica" ))  
				{  //francesca.ribezzi 07/10/19 - WN-566 - adding sequence not null condition
					if(value.fields.visible == "true" || value.fields.visible == true){
						return true;
					} 
				}
			}).sort(function(a, b){
				//start antonio.vatrano prodOB_314 11/07/2019
				var intA = isNaN(parseInt(a.fields.OB_Sequence__c)) ? 0 : parseInt(a.fields.OB_Sequence__c);
				var intB = isNaN(parseInt(b.fields.OB_Sequence__c)) ? 0 : parseInt(b.fields.OB_Sequence__c);
				var sec = (intA > intB) ? 1 : -1 ;
				return sec;				
				//End antonio.vatrano prodOB_314 11/07/2019
				//END GIOVANNI SPINELLI - PROD-21 - FIX MIGRATION POS WITH NO SEQUENCE IN CAN_LOC IN MODIFICA PREZZI - 08/11/2019
			});
			 pos[i].childItems = filteredItems;
		} //for closing HERE!!
            
          
          // _utils.debug("@@@posList", pos);
           
           pos = helper.createAttribute(pos, component.get("v.posCategories"), mainProcess, subProcess);	
		   //_utils.debug("@@@posList after calling helper", pos);
	   	 
		  var labelLenPos = 0;
		  
		   if(pos.length > 0 ){
			   numOfCol = pos[0].numOfCol;
			   commissionColSize = pos[0].commissionColSize;
		   }
		   //giovanni spinelli - start - 30/08/2019 - creation label for pos in riepilogo prezzi - setup
			   try {
				   var tmpUniqueLabel = [];
				   uniqueLabelsPos.length = numOfCol;
				   for (var i = 0; i < pos.length; i++) {
					   // uniqueLabelsPos = [];
					   console.log('pos[' + i + ']: ', pos[i]);
					   for (var k = 0; k < pos[i].childItems.length; k++) {
						   var childItem = pos[i].childItems[k];
						   tmpUniqueLabel.push(JSON.parse(JSON.stringify(childItem.uniqueLabels)));
					   }
				   }
				   /**
					* delete this START francesca.ribezzi 23/07/19 - WN-168
						if(childItem.uniqueLabels.indexOf("percentuale") != -1 && uniqueLabelsPos.indexOf("percentuale") == -1){
							uniqueLabelsPos.push('percentuale');	
						}
						//END francesca.ribezzi 23/07/19 - WN-168
				    */
				   tmpUniqueLabel.sort(function (a, b) {
					   var tmpA = a.filter(
						   function (value) {
							   if (value != ' ') {
								   return true;
							   }
						   });
					   var tmpB = b.filter(
						   function (value) {
							   if (value != ' ') {
								   return true;
							   }
						   });

					   return tmpB.length - tmpA.length;
				   });
				   console.log('tmpUniqueLabel after sort : ', tmpUniqueLabel);
				   for (var i = 0; i < tmpUniqueLabel.length; i++) {
					   var currentLabel = tmpUniqueLabel[i];
					   for (var j = 0; j < currentLabel.length; j++) {
						   if (uniqueLabelsPos[j] == ' ' || !uniqueLabelsPos[j]) {
							   uniqueLabelsPos[j] = currentLabel[j];
						   } else {
							   if (currentLabel[j] && JSON.stringify(uniqueLabelsPos).indexOf(currentLabel[j]) == -1) {
								   uniqueLabelsPos[j] = uniqueLabelsPos[j] + '/ ' + currentLabel[j];
							   }
						   }
					   }
				   }
				} catch (err) {
				   console.log('GENERIC ERROR: ' + err.message);
			   }
			//giovanni spinelli - end - 30/08/2019
		   }
			/*
			####PAGOBANCOMAT LABELS###
			*/
           if(bancomat != undefined && bancomat.length>0){
				_utils.debug("into bancomat!!!!");
				//_utils.debug("bancomat:", bancomat);
				var tmpUniqueLabelBancomat = [];
				for(var i = 0; i < bancomat.length; i++){
					for(var j= 0; j < bancomat[i].childItems.length; j++){
						if(bancomat[i].childItems[j].fields.visible == "true" || bancomat[i].childItems[j].fields.visible == true){
							bancomatChildItems.push(bancomat[i].childItems[j]);
						}
					}
					
						bancomatChildItems.sort(function(a, b){
							/* ANDREA MORITTU START 03-Jul-19 PRODOB-314 */
							//start antonio.vatrano prodOB_314 11/07/2019
							var intA = parseInt(a.fields.OB_Sequence__c);
							var intB = parseInt(b.fields.OB_Sequence__c);
							var sec = (intA > intB) ? 1 : -1 ;
							return sec;
							//End antonio.vatrano prodOB_314 11/07/2019
							/* ANDREA MORITTU END 03-Jul-19 PRODOB-314 */
						});
						bancomat[i].childItems = bancomatChildItems;
				}
            
           //_utils.debug("@@@bancomat", bancomat);
           if(bancomat.length > 0 ){
           		bancomat = helper.createAttribute(bancomat, component.get("v.posCategories"), mainProcess, subProcess);	
		   //check attributes in bancomat
           }
		   //_utils.debug("@@@bancomat after calling helper", bancomat);
		   if(bancomat.length > 0 ){
			   numOfColBancomat = bancomat[0].numOfCol;
			   commissionColSizeBancomat = bancomat[0].commissionColSize;
		   }
		   var labelLenBancomat = 0;
		   //giovanni spinelli - start - 30/08/2019 - creation label for pago bancomat in riepilogo prezzi - setup
		   for(var i = 0; i<bancomat.length; i++)
		   {
				for(var k = 0; k<bancomat[i].childItems.length; k++)
				{
					var childItem = bancomat[i].childItems[k]; 
					tmpUniqueLabelBancomat.push(JSON.parse(JSON.stringify(childItem.uniqueLabels)));
					
				}	
			}
			   tmpUniqueLabelBancomat.sort(function (a, b) {
				   var tmpA = a.filter(
					   function (value) {
						   if (value != ' ') {
							   return true;
						   }
					   });
				   var tmpB = b.filter(
					   function (value) {
						   if (value != ' ') {
							   return true;
						   }
					   });

				   return tmpB.length - tmpA.length;
			   });
			   console.log('tmpUniqueLabelBancomat after sort : ', tmpUniqueLabelBancomat);
			   for (var i = 0; i < tmpUniqueLabelBancomat.length; i++) {
				   var currentLabel = tmpUniqueLabelBancomat[i];
				   for (var j = 0; j < currentLabel.length; j++) {
					   if (uniqueLabelsBancomat[j] == ' ' || !uniqueLabelsBancomat[j]) {
						   uniqueLabelsBancomat[j] = currentLabel[j];
					   } else {
						   if (currentLabel[j] && JSON.stringify(uniqueLabelsBancomat).indexOf(currentLabel[j]) == -1) {
							   uniqueLabelsBancomat[j] = uniqueLabelsBancomat[j] + '/ ' + currentLabel[j];
						   }
					   }
				   }
			   }
			   //giovanni spinelli - end - 30/08/2019
		   }
            
		   if(acquiring != undefined && acquiring.length>0){
	
			//30/01/19 francesca.ribezzi sorting acquiring by sequence:
			acquiring.sort(function(a, b){
				 return a.fields.sequence == b.fields.sequence ? 0 : +(a.fields.sequence > b.fields.sequence) || -1;
			 });
		   //check attributes in acquiring
		           for(var i = 0; i < acquiring.length; i++){
		        	   acquiringChildItems = [];
		            	for(var j= 0; j < acquiring[i].childItems.length; j++){
		            		//TODO push only if RecordTypeName is Pricing
		            		if(acquiring[i].childItems[j].fields.visible == "true" || acquiring[i].childItems[j].fields.visible == true){
		            			acquiringChildItems.push(acquiring[i].childItems[j]);
		            		}
		            	}
		            	//SORT 
		            	acquiringChildItems.sort(function(a, b){
		            		//start antonio.vatrano prodOB_314 11/07/2019
							var intA = parseInt(a.fields.OB_Sequence__c);
							var intB = parseInt(b.fields.OB_Sequence__c);
							var sec = (intA > intB) ? 1 : -1 ;
							return sec;
							//End antonio.vatrano prodOB_314 11/07/2019;
		            	});
		            	acquiring[i].childItems = acquiringChildItems;
		            } 
		               
		            //if an attribute is hidden, it removes it from acquiringChildItems list.
		            for(var i = 0; i< acquiringChildItems.length; i++){
		            	if(acquiringChildItems[i].listOfAttributes.length > 0){
				             for(var j = acquiringChildItems[i].listOfAttributes.length; j--;){    	
				            	if(acquiringChildItems[i].listOfAttributes[j].fields.hidden =="true" || acquiringChildItems[i].listOfAttributes[j].fields.hidden ==true){
				            		acquiringChildItems[i].listOfAttributes.splice(j,1);
				            	}	
				           }
				        }
		            }  
		            
		        //      _utils.debug("@@@acquiringList: " , acquiring);
		                  if(acquiring.length > 0){
		              	acquiring =	helper.createAttribute(acquiring, component.get("v.categoryCircuit"), mainProcess, subProcess);	
						  }
						  //elena.preteni prod-89 riepilogo prezzi
		              if(acquiring.length > 0 && acquiring[0].childItems[0]!= undefined && acquiring[0].childItems[0].listOfAttributes!= undefined ){
						  //elena.preteni prod-89 riepilogo prezzi
			              if(numOfColACQ < acquiring[0].childItems[0].listOfAttributes.length){
			            	  numOfColACQ = acquiring[0].childItems[0].listOfAttributes.length;
					      }
					  }
		          //    _utils.debug("@@@acquiringList after calling helper: ", acquiring);          	
            } 
         
       if(pciList != undefined && pciList.length>0){
           //check attributes in pci
           for(var i = 0; i < pciList.length; i++){
        	   pciChildItems = [];
            	for(var j= 0; j < pciList[i].childItems.length; j++){
            		//TODO push only if RecordTypeName is Pricing
            		if(pciList[i].childItems[j].fields.visible == "true" || pciList[i].childItems[j].fields.visible == true){
            			pciChildItems.push(pciList[i].childItems[j]);
            		}
            	}
            	//SORT 
            	pciChildItems.sort(function(a, b){
            		return a.fields.OB_Sequence__c == b.fields.OB_Sequence__c ? 0 : +(a.fields.OB_Sequence__c > b.fields.OB_Sequence__c) || -1;
            	});
            	pciList[i].childItems = pciChildItems;
            } 
               
            //if an attribute is hidden, it removes it from acquiringChildItems list.
            for(var i = 0; i< pciChildItems.length; i++){
            	if(pciChildItems[i].listOfAttributes.length > 0){
		             for(var j = pciChildItems[i].listOfAttributes.length; j--;){    	
		            	if(pciChildItems[i].listOfAttributes[j].fields.hidden =="true" || pciChildItems[i].listOfAttributes[j].fields.hidden ==true){
		            		pciChildItems[i].listOfAttributes.splice(j,1);
		            	}	
		           }
		        }
            }  
            
          //  _utils.debug("pciList: " , pciList);

              if(acquiring.length > 0){    
				pciList = helper.createAttribute(pciList, component.get("v.pciCategories"), mainProcess, subProcess);   
              }
		//	_utils.debug("@@@pciList after calling helper: ", pciList);
		//elena.preteni prod-89 riepilogo prezzi
			if(pciList.length > 0 && pciList[0].childItems[0]!= undefined && pciList[0].childItems[0].listOfAttributes!= undefined){
				//elena.preteni prod-89 riepilogo prezzi
				if(numOfColACQ < pciList[0].childItems[0].listOfAttributes.length){
					numOfColACQ = pciList[0].childItems[0].listOfAttributes.length;
			    }
			}
       }  
		    //sort vas List
		   if(vas != undefined && vas.length>0){
			    vas.sort(function(a, b){
					return a.fields.sequence == b.fields.sequence ? 0 : +(a.fields.sequence > b.fields.sequence) || -1;
				});
		    }
		    if(vas != undefined && vas.length>0){
		    	//check attributes in vas
			  /*  for(var i = 0; i < vas.length; i++){
	            	for(var j= 0; j < vas[i].childItems.length; j++){
	            		if(vas[i].childItems[j].fields.visible == "true" || vas[i].childItems[j].fields.visible == true){
	            			vasChildItems.push(vas[i].childItems[j]);
	            		}
	            	}
	            	//SORT vas children
	            	vasChildItems.sort(function(a, b){
	            		return a.fields.OB_Sequence__c == b.fields.OB_Sequence__c ? 0 : +(a.fields.OB_Sequence__c > b.fields.OB_Sequence__c) || -1;
	            	});
	            	
	            	vas[i].childItems = vasChildItems;
	            }*/
	          for(var i = 0; i < vas.length; i++){
		    	var filteredItems = vas[i].childItems.sort(function(a, b){
            		return a.fields.OB_Sequence__c == b.fields.OB_Sequence__c ? 0 : +(a.fields.OB_Sequence__c > b.fields.OB_Sequence__c) || -1;
            	}).filter(function(value){
            	//	_utils.debug("@@value: " ,value);
            		if(value.fields.RecordTypeName == pricingRecordType){
            			if(value.fields.visible == "true" || value.fields.visible == true){
            				return true;
            			} 
		    		}
		    	});
		    	 vas[i].childItems = filteredItems;
            } //for closing HERE!!
            
	       //    _utils.debug("@@@vasList", vas);
	           vas = helper.createAttribute(vas, component.get("v.vasCategories"), mainProcess, subProcess);	
			//   _utils.debug("@@@vasList after calling helper", vas);
			   if(vas.length > 0 ){
				   numOfColVas = vas[0].numOfCol;
				   commissionColSizeVas = vas[0].commissionColSize;
			   }
			   var labelLenVas = 0;
			   for(var i = 0; i<vas.length; i++){
				  // uniqueLabelsVas = [];
				for(var k = 0; k<vas[i].childItems.length; k++){
					var childItem = vas[i].childItems[k]; 
					if(childItem.uniqueLabels != undefined){
						labelLenVas = childItem.uniqueLabels.length;
						if(childItem.uniqueLabels.indexOf("Gratuità") != -1){
							var index = childItem.uniqueLabels.indexOf("Gratuità");
							 childItem.uniqueLabels.splice(index, 1);
							 var label = "Condizioni particolari/Mesi";
							 //childItem.uniqueLabels.push(label);
							 childItem.uniqueLabels.splice(index, 0, label);
						}
						if(labelLenVas > uniqueLabelsVas.length){
									uniqueLabelsVas = childItem.uniqueLabels;
								}
						else if(labelLenVas == uniqueLabelsVas.length){
							//check fakes
							//_utils.debug("TEST childItem: "+ childItem.uniqueLabels.indexOf(" "));
							//_utils.debug("TEST uniqueLabels: "+ uniqueLabels.indexOf(" "));
							if(childItem.uniqueLabels.indexOf(" ") == -1 && uniqueLabelsVas.indexOf(" ") != -1 ){
								uniqueLabelsVas = childItem.uniqueLabels;
							}
						}
						//component.set("v.uniqueLabels", childItem.uniqueLabels);
						//uniqueLabelsPos.push.apply(childItem.uniqueLabels);
						/*for(var x = 0; x<childItem.uniqueLabels.length; x++){
							uniqueLabelsVas.push(childItem.uniqueLabels[x]);
						}	*/
						//_utils.debug("uniqueLabelsVas attribute: ", uniqueLabelsVas);
						//break;
					}
				}	
			 }
           
           } 
		   //francesca.ribezzi 25/11/19 - performance - deleting variation logic 
		   component.set("v.posList", pos);  
		   component.set("v.pciList", pciList);
		   component.set("v.bancomatList", bancomat);
		   component.set("v.acquiringList", acquiring);
		   component.set("v.vasList", vas);
		   
		   //POS setting cols:
		   component.set("v.commissionColSize", commissionColSize);
		   //_utils.debug("numOfCol: " + numOfCol);
		   component.set("v.numOfCol", numOfCol);
		   numOfCol =  parseInt(numOfCol)+2;
    	   component.set("v.maxCol", numOfCol);	
    	   //END POS COLs
    	   
    	   //BANCOMAT setting cols:
    	   component.set("v.commissionColSizeBancomat", commissionColSizeBancomat);
		   //_utils.debug("numOfColBancomat: " + numOfColBancomat);
		   component.set("v.numOfColBancomat", numOfColBancomat);
		   numOfColBancomat =  parseInt(numOfColBancomat)+2;
    	   component.set("v.maxColBancomat", numOfColBancomat);	
    	   //END BANCOMAT COLs
    	   
    	   //VAS setting cols:
    	   component.set("v.commissionColSizeVas", commissionColSizeVas);
		//   _utils.debug("numOfColVas: " + numOfColVas);
		   component.set("v.numOfColVas", numOfColVas);
		   numOfColVas =  parseInt(numOfColVas)+2;
    	   component.set("v.maxColVas", numOfColVas);
    	   //END VAS COLs
    	   	
    	   //ACQUIRING setting cols:
    	   numOfColACQ =  parseInt(numOfColACQ)+2;
    	   component.set("v.numOfColACQ", numOfColACQ);	
    	   //END ACQUIRING COLs
    		
    	   component.set("v.uniqueLabelsPos", uniqueLabelsPos);	
    	   component.set("v.uniqueLabelsBancomat", uniqueLabelsBancomat);	
    	   component.set("v.uniqueLabelsVas", uniqueLabelsVas);	
	       component.set("v.itemToUpdate", null); 
		//end of everything
		component.set("v.contextOutput", coreOutput); 
		component.set("v.spinner", false);  	
		}catch(e){
			console.log('an error occured in OnUpdateContext function: ' + e.stack);  //francesca.ribezzi - perf-17 - 06/12/19 ading try catch block 
		}
    }, 
  
    
	onUpdateApprovalOrderRules: function(component,event, helper){ 
    	_utils.debug("into onUpdateApprovalOrderRules");
    	var idChild = event.getParam("IdChildItem");
    	var itemToUpdate = event.getParam("ChildItem");
    	var regexField = event.getParam("regexField");
    	var contextOutput = component.get("v.contextOutput");
    	    	
    	if(regexField != 'INVALID'){ 
    		var changeAttributeEvent = $A.get("e.NE:Bit2win_Event_AttributeChanged");
			changeAttributeEvent.setParams({
				'itemChanged': itemToUpdate,
				'Context_Output':contextOutput
			});										
	   		changeAttributeEvent.fire(); 			   
	  
	   		component.set("v.childItemToFocus",idChild);
	   		component.set("v.itemToUpdate", itemToUpdate);
	   		component.set("v.spinner", true);
    	}

    },
    
    //04/01/19 francesca.ribezzi showing an alert when the user changes JCB and UPI pricing (the processor must be SIA):
    showInfoAlert: function(component,event, helper){
    	_utils.debug("into showInfoAlert");
    	var infoMessage = 'è stato variato il prezzo di jcb e/o upi.';
	    if(component.get("v.isMaintenance") && component.get("v.contextOutput.configuration.OB_JCBUPIAlert")){
	    	var toastEvent = $A.get("e.force:showToast");
	        toastEvent.setParams({
	            title: '',
	            message: infoMessage,
	            //messageTemplateData: [name],
	            duration: '5000',
	            key: 'info_alt',
	            type: 'other',
	            mode: 'dismissible'
	        });
	        toastEvent.fire();
	   }
	},
	//ANDREA.MORITTU START 11/04/2019
	showHistoricPricingModal : function(component, event, helper) {
		helper.openModalHistoricPricingHelper(component, event, helper);
	},

	//ANDREA.MORITTU START 12/04/2019
	showAcquiring : function (component, event, helper) {
		helper.showAcquiringhelper(component, event, helper);
	},
	//ANDREA.MORITTU END 12/04/2019
	/*
	*	Author		:	Morittu Andrea
	*	Date		:	18-Sept-2019
	*	Task		:	EVO_PRODOB_452
	*	Description	:	On click function of 'edit' maintenance operation modal
	*/
	openModalToChooseMaintenanceOperation : function(component, event, helper) {
		let offerAssetSelected = component.get('v.offerAssetSelected');
		if(offerAssetSelected.NE__Status__c != 'In Progress') {
			component.set('v.showChooseOperationModal', true);
		} else {
			try {
				var infoMessage = $A.get("$Label.c.OB_pendingOrder");
				helper.showInfoMessage(component, event, infoMessage);
			}catch(exc) {
				console.log(exc.message);
			}
		}
	},
	/*
	*	Author		:	Morittu Andrea
	*	Date		:	18-Sept-2019
	*	Task		:	EVO_PRODOB_452
	*	Description	:	On click function of choosen maintenance operation modal
	*/
	chooseMaintenanceOperation : function(component, event, helper) {
		helper.chooseMaintenanceOperation_Helper(component, event, helper);
	},
	/*
	*	Author		:	Morittu Andrea
	*	Date		:	18-Sept-2019
	*	Task		:	EVO_PRODOB_452
	*	Description	:	On click function of 'Cancel' maintenance operation modal
	*/
	closeChoseOperationModal  : function(component, event, helper) {
		component.set('v.showChooseOperationModal', false);
	},
	/**
    *   Author      :       Francesca Ribezzi
    *   Date        :       26-11-2019
    *   Task        :       Performance
    * Description   :       handle the approvalLevel on conf  
    **/
   updateApprovalLevel: function(component, event, helper){
	   try{
			var childApprovalLevelMap =  event.getParam("value");
			helper.checkApprovalLevel(component, event, childApprovalLevelMap);  
	    }catch(e){
			console.log('exception in updateApprovalLevel: ' +e.stack);
		}
	}
})