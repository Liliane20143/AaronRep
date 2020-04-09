({
    getCap : function(component, street, keyCity) {
        let action = component.get("c.getCaps");
        let zipcodeinputobject = component.get("v.addressMapping.zipcodeinputobject");
        let zipcodeinputfield = component.get("v.addressMapping.zipcodeinputfield");
        action.setParams({
            "street": street,
            "keyCity": keyCity
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
                let caps = response.getReturnValue();
                component.set("v.caps", caps);
                if(caps != null && caps != [])
                {
                    component.set("v.objectDataMap." + zipcodeinputobject + "." + zipcodeinputfield,  caps[0]);
                }
            }
            else
            {
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message)
                    {
                        console.log("Error message: " + errors[0].message);
                    }
                    else
                    {
                        console.log("Unknown error");
                    }
                }
            }
        });
        
        $A.enqueueAction(action);
    },

    getStreets: function(component, event , helper){
        let civicoId = component.get("v.civicoId");

	    let streets = component.get("v.responseStreets");
	    let addresses = [];
	    let streetsList = [];
	    if(streets != null && typeof streets == 'object')
        {
            for (let key in streets)
            {
                streets[key] = streets[key].replace("&#39;","\'");
                streetsList.push(streets[key]);
                addresses.push
                ({
                    value : key,
                    label : streets[key]
                });
            }
            component.set("v.streets", streetsList.sort());
            component.set("v.filteredOptions", addresses);

	        document.getElementById(civicoId).disabled = false;
        }
    },

    removeRedBorder: function (component, event , helper){
    	let sectionName = component.get("v.addressMapping.sectionName");
    	if(sectionName == undefined || sectionName == null)
    	{
    		sectionName='';
        }
        let errorIdstrada = 'errorIdstrada' + sectionName;
        $A.util.removeClass(document.getElementById("strada" + sectionName), 'slds-has-error flow_required');
        $A.util.addClass(document.getElementById("strada" + sectionName), 'slds-input');
        
        if(document.getElementById(errorIdstrada) != null)
        {
            document.getElementById(errorIdstrada).remove();
        }
    },

    removeRedBorderCivico: function (component, event , helper){
    	let sectionName = component.get("v.addressMapping.sectionName");
    	if(sectionName == undefined || sectionName == null)
    	{
    		sectionName='';
        }

        let errorIdnumber = 'errorIdcivico' + sectionName;
		$A.util.removeClass(document.getElementById("civico" + sectionName), 'slds-has-error flow_required');
		$A.util.addClass(document.getElementById("civico" + sectionName), 'slds-input');
		
        if(document.getElementById(errorIdnumber) != null)
        {
            document.getElementById(errorIdnumber).remove();
        }
    },

    removeRedBorderEE: function (component, event , helper) {
    	let sectionName = component.get("v.addressMapping.sectionName");
    	if(sectionName == undefined || sectionName == null)
    	{
    		sectionName='';
        }
        let errorIdstrada = 'errorIdstreetEE' + sectionName;
        $A.util.removeClass(document.getElementById("streetEE" + sectionName), 'slds-has-error flow_required');
        $A.util.addClass(document.getElementById("streetEE" + sectionName), 'slds-input');
        
        if(document.getElementById(errorIdstrada)!= null)
        {
            document.getElementById(errorIdstrada).remove();
        }
    },

    removeRedBorderCivicoEE: function (component, event , helper){
    	let sectionName = component.get("v.addressMapping.sectionName");
    	if(sectionName == undefined || sectionName == null)
    	{
    		sectionName = '';
        }
        let errorIdnumber = 'errorIdcivicoEE' + sectionName;
		$A.util.removeClass(document.getElementById("civicoEE" + sectionName), 'slds-has-error flow_required');
		$A.util.addClass(document.getElementById("civicoEE" + sectionName), 'slds-input');
		
        if(document.getElementById(errorIdnumber) != null)
        {
            document.getElementById(errorIdnumber).remove();
        }
    },

    setInputLabel : function(component)
    {
        let sectionAdress = component.get("v.addressMapping.sectionaddress");
        if(sectionAdress == "sedelegale")
        {
            component.set("v.inputLabel",$A.get("$Label.c.OB_Legal_Address_Street"));
        }
        else if(sectionAdress == "sedeamministrativa")
        {
            component.set("v.inputLabel",$A.get("$Label.c.OB_Administrative_Office_Street"));
        }
        else if(sectionAdress == "generaladdress" || sectionAdress == "documentrelease" || sectionAdress == "birthaddress")
        {
            component.set("v.inputLabel",$A.get("$Label.c.OB_Address_Street"));
        }
    }

})