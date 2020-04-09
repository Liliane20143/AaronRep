({
	district :function(component, event , helper){
	    let frazioni = component.get("v.responseDistr");
		let sectionName = component.get("v.addressMapping.sectionName");
		let districts = [];
		if(sectionName == undefined || sectionName == null)
			sectionName='';
    	let districtId = component.get("v.districtId");
		let listaDistr = [];
		let frazioneElement = document.getElementById("frazione"+sectionName);
		if(frazioni!=null ){
			for (let key in frazioni) {
				listaDistr.push(frazioni[key]);
				districts.push
				({
                    value : key,
                    label : frazioni[key]
                });
			}
			    component.set('v.frazioni',listaDistr.sort());
			    component.set("v.filteredOptions", districts);

            	document.getElementById(districtId).disabled = false;
        }
    },
	removeRedBorderEE: function (component, event , helper){
		var sectionName = component.get("v.addressMapping.sectionName");
		if(sectionName == undefined || sectionName == null)
			sectionName='';
        var errorIddistrict = 'errorIddistrictEE'+sectionName;
        $A.util.removeClass(document.getElementById("districtEE"+sectionName), 'slds-has-error flow_required');
        
       if(document.getElementById(errorIddistrict)!=null){
    	    console.log("errorID . " + errorIddistrict);
            document.getElementById(errorIddistrict).remove();
        }
    },

     setInputLabel : function(component)
        {
            let sectionAdress = component.get("v.addressMapping.sectionaddress");
            if(sectionAdress == "sedelegale")
            {
                component.set("v.inputLabel",$A.get("$Label.c.OB_Legal_District"));
            }
            else if(sectionAdress == "sedeamministrativa")
            {
                component.set("v.inputLabel",$A.get("$Label.c.OB_Administrative_Office_District"));
            }
            else if(sectionAdress == "generaladdress" || sectionAdress == "documentrelease" || sectionAdress == "birthaddress")
            {
                component.set("v.inputLabel",$A.get("$Label.c.OB_Address_District"));
            }
        }




	
	
})