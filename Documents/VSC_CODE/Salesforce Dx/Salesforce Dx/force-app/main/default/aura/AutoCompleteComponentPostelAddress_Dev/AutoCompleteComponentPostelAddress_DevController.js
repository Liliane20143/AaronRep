({

    doInit: function(component, event , helper) {
        String.prototype.replaceAll = function(search, replacement) {
            let target = this;
            return target.replace(new RegExp(search, 'g'), replacement);
        };
        let streetinputobject = component.get("v.addressMapping.streetinputobject");
        let streetinputfield = component.get("v.addressMapping.streetinputfield");
        let streetnumberinputobject = component.get("v.addressMapping.streetnumberinputobject");
        let streetnumberinputfield = component.get("v.addressMapping.streetnumberinputfield");
        let objectDataMaptemp = component.get("v.objectDataMap");
        let sectionName = component.get("v.addressMapping.sectionName");
        let streetinput = null;
        let streetIdInput = null;
        let streetNumberIdInput = null;
        let streetEEIdInput = null;
        let streetNumberEEIdInput = null;

        if( streetinputobject != null && streetinputobject != 'undefined' && streetinputfield != 'undefined' && streetinputfield != null )
        {
           streetinput = objectDataMaptemp[streetinputobject][streetinputfield];
        }

        let streetnumberinput = null;

        if(streetnumberinputobject != null && streetnumberinputobject != 'undefined'
            && streetnumberinputfield != 'undefined' && streetnumberinputfield != null)
        {
            streetnumberinput = objectDataMaptemp[streetnumberinputobject][streetnumberinputfield];
        }

        if( sectionName != null && sectionName != undefined )
        {
            component.set("v.stradaId", 'strada' + sectionName);
            component.set("v.civicoId", 'civico' + sectionName);
            component.set("v.stradaEEId", 'streetEE' + sectionName);
            component.set("v.civicoEEId", 'civicoEE' + sectionName);
        }

        component.set("v.streetString", streetinput);
        component.set("v.streetNumberString", streetnumberinput);
        
//        if( streetinput )
//        {
//            helper.removeRedBorder(component, event, helper);
//        }
//
//        if(streetnumberinput)
//        {
//            helper.removeRedBorderCivico(component, event, helper);
//        }
        helper.setInputLabel(component);
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
				}
			}//END FOR
			component.set("v.objectDataMap.errorEEMap.isErrorEEStreet"+sectionName, true);
			
		} else {
			helper.removeRedBorderEE(component, event , helper);
			component.set("v.objectDataMap.errorEEMap.isErrorEEStreet"+sectionName, false);
			
		}
    },

    callStreet : function(component, event, helper) {
        $A.util.removeClass( component.find("addressSuggestion"), "slds-hide" );
        let sectionName = component.get("v.addressMapping.sectionName");
        if(sectionName == undefined || sectionName == null)
        {
            sectionName = '';
        }
        let input = encodeURI(document.getElementById("strada" + sectionName).value);
        let idField;
        if(component.get("v.frazione") != '' && component.get("v.frazione") != undefined ){
            idField = component.get("v.frazione") == null ? component.get("v.objectDataMap.district") : component.get("v.frazione");
        }
        else
        {
            idField = component.get("v.comune") == null ? component.get("v.objectDataMap.comune") : component.get("v.comune");
        }

        let action = component.get("c.getStreet");
        action.setParams({
            "input": input,
            "idField": idField 
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS")
            {
                let responseStreets = response.getReturnValue();
                component.set("v.responseStreets", responseStreets);
                helper.getStreets(component, event , helper);
            } 
            else
            {
                let errors = response.getError();
                if (errors)
                {
                    if (errors[0] && errors[0].message)
                    {
                        console.log("Error message: " + errors[0].message);
                    }
                }
                else
                {
                    console.log("****Unknown error");
                }
            }
        });

        $A.enqueueAction(action);
    }, 

    street: function(component, event , helper){
        let stradaId = component.get("v.stradaId");
        if (document.getElementById(stradaId).value == '')
        {
            $A.util.addClass(component.find("addressSuggestion"), "slds-hide");
            component.set("v.caps", "");
        }
        let sectionName = component.get("v.addressMapping.sectionName");
        if(sectionName == undefined || sectionName == null)
        {
        	sectionName = '';
        }
        document.getElementById("comune" + sectionName).disabled = false;
        document.getElementById("frazione" + sectionName).disabled = false;
        document.getElementById("strada" + sectionName).disabled = false;
        document.getElementById("civico" + sectionName).disabled = false;
       //  helper.removeRedBorder(component, event, helper);
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
				}
			}//END FOR
			component.set("v.objectDataMap.errorEEMap.isErrorEECivico"+sectionName, true);
			
		} else {
			helper.removeRedBorderCivicoEE(component, event , helper);
			component.set("v.objectDataMap.errorEEMap.isErrorEECivico"+sectionName, false);
		}
    },

    getValueStreetNumber : function(component, event, helper){
    	let sectionName = component.get("v.addressMapping.sectionName");
        if(sectionName == undefined || sectionName == null)
        {
        	sectionName = '';
        }
        let streetnumberinputobject = component.get("v.addressMapping.streetnumberinputobject");
        let streetnumberinputfield = component.get("v.addressMapping.streetnumberinputfield");
        //GET THE KEY FROM A VALUE
        let civico = document.getElementById("civico" + sectionName).value;
        component.set("v.objectDataMap." + streetnumberinputobject + "." + streetnumberinputfield ,  civico );
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
    	let streetinputobject = component.get("v.addressMapping.streetinputobject");
        let streetinputfield = component.get("v.addressMapping.streetinputfield");
        let streetnumberinputobject = component.get("v.addressMapping.streetnumberinputobject");
        let streetnumberinputfield = component.get("v.addressMapping.streetnumberinputfield");
        component.set("v.objectDataMap." + streetinputobject + "." + streetinputfield ,  '' );
        component.set("v.objectDataMap." + streetnumberinputobject + "." + streetnumberinputfield ,  '' );
        component.set("v.streetString", '');
        component.set("v.streetNumberString", '');
//        helper.removeRedBorder(component, event, helper);
//        helper.removeRedBorderCivico(component, event, helper);
        helper.removeRedBorderEE(component, event, helper);
        helper.removeRedBorderCivicoEE(component, event, helper);
    },

    // joanna.mielczarek@accenture.com 28/03/2019
    selectOption: function(component, event, helper) {
        let selectedItem = event.currentTarget;
        let index = selectedItem.dataset.record;
        let address = component.get("v.filteredOptions")[index];

        // TODO find another way to set value of streetString
        document.getElementById(component.get("v.stradaId")).value = address.label;

        let strada = document.getElementById(component.get("v.stradaId")).value;
        let streetInputObject = component.get("v.addressMapping.streetinputobject");
        let streetInputField = component.get("v.addressMapping.streetinputfield");
        strada = strada.replace("&#39;","\'");
        component.set("v.objectDataMap." + streetInputObject + "." + streetInputField ,  address.value);
        let caps = [];
        helper.getCap(component, encodeURI(strada), component.get("v.objectDataMap.frazione") != null ? component.get("v.objectDataMap.frazione") : component.get("v.objectDataMap.comune") );
        let myEvent = component.getEvent("AutocompleteEvent");
        myEvent.setParams({
            "caps": component.get("v.caps")
        });
        myEvent.fire();

        let sectionName = component.get("v.addressMapping.sectionName");
        if(sectionName == undefined || sectionName == null)
        {
        	sectionName = '';
        }
        $A.util.addClass(component.find("addressSuggestion"), "slds-hide");
        document.getElementById("frazione" + sectionName).disabled = true;
    }
})