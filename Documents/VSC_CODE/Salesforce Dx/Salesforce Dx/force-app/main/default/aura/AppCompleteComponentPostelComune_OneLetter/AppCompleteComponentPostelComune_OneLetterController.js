({  
	doInit : function(component, event, helper) {
        
		console.log('function do Init of AutoCompleteComune');
		console.log('AddressMapping: '+component.get("v.addressMapping"));
		var cityinputobject = component.get("v.addressMapping.cityinputobject");
		var cityinputfield = component.get("v.addressMapping.cityinputfield");
		var sectionName = component.get("v.addressMapping.sectionName");
		if(sectionName == undefined || sectionName == null)
			sectionName='';
		console.log('cityinputobject : ' + cityinputobject + ' cityinputfield: ' + cityinputfield);
	   // var cityinput = 'v.objectDataMap.' + cityinputobject + '.' + cityinputfield;
	   var objectDataMaptemp = component.get("v.objectDataMap");
	   var cityinput=null;
	   var cityIdInput=null;
	   var cityEEIdInput = null;
	   if(cityinputobject != null && cityinputobject != undefined && cityinputfield != undefined && cityinputfield != null)
	   	cityinput = objectDataMaptemp[cityinputobject][cityinputfield];
	   if(sectionName != null && sectionName != ''){
	   	cityIdInput = 'comune'+sectionName;
	   	component.set("v.cityId", cityIdInput);
	   	cityEEIdInput = 'cityEE'+sectionName;
	   	component.set("v.cityEEId", cityEEIdInput);
	   }

	   if(cityinput!='')
	   	helper.removeRedBorder(component, event, helper);

	   console.log('cityinput: '+cityinput);
	   console.log('cityIdInput: '+cityIdInput);
		// var city = component.get("v.objectDataMap");
		console.log('objectDataMap : ' + JSON.stringify(objectDataMaptemp));
		component.set("v.cityString", cityinput);
		
	},

	/*************lea.emalieu 05/09/2018 START ****************/
  /*  objectDataMapChanges : function(component, event, helper){
		var objectDataMaptemp = component.get("v.objectDataMap");
		var cityinputobject = component.get("v.addressMapping.cityinputobject");
		var cityinputfield = component.get("v.addressMapping.cityinputfield");
		if(cityinputobject != undefined && cityinputobject != null && cityinputfield != undefined && cityinputfield != null)
		   cityinput = objectDataMaptemp[cityinputobject][cityinputfield];
		console.log('objectDataMap : ' + JSON.stringify(objectDataMaptemp));
		component.set("v.cityString", cityinput);

			
		}
	},*/
	/*************lea.emalieu 05/09/2018 END *********************/
	
	// fieldChanges : function(component, event, helper) 
	// {
	//     console.log('function do Init of AutoCompleteComune');
	//     console.log('AddressMapping: '+component.get("v.addressMapping"));
	//     var cityinputobject = component.get("v.addressMapping.cityinputobject");
	//     var cityinputfield = component.get("v.addressMapping.cityinputfield");
	//     console.log('cityinputobject : ' + cityinputobject + ' cityinputfield: ' + cityinputfield);
	//    // var cityinput = 'v.objectDataMap.' + cityinputobject + '.' + cityinputfield;
	//    var objectDataMaptemp = component.get("v.objectDataMap");
	//    var cityinput=null;
	//    if(cityinputobject != null && cityinputobject != undefined && cityinputfield != undefined && cityinputfield != null)
	//        cityinput = objectDataMaptemp[cityinputobject][cityinputfield];
	//    console.log('cityinput: '+cityinput);
	//     // var city = component.get("v.objectDataMap");
	//     console.log('objectDataMap : ' + JSON.stringify(objectDataMaptemp));
	//     component.set("v.cityString", cityinput);
	// },

	completeComune : function(component, event, helper) {

		var input = document.getElementById("comune").value;
		var idProv = component.get("v.province");
		console.log("the id into comune child is: " + idProv);
		helper.getResponse(component,'/comuni?in='+input+'&prov='+idProv,'comune');
		if(document.getElementById("frazione")!=null && document.getElementById("frazione")!=undefined)
		{
			document.getElementById("frazione").disabled=false;
		};
		if(document.getElementById("strada")!=null && document.getElementById("strada")!=undefined)
		{
			document.getElementById("strada").disabled=false;
		};
		if(document.getElementById("civico")!=null && document.getElementById("civico")!=undefined)
		{
			document.getElementById("civico").disabled=false;
		};
		// document.getElementById("frazione").disabled=false;
		// document.getElementById("strada").disabled=false;
		// document.getElementById("civico").disabled=false;
	},
	getValueEE : function(component, event , helper){  
		//****START EVENT METHOD****//
		console.log('getvalueEE');
		var sectionName = component.get("v.addressMapping.sectionName");
		if(sectionName == undefined || sectionName == null)
			sectionName='';
		var cityinputobject = component.get("v.addressMapping.cityinputobject");
		var cityinputfield = component.get("v.addressMapping.cityinputfield");
		var city = document.getElementById('cityEE'+sectionName).value;
		var cityEEId = component.get("v.cityEEId");
		component.set("v.objectDataMap."+ cityinputobject + "." + cityinputfield ,  city );
		var regex = new RegExp("^[a-zA-Z0-9()?!&% $£  =^ °\/\"\.\']+$","g");
		city = city.replaceAll(/\\/,'0');
		if(city && !regex.test(city)){ 
			console.log('inside error');
			var errorId = 'errorId'+cityEEId;
			var myDiv;
			
			myDiv = document.createElement('div');
			myDiv.setAttribute('id',errorId);//SET AN ID TO EVERY MESSAGE
			myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
			myDiv.setAttribute('class' , 'messageError'+cityEEId);
			//SET THE MESSAGE
			var errorMessage = document.createTextNode($A.get("$Label.c.errorSpecialCharacter"));
			myDiv.appendChild(errorMessage);

			var idSet = document.getElementById(cityEEId);
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
			component.set("v.objectDataMap.errorEEMap.isErrorEECity"+sectionName, true);
			
		} else {
			helper.removeRedBorderEE(component, event , helper);
			component.set("v.objectDataMap.errorEEMap.isErrorEECity"+sectionName, false);
			
		}
					
	},
	getValue: function(component, event, helper) {
		var cityinputobject = component.get("v.addressMapping.cityinputobject");
		var cityinputfield = component.get("v.addressMapping.cityinputfield");
		var comuneId = component.get("v.cityId");
		var sectionName = component.get("v.addressMapping.sectionName");
		if(sectionName == undefined || sectionName == null)
			sectionName='';
		console.log('addressMapping');
		console.log(JSON.stringify(component.get("v.addressMapping")));
		var id;
		var myEvent = component.getEvent("AutocompleteEvent");
		var response = component.get("v.responseCom");
		console.log("the responseCom is: " + JSON.stringify(response));
		//GET THE KEY FROM A VALUE
		var comune = document.getElementById(comuneId).value;
		//var comune = $('[id$="comune"]').val();
		component.set("v.objectDataMap."+ cityinputobject + "." + cityinputfield ,  comune );
		console.log("il comune è: " + comune);
		for (var key in component.get("v.responseCom")){
			console.log("into the for");
			if(component.get("v.responseCom")[key]==comune){
				id=key;
				console.log("the ID of comune is: " + id);
				component.set("v.objectDataMap.comune",id);
			}
		}
		myEvent.setParams({"comune": id });
		myEvent.fire()
		console.log("the idCom into getValue is: " + myEvent.getParams("comune"));
		
	},
	//*******METHOD TO CLEAR THE CASCADE COMPONENT*******//
	clearInput : function(component, event, helper) {
		console.log("into the clear input");
		var sectionName = component.get("v.addressMapping.sectionName");
		if(sectionName == undefined || sectionName == null)
			sectionName='';

		var comuneValue = document.getElementById("comune"+sectionName).value;
        if(document.getElementById("frazione"+sectionName)!=null && document.getElementById("frazione"+sectionName)!=undefined){
        	if(comuneValue != undefined && comuneValue != null){
        		if(comuneValue == ''){
        			document.getElementById("frazione"+sectionName).disabled=true;
        		} else {
        			document.getElementById("frazione"+sectionName).disabled=false;
        		}
        	 }
        }
        if(document.getElementById("strada"+sectionName)!=null && document.getElementById("strada"+sectionName)!=undefined){
            if(comuneValue != undefined && comuneValue != null){
	            if(comuneValue == ''){
	            	document.getElementById("strada"+sectionName).disabled=true;
	            	component.set("v.caps",'');
	            }else {
	            	document.getElementById("strada"+sectionName).disabled=false;
	            }
            }
        }
        if(document.getElementById("civico"+sectionName)!=null && document.getElementById("civico"+sectionName)!=undefined){
        	if(comuneValue != undefined && comuneValue != null){
        		if(comuneValue == ''){
	            	document.getElementById("civico"+sectionName).disabled=true;
	            }else {
	            	document.getElementById("civico"+sectionName).disabled=false;
	            }
        	}
        }
		component.set("v.objectDataMap.comune", '');
		//*** 22/10/2018  - SPINELLI GIOVANNI - FOCUS ON DISTRICT WITH TAB EVENT
		if(document.getElementById("frazione"+sectionName)!=null && document.getElementById("frazione"+sectionName)!=undefined){
			if(event.keyCode==9){
				document.getElementById('comune'+sectionName).focus();
			}
		}	

		
		

		// function TabExample(evt) {
		//   var evt = (evt) ? evt : ((event) ? event : null);
		  
		//   var tabKey = 9;
		//   alert('1 + ' + evt.keyCode);
		//   if(evt.keyCode == tabKey) {
		//     document.getElementById('frazione').focus();
		//   }
		// }

		
		
	}, 
	// callService : function(component, event , helper){
	//     var sectionName = component.get("v.addressMapping.sectionName");
	//     var comuneId = component.get("v.cityId");
	//     console.log(event.target.id);
	//     //var url = '/province';
	//     var field = event.target.id;
	//     //var input = encodeURI(document.getElementById("comune").value);
	//     var input = encodeURI(event.target.value);
	//     console.log('OGGETTO INPUT CON ID: '+document.getElementById(comuneId));
	//     console.log('VALORE EVENTO: '+event.target.value);
	//     console.log('component.get("v.objectDataMap.province")'+ component.get("v.objectDataMap.province"));
	//     var idField = component.get("v.province") == null ? component.get("v.objectDataMap.province") : component.get("v.province");
	//     console.log('field: '+field+'input: '+input+'idField: '+idField);
	//     if(input.length%2==0){
	//        var request = $A.get("e.c:OB_ContinuationRequest");
	//        console.log('siamo nel callService, stampo la request: '+request);
	//        request.setParams({ 
	//            methodName: "getPostel",
	//            methodParams: [field, input, idField],
	//            callback: function(result) {
	//                console.log('RISULTATO: '+ JSON.stringify(result));
	//                component.set("v.responseCom" , result);
	//                helper.city(component, event , helper);
	//            }
	//        });

	//        request.fire();
	//    }
	//     //console.log("prov response : " + component.get("v.response"));
	// },


	
//********************call for cities***********************
callCities : function(component, event, helper) {

	    console.log("****in callCities");
		// var field = event.target.id;
		if (event.target.value.length == 1 && String(component.get("v.previousLength")) == '0') //Zuza
		{
		    var j$ = jQuery.noConflict();
		    j$('[id$="'+component.get("v.cityId")+'"]').autocomplete({source: {}});
            var cityList = []; //Zuza
		    var input = encodeURI(event.target.value);
            		var idField = component.get("v.province") == null ? component.get("v.objectDataMap.province") : component.get("v.province");

            		var action = component.get("c.getCities");
            		action.setParams({
            			"input": input,
            			"idField": idField
            		});
            		action.setCallback(this, function(response){
            			var state = response.getState();
            			if (state === "SUCCESS") {
            				var res = response.getReturnValue()
                            console.log('****TRY ONE LETTER ');
            				console.log('****RESPONSE CIIES: '+JSON.stringify(res));
            				component.set("v.responseCom", res);


                            
                            helper.city(component, event , helper);
                            helper.nowyAutocomplete(component);

                            //STOP Zuza
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
                        component.set("v.isSpinnerEnabled", false);
            		});

            		$A.enqueueAction(action);
            		component.set("v.isSpinnerEnabled", true);
        }
        component.set("v.previousLength",event.target.value.length);
        if (event.target.value.length > 1) //Zuza
        {
            //helper.nowyAutocomplete(component);
        }

	},

	comune: function(component, event , helper){
		var sectionName = component.get("v.addressMapping.sectionName");
		var comuneId = component.get("v.cityId");
		if(sectionName == undefined || sectionName == null)
			sectionName='';
		if(document.getElementById(comuneId)!=null && document.getElementById(comuneId)!=undefined)
		{
			document.getElementById(comuneId).disabled=false;
		}
		if(document.getElementById("frazione"+sectionName)!=null && document.getElementById("frazione"+sectionName)!=undefined)
		{
			if((document.getElementById(comuneId).value != ''))
				document.getElementById("frazione"+sectionName).disabled=false;
			else
				document.getElementById("frazione"+sectionName).disabled=true;
		}
		if(document.getElementById("strada"+sectionName)!=null && document.getElementById("strada"+sectionName)!=undefined)
		{
			if((document.getElementById(comuneId).value != ''))
				document.getElementById("strada"+sectionName).disabled=false;
			else
				document.getElementById("strada"+sectionName).disabled=true;
		}
		if(document.getElementById("civico"+sectionName)!=null && document.getElementById("civico"+sectionName)!=undefined)
		{
			if((document.getElementById(comuneId).value != ''))
				document.getElementById("civico"+sectionName).disabled=false;
			else
				document.getElementById("civico"+sectionName).disabled=true;
		}
		helper.removeRedBorder(component, event, helper);
		var section = component.get("v.addressMapping.sectionName");
		console.log('section: '+section);

		if(section != undefined && section.includes('Birth')){
			
			var province = component.get("v.objectDataMap."+component.get("v.addressMapping.provinceinputobject")+".OB_Birth_State__c");
			var city=event.target.value;
			console.log(province+'_'+ city);
			var url = 'callout:OB_doNormJSON/doNormJSON?provincia='+encodeURI(province)+'&localita='+encodeURI(city);
			var action = component.get("c.getCadastrialCode");
	        console.log('******printing Action: '+ action);
	        action.setStorable();
	        action.setParams({ 
				url : url });
	        action.setCallback(this, function (response){
	            var state = response.getState();
	            if (state === "SUCCESS") {
	                console.log("SUCCESS getCadastrialCode: "+response.getReturnValue()); 
	                component.set("v.objectDataMap."+component.get("v.addressMapping.provinceinputobject")+".OB_Cadastral_Code__c",response.getReturnValue());
	                console.log(JSON.stringify(component.get('v.objectDataMap')));
	            }
	            else if (state === "INCOMPLETE"){
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
		
		}
		//
		//do call to normJSON toget cadastrial code
		// document.getElementById("comune").disabled=false;
	 //    document.getElementById("frazione").disabled=false;
	 //    document.getElementById("strada").disabled=false;
	 //    document.getElementById("civico").disabled=false;
	 
	},


	removeRedBorderEE: function(component, event, helper) {

		helper.removeRedBorderEE(component, event, helper);
	},

	blankValue : function(component, event, helper) {
		var cityinputobject = component.get("v.addressMapping.cityinputobject");
		var cityinputfield = component.get("v.addressMapping.cityinputfield");
		component.set("v.objectDataMap."+ cityinputobject + "." + cityinputfield ,  '' );
		component.set("v.cityString", '');
		console.log('cityinput'+component.get("v.cityString"));
		helper.removeRedBorder(component, event, helper);
		helper.removeRedBorderEE(component, event, helper);
	}


})