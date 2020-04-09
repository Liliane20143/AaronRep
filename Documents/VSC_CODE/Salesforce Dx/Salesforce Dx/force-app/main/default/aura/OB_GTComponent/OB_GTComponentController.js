({
	doInit : function(component, event) {
		var objectDataMap = component.get('v.objectDataMap');
		console.log('objectDataMap');
		console.log(JSON.stringify(objectDataMap));
		if (objectDataMap.hasOwnProperty('Configuration')) {
			console.log('objectDataMap config obgt'
					+ objectDataMap.Configuration.OB_GT__c);
			console.log('objectDataMap get element'
					+ document.getElementById('TRV'));
		}
		// micol.ferrari@accenture.com 02/08/2019 - START
		if (objectDataMap.hasOwnProperty('bankProfile')) {
			var stringOfGT = objectDataMap.bankProfile.OB_GT__c;
            // micol.ferrari@accenture.com 02/08/2019 - STOP
			var arrayOfGT = [];
			arrayOfGT = stringOfGT.split(';');
			console.log('arrayOfGT ' + arrayOfGT);
			var newlst = [];
			for (var i = 0; i < arrayOfGT.length; i++) {
				console.log(i);
				var gtValuesTemp = {};
				console.log(arrayOfGT[i] + '='
						+ objectDataMap.Configuration.OB_GT__c)
				if (arrayOfGT[i] == objectDataMap.Configuration.OB_GT__c) {
					gtValuesTemp.isDefault = true;
				} else {
					gtValuesTemp.isDefault = false;
				}
				gtValuesTemp.GTLabel = arrayOfGT[i];
				console.log("detail space subset " + gtValuesTemp);
				newlst.push(gtValuesTemp);
				console.log("value after iteration" + i
						+ JSON.stringify(newlst));
			}
			component.set("v.GTvalues", newlst);
			console.log('newlst' + newlst);
			/**********lea.emalieu START 24/09/2018 ***************************/
			//Comment riga 38
			//component.set('v.objectDataMap.Configuration.OB_GT__c' , newlst );
			/*********lea.emalieu END 24/09/2018 *****************************/
		}
		/*
		 * if (objectDataMap.hasOwnProperty('Configuration')) {
		 * component.find(objectDataMap.Configuration.OB_GT__c).checked = true; }
		 */
		/*
		 * if (objectDataMap.hasOwnProperty('Configuration')) { var currentGT =
		 * objectDataMap.Configuration.OB_GT__c; console.log('currentGT
		 * '+currentGT); if (currentGT=='Nexi') { var GTMap =
		 * {'Nexi':'true','Other':'false'}; component.set('v.GTchecked',GTMap); }
		 * else if (currentGT=='Other') { var GTMap =
		 * {'Nexi':'false','Other':'true'}; component.set('v.GTchecked',GTMap); }
		 * else { var GTMap = {'Nexi':'false','Other':'false'};
		 * component.set('v.GTchecked',GTMap); } } var mapGT =
		 * component.get('v.GTchecked'); console.log('checked nexi
		 * '+mapGT.Nexi); console.log('checked other '+mapGT.Other);
		 */
	},
	handleChange : function(component, event) {
		var objectDataMap = component.get('v.objectDataMap');
		objectDataMap.Configuration.OB_GT__c = event.target.value;
		component.set('v.objectDataMap', objectDataMap);
		console.log(objectDataMap.Configuration.OB_GT__c);
	}
})