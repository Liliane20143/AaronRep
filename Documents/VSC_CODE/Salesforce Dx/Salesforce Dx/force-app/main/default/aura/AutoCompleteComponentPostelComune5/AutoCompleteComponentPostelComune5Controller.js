({  
	doInit : function(component, event, helper)
	{
		String.prototype.replaceAll = function(search, replacement)
		{
		    var target = this;
		    return target.replace(new RegExp(search, 'g'), replacement);
		};

		let cityinputobject = component.get("v.addressMapping.cityinputobject");
		let cityinputfield = component.get("v.addressMapping.cityinputfield");

        let objectDataMaptemp = component.get("v.objectDataMap");
        let cityinput=null;
        if(cityinputobject != null && cityinputobject != undefined && cityinputfield != undefined && cityinputfield != null)
        {
            cityinput = objectDataMaptemp[cityinputobject][cityinputfield];
        }
        let sectionName = component.get("v.addressMapping.sectionName");
        if(sectionName != undefined && sectionName != null)
        {
            component.set("v.cityId", 'comune'+sectionName);
            component.set("v.cityEEId", 'cityEE'+sectionName);
        }

        if(cityinput!='')
        {
            helper.removeRedBorder(component, event, helper);
        }
        component.set("v.cityString", cityinput);
        helper.setInputLabel(component);
	},

	getValueEE : function(component, event , helper)
	{
		//****START EVENT METHOD****//
		var sectionName = component.get("v.addressMapping.sectionName");
		if(sectionName == undefined || sectionName == null)
		{
			sectionName='';
        }
		var cityinputobject = component.get("v.addressMapping.cityinputobject");
		var cityinputfield = component.get("v.addressMapping.cityinputfield");
		var city = document.getElementById('cityEE'+sectionName).value;
		var cityEEId = component.get("v.cityEEId");
		component.set("v.objectDataMap."+ cityinputobject + "." + cityinputfield ,  city );
		var regex = new RegExp("^[a-zA-Z0-9()?!&% $£  =^ °\/\"\.\']+$","g");
		city = city.replaceAll(/\\/,'0');
		if(city && !regex.test(city))
		{
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
			if(idSet!=null && idSet!= undefined)
			{ 
				if(!(document.getElementById(errorId)))
				{
					idSet.after(myDiv);
					$A.util.addClass(idSet, 'slds-has-error flow_required');
				}
			}//END FOR
			component.set("v.objectDataMap.errorEEMap.isErrorEECity"+sectionName, true);
		}
		else
		{
			helper.removeRedBorderEE(component, event , helper);
			component.set("v.objectDataMap.errorEEMap.isErrorEECity"+sectionName, false);
		}
	},

	//*******METHOD TO CLEAR THE CASCADE COMPONENT*******//
	clearInput : function(component, event, helper)
	{
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
	},

    //********************call for cities***********************
    callCities : function(component, event, helper)
    {
        console.log("****in callCities");
        $A.util.removeClass( component.find("addressSuggestion"), "slds-hide");
		var input = encodeURI(event.target.value);
		let province = component.get("v.province") == null ? component.get("v.objectDataMap.province") : component.get("v.province");

		var action = component.get("c.getCities");
		action.setParams
		({
			"input": input,
			"idField": province
		});
		action.setCallback(this, function(response)
		{
			var state = response.getState();
			if (state === "SUCCESS")
			{
				var res = response.getReturnValue()
				component.set("v.responseCom", res);
				helper.city(component, event , helper);
			} 
			else
			{
				var errors = response.getError();
				if (errors)
				{
					if (errors[0] && errors[0].message)
					{
						console.log("Error message: " +  errors[0].message);
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

	comune: function(component, event , helper)
	{
		var sectionName = component.get("v.addressMapping.sectionName");
		var comuneId = component.get("v.cityId");
		if(document.getElementById(comuneId).value == '')
		{
            $A.util.addClass( component.find("addressSuggestion"), "slds-hide");
        }
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
		//helper.removeRedBorder(component, event, helper);
		var section = component.get("v.addressMapping.sectionName");

		if(section != undefined && section.includes('Birth'))
		{
			var province = component.get("v.objectDataMap."+component.get("v.addressMapping.provinceinputobject")+".OB_Birth_State__c");
			var city=event.target.value;
			console.log(province+'_'+ city);
			var url = 'callout:OB_doNormJSON/doNormJSON?provincia='+encodeURI(province)+'&localita='+encodeURI(city);
			var action = component.get("c.getCadastrialCode");
	        console.log('******printing Action: '+ action);
	        action.setStorable();
	        action.setParams
	        ({
				url : url
            });
	        action.setCallback(this, function (response)
	        {
	            var state = response.getState();
	            if (state === "SUCCESS")
	            {
	                component.set("v.objectDataMap."+component.get("v.addressMapping.provinceinputobject")+".OB_Cadastral_Code__c",response.getReturnValue());
	            }
	            else
	            {
	                var errors = response.getError();
	                if (errors)
	                {
	                    if (errors[0] && errors[0].message)
	                    {
	                        console.log("Error message: " +  errors[0].message);
	                    }
	                }
	                else
	                {
	                    console.log("Unknown error");
	                }
	            }
	        });
	        $A.enqueueAction(action);
		}
	},

	removeRedBorderEE: function(component, event, helper)
	{
		helper.removeRedBorderEE(component, event, helper);
	},

	blankValue : function(component, event, helper)
	{
		var cityinputobject = component.get("v.addressMapping.cityinputobject");
		var cityinputfield = component.get("v.addressMapping.cityinputfield");
		component.set("v.objectDataMap."+ cityinputobject + "." + cityinputfield ,  '' );
		component.set("v.cityString", '');
		//helper.removeRedBorder(component, event, helper);
		helper.removeRedBorderEE(component, event, helper);
	},

	// joanna.mielczarek@accenture.com 28/03/2019
	selectOption: function(component, event, helper)
    {
        let selectedItem = event.currentTarget;
        let index = selectedItem.dataset.record;
        let city = component.get("v.filteredOptions")[index];

        document.getElementById(component.get("v.cityId")).value = city.label; //TOD change to cityString
        component.set("v.objectDataMap.comune",city.value);

        var cityinputobject = component.get("v.addressMapping.cityinputobject");
        var cityinputfield = component.get("v.addressMapping.cityinputfield");
        component.set("v.objectDataMap."+ cityinputobject + "." + cityinputfield ,  city.label );

        var myEvent = component.getEvent("AutocompleteEvent");
        myEvent.setParams({"comune": city.value });
        myEvent.fire()

        $A.util.addClass(component.find("addressSuggestion"), "slds-hide");
    }
})