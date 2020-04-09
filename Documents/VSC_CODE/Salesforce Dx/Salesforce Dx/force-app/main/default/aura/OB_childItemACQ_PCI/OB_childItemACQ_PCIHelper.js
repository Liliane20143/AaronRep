({
	 
	 checkMaggiorazionePercentuale: function(component,event,attrId,attrCode, valueToCheck, attrOldValue){ 
			var childItem = component.get("v.childItem");
			var mapChildIdName = component.get("v.mapChildIdName");
			var childName =  childItem.fields.productname;
			var childId = childItem.fields.id;
		//	if(attrCode == 'MAGGIORAZIONE'){
	/*		if(!mapChildIdName.hasOwnProperty(childId)){
				var obj = {};
				obj.name = childName;
				obj.warning = false;
				mapChildIdName[childId] = obj;
			}*/
			if(attrCode == 'MAGGIORAZIONE' && attrOldValue != valueToCheck){
				if(mapChildIdName.hasOwnProperty(childId)){
					mapChildIdName[childId].warning = (mapChildIdName[childId].newValue >= (mapChildIdName[childId].oldValue - 0.01));
				}else{
					var obj = {};
					obj.name = childName;
					obj.warning = true;
					mapChildIdName[childId] = obj;
				//	mapChildIdName[childId].warning = true;
				}

				//inserisco nella mappa
			/*	if(!mapChildIdName.hasOwnProperty(childId)){
						var obj = {};
						obj.name = childName;
						obj.warning = true;
						mapChildIdName[childId] = obj;
				}*/
			}
			if(attrCode == 'PERCENTUALE'){
					var oldValue = parseFloat(attrOldValue);
					var newValue = parseFloat(valueToCheck);
					if(mapChildIdName.hasOwnProperty(childId)){
						if(newValue < (oldValue - 0.01)){
							mapChildIdName[childId].warning = false;
						}
					}else{
						var obj = {};
						obj.oldValue = oldValue;
						obj.newValue = newValue;
						obj.name = childName;
						obj.warning = false;
						mapChildIdName[childId] = obj;
					}
		}
			/*	for(var i = 0; i < childItem.listOfAttributes.length; i++ ){
						var att= childItem.listOfAttributes[i];
						if(attPercentuale.fields.OB_Attribute_Code__c == 'PERCENTUALE'){
								var oldValue = parseFloat(attPercentuale.fields.Old_Value__c),
								var newValue = parseFloat(attPercentuale.fields.newValue);
								
								var childName =  childItem.fields.productname;
								var childId = childItem.fields.id;
									if(newValue < oldValue){
										//ok! delete couple from map if it is in there:
										if(mapChildIdName.hasOwnProperty(childId)){
											delete mapChildIdName[childId];
										}
									}else{
										//not ok -> insert into map:
										if(mapChildIdName.hasOwnProperty(childId)){
											//do nothing
										}else{
											//add to map:
											mapChildIdName[childId] = childName;

										}
									}
							}

				}*/
		//	}
			component.set("v.mapChildIdName", mapChildIdName);
		    //START EVENT - > to OB_FlowCart
				var childItemAcqEvent = $A.get("e.c:OB_childItemACQevent");
				childItemAcqEvent.setParams({ 
					"mapChildIdName": component.get("v.mapChildIdName")
				});
				childItemAcqEvent.fire();
				//END event   
	 },

	 /**
     * @author francesca ribezzi
     * @date 26/11/2019
     * @description function to get the approval level to set on configuration 
     * @task: performance
    **/
   checkThresholds : function ( component , event, minThresholdMap, maxThresholdMap, valueToCheck){
		try{
			var listToReturn = [];
			for(var minKey in minThresholdMap ){ //get the min Threshold 
				var minValue = minThresholdMap[minKey]; 
				if(valueToCheck < minValue){
					listToReturn.push(minKey); 
				}
			}
			for(var maxKey in maxThresholdMap ){ //get the max Threshold
				var maxValue = maxThresholdMap[maxKey]; 
				if(valueToCheck > maxValue){ 
					listToReturn.push(maxKey); 
				}
			}
			if(listToReturn.length == 0){
				return null;
			}
			return Math.max(...listToReturn); //return the highest level
		}catch(err){ 
			console.log('exception in checkThresholds [OB_childItem.Helper]: ' + err.stack);
		}
	},

})