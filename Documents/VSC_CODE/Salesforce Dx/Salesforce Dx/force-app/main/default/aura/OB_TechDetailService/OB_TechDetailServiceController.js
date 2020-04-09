({    
    doInit : function(component, event, helper) {
    	
    	var isMaintenance = component.get("v.isMaintenance");
    	var isFlow = component.get("v.isFlow");
    	var objectDataMap = component.get("v.objectDataMap");
    	
    	if(component.get("v.isFlow") == true && isMaintenance == false ){
	    	var postPagatoPickList = [];
	    	postPagatoPickList.push( $A.get("$Label.c.OB_PostpaidSettlmentMethodNetValue"));
	    	postPagatoPickList.push( $A.get("$Label.c.OB_PostpaidSettlmentMethodGrossValue"));
	    	component.set('v.postPagatoPickList',postPagatoPickList);
	    	//25-09-2018-Salvatore P.-Set input values in object data map nodes
			var objectDataMap = component.get("v.objectDataMap");
			console.log("OBJECT DATA MAP IN OPERATIONAL DATA: " + JSON.stringify(objectDataMap));
			////_utils.debug('do init of Operational Data Controller');
			helper.getReportType(component,helper ,event );
			component.set("v.onfocusvar",false);
			// ****** Doris T. ** 08/10/2018 **** START **//
			var BillingProfileABI = component.get("v.objectDataMap.BillingProfilePOS.OB_ABICode__c");
			// var bankABI           = component.get("v.objectDataMap.bank.OB_ABI__c"),
			// 	CAB               = component.get("v.objectDataMap.user.OB_CAB__c");

			//	Daniele Gandini <daniele.gandini@accenture.com>	16/04/2019 - R1F2-15 - Start
			var bankABI           = component.get("v.objectDataMap.user.OB_ABI__c"),
			    CAB               = component.get("v.objectDataMap.user.OB_CAB__c");
			//	Daniele Gandini <daniele.gandini@accenture.com>	16/04/2019 - R1F2-15 - Stop

			////_utils.debug('ABI tech detail: ' + bankABI +' CAB ' + CAB);
			////_utils.debug("bank ABI = " + bankABI );
			////_utils.debug("BillingProfile ABI = " + BillingProfileABI);
	
			 var abiValue          = component.find("abi").get("v.value");
			 ////_utils.debug("abi Value = " + abiValue);
			 //GIOVANNI SPINELLI - 09/11/2018 *** COMPILE THE FIELD ABI E CAB *** START
			 ////_utils.debug('BOOLEAN: ' + objectDataMap.bankProfile.OB_AccountHolder__c);
			 if(objectDataMap.bankProfile.OB_AccountHolder__c=='true'){
			 	////_utils.debug('BOOLEAN IF');
			 	component.set("v.objectDataMap.BillingProfilePOS.OB_CABCode__c", CAB   );
				component.set("v.disabledCab",true);
				component.set("v.objectDataMap.BillingProfilePOS.OB_ABICode__c", bankABI   );
				component.set("v.disabledAbi",true);
			 }else{
			 	////_utils.debug('BOOLEAN ELSE');
			 	component.set("v.objectDataMap.BillingProfilePOS.OB_CABCode__c", ''   );
				component.set("v.disabledCab",false);
				component.set("v.objectDataMap.BillingProfilePOS.OB_ABICode__c", ''   );
				component.set("v.disabledAbi",false);
			 }
			 //GIOVANNI SPINELLI - 09/11/2018 *** COMPILE THE FIELD ABI E CAB *** END
			 // if(BillingProfileABI == undefined || BillingProfileABI == null || BillingProfileABI == ''){
			 // 	//BillingProfileABI = bankABI;
			 // 	component.set("v.objectDataMap.BillingProfilePOS.OB_ABICode__c",bankABI);
			 // 	component.set("v.disabledAbi",true);
			 // }
			// ****** Doris T. ** 08/10/2018 **** END **//
			//	START 	micol.ferrari 12/10/2018 - SIT193
			component.set("v.objectDataMap.BillingProfilePOS.OB_HeaderInternational__c",objectDataMap.merchant.Name);
			//	END 	micol.ferrari 12/10/2018 - SIT193
			helper.doInitMethodApex(component,event,helper);
			component.set("v.orderCreatedDate",component.get("v.objectDataMap.OrderHeader.OB_OrderDate__c"));
			
			//get order ID 
	        var orderId = component.get("v.orderId");
	        if($A.util.isEmpty(orderId)){
	        	orderId = objectDataMap.Configuration.Id;
	        	component.set("v.orderId",orderId);
	        	//split items here
	        	helper.splitOrderItemPOS(component,event);
	        }
			
		}
		if(isMaintenance){
			////_utils.debug("into_isMaintenance");
        	var orderId = component.get("v.orderId");
	        if($A.util.isEmpty(orderId)){
	        	orderId = objectDataMap.Configuration.Id;
	        	component.set("v.orderId",orderId);
	        	//split items here
	        	helper.splitOrderItemPOS(component,event);
	        }
		}
		
		if(!isFlow)
		{
			var orderId = component.get("v.orderParameter");
			orderId = orderId.substr(orderId.lastIndexOf('=')+1);
			////_utils.debug('orderParameterDoInit: '+orderId);
			helper.createFakeContextOutput(component,event,orderId);
		}
	},

	//LUBRANO 16/01/2019 Libreria Log
	logInit: function(component){
		_utils.logInit(component.getName());
	},

	generateTerminalId: function(component, event, helper) {
	
		//_utils.debug("into generateTerminalId");
       	//call service from here		
		helper.callService(component);		
	},
    onUpdateContext : function(component, event, helper) {
		
		//_utils.debug('Inside onUpdateContext for TechDetailService');
		
		var objectDataMap = component.get("v.objectDataMap");
		var coreOutput = event.getParam("CartService_Output");
		
		var itemToUpdate =  component.get("v.itemToUpdate");
		var needConfig = component.get("v.needConfig");
		var isEnd = component.get("v.isEnd");
		var itemChildToUpdate = component.get("v.itemChildToUpdate");
		var configurePicklist = component.get("v.configurePicklist");
		var doneCheckout = component.get("v.doneCheckout");
			
		if(coreOutput != null){
			////_utils.debug("GOT THE CONTEXT? ", coreOutput);
		
			if(coreOutput.cart.length == 0){
				//error
				//_utils.debug("Cart is Empty!");
				component.set("v.Spinner",false);
			}
			//THIS IS THE END OF TIMEEEEE!!!!
			else if(isEnd){
				
				component.set("v.contextOutput", coreOutput);
				component.set("v.Spinner", false);
			}
			//
			else if(itemToUpdate != null && !needConfig){
				//_utils.debug("itemToUpdate has been changed!");
		    	////_utils.debug("coreOutput item updated? "+ JSON.stringify(coreOutput));
		    	
		    	if(itemChildToUpdate || configurePicklist){
			    	var closeConfEvent 	= 	$A.get("e.NE:Bit2Win_Event_ResetSaveConfiguration");
		            closeConfEvent.setParams({
		
					    "CartService_Output": coreOutput,
					    "type": "save"
		            });
	
		            closeConfEvent.fire();
		            component.set("v.itemChildToUpdate",null);
		            component.set("v.configurePicklist",false);  
		            component.set("v.isEnd",true);   
	            }
	            else{
	            	component.set("v.Spinner", false);
	            }
		            component.set("v.itemToUpdate", null);
			    	component.set("v.contextOutput", coreOutput);
			}
			
			else if(itemToUpdate != null && needConfig){
				
				if(!configurePicklist){
					//_utils.debug("itemToUpdate childItem has been changed!");
					itemChildToUpdate.fields.OB_enablement__c = component.get("v.itemChildCheck");
					
					var cartEventCheckout = $A.get("e.NE:Bit2win_Event_CartEvent");
		   
					var factsJSON = {"executeRules":true,
							   			"objectList": [{
							   				"action": "modify",
							   				"type": "cartitem",
							   				"uniqueid": "fields.itemCode",
							   				"value": itemChildToUpdate.fields.itemCode, 
							   				"instance": itemChildToUpdate
							   				} 
							   			]
							   		};
					   
					 cartEventCheckout.setParams({
						   'updateB2WGinEngine': factsJSON
					 });
					   
					 cartEventCheckout.fire();
				 }
				 else{//configuring picklist
					var cartEventCheckout = $A.get("e.NE:Bit2win_Event_CartEvent");
		   
					var factsJSON = {"executeRules":true,
							   			"objectList": [{
							   				"action": "modify",
							   				"type": "cartitem",
							   				"uniqueid": "fields.itemCode",
							   				"value": itemToUpdate.fields.itemCode, 
							   				"instance": itemToUpdate
							   				} 
							   			]
							   		};
					   
					 cartEventCheckout.setParams({
						   'updateB2WGinEngine': factsJSON
					 });
					   
					 cartEventCheckout.fire();
					 
				 } 
				 
				 component.set("v.needConfig",false);
				 
			}
			
			else{ //initial situation 
				
				component.set("v.cartList", coreOutput.cart);
				var cart = component.get("v.cartList");
				var pos = [];
				var posAdd = []; //antonio.vatrano 30/05/2019 RI-88
		        var bancomat = [];
		        var vas = [];
		        var acquiring = [];
		        //var categoryName = [];
		        var terminalIdItems = [];
				
				//recordTypes to match
				var terminaliRecordType = "Terminali";
				var terminaliRecordTypeGateway = "Gateway_Virtuale";
				var terminaliRecordTypeEcommerce = "eCommerce";
				var terminaliRecordTypeMoto = "Moto";
				var pagobancomatRecordType = "Pagobancomat";
				var acquiringRecordType = "Acquiring";
				var vasRecordType = "Vas";
				
				//check racSia
				var ob_racSiaNexi = "Nexi"; //nexi
				var ob_racSiaNexiToMatch = ob_racSiaNexi.toLowerCase();
				var ob_racSIACurrent = coreOutput.configuration.OB_Applicant_RAC_Code_SIA__c;	
				var ob_racSIACurrentToMatch = ob_racSIACurrent.toLowerCase();
				//end
				
				terminaliRecordType = terminaliRecordType.toLowerCase();
				terminaliRecordTypeGateway = terminaliRecordTypeGateway.toLowerCase();
				terminaliRecordTypeEcommerce = terminaliRecordTypeEcommerce.toLowerCase();
				terminaliRecordTypeMoto = terminaliRecordTypeMoto.toLowerCase();
				pagobancomatRecordType = pagobancomatRecordType.toLowerCase(); 
				acquiringRecordType = acquiringRecordType.toLowerCase();
				vasRecordType = vasRecordType.toLowerCase();
				
				////_utils.debug(ob_racSIACurrentToMatch+" == "+ob_racSiaNexiToMatch);
				
				 //getting cart lists for each sections (pos, acquiring, vas and acquiring):
		        if(coreOutput.listOfBundles.length > 0){
			        for(var j = 0; j<coreOutput.listOfBundles.length; j++){  
			        	for(var x= 0; x<coreOutput.listOfBundles[j].bundleElements.length; x++){
			        		for(var i = 0; i< cart.length; i++){
			        			if(cart[i] != null){
			        				if(coreOutput.listOfBundles[j].bundleElements[x].fields.id == cart[i].fields.bundleElement){
			        					//if(coreOutput.listOfBundles[j].bundleElements[x].fields.name =="Gestione Terminali" ){
			        					////_utils.debug(cart[i].fields.RecordTypeName.toLowerCase()+ " == "+terminali.toLowerCase());
			        					var recordTypeToMatch = cart[i].fields.RecordTypeName.toLowerCase();
			        					if(recordTypeToMatch == terminaliRecordType || recordTypeToMatch == terminaliRecordTypeGateway  || recordTypeToMatch == terminaliRecordTypeEcommerce || recordTypeToMatch == terminaliRecordTypeMoto)
			        					{
			        						if(cart[i].listOfAttributes.length != 0)
			        						{
			        							for(var k = 0; k < cart[i].listOfAttributes.length; k++)
			        							{
			        								if(cart[i].listOfAttributes[k].fields.name == 'Terminal Id'){
			        									terminalIdItems.push(cart[i]);
			        								}
			        							}
			        							pos.push(cart[i]);	
											}
											//Start antonio.vatrano 30/05/2019 RI-88
											if(cart[i].fields.action == 'Add'){
												posAdd.push(cart[i]);
											}
											//End antonio.vatrano 30/05/2019 RI-88
			        					}
			        					//else if(coreOutput.listOfBundles[j].bundleElements[x].fields.name =="Gestione Pagobancomat" ){
			        					else if(recordTypeToMatch == pagobancomatRecordType && ob_racSIACurrentToMatch != ob_racSiaNexiToMatch ){
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
			        					else if(recordTypeToMatch == vasRecordType ){
			        						if(cart[i].listOfAttributes.length != 0)
			        						{
			        							for(var k = 0; k < cart[i].listOfAttributes.length; k++)
			        							{
			        								if(cart[i].listOfAttributes[k].fields.name == 'Terminal Id'){
			        									cart[i].hasTerminalId = true;
			        									terminalIdItems.push(cart[i]);
			        								}
			        							}
			        							vas.push(cart[i]);
			        						}
			        					}
			        				}
			        			}
			        		}
			        	}
		        	}	
			    }//END filling lists
			    //francesca.ribezzi - setting terminalIdItems
		        component.set("v.terminaIdItemsList", terminalIdItems);
			    //sort lists
			    pos.sort(function(a, b){
				return a.fields.sequence == b.fields.sequence ? 0 : +(a.fields.sequence > b.fields.sequence) || -1;
			    });
			    
			    
			    var posChildItems;
			    //check attributes in pos
			    for(var i = 0; i < pos.length; i++){
			    	posChildItems = [];
	            	for(var j= 0; j < pos[i].childItems.length; j++){
	            		if( (pos[i].childItems[j].fields.visible == "true" || pos[i].childItems[j].fields.visible == true) && pos[i].childItems[j].fields.RecordTypeName !='Pricing'){
	            			posChildItems.push(pos[i].childItems[j]);
	            		}
            	}
            	//SORT pos children
            	posChildItems.sort(function(a, b){
            		return a.fields.sequence == b.fields.sequence ? 0 : +(a.fields.sequence > b.fields.sequence) || -1;
            	});
            	
            	pos[i].childItems = posChildItems;
			    }
			    
			   
			    bancomat.sort(function(a, b){
				return a.fields.sequence == b.fields.sequence ? 0 : +(a.fields.sequence > b.fields.sequence) || -1;
			    });
			    
			    vas.sort(function(a, b){
				return a.fields.sequence == b.fields.sequence ? 0 : +(a.fields.sequence > b.fields.sequence) || -1;
			    });
			    
			    /*
			    acquiringList.sort(function(a, b){
				return a.fields.OB_Sequence__c == b.fields.OB_Sequence__c ? 0 : +(a.fields.OB_Sequence__c > b.fields.OB_Sequence__c) || -1;
			    });
			    */
 
				////_utils.debug("acquiringList: " + JSON.stringify(acquiring));
				////_utils.debug("posList: ",pos);
				////_utils.debug("coreOutput: ",coreOutput);
				component.set("v.posList", pos);
				component.set("v.posListAdd", posAdd);	//antonio.vatrano 30/05/2019 RI-88
		        component.set("v.vasList", vas);
		        component.set("v.acquiringList", acquiring);
		        component.set("v.bancomatList", bancomat);
		        //francesca.ribezzi -  setting contextOutput:
				component.set("v.contextOutput", coreOutput);
				component.set("v.Spinner",false);
			}	
		}
	},
	handleAfterCheckOut : function(component,event, helper){
    	//_utils.debug("into handleAfterCheckOut");
    	
    	var doCheckout = component.get("v.requestCheckout");
    	
    	if(doCheckout){
	    	var bitwinMap = {};
	    	bitwinMap = event.getParam("bitwinMap");
	    	////_utils.debug("bitwinMap: " + JSON.stringify(bitwinMap));
	    	////_utils.debug("bitwinMap.checkOutResponse: " + JSON.stringify(bitwinMap.checkOutResponse));
	    	
	    	//helper.showBit2flowNext(component, event);
	    	helper.enrichOrder(component,event);
	    	component.set("v.requestCheckout",false); 
		}
    },
	
	//this is called when an attribute value is changed. it fires an event that calls onUpdateContext function:
    onChangeAttributeValuePOS: function(component, event, helper){
    	//_utils.debug("into onChangeAttributeValuePOS");
    	var attributeIndex = JSON.stringify(event.target.id); 
        var listOfItems = component.get("v.posList");
        var parentIndex = document.getElementById(event.target.id).name;
        //_utils.debug("parentIndex: " + parentIndex);
       // var firstIndex = event.currentTarget.getAttribute('data-item'); 
       // //_utils.debug("listOfItems[firstIndex].childItems: " + JSON.stringify(listOfItems[firstIndex].childItems));
        ////_utils.debug("posList: " + JSON.stringify(listOfItems));
       // attributeIndex = parseInt(attributeIndex.split('_').pop());
        var pos1 = attributeIndex.indexOf("_")+1;
        var length1 = attributeIndex.indexOf("_",pos1)-1;
        var tempStr = attributeIndex.substr(length1);
        attributeIndex = tempStr.substr(0,tempStr.indexOf('_'));//firstIndex+'_'+index+'_POS'
    
        ////_utils.debug("attributeIndex POS: " + attributeIndex);
        
        //RESET Error Message if updating terminal ID
        var attName = document.getElementById(attributeIndex+'_attName').textContent;
        var itemToUpdate = listOfItems[parentIndex];
         var errMsg= document.getElementById(event.target.id+'_Error');
        //checking if this is the terminal id: 
     /*   if(attName == 'Terminal Id'){
        	 //_utils.debug("it is a terminal id!");
         	 //if it is not readonly and it is required
        	 if(itemToUpdate.listOfAttributes[attributeIndex].fields.required == 'Yes' && (itemToUpdate.listOfAttributes[attributeIndex].fields.readonly == false || itemToUpdate.listOfAttributes[attributeIndex].fields.readonly == 'false')){
        		 //_utils.debug("terminal id is required and must be 9 characters long!");
        		 errMsg.innerHTML = "terminal id is required and must be 9 characters long!"; 
        	 }else{
        		  //reset error Msg if result is correct
        		 errMsg.innerHTML = '';
        	 }
        }*/   
        var contextOutput = component.get("v.contextOutput");
        itemToUpdate.listOfAttributes[attributeIndex].fields.value =  event.target.value;
        //francesca.ribezzi - removing error class from input:
	     var inputValue = event.target.value;
	    /*  if(attName == 'Terminal Id'){   
	         if(/^[0-9]*([,][0-9]{1,3}|)$/.test(event.target.value)){ 
		        if(inputValue.length > 0){
		        	document.getElementById(event.target.id).classList.remove("borderError");
		        }
		        component.set("v.itemToUpdate", itemToUpdate);
		        //_utils.debug("itemToUpdate: ",itemToUpdate);  
		    	
		    	var changeAttributeEvent = 	$A.get("e.NE:Bit2win_Event_AttributeChanged");
					changeAttributeEvent.setParams({
						'itemChanged': itemToUpdate,
						'Context_Output':contextOutput
					});
			    											
			   changeAttributeEvent.fire(); 
			   errMsg.innerHTML = '';
			   component.set("v.Spinner", true);
	         }
	         else{
	        	 errMsg.innerHTML = 'the value is not valid.'
	        	 event.target.value = '';
	        	 document.getElementById(event.target.id).classList.add("borderError");
	         }
	    }*/
    		component.set("v.itemToUpdate", itemToUpdate);
	        //_utils.debug("itemToUpdate: ",itemToUpdate);  
	    	
	    	var changeAttributeEvent = 	$A.get("e.NE:Bit2win_Event_AttributeChanged");
				changeAttributeEvent.setParams({
					'itemChanged': itemToUpdate,
					'Context_Output':contextOutput
				});
		    											
		   changeAttributeEvent.fire(); 
		   errMsg.innerHTML = '';
		   component.set("v.Spinner", true);
	   //component.set("v.itemToUpdate", itemToUpdate); 
    },
     onChangeAttributeValuePOSPickList: function(component, event, helper){
        //_utils.debug("into onChangeAttributeValuePOSPicklist")
        
        var listOfItems = component.get("v.posList");
        //LUBRANO -- 2019/02/23 gestione attribute/parent index index 
		var attributeIndex = event.target.name.replace(/"\""/g, ""); 
        //var attributeIndex = JSON.stringify(event.target.name); 
		//_utils.debug("attributeIndex: " + attributeIndex);
		var indexArray = attributeIndex.split('_');
		var parentIndex = indexArray[0]; 
		attributeIndex = indexArray[1];
		/*
        //var parentIndex = attributeIndex.substring(1, attributeIndex.indexOf('_')); 
    	//_utils.debug("parentIndex: " + parentIndex);
       // var firstIndex = event.currentTarget.getAttribute('data-item'); 
       // //_utils.debug("listOfItems[firstIndex].childItems: " + JSON.stringify(listOfItems[firstIndex].childItems));
        //_utils.debug("posList: " ,listOfItems);
        var pos1 = attributeIndex.indexOf("_")+1;
        var length1 = attributeIndex.indexOf("_",pos1)-1;
        var tempStr = attributeIndex.substr(length1);
        attributeIndex = tempStr.substr(0,tempStr.indexOf('_'));
        */
        //attributeIndex = parseInt(attributeIndex.split('_').pop());
        
        var itemToUpdate = listOfItems[parseInt(parentIndex)];
        var contextOutput = component.get("v.contextOutput");
        itemToUpdate.listOfAttributes[attributeIndex].fields.value =  event.target.value;
        ////_utils.debug("attribute changed: " +itemToUpdate.listOfAttributes[attributeIndex] );
        
        component.set("v.itemToUpdate", itemToUpdate);
  	   
    	component.set("v.isEnd",false);
        //itemToUpdate.childItems[attributeIndex].fields.OB_enablement__c = status; 
	
		 var addRemoveFromCart = $A.get("e.NE:Bit2win_Event_AddRemoveFromCart");  
		 //before launching addRemoveFromCart to configure the item
		 	addRemoveFromCart.setParams({
            	"item": itemToUpdate,
                "action": "modify",
                "typeOfAdd": "multiAdd" 
        	});
		 addRemoveFromCart.fire(); 
		 
		 component.set("v.configurePicklist",true);
		 component.set("v.needConfig",true);
		 component.set("v.Spinner", true);
		 //START gianluigi.virga 23/07/2019 - PRODOB-161
		 if(itemToUpdate.listOfAttributes[attributeIndex].fields.name == $A.get("$Label.c.OB_SimCard")){
			if(itemToUpdate.listOfAttributes[attributeIndex].fields.value != null && itemToUpdate.listOfAttributes[attributeIndex].fields.value != undefined && itemToUpdate.listOfAttributes[attributeIndex].fields.value != ''){
				itemToUpdate.listOfAttributes[attributeIndex].fields.simCardIsValid = true;
			}else{
				itemToUpdate.listOfAttributes[attributeIndex].fields.simCardIsValid = false;
			}
		 }
		 if(itemToUpdate.listOfAttributes[attributeIndex].fields.name == $A.get("$Label.c.OB_Property")){
			if(itemToUpdate.listOfAttributes[attributeIndex].fields.value != null && itemToUpdate.listOfAttributes[attributeIndex].fields.value != undefined && itemToUpdate.listOfAttributes[attributeIndex].fields.value != ''){
				itemToUpdate.listOfAttributes[attributeIndex].fields.thirdPartyPropertyIsValid = true;
			}else{
				itemToUpdate.listOfAttributes[attributeIndex].fields.thirdPartyPropertyIsValid = false;
			}
		 }
		//END gianluigi.virga 23/07/2019 - PRODOB-161

    },
    onChangeItemValuePOS: function(component, event, helper){
    	//_utils.debug("into onChangeItemValuePOS");
    	var attributeIndex = event.target.id; 
        var listOfItems = component.get("v.posList");

        
        var itemToUpdate = listOfItems[parseInt(attributeIndex)];
        var contextOutput = component.get("v.contextOutput");
        ////_utils.debug("itemToUpdate description",itemToUpdate);
        
        itemToUpdate.fields.OB_Description__c = event.srcElement.value;
        
        component.set("v.itemToUpdate", itemToUpdate);
        ////_utils.debug("itemToUpdate: ",itemToUpdate);  
    	
       //_utils.debug("uniqueId "+itemToUpdate.fields.itemCode);
	   var cartEventCheckout = $A.get("e.NE:Bit2win_Event_CartEvent");
	   
	   var factsJSON = {"executeRules":true,
			   			"objectList": [{
			   				"action": "modify",
			   				"type": "cartitem",
			   				"uniqueid": "fields.itemCode",
			   				"value": itemToUpdate.fields.itemCode, 
			   				"instance": itemToUpdate
			   				} 
			   			]
			   		};
	   
	   cartEventCheckout.setParams({
		   'updateB2WGinEngine': factsJSON
	   });
	   
	   cartEventCheckout.fire();

	   component.set("v.Spinner", true);
	   //component.set("v.itemToUpdate", itemToUpdate);  
    },
    
    onCheck :function(component, event, helper){
    
    	//_utils.debug("into onCheck");
    	//
    	component.set("v.isEnd",false);
    	//
    	var attributeIndex = JSON.stringify(event.target.id); 
        var listOfItems = component.get("v.posList");
       // var parentIndex = document.getElementById(event.target.id).name;
        //var parentIndex = event.currentTarget.getAttribute('data-item');
        var parentIndex = attributeIndex.substr(1, attributeIndex.indexOf('_')-1);
        //_utils.debug("parentIndex: " + parentIndex);
        
        var acq1 = attributeIndex.indexOf("_")+1;
        var length1 = attributeIndex.indexOf("_",acq1)-1;
        var tempStr = attributeIndex.substr(length1);
        attributeIndex = tempStr.substr(0,tempStr.indexOf('_'));	
       // attributeIndex = parseInt(attributeIndex.split('_').pop());
        //_utils.debug("attributeIndex "+attributeIndex);
        var itemToUpdate = listOfItems[parseInt(parentIndex)];
        var contextOutput = component.get("v.contextOutput");
        //_utils.debug("itemToUpdate ",itemToUpdate);
        var status;
        if(event.target.checked == true){
        	status = "Y";
        }
        else{
        	status = "N";
        }
        //itemToUpdate.childItems[attributeIndex].fields.OB_enablement__c = status;
        component.set("v.itemChildCheck",status);
        component.set("v.itemChildToUpdate",itemToUpdate.childItems[attributeIndex]);
        component.set("v.itemToUpdate", itemToUpdate);
        ////_utils.debug("itemToUpdate: ",itemToUpdate);  

		
		 var addRemoveFromCart = $A.get("e.NE:Bit2win_Event_AddRemoveFromCart");  
		 //before launching addRemoveFromCart to configure the item
		 	addRemoveFromCart.setParams({
            	"item": itemToUpdate.childItems[attributeIndex],
                "action": "modify",
                "typeOfAdd": "multiAdd" 
        	});
		 addRemoveFromCart.fire(); 
		
		 component.set("v.needConfig",true);
		 component.set("v.Spinner", true);
    
    },   
    //this is called when an attribute value is changed. it fires an event that calls onUpdateContext function:
    onChangeAttributeValueBancomat: function(component, event, helper){
    	//_utils.debug("into onChangeAttributeValueBancomat");
        var attributeIndex = JSON.stringify(event.target.id); 
        var listOfItems = component.get("v.bancomatList");
        var parentIndex = document.getElementById(event.target.id).name;
        ////_utils.debug("parentIndex: " + parentIndex);
       // var firstIndex = event.currentTarget.getAttribute('data-item'); 
       // //_utils.debug("listOfItems[firstIndex].childItems: " + JSON.stringify(listOfItems[firstIndex].childItems));
        //_utils.debug("bancomatList: " ,listOfItems);
        //attributeIndex = parseInt(attributeIndex.split('_').pop());
        var Bancomat1 = attributeIndex.indexOf("_")+1;
        var length1 = attributeIndex.indexOf("_",Bancomat1)-1;
        var tempStr = attributeIndex.substr(length1);
        attributeIndex = tempStr.substr(0,tempStr.indexOf('_'));//firstIndex+'_'+index+'_Bancomat'
        var errMsg = document.getElementById(event.target.id+'Error');
        
        var itemToUpdate = listOfItems[parentIndex];
        var inputNumNameMap = {};
        //francesca.ribezzi - creating map to check the correct input value length for each field:
        inputNumNameMap['Codice SIA'] = 7;
        inputNumNameMap['Codice Stabilimento SIA'] = 5;
        inputNumNameMap['Progressivo SIA'] = 3;
         
        if(itemToUpdate != null){
	        var contextOutput = component.get("v.contextOutput");
	        itemToUpdate.listOfAttributes[attributeIndex].fields.value =  event.target.value;
	        ////_utils.debug("attribute changed: " +itemToUpdate.listOfAttributes[attributeIndex] );
	        var inputValue = event.target.value;
	         //match the regex  /^[0-9]+$/
	        if(/^[0-9]+$/.test(event.target.value)){   	
	        	var nameToCheck = itemToUpdate.listOfAttributes[attributeIndex].fields.name;
				 if(inputValue.length == inputNumNameMap[nameToCheck]){
		        	document.getElementById(event.target.id).classList.remove("borderError");
		        	itemToUpdate.listOfAttributes[attributeIndex].fields.value =  event.target.value;
			        component.set("v.itemToUpdate", itemToUpdate);
			        //_utils.debug("itemToUpdate: ",itemToUpdate);  
			    	var changeAttributeEvent = 	$A.get("e.NE:Bit2win_Event_AttributeChanged");
						changeAttributeEvent.setParams({
							'itemChanged': itemToUpdate,
							'Context_Output':contextOutput
						});
				    											
				   changeAttributeEvent.fire(); 
				   errMsg.innerHTML = '';
				   component.set("v.Spinner", true);
			     }else{
			    	 if(inputValue.length == 0){
			    		 errMsg.innerHTML = '';
				    	 document.getElementById(event.target.id).classList.remove("borderError");
			    	 }else{
				    	 errMsg.innerHTML = $A.get("$Label.c.OB_invalidValue");
				    	 document.getElementById(event.target.id).classList.add("borderError");
				    }
			     }
			     
			}
			else{
				//show error message!!!
				 errMsg.innerHTML = $A.get("$Label.c.OB_invalidValue");
				event.target.value = '';
				document.getElementById(event.target.id).classList.add("borderError");
			}
        }
	 								
    },
    onChangeAttributeValueBancomatPickList: function(component, event, helper){
        //_utils.debug("into onChangeAttributeValueBancomatPicklist")
        
        var listOfItems = component.get("v.bancomatList");
        
        var attributeIndex = JSON.stringify(event.target.name); 
        //_utils.debug("attributeIndex: " + attributeIndex);
        var parentIndex = attributeIndex.substring(1, attributeIndex.indexOf('_')); 
        //_utils.debug("parentIndex: " + parentIndex);
       // var firstIndex = event.currentTarget.getAttribute('data-item'); 
       // //_utils.debug("listOfItems[firstIndex].childItems: " + JSON.stringify(listOfItems[firstIndex].childItems));
        //_utils.debug("vasList: " ,listOfItems);
        var bancomat1 = attributeIndex.indexOf("_")+1;
        var length1 = attributeIndex.indexOf("_", bancomat1)-1;
        var tempStr = attributeIndex.substr(length1);
        attributeIndex = tempStr.substr(0,tempStr.indexOf('_'));
        //attributeIndex = parseInt(attributeIndex.split('_').pop());
        
        var itemToUpdate = listOfItems[parseInt(parentIndex)];
        var contextOutput = component.get("v.contextOutput");
        itemToUpdate.listOfAttributes[attributeIndex].fields.value =  event.target.value;
        ////_utils.debug("attribute changed: " +itemToUpdate.listOfAttributes[attributeIndex] );
        
        component.set("v.itemToUpdate", itemToUpdate);
       // //_utils.debug("itemToUpdate: ",itemToUpdate);  
    	
    	var changeAttributeEvent = 	$A.get("e.NE:Bit2win_Event_AttributeChanged");
			changeAttributeEvent.setParams({
				'itemChanged': itemToUpdate,
				'Context_Output':contextOutput
			});
	    											
	   changeAttributeEvent.fire(); 
	   component.set("v.Spinner", true);
    },      
    //this is called when an attribute value is changed. it fires an event that calls onUpdateContext function:
    onChangeAttributeValueACQ: function(component, event, helper){
        //_utils.debug("into onChangeAttributeValueACQ")
        var attributeIndex = JSON.stringify(event.target.id); 
          //_utils.debug("attributeIndex: " + attributeIndex);
        var listOfItems = component.get("v.acquiringList");
        var parentIndex = document.getElementById(event.target.id).name;
        //_utils.debug("parentIndex: " + parentIndex);
       // var firstIndex = event.currentTarget.getAttribute('data-item'); 
       // //_utils.debug("listOfItems[firstIndex].childItems: " + JSON.stringify(listOfItems[firstIndex].childItems));
        //_utils.debug("acquiringList: " listOfItems);
        var acq1 = attributeIndex.indexOf("_")+1;
        var length1 = attributeIndex.indexOf("_",acq1)-1;
        var tempStr = attributeIndex.substr(length1);
        attributeIndex = tempStr.substr(0,tempStr.indexOf('_'));
       
        //attributeIndex = parseInt(attributeIndex.split('_').pop());
        
        var itemToUpdate = listOfItems[parentIndex];
        var errMsg= document.getElementById(event.target.id+'_Error');
        
        if(itemToUpdate != null){
	        var contextOutput = component.get("v.contextOutput");
	        itemToUpdate.listOfAttributes[attributeIndex].fields.value =  event.target.value;
	        var attName = itemToUpdate.listOfAttributes[attributeIndex].fields.name;
	        ////_utils.debug("attribute changed: " +itemToUpdate.listOfAttributes[attributeIndex] );
	         //match the regex
	        if(/^[0-9]*([,][0-9]{1,3}|)$/.test(event.target.value)){
	        	if(attName == 'Codice Convenzione'){
	        		if(event.target.value.length != 10 && event.target.value.length != 0){
	        			document.getElementById(event.target.id).classList.add("borderError");
	        			errMsg.innerHTML = $A.get("$Label.c.OB_TenCharsError");
	        		}else{
	        			errMsg.innerHTML = '';
	        			document.getElementById(event.target.id).classList.remove("borderError");
	        			
	        			component.set("v.itemToUpdate", itemToUpdate);
				        //_utils.debug("itemToUpdate: ",itemToUpdate);  
				    	var changeAttributeEvent = 	$A.get("e.NE:Bit2win_Event_AttributeChanged");
							changeAttributeEvent.setParams({
								'itemChanged': itemToUpdate,
								'Context_Output':contextOutput
							});
					    											
					   changeAttributeEvent.fire(); 
					   component.set("v.Spinner", true); 
	        		}
	        	}else{
	        		document.getElementById(event.target.id).classList.remove("borderError");
	        		errMsg.innerHTML = '';
			        component.set("v.itemToUpdate", itemToUpdate);
			        //_utils.debug("itemToUpdate: ",itemToUpdate);  
			    	var changeAttributeEvent = 	$A.get("e.NE:Bit2win_Event_AttributeChanged");
						changeAttributeEvent.setParams({
							'itemChanged': itemToUpdate,
							'Context_Output':contextOutput
						});
				    											
				   changeAttributeEvent.fire(); 
				   component.set("v.Spinner", true); 
				}
		   }
		   else{
			   event.target.value = '';
			   errMsg.innerHTML = $A.get("$Label.c.OB_invalidValue");
			   	document.getElementById(event.target.id).classList.add("borderError");
		   }
        }
    },
     onChangeAttributeValueVAS: function(component, event, helper){
    	//_utils.debug("into onChangeAttributeValueVAS");
    	var attributeIndex = JSON.stringify(event.target.id); 
         var listOfItems = component.get("v.vasList");
        var parentIndex = document.getElementById(event.target.id).name;
        //_utils.debug("parentIndex: " + parentIndex);
       // var firstIndex = event.currentTarget.getAttribute('data-item'); 
       // //_utils.debug("listOfItems[firstIndex].childItems: " + JSON.stringify(listOfItems[firstIndex].childItems));
        //_utils.debug("vasList: " ,listOfItems);
        //attributeIndex = parseInt(attributeIndex.split('_').pop());
        
        var vas1 = attributeIndex.indexOf("_")+1;
        var length1 = attributeIndex.indexOf("_",vas1)-1;
        var tempStr = attributeIndex.substr(length1);
        attributeIndex = tempStr.substr(0,tempStr.indexOf('_'));//firstIndex+'_'+index+'_VAS'
        var errMsg = document.getElementById(event.target.id+'Error');
        var itemToUpdate = listOfItems[parentIndex];
        if(itemToUpdate != null){
	        var contextOutput = component.get("v.contextOutput");
	        itemToUpdate.listOfAttributes[attributeIndex].fields.value =  event.target.value;
	        ////_utils.debug("attribute changed: " +itemToUpdate.listOfAttributes[attributeIndex] );
	         if(/^[0-9]*([,][0-9]{1,3}|)$/.test(event.target.value)){ 
		        //francesca.ribezzi - removing error class from input:
		        errMsg.innerHTML = '';
		        var inputValue = event.target.value;
		        if(inputValue.length > 0){
		        	document.getElementById(event.target.id).classList.remove("borderError");
		        }
		        component.set("v.itemToUpdate", itemToUpdate);
		        //_utils.debug("itemToUpdate: ",itemToUpdate);  
		    	
		    	var changeAttributeEvent = 	$A.get("e.NE:Bit2win_Event_AttributeChanged");
					changeAttributeEvent.setParams({
						'itemChanged': itemToUpdate,
						'Context_Output':contextOutput
					});
			    											
			   changeAttributeEvent.fire(); 
			   component.set("v.Spinner", true);
			 }
	         else{
	        	 errMsg.innerHTML = 'Enter a valid value.';
	        	 event.target.value = '';
	        	 document.getElementById(event.target.id).classList.add("borderError");
	         }
	    }
	   //component.set("v.itemToUpdate", itemToUpdate);  
    },
 
    onChangeAttributeValueVASPickList: function(component, event, helper){
        //_utils.debug("into onChangeAttributeValueVASPicklist")
        
        var listOfItems = component.get("v.vasList");
        
        var attributeIndex = JSON.stringify(event.target.name); 
        //_utils.debug("attributeIndex: " + attributeIndex);
        var parentIndex = attributeIndex.substring(1, attributeIndex.indexOf('_')); 
        //_utils.debug("parentIndex: " + parentIndex);
       // var firstIndex = event.currentTarget.getAttribute('data-item'); 
       // //_utils.debug("listOfItems[firstIndex].childItems: " + JSON.stringify(listOfItems[firstIndex].childItems));
        //_utils.debug("vasList: " ,listOfItems);
        
        var vas1 = attributeIndex.indexOf("_")+1;
        var length1 = attributeIndex.indexOf("_", vas1)-1;
        var tempStr = attributeIndex.substr(length1);
        attributeIndex = tempStr.substr(0,tempStr.indexOf('_'));
        //attributeIndex = parseInt(attributeIndex.split('_').pop());
        
        var itemToUpdate = listOfItems[parseInt(parentIndex)];
        var contextOutput = component.get("v.contextOutput");
        itemToUpdate.listOfAttributes[attributeIndex].fields.value =  event.target.value;
        ////_utils.debug("attribute changed: " +itemToUpdate.listOfAttributes[attributeIndex] );
        
        component.set("v.itemToUpdate", itemToUpdate);
       // //_utils.debug("itemToUpdate: ",itemToUpdate);  
    	
    	var changeAttributeEvent = 	$A.get("e.NE:Bit2win_Event_AttributeChanged");
			changeAttributeEvent.setParams({
				'itemChanged': itemToUpdate,
				'Context_Output':contextOutput
			});
	    											
	   changeAttributeEvent.fire(); 
	   component.set("v.Spinner", true);
    },

      checkout: function(component, event, helper){
    	  
    	var isOk = helper.checkRequiredInputs(component);  
		var goToCheckout = true;
		var mapItemIdSuccessTerminalCall = component.get("v.mapItemIdSuccessTerminalCall");
		
		//davide.franzini - R1F2-227 - 12/06/2019 - START
		var cartToCheck = component.get("v.contextOutput");
		var numberTerminalsToCheck = 0;
		var checkedTerminals = 0;

		for(var i=0; i<cartToCheck.cart.length; i++){
			var item = cartToCheck.cart[i];
			for(var j=0; j<item.listOfAttributes.length;j++){
				var att = item.listOfAttributes[j];
				if(att.fields.name == 'Terminal Id'){
					numberTerminalsToCheck = numberTerminalsToCheck + 1;
				}
			}
		}

		var terminalsToCheck = component.get("v.terminalsToCheck");
    	if(terminalsToCheck != null && terminalsToCheck.length>0){		
			for(var i = 0; i< terminalsToCheck.length; i++){
				for(var j = 0; j<terminalsToCheck[i].listOfAttributes.length;j++){
					var att = terminalsToCheck[i].listOfAttributes[j];
					if(att.fields.name == 'Terminal Id'){
						checkedTerminals = checkedTerminals + 1;
						if($A.util.isEmpty(att.fields.value) || (checkedTerminals != numberTerminalsToCheck)){
							goToCheckout = false;
						}else{
							goToCheckout = true; 
						}
					}
				}
			}
		}else if(terminalsToCheck.length != numberTerminalsToCheck){
			goToCheckout = false;
		}
		//davide.franzini - R1F2-227 - 12/06/2019 - END
		
    	if(goToCheckout){
    		//check mapItemIdSuccessTerminalCall;
    		for(var key in mapItemIdSuccessTerminalCall){
    			if(!mapItemIdSuccessTerminalCall[key]){
    				//_utils.debug("SuccessTerminalCall - false! do not checkout!");
    				goToCheckout = false;
    			}
    		}
    	}
		//START [11-03-2019 Manage Rac Sia Code] Andrea Saracini
		var siaIsValid = component.get("{!v.siaIsValid}");
		/*START gianluigi.virga 23/07/2019 - PRODOB-161 - Added simCardIsValid and thirdPartyPropertyIsValid conditions in the if statement. 
		The first one only when simCard property is visible and not filled for at least one pos, the second one when there is one or more 'pos terzi'*/
		var listOfItems = component.get("v.posList");
		var simCardIsValid = true;
		var thirdPartyPropertyIsValid = true;
		for(var i = 0; i < listOfItems.length; i++){
			var currentPos = listOfItems[i];
			for(var j = 0; j < currentPos.listOfAttributes.length; j++){
				if(currentPos.listOfAttributes[j].fields.name == $A.get("$Label.c.OB_SimCard")
						&& (currentPos.listOfAttributes[j].fields.simCardIsValid == undefined 
						|| currentPos.listOfAttributes[j].fields.simCardIsValid == null 
						|| currentPos.listOfAttributes[j].fields.simCardIsValid == ''
						|| currentPos.listOfAttributes[j].fields.simCardIsValid == false)){
					simCardIsValid = false;
				}
				if(currentPos.listOfAttributes[j].fields.name == $A.get("$Label.c.OB_Property")
						&& currentPos.fields.categoryname == $A.get("$Label.c.OB_TerminaliTerzi")
						&& (currentPos.listOfAttributes[j].fields.thirdPartyPropertyIsValid == undefined 
						|| currentPos.listOfAttributes[j].fields.thirdPartyPropertyIsValid == null 
						|| currentPos.listOfAttributes[j].fields.thirdPartyPropertyIsValid == ''
						|| currentPos.listOfAttributes[j].fields.thirdPartyPropertyIsValid == false)){
					thirdPartyPropertyIsValid = false;
				}
			}
		}
		if(goToCheckout && isOk && siaIsValid && simCardIsValid && thirdPartyPropertyIsValid){ //STOP [11-03-2019 Manage Rac Sia Code] Andrea Saracini
		//END gianluigi.virga 23/07/2019 - PRODOB-161
			//_utils.debug('__CHECKOUT__');
			var checkPenalty = 	$A.get("e.NE:Bit2win_Event_ApplyPenalty");
	        checkPenalty.setParams({
	            'action' 	: 	'checkout'
	        });
			//_utils.debug('FIRE EVENT __Bit2win_Event_ApplyPenalty');
	        checkPenalty.fire();
	        
	        component.set("v.requestCheckout",true); 
	
	        component.set("v.Spinner",true); 
        }else{
        	var errorMessage = $A.get("$Label.c.OB_ErrorBannerRequiredFields");
        	helper.showErrorToast(component, event, errorMessage);
        }
    },
    
    /* NEW STUFF */
  	fieldCheck : function(component, event, helper) // onchange
	{
		// 25-09-2018-Salvatore P.-Check if fields are of max length and focus on next input
		var inputId 		= event.getSource().getLocalId();
		var inputValue 		= component.find(inputId).get("v.value");
		var maxLengthInput 	= component.find(inputId).get("v.maxlength");
		//_utils.debug("MAXLENGHT: "+maxLengthInput);

		try
		{
			inputValue=inputValue.toUpperCase();
		}
		catch(err)
		{
			//_utils.debug('err.message: ' + err.message);
		}

		if(inputId == 'euroControlCode')
		{
			component.set("v.objectDataMap.BillingProfilePOS.OB_EuroControlCode__c",inputValue);
			nextInput=document.getElementById('cin');
			if(maxLengthInput==inputValue.length)
			{
				nextInput.focus();
			}

		}
		else if(inputId == 'cin')
		{
			component.set("v.objectDataMap.BillingProfilePOS.OB_CINCode__c",inputValue);
			nextInput=document.getElementById('abi');
			nextInput2=document.getElementById('cab');
			if(maxLengthInput==inputValue.length)
			{
				var disabledAbi = component.get("v.disabledAbi");
				if(disabledAbi == false)
				{	
					nextInput.focus();
				}
				else
				{
					nextInput2.focus();
				}
			}
		}
		else if(inputId == 'abi')
		{
			component.set("v.objectDataMap.BillingProfilePOS.OB_ABICode__c",inputValue);
			nextInput=document.getElementById('cab');
			if(maxLengthInput==inputValue.length)
			{
				nextInput.focus();
			}
		}
		else if(inputId == 'cab')
		{
			component.set("v.objectDataMap.BillingProfilePOS.OB_CABCode__c",inputValue);
			nextInput=document.getElementById('bankAccountNumber');
			if(maxLengthInput==inputValue.length)
			{
				nextInput.focus();
			}
		}
		else if(inputId == 'bankAccountNumber')
		{
			component.set("v.objectDataMap.BillingProfilePOS.OB_Bank_Account_Number__c",inputValue);
			nextInput=document.getElementById('headerInternational');
			if(maxLengthInput==inputValue.length)
			{
				// nextInput.focus();
			}
		}
	},

	completeIban : function(component,event,helper) //onblur
	{
		// 25-09-2018-Salvatore P.-Check mandatory fields and validations 
		var inputId 				= event.getSource().getLocalId();
		//_utils.debug("INPUD ID: "+inputId);
		var inputValue 				= component.find(inputId).get("v.value");
		var errorId 				= 'errorId' + inputId;
		var errorIdValidation 		= 'errorId' + inputId;
		var errorCustomLabel 		= '';
		var myDiv;
		var arrayIban 				= [];
		var arrayConverted 			= [];
		var countryCodeValue 		=	component.get("v.objectDataMap.BillingProfilePOS.OB_CountryCode__c");
		var euroControlCodeValue 	=	component.get("v.objectDataMap.BillingProfilePOS.OB_EuroControlCode__c");
		var cinCodeValue 			=	component.get("v.objectDataMap.BillingProfilePOS.OB_CINCode__c");
		var abiCodeValue 			=	component.get("v.objectDataMap.BillingProfilePOS.OB_ABICode__c");
		var cabCodeValue 			=	component.get("v.objectDataMap.BillingProfilePOS.OB_CABCode__c");
		var bankAccountNumberValue 	= 	component.get("v.objectDataMap.BillingProfilePOS.OB_Bank_Account_Number__c");
		var ibanComplete 			=	countryCodeValue + euroControlCodeValue + cinCodeValue + abiCodeValue + cabCodeValue + bankAccountNumberValue;

		var ibanLength = ibanComplete.length;
		//_utils.debug("iban length: "+ibanLength);
		
		if(inputId == 'euroControlCode')
		{	
			var countryCode = component.find("countryCode").get("v.value");
			if(countryCode=="IT")
			{
				component.set("v.objectDataMap.BillingProfilePOS.OB_CountryCode__c","IT");
			}
			var typeInputValue = isNaN(inputValue);
			component.set("v.objectDataMap.BillingProfilePOS.OB_EuroControlCode__c", '');
			if(!inputValue)
			{				
				if(document.getElementById(errorIdValidation))
				{
					//_utils.debug("errorIdValidation . " + errorIdValidation);
					document.getElementById(errorIdValidation).remove();
				}
				//_utils.debug("control if fields value is null (onblur)");
				$A.util.addClass(component.find(inputId) , 'slds-has-error');
				errorCustomLabel = $A.get("$Label.c.MandatoryField");
				//_utils.debug("ERROR CUSTOM Label: "+errorCustomLabel);
				myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorId);
				myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
				var errorMessage = document.createTextNode(errorCustomLabel);
				myDiv.appendChild(errorMessage);
				var divAfter = component.find(inputId).getElement();
				divAfter.after(myDiv);

			}
			else if(inputValue.length > 0 && inputValue.length != 2 || typeInputValue==true)
			{
				if(document.getElementById(errorId))
				{
					//_utils.debug("errorID . " + errorId);
					document.getElementById(errorId).remove();
				}
				$A.util.addClass(component.find(inputId) , 'slds-has-error');
				errorCustomLabel = $A.get("$Label.c.TwoDigitLength");
				myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorIdValidation);
				myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
				var errorMessage = document.createTextNode(errorCustomLabel);
				myDiv.appendChild(errorMessage);
				var divAfter = component.find(inputId).getElement();
				divAfter.after(myDiv);
			}
			else
			{
				if(document.getElementById(errorId))
				{
					//_utils.debug("errorID . " + errorId);
					document.getElementById(errorId).remove();
				}
				component.set("v.objectDataMap.BillingProfilePOS.OB_EuroControlCode__c", inputValue);
				//_utils.debug("euroControlCode value in object data map:  ",component.get("v.objectDataMap.BillingProfilePOS.OB_EuroControlCode__c"));
				if(ibanLength == 27)
				{
					helper.validateIban(component,event,helper,inputId);
				}
			}
		}
		else if(inputId == "cin")
		{
			var typeInputValue = isNaN(inputValue);
			component.set("v.objectDataMap.BillingProfilePOS.OB_CINCode__c", '');
			if(!inputValue)
			{				
				if(document.getElementById(errorIdValidation))
				{
					//_utils.debug("errorIdValidation . " + errorIdValidation);
					document.getElementById(errorIdValidation).remove();
				}
				//_utils.debug("control if fields value is null (onblur)");
				$A.util.addClass(component.find(inputId) , 'slds-has-error');
				errorCustomLabel = $A.get("$Label.c.MandatoryField");
				//_utils.debug("ERROR CUSTOM Label: "+errorCustomLabel);
				myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorId);
				myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
				var errorMessage = document.createTextNode(errorCustomLabel);
				myDiv.appendChild(errorMessage);
				var divAfter = component.find(inputId).getElement();
				divAfter.after(myDiv);

			}
			else if(inputValue.length > 0 && inputValue.length != 1 || typeInputValue==false)
			{
				if(document.getElementById(errorId))
				{
					//_utils.debug("errorID . " + errorId);
					document.getElementById(errorId).remove();
				}
				$A.util.addClass(component.find(inputId) , 'slds-has-error');
				errorCustomLabel = $A.get("$Label.c.OneCharLength");
				myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorIdValidation);
				myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
				var errorMessage = document.createTextNode(errorCustomLabel);
				myDiv.appendChild(errorMessage);
				var divAfter = component.find(inputId).getElement();
				divAfter.after(myDiv);
			}
			else
			{
				if(document.getElementById(errorId))
				{
					//_utils.debug("errorID . " + errorId);
					document.getElementById(errorId).remove();
				}
				component.set("v.objectDataMap.BillingProfilePOS.OB_CINCode__c", inputValue);
				//_utils.debug("cin value in object data map:  ",component.get("v.objectDataMap.BillingProfilePOS.OB_CINCode__c"));
				if(ibanLength == 27)
				{
					helper.validateIban(component,event,helper,inputId);
				}
			}
		}
		else if(inputId == "abi")
		{
			var typeInputValue = isNaN(inputValue);
			component.set("v.objectDataMap.BillingProfilePOS.OB_ABICode__c", '');
			if(!inputValue)
			{				
				if(document.getElementById(errorIdValidation))
				{
					//_utils.debug("errorIdValidation . " + errorIdValidation);
					document.getElementById(errorIdValidation).remove();
				}
				//_utils.debug("control if fields value is null (onblur)");
				$A.util.addClass(component.find(inputId) , 'slds-has-error');
				errorCustomLabel = $A.get("$Label.c.MandatoryField");
				//_utils.debug("ERROR CUSTOM Label: "+errorCustomLabel);
				myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorId);
				myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
				var errorMessage = document.createTextNode(errorCustomLabel);
				myDiv.appendChild(errorMessage);
				var divAfter = component.find(inputId).getElement();
				divAfter.after(myDiv);

			}
			else if(inputValue.length > 0 && inputValue.length != 5 || typeInputValue==true)
			{
				if(document.getElementById(errorId))
				{
					//_utils.debug("errorID . " + errorId);
					document.getElementById(errorId).remove();
				}
				$A.util.addClass(component.find(inputId) , 'slds-has-error');
				errorCustomLabel = $A.get("$Label.c.FiveDigitLength");
				myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorIdValidation);
				myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
				var errorMessage = document.createTextNode(errorCustomLabel);
				myDiv.appendChild(errorMessage);
				var divAfter = component.find(inputId).getElement();
				divAfter.after(myDiv);
			}
			else
			{
				if(document.getElementById(errorId))
				{
					//_utils.debug("errorID . " + errorId);
					document.getElementById(errorId).remove();
				}
				component.set("v.objectDataMap.BillingProfilePOS.OB_ABICode__c", inputValue);
				//_utils.debug("abi value in object data map:  ",component.get("v.objectDataMap.BillingProfilePOS.OB_ABICode__c"));
				if(ibanLength == 27 && component.get("v.disabledAbi")==false)
				{
					helper.validateIban(component,event,helper,inputId);
				}
			}
		}
		else if(inputId == "cab")
		{
			var typeInputValue = isNaN(inputValue);
			component.set("v.objectDataMap.BillingProfilePOS.OB_CABCode__c", '');
			if(!inputValue)
			{				
				if(document.getElementById(errorIdValidation))
				{
					//_utils.debug("errorIdValidation . " + errorIdValidation);
					document.getElementById(errorIdValidation).remove();
				}
				//_utils.debug("control if fields value is null (onblur)");
				$A.util.addClass(component.find(inputId) , 'slds-has-error');
				errorCustomLabel = $A.get("$Label.c.MandatoryField");
				//_utils.debug("ERROR CUSTOM Label: "+errorCustomLabel);
				myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorId);
				myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
				var errorMessage = document.createTextNode(errorCustomLabel);
				myDiv.appendChild(errorMessage);
				var divAfter = component.find(inputId).getElement();
				divAfter.after(myDiv);

			}
			else if(inputValue.length > 0 && inputValue.length != 5 || typeInputValue==true)
			{
				if(document.getElementById(errorId))
				{
					//_utils.debug("errorID . " + errorId);
					document.getElementById(errorId).remove();
				}
				$A.util.addClass(component.find(inputId) , 'slds-has-error');
				errorCustomLabel = $A.get("$Label.c.FiveDigitLength");
				myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorIdValidation);
				myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
				var errorMessage = document.createTextNode(errorCustomLabel);
				myDiv.appendChild(errorMessage);
				var divAfter = component.find(inputId).getElement();
				divAfter.after(myDiv);
			}
			else
			{
				if(document.getElementById(errorId))
				{
					//_utils.debug("errorID . " + errorId);
					document.getElementById(errorId).remove();
				}
				component.set("v.objectDataMap.BillingProfilePOS.OB_CABCode__c", inputValue);
				//_utils.debug("cab value in object data map:  ",component.get("v.objectDataMap.BillingProfilePOS.OB_CABCode__c"));
				if(ibanLength == 27)
				{
					helper.validateIban(component,event,helper,inputId);
				}
			}
		}
		else if(inputId == "bankAccountNumber")
		{
			component.set("v.objectDataMap.BillingProfilePOS.OB_Bank_Account_Number__c", inputValue);
			var typeInputValue = false;
			if( /[^a-zA-Z0-9]/.test(inputValue))
			{
				typeInputValue = true;
			}
			if(!inputValue)
			{				
				if(document.getElementById(errorIdValidation))
				{
					//_utils.debug("errorIdValidation . " + errorIdValidation);
					document.getElementById(errorIdValidation).remove();
				}
				//_utils.debug("control if fields value is null (onblur)");
				$A.util.addClass(component.find(inputId) , 'slds-has-error');
				errorCustomLabel = $A.get("$Label.c.MandatoryField");
				//_utils.debug("ERROR CUSTOM Label: "+errorCustomLabel);
				myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorId);
				myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
				var errorMessage = document.createTextNode(errorCustomLabel);
				myDiv.appendChild(errorMessage);
				var divAfter = component.find(inputId).getElement();
				divAfter.after(myDiv);

			}
			else if(inputValue.length > 0 && inputValue.length != 12 || typeInputValue==true)
			{
				if(document.getElementById(errorId))
				{
					//_utils.debug("errorID . " + errorId);
					document.getElementById(errorId).remove();
				}
				$A.util.addClass(component.find(inputId) , 'slds-has-error');
				errorCustomLabel = $A.get("$Label.c.TwelveDigitLength");
				myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorIdValidation);
				myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
				var errorMessage = document.createTextNode(errorCustomLabel);
				myDiv.appendChild(errorMessage);
				var divAfter = component.find(inputId).getElement();
				divAfter.after(myDiv);
			}
			else if(document.getElementById(errorId))
			{
				//_utils.debug("errorID . " + errorId);
				document.getElementById(errorId).remove();
			}
			component.set("v.objectDataMap.BillingProfilePOS.OB_Bank_Account_Number__c", inputValue);
			//_utils.debug("bankAccountNumber value in object data map:  ",component.get("v.objectDataMap.BillingProfilePOS.OB_Bank_Account_Number__c"));
			if(ibanLength == 27)
			{
				helper.validateIban(component,event,helper,inputId);
			}
		}
		else if(inputId == 'headerInternational')
		{
			// //_utils.debug("reminder function: "+ helper.longIntegerReminder("96","97"));
			// //_utils.debug("reminder function 2: "+helper.longIntegerReminder("97","97"));
			// //_utils.debug("reminder function 3: "+helper.longIntegerReminder("290","15"));


			component.set("v.objectDataMap.BillingProfilePOS.OB_HeaderInternational__c", inputValue);
			var typeInputValue = false;
			if(/^[a-zA-Z0-9()""?!&% $£=^ °\/\\.'']+$/.test(inputValue))
			{
				typeInputValue = true;
			}
			if(!inputValue)
			{				
				if(document.getElementById(errorIdValidation))
				{
					//_utils.debug("errorIdValidation . " + errorIdValidation);
					document.getElementById(errorIdValidation).remove();
				}
			//_utils.debug("control if fields value is null (onblur)");
			$A.util.addClass(component.find(inputId) , 'slds-has-error');
			errorCustomLabel = $A.get("$Label.c.MandatoryField");
			//_utils.debug("ERROR CUSTOM Label: "+errorCustomLabel);
			myDiv = document.createElement('div');
			myDiv.setAttribute('id',errorId);
			myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
			var errorMessage = document.createTextNode(errorCustomLabel);
			myDiv.appendChild(errorMessage);
			var divAfter = component.find(inputId).getElement();
			divAfter.after(myDiv);
			}
			else if(typeInputValue==false)
			{
				if(document.getElementById(errorId))
				{
					//_utils.debug("errorID . " + errorId);
					document.getElementById(errorId).remove();
				}
				$A.util.addClass(component.find(inputId) , 'slds-has-error');
				errorCustomLabel = $A.get("$Label.c.errorSpecialCharacter");
				myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorIdValidation);
				myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
				var errorMessage = document.createTextNode(errorCustomLabel);
				myDiv.appendChild(errorMessage);
				var divAfter = component.find(inputId).getElement();
				divAfter.after(myDiv);
			}
			else
			{
				if(document.getElementById(errorId))
				{
					//_utils.debug("errorID . " + errorId);
					document.getElementById(errorId).remove();
				}
				component.set("v.objectDataMap.BillingProfilePOS.OB_HeaderInternational__c", inputValue);
				//_utils.debug("headerInternational value in object data map:  ",component.get("v.objectDataMap.BillingProfilePOS.OB_HeaderInternational__c"));
			}
		}

	},

	// ID 155, Doris Dongmo <doris.tatiana.dongmo@accenture.com>, 08/04/2019 Start
	controlIsSpecialCharacter:function(component,event,helper){

		var inputIdVar          = component.find('prelimVerifCode');
		var inputValue 	        = inputIdVar.get("v.value");
		var errorIdValidation 	= 'errorId' + inputIdVar;
		var typeInputValue      = false;	
						
		// ID 155, Doris Dongmo <doris.tatiana.dongmo@accenture.com>, 03/05/2019, update regex
		if(/^[a-zA-Z0-9()?@_:\-!&% $+ \/°.'',]+$/.test(inputValue) ) 
		{
			typeInputValue = true;
						
		}
		if(!inputValue)
		{				
			// BOOLEAN TO SHOW ERROR MESSAGE - BOOLEAN TO HIDE  SPECIAL CHARACTER ERROR MESSAGE - ADD CLASS				
			helper.controlIsSpecialCharacterHelper(component, true,false,inputIdVar);
			
		}

		else if(typeInputValue==false)
		{
			// BOOLEAN TO HIDE ERROR MESSAGE - BOOLEAN TO SHOW  SPECIAL CHARACTER ERROR MESSAGE - ADD CLASS
			helper.controlIsSpecialCharacterHelper(component, false,true,inputIdVar);
			component.set("v.objectDataMap.errorDateMap."+errorIdValidation, true);
		}
		else
		{
			// BOOLEAN TO HIDE ERROR MESSAGE -  BOOLEAN TO HIDE  SPECIAL CHARACTER ERROR MESSAGE - REMOVE CLASS
			helper.controlIsSpecialCharacterHelper(component, false, false,inputIdVar);
			component.set("v.objectDataMap.errorDateMap."+errorIdValidation, false);
		}
	},
		//ID 155, Doris Dongmo <doris.tatiana.dongmo@accenture.com>,  08/04/2019 .....END
	

	setPickListValue : function(component,event,helper)
	{	var currentId = event.getSource().getLocalId();
		//_utils.debug('currentId is:: '+currentId);
		// 25-09-2018-Salvatore P.-Set of picklist value
		component.set("v.objectDataMap.Configuration.OB_Report_Type__c", component.get("v.objectDataMap.OrderHeader.OB_Report_Type__c"));
		//_utils.debug("Report type value in object data map:  ",component.get("v.objectDataMap.Configuration.OB_Report_Type__c"));
		$A.util.removeClass(component.find(currentId) , 'slds-has-error');
        //RECREATE THE SAME ID OF ERROR MESSAGE
        var errorId = 'errorId'+ currentId;
        if(document.getElementById(errorId)!=null){
            //_utils.debug("errorID . " + errorId);
            document.getElementById(errorId).remove();
        }
	},

	setRedBorderoperationalData: function(component, event, helper) 
	{
	 	helper.setRedBorderHelper(component,event,helper);
	},
	
	/* START 	micol.ferrari 01/10/2018 - CREATION OF BILLING PROFILES */
	confirmCreationBillingProfiles: function(component, event, helper) 
	{
		helper.confirmCreationBillingProfilesHelper(component,event,helper);
	},
	/* END	 	micol.ferrari 01/10/2018 - CREATION OF BILLING PROFILES */
	
	picklistPrepagatoChange: function(component, event, helper) {
		var currentId = event.getSource().getLocalId();
		var postPagatoValue = component.get("v.settMethodPostPagatoValue");
		component.set("v.objectDataMap.Configuration.OB_PBSettlementMethod__c", postPagatoValue);
		component.set("v.objectDataMap.Configuration.OB_InternationalSettlementMethod__c", postPagatoValue);
		$A.util.removeClass(component.find(currentId) , 'slds-has-error');
        //RECREATE THE SAME ID OF ERROR MESSAGE
        var errorId = 'errorId'+ currentId;
        if(document.getElementById(errorId)!=null){
            //_utils.debug("errorID . " + errorId);
            document.getElementById(errorId).remove();
        }
	},
	removeRedBorder: function (component, event , helper){
       
        helper.removeRedBorder(component, event , helper);
    },
    
    notBlank: function (component, event , helper){
    	var dateValue = event.getSource().get("v.value");
    	var currentId = event.getSource().getLocalId();
    	//_utils.debug('dateValue:: '+dateValue);
    	if(!dateValue){
    		component.find(currentId).set("v.value", component.get("v.orderCreatedDate"));
    	} else {
    		 helper.removeRedBorderDate(component, event , helper);
    	}
    },
    
    //francesca.ribezzi -  checking if the value is a terminal id and if it is correct:
  /*  checkInputValue: function(component, event, helper) {
    	//_utils.debug("into checkInputValue");
    	var value = event.target.value;//event.getSource().get("v.value");
    	var attributeIndex = JSON.stringify(event.target.id); 
        var listOfItems = component.get("v.posList");
        var parentIndex = document.getElementById(event.target.id).name;
        //_utils.debug("parentIndex: " + parentIndex);
        var pos1 = attributeIndex.indexOf("_")+1;
        var length1 = attributeIndex.indexOf("_",pos1)-1;
        var tempStr = attributeIndex.substr(length1);
        attributeIndex = tempStr.substr(0,tempStr.indexOf('_'));
        var attName = document.getElementById(attributeIndex+'_attName').textContent;
        var itemToUpdate = listOfItems[parentIndex];
        var errMsg= document.getElementById(event.target.id+'_ErrorTerminalId');
        //checking if this is the terminal id: 
	 //   if(value.length > 2){
	    	if(value.length != 8){
	    		errMsg.innerHTML= 'Terminal ID must be 8 characters long.';
	    	}
	  //  }
		
    },*/
    onChangeAttributeValueTerminalId: function(component, event, helper){
    	//_utils.debug("into onChangeAttributeValueTerminalId");
    	var attributeIndex = JSON.stringify(event.target.id); 
    	//francesca.ribezzi - new list composed by vas and pos with terminal ids:
        var listOfItems = component.get("v.terminaIdItemsList");//component.get("v.posList");
        var parentIndex = document.getElementById(event.target.id).name;
        //_utils.debug("parentIndex: " + parentIndex);
        var pos1 = attributeIndex.indexOf("_")+1;
        var length1 = attributeIndex.indexOf("_",pos1)-1;
        var tempStr = attributeIndex.substr(length1);
        var mapItemIdSuccessTerminalCall = component.get("v.mapItemIdSuccessTerminalCall");
        
        attributeIndex = tempStr.substr(0,tempStr.indexOf('_'));//firstIndex+'_'+index+'_POS'
    
        //_utils.debug("attributeIndex : " + attributeIndex);
        
        //RESET Error Message if updating terminal ID
        var attName = document.getElementById(attributeIndex+'_attName').textContent;
        var itemToUpdate = listOfItems[parentIndex];
        var errMsg= document.getElementById(event.target.id+'_ErrorTerminalId');
        //checking if this is the terminal id: 

	    var contextOutput = component.get("v.contextOutput");

        //francesca.ribezzi - removing error class from input:
	     var inputValue = event.target.value;
	         if(/^[0-9]*([,][0-9]{1,3}|)$/.test(event.target.value)){ 
		        if(inputValue.length == 8){
		        	document.getElementById(event.target.id).classList.remove("borderError");
		        	itemToUpdate.listOfAttributes[attributeIndex].fields.value =  event.target.value;
			        component.set("v.itemToUpdate", itemToUpdate);
			        //_utils.debug("itemToUpdate: ",itemToUpdate);  
			    	//moving this logic to success response of callService method!
			    	/*var changeAttributeEvent = 	$A.get("e.NE:Bit2win_Event_AttributeChanged");
						changeAttributeEvent.setParams({
							'itemChanged': itemToUpdate,
							'Context_Output':contextOutput
						});
				    											
				   changeAttributeEvent.fire(); */
				   errMsg.innerHTML = '';
				  // component.set("v.Spinner", true);
			     }else{
			    	 if(inputValue.length == 0){
			    		 errMsg.innerHTML = '';
				    	 document.getElementById(event.target.id).classList.remove("borderError");
			    	 }else{
				    	 errMsg.innerHTML = $A.get("$Label.c.OB_EightCharError");
				    	 document.getElementById(event.target.id).classList.add("borderError");
				    }
			     }
			     

	         }
	         else{
	        	 var errorMessage = $A.get("$Label.c.OB_invalidValue");
	        	 errMsg.innerHTML = errorMessage;
	        	 //event.target.value = '';
	        	 document.getElementById(event.target.id).classList.add("borderError");
	         }
	         
	     mapItemIdSuccessTerminalCall[itemToUpdate.fields.id] = false;
	     //_utils.debug("mapItemIdSuccessTerminalCall: ", mapItemIdSuccessTerminalCall);
	     component.set("v.mapItemIdSuccessTerminalCall", mapItemIdSuccessTerminalCall);
    },
	
	// Doris D.  ...25/03/2019... ::::::: Start//
	open : function (component,event,helper){
           
		component.set("v.showMessage", true);
	
	},
	
	close : function (component,event,helper){
		component.set("v.showMessage", false);
	
	},

	// Doris D.  ...25/03/2019... ::::::: End//
})