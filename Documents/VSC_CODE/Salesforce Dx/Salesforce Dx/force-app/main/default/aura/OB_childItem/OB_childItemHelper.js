({
		
    /**
     * @author Spinelli Giovannni <spinelli.giovanni@accenture.com>
     * @date 21/11/2019
     * @description the method manages number like 1.000
     * @task: PROD-120
    **/
   createValueToCheck : function ( component , attributeFieldValue , tmpValue , valueToCheck){
	try{
		var initValue = attributeFieldValue;
		if( initValue && initValue.includes('.') ){
			initValue = initValue.split('.')[1];
		}
		
		var initValueLength = null;
		if( initValue ){
			initValueLength = initValue.length;
		} 
		//check if after the dot there are more than 3 numbers
		if (initValueLength != null && initValueLength >= 3) {
			tmpValue = (attributeFieldValue).replace('.', '');
		}
		if (tmpValue != null) {
			valueToCheck = parseFloat(('' + tmpValue).replace(',', '.'));
		} else {
			valueToCheck = parseFloat(('' + attributeFieldValue).replace(',', '.'));
		}
		return valueToCheck;
	}catch(err){
		console.log('exception in createValueToCheck [OB_childItemHelper]: '+err.message);
	}
},

    /**
     * @author francesca ribezzi
     * @date 26/11/2019
     * @description function to get the approval level to set on configuration 
     * @task: performance
    **/
   	checkThresholds : function ( component , event, minThresholdMap, maxThresholdMap, valueToCheck){
		//type can be 'max' or 'min'   
		try{
			var listToReturn = [];
			for(var minKey in minThresholdMap ){ //get the min Threshold 
				var minValue = minThresholdMap[minKey]; 
				if(valueToCheck < minValue){
					listToReturn.push(parseInt(minKey)); 
				}
			}
			for(var maxKey in maxThresholdMap ){ //get the max Threshold
				var maxValue = maxThresholdMap[maxKey]; 
				if(valueToCheck > maxValue){
					listToReturn.push(parseInt(maxKey)); 
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