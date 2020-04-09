({
    removeRedBorderEE: function (component, event , helper){
    	var sectionName = component.get("v.addressMapping.sectionName");
    	if(sectionName == undefined || sectionName == null)
    		sectionName='';
    	console.log('sectionName'+sectionName);
        var errorId = 'errorIdprovinceEE'+sectionName;
        console.log("errorId = "+ errorId);
        var x =  document.getElementById(errorId);
        console.log(" Id error provincia ee " +document.getElementById(errorId));

        $A.util.removeClass(document.getElementById("provinceEE"+sectionName), 'slds-has-error');
        $A.util.addClass(document.getElementById("provinceEE"+sectionName), 'slds-input');
        if(x){
        	x.remove();
            console.log(" Id error provincia ee " +document.getElementById(errorId));
        }
        
    },
})