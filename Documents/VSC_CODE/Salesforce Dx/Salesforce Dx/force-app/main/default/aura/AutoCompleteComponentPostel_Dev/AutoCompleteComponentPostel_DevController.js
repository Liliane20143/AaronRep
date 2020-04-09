({ 
	 doInit: function(component, event , helper){
	 	console.log('INSIDE DO INIT');
	 	
		String.prototype.replaceAll = function(search, replacement) {
		    var target = this;
		    return target.replace(new RegExp(search, 'g'), replacement);
		};
		var objectDataMap = component.get("v.objectDataMap");
		var addressMapping = component.get("v.addressMapping");
		var isPV = component.get("v.addressMapping.isPV");
		var lovType = 'COUNTRY';
		var lovOrderBy = 'Name';
		var mapLabelColumns = 'NE__Value1__c||'+$A.get("$Label.c.Country_Code")+',Name||'+$A.get("$Label.c.Country");
		var lovSourceField = (addressMapping.countryinputfield)+'||Name,'+(addressMapping.countrycodeinputfield)+'||NE__Value1__c';
	  
		console.log('v.addressMapping.isComplete'+addressMapping.isComplete);
		 console.log('function do Init of AutoCompletePostel');
		console.log('AddressMapping: '+JSON.stringify(addressMapping));
		var countryinputobject = component.get("v.addressMapping.countryinputobject");
		var countryinputfield = component.get("v.addressMapping.countryinputfield");
		var countrycodeinputobject = component.get("v.addressMapping.countrycodeinputobject");
		var countrycodeinputfield = component.get("v.addressMapping.countrycodeinputfield");
		var pressoinputobject = component.get("v.addressMapping.pressoinputobject");
		var pressoinputfield = component.get("v.addressMapping.pressoinputfield");
		var zipcodeinputobject = component.get("v.addressMapping.zipcodeinputobject");
		var zipcodeinputfield = component.get("v.addressMapping.zipcodeinputfield");
		var sectionName = component.get("v.addressMapping.sectionName");
		 if(sectionName == undefined || sectionName == null)
			sectionName='';
		console.log('countryinputobject : ' + countryinputobject + ' countryinputfield: ' + countryinputfield);
		console.log('countrycodeinputobject : ' + countrycodeinputobject + ' countrycodeinputfield: ' + countrycodeinputfield);
		console.log('pressoinputobject : ' + pressoinputobject + ' pressoinputfield: ' + pressoinputfield);
	   var objectDataMaptemp = component.get("v.objectDataMap");
	   var countryinput=null;
	   var countrycodeinput=null;
	   var pressoinput=null;
	   var zipcodeinput =null;
	   
	   if(zipcodeinputobject != null && zipcodeinputobject != undefined && zipcodeinputfield != undefined && zipcodeinputfield != null) 
			zipcodeinput = objectDataMaptemp[zipcodeinputobject][zipcodeinputfield];
	   if(countryinputobject != null && countryinputobject != undefined && countryinputfield != undefined && countryinputfield != null)
		   countryinput = objectDataMaptemp[countryinputobject][countryinputfield];
	   if(countrycodeinputobject != null && countrycodeinputobject != undefined && countrycodeinputfield != undefined && countrycodeinputfield != null)
		   countrycodeinput = objectDataMaptemp[countrycodeinputobject][countrycodeinputfield]; 
	   if(pressoinputobject != null && pressoinputobject != undefined && pressoinputfield != undefined && pressoinputfield != null)
		   pressoinput = objectDataMaptemp[pressoinputobject][pressoinputfield];  
	   console.log('countryinput: '+countryinput);
	   var pressoId = null;
	   var zipCodeEEId = null;
	   if(sectionName){
			pressoId = 'presso'+sectionName;
			component.set("v.pressoId", pressoId);
			zipCodeEEId = 'zipcodeEE'+sectionName;
			component.set("v.zipCodeEEId",zipCodeEEId);
	   }
	   if(countryinput == undefined || countryinput == null || countryinput == '' || countryinput == 'ITALIA'){
		   countryinput='ITALIA';
		   countrycodeinput= 'ITA';
		   component.set("v.objectDataMap."+ countryinputobject + "." + countryinputfield ,  'ITALIA' );
		   component.set("v.objectDataMap."+ countrycodeinputobject + "." + countrycodeinputfield ,  'ITA' );
		} else {
			//component.find("buttonCountry").set("v.disabled", true);
		}
		if(isPV != 'true'){
			if(countryinput != 'ITALIA'){
				component.set("v.isEE",true); 
				addressMapping.provincedisabled = 'false';
				addressMapping.citydisabled = 'false';
				addressMapping.districtdisabled = 'false';
				addressMapping.streetdisabled = 'false';
				addressMapping.streetnumberdisabled = 'false';
				component.set("v.addressMapping", addressMapping);
			}   
			else {
				component.set("v.isEE",false);
				addressMapping.provincedisabled = 'false';
				addressMapping.citydisabled = 'true';
				addressMapping.districtdisabled = 'true';
				addressMapping.streetdisabled = 'true';
				addressMapping.streetnumberdisabled = 'true';
				component.set("v.addressMapping", addressMapping);
			}
		}
		console.log('AddressMapping dopo set: '+JSON.stringify(addressMapping));
		if(countryinput != 'ITALIA'){
			component.set("v.isEE",true); 
			component.set("v.addressMapping.zipcodedisabled",'true');
			component.set("v.addressMapping.provincedisabled",'true');
		}else {
			component.set("v.isEE",false);
		}
		// var city = component.get("v.objectDataMap");
		console.log('objectDataMap : ' + JSON.stringify(objectDataMaptemp));
		component.set("v.countryString", countryinput);
		component.set("v.countryCodeString", countrycodeinput);
		component.set("v.detailString", pressoinput);
		component.set("v.zipcodeString", zipcodeinput);
		if($A.util.isUndefinedOrNull(component.get("v.objectDataMap"))){
			console.log('objectDataMap mancante')
			return null;
		}
		//	SET OBJECTSTRING
		component.set("v.objectString", countryinputobject);
		//Set input Field
		component.set("v.inputField", '');
		//Set Type
		component.set("v.type", lovType);
		//Set lov Source Field 
		var resultMapTargetSource = lovSourceField.split(',');
		console.log(resultMapTargetSource);
		var objTarget = {};
		for (var i=0;i<resultMapTargetSource.length;i++)
		{
			var resultTarget = resultMapTargetSource[i].split('||');
			for (var j=0;j<resultTarget.length;j++)
			{
				objTarget[resultTarget[0]] = resultTarget[1];
			}
		}
		console.log(JSON.stringify(objTarget));	
		component.set("v.mapOfSourceFieldTargetField",objTarget);
		//Set Order By on Modal
		component.set("v.orderBy", lovOrderBy);
		//Set Map Label Colums
		var resultMapLabelCol = mapLabelColumns.split(',');
		console.log(resultMapLabelCol);
		var objColumns = {};
		for (var i=0;i<resultMapLabelCol.length;i++)
		{
			var resultCol = resultMapLabelCol[i].split('||');
			for (var j=0;j<resultCol.length;j++)
			{
				objColumns[resultCol[0]] = resultCol[1];
			}
		}
		console.log(JSON.stringify(objColumns));
		
		component.set("v.mapLabelColumns",objColumns);
		var isComUser = component.get("v.objectDataMap.isCommunityUser");
		console.log('isComUser'+isComUser);
		var countriesVar = [];
		countriesVar.push('ITALIA');
		if(isComUser == false){
			countriesVar.push('SAN MARINO');
		}
		component.set('v.countries',countriesVar);
		console.log('AddressMapping dopo set  set: '+JSON.stringify(addressMapping));
	 
		
		var capsInit = component.get("v.caps");
		if(zipcodeinput != undefined && zipcodeinput != null && zipcodeinput != '' && capsInit != undefined){
			capsInit.push(zipcodeinput);
			component.set("v.caps",capsInit);
		}
		
		component.set('v.objectDataMap.isLegalEqualAdm',false);
	 },
	 
	
	openModal: function(component, event, helper) {
		component.set("v.spinner", true); 
		helper.createComponentModal(component, event);
	}, 	
	handleEvent : function(component, event, helper) {
		var value  = event.getParam("province");
		var value2 = event.getParam("comune");
		var value3 = event.getParam("frazione");
		var value4 = event.getParam("caps");
		var value5 = event.getParam("isDisabled");
		component.set("v.province" , value );
		component.set("v.comune"   , value2);
		component.set("v.frazione" , value3);
		component.set("v.caps" , value4);
		component.set("v.isDisabled" , value5);
		console.log("the cap is: " + component.get("v.isDisabled"));

	  
	},
	//****METHOD TO SET POSTAL CODE INTO OBJDATAMP****//
	setPostalCode: function(component, event, helper) {
	 console.log("dentro on change");
	 
	 var sectionName = component.get("v.addressMapping.sectionName");
	 if(sectionName == undefined || sectionName == null)
		sectionName='';
	  var zipcodeinputobject = component.get("v.addressMapping.zipcodeinputobject");
		var zipcodeinputfield = component.get("v.addressMapping.zipcodeinputfield");
	 var objectDataMap = component.get("v.objectDataMap");
	 if(component.find("zipcode") != undefined && component.find("zipcode") != null)
		 objectDataMap[zipcodeinputobject][zipcodeinputfield]   = component.find("zipcode").get("v.value"); 
	 else 
		  objectDataMap[zipcodeinputobject][zipcodeinputfield]   = document.getElementById("zipcodeEE"+sectionName).value;
	 console.log("set NE__Postal_Code__c into objdatamap: " + objectDataMap[zipcodeinputobject][zipcodeinputfield]);
		
	 if(document.getElementById('zipcodeEE'+sectionName)){
			var zipCodeEE = document.getElementById("zipcodeEE"+sectionName).value;
			var regex = new RegExp("^[a-zA-Z0-9()?!&% $£  =^ °\/\"\.\']+$","g");
			zipCodeEE = zipCodeEE.replaceAll(/\\/,'0');
			if(zipCodeEE && !regex.test(zipCodeEE)){ 
				console.log('inside error');
				var errorId = 'errorIdzipcodeEE'+sectionName;
				var myDiv;
				
				myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorId);//SET AN ID TO EVERY MESSAGE
				myDiv.setAttribute('style','color:rgb(194, 57, 52); position: absolute; z-index: 1;');
				myDiv.setAttribute('class' , 'messageErrorzipcodeEE'+sectionName);
				//SET THE MESSAGE
				var errorMessage = document.createTextNode($A.get("$Label.c.errorSpecialCharacter"));
				myDiv.appendChild(errorMessage);
	
				var idSet = document.getElementById('zipcodeEE'+sectionName);
				console.log('idSet:: '+idSet);
				if(idSet!=null && idSet!= undefined)
				{ 
					if(!(document.getElementById(errorId)))
					{
						console.log("METHOD TO SHOW ONLY A MESSAGE");
						idSet.after(myDiv);
						$A.util.addClass(idSet, 'slds-has-error flow_required');
						//idSet.className="slds-has-error flow_required";
					}
				}//END FOR
				component.set("v.objectDataMap.errorEEMap.isErrorEEZip"+sectionName, true);
				
			} else {
				helper.removeRedBorderZipCodeEE(component, event , helper);
				component.set("v.objectDataMap.errorEEMap.isErrorEEZip"+sectionName, false);
			}
		}
	},
	
	blankMethodCaps : function(component,event,helper){
		console.log("blankmethod"+component.get("v.addressMapping.zipcodedisabled"));
		var params = event.getParam('arguments');
		component.set("v.caps" , params.caps);
		if(component.find("buttonCountry"))
			component.find("buttonCountry").set("v.disabled", false);
		console.log('provincestring'+component.get("v.provinceString"));
	},
	reInitAll : function(component,event,helper){
		console.log("reInitAll");
		var autoProv= component.find("provinceComponent");
		var autoComune= component.find("comuneComponent");
		var autoDist= component.find("districtComponent");
		var autoStreet= component.find("addressComponent"); 
		var a = component.get('c.doInit');
		$A.enqueueAction(a);
		if(autoProv)
			autoProv.reInit();
		if(autoComune)
			autoComune.reInit();
		if(autoDist)
			autoDist.reInit();
		if(autoStreet)
			autoStreet.reInit();
		var countrySel = component.get("v.countryString");
		if(countrySel != 'ITALIA')
			component.set("v.isEE",true);    
		else 
			component.set("v.isEE",false);
	},
	handleShowModalEvent : function(component, event, helper) {
		var zipcodeinputobject = component.get("v.addressMapping.zipcodeinputobject");
		var zipcodeinputfield = component.get("v.addressMapping.zipcodeinputfield");
		console.log("INTO HANDLE SHOW EVENT");
		var sectionName = component.get("v.addressMapping.sectionName");
		 if(sectionName == undefined || sectionName == null)
			sectionName='';
		var objectDataMap = event.getParam("objectDataMap");
		var addressMapping = component.get("v.addressMapping");
		var countryinputobject = component.get("v.addressMapping.countryinputobject");
		var countryinputfield = component.get("v.addressMapping.countryinputfield");
		console.log("handleShowModalEvent event.getParam: " + JSON.stringify(objectDataMap));
		component.set("v.objectDataMap", objectDataMap);
		component.set("v.countryString", objectDataMap[countryinputobject][countryinputfield]);
		console.log('Test inputFiled: '+ component.get("v.countryString")); 
		console.log('changecountry');
		console.log('country selected'+component.get("v.countryString"));
		var countrySel = component.get("v.countryString");
		if(countrySel != 'ITALIA'){
			component.set("v.isEE",true); 
			addressMapping.provincedisabled = 'true';
			addressMapping.citydisabled = 'false';
			addressMapping.districtdisabled = 'false';
			addressMapping.streetdisabled = 'false';
			addressMapping.streetnumberdisabled = 'false';
			component.set("v.addressMapping", addressMapping);
		}   
		else {
			component.set("v.isEE",false);
			addressMapping.provincedisabled = 'false';
			addressMapping.citydisabled = 'true';
			addressMapping.districtdisabled = 'true';
			addressMapping.streetdisabled = 'true';
			addressMapping.streetnumberdisabled = 'true';
			component.set("v.addressMapping", addressMapping);
		}
		console.log("setBlank");
		var autoProv= component.find("provinceComponent");
		var autoComune= component.find("comuneComponent");
		var autoDist= component.find("districtComponent");
		var autoStreet= component.find("addressComponent"); 
		if(autoProv)
			autoProv.blankValue();
		if(autoComune)
			autoComune.blankValue();
		if(autoDist)
			autoDist.blankValue();
		if(autoStreet)
			autoStreet.blankValue();
		if(countrySel == 'ITALIA'){	
			component.set("v.objectDataMap."+ zipcodeinputobject + "." + zipcodeinputfield ,  '' );
			component.set("v.zipcodeString",'');
		} else {
			component.set("v.objectDataMap."+ zipcodeinputobject + "." + zipcodeinputfield ,  '99999' );
			component.set("v.zipcodeString",'99999');
			component.set("v.addressMapping.zipcodedisabled",'true');
		}
		component.set("v.caps",[]);
	}, 
	changeCountry : function(component, event, helper) {
		var zipcodeinputobject = component.get("v.addressMapping.zipcodeinputobject");
		var zipcodeinputfield = component.get("v.addressMapping.zipcodeinputfield");
		var sectionName = component.get("v.addressMapping.sectionName");
		if(sectionName == undefined || sectionName == null)
		  sectionName='';
		var addressMapping = component.get("v.addressMapping");
		var countryinputobject = component.get("v.addressMapping.countryinputobject");
		var countryinputfield = component.get("v.addressMapping.countryinputfield");
		var countrycodeinputobject = component.get("v.addressMapping.countrycodeinputobject");
		var countrycodeinputfield = component.get("v.addressMapping.countrycodeinputfield");
		console.log('country selected'+component.get("v.countryString"));
		var countrySel = component.get("v.countryString");
		var countryCodeSel = component.get("v.countryCodeString");
		component.set("v.objectDataMap."+ countryinputobject + "." + countryinputfield ,  countrySel );
		component.set("v.objectDataMap."+ countrycodeinputobject + "." + countrycodeinputfield ,  countryCodeSel );
		if(countrySel != 'ITALIA'){
			component.set("v.isEE",true); 
			addressMapping.provincedisabled = 'true';
			addressMapping.citydisabled = 'false';
			addressMapping.districtdisabled = 'false';
			addressMapping.streetdisabled = 'false';
			addressMapping.streetnumberdisabled = 'false';
			component.set("v.addressMapping", addressMapping);
		}   
		else {
			component.set("v.isEE",false);
			addressMapping.provincedisabled = 'false';
			addressMapping.citydisabled = 'true';
			addressMapping.districtdisabled = 'true';
			addressMapping.streetdisabled = 'true';
			addressMapping.streetnumberdisabled = 'true';
			component.set("v.addressMapping", addressMapping);
		}
		
		var labels = document.getElementsByTagName('div');
		for (var i = 0; i < labels.length; i++) {
			console.log('errorIdFor'+JSON.stringify(labels[i]) +'   '+JSON.stringify(labels[i].id));  
			if (labels[i].id.indexOf('errorId') == 0 && labels[i].id.includes(sectionName)) {
				 if (labels[i].id.includes('provincia'))
					labels[i].remove();    
				 else if (labels[i].id.includes('comune'))
					labels[i].remove(); 
				 else if (labels[i].id.includes('strada'))
					labels[i].remove();
				 else if (labels[i].id.includes('civico'))
					labels[i].remove();
				 else if (labels[i].id.includes('provinceEE'))
					labels[i].remove();
				 else if (labels[i].id.includes('cityEE'))
					labels[i].remove();  
				 else if (labels[i].id.includes('streetEE'))
					labels[i].remove();
				 else if (labels[i].id.includes('civicoEE'))
					labels[i].remove(); 
			}
		}
		console.log("setBlank");
		var autoProv= component.find("provinceComponent");
		var autoComune= component.find("comuneComponent");
		var autoDist= component.find("districtComponent");
		var autoStreet= component.find("addressComponent"); 
		if(autoProv)
			autoProv.blankValue();
		if(autoComune)
			autoComune.blankValue();
		if(autoDist)
			autoDist.blankValue();
		if(autoStreet)
			autoStreet.blankValue();
		if(countrySel == 'ITALIA'){	
			component.set("v.objectDataMap."+ zipcodeinputobject + "." + zipcodeinputfield ,  '' );
			component.set("v.zipcodeString",'');
		} else {
			component.set("v.objectDataMap."+ zipcodeinputobject + "." + zipcodeinputfield ,  '99999' );
			component.set("v.zipcodeString",'99999');
			component.set("v.addressMapping.zipcodedisabled",'true');
		}
		component.set("v.caps",[]);
		
	},
	setRedBorderCompanyData : function(component, event, helper) {
		var mapFromNext = {};
		var objectDataMap = component.get("v.objectDataMap");
		console.log('setredbord'+objectDataMap.setRedBordercompanyData);
		if(objectDataMap.setRedBordercompanyData == true){
			mapFromNext = component.get("v.objectDataMap.checkMapValues");
			console.log("mandatory field from map: " + JSON.stringify(mapFromNext));
			
				console.log("INTO IF METHOD OF TRUE BOOLEAN");
				for (var keys in mapFromNext)
				{
	
					var errorId = 'errorId' +keys;
					console.log("key  = " + keys);
					
					var myDiv;
					
					myDiv = document.createElement('div');
					myDiv.setAttribute('id',errorId);//SET AN ID TO EVERY MESSAGE
					myDiv.setAttribute('aura:id',errorId);
					myDiv.setAttribute('style','color:rgb(194, 57, 52); position: absolute; z-index: 1;');
					myDiv.setAttribute('class' , 'messageError'+keys);
					//SET THE MESSAGE
					var errorMessage = document.createTextNode(mapFromNext[keys]);
					myDiv.appendChild(errorMessage);
	
					var idSet = document.getElementById(keys);
					console.log("ID SET : " + idSet + ", input: " + component.find(keys));
					//CONTROL TO CATCH THE AURA ID IN LIGHTNING:SELECT 
					//THIS METHOD STARTS WHEN ON DISPLAY THERE ARE THE INPUTS TO EXAMINE
					if($A.util.isUndefinedOrNull(idSet) && !$A.util.isUndefinedOrNull(component.find(keys))){
						idSet = component.find(keys).getElement();
					 } else if($A.util.isUndefinedOrNull(idSet)){
					   idSet = document.getElementsByName(keys)[0];
					}
					if(idSet!=null && idSet!= undefined)
					{ 
						if(!(document.getElementById(errorId)) && !(idSet.value))
						{
							console.log("METHOD TO SHOW ONLY A MESSAGE");
							idSet.after(myDiv);
							$A.util.addClass(idSet, 'slds-has-error flow_required');
							//idSet.className="slds-has-error flow_required";
						}
					}//END FOR
			}
			objectDataMap.setRedBordercompanyData = false;
			objectDataMap.setRedBordercompanyDataDoc = true;
			console.log("boolean value after: " + component.get("v.objectDataMap.setRedBordercompanyData" ));
			}
	},
	getValuePresso : function(component, event, helper) {
		var sectionName = component.get("v.addressMapping.sectionName");
		if(sectionName == undefined || sectionName == null)
		  sectionName='';
		var pressoinputobject = component.get("v.addressMapping.pressoinputobject");
		var pressoinputfield = component.get("v.addressMapping.pressoinputfield");
		var presso = document.getElementById("presso"+sectionName).value;
		component.set("v.objectDataMap."+ pressoinputobject + "." + pressoinputfield ,  presso );
		console.log("il presso è: " + presso);
		
		if(document.getElementById('presso'+sectionName)){
			var regex = new RegExp("^[a-zA-Z0-9()?!&% $£  =^ °\/\"\.\']+$","g");
			presso = presso.replaceAll(/\\/,'0');
			if(presso && !regex.test(presso)){ 
				console.log('inside error');
				var errorId = 'errorIdpresso'+sectionName;
				var myDiv;
				
				myDiv = document.createElement('div');
				myDiv.setAttribute('id',errorId);//SET AN ID TO EVERY MESSAGE
				myDiv.setAttribute('style','color:rgb(194, 57, 52); position: absolute;  z-index: 1;');
				myDiv.setAttribute('class' , 'messageErrorpresso'+sectionName);
				//SET THE MESSAGE
				var errorMessage = document.createTextNode($A.get("$Label.c.errorSpecialCharacter"));
				myDiv.appendChild(errorMessage);
	
				var idSet = document.getElementById('presso'+sectionName);
				console.log('idSet:: '+idSet);
				if(idSet!=null && idSet!= undefined)
				{ 
					if(!(document.getElementById(errorId)))
					{
						console.log("METHOD TO SHOW ONLY A MESSAGE");
						idSet.after(myDiv);
						$A.util.addClass(idSet, 'slds-has-error flow_required');
						//idSet.className="slds-has-error flow_required";
					}
				}//END FOR
				component.set("v.objectDataMap.errorEEMap.isErrorEEpresso"+sectionName, true);
				
			} else {
				helper.removeRedBorderPresso(component, event , helper);
				component.set("v.objectDataMap.errorEEMap.isErrorEEpresso"+sectionName, false);
			}
		}
	},
	aggiornaForm: function(component, event, helper) {
	//	console.log('capConcat: '+component.get("v.objectDataMap.capConcat"));
		if(component.get("v.objectDataMap.capConcat")!=undefined && component.get("v.objectDataMap.capConcat")!=null && component.get("v.objectDataMap.capConcat")!=''){
			console.log('aggiorna form');
			var cap = [];
			console.log('component.get("v.caps")'+component.get("v.caps"));
			cap = component.get("v.objectDataMap.capConcat").split('_');
			console.log('cap splittited:'+cap);
			component.set("v.caps",cap);
			console.log('after set'+component.get("v.caps"));
		}
		var fiscalcodeinputobject = component.get("v.addressMapping.fiscalcodeinputobject");
		var input = document.getElementById('input:'+fiscalcodeinputobject+':OB_Fiscal_Code__c');
		if(input!=undefined && input!=null){
			console.log('input not empty'+JSON.stringify(input.value));
			if(input.value){
				//
				input.setAttribute('style','text-transform:uppercase');
				input.value=input.value.toUpperCase();
				console.log('input after uppercase'+JSON.stringify(input.value));
			}
		}
	},
	changeCheckbox: function(component, event, helper) {
		var isEqual = event.getSource().getElement().checked;
		if(isEqual == true){
		
			component.set('v.objectDataMap.isLegalEqualAdm',true);
		} else {
			component.set('v.objectDataMap.isLegalEqualAdm',false);
		}
		
		
		
	}
})