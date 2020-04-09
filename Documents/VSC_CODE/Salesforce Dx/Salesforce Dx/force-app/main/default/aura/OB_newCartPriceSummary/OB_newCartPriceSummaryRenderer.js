({
/*afterRender : function(component,helper){
	   	console.log("into afterRender");
        this.superAfterRender();
        var pos = component.get("v.posList");
        console.log("pos.length" + pos.length);
    	   for(var i = 0; i<pos.length; i++){
    		   console.log("first for");
			    for(var j = 0; j<pos[i].childItems.length; j++){
			    	 console.log("second for");
			    	for(var x; x<pos[i].childItems[j].listOfAttributes.length; x++){
			    		console.log("third for");
			    		var item = pos[i].childItems[j].listOfAttributes[x];
			    		//var posClass = document.getElementsByClassName('posClassTest');
			    		//console.log(" FR# posClass: ", posClass);
			    		console.log(" FR# item: ", item);
			    		var input = document.getElementById(j+'_'+x+'_POS');
			    		var valueToCheck = item.fields.value;
			    		var attributeFields = item.fields;  //!index+'_'+index2+'_POS'
			    		var errorIndex = document.getElementById(j+'_'+x+'_POS_'+i+'_errorPOS');
			    		console.log(" FR# composed ID:  " + j+'_'+x+'_POS_'+i+'_errorPOS');
			    		console.log(" FR# errorIndex pos: " + errorIndex);
			    		console.log("FR# input pos: " , input);
			    		//helper.checkItemValueApprovalRules(component,event,attributeFields,valueToCheck,input,errorIndex);
			    	}
			    }
		   }
    }*/
})