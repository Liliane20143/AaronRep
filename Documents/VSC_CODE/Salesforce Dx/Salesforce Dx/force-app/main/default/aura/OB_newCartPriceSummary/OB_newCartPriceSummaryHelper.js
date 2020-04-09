({
    createAttribute: function(listToCheck, category, mainProcess, subProcess){
 
    	_utils.debug("into createAttribute");
    	_utils.debug("listToCheck.length: " + listToCheck.length);

      	var categoriesMap = {}; 
    	for(var key in category){
    		categoriesMap[category[key]] = key;
    	}
    	if($A.util.isEmpty(categoriesMap)){
    		return listToCheck;
    	}
    	else{
	    	if(listToCheck.length > 0){
				try{ //francesca.ribezzi 27/09/19 - WN-509 - adding try catch 
				 	return this.enrichAttribute(listToCheck, categoriesMap, mainProcess, subProcess);
				}catch(err){
					console.log('ERROR into enrichAttribute: ' + err.message);
				}
		
	    	}
	    }
	    
    },
 
    enrichAttribute : function(listToSort, categoriesMap, mainProcess, subProcess){
    	console.log("into enrichAttribute newCartPriceSummary...");
    	//_utils.debug("mainProcess: " + mainProcess);
    	//_utils.debug("subProcess: " + subProcess);
    	//_utils.debug("listToSort..", listToSort);
    	//var numOfCol = component.get("v.numOfCol");
    	var listOfItems = [];
		var colCounter = 0;
		/*
		giovanni spinelli - start - 30/08/2019
		create tmp var to store value of numCol and commissionColSize
		after each loop compare with the value in listToSort[0]
		in this way in tmp is alway stored the max value to organize the whole page 
		with the max number of columns 
		*/
		var tmpCommissionColSize = 1 ;
		var tmpNumOfCol			 = 3 ;
    	for(var i = 0; i<listToSort.length; i++){
			listToSort[i].listOfChildItems = [];
			if( tmpNumOfCol < listToSort[0].numOfCol){
				listToSort[0].numOfCol = 3;
			}else{
				listToSort[0].numOfCol = tmpNumOfCol;
			}						
			
			if(tmpCommissionColSize < listToSort[0].commissionColSize){
				listToSort[0].commissionColSize = 1;
			}else{
				listToSort[0].commissionColSize = tmpCommissionColSize;
			}
    		for(var j = 0; j<listToSort[i].childItems.length; j++){
				for(var k = 0; k<listToSort[i].childItems[j].listOfAttributes.length; k++){
					var att = listToSort[i].childItems[j].listOfAttributes[k];
					var attributeCode = ''; //francesca.ribezzi 02/12/19 - performance - check if attrCode is empty before doing toLowerCase
					//change attributeCode to OB_attribute_code:
					if(!$A.util.isEmpty(att.fields.attributeCode)){
						attributeCode = att.fields.attributeCode.toLowerCase();
					} 
					/*
					giovanni spinelli - START - 28/08/2019
					add  'importo' value as a commission
					*/
					//giovanni spinelli 08/10/2019 - add new value in commission - start
					att.commission = (attributeCode.indexOf('importo 5') != -1) || (attributeCode.indexOf('importo 4') != -1) || (attributeCode.indexOf('importo 3') != -1) || (attributeCode.indexOf('importo 2') != -1) ||(attributeCode.indexOf('importo 1') != -1) || (attributeCode.indexOf('scaglione') != -1) || (attributeCode.indexOf('indifferenziata') != -1) ;
					//giovanni spinelli 08/10/2019 - add new value in commission - start
					//giovanni spinelli - END - 28/08/2019
					//_utils.debug("before if attributeCode: " + attributeCode);
					//_utils.debug("att.commission: " + att.commission);
					//TODO: add vas, bancomat and gateway recordtypes:
					if(att.commission ){ //&& (listToSort[i].fields.RecordTypeName == 'Terminali' || listToSort[i].fields.RecordTypeName == 'Pagobancomat' || listToSort[i].fields.RecordTypeName == 'Vas'
						listToSort[i].childItems[j].commission = true;
						//_utils.debug("sto in commissione");
						att.displaySequence = categoriesMap['COMMISSIONE'];
						var index = att.fields.attributeCode.indexOf(':');
						//_utils.debug("attributeCode: " + att.fields.attributeCode);
						var commissionSequence = att.fields.attributeCode.substring(index-1, index);
						
						//_utils.debug("@@@index: " + index);
						if(isNaN(commissionSequence)){
							commissionSequence = 4;
						}
						//_utils.debug("@@@commissionSequence: " + commissionSequence);
						//_utils.debug('att.displaySequence' + att.displaySequence);
						switch(att.fields.name){
							case 'Commissione':
								att.displaySequence= parseInt(att.displaySequence) + parseFloat(0.01+parseInt(commissionSequence)/10);
							//att.fields.value = '10';
								break;
							/*
							giovanni spinelli - START - 28/08/2019
							add case to manage the 'importo' value in frontend
							*/
							case 'Importo':
								att.displaySequence= parseInt(att.displaySequence) + parseFloat(0.01+parseInt(commissionSequence)/10);
								break
							//giovanni spinelli - END - 28/08/2019
							case 'da': 
								att.displaySequence=parseInt(att.displaySequence) + parseFloat(0.02+parseInt(commissionSequence)/10);
							//	att.fields.value = '10';
								if(!$A.util.isEmpty(att.fields.value)){
									/*
									if there is 'da' attribute it meaning that the 
									number of columns is 5 and col size 3
									store these value in tmp variables to match at next loop
									*/
									listToSort[0].commissionColSize = 3;
									tmpCommissionColSize = listToSort[0].commissionColSize;
									listToSort[0].numOfCol = 5;
									tmpNumOfCol = listToSort[0].numOfCol;
								}
								break;
							case 'a':
								att.displaySequence= parseInt(att.displaySequence) +parseFloat(0.03+parseInt(commissionSequence)/10);
							//	att.fields.value = '10';
								break;
								
						}
						att.rowSequence = commissionSequence;
						//_utils.debug("@@@att.displaySequence: " + att.displaySequence);
					}else{
						//_utils.debug("att.fields.OB_Attribute_Code__c: " + att.fields.OB_Attribute_Code__c);
						att.displaySequence = categoriesMap[att.fields.OB_Attribute_Code__c];
					}
				}
			}
		}
    	//_utils.debug("categoriesMap: ", categoriesMap);
    	for(var i = 0; i<listToSort.length; i++){
    	    //new logic for maintenance:
			//setReadOnly = true
			//var setReadOnly = (listToSort[i].fields.status == 'Active' && mainProcess == 'Maintenance' && subProcess != 'variazione economica'); 
			//'variazione economica' is only used to test - waiting for real values!!
			var setReadOnly; 
			
			//readonly set by rules
		/*	if(($A.util.isEmpty(listToSort[i].fields.status) || listToSort[i].fields.status == 'Pending') && mainProcess == 'Maintenance'){
				//_utils.debug("status is empty or Pending. mainProcess is maintenance: readOnly is FALSE for " + listToSort[i].fields.productname);
				setReadOnly = false;
			}else if(listToSort[i].fields.status == 'Active'){
				setReadOnly = (mainProcess == 'Maintenance' && subProcess != 'variazione economica'); 
				//_utils.debug("status is active. mainProcess is maintenance: readOnly is "+setReadOnly+" for " + listToSort[i].fields.productname);
			}*/
			
			for(var j = 0; j<listToSort[i].childItems.length; j++){
				var localMap = JSON.parse(JSON.stringify(categoriesMap));
				
				for(var k = 0; k<listToSort[i].childItems[j].listOfAttributes.length; k++){
					var att = listToSort[i].childItems[j].listOfAttributes[k];
					/*if(!$A.util.isEmpty(setReadOnly)){
						if(setReadOnly){
							att.fields.readonly = "true";
						}else{
							att.fields.readonly = "false";
						}
					}
					
					if(att.fields.OB_Attribute_Code__c == 'RIDUZIONE'){
						att.fields.readonly = "true";
					}*/
					
					
					//creating list of attributes		
					var attKey = att.fields.idfamily+'_'+att.fields.propid;
					
					
					if(localMap[att.fields.OB_Attribute_Code__c] != undefined){		
						delete localMap[att.fields.OB_Attribute_Code__c]; //francesca.ribezzi 17/12/19 - PERF-32 - using util.isEmpty 
					}else if(att.commission && localMap['COMMISSIONE'] != undefined && !$A.util.isEmpty(att.fields.OB_Attribute_Code__c)){
						delete localMap['COMMISSIONE'];
					}
				}
				//_utils.debug("listToSort[0].commissionColSize: " + listToSort[0].commissionColSize);
				for(var key in localMap){
					var tmpAttr = {};
					tmpAttr.displaySequence = localMap[key];
					tmpAttr.virtualAttribute = true;
					if(key == 'COMMISSIONE'){
						tmpAttr.commission = true;
					}
					tmpAttr.fields = {"value" : null, "name" : "fake"};
					/*
					giovanni spinelli - START - 28/08/2019
					add if condition to manage the addition of new columns
					when they are empty columns
					*/
					if(tmpAttr.commission){
						for(var z = 0; z < parseInt(listToSort[0].commissionColSize); z++){
						listToSort[i].childItems[j].listOfAttributes.push(tmpAttr);
						}
					}else{
						listToSort[i].childItems[j].listOfAttributes.push(tmpAttr);
					}
					//giovanni spinelli - END - 28/08/2019	
				}
				//_utils.debug("before filteredAttributes");
				var filteredAttributes = listToSort[i].childItems[j].listOfAttributes.filter(function(element){ 
					return (!$A.util.isEmpty(element.fields.value) || element.fields.name == 'fake'); //        || element.displaySequence == undefined
				}).sort(function(a, b){
					return a.displaySequence == b.displaySequence ? 0 : +(a.displaySequence > b.displaySequence) || -1;
				});
				listToSort[i].childItems[j].listOfAttributes = filteredAttributes;
				/*if(listToSort[i].childItems[j].listOfAttributes.length > numOfCol){
					numOfCol = listToSort[i].childItems[j].listOfAttributes.length;
				}*/
				//_utils.debug("after filteredAttributes");

				var childItem = this.createListOfItems(listToSort[i].childItems[j]);
				listToSort[i].listOfChildItems.push(childItem);
		
			}
		}

    	//_utils.debug("listToSort: ", listToSort);
    	return listToSort;
    },
    
    createListOfItems : function(childItem){
    	
    	var emptyObj = {};
    	emptyObj.productname = childItem.fields.productname;
    	emptyObj.listOfAttributes = [];
    	//emptyObj.listOfFamilies = [];//francesca.ribezzi 29/11/19 - performance - list of families not used anymore 
    	
    	var needGrid = true; 
    	var attributeLabelsList = [];
    	for(var i = 0; i< childItem.listOfAttributes.length; i++){
    		//francesca.ribezzi - creating a list of all attributes' labels:
			if(childItem.listOfAttributes[i].commission && childItem.listOfAttributes[i].fields.value != null && needGrid){
    			childItem.listOfAttributes[i].openGrid = true;
    			needGrid = false;
    		}else{
    			childItem.listOfAttributes[i].openGrid = false;
    		}
    		if(!childItem.listOfAttributes[i].commission && !needGrid && childItem.listOfAttributes[i].fields.value != null){
    			childItem.listOfAttributes[i].closeGrid = true;
    		}else{
    			childItem.listOfAttributes[i].closeGrid = false;
    		}
    		emptyObj.listOfAttributes.push({
    			"attribute": childItem.listOfAttributes[i]
    		});
		}
		//francesca.ribezzi 29/11/19 - performance - list of families not used anymore 
    /*	for(var i = 0; i< childItem.listOfFamilies.length; i++){ 
    		emptyObj.listOfFamilies.push({
    			"attribute": childItem.listOfFamilies[i] 
    		});
    	}*/
		var description;
		var price;	  
		if(!$A.util.isEmpty(childItem.fields.cartDescription)){
			description = childItem.fields.cartDescription;
		}else{
			description = childItem.fields.description;	
		}
		if(childItem.fields.baserecurringcharge > 0){
			price = childItem.fields.baserecurringcharge;
		}else{
			price = childItem.fields.baseonetimefee;	
		}
		
		//creating labels:
		// var uniqueLabels = attributeLabelsList.filter(function(elem, index, self) {
		// 	return index == self.indexOf(elem);
		//  });
		 //OLD logic:
		/*if(uniqueLabels.indexOf("fake") == -1){
			//_utils.debug("uniqueLabels: ", uniqueLabels);
			childItem.uniqueLabels = [];
			for(var i = 0; i< uniqueLabels.length; i++){
				childItem.uniqueLabels.push(uniqueLabels[i]);	
			}
	    } */ 
	   childItem.uniqueLabels = [];
		//giovanni spinelli - START - 28/08/2019
		childItem.uniqueLabels = this.findLabels(childItem.listOfAttributes);
		console.log('@@@childItem: ', childItem);
		
		emptyObj.description = description;
		emptyObj.price = price;
		emptyObj.qty = childItem.fields.qty;
		emptyObj.item = childItem;
		
		return emptyObj;
	},
	/**
	*@author Giovanni Spinelli <spinelli.giovanni@accenture.com>
	*@date 28/08/2019
	*@description Method create list of unique label sorted by decimal value 
	*@params listOfAttributes
	*@return array with sorted unique label to show when select a pos
	*/
	findLabels:function(listOfAttributes) {
		if(!listOfAttributes){
			return [];
		}
		var beforeDecimal =[];
		var insideDecimal =[];
		var afterDecimal =[];
		var currentArray = beforeDecimal;
		var maxDecimal = 999.99;
		for(var  i =0; i<listOfAttributes.length; i++){
			var displaySequence = listOfAttributes[i].displaySequence;
			//START francesca.ribezzi 27/09/19 - WN-509 - if displaySequence is undefined, continue
			if($A.util.isEmpty(displaySequence)){
				continue;
			}
			//END francesca.ribezzi 27/09/19 - WN-509 
			if(displaySequence % 1 != 0){
				
				currentArray = insideDecimal;
				maxDecimal = displaySequence;
				var temp = displaySequence.toString();
				var lastNum = parseInt(temp[temp.length - 1]);
				displaySequence = parseInt(lastNum , 10 ) - 1;
				
			}else if(displaySequence < maxDecimal ){
				currentArray = beforeDecimal;
			}else if(displaySequence > maxDecimal){
				currentArray = afterDecimal;
				displaySequence = displaySequence - Math.ceil( maxDecimal );
			}
			var attributeName = listOfAttributes[i].fields.name;
			if(attributeName == 'fake'){
				attributeName = ' ';
			}else if(attributeName == 'Gratuità') {
				attributeName = 'Condizioni particolari/Mesi';
			}
			currentArray[displaySequence] = attributeName;
		}
		console.log('@RETURN LABELS: ' , beforeDecimal.concat( insideDecimal ).concat( afterDecimal ));
		
		return beforeDecimal.concat( insideDecimal ).concat( afterDecimal );
		
	},
    
    removeFakeItem : function(component){
    	
    	//_utils.debug("into removeFakeItem");
    	var itemToRemove = component.get("v.itemFakeToRemove");
    	if(itemToRemove != null){
	    	//call event
	    	var configureAppEvent 	= 	$A.get("e.NE:Bit2win_Event_AddRemoveFromCart");
		        configureAppEvent.setParams({
		                'item'	: 	itemToRemove,
		                'action' : 	'remove',
		            });
		    configureAppEvent.fire();
	    	
	    	//wonderful updateContext happenz, will need boolean to undestand where to go next...
	    	component.set("v.itemFakeToRemove",null);
    	}
    },
       
    
    createFakeContextOutput: function(component, event,orderId){
    	//_utils.debug("into createFakeContextOutput");
    	
    	var action = component.get("c.createCartListFromMapLight");//francesca.ribezzi 28/11/19 calling this new light method to retrieve cart
    	 action.setParams({ 
				"orderId" : orderId,
				"isPricing": true //francesca.ribezzi 28/11/19 adding isPricing filer - performance
	    });
    	
		action.setCallback(this, function(response)
		{
			if (response.getState() === "SUCCESS")
			{
				//START enrico.purificato 28/11/19 - performance - creating cart structure:
				let context = JSON.parse('[' + response.getReturnValue() +']');
				let parents	= {};
				let childs 	= {};
				for(let i = 0 ; i< context.length;i++){
					let cartItem = context[i];
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
					if(childs.hasOwnProperty(key)){
						parents[key].childItems = childs[key];
						parents[key].readOnly = true; //francesca.ribezzi 06/12/19 - PERF-17 - setting readonly to pricing attributes 
					}
		    		cart.push(parents[key]);
		    	}
				//END enrico.purificato 28/11/19 - performance	
				this.buildPageLists(component,event,cart);

			}
			else if (response.getState() === "INCOMPLETE")
			{
				//_utils.debug("OB_newCartPriceSummary.createFakeContextOutput - INCOMPLETE"); 
			}
			else if (response.getState() === "ERROR") 
			{
				var errors = response.getError();
				if (errors) 
				{ 
					if (errors[0] && errors[0].message) 
					{
						//_utils.debug("OB_newCartPriceSummary.createFakeContextOutput - Error message: " + errors[0].message);
					}
				}
				else 
				{
					//_utils.debug("OB_newCartPriceSummary.createFakeContextOutput - UNKNOWN ERROR"); 
				}
			}
		});
		$A.enqueueAction(action);
    },  
    
    buildPageLists : function(component,event,cart){
		
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
		var qtyMax = component.get("v.qtyMax");
		var mainProcess = 'Setup';
		var subProcess = '';
		
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

    				
    				var recordTypeToMatch = cart[i].fields.RecordTypeName.toLowerCase();
    					var element = cart[i];
						// ON HOLD: || recordTypeToMatch == terminaliRecordTypeEcommerce || recordTypeToMatch == terminaliRecordTypeMoto
						
    					if(recordTypeToMatch == terminaliRecordType || recordTypeToMatch == terminaliRecordTypeGateway || recordTypeToMatch == terminaliRecordTypeEcommerce || recordTypeToMatch == terminaliRecordTypeMoto) // ANDREA MORITTU 19-Jul-19 - F2WAVE2-147  - ADDED IF CONDITION  //davide.franzini - WN-209 - 29/07/2019 - added check for Moto
    					{	
    						if(cart[i].childItems.length != 0){
    							pos.push(element);
    						}
						}
						
    					//else if(coreOutput.listOfBundles[j].bundleElements[x].fields.name =="Gestione Pagobancomat" ){
    					else if(recordTypeToMatch == pagobancomatRecordType ){	
    						if(cart[i].childItems.length != 0){
    							bancomat.push(element);
    						}
    					}
    					//else if(coreOutput.listOfBundles[j].bundleElements[x].fields.name =="Selezione Acquiring" ){
    					else if(recordTypeToMatch == acquiringRecordType){	
    						if(cart[i].childItems.length != 0){
									acquiring.push(element);
    						}
    					}
    					else if(recordTypeToMatch == acquiringRecordType2){
    						if(cart[i].childItems.length != 0){
    							pciList.push(element);
    						}
    					}
    					//else if(coreOutput.listOfBundles[j].bundleElements[x].fields.name =="Selezione VAS" ){
    					else if(recordTypeToMatch == vasRecordType ){	
    						if(cart[i].childItems.length != 0){	
    							vas.push(element);
    						}
    					}	
    			}
    		}
	        //_utils.debug("after for ");
	        if(itemFakeToRemove != null || itemFakeToRemove != undefined){   
	        	//_utils.debug("before calling removeFakeItem");
	            	this.removeFakeItem(component);	
	        }
   
		   if(pos != undefined && pos.length>0){
			   //_utils.debug("pos is not undefined!!");
			   pos.sort(function(a, b){
				return a.fields.sequence == b.fields.sequence ? 0 : +(a.fields.sequence > b.fields.sequence) || -1;
			});
		        
		   //check attributes in pos
		  //_utils.debug("posList before map: ", pos);
		    for(var i = 0; i < pos.length; i++){
		    	var filteredItems = pos[i].childItems.sort(function(a, b){
					//PRODOB-64 , Doris Dongmo <doris.tatiana.dongmo@accenture.com>,10/05/2019 - START 
					// RESET 'sequence' TO 'OB_Sequence__c' 
					//start antonio.vatrano prodOB_314 11/07/2019
					//start giovanni spinelli 04/11/2019 - fix sequence migration POS
					var intA = isNaN(parseInt(a.fields.OB_Sequence__c)) ? 0 : parseInt(a.fields.OB_Sequence__c);
					var intB = isNaN(parseInt(b.fields.OB_Sequence__c)) ? 0 : parseInt(b.fields.OB_Sequence__c);
					var sec = (intA > intB) ? 1 : -1 ;
					return sec;
					//end giovanni spinelli 04/11/2019 - fix sequence migration POS
					//End antonio.vatrano prodOB_314 11/07/2019
					//PRODOB-64 , Doris Dongmo <doris.tatiana.dongmo@accenture.com>,10/05/2019 - END 
            	}).filter(function(value){ 
							//	_utils.debug("@@value: " ,value);
            		if(value.fields.RecordTypeName == pricingRecordType){
            			if(value.fields.visible == "true" || value.fields.visible == true){
            				return true;
            			} 
		    		}
					});
				
					 	pos[i].childItems = filteredItems;	

            } //for closing HERE!!
            
          
          // _utils.debug("@@@posList", pos);
           
           pos = this.createAttribute(pos, component.get("v.posCategories"), mainProcess, subProcess);	
	   	  //var uniqueLabelsPos  = [];
		  var labelLenPos = 0;
		  
		   if(pos.length > 0 ){
			   numOfCol = pos[0].numOfCol;
			   commissionColSize = pos[0].commissionColSize;
		   }
		   //giovanni spinelli - start - 30/08/2019 - create label for pos in order detail page
		   	   var tmpUniqueLabel = [];
			   for (var i = 0; i < pos.length; i++) {
				   // uniqueLabelsPos = [];
				   for (var k = 0; k < pos[i].childItems.length; k++) {
					   var childItem = pos[i].childItems[k];

					   tmpUniqueLabel.push(JSON.parse(JSON.stringify(childItem.uniqueLabels)));
					   console.log('@@@@tmpUniqueLabel after push: ', tmpUniqueLabel);

				   }
			   }
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
			   //giovanni spinelli - end - 30/08/2019
		   }
		   //giovanni spinelli - start - 30/08/2019 - create label for pagoBancomat in order detail page
           if(bancomat != undefined && bancomat.length>0){
				var tmpUniqueLabelBancomat = [];
               _utils.debug("into bancomat!!!!");
               //_utils.debug("bancomat:", bancomat);
               for(var i = 0; i < bancomat.length; i++){
                    for(var j= 0; j < bancomat[i].childItems.length; j++){
                        if(bancomat[i].childItems[j].fields.visible == "true" || bancomat[i].childItems[j].fields.visible == true){
                            bancomatChildItems.push(bancomat[i].childItems[j]);
                        }
                    }
                     bancomatChildItems.sort(function(a, b){
                         //start antonio.vatrano prodOB_314 11/07/2019
						var intA = parseInt(a.fields.OB_Sequence__c);
						var intB = parseInt(b.fields.OB_Sequence__c);
						var sec = (intA > intB) ? 1 : -1 ;
						return sec;
						//End antonio.vatrano prodOB_314 11/07/2019
                     });
                     bancomat[i].childItems = bancomatChildItems;
                }
            
           //_utils.debug("@@@bancomat", bancomat);
           if(bancomat.length > 0 ){
           		bancomat = this.createAttribute(bancomat, component.get("v.posCategories"), mainProcess, subProcess);	
		   //check attributes in bancomat
           }
		   if(bancomat.length > 0 ){
			   numOfColBancomat = bancomat[0].numOfCol;
			   commissionColSizeBancomat = bancomat[0].commissionColSize;
		   }
		   var labelLenBancomat = 0;
		   for(var i = 0; i<bancomat.length; i++){
				for(var k = 0; k<bancomat[i].childItems.length; k++){
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
			console.log('tmpUniqueLabelBancomat after sort : ' , tmpUniqueLabelBancomat);
			for (var i = 0; i < tmpUniqueLabelBancomat.length; i++) {
				var currentLabel = tmpUniqueLabelBancomat[i];
				for (var j = 0; j < currentLabel.length; j++) {
					if (uniqueLabelsBancomat[j] == ' ' || !uniqueLabelsBancomat[j]) {
						uniqueLabelsBancomat[j] = currentLabel[j];
					} else {
						if (currentLabel[j] &&  JSON.stringify(uniqueLabelsBancomat).indexOf(currentLabel[j]) == -1) {
							uniqueLabelsBancomat[j] = uniqueLabelsBancomat[j] + '/ ' + currentLabel[j];
						}
					}
				}
			}
		   //giovanni spinelli - end - 30/08/2019 
           }
            
		   if(acquiring != undefined && acquiring.length>0){
		   //check attributes in acquiring
		    // R1F2-239 - <daniele.gandini@accenture.com> - 13/06/2019 - Acquiring sort - START
			acquiring.sort(function(a, b){
				//start antonio.vatrano prodOB_314 11/07/2019
				var intA = parseInt(a.fields.OB_Sequence__c);
				var intB = parseInt(b.fields.OB_Sequence__c);
				var sec = (intA > intB) ? 1 : -1 ;
				return sec;
				//End antonio.vatrano prodOB_314 11/07/2019
		   });
		   // R1F2-239 - <daniele.gandini@accenture.com> - 13/06/2019 - Acquiring sort - STOP
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
										// R1F2-118 - daniele.gandini - <daniele.gandini@accenture.com> - copy childItems Acquiring sorting of catalog - START
										// return a.fields.OB_Sequence__c == b.fields.OB_Sequence__c ? 0 : +(a.fields.OB_Sequence__c > b.fields.OB_Sequence__c) || -1;
										return a.fields.OB_Sequence__c == b.fields.OB_Sequence__c ? 0 : (a.fields.OB_Sequence__c - b.fields.OB_Sequence__c);
										// R1F2-118 - daniele.gandini - <daniele.gandini@accenture.com> - copy childItems Acquiring sorting of catalog - END
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
		              		acquiring =	this.createAttribute(acquiring, component.get("v.categoryCircuit"), mainProcess, subProcess);	
							  if(acquiring[0].childItems.length > 0){
								var attrSize = acquiring[0].childItems[0].listOfAttributes.length;
								numOfColACQ = numOfColACQ < attrSize ? attrSize : numOfColACQ;
							  }
						}
		           	
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
				pciList = this.createAttribute(pciList, component.get("v.pciCategories"), mainProcess, subProcess);   
				if(pciList[0].childItems.length > 0){
					var attrSize = pciList[0].childItems[0].listOfAttributes.length;
					numOfColACQ = numOfColACQ < attrSize ? attrSize : numOfColACQ;	
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
	           vas = this.createAttribute(vas, component.get("v.vasCategories"), mainProcess, subProcess);	
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
    	   
    	   component.set("v.spinner", false);

    },
    
		
	getConfigurationApprovalStatus : function(component, event, orderId){
    	var action = component.get("c.getApprovalStatusOfConfiguration");
    	 action.setParams({ 
	        	"orderId" : orderId
	    });
    	
		action.setCallback(this, function(response)
		{
			if (response.getState() === "SUCCESS")
			{
				var conf	= response.getReturnValue();
				console.log("conf from response: ", conf);
				console.log("conf approval status: ", conf.OB_ApprovalStatus__c);
				component.set("v.approvalStatus",  conf.OB_ApprovalStatus__c);
				this.createFakeContextOutput(component,event,orderId);
			//	component.set("v.confApproval", conf);
			}
			else if (response.getState() === "INCOMPLETE")
			{
				
			}
			else if (response.getState() === "ERROR") 
			{
				var errors = response.getError();
				if (errors) 
				{ 
					if (errors[0] && errors[0].message) 
					{
	
					}
				}
				else 
				{

				}
			}
		});
		$A.enqueueAction(action);
		},
		// ANDREA MORITTU START 12/04/2019
		showAcquiringhelper : function (component, event, helper) {
			var buttonPressed = event.target.id;
			var acquiring = component.get("v.acquiringList");
			console.log('##buttonPressed is : ' + buttonPressed);
			if(!$A.util.isEmpty(buttonPressed)) {
				if(!$A.util.isEmpty(acquiring)) {
					for(var singleAcq in acquiring)  {
						if(buttonPressed == 'VM') {
							if(acquiring[singleAcq].fields.OBCodiceSfd == 'VISAMASTERCARD' ) {
								component.set("v.productId" , acquiring[singleAcq].fields.productid );
								console.log('acquiring[singleAcq].fields.NE__ProdId__c' , acquiring[singleAcq].fields.productid);
								break;
							}
						} else if(buttonPressed == 'JCB') {
							if(acquiring[singleAcq].fields.OBCodiceSfd == 'JCB' ) {
								component.set("v.productId" , acquiring[singleAcq].fields.productid );
								console.log('acquiring[singleAcq].fields.NE__ProdId__c' , acquiring[singleAcq].fields.productid);
								break;
							}
						} else if(buttonPressed== 'UPI') { 
							if(acquiring[singleAcq].fields.OBCodiceSfd == 'UPI' ) {
								component.set("v.productId" , acquiring[singleAcq].fields.productid );
								console.log('acquiring[singleAcq].fields.NE__ProdId__c' , acquiring[singleAcq].fields.productid);
								break;
							}
						}	
					}
				}
			}
			component.set("v.showHistoricPricingModalBoolean", true);
			console.log("v.productId is : " + component.get("v.productId"));
		},

		openModalHistoricPricingHelper : function(component, event, helper) {
			/* RESET THE CONTEXT PRODUCT*/
			component.set("v.productId", '' );

			var currentTarget = event.currentTarget;
			var buttonPressed = currentTarget.getAttribute("id");
			console.log('###currentButtonLocation is : ' + buttonPressed);
			var posList = component.get('v.posList');
			if(!$A.util.isUndefined(buttonPressed)) {
				var productIdSplitted = [];
				var productIdSplitted = buttonPressed.split("_");
				console.log('last element is : ' + productIdSplitted.length -1);
				var natureItem = productIdSplitted.slice(-1);
				console.log('natureItem is  :  ' +natureItem);
				/* --------- 			POS SECTION		 ---------*/
				if(natureItem == 'posModal') {
					var productId = productIdSplitted[0];
					var productName = productIdSplitted[1];
				}
				/* --------- 			VAS SECTION		 ---------*/
				else if(natureItem == 'vasModal') {
					var productId = productIdSplitted[0];
					var productName = productIdSplitted[1];
				}
				console.log("## product id is : " + productId);
				component.set("v.productId", productId );
				component.set("v.nameItem", productName );
			}
			component.set("v.showHistoricPricingModalBoolean", true);
		},
		// ANDREA MORITTU END 12/04/2019

		/*
		*	Author		:	Morittu Andrea
		*	Date		:	18-Sept-2019
		*	Task		:	EVO_PRODOB_452
		*	Description	:	Selection of button inside modal maintenance operation
		*/
		chooseMaintenanceOperation_Helper : function(component, event, helper) {
			let clickedButton = event.getSource().get('v.name');
			var decideWhichMaintenanceOperatio = component.getEvent("decideWhichMaintenanceOperation_Evt"); 
			//Set event attribute value
		
			switch (clickedButton) {
				case $A.get("$Label.c.OB_EditCommissionModel"):
					// ANDREA MORITTU START 02-Oct-2019 - EVO_BACKLOG_245 
					let oldConfigurationID = component.get('v.offerAssetSelected.NE__Order_Config__c');
						
					var action = component.get("c.getOldAssetItemAttributes_VM");
					action.setParams({ configurationID :  oldConfigurationID});
	
					action.setCallback(this, function(response) {
						var state = response.getState();
						if (state === "SUCCESS") {
							let oldValues = new Object();
							oldValues = response.getReturnValue();
							component.set('v.oldVMAttributes' , oldValues);
							decideWhichMaintenanceOperatio.setParams({"whichAction" : 'editCommissionBtn'}); 
							decideWhichMaintenanceOperatio.setParams({"oldVisaMastercard" : oldValues}); 
							decideWhichMaintenanceOperatio.fire(); 

						} else if (state === "INCOMPLETE") {
							
						}
						else if (state === "ERROR") {
							var errors = response.getError();
							reject(errors);
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
					// ANDREA MORITTU END 02-Oct-2019 - EVO_BACKLOG_245 
				break;
				case $A.get("$Label.c.OB_EditPricing"):
					// ANDREA MORITTU START 02-Oct-2019 - EVO_BACKLOG_245 
					decideWhichMaintenanceOperatio.setParams({"whichAction" : 'pricingBtn'}); 
					decideWhichMaintenanceOperatio.fire(); 
					// ANDREA MORITTU END 02-Oct-2019 - EVO_BACKLOG_245 
				break;
			}
			component.set('v.showChooseOperationModal', false);
		},
 /**
    *   Author      :       Francesca Ribezzi
    *   Date        :       26-11-2019
    *   Task        :       Performance
    * Description   :       get the highest approvalLevel
    **/
   checkApprovalLevel: function(component, event, childApprovalLevelMap){
	if(childApprovalLevelMap == undefined){
		console.log('into checkApprovalLevel: childApprovalLevelMap is undefined');
		return; 
	}
	var approvalLevelMap = component.get("v.approvalLevelMap"); 
	for(var newKey in childApprovalLevelMap){ //adding new child map to complete map  
		approvalLevelMap[newKey] = childApprovalLevelMap[newKey];
	}
	var approvalLevelList = [];
	for(var key in approvalLevelMap){
		if(approvalLevelMap[key] == null){
			continue;
		}
		approvalLevelList.push(approvalLevelMap[key]);
	}
	if(approvalLevelList.length == 0){
		component.set("v.priceApprovalLevel", '');    
		return;
	}
	var approvalNumber =  'L'+ Math.max(...approvalLevelList); //taking the max value
	component.set("v.priceApprovalLevel", approvalNumber);   
	component.set("v.approvalLevelMap", approvalLevelMap);  
},

	/*
	*	Author		:	Francesca Ribezzi
	*	Date		:	06/12/19
	*	Task		:	PERF-17
	*	Description	:	setting readonly on cartItem --> used to set readonly on its attributes
	*/
	setReadOnlyOnAttributes : function(component, isMaintenancePricing,action){
		if(isMaintenancePricing){
			return false;
		}
		else if($A.util.isEmpty(action)){
			return false;
		}
		else if(action == 'None'){ 
			return true;
		}

	},

		/*
		*	Author		:	Morittu Andrea
		*	Date		:	18-Sept-2019
		*	Task		:	EVO_PRODOB_452
		*	Description	:	if the status is 'Pending' block the user launching this message
		*/
		showInfoMessage : function(component, event, infoMessage){
			console.log("into show info message");
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				title: '',
				message: infoMessage,
				//messageTemplateData: [name],
				duration: '5000',
				key: 'info_alt',
				type: 'info',
				mode: 'dismissible'
			});
			toastEvent.fire();
		},


})