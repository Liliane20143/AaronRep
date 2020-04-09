({
	doInit : function(component, event, helper) {
		// helper.prova(component, event, helper);
		//START gianluigi.virga 02/09/2019
		helper.retrieveTitolariEffettiviFromServer(component, event, helper);
		//END gianluigi.virga
	},

    /**
    *@author ?
    *@date ?
    *@description ?
    *@history ? Method created
    *@history 11/09/2019 <grzegorz.banach@accenture.com> NEXI-323 Click event fix, added "isInitialized" variable to the condition
    */
	onRender : function (component, event, helper)
	{
        //NEXI-323 Grzegorz Banach <grzegorz.banach@accenture.com> 11/09/2019 START
	    let doneRender = component.get("v.doneRender");
        let isInitialized = component.get("v.isInitialized");
		if ( !doneRender && isInitialized )
		{
			let currentButton = document.getElementById('buttonDiv1').childNodes[0];
			console.log('currentButton: '+currentButton);
			currentButton.click();
			//NEXI-323 Grzegorz Banach <grzegorz.banach@accenture.com> 11/09/2019 STOP
			component.set("v.doneRender",true);
		}
	},


	closeBanner: function (component, event, helper){
		component.set('v.hasMessage', false);
	},


	aggiungiTitolare : function (component, event, helper){
		component.set("v.objectDataMap.checkMapValues", {});
		console.log("add Titolare");	
		component.set('v.addOwner','');
		var objectDataMap=component.get("v.objectDataMap");
		var sections= component.get("v.sections");
		var lastIndex = component.get('v.objectDataMap.lastContact');
		var lastContact = sections[lastIndex-1];
		var contactToCheck= objectDataMap['contact'+lastIndex];
		var legRapp= component.find('legRapp');
		console.log("add Titolare lastcont  "+JSON.stringify(lastContact));
		var sectionFullFilled=false;
		var errorDate = component.get("v.objectDataMap.errorDateMap");
        for(var error in errorDate){
        	if(errorDate[error] == true){
        		sectionFullFilled=true;
        	}
        }
		
		for(var key in lastContact){
			if(helper.fieldsToCheckAdd(key)){
				if(objectDataMap['contact'+lastIndex][key]==null || objectDataMap['contact'+lastIndex][key]==''){
					if(!helper.skipMandatory(key, contactToCheck)){
						console.log("missing field : "+ key);
						sectionFullFilled=true;
						break;
					}
				}
			}
		}
		if(sectionFullFilled){
			objectDataMap.setRedBordercompanyData = true;
			helper.elementsRequired(component, lastIndex);
			var myEvent = $A.get("e.c:OB_EventAutoCompleteRedBorder");
			console.log("*****objectDataMap: " + JSON.stringify(component.get("v.objectDataMap")));
			console.log("firing evt");
			myEvent.fire();
			console.log("fire evt");
			component.set('v.addOwner', "true");
		}else {
			// helper.checkedTaxValue(component, lastIndex);
			helper.checkValidation(component, lastIndex, true);
			console.log('section check val'+(component.get("v.objectDataMap.setRedBordercompanyDataValidation")));
			sectionFullFilled = (component.get("v.objectDataMap.setRedBordercompanyDataValidation"));
		}

	},



	explodeTitolare1 : function(component, event, helper){
		if(component.get('v.objectDataMap.lastContact') != 1){
			helper.checkMandatorySection(component, 1);
		} else {
			component.set('v.objectDataMap.contactToGo',1);
			helper.changeOwnerMethod2(component,event,helper);
		}
	},

	explodeTitolare2 : function(component, event, helper){
		if(component.get('v.objectDataMap.lastContact') != 2){
			helper.checkMandatorySection(component, 2);
		} else {
			component.set('v.objectDataMap.contactToGo',2);
			helper.changeOwnerMethod2(component,event,helper);
		}
	},

	explodeTitolare3 : function(component, event, helper){
		if(component.get('v.objectDataMap.lastContact') != 3){
			helper.checkMandatorySection(component, 3);
		} else {
			component.set('v.objectDataMap.contactToGo',3);
			helper.changeOwnerMethod2(component,event,helper);
		}
	},

	explodeTitolare4 : function(component, event, helper){
		if(component.get('v.objectDataMap.lastContact') != 4){
			helper.checkMandatorySection(component, 4);
		} else {
			component.set('v.objectDataMap.contactToGo',4);
			helper.changeOwnerMethod2(component,event,helper);
		}
	},

	explodeTitolare5 : function(component, event, helper){
		if(component.get('v.objectDataMap.lastContact') != 5){
			helper.checkMandatorySection(component, 5);
		} else {
			component.set('v.objectDataMap.contactToGo',5);
			helper.changeOwnerMethod2(component,event,helper);
		}
	},

	explodeTitolare6 : function(component, event, helper){
		if(component.get('v.objectDataMap.lastContact') != 6){
			helper.checkMandatorySection(component, 6);
		} else {
			component.set('v.objectDataMap.contactToGo',6);
			helper.changeOwnerMethod2(component,event,helper);
		}
	},

	handleDelete : function (component, event, helper){
		var index = parseInt(event.getParam("position"))-1;
		var sections = component.get('v.sections');
		var lastIndex = sections.length;
		var objectDataMap=component.get("v.objectDataMap");
		for(var i = 1; i<=sections.length; i++){
			sections[i-1]= objectDataMap['contact'+i];
		}
		var ListContactsInactive= component.get('v.ListInactive');
		if(sections[index]['Id']!=null && sections[index]['Id']!='' ){
			ListContactsInactive.push(sections[index]['Id']);
		}

		var indexContact= (index+1).toString();
		console.log("********ID: "+JSON.stringify(objectDataMap['contact'+indexContact]));
		component.set('v.ListInactive', ListContactsInactive);
		component.set('v.objectDataMap.ListContactsInactive', ListContactsInactive);
		console.log('****ListContactsInactive: '+JSON.stringify(objectDataMap.ListContactsInactive))
		sections.splice(index, 1);
		objectDataMap['unbind']['required'+lastIndex] = "not_required";
		for(var i = 1; i<=6; i++){
			if(i>sections.length){
				objectDataMap['unbind']['clean'+i]='hide';
				var btn= component.find("button"+i);
				btn.set("v.disabled",true);
				// $A.util.addClass(btn, 'button');
				var contactToClear = objectDataMap['contact'+i];
				for(var key in contactToClear){
					console.log('key');
					if(key == 'Account' || key == 'RecordType'){
						objectDataMap['contact'+i][key]=null;
					} else {
						objectDataMap['contact'+i][key]="";
					}
					
				}
			}
			if(i<=sections.length){
				var btn= component.find("button"+i);
				btn.set("v.disabled",false);
				for(var key in sections[i-1]){
					objectDataMap['contact'+i][key]= sections[i-1][key];
				}
				if(i==sections.length) {
					objectDataMap['unbind']['clean'+i]='show';
					$A.util.removeClass(btn, 'button');
					if(i==1){
						var legRapp= component.find('legRapp');
						$A.util.addClass(component.find("legRapp"), 'slds-show');
						$A.util.removeClass(component.find("legRapp"), 'slds-hide');
					}
				} else {
					objectDataMap['unbind']['clean'+i]='hide';
					var isDisabled= btn.get("v.disabled");
					if(isDisabled==false){
						$A.util.addClass(btn, 'button');
					}
				}
			}
		}
		if(sections.length<=5){
			var addOwnerBtn= component.find('AddOwnerBtn');
			addOwnerBtn.set('v.disabled', false);
		}
		component.set('v.objectDataMap', objectDataMap);
		component.set('v.sections', sections);
		var myEvent = $A.get("e.c:OB_EventAutoCompleteReInit");
		console.log("firing evt");
		myEvent.fire();
		console.log("fire evt");
		console.log('sections.length: '+sections.length);
		component.set('v.objectDataMap.lastContact', sections.length);
		helper.removeRedBorderAll(component,event,helper);
	},

	updateFieldLegaleRapp: function(component,event,helper){
		var objectDataMap = component.get("v.objectDataMap");
		helper.legaleRapp(component,event,helper);
		
	},

	addOwnerMethod1 : function(component,event,helper){
		var checkVal = component.get('v.addOwner');
		// var CFvalid = component.get("v.isValid");
		if(checkVal != ""){
			console.log('checkval bool'+checkVal);
			if(checkVal == 'false'){
				helper.addOwnerMethod2(component,event,helper);
			}
			else{
				console.log("****controller addowner");
				component.set('v.hasMessage', true);
			}
		}
	},
	
	changeOwnerMethod1 : function(component,event,helper){
		var checkVal = component.get('v.changeOwner');
		// var CFvalid = component.get("v.isValid");
		if(checkVal != ""){
			console.log('checkval bool'+checkVal);
			if(checkVal == 'false'){
				helper.changeOwnerMethod2(component,event,helper);
			}
			else{
				console.log("****controller addowner");
				component.set('v.hasMessage', true);
			}
		}
	},



})