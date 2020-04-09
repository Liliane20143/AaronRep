({  doInit: function(component, event , helper){
	String.prototype.replaceAll = function(search, replacement) {
		    var target = this;
		    return target.replace(new RegExp(search, 'g'), replacement);
		};
    console.log('function do Init of AutoCompleteStreet');
    var streetinputobject = component.get("v.addressMapping.streetinputobject");
    var streetinputfield = component.get("v.addressMapping.streetinputfield");
    console.log('streetinputobject : ' + streetinputobject + ' streetinputfield: ' + streetinputfield);
    var streetnumberinputobject = component.get("v.addressMapping.streetnumberinputobject");
    var streetnumberinputfield = component.get("v.addressMapping.streetnumberinputfield");
    console.log('function do Init of AutoCompletePostel');
    var objectDataMaptemp = component.get("v.objectDataMap");
        // var city = component.get("v.objectDataMap");
        console.log('objectDataMap : ' + JSON.stringify(objectDataMaptemp));
        console.log('AddressMapping: '+JSON.stringify(component.get("v.addressMapping")));
        var sectionName = component.get("v.addressMapping.sectionName");
        if(sectionName == undefined || sectionName == null)
        	sectionName='';
        console.log('streetnumberinputobject : ' + streetnumberinputobject + ' streetnumberinputfield: ' + streetnumberinputfield);
       // var cityinput = 'v.objectDataMap.' + cityinputobject + '.' + cityinputfield;
       var objectDataMaptemp = component.get("v.objectDataMap");
       var streetinput =null;
       var streetIdInput=null;
       var streetNumberIdInput=null;
       var streetEEIdInput=null;
       var streetNumberEEIdInput=null;
       if(streetinputobject != null && streetinputobject != 'undefined' && streetinputfield != 'undefined' && streetinputfield != null) 
           streetinput = objectDataMaptemp[streetinputobject][streetinputfield];
       var streetnumberinput =null;
       if(streetnumberinputobject != null && streetnumberinputobject != 'undefined' && streetnumberinputfield != 'undefined' && streetnumberinputfield != null) 
          streetnumberinput = objectDataMaptemp[streetnumberinputobject][streetnumberinputfield];
      if(sectionName != null && sectionName != ''){
         streetIdInput = 'strada'+sectionName;
         streetNumberIdInput = 'civico'+sectionName;
         component.set("v.stradaId", streetIdInput);
         component.set("v.civicoId", streetNumberIdInput);
         streetEEIdInput = 'streetEE'+sectionName;
         streetNumberEEIdInput = 'civicoEE'+sectionName;
         component.set("v.stradaEEId", streetEEIdInput);
         component.set("v.civicoEEId", streetNumberEEIdInput);
     }
     console.log('streetinput: '+streetinput);
        // var city = component.get("v.objectDataMap");
        console.log('objectDataMap : ' + JSON.stringify(objectDataMaptemp));
        component.set("v.streetString", streetinput);
        component.set("v.streetNumberString", streetnumberinput);
        
        if(streetinput)
        {
            helper.removeRedBorder(component, event, helper);
        }
        if(streetnumberinput)
        {
        	helper.removeRedBorderCivico(component, event, helper);
        }

    },
    
    completeAddress : function(component, event , helper){  
        var input = document.getElementById("strada").value;
        console.log('hasSPace'+ input.indexOf(' '));
        var idCom = component.get("v.comune");
        var idFraz = component.get("v.frazione");
        console.log("the id frazione into address child is: " + component.get("v.frazione"));
        console.log("the id co into address child is: " + component.get("v.frazione"));
        
        if(component.get("v.frazione") != '' && component.get("v.frazione") != undefined){
            console.log("into  id frazione not null: " + component.get("v.frazione"));
            helper.getResponse(component,'/strade?in='+input+'&loc='+idFraz,'strada');
            console.log("THE URL STRING IS:" + '/strade?in='+input+'&loc='+idFraz,'strada' );
            
        }else{
            console.log("into  id frazione null: " + component.get("v.frazione"));
            helper.getResponse(component,'/strade?in='+input+'&loc='+idCom,'strada');
            
        }
        document.getElementById("civico").disabled=false;
    },
    getValueEE : function(component, event , helper){  
        //****START EVENT METHOD****//
        console.log('getvalueEE');
        var sectionName = component.get("v.addressMapping.sectionName");
        if(sectionName == undefined || sectionName == null)
        	sectionName='';
        var streetinputobject = component.get("v.addressMapping.streetinputobject");
        var streetinputfield = component.get("v.addressMapping.streetinputfield");
        var street = document.getElementById('streetEE'+sectionName).value;
        component.set("v.objectDataMap."+ streetinputobject + "." + streetinputfield ,  street );
        var stradaEEId = component.get("v.stradaEEId");
		var regex = new RegExp("^[a-zA-Z0-9()?!&% $£  =^ °\/\"\.\']+$","g");
		street = street.replaceAll(/\\/,'0');
		if(street && !regex.test(street)){
			console.log('inside error');
			var errorId = 'errorId'+stradaEEId;
			var myDiv;
			
			myDiv = document.createElement('div');
			myDiv.setAttribute('id',errorId);//SET AN ID TO EVERY MESSAGE
			myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
			myDiv.setAttribute('class' , 'messageError'+stradaEEId);
			//SET THE MESSAGE
			var errorMessage = document.createTextNode($A.get("$Label.c.errorSpecialCharacter"));
			myDiv.appendChild(errorMessage);

			var idSet = document.getElementById(stradaEEId);
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
			component.set("v.objectDataMap.errorEEMap.isErrorEEStreet"+sectionName, true);
			
		} else {
			helper.removeRedBorderEE(component, event , helper);
			component.set("v.objectDataMap.errorEEMap.isErrorEEStreet"+sectionName, false);
			
		}
    },
    getValue: function(component, event, helper) { 
        var sectionName = component.get("v.addressMapping.sectionName");
        if(sectionName == undefined || sectionName == null)
        	sectionName='';
        var streetinputobject = component.get("v.addressMapping.streetinputobject");
        var streetinputfield = component.get("v.addressMapping.streetinputfield");
        var streetnumberinputobject = component.get("v.addressMapping.streetnumberinputobject");
        var streetnumberinputfield = component.get("v.addressMapping.streetnumberinputfield");
        var zipcodeinputobject = component.get("v.addressMapping.zipcodeinputobject");
        var zipcodeinputfield = component.get("v.addressMapping.zipcodeinputfield");
        
        //GET THE KEY FROM A VALUE
        var strada = document.getElementById("strada"+sectionName).value;
        var civico = document.getElementById("civico"+sectionName).value;
        //component.set("v.objectDataMap.pv.NE__Street__c" ,  strada );
        //component.set("v.objectDataMap.pv.OB_Street_Number__c" ,  civico );
        component.set("v.objectDataMap."+ streetinputobject + "." + streetinputfield ,  strada );
        component.set("v.objectDataMap."+ streetnumberinputobject + "." + streetnumberinputfield ,  civico );
        var myEvent = component.getEvent("AutocompleteEvent");
        var response = component.get("v.responseStreets");
        console.log("the responseStreets is: " + JSON.stringify(response));
        console.log("la strada è: " + strada);
        strada = strada.replace("&#39;","\'");
        var caps= [];
        /*for (var key in response){
            console.log("into the for");
            if(response[key]==strada){
                var chiaveNumeroCap=response['N_CAP_'+key];
                console.log(parseInt(chiaveNumeroCap));
                for(var i = 0;i<parseInt(chiaveNumeroCap);i++){
                    var chiave  = 'CAP_'+i+'_'+key;
                    console.log(chiave);
                    caps.push(response[chiave]);
                }
            }
        }*/
        helper.getCap(component,encodeURI(strada), component.get("v.objectDataMap.frazione")!=null ? component.get("v.objectDataMap.frazione") : component.get("v.objectDataMap.comune") );
        myEvent.setParams({"caps": caps });
        myEvent.fire(); 
        //Must set the first element of caps array because if we don't change the picklist we don't give value to the objectdatamap
        /*if(caps != null && caps != []){
        	console.log("I cap sono dentro: " + caps);
        	component.set("v.objectDataMap."+ zipcodeinputobject + "." + zipcodeinputfield ,  caps[0]); 
        }*/
        //NEXI-322 Kinga Fornal <kinga.fornal@accenture.com>, 16/09/2019 START
        component.set("v.streetString", strada);  
        component.set("v.streetNumberString", civico);
        //NEXI-322 Kinga Fornal <kinga.fornal@accenture.com>, 16/09/2019 STOP
        document.getElementById("frazione"+sectionName).disabled=true;
    },

    clearInput : function(component, event, helper) {
        //component.set("v.caps",'');
    },
    disableFunction: function(component,event,helper){

        var myEvent = component.getEvent("AutocompleteEvent");
        myEvent.setParams({"isDisabled": false });
        myEvent.fire()

    },
    // callService : function(component, event , helper){
    //     var sectionName = component.get("v.addressMapping.sectionName");
    //     if(sectionName == undefined || sectionName == null)
    //     	sectionName='';
    //     console.log(event.target.id);
    //     //var url = '/province';
    //     var idField;
    //     var field = event.target.id;
    //     var input = encodeURI(document.getElementById("strada"+sectionName).value);
    //     console.log('encode uri ' + component.get("v.frazione"));
    //     if(component.get("v.frazione") != '' && component.get("v.frazione") != undefined ){
    //         idField = component.get("v.frazione")==null?component.get("v.objectDataMap.district"):component.get("v.frazione") ; 
    //         console.log('idField frazione' +idField);
    //     } else {
    //         idField = component.get("v.comune")==null?component.get("v.objectDataMap.comune"):component.get("v.comune");
    //         console.log('idField comune' +idField);
    //     }
    //     if(input.length%2==0){
    //      var request = $A.get("e.c:OB_ContinuationRequest");
    //      console.log('siamo nel completeProvincia, stampo la request: '+request);
    //      request.setParams({ 
    //          methodName: "getPostel",
    //          methodParams: [field, input, idField],
    //          callback: function(result) {
    //              console.log('RISULTATO: '+ result);
    //              component.set("v.responseStreets" , result);
    //              helper.street(component, event , helper);

    //          }
    //      });
    //      request.fire();
    //  }


    //     //console.log("prov response : " + component.get("v.response"));
    // }, 

//********************call for cities***********************
callStreet : function(component, event, helper) {
    console.log("****in getStreet");
        // var field = event.target.id;
        var sectionName = component.get("v.addressMapping.sectionName");
        if(sectionName == undefined || sectionName == null)
            sectionName='';
        var input = encodeURI(document.getElementById("strada"+sectionName).value);
        var idField;
        if(component.get("v.frazione") != '' && component.get("v.frazione") != undefined ){
            idField = component.get("v.frazione")==null?component.get("v.objectDataMap.district"):component.get("v.frazione") ; 
            console.log('idField frazione' +idField);
        } else {
            idField = component.get("v.comune")==null?component.get("v.objectDataMap.comune"):component.get("v.comune");
            console.log('idField comune' +idField);
        }
        console.log("comune: "+component.get("v.comune"));
        console.log("frazione: "+component.get("v.frazione"));

        var action = component.get("c.getStreet");
        action.setParams({
            "input": input,
            "idField": idField 
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log("state: "+state);
            if (state === "SUCCESS") {
                var res = response.getReturnValue()
                console.log('****RESPONSE STREET: '+JSON.stringify(res));
                component.set("v.responseStreets", res);
                helper.street(component, event , helper); //NEXI-322 Kinga Fornal <kinga.fornal@accenture.com>, 13/09/2019
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




    street:function(component, event , helper){
        var sectionName = component.get("v.addressMapping.sectionName");
        if(sectionName == undefined || sectionName == null)
        	sectionName='';
        document.getElementById("comune"+sectionName).disabled=false;
        document.getElementById("frazione"+sectionName).disabled=false;
        document.getElementById("strada"+sectionName).disabled=false;
        document.getElementById("civico"+sectionName).disabled=false;
        console.log('zipcodeId'+component.find("zipcode"));
        helper.removeRedBorder(component, event, helper);
        //.disabled=false;
        //component.set("v.addressMapping.zipcodedisabled",'false'); 

        //NEXI-322 Kinga Fornal <kinga.fornal@accenture.com>, 13/09/2019 START
        let streetString = component.get("v.streetString");
        let streetInputValue = document.getElementById("strada"+sectionName).value;

        let mapping = component.get("v.addressMapping");
        mapping.citydisabled = 'false';
        mapping.provincedisabled = 'false';
        mapping.streetdisabled = 'false';
        mapping.streetnumberdisabled = 'false';
        mapping.districtdisabled = 'false';
        mapping.zipcodedisabled = 'false';
        mapping.pressodisabled = 'false';
        if ( streetString != streetInputValue || streetInputValue == '' || streetInputValue == null ){
            component.set("v.streetString", '');
            component.set("v.streetNumberString", '');
        }
        component.set("v.addressMapping", mapping );

        let stradaId = component.get("v.stradaId");
        let j$ = jQuery.noConflict();
        j$('[id$="'+stradaId+'"]').autocomplete({source: []});
        //NEXI-322 Kinga Fornal <kinga.fornal@accenture.com>, 13/09/2019 STOP
    },
    getValueStreetNumberEE : function(component, event, helper){
      var sectionName = component.get("v.addressMapping.sectionName");
      if(sectionName == undefined || sectionName == null)
       sectionName='';
	   var streetnumberinputobject = component.get("v.addressMapping.streetnumberinputobject");
	   var streetnumberinputfield = component.get("v.addressMapping.streetnumberinputfield");
        //GET THE KEY FROM A VALUE
        var civico = document.getElementById("civicoEE"+sectionName).value;
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
			myDiv.setAttribute('id',errorId);//SET AN ID TO EVERY MESSAGE
			myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
			myDiv.setAttribute('class' , 'messageError'+civicoEEId);
			//SET THE MESSAGE
			var errorMessage = document.createTextNode($A.get("$Label.c.errorSpecialCharacter"));
			myDiv.appendChild(errorMessage);

			var idSet = document.getElementById(civicoEEId);
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
			component.set("v.objectDataMap.errorEEMap.isErrorEECivico"+sectionName, true);
			
		} else {
			helper.removeRedBorderCivicoEE(component, event , helper);
			component.set("v.objectDataMap.errorEEMap.isErrorEECivico"+sectionName, false);
			
		}
    },
    getValueStreetNumber : function(component, event, helper){
    	var sectionName = component.get("v.addressMapping.sectionName");
        if(sectionName == undefined || sectionName == null)
        	sectionName='';
        var streetnumberinputobject = component.get("v.addressMapping.streetnumberinputobject");
        var streetnumberinputfield = component.get("v.addressMapping.streetnumberinputfield");
        //GET THE KEY FROM A VALUE
        var civico = document.getElementById("civico"+sectionName).value;
        console.log('civico onchange'+civico);
        component.set("v.objectDataMap."+ streetnumberinputobject + "." + streetnumberinputfield ,  civico );
    },
    removeRedBorder: function(component, event, helper) {

        helper.removeRedBorder(component, event, helper);
    },
    removeRedBorderCivico: function(component, event, helper) {

        helper.removeRedBorderCivico(component, event, helper);
    },
    removeRedBorderEE: function(component, event, helper) {

        helper.removeRedBorderEE(component, event, helper);
    },
    removeRedBorderCivicoEE: function(component, event, helper) {

        helper.removeRedBorderCivicoEE(component, event, helper);
    },
    blankValue : function(component, event, helper) {
    	var streetinputobject = component.get("v.addressMapping.streetinputobject");
        var streetinputfield = component.get("v.addressMapping.streetinputfield");
        console.log('streetinputobject : ' + streetinputobject + ' streetinputfield: ' + streetinputfield);
        var streetnumberinputobject = component.get("v.addressMapping.streetnumberinputobject");
        var streetnumberinputfield = component.get("v.addressMapping.streetnumberinputfield");
        component.set("v.objectDataMap."+ streetinputobject + "." + streetinputfield ,  '' );
        component.set("v.objectDataMap."+ streetnumberinputobject + "." + streetnumberinputfield ,  '' );
        component.set("v.streetString", '');
        component.set("v.streetNumberString", '');
        helper.removeRedBorder(component, event, helper);
        helper.removeRedBorderCivico(component, event, helper);
        helper.removeRedBorderEE(component, event, helper);
        helper.removeRedBorderCivicoEE(component, event, helper);
    }
})