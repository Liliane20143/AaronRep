({  
	doInit : function(component, event, helper) { 
		String.prototype.replaceAll = function(search, replacement) {
		    var target = this;
		    return target.replace(new RegExp(search, 'g'), replacement);
		};
		console.log('function do Init of AutoCompleteDistrict');
		var sectionName = component.get("v.addressMapping.sectionName");
		if(sectionName == undefined || sectionName == null)
			sectionName='';
		var districtinputobject = component.get("v.addressMapping.districtinputobject");
		var districtinputfield = component.get("v.addressMapping.districtinputfield");
		console.log('districtinputobject : ' + districtinputobject + ' districtinputfield: ' + districtinputfield);
	   // var cityinput = 'v.objectDataMap.' + cityinputobject + '.' + cityinputfield;
	   var objectDataMaptemp = component.get("v.objectDataMap");
	   var districtinput=null;
	   var districtIdInput=null;
	   var districtIdEEInput=null;
	   if(districtinputobject != null && districtinputobject != 'undefined' && districtinputfield != 'undefined' && districtinputfield != null)
	   	districtinput = objectDataMaptemp[districtinputobject][districtinputfield];
	   if(sectionName != null && sectionName != ''){
	   	districtIdInput = 'frazione'+sectionName;
	   	component.set("v.districtId", districtIdInput);
	   	districtIdEEInput = 'districtEE'+sectionName;
	   	component.set("v.districtEEId", districtIdEEInput);
	   }
	   console.log('districtinput : '+ districtinput);
		// var city = component.get("v.objectDataMap");
		console.log('objectDataMap : ' + JSON.stringify(objectDataMaptemp));
		component.set("v.districtString", districtinput);

		
	},

	completeFrazione : function(component, event, helper) {
		var input = document.getElementById("frazione").value;
		var idCom = component.get("v.comune");
		console.log("the district input is: " + input);
		// var idCom = '7984';
		console.log("the idCom into complete frazione is: " + idCom);
		helper.getResponse(component,'/frazioni?in='+input+'&com='+idCom,'frazione');
	},
	getValueEE : function(component, event , helper){  
		var sectionName = component.get("v.addressMapping.sectionName");
		if(sectionName == undefined || sectionName == null)
			sectionName='';
		//****START EVENT METHOD****//
		console.log('getvalueEE');
		var districtinputobject = component.get("v.addressMapping.districtinputobject");
		var districtinputfield = component.get("v.addressMapping.districtinputfield");
		var district = document.getElementById('districtEE'+sectionName).value;
		component.set("v.objectDataMap."+ districtinputobject + "." + districtinputfield ,  district );
        var regex = new RegExp("^[a-zA-Z0-9()?!&% $£  =^ °\/\"\.\']+$","g");
		district = district.replaceAll(/\\/,'0');
		if(district && !regex.test(district)){
			console.log('inside error');
			var errorId = 'errorIddistrictEE'+sectionName;
			var myDiv;
			
			myDiv = document.createElement('div');
			myDiv.setAttribute('id',errorId);//SET AN ID TO EVERY MESSAGE
			myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
			myDiv.setAttribute('class' , 'messageErrordistrictEE'+sectionName);
			//SET THE MESSAGE
			var errorMessage = document.createTextNode($A.get("$Label.c.errorSpecialCharacter"));
			myDiv.appendChild(errorMessage);

			var idSet = document.getElementById('districtEE'+sectionName);
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
			component.set("v.objectDataMap.errorEEMap.isErrorEEDist"+sectionName, true);
			
		} else {
			helper.removeRedBorderEE(component, event , helper);
			component.set("v.objectDataMap.errorEEMap.isErrorEEDist"+sectionName, false);
		}
	},
	//*********METHOD TO PASS THE EVENT ATTRIBUTE******//
	getValue: function(component, event, helper) {  
		var districtinputobject = component.get("v.addressMapping.districtinputobject");
		var districtinputfield = component.get("v.addressMapping.districtinputfield");
		var sectionName = component.get("v.addressMapping.sectionName");
		if(sectionName == undefined || sectionName == null)
			sectionName='';
		var id;
		var myEvent = component.getEvent("AutocompleteEvent");
		var response = component.get("v.responseDistr");
		console.log("the responseDistr is: " + JSON.stringify(response));
		//GET THE KEY FROM A VALUE
		var frazione = document.getElementById("frazione"+sectionName).value;
		component.set("v.objectDataMap."+ districtinputobject + "." + districtinputfield , frazione);
	   // component.set("v.objectDataMap.pv.OB_District__c" ,  frazione );
	   console.log("la frazione è: " + frazione);
		// var idProv = Object.keys(response).find();
		
		for (var key in component.get("v.responseDistr")){
			console.log("into the for");
			if(component.get("v.responseDistr")[key]==frazione){

				id=key;
				console.log("the ID of comune is: " + id);
				component.set("v.objectDataMap.district",id);
			}
			
		}
		
		myEvent.setParams({"frazione": id });
		
		myEvent.fire() 
		console.log("the frazione idafter fire event is:" +myEvent.getParams("frazione"));
		document.getElementById("strada"+sectionName).disabled=false;
	},
	
	clearInput : function(component, event, helper) {
		var sectionName = component.get("v.addressMapping.sectionName");
		if(sectionName == undefined || sectionName == null)
			sectionName='';
		console.log("into the clear input");
		//var inputCity = document.getElementById("comune").value;
		/*if(document.getElementById("civico"+sectionName))
			document.getElementById("civico"+sectionName).value='';
		if(document.getElementById("strada"+sectionName))
			document.getElementById("strada"+sectionName).value='';
		if(document.getElementById("presso"+sectionName))
			document.getElementById("presso"+sectionName).value='';*/
		//component.set("v.caps",'');
		component.set("v.objectDataMap.district", '');
	},
	// callService : function(component, event , helper){
	// 	var sectionName = component.get("v.addressMapping.sectionName");
	// 	if(sectionName == undefined || sectionName == null)
	// 		sectionName='';
	// 	console.log(event.target.id);
	// 	//var url = '/province';
	// 	var field = event.target.id;
	// 	var input = encodeURI(document.getElementById("frazione"+sectionName).value);
	// 	var idField = component.get("v.comune")==null?'':component.get("v.comune");
	// 	if(input.length%2==0){
	// 		var request = $A.get("e.c:OB_ContinuationRequest");
	// 		console.log('siamo nel completeProvincia, stampo la request: '+request);
	// 		request.setParams({ 
	// 			methodName: "getPostel",
	// 			methodParams: [field, input, idField],
	// 			callback: function(result) {
	// 				console.log('RISULTATO: '+ result);
	// 				component.set("v.responseDistr" , result);
	// 				helper.district(component, event , helper);
	// 			}
	// 		});

	// 		request.fire();
	// 	}
	// 	//console.log("prov response : " + component.get("v.response"));
	// },



//********************call for cities***********************
callDistrict : function(component, event, helper) {
	console.log("****in getDistrict");
		// var field = event.target.id;
		var sectionName = component.get("v.addressMapping.sectionName");
		if(sectionName == undefined || sectionName == null)
			sectionName='';
		var input = encodeURI(document.getElementById("frazione"+sectionName).value);
		var idField = component.get("v.comune")==null ? component.get("v.objectDataMap.comune") : component.get("v.comune");

		var action = component.get("c.getDistrict");
		action.setParams({
			"input": input,
			"idField": idField 
		});
		action.setCallback(this, function(response){
			var state = response.getState();
			console.log("state: "+state);
			if (state === "SUCCESS") {
				var res = response.getReturnValue()
				console.log('****RESPONSE DISTRICT: '+JSON.stringify(res));
				component.set("v.responseDistr", res);
				helper.district(component, event , helper); //NEXI-322 Kinga Fornal <kinga.fornal@accenture.com>, 13/09/2019
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
					console.log("****Unknown error");
				}
			}
		});

		$A.enqueueAction(action);

	}, 







	district: function(component, event , helper){
		var sectionName = component.get("v.addressMapping.sectionName");
		if(sectionName == undefined || sectionName == null)
			sectionName='';
		document.getElementById("comune"+sectionName).disabled=false;
		document.getElementById("frazione"+sectionName).disabled=false;
		document.getElementById("strada"+sectionName).disabled=false;
		document.getElementById("civico"+sectionName).disabled=false;

        //NEXI-322 Kinga Fornal <kinga.fornal@accenture.com>, 13/09/2019 START
        let districtId = component.get("v.districtId");
        let j$ = jQuery.noConflict();
        j$('[id$="'+districtId+'"]').autocomplete({source: []});
        //NEXI-322 Kinga Fornal <kinga.fornal@accenture.com>, 13/09/2019 STOP

	},
	blankValue : function(component, event, helper) {
		var districtinputobject = component.get("v.addressMapping.districtinputobject");
		var districtinputfield = component.get("v.addressMapping.districtinputfield");
		component.set("v.objectDataMap."+ districtinputobject + "." + districtinputfield ,  '' );
		component.set("v.districtString", '');
		helper.removeRedBorderEE(component, event, helper);
	}
})