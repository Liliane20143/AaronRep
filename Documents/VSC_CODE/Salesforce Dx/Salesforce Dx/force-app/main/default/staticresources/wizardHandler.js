window._wizardHandler = (function() {

    return {
		findableAuraId : 
			{onClick: function(component, event, helper)  {
					var auraId = event.getSource().getLocalId();
					var cmp = component.find(auraId);
					cmp.set("v.label","PRESSED");
				}
			},
		fiscalcodetest : 
			{onBlur: function(component, event, helper)  {
					var auraId = event.getSource().getLocalId();
					console.log('evento');
					var cmp = component.find(auraId);
					cmp.set("v.disabled",true);
					var objectDataMap  	= component.get("v.objectDataMap");
					console.log('objectDataMap: ' + JSON.stringify(objectDataMap));
				},
			 doInit: function(component, auraId)  {
					component.set("v.label","PIPPO");
					
				},
			 doValidate: function(component, auraId)  {
					var cmp = component.find(auraId);
					cmp.set("v.label","PIPPO2");
					component.set("v.validState", false);
					
				}	
			},
			
			
			fiscalCodeLegaleRapp : 
			{onBlur: function(component, event, helper)  {
					helper.removeRedBorder(component, event , helper);
				},
			 doInit: function(component, auraId)  {
					//component.set("v.customLabelFlow",$A.get("$Label.c.OBFiscalCodeContact"));
				},
				onChange: function(component, event, helper)  {
					var auraId = event.target.id;
					var inputValue = component.find(auraId).get("v.value");
					console.log('inputValue::  '+inputValue);
					inputValue=inputValue.toUpperCase();
					component.find(auraId).set("v.value",inputValue);
				},
				doValidate: function(component, auraId, helper)  {
					console.log('on validate');
					console.log("current id is: " + auraId);
					helper.setRedBorder(component, auraId, helper);
					
				}	
			},
			
			fiscalCodeContact1 : 
			{onBlur: function(component, event, helper)  {
					helper.removeRedBorder(component, event , helper);
				},
			 doInit: function(component, auraId)  {
					//component.set("v.customLabelFlow",$A.get("$Label.c.OBFiscalCodeContact"));
				},
				onChange: function(component, event, helper)  {
					var auraId = event.target.id;
					var inputValue = component.find(auraId).get("v.value");
					console.log('inputValue::  '+inputValue);
					inputValue=inputValue.toUpperCase();
					component.find(auraId).set("v.value",inputValue);
				},
				doValidate: function(component, auraId, helper)  {
					console.log('on validate');
					console.log("current id is: " + auraId);
					var indexContact =component.get("v.objectDataMap.lastContact");
					if(indexContact == '1'){
						helper.setRedBorder(component, auraId, helper);
					}
					
				}	
			},
			
			fiscalCodeContact2 : 
			{onBlur: function(component, event, helper)  {
					helper.removeRedBorder(component, event , helper);
				},
			 doInit: function(component, auraId)  {
					//component.set("v.customLabelFlow",$A.get("$Label.c.OBFiscalCodeContact"));
				},
				onChange: function(component, event, helper)  {
					var auraId = event.target.id;
					var inputValue = component.find(auraId).get("v.value");
					console.log('inputValue::  '+inputValue);
					inputValue=inputValue.toUpperCase();
					component.find(auraId).set("v.value",inputValue);
				},
				doValidate: function(component, auraId, helper)  {
					console.log('on validate');
					console.log("current id is: " + auraId);
					var indexContact =component.get("v.objectDataMap.lastContact");
					if(indexContact == '2'){
						helper.setRedBorder(component, auraId, helper);
					}
					
				}	
			},
			
			fiscalCodeContact3 : 
			{onBlur: function(component, event, helper)  {
					helper.removeRedBorder(component, event , helper);
				},
			 doInit: function(component, auraId)  {
					//component.set("v.customLabelFlow",$A.get("$Label.c.OBFiscalCodeContact"));
				},
				onChange: function(component, event, helper)  {
					var auraId = event.target.id;
					var inputValue = component.find(auraId).get("v.value");
					console.log('inputValue::  '+inputValue);
					inputValue=inputValue.toUpperCase();
					component.find(auraId).set("v.value",inputValue);
				},
				doValidate: function(component, auraId, helper)  {
					console.log('on validate');
					console.log("current id is: " + auraId);
					var indexContact =component.get("v.objectDataMap.lastContact");
					if(indexContact == '3'){
						helper.setRedBorder(component, auraId, helper);
					}
					
				}	
			},
			
			fiscalCodeContact4 : 
			{onBlur: function(component, event, helper)  {
					helper.removeRedBorder(component, event , helper);
				},
			 doInit: function(component, auraId)  {
					//component.set("v.customLabelFlow",$A.get("$Label.c.OBFiscalCodeContact"));
				},
				onChange: function(component, event, helper)  {
					var auraId = event.target.id;
					var inputValue = component.find(auraId).get("v.value");
					console.log('inputValue::  '+inputValue);
					inputValue=inputValue.toUpperCase();
					component.find(auraId).set("v.value",inputValue);
				},
				doValidate: function(component, auraId, helper)  {
					console.log('on validate');
					console.log("current id is: " + auraId);
					var indexContact =component.get("v.objectDataMap.lastContact");
					if(indexContact == '4'){
						helper.setRedBorder(component, auraId, helper);
					}
					
				}	
			},
			
			fiscalCodeContact5 : 
			{onBlur: function(component, event, helper)  {
					helper.removeRedBorder(component, event , helper);
				},
			 doInit: function(component, auraId)  {
					//component.set("v.customLabelFlow",$A.get("$Label.c.OBFiscalCodeContact"));
				},
				onChange: function(component, event, helper)  {
					var auraId = event.target.id;
					var inputValue = component.find(auraId).get("v.value");
					console.log('inputValue::  '+inputValue);
					inputValue=inputValue.toUpperCase();
					component.find(auraId).set("v.value",inputValue);
				},
				doValidate: function(component, auraId, helper)  {
					console.log('on validate');
					console.log("current id is: " + auraId);
					var indexContact =component.get("v.objectDataMap.lastContact");
					if(indexContact == '5'){
						helper.setRedBorder(component, auraId, helper);
					}
					
				}	
			},
			
			fiscalCodeContact6 : 
			{onBlur: function(component, event, helper)  {
					helper.removeRedBorder(component, event , helper);
				},
			 doInit: function(component, auraId)  {
					//component.set("v.customLabelFlow",$A.get("$Label.c.OBFiscalCodeContact"));
				},
				onChange: function(component, event, helper)  {
					var auraId = event.target.id;
					var inputValue = component.find(auraId).get("v.value");
					console.log('inputValue::  '+inputValue);
					inputValue=inputValue.toUpperCase();
					component.find(auraId).set("v.value",inputValue);
				},
				doValidate: function(component, auraId, helper)  {
					console.log('on validate');
					console.log("current id is: " + auraId);
					var indexContact =component.get("v.objectDataMap.lastContact");
					if(indexContact == '6'){
						helper.setRedBorder(component, auraId, helper);
					}
					
				}	
			},

    };
}());