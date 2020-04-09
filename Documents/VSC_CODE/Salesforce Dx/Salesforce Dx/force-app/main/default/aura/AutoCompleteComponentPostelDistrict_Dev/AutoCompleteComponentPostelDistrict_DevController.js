({  
	doInit : function(component, event, helper) { 
		String.prototype.replaceAll = function(search, replacement) {
		    var target = this;
		    return target.replace(new RegExp(search, 'g'), replacement);
		};
		console.log('function do Init of AutoCompleteDistrict');
		let sectionName = component.get("v.addressMapping.sectionName");
		if(sectionName == undefined || sectionName == null)
			sectionName='';
		let districtinputobject = component.get("v.addressMapping.districtinputobject");
		let districtinputfield = component.get("v.addressMapping.districtinputfield");
		console.log('districtinputobject : ' + districtinputobject + ' districtinputfield: ' + districtinputfield);
	    let objectDataMaptemp = component.get("v.objectDataMap");
	    let districtinput=null;
	    let districtIdInput=null;
	    let districtIdEEInput=null;
	    if(districtinputobject != null && districtinputobject != 'undefined' && districtinputfield != 'undefined' && districtinputfield != null)
	   	districtinput = objectDataMaptemp[districtinputobject][districtinputfield];
	    if(sectionName != null && sectionName != ''){
	   	districtIdInput = 'frazione'+sectionName;
	   	component.set("v.districtId", districtIdInput);
	   	districtIdEEInput = 'districtEE'+sectionName;
	   	component.set("v.districtEEId", districtIdEEInput);
	   }
	    console.log('districtinput : '+ districtinput);
	    console.log('objectDataMap : ' + JSON.stringify(objectDataMaptemp));
		component.set("v.districtString", districtinput);
        helper.setInputLabel(component);
	},

	getValueEE : function(component, event , helper){  
		let sectionName = component.get("v.addressMapping.sectionName");
		if(sectionName == undefined || sectionName == null)
			sectionName='';
		//****START EVENT METHOD****//
		let districtinputobject = component.get("v.addressMapping.districtinputobject");
		let districtinputfield = component.get("v.addressMapping.districtinputfield");
		let district = document.getElementById('districtEE'+sectionName).value;
		component.set("v.objectDataMap."+ districtinputobject + "." + districtinputfield ,  district );
        let regex = new RegExp("^[a-zA-Z0-9()?!&% $£  =^ °\/\"\.\']+$","g");
		district = district.replaceAll(/\\/,'0');
		if(district && !regex.test(district)){
			let errorId = 'errorIddistrictEE'+sectionName;
			let myDiv;
			
			myDiv = document.createElement('div');
			myDiv.setAttribute('id',errorId);//SET AN ID TO EVERY MESSAGE
			myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
			myDiv.setAttribute('class' , 'messageErrordistrictEE'+sectionName);
			//SET THE MESSAGE
			let errorMessage = document.createTextNode($A.get("$Label.c.errorSpecialCharacter"));
			myDiv.appendChild(errorMessage);

			let idSet = document.getElementById('districtEE'+sectionName);
			if(idSet!=null && idSet!= undefined)
			{ 
				if(!(document.getElementById(errorId)))
				{
					idSet.after(myDiv);
					$A.util.addClass(idSet, 'slds-has-error flow_required');
				}
			}//END FOR
			component.set("v.objectDataMap.errorEEMap.isErrorEEDist"+sectionName, true);
			
		} else {
			helper.removeRedBorderEE(component, event , helper);
			component.set("v.objectDataMap.errorEEMap.isErrorEEDist"+sectionName, false);
		}
	},

//********************call for cities***********************
    callDistrict : function(component, event, helper) {
	console.log("****in getDistrict");
	$A.util.removeClass( component.find("districtSuggestion"), "slds-hide");
		let sectionName = component.get("v.addressMapping.sectionName");
		if(sectionName == undefined || sectionName == null)
			sectionName='';
		let input = encodeURI(document.getElementById("frazione"+sectionName).value);
		let idField = component.get("v.comune")==null ? component.get("v.objectDataMap.comune") : component.get("v.comune");

		let action = component.get("c.getDistrict");
		action.setParams({
			"input": input,
			"idField": idField 
		});
		action.setCallback(this, function(response){
			let state = response.getState();
			console.log("state: "+state);
			if (state === "SUCCESS") {
				let res = response.getReturnValue();
				component.set("v.responseDistr", res);
				helper.district(component, event , helper);
			} 
			else if (state === "INCOMPLETE") {
			} 
			else if (state === "ERROR") {
				let errors = response.getError();
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
		let sectionName = component.get("v.addressMapping.sectionName");
		if(sectionName == undefined || sectionName == null)
			sectionName='';
		document.getElementById("comune"+sectionName).disabled=false;
		document.getElementById("frazione"+sectionName).disabled=false;
		document.getElementById("strada"+sectionName).disabled=false;
		document.getElementById("civico"+sectionName).disabled=false;
	},

	blankValue : function(component, event, helper) {
		let districtinputobject = component.get("v.addressMapping.districtinputobject");
		let districtinputfield = component.get("v.addressMapping.districtinputfield");
		component.set("v.objectDataMap."+ districtinputobject + "." + districtinputfield ,  '' );
		component.set("v.districtString", '');
		helper.removeRedBorderEE(component, event, helper);
	},

	selectOption: function(component, event, helper) {
            let selectedItem = event.currentTarget;
            let index = selectedItem.dataset.record;
            let district = component.get("v.filteredOptions")[index];

            document.getElementById("frazione").value = district.label;

            let frazione = document.getElementById(component.get("v.districtId")).value;
            let districtInputObject = component.get("v.addressMapping.districtinputobject");
            let districtInputField =  component.get("v.addressMapping.districtinputfield");
            component.set("v.objectDataMap."+ districtInputObject + "." + districtInputField , frazione);

            $A.util.addClass(component.find("districtSuggestion"), "slds-hide");
    }
})