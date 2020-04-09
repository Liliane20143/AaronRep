({
	disableFields : function(component, event, helper) {
		var dis= component.get("v.disabled");
		var myInputs = component.find("MainDiv").find({instancesOf : "lightning:input"});
		for(var i = 0; i < myInputs.length; i++){
			console.log(myInputs[i]);
			myInputs[i].set('v.disabled',dis);
		}
	},
	getCompanyLinkTypes : function (component, event )
	{
		var actionGetCompanyLinkTypes = component.get("c.getCompanyLinkTypes");
		var objectDataMap = component.get("v.objectDataMap");
		actionGetCompanyLinkTypes.setCallback(this, function(response)
		{
			 var state = response.getState();
			 if (state === "SUCCESS") 
			 {
				 var  tempMap =[];
				 var  responseMap= response.getReturnValue();
				 for(var key in responseMap)
				 {
					tempMap.push({value:responseMap[key], key:key});
				 }
				 component.set( "v.companyLinkTypesList",  tempMap);
				 console.log("Value of picklist report type: "+tempMap);
			 } 
			 else if (state === "INCOMPLETE") 
			 {
				 // do something
			 }
			 else if (state === "ERROR") 
			 {
				var errors = response.getError();
				if (errors) 
				{
					if (errors[0] && errors[0].message) 
					{
						console.log("Error message: " + errors[0].message);
					}
				}
				else 
				{
					console.log("Unknown error");
				}
			 }
		 });
		$A.enqueueAction(actionGetCompanyLinkTypes); 
	},
	
	getGenders : function (component, event )
	{
		var actionGetGenders = component.get("c.getGenders");
		var objectDataMap = component.get("v.objectDataMap");
		actionGetGenders.setCallback(this, function(response)
		{
			 var state = response.getState();
			 if (state === "SUCCESS") 
			 {
				 var  tempMap =[];
				 var  responseMap= response.getReturnValue();
				 for(var key in responseMap)
				 {
					tempMap.push({value:responseMap[key], key:key});
				 }
				 component.set( "v.genderList",  tempMap);
				 console.log("Value of picklist report type: "+tempMap);
			 } 
			 else if (state === "INCOMPLETE") 
			 {
				 // do something
			 }
			 else if (state === "ERROR") 
			 {
				var errors = response.getError();
				if (errors) 
				{
					if (errors[0] && errors[0].message) 
					{
						console.log("Error message: " + errors[0].message);
					}
				}
				else 
				{
					console.log("Unknown error");
				}
			 }
		 });
		$A.enqueueAction(actionGetGenders); 
	},
	retrieveFieldsLabel : function(component, event, helper) {
		var action = component.get('c.retriveSchemaInformation');
		var listOfSobject = ["Contact"];
		action.setParams({ 
			"SObjectToRetrive" : listOfSobject
		});
		action.setCallback(this, $A.getCallback(function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var valueReturns = response.getReturnValue();
				var myMap = new Map(); 
				var result = JSON.parse( valueReturns );
				try{
					var contactFiels = result.mapSObjectfields['Contact'];
					component.set("v.ContactFieldsLabel",contactFiels);

				}
				catch(err){
					console.log(err);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				console.error(errors);
			}
		}));
		$A.enqueueAction(action);    
	},
	
	savecustomHelper : function(component, event, oldObject, newObject,generateNewContact) {
		try
		{
			console.log('@new data in helper: ' + JSON.stringify(newObject));
			console.log('@old data in helper: ' + JSON.stringify(oldObject));
			console.log('@generateNewContact in helper: ' + JSON.stringify(generateNewContact));
			var action = component.get('c.saveRequestExecutor');
			var objData = JSON.stringify(component.get('v.objectDataMap'));
			action.setParams({ 
				"oldData" : oldObject,
				"newData" : newObject,
				"isNewContact" : generateNewContact,
				"objectDataMapInput" : objData
			});
			action.setCallback(this, $A.getCallback(function (response) {
				var state = response.getState();
				if (state === "SUCCESS") {
					console.log('STATE IN SAVE EXECUTOR: ' + state);
					var objDataMap = response.getReturnValue();
					console.log('RESPONSE IN SAVE EXECUTOR : ' + JSON.stringify(objDataMap));
					component.set('v.objectDataMap', objDataMap);
					if(objDataMap.message == 'Success'){
						  //component.set('v.status', 'VIEW');
							component.set('v.showModal', false);//CLOSE FIRST MODAL
							component.set('v.logrequestid'       , objDataMap.logRequestId);//SET LOG RECORD ID
							component.set('v.showModalDocuments' , true);//SHOW DOCUMENT MODAL
							console.log('log request id: ' +  objDataMap.logRequestId);
							console.log('showModalDocuments: ' + component.get('v.showModalDocuments'));
							console.log('object datamap executor: ' + JSON.stringify(objDataMap));
							// component.set('v.executorModifiedAllowed' , false);//BOOLEAN TO BLOCK NEXT MODIFY
							//console.log('BOOLEAN AFTER SET HELPER: ' + component.get('v.executorModifiedAllowed'));
						  this.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_TOAST_OPERATIONSUCCESSFULL"), $A.get("$Label.c.OB_MAINTENANCE_LOGSAVED"), 'Success');
					} else {
						console.log('ELSE SAVE CUSTOM');
						this.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR") , $A.get("$Label.c.OB_MAINTENANCE_CHECKFIELDS"), 'error');
					}
				} else if (state === "ERROR") {
					console.log('STATE ERROR');
					var errors = response.getError();
					console.error('ERROR: ' + errors);
					this.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR") , errors, 'error');
				}
			}));
			$A.enqueueAction(action);
		}
		catch(err){
			console.log(err);
		}
	},
	
	showToast: function (component, event,title, message, type) {
		var toastEvent = $A.get("e.force:showToast");
		console.log('toast esecutor: ' + message);
		toastEvent.setParams({
			"title": title,
			"message": message,
			"type": type
			// "mode": 'sticky'
		});
		toastEvent.fire();
	},
	
	setAddressMappingcontactAddress : function(component, event) {
		var postelcomponentparamscontactAddress = {};
		postelcomponentparamscontactAddress.sectionaddress          = 'generaladdress';
		postelcomponentparamscontactAddress.sectionName          	  = 'legaleRappresentante';
		
		postelcomponentparamscontactAddress.provincedisabled        = 'false';
		postelcomponentparamscontactAddress.provinceinputobject     = 'executor';
		postelcomponentparamscontactAddress.provinceinputfield      = 'OB_Address_State__c';
		
		postelcomponentparamscontactAddress.citydisabled            = 'true';
		postelcomponentparamscontactAddress.cityinputobject         = 'executor';
		postelcomponentparamscontactAddress.cityinputfield          = 'OB_Address_City__c';
		
		postelcomponentparamscontactAddress.districtdisabled        = 'true';
		postelcomponentparamscontactAddress.districtinputobject     = 'executor';
		postelcomponentparamscontactAddress.districtinputfield      = 'OB_Address_Hamlet__c';
		
		postelcomponentparamscontactAddress.streetdisabled          = 'true';
		postelcomponentparamscontactAddress.streetinputobject       = 'executor';
		postelcomponentparamscontactAddress.streetinputfield        = 'OB_Address_Street__c';
		
		postelcomponentparamscontactAddress.streetnumberdisabled    = 'false'; //gianluigi.virga 10/09/2019 - UX-55
		postelcomponentparamscontactAddress.streetnumberinputobject = 'executor';
		postelcomponentparamscontactAddress.streetnumberinputfield  = 'OB_Address_Street_Number__c';
		
		postelcomponentparamscontactAddress.zipcodedisabled         = 'false';
		postelcomponentparamscontactAddress.zipcodeinputobject      = 'executor';
		postelcomponentparamscontactAddress.zipcodeinputfield       = 'OB_Address_PostalCode__c';

		postelcomponentparamscontactAddress.countrydisabled         = 'false';
		postelcomponentparamscontactAddress.countryinputobject      = 'executor';
		postelcomponentparamscontactAddress.countryinputfield       = 'OB_Address_Country__c';
		
		postelcomponentparamscontactAddress.countrycodeinputobject  = 'executor';
		postelcomponentparamscontactAddress.countrycodeinputfield   = 'OB_Address_Country_Code__c';

		postelcomponentparamscontactAddress.provincecodeinputobject = 'executor';
		postelcomponentparamscontactAddress.provincecodeinputfield  = 'OB_Address_State_Code__c';
		postelcomponentparamscontactAddress.isComplete              = 'true';

		postelcomponentparamscontactAddress.withCountry             = 'true';
		postelcomponentparamscontactAddress.withDetail              = 'false';

		component.set("v.postelcomponentparamscontactAddress", postelcomponentparamscontactAddress);
		console.log('postelcomponentparamscontactAddress');
		console.log(JSON.stringify(postelcomponentparamscontactAddress));
	},
	setAddressMappingdocreleaseAddress : function(component, event) {
		var postelcomponentparamsdocreleaseAddress = {};
		postelcomponentparamsdocreleaseAddress.sectionaddress          = 'documentrelease';
		postelcomponentparamsdocreleaseAddress.sectionName             = 'legaleRappDoc';
		
		postelcomponentparamsdocreleaseAddress.provincedisabled        = 'false';
		postelcomponentparamsdocreleaseAddress.provinceinputobject     = 'executor';
		postelcomponentparamsdocreleaseAddress.provinceinputfield      = 'OB_Document_Release_State__c';
		
		postelcomponentparamsdocreleaseAddress.citydisabled            = 'true';
		postelcomponentparamsdocreleaseAddress.cityinputobject         = 'executor';
		postelcomponentparamsdocreleaseAddress.cityinputfield          = 'OB_Document_Release_City__c';
		
		postelcomponentparamsdocreleaseAddress.countrydisabled         = 'false';
		postelcomponentparamsdocreleaseAddress.countryinputobject      = 'executor';
		postelcomponentparamsdocreleaseAddress.countryinputfield       = 'OB_Document_Release_Country__c';
		
		postelcomponentparamsdocreleaseAddress.countrycodeinputobject  = 'executor';
		postelcomponentparamsdocreleaseAddress.countrycodeinputfield   = 'OB_Document_Release_Country_Code__c';

		postelcomponentparamsdocreleaseAddress.provincecodeinputobject = 'executor';
		postelcomponentparamsdocreleaseAddress.provincecodeinputfield  = 'OB_Document_Release_State_Code__c';
		postelcomponentparamsdocreleaseAddress.isComplete              = 'false';

		postelcomponentparamsdocreleaseAddress.withCountry             = 'true';

		component.set("v.postelcomponentparamsdocreleaseAddress", postelcomponentparamsdocreleaseAddress);
		console.log('postelcomponentparamsdocreleaseAddress');
		console.log(JSON.stringify(postelcomponentparamsdocreleaseAddress));
	}, 
	setAddressMappingbirthAddress : function(component, event) {
		var postelcomponentparamsbirthAddress = {};
		postelcomponentparamsbirthAddress.sectionaddress          = 'birthaddress';
		postelcomponentparamsbirthAddress.sectionName             = 'legaleRappBirth';
		
		postelcomponentparamsbirthAddress.provincedisabled        = 'false';
		postelcomponentparamsbirthAddress.provinceinputobject     = 'executor';
		postelcomponentparamsbirthAddress.provinceinputfield      = 'OB_Birth_State__c';
		
		postelcomponentparamsbirthAddress.citydisabled            = 'true';
		postelcomponentparamsbirthAddress.cityinputobject         = 'executor';
		postelcomponentparamsbirthAddress.cityinputfield          = 'OB_Birth_City__c';
		
		postelcomponentparamsbirthAddress.countrydisabled         = 'false';
		postelcomponentparamsbirthAddress.countryinputobject      = 'executor';
		postelcomponentparamsbirthAddress.countryinputfield       = 'OB_Country_Birth__c';
		
		postelcomponentparamsbirthAddress.countrycodeinputobject  = 'executor';
		postelcomponentparamsbirthAddress.countrycodeinputfield   = 'OB_Country_Birth_Code__c';

		postelcomponentparamsbirthAddress.provincecodeinputobject = 'executor';
		postelcomponentparamsbirthAddress.provincecodeinputfield  = 'OB_Birth_State_Code__c';
		postelcomponentparamsbirthAddress.isComplete              = 'false';
		
		postelcomponentparamsbirthAddress.withCountry             = 'true';
		component.set("v.postelcomponentparamsbirthAddress", postelcomponentparamsbirthAddress);
		console.log('postelcomponentparamsbirthAddress');
		console.log(JSON.stringify(postelcomponentparamsbirthAddress));
	},
	setAddressMappingCitizenship : function(component, event) {
		var postelcomponentparamsCitizenship = {};
		postelcomponentparamsCitizenship.objectDataNode        = 'executor';
		postelcomponentparamsCitizenship.objectDataField       = 'OB_Citizenship__c';
		postelcomponentparamsCitizenship.lovType			   = 'COUNTRY';
		postelcomponentparamsCitizenship.lovOrderBy     	   = 'Name';
		postelcomponentparamsCitizenship.lovSourceField        = 'OB_Citizenship__c||Name';
		postelcomponentparamsCitizenship.inputFieldId 		   = 'CittadinanzaLegaleRapp';
		postelcomponentparamsCitizenship.fieldInputLabel  	   = 'OB_Citizenship';
		postelcomponentparamsCitizenship.mapLabelColumns       = 'NE__Value1__c||Codice Paese,Name||Nazione';

		component.set("v.postelcomponentparamsCitizenship", postelcomponentparamsCitizenship);
		console.log('postelcomponentparamsCitizenship');
		console.log(JSON.stringify(postelcomponentparamsCitizenship));
	},
	setAddressMappingFiscalCode : function(component, event) {
		var postelcomponentparamsFiscalCode = {};
		postelcomponentparamsFiscalCode.objectDataNode        = 'executor';
		postelcomponentparamsFiscalCode.objectDataField       = 'OB_Fiscal_Code__c';
		postelcomponentparamsFiscalCode.auraId 			      = 'fiscalCodelegaleRapp';
		postelcomponentparamsFiscalCode.label				  = 'OBFiscalCodeContact';
		postelcomponentparamsFiscalCode.isRequired			  = 'true';
		
		component.set("v.postelcomponentparamsFiscalCode", postelcomponentparamsFiscalCode);
		console.log('postelcomponentparamsFiscalCode');
		console.log(JSON.stringify(postelcomponentparamsFiscalCode));
	},
	existLog: function(component, event, AccountId, isNewExecutor)
	{
		// var objData = component.get('v.objectDataMap');
		var actionExistLog = component.get('c.checkExistLogRequest');
		
		console.log('IN HELPER EXIST');
		actionExistLog.setParams({ 
			"AccountId" : AccountId
		});
		actionExistLog.setCallback(this, $A.getCallback(function (response){
			var state = response.getState();
			console.log('state in exist log: ' + state);
			console.log('response in exist log: ' + JSON.stringify(response.getReturnValue()));
			if (state === "SUCCESS") {
				
				//	START 	micol.ferrari 19/12/2018
				var mapreturned = {};
				mapreturned		= response.getReturnValue(); 
				if (mapreturned["RECORDFOUND"]=="false")
				{
					if(isNewExecutor==true){
					    component.set( "v.disabledFields", {} );//NEXI-229 Grzegorz Banach <grzegorz.banach@accenture.com> 23/07/2019
						component.set('v.newExecutor',true);
					}else{
					    this.setDisabledFields( component );//NEXI-229 Grzegorz Banach <grzegorz.banach@accenture.com> 23/07/2019
						component.set('v.newExecutor',false);
					}
					component.set("v.disabled",false);  
					var switchOnload= component.get("v.switchOnload");
					component.set('v.switchOnload',!switchOnload);
					component.set("v.showModal", true);
				}
				else if(mapreturned["RECORDFOUND"] == "true")
				{
					var logname = ' ('+mapreturned["LOGNAME"]+')';
					console.log('LOG NAME: ' +logname );
					this.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR")  ,$A.get("$Label.c.OB_MAINTENANCE_LOGALREADYEXIST")+logname,'error'  );
				}
			}
			else if (state === "ERROR") 
			{
				var errors = response.getError();
				console.error(errors);
				this.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR") , errors, 'error');
			}
		}));
		$A.enqueueAction(actionExistLog); 

	},

    /**
    *@author Grzegorz Banach <grzegorz.banach@accenture.com>
    *@date 23/07/2019
    *@task NEXI-229
    *@description Method sets the fields that should be disabled during the edit of Executor
    *@history 23/07/2019 Method created
              05/09/2019 NEXI-302 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 05/09/2019 added OB_Sex__c as disabled field
    */
	setDisabledFields : function( component )
	{
        let disabledFields = {
            FirstName           : true,
            LastName            : true,
            OB_Fiscal_Code__c   : true,
            OB_Birth_Date__c    : true,
            OB_Sex__c           : true
        };
        component.set( "v.disabledFields", disabledFields );
    },
})