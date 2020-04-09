({
	//22/07/19 francesca.ribezzi splitOrderItemPOS function deleted - checkout splits  items now - performance

	buildPageLists : function(component,event,cart){

		console.log('cart: ', cart);
		var pos = [];
		//08/07/19 francesca.ribezzi -  antonio.vatrano code moved here from onUpdateContextOutput
		var posAdd = []; //antonio.vatrano 30/05/2019 RI-88
        var bancomat = [];
        var vas = [];
        var acquiring = [];
        //var categoryName = [];
		var terminalIdItems = {};  //francesca.ribezzi 30/09/19 - changing list to map id orderItem
		var server2server = [];//[09-05-2019 No Card Present Server2Server] Andrea Saracini
		//recordTypes to match
		var terminaliRecordType = "Terminali";
		var terminaliRecordTypeGateway = "Gateway_Virtuale";
		var terminaliRecordTypeEcommerce = "eCommerce";
		var terminaliRecordTypeMoto = "Moto";
		var pagobancomatRecordType = "Pagobancomat";
		var acquiringRecordType = "Acquiring";
		var vasRecordType = "Vas";
		var bundleRecordType = "Tariff_Plan"; //09/10/19 francesca.ribezzi WN-551 - adding bundle RecordType
		//START Simone Misani WN-218
		var oneClick = 'ONECLICK';
		var recurring ='RECURRING';
		//END Simone Misani WN-218

		terminaliRecordType = terminaliRecordType.toLowerCase();
		terminaliRecordTypeGateway = terminaliRecordTypeGateway.toLowerCase();
		terminaliRecordTypeEcommerce = terminaliRecordTypeEcommerce.toLowerCase();
		terminaliRecordTypeMoto = terminaliRecordTypeMoto.toLowerCase();
		pagobancomatRecordType = pagobancomatRecordType.toLowerCase(); 
		acquiringRecordType = acquiringRecordType.toLowerCase();
		vasRecordType = vasRecordType.toLowerCase();
		bundleRecordType = bundleRecordType.toLowerCase();  //09/10/19 francesca.ribezzi WN-551 - adding bundle RecordType
		//08/07/19 francesca.ribezzi -  Andrea Saracini code moved here from onUpdateContext
		//check racSia
		var coreOutput = component.get("v.contextOutput");
		var ob_racSiaNexi = "Nexi"; //nexi
		var ob_racSiaNexiToMatch = ob_racSiaNexi.toLowerCase();
		//11/07/19 francesca.ribezzi _ get value from racSIACurrent attribute:
		var ob_racSIACurrent = component.get("v.racSIACurrent");	
		var ob_racSIACurrentToMatch;
		if(!$A.util.isEmpty(ob_racSIACurrent)){
			ob_racSIACurrentToMatch = ob_racSIACurrent.toLowerCase();
		}
		//var ob_racSIACurrentToMatch = '';
		//end
		//START francesca.ribezzi 10/07/19  adding performance attributes here:
		let lineItemAttrNameList = ['SimCard','PinPad','Soluzione Tecnica','Proprietà','URL','APP','Paymail'];
		let posSimCardList = ['Pos Wi-fi C-less','Pos Tradizionale Premium','Pos Portatile Smart','Pos Portatile Premium (3G)','Pos GPRS C-Less','POS ETHERNET','Pos Desktop Ethernet GPRS C-Less','Pos Cordless Premium (WIFI)','Pos Cordless C-Less'];
		var cartItemsSimCardList = [];
		var terminalIdGenerator = component.get("v.terminalIdGenerator");
		var terminalIdGeneratorVirtual = component.get("v.terminalIdGeneratorVirtual");
		var requiredMap = {};//map composed by attributeId and value
		//END francesca.ribezzi 10/07/19
		var isReplacement = component.get("v.isReplacement"); //francesca.ribezzi 25/09/19 - WN-488 adding isReplacement
		//getting cart lists for each sections (pos, acquiring, vas and acquiring):
		for(var i = 0; i< cart.length; i++){
			if(cart[i] != null){
				//START francesca.ribezzi 10/07/19 - setting readonly to listOfAttributes:
				var recordTypeName = cart[i].fields.RecordTypeName.toLowerCase();
				var codiceSfdcVas = cart[i].fields.OBCodiceSfd;
				var isOneClick = (codiceSfdcVas ==  oneClick);
				var isRecurring = (codiceSfdcVas ==  recurring);
				var isMoto = (recordTypeName == terminaliRecordTypeMoto);
				var isEcommerce = (recordTypeName == terminaliRecordTypeEcommerce);
				var isTerminali = (recordTypeName == terminaliRecordType);
				//START Simone Misani WN-218
				var setReadonly = (terminalIdGenerator != 'Banca' && isTerminali);
				setReadonly = setReadonly || (terminalIdGeneratorVirtual != 'Banca'&&(isMoto || isEcommerce ||isOneClick|| isRecurring));
				//END Simone Misani WN-218
				for(var j = 0;j <cart[i].listOfAttributes.length; j++){
					var att = cart[i].listOfAttributes[j];
					//setting every attribute to readonly except for those contained in lineItemAttrNameList: //francesca.ribezzi 24/09/19 - R1F3-103 - check if it is not a termId attribute:
					if(setReadonly && !lineItemAttrNameList.includes(att.fields.name) && cart[i].listOfAttributes[j].fields.name != 'Terminal Id'){
						att.fields.readonly = true;
					}//francesca.ribezzi 24/09/19 - R1F3-103 - term id readonly if term generator is not Banca : 
					if((terminalIdGenerator != 'Banca' || isReplacement) && cart[i].listOfAttributes[j].fields.name == 'Terminal Id'){   //francesca.ribezzi 25/09/19 - WN-488 adding isReplacement
						att.fields.readonly = true;
					}
				}
				//END francesca.ribezzi 10/07/19 
				//08/07/19 francesca.ribezzi -  Andrea Saracini code moved here from onUpdateContext
				//START [08-05-2019 No Card Present Server2Server] Andrea Saracini
				var codes2s = cart[i].fields.OBCodiceSfd;
				if('SERVER2SERVER' == codes2s){
					server2server.push(cart[i]);
					component.set("v.isServer2Server", true);		
				}
				//STOP [08-05-2019 No Card Present Server2Server] Andrea Saracini

				//if(coreOutput.listOfBundles[j].bundleElements[x].fields.name =="Gestione Terminali" ){
				//_utils.debug(cart[i].fields.RecordTypeName.toLowerCase()+ " == "+terminali.toLowerCase());
				var recordTypeToMatch = cart[i].fields.RecordTypeName.toLowerCase();
				if(recordTypeToMatch == bundleRecordType){  //09/10/19 francesca.ribezzi WN-551 - setting offer attribute
					component.set("v.offer", cart[i]);
					component.set("v.showConventionCode", true);
				}
				if(recordTypeToMatch == terminaliRecordType || recordTypeToMatch == terminaliRecordTypeGateway  || recordTypeToMatch == terminaliRecordTypeEcommerce || recordTypeToMatch == terminaliRecordTypeMoto)
				{
					if(cart[i].listOfAttributes.length != 0)
					{
						for(var k = 0; k < cart[i].listOfAttributes.length; k++)
						{
							requiredMap[cart[i].listOfAttributes[k].fields.name] = cart[i].listOfAttributes[k].fields.required;
							if(cart[i].listOfAttributes[k].fields.name == 'Terminal Id'){
								terminalIdItems[cart[i].fields.id] = cart[i]; //francesca.ribezzi 30/09/19 - changing list to map id orderItem
								//davide.franzini - F2WAVE2-178 - 26/08/2019 - START
								if(cart[i].fields.status == 'Active' && component.get("v.isMaintenance")){
									cart[i].listOfAttributes[k].fields.readonly = true;   
								}
								//davide.franzini - F2WAVE2-178 - 26/08/2019 - START
							}
							//START francesca.ribezzi 01/08/19 setting blank value as default - WN-211
							if(cart[i].listOfAttributes[k].fields.name == 'Paymail'){
								var obj = {};
								var fields = {};
								fields.value = '';
								fields.selected= 'Y';
								obj.fields = fields;
								cart[i].listOfAttributes[k].listOfDomains.unshift(obj);
								console.log('paymail with default value: ', cart[i].listOfAttributes[k]);
							}
							//END francesca.ribezzi 01/08/19
						}
						pos.push(cart[i]);	
					}
					//08/07/19 francesca.ribezzi -  antonio.vatrano code moved here from onUpdateContextOutput
					//Start antonio.vatrano 30/05/2019 RI-88
					if(cart[i].fields.action == 'Add'){
						posAdd.push(cart[i]);
					}
					//End antonio.vatrano 30/05/2019 RI-88
				}
				//else if(coreOutput.listOfBundles[j].bundleElements[x].fields.name =="Gestione Pagobancomat" ){
				//08/07/19 francesca.ribezzi -  Andrea Saracini racSIA if condition moved here from onUpdateContext
				else if(recordTypeToMatch == pagobancomatRecordType  && ob_racSIACurrentToMatch != ob_racSiaNexiToMatch ){
					if(cart[i].listOfAttributes.length != 0)
					{
						bancomat.push(cart[i]);
					}
				}
				//else if(coreOutput.listOfBundles[j].bundleElements[x].fields.name =="Selezione Acquiring" ){
				else if(recordTypeToMatch == acquiringRecordType ){
					if(cart[i].listOfAttributes.length != 0)
					{
						acquiring.push(cart[i]);
					}
				}
				//else if(coreOutput.listOfBundles[j].bundleElements[x].fields.name =="Selezione VAS" ){
				else if(isOneClick || isRecurring ){
					if(cart[i].listOfAttributes.length != 0)
					{
						for(var k = 0; k < cart[i].listOfAttributes.length; k++)
						{
							if(cart[i].listOfAttributes[k].fields.name == 'Terminal Id'){
								cart[i].hasTerminalId = true;
								terminalIdItems[cart[i].fields.id] = cart[i]; //francesca.ribezzi 30/09/19 - changing list to map id orderItem
							}
						}
						vas.push(cart[i]);
					}
				}						
			}			
	    }//END filling lists
	    //francesca.ribezzi 30/09/19 - setting terminalIdItems
		component.set("v.terminaIdItemsMap", terminalIdItems);  
	    var posChildItems;
	    //check attributes in pos
	    for(var i = 0; i < pos.length; i++){
	    	posChildItems = [];
        	for(var j= 0; j < pos[i].childItems.length; j++){ //antonio.vatrano perf-18 05/12/19 - adding remove filter 
        		if(pos[i].childItems[j].fields.action != 'Remove' && (pos[i].childItems[j].fields.visible == "true" || pos[i].childItems[j].fields.visible == true) && (pos[i].childItems[j].fields.RecordTypeName == 'Acquiring' || pos[i].childItems[j].fields.RecordTypeName == 'Vas')){
        			posChildItems.push(pos[i].childItems[j]);
        		}
    	}	
    		pos[i].childItems = posChildItems;
	    }

		//08/07/19 francesca.ribezzi -  Daniele Gandini code moved here from onUpdateContext
		// Daniele Gandini <daniele.gandini@accenture.com> - 22/05/2019 - TerminalsReplacement - START
		if(component.get("v.isReplacement")){
		/*	for(var i=0;i<pos.length;i++){
				if(pos[i].fields.action == 'None'){
					pos.splice(i, 1);
				}
			}*/
		//START francesca.ribezzi 15/07/19 - changing splice loop:
			for(var i = pos.length-1; i--;){
				if(pos[i].fields.action == 'None'){ 
					pos.splice(i, 1);
				}
			}
		//END francesca.ribezzi 15/07/19 
		}
		// Daniele Gandini <daniele.gandini@accenture.com> - 22/05/2019 - TerminalsReplacement - END
		component.set("v.posList", pos);
		//08/07/19 francesca.ribezzi - antonio.vatrano code moved here from onUpdateContext
		component.set("v.posListAdd", posAdd);	//antonio.vatrano 30/05/2019 RI-88
		//davide.franzini - WN-28 - 19/08/2019 - START
        this.cloneSiaCode(component,event);
		//davide.franzini - WN-28 - 19/08/2019 - END
        component.set("v.vasList", vas);
        component.set("v.acquiringList", acquiring);
		component.set("v.bancomatList", bancomat);
		component.set("v.server2serverList", server2server);//[09-05-2019 No Card Present Server2Server] Andrea Saracini
		//START francesca.ribezzi 26/07/19 showing  racSIA component:
		var modelACQ = component.get("v.objectDataMap.bankProfile.OB_Business_Model_Acquiring__c");
		var gt = component.get("v.objectDataMap.Configuration.OB_GT__c"); // antonio.vatrano 26/09/2019 wn-502
		var racSIA = component.get("v.objectDataMap.bankProfile.OB_Applicant_RAC_Code_SIA__c");
		var typology = component.get("v.objectDataMap.pv.OB_Typology__c");
		var isReplacement = component.get("v.isReplacement");
		var isPosAdd = !$A.util.isEmpty(posAdd) ? true : false; //francesca.ribezzi F2WAVE2-191 - checking if there is at least one pos in add
		var showManageRacSia = (isPosAdd && modelACQ == 'Bancario' && gt== 'Nexi' && racSIA != 'Nexi'  && !isReplacement); // Simone Misani WN-609

		console.log('showManageRacSia: ' + showManageRacSia);
		component.set("v.showManageRacSia",showManageRacSia);

		var isFlow = component.get("v.isFlow"); 
		var isMaintenance = component.get("v.isMaintenance"); 
		var isEcommerce = component.get("v.objectDataMap.isEcommerce");
		var showConventionCode = (isFlow && !isMaintenance && isEcommerce);
		console.log('showConventionCode: ' + showConventionCode);
		component.set("v.showConventionCode",showConventionCode);


		//END francesca.ribezzi 26/07/19
		component.set("v.Spinner",false);
	},
	
    enrichOrder: function(component, event) {
    
    	
	   
    	var ordId = component.get("v.orderId");
										
    	//_utils.debug("__into enrichOrder with order id: "+ordId);
    	var isMaintenance = component.get("v.isMaintenance");
    	
    	var action = component.get("c.enrichOrderWrapper");
	        action.setParams({ 
	        	idOrder: ordId
	        });
	        action.setCallback(this, function(response) {
	            var state = response.getState();
	            if (state === "SUCCESS") {        
										  
	                //_utils.debug("response: ", response.getReturnValue());
	                var res = response.getReturnValue();	                
	                
	                if(res){
						//16/07/19 francesca.ribezzi not updating terminal ids anymore but call directly showBit2flowNext - performance.
	                	this.showBit2flowNext(component, event); 	
				    	
			    	}
			    	else{
	  
			    		//error message
			    		//toast message error TODO
									
			    		component.set("v.Spinner",false);	
			    	}
				}
	            else if (state === "INCOMPLETE") {
	            	component.set("v.Spinner",false);
	            }
	            else if (state === "ERROR") {
	                    var errors = response.getError();
	                    if (errors) {
	                        if (errors[0] && errors[0].message) {
	                            //_utils.debug("Error message: " + 
	                                        //errors[0].message);
	                        }
	                    } else {
	                        //_utils.debug("Unknown error");
	                    }
	                    component.set("v.Spinner",false);
	            }
	        });
	        $A.enqueueAction(action);

    },
    showBit2flowNext: function(component, event) {
		var objectDataMap = component.get("v.objectDataMap");
		//START francesca.ribezzi 24/07/19 fixing redirect functions logic
		var isMaintenance = component.get("v.isMaintenance");
		var isReplacement = component.get("v.isReplacement");
		// Daniele Gandini <daniele.gandini@accenture.com> - 17/05/2019 - TerminalsReplacement - START
		if(isReplacement){
			objectDataMap.unbind.goToNextStepSocieta  = 'goToSocieta';
		}else if(!isMaintenance && !isReplacement){
			objectDataMap.unbind.goToNextStepSocieta  = 'true';
		}else if(isMaintenance  && !isReplacement){
        //START francesca.ribezzi 12/07/19  - Maintenance COnsistenza - check if there are any changes.
            this.checkChangedCartItems(component, event);
        //END francesca.ribezzi 12/07/19 
		}
		//END francesca.ribezzi 24/07/19
		// Daniele Gandini <daniele.gandini@accenture.com> - 17/05/2019 - TerminalsReplacement - END
        component.set("v.objectDataMap", objectDataMap); 
        component.set("v.Spinner",false); 

    },
    checkChangedCartItems: function(component, event) {
			//START francesca.ribezzi 21/03/19 checking if there's any changes on cartItems:
			var objectDataMap = component.get("v.objectDataMap");
            var cart = [];
            var parentAndChilItems = [];
            cart = cart.concat(component.get("v.posList"));
            cart = cart.concat(component.get("v.vasList"));
            cart = cart.concat(component.get("v.acquiringList"));
			cart = cart.concat(component.get("v.bancomatList"));
			cart = cart.concat(component.get("v.server2serverList")); // antonio.vatrano wn-320 03/09/2019
			var orderItems = [];
			for(var i = 0; i<cart.length; i++){
				//START francesca.ribezzi 25/07/19 - going to società step if there is a pos in add
				if(cart[i].fields.action == 'Add'){
					orderItems.push(cart[i]);
					break;
				}
				for(var j = 0; j<cart[i].childItems.length; j++){
					//24/07/19 francesca.ribezzi changing action into NE__Action__c -> no engine - custom update:
					var actionAdd = (cart[i].childItems[j].fields.action == 'Add');
					var actionChange = (cart[i].childItems[j].fields.action == 'Change');
					// antonio.vatrano wn 428 18/09/2019 add condition in if for CHANGE
					if(cart[i].childItems[j].fields.NE__Action__c == 'Add' || ((cart[i].childItems[j].fields.NE__Action__c == 'Change' || actionChange) && cart[i].childItems[j].fields.OB_enablement__c == 'Y') || actionAdd ){	
						orderItems.push(cart[i].childItems[j]);
						break;
					}
				}
				  //END francesca.ribezzi 25/07/19
			}
			//if theres a change, going to step società
			if(orderItems.length > 0){
				console.log('OBJ_NEXT: ' +	JSON.stringify(component.get('v.objectDataMap.unbind')));
				objectDataMap.unbind.goToNextStepSocieta='goToSocieta';
			}else{
			//if there are no changes, going to carica documenti step
				objectDataMap.unbind.goToFinalStep='true';
			}
			//francesca.ribezzi 24/07/19 setting objDatamap:
			component.set("v.objectDataMap", objectDataMap); 
			//END francesca.ribezzi	
    },
    checkRequiredInputs: function(component){
		var isOk;
		var requiredIsOk = true;
		//var cart = component.get("v.cartList");
		//START francesca.ribezzi 11/07/19 cartList is null [no engine]- using these lists instead:
		var	posList	= component.get("v.posList");		
		var	vasList= component.get("v.vasList");
		var	acquiringList= component.get("v.acquiringList");
		var	bancomatList= component.get("v.bancomatList");
		var server2serverList = component.get("v.server2serverList");
		var cart = []; 
		var parentAndChilItems = [];
		//davide.franzini - WN-339 - 04/09/2019 - START
		var attrValorized = false;
		var isEcommerceItem = false;
		//davide.franzini - WN-339 - 04/09/2019 - END
		cart = cart.concat(posList);
		cart = cart.concat(vasList);
		cart = cart.concat(acquiringList);
		cart = cart.concat(bancomatList);
		cart = cart.concat(server2serverList);
		console.log("cart test: ", cart);
		//END francesca.ribezzi 11/07/19
		if(!$A.util.isEmpty(cart)){			
			//davide.franzini - WN-339 - 04/09/2019 - START
			for(var i = 0;i< cart.length; i++){
				var cartItem = cart[i];
				for(var k = 0; k < cartItem.listOfAttributes.length; k++){
					var attr = cartItem.listOfAttributes[k];
					var eCommAttr = ((attr.fields.name=='URL' || attr.fields.name=='APP' || attr.fields.name=='Paymail' ) && attr.fields.familyname=='Attributi Tecnici');
					var isRequired = (attr.fields.required == 'Yes' || attr.fields.required == 'true');
					var isEmptyValue = ($A.util.isEmpty(attr.fields.value));
					var isHidden = (attr.fields.hidden == "true" || attr.fields.hidden);
					if(eCommAttr){
						isEcommerceItem = true;
						if((!isHidden || isHidden == "false") && !isEmptyValue){
							attrValorized = true;
						}
					}
				}
			}
			//davide.franzini - WN-339 - 04/09/2019 - END
			for(var i = 0;i< cart.length; i++){
				//davide.franzini - WN-339 - 04/09/2019 - START
				var cartItem = cart[i];						 
				for(var k = 0; k < cartItem.listOfAttributes.length; k++){
					var attr = cartItem.listOfAttributes[k];
					//davide.franzini - WN-339 - 04/09/2019 - END
					//START francesca.ribezzi 11/07/19
					var isRequired = (attr.fields.required == 'Yes' || attr.fields.required == 'true');
					var isEmptyValue = ($A.util.isEmpty(attr.fields.value));
					var isHidden = (attr.fields.hidden == "true" || attr.fields.hidden);
					//END francesca.ribezzi 11/07/19
					//davide.franzini - WN-339 - 04/09/2019 - added condition for eCommerce
					if((isRequired && isEmptyValue && (!isHidden || isHidden == "false") && !isEcommerceItem) || (isEcommerceItem && !attrValorized)){
						requiredIsOk = false;
						break;
					}
				}		
			var errors = document.getElementsByClassName('borderError');
			//_utils.debug("borderErrors? "+ errors.length);
			if(errors.length > 0){
				isOk = false;
			}else{
				isOk = true;
			}
			return (isOk && requiredIsOk);
			}
		}
		// Daniele Gandini <daniele.gandini@accenture.com> - 17/05/2019 - TerminalsReplacement - START
		var dateError = component.get("v.dateError");
		if(dateError){
			var message = $A.get("$Label.c.OB_Request_Date_Error");
			//davide.franzini - WN-241 - 02/08/2019 - START
			var type = 'error';
			this.showErrorToast(component,event,message);
			//davide.franzini - WN-241 - 02/08/2019 - END
			isOk = false;
		}else{
			isOk = true;
		}

		return (isOk && requiredIsOk); //NEXI-255 Kinga Fornal <kinga.fornal@accenture.com> 17/06/2019

		// Daniele Gandini <daniele.gandini@accenture.com> - 17/05/2019 - TerminalsReplacement - END
	},
    redirectMaintenance: function(component,event){
	
		//_utils.debug("enrich Order Complete");
		component.set("v.Spinner",false);
		
    },
    	/*  OB OPERATIONAL DATA   */
	getReportType : function (component , helper , event )
	{
		//25-09-2018-Salvatore P.- Get picklist values for Report Type field
													   
		var actionGetReportTypeValues = component.get("c.getReportTypeValues");
		var objectDataMap = component.get("v.objectDataMap");
		actionGetReportTypeValues.setCallback(this, function(response)
		{
			 var state = response.getState();
			 if (state === "SUCCESS") 
			 {
										   
				 var  tempMap =[];
				 var  responseMap= response.getReturnValue();
				 for(var key in responseMap)
				 {
					tempMap.push({value:responseMap[key], key:key});
				 }
				 component.set( "v.reportTypeList",  tempMap);
											
				 //_utils.debug("Value of picklist report type: "+tempMap);
			 } 
			 else if (state === "INCOMPLETE") 
			 {
				 // do something
			 }
			 else if (state === "ERROR") 
			 {
				var errors = response.getError();
				if (errors) 
				{
					if (errors[0] && errors[0].message) 
					{
						//_utils.debug("Error message: " + errors[0].message);
					}
				}
				else 
				{
					//_utils.debug("Unknown error");
				}
			 }
		 });
		$A.enqueueAction(actionGetReportTypeValues); 
	},
	/* START 	micol.ferrari 01/10/2018 - CREATION OF BILLING PROFILES */
	confirmCreationBillingProfilesHelper: function(component, event, chosenIban) 
	{
		//29/07/19 francesca.ribezzi adding spinner so that user cannot click on next twice
		component.set("v.Spinner", true);
		component.set("v.nextClicked", true); //used to check if the next btn has been clicked -> checks required inputs
		var isMaintenance 			= component.get("v.isMaintenance");
		var showIBANSection 		= component.get('v.showIBANSection');
		var objectDataMap 			= component.get("v.objectDataMap");
		//START francesca.ribezzi 22/07/19 deleting confirmOperationData button
		var isSingleIban = component.get("v.isSingleIban"); // 25/07/19 francesca.ribezzi added isSingleIban
		var isIbanValid = component.get("v.objectDataMap.isIbanValid"); 
		var isModificaOfferta = component.get("v.isModificaOfferta");
		var itemsInRemove = component.get("v.itemsInRemove");
		//francesca.ribezzi 20/03/19 commenting methodDone -it was used for the spinner
		// Daniele Gandini <daniele.gandini@accenture.com> - 21/05/2019 - TerminalsReplacement - START
		var isReplacement = component.get("v.isReplacement");
		// console.log("isReplacement in confirm operational data: " + isReplacement);
		if(!isReplacement){
		// Daniele Gandini <daniele.gandini@accenture.com> - 21/05/2019 - TerminalsReplacement - END
				try
				{
				//francesca.ribezzi 15/07/19 - performance adding isMaintenance -
				var merchantId 				= objectDataMap.merchant.Id;
				var actualBankId 			= objectDataMap.actualBank;
				var objBillingProfilePOS 	= JSON.stringify(objectDataMap.BillingProfilePOS);
				var objOrderHeader 			= JSON.stringify(objectDataMap.OrderHeader);

				//	CLONE OF BILLINGPROFILEPOS TO BILLINGPROFILEACQUIRING		
				var countrycode 		= objectDataMap.BillingProfilePOS.OB_CountryCode__c;
				var eurocontrolcode 	= objectDataMap.BillingProfilePOS.OB_EuroControlCode__c;
				var cin 				= objectDataMap.BillingProfilePOS.OB_CINCode__c;
				var abi 				= objectDataMap.BillingProfilePOS.OB_ABICode__c;
				var cab					= objectDataMap.BillingProfilePOS.OB_CABCode__c;
				var bankaccountnumber 	= objectDataMap.BillingProfilePOS.OB_Bank_Account_Number__c;
				var headerinternational = objectDataMap.BillingProfilePOS.OB_HeaderInternational__c;
				//console.log('INTERMEDIATE');
				objectDataMap.BillingProfileAcquiring.OB_CountryCode__c 			= countrycode;
				objectDataMap.BillingProfileAcquiring.OB_EuroControlCode__c 		= eurocontrolcode;
				objectDataMap.BillingProfileAcquiring.OB_CINCode__c 				= cin;
				objectDataMap.BillingProfileAcquiring.OB_ABICode__c 				= abi;
				objectDataMap.BillingProfileAcquiring.OB_CABCode__c 				= cab;
				objectDataMap.BillingProfileAcquiring.OB_Bank_Account_Number__c 	= bankaccountnumber;
				objectDataMap.BillingProfileAcquiring.OB_HeaderInternational__c 	= headerinternational;

				component.set("v.objectDataMap",objectDataMap);							
				
				//console.log('BEFORE CALLBACK');
				//console.log('SHOW_IBAN_IN_CONFIRM: ' +showIBANSection );
				//	START 	micol.ferrari 30/01/2019
				if (showIBANSection==true || !isMaintenance){
					//	INSERT OF TWO BILLING PROFILES
					//19/92/19 francesca.ribezzi moving call server side to handleAfterCheckout
					var createBillingProfiles = component.get("c.insertBillingProfilesUpdateOrderHeader");
					//console.log('PARAMS_CONFIRM: ' + merchantId + ' '+actualBankId);
					createBillingProfiles.setParams({
														"objectDataString": JSON.stringify(objectDataMap),
														"merchantId": merchantId,
														"actualBankId": actualBankId,
														"isCheckout": false
													});
					createBillingProfiles.setCallback(this,function(response) 
					{
						var state = response.getState();
						//console.log('STATE_CONFIRM_IS: ' + state);			 
						if (state === "SUCCESS") 
						{	
							//console.log('INTO_SUCCESS_CONFIRM');	
							var responseData		= {};
							responseData 			= response.getReturnValue();
							
							console.log('@@@@ ResponseData: ', JSON.stringify(responseData));
							//console.log("responseData.unbind.OB_Year_constitution_company__c"+JSON.stringify(responseData.unbind.yearOfConstitutionCompany));
							// Simone  Misani START 25/06/2019  change the conditions on if 
						/*	if( responseData.unbind.yearOfConstitutionCompany == undefined || responseData.unbind.yearOfConstitutionCompany== null || responseData.unbind.yearOfConstitutionCompany =='' ) {
								console.log('in the if');
								responseData.unbind.yearOfConstitutionCompany= "";
								responseData.merchant.OB_Year_constitution_company__c = "";
								// component.set('v.objectDataMap.unbind.yearOfConstitutionCompany' ,'test');
							}
							// Simone Misani END 25/06/2019 change the conditions on if 
							console.log('@@@@ ResponseData: ', JSON.stringify(responseData));*/
							component.set("v.objectDataMap",responseData);
							var objectDataMapAfter	= component.get("v.objectDataMap");				
							//	CHECK MANDATORY FIELDS KO
							if (objectDataMapAfter.setRedBorderoperationalData==true)
							{
								console.log('## setRedBorderoperationalData is true!');
								objectDataMapAfter.BillingProfileAcquiring.OB_CountryCode__c 			= "";
								objectDataMapAfter.BillingProfileAcquiring.OB_EuroControlCode__c 		= "";
								objectDataMapAfter.BillingProfileAcquiring.OB_CINCode__c 				= "";
								objectDataMapAfter.BillingProfileAcquiring.OB_ABICode__c 				= "";
								objectDataMapAfter.BillingProfileAcquiring.OB_CABCode__c 				= "";
								objectDataMapAfter.BillingProfileAcquiring.OB_Bank_Account_Number__c 	= "";
								objectDataMapAfter.BillingProfileAcquiring.OB_HeaderInternational__c 	= "";
								component.set("v.objectDataMap",objectDataMapAfter);
								this.setRedBorderHelper(component,event); 
								//29/07/19 francesca.ribezzi removing spinner if there are errors:
								component.set("v.Spinner", false);			
							}
							else
							{
								//25/07/19 francesca.ribezzi setting disable iban
								component.set("v.ibanDisabled", true);
								component.set("v.objectDataMap",objectDataMapAfter);	
								//19/02/19 francesca.ribezzi setting confirmOperationalData to true here
								objectDataMapAfter.confirmOperationalData = true;
								component.set("v.objectDataMap",objectDataMapAfter);
								//26/07/19 francesca.ribezzi calling checkout function here:
								this.checkout(component, event);
								//---------------------------------------------------------

								//			SHOW CATALOG

								//---------------------------------------------------------
							}
							// G.S. 14/02/2019
						//	component.set("v.Spinner", false);					
						}
						else if (state === "INCOMPLETE") 
						{
							//	INCOMPLETE
						}
						else if (state === "ERROR") 
						{
							//	ERROR TBD
						}
					});
					$A.enqueueAction(createBillingProfiles); 
				}
				else
				{	
					console.log('INTO_ELSE_CONFIRM');
					//francesca.ribezzi 07/10/19 - WN_566 - calling updateConfiguration to update configuration:
					if(isModificaOfferta && itemsInRemove){
						this.updateConfiguration(component,event, JSON.stringify(objectDataMap.Configuration));
					}else{
						//26/07/19 francesca.ribezzi calling checkout function here;
						this.checkout(component, event);
					}
		
				}
				//	END 	micol.ferrari 30/01/2019
			}catch(err){
				console.log('ERROR_MESSAGE_CONFIRM_DATA: ' + err.message);
			}
		}
		//START francesca.ribezzi 29/07/19 going directly to checkout function if it's replacement process:
		else if(isReplacement){ 
			this.checkout(component, event);
		}
		//END francesca.ribezzi 29/07/19
	},
    insertBillingProfilesUpdate: function(component,event){
		_utils.debug('into insertBillingProfilesUpdate');
		var objectDataMap = component.get("v.objectDataMap");
		var merchantId = 	objectDataMap.merchant.Id;
		var actualBankId =  objectDataMap.actualBank;
		var createBillingProfiles = component.get("c.insertBillingProfilesUpdateOrderHeader");
		//console.log('PARAMS_CONFIRM: ' + merchantId + ' '+actualBankId);
		createBillingProfiles.setParams({
											"objectDataString": JSON.stringify(objectDataMap),
											"merchantId": merchantId,
											"actualBankId": actualBankId, 
											"isCheckout": true
										});
		createBillingProfiles.setCallback(this,function(response) 
		{
			var state = response.getState();
			//console.log('STATE_CONFIRM_IS: ' + state);			 
			if (state === "SUCCESS") 
			{	
				//console.log('INTO_SUCCESS_CONFIRM');
				var responseData		= {};
				responseData 			= response.getReturnValue();
				component.set("v.objectDataMap",responseData);
								 
				var objectDataMapAfter	= component.get("v.objectDataMap");			
				this.enrichOrder(component,event);	
				// G.S. 14/02/2019
				component.set("v.Spinner", false);	
				
			}
			else if (state === "INCOMPLETE") 
			{
				//	INCOMPLETE
			}
			else if (state === "ERROR") 
			{
				//	ERROR TBD
			}
		});
		$A.enqueueAction(createBillingProfiles); 
    },
    //D.F. _ 26-03-2019 ManageRacSia v4 _ START
	checkTerminalsIBAN: function(component, event){
		var objectDataString = component.get("v.objectDataMap");	
		var act = component.get("c.checkActiveTerminalsIBAN");
		act.setParams({ 
			objectDataString: JSON.stringify(objectDataString),
		});
		act.setCallback(this, function(response){
			var state = response.getState();
			console.log("state: "+state);			 
			if (state === "SUCCESS"){
				var resp = response.getReturnValue();
				component.set("v.ibanList", resp);
				if(!$A.util.isEmpty(resp)){ //16/07/19 francesca.ribezzi changing condition in util.isEmpty 
					if(resp.length > 1){ //francesca.ribezzi if resp is > 1, it means that there are more than one iban
						console.log('### multiple iban, open Modal');
						var ibanList = [];
						for(var i=0; i<resp.length; i++){
							ibanList.push({
								"full" : resp[i],
								"countryCode" : resp[i].substring(0, 2),
								"euroControlCode" : resp[i].substring(2, 4),
								"cin" : resp[i].substring(4, 5),
								"abi" : resp[i].substring(5, 10),
								"cab" : resp[i].substring(10, 15),
								"bankAccountNumber" : resp[i].substring(15, 27)
							});
						}
						component.set("v.ibanList",ibanList);
						//START francesca.ribezzi 26/07/19 clearing iban if there is more than one iban
						component.set("v.objectDataMap.BillingProfilePOS.OB_CountryCode__c",'');
						component.set("v.objectDataMap.BillingProfilePOS.OB_EuroControlCode__c",'');
						component.set("v.objectDataMap.BillingProfilePOS.OB_CINCode__c",'');
						component.set("v.objectDataMap.BillingProfilePOS.OB_ABICode__c",'');
						component.set("v.objectDataMap.BillingProfilePOS.OB_CABCode__c",'');
						component.set("v.objectDataMap.BillingProfilePOS.OB_Bank_Account_Number__c",'');
						component.set("v.objectDataMap.BillingProfilePOS.OB_IBAN__c",'');
						//END francesca.ribezzi 26/07/19 

				        //25/07/19 francesca.ribezzi commenting setting ibanDisabled to true
						//component.set("v.ibanDisabled", true);
						component.set("v.showSearchIban",true);
						//START----> Simone Misani 25/06/2019 R1F2-181
						if(!$A.util.isEmpty(component.get("v.objectDataMap.BillingProfilePOS.OB_HeaderInternational__c"))){
							component.set("v.headerIntDisabled", true);
						}
						//END----> Simone Misani 25/06/2019 R1F2-181
						//25/07/19 francesca.ribezzi setting isSingleIban to false:
						component.set("v.isSingleIban",false);
					}else{
						console.log('### single Iban, autopopulate');
						component.set("v.showSearchIban",false);
						var countryCode = resp[0].substring(0, 2);
						var euroControlCode = resp[0].substring(2, 4);
						var cin = resp[0].substring(4, 5);
						var abi = resp[0].substring(5, 10);
						var cab = resp[0].substring(10, 15);
						var bankAccountNumber = resp[0].substring(15, 27);
						component.set("v.objectDataMap.BillingProfilePOS.OB_CountryCode__c",countryCode);
						component.set("v.objectDataMap.BillingProfilePOS.OB_EuroControlCode__c",euroControlCode);
						component.set("v.objectDataMap.BillingProfilePOS.OB_CINCode__c",cin);
						component.set("v.objectDataMap.BillingProfilePOS.OB_ABICode__c",abi);
						component.set("v.objectDataMap.BillingProfilePOS.OB_CABCode__c",cab);
						component.set("v.objectDataMap.BillingProfilePOS.OB_Bank_Account_Number__c",bankAccountNumber);
						component.set("v.objectDataMap.BillingProfilePOS.OB_IBAN__c",resp[0]);//davide.franzini - 19/04/2019 - RI-12_RI-18 - fullIban setted in obj datamap
						component.set("v.ibanDisabled", true);
						if(!$A.util.isEmpty(component.get("v.objectDataMap.BillingProfilePOS.OB_HeaderInternational__c"))){//davide.franzini 13/06/2019 - RI-104
							component.set("v.headerIntDisabled", true);//ANDREA SARACINI 23/05/2019 CR R1F2-181
						}
						component.set("v.showIbanSelModal", false);
						component.set("v.objectDataMap.isIbanValid",true);
					}
				}else{
					component.set("v.ibanDisabled", false);
					console.log('### No IBAN founded');
				}
                //22/07/19 francesca.ribezzi deleting confirmOperationData button	so calling this function here - performance
			//	this.confirmCreationBillingProfilesHelper(component,event);
			}
			else if (state === "ERROR") 
			{
				component.set("v.ibanDisabled", false);
				component.set("v.Spinner", false);
			}
			
		});
		$A.enqueueAction(act);
    },
    getSelectedOption: function(component, event){
		console.log("### selectedRecord value: " + event.target.value);
		var selectedIban = event.target.value;
		if(typeof selectedIban !== 'undefined' && selectedIban!= null && selectedIban!= ''){
			var countryCode = selectedIban.substring(0, 2);
			var euroControlCode = selectedIban.substring(2, 4);
			var cin = selectedIban.substring(4, 5);
			var abi = selectedIban.substring(5, 10);
			var cab = selectedIban.substring(10, 15);
			var bankAccountNumber = selectedIban.substring(15, 27);
			component.set("v.objectDataMap.BillingProfilePOS.OB_CountryCode__c",countryCode);
			component.set("v.objectDataMap.BillingProfilePOS.OB_EuroControlCode__c",euroControlCode);
			component.set("v.objectDataMap.BillingProfilePOS.OB_CINCode__c",cin);
			component.set("v.objectDataMap.BillingProfilePOS.OB_ABICode__c",abi);
			component.set("v.objectDataMap.BillingProfilePOS.OB_CABCode__c",cab);
			component.set("v.objectDataMap.BillingProfilePOS.OB_Bank_Account_Number__c",bankAccountNumber);
			component.set("v.objectDataMap.BillingProfilePOS.OB_IBAN__c",selectedIban);//davide.franzini - 19/04/2019 - RI-12_RI-18 - fullIban setted in obj datamap
			component.set("v.showIbanSelModal", false);
			component.set("v.objectDataMap.isIbanValid",true);
			//START  francesca.ribezzi 25/07/19 calling dati operativi:
			component.set("v.ibanDisabled", true);	// disable iban
			var chosenIban = true;
		//	this.confirmCreationBillingProfilesHelper(component,event, chosenIban);
			//END francesca.ribezzi 25/07/19
		}else{
			console.log("### no Iban Selected or Undefined");
			component.set("v.showIbanSelModal", false);
			component.set("v.Spinner", false);
		}
	},
    //D.F. _ END
    //start------simone misani R1F2-115 15/05/2019 function for current user
		currentUse : function(component, event, helper){
	  
														
															

			var act = component.get("c.getUserInformation");
													
	
			
			act.setCallback(this, function(response){
				var state = response.getState();
				console.log("state: "+state);			 
				if (state === "SUCCESS"){
					var resp = response.getReturnValue();
					console.log('response currentUse: '+JSON.stringify(resp));
					console.log('response currentUse: '+JSON.stringify(resp.isOperation));
					component.set('v.isOp',resp.isOperation);
	
	
				}
			
			});
			$A.enqueueAction(act);
		},
		
	//end------simone misani R1F2-115 15/05/2019 function for current user
		// Daniele Gandini <daniele.gandini@accenture.com> - 19/06/2019 - method for understanding if in remove POS case - START
		removeCase_Helper : function(component, event, helper){
			var itemsInRemove = component.get("v.objectDataMap.itemsInRemove");
			if(itemsInRemove != undefined && itemsInRemove != '' && itemsInRemove != null){
				component.set("v.itemsInRemove", true);
			}
		},
		// Daniele Gandini <daniele.gandini@accenture.com> - 19/06/2019 - method for understanding if in remove POS case - END
		// Daniele Gandini <daniele.gandini@accenture.com> - 19/06/2019 - method for understanding if in modify offer stream - START
		offerModify_Helper  : function(component, event, helper){
			var dataMap = component.get("v.objectDataMap");
			if(dataMap.OrderHeader.OB_Main_Process__c == 'Maintenance' && dataMap.OrderHeader.OB_Sub_Process__c == 'variazione operativa'){
				component.set("v.isModificaOfferta", true);
			}
		},
		// Daniele Gandini <daniele.gandini@accenture.com> - 19/06/2019 - method for understanding if in modify offer stream - END
	
		// ID 155, Doris Dongmo <doris.tatiana.dongmo@accenture.com>, 30/04/2019 - END
	
		
	setRedBorderHelper: function(component, event) 
	{
		// 26-09-2018-Salvatore P.-Check mandatory fields on next button
		var mapFromNext 	= {};
		var objectDataMap 	= component.get("v.objectDataMap");
		//_utils.debug('setredbord'+objectDataMap.setRedBorderoperationalData);
		if(objectDataMap.setRedBorderoperationalData == true)
		{
			mapFromNext = component.get("v.objectDataMap.checkMapValuesoperationalData");
			console.log("mandatory field from map: " ,mapFromNext);
			
			//_utils.debug("INTO IF METHOD OF TRUE BOOLEAN");
			for (var keys in mapFromNext)
			{
	
				var errorId = 'errorId' +keys;
				console.log("key  = " + keys);
				
				var myDiv;
				
				if(keys != 'prelimVerifCode'){  // ID 155,  Doris Dongmo <doris.tatiana.dongmo@accenture.com>, 26/04/2109 - Adds if condition

				myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorId);//SET AN ID TO EVERY MESSAGE
				myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
				myDiv.setAttribute('class' , 'messageError'+keys);
				//SET THE MESSAGE
				var errorMessage = document.createTextNode(mapFromNext[keys]);
				myDiv.appendChild(errorMessage);
				console.log("ID SET : " + idSet + ", input: " + component.find(keys));
				console.log("ID SET : " + idSet + ", input: " , JSON.stringify(component.find(keys)));
				var idSet = component.find(keys).get("v.id");//document.getElementById(keys);
				var inputKey = component.find(keys);
				//CONTROL TO CATCH THE AURA ID IN LIGHTNING:SELECT 
				//THIS METHOD STARTS WHEN ON DISPLAY THERE ARE THE INPUTS TO EXAMINE
				if($A.util.isUndefinedOrNull(idSet) && !$A.util.isUndefinedOrNull(component.find(keys)))
				{
					//START francesca.ribezzi 30/08/19 - using standard lightning - api version updated
					idSet = component.find(keys);
					if($A.util.isUndefinedOrNull(idSet)){
					   idSet = document.getElementsByClassName(keys)[0];
					   if(idSet){
						$A.util.addClass(idSet, 'slds-has-error');
					  } 
				   }
				   	//END francesca.ribezzi 30/08/19
				}
				if(idSet!=null && idSet!= undefined)
				{ 
					if(!(document.getElementById(errorId)) && !(idSet.value))
					{
						//_utils.debug("METHOD TO SHOW ONLY A MESSAGE");
						//francesca.ribezzi 26/07/19 
						$A.util.addClass(inputKey, "slds-has-error");
						//idSet.after(myDiv);
						//idSet.className="slds-has-error";
					}
				}//END FOR
				} // ID 155,  Doris Dongmo <doris.tatiana.dongmo@accenture.com>, 26/04/2109 - close if condition

			}
			// ID 155, Doris Dongmo <doris.tatiana.dongmo@accenture.com>, 29/04/2109 - START
			var inputIdVar          = component.find('prelimVerifCode');
			var inputValue 	        = inputIdVar.get("v.value");

			//START gianluigi.virga 12/06/2019 - PRODOB-209 - If the field is disabled it isn't mandatory
			var inputDisabled 	    = inputIdVar.get("v.disabled");
			if(!inputValue && !inputDisabled)
			//END gianluigi.virga 12/06/2019 - PRODOB-209
			{					
				// BOOLEAN TO SHOW ERROR MESSAGE 
				component.set("v.isMandatoryField",true);
				//ADD CLASS
				$A.util.addClass(inputIdVar, 'slds-has-error');	
			}
			// ID 155,  Doris Dongmo <doris.tatiana.dongmo@accenture.com>, 29/04/2109 - END
			
			component.set("v.objectDataMap.setRedBorderoperationalData" , false);
			//_utils.debug("boolean value after: " + component.get("v.objectDataMap.setRedBorderoperationalData" ));
			//START francesca.ribezzi 30/07/19 - WN-211
			var errorMessage = $A.get("$Label.c.OB_ErrorBannerRequiredFields");
			this.showErrorToast(component, event, errorMessage);
			//END francesca.ribezzi 30/07/19 - WN-211
		}
	},
	/* END	 	micol.ferrari 01/10/2018 - CREATION OF BILLING PROFILES */

	greaterThan: function(x,y)
	{
		if (x.length > y.length)
		{
			y= this.padS(y,x.length);
		}
		if (x.length < y.length)
		{
			x= this.padS(x,y.length);
		}
		return (x > y);
	},

	padS: function(s,size){
			while (s.length < (size || 1)) {s = "0" + s;}
			return s;
	},

	lessThan: function(x,y){
		if (x.length>y.length)
		{
			y= this.padS(y,x.length);
		}
		if (x.length<y.length)
		{
			x= this.padS(x,y.length);
		}

		return (x < y);
	},

	equal: function(x,y)
	{
		
		return (!(this.greaterThan(x,y) || this.lessThan(x,y)));
	},

	longIntegerReminder: function(x,y)
	{
		var firstDigit;
		var lastDigit;

		if(this.lessThan(x,y)){
			return parseInt(x);
		}

		if(this.equal(x,y)) return 0;


		for(var i = 1;i <= x.length;i++)
		{	
			firstDigit = x.substring(0,i);
			lastDigit = x.substring(i,x.length);
			//_utils.debug('i: ' + i);
			//_utils.debug('firstDigit: ' + firstDigit);
			//_utils.debug('y: ' + y);
			//_utils.debug('lastDigit: ' + lastDigit);
			
			if(this.greaterThan(firstDigit,y)|| this.equal(firstDigit,y)) {
				//_utils.debug('break');
				break;
			} 


		}		
		//_utils.debug('firstDigit: ' + firstDigit);
		//_utils.debug('lastDigit: ' + lastDigit);

		var reminder = parseInt(firstDigit) % parseInt(y);
		//_utils.debug("reminder: "+ reminder);


		
		var newNumb = reminder.toString() + lastDigit.toString();
		//_utils.debug('newNumb: ' + newNumb);

			//_utils.debug("Y: "+y);
		
		return parseInt(this.longIntegerReminder(newNumb.toString(),y));
	},

		validateIban : function(component,event, helper,inputId)
	{
// 04-10-2018-Salvatore P.-Validation of complete IBAN
		var errorId 				= 'errorId' + inputId;
		var errorCustomLabel 		= '';
		var myDiv;
		var arrayIban 				= [];
		var arrayConverted 			= [];
		var countryCodeValue 		= component.get("v.objectDataMap.BillingProfilePOS.OB_CountryCode__c");
		var euroControlCodeValue 	= component.get("v.objectDataMap.BillingProfilePOS.OB_EuroControlCode__c");
		var cinCodeValue 			= component.get("v.objectDataMap.BillingProfilePOS.OB_CINCode__c");
		var abiCodeValue 			= component.get("v.objectDataMap.BillingProfilePOS.OB_ABICode__c");
		var cabCodeValue 			= component.get("v.objectDataMap.BillingProfilePOS.OB_CABCode__c");
		var bankAccountNumberValue 	= component.get("v.objectDataMap.BillingProfilePOS.OB_Bank_Account_Number__c");
		var ibanComplete 			= countryCodeValue 	+ euroControlCodeValue 	+ cinCodeValue + abiCodeValue 			+ cabCodeValue 		+ bankAccountNumberValue;		
		var ibanToConverte 			= cinCodeValue		+ abiCodeValue			+ cabCodeValue + bankAccountNumberValue	+ countryCodeValue 	+ euroControlCodeValue;
		var ibanLength 				= ibanComplete.length;
		arrayIban.push(ibanToConverte);
		//_utils.debug("ibanToConverte: "+ ibanToConverte);
		//_utils.debug("Array of iban where do convertation: "+ arrayIban);
		var element;
		for (var i = 0; i < arrayIban.length; i++)
			{
				arrayIban[i] = arrayIban[i].replace(/A/g,"10");
				arrayIban[i] = arrayIban[i].replace(/B/g,"11");
				arrayIban[i] = arrayIban[i].replace(/C/g,"12");
				arrayIban[i] = arrayIban[i].replace(/D/g,"13");
				arrayIban[i] = arrayIban[i].replace(/E/g,"14");
				arrayIban[i] = arrayIban[i].replace(/F/g,"15");
				arrayIban[i] = arrayIban[i].replace(/G/g,"16");
				arrayIban[i] = arrayIban[i].replace(/H/g,"17");
				arrayIban[i] = arrayIban[i].replace(/I/g,"18");
				arrayIban[i] = arrayIban[i].replace(/J/g,"19");
				arrayIban[i] = arrayIban[i].replace(/K/g,"20");
				arrayIban[i] = arrayIban[i].replace(/L/g,"21");
				arrayIban[i] = arrayIban[i].replace(/M/g,"22");
				arrayIban[i] = arrayIban[i].replace(/N/g,"23");
				arrayIban[i] = arrayIban[i].replace(/O/g,"24");
				arrayIban[i] = arrayIban[i].replace(/P/g,"25");
				arrayIban[i] = arrayIban[i].replace(/Q/g,"26");
				arrayIban[i] = arrayIban[i].replace(/R/g,"27");
				arrayIban[i] = arrayIban[i].replace(/S/g,"28");
				arrayIban[i] = arrayIban[i].replace(/T/g,"29");
				arrayIban[i] = arrayIban[i].replace(/U/g,"30");
				arrayIban[i] = arrayIban[i].replace(/V/g,"31");
				arrayIban[i] = arrayIban[i].replace(/W/g,"32");
				arrayIban[i] = arrayIban[i].replace(/X/g,"33");
				arrayIban[i] = arrayIban[i].replace(/Y/g,"34");
				arrayIban[i] = arrayIban[i].replace(/Z/g,"35");

				arrayConverted.push(arrayIban[i]);
				//_utils.debug("arrayConverted: "+ arrayConverted);
			}
			var ibanToValidate='';
			for (var i = 0; i < arrayConverted.length; i++)
			{
				ibanToValidate += arrayConverted[i];
			}
			
			var reminder 			= this.longIntegerReminder(ibanToValidate,'97');
			//START francesca.ribezzi 16/07/19 changing getElementById to component.find cause of API version
			var errorInvalidIban 	= component.find("errorIbanNotValid");
			var ibanError 			= component.find("iban");
			var eccError 			= component.find("euroControlCode");
			var cinError 			= component.find("cin");
			var abiError 			= component.find("abi");
			var cabError 			= component.find("cab");
			var banError 			= component.find("bankAccountNumber");
			//END francesca.ribezzi 16/07/19 
			if(reminder == "1")
			{
				//START francesca.ribezzi 16/07/19 changing remove/add class cause of API version
				//remove eventual errors
				$A.util.addClass(errorInvalidIban, "slds-has-error");
				$A.util.removeClass(eccError, "slds-has-error");
				$A.util.removeClass(cinError, "slds-has-error");
				$A.util.removeClass(abiError, "slds-has-error");
				$A.util.removeClass(cabError, "slds-has-error");
				$A.util.removeClass(banError, "slds-has-error");
				$A.util.removeClass(ibanError,"iban-has-error");
				//START francesca.ribezzi 28/08/19 -R1F3-7 removing error message if any	
				eccError.setCustomValidity("");
				cinError.setCustomValidity("");
				abiError.setCustomValidity("");
				cabError.setCustomValidity("");
				banError.setCustomValidity("");
				//END francesca.ribezzi 28/08/19

				//END francesca.ribezzi 16/07/19 
				component.set("v.objectDataMap.isIbanValid",true);
				//START francesca.ribezzi 25/07/19
				var oldIban = component.get("v.objectDataMap.BillingProfilePOS.OB_IBAN__c");
				var isSingleIban = component.get("v.isSingleIban");
				var chosenIban = false;
				if(oldIban != ibanComplete && !isSingleIban){
					chosenIban = true;
				}
				//END francesca.ribezzi 25/07/19
				//START francesca.ribezzi 18/07/19 deleting confirmOperationData button
			//	helper.confirmCreationBillingProfilesHelper(component,event, chosenIban); //25/07/19 francesca.ribezzi adding chosenIban
			}
			else
			{
				//show error
				if(document.getElementById(errorId))
				{
					//_utils.debug("errorID . " + errorId);
					document.getElementById(errorId).remove();
				}
				$A.util.addClass(eccError, 'slds-has-error');
				$A.util.addClass(cinError, 'slds-has-error');
				var disabledAbi = component.get('v.disabledAbi');
				if(disabledAbi == false)
				{
					$A.util.addClass(abiError, 'slds-has-error');
				}
				$A.util.addClass(cabError, 'slds-has-error');
				$A.util.addClass(banError, 'slds-has-error');
				$A.util.addClass(ibanError, 'iban-has-error');
				//26/07/19 francesca.ribezzi changing errorInvalidIban add class - api version
				$A.util.addClass(errorInvalidIban, 'slds-show errorIbanInvalid');
			//	errorInvalidIban.setAttribute('class','slds-show errorIbanInvalid');
				
				component.set("v.objectDataMap.isIbanValid",false);
			} 
	

		component.set("v.objectDataMap.BillingProfilePOS.OB_IBAN__c", ibanComplete);

		//_utils.debug("IBAN IN OBJECT DATA MAP: ",component.get("v.objectDataMap.BillingProfilePOS.OB_IBAN__c"));
	},
    doInitMethodApex: function(component, event, helper) 
	{ 
		console.log("a1: " + performance.now());
		//START francesca.ribezzi 30/08/19- R1F3-17 - moving postPagatoPickList setting here
		var postPagatoPickList = [];
		postPagatoPickList.push( $A.get("$Label.c.OB_PostpaidSettlmentMethodNetValue"));
		postPagatoPickList.push( $A.get("$Label.c.OB_PostpaidSettlmentMethodGrossValue"));
		component.set('v.postPagatoPickList',postPagatoPickList);
		//END francesca.ribezzi 30/08/19- R1F3-17
		//28/02/19 francesca.ribezzi adding spinner
		component.set("v.Spinner", true);
		var objectDataMap 			= component.get("v.objectDataMap");
		component.set('v.objectDataMap.keyToUse' , {});
		var doInitMethod = component.get("c.doInitMethod");
		var keyToUseTmp;
		doInitMethod.setParams({	"objectDataString": JSON.stringify(objectDataMap)
										});
		doInitMethod.setCallback(this,function(response) 
		{
			var state = response.getState();
			//console.log('STATE_IS: ' + state);			 
			if (state === "SUCCESS") 
			{	
				// responseData		= {};
				var responseData 			= response.getReturnValue(); 
				keyToUseTmp = response.getReturnValue()['keyToUse'];
				component.set("v.objectDataMap",responseData);
				////console.log('SHOW IBAN IN HELPER: ' + component.get('v.showIBANSection'));
				//var showIBANSection =  component.get('v.showIBANSection');
				//15/07/19 francesca.ribezzi adding isMainteance condition - merge performance
				//START - elena.preteni R1F2 - 11, trigger change event to call doInitAfter
				if(keyToUseTmp &&  (component.get("v.isMaintenance") || (component.get("v.objectDataMap.isOperation") && component.get("v.objectDataMap.isSetup"))))
				//END - elena.preteni R1F2 - 11, trigger change event to call doInitAfter
				{
					//console.log('INTO SET INIT AFTER');
					component.set('v.callInit' , true);
				}else{
					//16/07/19  francesca.ribezzi adding else condition - performance merge
					component.set("v.loadComponent", true);
					//START 27/07/19 francesca.ribezzi adding code block from init - get iban values - CAB is EMPTY!!
				    if(component.get("v.isFlow") == true && !component.get("v.isMaintenance")){
						//25-09-2018-Salvatore P.-Set input values in object data map nodes
						var objectDataMap = component.get("v.objectDataMap");
						console.log("OBJECT DATA MAP IN OPERATIONAL DATA: " + JSON.stringify(objectDataMap));
						////_utils.debug('do init of Operational Data Controller');
						component.set("v.onfocusvar",false);
						// ****** Doris T. ** 08/10/2018 **** START **//
						var BillingProfileABI = component.get("v.objectDataMap.BillingProfilePOS.OB_ABICode__c");
						//	Daniele Gandini <daniele.gandini@accenture.com>	16/04/2019 - R1F2-15 - Start
						var bankABI           = component.get("v.objectDataMap.bank.OB_ABI__c"), //30/07/19 francesca.ribezzi using bank node instead of user's!
							CAB               = component.get("v.objectDataMap.user.OB_CAB__c");
						//	Daniele Gandini <daniele.gandini@accenture.com>	16/04/2019 - R1F2-15 - Stop
						 //GIOVANNI SPINELLI - 09/11/2018 *** COMPILE THE FIELD ABI E CAB *** START
						 if(objectDataMap.bankProfile.OB_AccountHolder__c=='true' || objectDataMap.bankProfile.OB_AccountHolder__c==true){ //davide.franzini - 04/07/2019 - WN-29
							if(CAB != undefined){ //29/07/19 francesca.ribezzi setting value if cab is not blank
								component.set("v.objectDataMap.BillingProfilePOS.OB_CABCode__c", CAB   );
							}
							component.set("v.disabledCab",true);
							if(bankABI != undefined){ //29/07/19 francesca.ribezzi setting value if abi is not blank
								component.set("v.objectDataMap.BillingProfilePOS.OB_ABICode__c", bankABI   );
							}
							component.set("v.disabledAbi",true);
						 }else{
							 component.set("v.objectDataMap.BillingProfilePOS.OB_CABCode__c", ''   );
							component.set("v.disabledCab",false);
							component.set("v.objectDataMap.BillingProfilePOS.OB_ABICode__c", ''   );
							component.set("v.disabledAbi",false);
						 }
						// ****** Doris T. ** 08/10/2018 **** END **//
						//	START 	micol.ferrari 12/10/2018 - SIT193
						component.set("v.objectDataMap.BillingProfilePOS.OB_HeaderInternational__c",objectDataMap.merchant.Name);
						//	END 	micol.ferrari 12/10/2018 - SIT193
						component.set("v.orderCreatedDate",component.get("v.objectDataMap.OrderHeader.OB_OrderDate__c"));
																		
					}
					//END 27/07/19 francesca.ribezzi
					//22/07/19 francesca.ribezzi deleting confirmOperationData button	so calling this function here - performance
				//	this.confirmCreationBillingProfilesHelper(component,event);
				}

				console.log('OBJDATAMAP_SET_INIT : ' + JSON.stringify(component.get('v.objectDataMap')));
				//05/03/19 francesca.ribezzi spinner commentato
				//component.set("v.Spinner", false);
			}
			else if (state === "INCOMPLETE") 
			{
				//	INCOMPLETE
				component.set("v.Spinner", false);
	
			}
			else if (state === "ERROR") 
			{
				component.set("v.Spinner", false);
				//	ERROR TBD

			}
		});
		$A.enqueueAction(doInitMethod);
		
		 
		
	},

    showErrorToast: function(component, event, errorMessage) {
      
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: '',
            message: errorMessage,
            //messageTemplateData: [name],
            duration: '5000',
            key: 'info_alt',
            type: 'error',
            mode: 'dismissible'
        });
        toastEvent.fire();
    },
	removeRedBorder: function (component, event , helper){
       
        //GET THE CURRENT ID FROM INPUT 
		var currentId = event.getSource().get("v.id"); //francesca.ribezzi 26/07/19 changing get id  cause of API version
		var currentInput = component.find(currentId); //francesca.ribezzi 26/07/19 getting input from aura:id
        //_utils.debug("current id is: " + currentId);
        $A.util.removeClass(currentInput, 'slds-has-error'); //francesca.ribezzi 26/07/19 currentInput
        //RECREATE THE SAME ID OF ERROR MESSAGE
        var errorId = 'errorId'+ currentId;
        if(document.getElementById(errorId)!=null){
            //_utils.debug("errorID . " + errorId);
            document.getElementById(errorId).remove();
		}
		//START francesca.ribezzi 18/07/19 deleting confirmOperationData button
	//	this.confirmCreationBillingProfilesHelper(component,event);
		
    },
    removeRedBorderDate: function(component, event, helper) {
        var elementDateClass = event.getSource().get("v.class");
		var idSet = document.getElementsByClassName(elementDateClass)[0];
		var errorId = 'errorId' +elementDateClass;
        //_utils.debug("key  = " + elementDateClass);
        
        var myDiv;
        
        myDiv = document.createElement('div');
        myDiv.setAttribute('id',errorId);//SET AN ID TO EVERY MESSAGE
        myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
        myDiv.setAttribute('class' , 'messageError'+elementDateClass);
        //SET THE MESSAGE
        
        if(idSet.value){
			if(!/^[0-9]{2}\/[0-9]{2}\/[0-9]{4}$/.test(idSet.value)){
				var errorMessage = document.createTextNode($A.get("$Label.c.OB_InvalidDateFormat"));
	            //_utils.debug('errorMessage:: ',errorMessage);
	            myDiv.appendChild(errorMessage);
	
				if(idSet!=null && idSet!= undefined)
				{ 
					//_utils.debug('errorId doc'+(document.getElementById(errorId)));
					if(!(document.getElementById(errorId)))
					{
						//_utils.debug("METHOD TO SHOW ONLY A MESSAGE");
						idSet.after(myDiv);
						idSet.style.border = "2px solid rgb(221, 219, 218)";
						idSet.style.borderColor = "rgb(194, 57, 52)";
					}
				}
				component.set("v.objectDataMap.errorDateMap."+elementDateClass, true);
		    } else{
		    	
		        idSet.style.border = "";
				idSet.style.borderColor = "";
		        //RECREATE THE SAME ID OF ERROR MESSAGE
		        var errorId = 'errorId'+ elementDateClass;
		        if(document.getElementById(errorId)!=null){
		            //_utils.debug("errorID . " + errorId);
		            document.getElementById(errorId).remove();
		        }
		        component.set("v.objectDataMap.errorDateMap."+elementDateClass, false);
		    }
		 }
        
    },
    
    createFakeContextOutput: function(component, event,orderId){
    	//_utils.debug("into createFakeContextOutput");
    	
    	var action = component.get("c.createCartListFromMapLight");
    	action.setParams({ 
				"orderId" : orderId,
				"isPricing": false //francesca.ribezzi 28/11/19 - adding isPricing variable to false 
	    });
    	
		action.setCallback(this, function(response)
		{
			if (response.getState() === "SUCCESS")
			{
				//_utils.debug("OB_TechDetailService.createFakeContextOutput - SUCCESS"); 

				let context = JSON.parse('[' + response.getReturnValue() +']');
				debugger;
				let parents	= {};
				let childs 	= {};
				for(let i = 0 ; i< context.length;i++){
					let cartItem = context[i];
					console.log('parentvid ' +cartItem.fields.parentvid); 
					console.log('vid ' +cartItem.fields.vid); 
					if(cartItem.fields.parentvid ==''){
						parents[cartItem.fields.vid] = cartItem;
					}else
					{
						if(!childs.hasOwnProperty(cartItem.fields.parentvid)){
							childs[cartItem.fields.parentvid]=[];
						}
						childs[cartItem.fields.parentvid].push(cartItem);
					}

				}
				let cart = [];
				for(let key in parents){
					let tempParent = JSON.parse(JSON.stringify(parents[key]));
					if(childs.hasOwnProperty(key)){
						
						tempParent.childItems = {}; 
						tempParent.childItems = childs[key];
					}
		    		cart.push(tempParent);
		    	}

				this.buildPageLists(component,event,cart)
				
			}
			else if (response.getState() === "INCOMPLETE")
			{
				//_utils.debug("OB_TechDetailService.createFakeContextOutput - INCOMPLETE"); 
			}
			else if (response.getState() === "ERROR") 
			{
				var errors = response.getError();
				if (errors) 
				{ 
					if (errors[0] && errors[0].message) 
					{
						//_utils.debug("OB_TechDetailService.createFakeContextOutput - Error message: " + errors[0].message);
					}
				}
				else 
				{
					//_utils.debug("OB_TechDetailService.createFakeContextOutput - UNKNOWN ERROR"); 
				}
			}
		});
		$A.enqueueAction(action);
    },


	// Daniele Gandini <daniele.gandini@accenture.com> - 19/06/2019 - Logic for Request Details Section - START
	checkProfileLoggedUser_helper : function(component, event, helper){
        var action = component.get("c.checkProfileLoggedUser");
        action.setCallback(this, function(response)
        {
            var state = response.getState();
            if (state === "SUCCESS")
            {
                var isOperationLogged = response.getReturnValue();
                component.set( "v.isOperationLogged",  isOperationLogged);
														
            }
            else if (state === "INCOMPLETE")
            {
							   
            }
            else if (state === "ERROR")
            {
                    var errors = response.getError();
                    if (errors)
                    {
                        if (errors[0] && errors[0].message)
                        {
																				
                        }
                    } else {
													  
                    }
            }
        });
        $A.enqueueAction(action);
	},
	// Daniele Gandini <daniele.gandini@accenture.com> - 19/06/2019 - Logic for Request Details Section - END
	populateMapForTerminalId_Helper : function(component, event, helper){
		var TerminalIdsChanged = component.get("v.objectDataMap.TerminalIdsChanged");
		var mapOfTerminalId = {};
		for(var j = 0; j < TerminalIdsChanged.length; j++){
			mapOfTerminalId[j]= "";
		}
		console.log("@@@ map: " + JSON.stringify(mapOfTerminalId));
		var termIdAssignment = component.set("v.termIdMap", mapOfTerminalId);
    },
    
    updateOrderInfoInReplacement_helper : function(component, event, helper){
		console.log("updateOrderInfoInReplacement_helper");
		var termIdSelectedList = component.get("v.termIdSelectedList");
		var orderId = component.get("v.objectDataMap.Configuration.Id");
		console.log("termIdSelectedList: " + termIdSelectedList);
		console.log("orderId: " + orderId);
		var action = component.get("c.updateReplacedOrderItem");
		action.setParams({ 
			"orderId": orderId,
			"terminalIdList": termIdSelectedList													  
	
		});
        action.setCallback(this, function(response)
        {
            var state = response.getState();
												   
            if (state === "SUCCESS")
            {
				var orderItemUpdated = response.getReturnValue();
				console.log("Updated order item: " + JSON.stringify(orderItemUpdated));
	
            }
            else if (state === "INCOMPLETE")
            {
				_utils.debug("INCOMPLETE");
            }
            else if (state === "ERROR")
            {
                    var errors = response.getError();
                    if (errors)
                    {
                        if (errors[0] && errors[0].message)
                        {
                            _utils.debug("Error message: " + errors[0].message);
                        }
                    } else {
                        _utils.debug("Unknown error");
                    }
            }
        });
        $A.enqueueAction(action);
	},
										
	retrieveSiaCodes_Helper : function(component, event, helper){
		var termsId = component.get("v.objectDataMap.TerminalIdsChanged");
		var orderId = component.get("v.objectDataMap.Configuration.Id");
		var action = component.get("c.retrieveSiaCodes");
		action.setParams({ 
			"orderId": orderId,
			"terminalsId": termsId										  
		});								   
        action.setCallback(this, function(response)
        {
            var state = response.getState();
            if (state === "SUCCESS")
            {
				var resultMap = response.getReturnValue();
				console.log("Updated order item: " + JSON.stringify(resultMap));
				component.set('v.siaCodesFromTerminals', resultMap);
            }
            else if (state === "INCOMPLETE")
            {
				_utils.debug("INCOMPLETE");
            }
            else if (state === "ERROR")
            {
                    var errors = response.getError();
                    if (errors)
                    {
                        if (errors[0] && errors[0].message)
                        {
                            _utils.debug("Error message: " + errors[0].message);
                        }
                    } else {
                        _utils.debug("Unknown error");
                    }
            }
        });
        $A.enqueueAction(action);
	},
	// Daniele Gandini <daniele.gandini@accenture.com> - 17/05/2019 - TerminalsReplacement - END	

	// ID 155, Doris Dongmo <doris.tatiana.dongmo@accenture.com>, 30/04/2019 - END
	controlIsSpecialCharacterHelper: function(component,isMandatoryField, isSpecialCharacter, inputIdVar){
		try{
			component.set("v.isMandatoryField",isMandatoryField);
			component.set("v.isSpecialCharacter",isSpecialCharacter);

			if(isMandatoryField == true ||  isSpecialCharacter == true ){
				$A.util.addClass(inputIdVar, 'slds-has-error');	
			}
			
			else {
	
	 
				$A.util.removeClass(inputIdVar, 'slds-has-error');
	 
 
			   
										 
			}

		}catch(err){
			console.log( " ERROR " +err.message);
		}

	},

	// ID 155, Doris Dongmo <doris.tatiana.dongmo@accenture.com>, 30/04/2019 - END
    
		/*
     *@author francesca.ribezzi
     *@date 11/07/2019
     *@task fix dati operativi step (setup) performance
     *@description Method get useful data for setting readOnly attributes
     *@history 11/07/2019 Method created
     */
	getOrderData:function(component,event, orderId){
    	//_utils.debug("into updateAllItems");
		try {
			var action = component.get("c.getOrderDataServer");
			action.setParams({	
				"orderId": orderId
			});
			action.setCallback(this,function(response) 
			{
				var state = response.getState();
				var data = response.getReturnValue();
				//console.log('STATE_CONFIRM_IS: ' + state);			 
				if (state === "SUCCESS" && !$A.util.isEmpty(data))
																										
				{	
					component.set("v.racSIACurrent", data.NE__Order_Header__r.OB_Applicant_RAC_Code_SIA__c);
					component.set("v.terminalIdGenerator", data.NE__Order_Header__r.OB_Terminal_Id_Generator__c);
					component.set("v.terminalIdGeneratorVirtual", data.NE__Order_Header__r.OB_Terminal_Id_Gateway__c);//Simone Misani WN-218				
					component.set("v.orderABI", data.OB_ABI__c); //francesca.ribezzi 28/08/19 adding order abi
					this.createFakeContextOutput(component,event, orderId);
															
					
				}
				else if (state === "INCOMPLETE") 
				{
					//	INCOMPLETE
				}
				else if (state === "ERROR") 
				{
					//	ERROR TBD
													   
				}
			});
			$A.enqueueAction(action); 
		} catch(e) {
			console.log('An error has occured: ' + e.message);
		}

    },

	/*
     *@author francesca.ribezzi
     *@date 08/07/2019
     *@task fix dati operativi step (setup) performance
     *@description Method update items and calls enrichOrder function
     *@history 08/07/2019 Method created
     */
	updateAllItems:function(component,event, helper){
		//_utils.debug("into updateAllItems");
		try {
		//26/07/19 antonio.vatrano - WN-206 - setting yearConstitution on objectdatamap
		this.setYearConstitution(component);
		//francesca.ribezzi 08/07/19 UPDATE ITEMS HERE. if success, call enrichOrder
		var	posList	= component.get("v.posList");		
		var	vasList= component.get("v.vasList");
		var	acquiringList= component.get("v.acquiringList");
		var	bancomatList= component.get("v.bancomatList");
		var server2serverList = component.get("v.server2serverList");
		var completedList = [];
		var parentAndChilItems = [];
		completedList = completedList.concat(posList);
		completedList = completedList.concat(vasList);
		completedList = completedList.concat(acquiringList);
		completedList = completedList.concat(bancomatList);
		completedList = completedList.concat(server2serverList);
		console.log("completedList test: ", completedList);
		var listOfAttributes = [];
		for(var i = 0; i< completedList.length; i++){
			parentAndChilItems.push(completedList[i].fields);
			for(var j = 0; j< completedList[i].childItems.length; j++){
				var child = completedList[i].childItems[j];
				parentAndChilItems.push(child.fields);
			}	
			for(var k = 0; k< completedList[i].listOfAttributes.length; k++){
				var att = completedList[i].listOfAttributes[k];
				//davide.franzini - 18/10/2019 - attr id error fix - START
				if($A.util.isEmpty(att.fields.lineId)){
					att.fields.lineId = completedList[i].fields.id;
				}
				//davide.franzini - 18/10/2019 - attr id error fix - END
				listOfAttributes.push(att.fields);
				if($A.util.isEmpty(att.fields.id)){
					console.log('att ID EMPTY!! ', att);
				}
			}
		}
																														

		console.log('parentAndChilItems: ', parentAndChilItems);
		console.log('listOfAttributes: ', listOfAttributes);

	
			var action = component.get("c.updateAllItemsServer");
			action.setParams({	
				"parentAndChilItems": parentAndChilItems,
				"listOfAttributes": listOfAttributes,
				"orderId":  component.get("v.orderId") //francesca.ribezzi 04/09/19 passing orderId to insert orderItems
			});
			action.setCallback(this,function(response) 
			{
				var state = response.getState();
				var isOk = response.getReturnValue();
				//console.log('STATE_CONFIRM_IS: ' + state);			 
				if (state === "SUCCESS" && isOk) 
				{	
					this.enrichOrder(component,event);
					
				}
				else if (state === "INCOMPLETE") 
				{
					//	INCOMPLETE
				}
				//davide.franzini - 18/10/2019 - Show Error when upsert fails - START
				else if (state === "ERROR" || !isOk) 
				{
					
					component.set("v.Spinner", false);
					var errorMessage = $A.get("$Label.c.OB_ErrorBannerRequiredFields");
					this.showErrorToast(component, event, errorMessage);
				}
				//davide.franzini - 18/10/2019 - Show Error when upsert fails - END 
			});
			$A.enqueueAction(action); 
		} catch(e) {
			console.log('An error has occured: ' + e.stack);
		}

	},
	//26/07/19 francesca.ribezzi checkout function moved here
	checkout: function(component, event){

		var goToCheckout = true;
		var isReplacement = component.get("v.isReplacement");  
    	var isOk = this.checkRequiredInputs(component);  
		//davide.franzini - R1F2-227 - 12/06/2019 - START
		//var cartToCheck = component.get("v.contextOutput");
		//START francesca.ribezzi 11/07/19 cartList is null [no engine]- using these lists instead:
		var	posList	= component.get("v.posList");		
		var	vasList= component.get("v.vasList");
		var	acquiringList= component.get("v.acquiringList");
		var	bancomatList= component.get("v.bancomatList");
		var server2serverList = component.get("v.server2serverList");
		var cartToCheck = [];
		var parentAndChilItems = [];
		cartToCheck = cartToCheck.concat(posList);
		cartToCheck = cartToCheck.concat(vasList);
		cartToCheck = cartToCheck.concat(acquiringList);
		cartToCheck = cartToCheck.concat(bancomatList);
		cartToCheck = cartToCheck.concat(server2serverList);
		var errorMessage = $A.get("$Label.c.OB_ErrorBannerRequiredFields");
		//END francesca.ribezzi 11/07/19 

		//francesca.ribezzi 18/09/19 - R1F3-84 - using cartToCheck and checking if every terminal id is populated:
		var blankTermId = false; //adding flag to check if a term id is not populated 
		if(cartToCheck != null){		
			for(var i = 0; i< cartToCheck.length; i++){
				if(blankTermId){
					break;
				}
				for(var j = 0; j<cartToCheck[i].listOfAttributes.length;j++){
					var att = cartToCheck[i].listOfAttributes[j];
					if(att.fields.name == 'Terminal Id'){
						if($A.util.isEmpty(att.fields.value) || att.fields.error){  //08/10/19 francesca.ribezzi WN-576 checking if there s any error
							goToCheckout = false;
							blankTermId = true;
							break;
						}else{
							goToCheckout = true; 
						}
					}
				}
			}
		}
		//davide.franzini - R1F2-227 - 12/06/2019 - END
		// Daniele Gandini <daniele.gandini@accenture.com> - 17/05/2019 - TerminalsReplacement - START  	
		if(isReplacement){
			var isOperationLogged = component.get("v.isOperationLogged");
			var isComponentOperationOn = (isReplacement && isOperationLogged);
			var termiIdMap = component.get("v.termIdMap");
			var dateError = component.get("v.dateError");
			var listSelectedTermId = [];
			for(var key in termiIdMap){
				listSelectedTermId.push(termiIdMap[key]);
			}
			var setOfTermIdSelected = new Set(listSelectedTermId);
			if(setOfTermIdSelected.size != component.get("v.objectDataMap.TerminalIdsChanged").length){
				goToCheckout=false;
				errorMessage = $A.get("$Label.c.OB_ErrorBannerTerminalId"); //francesca.ribezzi WN-536 01/10/19 adding new message for replacement
			}else{
				component.set("v.termIdSelectedList", listSelectedTermId);
			}
		}
		// Daniele Gandini <daniele.gandini@accenture.com> - 17/05/2019 - TerminalsReplacement - END

		/*START gianluigi.virga 23/07/2019 - PRODOB-161 - Added simCardIsValid and thirdPartyPropertyIsValid conditions in the if statement. 
		The first one only when simCard property is visible and not filled for at least one pos, the second one when there is one or more 'pos terzi'*/
		var listOfItems = component.get("v.posList");
		var simCardIsValid = true;
		var thirdPartyPropertyIsValid = true;
		for(var i = 0; i < listOfItems.length; i++){
			var currentPos = listOfItems[i];
			for(var j = 0; j < currentPos.listOfAttributes.length; j++){
				if(currentPos.listOfAttributes[j].fields.name == $A.get("$Label.c.OB_SimCard") && currentPos.listOfAttributes[j].fields.action != $A.get("$Label.c.OB_ActionNone")
						&& (currentPos.listOfAttributes[j].fields.simCardIsValid == undefined 
						|| currentPos.listOfAttributes[j].fields.simCardIsValid == null 
						|| currentPos.listOfAttributes[j].fields.simCardIsValid == ''
						|| currentPos.listOfAttributes[j].fields.simCardIsValid == false)){
					simCardIsValid = false;
				}
				if(currentPos.listOfAttributes[j].fields.name == $A.get("$Label.c.OB_Property")
						&& currentPos.fields.categoryname == $A.get("$Label.c.OB_TerminaliTerzi")
						&& currentPos.listOfAttributes[j].fields.action != $A.get("$Label.c.OB_ActionNone")
						&& (currentPos.listOfAttributes[j].fields.thirdPartyPropertyIsValid == undefined 
						|| currentPos.listOfAttributes[j].fields.thirdPartyPropertyIsValid == null 
						|| currentPos.listOfAttributes[j].fields.thirdPartyPropertyIsValid == ''
						|| currentPos.listOfAttributes[j].fields.thirdPartyPropertyIsValid == false)){
					thirdPartyPropertyIsValid = false;
				}
			}
		}
		//END gianluigi.virga 23/07/2019 - PRODOB-16
		
		var siaIsValid = component.get("{!v.siaIsValid}");//[11-03-2019 Manage Rac Sia Code] Andrea Saracini
		//START [08-05-2019 No Card Present Server2Server] Andrea Saracini
		var itemServer2Server = component.get("v.server2serverList");
		//francesca.ribezzi 04/09/19 adding isNoteOK - WN-349
		var isNoteOK = component.get("v.isNoteOK"); 
		var isOkPrelimVerifCode = component.get("v.isOkPrelimVerifCode");//francesca.ribezzi 26/09/19 adding isOkPrelimVerifCode - WN-368
		var isConventionCodeOk = component.get("v.isConventionCodeOk"); //09/10/19 francesca.ribezzi WN-551 adding check if conventionCode is required 
		var isValideCheckOut = (goToCheckout && isOk && siaIsValid && simCardIsValid && thirdPartyPropertyIsValid && isNoteOK && isOkPrelimVerifCode && isConventionCodeOk); //gianluigi.virga 26/08/2019 - added simCardIsValid and thirdPartyPropertyIsValid conditions

       	//START [08-05-2019 No Card Present Server2Server] Andrea Saracini		
		var itemServer2Server = component.get("v.server2serverList");
		var isServer2ServerVailid = true;
		
		var attrRequired = [];
        
        for(var j=0; j<itemServer2Server.length; j++){
            var item = itemServer2Server[j].listOfAttributes;
            for(var i=0; i<item.length; i++){
                if(item[i].fields.required == 'Yes' && (item[i].fields.value == '' || item[i].fields.value == null)){
                    attrRequired.push(item[i].fields.required);
                }
            }
        }      
        if(!$A.util.isEmpty(attrRequired)){
            isServer2ServerVailid = false;
		}
		//STOP [08-05-2019 No Card Present Server2Server] Andrea Saracini
																														
		// Daniele Gandini <daniele.gandini@accenture.com> - 17/05/2019 - TerminalsReplacement - added dateError conditionc - START
		if(isReplacement && isOperationLogged && !dateError  && isValideCheckOut ){				 
			component.set("v.checkoutPerformance", Date.now());												  
			component.set("v.requestCheckout",true); 
			//francesca.ribezzi 08/07/19 not calling checkout event anymore - call updateAllItems instead
			this.updateAllItems(component, event);
			this.updateOrderInfoInReplacement_helper(component, event, helper);
		//	component.set("v.Spinner",true); 
		}else if(isReplacement && !isOperationLogged && isValideCheckOut){												  
			component.set("v.checkoutPerformance", Date.now());												  
			component.set("v.requestCheckout",true);
			//francesca.ribezzi 08/07/19 not calling checkout event anymore - call updateAllItems instead
			this.updateAllItems(component, event); 
			this.updateOrderInfoInReplacement_helper(component, event, helper);
		//	component.set("v.Spinner",true);
		// Daniele Gandini <daniele.gandini@accenture.com> - 17/05/2019 - TerminalsReplacement - added dateError condition - END
		}else if(isValideCheckOut){ //STOP [11-03-2019 Manage Rac Sia Code] Andrea Saracini ) 
	    	//_utils.debug('__CHECKOUT__');
	        component.set("v.requestCheckout",true); 
																			
		//	component.set("v.Spinner",true); 
			//francesca.ribezzi 08/07/19 not calling checkout event anymore - call updateAllItems instead
			this.updateAllItems(component, event);
        }else{
			// francesca.ribezzi 30/07/19 setting red border to empty required fields - WN-211
			this.handleRedBorderErrors(component,event); 
			this.showErrorToast(component, event, errorMessage);
			//29/07/19 francesca.ribezzi removing spinner
			component.set("v.Spinner", false);
		}
			//francesca.ribezzi 08/07/19 not calling checkout event anymore - call updateAllItems instead
		//	helper.updateAllItems(component, event, helper);

	},
	

	//start antonio.vatrano wn206 26/07/2019
    setYearConstitution : function (component){
        var objDataMap= component.get("v.objectDataMap");
        console.log('@@@objDataMap: ', objDataMap);
        var yearMerchant = objDataMap.merchant.OB_Year_constitution_company__c;
        if( yearMerchant == undefined || yearMerchant== null || yearMerchant =='' ) {
            component.set("v.objectDataMap.unbind.yearOfConstitutionCompany",'');
        }else{
            component.set("v.objectDataMap.unbind.yearOfConstitutionCompany", yearMerchant);
        }
        console.log('@@@objDataMap after: ', objDataMap);
    },
	//start antonio.vatrano wn206 26/07/2019
	/*
    *@author francesca.ribezzi
    *@date 30/07/2019
    *@task  setting red border to empty required fields - WN-211
    *@history 30/07/2019 Method created
    */
	handleRedBorderErrors: function(component, event, input){
		var isEmpty =  ($A.util.isEmpty(input));
		var siaCode = component.find('siaCode');
		$A.util.addClass(siaCode, "slds-has-error");

		switch(isEmpty) {
			case true:
				var requiredInputs = document.getElementsByClassName('requiredInput');
				//var requiredInputLight = document.getElementsByClassName('requiredInputLight');
				var checkRacSiaInputs = component.get("v.checkRacSiaInputs");
				component.set("v.checkRacSiaInputs", !checkRacSiaInputs); //this triggers the same function in OB_ManageRacSia cmp
				var checkConventionCodeInput = component.get("v.checkConventionCodeInput"); //09/10/19 francesca.ribezzi WN-551 adding checkConventionCodeInput
				component.set("v.checkConventionCodeInput", !checkConventionCodeInput); //this triggers the same function in OB_ConventionCodeSearch cmp
				for(var i = 0; i <requiredInputs.length; i++){
					console.log(requiredInputs[i].value);
					if($A.util.isEmpty(requiredInputs[i].value)){
						requiredInputs[i].classList.add("slds-has-error");
					}else{
						requiredInputs[i].classList.remove("slds-has-error");
					}
				}

				/*for(var i = 0; i <requiredInputLight.length; i++){
					console.log(requiredInputLight[i].value);
					if($A.util.isEmpty(requiredInputLight[i].value)){
						$A.util.addClass(requiredInputLight[i], "slds-has-error");
					}else{
						$A.util.addClass(requiredInputLight[i], "slds-has-error");
					}
				}*/

			  break;
			case false:
				if($A.util.isEmpty(input.value)){
					input.classList.add("borderError");
				}else{
					input.classList.remove("borderError");
				}
		}
	},
	//davide.franzini - WN-241 - 02/08/2019 - START
	showToast: function(component,event, message, type){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: '',
            message:  message,
            duration: '5000',
            key: 'info_alt',
            type: type,
            mode: 'pester'
        });
        toastEvent.fire();
    },
	//davide.franzini - WN-241 - 02/08/2019 - END
	//davide.franzini - WN-28 - 19/08/2019 - START
    cloneSiaCode: function(component,event){
        var	posList	= component.get("v.posList");
        var	posListAdd	= component.get("v.posListAdd");
        var isMaintenance = component.get("v.isMaintenance");
        var racSIA = component.get("v.objectDataMap.bankProfile.OB_Applicant_RAC_Code_SIA__c");
        var siaCode = '';
        var progSia = '';
        var estbCode = '';
        var posToCheck = [];
        var posToUpdate = [];

        if(isMaintenance && posListAdd.length > 0 && racSIA == 'Nexi'){
            posToCheck = posList;
            posToUpdate = posListAdd;
        }else if(posListAdd.length > 1){
            posToCheck = posListAdd;
            posToUpdate = posListAdd;
        }

        if(posToCheck.length > 0){
            for(var i=0; i<posToCheck.length; i++){
                var pos = posToCheck[i];
                for(var j=0; j<pos.listOfAttributes.length;j++){
                    var attr = pos.listOfAttributes[j];
                    if(String(attr.fields.name).toLowerCase() == 'codice sia' && attr.fields.value){
                        siaCode = attr.fields.value;
                    }
                    if(String(attr.fields.name).toLowerCase() == 'progressivo sia' && attr.fields.value){
                        progSia = attr.fields.value;
                    }
                    if(String(attr.fields.name).toLowerCase() == 'codice stabilimento sia' && attr.fields.value){
                        estbCode = attr.fields.value;
                    }
                }
                if(siaCode && progSia && estbCode){break;}
            }

            for(var i=0; i<posToUpdate.length; i++){
                var pos = posToUpdate[i];
                for(var j=0; j<pos.listOfAttributes.length;j++){
                    var attr = pos.listOfAttributes[j];
                    if(String(attr.fields.name).toLowerCase() == 'codice sia'){
                        attr.fields.value = siaCode;
                    }
                    if(String(attr.fields.name).toLowerCase() == 'progressivo sia'){
                        attr.fields.value = progSia;
                    }
                    if(String(attr.fields.name).toLowerCase() == 'codice stabilimento sia'){
                        attr.fields.value = estbCode;
                    }
                }
            }

            component.set("v.posListAdd", posToUpdate);
        }
    },
	//davide.franzini - WN-28 - 19/08/2019 - END
	
	/*
    *@author francesca.ribezzi
    *@date 07/10/2019
    *@task  calling server to update Configuration from configuration node on objectDataMap when a pos is removed and no other action has been taken.
    *@history 07/10/2019 Method created
    */
	updateConfiguration: function(component,event, configurationString){

		var action = component.get("c.updateConfigurationServer");
		action.setParams({ 
			confString: configurationString
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {        
				var res = response.getReturnValue();	                
				
				if(res){
					//07/10/19 francesca.ribezzi calling checkout function here:
					this.checkout(component, event);	
				}
				else{
					//error message
					//toast message error TODO		
				}
			}
			else if (state === "INCOMPLETE") {
				component.set("v.Spinner",false);
			}
			else if (state === "ERROR") {
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							//_utils.debug("Error message: " + 
										//errors[0].message);
						}
					} else {
						//_utils.debug("Unknown error");
					}
					component.set("v.Spinner",false);
			}
		});
		$A.enqueueAction(action);
	},

})