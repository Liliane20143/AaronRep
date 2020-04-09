({
	doInit : function(component, event, helper) {
		
		/* MODALE MCC & CAP */
		var objectDataMap = component.get("v.objectDataMap");
		console.log('object do init service point: ' + JSON.stringify(objectDataMap) );
		var level = component.get('v.value');
		var valueMCC = component.get('v.valueMCC');
		console.log('level do init sp: ' + level);
		console.log('valueMCC do init sp: ' + valueMCC);
		
		
		
		/* SET ATTRIBUTE TO PREVIOUS BUTTON */

		//	START 	micol.ferrari 13/11/2018
		// console.log("annualNegotiatedList_ServicePoint : " + JSON.stringify(component.get('v.annualNegotiatedList_ServicePoint')));
		component.set("v.valuePreviousTypology",objectDataMap.pv.OB_Typology__c);
		// component.set("v.valuePreviousSPAnnRev",(objectDataMap.pv.OB_Annual_Revenue__c).replace(/_/g, ' '));
		// component.set("v.valuePreviousSPAnnNeg",(objectDataMap.pv.OB_Annual_Negotiated__c).replace(/_/g, ' '));

		// var annualRevenueMerchant = component.get("v.objectDataMap.merchant.OB_Annual_Revenue__c");
		//	END 	micol.ferrari 13/11/2018
		/** 
		 ANDREA MORITTU :
		 1- SETTING COMMUNITY USER, IF TRUE PICKLIST'S VALUE IS ONKY 'ITALIA'
		 ELSE IT'S ITALIA & SAN MARINO
		 */
		var isComUser = component.get("v.objectDataMap.isCommunityUser");
		console.log('isComUser'+isComUser);
		if(isComUser == true){
			var countries = ["ITALIA"];
			component.set("v.countries", countries);
		} else {
			var countries = [ "ITALIA", "SAN MARINO" ]; 
			component.set("v.countries", countries);
		}
		component.set("v.countries", countries);
		console.log('@@@ my countries are:' + countries);
		
		// var search = document.getElementsByClassName('slds-form-element__label slds-no-flex');
		// console.log('@@@@@@@@@ search is: ' + JSON.stringify(search));

		/*
		 * START micol.ferrari 23/08/2018 - PARAM TO PASS TO POSTEL COMPONENT
		 * (--> ADDRESSMAPPING)
		 */
		var postelcomponentparams = {};
		postelcomponentparams.sectionaddress          = 'generaladdress';
		
		postelcomponentparams.provincedisabled        = 'false';
		postelcomponentparams.provinceinputobject     = 'pv';
		postelcomponentparams.provinceinputfield      = 'NE__Province__c';
		
		postelcomponentparams.citydisabled            = 'true';
		postelcomponentparams.cityinputobject         = 'pv';
		postelcomponentparams.cityinputfield          = 'NE__City__c';
		
		postelcomponentparams.districtdisabled        = 'true';
		postelcomponentparams.districtinputobject     = 'pv';
		postelcomponentparams.districtinputfield      = 'OB_District__c';
		
		postelcomponentparams.streetdisabled          = 'true';
		postelcomponentparams.streetinputobject       = 'pv';
		postelcomponentparams.streetinputfield        = 'NE__Street__c';
		
		postelcomponentparams.streetnumberdisabled    = 'false'; //gianluigi.virga 10/09/2019 - UX-55
		postelcomponentparams.streetnumberinputobject = 'pv';
		postelcomponentparams.streetnumberinputfield  = 'OB_Street_Number__c';
		
		postelcomponentparams.zipcodedisabled         = 'false';
		postelcomponentparams.zipcodeinputobject      = 'pv';
		// postelcomponentparams.zipcodeinputfield       = 'NE__Postal_Code__c';
		postelcomponentparams.zipcodeinputfield       = 'NE__Zip_Code__c';

		postelcomponentparams.countrydisabled         = 'false';
		postelcomponentparams.countryinputobject      = 'pv';
		postelcomponentparams.countryinputfield       = 'NE__Country__c';
		
		postelcomponentparams.countrycodeinputobject  = 'pv';
		postelcomponentparams.countrycodeinputfield   = 'NE__Country_Code__c';

		postelcomponentparams.provincecodeinputobject = 'pv';
		postelcomponentparams.provincecodeinputfield  = 'OB_Province_Code__c';
		postelcomponentparams.isComplete              = 'true';

		postelcomponentparams.withCountry             = 'true';
		postelcomponentparams.withDetail              = 'true';
		postelcomponentparams.pressoinputfield        = 'OB_Address_Detail__c';
		postelcomponentparams.pressoinputobject       = 'pv';
		postelcomponentparams.isPV                    = 'true';

		component.set("v.postelcomponentparams", postelcomponentparams);
		console.log('postelcomponentparams service point');
		console.log(JSON.stringify(postelcomponentparams));
		//alert('do init service point: ' + component.get('v.isLoading2'));
		/* END micol.ferrari 23/08/2018 - PARAM TO PASS TO POSTEL COMPONENT */

		//	START 	micol.ferrari 13/11/2018
		//console.log("the boolean is" + component.get("v.showOtherInput"));
		// var annNegMerch = component.get('v.objectDataMap.merchant.OB_Annual_Negotiated__c');
		// var annRevMerch = component.get('v.objectDataMap.merchant.OB_Annual_Revenue__c');
		//	END 	micol.ferrari 13/11/2018

		//	START 	micol.ferrari 13/11/2018
		// **********METHOD TO RETRIEVE THE ANNUAL REVENUE VALUE IN SERVICE
		// POINT**********//
		// var actionGetAnnualNegotiationValues = component.get("c.getAnnualRevenueValues_SP");
		
		// actionGetAnnualNegotiationValues.setCallback(this, function(response) {
		// 	var state = response.getState();
		// 	if (state === "SUCCESS") {
		// 		var tempMap = [];
		// 		var responseMap = response.getReturnValue();

		// 		for ( var key in responseMap) {
		// 			tempMap.push({
		// 				value : responseMap[key],
		// 				key : key
		// 			});
		// 		}
		// 		component.set("v.annualRevenueList_ServicePoint", tempMap);
		// 		console.log("list annualRevenue : "+ JSON.stringify(component.get("v.annualRevenueList_ServicePoint")));
		

		// 	} else if (state === "INCOMPLETE") {
		// 		// do something
		// 	} else if (state === "ERROR") {
		// 		var errors = response.getError();
		// 		if (errors) {
		// 			if (errors[0] && errors[0].message) {
		// 				console.log("Error message: " + errors[0].message);
		// 			}
		// 		} else {
		// 			console.log("Unknown error");
		// 		}
		// 	}
		// });
		// $A.enqueueAction(actionGetAnnualNegotiationValues);

		
		// **********METHOD TO RETRIEVE THE ANNUAL NEGOTIATIED VALUE IN SERVICE
		// POINT**********//
		// var actionGetAnnualNegotiationValues = component.get("c.getAnnualNegotiationValues_SP");
		
		// actionGetAnnualNegotiationValues.setCallback(this, function(response) {
		// 	var state = response.getState();
		// 	if (state === "SUCCESS") {
		// 		var tempMap = [];

		// 		var responseMap = response.getReturnValue();
		// 		for ( var key in responseMap) {
		// 			tempMap.push({
		// 				value : responseMap[key],
		// 				key : key
		// 			});
		// 		}
		// 		component.set("v.annualNegotiatedList_ServicePoint", tempMap);

		// 	} else if (state === "INCOMPLETE") {
		// 		// do something
		// 	} else if (state === "ERROR") {
		// 		var errors = response.getError();
		// 		if (errors) {
		// 			if (errors[0] && errors[0].message) {
		// 				console.log("Error message: " + errors[0].message);
		// 			}
		// 		} else {
		// 			console.log("Unknown error");
		// 		}
		// 	}
		// });
		// $A.enqueueAction(actionGetAnnualNegotiationValues);
		//	END 	micol.ferrari 13/11/2018
		/*
		 * Andrea Morittu RETRIEVING VALUES FROM
		 * NE__SERVICE_POINT__c.OB_Typology__c 27/09/2018 *** START **
		 */
		
		/* */
		var actionGetTypologyValues = component.get("c.getServicePointTypologyValues_SP");
		helper.getTypologyValuesHelper(component, actionGetTypologyValues)
			.then(function(tempMap) {
				/* ANDREA MORITTU 2019.05.09 - Fix old SP type F2WVE2_68*/
				try{
					var temporaryMap = [];
					temporaryMap = tempMap; 
        		    var isNewMerchant= objectDataMap.isNewMerchant;
        		    if(isNewMerchant) {
        		        var oldWrapperInformation = component.get('v.oldWrapperInformation');
        		        if(!$A.util.isUndefinedOrNull(oldWrapperInformation) && !$A.util.isEmpty(oldWrapperInformation.formalCheckOnServicePointType)) {
        		            component.set('v.oldServicePointTypologyExist', true);
							component.find('typologySP').set('v.disabled', true);
							component.set('v.objectDataMap.pv.OB_Typology__c', oldWrapperInformation.formalCheckOnServicePointType );
							if(oldWrapperInformation.formalCheckOnServicePointType == 'Fisico') {
								
								temporaryMap = [{'value' : 'POS ' + oldWrapperInformation.formalCheckOnServicePointType, 
												'key'	 : oldWrapperInformation.formalCheckOnServicePointType
												}];
							} else if(oldWrapperInformation.formalCheckOnServicePointType == 'Virtuale') {
								temporaryMap = [{'value' : 'POS ' + oldWrapperInformation.formalCheckOnServicePointType,
												'key'	 : oldWrapperInformation.formalCheckOnServicePointType
												}];
							}
							

							//component.set("v.typologyList", temporaryMap);
        		        } else {
							component.set("v.typologyList", tempMap);
						}	
        		    }
        		} catch(e) {
        		    console.log('An error has occured : ' + e.message);
        		}
		/* ANDREA MORITTU 2019.05.09 - Fix old SP type F2WVE2_68*/

				component.set("v.typologyList", tempMap);
        	}	
        	).catch(
            function(error) {
                console.log('An error has occured: ' + error);
            }
		);
		
		/*
		 * Andrea Morittu RETRIEVING VALUES FROM
		 * NE__SERVICE_POINT__c.OB_Typology__c 27/09/2018 *** END **
		 */

		var objectString = 'pv'; // target object

		var mappa = {
			"Name" : $A.get("$Label.c.OB_MCC_Description"),
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
		console.log("mapOfSourceFieldTargetField "+ JSON.stringify(mapOfSourceFieldTargetField));
		var type = component.get("v.type");
		type = 'MCC';
		component.set("v.type", type);
		component.set("v.objectString", objectString);
		component.set("v.orderBy", "Name");

		component.set('v.isLoading2', true);
	},

	onClickToSearch : function(component, event, helper) {

		var searchAddress = component.find("searchInputAddressId").get("v.value");
		var searchName = component.find("searchInputNameId").get("v.value");

		if ((searchAddress !== undefined || searchAddress != "" || searchAddress != null)
				&& (searchName !== undefined || searchName != "" || searchName != null)) {

			component.set("v.booleanDoSearch", false);
		} else {
			component.set("v.booleanDoSearch", true);

		}

	},

	enableRetrieveServicePoint : function(component, event, helper) {

		//helper.enableRetrieveServicePointHelper(component, event);
		//GIOVANNI SPINELLI - 30/10/2019

		var objectDataMap 	= component.get("v.objectDataMap");
		var zipcode     	= objectDataMap.pv.NE__Zip_Code__c;
		var zipCodeSearch ;
		if(component.find('zipcode')){
			 zipCodeSearch = component.find('zipcode').get('v.value');
			 if(zipCodeSearch.length>0 && zipCodeSearch.length < 5){
			 	//alert();
			 	component.set('v.searchButtonSpFromSfdc' , true);
			 }else if(zipCodeSearch.length==5 &&  onlyNumber(zipCodeSearch) !='ERROR'){
			 	component.set('v.searchButtonSpFromSfdc' , false);
			 }else if(zipCodeSearch.length==5 &&  onlyNumber(zipCodeSearch) =='ERROR'){
			 	component.set('v.searchButtonSpFromSfdc' , true);
			 }else{
			 	component.set('v.searchButtonSpFromSfdc' , false);
			 }
		}

		
		console.log('zipcode in enableRetrieveServicePoint: ' + zipCodeSearch);
		
		// if (zipcode && zipcode.length==5 && onlyNumber(zipcode) !='ERROR' )
		// {
		// 	//  MAKE VISIBLE THE BUTTON
		//  	component.set("v.hideNewButton", false);
		// }
		// else if(zipcode && zipcode.length<5){
			
		// } 
	 //    else 
	 //    {
		//  	 //  ZIP CODE EMPTY
		//  	 //  MAKE HIDDEN THE BUTTON
		//  	 component.set("v.hideNewButton", true);
		// }
		// var objDMzipCode = component.get("v.objectDataMap.pv.NE__Zip_Code__c");
		// console.log("objDMzipCode = " + objDMzipCode);
		var zipcode = component.find("zipcode");
		if(zipcode)
			var zipCodeValue = zipcode.get("v.value");
		if(component.find("ecommerce"))
			var ecomm = component.find("ecommerce").get("v.checked");
		var ecommerce = document.getElementById('ecommerce');
		var country = component.find('countrySelection');

		console.log("@@@country is defined? : " + country);
		//document.getElementById('zipcode').disabled = false;
		//document.getElementById('ecommerce').disabled = false;
		//var zipCdMaxLength = document.getElementById('zipcode').maxLength = 5;
		// if (component.find("zipcode")){
		// 	if (zipCodeValue.length >=5 && onlyNumber(zipCodeValue) == 'ERROR') 
		// 	{
		// 		$A.util.addClass(zipcode, 'slds-has-error flow_required');
		// 		component.set("v.errorCap", true);
		// 		component.set("v.hideNewButton", true);
		// 		component.set("v.zipCodeErrorMessage",$A.get("$Label.c.OB_InvalidPostalCodeLabel") );
		// 	}
		// 	else
		// 	{
		// 		$A.util.removeClass(zipcode, 'slds-has-error flow_required');
		// 		component.set("v.errorCap", false);
		// 		if (zipCodeValue.length >=5 && onlyNumber(zipCodeValue) != 'ERROR')
		// 				component.set("v.hideNewButton", false);
		// 	}
		// }
		//SHOW SEARCH BUTTON IF WRITE IN ONE OF THESE FIELDS
		// if(component.find('insegnaSearch')){
		// 	var insegna = component.find('insegnaSearch').get("v.value");
		// 	if(insegna.length > 0)
		// 		component.set("v.hideNewButton", false);
		// }
		// if(component.find('citySearch')){
		// 	var city = component.find('citySearch').get("v.value");
		// 	if(city.length > 0)
		// 		component.set("v.hideNewButton", false);
		   
		// }
		// if(component.find('streetSearch')){
		// 	var street = component.find('streetSearch').get("v.value");
		// 	console.log("street: "+ street);
		// 	if(street.length > 0)
		// 		component.set("v.hideNewButton", false);
		// }
			
		

		// var objectDataMap = component.get("v.objectDataMap");
		// if (objectDataMap.pv.OB_MCC_Description__c != '') {
		// 	// REMOVE RED BORDER
		// 	$A.util.removeClass(document.getElementById('mccDescription'),
		// 			'slds-has-error flow_required');
			
		// 	// IF THERE IS THE ERROR MESSAGE
		// 	if (document.getElementById('errorIdmccDescription')) {
		// 		var errorMessage = document.getElementsByClassName('messageErrormccDescription').length;
				
		// 		// TRY TO DELETE THE MESSAGE
		// 		try {
		// 			for (var i = 0; i < errorMessage; i++) {
		// 				document.getElementById('errorIdmccDescription').remove();
		// 			}

		// 			console.log("success delete");
		// 		} catch (err) {
		// 			console.log('err.message: ' + err.message);
		// 		}
		// 	}
		// }

	},

	openModalMccCap : function(component, event, helper) {
		 component.set("v.openModalMccCap", true);
		 component.set("v.errorCap",     false);
		 
		 component.set("v.hideInputCap", false);
		 component.set("v.hasMessage"   , false);
		 component.set("v.objectDataMap.shopSign","");
		 component.set('v.valueShopSignWithModal' , '');
		 component.set('v.valueShopSignNoModal' , '');
		 component.set('v.showMessageShopSign' , false);
		 var inputButton = event.getSource();
		 console.log('inputButton: ' + inputButton);
		 var searchButtonSp = inputButton.getElement();
		   searchButtonSp.setAttribute('style', '');	
		 //SET TO NULL THE ZIPCODE IN FILTER
		 component.set('v.zipcodeValueSearch' , '');
		 //HIDE MESSAGE 'NO SERVICE POINT' OF PREVIOS RESEARCH
		 component.set('v.showMessage' , false);
		 
		// component.set("v.errorCap",     false);
		// component.set("v.hideNewButton", true);
		// component.set("v.hideInputCap", false);
		// // GIOVANNI SPINELLI-29/09/2018-->HIDE THE BANNER MESSAGE-START
		// component.set("v.hasMessage", false);
		// // GIOVANNI SPINELLI-29/09/2018-->HIDE THE BANNER MESSAGE-END

		// if (component.find("searchButton")) {
		// 	try {
		// 		var searchButtonSp = component.find("searchButton").getElement();
		// 		searchButtonSp.setAttribute('style', '');

		// 	} catch (err) {
		// 		console.log('err.message button : ' + err.message);
		// 	}
		// }

		// var annualRevenue        = component.get("v.objectDataMap.merchant.OB_Annual_Revenue__c");
		// var merchantCategoryCode = component.get("v.objectDataMap.pv.OB_MCC_Description__c");
		// var tipologia            = component.get("v.objectDataMap.pv.OB_Typology__c");
		// var zipCode              = component.get("v.objectDataMap.pv.NE__Zip_Code__c");
		// var errorId              = 'errorIdannualRevenue';
		// component.set("v.objectDataMap.pv.NE__Zip_Code__c", "");

		// console.log("zipCode : " + zipCode);
		// console.log("annualRevenue : " + annualRevenue);
		// if (annualRevenue == "da_0_a_350K" || annualRevenue == "da_350_a_600K"
		// 		|| annualRevenue == "da_600_a_960K"
		// 		|| annualRevenue == "da_960K_a_2Mio")

		// {
		// 	component.set("v.showStarRequired", false);
		// }

		// if (annualRevenue == "da_2Mio_a_3Mio" || annualRevenue == "oltre_3Mio") {
		// 	component.set("v.showStarRequired", true);
		// }

		// if (annualRevenue != '') {
		// 	console.log("ANNUAL revenue value ---> "+ component.get("v.objectDataMap.merchant.OB_Annual_Revenue__c"));
		// 	component.set("v.openModalMccCap", true);
		// 	component.set("v.hideNewButton", true);
		// 	component.set("v.objectDataMap.pv.OB_MCC_Description__c", "");
		// 	component.set("v.objectDataMap.pv.NE__Zip_Code__c", "");
		// 	component.set("v.objectDataMap.pv.OB_Ecommerce__c", false);

		// 	if (document.getElementById(errorId) != null) {
		// 		document.getElementById(errorId).remove();
		// 	}

		// } else {

		// 	component.set("v.hideNewButton", true);

		// 	var myDiv;

		// 	myDiv = document.createElement('div');
		// 	myDiv.setAttribute('id', errorId); // SET AN ID TO EVERY MESSAGE
		// 	myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');

		// 	// SET THE MESSAGE
		// 	var message = $A.get("$Label.c.MandatoryField");
		// 	var errorMessage = document.createTextNode(message);
		// 	myDiv.appendChild(errorMessage);
		// 	try
		// 	{
		// 		var idSet = component.get("v.idAnnualRevenure");
		// 		var idAnnual = idSet.getElement();
		// 		console.log("idSet = " + idSet);
		// 		idAnnual.after(myDiv);
		// 		idAnnual.className = "slds-has-error flow_required";
		// 	}
		// 	catch (err) 
		// 	{
		// 		console.log('err.message idSet: ' + err.message);

		// 	}
		// }

	},

	closeModel : function(component, event, helper) {
		component.set('v.openModalShopSign' , false);
		// -----filter by street and shopName------START//
		if (component.find("searchInputNameId") || component.find("searchInputAddressId") ||component.find("searchInputCityId") || component.find("searchInputZipCodeId")) {

			component.find("searchInputNameId").set("v.value", "");
			component.find("searchInputAddressId").set("v.value", "");
			component.find("searchInputCityId").set("v.value", "");
			component.find("searchInputZipCodeId").set("v.value", "");
			

		}
		if (component.find("insegnaSearch") || component.find("zipcode") ||component.find("citySearch") || component.find("streetSearch")) {

			component.find("insegnaSearch").set("v.value", "");
			component.find("zipcode").set("v.value", "");
			component.find("citySearch").set("v.value", "");
			component.find("streetSearch").set("v.value", "");
			

		}
		component.set('v.zipcodeValueSearch' , '');
		
		// -----filter by street and shopName------END//

		// for Hide/Close Model,set the "isOpen" attribute to "False"
		component.set("v.isOpen", false);
		component.set("v.openModalMccCap", false);
		// set hideNewButton to true to desable button
		//component.set("v.hideNewButton", false);
		component.set("v.showMessage", false);
		component.set("v.booleanFilter",  false);//CLOSE MODAL WITH FILTER
		/*
		21/05/2019
		giovanni spinelli delete component.set("v.objectDataMap.pv.NE__Zip_Code__c", '');
		because when click X on shopSign modal it delete the zipCode from objectDataMap
		*/
		component.set("v.objectDataMap.pv.OB_Ecommerce__c", false);

	},
	closeModel2 : function(component, event, helper) {
		component.set("v.hideNewButton", false);
		component.set("v.isOpen", false);
	},

	// Doris D. 05/03/2019 ................Start //
	confirmationSP : function(component, event, helper) {
		component.set("v.hideNewButton", false);		
		component.set("v.isOpen", false);	
		//START gianluigi.virga 13/07/2019 - UX-55
		component.set("v.postelcomponentparams.streetnumberdisabled", true);
		component.set("v.showAddressButton", false);
		component.set("v.isPostelDisabled", false);
		//END gianluigi.virga 13/07/2019 - UX-55
		
	// Doris D. 05/03/2019 ................End //
		
		},

	openModal : function(component, event, helper) {
		// component.set("v.spinner", true);
		helper.createComponent(component, event);
	},

	handleShowModalEvent : function(component, event, helper) {
		var objectDataMap = event.getParam("objectDataMap");
		//GET LOV FROM LEVEL 3 WITH VALUE OF LEVEL 2
         if(objectDataMap.pv.MCC_level == 'L1' )
         {
        	//alert('handler l1');
        	component.set('v.lookupLovL2' , objectDataMap.pv.NE__Lov__c);
        	var inputMCCdescription2= component.find("inputMCCdescription2"); 
			if(inputMCCdescription2){
				console.log('INTO IF RE INIT')
				inputMCCdescription2.reInit();
			}

         }
        //IF THERE ISN'T A MCC CODE--> SHOW LEVEL 3
        if(objectDataMap.order.MCC_level == 'L2' )
        {
        	var showLevel3 = false;
	        if(objectDataMap.order.OB_MCC__c)
	        {
	        	showLevel3 = false;
	        }
	        else if(!objectDataMap.order.OB_MCC__c)
	        {
	        	showLevel3 = true;
	        }
	        /*
	         IF THE FAKE CODE AND MCC ARE THE SAME, IT MEANS THAT AT
	         THE BEGINNING THE MCC VALUE WAS NULL SO THE THIRD LEVEL
	         MUST BE VISIBLE
			*/
	        if(objectDataMap.order.OB_MCC__c == objectDataMap.order.OB_tmp_MCC__c){
	        	showLevel3 = true;
	        }
        	component.set('v.lookupLov' , objectDataMap.order.NE__Lov__c);
        	if(showLevel3==true || objectDataMap.order2.OB_MCC__c)
        	{
        		component.set('v.showLevel3'  , true);
        		component.set('v.objectDataMap.isL3Required' , true);
            	//SAVE THE FAKE CODE INTO MCC
            	component.set('v.objectDataMap.order.OB_MCC__c' , objectDataMap.order.OB_tmp_MCC__c);
        	}else if(showLevel3 == false ){
        		component.set('v.showLevel3'  , false);
        		component.set('v.objectDataMap.isL3Required' , false); 
        	}

		}
		component.set('v.objectDataMap.isL3Required' , true); //francesca.ribezzi 13/11/19 - PROD-80 - Mcc l3 is always required 
		component.set("v.objectDataMap", objectDataMap);
	
	},

	doSearch : function(component, event, helper) {

		var  searchAddress    = component.find("searchInputAddressId").get("v.value"),
			 searchName       = component.find("searchInputNameId").get("v.value"),
			 searchCity       = component.find("searchInputCityId").get("v.value"),
			 searchZipCode    = component.find("searchInputZipCodeId").get("v.value"),
			 //START Andrea Saracini 21/03/2019 Card no Present
			 searchUrl 		  = component.find("searchInputUrlId").get("v.value"),
			 searchApp	      = component.find("searchInputAppId").get("v.value"),
			 //STOP Andrea Saracini 21/03/2019 Card no Present
			 searchAddressUpperCase,
			 searchCityUpperCase,
			 searchZipCodeUpperCase,
			 searchNameUpperCase,
			 searchUrlUpperCase,
			 searchAppUpperCase;

		if (searchAddress !== undefined || searchAddress != "" || searchAddress != null) {
			searchAddressUpperCase = (searchAddress.trim()).toUpperCase();
		} else {
			searchAddressUpperCase = null;
		}

		if (searchName !== undefined || searchName != "" || searchName != null) {
			searchNameUpperCase = (searchName.trim()).toUpperCase();
		} else {
			searchNameUpperCase = null;
		}
		//START Andrea Saracini 21/03/2019 Card no Present
		if (searchUrl !== undefined || searchUrl != "" || searchUrl != null) {
			searchUrlUpperCase = (searchUrl.trim()).toUpperCase();
		} else {
			searchUrlUpperCase = null;
		}
		if (searchApp !== undefined || searchApp != "" || searchApp != null) {
			searchAppUpperCase = (searchName.trim()).toUpperCase();
		} else {
			searchAppUpperCase = null;
		}
		//STOP Andrea Saracini 21/03/2019 Card no Present
		searchCity ?    searchCityUpperCase    = (searchCity.trim()).toUpperCase()    : searchCityUpperCase = null;
		searchZipCode ?    searchZipCodeUpperCase    = (searchZipCode.trim()).toUpperCase()    : searchZipCodeUpperCase = null;

		var responseServicePoint = component.get("v.responseServicePoint");
		var filteredList = [];
		var arrToFilter  = [];		

		arrToFilter = component.get("v.responseServicePoint");
		console.log("array to filter " + JSON.stringify(arrToFilter));
		console.log("searchAddressUpperCase " + searchAddressUpperCase);
		console.log("CODE ARRAY: " + ((arrToFilter[0].NE__Street__c.trim()).toUpperCase()).indexOf(searchAddressUpperCase));
		
		//START Andrea Saracini 21/03/2019 Card no Present: Filtrer Service point for url or app
		//component.set("v.spinner", true);
		var	merchantId = component.get("v.objectDataMap.merchant.Id");
		var arrToFilterForUrlApp  = [];

		var action = component.get("c.filterForUrlAndApp");
		action.setParams({
			url: searchUrl,
			app: searchApp,
			merchantId: merchantId
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS"){
				var response = response.getReturnValue();
				if(response != null && response.length > 0){
					component.set("v.responseSpFilterForUrlAndApp", response);
					arrToFilterForUrlApp = component.get("v.responseSpFilterForUrlAndApp");
					if(arrToFilterForUrlApp.length > 0){
						arrToFilter = component.get("v.responseSpFilterForUrlAndApp")
					}							
				}	
				for (var i = 0; i < arrToFilter.length; i++) {
					var booleanFilter = true;
					if(searchAddressUpperCase)
					{
						if(!(arrToFilter[i].NE__Street__c !== undefined  && (( arrToFilter[i].NE__Street__c.trim()).toUpperCase()).indexOf(searchAddressUpperCase) != -1 )) {
							booleanFilter= false;
						}
					}
					if(searchNameUpperCase ){
						if(!(arrToFilter[i].Name !== undefined && ((arrToFilter[i].Name.trim()).toUpperCase()).indexOf(searchNameUpperCase) != -1)){
							booleanFilter= false;
						}
					}
					if(searchCityUpperCase ){
						if(!(arrToFilter[i].NE__City__c !== undefined && ((arrToFilter[i].NE__City__c.trim()).toUpperCase()).indexOf(searchCityUpperCase) != -1)){
							booleanFilter= false;
						}
					}
					if(searchZipCodeUpperCase  ){
						if(!(arrToFilter[i].NE__Zip_Code__c !== undefined && ((arrToFilter[i].NE__Zip_Code__c.trim()).toUpperCase()).indexOf(searchZipCodeUpperCase) != -1)){
							booleanFilter= false;
						}
					}
					if(booleanFilter==true){
						filteredList.push(arrToFilter[i]);				
					}
				}
				//START Andrea Saracini 21/03/2019 Card no Present: Filtrer Service point for url or app
				if((searchUrl || searchApp) && arrToFilterForUrlApp.length > 0 && filteredList.length == 0){
					filteredList.push.apply(filteredList, arrToFilter);
					//for (var i = 0; i < arrToFilter.length; i++) {
					//	filteredList.push(arrToFilter[i]);
					//}
				}
				//STOP Andrea Saracini 21/03/2019 Card no Present
				//component.set("v.spinner", false);
				component.set("v.responseServicePointFilter", filteredList);
				component.set("v.booleanFilter",    true);
				component.set("v.booleanResponse", false);
		
				if (filteredList.length == 0) {
					component.set("v.showMessage", true);
				}
				else {
					component.set("v.showMessage", false);
				}
			}
		});
		$A.enqueueAction(action);

		//STOP Andrea Saracini 21/03/2019 Card no Present		
		/* Filtrer par Service point address et servicePointName */
		/*
		for (var i = 0; i < arrToFilter.length; i++) {

			// if ((searchAddressUpperCase && (arrToFilter[i].NE__Street__c !== undefined) && ((arrToFilter[i].NE__Street__c.trim()).toUpperCase()).indexOf(searchAddressUpperCase) != -1)
			// 	|| (searchNameUpperCase && (arrToFilter[i].Name !== undefined) && ((arrToFilter[i].Name.trim()).toUpperCase()).indexOf(searchNameUpperCase) != -1)
			// 	|| (searchCityUpperCase && (arrToFilter[i].NE__City__c !== undefined) && ((arrToFilter[i].NE__City__c.trim()).toUpperCase()).indexOf(searchCityUpperCase) != -1)
			// 	|| (searchZipCodeUpperCase && (arrToFilter[i].NE__Zip_Code__c !== undefined) && ((arrToFilter[i].NE__Zip_Code__c.trim()).toUpperCase()).indexOf(searchZipCodeUpperCase) != -1)) 

			// {
				
			// 	filteredList.push(arrToFilter[i]);
			// 	console.log('ARRAY FILTERED: ' + JSON.stringify(arrToFilter));

			// }
			var booleanFilter = true;
			if(searchAddressUpperCase)
			{
				if(!(arrToFilter[i].NE__Street__c !== undefined  && (( arrToFilter[i].NE__Street__c.trim()).toUpperCase()).indexOf(searchAddressUpperCase) != -1 )) {
					booleanFilter= false;
				}
				//filteredList.push(arrToFilter[i]);
			}
			if(searchNameUpperCase ){
				if(!(arrToFilter[i].Name !== undefined && ((arrToFilter[i].Name.trim()).toUpperCase()).indexOf(searchNameUpperCase) != -1)){
					booleanFilter= false;
				}
			}

				//filteredList.push(arrToFilter[i]);
			if(searchCityUpperCase ){
				if(!(arrToFilter[i].NE__City__c !== undefined && ((arrToFilter[i].NE__City__c.trim()).toUpperCase()).indexOf(searchCityUpperCase) != -1)){
					booleanFilter= false;
				}
				//filteredList.push(arrToFilter[i]);
			}
			if(searchZipCodeUpperCase  ){
				if(!(arrToFilter[i].NE__Zip_Code__c !== undefined && ((arrToFilter[i].NE__Zip_Code__c.trim()).toUpperCase()).indexOf(searchZipCodeUpperCase) != -1)){
					booleanFilter= false;
				}
				//filteredList.push(arrToFilter[i]);
			}
			if(booleanFilter==true){
				filteredList.push(arrToFilter[i]);				
			}
		}
		component.set("v.spinner", false);
		component.set("v.responseServicePointFilter", filteredList);
		component.set("v.booleanFilter",    true);
		component.set("v.booleanResponse", false);

		if (filteredList.length == 0) {
			component.set("v.showMessage", true);
		}
		else {
			component.set("v.showMessage", false);
		}
		*/	
	},

	resetSearch : function(component, event, helper) {
		component.set("v.booleanFilter",  false);
		component.set("v.booleanResponse", true);
		component.set("v.showMessage",    false);
		component.set("v.booleanDoSearch", true);
		// -----filter by street and shopName------START//
		if (component.find("searchInputNameId") != undefined || component.find("searchInputNameId") != null || component.find("searchInputAddressId") != undefined || component.find("searchInputAddressId") != null
			||component.find("searchInputZipCodeId")  || component.find("searchInputCityId")) {

			component.find("searchInputNameId").set("v.value", "");
			component.find("searchInputAddressId").set("v.value", "");
			component.find("searchInputZipCodeId").set("v.value", "");
			component.find("searchInputCityId").set("v.value", "");
			//STAR Andrea Saracini 21/03/2019 Card no Present
			component.find("searchInputUrlId").set("v.value", "");
			component.find("searchInputAppId").set("v.value", "");
			//STOP Andrea Saracini 21/03/2019 Card no Present
		}
		// -----filter by street and shopName------END//

	},

	// *****FUNCTION TO MANAGE SERVICE POINTS OBTAINED FROM SEVICE RESPONSE
	// *****/
	callService : function(component, event, helper) {

		// ******giovanni spinelli start******//
		var appEvent = $A.get("e.c:OB_EventNextButton");
		// var stepName = component.find("errorMessageId").get("v.value");
		appEvent.setParams({"showPvErrorMessage" : false});
		appEvent.setParams({"idStep" : "step_getMerchant"});
		appEvent.fire();
		// component.set( "v.showPvErrorMessage", false);
		console.log("the show error is: "+ component.get("v.showPvErrorMessage"));
		// ******giovanni spinelli stop******//

		console.log(event.target.id);

		var objectDataMap = component.get("v.objectDataMap");
		responseServicePoint = [];
		component.set("v.responseServicePoint", responseServicePoint);

		component.set("v.openModalMccCap",false);
		// boolean to open the Modal
		component.set("v.isOpen",          true);
		component.set("v.booleanDoSearch", true);
		component.set("v.booleanFilter",  false);
		component.set("v.booleanResponse", true);
		console.log("booleanResponse ----->>>> "+ component.get("v.booleanResponse"));

		var merchantCode         = component.get("v.objectDataMap.merchant.NE__Fiscal_code__c");

		var partitaIVA           = component.get("v.objectDataMap.merchant.NE__VAT__c");		

		var processor            = 'EQUENS';

		var merchantCategoryCode = component.get("v.objectDataMap.pv.OB_MCC_Description__c");
		// console.log("RESPONSE merchantCategoryCode ----->>>> "	+ merchantCategoryCode);
		var merchantCategoryCode = component.get("v.objectDataMap.pv.OB_MCC__c");
		var zipCode              = component.get("v.objectDataMap.pv.NE__Zip_Code__c");
		var eCommerce            =component.get("v.objectDataMap.pv.OB_Ecommerce__c");

		console.log("RESPONSE postalCode ----->>>> " + zipCode);
		console.log("RESPONSE eCommerce ----->>>> " + eCommerce);
		console.log("RESPONSE fiscalCode ----->>>> " + merchantCode);
		console.log("RESPONSE merchantCategoryCode ----->>>> "	+ merchantCategoryCode);
		console.log("RESPONSE partitaIVA ----->>>> " + partitaIVA);

		var fiscalCode     = encodeURI(merchantCode);
		var processore     = encodeURI(processor);
		var MCCDescription = encodeURI(merchantCategoryCode);
		var cap            = encodeURI(zipCode);
		var vat            = encodeURI(partitaIVA);

		/** ************ lea.emalieu START 10/09/2018 ******************** */
		var searchPVParam = null;
		console.log('Merchant Search : fiscalCode encodeURI: ' + fiscalCode	+ ' vat encodeURI: ' + vat);
		if (fiscalCode) {
			console.log('Fidcal code not null');
			searchPVParam = fiscalCode;
		} else if (vat) {
			console.log('vat not null');
			searchPVParam = vat;
		}

		console.log('searchPVParam:' + searchPVParam);
		/** ********** lea.emalieu END 10/09/2018 ********************* */

		var request = $A.get("e.c:OB_ContinuationRequest");
		console.log('siamo nel completeProvincia, stampo la request: '+ JSON.stringify(request));
		request.setParams({
					methodName   : "retriveServicePoint",
					methodParams : [ searchPVParam, processore, MCCDescription,cap ],

					callback : function(result) {
						console.log('RISULTATO: ' + result);
						console.log('RISULTATO CONVERT : '+ result.replace(/&quot;/g, '"'));
						responseServicePoint = [];
						component.set("v.responseServicePoint",responseServicePoint);

						var resultJson = result.replace(/&quot;/g, '"');

						// ****SET THE OBJECTDATAMAP WITH THE RETURN VALUE FROM SERVICE****//

						var parseJSON = JSON.parse(resultJson);
						
						if(parseJSON != undefined){

								if (parseJSON.length == 0 ) {
									component.set("v.showMessage", true);

								}
								
								// for(var i in resultJson){
								 	console.log("PARSE RESULT :  "+JSON.stringify(parseJSON.salePoints));
		    				
		    		 			//}

		    					if(parseJSON.salePoints != undefined){

									for (var i = 0; i < parseJSON.salePoints.length; i++) {
									 	var counter = parseJSON.salePoints[i];

									 	console.log("counter ---> " + i + " "+  JSON.stringify(counter));
									 	var servicePointProvisorio = {};
									 	servicePointProvisorio.shopName = counter.shopName;
									 	console.log("shopName = " + counter.shopName);
										servicePointProvisorio.merchantCategoryCode = counter.merchantCategoryCode;
										console.log("merchantCategoryCode = " + counter.merchantCategoryCode);
									 	var myObj = counter.address;

									 	for ( var x in myObj) {
									 		servicePointProvisorio[x] = myObj[x];
									 	}

									 	console.log('servicePointProvisorio '+ JSON.stringify(servicePointProvisorio));
									 	responseServicePoint.push(servicePointProvisorio);
									 	
									}
							}

						}
						

						component.set("v.responseServicePoint",	responseServicePoint);
						console.log("responseServicePoint "	+ JSON.stringify(responseServicePoint));

						component.set('v.columns', [ {
							label : $A.get("$Label.c.Name"),
							fieldName : 'shopName',
							type : 'text'
						}, {
							label : $A.get("$Label.c.Street"),
							fieldName : 'street',
							type : 'text'
						}, {
							label : $A.get("$Label.c.Street_Number"),
							fieldName : 'civicNumber',
							type : 'text'
						}, {
							label : $A.get("$Label.c.City"),
							fieldName : 'city',
							type : 'text'
						}, {
							label : $A.get("$Label.c.OB_MCC_Description"),
							fieldName : 'merchantCategoryCode',
							type : 'text'
						 },	
						 //{
						// 	label: $A.get("$Label.c.Status"),fieldName:'OB_Status__c',
						// 	 type: 'text'
						// },	
						{
							label : $A.get("$Label.c.PostalCode"),
							fieldName : 'postalCode',
							type : 'text'
						} ]);

					}

				});

		request.fire();

	},

	searchSpSFDC : function(component, event, helper) {
		component.set("v.hideNewButton", true);
		component.set("v.isOpen", true);
		// ******giovanni spinelli start******//
		var appEvent = $A.get("e.c:OB_EventNextButton");
		// var stepName = component.find("errorMessageId").get("v.value");
		appEvent.setParams({
			"showPvErrorMessage" : false
		});
		appEvent.setParams({
			"idStep" : "step_getMerchant"
		});
		appEvent.fire();
		// component.set( "v.showPvErrorMessage", false);
		console.log("the show error is: "+ component.get("v.showPvErrorMessage"));
		// ******giovanni spinelli stop******//

		//component.set("v.hideNewButton", false);
		// boolean to open the Modal
		
		// boolean to close the ModalMccCap
		
		component.set("v.booleanDoSearch", true);

		var objectDataMap        = component.get("v.objectDataMap");
		//var fiscalCode           = component.get("v.objectDataMap.merchant.NE__Fiscal_code__c");
		var partitaIVA           = component.get("v.objectDataMap.merchant.NE__VAT__c");
		var processor            = 'EQUENS';
		//var merchantCategoryCode = component.get("v.objectDataMap.pv.OB_MCC__c");
		//Doris D. 05/03/2019 ....START//
		var insegna              = "";// component.find("insegnaSearch").get("v.value"),
		    zipCode              = "";//component.find("zipcode").get("v.value"),
		    city                 = "";//component.find("citySearch").get("v.value"),
			street               = "";//component.find("streetSearch").get("v.value"),
			//START Andrea Saracini 19/03/2019 Card no Present
			url = "";//component.find("urlSearch").get("v.value"),
			app = "";//component.find("appSearch").get("v.value"),
			//STOP 	Andrea Saracini 19/03/2019 Card no Present



		//Doris D. 05/03/2019 ....END//	
		var	merchantId           = component.get("v.objectDataMap.merchant.Id");
		console.log("PARAMS: ");
		console.log("insegna: " + insegna + ' zipCode ' + zipCode + ' city ' + city + ' street ' + street + ' merchantId ' + merchantId);
		//console.log("RESPONSE fiscalCode ----->>>>" + fiscalCode);
		/* ANDREA.MORITTU START 2019.05.03 -> ID_Stream_6_Subentro */
		var oldWrapperInformation = !$A.util.isUndefinedOrNull(component.get("v.oldWrapperInformation")) ? JSON.stringify(component.get("v.oldWrapperInformation")) : null ;
		var action = component.get("c.listServicePoint");
		//STOP Andrea Saracini 19/03/2019 Card no Present: add "url" and "app"
		action.setParams({
			insegna : insegna, 
			zipCode : zipCode, 
			city: city, 
			street: street, 
			url: url, 
			app: app, 
			merchantId: merchantId,
			oldWrapperInformation : oldWrapperInformation
		});
		/* ANDREA.MORITTU END 2019.05.03 -> ID_Stream_6_Subentro */
		//STOP Andrea Saracini 19/03/2019 Card no Present: add "url" and "app"		

		action.setCallback(this, function(response) {
						var state = response.getState();
						console.log("the state is  " + state);
						if (state === "SUCCESS") 
						{
							console.log("RESPONSE SERVICE POINT"	+ JSON.stringify(response.getReturnValue()));
							var serviPointList = response.getReturnValue();
							// component.set("v.servicePointData", response.getReturnValue());
							// console.log("RESPONSE servicePointData ******"
							// 		+ JSON.stringify(component.get("v.servicePointData")));
							//THE MERCHANT HAS ONLY ONE SERVICE POINT
							//if(serviPointList.length == 1){
								//HIDE THE FIELD TO FILTER
								//

								component.set("v.showFilters"    , true);
								// component.set("v.openModalMccCap", false);
								component.set("v.isOpen",          true);
								component.set("v.booleanResponse", true);
								var address;
								for(var key in serviPointList){
									console.log('VALORI MAPPA: ' + serviPointList[key]['NE__Street__c']);
									address = serviPointList[key]['NE__Street__c'] +', '+ serviPointList[key]['OB_Street_Number__c'];
									serviPointList[key]['NE__Street__c'] = address;
									
								}
								component.set("v.responseServicePoint",	serviPointList);
								component.set('v.columns', [
									{label : $A.get("$Label.c.Name"),              fieldName : 'Name',                 type : 'text'},
									{label : $A.get("$Label.c.City"),              fieldName : 'NE__City__c',          type : 'text'},
									{label : $A.get("$Label.c.Street"),            fieldName : 'NE__Street__c',        type : 'text'}, 
									{label : $A.get("$Label.c.PostalCode"),        fieldName : 'NE__Zip_Code__c',      type : 'text'},
									{label : $A.get("$Label.c.OB_MCC_Description"),fieldName : 'OB_MCC_Description__c', type : 'text'},
									//START 	Andrea Saracini 21/03/2019 Card no Present
									//PRODOB-463 giovanni spinelli remove OB_Stato_IT_Service_Point__c from table
									{label : $A.get("$Label.c.OB_Typology"),	fieldName : 'OB_Typology__c', type : 'text'}]);
									//STOP 		Andrea Saracini 21/03/2019 Card no Present
									
							    //---------------------Doris D. ----- 18/02/2019 -----------------------------------------------------//
									// {label : $A.get("$Label.c.Status"),			    fieldName: 'OB_Stato_IT_Service_Point__c',  		type: 'text'} ]);
								//-----------------------------------------  END  ----------------------------------------------------//	
									//PRODOB-463 giovanni spinelli remove OB_Stato_IT_Service_Point__c from table
								//}
							// else if(serviPointList.length == 0 )










							// {
							// 	component.set('v.showMessage' , true);

							// 	//HIDE THE FIELD TO FILTER
							// 	component.set("v.showFilters" , false);
							// 	//HIDE PREVIOUS DATA TABLE
							// 	component.set("v.booleanResponse" , false);
							// 	component.set("v.isOpen", true);
							// 	component.set("v.openModalMccCap", false);
							// 	// console.log('zipcode search: ' +component.get('v.zipcodeValueSearch'));
							// 	// if(component.get('v.zipcodeValueSearch')){
							// 	// 	component.set('v.showMessage' , true);
							// 	// 	//call service with zipcode
							// 	// 	component.set("v.isOpen", true);
							// 	// 	component.set("v.openModalMccCap", false);
									

									
							// 	// }else{
							// 	// 	//stay in modal search
							// 	// 	component.set("v.isOpen" , false);
							// 	// 	component.set("v.openModalMccCap" , true);
							// 	// 	//set red border to zip code
							// 	// 	$A.util.addClass(zipcode, 'slds-has-error flow_required');
							// 	// 	component.set("v.errorCap", true);
							// 	// 	component.set("v.zipCodeErrorMessage",$A.get("$Label.c.OB_MandatoryPostalCode") );
									
							// 	// }
							// }

							// else

							// {
							// 	//SHOW THE FIELD TO FILTER
							// 	// alert('show filter? ' + component.get("v.showFilters"));

							// 	component.set("v.showFilters" , true);
							// 	component.set("v.isOpen", true);
							// 	component.set("v.openModalMccCap", false);
							// 	component.set("v.booleanResponse",    true);
							// 	//UNION OF STREET + STREET NUMBER TO SHOW IN DATA TABLE
							// 	var address;
							// 	for(var key in serviPointList){
							// 		console.log('VALORI MAPPA: ' + serviPointList[key]['NE__Street__c']);
							// 		address = serviPointList[key]['NE__Street__c'] +', '+ serviPointList[key]['OB_Street_Number__c'];
							// 		serviPointList[key]['NE__Street__c'] = address;
									

							// 	}
							// 	component.set("v.responseServicePoint",	serviPointList);

							// 	component.set('v.columns', [
							// 	{label : $A.get("$Label.c.Name"),              fieldName : 'Name',                 type : 'text'},
							// 	{label : $A.get("$Label.c.City"),              fieldName : 'NE__City__c',          type : 'text'},
							// 	{label : $A.get("$Label.c.Street"),            fieldName : 'NE__Street__c' ,        type : 'text'}, 
								 
							// 	{label : $A.get("$Label.c.PostalCode"),        fieldName : 'NE__Zip_Code__c',      type : 'text'},
							// 	{label : $A.get("$Label.c.OB_MCC_Description"),fieldName : 'OB_MCC_Description__c', type :'text'},
							// 	//---------------------Doris D. ----- 18/02/2019 -----------------------------------------------------//
							// 	{label : $A.get("$Label.c.Status"),			   fieldName: 'OB_Stato_IT_Service_Point__c',  		    type: 'text'} ]);
							// 	//-----------------------------------------  END  ----------------------------------------------------// ]);

							// }

						} else if (state === "ERROR") {

							var errors = response.getError();
							if (errors) {
								if (errors[0] && errors[0].message) {
									console.log("Error message: " + errors[0].message);
								}
							} else {
								console.log("Unknown error");
							}
						}
					});
		$A.enqueueAction(action);

	},

	/* Function to select a service point */

	getSelectedServicePoints : function(component, event, helper) {
		/**
		 * giovanni spinelli start - 26/09/2019
		 * reproduce selection behavior sp
		 * params is get from aura:method and it is the specific service point
		 * selected in the maintenance 
		 * if the flow start from maintenance I use the params in place of
		 * the selected row in identifyServicePoint
		 */
		
		var params = event.getParam('arguments');
		console.log('@@@params: ' , params);
		var selectedRows = event.getParam('selectedRows'); 
		if( params ){
			selectedRows = params.pvNode;
			
		}
		//giovanni spinelli - reproduce selection behavior sp - end - 26/09/2019
		var objectDataMap = component.get("v.objectDataMap");
		var objectDataMapClone = component.get("v.objectDataMapClone");
		console.log("SONO objectDataMap " + JSON.stringify(objectDataMap));

		var selectServicePointArray = [];
		for (var i = 0; i < selectedRows.length; i++) {
			// component.set("v.selectServicePoint", selectedRows[i]);
			selectServicePointArray.push(selectedRows[i]);
		}
		// var selectServicePoint = component.get("v.selectServicePoint");
		var selectServicePoint = selectServicePointArray;
		console.log('selectServicePoint: '+ JSON.stringify(selectServicePoint));

		
        if (selectedRows.length === 1) {
        	//SET NULL THE BOOLEAN IF THERE IS A LEVEL 3 IN PREVIOUS RESEARCH
        	component.set('v.objectDataMap.order.hasLeve3' , '');
            // close modal after select a service point
            component.set( 'v.showShopSignInput', false);
            component.set("v.isOpen", true);
            component.set("v.hideNewButton", false);
            component.set("v.objectDataMap.pv.OB_Ecommerce__c", false);
            //MAKE DISABLE THE BUTTON FOR MCC L1
            component.set('v.objectDataMap.disableButtonMcc' , true);
            
            /*
             SET TRUE THE BOOLEAN FOR NEW MERCHANT AND FALSE BOOLEANS FOR NEW AND OLD SP
             TO MANAGE THE READ ONLY FIELDS IN PREVIOS SCENARIO
            */
            component.set("v.objectDataMap.isNewMerchant"              ,  false);
            component.set("v.objectDataMap.isOldMerchantNewSp"         ,  false);
            component.set("v.objectDataMap.isOldMerchantOldSp"         ,  true);
            console.log('is new merchant?: '              + component.get('v.objectDataMap.isNewMerchant') 
          	            + '** is new service point?: '    + component.get('v.objectDataMap.isOldMerchantNewSp')
          	            + '** is old service point?: '    + component.get('v.objectDataMap.isOldMerchantOldSp'));
            //DELETE THE VALUE FROM MCC L2 MCC L3
            component.set("v.objectDataMap.order.OB_MCC__c","");
            component.set("v.objectDataMap.order.OB_MCC_Description__c","");
            component.set("v.objectDataMap.order2.OB_MCC__c","");
            component.set("v.objectDataMap.order2.OB_MCC_Description__c","");
            //HIDE LEVEL 3 OF MCC
            component.set('v.showLevel3'  , false);
        	component.set('v.objectDataMap.isL3Required'  , false);
            
			console.log("la selectedRows del servicePoint è: "+ JSON.stringify(selectedRows));
			var selectedPv = selectedRows[selectedRows.length - 1];
			/*
			 * lea.emalieu 20/09/2018 START
			 * ******************************************
			 */
			// Method to take the description of mcc code
			//elena.preteni 8/2/19 hide MCC L1
			component.set("v.objectDataMap.pv.OB_MCC_Description__c",'ALL');
			component.set("v.objectDataMap.pv.OB_MCC__c"            ,'0001');
			// var actionmccDescription = component.get("c.getMccDescription");
			// actionmccDescription.setParams({
			// 	mccCode : selectedPv.OB_MCC__c
			// });
			// actionmccDescription.setCallback(this, function(response) {
			// 	var state = response.getState();
			// 	if (state === "SUCCESS") {

			// 		component.set("v.objectDataMap.pv.OB_MCC_Description__c",response.getReturnValue());
			// 		console.log('MCC SELECTED: ' + component.get('v.objectDataMap.pv.OB_MCC_Description__c'));
			// 		console.log('MCC CODE SELECTED: ' + component.get('v.objectDataMap.pv.OB_MCC__c'));

			// 	} else if (state === "INCOMPLETE") {
			// 		// do something
			// 	} else if (state === "ERROR") {
			// 		var errors = response.getError();
			// 		if (errors) {
			// 			if (errors[0] && errors[0].message) {
			// 				console.log("Error message: " + errors[0].message);
			// 			}
			// 		} else {
			// 			console.log("Unknown error");
			// 		}
			// 	}
			// });

			// $A.enqueueAction(actionmccDescription);
			//elena.preteni 8/2/19 hide MCC L1
			/*
			 * lea.emalieu 20/09/2018 END
			 * ******************************************
			 */

			// ****SET THE OBJDATAMAP WITH THE VALUE FROM A SELECTED SERVICE
			// POINT****//
			// objectDataMap.pv.NE__Account__c = selectedPv.NE__Account__c;

			// objectDataMap.pv.Name = selectedPv.shopName;
			// objectDataMap.pv.OB_Service_Point_Name__c = component.get("v.objectDataMap.pv.OB_Service_Point_Name__c");
			// // objectDataMap.pv.NE__Street__c = selectedPv.NE__Street__c;
			// objectDataMap.pv.NE__Street__c = selectedPv.street;
			// // objectDataMap.pv.OB_Street_Number__c =
			// // selectedPv.OB_Street_Number__c;
			// objectDataMap.pv.OB_Street_Number__c = selectedPv.civicNumber;
			// console.log("numero civico: " + selectedPv.civicNumber);
			// // objectDataMap.pv.NE__Postal_Code__c =
			// // selectedPv.NE__Postal_Code__c;
			// objectDataMap.pv.NE__Postal_Code__c = selectedPv.NE__Zip_Code__c;
			// console.log("v.objectDataMap.pv.NE__Postal_Code__c = "+ objectDataMap.pv.NE__Postal_Code__c);
			// var zipcodeSelected =  objectDataMap.pv.NE__Postal_Code__c;
			
			// // objectDataMap.pv.NE__City__c = selectedPv.NE__City__c;
			// objectDataMap.pv.NE__City__c = selectedPv.city;
			// console.log("objectDataMap.pv.NE__City__c = " + selectedPv.city);
			// // objectDataMap.pv.NE__Country__c = selectedPv.NE__Country__c;
			// objectDataMap.pv.NE__Country__c = selectedPv.country;
			// console.log("objectDataMap.pv.NE__Country__c = "
			// 		+ selectedPv.country);
			// // objectDataMap.pv.NE__Province__c = selectedPv.NE__Province__c;
			// objectDataMap.pv.NE__Province__c = selectedPv.province
			// console.log("objectDataMap.pv.NE__Province__c = "
			// 		+ selectedPv.province);
			// objectDataMap.pv.OB_District__c = selectedPv.district;
			// console.log("objectDataMap.pv.OB_District__c = "
			// 		+ selectedPv.district);
			// objectDataMap.pv.OB_Email__c = selectedPv.OB_Email__c;
			// objectDataMap.pv.OB_MCC__c = selectedPv.merchantCategoryCode;
			// console.log("objectDataMap.pv.OB_MCC__c = "+ selectedPv.OB_MCC__c);
			// var MCCSelected = selectedPv.OB_MCC__c;
			// helper.getServicePointMIP(component , zipcodeSelected , MCCSelected);
			// // objectDataMap.pv.OB_MCC_Description__c =
			// // selectedPv.OB_MCC_Description__c;
			// objectDataMap.pv.OB_MCC_Description__c = component.get("v.objectDataMap.pv.OB_MCC_Description__c");

			// objectDataMap.pv.OB_Annual_Revenue__c = selectedPv.OB_Annual_Revenue__c;
			// objectDataMap.pv.OB_Annual_Negotiated__c = selectedPv.OB_Annual_Negotiated__c;
			// objectDataMap.pv.Id = "";

			//GIOVANNI SPINELLI - START - 08/02/2019
			// Create a new JavaScript Date object based on the timestamp
			// multiplied by 1000 so that the argument is in milliseconds, not seconds.
			try{

				// DG - 11/02/2019 - 1341 - START
				console.log('@@@@ Dates ObjectDatamap --> \nopening:'+selectedPv.OB_Opening_Time__c+' '+'\nclosing:'+selectedPv.OB_Ending_Time__c+' '+'\nbreakStart:'+selectedPv.OB_Break_Start_Time__c+' '+'\nbreakEnd:'+selectedPv.OB_Break_End_Time__c);
				// Vars to have row time from timestamp
				var opening = selectedPv.OB_Opening_Time__c/1000/3600;
				var closing = selectedPv.OB_Ending_Time__c/1000/3600;
				var breakStart = selectedPv.OB_Break_Start_Time__c/1000/3600;
				var breakEnd = selectedPv.OB_Break_End_Time__c/1000/3600;
				
				// Timing logic
				// console.log('typeof: ' + typeof(opening));
				// console.log('@@@@ Dates--> opening:'+opening+' '+'closing:'+closing+' '+'breakStart:'+breakStart+' '+'breakEnd:'+breakEnd);
				// console.log('@@@@ Math.floor: ' + Math.floor(opening));
				// console.log('@@@@ Decimal Value: ' + (opening - (Math.floor(opening))));
				// console.log('@@@@ Minute Value: ' + ((opening - (Math.floor(opening)))*60/100));
				// console.log('@@@@ Time Value: ' + ((Math.floor(opening)) + ((opening - (Math.floor(opening)))*60/100)).toFixed(2));

				// Vars to have right time values
				// OPENING 
				var openingHours =  Math.floor(opening);
				var openingMinutes =  ((opening - (Math.floor(opening)))*60/100);
				var openingTime = (openingHours + openingMinutes).toFixed(2);
				// CLOSURE
				var closingHours =  Math.floor(closing);
				var closingMinutes = ((closing - (Math.floor(closing)))*60/100);
				var closingTime = (closingHours + closingMinutes).toFixed(2);
				// BREAK START
				var breakStartHours =  Math.floor(breakStart);
				var breakStartMinutes = ((breakStart - (Math.floor(breakStart)))*60/100);
				var breakStartTime = (breakStartHours + breakStartMinutes).toFixed(2);
				// BREAK END
				var breakEndHours =  Math.floor(breakEnd);
				var breakEndMinutes = ((breakEnd - (Math.floor(breakEnd)))*60/100);
				var breakEndTime = (breakEndHours + breakEndMinutes).toFixed(2);
				// DG - 11/02/2019 - 1341 - END


				// var date1 = new Date(selectedPv.OB_Opening_Time__c*1000);
				// var date2 = new Date(selectedPv.OB_Ending_Time__c*1000);
				// var date3 = new Date(selectedPv.OB_Break_Start_Time__c*1000);
				// var date4 = new Date(selectedPv.OB_Break_End_Time__c*1000);
				// console.log('DATE * 1000: ' + date1);
				// console.log('HOURS ' + date1.toDateString() );
				// console.log('MINUTES ' + date1.getUTCMinutes() );
				// console.log('DATE TEST: '+$A.localizationService.formatDate(date1, "MMM dd yyyy, hh:mm:ss a"));

				// // Hours part from the timestamp
				// var hours1 = date1.getHours();
				// var hours2 = date2.getHours();
				// var hours3 = date3.getHours();
				// var hours4 = date4.getHours();
				// console.log('hours1: ' + hours1);
				// // Minutes part from the timestamp
				// var minutes1 = "0" + date1.getMinutes();
				// var minutes2 = "0" + date2.getMinutes();
				// var minutes3 = "0" + date3.getMinutes();
				// var minutes4 = "0" + date4.getMinutes();
				// console.log('minutes1' + minutes1);
				// // Seconds part from the timestamp
				// //var seconds = "0" + date.getSeconds();

				// // Will display time in 10:30:23 format
				// var formattedTimeOpen			 = hours1 + '.' + minutes1.substr(-2) ;
				// var formattedTimeEnd 			 = hours2 + '.' + minutes2.substr(-2) ;
				// var formattedTimeBreakStart 	 = hours3 + '.' + minutes3.substr(-2) ;
				// var formattedTimeBreakEnd 		 = hours4 + '.' + minutes4.substr(-2) ;
				// console.log('TIME FROM TIMESTAMP: ' + formattedTimeOpen + ' - '+formattedTimeEnd + ' - '+formattedTimeBreakStart +' - '+ formattedTimeBreakEnd);
				//GIOVANNI SPINELLI - START - 08/02/2019

				//05/11/2018 - GIOVANNI SPINELLI - SET OBJECT DATA MAP WITH VALUE FROM SFDC
				objectDataMap.pv.Id                       = selectedPv.Id;
				objectDataMap.pv.NE__Account__c           = selectedPv.NE__Account__c;
				objectDataMap.pv.Name                     = selectedPv.shopName;
				objectDataMap.pv.OB_Service_Point_Name__c = component.get("v.objectDataMap.pv.OB_Service_Point_Name__c");
				objectDataMap.pv.Name                     = selectedPv.Name;
				objectDataMap.pv.NE__Street__c            = (selectedPv.NE__Street__c).split(',')[0];
				objectDataMap.pv.OB_Street_Number__c      = selectedPv.OB_Street_Number__c;
				objectDataMap.pv.NE__Zip_Code__c          = selectedPv.NE__Zip_Code__c;
				objectDataMap.pv.NE__City__c              = selectedPv.NE__City__c;
				objectDataMap.pv.NE__Country__c           = selectedPv.NE__Country__c;
				objectDataMap.pv.NE__Province__c          = selectedPv.NE__Province__c;
				objectDataMap.pv.OB_District__c           = selectedPv.OB_District__c;
				objectDataMap.pv.OB_Address_Detail__c     = selectedPv.OB_Address_Detail__c;
				objectDataMap.pv.OB_MCC__c                = selectedPv.OB_MCC__c;
				//GIOVANNI SPINELLI 27/06/2019 MAPPING OPENING DAYS - START
				objectDataMap.pv.OB_Opening_Monday_Morning__c                = selectedPv.OB_Opening_Monday_Morning__c;
				objectDataMap.pv.OB_Opening_Monday_Afternoon__c              = selectedPv.OB_Opening_Monday_Afternoon__c;
				objectDataMap.pv.OB_Opening_Tuesday_Morning__c               = selectedPv.OB_Opening_Tuesday_Morning__c;
				objectDataMap.pv.OB_Opening_Tuesday_Afternoon__c             = selectedPv.OB_Opening_Tuesday_Afternoon__c;
				objectDataMap.pv.OB_Opening_Wednesday_Morning__c             = selectedPv.OB_Opening_Wednesday_Morning__c;
				objectDataMap.pv.OB_Opening_Wednesday_Afternoon__c           = selectedPv.OB_Opening_Wednesday_Afternoon__c;
				objectDataMap.pv.OB_Opening_Thursday_Morning__c              = selectedPv.OB_Opening_Thursday_Morning__c;
				objectDataMap.pv.OB_Opening_Thursday_Afternoon__c            = selectedPv.OB_Opening_Thursday_Afternoon__c;
				objectDataMap.pv.OB_Opening_Friday_Morning__c                = selectedPv.OB_Opening_Friday_Morning__c;
				objectDataMap.pv.OB_Opening_Friday_Afternoon__c              = selectedPv.OB_Opening_Friday_Afternoon__c;
				objectDataMap.pv.OB_Opening_Saturday_Morning__c              = selectedPv.OB_Opening_Saturday_Morning__c;
				objectDataMap.pv.OB_Opening_Saturday_Afternoon__c            = selectedPv.OB_Opening_Saturday_Afternoon__c;
				objectDataMap.pv.OB_Opening_Sunday_Morning__c                = selectedPv.OB_Opening_Sunday_Morning__c;
				objectDataMap.pv.OB_Opening_Sunday_Afternoon__c              = selectedPv.OB_Opening_Sunday_Afternoon__c;
				if(selectedPv.OB_End_Seasonal__c){
					objectDataMap.pv.OB_End_Seasonal__c                			 = selectedPv.OB_End_Seasonal__c;
				}else{
					objectDataMap.pv.OB_End_Seasonal__c = '';
				}

				if(selectedPv.OB_Start_Seasonal__c){
					objectDataMap.pv.OB_Start_Seasonal__c              			 = selectedPv.OB_Start_Seasonal__c;
				}else{
					objectDataMap.pv.OB_Start_Seasonal__c = '';
				}
				
				
				//GIOVANNI SPINELLI 27/06/2019 MAPPING OPENING DAYS - END
				//--------------------Doris __18/02/2019 ------------------------------------------------------//
				
				//objectDataMap.pv.OB_Stato_IT_Service_Point__c             = selectedPv.OB_Stato_IT_Service_Point__c; --> spinelli giovanni PRODOB-463
				//--------------------------- END -------------------------------------------------------------//
				//elena.preteni 8/2/19 hideMCC L2
				objectDataMap.pv.OB_MCC_Description__c    = component.get("v.objectDataMap.pv.OB_MCC_Description__c");
				// objectDataMap.pv.OB_MCC_Description__c    = 'ALL';
				//elena.preteni 8/2/19 hideMCC L2
				objectDataMap.pv.OB_Annual_Revenue__c     = selectedPv.OB_Annual_Revenue__c;
				objectDataMap.pv.OB_Annual_Negotiated__c  = selectedPv.OB_Annual_Negotiated__c;
				objectDataMap.pv.OB_Typology__c           = selectedPv.OB_Typology__c;
				// DG - 11/02/2019 - 1341 - START
				//save hours only if they aren't undefined
				if(selectedPv.OB_Opening_Time__c){
					objectDataMap.pv.OB_Opening_Time__c       = openingTime;
				}
				if(selectedPv.OB_Ending_Time__c){
					objectDataMap.pv.OB_Ending_Time__c        = closingTime;
				}
				if(selectedPv.OB_Break_Start_Time__c){
					objectDataMap.pv.OB_Break_Start_Time__c   = breakStartTime;
				}
				if(selectedPv.OB_Break_End_Time__c){
					objectDataMap.pv.OB_Break_End_Time__c     = breakEndTime;
				}
				console.log('SERVICE POINT AFTER SET: ' + JSON.stringify(objectDataMap.pv));
				console.log('@@@@ DATAMAP OBJECT TIME VALUES');
				console.log('@@@@ OPENING: ' + openingTime);
				console.log('@@@@ CLOSURE: ' + closingTime);
				console.log('@@@@ BREAKSTART: '+ breakStartTime);
				console.log('@@@@ BREAKEND: ' + breakEndTime);
				// DG - 11/02/2019 - 1341 - END

				//set time 
				// objectDataMap.pv.OB_Opening_Time__c       = formattedTimeOpen;
				// objectDataMap.pv.OB_Ending_Time__c        = formattedTimeEnd;
				// objectDataMap.pv.OB_Break_Start_Time__c   = formattedTimeBreakStart;
				// objectDataMap.pv.OB_Break_End_Time__c     = formattedTimeBreakEnd;
			}catch(err){
				console.log('ERROR_TIME: ' + err.message);
			}
			//SHOW THE ZIPCODE INPUT AS AN INPUT AND DISABLED
			component.set("v.postelcomponentparams.zipcodedisabled" , 'true');
			//MAKE PRESSO DISABLED
			component.set("v.postelcomponentparams.pressodisabled"      , 'true');
			
			console.log('THE ZIP CODE SELECTED IS: ' + component.get("v.zipcodeString"));
			
			console.log("SERVICE POINT SELECTED: " + JSON.stringify(objectDataMap.pv));
			//giovanni spinelli - reproduce selection behavior sp - start - 26/09/2019
			if(params){
				component.set("v.hideNewButton", false);		
				component.set("v.isOpen", false);	
				//START gianluigi.virga 13/07/2019 - UX-55
				component.set("v.postelcomponentparams.streetnumberdisabled", true);
				component.set("v.showAddressButton", false);
				component.set("v.isPostelDisabled", false);
			}
			//giovanni spinelli - reproduce selection behavior sp - end - 26/09/2019
		}
		// ****24/09/2018-GIOVANNI SPINELLI****//
		// console.log("name id of namePv is: "+ document.getElementById('errorIdnamePv'));
		if (document.getElementById('customErrorIdnamePv')) {
			document.getElementById('customErrorIdnamePv').remove();
		    $A.util.removeClass(component.find('namePv'),'slds-has-error flow_required');
		}
		// ****24/09/2018-GIOVANNI SPINELLI****//

		console.log(' The provincia error Id is '+ document.getElementById('errorIdprovincia'));
		// var elem = document.getElementById('errorIdprovincia');
		// if(elem){ //document.getElementById('errorIdprovincia').remove();
		// elem.parentNode.removeChild(elem);
		// }

		var componentParm = component.get("v.postelcomponentparams");
		componentParm.provincedisabled       = 'true';
		componentParm.countrydisabled        = 'true';
    	componentParm.citydisabled           = 'true';
    	componentParm.districtdisabled       = 'true';
    	componentParm.streetdisabled         = 'true';
    	componentParm.streetnumberdisabled   = 'true';
    	componentParm.zipcodedisabled        = 'true';
    	componentParm.pressodisabled         = 'true';

		component.set("v.postelcomponentparams", componentParm);

		console.log("componentParm **** " + JSON.stringify(componentParm));

		// make the sp input readonly
		var disabledInputSp = component.get("v.disabledInput_sp");
		disabledInputSp = true;
		component.set("v.disabledInput_sp", disabledInputSp);
		component.set("v.hideFieldTypology"       , true);//MAKE DISABLED TYPOLOGY FIELD
		
		component.set("v.objectDataMap", objectDataMap);
		component.set("v.objectDataMapClone", objectDataMap);
		component.set("v.selectServicePoint", selectServicePointArray);
		console.log("selectServicePointArray: " + selectServicePointArray);

		//START gianluigi.virga 13/08/2019 - UX-55
		/** *******Tajana Alessandro START 17/09/2018 ********** */
		// var autoCompleteCmp = component.find("AutoCompleteComponentPostel");
		// if (autoCompleteCmp) {
		// 	autoCompleteCmp.reInitAll();
		// }
		var autoCompleteCmp = component.find("OB_FreeInputAddress");
		if (autoCompleteCmp) {
			autoCompleteCmp.reInitAllPostel();
		}
		/** *******Tajana Alessandro END 17/09/2018 ********** */
		//END gianluigi.virga 13/08/2019 - UX-55
		
		/** *******Tajana Alessandro END 17/09/2018 ********** */
		//METHO TO HAVE THE SAME VALUE OF MCC IN PV AND LOV TO FILTER LEVEL 2
		var actionGetLovMCC = component.get("c.getMccLov");
			actionGetLovMCC.setParams({
				MCCCodePv : selectedPv.OB_MCC__c
			});
			actionGetLovMCC.setCallback(this, function(response) {
				var state = response.getState();
				if (state === "SUCCESS") {
					console.log("LOV LINKED TO MCC PV: " + JSON.stringify(response.getReturnValue()));
					component.set('v.lookupLovL2' , response.getReturnValue().Id);
					var inputMCCdescription2= component.find("inputMCCdescription2"); 
					if(inputMCCdescription2){
						console.log('INTO IF RE INIT')
						inputMCCdescription2.reInit();
					}
					console.log("ID LOV FROM MCC PV: " + component.get('v.lookupLovL2'));
					} else if (state === "INCOMPLETE") {
					// do something
				} else if (state === "ERROR") {
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							console.log("Error message: " + errors[0].message);
						}
					} else {
						console.log("Unknown error");
					}
				}
			});

			$A.enqueueAction(actionGetLovMCC);
			//alert('parent');


	},

	// *****FUNCTION TO CREATE A NEW SERVICE POINT*****/

	newServicePoint : function(component, event, helper) {
		
		//RESET NULL LEVEL 2 AND 3
		component.set('v.objectDataMap.order' , {} );
		component.set('v.objectDataMap.order2' , {} );
		
		/* Doris D.   27/02/2019 ------------- Start*/
		component.set("v.objectDataMap.unbind.isNewPV" ,  'true'); 
		/* Doris D.   27/02/2019 ------------- End*/

		/* Doris D.   28/02/2019 ------------- Start*/
		component.set("v.openModalMccCap", false);
		/* Doris D.   28/02/2019 ------------- End*/
		
		//SET NULL THE BOOLEAN IF THERE IS A LEVEL 3 IN PREVIOUS RESEARCH
		component.set('v.objectDataMap.order.hasLeve3' , '');
		//MAKE ENABLE THE BUTTON FOR MCC L1
        component.set('v.objectDataMap.disableButtonMcc' , false);
		/*
          SET TRUE THE BOOLEAN FOR NEW MERCHANT AND FALSE BOOLEANS FOR NEW AND OLD SP
          TO MANAGE THE READ ONLY FIELDS IN PREVIOS SCENARIO
        */
        component.set("v.objectDataMap.isNewMerchant"              ,  false);
        component.set("v.objectDataMap.isOldMerchantNewSp"         ,  true);
        component.set("v.objectDataMap.isOldMerchantOldSp"         ,  false);
        console.log('is new merchant?: '      + component.get('v.objectDataMap.isNewMerchant') 
                    + '** is new service point?: '    + component.get('v.objectDataMap.isOldMerchantNewSp')
                    + '** is old service point?: '    + component.get('v.objectDataMap.isOldMerchantOldSp'));
		//SHOW SHOP SIGN AS INPUT
		component.set('v.showShopSignInput',true);
		//SHOW THE ZIPCODE INPUT AS A LIGHTNING SELECT
		component.set("v.postelcomponentparams.zipcodedisabled" , 'false');
		//MAKE PRESSO ENABLED
		component.set("v.postelcomponentparams.pressodisabled"      , false);
		var objectDataMap = component.get("v.objectDataMap");
		
		component.set("v.showEmptyInput", true);
		component.set("v.hideFieldTypology"       , false);//MAKE ENSABLED TYPOLOGY FIELD
		// make the sp input writable
		var disabledInputSp = component.get("v.disabledInput_sp");
		disabledInputSp = false;
		component.set("v.disabledInput_sp", disabledInputSp);
		// reset the objectDataMap to insert a new service point
		component.set("v.objectDataMap.pv"                          ,{});
		//giovanni spinelli 27/06/2019 set default values for opening days - start
		objectDataMap.pv.OB_Opening_Monday_Morning__c                = true;
		objectDataMap.pv.OB_Opening_Monday_Afternoon__c              = true;
		objectDataMap.pv.OB_Opening_Tuesday_Morning__c               = true;
		objectDataMap.pv.OB_Opening_Tuesday_Afternoon__c             = true;
		objectDataMap.pv.OB_Opening_Wednesday_Morning__c             = true;
		objectDataMap.pv.OB_Opening_Wednesday_Afternoon__c           = true;
		objectDataMap.pv.OB_Opening_Thursday_Morning__c              = true;
		objectDataMap.pv.OB_Opening_Thursday_Afternoon__c            = true;
		objectDataMap.pv.OB_Opening_Friday_Morning__c                = true;
		objectDataMap.pv.OB_Opening_Friday_Afternoon__c              = true;
		objectDataMap.pv.OB_Opening_Saturday_Morning__c              = true;
		objectDataMap.pv.OB_Opening_Saturday_Afternoon__c            = true;
		objectDataMap.pv.OB_Opening_Sunday_Morning__c                = true;
		objectDataMap.pv.OB_Opening_Sunday_Afternoon__c              = true;
		objectDataMap.pv.OB_Start_Seasonal__c						 = '';
		objectDataMap.pv.OB_End_Seasonal__c							 = '';
		component.set('v.objectDataMap.pv' , objectDataMap.pv);
		//giovanni spinelli 27/06/2019 set default values for opening days - end
		component.set("v.objectDataMap.pv.OB_MCC_Description__c",'ALL');
		component.set("v.objectDataMap.pv.OB_MCC__c",'0001');
		//	START 	micol.ferrari 29/01/2019 - UAT_SETUP_02_R1F1
		//	TO ROLLBACK, DELETE THESE ROW
		/*giovanni spinelli 19/02/2019--> 	change value from Fisico to POS Fisico
											when also virtuale will be available into
											catalog, decomment for loop.
											Value in picklsit is changed!!
		*/
		//end giovanni spinelli
		//	END 	micol.ferrari 29/01/2019 - UAT_SETUP_02_R1F1

		component.set("v.objectDataMap.shopSign"                    ,"");
        component.set("v.objectDataMap.order.OB_MCC__c"             ,"");
        component.set("v.objectDataMap.order.OB_MCC_Description__c" ,"");
        component.set("v.objectDataMap.order2.OB_MCC__c"            ,"");
        component.set("v.objectDataMap.order2.OB_MCC_Description__c","");
        //RESET SHOP SIGN
        component.set("v.valueShopSignWithModal"                    ,"");
        component.set("v.valueShopSignNoModal"                      ,"");
        
        //HIDE LEVEL 3
        component.set('v.showLevel3'  , false);
        component.set('v.objectDataMap.isL3Required'  , false);
		
		component.set("v.selectedRows", []);
		component.set("v.objectDataMap.pv.OB_Service_Point_Name__c","");
		component.set("v.objectDataMap.pv.OB_Service_Point_City__c","");
		console.log(' The select row is '+ JSON.stringify(component.get("v.selectedRows")));
		//START gianluigi.virga 13/08/2019 - UX-55
		// ******** Tajana ALESSANDRO ******* 13/09/2018 *****START**//
		// var autoCaps = component.find("AutoCompleteComponentPostel");
		// var caps = [];
		// autoCaps.blankMethod(caps);
		// *********Tajana Alessandro END 17/09/2018 ***********/
		var autoCaps = component.find("OB_FreeInputAddress");
		if (autoCaps) {
			autoCaps.blankMethodPostel();
		}
		//END gianluigi.virga 13/08/2019 - UX-55
		// *****delete the value into postel component*****//
		component.set("v.postelcomponentparams.provincedisabled", "false");
		component.set("v.postelcomponentparams.countrydisabled ", "false");

		if (document.getElementById('namePv')) {
			$A.util.removeClass(document.getElementById('namePv'),'slds-has-error flow_required');
		}
		//elena.preteni 8/2/19 hide MCC L!
		// if (document.getElementById('mccDescription')
		// 		&& objectDataMap.pv.OB_MCC_Description__c == ''
		// 		&& objectDataMap.pv.OB_MCC_Description__c == undefined
		// 		&& objectDataMap.pv.OB_MCC_Description__c == null) {
		// 	// REMOVE RED BORDER
		// 	$A.util.removeClass(document.getElementById('mccDescription'),
		// 			'slds-has-error flow_required');
		// }
		//elena.preteni 8/2/19 hide MCC L!


		if (document.getElementById('provincia') != null) {
			document.getElementById('provincia').value = "";
			
		}

		if (document.getElementById('comune') != null) {
			document.getElementById('comune').value = "";
		}

		if (document.getElementById('strada') != null) {
			document.getElementById('strada').value = "";
		}

		if (document.getElementById('civico') != null) {
			document.getElementById('civico').value = "";
			
		}

		if (document.getElementById('frazione') != null) {
			document.getElementById('frazione').value = "";
			
		}

		if (document.getElementById('presso') != null) {
			document.getElementById('presso').value = "";
			
		}

		if (document.getElementById('country') != null) {
			document.getElementById('country').value = "ITALIA";
		}
		// ***********************************************//
		objectDataMap.pv.Id = "";
		component.set("v.objectDataMap.pv.NE__Country__c", "ITALIA");
		//START gianluigi.virga 13/08/2019 - UX-55
		// ******** Tajana ALESSANDRO ******* 17/09/2018 *****START**//
		// autoCaps.reInitAll();
		autoCaps.reInitAllPostel();
		// ******** Tajana ALESSANDRO ******* 17/09/2018 *****END**//
		//END gianluigi.virga 13/08/2019 - UX-55
		component.set("v.isOpen", false);
		//START gianluigi.virga 13/07/2019 - UX-55
		component.set("v.postelcomponentparams.streetnumberdisabled", false);

		component.set("v.showAddressButton", true);
		component.set("v.isPostelDisabled", false);
		//END gianluigi.virga 13/07/2019 - UX-55
		

		/* ANDREA.MORITTU START 2019.05.06 - Id_Stream_6_Subentro*/
		var oldWrapperInformation = !$A.util.isEmpty(component.get("v.oldWrapperInformation")) ? component.get("v.oldWrapperInformation") : null ;
		if(!$A.util.isUndefined(oldWrapperInformation.formalCheckOnServicePointType)) {
			var typology = !$A.util.isUndefined(component.find("typologySP")) ? component.find("typologySP").get("v.value")  : null;
			if($A.util.isEmpty(typology)) {
				if(oldWrapperInformation.formalCheckOnServicePointType != typology) {
					component.set("v.objectDataMap.offerAsset.incoherentServicePointTypology", true);
					var SPtypologyInput = component.find("typologySP");
					SPtypologyInput.set("v.value" , oldWrapperInformation.formalCheckOnServicePointType );
					SPtypologyInput.set("v.disabled" ,  true);
				} 
			}
		}
		/* ANDREA.MORITTU END 2019.05.06 - Id_Stream_6_Subentro*/
	},

	

	setPickListValue_SP : function(component, event, helper) {

		var currentId = event.getSource().getLocalId();
        $A.util.removeClass(component.find(currentId), 'slds-has-error');
        //RECREATE THE SAME ID OF ERROR MESSAGE
        var errorId = 'errorId'+ currentId;
        if(document.getElementById(errorId)!=null)
        {
            console.log("errorID . " + errorId);
            document.getElementById(errorId).remove();
        }
		var objectDataMap = component.get("v.objectDataMap");
		var annualRevenueMerchant = component.get("v.objectDataMap.merchant.OB_Annual_Revenue__c");
		objectDataMap.pv.OB_Annual_Revenue__c    = component.find("annualRevenue_SP").get("v.value");
		objectDataMap.pv.OB_Annual_Negotiated__c = component.find("annualNegotiated_SP").get("v.value");
		console.log("set annual revenue sp into objdatamap: " + objectDataMap.pv.OB_Annual_Revenue__c);
		console.log("set annual negotiated sp into objdatamap: "+ objectDataMap.pv.OB_Annual_Negotiated__c);
		component.set("v.objectDataMap", objectDataMap);
	},

	removeRedBorder : function(component, event, helper) {
		var name     = component.find('namePv').get("v.value");
		var shopSign = component.find('ShopSign');
		
		var currentId = event.getSource().getLocalId();
		console.log('current id in remove red border: ' + currentId);
		var objectDataMap = component.get("v.objectDataMap");
		helper.removeRedBorder(component, event, helper);
		//SET THE VALUE OF SHOP SIGN WITH THE SAME VALUE OF LOCATION
		if(name  && shopSign && currentId == 'namePv'){
			//shopSign.set("v.value" , name);
			//SET SHOP SIGN WITH VALUE OF SP NAME ONLY IF SP NAME IS CORRECT
			if(specialCharacter(name)!='ERROR'){
				component.set('v.valueShopSignNoModal' , name);
				objectDataMap.shopSign = name;
			}
		}else if(!name && currentId == 'namePv'){
			//IF I DELETE SP NAME, DELETE ALSO THE VALUE IN SHOP SIGN
			console.log('into set null shop sign');
			component.set('v.valueShopSignNoModal' , '');
		}
		if(currentId == 'ShopSign'){
			component.set('v.valueShopSignNoModal' , component.find('ShopSign').get('v.value'));
			objectDataMap.shopSign = component.get('v.valueShopSignNoModal');
		}
		if(currentId == 'ShopSignWithModal'){
			component.set('v.valueShopSignNoModal' , component.find('ShopSignWithModal').get('v.value'));
			objectDataMap.shopSign = component.get('v.valueShopSignWithModal');
		}
		component.set('v.objectDataMap' , objectDataMap);
		console.log('SHOP SIGN IN OBJ: ' + objectDataMap.shopSign);
		// ******** METHOD FOR FORMAL CONTROL OF SERVICE POINT NAME *** START
		// ******//
		
		// CREATE A DIV WITH A CUSTOM ERROR MESSAGE
		var myDiv;
		myDiv = document.createElement('div');
		var errorMessage = document.createTextNode($A.get("$Label.c.errorSpecialCharacter"));
		console.log("error message: " + JSON.stringify(errorMessage));
		myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
		myDiv.setAttribute('id', 'customErrorId'+currentId);
		myDiv.appendChild(errorMessage);
		var idTest;
		// IF THERE IS THE INPUT
		if (component.find('namePv')) {
			idTest = component.find('namePv').getElement();
		}
		// WRONG CHARACTER
		if (specialCharacter(name) == 'ERROR' && name.length > 0) {
			$A.util.addClass(component.find('namePv'),'slds-has-error flow_required');
			// ADD THE ERROR MESSAGE
			if (!document.getElementById('customErrorIdnamePv')) {
				idTest.after(myDiv);
			}
			// BOOLEANT TO REST IN PAGE
			component.set("v.objectDataMap.errorFamily.errorNamePv", true);
		}
		// RIGHT CHARACTER
		else if (specialCharacter(name) == null || name.length == 0) {

			if (document.getElementById('customErrorIdnamePv')) {
				document.getElementById('customErrorIdnamePv').remove();
			}
			component.set("v.objectDataMap.errorFamily.errorNamePv", false);

		}

		// ******* METHOD FOR FORMAL CONTROL OF NAME SERVICE POINT NAME **** END
		// *****//
		//*****CONTROL SPECIAL CHARACTER OF SHOP SIGN******//
		// WRONG CHARACTER--> use the current id because there are two typology of field
		var idTest2;
		var shopSignValue = component.find(currentId).get('v.value');
		if (component.find(currentId)) {
			idTest2 = component.find(currentId).getElement();
		}

		
		//alert('shopSignValue: ' + shopSignValue);
		if (specialCharacter(shopSignValue) == 'ERROR' && shopSignValue.length > 0) 
		{
			$A.util.addClass(component.find(currentId),'slds-has-error flow_required');
			// ADD THE ERROR MESSAGE
			if (!document.getElementById('customErrorId'+currentId)) 
			{

				idTest2.after(myDiv);
			}
			// BOOLEANT TO REST IN PAGE
			component.set("v.objectDataMap.errorFamily.errorShopSign", true);
		}
		// RIGHT CHARACTER
		else if (specialCharacter(shopSignValue) == null || shopSignValue.length == 0) 
		{

			if (document.getElementById('customErrorId'+currentId)) 
			{
				document.getElementById('customErrorId'+currentId).remove();
			}
			//alert();
			component.set("v.objectDataMap.errorFamily.errorShopSign", false);

		}

	},

	setTypologyPickListValue_SP : function(component, event, helper) {
		var objectDataMap = component.get("v.objectDataMap");
		
		objectDataMap.pv.OB_Typology__c = component.find("typologySP").get("v.value");

		console.log("@@@@ Service Point Typology is: "
				+ objectDataMap.pv.OB_Typology__c);
		component.set("v.objectDataMap", objectDataMap);
		var errorId = component.find("typologySP");
		if (document.getElementById('errorIdtypologySP') != null) {
			console.log("errorID . " + errorId);
			$A.util.removeClass(errorId, 'slds-has-error flow_required');
			document.getElementById('errorIdtypologySP').remove();

		}
	},

	redBorderChild : function(component, event, helper) {

		var redBorderChild = component.get("v.redBorderChild");
		var annualRevenueIncoherent = component.get("v.annualRevenueIncoherent");
		var annualNegotiatedIncoherent = component.get("v.annualNegotiatedIncoherent");
		// var myDiv;
		var tipologia = component.get("v.objectDataMap.pv.OB_Typology__c");
		console.log("tipologia = " + tipologia);
		// ***GIOVANNI SPINELLI--29/09/2018 SETTING RED BORDER ON BUTTON SEARCH
		// SERVICE POINT--START
		if (component.get("v.showButtons") == true
				&& (component.get("v.showOtherInput") == false || component
						.get("v.showOtherInput") == undefined)) {
			try {
				var searchButtonSp = component.find("searchButton")
						.getElement();
				searchButtonSp
						.setAttribute(
								'style',
								'background-color: rgb(255, 255, 255)!important;border: 1px solid rgb(221, 219, 218)!important;border-color: rgb(194, 57, 52)!important;  box-shadow: rgb(194, 57, 52) 0 0 0 1px inset!important;background-clip: padding-box!important;');

			} catch (err) {
				console.log('err.message e mail: ' + err.message);
			}
		}
		// ***GIOVANNI SPINELLI--29/09/2018 SETTING RED BORDER ON BUTTON SEARCH
		// SERVICE POINT--END
		console.log("Sono nel red BORDER! " + redBorderChild);
		// GIOVANNI SPINELLI--28/09/2018--GET THE VALUE ONLY IF THE COMPONENT IS
		// ON THE DISPLAY
		var tipologiaId;
		if (component.find("typologySP")) {
			tipologiaId = component.find("typologySP").get("v.value");
		}

		var errorId = component.find("typologySP");

		console.log('tipologiaId ==  ' + tipologiaId);

		if (redBorderChild == true) {

			if (tipologiaId == '') {

				if (errorId.getElement()) {

					console.log("get id is null? "
							+ document.getElementById('errorIdtypologySP')
							+ '   ' + 'input is null? ' + errorId.value);
					if (!(document.getElementById('errorIdtypologySP'))) {

						var myDiv;
						myDiv = document.createElement('div');
						myDiv.setAttribute('id', 'errorIdtypologySP'); // SET AN ID  TO  EVERY  MESSAGE
						myDiv.setAttribute('style',
										'color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
						// SET THE MANDATORY MESSAGE ERROR

						var message = $A.get("$Label.c.MandatoryField");
						var errorMessage = document.createTextNode(message);
						myDiv.appendChild(errorMessage);
						errorId = errorId.getElement();
						errorId.after(myDiv);
						$A.util.addClass(errorId,'slds-has-error flow_required');

					}

				}
			}

		}
	

	},
	// SALVATORE PIANURA - 18/10/2018
	checkValidationAnnRevNeg : function(component, event, helper)
	{
		    var objectDataMap = component.get("v.objectDataMap");

            console.log('setredbord '+objectDataMap.setRedBorderAnnualRevNeg);
       
    
            if(objectDataMap.setRedBorderAnnualRevNeg==true)
            {
                var mapFromNext = {};
                
                mapFromNext = objectDataMap.checkMapValuesAnnRevNeg;
                console.log("map : " + JSON.stringify(mapFromNext));
                for (var keys in mapFromNext)
                {   
                    console.log("the key in open data: " + keys);
                                   
                    var errorId = 'errorId' +keys;
                    var myDiv;
                      
                    myDiv = document.createElement('div');
                    myDiv.setAttribute('id',errorId);//SET AN ID TO EVERY MESSAGE
                    myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
                    myDiv.setAttribute('class' , 'messageError'+keys);
                    var errorMessage = document.createTextNode(mapFromNext[keys]);
                    myDiv.appendChild(errorMessage);

                    var idSet = component.find(keys).getElement();
                    console.log("ID SET : " + idSet + ", input: " + JSON.stringify(component.find(keys)));

                    if(idSet!=null && idSet!= undefined)
					{ 
						if(!(document.getElementById(errorId)) && !(idSet.value))
						{
							console.log("METHOD TO SHOW ONLY A MESSAGE");
							idSet.after(myDiv);
							$A.util.addClass(idSet, 'slds-has-error flow_required');
						}
					}//END FOR
				}
				objectDataMap.setRedBorderAnnualRevNeg = false;
			}
		},
	/* @Andrea Morittu : METODO zipCodeControl (Confrontalo con le tua aggiunte */
	zipcodeControl : function(component, event, helper) {

		var objDMzipCode = component.get("v.objectDataMap.pv.NE__Zip_Code__c");
		console.log("objDMzipCode = " + objDMzipCode);
		var zipcode = component.find("zipcode");
		var zipCodeValue = zipcode.get("v.value");
		// var ecomm = component.find("ecommerce").get("v.checked");
		// var ecommerce = document.getElementById('ecommerce');
		var country = component.find('countrySelection');

		console.log("@@@country is defined? : " + country);

		//if (country) {

			var countryValue = country.get('v.value');
			console.log('@@countryValue  is:' + countryValue);
			// document.getElementById('zipcode').disabled = false;
			// document.getElementById('ecommerce').disabled = false;
			var zipCdMaxLength = document.getElementById('zipcode').maxLength = 5;

			if (component.find("zipcode")) {

				if (zipCodeValue  && (onlyNumber(zipCodeValue) == 'ERROR' || zipCodeValue.length!=5 ) ) 
				{

					// var ecomm = component.find("ecommerce");
					// console.log('@@@ecomm is: ' + ecomm);
					// /* @Andrea Morittu: DISABLE ZIPCODE WHILE ECOMM IS CHECKED */
					// if (ecomm.get("v.checked") != false) {
					// 	var zipcodeValue = component.find('zipcode');
					// 	console.log('zipcodeValue is: ' + zipcodeValue);
					// 	zipcodeValue.set('v.disabled', true);
					// }
					//document.getElementById('ecommerce').disabled = true;
					$A.util.addClass(zipcode, 'slds-has-error flow_required');
					component.set("v.errorCap", true);

					component.set("v.zipCodeErrorMessage",$A.get("$Label.c.OB_InvalidPostalCodeLabel") );
				}
				else
				{
					$A.util.removeClass(zipcode, 'slds-has-error flow_required');
					component.set("v.errorCap", false);
				}
			}
		//}

	},
	//REMOVE RED BORDER OF MANDATORY FIELD FROM MCC INPUT
    removeRedBorderFromMCC: function(component, event, helper) {
		var objectDataMap = component.get("v.objectDataMap");
		//elena.preteni 8/2/19 Hide MCC L1
        // if(objectDataMap.pv.OB_MCC_Description__c){
        //     if(document.getElementById('errorIdmccDescription')!=null){
        //         $A.util.removeClass(document.getElementById('mccDescription') , 'slds-has-error flow_required');
        //         document.getElementById('errorIdmccDescription').remove();
        //     }
		// }
		//elena.preteni 8/2/19 Hide MCC L1
        if(objectDataMap.order.OB_MCC_Description__c)
        {
            if(document.getElementById('errorIdmccDescription2')!=null){
                $A.util.removeClass(document.getElementById('mccDescription2') , 'slds-has-error flow_required');
                document.getElementById('errorIdmccDescription2').remove();
            }
        }
        if(objectDataMap.order2.OB_MCC_Description__c)
        {
            if(document.getElementById('errorIdmccDescription3')!=null){
                $A.util.removeClass(document.getElementById('mccDescription3') , 'slds-has-error flow_required');
                document.getElementById('errorIdmccDescription3').remove();
            }
        }
    },
	retrieveShopSign: function(component, event, helper) {
		var objectDataMap = component.get("v.objectDataMap");
		var servicePointId = objectDataMap.pv.Id;
		
		console.log('servicePointId: ' + servicePointId);
		var actionRetrieveShopSign = component.get("c.getShopSign");
		actionRetrieveShopSign.setParams({servicePointId : servicePointId});
		actionRetrieveShopSign.setCallback(this, function(response) {

			var state = response.getState();
			console.log('state in retrieveShopSign: ' + state);
			if (state === "SUCCESS") {
				
				var response = response.getReturnValue();

				component.set('v.shopSignList' , response);
				component.set( "v.openModalShopSign", true);
				console.log('response: ' + response);
				console.log('shopSignList in retrieveshopSign: ' + component.get('v.shopSignList'));
				if(response.length==0){
					//alert('vuota');
					component.set('v.showMessageShopSign' , true);
				}else{
					//alert('piena');
					component.set('v.showMessageShopSign' , false);
					
				}
			} else if (state === "INCOMPLETE") {
				// do something
			} else if (state === "ERROR") {
				var errors = response.getError();

				if (errors) {

					if (errors[0] && errors[0].message) {
						console.log("Error message: " + errors[0].message);
					}

				} else {
					console.log("Unknown error");
				}

			}
		});
		$A.enqueueAction(actionRetrieveShopSign);
		
	},
	removeRedBorderShopSign : function(component, event, helper) {
		if(component.get('v.openModalShopSign')==false && component.get('v.valueShopSignWithModal'))
		{
			component.set("v.objectDataMap.errorFamily.errorShopSign", false);
			var shopSign = component.get('v.valueShopSignWithModal');
			
			if(shopSign.length>0)
			{
				
				if( document.getElementById('errorIdShopSignWithModal'))
				{
					$A.util.removeClass(document.getElementById('ShopSignWithModal'),'slds-has-error flow_required');
					
					document.getElementById('errorIdShopSignWithModal').remove();
					
				}
				//START gianluigi.virga 02/07/2019 - stop the flow if shopSign is not valid
				if(specialCharacter(shopSign) == 'ERROR'){
					component.set("v.objectDataMap.errorFamily.errorShopSign", true);
				}
				//END gianluigi.virga
			}
			

		}
	},

	/* Doris D.   22/03/2019 ------------- START*/
	openTooltipSP : function (component,event,helper){
			
		component.set("v.showMessageSPtooltip", true);

	},

	

	closeTooltipSP : function (component,event,helper){
		component.set("v.showMessageSPtooltip", false);

	}

	// openTooltipconfirmationSP : function (component,event,helper){
			
	// 	component.set("v.showMessageconfirmationSPtooltip", true);

	// },CIAO
	
	// close_1 : function (component,event,helper){
	// 	component.set("v.showMessageSP", false);
	
	// },
	/*  Doris D. 22/02/2019..................... END */	

})