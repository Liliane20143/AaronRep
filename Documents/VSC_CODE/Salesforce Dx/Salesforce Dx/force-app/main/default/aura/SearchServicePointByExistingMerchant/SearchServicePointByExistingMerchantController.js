({
	doInit : function(component, event , helper)
	{   
		/*MODALE MCC & CAP*/
		var objectDataMap = component.get("v.objectDataMap");


		/* START 	micol.ferrari 23/08/2018 - PARAM TO PASS TO POSTEL COMPONENT (--> ADDRESSMAPPING) */
		var postelcomponentparams = {};
		postelcomponentparams.provincelabel         	= $A.get("$Label.c.Province");
		postelcomponentparams.provincedisabled      	= 'false';
		postelcomponentparams.provinceinputobject    	= 'pv';
		postelcomponentparams.provinceinputfield 		= 'NE__Province__c'; 
		postelcomponentparams.citylabel         		= $A.get("$Label.c.City");
		postelcomponentparams.citydisabled        		= 'true';
		postelcomponentparams.cityinputobject      		= 'pv';
		postelcomponentparams.cityinputfield      		= 'NE__City__c';
		postelcomponentparams.districtlabel       		= $A.get("$Label.c.District");
		postelcomponentparams.districtdisabled      	= 'true';
		postelcomponentparams.districtinputobject    	= 'pv';
		postelcomponentparams.districtinputfield    	= 'OB_District__c';
		postelcomponentparams.streetlabel         		= $A.get("$Label.c.Street");
		postelcomponentparams.streetdisabled      		= 'true';
		postelcomponentparams.streetinputobject      	= 'pv';
		postelcomponentparams.streetinputfield      	= 'NE__Street__c';
		postelcomponentparams.streetnumberlabel     	= $A.get("$Label.c.Street_Number");
		postelcomponentparams.streetnumberdisabled    	= 'true';
		postelcomponentparams.streetnumberinputobject  	= 'pv';
		postelcomponentparams.streetnumberinputfield  	= 'OB_Street_Number__c';
		postelcomponentparams.zipcodelabel 				= $A.get("$Label.c.PostalCode");
		postelcomponentparams.zipcodedisabled 			= 'false';
		postelcomponentparams.zipcodeinputobject		= 'pv';
		postelcomponentparams.zipcodeinputfield			= 'NE__Postal_Code__c';

		postelcomponentparams.countrylabel 				= $A.get("$Label.c.Country");
		postelcomponentparams.countrydisabled 			= 'false';
		postelcomponentparams.countryinputobject		= 'pv';
		postelcomponentparams.countryinputfield			= 'NE__Country__c';
		
		postelcomponentparams.countrycodeinputobject	= 'pv';
		postelcomponentparams.countrycodeinputfield		= 'NE__Country_Code__c';

		postelcomponentparams.provincecodeinputobject	= 'pv';
		postelcomponentparams.provincecodeinputfield	= 'OB_Province_Code__c';
		postelcomponentparams.isComplete		        = 'true';

		postelcomponentparams.withCountry		        = 'true';
		postelcomponentparams.withDetail		        = 'true';
		postelcomponentparams.pressoinputfield          = 'OB_Address_Detail__c';
		postelcomponentparams.pressoinputobject         = 'pv';



		component.set("v.postelcomponentparams",postelcomponentparams);
		console.log('postelcomponentparams');
		console.log(JSON.stringify(postelcomponentparams));
		/* END	 	micol.ferrari 23/08/2018 - PARAM TO PASS TO POSTEL COMPONENT */

		
		console.log('this is doInit');  
		console.log("the boolean is" + component.get("v.showOtherInput") );

		//**********METHOD TO RETRIEVE THE ANNUAL  REVENUE VALUE IN SERVICE POINT**********//
		var actionGetAnnualNegotiationValues = component.get("c.getAnnualRevenueValues_SP");
		//var objectDataMap = component.get("v.objectDataMap");
		//console.log("the vat not present into doInit is: " + objectDataMap.merchant.VAT_Not_Present__c);
		actionGetAnnualNegotiationValues.setCallback(this, function(response) 
												 {
													 var state = response.getState();
													 if (state === "SUCCESS") {
														var  tempMap =[];
															var  responseMap= response.getReturnValue();
															for(var key in responseMap)
															{
															    tempMap.push({value:responseMap[key], key:key});
															}
															component.set( "v.annualRevenueList_ServicePoint",  tempMap); 
																													 
													 } 
													 else if (state === "INCOMPLETE") 
													 {
														 // do something
													 }
														 else if (state === "ERROR") 
														 {
															 var errors = response.getError();
															 if (errors) {
																 if (errors[0] && errors[0].message) 
																 {
																	 console.log("Error message: " + 
																				 errors[0].message);
																 }
															 } else 
															 {
																 console.log("Unknown error");
															 }
														 }
												 });
		$A.enqueueAction(actionGetAnnualNegotiationValues);  

		//**********METHOD TO RETRIEVE THE ANNUAL NEGOTIATIED  VALUE IN SERVICE POINT**********//
		var actionGetAnnualNegotiationValues = component.get("c.getAnnualNegotiationValues_SP");
		//var objectDataMap = component.get("v.objectDataMap");
		//console.log("the vat not present into doInit is: " + objectDataMap.merchant.VAT_Not_Present__c);
		actionGetAnnualNegotiationValues.setCallback(this, function(response) 
												 {
													 var state = response.getState();
													 if (state === "SUCCESS") {
														var  tempMap =[];

														var  responseMap= response.getReturnValue();
														for(var key in responseMap)
														{
															    tempMap.push({value:responseMap[key], key:key});
														}
														component.set( "v.annualNegotiatedList_ServicePoint",  tempMap); 
														
														
													 } 
													 else if (state === "INCOMPLETE") 
													 {
														 // do something
													 }
														 else if (state === "ERROR") 
														 {
															 var errors = response.getError();
															 if (errors) {
																 if (errors[0] && errors[0].message) 
																 {
																	 console.log("Error message: " + 
																				 errors[0].message);
																 }
															 } else 
															 {
																 console.log("Unknown error");
															 }
														 }
												 });
		$A.enqueueAction(actionGetAnnualNegotiationValues);  


		
        /*Andrea Morittu RETRIEVING VALUES FROM NE__SERVICE_POINT__c.OB_Typology__c  27/09/2018 *** START ***/
		var actionGetTypologyValues =  component.get("c.getServicePointTypologyValues_SP");

		actionGetTypologyValues.setCallback(this, function(response){

			var state = response.getState();
				if (state === "SUCCESS") {
				var  tempMap =[];
				var  responseMap= response.getReturnValue();

				for(var key in responseMap) {
					tempMap.push({value:responseMap[key], key:key});
				}
				component.set( "v.typologyList",  tempMap);
				console.log("typologyList= "+JSON.stringify(component.get( "v.typologyList")));
				} 
				else if (state === "INCOMPLETE") {
					// do something
				}
				 else if (state === "ERROR") {
					var errors = response.getError();

						if (errors) {

							if (errors[0] && errors[0].message) {
								console.log("Error message: " + errors[0].message);
							} 

						} 
						else {
							console.log("Unknown error");
						}
				
				} 
		 });
		$A.enqueueAction(actionGetTypologyValues);

		/*Andrea Morittu RETRIEVING VALUES FROM NE__SERVICE_POINT__c.OB_Typology__c  27/09/2018 *** END ***/

        
		var objectString = 'pv'; // target object
		
		var mappa = {
			"Name": $A.get("$Label.c.OB_MCC_Description"),
			"NE__Value2__c" : $A.get("$Label.c.MCCCode")
		};
		console.log("doinit objectDataMap: " + JSON.stringify(objectDataMap));
		console.log("mappa " + JSON.stringify(mappa));
		component.set("v.mapLabelColumns", mappa);
		var mapLabelColumns = component.get("v.mapLabelColumns");
		console.log("mapLabelColumns " + JSON.stringify(mapLabelColumns));
		var mappa2 = {}; 
		mappa2['OB_MCC_Description__c'] = 'Name';
		mappa2['OB_MCC__c'] = 'NE__Value2__c';
		component.set("v.mapOfSourceFieldTargetField", mappa2);
		var mapOfSourceFieldTargetField = component.get("v.mapOfSourceFieldTargetField");
		console.log("mapOfSourceFieldTargetField " + JSON.stringify(mapOfSourceFieldTargetField));
		var type = component.get("v.type");
		type = 'MCC';
		component.set("v.type", type);
		component.set("v.objectString", objectString);
		component.set("v.orderBy", "Name");
	},


	
	onClickToSearch:function(component, event, helper) {
		
		
		var searchAddress = component.find("searchInputAddressId").get("v.value");
		var searchName    = component.find("searchInputNameId").get("v.value"); 
		
		if((searchAddress !== undefined || searchAddress !="" || searchAddress != null) &&
		   (searchName !== undefined || searchName !="" || searchName != null)){
			
			component.set("v.booleanDoSearch",false); 
		}
		
		else{
			component.set("v.booleanDoSearch",true);

		}


		
	},

	enableRetrieveServicePoint: function(component, event, helper) {

		helper.enableRetrieveServicePointHelper(component, event);

		var objectDataMap = component.get("v.objectDataMap"); 
        if( objectDataMap.pv.OB_MCC_Description__c != '')
        {          
            //REMOVE RED BORDER
            $A.util.removeClass(document.getElementById('mccDescription') , 'slds-has-error flow_required');
            //****Giovanni Spinelli *****START***21/09/2018*****//
           // component.set("v.objectDataMap.setRedBorder" , false);
            //****Giovanni Spinelli *****END*****21/09/2018*****//
            //IF THERE IS THE ERROR MESSAGE
            if(document.getElementById('errorIdmccDescription'))
            {
                var errorMessage = document.getElementsByClassName('messageErrormccDescription').length;
                console.log("lunghezza: " + errorMessage);
                //TRY TO DELETE THE MESSAGE
                try 
                {
                    for(var i=0 ; i<errorMessage ; i++)
                        {
                            document.getElementById('errorIdmccDescription').remove();
                        }
                
                console.log("success delete");
                }
               catch(err) 
                {
                console.log('err.message: ' + err.message);
             }
             }
        } 

      
 
	},



	openModalMccCap : function(component, event, helper) {

		component.set("v.hideNewButton", true);
		var annualRevenue = component.get("v.objectDataMap.merchant.OB_Annual_Revenue__c");
		var merchantCategoryCode = component.get("v.objectDataMap.pv.OB_MCC_Description__c");
		var tipologia = component.get("v.objectDataMap.pv.OB_MCC_Description__c");

		var zipCode    = component.get("v.objectDataMap.pv.NE__Zip_Code__c");
		component.set("v.objectDataMap.pv.NE__Zip_Code__c", "");

		console.log("zipCode : " + zipCode );
		console.log("annualRevenue : "+ annualRevenue);
		var errorId = 'errorIdannualRevenue';
				

		if(annualRevenue != ''){
			console.log("ANNUAL revenue value ---> "+ component.get("v.objectDataMap.merchant.OB_Annual_Revenue__c"));
			component.set("v.openModalMccCap", true);
			component.set("v.hideNewButton", true);
			component.set("v.objectDataMap.pv.OB_MCC_Description__c", "");
			component.set("v.objectDataMap.pv.NE__Zip_Code__c", "");
			component.set("v.objectDataMap.pv.OB_Ecommerce__c", false);
			
	        if(document.getElementById(errorId)!=null){
            	document.getElementById(errorId).remove();
       		 }



		}

		else{
			
			component.set("v.hideNewButton", true);

			var myDiv;

			myDiv = document.createElement('div');
			myDiv.setAttribute('id',errorId);//SET AN ID TO EVERY MESSAGE
			myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');

            //SET THE MESSAGE
            var message = $A.get("$Label.c.MandatoryField");
            var errorMessage = document.createTextNode(message);
            myDiv.appendChild(errorMessage);
            var idSet = component.get("v.idAnnualRevenure");
            var idAnnual = idSet.getElement();
            console.log("idSet = " + idSet);
            idAnnual.after(myDiv);

            idAnnual.className="slds-has-error flow_required";
		}
		

	},


	closeModel: function(component, event, helper) {
		//-----filter by street  and shopName------START// 
		if(component.find("searchInputNameId") != undefined || component.find("searchInputNameId") !=null || component.find("searchInputAddressId") != undefined || component.find("searchInputAddressId") !=null){
			
			component.find("searchInputNameId").set("v.value", ""); 
			component.find("searchInputAddressId").set("v.value", ""); 
			console.log("searchInputNameId after ----" + component.find("searchInputNameId").get("v.value"));
	
		}
	    //-----filter by street  and shopName------END//

		// for Hide/Close Model,set the "isOpen" attribute to "False"  
		component.set("v.isOpen", false);
		component.set("v.openModalMccCap", false);
		//set hideNewButton to true to desable button
 		component.set("v.hideNewButton", false);
 		component.set("v.showMessage", false);

 		component.set("v.objectDataMap.pv.NE__Zip_Code__c", '');
 		component.set("v.objectDataMap.pv.OB_Ecommerce__c", false);

	},

	openModal : function(component, event, helper) {
		//component.set("v.spinner", true); 
		helper.createComponent(component, event);
	},


	handleShowModalEvent : function(component, event, helper) {
		var objectDataMap = event.getParam("objectDataMap");
		console.log("handleShowModalEvent event.getParam: " + objectDataMap);
		component.set("v.objectDataMap", objectDataMap);
	},

	
	doSearch:function(component, event, helper) {
   
		var searchAddress = component.find("searchInputAddressId").get("v.value");

		var searchName    = component.find("searchInputNameId").get("v.value");

		var searchAddressUpperCase;
		var searchNameUpperCase;

		if(searchAddress !== undefined || searchAddress != "" || searchAddress != null){
		  searchAddressUpperCase = (searchAddress.trim()).toUpperCase();
		}else{
			searchAddressUpperCase=null;
		}
		
		if(searchName !== undefined || searchName !="" || searchName != null){
		 searchNameUpperCase = (searchName.trim()).toUpperCase();
		 }else{
		 	searchNameUpperCase= null;
		 }
		var responseServicePoint = component.get("v.responseServicePoint");

		console.log("searchAddressUpperCase =  " +searchAddressUpperCase + " searchNameUpperCase = "+searchNameUpperCase);

		console.log("doSearch responseServicePoint " + JSON.stringify(responseServicePoint));
		var filteredList = [];
		var arrToFilter = [];


	    arrToFilter = component.get("v.responseServicePoint");
	    
					
		/*Filtrer par Service point address et servicePointName */
		
		for( var i = 0 ;i<arrToFilter.length; i++){

			console.log( i  + " sono in doSearch method *_* (street) = " + JSON.stringify(arrToFilter[i].street));
			console.log('First If: ');
			//console.log(searchAddressUpperCase!=null && (arrToFilter[i].street !== undefined) && ((arrToFilter[i].street.trim()).toUpperCase()).indexOf(searchAddressUpperCase) != -1);
			console.log(searchAddressUpperCase);
			console.log(arrToFilter[i].street !== undefined);
			console.log(((arrToFilter[i].street.trim()).toUpperCase()).indexOf(searchAddressUpperCase) != -1);
			console.log('Second If: ');
			console.log(searchNameUpperCase);
			//console.log(searchNameUpperCase );
			console.log(arrToFilter[i].shopName !== undefined );
			console.log(((arrToFilter[i].shopName.trim()).toUpperCase()).indexOf(searchNameUpperCase) != -1);

		   if((searchAddressUpperCase && (arrToFilter[i].street !== undefined) && ((arrToFilter[i].street.trim()).toUpperCase()).indexOf(searchAddressUpperCase) != -1) ||
			  (searchNameUpperCase && (arrToFilter[i].shopName !== undefined) && ((arrToFilter[i].shopName.trim()).toUpperCase()).indexOf(searchNameUpperCase) != -1))
		   {
			 	filteredList.push(arrToFilter[i]);
	
		   }
			
		}  

		console.log("filteredList length is ------>> : " + filteredList.length);
		console.log("searchAddress = "+ searchAddress);
		console.log("searchName = "+ searchName);
		
		component.set("v.responseServicePointFilter",filteredList);
		//console.log("responseServicePointFilter is ------>> : " + JSON.stringify(component.get("v.responseServicePointFilter"));

		component.set("v.booleanFilter", true);
		component.set("v.booleanResponse", false);

		if(filteredList.length == 0){
			console.log("son nel if filter");
			console.log(component.get("v.showMessage"));
		 	component.set("v.showMessage", true);
		 	console.log("after = "+component.get("v.showMessage"));
			

		}
		else {

		 	component.set("v.showMessage", false);
		}


	},


	resetSearch: function(component, event , helper){
		component.set("v.booleanFilter", false);
		component.set("v.booleanResponse", true);
		component.set("v.showMessage", false);
		component.set("v.booleanDoSearch",true); 
		
		//-----filter by street  and shopName------START// 
		if(component.find("searchInputNameId") != undefined || component.find("searchInputNameId") !=null || component.find("searchInputAddressId") != undefined || component.find("searchInputAddressId") !=null){
			console.log("searchInputNameId ----" + component.find("searchInputNameId").getElement().value);
			component.find("searchInputNameId").set("v.value", ""); 
			component.find("searchInputAddressId").set("v.value", ""); 
			console.log("searchInputNameId after ----" + component.find("searchInputNameId").get("v.value"));
	
		}
	    //-----filter by street  and shopName------END//

		
	},



	//*****FUNCTION TO MANAGE SERVICE POINTS OBTAINED FROM SEVICE RESPONSE *****/
	callService : function(component, event , helper){


		//******giovanni spinelli start******//
		var appEvent = $A.get("e.c:OB_EventNextButton");	  
		//var stepName = component.find("errorMessageId").get("v.value");
		appEvent.setParams({"showPvErrorMessage" : false  });
		appEvent.setParams({"idStep" : "step_getMerchant" });
		appEvent.fire();
		//component.set( "v.showPvErrorMessage", false);
		console.log("the show error is: " + component.get("v.showPvErrorMessage"));
		//******giovanni spinelli stop******//

		console.log(event.target.id);


		var objectDataMap = component.get("v.objectDataMap");
		responseServicePoint = [];
		component.set("v.responseServicePoint",responseServicePoint);


		component.set("v.openModalMccCap", false);
		//boolean to open the Modal 
		component.set("v.isOpen",         true);
		component.set("v.booleanDoSearch",true); 
		component.set("v.booleanFilter", false);
		component.set("v.booleanResponse",true);
		console.log("booleanResponse ----->>>> " + component.get("v.booleanResponse"));

		var merchantCode         = component.get("v.objectDataMap.merchant.NE__Fiscal_code__c");
		console.log("RESPONSE fiscalCode ----->>>> " + merchantCode);

		var partitaIVA           = component.get("v.objectDataMap.merchant.NE__VAT__c");
		console.log("RESPONSE partitaIVA ----->>>> " + partitaIVA);
		
		var processor            = 'processor SUCCESS';
		
		var merchantCategoryCode = component.get("v.objectDataMap.pv.OB_MCC_Description__c");
		console.log("RESPONSE merchantCategoryCode ----->>>> " + merchantCategoryCode);

		var zipCode              = component.get("v.objectDataMap.pv.NE__Zip_Code__c");
		console.log("RESPONSE postalCode ----->>>> " + zipCode);

		
		
		var fiscalCode     = encodeURI(merchantCode);
		var processore     = encodeURI(processor);
		var MCCDescription = encodeURI(merchantCategoryCode);
		var cap            = encodeURI(zipCode);
		var vat 		   = encodeURI(partitaIVA);

		/************** lea.emalieu START 10/09/2018 *********************/
		var searchPVParam  = null;
		console.log('Merchant Search : fiscalCode encodeURI: ' + fiscalCode + ' vat encodeURI: ' + vat);
		if(fiscalCode){
			console.log('Fidcal code not null');
			searchPVParam = fiscalCode;
		}else if(vat){
			console.log('vat not null');
			searchPVParam = vat;
		}

		console.log('searchPVParam:' + searchPVParam );
        /************ lea.emalieu END 10/09/2018  **********************/
		 


		var request = $A.get("e.c:OB_ContinuationRequest");
		console.log('siamo nel completeProvincia, stampo la request: '+JSON.stringify(request));
		request.setParams({ 
			methodName: "retriveServicePoint",
			methodParams: [searchPVParam,processore,MCCDescription,cap],
			callback: function(result) {
				console.log('RISULTATO: '+ result);
				
				console.log('RISULTATO CONVERT : '+ result.convertChart());

				responseServicePoint = [];
		     	component.set("v.responseServicePoint",responseServicePoint);
		     	
				
				var resultJson = null,
				resultJson = result.convertChart();			   

				//****SET THE OBJECTDATAMAP WITH THE RETURN VALUE FROM SERVICE****//
	
				 var parseJSON = JSON.parse(resultJson);
				 console.log("parseJSON length---> "+ parseJSON.length);
				 
				 if(parseJSON.length == 0){
				 	component.set("v.showMessage", true);
				 }
				 

				for (var i = 0; i < parseJSON.length; i++) {
					 var counter = parseJSON[i];

					 console.log("counter ---> "+ i +" "+ JSON.stringify(counter));
					 var servicePointProvisorio = {} ;
					 servicePointProvisorio.shopName= counter.ServicePoint.shopName;
					 servicePointProvisorio.merchantCategoryCode = counter.ServicePoint.merchantCategoryCode;
					 var myObj =counter.ServicePoint.Address;
					
					 for (var x in myObj) {
					  	servicePointProvisorio[x] = myObj[x];
					 }
					
					 console.log('servicePointProvisorio ' + JSON.stringify(servicePointProvisorio));
					 responseServicePoint.push(servicePointProvisorio);


				}

				component.set("v.responseServicePoint",responseServicePoint);
				console.log("responseServicePoint " + JSON.stringify(responseServicePoint));
				 

				
				component.set('v.columns', [
										   {label: $A.get("$Label.c.Name"),fieldName: 'shopName', type: 'text'},
										   {label: $A.get("$Label.c.Street"),fieldName: 'street', type: 'text'},
										   {label: $A.get("$Label.c.Street_Number"),fieldName: 'civicNumber', type: 'text'},
										   {label: $A.get("$Label.c.City"),fieldName: 'city',   type: 'text'},
										   {label: $A.get("$Label.c.OB_MCC_Description"),fieldName: 'merchantCategoryCode' , type: 'text'},
										   //{label: $A.get("$Label.c.Service_Point_Name"),fieldName: 'OB_Service_Point_Name__c', type: 'text'},
										   {label: $A.get("$Label.c.PostalCode"),fieldName: 'postalCode', type: 'text'}
									   ]);
				
				}
			  
 
		});
		
		request.fire();
		
	},

  
	
	searchClick : function(component, event, helper) {

		 //******giovanni spinelli start******//

		var appEvent = $A.get("e.c:OB_EventNextButton");
		  
		 //var stepName = component.find("errorMessageId").get("v.value");
		appEvent.setParams({"showPvErrorMessage" : false  });
		appEvent.setParams({"idStep" : "step_getMerchant" });
		appEvent.fire();
		//component.set( "v.showPvErrorMessage", false);
		console.log("the show error is: " + component.get("v.showPvErrorMessage"));
		//******giovanni spinelli stop******//


		component.set("v.hideNewButton", false);
			
		//boolean to open the Modal 
		component.set("v.isOpen", true);
		//boolean to close the ModalMccCap 
		component.set("v.openModalMccCap", false); 
		
		
		component.set("v.booleanDoSearch",true); 
		
	   	var objectDataMap = component.get("v.objectDataMap");
		var objectDataMapClone = component.get("v.objectDataMapClone");
		var fiscalCode = component.get("v.objectDataMap.merchant.NE__Fiscal_code__c");
		console.log("RESPONSE fiscalCode ----->>>>" + fiscalCode);
		
		var merchantId = component.get("v.objectDataMap.merchant.Id");
		console.log("RESPONSE  merchantId ------>>>>>> " + merchantId);
		
		var action = component.get("c.listServicePoint");
		
		action.setParams({fiscalCode : fiscalCode, 
						  merchantId : merchantId});
		
		action.setCallback(this, function(response) 
						   {
							   var state = response.getState();
							   console.log("the state is  "+ state);
							   if (state === "SUCCESS") {
								   console.log("RESPONSE " + JSON.stringify(response.getReturnValue()));

								   component.set("v.servicePointData", response.getReturnValue());   
								   console.log("RESPONSE servicePointData ******" + JSON.stringify(component.get("v.servicePointData")));
								   
								   component.set('v.columns', [
									   
									   {label: $A.get("$Label.c.Street"),fieldName: 'NE__Street__c', type: 'text'},
									   {label: $A.get("$Label.c.Name"),fieldName: 'Name', type: 'text'},
									   {label: $A.get("$Label.c.City"),fieldName: 'NE__City__c',   type: 'text'},
									   {label: $A.get("$Label.c.OB_MCC_Description"),fieldName: 'OB_MCC_Description__c', type: 'text'},
									   {label: $A.get("$Label.c.Service_Point_Name"),fieldName: 'OB_Service_Point_Name__c', type: 'text'},
									   {label: $A.get("$Label.c.PostalCode"),fieldName: 'NE__Postal_Code__c', type: 'text'}
								   ]);
								   
							   }
							   
								   else if (state === "ERROR") 
								   {
									   
									   var errors = response.getError();
									   if (errors) {
										   if (errors[0] && errors[0].message) 
										   {
											   console.log("Error message: " + 
														   errors[0].message);
										   }
									   } else 
									   {
										   console.log("Unknown error");
									   }
								   }
						   });
		$A.enqueueAction(action);
		
		
	},
	
	
	
	/*Function to select a service point */
	
	getSelectedServicePoints:function(component, event, helper) {  
		
		var selectedRows = event.getParam('selectedRows');
		var objectDataMap = component.get("v.objectDataMap");
		var objectDataMapClone = component.get("v.objectDataMapClone");
		console.log("SONO objectDataMap "+ JSON.stringify(objectDataMap));
		
		var selectServicePointArray = [];
		for (var i = 0; i < selectedRows.length; i++){
			// component.set("v.selectServicePoint", selectedRows[i]);
			selectServicePointArray.push(selectedRows[i]);
		}
		// var selectServicePoint = component.get("v.selectServicePoint");
		var selectServicePoint = selectServicePointArray;
		console.log('selectServicePoint: ' + JSON.stringify(selectServicePoint));

			
		if(selectedRows.length===1){
			//close modal  after select a service point
			component.set("v.isOpen", false);
			component.set("v.hideNewButton", false);
			component.set("v.objectDataMap.pv.OB_Ecommerce__c", false);

			console.log("la selectedRows del servicePoint è: " + JSON.stringify(selectedRows));
			var selectedPv = selectedRows[selectedRows.length-1];
			/*lea.emalieu 20/09/2018 START *******************************************/
			//Method to take the description of mcc code 
			var actionmccDescription = component.get("c.getMccDescription");
			actionmccDescription.setParams({ mccCode: selectedPv.merchantCategoryCode});
			actionmccDescription.setCallback(this, function(response) {
				            var state = response.getState();
				            if (state === "SUCCESS") {
				            	
				                component.set("v.objectDataMap.pv.OB_MCC_Description__c", response.getReturnValue());
 
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

            $A.enqueueAction(actionmccDescription);
            /*lea.emalieu 20/09/2018 END *******************************************/
    	
					
			//****SET THE OBJDATAMAP WITH THE VALUE FROM A SELECTED SERVICE POINT****//
			objectDataMap.pv.NE__Account__c          = selectedPv.NE__Account__c;

			objectDataMap.pv.Name                    = selectedPv.shopName;
			objectDataMap.pv.OB_Service_Point_Name__c= component.get("v.objectDataMap.pv.OB_Service_Point_Name__c");
			//objectDataMap.pv.NE__Street__c           = selectedPv.NE__Street__c;
			objectDataMap.pv.NE__Street__c           = selectedPv.street;
			//objectDataMap.pv.OB_Street_Number__c     = selectedPv.OB_Street_Number__c;
			objectDataMap.pv.OB_Street_Number__c     = selectedPv.civicNumber;
			console.log("numero civico: " + selectedPv.civicNumber); 
			//objectDataMap.pv.NE__Postal_Code__c      = selectedPv.NE__Postal_Code__c;
			objectDataMap.pv.NE__Postal_Code__c      = selectedPv.postalCode;
			console.log("v.objectDataMap.pv.NE__Postal_Code__c = " + selectedPv.postalCode);
			//objectDataMap.pv.NE__City__c             = selectedPv.NE__City__c;
			objectDataMap.pv.NE__City__c             = selectedPv.city;
			console.log("objectDataMap.pv.NE__City__c = " + selectedPv.city);
			//objectDataMap.pv.NE__Country__c          = selectedPv.NE__Country__c;
			objectDataMap.pv.NE__Country__c          = selectedPv.country;
			console.log("objectDataMap.pv.NE__Country__c = " + selectedPv.country);
			//objectDataMap.pv.NE__Province__c         = selectedPv.NE__Province__c;
			objectDataMap.pv.NE__Province__c         = selectedPv.province
			console.log("objectDataMap.pv.NE__Province__c = " + selectedPv.province);
			objectDataMap.pv.OB_District__c          = selectedPv.district;
			console.log("objectDataMap.pv.OB_District__c = " + selectedPv.district);
			objectDataMap.pv.OB_Email__c             = selectedPv.OB_Email__c;
			objectDataMap.pv.OB_MCC__c               = selectedPv.merchantCategoryCode;
			console.log("objectDataMap.pv.OB_MCC__c = " + selectedPv.merchantCategoryCode);
			//objectDataMap.pv.OB_MCC_Description__c   = selectedPv.OB_MCC_Description__c;
			objectDataMap.pv.OB_MCC_Description__c   = component.get("v.objectDataMap.pv.OB_MCC_Description__c");
		
			objectDataMap.pv.OB_Annual_Revenue__c    = selectedPv.OB_Annual_Revenue__c;
			objectDataMap.pv.OB_Annual_Negotiated__c = selectedPv.OB_Annual_Negotiated__c;
			objectDataMap.pv.Id                      = "";
			console.log("OBJDATA MAP PV: " + JSON.stringify(objectDataMap.pv.OB_Annual_Revenue__c));
		}
		//****24/09/2018-GIOVANNI SPINELLI****//
		console.log("name id of namePv is: " + document.getElementById('errorIdnamePv'));
		if(document.getElementById('errorIdnamePv'))
		{
			document.getElementById('errorIdnamePv').remove();
		}
		//****24/09/2018-GIOVANNI SPINELLI****//

		console.log(' The provincia error Id is '+ document.getElementById('errorIdprovincia'));
		// var elem = 	document.getElementById('errorIdprovincia');	
		// if(elem){	//document.getElementById('errorIdprovincia').remove();
		// 	elem.parentNode.removeChild(elem);
		// }

						
		
		var componentParm = component.get("v.postelcomponentparams");		
		componentParm.provincedisabled  = 'true';
		componentParm.countrydisabled   = 'true';

		component.set("v.postelcomponentparams",componentParm);

        console.log( "componentParm **** " + JSON.stringify(componentParm));  

		

			 //make the sp input readonly
		var disabledInputSp = component.get("v.disabledInput_sp");
		disabledInputSp = true;
		component.set("v.disabledInput_sp" , disabledInputSp);
			
		component.set("v.objectDataMap" , objectDataMap ); 
		component.set("v.objectDataMapClone" , objectDataMap ); 
		
		component.set("v.selectServicePoint", selectServicePointArray);

		console.log("selectServicePointArray: " + selectServicePointArray);

		/*********Tajana Alessandro START 17/09/2018 ***********/
		var autoCompleteCmp= component.find("AutoCompleteComponentPostel");
		if(autoCompleteCmp){
			autoCompleteCmp.reInitAll(); 
		}
		/*********Tajana Alessandro END 17/09/2018 ***********/

					  
	},

	
	
	//*****FUNCTION TO CREATE A NEW SERVICE POINT*****/
	
	newServicePoint :function(component, event, helper) { 

		var objectDataMap = component.get("v.objectDataMap");		
		component.set("v.showEmptyInput",true);				
		//make the sp input writable
		var disabledInputSp = component.get("v.disabledInput_sp");
		disabledInputSp = false;
		component.set("v.disabledInput_sp" , disabledInputSp);
		//reset the objectDataMap to insert a new service point
		component.set("v.objectDataMap.pv",{});
		component.set("v.selectedRows", []);
		console.log(' The select row is '+ JSON.stringify(component.get("v.selectedRows")));

		//******** Tajana ALESSANDRO ******* 13/09/2018 *****START**//
		var autoCaps= component.find("AutoCompleteComponentPostel");
		var caps= [];
		autoCaps.blankMethod(caps); 
		//*********Tajana Alessandro END 17/09/2018 ***********/

		//*****delete the value into postel component*****//
		component.set("v.postelcomponentparams.provincedisabled","false");
		component.set("v.postelcomponentparams.countrydisabled ","false");

		if(document.getElementById('namePv')){
		 $A.util.removeClass(document.getElementById('namePv') , 'slds-has-error flow_required');
		}

		if( document.getElementById('mccDescription') && objectDataMap.pv.OB_MCC_Description__c == '' && objectDataMap.pv.OB_MCC_Description__c == undefined && objectDataMap.pv.OB_MCC_Description__c == null ) {          
            //REMOVE RED BORDER
            $A.util.removeClass(document.getElementById('mccDescription') , 'slds-has-error flow_required');                  
        } 
					
		if(document.getElementById('provincia') != null){
			document.getElementById('provincia').value="";
			console.log(' The provincia is '+ document.getElementById('provincia'));
			//document.getElementById('provincia').removeAttribute("disabled");
		} 

		if(document.getElementById('comune') != null){
		    document.getElementById('comune').value   ="";
		}

		if(document.getElementById('strada') != null){
		    document.getElementById('strada').value   ="";
		}

		if(document.getElementById('civico') != null){
		    document.getElementById('civico').value   ="";
		    console.log("***************************************");
		    console.log("civico = " +document.getElementById('civico').value );	
		}
		 
		if(document.getElementById('frazione') != null){
		 	document.getElementById('frazione').value ="";
		 	console.log("frazione = " +document.getElementById('frazione').value );
		}
		 
		if(document.getElementById('presso') != null){
		  	document.getElementById('presso').value   ="";
		  	console.log("presso = " +document.getElementById('presso').value );
		  	 console.log("***************************************");
		}
		 
		if(document.getElementById('country') != null){
		 	document.getElementById('country').value = "ITALIA";
		}
		//***********************************************//
		objectDataMap.pv.Id  = "";
		component.set("v.objectDataMap.pv.NE__Country__c","ITALIA");
		
		//******** Tajana ALESSANDRO ******* 17/09/2018 *****START**//
		autoCaps.reInitAll(); 
		//******** Tajana ALESSANDRO ******* 17/09/2018 *****END**//


		


	},
	

	//GIOVANNI SPINELLI-20/09/2018
	//onchange="{!c.CompleteAddress}" --->delete because useless
	
	/*CompleteAddress: function(component, event, helper) {
		
		var objectDataMap= component.get("v.objectDataMap");
		var name    = component.find("namePv").get("v.value");
		console.log("nome insegna " + name);

		component.set("v.objectDataMap.pv.Name",name);

		component.set("v.objectDataMap",objectDataMap);
		
		
	},*/


	setPickListValue_SP: function(component, event, helper) {
	    var objectDataMap = component.get("v.objectDataMap");
	    objectDataMap.pv.OB_Annual_Revenue__c    = component.find("annualRevenue_SP").get("v.value"); 
	    objectDataMap.pv.OB_Annual_Negotiated__c = component.find("annualNegotiated_SP").get("v.value"); 
	    console.log("set annual revenue sp into objdatamap: " + objectDataMap.pv.OB_Annual_Revenue__c);
	    console.log("set annual negotiated sp into objdatamap: " + objectDataMap.pv.OB_Annual_Negotiated__c);
	    component.set("v.objectDataMap" , objectDataMap );
	},


	removeRedBorder:function(component, event, helper) {
		helper.removeRedBorder(component, event , helper);

		//******** METHOD FOR FORMAL CONTROL OF SERVICE POINT NAME *** START ******//
        var name = component.find('namePv').get("v.value");
        //CREATE A DIV WITH A CUSTOM ERROR MESSAGE
        var myDiv;
        myDiv = document.createElement('div');
        var errorMessage = document.createTextNode($A.get("$Label.c.errorSpecialCharacter")); 
        console.log("error message: " + JSON.stringify(errorMessage));
        myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
        myDiv.setAttribute('id','customErrorIdnamePv');
        myDiv.appendChild(errorMessage);
        var idTest;
        //IF THERE IS THE INPUT
       if(component.find('namePv'))
       {
           idTest  = component.find('namePv').getElement();
       }
        //WRONG CHARACTER
        if(specialCharacter(name)=='ERROR' && name.length>0  )
        {
            $A.util.addClass(component.find('namePv') , 'slds-has-error flow_required');
            //ADD THE ERROR MESSAGE
            if(!document.getElementById('customErrorIdnamePv')){
                 idTest.after(myDiv);
            }
            //BOOLEANT TO REST IN PAGE
            component.set("v.objectDataMap.errorFamily.errorNamePv", true);
        }
        //RIGHT CHARACTER
        else if(specialCharacter(name)==null || name.length==0)
        {
           
             if(document.getElementById('customErrorIdnamePv')){
                document.getElementById('customErrorIdnamePv').remove();
             }
            component.set("v.objectDataMap.errorFamily.errorNamePv", false);
             
        }
        //******* METHOD FOR FORMAL CONTROL OF NAME SERVICE POINT NAME **** END *****//

	 },

    setTypologyPickListValue_SP: function(component, event, helper) {
	    var objectDataMap = component.get("v.objectDataMap");
	    objectDataMap.pv.OB_Typology__c  = component.find("typologySP").get("v.value");  
	    console.log("@@@@ Service Point Typology is: " + objectDataMap.pv.OB_Typology__c);
	    component.set("v.objectDataMap" , objectDataMap );
	 },


	 redBorderChild:function(component, event, helper) {

	 	var redBorderChild = component.get("v.redBorderChild");
	 	//var myDiv;
	 	var tipologia = component.get("v.objectDataMap.pv.OB_MCC_Description__c");
	 	console.log("tipologia = "+ tipologia);


	 	console.log("Sono nel red BORDER! " + redBorderChild);
	 	//GIOVANNI SPINELLI--28/09/2018--GET THE VALUE ONLY IF THE COMPONENT IS ON THE DISPLAY 
	 	var tipologiaId;
	 	if(component.find("typologySP"))
	 	{
	 		 tipologiaId = component.find("typologySP").get("v.value");
	 	}
	 	
	 	var errorId = component.find("typologySP");
	 	console.log('tipologiaId ==  ' + tipologiaId);
	 	
	 	if(redBorderChild ==true){

		 	if (tipologiaId == ''){	

				var myDiv;
				myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorId);//SET AN ID TO EVERY MESSAGE
				myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
				//errorId.classList.add('messageErrornamePv');
	            //SET THE MESSAGE
	            var message = $A.get("$Label.c.MandatoryField");
	            var errorMessage = document.createTextNode(message);
	            myDiv.appendChild(errorMessage);
	            $A.util.addClass(errorId , 'slds-has-error flow_required');
	        }
				
		} 	
	 }

})