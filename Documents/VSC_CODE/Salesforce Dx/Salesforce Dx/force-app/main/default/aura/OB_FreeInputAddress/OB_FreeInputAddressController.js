({
    doInit : function(component, event, helper) {
		var objectDataMap = component.get("v.objectDataMap");
		var addressMapping = component.get("v.addressMapping");
		var isPV = component.get("v.addressMapping.isPV");
		var lovType = 'COUNTRY';
		var lovOrderBy = 'Name';
		var mapLabelColumns = 'NE__Value1__c||'+$A.get("$Label.c.Country_Code")+',Name||'+$A.get("$Label.c.Country");
		var lovSourceField = (addressMapping.countryinputfield)+'||Name,'+(addressMapping.countrycodeinputfield)+'||NE__Value1__c';
		console.log('v.addressMapping.isComplete'+addressMapping.isComplete);
		console.log('AddressMapping: '+JSON.stringify(addressMapping));
		var countryinputobject = component.get("v.addressMapping.countryinputobject");
		var countryinputfield = component.get("v.addressMapping.countryinputfield");
		var countrycodeinputobject = component.get("v.addressMapping.countrycodeinputobject");
		var countrycodeinputfield = component.get("v.addressMapping.countrycodeinputfield");
		var pressoinputobject = component.get("v.addressMapping.pressoinputobject");
		var pressoinputfield = component.get("v.addressMapping.pressoinputfield");
		var zipcodeinputobject = component.get("v.addressMapping.zipcodeinputobject");
		var zipcodeinputfield = component.get("v.addressMapping.zipcodeinputfield");
		//OTHER FIELD
		var provinceinputobject = component.get("v.addressMapping.provinceinputobject");
		var provinceinputfield = component.get("v.addressMapping.provinceinputfield");
		var provincecodeinputobject = component.get("v.addressMapping.provincecodeinputobject");
		var provincecodeinputfield = component.get("v.addressMapping.provincecodeinputfield");
		var cityinputobject = component.get("v.addressMapping.cityinputobject");
		var cityinputfield = component.get("v.addressMapping.cityinputfield");
		var districtinputobject = component.get("v.addressMapping.districtinputobject");
		var districtinputfield = component.get("v.addressMapping.districtinputfield");
		var streetinputobject = component.get("v.addressMapping.streetinputobject");
		var streetinputfield = component.get("v.addressMapping.streetinputfield");
		var streetnumberinputobject = component.get("v.addressMapping.streetnumberinputobject");
		var streetnumberinputfield = component.get("v.addressMapping.streetnumberinputfield");

		var sectionName = component.get("v.addressMapping.sectionName");
		 if($A.util.isUndefinedOrNull(sectionName))
			sectionName='';
		console.log('countryinputobject : ' + countryinputobject + ' countryinputfield: ' + countryinputfield);
		console.log('countrycodeinputobject : ' + countrycodeinputobject + ' countrycodeinputfield: ' + countrycodeinputfield);
		console.log('pressoinputobject : ' + pressoinputobject + ' pressoinputfield: ' + pressoinputfield);
	   var objectDataMaptemp = component.get("v.objectDataMap");
	   var countryinput=null;
	   var countrycodeinput=null;
	   var pressoinput=null;
	   var zipcodeinput =null;
	   // Other
	   var provinceinput = null;
	   var provincecodeinput = null;
	   var cityinput = null;
	   var streetinput = null;
	   var streetnumberinput = null;
	   var districtinput = null;
	   
	   if(!$A.util.isEmpty(zipcodeinputobject) && !$A.util.isEmpty(zipcodeinputfield)) 
			zipcodeinput = objectDataMaptemp[zipcodeinputobject][zipcodeinputfield];
	   if(!$A.util.isEmpty(countryinputobject) && !$A.util.isEmpty(countryinputfield))
		   countryinput = objectDataMaptemp[countryinputobject][countryinputfield];
	   if(!$A.util.isEmpty(countrycodeinputobject) && !$A.util.isEmpty(countrycodeinputfield))
		   countrycodeinput = objectDataMaptemp[countrycodeinputobject][countrycodeinputfield]; 
	   if(!$A.util.isEmpty(pressoinputobject) && !$A.util.isEmpty(pressoinputfield))
		   pressoinput = objectDataMaptemp[pressoinputobject][pressoinputfield];  
		//OTHER
		if(!$A.util.isEmpty(provinceinputobject) && !$A.util.isEmpty(provinceinputfield))
			provinceinput = objectDataMaptemp[provinceinputobject][provinceinputfield];  
		if(!$A.util.isEmpty(provincecodeinputobject) && !$A.util.isEmpty(provincecodeinputfield))
			provincecodeinput = objectDataMaptemp[provincecodeinputobject][provincecodeinputfield];  
		if(!$A.util.isEmpty(cityinputobject) && !$A.util.isEmpty(cityinputfield))
			cityinput = objectDataMaptemp[cityinputobject][cityinputfield];  
		if(!$A.util.isEmpty(districtinputobject) && !$A.util.isEmpty(districtinputfield))
			districtinput = objectDataMaptemp[districtinputobject][districtinputfield];  
		if(!$A.util.isEmpty(streetinputobject) && !$A.util.isEmpty(streetinputfield))
			streetinput = objectDataMaptemp[streetinputobject][streetinputfield];  
		if(!$A.util.isEmpty(streetnumberinputobject) && !$A.util.isEmpty(streetnumberinputfield))
			streetnumberinput = objectDataMaptemp[streetnumberinputobject][streetnumberinputfield];  
	   console.log('countryinput: '+countryinput);
	   var pressoId = null;
	   var zipCodeEEId = null;
	   var provinceEEId = null;
	   var cityEEId = null;
	   var stradaEEId = null;
	   var civicoEEId = null;
	   var districtEEId = null;
	   var provinceCodeEEId = null;
	   if(sectionName){
		   //presso
			pressoId = 'presso'+sectionName;
			component.set("v.pressoId", pressoId);
			//zip
			zipCodeEEId = 'zipcode'+sectionName; 
			component.set("v.zipCodeEEId",zipCodeEEId);
			//province
			provinceEEId = 'provincia'+sectionName;
			component.set("v.provinceEEId", provinceEEId);
			//provinceCode
			provinceCodeEEId = 'sigla'+sectionName;
			component.set("v.provinceCodeEEId", provinceCodeEEId);
			//city
			cityEEId = 'comune'+sectionName;
			component.set("v.cityEEId", cityEEId);
			//street
			stradaEEId = 'strada'+sectionName;
			component.set("v.stradaEEId", stradaEEId);
			//number
			civicoEEId = 'civico'+sectionName;
			component.set("v.civicoEEId", civicoEEId);
			//district
			districtEEId = 'frazione'+sectionName;
			component.set("v.districtEEId", districtEEId);
	   }
	   if($A.util.isUndefinedOrNull(countryinput) || countryinput == '' || countryinput == 'ITALIA'){
		   countryinput='ITALIA';
		   countrycodeinput= 'ITA';
		   component.set("v.objectDataMap."+ countryinputobject + "." + countryinputfield ,  'ITALIA' );
		   component.set("v.objectDataMap."+ countrycodeinputobject + "." + countrycodeinputfield ,  'ITA' );
		   component.set("v.isEE", false );
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
				addressMapping.streetnumberdisabled = 'false';
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
			component.set("v.addressMapping.zipcodedisabled",'false');
		}
		console.log('objectDataMap : ' + JSON.stringify(objectDataMaptemp));
		component.set("v.countryString", countryinput);
		component.set("v.countryCodeString", countrycodeinput);
		component.set("v.detailString", pressoinput);
		component.set("v.zipcodeString", zipcodeinput);
		//TO SET OTHER FIELD
		component.set("v.provinceString", provinceinput);
		component.set("v.provinceCodeString", provincecodeinput);
		component.set("v.cityString", cityinput);
		component.set("v.districtString", districtinput);
		component.set("v.streetString", streetinput);
		component.set("v.streetNumberString", streetnumberinput);

		if($A.util.isUndefinedOrNull(component.get("v.objectDataMap"))){
			console.log('objectDataMap mancante')
			return null;
		}
		//	SET OBJECTSTRING
		component.set("v.objectString", countryinputobject);
		//  Set input Field
		component.set("v.inputField", '');
		//  Set Type
		component.set("v.type", lovType);
		//  Set lov Source Field 
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
		if(!$A.util.isEmpty(zipcodeinput) && !$A.util.isUndefined(capsInit)){
			capsInit.push(zipcodeinput);
			component.set("v.caps",capsInit);
		}
		component.set("v.objectDataMap.isLegalEqualAdm",true);
	 },
    showModal : function (component,event,helper){
        component.set("v.showAddressModal", true);
    },
    disablePostel : function (component,event,helper){
		//set postel input with a blanks values
		var activePostel = component.get("v.isPostelDisabled");
		if(activePostel != true){
			var autoCompleteCmp = component.find("AutoCompleteComponentPostel");
			if (autoCompleteCmp) {
				autoCompleteCmp.reInitAll();
				var caps = [];
				autoCompleteCmp.blankMethod(caps);
			}
		}
        component.set("v.showAddressModal", false);
		component.set("v.isPostelDisabled", true);
		//set address fields on objectdatamap with blanks values
		var sectionName = component.get("v.addressMapping.sectionName");
		if($A.util.isUndefinedOrNull(sectionName))
			sectionName='';
		//country always ITA
		component.set("v.countryString", 'ITALIA');
		component.set("v.countryCodeString", 'ITA');
		component.set("v.isEE", false );
		var countryinputobject = component.get("v.addressMapping.countryinputobject");
		var countryinputfield = component.get("v.addressMapping.countryinputfield");
		var countrycodeinputobject = component.get("v.addressMapping.countrycodeinputobject");
		var countrycodeinputfield = component.get("v.addressMapping.countrycodeinputfield");
		component.set("v.objectDataMap."+ countryinputobject + "." + countryinputfield ,  'ITALIA' );
		component.set("v.objectDataMap."+ countrycodeinputobject + "." + countrycodeinputfield ,  'ITA' );

		//city
		var cityinputobject = component.get("v.addressMapping.cityinputobject");
		var cityinputfield = component.get("v.addressMapping.cityinputfield");
		component.set("v.cityString", '');
		component.set("v.objectDataMap."+ cityinputobject + "." + cityinputfield ,  '' );
		//province
        var provinceinputobject = component.get("v.addressMapping.provinceinputobject");
		var provinceinputfield = component.get("v.addressMapping.provinceinputfield");
		component.set("v.provinceString", '');
		component.set("v.objectDataMap."+ provinceinputobject + "." + provinceinputfield ,  '' );
		//province code
		var provincecodeinputobject = component.get("v.addressMapping.provincecodeinputobject");
        var provincecodeinputfield = component.get("v.addressMapping.provincecodeinputfield");
		component.set("v.provinceCodeString", '');
		component.set("v.objectDataMap."+ provincecodeinputobject + "." + provincecodeinputfield ,  '' );
		//street
		var streetinputobject = component.get("v.addressMapping.streetinputobject");
		var streetinputfield = component.get("v.addressMapping.streetinputfield");
		component.set("v.streetString", '');
		component.set("v.objectDataMap."+ streetinputobject + "." + streetinputfield ,  '' );
		//number
		var streetnumberinputobject = component.get("v.addressMapping.streetnumberinputobject");
		var streetnumberinputfield = component.get("v.addressMapping.streetnumberinputfield");
		component.set("v.streetNumberString", '');
		component.set("v.objectDataMap."+ streetnumberinputobject + "." + streetnumberinputfield ,  '' );
		//district
		var districtinputobject = component.get("v.addressMapping.districtinputobject");
		var districtinputfield = component.get("v.addressMapping.districtinputfield");
		component.set("v.districtString", '');
		component.set("v.objectDataMap."+ districtinputobject + "." + districtinputfield ,  '' );
		//presso
		var pressoinputobject = component.get("v.addressMapping.pressoinputobject");
		var pressoinputfield = component.get("v.addressMapping.pressoinputfield");
		component.set("v.detailString", '');
		component.set("v.objectDataMap."+ pressoinputobject + "." + pressoinputfield ,  '' );
		//ZIPCODE
		var zipcodeinputobject = component.get("v.addressMapping.zipcodeinputobject");
		var zipcodeinputfield = component.get("v.addressMapping.zipcodeinputfield");
		component.set("v.zipcodeString", '');
		component.set("v.objectDataMap."+ zipcodeinputobject+ "." +zipcodeinputfield, '');
		if(sectionName == 'sedeAmministrativa'){
			component.set("v.isEqualsAddress", false);
			component.set("v.objectDataMap.isLegalEqualAdm", false);
		}
    },
    cancel : function (component,event,helper){
        component.set("v.showAddressModal", false);
    },
    activatePostel : function (component,event,helper){
		component.set("v.isPostelDisabled", false);
		///set address fields on objectdatamap and free input fields with blanks values
		var sectionName = component.get("v.addressMapping.sectionName");
		if($A.util.isUndefinedOrNull(sectionName))
			sectionName='';
		//country always ITA
		component.set("v.countryString", 'ITALIA');
		component.set("v.countryCodeString", 'ITA');
		component.set("v.isEE", false );
		var countryinputobject = component.get("v.addressMapping.countryinputobject");
		var countryinputfield = component.get("v.addressMapping.countryinputfield");
		var countrycodeinputobject = component.get("v.addressMapping.countrycodeinputobject");
		var countrycodeinputfield = component.get("v.addressMapping.countrycodeinputfield");
		component.set("v.objectDataMap."+ countryinputobject + "." + countryinputfield ,  'ITALIA' );
		component.set("v.objectDataMap."+ countrycodeinputobject + "." + countrycodeinputfield ,  'ITA' );
		//city
		var cityinputobject = component.get("v.addressMapping.cityinputobject");
		var cityinputfield = component.get("v.addressMapping.cityinputfield");
		component.set("v.cityString", '');
		component.set("v.objectDataMap."+ cityinputobject + "." + cityinputfield ,  '' );
		//province
        var provinceinputobject = component.get("v.addressMapping.provinceinputobject");
        var provinceinputfield = component.get("v.addressMapping.provinceinputfield");
		component.set("v.provinceString", '');
		component.set("v.objectDataMap."+ provinceinputobject + "." + provinceinputfield ,  '' );
		//province code
		var provincecodeinputobject = component.get("v.addressMapping.provincecodeinputobject");
        var provincecodeinputfield = component.get("v.addressMapping.provincecodeinputfield");
		component.set("v.provinceCodeString", '');
		component.set("v.objectDataMap."+ provincecodeinputobject + "." + provincecodeinputfield ,  '' );
		//street
		var streetinputobject = component.get("v.addressMapping.streetinputobject");
        var streetinputfield = component.get("v.addressMapping.streetinputfield");
		component.set("v.streetString", '');
		component.set("v.objectDataMap."+ streetinputobject + "." + streetinputfield ,  '' );
		//number
		var streetnumberinputobject = component.get("v.addressMapping.streetnumberinputobject");
        var streetnumberinputfield = component.get("v.addressMapping.streetnumberinputfield");
		component.set("v.streetNumberString", '');
		component.set("v.objectDataMap."+ streetnumberinputobject + "." + streetnumberinputfield ,  '' );
		//district
		var districtinputobject = component.get("v.addressMapping.districtinputobject");
		var districtinputfield = component.get("v.addressMapping.districtinputfield");
		component.set("v.districtString", '');
		component.set("v.objectDataMap."+ districtinputobject + "." + districtinputfield ,  '' );
		//presso
		var pressoinputobject = component.get("v.addressMapping.pressoinputobject");
		var pressoinputfield = component.get("v.addressMapping.pressoinputfield");
		component.set("v.detailString", '');
		component.set("v.objectDataMap."+ pressoinputobject + "." + pressoinputfield ,  '' );
		//ZIPCODE
		var zipcodeinputobject = component.get("v.addressMapping.zipcodeinputobject");
        var zipcodeinputfield = component.get("v.addressMapping.zipcodeinputfield");
        var objectDataMap = component.get("v.objectDataMap");
        
		document.getElementById("zipcode"+sectionName).value = '';
		objectDataMap[zipcodeinputobject][zipcodeinputfield]   = '';
		
		//set postel input with a blanks values
		var activePostel = component.get("v.isPostelDisabled");
		if(activePostel != true){
			var autoCompleteCmp = component.find("AutoCompleteComponentPostel");
			if (autoCompleteCmp) {
				autoCompleteCmp.reInitAll();
				var caps = [];
				autoCompleteCmp.blankMethod(caps);
			}
		}
		if(sectionName == 'sedeAmministrativa'){
			component.set("v.isEqualsAddress", true);
			component.set("v.objectDataMap.isLegalEqualAdm", true);
		}
    },
    setProvince : function(component, event , helper){
        var sectionName = component.get("v.addressMapping.sectionName");
        if($A.util.isUndefinedOrNull(sectionName))
        	sectionName='';
        var provinceinputobject = component.get("v.addressMapping.provinceinputobject");
        var provinceinputfield = component.get("v.addressMapping.provinceinputfield");
		var province = document.getElementById('provincia'+sectionName).value.toUpperCase();
		component.set("v.provinceString", province);
        component.set("v.objectDataMap."+ provinceinputobject + "." + provinceinputfield ,  province );
        var provinceEEId = component.get("v.provinceEEId");
		var regex = new RegExp("^[a-zA-Z0-9()?!&% $£  =^ °\/\"\.\']+$","g");
		province = province.replaceAll(/\\/,'0');
		if(province && !regex.test(province)){
			console.log('inside error');
			var errorId = 'errorId'+provinceEEId;
			var myDiv;
			myDiv = document.createElement('div');
			myDiv.setAttribute('id',errorId);//SET AN ID TO EVERY MESSAGE
			myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
			myDiv.setAttribute('class' , 'messageError'+provinceEEId);
			//SET THE MESSAGE
			var errorMessage = document.createTextNode($A.get("$Label.c.errorSpecialCharacter"));
			myDiv.appendChild(errorMessage);

			var idSet = document.getElementById(provinceEEId);
			console.log('idSet:: '+idSet);
			if(!$A.util.isEmpty(idSet))
			{ 
				if(!(document.getElementById(errorId)))
				{
					console.log("METHOD TO SHOW ONLY A MESSAGE");
					idSet.after(myDiv);
					$A.util.addClass(idSet, 'slds-has-error flow_required');
					//idSet.className="slds-has-error flow_required";
				}
			}//END FOR
			component.set("v.objectDataMap.errorEEMap.isErrorEEProv"+sectionName, true);
		} else {
			helper.removeRedBorderEE(component, event , helper);
			component.set("v.objectDataMap.errorEEMap.isErrorEEProv"+sectionName, false);
		}
    },
    changeCountry : function(component, event, helper) {
		var zipcodeinputobject = component.get("v.addressMapping.zipcodeinputobject");
		var zipcodeinputfield = component.get("v.addressMapping.zipcodeinputfield");
		var sectionName = component.get("v.addressMapping.sectionName");
		if($A.util.isUndefinedOrNull(sectionName))
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
			addressMapping.streetnumberdisabled = 'false';
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
		if(countrySel == 'ITALIA'){	
			component.set("v.isEE",false);
			component.set("v.objectDataMap."+ zipcodeinputobject + "." + zipcodeinputfield ,  '' );
			component.set("v.zipcodeString",'');
			component.set("v.addressMapping.zipcodedisabled",'false');
			
		} else {
			component.set("v.isEE",true);
			component.set("v.objectDataMap."+ zipcodeinputobject + "." + zipcodeinputfield ,  '99999' );
			component.set("v.zipcodeString",'99999');
			component.set("v.addressMapping.zipcodedisabled",'true');
		}
    },
    setCity : function(component, event , helper){
		var sectionName = component.get("v.addressMapping.sectionName");
		if($A.util.isUndefinedOrNull(sectionName))
			sectionName='';
		var cityinputobject = component.get("v.addressMapping.cityinputobject");
		var cityinputfield = component.get("v.addressMapping.cityinputfield");
		var city = document.getElementById('comune'+sectionName).value.toUpperCase();
		component.set("v.cityString", city);
		var cityEEId = component.get("v.cityEEId");
		component.set("v.objectDataMap."+ cityinputobject + "." + cityinputfield ,  city );
		var regex = new RegExp("^[a-zA-Z0-9()?!&% $£  =^ °\/\"\.\']+$","g");
		city = city.replaceAll(/\\/,'0');
		if(city && !regex.test(city)){ 
			console.log('inside error');
			var errorId = 'errorId'+cityEEId;
			var myDiv;
			myDiv = document.createElement('div');
			myDiv.setAttribute('id',errorId);
			myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
			myDiv.setAttribute('class' , 'messageError'+cityEEId);
			var errorMessage = document.createTextNode($A.get("$Label.c.errorSpecialCharacter"));
			myDiv.appendChild(errorMessage);
			var idSet = document.getElementById(cityEEId);
			console.log('idSet:: '+idSet);
			if(!$A.util.isEmpty(idSet))
			{ 
				if(!(document.getElementById(errorId)))
				{
					console.log("METHOD TO SHOW ONLY A MESSAGE");
					idSet.after(myDiv);
					$A.util.addClass(idSet, 'slds-has-error flow_required');
				}
			}
			component.set("v.objectDataMap.errorEEMap.isErrorEECity"+sectionName, true);	
		} else {
			helper.removeRedBorderEE(component, event , helper);
			component.set("v.objectDataMap.errorEEMap.isErrorEECity"+sectionName, false);
		}			
    },
    setStreet : function(component, event , helper){
        var sectionName = component.get("v.addressMapping.sectionName");
        if($A.util.isUndefinedOrNull(sectionName))
        	sectionName='';
        var streetinputobject = component.get("v.addressMapping.streetinputobject");
        var streetinputfield = component.get("v.addressMapping.streetinputfield");
		var street = document.getElementById('strada'+sectionName).value.toUpperCase();
		component.set("v.streetString", street);
        component.set("v.objectDataMap."+ streetinputobject + "." + streetinputfield ,  street );
        var stradaEEId = component.get("v.stradaEEId");
		var regex = new RegExp("^[a-zA-Z0-9()?!&% $£  =^ °\/\"\.\']+$","g");
		street = street.replaceAll(/\\/,'0');
		if(street && !regex.test(street)){
			console.log('inside error');
			var errorId = 'errorId'+stradaEEId;
			var myDiv;
			myDiv = document.createElement('div');
			myDiv.setAttribute('id',errorId);
			myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
			myDiv.setAttribute('class' , 'messageError'+stradaEEId);
			var errorMessage = document.createTextNode($A.get("$Label.c.errorSpecialCharacter"));
			myDiv.appendChild(errorMessage);
			var idSet = document.getElementById(stradaEEId);
			console.log('idSet:: '+idSet);
			if(!$A.util.isEmpty(idSet))
			{ 
				if(!(document.getElementById(errorId)))
				{
					console.log("METHOD TO SHOW ONLY A MESSAGE");
					idSet.after(myDiv);
					$A.util.addClass(idSet, 'slds-has-error flow_required');
				}
			}
			component.set("v.objectDataMap.errorEEMap.isErrorEEStreet"+sectionName, true);
		} else {
			helper.removeRedBorderEE(component, event , helper);
			component.set("v.objectDataMap.errorEEMap.isErrorEEStreet"+sectionName, false);
			
		}
    },
    setValueStreetNumberEE : function(component, event, helper){
        var sectionName = component.get("v.addressMapping.sectionName");
        if($A.util.isUndefinedOrNull(sectionName))
         sectionName='';
         var streetnumberinputobject = component.get("v.addressMapping.streetnumberinputobject");
         var streetnumberinputfield = component.get("v.addressMapping.streetnumberinputfield");
          var civico = document.getElementById('civico'+sectionName).value.toUpperCase();
		  component.set("v.streetNumberString", civico);
          console.log('civico onchange'+civico);
          component.set("v.objectDataMap."+ streetnumberinputobject + "." + streetnumberinputfield ,  civico );
          var civicoEEId = component.get("v.civicoEEId");
          var regex = new RegExp("^[a-zA-Z0-9()?!&% $£  =^ °\/\"\.\']+$","g");
          civico = civico.replaceAll(/\\/,'0');
          if(civico && !regex.test(civico)){
              console.log('inside error');
              var errorId = 'errorId'+civicoEEId;
              var myDiv;
              myDiv = document.createElement('div');
              myDiv.setAttribute('id',errorId);
              myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
              myDiv.setAttribute('class' , 'messageError'+civicoEEId);
              var errorMessage = document.createTextNode($A.get("$Label.c.errorSpecialCharacter"));
              myDiv.appendChild(errorMessage);
              var idSet = document.getElementById(civicoEEId);
              console.log('idSet:: '+idSet);
              if( !$A.util.isEmpty(idSet))
              { 
                  if(!(document.getElementById(errorId)))
                  {
                      console.log("METHOD TO SHOW ONLY A MESSAGE");
                      idSet.after(myDiv);
                      $A.util.addClass(idSet, 'slds-has-error flow_required');
                  }
              }
              component.set("v.objectDataMap.errorEEMap.isErrorEECivico"+sectionName, true);
              
          } else {
              helper.removeRedBorderCivicoEE(component, event , helper);
              component.set("v.objectDataMap.errorEEMap.isErrorEECivico"+sectionName, false);
              
          }
      },
      setDistrict : function(component, event , helper){  
		var sectionName = component.get("v.addressMapping.sectionName");
		if($A.util.isUndefinedOrNull(sectionName))
			sectionName='';
		var districtinputobject = component.get("v.addressMapping.districtinputobject");
		var districtinputfield = component.get("v.addressMapping.districtinputfield");
		var district = document.getElementById('frazione'+sectionName).value.toUpperCase();
		component.set("v.districtString", district);
		component.set("v.objectDataMap."+ districtinputobject + "." + districtinputfield ,  district );
        var regex = new RegExp("^[a-zA-Z0-9()?!&% $£  =^ °\/\"\.\']+$","g");
		district = district.replaceAll(/\\/,'0');
		if(district && !regex.test(district)){
			console.log('inside error');
			var errorId = 'errorIddistrictEE'+sectionName;
			var myDiv;
			myDiv = document.createElement('div');
			myDiv.setAttribute('id',errorId);
			myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
			myDiv.setAttribute('class' , 'messageErrordistrictEE'+sectionName);
			var errorMessage = document.createTextNode($A.get("$Label.c.errorSpecialCharacter"));
			myDiv.appendChild(errorMessage);
			var idSet = document.getElementById('districtEE'+sectionName);
			console.log('idSet:: '+idSet);
			if(!$A.util.isEmpty(idSet))
			{ 
				if(!(document.getElementById(errorId)))
				{
					console.log("METHOD TO SHOW ONLY A MESSAGE");
					idSet.after(myDiv);
					$A.util.addClass(idSet, 'slds-has-error flow_required');
				}
			}
			component.set("v.objectDataMap.errorEEMap.isErrorEEDist"+sectionName, true);
		} else {
			helper.removeRedBorderEE(component, event , helper);
			component.set("v.objectDataMap.errorEEMap.isErrorEEDist"+sectionName, false);
		}
    },
    setPostalCode: function(component, event, helper) {
        var sectionName = component.get("v.addressMapping.sectionName");
        if($A.util.isUndefinedOrNull(sectionName))
           sectionName='';
        var zipcodeinputobject = component.get("v.addressMapping.zipcodeinputobject");
        var zipcodeinputfield = component.get("v.addressMapping.zipcodeinputfield");
        var objectDataMap = component.get("v.objectDataMap");
        
		var val = document.getElementById("zipcode"+sectionName).value;
		if(val.length > 5){
			document.getElementById("zipcode"+sectionName).value = val.substring(0,5);
		}
		objectDataMap[zipcodeinputobject][zipcodeinputfield] = document.getElementById("zipcode"+sectionName).value;
		
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
                   myDiv.setAttribute('id',errorId);
                   myDiv.setAttribute('style','color:rgb(194, 57, 52); position: absolute; z-index: 1;');
                   myDiv.setAttribute('class' , 'messageErrorzipcodeEE'+sectionName);
                   var errorMessage = document.createTextNode($A.get("$Label.c.errorSpecialCharacter"));
                   myDiv.appendChild(errorMessage);
                   var idSet = document.getElementById('zipcodeEE'+sectionName);
                   console.log('idSet:: '+idSet);
                   if(!$A.util.isEmpty(idSet))
                   { 
                       if(!(document.getElementById(errorId)))
                       {
                           console.log("METHOD TO SHOW ONLY A MESSAGE");
                           idSet.after(myDiv);
                           $A.util.addClass(idSet, 'slds-has-error flow_required');
                       }
                   }
                   component.set("v.objectDataMap.errorEEMap.isErrorEEZip"+sectionName, true);
                   
               } else {
                   helper.removeRedBorderZipCodeEE(component, event , helper);
                   component.set("v.objectDataMap.errorEEMap.isErrorEEZip"+sectionName, false);
               }
           }
       },
       setValuePresso : function(component, event, helper) {
		var sectionName = component.get("v.addressMapping.sectionName");
		if($A.util.isUndefinedOrNull(sectionName))
		  sectionName='';
		var pressoinputobject = component.get("v.addressMapping.pressoinputobject");
		var pressoinputfield = component.get("v.addressMapping.pressoinputfield");
		var presso = document.getElementById("presso"+sectionName).value.toUpperCase();
		component.set("v.detailString", presso);
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
				myDiv.setAttribute('id',errorId);
				myDiv.setAttribute('style','color:rgb(194, 57, 52); position: absolute;  z-index: 1;');
				myDiv.setAttribute('class' , 'messageErrorpresso'+sectionName);
				var errorMessage = document.createTextNode($A.get("$Label.c.errorSpecialCharacter"));
				myDiv.appendChild(errorMessage);
				var idSet = document.getElementById('presso'+sectionName);
				console.log('idSet:: '+idSet);
				if(!$A.util.isEmpty(idSet))
				{ 
					if(!(document.getElementById(errorId)))
					{
						console.log("METHOD TO SHOW ONLY A MESSAGE");
						idSet.after(myDiv);
						$A.util.addClass(idSet, 'slds-has-error flow_required');
					}
				}
				component.set("v.objectDataMap.errorEEMap.isErrorEEpresso"+sectionName, true);
				
			} else {
				helper.removeRedBorderPresso(component, event , helper);
				component.set("v.objectDataMap.errorEEMap.isErrorEEpresso"+sectionName, false);
			}
		}
    },
	reInitAllPostel : function(component,event,helper){
		console.log('%%%reinitallpostel');
		var activePostel = component.get("v.isPostelDisabled");
		console.log('%%%activePostel '+ activePostel);
		if(activePostel != true){
			console.log('%%%inactivepostel');
			var autoCompleteCmp = component.find("AutoCompleteComponentPostel");
			console.log('%%%autoCompleteCmp'+autoCompleteCmp);
			if (autoCompleteCmp) {
				console.log('%%%in IF autocompl');
				autoCompleteCmp.reInitAll();
			}
		}
	},
	blankMethodCapsPostel : function(component,event,helper){
		console.log('%%%blankMethodCapsPostel');
		var activePostel = component.get("v.isPostelDisabled");
		if(activePostel != true){
			console.log('%%%inactivepostel');
			var autoCaps = component.find("AutoCompleteComponentPostel");
			if(autoCaps){
				var caps = [];
				autoCaps.blankMethod(caps);
				console.log('%%%finish blankmethodpostel');
			}
		}
	},
	setValueProvinceCode : function(component,event,helper){
		var sectionName = component.get("v.addressMapping.sectionName");
        if($A.util.isUndefinedOrNull(sectionName))
        	sectionName='';
        var provincecodeinputobject = component.get("v.addressMapping.provincecodeinputobject");
        var provincecodeinputfield = component.get("v.addressMapping.provincecodeinputfield");
		var provinceCode = document.getElementById('sigla'+sectionName).value.toUpperCase();
		console.log('&&&: '+ provinceCode);
		component.set("v.provinceCodeString", provinceCode);
        component.set("v.objectDataMap."+ provincecodeinputobject + "." + provincecodeinputfield ,  provinceCode );
        var provinceCodeEEId = component.get("v.provinceCodeEEId");
		var regex = new RegExp("^[a-zA-Z0-9()?!&% $£  =^ °\/\"\.\']+$","g");
		provinceCode = provinceCode.replaceAll(/\\/,'0');
		if(provinceCode && !regex.test(provinceCode)){
			console.log('inside error');
			var errorId = 'errorId'+provinceCodeEEId;
			var myDiv;
			myDiv = document.createElement('div');
			myDiv.setAttribute('id',errorId);//SET AN ID TO EVERY MESSAGE
			myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
			myDiv.setAttribute('class' , 'messageError'+provinceCodeEEId);
			//SET THE MESSAGE
			var errorMessage = document.createTextNode($A.get("$Label.c.errorSpecialCharacter"));
			myDiv.appendChild(errorMessage);
			var idSet = document.getElementById(provinceCodeEEId);
			console.log('idSet:: '+idSet);
			if(!$A.util.isEmpty(idSet))
			{ 
				if(!(document.getElementById(errorId)))
				{
					console.log("METHOD TO SHOW ONLY A MESSAGE");
					idSet.after(myDiv);
					$A.util.addClass(idSet, 'slds-has-error flow_required');
				}
			}
			component.set("v.objectDataMap.errorEEMap.isErrorEEProv"+sectionName, true);
		} else {
			helper.removeRedBorderEE(component, event , helper);
			component.set("v.objectDataMap.errorEEMap.isErrorEEProv"+sectionName, false);
		}
	}
})